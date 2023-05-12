import 'NearByDriverListModel.dart';

class NearByDriverModel {
    List<NearByDriverListModel>? data;
    String? message;

    NearByDriverModel({this.data, this.message});

    factory NearByDriverModel.fromJson(Map<String, dynamic> json) {
        return NearByDriverModel(
            data: json['data'] != null ? (json['data'] as List).map((i) => NearByDriverListModel.fromJson(i)).toList() : null,
            message: json['message'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        if (this.data != null) {
            data['data'] = this.data!.map((v) => v.toJson()).toList();
        }
        return data;
    }
}