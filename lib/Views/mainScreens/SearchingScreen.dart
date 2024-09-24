import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Searchingscreen extends StatelessWidget {
  const Searchingscreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Container(
            height: height * 0.3,
            child: Column(
              children: [
                LinearProgressIndicator(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
