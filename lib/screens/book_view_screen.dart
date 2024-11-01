import 'package:flutter/material.dart';
import '../services/book_service.dart';
import 'book_update_screen.dart';

class BookViewScreen extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookViewScreen({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดหนังสือ'),
        backgroundColor: const Color.fromARGB(255, 7, 123, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงรูปภาพหนังสือ
            SizedBox(
              width: double.infinity,
              height: 250, // กำหนดความสูงของรูปภาพ
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // ปรับมุมให้โค้ง
                child: Image.network(
                  BookService().imageUrl + "/" + (bookData['image'] ?? ''),
                  fit: BoxFit.cover, // ปรับให้เต็มขอบเขตของ Widget
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('ไม่สามารถโหลดรูปภาพได้'));
                  },
                ),
              ),
            ),
            SizedBox(height: 7.5),
            // แสดงชื่อหนังสือ
            Text(
              bookData['title'] ?? 'ไม่ระบุชื่อหนังสือ',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // แสดงผู้เขียน
            Text(
              'ผู้เขียน: ${bookData['author'] ?? 'ไม่ระบุผู้เขียน'}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // แสดงวันที่เผยแพร่
            Text(
              'วันที่เผยแพร่: ${bookData['published_date'] ?? 'ไม่ระบุวันที่'}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // แสดงสถานะการให้ยืม
            Text(
              'สถานะการให้ยืม: ${bookData['available'] ? 'สามารถให้ยืมได้' : 'ไม่สามารถให้ยืมได้'}',
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15),
            // ปุ่มสำหรับแก้ไขข้อมูลหนังสือ
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookUpdateScreen(
                      bookData: bookData,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('แก้ไขข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }
}
