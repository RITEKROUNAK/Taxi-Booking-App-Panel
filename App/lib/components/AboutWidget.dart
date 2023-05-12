import 'package:flutter/material.dart';
import '../utils/Extensions/StringExtensions.dart';
import '../main.dart';
import '../model/UserDetailModel.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Extensions/app_common.dart';

class AboutWidget extends StatefulWidget {
  final UserData? userData;

  AboutWidget({this.userData});

  @override
  AboutWidgetState createState() => AboutWidgetState();
}

class AboutWidgetState extends State<AboutWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.userData != null
        ? Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.driverInformation, style: boldTextStyle()),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                        child: Icon(Icons.close, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: commonCachedNetworkImage(widget.userData!.profileImage.validate(), height: 45, width: 45, fit: BoxFit.cover),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(widget.userData!.firstName.validate(), style: boldTextStyle(size: 14)),
                        SizedBox(height: 4),
                        // if (widget.userData!.rating != null)
                        //   RatingBar.builder(
                        //     direction: Axis.horizontal,
                        //     glow: false,
                        //     allowHalfRating: true,
                        //     ignoreGestures: true,
                        //     wrapAlignment: WrapAlignment.spaceBetween,
                        //     itemCount: 5,
                        //     itemSize: 10,
                        //     initialRating: double.parse(widget.userData!.rating.toString()),
                        //     itemPadding: EdgeInsets.symmetric(horizontal: 0),
                        //     itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                        //     onRatingUpdate: (rating) {
                        //       //
                        //     },
                        //   ),
                        // SizedBox(height: 4),
                        Text(widget.userData!.email.validate(), style: secondaryTextStyle()),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 1, height: 30),
                // Row(
                //   children: [
                //     Container(
                //       padding: EdgeInsets.all(6),
                //       decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.green)),
                //       child: Icon(Ionicons.call_outline,size: 16),
                //     ),
                //     SizedBox(width: 12),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(language.phoneNumber, style: primaryTextStyle(size: 14)),
                //           SizedBox(height: 5),
                //           Text(widget.userData!.contactNumber.validate(), style: boldTextStyle(size: 14)),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // Divider(thickness: 1,height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.carModel, style: primaryTextStyle(size: 14)),
                    Text(widget.userData!.userDetail!.carModel!.validate(), style: secondaryTextStyle()),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language.lblCarNumberPlate, style: primaryTextStyle(size: 14)),
                    Text(widget.userData!.userDetail!.carPlateNumber!.validate(), style: secondaryTextStyle()),
                  ],
                ),
              ],
            ),
          )
        : Visibility(
            visible: widget.userData != null && appStore.isLoading,
            child: loaderWidget(),
          );
  }
}
