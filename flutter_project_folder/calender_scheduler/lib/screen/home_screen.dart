import "package:calender_scheduler/component/main_calendar.dart";
import "package:flutter/material.dart";
import "package:calender_scheduler/const/colors.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime selectedDate = DateTime.utc( // 선택될 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelceted: onDaySelected,
            ),
          ]
        )
      )
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate){
    setState((){
      this.selectedDate = selectedDate;
    });
  }
}