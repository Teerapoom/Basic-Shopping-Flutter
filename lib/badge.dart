import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

Widget badge(dynamic cartItemsCount) {
  var showBadge = false;
  var padding = 4.0;
  //ถ้าไม่มีสินค้าในรถเข็น ให้ซ่อน ฺBadge
  if (cartItemsCount > 0) {
    showBadge = true;
    if (cartItemsCount < 10) {
      padding = 7.0;
    }
  }

  return badges.Badge( // ใช้ตัวบ่งชี้ badges.Badge
    child: Icon(
      Icons.shopping_cart,
      color: Colors.white,
    ),
    badgeContent: Text(
      '$cartItemsCount',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    showBadge: showBadge,
    badgeStyle: badges.BadgeStyle( // ใช้ตัวบ่งชี้ badges.BadgeStyle
      badgeColor: Colors.orange,
      padding: EdgeInsets.all(padding),
    ),
    position: badges.BadgePosition.topEnd(), // ใช้ตัวบ่งชี้ badges.BadgePosition
    badgeAnimation: badges.BadgeAnimation.fade(), // ใช้ตัวบ่งชี้ badges.BadgeAnimation
  );
}