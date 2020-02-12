import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'theme_model.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String user;
  final AnimationController animationController;
  final DateTime sendDate;
  final String sender;

  ChatMessage({this.text, this.animationController, this.sender, this.user, this.sendDate});
  @override
  Widget build(BuildContext context) {
    ThemeModel themeModel = Injector.get(context: context);
    bool isMe = themeModel.sender == sender;
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
