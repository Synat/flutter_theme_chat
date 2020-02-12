import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  ButtonIcon({this.onTap, this.icon});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Theme.of(context).accentColor, size: 28),
      ),
    );
  }
}
