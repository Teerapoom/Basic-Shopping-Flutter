import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'share.dart';

class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() =>
      ProductsPageState();
}

class ProductsPageState extends State<ProductsPage> {
  late Future<List<dynamic>> allProducts; //เรียก api                             
  var listProducts = [];
  bool _apiCalling = true;
  var fmt = NumberFormat.decimalPattern();
  //สำหรับจัดรูปแบบตัวเลข (ราคาสินค้า)

  @override
  void initState() {
    super.initState();

    //อ่านข้อมูลจากเซิร์ฟเวอร์
    allProducts = apiGetAllProducts();

    //เมื่อข้อมูลถูกส่งกลับมา ให้อ่านแต่รายการจาก Future
    //ไปจัดเก็บในลิสต์
    allProducts.then((value) {
      for (var p in value) {
        listProducts.add(p);
      }
      setState(() {
        _apiCalling = false;
      });

    });
    //ลักษณะของข้อมูลคือ
    /*
    listProducts = [
      {id: 1001, name: 'iPhone', price: 35000, imgUrl: '...'},
      {id: 1002, name: 'iPad', price: 25000, imgUrl: '...'},
      ...
    ]
    */
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('สินค้า')),
      body: (_apiCalling)
      ? Center(child: CircularProgressIndicator())
      : GridView.builder(
          itemCount: listProducts.length,
          padding: EdgeInsets.all(10),
          gridDelegate:
          SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5
          ),
          itemBuilder: (context, index) =>
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: buildGridTile(index)
            )
      ),
  );

  //สร้างรายการด้วย GridTile และห่อหุ้มทั้งหมดด้วย InkWell
  //ให้สามารถคลิกที่ส่วนใดส่วนหนึ่งของรายการก็ได้
  //และเนื่องจาก เราเก็บข้อมูลในแบบ List<Map>
  //ดังนั้น ต้องใช้เลขลำดับรายการของ List
  //ร่วมกับคีย์ของ Map เพื่อเข้าถึงค่าของสมาชิก
  Widget buildGridTile(int index) => InkWell(
    child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            listProducts[index]['name'],
            textScaleFactor: 1.3,
            maxLines: 1,
          ),
          subtitle: Text(
            '฿${fmt.format(listProducts[index]['price'])}'
          ),
          trailing: Icon(
              Icons.arrow_forward_ios,
              size: 32,
              color: Colors.white
          ),
        ),
        child: Image.network(
            listProducts[index]['imgUrl'],
            //fit: BoxFit.cover
        )
    ),

    //เมื่อคลิกที่รายการ ให้เปิดไปยังเพจที่แสดงรายละเอียดสินค้า
    //พร้อมส่งค่า id ไปเป็นเงื่อนใขสำหรับการอ่านข้อมูล
    onTap: () => {
      Navigator.pushNamed(
          context, '/product_detail',
          arguments: {'id': listProducts[index]['id']} // การส่งเเค่เเบบ routes
      ).then((value) {
        Share.updateCartItems(Share.cartItems);
      })
    },
  );
}
