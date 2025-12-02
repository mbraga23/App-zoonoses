import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/screens/export_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/record_form_screen.dart';
import 'presentation/screens/records_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ZoonosesApp()));
}

class ZoonosesApp extends StatelessWidget {
  const ZoonosesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro Antivetorial',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      initialRoute: LoginScreen.route,
      routes: {
        LoginScreen.route: (_) => const LoginScreen(),
        RecordsListScreen.route: (_) => const RecordsListScreen(),
        RecordFormScreen.route: (_) => const RecordFormScreen(),
        ExportScreen.route: (_) => const ExportScreen(),
      },
    );
  }
}
