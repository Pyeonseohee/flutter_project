import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "dart:async"; // Timer를 사용할 수 있는 패키지

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  // pageController 생성 -> PageView 제어할 수 있음.
  final PageController pageController = PageController();

  // initState()를 override하면 StatefulWidget 생명주기에서의 initState() 함수를 사용할 수 있음.
  @override
  void initState() {
    // 모든 initState() 함수는 부모의 initState() 함수를 실행해줘야 함.
    super.initState();

    try {
      Timer.periodic(Duration(seconds: 3),
              (timer) {
        // PageController의 page게터를 사용해 PageView의 현재 페이지를 가져올 수 있음.
        // 페이지가 넘어가는 중에는 double로 반환이 되기 때문에 int로 바꿔줘야함.
        int? nextPage = pageController.page?.toInt();
        if(nextPage == null){
          return ;
        }

        // 첫 페이지와 마지막 페이지 분기 처리
        if(nextPage == 3){
          nextPage = 0;
        }else{
          nextPage++;
        }
        // PageController의 animateToPage() 함수를 이용해 PageView의 현재 페이지를 변경할 수 있음
        // 매개변수: 이동할 페이지(정수), 이동할 때 소요될 시간, 페이지가 변경되는 애니메이션의 작동 방식
        pageController.animateToPage(
          nextPage, duration: Duration(milliseconds: 500), curve: Curves.ease
        );
              }
      );
    } catch (e, s) {
      print(s);
    }
  }

  @override
  Widget build(BuildContext context){
    // SystemChrome 클래스는 시스템 UI의 그래픽 설정을 변경하는 기능 제공
    // setSystemUIOverlayStyle은 상태바 색상 변경.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        body: PageView(
          controller: pageController, // controller 등록
          // map() 함수 이용해 이미지 추가하기 / fit은 이미지의 핏을 조절하는 매개변수
          children: [
            Image.network("https://cdn.famtimes.co.kr/news/photo/202012/502141_3167_2850.png"),
            Image.network("http://image.dongascience.com/Photo/2019/12/fb4f7da04758d289a466f81478f5f488.jpg"),
            Image.network("https://m.petinzooshop.com/web/product/big/202112/3c09f75d145aa0273761c90ab4e02f32.jpg"),
            Image.network("http://storage.enuri.info/pic_upload/knowbox/mobile_img/202105/2021050709502274196.jpg")
          ]
        ),
    );
  }
}