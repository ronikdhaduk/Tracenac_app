class AssignTaskModelClass {
  bool? status;
  List<AssignTaskMsg>? assignTaskMsgmsg;

  AssignTaskModelClass({this.status, this.assignTaskMsgmsg});

  AssignTaskModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['msg'] != null) {
      assignTaskMsgmsg = <AssignTaskMsg>[];
      json['msg'].forEach((v) {
        assignTaskMsgmsg!.add(new AssignTaskMsg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.assignTaskMsgmsg != null) {
      data['msg'] = this.assignTaskMsgmsg!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssignTaskMsg {
  String? sId;
  String? dateOfVisit;
  String? emailID;
  PartnerData? partnerData;

  AssignTaskMsg({this.sId, this.dateOfVisit, this.emailID, this.partnerData});

  AssignTaskMsg.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    dateOfVisit = json['dateOfVisit'];
    emailID = json['emailID'];
    partnerData = json['partnerData'] != null
        ? new PartnerData.fromJson(json['partnerData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['dateOfVisit'] = this.dateOfVisit;
    data['emailID'] = this.emailID;
    if (this.partnerData != null) {
      data['partnerData'] = this.partnerData!.toJson();
    }
    return data;
  }
}

class PartnerData {
  String? partnerId;
  String? partnerName;
  String? lat;
  String? long;

  PartnerData({this.partnerId, this.partnerName,this.lat, this.long});

  PartnerData.fromJson(Map<String, dynamic> json) {
    partnerId = json['partnerId'];
    partnerName = json['partnerName'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partnerId'] = this.partnerId;
    data['partnerName'] = this.partnerName;
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}
