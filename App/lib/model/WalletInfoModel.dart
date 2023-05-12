class WalletInfoModel {
  WalletData? walletData;
  int? minAmountToGetRide;
  int? totalAmount;

  WalletInfoModel({this.walletData, this.minAmountToGetRide, this.totalAmount});

  WalletInfoModel.fromJson(Map<String, dynamic> json) {
    walletData = json['wallet_data'] != null
        ? new WalletData.fromJson(json['wallet_data'])
        : null;
    minAmountToGetRide = json['min_amount_to_get_ride'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.walletData != null) {
      data['wallet_data'] = this.walletData!.toJson();
    }
    data['min_amount_to_get_ride'] = this.minAmountToGetRide;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class WalletData {
  int? id;
  int? userId;
  int? totalAmount;
  String? onlineReceived;
  String? collectedCash;
  String? manualReceived;
  String? totalWithdrawn;
  String? currency;
  String? createdAt;
  String? updatedAt;

  WalletData(
      {this.id,
        this.userId,
        this.totalAmount,
        this.onlineReceived,
        this.collectedCash,
        this.manualReceived,
        this.totalWithdrawn,
        this.currency,
        this.createdAt,
        this.updatedAt});

  WalletData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    totalAmount = json['total_amount'];
    onlineReceived = json['online_received'];
    collectedCash = json['collected_cash'];
    manualReceived = json['manual_received'];
    totalWithdrawn = json['total_withdrawn'];
    currency = json['currency'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['total_amount'] = this.totalAmount;
    data['online_received'] = this.onlineReceived;
    data['collected_cash'] = this.collectedCash;
    data['manual_received'] = this.manualReceived;
    data['total_withdrawn'] = this.totalWithdrawn;
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
