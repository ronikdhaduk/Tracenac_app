import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tracenac/core/APIClass/APIClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AssignTaskModelClass.dart';


class Assigntask extends StatefulWidget {
  const Assigntask({super.key});

  @override
  State<Assigntask> createState() => _AssigntaskState();
}

class _AssigntaskState extends State<Assigntask> {

  DateTime now = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? firstDateOfMonth;
  DateTime? lastDateOfMonth;
  AssignTaskMsg? _tasks ;
  Map<DateTime, List<String>> events = {};
  Map<DateTime, List> _mark = {};
  AssignTaskModelClass? assignTask;
  bool isLoading=true;


  @override
  void initState() {
    super.initState();
    getDateTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getDateTime(){
     firstDateOfMonth = DateTime(now.year, now.month, 1);
    lastDateOfMonth = DateTime(now.year, now.month + 1, 0);
    fetchTasks();

  }

  Future<void> fetchTasks() async {
    try{
      String formattedStartDate = DateFormat('dd-MM-yyyy').format(firstDateOfMonth!);
      String formattedEndDate = DateFormat('dd-MM-yyyy').format(lastDateOfMonth!);

      print("My LogData ==> assignTask $firstDateOfMonth");
      assignTask = await APIClass().getAssignTask(formattedStartDate, formattedEndDate);

      if ( assignTask?.assignTaskMsgmsg != null) {
        assignTask?.assignTaskMsgmsg?.forEach((event) {
          log("My LogData ==> _formatDate if ${event.dateOfVisit}");
          DateTime eventDate = DateTime.parse(_formatDate("${event.dateOfVisit}"));
          if (!events.containsKey(eventDate)) {
            events[eventDate] = [];
          }
          events[eventDate]?.add("${event.partnerData?.partnerName}");
        });
      }
      setState(() {
        isLoading = false;
      });
    }catch(e){
      setState(() {
        isLoading = false;
      });
      log("fetchTasks===> $e");
    }finally{
      setState(() {
        isLoading = false;
      });
    }




  }
   _formatDate(String date) {
    log("My LogData ==> _formatDate $date");
    List<String> parts = date.split('/');
    if (parts.length == 3) {
      // Assuming that the year is given as a two-digit year (e.g., "04" for 2004)
      String year = '${parts[2]}';
      String month = parts[1];
      String day = parts[0];

      // Construct a valid date string in the format "yyyy-MM-dd"
      String formattedDate = "$year-$month-$day";

      log("My LogData ==> parts _formatDate $formattedDate");
      return formattedDate;
    }


  }


  Map<DateTime, List<AssignTaskMsg>> _groupTasksByDate(List<AssignTaskMsg> tasks) {
    Map<DateTime, List<AssignTaskMsg>> groupedTasks = {};
    log("My LogData ==> _groupTasksByDate 1 ${tasks}");

    for (var task in tasks) {
      log("My LogData ==> _groupTasksByDate 1-1 ${task}");
      // DateTime date = DateTime(task.date.year, task.date.month, task.date.day);
      DateTime date = DateTime(task.dateOfVisit as int);
      log("My LogData ==> _groupTasksByDate 1-2 ${task.dateOfVisit}");
      log("My LogData ==> _groupTasksByDate 2-1 ${groupedTasks[date]}");

      if (groupedTasks[date] != null) {
        log("My LogData ==> _groupTasksByDate 2 ==> ${groupedTasks[date]?.length} ${task.dateOfVisit}, ${task.partnerData?.partnerName}");

        groupedTasks[date]!.add(task);

      } else {
        log("My LogData ==> groupedTasks 3-1 ${groupedTasks[date]} task ${task.dateOfVisit}");
        groupedTasks[date] = [task];
        log("My LogData ==> groupedTasks 3-2 ${groupedTasks}");
      }
    }
    log("My LogData ==> groupedTasks 3 ${groupedTasks.length}");

    return groupedTasks;
  }

  void _selectMonth(int? month) {
    if (month != null) {
      setState(() {
        isLoading=true;
        _selectedDay = DateTime(_selectedDay.year, month, _selectedDay.day);
        _focusedDay = _selectedDay;
        firstDateOfMonth = DateTime(_selectedDay.year, _selectedDay.month, 1);
        lastDateOfMonth = DateTime(_selectedDay.year, _selectedDay.month + 1, 0);
      });
      fetchTasks();
    }
  }

  void _selectYear(int? year) {
    if (year != null) {
      setState(() {
        isLoading=true;
        _selectedDay = DateTime(year, _selectedDay.month, _selectedDay.day);
        _focusedDay = _selectedDay;
        firstDateOfMonth = DateTime(_selectedDay.year, _selectedDay.month, 1);
        lastDateOfMonth = DateTime(_selectedDay.year, _selectedDay.month + 1, 0);
      });
      fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monthly Task"),
      ),
      body :
      isLoading ? Center(child: CircularProgressIndicator(),):

      AssignTaskModelClass().status != false ? Center(child: Text("User not "
          "found")) :
      SingleChildScrollView(
           child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton<int>(
                        value: _selectedDay.month,
                        onChanged: _selectMonth,
                        items: List.generate(12, (index) {
                          final month = index + 1;
                          return DropdownMenuItem<int>(
                            value: month,
                            child: Text(month.toString()),
                          );
                        }),
                      ),
                      SizedBox(
                        width: 30,
                      ),

                      DropdownButton<int>(
                        value: _selectedDay.year,
                        onChanged: _selectYear,
                        items: List.generate(10, (index) {
                          final year = DateTime.now().year - 5 + index;
                          return DropdownMenuItem<int>(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }),
                      ),
                    ],
                  ),
                  TableCalendar(

                    calendarFormat: CalendarFormat.month,
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    headerStyle:
                    HeaderStyle(formatButtonVisible: false, titleCentered: true),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        log("My LogData ==> Change onDaySelected");
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay ?? selectedDay;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      if (focusedDay != null) {
                        log("My LogData ==> Change onPageChanged $focusedDay");
                        if (!focusedDay.isAfter(_focusedDay)) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        }
                        int month = focusedDay.month;
                    // _selectMonth(month);
                        print("Month: $month");
                          // fetchTasks();
                      }
                    },

                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.red, // Choose the color for the "today" date
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      markerMargin: EdgeInsets.symmetric(horizontal: 2),
                      markerSizeScale: 0.2,
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, event) {
                        final selectedTasks = events[DateTime(
                          day.year,
                          day.month,
                          day.day,
                        )];

                        if (selectedTasks != null && selectedTasks.isNotEmpty) {
                          // Create a set to store unique 'assign' values
                          final uniqueAssignValues = Set<String>();

                          // Iterate through the tasks to find unique 'assign' values
                          for (final task in selectedTasks) {
                            uniqueAssignValues.add(task);
                          }

                          return Positioned(
                            bottom: 5,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue, // Choose the color of the dot
                              ),
                            ),
                          );
                        }

                        return Container();
                      },
                    ),


                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Tasks:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // SizedBox(height: 10),
                  Container(
                      height: MediaQuery.of(context).size.height*0.75,
                      child: _buildTaskList()),
                ],
              ),
         ),




    );
  }

  Widget _buildTaskList() {
  log("My LogData ==> _selectedDay ${assignTask!.assignTaskMsgmsg?.length}");


  List<AssignTaskMsg> tasksForSelectedDate = assignTask!.assignTaskMsgmsg!
      .where((task) {
    DateTime taskDate = DateTime.parse(_formatDate(task.dateOfVisit!));
    log("My LogData ==> _formatDate tasksForSelectedDate");
    return taskDate.year == _selectedDay.year &&
        taskDate.month == _selectedDay.month &&
        taskDate.day == _selectedDay.day;
  })
      .toList();

// Initialize empty lists for latitudes and longitudes
    List<double?> latList = [];
    List<double?> longList = [];

// Add latitudes and longitudes to the lists if they are present in the API response, otherwise set to null
    tasksForSelectedDate.forEach((task) {
      double? lat = double.tryParse(task.partnerData?.lat ?? '');
      double? long = double.tryParse(task.partnerData?.long ?? '');

      if (lat != null && long != null) {
        latList.add(lat);
        longList.add(long);
      } else {
        latList.add(null);
        longList.add(null);
      }
    });


    // log("My LogData ==> tasksForSelectedDate ${tasksForSelectedDate[0].dateOfVisit}");
    if (tasksForSelectedDate.isEmpty) {
      return Center(child: Text('No tasks for this date.'));
    }

    return ListView.builder(
      itemCount: tasksForSelectedDate.length,
      itemBuilder: (context, index) {
        var task =tasksForSelectedDate[index].partnerData;
        log("My LogData ==> ListView.builder ${tasksForSelectedDate.length}");
        return Container(
            margin: EdgeInsets.only(top: 10.0,),
            // padding: EdgeInsets.all(8.0),
            color: Colors.grey,
            child:
            ListTile(title: Text("${task?.partnerName}"),subtitle: Text("${task?.partnerId}"),
              trailing: IconButton(onPressed: () async {
                setState(() {
                  if(task?.lat != null && task?.long != null ){

                  double lat = double.parse("${task?.lat}");
                  double long = double.parse("${task?.long}");
                  log("My LogData ==> IconButton $lat");
                  log("My LogData ==> IconButton $long");
                  openMap(lat, long);
                  } else{
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                            'Lat & Long Not Found'),
                      ),
                    );
                  }
                });
              },
                icon: Icon(Icons.pin_drop,color: task?.lat != null && task?.long != null ? Colors.red: Colors.white70),),

            )
            /*Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${task?.partnerName}"),
                Text("${task?.partnerId}"),


              ],)*/
        );
      },
    );
  }
  void openMap(double lat, double long) async {
    // String url = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    String url = "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch the map.");
    }
  }

}

