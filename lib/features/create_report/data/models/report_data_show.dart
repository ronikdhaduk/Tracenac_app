
import 'package:tracenac/features/create_report/data/models/report_data.dart';

class ReportDataShow {
  SummaryShow? summary;
  String? sId;
  String? reportType;
  String? status;
  String? itemCode;
  bool? dealerApproval;
  int? units;
  List<String>? codesScanned;
  String? reportId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ReportDataShow({
    this.summary,
    this.sId,
    this.reportType,
    this.status,
    this.itemCode,
    this.dealerApproval,
    this.units,
    this.codesScanned,
    this.reportId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });
  ReportDataShow.fromReportData(ReportData reportData)
      : summary = reportData.summary != null ? SummaryShow.fromSummary(reportData.summary!) : null,
        sId = reportData.sId,
        reportType = reportData.reportType,
        status = reportData.status,
        itemCode = reportData.itemCode,
        dealerApproval = reportData.dealerApproval,
        units = reportData.units,
        codesScanned = List.from(reportData.codesScanned ?? []),
        reportId = reportData.reportId,
        createdAt = reportData.createdAt,
        updatedAt = reportData.updatedAt,
        iV = reportData.iV;

  void clear() {
    summary = null;
    sId = null;
    reportType = null;
    status = null;
    itemCode = null;
    dealerApproval = null;
    units = null;
    codesScanned = null;
    reportId = null;
    createdAt = null;
    updatedAt = null;
    iV = null;
  }

  ReportDataShow.fromJson(Map<String, dynamic> json) {
    summary = json['summary'] != null ? new SummaryShow.fromJson(json['summary']) : null;
    sId = json['_id'];
    reportType = json['reportType'];
    status = json['status'];
    itemCode = json['itemCode'];
    // dealerApproval = json['dealerApproval'];
    units = json['units'];
    codesScanned = (json['codesScanned'] as List?)
        ?.map((dynamic e) => e as String)
        .toList();
    reportId = json['reportId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    data['_id'] = this.sId;
    data['reportType'] = this.reportType;
    data['status'] = this.status;
    data['itemCode'] = this.itemCode;
    data['dealerApproval'] = this.dealerApproval;

    data['units'] = this.units;
    data['codesScanned'] = this.codesScanned;
    data['reportId'] = this.reportId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }

  @override
  String toString() => "$units units for $itemCode are $summary";
}

class SummaryShow {
  int? fake;
  int? warrentyAlreadyClaimed;
  int? outOfWarenty;
  int? itemInWarenty;

  SummaryShow({
    this.fake,
    this.warrentyAlreadyClaimed,
    this.outOfWarenty,
    this.itemInWarenty,
  });

  SummaryShow.fromSummary(Summary summary)
      : fake = summary.fake,
        warrentyAlreadyClaimed = summary.warrentyAlreadyClaimed,
        outOfWarenty = summary.outOfWarenty,
        itemInWarenty = summary.itemInWarenty;

  SummaryShow.fromJson(Map<String, dynamic> json) {
    fake = json['fake'];
    warrentyAlreadyClaimed = json['warrenty_already_claimed'];
    outOfWarenty = json['out_of_warenty'];
    itemInWarenty = json['item_in_warenty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fake'] = this.fake;
    data['warrenty_already_claimed'] = this.warrentyAlreadyClaimed;
    data['out_of_warenty'] = this.outOfWarenty;
    data['item_in_warenty'] = this.itemInWarenty;
    return data;
  }

  @override
  String toString() {
    // return "F: ${fake ?? '0'}  C: ${warrentyAlreadyClaimed ?? '0'} Out: ${outOfWarenty ?? '0'} W: ${itemInWarenty ?? '0'}";
    return "S: ${fake ?? '0'}  C: ${warrentyAlreadyClaimed ?? '0'} Out: ${outOfWarenty ?? '0'} W: ${itemInWarenty ?? '0'}";
  }
}
