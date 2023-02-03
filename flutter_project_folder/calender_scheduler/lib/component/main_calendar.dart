import "package:calender_scheduler/const/colors.dart";
import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";

// 화면 윗부분에 보여지는 달력 화면
class MainCalendar extends StatelessWidget{
  final OnDaySelected onDaySelceted; // 날짜 선택시 실행할 함수
  final DateTime selectedDate; // 선택된 날짜


  const MainCalendar({
    required this.onDaySelceted,
    required this.selectedDate,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TableCalendar(
      onDaySelected: onDaySelceted, // 달력의 날짜가 탭될 때마다 실행되는 함수
      selectedDayPredicate: (date)=> // 선택된 날짜를 구분할 로직
      date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day,
      firstDay: DateTime(1800, 1, 1), // 첫째 날
      lastDay: DateTime(3000, 1, 1),// 마지막 날
      focusedDay: DateTime.now(), // 화면에 보여지는 날
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0
        )
      ),
      calendarStyle: CalendarStyle(
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,

          // borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0
          )
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR
        )
      ),
    );
  }
}