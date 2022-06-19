import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../constants/themes.dart';
import '../controllers/search_controller.dart';
import '../models/favorite_model.dart';
import '../models/word_model.dart';
import '../services/firebase/word_crud.dart';

class DetailPage extends StatefulWidget {
  final String word;
  final String lang;
  DetailPage({Key? key, required this.word, required this.lang})
      : super(key: key);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  SearchController searchController = Get.find();
  @override
  void initState() {
    searchController.getData(word: widget.word, lang: widget.lang);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(builder: ((controller) {
      WordModel wordModel = controller.wordModel;
      TextTheme textTheme = Theme.of(context).textTheme;

      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              centerTitle: true,
              title: Text("MyDictionary"),
              expandedHeight: 100,
            ),
            SliverToBoxAdapter(
              child: wordModel.def == null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: loadingIcon,
                      ),
                    )
                  : wordModel.def!.isEmpty
                      ? Container()
                      : StreamBuilder<List<FavoriteModel>>(
                          stream: WordCRUD().getFavorites(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            final favorites = snapshot.data;
                            List words = favorites == null
                                ? []
                                : favorites.map((e) => e.word).toList();
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                child: controller.isLoaded
                                    ? Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      wordModel.def!.isEmpty
                                                          ? ''
                                                          : wordModel
                                                              .def![0].text!,
                                                      style:
                                                          textTheme.bodyLarge,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (!words.contains(
                                                              wordModel.def![0]
                                                                  .text!)) {
                                                            WordCRUD().create(
                                                                word: wordModel
                                                                    .def![0]
                                                                    .text!,
                                                                lang: controller
                                                                        .isEnRu
                                                                    ? 'en-ru'
                                                                    : 'ru-en');
                                                          } else if (words
                                                              .contains(
                                                                  wordModel
                                                                      .def![0]
                                                                      .text!)) {
                                                            WordCRUD().delete(
                                                                wordModel
                                                                    .def![0]
                                                                    .text!);
                                                          }
                                                        },
                                                        child: Icon(
                                                          words.contains(
                                                                  wordModel
                                                                      .def![0]
                                                                      .text!)
                                                              ? Icons.star
                                                              : Icons
                                                                  .star_outline,
                                                          size: 30,
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.volume_up,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      wordModel.def!.isEmpty
                                                          ? ''
                                                          : '/${wordModel.def![0].ts ?? ''}/',
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          _divider(),
                                          Column(
                                            children: List.generate(
                                                wordModel.def!.length,
                                                (index) => _type(textTheme,
                                                    wordModel.def![index])),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          _divider(),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                wordModel.def!.isEmpty
                                                    ? Container()
                                                    : wordModel.def![0].tr![0]
                                                                .ex ==
                                                            null
                                                        ? Container()
                                                        : Text(
                                                            "Sample Sentences"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      wordModel.def!.length,
                                                      (index) => Column(
                                                            children: List.generate(
                                                                wordModel
                                                                    .def![index]
                                                                    .tr!
                                                                    .length,
                                                                (i) => wordModel
                                                                            .def![
                                                                                index]
                                                                            .tr![
                                                                                i]
                                                                            .ex ==
                                                                        null
                                                                    ? Container()
                                                                    : _exampleTr(
                                                                        wordModel
                                                                            .def![index]
                                                                            .tr![i],
                                                                        textTheme)),
                                                          )),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Center(
                                          child: loadingIcon,
                                        ),
                                      ),
                              );
                            } else {
                              return Container(
                                height: MediaQuery.of(context).size.height,
                                child: Center(
                                  child: loadingIcon,
                                ),
                              );
                            }
                          },
                        ),
            )
          ],
        ),
      );
    }));
  }

  Container _exampleTr(Tr tr, TextTheme textTheme) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            '${tr.text!}:',
            style: TextStyle(color: AppColors.primaryColor),
          ),
          tr.ex == null
              ? Container()
              : Column(
                  children: List.generate(
                    tr.ex?.length ?? 0,
                    (index) => _example(tr.ex![index], textTheme),
                  ),
                )
        ],
      ),
    );
  }

  Column _example(Ex ex, TextTheme textTheme) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: Container(width: 40),
            ),
            Flexible(
                flex: 13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ex.text! + '.',
                      style: textTheme.bodySmall,
                    ),
                    Text(ex.tr![0].text! + '.',
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.grey))
                  ],
                ))
          ],
        ),
      ],
    );
  }

  Container _type(TextTheme textTheme, Def wordType) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Container(
              width: 40,
              child: Text(
                wordType.pos == 'adjective' ? 'adj:' : '${wordType.pos ?? ''}:',
                style: TextStyle(color: AppColors.primaryColor, fontSize: 14),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
              flex: 13,
              child: RichText(
                text: TextSpan(
                  children: List.generate(
                    wordType.tr!.length,
                    (index) => TextSpan(
                        text:
                            '${wordType.tr![index].text}${wordType.tr![index].syn?.length == null ? '' : ' '}${wordType.tr![index].syn?.length == null ? '' : List.generate(wordType.tr![index].syn?.length ?? 0, (i) => wordType.tr![index].syn![i].text!).map((e) => e)}, '),
                  ),
                  style: textTheme.bodySmall,
                ),
              ))
        ],
      ),
    );
  }

  Container _divider() {
    return Container(
      height: 10,
      color: AppColors.greyColor,
    );
  }
}
