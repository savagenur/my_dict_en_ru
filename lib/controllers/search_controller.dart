import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:my_dict_en_ru/apis/search_api.dart';
import 'package:my_dict_en_ru/models/word_model.dart';

class SearchController extends GetxController {
  SearchApi searchApi = SearchApi();
  bool _hasInet = true;
  bool get hasInet => _hasInet;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  WordModel wordModel = WordModel();
  bool _isEnRu = true;
  bool get isEnRu => _isEnRu;
  @override
  void onInit() {
    inetCheck();
    getData();

    super.onInit();
  }

  Future getData({String? lang = 'en-ru', String? word = 'happiness'}) async {
    if (_hasInet) {
      _isLoaded = false;
      wordModel = await searchApi.getData(lang: lang!, word: word!);

      _isLoaded = true;
      update();
    } else {}
  }

  void langSwap() {
    _isEnRu = !_isEnRu;
    update();
  }

  Future inetCheck() async {
    _hasInet = await InternetConnectionChecker().hasConnection;
  }

  void loaded(loading) {
    _isLoaded = loading;
  }
}
