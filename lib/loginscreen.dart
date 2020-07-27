import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fa_cosmetic/registerscreen.dart';
import 'package:fa_cosmetic/user.dart';
import 'package:fa_cosmetic/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/services.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   
    TextEditingController _emailEditingController = new TextEditingController();
    TextEditingController _passEditingController = new TextEditingController();
    String urlLogin = "https://seriouslaa.com/fa_cosmetic/user_login.php";


@override
Widget build(BuildContext context) {
  return new Scaffold(
       backgroundColor: Color(0xFFE0F2F1),
       body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image.asset(
                  'assets/images/logo2.png',
                   width: 200,
                   height: 230,
             ),
             SizedBox(
                   height: 50,
            ),
            
             TextField(
                   controller: _emailEditingController,
                   keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(
                   contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                   labelText: 'Email',
                   icon: Icon(Icons.email),
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(32.0))
                   )),
             SizedBox(
                    height: 10,
                  ),     
             TextField(
                   controller: _passEditingController,
                   decoration: InputDecoration(
                   contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                   labelText: 'Password',
                   icon: Icon(Icons.lock),
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(32.0))
                    ),
                   obscureText: true,
                  ),
             SizedBox(
                   height: 20,
                  ),
            
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Padding(
                       padding: EdgeInsets.all(5),
                       child:RaisedButton(
                       child: Text("REGISTER"),
                       onPressed:this._registerUser,
                       color: Colors.red,
                       textColor: Colors.yellow,
                       splashColor: Colors.grey,
                       elevation: 10,
                        ),
                    ),
                    
                   Padding(
                       padding: EdgeInsets.all(5),
                       child:RaisedButton(
                       child: Text("LOGIN"),
                       onPressed:this._userLogin,
                       color: Colors.red,
                       textColor: Colors.yellow,
                       splashColor: Colors.grey,
                       elevation: 10,
                        ),
                     ),
                    ],
                  ),
                  
                  CheckboxListTile(
                      title: Text("Remember Me"),
                      value: rememberMe,
                      onChanged: _onRememberMeChanged,
                      controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    ),         
          
         
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                        onTap: _forgotPassword,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
            ],
          
          ),
          ],
        ),
       ), 
      
    
    
  );
  }

  void _userLogin() async{
   try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email = _emailEditingController.text;
      String _password = _passEditingController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              name: userdata[1],
              email: _email,
              password: _password,
              phone: userdata[3],
              credit: userdata[4],
              datereg: userdata[5],
              quantity: userdata[6]);
         pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
       pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}