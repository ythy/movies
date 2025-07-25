import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {

   String _id = "maoxin";
   String _name = "毛欣";
   String _password = "";
   String _blockFlag = "N";

   String get name => _name;
   set name(String value) {
      if (_name == value) {
         return;
      }
      _name = value;
   }

   String get id => _id;
   set id(String value) {
      if (_id == value) {
         return;
      }
      _id = value;
   }

   String get password => _password;
   set password(String value) {
      if (_password == value) {
         return;
      }
      _password = value;
   }

   String get blockFlag => _blockFlag;
   set blockFlag(String value) {
      if (_blockFlag == value) {
         return;
      }
      _blockFlag = value;
   }


}