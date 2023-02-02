import "package:flutter/material.dart";
import "package:webview_flutter/webview_flutter.dart";

// 블로그 웹 앱을 실행했을 때 가장 먼저 실행되는 홈 화면

class HomeScreen extends StatelessWidget{
  WebViewController? controller;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Code Factory"),
        centerTitle: true,

        // appBar의 actions 매개변수
        actions: [
          IconButton(
            // 눌렀을 때의 콜백 함수 설정
            onPressed: () {
              if(controller != null){
                //  WebView에서 보여줄 사이트 실행
                controller!.loadUrl("https://blog.codefactory.ai");
              }
            },
            icon: Icon(Icons.home),
          ),

          IconButton(
            onPressed: (){
              if(controller != null){
                controller!.goForward();
              }
            },
            icon: Icon(Icons.access_alarm)
          ),

          IconButton(
              onPressed: (){
                if(controller != null){
                  controller!.goBack();
                }
              },
              icon: Icon(Icons.add_circle)
          )

        ]
      ),


      body: WebView(
        onWebViewCreated: (WebViewController controller){
          this.controller = controller;
        },
        initialUrl: "https://blog.codefactory.ai",
        javascriptMode: JavascriptMode.unrestricted,
      )
    );
  }
}