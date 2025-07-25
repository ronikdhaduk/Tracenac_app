class UniqueCode {
  String? status;
  String? ItemCode;

  UniqueCode({
    this.status,
    this.ItemCode,
  });

  UniqueCode.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    ItemCode = json['ItemCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['ItemCode'] = this.ItemCode;
    return data;
  }
}
