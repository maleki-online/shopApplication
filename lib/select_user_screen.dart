import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Image.asset('assets/images/1.jpg', width: 200, height: 200),
            Padding(padding: EdgeInsets.all(25)),
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage("assets/images/4.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "Amir Hossein Ghaemi Zadeh",
                style: TextStyle(fontSize: 17, color: Colors.purple[600]),
              ),
            ),
            Container(
              width: 330,
              height: 110,
              //
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.purple[100], // Uniform radius
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      print("Setting");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 6,
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/Setting.png',
                            width: 70,
                            height: 68,
                          ),
                          Text("Setting"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Fluttertoast.showToast(
                      //   msg: "This is Center Short Toast",
                      //   toastLength: Toast.LENGTH_SHORT,
                      //   gravity: ToastGravity.BOTTOM,
                      //   timeInSecForIosWeb: 1,
                      //   backgroundColor: Colors.red,
                      //   textColor: Colors.white,
                      //   fontSize: 16.0,
                      // );
                      print("Phone");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/phone.webp',
                            width: 70,
                            height: 60,
                          ),
                          const SizedBox(height: 5),
                          Text("Phone"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Setting");
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 17,
                        vertical: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/message_2.webp',
                            width: 70,
                            height: 60,
                          ),
                          const SizedBox(height: 5),
                          Text("Message"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
