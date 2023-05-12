import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/Extensions/StringExtensions.dart';
import '../model/ComplaintCommentModel.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';
import '../utils/Extensions/app_common.dart';

class ComplaintListScreen extends StatefulWidget {
  final int complaint;
  ComplaintListScreen({required this.complaint});

  @override
  ComplaintListScreenState createState() => ComplaintListScreenState();
}

class ComplaintListScreenState extends State<ComplaintListScreen> {
  TextEditingController messageCont = TextEditingController();
  ScrollController scrollController = ScrollController();
  var messageFocus = FocusNode();
  bool isMe = false;

  int currentPage = 1;
  int totalPage = 1;

  List<ComplaintList> complaintListData = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (currentPage < totalPage) {
          appStore.setLoading(true);
          currentPage++;
          setState(() {});

          init();
        }
      }
    });
    afterBuildCreated(() => appStore.setLoading(true));
  }

  void init() async {
    await complaintList(complaintId: widget.complaint,currentPage: currentPage).then((value) {
      appStore.setLoading(false);

      currentPage = value.pagination!.currentPage!;
      totalPage = value.pagination!.totalPages!;

      if (currentPage == 1) {
        complaintListData.clear();
      }
      complaintListData.addAll(value.data!);
      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      log(error.toString());
    });
  }

  Future<void> save() async {
    appStore.setLoading(true);
    Map req = {
      "complaint_id": widget.complaint,
      "comment": messageCont.text.trim(),
    };
    await complaintComment(request: req).then((value) {
      messageCont.clear();
      appStore.setLoading(false);
      init();
    }).catchError((error) {
      appStore.setLoading(false);
      log(error.toString());
    });
  }

  printTime(String data){
    String time = "";
    DateTime date = DateTime.parse(data).toLocal();
    if (date.day == DateTime.now().day) {
      time = DateFormat('hh:mm a').format(date);
    } else {
      time = DateFormat('dd-MM-yyyy hh:mm a').format(date);
    }
    return time;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.complainList, style: boldTextStyle(color: Colors.white)),
      ),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 76),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  reverse: true,
                  controller: scrollController,
                  itemCount: complaintListData.length,
                  itemBuilder: (_, index) {
                    ComplaintList mData = complaintListData[index];
                    return Container(
                      margin: complaintListData[index].addedBy != ADMIN
                          ? EdgeInsets.only(top: 6, bottom: 6, left: isRTL ? 0 : MediaQuery.of(context).size.width * 0.25, right: 8)
                          : EdgeInsets.only(top: 6, bottom: 6, left: 8, right: isRTL ? 0 : MediaQuery.of(context).size.width * 0.25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (complaintListData[index].addedBy == ADMIN)
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(mData.userProfileImage.validate())),border: Border.all(color:Colors.black12)),
                            ),
                          if (complaintListData[index].addedBy == ADMIN) SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: complaintListData[index].addedBy != ADMIN ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              mainAxisAlignment: complaintListData[index].addedBy != ADMIN ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(color: Colors.grey, blurRadius: 0.1, spreadRadius: 0.2), //BoxShadow
                                  ], color: complaintListData[index].addedBy != ADMIN ? primaryColor : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
                                  child: Text(
                                    mData.comment.validate(),
                                    style: primaryTextStyle(color: complaintListData[index].addedBy != ADMIN ? Colors.white : textPrimaryColorGlobal),
                                    maxLines: null,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(printTime(mData.createdAt.validate()), style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                          ),
                          if (complaintListData[index].addedBy != ADMIN) SizedBox(width: 8),
                          if (complaintListData[index].addedBy != ADMIN)
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(mData.userProfileImage.validate())),border: Border.all(color:Colors.black12)),
                            ),
                        ],
                      ),
                    );
                  }),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: Theme.of(context).cardColor,
                ),
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageCont,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: language.writeMsg,
                          hintStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        cursorColor: Colors.black,
                        focusNode: messageFocus,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        style: primaryTextStyle(),
                        // textInputAction: mIsEnterKey ? TextInputAction.send : TextInputAction.newline,
                        onSubmitted: (s) {
                          //
                        },
                        maxLines: 5,
                      ),
                    ),
                    inkWellWidget(
                      child: Icon(Icons.send, color: primaryColor, size: 25),
                      onTap: () {
                        if (messageCont.text.isEmpty) {
                          return toast(language.pleaseEnterMsg);
                        } else {
                          save();
                        }
                      },
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width,
              ),
            ),
            if (appStore.isLoading) loaderWidget(),
            if (!appStore.isLoading && complaintListData.isEmpty) emptyWidget()
          ],
        );
      }),
    );
  }
}
