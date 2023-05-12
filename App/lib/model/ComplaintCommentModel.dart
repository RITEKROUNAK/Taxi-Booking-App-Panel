import 'PaginationModel.dart';

class ComplaintCommentModel {
  List<ComplaintList>? data;
  PaginationModel? pagination;

  ComplaintCommentModel({this.data, this.pagination});

  factory ComplaintCommentModel.fromJson(Map<String, dynamic> json) {
    return ComplaintCommentModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => ComplaintList.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? PaginationModel.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class ComplaintList {
  String? addedBy;
  String? comment;
  int? complaintId;
  String? createdAt;
  int? id;
  String? status;
  String? updatedAt;
  int? userId;
  String? userName;
  String? userProfileImage;

  ComplaintList({
    this.addedBy,
    this.comment,
    this.complaintId,
    this.createdAt,
    this.id,
    this.status,
    this.updatedAt,
    this.userId,
    this.userName,
    this.userProfileImage,
  });

  factory ComplaintList.fromJson(Map<String, dynamic> json) {
    return ComplaintList(
      addedBy: json['added_by'],
      comment: json['comment'],
      complaintId: json['complaint_id'],
      createdAt: json['created_at'],
      id: json['id'],
      status: json['status'],
      updatedAt: json['updated_at'],
      userId: json['user_id'],
      userName: json['user_name'],
      userProfileImage: json['user_profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['added_by'] = this.addedBy;
    data['comment'] = this.comment;
    data['complaint_id'] = this.complaintId;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_profile_image'] = this.userProfileImage;
    return data;
  }
}
