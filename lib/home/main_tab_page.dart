import 'package:flutter/material.dart';
import 'package:used_market/view/used_market/goods_list.dart';
import 'package:used_market/view/user_info_management/my_page.dart';
import 'home.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({Key? key}) : super(key: key);

  @override
  State<MainTabPage> createState() => MainTabPageState();
}

class MainTabPageState extends State<MainTabPage> {
  int _selectedIndex = 0;
  final screens = [const Home(), const GoodsList(), GoodsList(), const MyPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.widgets_outlined), label: '중고마켓'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
        iconSize: 25,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
