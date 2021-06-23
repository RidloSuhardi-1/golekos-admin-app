import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golekos_admin/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golekos Admin',
      theme: ThemeData(
        backgroundColor: Color(0xffF2F2F29),
        accentColor: Color(0xff282828),
      ),
      home: HomePage(),
    );
  }
}
