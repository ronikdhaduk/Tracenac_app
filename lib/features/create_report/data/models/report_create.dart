import 'package:intl/intl.dart';

import 'report.dart';

class CreateReportModel {
  Data? data;
  String? message;

  CreateReportModel({this.data, this.message});

  CreateReportModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] == null ?null: new Data.fromJson(json['data'])  ;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  LastReport? lastReport;
  Report? report;

  Data({this.lastReport, this.report});

  Data.fromJson(Map<String, dynamic> json) {
    lastReport = json['lastReport'] == "No Previous report found for this partner"
        ?null: new LastReport.fromJson(json['lastReport']);
    report =
    json['report'] != null ? new Report.fromJson(json['report']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastReport != null) {
      data['lastReport'] = this.lastReport!.toJson();
    }
    if (this.report != null) {
      data['report'] = this.report!.toJson();
    }
    return data;
  }
}

class LastReport {
  String? lastReport;
  String? date;

  LastReport({this.lastReport, this.date});

  LastReport.fromJson(Map<String, dynamic> json) {
    lastReport = json['lastReport'];
    // date = json['date'];
    date = DateFormat('dd/MM/yyyy').format(DateTime.parse(json['date']));;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastReport'] = this.lastReport;
    data['date'] = this.date;
    return data;
  }
}

class Report {
  String? reportColId;
  String? partnerId;
  bool? partnerApproval;
  int? noOfBoxes;
  bool? isReady;
  int? fake;
  int? rejectCount;
  ApprovedStatus? approvedStatus;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Report(
      {this.reportColId,
        this.partnerId,
        this.partnerApproval,
        this.noOfBoxes,
        this.isReady,
        this.fake,
        this.rejectCount,
        this.approvedStatus,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Report.fromJson(Map<String, dynamic> json) {
    reportColId = json['reportColId'];
    partnerId = json['partnerId'];
    partnerApproval = json['partnerApproval'];
    noOfBoxes = json['noOfBoxes'];
    isReady = json['isReady'];
    fake = json['fake'];
    rejectCount = json['rejectCount'];
    approvedStatus = json['approvedStatus'] != null
        ? new ApprovedStatus.fromJson(json['approvedStatus'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    // updatedAt = DateFormat('dd/MM/yyyy').format(DateTime.parse(json['updatedAt']));
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportColId'] = this.reportColId;
    data['partnerId'] = this.partnerId;
    data['partnerApproval'] = this.partnerApproval;
    data['noOfBoxes'] = this.noOfBoxes;
    data['isReady'] = this.isReady;
    data['fake'] = this.fake;
    data['rejectCount'] = this.rejectCount;
    if (this.approvedStatus != null) {
      data['approvedStatus'] = this.approvedStatus!.toJson();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

