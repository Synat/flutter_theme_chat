import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(height: 0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("feed"),
          onTap: () {},
        );
      },
    );
  }
}
