import 'package:chat_app/util/alert_utils.dart';
import 'package:chat_app/util/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'group_screen.dart';


class AuthScreen extends StatefulWidget {
  static final String routeName = '/auth';
  final bool isLogin;

  AuthScreen(this.isLogin);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  num count;

  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Builder(
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(widget.isLogin ? "Login" : "Register"),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Flexible(
                            child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Hero(
                                    tag: 'logo',
                                    child: Image(
                                        image: AssetImage("images/logo.png")))),
                            SizedBox(width: 20),
                            Expanded(
                              child: ScaleAnimatedTextKit(
                                  repeatForever: true,
                                  text: widget
                                          .isLogin //true and false values in bool isLogin variable shows diff outputs.
                                      ? ["Login", "Sign-in"] //true
                                      : ["Register", "Sign-up"], //false
                                  textStyle: TextStyle(
                                      fontSize: 40.0, color: Colors.black)),
                            )
                          ],
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Email',
                              icon: Icon(Icons.alternate_email)),
                        ),
                        TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true, //hides the password
                          decoration: InputDecoration(
                            hintText: 'Password',
                            icon: Icon(FontAwesomeIcons.userLock),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlatButton(
                                  color: Theme.of(context).primaryColorDark,
                                  splashColor: Theme.of(context).accentColor,
                                  onPressed: () async {
                                    final progress = ProgressHUD.of(context);
                                    progress.showWithText(widget.isLogin
                                        ? "Logging in"
                                        : "Registering");
                                    if (widget.isLogin) {
                                       await loginUser(context);//returned bool value is stored in variable.
                                       count=1;
                                    }
                                     else {
                                       await registerUser(context);
                                       count=2;
                                        }
                                    progress.dismiss();
                                     AuthUtils.firebaseUser = _auth.currentUser;
                                    if(count==1) {  //if it is true than show GroupScreen.
                                      Navigator.pushNamed(context, GroupScreen.routeName);
                                    }
                                    else{
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    widget.isLogin ? "LOGIN" : "REGISTER",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              //isLogin value is been used if it is true, show LOGIN else show REGISTER on button.
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Future<bool> loginUser(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      AlertUtils.getErrorAlert(context, e.code).show();
      return false;
    }
  }

  Future<bool> registerUser(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e) {
      print(e);
      AlertUtils.getErrorAlert(context, e.code).show();
      return false;
    }
  }
}
