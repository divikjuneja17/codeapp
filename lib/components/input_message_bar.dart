import 'package:chat_app/util/auth_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InputMessageBar extends StatefulWidget {
  final String groupId;

  InputMessageBar(this.groupId);

  @override
  _InputMessageBarState createState() => _InputMessageBarState();
}

class _InputMessageBarState extends State<InputMessageBar> {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController controller;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget> [
        Expanded(
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value){
                message = value.trim();
              },
              onSubmitted: (value){
                _firestore.collection("messages").add(
                    {
                      'groupId' : widget.groupId,
                      'message' : message,
                      'sender' : AuthUtils.firebaseUser.email,
                      'timeStamp' : Timestamp.now(),
                    }
                );
                controller.clear();
              },
            )),
        SizedBox(width: 20),
        OutlineButton(
          highlightedBorderColor: Theme.of(context).primaryColorLight,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            _firestore.collection("messages").add(
              {
               'groupId' : widget.groupId,
                'message' : message,
                'sender' : AuthUtils.firebaseUser.email,
                'timeStamp' : Timestamp.now(),
              }
            );
            controller.clear();
          },
          child: Text("Send"),)
      ],
    );
  }
}
