import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupScreen extends StatefulWidget {
  static final String routeName = '/groups';
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),

      body: StreamBuilder(
        stream: _firestore.collection("groups").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data == null)
            return CircularProgressIndicator();
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot groups = snapshot.data.documents[index];
                return Card (
                  elevation: 3,
                  child: ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, ChatScreen.routeName, arguments: groups['name']);
                    },
                    title: Text(groups["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(groups["tagLine"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,),
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: CachedNetworkImage(
                          width: 400,
                          height: 400,
                          fit: BoxFit.cover,
                          imageUrl: groups["imageURL"],
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.group),
                        ),
                      ),
                      backgroundImage: NetworkImage("https://media.glamour.com/photos/5de651f455321a0008bced61/16:9/w_2560%2Cc_limit/GettyImages-143479441.jpg"),
                    ),
                  ),
                  );
              });
        },
      )
    );
  }
}
