import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.settings_applications),
          title: Text("Setting"),
        );
      },
    );
  }
}
