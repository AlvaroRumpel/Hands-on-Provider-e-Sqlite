import 'package:flutter/material.dart';

class TodoListNavigator {
  TodoListNavigator._();

  static final navigatorkey = GlobalKey<NavigatorState>();
  static NavigatorState get to => navigatorkey.currentState!;
}
