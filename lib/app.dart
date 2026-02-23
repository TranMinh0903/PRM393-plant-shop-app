import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

/// Root application widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Plant Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
