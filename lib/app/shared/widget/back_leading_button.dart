import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class BackLeadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: Icon(
        Icons.arrow_back,
        color: UiKit.palette.icon,
      ),
    );
  }
}
