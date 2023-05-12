import 'package:flutter/material.dart';
import 'package:taxibooking/model/CouponData.dart';
import 'package:taxibooking/utils/Extensions/StringExtensions.dart';

import '../utils/Extensions/app_common.dart';

class CouponInfo extends StatefulWidget {
  static String tag = '/CouponInfo';
  final CouponData? couponData;

  CouponInfo(this.couponData);

  @override
  CouponInfoState createState() => CouponInfoState();
}

class CouponInfoState extends State<CouponInfo> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                ' ${widget.couponData!.code.validate()} ${widget.couponData!.code.validate()}',
                style: boldTextStyle(size: 14, letterSpacing: 0.5),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_sharp),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.couponData!.title.validate(), style: primaryTextStyle(size: 14)),
              SizedBox(height: 8),
              Text(widget.couponData!.description.validate(), style: secondaryTextStyle()),
              SizedBox(
                height: 16,
              )
            ],
          ),
        )
      ],
    );
  }
}
