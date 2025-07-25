import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';
import '../../../database/DatabaseHelper.dart';
import '../../data/models/report_data.dart';


class ManualSubmitScreen extends StatefulWidget {
  const ManualSubmitScreen({super.key, required this.reportColId, required this.partnerId, required this.date, required this.reportDataList});
  final String reportColId;
  final String partnerId;
  final String date;
  final List<ReportData> reportDataList;

  @override
  State<ManualSubmitScreen> createState() => _ManualSubmitScreenState();
}

class _ManualSubmitScreenState extends State<ManualSubmitScreen> {
  final dbHelper = DatabaseHelper.instance;
  TextEditingController myController = TextEditingController();
  TextEditingController noOfBoxController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? userEmail;
  String userType = '';
  int? box, totalUnit = 0;
  bool loading = false, isSubmit = false;
  TextEditingController userCtr = TextEditingController();
  List<String> scanCodeList = [];
  final _formKey = GlobalKey<FormState>();
  final _formKeyComment = GlobalKey<FormState>();
  HandSignatureControl control = new HandSignatureControl(
    threshold: 0.01,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );

  getReportData() async {
    // getLocationData();
    var temp = await dbHelper.getProductsByReportId(widget.reportColId);
    print("My LogData ==> temp: $temp");

    for (int i = 0; i < temp.length; i++) {
      if (temp[i]["Creation_Type"] == "M") {
        // scanCodeList = jsonDecode(temp[i]["ScanCode"]).cast<String>();
        log("My LogData ==> temp ${i}");
        log("My LogData ==> temp ${temp[i]["Creation_Type"]}");

        setState(() {
          int units = int.tryParse(temp[i]["Unit"]) ?? 0;
          int fake = int.tryParse(temp[i]["Fake"]) ?? 0;
          int warrentyAlreadyClaimed =
              int.tryParse(temp[i]["warrenty_already_claimed"]) ?? 0;
          int outOfWarenty = int.tryParse(temp[i]["out_of_warenty"]) ?? 0;
          int itemInWarenty = int.tryParse(temp[i]["item_in_warenty"]) ?? 0;

          Summary newSummary = Summary(
            fake: fake,
            warrentyAlreadyClaimed: warrentyAlreadyClaimed,
            outOfWarenty: outOfWarenty,
            itemInWarenty: itemInWarenty,
          );

          ReportData reportData = ReportData(
            itemCode: "${temp[i]['Product']}",
            // codesScanned: scanCodeList,
            units: units, // Assign the converted int value
            summary: newSummary,
          );
          widget.reportDataList.add(reportData);
          log("My LogData ==> Manul getReportData $reportData");
        });

        setState(() {});
        log("My LogData ==> buildList ${widget.reportDataList.length}");
      } else {
        scanCodeList = jsonDecode(temp[i]["ScanCode"]).cast<String>();
        log("My LogData ==> temp ${i}");
        log("My LogData ==> temp ${temp[i]["Creation_Type"]}");

        setState(() {
          int units = int.tryParse(temp[i]["Unit"]) ?? 0;
          int fake = int.tryParse(temp[i]["Fake"]) ?? 0;
          int warrentyAlreadyClaimed =
              int.tryParse(temp[i]["warrenty_already_claimed"]) ?? 0;
          int outOfWarenty = int.tryParse(temp[i]["out_of_warenty"]) ?? 0;
          int itemInWarenty = int.tryParse(temp[i]["item_in_warenty"]) ?? 0;

          Summary newSummary = Summary(
            fake: fake,
            warrentyAlreadyClaimed: warrentyAlreadyClaimed,
            outOfWarenty: outOfWarenty,
            itemInWarenty: itemInWarenty,
          );

          ReportData reportData = ReportData(
            itemCode: "${temp[i]['Product']}",
            codesScanned: scanCodeList,
            units: units, // Assign the converted int value
            summary: newSummary,
          );
          widget.reportDataList.add(reportData);
          log("My LogData ==> Manul getReportData $reportData");
        });

        setState(() {});
        log("My LogData ==> buildList ${widget.reportDataList.length}");
      }
      totalUnit = (int.tryParse(temp[i]["Unit"]) ?? 0) + totalUnit!;

      log("My LogData ==> total Unit $totalUnit");
    }
  }

  @override
  void initState() {
    widget.reportDataList.clear();
    getReportData();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    widget.reportDataList.clear();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("submit"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // userAssigned == null
                  //     ? SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.1,
                  //   child: TextFieldSearch(
                  //     decoration: InputDecoration(
                  //       labelText: Constants.searchUsers,
                  //       hintText: Constants.searchUsers,
                  //       prefixIcon: Icon(Icons.search),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(25.0),
                  //         ),
                  //       ),
                  //     ),
                  //     controller: myController,
                  //     label: 'Complex Future List',
                  //     future: () {
                  //       return fetchUsers();
                  //     },
                  //     getSelectedValue: (item) async {
                  //       setState(() {
                  //         userAssigned = item.email!;
                  //         auth.user?.userprofile?.reportingTo =
                  //             userAssigned;
                  //       });
                  //     },
                  //     minStringLength: 1,
                  //     itemsInView: 1,
                  //     textStyle: TextStyle(color: Colors.redAccent),
                  //   ),
                  // )
                  //     : Row(
                  //   children: [
                  //     SizedBox(
                  //       height: 20.0,
                  //       child: Text(
                  //         'Submit: ${userAssigned! ?? ""}',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 14.0,
                  //         ),
                  //       ),
                  //     ),
                  //     userType != 'servicetechnician'
                  //         ? IconButton(
                  //         onPressed: () {
                  //           setState(() {
                  //             userAssigned = null;
                  //             auth.user?.userprofile?.reportingTo =
                  //             null;
                  //           });
                  //         },
                  //         icon: Icon(
                  //           Icons.edit,
                  //           color: Colors.redAccent,
                  //         ))
                  //         : SizedBox.shrink()
                  //   ],
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.328,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    // height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.builder(
                      itemCount: widget.reportDataList.length,
                      itemBuilder: (BuildContext context, int index) {
                        log("My LogData ==> reportDataList ${widget.reportDataList.length}");
                        return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            subtitle: Text(
                              '${"fake"}: ${widget.reportDataList[index].summary?.fake ?? '0'}, Warranty In: ${widget.reportDataList[index].summary?.itemInWarenty ?? '0'}, Warranty Out: ${widget.reportDataList[index].summary?.outOfWarenty ?? '0'}, Scanned: ${widget.reportDataList[index].summary?.warrentyAlreadyClaimed ?? '0'}',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            title: Text(
                                "Code: ${widget.reportDataList[index].itemCode!}  Units: ${widget.reportDataList[index].units.toString()}"));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          // padding: EdgeInsets.all(8),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                if (value != null && value.isNotEmpty) {
                                  log("My LogData ==> noOfBoxController $value");
                                  box = int.parse(value);
                                  log("My LogData ==> box $box");
                                }
                              });
                            },
                            controller: noOfBoxController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFFEFE2E2),
                                  width: 1.0,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                borderSide: BorderSide(
                                  color: Color(0xFFFF3232),
                                  width: 1.0,
                                ),
                              ),
                              labelText: "noofBox",
                              // borderRadius: BorderRadius.all(
                              //   Radius.circular(10.0),
                              // ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              // Additional validation logic can be added here if needed
                              return null; // Return null if the input is valid
                            },
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 44,
                          // Adjust the height as needed
                          margin: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              // "Total Report: ${widget.reportDataList.length}",
                              "Total Units: ${totalUnit}",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "signature",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          control.clear();
                        },
                        icon: Icon(Icons.delete),
                      )
                    ],
                  ),
                  Center(
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints.expand(),
                            color: Colors.grey.shade300,
                            child: HandSignature(
                              control: control,
                              type: SignatureDrawType.shape,
                            ),
                          ),
                          CustomPaint(
                            painter: DebugSignaturePainterCP(
                              control: control,
                              cp: false,
                              cpStart: false,
                              cpEnd: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            noOfBoxController.text.isNotEmpty) {
                          // _showCommentDialog(context, auth);
                        } else {
                          log("My LogData ==> noOfBoxController Else");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('All Field Required !!!'),
                          ));
                        }
                      },
                      child: Text("submitReport"),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

}


//
// class SubmitManualReport extends ConsumerStatefulWidget {
//   SubmitManualReport({
//     required this.reportColId,
//     required this.partnerId,
//     required this.reportDataList,
//     required this.date,
//     Key? key,
//   }) : super(key: key);
//   final String reportColId;
//   final String partnerId;
//   final String date;
//   final List<ReportData> reportDataList;
//
//   @override
//   _SubmitManualReportState createState() => _SubmitManualReportState();
// }
//
// class _SubmitManualReportState extends ConsumerState<SubmitManualReport> {
//   final dbHelper = DatabaseHelper.instance;
//   TextEditingController myController = TextEditingController();
//   TextEditingController noOfBoxController = TextEditingController();
//   TextEditingController dateController = TextEditingController();
//   TextEditingController commentController = TextEditingController();
//   String? userEmail;
//   String userType = '';
//   int? box, totalUnit = 0;
//   bool loading = false, isSubmit = false;
//   TextEditingController userCtr = TextEditingController();
//   List<String> scanCodeList = [];
//   final _formKey = GlobalKey<FormState>();
//   final _formKeyComment = GlobalKey<FormState>();
//   Position? position;
//   Future<List<UserProfile>?> fetchUsers() async {
//     String user = myController.text;
//     return await ApiService().getUsers(user);
//   }
//
//   getLocationData() async {
//     await _handleLocationPermission();
//      setState(() async {
//      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
//      print("getLocationData $position");
//      });
//   }
//
//   getReportData() async {
//     getLocationData();
//     var temp = await dbHelper.getProductsByReportId(widget.reportColId);
//     print("My LogData ==> temp: $temp");
//
//     for (int i = 0; i < temp.length; i++) {
//       if (temp[i]["Creation_Type"] == "M") {
//         // scanCodeList = jsonDecode(temp[i]["ScanCode"]).cast<String>();
//         log("My LogData ==> temp ${i}");
//         log("My LogData ==> temp ${temp[i]["Creation_Type"]}");
//
//         setState(() {
//           int units = int.tryParse(temp[i]["Unit"]) ?? 0;
//           int fake = int.tryParse(temp[i]["Fake"]) ?? 0;
//           int warrentyAlreadyClaimed =
//               int.tryParse(temp[i]["warrenty_already_claimed"]) ?? 0;
//           int outOfWarenty = int.tryParse(temp[i]["out_of_warenty"]) ?? 0;
//           int itemInWarenty = int.tryParse(temp[i]["item_in_warenty"]) ?? 0;
//
//           Summary newSummary = Summary(
//             fake: fake,
//             warrentyAlreadyClaimed: warrentyAlreadyClaimed,
//             outOfWarenty: outOfWarenty,
//             itemInWarenty: itemInWarenty,
//           );
//
//           ReportData reportData = ReportData(
//             itemCode: "${temp[i]['Product']}",
//             // codesScanned: scanCodeList,
//             units: units, // Assign the converted int value
//             summary: newSummary,
//           );
//           widget.reportDataList.add(reportData);
//           log("My LogData ==> Manul getReportData $reportData");
//         });
//
//         setState(() {});
//         log("My LogData ==> buildList ${widget.reportDataList.length}");
//       } else {
//         scanCodeList = jsonDecode(temp[i]["ScanCode"]).cast<String>();
//         log("My LogData ==> temp ${i}");
//         log("My LogData ==> temp ${temp[i]["Creation_Type"]}");
//
//         setState(() {
//           int units = int.tryParse(temp[i]["Unit"]) ?? 0;
//           int fake = int.tryParse(temp[i]["Fake"]) ?? 0;
//           int warrentyAlreadyClaimed =
//               int.tryParse(temp[i]["warrenty_already_claimed"]) ?? 0;
//           int outOfWarenty = int.tryParse(temp[i]["out_of_warenty"]) ?? 0;
//           int itemInWarenty = int.tryParse(temp[i]["item_in_warenty"]) ?? 0;
//
//           Summary newSummary = Summary(
//             fake: fake,
//             warrentyAlreadyClaimed: warrentyAlreadyClaimed,
//             outOfWarenty: outOfWarenty,
//             itemInWarenty: itemInWarenty,
//           );
//
//           ReportData reportData = ReportData(
//             itemCode: "${temp[i]['Product']}",
//             codesScanned: scanCodeList,
//             units: units, // Assign the converted int value
//             summary: newSummary,
//           );
//           widget.reportDataList.add(reportData);
//           log("My LogData ==> Manul getReportData $reportData");
//         });
//
//         setState(() {});
//         log("My LogData ==> buildList ${widget.reportDataList.length}");
//       }
//       totalUnit = (int.tryParse(temp[i]["Unit"]) ?? 0) + totalUnit!;
//
//       log("My LogData ==> total Unit $totalUnit");
//     }
//   }
//
//   @override
//   void initState() {
//     widget.reportDataList.clear();
//     getReportData();
//
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     widget.reportDataList.clear();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     log("My LogData ==> SubmitManualReport ${widget.reportColId}");
//     log("My LogData ==> SubmitManualReport ${widget.partnerId}");
//     log("My LogData ==> SubmitManualReport ${widget.reportDataList}");
//     final auth = ref.watch(authNotifierProvider);
//     userType = auth.user!.userprofile!.userType!.toString();
//     String? userAssigned = auth.user?.userprofile?.reportingTo;
//
//     myController.selection = TextSelection.collapsed(offset: myController.text.length);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(Constants.submit),
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 // crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   userAssigned == null
//                       ? SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.1,
//                           child: TextFieldSearch(
//                             decoration: InputDecoration(
//                               labelText: Constants.searchUsers,
//                               hintText: Constants.searchUsers,
//                               prefixIcon: Icon(Icons.search),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(25.0),
//                                 ),
//                               ),
//                             ),
//                             controller: myController,
//                             label: 'Complex Future List',
//                             future: () {
//                               return fetchUsers();
//                             },
//                             getSelectedValue: (item) async {
//                               setState(() {
//                                 userAssigned = item.email!;
//                                 auth.user?.userprofile?.reportingTo =
//                                     userAssigned;
//                               });
//                             },
//                             minStringLength: 1,
//                             itemsInView: 1,
//                             textStyle: TextStyle(color: Colors.redAccent),
//                           ),
//                         )
//                       : Row(
//                           children: [
//                             SizedBox(
//                               height: 20.0,
//                               child: Text(
//                                 'Submit: ${userAssigned! ?? ""}',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14.0,
//                                 ),
//                               ),
//                             ),
//                             userType != 'servicetechnician'
//                                 ? IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         userAssigned = null;
//                                         auth.user?.userprofile?.reportingTo =
//                                             null;
//                                       });
//                                     },
//                                     icon: Icon(
//                                       Icons.edit,
//                                       color: Colors.redAccent,
//                                     ))
//                                 : SizedBox.shrink()
//                           ],
//                         ),
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.328,
//                     decoration: BoxDecoration(
//                       border: Border.all(),
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(12),
//                       ),
//                     ),
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 10.0,
//                       vertical: 4.0,
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 10.0,
//                     ),
//                     // height: MediaQuery.of(context).size.height * 0.8,
//                     child: ListView.builder(
//                       itemCount: widget.reportDataList.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         log("My LogData ==> reportDataList ${widget.reportDataList.length}");
//                         return ListTile(
//                             contentPadding: EdgeInsets.all(0),
//                             subtitle: Text(
//                               '${Constants.fake}: ${widget.reportDataList[index].summary?.fake ?? '0'}, Warranty In: ${widget.reportDataList[index].summary?.itemInWarenty ?? '0'}, Warranty Out: ${widget.reportDataList[index].summary?.outOfWarenty ?? '0'}, Scanned: ${widget.reportDataList[index].summary?.warrentyAlreadyClaimed ?? '0'}',
//                               style: TextStyle(
//                                 fontSize: 12,
//                               ),
//                             ),
//                             title: Text(
//                                 "Code: ${widget.reportDataList[index].itemCode!}  Units: ${widget.reportDataList[index].units.toString()}"));
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Form(
//                     key: _formKey,
//                     child: Row(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                             horizontal: 10.0,
//                             vertical: 4.0,
//                           ),
//                           width: MediaQuery.of(context).size.width * 0.5,
//                           // padding: EdgeInsets.all(8),
//                           child: TextFormField(
//                             onChanged: (value) {
//                               setState(() {
//                                 if (value != null && value.isNotEmpty) {
//                                   log("My LogData ==> noOfBoxController $value");
//                                   box = int.parse(value);
//                                   log("My LogData ==> box $box");
//                                 }
//                               });
//                             },
//                             controller: noOfBoxController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.all(8),
//
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   10,
//                                 ),
//                                 borderSide: BorderSide(
//                                   color: Color(0xFFEFE2E2),
//                                   width: 1.0,
//                                 ),
//                               ),
//
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   10,
//                                 ),
//                                 borderSide: BorderSide(
//                                   color: Color(0xFFFF3232),
//                                   width: 1.0,
//                                 ),
//                               ),
//                               labelText: Constants.noofBox,
//                               // borderRadius: BorderRadius.all(
//                               //   Radius.circular(10.0),
//                               // ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter a value';
//                               }
//                               // Additional validation logic can be added here if needed
//                               return null; // Return null if the input is valid
//                             },
//                           ),
//                         ),
//                         Expanded(child: Container()),
//                         Container(
//                           height: 44,
//                           // Adjust the height as needed
//                           margin: EdgeInsets.symmetric(
//                             horizontal: 10.0,
//                             vertical: 4.0,
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16.0,
//                             vertical: 10.0,
//                           ),
//
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey,
//                               width: 1.0,
//                             ),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               // "Total Report: ${widget.reportDataList.length}",
//                               "Total Units: ${totalUnit}",
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         Constants.signature,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14.0,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           control.clear();
//                         },
//                         icon: Icon(Icons.delete),
//                       )
//                     ],
//                   ),
//                   Center(
//                     child: AspectRatio(
//                       aspectRatio: 2,
//                       child: Stack(
//                         children: <Widget>[
//                           Container(
//                             constraints: BoxConstraints.expand(),
//                             color: Colors.grey.shade300,
//                             child: HandSignature(
//                               control: control,
//                               type: SignatureDrawType.shape,
//                             ),
//                           ),
//                           CustomPaint(
//                             painter: DebugSignaturePainterCP(
//                               control: control,
//                               cp: false,
//                               cpStart: false,
//                               cpEnd: false,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState!.validate() &&
//                             noOfBoxController.text.isNotEmpty) {
//                           _showCommentDialog(context, auth);
//                         } else {
//                           log("My LogData ==> noOfBoxController Else");
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text('All Field Required !!!'),
//                           ));
//                         }
//                       },
//                       child: Text("submitReport"),
//                     ),
//                   ),
//                 ],
//               ),
//             )),
//       ),
//     );
//   }
//
//   void _showCommentDialog(BuildContext context, auth) {
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false, // User must tap button!
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Add comment'),
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: <Widget>[
//                     SizedBox(
//                       child: Form(
//                         key: _formKeyComment,
//                         child: TextFormField(
//                           controller: commentController,
//                           maxLines: null,
//                           decoration: InputDecoration(
//                             labelText: 'Comment',
//                             border: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color:
//                                     Colors.black, // Border color when focused
//                               ),
//                             ),
//                             errorBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors
//                                     .red, // Border color when error occurs
//                               ),
//                             ),
//                             focusedErrorBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors
//                                     .red, // Border color when focused with error
//                               ),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your Comment';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     commentController.clear();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Cancel'),
//                 ),
//                TextButton(
//                   onPressed: () async {
//                     if (isSubmit == false) {
//                       if (_formKeyComment.currentState!.validate()) {
//                         if (commentController.text.isNotEmpty) {
//                           try {
//
//                             setState((){
//                               isSubmit = true;
//                             });
//                             List<UserProfile>? users = await fetchUsers();
//
//                             if (auth.user?.userprofile?.userType ==
//                                     'servicetechnician' &&
//                                 users != null &&
//                                 widget.reportDataList.isNotEmpty) {
//                               log("position $position");
//                               if(position == null) {
//                                 final hasPermission = await _handleLocationPermission();
//                                 log(
//                                     "My LogData ==> hasPermission $hasPermission");
//                                 if (!hasPermission) return;
//                                 // loading=true;
//
//                                 position =
//                                 await Geolocator.getCurrentPosition(
//                                   desiredAccuracy: LocationAccuracy.high,
//                                 );
//                                 log(
//                                     "My LogData ==> position Manual Report  $position");
//                               }
//                               try {
//                                 for (int i = 0;
//                                     i < widget.reportDataList.length;
//                                     i++) {
//                                   log("My LogData ==> reportDataList codesScanned ${widget.reportDataList[i].codesScanned}");
//                                   widget.reportDataList[i].dealerApproval =
//                                       true;
//                                   log("My LogData ==> reportDataList codesScanned ${widget.reportDataList[i].codesScanned}");
//                                 }
//                                 log("My LogData ==> fillManualReport noOfBoxController ${box}");
//                                 ReportCreationSuccess? success =
//                                     await ApiService().fillManualReport(
//                                         widget.reportColId,
//                                         widget.reportDataList,
//                                         box ?? 0,
//                                         widget.date,
//                                         commentController.text,
//                                         position!);
//
//                                 if (success != null) {
//                                   await dbHelper.deleteReportAndData(
//                                       widget.reportColId, widget.partnerId);
//
//                                   Widget okButton = TextButton(
//                                     child: Text("OK"),
//                                     onPressed: () async {
//                                       control.clear();
//                                       Navigator.of(context)
//                                           .pushNamedAndRemoveUntil(
//                                         '/auth',
//                                         (Route<dynamic> route) => false,
//                                       );
//                                     },
//                                   );
//
//                                   AlertDialog alert = AlertDialog(
//                                     title: Text("Success"),
//                                     content:
//                                         Text("Report submitted successfully."),
//                                     actions: [
//                                       okButton,
//                                     ],
//                                   );
//
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return alert;
//                                     },
//                                   );
//                                 }
//                               } catch (e) {
//                                 setState(() {
//                                   isSubmit = false;
//                                 });
//                                 log("My LogData ==> catch ${e.toString()}");
//                                 final snackBar = SnackBar(
//                                   content: Text(e.toString()),
//                                   action: SnackBarAction(
//                                     label: Constants.error,
//                                     onPressed: () {
//                                       // Some code to undo the change.
//                                     },
//                                   ),
//                                 );
//
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(snackBar);
//                               }
//                             } else {
//                               setState(() {
//                                 isSubmit = false;
//                               });
//                               String message = 'No fields can be empty';
//                               if (auth.user?.userprofile?.userType !=
//                                   'servicetechnician') {
//                                 message = Constants.serviceTechnicianAccessOnly;
//                               }
//                               final snackBar = SnackBar(
//                                 content: Text(message),
//                                 action: SnackBarAction(
//                                   label: Constants.error,
//                                   onPressed: () {
//                                     // Some code to undo the change.
//                                   },
//                                 ),
//                               );
//
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(snackBar);
//                             }
//                           } catch (e) {
//                             setState(() {
//                               isSubmit = false;
//                             });
//                             final snackBar = SnackBar(
//                               content: Text(e.toString()),
//                               action: SnackBarAction(
//                                 label: Constants.error,
//                                 onPressed: () {
//                                   // Some code to undo the change.
//                                 },
//                               ),
//                             );
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(snackBar);
//                           }
//                         }
//                       }
//                     } else {
//                       final snackBar = SnackBar(
//                         content: Text("Please Wait Report is Submit."),
//                         action: SnackBarAction(
//                           label: Constants.error,
//                           onPressed: () {
//                             // Some code to undo the change.
//                           },
//                         ),
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                     }
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text(Constants.locationPermissionDenied)),
//         );
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text(Constants.locationPermanentDenied)),
//       );
//       return false;
//     }
//     return true;
//   }
// }
//
// HandSignatureControl control = new HandSignatureControl(
//   threshold: 0.01,
//   smoothRatio: 0.65,
//   velocityRange: 2.0,
// );
