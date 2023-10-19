
import 'package:flutter/material.dart';
import 'share.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  var cartItems = [];

  @override
  Widget build(BuildContext context) {
    cartItems = Share.cartItems;

    return Scaffold(
        appBar: AppBar(title: Text('รถเข็น')),
        body: Container(
            padding: EdgeInsets.all(15),
            alignment: Alignment.topCenter,
            child:
            //ถ้ามีสินค้าในรถเข็น ให้แสดงรายการด้วย ListView
            //ถ้าไม่มี ให้แสดงข้อความ ว่าไม่มีสินค้า
            (cartItems.length > 0)
            ? ListView.separated(
                itemCount: cartItems.length,
                itemBuilder: (ctx, idx) => buildListTile(idx),
                separatorBuilder: (ctx, idx) => Divider(
                  thickness: 1, color: Colors.indigo,
                )
            )
            : Text('ไม่มีสินค้าในรถเข็น', textScaleFactor: 1.5)
        )
    );
}

  //เมธอดสำหรับสร้าง ListView แบบมีเส้นแบ่งรายการ
  Widget builListView() => ListView.separated(
      itemCount: cartItems.length,
      itemBuilder: (ctx, i) => buildListTile(i), //กำหนดรายการ
      separatorBuilder: (ctx, i) => //กำหนดเส้นเเบ่งรายการ                     
          Divider(thickness:1, color:Colors.indigo)
  );

  //สร้างรายการของ ListView ด้วย ListTile
  Widget buildListTile(int index) => ListTile(
    contentPadding: EdgeInsets.only(top: 5, bottom: 5),
    leading: ClipRRect( //โค้งมล  leding widget ที่แสดงด้านขวามือ
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
            cartItems[index]['imgUrl'],
            width: 60.0,
        ) 
    ),
    title: Text(
        cartItems[index]['name'],
        textScaleFactor: 1.3,
        maxLines: 2,
    ),
    trailing: rowQuantity(index), // widget ที่แสดงด้านขวามือ
    onTap: () {
        //เมื่อแตะทีรายการ ให้เลื่อนกลับไปยังเพจแสดงรายละเอียด
        //ของสินค้ารายการนั้น โดยส่งค่า id ย้อนกลับไปด้วย
        Navigator.pushNamed(
            context, '/product_detail',
            arguments: {'id': cartItems[index]['id']}
        ).then((value) {
          Share.updateCartItems(Share.cartItems);
        });
    },
  );

  //ส่วนที่แสดงจำนวนสินค้าของแต่ละรายการ
  //ซึ่งเราให้มี 3 วิดเจ็ตเรียงต่อกันในแนวนอน
  //จึงกำหนดโครงร่างด้วย Row
  Widget rowQuantity(int index) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      OutlinedButton(
          style: btnSyle(),
          child: Text('-', textScaleFactor: 1.3),
          onPressed: () {
            setState(() {
              //เมื่อคลิกปุ่ม - ให้ลดจำนวนสินค้าลง 1
              //ถ้าลดแล้วเหลือ 0 ให้ลบรายการนั้นออกจาก
              //cartItems ซึ่งจะส่งให้รายการนั้นถูกลบ
              //ออกจาก ListView ตามไปด้วย
              var item = cartItems[index];
              if (item['quantity'] > 0) {
                item['quantity'] -= 1;
                if (item['quantity'] == 0) {
                  cartItems.removeAt(index);
                }
              }                                                                            
              Share.updateCartItems(cartItems);
            });
          },
      ),

      Text(' ${cartItems[index]['quantity']} ', textScaleFactor: 1.4),

      OutlinedButton(
          style: btnSyle(),
          child: Text('+', textScaleFactor: 1.3),
          onPressed: () {
            //ถ้าคลิกปุ่ม + ให้เพิ่มจำนวนสินค้ารายการนั้นไปอีก 1
            setState(() {
              var item = cartItems[index];
              item['quantity'] += 1;
            });
            Share.updateCartItems(cartItems);
          }
      )
    ],
  );

  //สำหรับปรับแต่งรูปแบบของปุ่ม -/+
  ButtonStyle btnSyle() => OutlinedButton.styleFrom(
    minimumSize: Size(30, 30),
    side: BorderSide(
      color: Colors.black26,
      width: 1.2,
      style: BorderStyle.solid,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
  );

}
