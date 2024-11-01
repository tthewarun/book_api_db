import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/book_service.dart'; // Ensure this service is defined
import 'book_list_screen.dart'; // Ensure this import is correct

class BookUpdateScreen extends StatefulWidget {
  final Map<String, dynamic> bookData; // Book data passed to this screen
  const BookUpdateScreen({super.key, required this.bookData});

  @override
  State<BookUpdateScreen> createState() => _BookUpdateScreenState();
}

class _BookUpdateScreenState extends State<BookUpdateScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishedDateController =
      TextEditingController();
  final BookService _bookService =
      BookService(); // Ensure this service is defined

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.bookData['title'] ?? '';
    _authorController.text = widget.bookData['author'] ?? '';
    _publishedDateController.text = widget.bookData['published_date'] != null
        ? widget.bookData['published_date'].toString().substring(0, 10)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลหนังสือ'),
        backgroundColor: const Color.fromARGB(255, 185, 143, 17),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Display selected image or current book image
              SizedBox(
                height: 150,
                child: _image != null
                    ? Image.file(_image!)
                    : Image.network(
                        _bookService.imageUrl +
                            "/" +
                            (widget.bookData['image'] ?? ''),
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                              child: Text(
                                  'ไม่สามารถโหลดรูปภาพได้')); // Fallback text if image fails to load
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('ถ่ายรูป'),
                  ),
                  SizedBox(width: 20),
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
                decoration:
                    InputDecoration(labelText: 'วันที่เผยแพร่ (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              // Button for updating book info
              ElevatedButton.icon(
                onPressed: () async {
                  if (_image != null) {
                    String title = _titleController.text;
                    String author = _authorController.text;
                    String publishedDate = _publishedDateController.text;

                    // Call API to update book information
                    final upload = await _bookService.updateBook(
                      widget.bookData['bookId'],
                      _image!,
                      title,
                      author,
                      publishedDate,
                    );

                    // Check the response from the API
                    if (upload != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('อัปเดตสำเร็จ'),
                      ));
                      // Navigate back to the book list screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => BookListScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Color.fromARGB(255, 231, 244, 54),
                        content: Text('อัปเดตล้มเหลว'),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: const Color.fromARGB(255, 54, 244, 228),
                      content: Text('กรุณาถ่ายรูปใหม่ก่อนบันทึก'),
                    ));
                  }
                },
                icon: Icon(Icons.edit),
                label: Text('แก้ไขข้อมูล'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final success =
                      await _bookService.deleteBook(widget.bookData['bookId']);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('ลบข้อมูลสำเร็จ'),
                    ));
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => BookListScreen(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color.fromARGB(255, 244, 216, 54),
                      content: Text('ลบข้อมูลล้มเหลว'),
                    ));
                  }
                },
                icon: Icon(Icons.delete),
                label: Text('ลบข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
