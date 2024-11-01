import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BookService {
  final String apiUrl =
      'https://bookappdb.onrender.com/api/books'; // URL สำหรับ API ของคุณ
  final String baseUrl =
      'https://bookappdb.onrender.com'; // กำหนด base URL สำหรับการสร้าง URL ของภาพ
  String get imageUrl => '$baseUrl/images'; // หรือที่อยู่ที่ถูกต้องสำหรับภาพ

  /// เพิ่มข้อมูลหนังสือใหม่
  Future<Map<String, dynamic>?> createBook(
      File imageFile, String title, String author, String publishedDate) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(apiUrl)); // ใช้ apiUrl แทน baseUrl
    request.fields.addAll({
      'title': title,
      'author': author,
      'published_date': publishedDate,
    });
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      return null;
    }
  }

  // ดึงข้อมูลหนังสือทั้งหมด
  Future<List<dynamic>> fetchBooks() async {
    final response =
        await http.get(Uri.parse(apiUrl)); // ใช้ apiUrl แทน baseUrl
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      print('Failed to load books: ${response.statusCode}');
      throw Exception('ไม่สามารถโหลดข้อมูลหนังสือได้');
    }
  }

  // แก้ไขข้อมูลหนังสือ
  Future<Map<String, dynamic>?> updateBook(int bookId, File imageFile,
      String title, String author, String publishedDate) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse('$apiUrl/$bookId')); // ใช้ apiUrl
    request.fields.addAll({
      'title': title,
      'author': author,
      'published_date': publishedDate,
    });
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      String data = await response.stream.bytesToString();
      return jsonDecode(data);
    } else {
      print('Failed to update book: ${response.statusCode}');
      return null;
    }
  }

  // ลบข้อมูลหนังสือ
  Future<bool> deleteBook(int bookId) async {
    final response = await http.delete(Uri.parse('$baseUrl/books/$bookId'));
    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed to delete book: ${response.statusCode}');
      return false; // เปลี่ยนเป็น false แทนการ throw exception
    }
  }
}
