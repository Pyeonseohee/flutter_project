import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:vid_player/component/custom_video_player.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  XFile? video; // 동영상을 저장할 변수 ?는 null값이 들어갈 수도 있다는 뜻! ?를 안 붙이면 null 못들어감.

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(), // decoration 매개변수에 들어갈 BoxContainer값을 getBoxDecoration() 함수에서 구현함.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          SizedBox(height: 30.0),
          _AppName()
        ]
      )
    );
  }

  Widget renderVideo(){
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewVideoPressed: onNewVideoPressed
      ),
    );
  }

  void onNewVideoPressed() async{ // 동영상 선택하는 기능을 구현한 함수
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery
      );

    if(video != null){
      setState((){
        this.video = video;
      });
    }
}
  BoxDecoration getBoxDecoration(){
    return BoxDecoration(
      gradient: LinearGradient( // 그라데이션으로 색상 적용하기
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ]
      )
    );
  }
}
class _Logo extends StatelessWidget{
  final GestureTapCallback onTap; // 탭했을 때 실행할 함수

  const _Logo({
    required this.onTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap, // 상위 위젯으로부터 탭 콜백받기
      child: Image.asset("asset/img/logo.png")
    );// 로고 이미지
  }
}

class _AppName extends StatelessWidget{ // 앱 제목을 보여줄 위젯
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300
    );
    
    return Row(
    mainAxisAlignment: MainAxisAlignment.center, // 글자 가운데 정렬
    children: [
      Text("VIDEO", style: textStyle),
      Text("PLAYER", style: textStyle.copyWith(fontWeight: FontWeight.w700)) //textStyle에서 fontWeight만 변경
    ]
    );
  }
}