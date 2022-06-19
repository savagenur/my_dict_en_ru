import 'package:get/get.dart';
import 'package:my_dict_en_ru/controllers/search_controller.dart';

Future<void> init() async {
  Get.lazyPut(() => SearchController());
}
