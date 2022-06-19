import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_dict_en_ru/auth/welcome_page.dart';
import 'package:my_dict_en_ru/constants/themes.dart';
import 'package:my_dict_en_ru/controllers/search_controller.dart';
import 'package:my_dict_en_ru/pages/search_page.dart';
import 'package:my_dict_en_ru/helper/dependencies.dart' as dep;
import 'package:my_dict_en_ru/pages/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<SearchController>();
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "SavageDict En-Ru",
      theme: Themes.light,
      home: HeadMainPage(),
    );
  }
}


class HeadMainPage extends StatelessWidget {
  const HeadMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return MainPage();
        }
        return const WelcomePage();
      },
    );
  }
}