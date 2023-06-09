import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../ui/messages.dart';
import 'default_change_notifier.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    SuccessVoidCallback? successCallback,
    ErrorVoidCallback? errorCallback,
    EverVoidCallback? everCallback,
  }) {
    changeNotifier.addListener(
      () {
        if (changeNotifier.loading) {
          Loader.show(context);
        } else {
          Loader.hide();
        }

        if (changeNotifier.hasError) {
          if (errorCallback != null) {
            errorCallback(changeNotifier, this);
          }
          Messages.of(context)
              .showError(changeNotifier.error ?? 'Erro interno');
        } else if (changeNotifier.isSuccess) {
          if (successCallback != null) {
            successCallback(changeNotifier, this);
          }
        }

        if (everCallback != null) {
          everCallback(changeNotifier, this);
        }
      },
    );
  }
}

typedef SuccessVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listenerInstance,
);

typedef ErrorVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listenerInstance,
);

typedef EverVoidCallback = void Function(
  DefaultChangeNotifier notifier,
  DefaultListenerNotifier listenerInstance,
);
