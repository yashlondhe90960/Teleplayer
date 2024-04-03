import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:teleplay/screens/home/download_page.dart';
import 'package:teleplay/screens/home/history_page.dart';
import 'package:teleplay/screens/home/menu_screen.dart';
import 'package:teleplay/screens/home/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;

  final pages = [
    const SearchPage(),
    const HistoryPage(),
    const DownloadPage(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: GNav(
          onTabChange: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          backgroundColor: Colors.white,
          color: Colors.blue,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.blue,
          tabBorderRadius: 10,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          tabMargin: const EdgeInsets.all(2),
          gap: 6,
          tabs: const [
            GButton(
              icon: (Icons.search),
              text: 'Search',
            ),
            GButton(
              icon: (Icons.history_outlined),
              text: "History",
            ),
            GButton(
              icon: (Icons.download_outlined),
              text: 'Downloads',
            ),
            GButton(icon: (Icons.menu), text: 'Menu')
          ]),
    );
  }
}
