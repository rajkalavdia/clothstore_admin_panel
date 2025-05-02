import 'package:clothstore_admin_pannel/backend/provider/productProvider.dart';
import 'package:clothstore_admin_pannel/model/adminModel.dart';
import 'package:clothstore_admin_pannel/views/homeScreen/homeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = "/SignInScreen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValidationEnabled = false;

  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ProductProvider productProvider = ProductProvider();

  AdminModel adminModel = AdminModel();

  Future<void> adminSignIn() async {
    try {
      QuerySnapshot query = await _firestore.collection('admin').where('userName', isEqualTo: _userNameController.text.trim()).where('passWord', isEqualTo: _passwordController.text.trim()).get();
      if (query.docs.isNotEmpty) {
        DocumentSnapshot doc = query.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        adminModel = AdminModel.fromMap(data);
        // print("admin model : ${adminModel.toString()}");
        // print("admin model data : $data}");
        //
        // if(adminModel.adminUserName != _userNameController.text){
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect Username!")));
        //   return;
        // }
        // if(adminModel.password != _passwordController.text.trim()){
        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect Password!")));
        //   return;
        // }

        _userNameController.clear();
        _passwordController.clear();
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No user Found!")));
      }
    } catch (e) {
      print("Error in Sign in Admin:$e ");
    }
  }

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: CircularProgressIndicator(backgroundColor: Colors.transparent, color: Colors.black),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              getTitle(),
              getEmailTextFieldWidget(),
              getPasswordTextFieldWidget(),
              getContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Log In",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget getEmailTextFieldWidget() {
    return Form(
      key: _emailFormKey,
      child: Container(
        height: 80,
        margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
        decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: _userNameController,
          autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the Username';
            }
            return null;
          },
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: InputDecoration(
            labelText: 'UserName',
            contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
            hintStyle: TextStyle(color: Colors.black38, fontSize: 20),
            labelStyle: TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget getPasswordTextFieldWidget() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(18, 30, 18, 0),
      decoration: BoxDecoration(color: Colors.grey[350], borderRadius: BorderRadius.circular(10)),
      child: Form(
        key: _passwordFormKey,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          // Hides the password input
          keyboardType: TextInputType.number,
          // Allows only numbers
          autovalidateMode: _isValidationEnabled ? AutovalidateMode.always : AutovalidateMode.disabled,
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          style: TextStyle(color: Colors.black, fontSize: 20),
          decoration: InputDecoration(
            hintText: 'Enter your password',
            labelText: 'Password',
            contentPadding: EdgeInsets.fromLTRB(5, 18, 0, 0),
            hintStyle: TextStyle(color: Colors.black38, fontSize: 20),
            labelStyle: TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget getContinueButton() {
    return Container(
      height: 80,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_emailFormKey.currentState!.validate() && _passwordFormKey.currentState!.validate()) {
            await adminSignIn();
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent, elevation: 0),
        child: Text('Continue', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }
}
