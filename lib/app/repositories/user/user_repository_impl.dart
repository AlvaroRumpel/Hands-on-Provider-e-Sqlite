import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './user_repository.dart';
import '../../core/database/sqlite_connection_factory.dart';
import '../../exceptions/auth_exception.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final SqliteConnectionFactory _sqliteConnectionFactory;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required SqliteConnectionFactory sqliteConnectionFactory,
  })  : _firebaseAuth = firebaseAuth,
        _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      log('Erro ao criar usuário', error: e, stackTrace: s);

      if (e.code == 'email-already-in-use') {
        final loginType = await _firebaseAuth.fetchSignInMethodsForEmail(email);

        if (loginType.contains('password')) {
          throw AuthException(
              message: 'Email já utlizado, escolha outro email!');
        } else {
          throw AuthException(
            message:
                'Você se cadastrou no Todo List pelo Google, utilize o mesmo para entrar!',
          );
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao criar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      throw AuthException(message: e.message ?? 'Erro ao realizar o login');
    } on FirebaseAuthException catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);

      if (e.code == 'wrong-password') {
        throw AuthException(message: 'Login ou senha inválidos');
      }

      throw AuthException(message: e.message ?? 'Erro ao realizar o login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginType = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginType.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginType.contains('google')) {
        throw AuthException(
          message:
              'Cadastro realizado com o google, não pode ser trocada a senha',
        );
      } else {
        throw AuthException(message: 'Email não encontrado');
      }
    } on PlatformException catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      throw AuthException(message: 'Erro ao realizar a recuperação de senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginType;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginType =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginType.contains('password')) {
          throw AuthException(
            message:
                'Você utilizou o email para cadastro, caso tenha esquecido a senha, clique no esqueci a senha',
          );
        }
        final googleAuth = await googleUser.authentication;
        final firebaseCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var userCredential =
            await _firebaseAuth.signInWithCredential(firebaseCredential);

        return userCredential.user;
      }
    } on FirebaseAuthException catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);

      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
          message:
              '''
                Login inválido, você se registrou com os seguintes provedores:
                ${loginType?.join(',')}
              ''',
        );
      }
      throw AuthException(message: 'Erro ao realizar o login');
    }

    return null;
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
    final conn = await _sqliteConnectionFactory.openConnection();
    conn.delete('todo');
  }

  @override
  Future<void> updateDisplayedName(String name) async {
    final user = _firebaseAuth.currentUser;

    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
