import 'package:flutter/material.dart';
import 'package:weather_app/widget/constant.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
           const Center(
            child: CircularProgressIndicator(
              color: Colors.blueGrey,
              backgroundColor: Colors.orange,
            ),
          ),
          Text("Weather Update",style: TextStyle(color: lightColor, fontSize: 35,fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
