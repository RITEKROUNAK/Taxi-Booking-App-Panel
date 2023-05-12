import 'ServiceModel.dart';

class UserDetailModel {
  UserData? data;
  String? message;

  UserDetailModel({this.data, this.message});

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserData {
  String? address;
  String? contactNumber;
  String? createdAt;
  String? apiToken;
  String? displayName;
  ServiceList? driverService;
  String? email;
  String? fcmToken;
  String? firstName;
  String? gender;
  var id;
  int? isOnline;
  int? isVerifiedDriver;
  String? lastName;
  String? lastNotificationSeen;
  String? latitude;
  String? loginType;
  String? longitude;
  String? playerId;
  String? profileImage;
  var serviceId;
  String? status;
  String? timezone;
  String? uid;
  String? updatedAt;
  UserBankAccount? userBankAccount;
  UserDetail? userDetail;
  String? userType;
  String? username;
  int? isDocumentRequired;
  num? rating;

  UserData({
    this.address,
    this.contactNumber,
    this.createdAt,
    this.displayName,
    this.driverService,
    this.email,
    this.fcmToken,
    this.firstName,
    this.gender,
    this.id,
    this.isOnline,
    this.isVerifiedDriver,
    this.lastName,
    this.lastNotificationSeen,
    this.latitude,
    this.loginType,
    this.longitude,
    this.playerId,
    this.profileImage,
    this.serviceId,
    this.status,
    this.timezone,
    this.uid,
    this.updatedAt,
    this.userBankAccount,
    this.userDetail,
    this.userType,
    this.username,
    this.apiToken,
    this.isDocumentRequired,
    this.rating,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      address: json['address'],
      contactNumber: json['contact_number'],
      createdAt: json['created_at'],
      displayName: json['display_name'],
      email: json['email'],
      fcmToken: json['fcm_token'],
      firstName: json['first_name'],
      gender: json['gender'],
      id: json['id'],
      isOnline: json['is_online'],
      isVerifiedDriver: json['is_verified_driver'],
      lastName: json['last_name'],
      lastNotificationSeen: json['last_notification_seen'],
      latitude: json['latitude'],
      loginType: json['login_type'],
      longitude: json['longitude'],
      playerId: json['player_id'],
      profileImage: json['profile_image'],
      serviceId: json['service_id'],
      status: json['status'],
      timezone: json['timezone'],
      uid: json['uid'],
      updatedAt: json['updated_at'],
      userDetail: json['user_detail'] != null ? UserDetail.fromJson(json['user_detail']) : null,
      userBankAccount: json['user_bank_account'] != null ? UserBankAccount.fromJson(json['user_bank_account']) : null,
      driverService: json['driver_service'] != null ? ServiceList.fromJson(json['driver_service']) : null,
      userType: json['user_type'],
      username: json['username'],
      apiToken: json['api_token'],
      isDocumentRequired: json['is_document_required'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['contact_number'] = this.contactNumber;
    data['created_at'] = this.createdAt;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['fcm_token'] = this.fcmToken;
    data['first_name'] = this.firstName;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['is_online'] = this.isOnline;
    data['is_verified_driver'] = this.isVerifiedDriver;
    data['last_name'] = this.lastName;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['latitude'] = this.latitude;
    data['login_type'] = this.loginType;
    data['longitude'] = this.longitude;
    data['player_id'] = this.playerId;
    data['profile_image'] = this.profileImage;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['timezone'] = this.timezone;
    data['uid'] = this.uid;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    data['api_token'] = this.apiToken;
    data['is_document_required'] = this.isDocumentRequired;
    data['rating'] = this.rating;
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    if (this.userBankAccount != null) {
      data['user_bank_account'] = this.userBankAccount!.toJson();
    }
    if (this.driverService != null) {
      data['driver_service'] = this.driverService!.toJson();
    }
    return data;
  }
}

class UserDetail {
  String? carColor;
  String? carModel;
  String? carPlateNumber;
  String? carProductionYear;
  String? createdAt;
  String? homeAddress;
  String? homeLatitude;
  String? homeLongitude;
  int? id;
  String? updatedAt;
  int? userId;
  String? workAddress;
  String? workLatitude;
  String? workLongitude;

  UserDetail({
    this.carColor,
    this.carModel,
    this.carPlateNumber,
    this.carProductionYear,
    this.createdAt,
    this.homeAddress,
    this.homeLatitude,
    this.homeLongitude,
    this.id,
    this.updatedAt,
    this.userId,
    this.workAddress,
    this.workLatitude,
    this.workLongitude,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      carColor: json['car_color'],
      carModel: json['car_model'],
      carPlateNumber: json['car_plate_number'],
      carProductionYear: json['car_production_year'],
      createdAt: json['created_at'],
      homeAddress: json['home_address'],
      homeLatitude: json['home_latitude'],
      homeLongitude: json['home_longitude'],
      id: json['id'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      workAddress: json['work_address'],
      workLatitude: json['work_latitude'],
      workLongitude: json['work_longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['car_color'] = this.carColor;
    data['car_model'] = this.carModel;
    data['car_plate_number'] = this.carPlateNumber;
    data['car_production_year'] = this.carProductionYear;
    data['created_at'] = this.createdAt;
    data['home_address'] = this.homeAddress;
    data['home_latitude'] = this.homeLatitude;
    data['home_longitude'] = this.homeLongitude;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['work_address'] = this.workAddress;
    data['work_latitude'] = this.workLatitude;
    data['work_longitude'] = this.workLongitude;
    return data;
  }
}

class UserBankAccount {
  String? accountHolderName;
  String? accountNumber;
  String? bankCode;
  String? bankName;
  String? createdAt;
  int? id;
  String? updatedAt;
  int? userId;

  UserBankAccount({
    this.accountHolderName,
    this.accountNumber,
    this.bankCode,
    this.bankName,
    this.createdAt,
    this.id,
    this.updatedAt,
    this.userId,
  });

  factory UserBankAccount.fromJson(Map<String, dynamic> json) {
    return UserBankAccount(
      accountHolderName: json['account_holder_name'],
      accountNumber: json['account_number'],
      bankCode: json['bank_code'],
      bankName: json['bank_name'],
      createdAt: json['created_at'],
      id: json['id'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_holder_name'] = this.accountHolderName;
    data['account_number'] = this.accountNumber;
    data['bank_code'] = this.bankCode;
    data['bank_name'] = this.bankName;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    return data;
  }
}
