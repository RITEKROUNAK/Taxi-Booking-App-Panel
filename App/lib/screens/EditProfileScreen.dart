import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../network/RestApis.dart';
import '../utils/Colors.dart';
import '../utils/Extensions/AppButtonWidget.dart';
import '../utils/Extensions/StringExtensions.dart';
import '../utils/Extensions/app_common.dart';

import '../../main.dart';
import '../../utils/Common.dart';
import '../../utils/Constants.dart';
import '../../utils/Extensions/app_textfield.dart';
import 'RiderDashBoardScreen.dart';

class EditProfileScreen extends StatefulWidget {
  final bool? isGoogle;

  EditProfileScreen({this.isGoogle = false});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? imageProfile;
  String countryCode = defaultCountryCode;

  List<String> gender = [MALE, FEMALE, OTHER];
  String selectGender = MALE;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode firstnameFocus = FocusNode();
  FocusNode lastnameFocus = FocusNode();
  FocusNode contactFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(true);
    getUserDetail(userId: sharedPref.getInt(USER_ID)).then((value) {
      emailController.text = value.data!.email.validate();
      usernameController.text = value.data!.username.validate();
      firstNameController.text = value.data!.firstName.validate();
      lastNameController.text = value.data!.lastName.validate();
      selectGender = value.data!.gender.isEmptyOrNull ? MALE : value.data!.gender.validate();
      addressController.text = value.data!.address.validate();
      contactNumberController.text = value.data!.contactNumber.validate();

      appStore.setUserEmail(value.data!.email.validate());
      appStore.setUserName(value.data!.username.validate());
      appStore.setFirstName(value.data!.firstName.validate());

      sharedPref.setString(USER_EMAIL, value.data!.email.validate());
      sharedPref.setString(FIRST_NAME, value.data!.firstName.validate());
      sharedPref.setString(LAST_NAME, value.data!.lastName.validate());

      appStore.setLoading(false);
      setState(() {});
    }).catchError((error) {
      log(error.toString());
      appStore.setLoading(false);
    });
  }

  Widget profileImage() {
    if (imageProfile != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.file(File(imageProfile!.path), height: 100, width: 100, fit: BoxFit.cover, alignment: Alignment.center),
        ),
      );
    } else {
      if (sharedPref.getString(USER_PROFILE_PHOTO)!.isNotEmpty) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: commonCachedNetworkImage(sharedPref.getString(USER_PROFILE_PHOTO).validate(), fit: BoxFit.cover, height: 100, width: 100),
          ),
        );
      } else {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(left: 4, bottom: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: commonCachedNetworkImage(sharedPref.getString(USER_PROFILE_PHOTO).validate(), height: 90, width: 90),
            ),
          ),
        );
      }
    }
  }

  Future<void> getImage() async {
    imageProfile = null;
    imageProfile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {});
  }

  Future<void> saveProfile() async {
    hideKeyboard(context);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      appStore.setLoading(true);
      await updateProfile(
        file: imageProfile != null ? File(imageProfile!.path.validate()) : null,
        contactNumber: widget.isGoogle == true ? '$countryCode ${contactNumberController.text.trim()}' : contactNumberController.text.trim(),
        address: addressController.text.trim(),
        gender: selectGender,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        userEmail: emailController.text.trim(),
      ).then((value) {
        appStore.setLoading(false);
        toast(language.profileUpdateMsg);
        if (widget.isGoogle == true) {
          launchScreen(context, RiderDashBoardScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        } else {
          Navigator.pop(context);
        }
      }).catchError((error) {
        appStore.setLoading(false);
        log(error.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.editProfile, style: boldTextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, top: 30, right: 16, bottom: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      profileImage(),
                      if (sharedPref.getString(LOGIN_TYPE) != LoginTypeGoogle)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 60, left: 80),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: primaryColor),
                            child: IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 20),
                  AppTextField(
                    readOnly: true,
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    focus: emailFocus,
                    nextFocus: userNameFocus,
                    decoration: inputDecoration(context, label: language.email),
                    onTap: () {
                      toast(language.notChangeEmail);
                    },
                  ),
                  if (sharedPref.getString(LOGIN_TYPE) != 'mobile' && sharedPref.getString(LOGIN_TYPE) != null) SizedBox(height: 16),
                  if (sharedPref.getString(LOGIN_TYPE) != 'mobile' && sharedPref.getString(LOGIN_TYPE) != null)
                    AppTextField(
                      readOnly: true,
                      controller: usernameController,
                      textFieldType: TextFieldType.USERNAME,
                      focus: userNameFocus,
                      nextFocus: firstnameFocus,
                      decoration: inputDecoration(context, label: language.userName),
                      onTap: () {
                        toast(language.notChangeUsername);
                      },
                    ),
                  SizedBox(height: 16),
                  AppTextField(
                    controller: firstNameController,
                    textFieldType: TextFieldType.NAME,
                    focus: firstnameFocus,
                    nextFocus: lastnameFocus,
                    decoration: inputDecoration(context, label: language.firstName),
                    errorThisFieldRequired: language.thisFieldRequired,
                  ),
                  SizedBox(height: 16),
                  AppTextField(
                    controller: lastNameController,
                    textFieldType: TextFieldType.NAME,
                    focus: lastnameFocus,
                    nextFocus: contactFocus,
                    decoration: inputDecoration(context, label: language.lastName),
                    errorThisFieldRequired: language.thisFieldRequired,
                  ),
                  SizedBox(height: 16),
                  widget.isGoogle == true
                      ? AppTextField(
                          controller: contactNumberController,
                          textFieldType: TextFieldType.PHONE,
                          focus: contactFocus,
                          nextFocus: addressFocus,
                          decoration: inputDecoration(
                            context,
                            label: language.phoneNumber,
                            prefixIcon: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryCodePicker(
                                    padding: EdgeInsets.zero,
                                    initialSelection: countryCode,
                                    showCountryOnly: false,
                                    dialogSize: Size(MediaQuery.of(context).size.width - 60, MediaQuery.of(context).size.height * 0.6),
                                    showFlag: true,
                                    showFlagDialog: true,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
                                    textStyle: primaryTextStyle(),
                                    dialogBackgroundColor: Theme.of(context).cardColor,
                                    barrierColor: Colors.black12,
                                    dialogTextStyle: primaryTextStyle(),
                                    searchDecoration: InputDecoration(
                                      iconColor: Theme.of(context).dividerColor,
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).dividerColor)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                    ),
                                    searchStyle: primaryTextStyle(),
                                    onInit: (c) {
                                      countryCode = c!.dialCode!;
                                    },
                                    onChanged: (c) {
                                      countryCode = c.dialCode!;
                                    },
                                  ),
                                  VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                                ],
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.trim().isEmpty) return errorThisFieldRequired;
                            if (value.trim().length < 10 || value.trim().length > 14) return language.contactLength;
                            return null;
                          },
                        )
                      : AppTextField(
                          controller: contactNumberController,
                          textFieldType: TextFieldType.PHONE,
                          focus: contactFocus,
                          nextFocus: addressFocus,
                          isValidationRequired: true,
                          readOnly: sharedPref.getString(LOGIN_TYPE) == LoginTypeGoogle ? false : true,
                          decoration: inputDecoration(
                            context,
                            label: language.phoneNumber,
                          ),
                          onTap: () {
                            if (sharedPref.getString(LOGIN_TYPE) != LoginTypeGoogle) {
                              toast(language.youCannotChangePhoneNumber);
                            }
                          },
                        ),
                  SizedBox(height: 16),
                  AppTextField(
                    controller: addressController,
                    focus: addressFocus,
                    textFieldType: TextFieldType.ADDRESS,
                    decoration: inputDecoration(context, label: language.address),
                  ),
                  SizedBox(height: 16),
                  Text(language.gender, style: primaryTextStyle()),
                  SizedBox(height: 8),
                  DropdownButtonFormField(
                    decoration: inputDecoration(context, label: ""),
                    value: selectGender,
                    onChanged: (String? value) {
                      setState(() {
                        selectGender = value!;
                      });
                    },
                    items: gender
                        .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              "${value.capitalizeFirstLetter()}",
                              style: primaryTextStyle(),
                            )))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) {
              return Visibility(
                visible: appStore.isLoading,
                child: loaderWidget(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: AppButtonWidget(
          text: language.updateProfile,
          textStyle: boldTextStyle(color: Colors.white),
          color: primaryColor,
          onTap: () {
            if (sharedPref.getString(USER_EMAIL) == demoEmail) {
              toast(language.demoMsg);
            } else {
              saveProfile();
            }
          },
        ),
      ),
    );
  }
}
