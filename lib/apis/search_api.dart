import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_dict_en_ru/models/word_model.dart';

class SearchApi {
  static String apiKey =
      'dict.1.1.20220613T213822Z.5b2d8766b34d1c24.d81a96eee66961317b9717a0322ebac3ea9204f0';

  Future getData({required String lang, required String word}) async {
    String baseUrl =
        'https://dictionary.yandex.net/api/v1/dicservice.json/lookup?key=$apiKey&lang=$lang&text=$word';

    http.Response response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      WordModel data = WordModel.fromJson(body);
      return data;
    } else {
      print('SomeThing went wrong!');
    }
  }
}
