import "package:flutter/material.dart";
import "package:random_dice/screen/home_screen.dart";
import "package:random_dice/screen/settings_screen.dart";
import "dart:math";
import "package:shake/shake.dart";

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller; // 사용할 controller
  double threshold = 2.7; // 민감도의 기본값 설정
  int number = 1; // 주사위 숫자 기본값 설정
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();

    void onPhoneShake(){
      final rand = new Random(); // math 패키지의 Random 클래스 이용
      setState((){
        // nextInt() 함수는 최대 int값을 넣어주면 그 사이 난수 생성(여기서는 0~5까지)
        number = rand.nextInt(5) + 1;
      });
    }

    tabListener() { // 리스너로 사용할 함수
      setState(() {});
    }

    controller = TabController(length: 2, vsync: this); // 컨트롤러 초기화하기 length는 탭 개수를 int값으로.
    shakeDetector = ShakeDetector.autoStart( // 흔들기 감지 즉시 시작
      shakeSlopTimeMS: 100, // 감지 주기(period)
      shakeThresholdGravity: threshold, //감지 민감도
      onPhoneShake: onPhoneShake, // 감지 후 실행할 함수
    );

    @override
    dispose() {
      controller!.removeListener(tabListener); // 리스너에 등록한 함수 등록 취소
      shakeDetector!.stopListening(); // 흔들기 감지 중지
      super.dispose();
    }

    // 컨트롤러 속성이 변경될 때마다 실행할 함수 등록
    controller!.addListener(tabListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView( // 탭 화면을 보여줄 위젯
        controller: controller, // 컨트롤러 등록하기
        children: renderChildren(),
      ),
      // 아래 탭 내비게이션을 구현하는 매개변수
      bottomNavigationBar: renderBottomNavigation(),
    );
  }


  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingsScreen(
        threshold: threshold,
        onThresholdChange: onThresholdChange,
      )
    ];
  }

  // 슬라이더 값 변경 시 실행 함수
  void onThresholdChange(double val){
    setState((){ // 2. 다시 build하여 화면에 보여줌.
      threshold = val; // 1. 변경된 threshold값을 기반으로
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    // 탭 네비게이션을 구현하는 위젯
    return BottomNavigationBar(
        currentIndex: controller!.index, // 현재화면의 렌더링되는 탭의 인덱스
        onTap: (int index) { // 탭이 선택될 때마다 실행되는 함수
          setState(() {
            controller!.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edgesensor_high_outlined,
            ),
            label: "주사위",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "설정",
          )
        ]);
  }
}