import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';
import 'loginscreen.dart';
import 'package:toast/toast.dart';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    theme: new ThemeData(
primarySwatch: Colors.red),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
       backgroundColor: Color(0xFF444152),
       body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image.asset(
                  'assets/images/logo2.png',
                   width: 230,
                   height: 230,
             ),
             SizedBox(
                   height: 20,
            ),
          new ProgressIndicator(),
          
    ],
   ),
  ),
 ),
);

  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;



  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }


@override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
      //width: 300,
      child: CircularProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.brown,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.red,
      
    )
      )
    ));
  }
 void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('pass') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      //login with email and password
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered","123456789",ctx);
    }
  }

  void loginUser(String email, String pass, BuildContext ctx) {
   
    http.post("https://seriuoslaa.com/fa_cosmetic/php/user_login.php", body: {
      "email": email,
      "password": pass,
    })
        //.timeout(const Duration(seconds: 4))
        .then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: pass,
            phone: userdata[3],
            credit: userdata[4],
            datereg: userdata[5],
            quantity: userdata[6]);
   
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
      } else {
        Toast.show("Fail to login with stored credential. Login as unregistered account.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        loginUser("unregistered@grocery.com","123456789",ctx);
       }
    }).catchError((err) {
      print(err);
   
    });
  }
}
