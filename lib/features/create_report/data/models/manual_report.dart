class ManualReport {
  String? reportType;
  String? status;
  String? itemCode;
  bool? customerApproval;
  bool? dealerApproval;
  int? units;

  ManualReport(
      {this.reportType,
      this.status,
      this.itemCode,
      this.customerApproval,
      this.dealerApproval,
      this.units});

  ManualReport.fromJson(Map<String, dynamic> json) {
    reportType = json['reportType'];
    status = json['status'];
    itemCode = json['itemCode'];
    customerApproval = json['customerApproval'];
    dealerApproval = json['dealerApproval'];
    units = json['units'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportType'] = this.reportType;
    data['status'] = this.status;
    data['itemCode'] = this.itemCode;
    data['customerApproval'] = this.customerApproval;
    data['dealerApproval'] = this.dealerApproval;
    data['units'] = this.units;
    return data;
  }
}
