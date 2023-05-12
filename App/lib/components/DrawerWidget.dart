import 'package:flutter/material.dart';
import 'package:taxibooking/utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Extensions/app_common.dart';

class DrawerWidget extends StatefulWidget {
  final String title;
  final String iconData;
  final Function() onTap;

  DrawerWidget({required this.title, required this.iconData, required this.onTap});

  @override
  DrawerWidgetState createState() => DrawerWidgetState();
}

class DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return inkWellWidget(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(top: 8,bottom: 8),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(border: Border.all(color: primaryColor.withOpacity(0.6)),color: primaryColor.withOpacity(0.2),borderRadius: radius(10)),
                  child: Image.asset(widget.iconData, height: 30, width: 30),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(widget.title, style: primaryTextStyle()),
                ),
                Icon(Icons.arrow_forward_ios, size: 16)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
