import 'package:flutter/material.dart';

class HelloRectangle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.pink,
        height: 400.0,
        width: 400.0,
        child: Center(
          child: Text(
            'Hello',
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar(
          title: Text('Hello Rectangle'),
        ),
        body: HelloRectangle()
      )
    )
  );
}