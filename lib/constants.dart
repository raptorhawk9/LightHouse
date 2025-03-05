import 'package:flutter/material.dart';

class Constants {
  // Pastel
  static const Color pastelRed = Color.fromARGB(255, 227, 150, 136);
  static const Color pastelRedDark = Color.fromARGB(255, 193, 87, 87);
  static const Color pastelRedSuperDark = Color.fromARGB(255, 148, 30, 57);

  static const Color pastelYellow = Color.fromARGB(255, 237, 193, 142);
  static const Color pastelYellowDark = Color.fromARGB(255, 219, 143, 93);
  static const Color pastelYellowSuperDark = Color.fromARGB(255, 207, 95, 31);

  static const Color pastelGreen = Color.fromARGB(255, 165, 226, 135);
  static const Color pastelGreenDark = Color.fromARGB(255, 73, 185, 101);
  static const Color pastelGreenSuperDark = Color.fromARGB(255, 31, 145, 96);

  static const Color pastelBlue = Color.fromARGB(255, 74, 188, 216);
  static const Color pastelBlueDark = Color.fromARGB(255, 23, 123, 154);
  static const Color pastelBlueSuperDark = Color.fromARGB(255, 3, 62, 125);
  
  static const Color pastelGray = Color.fromARGB(255, 196, 201, 194);
  static const Color pastelGrayDark = Color.fromARGB(255, 153, 168, 153);
  static const Color pastelGraySuperDark = Color.fromARGB(255, 80, 102, 79);

  static const Color pastelWhite = Color.fromARGB(255, 250, 242, 240);
  static const Color pastelBrown = Color.fromARGB(255, 50, 30, 26);

  // Neon
  static const Color neonWhite = Colors.white;
  static const Color neonRed = Color.fromARGB(255, 248, 104, 133);
  static const Color neonYellow = Color.fromARGB(255, 255, 217, 101);
  static const Color neonGreen = Color.fromARGB(255, 149, 240, 104);
  static const Color neonBlue = Color.fromARGB(255, 108, 235, 241);
  static const Color neonGray = Color.fromARGB(255, 214, 229, 221);

  static const Color coolGray = Color.fromARGB(255, 63, 65, 68);

  static const List<Color> reefColors = [
      Color.fromARGB(255, 195, 103, 191), // L1
      Color.fromARGB(255, 77, 110, 211), // L2
      Color.fromARGB(255, 82, 197, 69), // L3
      Color.fromARGB(255, 236, 87, 87), // L4
      Color.fromARGB(255, 90, 216, 179) // Algae
  ];

  static final double neonBorder = 2;
  static final double borderRadius = 8;
  /// There is always a delay between the end of, for example, 
  /// auto and the start of teleop. Thus, this is simply for
  /// adding a bit of delay before the next section. :)
  static final double startDelay = 3;
  
  static const String versionName = "Feb 27 Update";
  // Should this key be exposed to the internet? no
  // do i care? also no
  static const String tbaAPIKey = "ayLg4jZVBMJ4BFKqDzt8Sn7nGTYqDgB4VEB0ZxbMXH3MVJVnhAChBZZSyuSEuEVH";

}

TextStyle comfortaaBold(double fontSize,
    {bool bold = true,
    Color color = Constants.pastelWhite,
    FontWeight? customFontWeight,
    bool italic = false,
    double? spacing}) {
  return TextStyle(
      fontFamily: "Comfortaa",
      fontWeight:
          customFontWeight ?? (bold ? FontWeight.bold : FontWeight.normal),
      color: color,
      fontSize: fontSize,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      letterSpacing: spacing
      );
}


final Map<int,String> responseCodes = {
  200:"OK",
  301:"Permanantly Moved",
  400: "Bad Request",
  404:"File Not Found",
};

extension StringExtensions on String {
  String get toSentenceCase => replaceAllMapped(
    RegExp(r'([a-z])([A-Z])'),
    (Match m) => '${m[1]} ${m[2]}',
  ).replaceFirstMapped(
    RegExp(r'^[a-z]'),
    (Match m) => m[0]!.toUpperCase(),
  );
}
extension DoubleExtensions on double {
  double get fourDigits => double.parse(toStringAsFixed(4));
}