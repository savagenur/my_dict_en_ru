import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_dict_en_ru/constants/themes.dart';
import 'package:my_dict_en_ru/controllers/search_controller.dart';
import 'package:my_dict_en_ru/models/favorite_model.dart';
import 'package:my_dict_en_ru/models/word_model.dart';
import 'package:my_dict_en_ru/services/firebase/word_crud.dart';
import 'package:my_dict_en_ru/widgets/my_drawer.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController queryController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GetBuilder<SearchController>(builder: ((controller) {
      WordModel wordModel = controller.wordModel;

      return Scaffold(
        endDrawer: MyDrawer(),
        body: GestureDetector(
          onPanDown: (details) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: NestedScrollView(
            headerSliverBuilder: ((context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  centerTitle: true,
                  title: Text("MyDictionary"),
                  expandedHeight: 170,
                  bottom: PreferredSize(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    controller.isEnRu ? "English" : "Russian",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    controller.langSwap();
                                    if (controller.isEnRu) {
                                      await controller.getData(
                                          word: queryController.text.isEmpty
                                              ? 'success'
                                              : queryController.text);
                                    } else if (!controller.isEnRu) {
                                      await controller.getData(
                                          lang: 'ru-en',
                                          word: queryController.text.isEmpty
                                              ? 'успех'
                                              : queryController.text);
                                    }
                                  },
                                  child: Icon(
                                    Icons.swap_horiz_outlined,
                                    color: AppColors.white,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Text(
                                    !controller.isEnRu ? "English" : "Russian",
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: queryController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        queryController.text = '';
                                        focusNode.requestFocus();
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: AppColors.primaryColor,
                                      ))),
                              onFieldSubmitted: (text) async {
                                if (controller.isEnRu) {
                                  await controller.getData(
                                      word: queryController.text);
                                } else if (!controller.isEnRu) {
                                  await controller.getData(
                                      lang: 'ru-en',
                                      word: queryController.text);
                                }
                              },
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.greyColor),
                          )
                        ],
                      ),
                      preferredSize: Size.fromHeight(120)),
                )
              ];
            }),
            body: wordModel.def == null
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
                                                    style: textTheme.bodyLarge,
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
                                                            .contains(wordModel
                                                                .def![0]
                                                                .text!)) {
                                                          WordCRUD().delete(
                                                              wordModel.def![0]
                                                                  .text!);
                                                        }
                                                      },
                                                      child: Icon(
                                                        words.contains(wordModel
                                                                .def![0].text!)
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
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    wordModel.def!.isEmpty
                                                        ? ''
                                                        : '/${wordModel.def![0].ts ?? ''}/',
                                                    style: textTheme.bodySmall!
                                                        .copyWith(
                                                            color: Colors.grey),
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
                                                                          .def![
                                                                              index]
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
          ),
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
