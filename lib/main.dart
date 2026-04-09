import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/screens/get_started_screen/get_started_screen.dart';
import 'package:fin_track/utils/main_navigation_screen/main_navigation_screen.dart';
import 'package:fin_track/utils/theme/app_theme.dart';
import 'package:fin_track/utils/theme/theme_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(
          create: (_) => TransactionController()..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionController = context.read<TransactionController>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),// reads whether we hv a firebase instance or not
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;// if it doesnt have than redirect it to getStartedScreen()
        if (user == null) {
          return const GetStartedScreen();
        }

        return MainNavigationScreen(// else MainNavigationScreen
          transactionController: transactionController,// MAJOR BUG i thought this context is global we can refer it from anywhere
          //but seems like we hv to pass it as a reference down the widget tree :(
          userName: user.displayName,
        );
      },
    );
  }
}
