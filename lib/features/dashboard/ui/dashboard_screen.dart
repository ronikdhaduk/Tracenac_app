import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tracenac/core/utils/app_color.dart';
import 'package:tracenac/features/dashboard/ui/second_bottom_screen.dart';
import 'package:tracenac/features/dashboard/ui/third_bottom_screen.dart';
import '../../Assign_Task/AssignTask.dart';
import 'first_bottom_screen.dart';
import 'fourth_bottom_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> screen = [
    FirstBottomScreen(),
    SecondBottomScreen(),
    ThirdBottomScreen(),
    Assigntask(),
    // FourthBottomScreen(),
  ];

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text(
          'Exit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: const Text(
          'Do you want to exit the app?',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontFamily: "Onest",
                        color: AppColor.appBarColor),
                  )),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColor.appBarColor,
                    foregroundColor: Colors.white
                    // backgroundColor: Colors.green.shade100,
                  ),
                  onPressed: () {
                    if(Platform.isAndroid){
                      SystemNavigator.pop() ;
                    }else{
                      exit(0) ;
                    }
                  },
                  child: const Text(
                    "Exit",
                    style: TextStyle(
                        fontFamily: "Onest",),
                  )),
            ],
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: buildMyNavBar(context),
        body: screen[_currentIndex],
      ),
    );
  }
  buildMyNavBar(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavItem(
                  icon: 'assets/images/home.png',
                  iconSelcted: 'assets/images/home.png',
                  index: 0,
                  label: 'Home',
                ),
                buildNavItem(
                  icon: 'assets/images/search.png',
                  iconSelcted: 'assets/images/search.png',
                  index: 1,
                  label: 'Search',
                ),
                buildNavItem(
                  icon: 'assets/images/tools.png',
                  iconSelcted: 'assets/images/tools.png',
                  index: 2,
                  label: 'Tools',
                ),
                buildNavItem(
                  icon: 'assets/images/library1.png',
                  iconSelcted: 'assets/images/library1.png',
                  index: 3,
                  label: 'Task',
                ),
                // buildNavItem(
                //   icon: 'images/bottom_4.png',
                //   iconSelcted: 'images/bottom_selected_4.png',
                //   index: 4,
                //   label: 'Profile',
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(
      {required String icon,
        required String iconSelcted,
        required int index,
        required String label}) {
    bool isSelected = _currentIndex == index;
    String iconColor = isSelected ? iconSelcted : icon;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index ;

          // if (index == 3) {
          //   _showPopupNearFAB(context);
          // } else {
          //   _bottomBarScreenController.pageIndex.value = index;
          // }
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 4),
            child: Image.asset(iconColor, height: 20, width: 20, color: isSelected ? Colors.blue : Colors.black),
          ),
          Container(
            decoration: isSelected
                ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black, width: 2.0),
              ),
            )
                : null,
          ),
          Text(label, style: TextStyle(color: isSelected ? Colors.blue :
          Colors.black, fontFamily: "Proxima",),)
        ],
      ),
    );
  }
}

