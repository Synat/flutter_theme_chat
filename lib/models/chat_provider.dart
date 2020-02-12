import 'package:flutter_theme_chat/widgets/chat_message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:states_rebuilder/states_rebuilder.dart';

class ChatProvider extends StatesRebuilder {
  IO.Socket socket;
  List<ChatMessage> messages = [];

  void onAddNewMessage(ChatMessage chatMessage) {
    this.messages.add(chatMessage);
    rebuildStates();
  }

  void initSocket() async {
    socket = IO.io('http://192.168.0.108:3000', <String, dynamic>{
      'transports': ["websocket"],
      "autoConnect": false
    });
    socket.connect();

    socket.on('connect', (_) {
      print('connect');
    });
    socket.on('event', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  void dispose() {
    socket.disconnect();
    //messages.clear();
    socket.destroy();
    socket.clearListeners();
  }
}
