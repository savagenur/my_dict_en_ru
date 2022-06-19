import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dict_en_ru/auth/signup_page.dart';
import 'package:my_dict_en_ru/main.dart';

import '../../constants/themes.dart';
import '../login_page.dart';

class MyAuthFields extends StatelessWidget {
  final bool isLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  MyAuthFields({
    Key? key,
    this.isLogin = true,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: double.infinity,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.primaryColor)),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: AppColors.primaryColor,

                controller: emailController,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Email',
                    suffixIcon:
                        Icon(Icons.person, color: AppColors.primaryColor)),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.primaryColor)),
            child: TextFormField(
              cursorColor: AppColors.primaryColor,
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: 'Password',
                suffixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15))),
              onPressed: () {
                if (emailController.text == '' ||
                    passwordController.text == '' ||
                    passwordController.text.length < 6) {
                  return validSnackBar();
                }
                isLogin ? login(context) : signUp(context);
              },
              child: Text(
                isLogin ? 'Login' : 'Sign Up',
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
              onTap: () {
                isLogin
                    ? Get.to(() => SignUpPage())
                    : Get.to(() => LoginPage());
              },
              child: _alreadyHaveAccount(isLogin))
        ],
      ),
    );
  }

  RichText _alreadyHaveAccount(bool isLogin) {
    return RichText(
        text: TextSpan(
            style: TextStyle(color: Colors.black),
            text: isLogin
                ? "Don't Have an Account? "
                : "Already have an Account? ",
            children: [
          TextSpan(
              style: TextStyle(
                  color: AppColors.primaryColor, fontWeight: FontWeight.bold),
              text: isLogin ? "Sign Up." : 'Sign In.')
        ]));
  }

  Future signUp(context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return loadingIcon;
        });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          "Required",
          snackPosition: SnackPosition.BOTTOM,
          e.toString().split('] ')[1],
          icon: const Icon(
            Icons.warning_amber,
            color: Colors.red,
          ));
      Navigator.of(context).pop();
    }
  }

  Future login(context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return loadingIcon;
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          "Required",
          snackPosition: SnackPosition.BOTTOM,
          e.toString().split('] ')[1],
          icon: const Icon(
            Icons.warning_amber,
            color: Colors.red,
          ));

      Navigator.of(context).pop();
    }
  }

  void validSnackBar() {
    Get.snackbar(
        "Required",
        snackPosition: SnackPosition.BOTTOM,
        "Fields can't be Empty and Password has to be more than 6 ch.",
        icon: const Icon(
          Icons.warning_amber,
          color: Colors.red,
        ));
  }
}
