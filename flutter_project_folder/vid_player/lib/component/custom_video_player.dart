import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:video_player/video_player.dart";
import "package:vid_player/component/custom_icon_button.dart";
import "dart:io"; // 파일 관련 작업 패키지

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget{
  final XFile video; // 선택한 동영상을 저장할 변수
  final GestureTapCallback onNewVideoPressed; // 새로운 동영상을 선택하면 실행되는 함수

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key}) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayer();
}

class _CustomVideoPlayer extends State<CustomVideoPlayer>{
  bool showControls = false; // 동영상 조작하는 아이콘을 보일지 여부
  VideoPlayerController? videoController; // 동영상을 조작하는 컨트롤러

  // videoController를 initState에서 초기화했기 때문에 동영상을 새로 선택해도 영상이 바뀌지 않음.
  // 따라서 새로운 생명주기인 didUpdateWidget() 함수를 사용해서 새로운 동영상이 선택되었을 때
  // videoController를 새로 생성해야함. 여기서 oldWidget은 폐기될 위젯.
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget){
    super.didUpdateWidget(oldWidget);

    // 새로 선택한 동영상이 같은 동영상인지 확인
    // 다르다면 initializeController() 함수를 재실행해서 videoController 변수를 재생성
    if(oldWidget.video.path != widget.video.path){
      initializeController();
    }
  }
  @override
  void initState(){
    super.initState();

    initializeController(); // 컨트롤러 초기화
  }

  initializeController() async{ // 선택한 동영상으로 컨트롤러 초기화
    final videoController = VideoPlayerController.file(
      File(widget.video.path)
    );

    await videoController.initialize(); // 에러가 없이 동영상을 재생할 수 있는 상태이면 setState()로 넘어감.

    // 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록
    videoController.addListener(videoControllerListener);

    setState((){
      this.videoController = videoController;
    });
  }

  void videoControllerListener(){
    setState((){});
  }

  @override
  void dispose(){
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    // 동영상 컨트롤러가 준비중일 때 로딩 표시
    if(videoController == null){
      return Center(
        child: CircularProgressIndicator()
      );
    }

    return GestureDetector( // 화면 전체의 탭을 인식하기 위해 사용
      onTap: (){
        setState((){
          showControls = !showControls;
        });
      },
      child: AspectRatio( // 동영상 비율에 따른 화면 렌더링
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack( // children 위젯을 위로 쌓을 수 있는 위젯 (아래부터 쌓아 올림)
          children: [
            VideoPlayer(
              videoController!
            ),
            if(showControls)
              Container(color: Colors.black.withOpacity(0.5)), // 아이콘 버튼이 보일 때 화면을 어둡게 변경
              Positioned( // child 위젯의 위치를 정할 수 있는 위젯
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                        videoController!.value.position
                      ),
                      Expanded(
                        child: Slider(
                          onChanged: (double val){
                            videoController!.seekTo(
                              Duration(seconds: val.toInt())
                            );
                          },
                            value: videoController!.value.position.inSeconds.toDouble(),
                            min: 0,
                            max: videoController!.value.duration.inSeconds.toDouble()
                        )
                      ),
                      renderTimeTextFromDuration(
                        videoController!.value.duration,
                      ),

                    ]
                  )
                )
              ),
            if(showControls) // showControls가 true일때만 아이콘 보여주기
              Align( // 오른쪽 위에 새 동영상 아이콘 위치
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back
                ),

              ),
            if(showControls)
              Align( // 동영상 재생 관련 아이콘 중앙에 위치
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 각 간격을 동일하게
                  children: [
                    CustomIconButton( // 뒤로 가기
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left
                    ),
                    CustomIconButton( // 재생/일시정지
                        onPressed: onPlayPressed,
                        iconData: videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow
                    ),
                    CustomIconButton( // 앞으로 가기
                        onPressed: onForwardPressed,
                        iconData: Icons.rotate_right
                    )
                  ]
                )
              )
          ]
        )
      )
    );
  }

  Widget renderTimeTextFromDuration(Duration duration){
    //padLeft()는 실행되는 대상의 문자열 왼쪽에 문자를 추가해주는 역할
    return Text("${duration.inMinutes.toString().padLeft(2, '0')} : ${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
    style: TextStyle(color: Colors.white));
  }
  void onReversePressed(){
    final currentPosition = videoController!.value.position; // 현재 실행중인 위치

    Duration position = Duration(); // 0초으로 초기화

    if(currentPosition.inSeconds > 3){
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position); // 우리가 조절한 구간으로 동영상이 이동하게끔!
  }

  void onForwardPressed(){
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    Duration position = maxPosition;

    if((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds){
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void onPlayPressed(){
    if(videoController!.value.isPlaying)
      videoController!.pause();
    else
      videoController!.play();
  }
}

