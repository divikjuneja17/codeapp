import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/group_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          initialRoute: LoginScreen.routeName,
          onGenerateRoute: (RouteSettings settings) {
            var routes = <String, WidgetBuilder>{
              LoginScreen.routeName: (context) => LoginScreen(),  //declaring routes
              AuthScreen.routeName: (context) => AuthScreen(settings.arguments),
              GroupScreen.routeName: (context) => GroupScreen(),
              ChatScreen.routeName: (context) => ChatScreen(settings.arguments),
            };
            WidgetBuilder builder = routes[settings.name];
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },

          // routes: {  //routes without parameters.
          //    LoginScreen.routeName: (context) => LoginScreen()
          // },
          theme: ThemeData(
            primaryColor: Colors.indigo,
            primaryColorDark: Colors.indigo[700],
            primaryColorLight: Colors.indigo[100],
            accentColor: Colors.lightGreenAccent[100],
          ),
        );
  }
}
