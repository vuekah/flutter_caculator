import 'package:flutter/material.dart';
import 'package:flutter_caculator/page/home_page.dart';
import 'package:flutter_caculator/theme/my_app_theme.dart';
import 'package:flutter_caculator/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
          create: (context) => ThemeProvider(), child: const MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Selector<ThemeProvider, bool>(
      selector: (context, viewmodel) => viewmodel.isLightMode,
      builder: (context, isLightMode, child) => MaterialApp(
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        themeMode: isLightMode ? ThemeMode.light : ThemeMode.dark,
        home: const HomePage(),
      ),
    );
  }
}
