import 'package:flutter/material.dart';
import '../screens/farmer_screen.dart';
import '../screens/shoper_screen.dart';
import 'user_session.dart';

Widget getHomeByRole() {
  if (UserSession.role == 'farmer') {
    return const FarmerHomePage();
  } else {
    return const ShopperHomePage();
  }
}
