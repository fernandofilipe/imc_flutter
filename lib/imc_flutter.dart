import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/pages/home_page.dart';
import 'package:imc_flutter/services/theme_services.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class IMCFlutter extends StatelessWidget {
  const IMCFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Constants.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      home: const HomePage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('pt'),
      ],
    );
  }
}
