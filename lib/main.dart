import 'package:clothstore_admin_pannel/backend/provider/categoryProvider.dart';
import 'package:clothstore_admin_pannel/backend/provider/homeScreenProvider.dart';
import 'package:clothstore_admin_pannel/backend/provider/productProvider.dart';
import 'package:clothstore_admin_pannel/backend/provider/userProvider.dart';
import 'package:clothstore_admin_pannel/firebase_options.dart';
import 'package:clothstore_admin_pannel/views/categeries/addEditCategories.dart';
import 'package:clothstore_admin_pannel/views/categeries/categoriesScreen.dart';
import 'package:clothstore_admin_pannel/views/homeScreen/homeScreen.dart';
import 'package:clothstore_admin_pannel/views/product/addEditProduct.dart';
import 'package:clothstore_admin_pannel/views/product/productsScreen.dart';
import 'package:clothstore_admin_pannel/views/signInScreen/signInScreen.dart';
import 'package:clothstore_admin_pannel/views/splashScreen/splashScreen.dart';
import 'package:clothstore_admin_pannel/views/user/orderDetails.dart';
import 'package:clothstore_admin_pannel/views/user/userDetailsScreen.dart';
import 'package:clothstore_admin_pannel/views/user/userScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: 'orbital-signal-369106', options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyC64zvcOfOD-S8AfznjFm-5tlIhdDvBCrY',
      appId: '1:831777599075:android:7c4bcce0053710270d1256',
      messagingSenderId: '831777599075',
      projectId: 'orbital-signal-369106',
      databaseURL: 'https://orbital-signal-369106-default-rtdb.asia-southeast1.firebasedatabase.app',
      storageBucket: 'orbital-signal-369106.firebasestorage.app',
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
        ChangeNotifierProvider<ProductProvider>(create: (context) => ProductProvider()),
        ChangeNotifierProvider<HomeScreenProvider>(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider<CategoryProvider>(create: (context) => CategoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Splashscreen.routeName,
        routes: {
          Splashscreen.routeName: (context) => Splashscreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          SignInScreen.routeName: (context) => SignInScreen(),
          ProductsScreen.routeName: (context) => ProductsScreen(),
          AddEditProduct.routeName: (context) => AddEditProduct(),
          CategoriesScreen.routeName: (context) => CategoriesScreen(),
          AddEditCategories.routeName: (context) => AddEditCategories(),
          UserScreen.routeName: (context) => UserScreen(),
          UserDetailsScreen.routeName: (context) => UserDetailsScreen(),
          OrderDetails.routeName: (context) => OrderDetails(),
        },
      ),
    );
  }
}
