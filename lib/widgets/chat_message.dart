import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String user;
  final AnimationController animationController;
  final bool isMe;

  ChatMessage({this.text, this.animationController, this.isMe = true, this.user});
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut), //new
        axisAlignment: 0.0,
        axis: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(user),
                ),
              Flexible(
                child: Container(
                  //alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
              ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage("https://picsum.photos/300"),
                ),
            ],
          ),
        ) //new
        );
  }
}
