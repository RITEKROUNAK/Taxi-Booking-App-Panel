import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/Common.dart';
import '../utils/Extensions/StringExtensions.dart';
import '../utils/Extensions/app_common.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../model/ContactNumberListModel.dart';
import '../../network/RestApis.dart';

class AlertScreen extends StatefulWidget {
  final int? rideId;
  final int? regionId;

  AlertScreen({this.rideId, this.regionId});

  @override
  AlertScreenState createState() => AlertScreenState();
}

class AlertScreenState extends State<AlertScreen> {
  List<ContactModel> sosListData = [];
  LatLng? sourceLocation;

  bool sendNotification = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getCurrentUserLocation();
    appStore.setLoading(true);
    await getSosList(regionId: widget.regionId).then((value) {
      sosListData.addAll(value.data!);
      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error.toString());
    });
  }

  Future<void> adminSosNotify() async {
    sendNotification = false;
    appStore.setLoading(true);
    Map req = {
      "ride_request_id": widget.rideId,
      "latitude": sourceLocation!.latitude,
      "longitude": sourceLocation!.longitude,
    };
    await adminNotify(request: req).then((value) {
      appStore.setLoading(false);
      sendNotification = true;
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);

      log(error.toString());
    });
  }

  Future<void> getCurrentUserLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    sourceLocation = LatLng(geoPosition.latitude, geoPosition.longitude);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Observer(builder: (context) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: !appStore.isLoading && sosListData.length != 0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.warning_amber, color: Colors.red, size: 50),
                        SizedBox(height: 8),
                        Text(language.useInCaseOfEmergency, style: boldTextStyle(color: Colors.red)),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.notifyAdmin, style: boldTextStyle()),
                                if (sendNotification) SizedBox(height: 4),
                                if (sendNotification) Text(language.notifiedSuccessfully, style: secondaryTextStyle(color: Colors.green)),
                              ],
                            ),
                            inkWellWidget(
                              onTap: () {
                                adminSosNotify();
                              },
                              child: Icon(Icons.notification_add_outlined),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: sosListData.length,
                              itemBuilder: (_, index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(sosListData[index].title.validate(), style: boldTextStyle()),
                                          SizedBox(height: 4),
                                          Text(sosListData[index].contactNumber.validate(), style: primaryTextStyle()),
                                        ],
                                      ),
                                      inkWellWidget(
                                        onTap: () {
                                          launchUrl(Uri.parse('tel:${sosListData[index].contactNumber}'), mode: LaunchMode.externalApplication);
                                        },
                                        child: Icon(Icons.call),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: appStore.isLoading,
                child: IntrinsicHeight(
                  child: loaderWidget(),
                ),
              )
            ],
          );
        }),
      ],
    );
  }
}
