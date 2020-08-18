import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'Welcome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future login()async{
    var response = await http.post('http://192.168.1.103/flutter-signup-with-email-verify/login.php',
    body: {
      "username":user.text,
      "password":pass.text
      }
    );
    var msg = json.decode(response.body);
    if(msg == "OKK"){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Welcome(),),);
    }else{
      showToast("Username and password invalid or contact support!", duration: 4, gravity:  Toast.CENTER);
    }
    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login UI'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Text('LOGIN',style: TextStyle(fontSize: 40,fontFamily: 'Nasalization'),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: user,
                decoration: InputDecoration(hintText: 'Username'),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(hintText: 'Password'),),
            ),

            MaterialButton(
              color: Colors.purple,
              child: Text('Login',style: TextStyle(color: Colors.white),),
              onPressed: (){
                login();
                
              },
            ),

          ],
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

}
