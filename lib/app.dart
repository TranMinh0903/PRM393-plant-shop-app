import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:provider/provider.dart';

import 'services/app_routes.dart';
import 'viewmodels/admin_product_viewmodel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProductViewModel()),
      ],
      child: ShadcnApp.router(
        title: 'Trạm Cây cảnh',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoutes.router,
        theme: ThemeData(colorScheme: ColorSchemes.lightSlate, radius: 0.5),
        darkTheme: ThemeData(colorScheme: ColorSchemes.darkSlate, radius: 0.5),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
