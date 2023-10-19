import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'home.dart';
import 'cart.dart';
//import 'shared_data.dart';
import 'products.dart';
import 'menu.dart';
import 'badge.dart';
import 'share.dart';

void main() => runApp(Workshop16());

class Workshop16 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    //กำหนดเส้นทางไปยังเพจต่างๆ
    initialRoute: '/',
    routes: {
      '/': (context) => MainPage(),
      '/product_detail': (context) => ProductDetailPage(),
      '/cart': (context) => CartPage()
    },
  );
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  //เพจที่จะเชื่อมโยงกับ BottomNav.
  var pages = <Widget>[
    HomePage(), ProductsPage(),
    CartPage(), MenuPage()
  ];

  int _cartItemsCount = 0;  //จำนวนสินค้าในรถเข็น
  int _navItemIndex = 0;    //ลำดับปุ่มของ BottomNav.

  @override
  Widget build(BuildContext context) {
    //กำหนดวิธีการทำงานใหักับเมธอดในคลาส ฆhare
    //โดยนำไปแทนที่รายการข้อมูลเดิม
    //ซึ่งข้อมูลที่ผ่านเข้ามาจะเป็นลิสต์ของรายการ
    Share.updateCartItems = (value) {
      setState(() {
        Share.cartItems = value;

        //ต้องอ่านจำนวนสินค้าในรถเข็นใหม่
        //เพื่อให้มีผลต่อการการแสดงตัวเลข badge count
        _cartItemsCount = Share.cartItemsCount();
      });
    };

    //เชื่อมโยงลำดับของปุ่ม BottomNav กับคลาส Share
    _navItemIndex = Share.navBarIndex;

    return Scaffold(
      body: pages[_navItemIndex],
      bottomNavigationBar: BottomNavigationBar(
          //ข้อกำหนดของ BottomNav. ให้ดูในบทที่ 13
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.yellow,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedFontSize: 14,
          selectedFontSize: 14,
          currentIndex: _navItemIndex,
          items: bottomNavItems(),
          onTap: (index) => setState(
            () {
              //เมื่อคลิกปุุ่ม BottomNav.
              //ให้อัปเดตลำดับปุ่มปัจจุบันและในคลาส Share ให้ตรงกัน
              Share.navBarIndex = index;
              _navItemIndex = Share.navBarIndex;
              //เขียนรวบให้สั้นกว่านี้ก็ได้
            }
          )
      ),
    );
  }

  //กำหนดองค์ประกอบ BottomNav.
  List<BottomNavigationBarItem> bottomNavItems() {
    var navItemLabels = [
      'หน้าแรก', 'สินค้า',
      'รถเข็น', 'เมนู'
    ];

    var bgColors = [
      Colors.deepPurple, Colors.indigo,
      Colors.teal, Colors.brown
    ];

    var navItemIcons = [
      Icons.home, Icons.apps,
      null, Icons.menu
    ];

    var len = navItemIcons.length;

    return List.generate(len, (index) =>
        BottomNavigationBarItem(
          label: navItemLabels[index],
          backgroundColor: bgColors[index],
          //ถ้าไม่ใช้ปุ่มลำดับที่ 2 ให้แสดงไอคอนตามที่กำหนดในลิสต์
          //ถ้าเป็นปุ่มในลำดับที่ 2 (หรือปุ่มที่ 3) ซึ่งเป็นรถเข็น
          //ให้กำหนดไอคอนและแสดงจำนวนสินค้าในรถเข็นด้วย badge()
          //ซึ่งฟังก์ชันนี้ เราได้สร้างเอาไว้แล้วในไฟล์ badge.dart
          icon: (index != 2)
            ? Icon(navItemIcons[index])
            : badge(_cartItemsCount)
        )
    );
  }
}
