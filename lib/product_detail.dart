import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'badge.dart';
import 'api.dart';
import 'share.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() =>
      ProductDetailPageState();
}

class ProductDetailPageState extends State<ProductDetailPage> {
  late Future<Map<String, dynamic>> future;
  var id = 0;
  var price = 0;
  bool _apiCalling = true;
  var product = {};
  var fmt = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;  // ใช้ในการดึงข้อมูลที่ถูกส่งมาผ่านการเปิดหน้าจอ (routing)

    id = args['id'];

    future = apiGetProduct(id);
    future.then((value) {
      product = value;
      setState(() => _apiCalling = false);
    });

    return Scaffold(
      appBar: buildAppBar(context, 'รายละเอียดสินค้า'),
      body: (_apiCalling)
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product['imgUrl'],
                fit: BoxFit.cover,
              )
          ),
          SizedBox(height: 15),

          column2(),
          SizedBox(height: 25),

          column3()
        ]),
      ),
    );
  }

  //คอลัมน์ 2 กำหนดโครงร้างด้วย ListTile
  Widget column2() => ListTile(
    title: Text(
      '${product['name']}',
      textScaleFactor: 1.5,
      style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold
      ),
    ),
    subtitle: Text(
        '฿${fmt.format(product['price'])}',
        textScaleFactor: 1.2
    ),
    trailing: IconButton(
        icon: Icon(
            Icons.add_shopping_cart,
            size: 36,
            color: Colors.green
        ),
        onPressed: () {
          //รายการสินค้าทั้งหมดในรถเข็น
          var cartItems = Share.cartItems
                          as List<Map<String, dynamic>>;

          bool existing = false;
          setState(() {
            //ตรวจสอบแต่ละรายการในรถเข็น
            //ถ้า id สินค้านั้นกับรายการกำลังแสดงผล
            //แสดงว่ารายการนั้นมีอยู่แล้วในรถเข็น
            //เราก็เพิ่มจำนวนไปอีก 1
            cartItems.forEach((element) {
              if (element['id'] == id) {
                element['quantity'] += 1;
                Share.cartItems = cartItems;
                existing = true;
              }
            });

            //ถ้ายังไม่มีสินค้านั้นในรถเข็น
            //ให้นำข้อมูลสินค้ามาสร้างเป็นรายการแบบ Map
            //แล้วเพิ่มลงในเข้าในลิสต์ที่เก็บรายการในรถเข็น
            if (!existing) {
              cartItems.add({
                'id': product['id'],
                'name': product['name'],
                'quantity': 1,
                'imgUrl': product['imgUrl']
              });
            }
            /*
            เมื่อเราอัปเดตรายการสินค้าในรถเข็น ซึ่งเก็บในคลาส Share
            จำนวนสินค้าในรถเข็นจะถูกอัปเดตามทันที
            เพราะเรากำหนดค่าไว้ใน setState()
            */
          });
        }
    ),
  );

  //คอลัมน์ 3 แสดงข้อความธรรมดา
  Widget column3() => Container(
    alignment: Alignment.centerLeft,
    child: Text('${product['detail']}'),
  );

  //ส่วนของ AppBar เราวางไอคอน home เพื่อย้อนกลับไปยังเพจแรก
  //และไอคอน cart เพื่อแสดง badge count และเชื่อมโยง
  //ไปยังเพจรายการสินค้าในรถเข็น
  AppBar buildAppBar(BuildContext context,
      String title) {

    int _cartItemsCount = Share.cartItemsCount();

    return AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              //เมื่อคลิกที่ไอคอนนี้ ให้กำหนดลดับของปุ่ม BottomNav. เป็น 0
              //ซึ่งก็คือปุ่ม หน้าแรก แล้วนำเพจปัจจุบันออกจาก Stack
              //เพื่อให้เพจแรกถูกนำขึ้นมาแสดง
              setState(() => Share.navBarIndex = 0);
              Navigator.pop(context);
            },
          ),

          //เราจะใช้ Padding ห่อหุ้มไอคอน cart
          //เพื่อจัดไม่ให้มันชิดแนวขอบจอด้านขวาจนเกินไป
          Padding(
              padding: EdgeInsets.only(left: 10, right: 15),
              child: IconButton(
                  //แสดง badge count จากฟังก์ขัน badge()
                  //ซึ่งกำหนดไว้แล้วที่ไฟล์ badge.dart
                  icon: badge(_cartItemsCount),
                  onPressed: () {
                    //เมื่อคลิกที่ไอคอนนี้ ให้กำหนดลดับของปุ่ม BottomNav. เป็น 2
                    //ซึ่งก็คือปุ่ม รถเข็น แล้วนำเพจปัจจุบันออกจาก Stack
                    //เพื่อให้เพจรถเข็นถูกนำขึ้นมาแสดง
                    setState(() => Share.navBarIndex = 2); // 2 คือ index
                    Navigator.pop(context);
                  }
              )
          )
        ]
    );
  }
}
