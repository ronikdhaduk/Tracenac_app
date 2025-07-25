import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tracenac/core/utils/app_color.dart';

import '../../../database/DatabaseHelper.dart';
import '../../data/models/report_data.dart';
import '../../data/models/report_data_show.dart';

class ListManualReport extends StatefulWidget {
  ListManualReport({
    super.key,
    required this.reportId,
    this.date,
    required this.creation,
    required this.partnerName,
    required this.partner,
    required this.reportDataItems,
  });

  final String reportId;
  final String creation;
  final String partnerName;
  final String partner;
  String? date;
  final List<ReportDataShow> reportDataItems;

  @override
  State<ListManualReport> createState() => _ListManualReportState();
}

class _ListManualReportState extends State<ListManualReport> {
  String? itemCode;
  int? units;
  bool success = false;
  bool radioButtonCountunderWarranty = false;
  bool radioButtonCountoutOfWarranty = false;
  bool radioButtonCountalreadyScanned = false;
  bool radioButtonCountfake = false;
  DateTime? createDate;
  String? reportId;
  String? status;
  var data;
  String? selectedProductStatus = "underWarranty";
  List<String> scanCodeList = [];
  bool isLoading = true;
  TextEditingController productController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool buildList = false;
  final _productFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();
  final dbHelper = DatabaseHelper.instance;
  var item;



  getReportData() async {
    var temp = await dbHelper.getManualProductsByReportId(widget.reportId);
    // if (widget.creation == "") {
    print("My LogData ==> Manual temp: $temp");

    for (int i = 0; i < temp.length; i++) {
      if (temp[i]["Creation_Type"] == "M") {
        log("My LogData ==> temp if ${i}");
        log("My LogData ==> temp if ${temp[i]["Creation_Type"]}");

        setState(() {
          int units = int.tryParse(temp[i]["Unit"]) ?? 0;
          int fake = int.tryParse(temp[i]["Fake"]) ?? 0;
          int warrentyAlreadyClaimed =
              int.tryParse(temp[i]["warrenty_already_claimed"]) ?? 0;
          int outOfWarenty = int.tryParse(temp[i]["out_of_warenty"]) ?? 0;
          int itemInWarenty = int.tryParse(temp[i]["item_in_warenty"]) ?? 0;

          SummaryShow newSummary = SummaryShow(
            fake: fake,
            warrentyAlreadyClaimed: warrentyAlreadyClaimed,
            outOfWarenty: outOfWarenty,
            itemInWarenty: itemInWarenty,
          );

          ReportDataShow reportData = ReportDataShow(
            itemCode: "${temp[i]['Product']}",
            // codesScanned: [],
            units: units, // Assign the converted int value
            summary: newSummary,
          );
          widget.reportDataItems.add(reportData);
          log("My LogData ==> Manul getReportData if $reportData");
        });
        setState(() {
          buildList = true;
        });
        log("My LogData ==> buildList ${widget.reportDataItems.length}");
      }
      setState(() {
        buildList = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getReportDate() async {
    final lastDate = await dbHelper.getReportLastDate(widget.reportId);
    if (lastDate != null) {
      dateController.text = lastDate;
      // Do something with the lastDate
      print('Last date: $lastDate');
    } else {
      // Handle the case when the lastDate is null
      print('Last date not found');
    }
  }

  deleteProductData(itemCode, unit) async {
    showLoadingDialog(context);

    log("My LogData ==> deleteProductData $itemCode ");

    // Delete the row with the specified productId
    await dbHelper.deleteProductDataByName(widget.reportId, itemCode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Item ${itemCode} units ${unit} dismissed")),
    );
    widget.reportDataItems.clear();
    getReportData();
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  addReport() async {
    await dbHelper.insertDealer(widget.partnerName, widget.partner, 0);
    await dbHelper.insertReport(widget.partner, widget.reportId, 0);
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(200),
      lastDate: currentDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFed3037), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat("dd/MM/yyy").format(pickedDate);
        print("My LogData ==> setState  dob ${dateController.text}");
      });
      await dbHelper.addOrUpdateReportDate(
        widget.reportId,
        dateController.text,
      );
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        log("My LogData ==> showLoadingDialog");
        return WillPopScope(
          // Disable back button pop
          onWillPop: () async {
            return false;
          },
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    widget.reportDataItems.clear();
    // units=0;
    addReport();
    log("My LogData ==> manual report Screen ==> ${widget.reportDataItems}");
    // createReport();
    getReportDate();
    getReportData();
    super.initState();
  }

  @override
  void dispose() {
    widget.reportDataItems.clear();
    log(
      "My LogData ==> reportDataItems widget ${widget.reportDataItems.length}",
    );
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ReportDataShow> reportDataShowList = widget.reportDataItems;
    List<ReportData> reportDataList =
    reportDataShowList.map((reportDataShow) {
      return ReportData(
        summary:
        reportDataShow.summary != null
            ? Summary(
          // fake: reportDataShow.summary!.fake,
          // warrentyAlreadyClaimed: reportDataShow.summary!.warrentyAlreadyClaimed,
          // outOfWarenty: reportDataShow.summary!.outOfWarenty,
          // itemInWarenty: reportDataShow.summary!.itemInWarenty,
        )
            : null,
        sId: reportDataShow.sId,
        reportType: reportDataShow.reportType,
        status: reportDataShow.status,
        itemCode: reportDataShow.itemCode,
        dealerApproval: reportDataShow.dealerApproval,
        // units: reportDataShow.units,
        codesScanned: reportDataShow.codesScanned,
        reportId: reportDataShow.reportId,
        createdAt: reportDataShow.createdAt,
        updatedAt: reportDataShow.updatedAt,
        iV: reportDataShow.iV,
      );
    }).toList();

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              log("My logData ==> Send to Submit ${dateController.text} ");
              // log("My logData ==> Send to Submit ${widget.reportDataItems[0].codesScanned} ");
              if (widget.reportId != null &&
                  // widget.reportDataItems.isNotEmpty &&
                  dateController.text.isNotEmpty) {
                log("routes comments SubmitManualReport not found");
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmitManualReport(
                //       date: dateController.text,
                //       reportDataList: reportDataList,
                //       reportColId: widget.reportId,
                //       partnerId: widget.partner,
                //     ),),);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All Field Required !!!')),
                );
              }
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 2.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.reportId, style: TextStyle(fontSize: 30)),
                  SizedBox(height: 10),

                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        selectDate(context);
                        setState(() {
                          log("My LogData ==> Date $dateController");
                          // date.text=DateFormat("dd-MM-yyy").format(pic);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "date",
                        suffixIcon: Icon(
                          Icons.date_range,
                          color: AppColor.appBarColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Date';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("addReport",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.partnerName),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // TextFieldSearch(
                        //   label: 'Complex Future List',
                        //   controller: productController,
                        //   future: () {
                        //     return ApiService().getProducts(productController.text,);
                        //   },
                        //   getSelectedValue: (item) {
                        //     itemCode = item.itemCode;
                        //     log("My LogData ==> itemCode $itemCode");
                        //   },
                        //   minStringLength: 1,
                        //   textStyle: TextStyle(color: Colors.red),
                        //   decoration: InputDecoration(
                        //     hintText: Constants.searchForProducts,
                        //   ),
                        // ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: unitController,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Can\'t be empty';
                            }
                            return null;
                          },
                          onChanged: (String? value) {
                            setState(() {
                              if (value != null && value.isNotEmpty) {
                                units = int.parse(value);
                              }
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "unit",
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "underWarranty",
                                          groupValue: selectedProductStatus,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProductStatus = value;
                                              radioButtonCountunderWarranty =
                                              true;
                                            });
                                            log(
                                              'MyLogData selectedProductStatus ==> ' +
                                                  selectedProductStatus
                                                      .toString(),
                                            );
                                          },
                                        ),
                                        Text("underWarranty"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "outOfWarranty",
                                          groupValue: selectedProductStatus,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProductStatus = value;
                                              radioButtonCountoutOfWarranty =
                                              true;
                                            });
                                            log(
                                              'MyLogData selectedProductStatus ==> ' +
                                                  selectedProductStatus
                                                      .toString(),
                                            );
                                          },
                                        ),
                                        Text("outOfWarranty"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "alreadyScanned",
                                          groupValue: selectedProductStatus,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProductStatus = value;
                                              radioButtonCountalreadyScanned =
                                              true;
                                            });
                                            log(
                                              'MyLogData selectedProductStatus ==> ' +
                                                  selectedProductStatus
                                                      .toString(),
                                            );
                                          },
                                        ),
                                        Text("alreadyScanned"),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: "fake",
                                          groupValue: selectedProductStatus,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedProductStatus = value;
                                              radioButtonCountfake = true;
                                            });
                                            log(
                                              'MyLogData selectedProductStatus ==> ' +
                                                  selectedProductStatus
                                                      .toString(),
                                            );
                                          },
                                        ),
                                        Text("fake"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                log(
                                  "My LogData ==> ElevatedButton ${widget.reportId}",
                                );
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder:
                                //         (context) => QRViewScreen(
                                //       creation: 'scan',
                                //       partnerName: widget.partnerName,
                                //       partnerId: widget.partner,
                                //       reportId: widget.reportId!,
                                //       // reportDataItems: widget.reportDataItems,
                                //       reportDataItems: reportDataList,
                                //     ),
                                //   ),
                                // );
                              },
                              child: Text("scanQR"),
                            ),

                            ElevatedButton(
                              onPressed: () async {
                                log(
                                  "My LogData ==> ElevatedButton $reportId",
                                );
                                log(
                                  "My LogData ==> ElevatedButton $selectedProductStatus",
                                );
                                if (_formKey.currentState!.validate() &&
                                    itemCode != null &&
                                    selectedProductStatus != null) {
                                  switch (selectedProductStatus!) {
                                    case 'fake':
                                      {
                                        status = 'fake';
                                      }
                                      break;
                                    case 'Under Warranty':
                                      {
                                        status = 'item_in_warenty';
                                      }
                                      break;
                                    case 'Out of Warranty':
                                      {
                                        status = 'out_of_warenty';
                                      }
                                      break;
                                    case 'Already Scanned':
                                      {
                                        status = 'warrenty_already_claimed';
                                      }
                                      break;
                                  }
                                  log(
                                    'MyLogData status ==> ' +
                                        status.toString(),
                                  );
                                  final index = widget.reportDataItems
                                      .indexWhere(
                                        (element) =>
                                    element.itemCode == itemCode,
                                  );
                                  // ReportData? report = null;
                                  ReportDataShow? report = null;
                                  // ReportDataShow? reportShow = null;
                                  if (index >= 0) {
                                    report = widget.reportDataItems[index];
                                  }
                                  log(
                                    'MyLogData buildList  ==> inside before IF $report',
                                  );
                                  if (report != null) {
                                    log(
                                      'MyLogData buildList  ==> inside IF ${report.units}',
                                    );
                                    log(
                                      'MyLogData buildList  ==> inside IF ${units}',
                                    );
                                    int totalUnit =
                                        (report.units ?? 0) + units!;
                                    log(
                                      'MyLogData buildList  ==> inside IF ${totalUnit}',
                                    );
                                    report.units =
                                        (report.units ?? 0) + units!;
                                    log(
                                      'MyLogData buildList  ==> inside ${report.units} ',
                                    );

                                    if (status == 'fake') {
                                      report.summary?.fake =
                                          (report.summary?.fake ?? 0) +
                                              units!;
                                    } else if (status ==
                                        'warrenty_already_claimed') {
                                      report
                                          .summary
                                          ?.warrentyAlreadyClaimed = (report
                                          .summary
                                          ?.warrentyAlreadyClaimed ??
                                          0) +
                                          units!;
                                    } else if (status == 'out_of_warenty') {
                                      report.summary?.outOfWarenty =
                                          (report.summary?.outOfWarenty ??
                                              0) +
                                              units!;
                                    } else if (status ==
                                        'item_in_warenty') {
                                      report.summary?.itemInWarenty =
                                          (report.summary?.itemInWarenty ??
                                              0) +
                                              units!;
                                    }

                                    log(
                                      "My LogData ==> reportShow 1 report $report",
                                    );
                                    log(
                                      "My LogData ==> reportShow 1 report ${widget.reportDataItems[index]}",
                                    );

                                    setState(() {
                                      widget.reportDataItems[index] =
                                      report!;
                                      addLocalStorageManual(
                                        report,
                                        [],
                                        widget.partner,
                                        "M",
                                        widget.partnerName,
                                        widget.reportId,
                                      );
                                      productController.text = '';
                                      itemCode = null;
                                      selectedProductStatus = "underWarranty";
                                      unitController.text = '0';
                                      buildList = true;
                                      units = 0;
                                    });
                                    log(
                                      'MyLogData buildList ==> inside IF ==> ' +
                                          buildList.toString(),
                                    );
                                  } else {
                                    log(
                                      'MyLogData buildList  ==> inside ELSE ',
                                    );
                                    Map<String, dynamic> summary = {
                                      '$status': units,
                                    };
                                    log(
                                      'MyLogData buildList  ==> inside ELSE $summary',
                                    );

                                    Summary currSummary = Summary.fromJson(
                                      summary,
                                    );
                                    SummaryShow newSummary =
                                    SummaryShow.fromJson(summary);
                                    log(
                                      "My LogData ==> status ${status.toString()}",
                                    );

                                    if (status == "fake") {
                                      newSummary.fake = units!;
                                    } else if (status ==
                                        'warrenty_already_claimed') {
                                      newSummary.warrentyAlreadyClaimed =
                                      units!;
                                    } else if (status == 'out_of_warenty') {
                                      newSummary.outOfWarenty = units!;
                                    } else if (status ==
                                        'item_in_warenty') {
                                      newSummary.itemInWarenty = units!;
                                    }
                                    ReportDataShow reportData =
                                    ReportDataShow(
                                      itemCode: itemCode,
                                      codesScanned: [],
                                      units: units,
                                      // summary: currSummary,);
                                      summary: newSummary,
                                    );

                                    log(
                                      "My LogData ==> reportShow 2 reportData $reportData",
                                    );

                                    setState(() {
                                      widget.reportDataItems.add(
                                        reportData,
                                      );
                                      addLocalStorageManual(
                                        reportData,
                                        [],
                                        widget.partner,
                                        "M",
                                        widget.partnerName,
                                        widget.reportId,
                                      );
                                      productController.text = '';
                                      itemCode = null;
                                      units = 0;
                                      selectedProductStatus = "underWarranty";
                                      unitController.text = '0';
                                      buildList = true;
                                    });
                                    log(
                                      'MyLogData buildList ==> inside ELSE ==> ' +
                                          buildList.toString(),
                                    );
                                  }
                                }
                              },
                              child: Text("add"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(8.0)),

            buildList && widget.reportDataItems.isNotEmpty
                ? Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                // color: Colors.green,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              child: ListView.builder(
                itemCount: widget.reportDataItems.length,
                itemBuilder: (BuildContext context, int index) {
                  item = widget.reportDataItems[index];

                  log(
                    "My LogData ==> reportDataItems length ${widget.reportDataItems.length}",
                  );
                  log(
                    "My LogData ==> reportDataItems length ${item.itemCode}",
                  );
                  // log("My LogData ==> reportDataItems length ${item[index]}");
                  return Visibility(
                    visible:
                    item.codesScanned == null ||
                        item.codesScanned!.isEmpty,
                    child: ListTile(
                      leading: const Icon(Icons.list),
                      title: Text("$item"),
                      trailing: GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          print(
                            "lkfjgklfd gklfdj jgklfdj  ${widget.reportDataItems[index].itemCode}",
                          );
                          // showLoadingDialog(context);
                          //delete action for this button
                          widget.reportDataItems.removeWhere(
                                (element) {
                              return element.itemCode ==
                                  item.itemCode &&
                                  element.units == item.units;
                            },
                          ); //go through the loop and match content to delete from list

                          print(
                            "reportDataItems ${item.itemCode} , ${item.units}",
                          );
                          // print("reportDataItems ${widget.reportDataItems[index].itemCode} , ${widget.reportDataItems[index].units}");
                          // deleteProductData(widget.reportDataItems[index].itemCode,widget.reportDataItems[index].units);
                          deleteProductData(item.itemCode, item.units);
                          setState(() {
                            //refresh UI after deleting element from list
                          });
                        },
                      ),
                    ),
                  );
                  // );
                },
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}


addLocalStorage(
    ReportData reportData,
    List scanCode,
    String partner,
    creation,
    partnerName,
    reportId,
    ) async {
  log("DivyeshLog 1  ==> units  ${reportData.units}");
  log("DivyeshLog 1  ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 1  ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 1  ==> itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 1  ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );
  await DatabaseHelper.instance.insertOrUpdateReport(
    Creation: "$creation",
    DealerId: int.parse(partner),
    dealerName: partnerName,
    ReportId: reportId,
    ScanCode: scanCode,
    productName: "${reportData.itemCode}",
    units: int.parse("${reportData.units}"),
    fake: reportData.summary?.fake ?? 0,
    out_of_warenty: reportData.summary?.outOfWarenty ?? 0,
    item_in_warenty: reportData.summary?.itemInWarenty ?? 0,
    warrenty_already_claimed: reportData.summary?.warrentyAlreadyClaimed ?? 0,
  );

  log("DivyeshLog 2  ==> units  ${reportData.units}");
  log("DivyeshLog 2 ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 2 ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 2 ==> itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 2 ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );

  // reportDataShow.clear();

  log("DivyeshLog 3 ==> units  ${reportData.units}");
  log("DivyeshLog 3 ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 3 ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 3 => itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 3 ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );
  /*reportData.itemCode = '';
  reportData.units = 0;
  reportData.summary = null;
  scanCode.clear();*/
}

addLocalStorageManual(
    ReportDataShow reportData,
    List scanCode,
    String partner,
    creation,
    partnerName,
    reportId,
    ) async {
  log("DivyeshLog 1  ==> units  ${reportData.units}");
  log("DivyeshLog 1  ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 1  ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 1  ==> itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 1  ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );
  await DatabaseHelper.instance.insertOrUpdateReport(
    Creation: "$creation",
    DealerId: int.parse(partner),
    dealerName: partnerName,
    ReportId: reportId,
    ScanCode: scanCode,
    productName: "${reportData.itemCode}",
    units: int.parse("${reportData.units}"),
    fake: reportData.summary?.fake ?? 0,
    out_of_warenty: reportData.summary?.outOfWarenty ?? 0,
    item_in_warenty: reportData.summary?.itemInWarenty ?? 0,
    warrenty_already_claimed: reportData.summary?.warrentyAlreadyClaimed ?? 0,
  );

  log("DivyeshLog 2  ==> units  ${reportData.units}");
  log("DivyeshLog 2 ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 2 ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 2 ==> itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 2 ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );

  // reportDataShow.clear();

  log("DivyeshLog 3 ==> units  ${reportData.units}");
  log("DivyeshLog 3 ==> fake ${reportData.summary?.fake}");
  log("DivyeshLog 3 ==> outOfWarenty ${reportData.summary?.outOfWarenty}");
  log("DivyeshLog 3 => itemInWarenty ${reportData.summary?.itemInWarenty}");
  log(
    "DivyeshLog 3 ==> warrentyAlreadyClaimed ${reportData.summary?.warrentyAlreadyClaimed}",
  );
  /*reportData.itemCode = '';
  reportData.units = 0;
  reportData.summary = null;
  scanCode.clear();*/
}



