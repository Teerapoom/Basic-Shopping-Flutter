
import 'package:http/http.dart' as http;
import 'dart:convert';

var url = 'https://www.developerthai.com/flutter/shopping-cart.php';

//สำหรับอ่านข้อมูลทุกรายการ จึงต้องเก็บผลลัพธ์ในแบบลิสต์
Future<List<dynamic>> apiGetAllProducts() async {
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var list = jsonDecode(response.body) as List<dynamic>;
    return list;
  } else {
    throw Exception('http.get() error');
  }
}

//อ่านเพียงรายการแบบเจาะจง
//โดยรับค่า id เข้ามาทางพารามิเตอร์
Future<Map<String, dynamic>> apiGetProduct(int id) async {
  var response = await http.post(
      Uri.parse(url),
      headers: <String, String> {
        'content-type': 'application/json'
      },
      body: jsonEncode(
          <String, dynamic> {'id': id}
      )
  );

  if (response.statusCode == 200) {
    var mapProduct = jsonDecode(response.body) as Map<String, dynamic>;
    return mapProduct;
  } else {
    throw Exception('http.get() error');
  }
}