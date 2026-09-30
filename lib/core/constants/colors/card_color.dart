import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CardColor {
  List<Color> colors;
  Color color1;
  Color? color2;

  CardColor({required this.colors, required this.color1, this.color2});
}

final HomeCardColor1 = CardColor(
  colors: [HexColor("dee9fc"),
  HexColor("dee9fc")
  ],
  color1: HexColor("3a63e2"),
);



final HomeCardColor2 = CardColor(
  colors: [
    HexColor("fae2e2"),
    HexColor("fae2e2"),
  ],
  color1: HexColor("c3241c"),
);


final HomeCardColor3 = CardColor(
  colors: [HexColor("fcedd8"),
  HexColor("fcedd8")
  ],
  color1: HexColor("d6551d"),
);


final HomeCardColor4 = CardColor(
  colors: [HexColor("f1e8fd"),
  HexColor("f1e8fd")
  ],
  color1: HexColor("9e5fe7"),
);
