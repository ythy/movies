import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {

   String _userName = "maoxin";

   String _userPassword = "";

   String get userName => _userName;
   set userName(String value) {
      if (_userName == value) {
         return;
      }
      _userName = value;

   }

   String get userPassword => _userPassword;
   set userPassword(String value) {
      if (_userPassword == value) {
         return;
      }
      _userPassword = value;

   }


}