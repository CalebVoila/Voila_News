
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _blogData;

  @override
  void initState() {
    super.initState();
    _fetchBlogPosts();
  }

  Future<void> _fetchBlogPosts() async {
    final response = await http.get(Uri.parse('https://packetprep.com/api/blog/general'));
    if (response.statusCode == 200) {
      setState(() {
        _blogData = jsonDecode(response.body);
      });
    } else {
      // Handle error gracefully (e.g., show error message)
      print('Failed to fetch blog posts. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voila News'),
      ),
      body: _buildBodyContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Popular',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Featured',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_blogData == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      itemCount: _blogData!['data'].length,
      itemBuilder: (context, index) {
        final post = _blogData!['data'][index];
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post['image'] != null)
                Image.network(
                  post['image'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Text('Failed to load image'),
                ),
              SizedBox(height: 16.0),
              Text(
                post['title'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              html(
                data: post['content'],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
