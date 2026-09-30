import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HeaderTitle extends StatelessWidget {
  String title;
  List<Widget> ?right;
  List<Widget> ?left;

  HeaderTitle({super.key, required this.title,this.right,this.left});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top).add(EdgeInsets.symmetric(horizontal: 15)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                title,
            
                style: TextStyle(
                  color: Colors.black45,
                  fontFamily: 'yekan',
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: SizedBox(
      height: 20,

              child: Row(
              children: right??[],
                        ),
            )),

            Positioned(
            left: 0,
            child: SizedBox(
      height: 26,

              child: Row(
              children: left??[],
                        ),
            ))
        ],
      ),
    );
  }
}
