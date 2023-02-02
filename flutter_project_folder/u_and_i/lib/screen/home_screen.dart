import "package:flutter/material.dart";
import "package:flutter/cupertino.dart"; // 쿠퍼티노 iOS 위젯 사용하기 위해 필요.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.pink[100], // 배경색 적용
      body: SafeArea( // 시스템 UI 피해서 UI 그리기
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 위아래 끝에 위젯 배치
          crossAxisAlignment: CrossAxisAlignment.stretch, // 반대축 최대 크기로 늘리기
          children:[
            _Dday(
              onHeartPressed: onHeartPressed,
              firstDay: firstDay, // _HomeScreenState의 firstDay 변수값을 매개변수로 넘겨줌.
            ),
            _CoupleImage()
          ]
        )
      )
    );
  }

  void onHeartPressed(){
    showCupertinoDialog( // 쿠퍼티노 다이얼로그 실행
      context: context, // 보여줄 다이얼로그 빌드
      builder: (BuildContext context){
        return Align( // 정렬을 지정하는 위젯
          alignment: Alignment.bottomCenter, // 아래 중간으로 정렬
          child: Container(
            color: Colors.white, // 배경색
            height: 300, // 높이
            child: CupertinoDatePicker( // 정해진 날짜 값을 입력받아 onDateTimeChanged 콜백함수의 매개변수로 전달해줌.
              mode: CupertinoDatePickerMode.date,
              // 날짜가 변경되면 실행되는 함수
              onDateTimeChanged: (DateTime date){
                setState((){
                  firstDay = date;
                });
              },
            )
          )
        );
      },
      barrierDismissible: true // 외부 탭할 경우 다이얼로그 안보이게
    );
  }
}

class _Dday extends StatelessWidget{
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  _Dday({
    required this.onHeartPressed,
    required this.firstDay, // firstDay 변수의 값을 생성자의 매개변수로 외부에서 입력받도록 정의한다.
  });

  @override
  Widget build(BuildContext context){
    // 테마 불러오기
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Text("U&I",
          style: textTheme.headline1),
        const SizedBox(height: 16.0),
        Text("우리 처음 만난 날",
            style: textTheme.bodyText1),
        Text("${firstDay.year}.${firstDay.month}.${firstDay.day}",
            style: textTheme.bodyText2),
        const SizedBox(height: 16.0),
        IconButton(
          iconSize: 60.0,
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite,
          color: Colors.red),
        ),
        const SizedBox(height: 16.0),
        Text(((){
    if(DateTime(now.year, now.month, now.day).difference(firstDay).inDays >= 0)
     return "D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}";
    else
     return "D${DateTime(now.year, now.month, now.day).difference(firstDay).inDays}";
    })())

      ]
    );
  }
}

class _CoupleImage extends StatelessWidget{
  // 밑에서 이미지를 반만 차지하게 했는데 위에서 배치한 위젯들의 사이즈가 이미 화면의 반이 넘는다면?
  // 플러터에서 overflow가 일어남!! 이때 해결 방법은
  // 1. 글자나 이미지의 크기를 임의로 조절하여 남는 공간만큼만 차지하도록 하는 방법
  // 2. Expanded 위젯을 이용해 우선 순위를 갖게하여 없애는 방법.
  @override
  Widget build(BuildContext context){
    return Expanded(
      // Expanded가 우선순위를 갖게 되어 무시됨. 크기가 작아짐. -> 오버플로우 영역이 사라짐.
        child: Center( // 이미지 중앙정렬
          child: Image.asset("asset/img/middle_image.png",
          // 화면의 반만큼 높이 구현
          // size게터를 불러와 화면 전체의 너비와 높이를 쉽게 가져올 수 있음.
            height: MediaQuery.of(context).size.height / 2,
          )
        )
    );
  }
}