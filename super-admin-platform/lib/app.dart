import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'widgets/layout/main_layout.dart';
import 'screens/auth_screen.dart';

class FleetoraApp extends StatelessWidget {
  const FleetoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'Fleetora Enterprise OS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: provider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('uz'),
            Locale('ru'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Consumer<AppProvider>(
            builder: (context, provider, _) {
              if (provider.isSignedIn) return const MainLayout();
              return AuthScreen(onSignedIn: () => provider.signIn());
            },
          ),
        );
      },
    );
  }
}
