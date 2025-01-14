import 'package:flutter/material.dart';

import 'package:login/Pages/content.dart';
import 'package:login/Pages/login.dart';
import 'package:login/Pages/register.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context)=> MyLogin()
    },
  ));
}
