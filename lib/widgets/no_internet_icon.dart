import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_dict_en_ru/controllers/search_controller.dart';
import 'package:my_dict_en_ru/pages/main_page.dart';
import 'package:my_dict_en_ru/pages/search_page.dart';

class NoInternetIcon extends StatelessWidget {
  const NoInternetIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .5,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/error.png",
                width: MediaQuery.of(context).size.width * .4,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    Get.find<SearchController>().loaded(false);
                    if (Get.find<SearchController>().hasInet) {
                      
                    await SearchController().getData();
                    }

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MainPage()));
                    Get.find<SearchController>().loaded(true);
                  },
                  icon: Icon(Icons.replay),
                  label: Text("Try again!"))
            ]),
      ),
    );
  }
}
