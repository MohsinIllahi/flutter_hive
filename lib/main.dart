import 'package:flutter/material.dart';
import 'package:flutter_hive/home_screen.dart';
import 'package:flutter_hive/models/notes_model.dart';
import 'package:flutter_hive/screens/dashboard.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.openBox('settings');
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  Hive.registerAdapter(NotesModelAdapter());

  await Hive.openBox<NotesModel>('notes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, box, child) {
          final isDark = box.get('isDark', defaultValue: false);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            // theme: isDark ? ThemeData.dark() : ThemeData(),
            home: const DashBoard(),
          );
        });
  }
}
