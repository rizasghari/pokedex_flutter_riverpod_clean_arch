import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_flutter_riverpod/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex_flutter_riverpod/sl/service_locator.dart';

Future<void> main() async {
  await ServiceLocator.setUp();

  runApp(ProviderScope(
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PokeDex",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
        textTheme: GoogleFonts.quattrocentoSansTextTheme(),
      ),
      home: HomePage(),
    );
  }
}
