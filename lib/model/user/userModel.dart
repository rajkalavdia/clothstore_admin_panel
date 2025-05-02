import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String password;
  String name;
  String phoneNumber;
  String signInMethod; // "email", "google", or "phone"
  String imageUrl;
  bool profileComplete; // New field to track profile completion
  List<String> favouriteProductIDs = [];
  List<String> ordersList = [];
  DateTime createdAt = DateTime.now(); // New field to track account creation time
  DateTime lastLogin = DateTime.now(); // New field to track last login time

  UserModel({
    this.uid = "",
    this.email = "",
    this.password = "",
    this.name = "",
    this.phoneNumber = "",
    this.signInMethod = "",
    this.imageUrl = "",
    List<String>? favouriteProductIDs,
    List<String>? ordersList,
    this.profileComplete = false, // Default to false for new users
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.lastLogin = lastLogin ?? DateTime.now();
    this.favouriteProductIDs = favouriteProductIDs ?? [];
    this.ordersList = ordersList ?? [];
  }

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'signInMethod': signInMethod,
      'imageUrl': imageUrl,
      'profileComplete': profileComplete,
      'favouriteProductIDs': favouriteProductIDs,
      'ordersList': ordersList,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  // Create UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      signInMethod: map['signInMethod'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      profileComplete: map['profileComplete'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      favouriteProductIDs: map['favouriteProductIDs'] != null ? List<String>.from(map['favouriteProductIDs']) : [],
      ordersList: map['ordersList'] != null ? List<String>.from(map['ordersList']) : [],
    );
  }
}
