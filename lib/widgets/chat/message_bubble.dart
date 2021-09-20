import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.isMe, this.username, this.imageUrl);
  final String message;
  final String isMe;
  final String username;
  final String imageUrl;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  bool findIfItsMe() {
    if (isMe == uid) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          findIfItsMe() ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: findIfItsMe()
                  ? Colors.grey[300]
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !findIfItsMe() ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: findIfItsMe()
                      ? Radius.circular(0)
                      : Radius.circular(12))),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: findIfItsMe()
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: findIfItsMe()
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1!.color),
              ),
              Text(
                message,
                style: TextStyle(
                    color: findIfItsMe()
                        ? Colors.black
                        : Theme.of(context).accentTextTheme.headline1!.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
