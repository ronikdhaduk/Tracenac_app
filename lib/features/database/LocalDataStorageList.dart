import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tracenac/core/APIClass/APIClass.dart';
import 'package:tracenac/core/utils/app_color.dart';
import '../create_report/create_report_screen/manual/manual_report_screen.dart';
import 'DatabaseHelper.dart';


class LocalDataStorageList extends StatefulWidget {
  const LocalDataStorageList({super.key});

  @override
  State<LocalDataStorageList> createState() => _LocalDataStorageListState();
}

class _LocalDataStorageListState extends State<LocalDataStorageList> {

  final dbHelper = DatabaseHelper.instance;
  bool isLoading = true;
  List<Map<String, dynamic>> reportList = [];
  List filteredReportList = [];
  List<Map<String, dynamic>> originalReportList = [];
  var data,item;
  String searchQuery = '';

  @override
  void initState() {
    // dealerId =int.parse(widget.partnerId);
    // TODO: implement initState
    fetchAllLocalData();
    super.initState();
  }

  fetchAllLocalData() async {
    originalReportList =
    await dbHelper.getAllData();
    print('Reports for Dealer ID $originalReportList');

    setState(() {
      reportList=originalReportList;
      isLoading = false;
    });
  }

  void _searchReports(String query) {
    setState(() {
      if (query.isEmpty) {
        reportList = [...originalReportList];
      } else {
        reportList = originalReportList
            .where((report) =>
        report["DealerName"].toString().toLowerCase().contains(query.toLowerCase()) ||
        report["ReportId"].toString().toLowerCase().contains(query.toLowerCase()) ||
            report["DealerId"].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      log("My LogData ==> LocalDataStorageList _searchReports $reportList");
    });
  }
  void deleteReport(int index) async {
    final reportId = reportList[index]["ReportId"];
    final partnerId = reportList[index]["DealerId"];
    final dealerName = reportList[index]["DealerName"];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Report'),
          content: Text(  'Are you sure you want to Delete a report for \n${dealerName}? \nDealerID : $partnerId  \nReport ID : ${reportId}'),

          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                // Perform deletion logic here
                await APIClass().deleteSoftReportId(reportId);
                await dbHelper.deleteReportAndData(reportId, partnerId);
                fetchAllLocalData();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );


    // Remove the report from the reportList
    // await ApiService().deleteSoftReportId(reportId);
    // Delete the report using dbHelper or any other method you have
    // await dbHelper.deleteReportAndData(reportId, partnerId);



      fetchAllLocalData();
    // Update the UI
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Local Data",
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
            ),
          ),
          backgroundColor: AppColor.appBarColor,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _searchReports,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 0,
                      horizontal: 0),
                  labelText: "Search",
                  // hintText: Constants.searchForReport,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
              reportList.isEmpty?Container(child: Text("No Report Found"),):ListView.builder(
                itemCount: reportList.length,
                itemBuilder: (context, index) {
                  final dealerName =
                  reportList[index]["DealerName"];
                  final reportId = reportList[index]["ReportId"];
                  final partnerId = reportList[index]["DealerId"];

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    margin: EdgeInsets.only(top: 5),
                    child: ListTile(
                      // tileColor: index%2 == 0 ? StyleConstants.primaryColor.withOpacity(0.8) : StyleConstants.appBarColor.withOpacity(0.8),
                      leading: Icon(
                        Icons.fact_check_sharp,
                        size: 35,
                        color: AppColor.appBarColor,
                      ),
                      title: Text(
                        dealerName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(reportId, style: TextStyle(color: Colors.black,),),
                      trailing: IconButton(onPressed: () {
                        deleteReport(index);
                        // openDialog(index);


                        setState(() {
                          log("My LogData ==> deleteReport 2");
                        });

                      },icon: Icon(Icons.delete_outline, color: Colors.black,)),
                      onTap: () {
                        getReportData(dealerName,partnerId, reportId);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  getReportData(dealerName,partnerId, reportId) async {
    log("My LogData ==> getReportData $dealerName => $partnerId =>$reportId");


    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ListManualReport(
          creation: '',
          partnerName: dealerName.toString(),
          partner: partnerId.toString(),
          reportId: reportId.toString(),
          reportDataItems: [],
        ),
      ),
    );
  }

  Widget openDialog(int index) {
    final dealerName = reportList[index]["DealerName"];
    final reportId = reportList[index]["ReportId"];
    final partnerId = reportList[index]["DealerId"];
    log("My LogData ==> openDialog dealerName $dealerName");
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0.1),
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          await showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Create Report'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'Are you sure you want to create a report for \n{widget.item.partnerName}? \nID : {widget.item.partnerId!}')
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () async {
                        log("My LogData ==> Loading {widget.item.partnerId}");
                        log("My LogData ==> Loading {widget.creationType}");
                        log("My LogData ==> Loading {widget.item.partnerName!}");

                      },
                    ),
                  ],
                );

                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => DealerProfile(
                //       dealer: item,
                //     ),
                //   ),
                // );
              });
        },
        title: Text("widget.item.partnerName!"),
        subtitle: Text('Id : widget.item.partnerId!'),
      ),
    );
    /*return AlertDialog(
      title: const Text('Delete Report'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Are you sure you want to Delete a report for \n${dealerName}? \nDealerID : $partnerId  \nReport ID : ${reportId}')
          ],
        ),
      ),
      actions: <Widget>[

        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            deleteReport(index);
          },
        ),
      ],
    );*/
  }
}