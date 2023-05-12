import 'package:flutter/material.dart';
import '../utils/Colors.dart';
import '../utils/Extensions/app_common.dart';
import '../../components/CreateTabScreen.dart';
import '../../utils/Constants.dart';
import '../main.dart';
import '../utils/Common.dart';

class MyRidesScreen extends StatefulWidget {
  @override
  MyRidesScreenState createState() => MyRidesScreenState();
}

class MyRidesScreenState extends State<MyRidesScreen> {
  int currentPage = 1;
  int totalPage = 1;
  List<String> riderStatus = [COMPLETED, CANCELED];

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
    return DefaultTabController(
      length: riderStatus.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(language.myRides, style: boldTextStyle(color: Colors.white)),
        ),
        body: Column(children: [
          Container(
            height: 40,
            margin: EdgeInsets.only(right: 16, left: 16, top: 16),
            decoration: BoxDecoration(
              color: dividerColor,
              borderRadius: radius(),
            ),
            child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: radius(),
                  color: primaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: primaryColor,
                labelStyle: boldTextStyle(color: Colors.white, size: 14),
                tabs: riderStatus.map((e) {
                  return Tab(
                    child: Text(changeStatusText(e)),
                  );
                }).toList()),
          ),
          Expanded(
            child: TabBarView(
              children: riderStatus.map((e) {
                return CreateTabScreen(status: e);
              }).toList(),
            ),
          ),
        ]),
      ),
    );
  }
}
