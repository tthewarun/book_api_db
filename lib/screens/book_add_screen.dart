import 'package:flutter/material.dart';
import '../services/book_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'book_list_screen.dart';

class BookAddScreen extends StatefulWidget {
  @override
  _BookAddScreenState createState() => _BookAddScreenState();
}

class _BookAddScreenState extends State<BookAddScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedDateController =
      TextEditingController();
  final BookService _bookService = BookService();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addBook() async {
    if (_image != null &&
        _titleController.text.isNotEmpty &&
        _authorController.text.isNotEmpty &&
        _publishedDateController.text.isNotEmpty) {
      String title = _titleController.text;
      String author = _authorController.text;
      String publishedDate = _publishedDateController.text;

      // Call API to add new book
      final upload = await _bookService.createBook(
        _image!,
        title,
        author,
        publishedDate,
      );

      if (upload != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('เพิ่มหนังสือสำเร็จ'),
        ));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => BookListScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 9, 100, 70),
          content: Text('เกิดข้อผิดพลาดในการเพิ่มหนังสือ'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลหนังสือใหม่'),
        backgroundColor: Color.fromARGB(255, 100, 31, 179),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: _image != null
                    ? Image.file(_image!)
                    : Text('ยังไม่มีรูปภาพ'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('ถ่ายรูป'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('เลือกรูปจากแกลเลอรี'),
                  ),
                ],
              ),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'ชื่อหนังสือ'),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(labelText: 'ผู้เขียน'),
              ),
              TextField(
                controller: _publishedDateController,
                decoration: InputDecoration(labelText: 'วันที่เผยแพร่'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _addBook,
                icon: Icon(Icons.save),
                label: Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
