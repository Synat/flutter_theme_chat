import 'dart:async';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_theme_chat/models/chat_provider.dart';
import 'package:flutter_theme_chat/models/room_model.dart';
import 'package:flutter_theme_chat/widgets/button_icon.dart';
import 'package:flutter_theme_chat/widgets/chat_message.dart';
import 'package:flutter_theme_chat/widgets/theme_model.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'chat_page.dart';

class ConversationPage extends StatefulWidget {
  final Room room;
  ConversationPage(this.room);
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> with TickerProviderStateMixin {
  TextEditingController textEditingController;
  ScrollController scrollController;
  ChatProvider chatProvider;
  ThemeModel themeModel;
  FocusNode focusNode;
  bool isShowingEmoji = false;
  num client = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  //method
  void onSendMessage(String message) {
    if (textEditingController.text.isEmpty) return;
    var animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var chatMessage = ChatMessage(
      text: message,
      animationController: animationController,
      sendDate: DateTime.now(),
      sender: themeModel.sender,
      user: "https://picsum.photos/210",
    );
    sendMessageToSocket();
    chatMessage.animationController.forward();
    textEditingController.clear();
    //FocusScope.of(context).unfocus();
    setState(() {
      isShowingEmoji = false;
    });
  }

  void sendMessageToSocket() {
    chatProvider.socket.emit("message", [
      {
        "message": textEditingController.text,
        "sender": themeModel.sender,
        "receiver": themeModel.receiver,
      },
    ]);
  }

  void initSocketConfiguration() {
    chatProvider.socket.on('message-${themeModel.sender}-${themeModel.receiver}', (data) async {
      print("Message receive: " + data.toString());
      var animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      var chatMessage = ChatMessage(
        text: data['message'],
        animationController: animationController,
        sendDate: DateTime.now(),
        sender: data['sender'],
        user: "https://picsum.photos/240",
      );
      chatMessage.animationController.forward();
      chatProvider.onAddNewMessage(chatMessage);
      await Future.delayed(Duration(milliseconds: 200));
      animateToBottom();
    });

    chatProvider.socket.on("clients", (data) {
      print("Clients: ${data['clients']}");
      setState(() {
        client = data['clients'];
      });
    });
  }

  void animateToBottom() async {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      curve: Curves.linear,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  void initState() {
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      chatProvider.initSocket();
      initSocketConfiguration();
      animateToBottom();
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    // for (ChatMessage chatMessage in chatProvider.messages) {
    //   chatMessage.animationController.dispose();
    // }
    chatProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    chatProvider = Injector.get(context: context);
    themeModel = Injector.get(context: context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(backgroundImage: NetworkImage(widget.room.image)),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.room.name),
                Text("Active now ($client people)", style: Theme.of(context).textTheme.caption),
              ],
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        ],
      ),
      body: SafeArea(
        top: false,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              isShowingEmoji = false;
            });
          },
          child: Column(
            children: <Widget>[
              buildConversationList(),
              Divider(height: 0),
              buildMessageComposer(),
              if (MediaQuery.of(context).viewInsets.bottom < 24 && isShowingEmoji)
                EmojiPicker(
                  rows: 4,
                  selectedCategory: Category.SMILEYS,
                  columns: 7,
                  recommendKeywords: ["smile", "chicken"],
                  numRecommended: 10,
                  onEmojiSelected: (Emoji emoji, category) {
                    textEditingController.text = textEditingController.text + emoji.emoji;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConversationList() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 12),
        itemCount: chatProvider.messages.length,
        controller: scrollController,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              if (index == 0) Text(formatDateTime(chatProvider.messages[index].sendDate)),
              if (index != 0 && chatProvider.messages[index - 1].sendDate.minute != chatProvider.messages[index].sendDate.minute)
                Text(formatDateTime(chatProvider.messages[index].sendDate)),
              chatProvider.messages[index],
            ],
          );
        },
      ),
    );
  }

  Widget buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: <Widget>[
          ButtonIcon(
            icon: Icons.photo,
            onTap: () {},
          ),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              onTap: () {
                isShowingEmoji = false;
                animateToBottom();
              },
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                hintText: "Message",
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
            ),
          ),
          SizedBox(width: 12),
          ButtonIcon(
            icon: Icons.tag_faces,
            onTap: () async {
              FocusScope.of(context).unfocus();
              animateToBottom();
              setState(() {
                isShowingEmoji = !isShowingEmoji;
              });
            },
          ),
          SizedBox(width: 12),
          ButtonIcon(
            icon: Icons.send,
            onTap: () => onSendMessage(textEditingController.text),
          ),
        ],
      ),
    );
  }
}
