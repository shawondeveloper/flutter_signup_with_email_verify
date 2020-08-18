import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'Login.dart';
import 'crediantial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter signup with email verify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  bool verifyButton = false;

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  String verifylink;
  Future signUp() async {
    if (user.text.isNotEmpty) {
      var response = await http.post(
          'http://192.168.1.103/flutter-signup-with-email-verify/signup.php',
          body: {"username": user.text, "password": pass.text});
      var link = json.decode(response.body);
      
      verifylink = link;
      
      sendMail();

      setState(() {
        verifyButton = true;
      });
      
      //print(verifylink);

      showToast(
          "Thanks for registering with Flutter localhost. Please click this link to complete this registation",
          duration: 4,
          gravity: Toast.CENTER);
    } else {
      showToast("Enter Username and password first",
          duration: 3, gravity: Toast.TOP);
    }
  }

  Future verify(String verifylink) async {
    var response = await http.post(verifylink);
    var link = json.decode(response.body);
    print(link);
    showToast("Thanks for verify! you can log in now",
        duration: 5, gravity: Toast.CENTER);
  }

  //mail
  sendMail() async {
    String username = EMAIL;
    String password = PASS;

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('abc@gmail.com') //recipent email
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      //..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject =
          'SignUp verification link from shawondeveloper : ${DateTime.now()}' //subject of the email
      //..text =
      //'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h3>Thanks for registering with localhost. Please click this link to complete this registation</h3>\n<p> <a href='$verifylink'>Click me to Verify</a></p>"; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }

  String menuValue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter signup with email verify'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (result){
              setState(() {
                menuValue = result;
                print(menuValue);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context){
            return [
              PopupMenuItem(
                value: 'Change',
                child: Text('Change Password'),
              ),
              PopupMenuItem(
                value: 'Setting',
                child: Text('Setting'),
              ),
            ];
          }),
          
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: Text('SignUp',style: TextStyle(fontSize: 40,fontFamily: 'Nasalization'),),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: user,
                decoration: InputDecoration(hintText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  color: Colors.purple,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      signUp();
                      user.text = "";
                      pass.text = "";
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                MaterialButton(
                  color: Colors.green,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            verifyButton
                ? MaterialButton(
                    color: Colors.amber[300],
                    child: Text('verify Mail'),
                    onPressed: () {
                      verify(verifylink).then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        ),
                      );
                      setState(() {
                        verifyButton = false;
                      });
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
