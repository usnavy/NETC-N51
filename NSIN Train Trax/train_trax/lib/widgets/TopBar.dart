import 'package:flutter/material.dart';
import 'package:train_trax/utils/ProfileBar.dart';
import 'package:train_trax/utils/profile.dart';

class TopBar {
  String? name = null;

  void setPage(String? pname){
    name=pname;

  }

  static Row createTopBar(BuildContext context, String name, String currentPage, String tokn, bool isAdmin){
    return Row(
      children: [
      Profile.createProfile(context, name, true),
      Spacer(),
      ProfileBar.createProfileBar(context, currentPage, tokn, name, isAdmin,),
      ],
    );
  }
}
