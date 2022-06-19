class FavoriteModel {
  String? word;
  String? lang;

  FavoriteModel({this.word});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    lang = json['lang'];
  }
}
