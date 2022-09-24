import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_dict_en_ru/constants/themes.dart';
import 'package:my_dict_en_ru/controllers/search_controller.dart';
import 'package:my_dict_en_ru/models/favorite_model.dart';
import 'package:my_dict_en_ru/pages/detail_page.dart';
import 'package:my_dict_en_ru/pages/search_page.dart';
import 'package:my_dict_en_ru/services/firebase/word_crud.dart';
import 'package:my_dict_en_ru/widgets/my_drawer.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              centerTitle: true,
              title: Text("MyDictionary"),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<List<FavoriteModel>>(
                stream: WordCRUD().getFavorites(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final List<FavoriteModel> data = snapshot.data;
                    List<String> favorites = data.map((e) => e.word!).toList();
                    return Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: List.generate(
                            favorites.length,
                            (index) => _wordItem(
                                favorites[index], index, data[index])),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: loadingIcon),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }

  InkWell _wordItem(String word, int index, FavoriteModel data) {
    return InkWell(
      onTap: (() {
        Get.find<SearchController>().loaded(false);
        Get.to(() => DetailPage(word: word, lang: data.lang!),
            transition: Transition.rightToLeft);
      }),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primaryColor, width: 0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(word),
            IconButton(
                onPressed: () {
                  WordCRUD().delete(word);
                },
                icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
