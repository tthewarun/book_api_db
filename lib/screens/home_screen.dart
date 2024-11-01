import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'book_list_screen.dart'; // Importing the book list screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Setting a default book cover image
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book App'),
        backgroundColor: Color.fromARGB(255, 7, 205, 255),
      ),
      body: Center(
        // Centering the content
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center alignment
            children: [
              CircleAvatar(
                radius: 80, // Increase size of the avatar
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : NetworkImage(
                        'https://example.com/default_book_cover.jpg', // Default book cover URL
                      ),
              ),
              SizedBox(height: 10), // Space between avatar and text
              Text(
                'ชื่อหนังสือ: ชื่อหนังสือของคุณ',
                // Change to the desired book title
                style: TextStyle(
                  fontSize: 15, // Text size
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              SizedBox(height: 10), // Space below the title
              Text(
                'ผู้เขียน: ชื่อผู้เขียน',
                // Change to the desired author name
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookListScreen(), // Navigate to the book list screen
                    ),
                  );
                },
                child: Text('แสดงรายการหนังสือ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
