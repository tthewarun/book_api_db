import 'package:flutter/material.dart';
import 'book_add_screen.dart';
import 'book_view_screen.dart';
import '../services/book_service.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<dynamic>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = BookService().fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการข้อมูลหนังสือ'),
        backgroundColor: Color.fromARGB(255, 255, 7, 28),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่พบรายการข้อมูลหนังสือ'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data![index]['title']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookViewScreen(
                            bookData: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookAddScreen()),
          );
        },
        tooltip: 'เพิ่มข้อมูลหนังสือใหม่',
        child: const Icon(Icons.add),
      ),
    );
  }
}
