import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dict_en_ru/auth/login_page.dart';
import 'package:my_dict_en_ru/auth/welcome_page.dart';
import 'package:my_dict_en_ru/constants/themes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.white,
                  radius: 40,
                  backgroundImage: ExactAssetImage("assets/avatar.png"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(fontSize: 20),
                )
              ],
            )),
            ListTile(),
            ListTile(),
            Spacer(),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.to(() => WelcomePage());
              },
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppColors.primaryColor,
                ),
                title: Text(
                  "Log out",
                  style: textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
