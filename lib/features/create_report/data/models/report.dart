import 'report_data.dart';

class ReportModel {
  Report? report;
  List<ReportData>? reportData;
  List<AprovedStatus>? approvedStatus;

  ReportModel({this.report, this.reportData});

  ReportModel.fromJson(Map<String, dynamic> json) {
    report =
        json['Report'] != null ? new Report.fromJson(json['Report']) : null;
    if (json['ReportData'] != null) {
      reportData = <ReportData>[];
      json['ReportData'].forEach((v) {
        reportData!.add(new ReportData.fromJson(v));
      });
    }
    if (json['approvedStatus'] != null) {
      approvedStatus = <AprovedStatus>[];
      json['approvedStatus'].forEach((v) {
        approvedStatus!.add(new AprovedStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['Report'] = this.report!.toJson();
    }
    if (this.reportData != null) {
      data['ReportData'] = this.reportData!.map((v) => v.toJson()).toList();
    }
    if (this.approvedStatus != null) {
      data['approvedStatus'] =
          this.approvedStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  Address? address;
  ApprovedStatus? approvedStatus;
  String? sId;
  String? reportColId;
  bool? sellerApproval;
  bool? isReady;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Report(
      {this.address,
      this.approvedStatus,
      this.sId,
      this.reportColId,
      this.sellerApproval,
      this.isReady,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Report.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    approvedStatus = json['approvedStatus'] != null
        ? new ApprovedStatus.fromJson(json['approvedStatus'])
        : null;
    sId = json['_id'];
    reportColId = json['reportColId'];
    sellerApproval = json['sellerApproval'];
    isReady = json['isReady'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.approvedStatus != null) {
      data['approvedStatus'] = this.approvedStatus!.toJson();
    }
    data['_id'] = this.sId;
    data['reportColId'] = this.reportColId;
    data['sellerApproval'] = this.sellerApproval;
    data['isReady'] = this.isReady;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Address {
  String? city;
  String? state;

  Address({this.city, this.state});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
}

class ApprovedStatus {
  ServiceTechnician? serviceTechnician;
  Manager? manager;
  Manager? businessUnitSpoc;
  Manager? warehouseHead;

  ApprovedStatus(
      {this.serviceTechnician,
      this.manager,
      this.businessUnitSpoc,
      this.warehouseHead});

  ApprovedStatus.fromJson(Map<String, dynamic> json) {
    serviceTechnician = json['serviceTechnician'] != null
        ? new ServiceTechnician.fromJson(json['serviceTechnician'])
        : null;
    manager =
        json['manager'] != null ? new Manager.fromJson(json['manager']) : null;
    businessUnitSpoc = json['businessUnitSpoc'] != null
        ? new Manager.fromJson(json['businessUnitSpoc'])
        : null;
    warehouseHead = json['warehouseHead'] != null
        ? new Manager.fromJson(json['warehouseHead'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.serviceTechnician != null) {
      data['serviceTechnician'] = this.serviceTechnician!.toJson();
    }
    if (this.manager != null) {
      data['manager'] = this.manager!.toJson();
    }
    if (this.businessUnitSpoc != null) {
      data['businessUnitSpoc'] = this.businessUnitSpoc!.toJson();
    }
    if (this.warehouseHead != null) {
      data['warehouseHead'] = this.warehouseHead!.toJson();
    }
    return data;
  }
}

class ServiceTechnician {
  bool? isApproved;
  String? assignedTo;

  ServiceTechnician({this.isApproved, this.assignedTo});

  ServiceTechnician.fromJson(Map<String, dynamic> json) {
    isApproved = json['isApproved'];
    assignedTo = json['assignedTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isApproved'] = this.isApproved;
    data['assignedTo'] = this.assignedTo;
    return data;
  }
}

class Manager {
  bool? isApproved;

  Manager({this.isApproved});

  Manager.fromJson(Map<String, dynamic> json) {
    isApproved = json['isApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isApproved'] = this.isApproved;
    return data;
  }
}

class AprovedStatus {
  String? approveState;
  List<String>? comment;
  int? rejectCount;
  String? assignedTo;
  String? assignedBy;
  String? sId;

  AprovedStatus(
      {this.approveState,
        this.comment,
        this.rejectCount,
        this.assignedTo,
        this.assignedBy,
        this.sId});

  AprovedStatus.fromJson(Map<String, dynamic> json) {
    approveState = json['approveState'];
    comment = json['Comment'].cast<String>();
    rejectCount = json['rejectCount'];
    assignedTo = json['assignedTo'];
    assignedBy = json['assignedBy'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approveState'] = this.approveState;
    data['Comment'] = this.comment;
    data['rejectCount'] = this.rejectCount;
    data['assignedTo'] = this.assignedTo;
    data['assignedBy'] = this.assignedBy;
    data['_id'] = this.sId;
    return data;
  }
}
