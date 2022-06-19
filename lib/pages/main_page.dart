import 'package:flutter/material.dart';
import 'package:my_dict_en_ru/pages/favorites_page.dart';
import 'package:my_dict_en_ru/pages/home_page.dart';
import 'package:my_dict_en_ru/pages/search_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<BottomNavigationBarItem> bottomItems = [
    
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
    BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
  ];
  List<Widget> pages = [
    SearchPage(),
    FavoritesPage(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    tabController = TabController(length: pages.length, vsync: this,initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        items: bottomItems,
      ),
    );
  }
}
