import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/user/user_service.dart';
import '../navigator/todo_list_navigator.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;

  AuthProvider({
    required FirebaseAuth firebaseAuth,
    required UserService userService,
  })  : _firebaseAuth = firebaseAuth,
        _userService = userService;

  Future<void> logout() => _userService.logout();

  User? get user => _firebaseAuth.currentUser;

  void loadListener() {
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.authStateChanges().listen((event) {
      if (user != null) {
        TodoListNavigator.to.pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }
}
