//
// import 'package:clothstore_admin_pannel/model/adminModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../provider/adminProvider.dart';
//
// class AdminController {
// AdminProvider? adminProvider;
//
// final FirebaseAuth _auth = FirebaseAuth.instance;
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
// // Try this version of getUserProvider for additional safety
// AdminProvider getUserProvider(BuildContext context) {
//   try {
//     final provider = Provider.of<AdminProvider>(context, listen: false);
//     return provider;
//   } catch (e) {
//     return AdminProvider();
//   }
// }
//
//   // Sign in existing user with email/password
//   Future<AdminModel?> signInAdmin(String username, String password, context) async {
//     try {
//       AdminModel? admin = adminProvider?.admin;
//
//       if (admin != null) {
//
//         DocumentSnapshot adminDoc = await _firestore.collection('users').doc(admin.adminUid).get();
//         if (adminDoc.exists) {
//           AdminModel adminModel = AdminModel.fromMap(adminDoc.data() as Map<String, dynamic>);
//
//           await _firestore.collection('users').doc(admin.uid).update({
//           });
//           adminProvider = getUserProvider(context);
//           adminProvider?.setUser(adminModel);
//           return adminModel;
//         } else if (admin.displayName == null || admin.email == null) {
//           AdminModel newAdmin = AdminModel(
//             adminName: admin.displayName,
//             adminUid: admin.uid,
//           );
//
//           try {
//             await _firestore.collection('admin').doc(admin.uid).set(newAdmin.toMap());
//             adminProvider = getUserProvider(context);
//             adminProvider?.setUser(newAdmin);
//           } catch (e) {
//             print("Error saving to Firestore: $e");
//           }
//           return newAdmin;
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error signing in: $e');
//       return null;
//     }
//   }
//
//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }
