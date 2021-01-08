import 'package:chat_app/components/input_message_bar.dart';
import 'package:chat_app/util/auth_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  static final String routeName = '/chats';

  final String name;

  ChatScreen(this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget> [
          Expanded(
            child: StreamBuilder(
               stream: _firestore.collection("messages").where("groupId", isEqualTo: widget.name).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }
                  return ListView.builder(
                    reverse: true,
                      padding: EdgeInsets.all(15.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot messages = snapshot.data
                            .documents[index];
                        Timestamp timestamp = messages['timeStamp'];
                        bool isMe = AuthUtils.firebaseUser.email == messages["sender"];
                        TextStyle textStyle = TextStyle(color: isMe ? Colors.white: Colors.black);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * .6,),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: isMe ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(isMe ? 20 : 0),
                                      topRight: Radius.circular(isMe ? 0 : 20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),

                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(messages["message"], style: textStyle,),
                                      Text(messages["sender"], style: textStyle,),
                                      Text(timeago.format(DateTime.tryParse(timestamp.toDate().toString())).toString(), style: textStyle,),

                                    ],
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        );
                      });
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: InputMessageBar(widget.name),
          ),
    ],
    ),
    );
  }
}
