import 'package:flutter/material.dart';
import 'package:flutter_theme_chat/models/chat_provider.dart';
import 'package:flutter_theme_chat/pages/chat_page.dart';
import 'package:flutter_theme_chat/pages/feed_page.dart';
import 'package:flutter_theme_chat/pages/setting_page.dart';
import 'package:flutter_theme_chat/widgets/navigation_bar_state.dart';
import 'package:flutter_theme_chat/widgets/theme_model.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

final pages = [
  ChatPage(),
  FeedPage(),
  SettingPage(),
];
void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject(() => ThemeModel()),
        Inject(() => NavigationBarState()),
        Inject(() => ChatProvider()),
      ],
      builder: (context) {
        final theme = Injector.get<ThemeModel>();
        return StateBuilder(
          models: [theme],
          builder: (context, _) => MaterialApp(
            title: 'Theme chat',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              brightness: theme.brightness,
              iconTheme: IconThemeData(color: Colors.red),
            ),
            home: MyHomePage(),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeModel themeModel = Injector.get(context: context);
    final NavigationBarState navigationBarState = Injector.get(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Theme chat"),
        centerTitle: false,
      ),
      body: PageView.builder(
        itemCount: 4,
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navigationBarState.index,
        onTap: (index) {
          navigationBarState.onChangeIndex(index);
          pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text("Chat"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            title: Text("Feed"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Setting"),
          ),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   notchMargin: 8,
      //   shape: CircularNotchedRectangle(),
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(onPressed: () {}, icon: Icon(Icons.card_travel)),
      //       IconButton(onPressed: () {}, icon: Icon(Icons.directions_walk)),
      //       Spacer(),
      //       IconButton(onPressed: () {}, icon: Icon(Icons.local_play)),
      //       IconButton(onPressed: () {}, icon: Icon(Icons.wb_sunny)),
      //     ],
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          themeModel.changeBrightness();
        },
        icon: Icon(Icons.refresh),
        label: Text("Change theme"),
      ),
    );
  }
}
