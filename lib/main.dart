import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracenac/core/utils/app_color.dart';
import 'package:tracenac/routes/app_routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return GetMaterialApp(
      title: 'Tracenac App',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        scaffoldBackgroundColor: Colors.white,
        iconTheme: IconThemeData(color: AppColor.iconColor),
        colorScheme: theme.colorScheme.copyWith(primary: AppColor.buttonColor, secondary: Color(0xFFD1CCCC),),
        useMaterial3: false,
      ),
      initialRoute: AppRoutes.splashScreen,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}