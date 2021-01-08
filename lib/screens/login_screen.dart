import 'package:chat_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginScreen extends StatefulWidget {
  static final String routeName = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GroupChat App"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, //crossAxisAlignment is for horizontal axis in column.
          children: <Widget> [

            Hero(  /*hero refers to the widget that flies between screens.Animate the transformation of a hero’s shape from circular to rectangular while flying it from one screen to another.
              The Hero widget in Flutter implements a style of animation commonly known as shared element transitions or shared element animations. */
              tag: 'logo',
              child: Image(
                  height: 250,
                    image: AssetImage('images/logo.png')),
            ),
        Row(
           mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(width: 20.0),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "Chat with your",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
            SizedBox(width: 20.0),

      Expanded(
          child: RotateAnimatedTextKit(
                    repeatForever: true,
                      onTap: () {
                        print("Tap Event");
                      },
                      text: ["FRIENDS", "FAMILY"],
                      textStyle: TextStyle(fontSize: 40.0, fontFamily: "Horizon"),
                      textAlign: TextAlign.start
                  ),
        ),
          ],
        ),
            FlatButton(
                color: Theme.of(context).primaryColorDark,
                splashColor: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, AuthScreen.routeName, arguments: true);
                },
                child: Text("LOGIN", style: TextStyle(color: Colors.white),)),

            OutlineButton(
                child: Text("REGISTER"),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, AuthScreen.routeName, arguments: false);
                },
                splashColor: Theme.of(context).accentColor,
                highlightedBorderColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColorDark,
                  width: 1.5
                ),
            )
          ],
        ),
      ),
    );
  }
}
