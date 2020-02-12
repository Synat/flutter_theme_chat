import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

import 'button_icon.dart';

class EmojiPickerDialog extends StatefulWidget {
  final Function(Emoji) onEmojiSelected;
  EmojiPickerDialog({this.onEmojiSelected});
  @override
  _EmojiPickerDialogState createState() => _EmojiPickerDialogState();
}

class _EmojiPickerDialogState extends State<EmojiPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Material(
          color: Colors.white,
          child: ButtonIcon(
            icon: Icons.check,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        EmojiPicker(
          rows: 7,
          selectedCategory: Category.SMILEYS,
          columns: 7,
          recommendKeywords: ["smile", "chicken"],
          numRecommended: 10,
          onEmojiSelected: (Emoji emoji, category) {
            widget.onEmojiSelected(emoji);
          },
        ),
      ],
    );
  }
}
