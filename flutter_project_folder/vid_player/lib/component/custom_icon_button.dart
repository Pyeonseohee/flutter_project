import "package:image_picker/image_picker.dart";
import "package:flutter/material.dart";

class CustomIconButton extends StatelessWidget{
  final GestureTapCallback onPressed;
  final IconData iconData;

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context){
    print(iconData);
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData)
    );
  }
}