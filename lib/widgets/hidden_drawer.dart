import 'package:chat_app/screens/developer.dart';
import 'package:chat_app/screens/home.dart';
import 'package:chat_app/screens/settings.dart';
import 'package:chat_app/screens/user_profile.dart';
import 'package:chat_app/widgets/first_name.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];
  final currentUserEmail =
      FirebaseAuth.instance.currentUser!.email.toString().trim();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Friends',
            baseStyle: TextStyle(),
            selectedStyle: TextStyle()),
        Home(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Your Profile',
            baseStyle: TextStyle(),
            selectedStyle: TextStyle()),
        UserProfile(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Settings',
            baseStyle: TextStyle(),
            selectedStyle: TextStyle()),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Developer ^_^',
            baseStyle: TextStyle(),
            selectedStyle: TextStyle()),
        Developer(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: Colors.cyan[200]!,
      initPositionSelected: 0,
      leadingAppBar: Icon(Icons.menu),
      backgroundColorAppBar: Color(0xFF00cfdf),
    );
  }
}
