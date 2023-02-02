import "package:flutter/material.dart";
import "package:random_dice/const/colors.dart";


class SettingsScreen extends StatelessWidget{
  final double threshold; // Slider의 현잿값
  final ValueChanged<double> onThresholdChange; // Slider가 변경될 때마다 실행되는 함수

  const SettingsScreen({
    Key? key,
    // threshold와 onThresholdChange는 SettingsScreen에서 입력받음.
  required this.threshold,
  required this.onThresholdChange}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: Row(
            children:[
              Text("민감도", style: TextStyle(
                color: secondaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.w700
              ))
            ]
          )
        ),
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101,
          value: threshold, // 슬라이더 선택값
          onChanged: onThresholdChange, // 값 변경시 실행되는 함수
          label: threshold.toStringAsFixed(1) // 슬라이더를 움직였을 때 위에 뜨는 표싯값(소숫점 첫째자리까지)
        )
      ]
    );
  }
}