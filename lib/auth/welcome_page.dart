import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:my_dict_en_ru/auth/login_page.dart';
import 'package:my_dict_en_ru/auth/signup_page.dart';

import '../constants/themes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              'assets/welcome1.svg',
              width: 400,
            ),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15))),
              onPressed: () {
                Get.to(() => LoginPage());
              },
              child: Text(
                'Login',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
                padding: MaterialStateProperty.all(
                  EdgeInsets.all(15),
                ),
                side: MaterialStateProperty.all(
                  BorderSide(color: AppColors.primaryColor),
                ),
              ),
              onPressed: () {
                Get.to(() => SignUpPage());

              },
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
