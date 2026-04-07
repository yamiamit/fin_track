import 'package:fin_track/screens/login_screen/sign_in.dart';
import 'package:fin_track/utils/theme/app_theme.dart';
import 'package:fin_track/utils/theme/theme_controller.dart';
import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/utils/main_navigation_screen/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


//we used provider state here which catches the toggle(change in colour and passes it as global in notifier to all the screens
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //await Hive.openBox(TransactionController.boxName); // ✅ open box before runApp

  bool isLoggedIn = true;
  runApp(
    MultiProvider(                                   // ✅ MultiProvider at the very top
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => TransactionController()..initialize()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {              // ✅ now just a simple StatelessWidget
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final transactionController = context.read<TransactionController>();
    // print(themeController);

    // your SystemChrome calls here...

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: isLoggedIn
          ? MainNavigationScreen(
              transactionController: transactionController,
            )
          : const LoginScreen(),
    );
  }
}

//We will need this in future when trying to scale our app
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     bool isLoggedIn = false;
//
//     return isLoggedIn
//         ? const MainNavigationScreen()
//         : const LoginScreen();
//   }
// }
