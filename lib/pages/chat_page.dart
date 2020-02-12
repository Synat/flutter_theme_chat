import 'package:flutter/material.dart';
import 'package:flutter_theme_chat/models/chat_model.dart';
import 'package:flutter_theme_chat/pages/conversation_page.dart';
import 'package:flutter_theme_chat/widgets/story_list.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  var formatter = DateFormat('dd MMM');
  return formatter.format(dateTime);
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        StoryList(),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 0),
            itemCount: chats.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / chats.length) * index, 1.0, curve: Curves.fastOutSlowIn),
              ));
              return FadeTransition(
                opacity: animation,
                child: Dismissible(
                  key: ValueKey(chats[index].name),
                  confirmDismiss: (value) async {
                    return false;
                  },
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 16),
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 16),
                        Icon(Icons.archive, color: Colors.white),
                      ],
                    ),
                  ),
                  //onDismissed: (direction) {},
                  child: ListTile(
                    leading: CircleAvatar(backgroundImage: NetworkImage(chats[index].image)),
                    title: Text("${chats[index].name}"),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => ConversationPage(chats[index]),
                        ),
                      );
                    },
                    subtitle: Row(
                      children: <Widget>[
                        Text(
                          "${chats[index].lastMessage}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(Icons.fiber_manual_record, size: 8),
                        ),
                        Text(
                          "${formatDate(DateTime.now().toLocal())}",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    //trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
