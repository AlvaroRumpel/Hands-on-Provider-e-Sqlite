import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/auth_provider.dart';
import '../../../core/ui/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Selector<AuthProvider, String>(
        selector: (context, authProvider) =>
            authProvider.user?.displayName ?? 'Não informado',
        builder: (_, value, __) => Text(
          'E ai, $value!',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
