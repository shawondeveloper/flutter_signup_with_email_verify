import 'package:flutter/material.dart';
import 'package:flutter_signup_with_email_verify/main.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(icon: Icon(Icons.power_settings_new),
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(),),);
      },)],),
      body: Container(child: Center(child: Text('Welcome'),),),
    );
  }
}