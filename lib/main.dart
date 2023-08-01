import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_app/note.dart';
import 'package:note_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'generated/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.registerAdapter(NoteAdapter());
  Hive.init(directory.path);
  await Hive.openBox<Note>('notes');
  runApp(EasyLocalization(
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      supportedLocales: const [Locale('en'), Locale('ru')],
      fallbackLocale: const Locale('en'),
      child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
