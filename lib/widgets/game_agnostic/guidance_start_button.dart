import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';

class NRGGuidanceButton extends StatefulWidget {
  final double height;
  final double width;
  final Function startGuidance;
  const NRGGuidanceButton ({
    super.key, 
    required this.height, 
    required this.width, 
    required this.startGuidance, 
  }); 
  
  @override
  State<StatefulWidget> createState() => _NRGGuidanceButtonState();
}

class _NRGGuidanceButtonState extends State<NRGGuidanceButton> {
  double get _height => widget.height;
  double get _width => widget.width;
  Function get _startGuidance => widget.startGuidance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _startGuidance(); 
      },
      child: Container(
        height: _height,
        width: _width, 
        decoration: BoxDecoration(
              color: Constants.pastelWhite,
              borderRadius: BorderRadius.circular(Constants.borderRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                Text("GUIDED NAVIGATION",style: comfortaaBold(21,color: Constants.pastelReddishBrown),),
                Icon(Icons.arrow_forward,color: Constants.pastelReddishBrown,size:33)
              ],)
      ),
    );
  }
}