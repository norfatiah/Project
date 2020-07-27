import 'package:flutter/material.dart';
import 'package:fa_cosmetic/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "https://seriouslaa.com/fa_cosmetic/php/user_register.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();



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
                   height: 20,
            ),
            Align(
                  alignment: Alignment.center,
                    child: Text(
                      "Register Here",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
             TextField(
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person),
                      )),
             TextField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      )),
             TextField(
                      controller: _phoneditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        icon: Icon(Icons.phone),
                      )),
             TextField(
                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
             SizedBox(
                    height: 10,
                  ),
             
             Padding(
                       padding: EdgeInsets.all(5),
                       child:RaisedButton(
                       child: Text("REGISTER"),
                       onPressed: _onRegister,
                       color: Colors.red[900],
                       textColor: Colors.red[100],
                       splashColor: Colors.blue,
                       elevation: 10,
                        ),
                    ),
             SizedBox(
                    height: 10,
                 ),
            
             Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
              
              Checkbox(
                    value: _isChecked,
                    onChanged: (bool value) {
                    _onChange(value);
                     },
                    ),
              GestureDetector(
                    onTap: _showEULA,
                    child: Text('I Agree to Terms  ',
                    style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
                    ),

              Text("Already register? " , style: TextStyle(fontSize: 16.0)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
       ),
    );
  }

  void _onRegister() {
   String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;
    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });


  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
  
  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("EULA"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and Slumberjer This EULA agreement governs your acquisition and use of our MY.GROCERY software (Software) directly from Slumberjer or indirectly through a Slumberjer authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the MY.GROCERY software. It provides a license to use the MY.GROCERY software and contains warranty information and liability disclaimers. If you register for a free trial of the MY.GROCERY software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the MY.GROCERY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by Slumberjer herewith regardless of whether other software is referred to or described herein. The terms also apply to any Slumberjer updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for MY.GROCERY. Slumberjer shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Slumberjer. Slumberjer reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}