import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/cyber_theme.dart';
import 'pages/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CYBER APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Cyber.bg,
        colorScheme: const ColorScheme.dark(
          primary: Cyber.cyan,
          secondary: Cyber.pink,
          surface: Cyber.surface,
          error: Cyber.red,
          onPrimary: Cyber.bg,
          onSecondary: Colors.white,
          onSurface: Cyber.textMain,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Cyber.textMain,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Cyber.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Cyber.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Cyber.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Cyber.cyan, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(color: Cyber.red),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: Cyber.textDim, letterSpacing: 1),
          hintStyle: TextStyle(color: Cyber.textDim.withOpacity(0.5)),
          prefixIconColor: Cyber.textDim,
          suffixIconColor: Cyber.textDim,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Cyber.textDim,
            side: const BorderSide(color: Cyber.border),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            textStyle:
                const TextStyle(letterSpacing: 1.5, fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Cyber.panel,
          contentTextStyle: const TextStyle(color: Cyber.textMain, fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Cyber.panel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(color: Cyber.border),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
