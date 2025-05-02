import 'package:clothstore_admin_pannel/backend/provider/categoryProvider.dart';
import 'package:clothstore_admin_pannel/model/categoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../backend/controller/categoryController.dart';
import 'addEditCategories.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = "/CategoriesScreen";

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  CategoryProvider categoryProvider = CategoryProvider();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      await CategoryController().getCategoryFirebase(categoryProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Column(
            children: [
              getHeader(context),
              getCategories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Expanded(child: SizedBox()),
        Container(
          height: 50,
          width: 160,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.grey[900],
          child: InkWell(
            onTap: () async {
              dynamic res = await Navigator.pushNamed(context, AddEditCategories.routeName);
              print("res res res : $res");
              if (res == true) {
                isLoading = true;
                await CategoryController().getCategoryFirebase(categoryProvider);
                isLoading = false;
                setState(() {});
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.draw_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                Text(
                  "Add Categories",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getCategories() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
              itemCount: categoryProvider.categoryList.length,
              itemBuilder: (context, int index) {
                final _model = categoryProvider.categoryList[index];
                print("Category Name: ${_model.categoryName}"); // This line prints the category name
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _model.categoryImageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _model.categoryName,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (builder) => AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  "Delete Category",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                content: Text(
                                  " Are you sure for delete This ${_model.categoryName} category?",
                                  style: TextStyle(fontSize: 15),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoading = true;
                                      });

                                      final storageRef = await FirebaseStorage.instance.ref().child("categories/${_model.categoryName}/${_model.categoryUid}");
                                      await storageRef.delete();
                                      await FirebaseFirestore.instance.collection("admin").doc("property").update({
                                        'categories.${_model.categoryUid}': FieldValue.delete(),
                                      });
                                      categoryProvider.categoryList.clear();
                                      await CategoryController().getCategoryFirebase(categoryProvider);
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Category Delete SuccesFully."),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(milliseconds: 4000),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.red[900],
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 35,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                        child: IconButton(
                          onPressed: () {
                            categoryProvider.startEdit();
                            Navigator.pushNamed(context, AddEditCategories.routeName, arguments: <String, CategoryModel>{"categoryModel": _model});
                          },
                          icon: Image.asset("assets/icons/category/editCategory.png"),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}

// Future<void> deleteCategoryFolder(String categoryUid) async {
//
//   print("name :$name");
//
//   final storageRef = FirebaseStorage.instance.ref().child("categories/$categoryUid/$name");
//
//   try {
//     // List all items in the directory
//     final ListResult result = await storageRef.listAll();
//
//     // Delete all files in the directory
//     for (final Reference ref in result.items) {
//       await ref.delete();
//       print("Deleted file: ${ref.fullPath}");
//     }
//
//     // Delete all directories in the directory (if there are nested folders)
//     for (final Reference ref in result.prefixes) {
//       // You would need to recursively delete each subfolder
//       // This is where you'd call this same function again with the new path
//       print("Found subfolder: ${ref.fullPath}");
//     }
//
//     print("Folder and all contents deleted successfully");
//   } on FirebaseException catch (e) {
//     print("Error deleting folder: ${e.code} - ${e.message}");
//   }
// }
//
// await deleteCategoryFolder(_model.categoryUid);
