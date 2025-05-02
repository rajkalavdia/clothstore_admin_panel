import 'package:clothstore_admin_pannel/backend/provider/homeScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../categeries/categoriesScreen.dart';
import '../product/productsScreen.dart';
import '../statistics/statisticsScreen.dart';
import '../user/userScreen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screens = [
    ProductsScreen(),
    CategoriesScreen(),
    StatisticsScreen(),
    UserScreen(),
  ];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final homeScreenProvider = context.watch<HomeScreenProvider>();
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'ClothStore Admin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.grey[900],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: _screens[homeScreenProvider.currentIndex],
          drawer: sideDrawer(
            drawerListTile: [
              ListTile(
                onTap: () async {
                  homeScreenProvider.onItemTapped(0);
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.draw_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  'Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  homeScreenProvider.onItemTapped(1);
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.edit_note,
                  color: Colors.white,
                ),
                title: Text(
                  'Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  homeScreenProvider.onItemTapped(2);
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.show_chart_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Statistics',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  homeScreenProvider.onItemTapped(3);
                  Navigator.pop(context);
                },
                leading: Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Users',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sideDrawer({required List<Widget> drawerListTile}) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      backgroundColor: Colors.grey[900],
      child: ListView(
        children: [
          DrawerHeader(
            margin: EdgeInsets.all(18),
            child: Text(
              'ClothStore Admin Panel',
              style: TextStyle(fontSize: 30, color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
          ),
          ...drawerListTile,
        ],
      ),
    );
  }
}
