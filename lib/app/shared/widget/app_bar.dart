import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final String? tag;
  final String title;
  final Widget? leading;
  final Widget? trailing;

  CustomAppBar({
    this.tag,
    required this.title,
    this.leading,
    this.trailing,
  }) : super(
          child: Container(),
          preferredSize: Size.fromHeight(80.0),
        );

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.appBar,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  offset: Offset(1, 0),
                  blurRadius: 1.0,
                ),
              ],
            ),
            padding: const EdgeInsets.only(
              top: 12.0,
              bottom: 16.0,
              left: 64.0,
              right: 64.0,
            ),
            child: TooltipText(
              tag: tag,
              text: title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Material(
            color: Theme.of(context).colorScheme.transparent,
            type: MaterialType.transparency,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(
                top: 12.0,
                bottom: 8.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  leading ?? Container(width: 16.0, height: 16.0),
                  trailing ?? Container(width: 16.0, height: 16.0),
                ],
              ),
            ),
          ),
        ],
      );
}
