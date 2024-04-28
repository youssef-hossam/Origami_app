// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:origami/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home_screen.dart';

check() {}
// Method to log in
Future<void> login({
  required TextEditingController phone,
  required TextEditingController pass,
  required BuildContext context,
}) async {
  // Perform login logic here

  try {
    // Check if phone number exists in Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phone.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // User with given phone number exists, now check password
      DocumentSnapshot userSnapshot = querySnapshot.docs.first;
      String storedPassword = userSnapshot['password'];

      if (storedPassword == pass.text) {
        // Password is correct, set login status to true and navigate to home screen
        await setLoginStatus(true);
        print("Login successful!");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
        // Navigate to home screen or any other authenticated screen
      } else {
        // Password is incorrect
        print("Incorrect password!");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'خطأ بالباسورد',
          desc: ' بالرجاء التأكد من صحه البيانات المدخله واعاده المحاوله ',
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      // User with given phone number does not exist
      print("User not found!");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'المستخدم غير موجود',
        desc: ' بالرجاء التأكد من صحه البيانات المدخله واعاده المحاوله ',
        btnOkOnPress: () {},
      );
    }
  } catch (e) {
    // Handle errors
    print("Error: $e");
  }
}

logout({required BuildContext context}) {
  setLoginStatus(false);
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false);
}

// Function to store login status locally
//
Future<void> setLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

// }
Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool loginstate = prefs.getBool('isLoggedIn') ??
      false; // Default to false if value is not found
  return loginstate;
}