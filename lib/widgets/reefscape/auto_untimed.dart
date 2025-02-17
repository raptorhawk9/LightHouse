import "dart:math" as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/custom_icons.dart';
import 'package:lighthouse/pages/data_entry.dart';

class RSAutoUntimed extends StatefulWidget {
  final double width;
  final bool pit;
  const RSAutoUntimed({super.key, required this.width, this.pit = false});

  @override
  State<RSAutoUntimed> createState() => _RSAutoUntimedState();
}

class _RSAutoUntimedState extends State<RSAutoUntimed> {
  late SharedState sharedState;
  late double scaleFactor;
  @override
  void initState() {
    super.initState();
    sharedState = SharedState();

    scaleFactor = widget.width / 400;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children =
        // widget.pit ? [
        //     SizedBox(height: 5 * scaleFactor),
        //     RSAUHexagon(sharedState: sharedState,scaleFactor: scaleFactor,),
        //     RSAUReef(sharedState: sharedState, scaleFactor: scaleFactor)] :
        [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RSAUCoralStation(
            title: "Processor",
            jsonKey: "autoCS",
            scaleFactor: scaleFactor,
            flipped: false,
          ),
          Container(
            height: 50 * scaleFactor,
            width: 100 * scaleFactor,
            decoration: BoxDecoration(
                color: Constants.pastelRed,
                borderRadius: BorderRadius.circular(Constants.borderRadius)),
            child: Center(
                child: AutoSizeText(
              "DRIVER STATION",
              textAlign: TextAlign.center,
              style: comfortaaBold(10 * scaleFactor),
            )),
          ),
          RSAUCoralStation(
            title: "Barge",
            jsonKey: "autoCS",
            scaleFactor: scaleFactor,
            flipped: true,
          ),
        ],
      ),
      RSAUHexagon(
        sharedState: sharedState,
        scaleFactor: scaleFactor,
      ),
      RSAUReef(sharedState: sharedState, scaleFactor: scaleFactor)
    ];
    return Container(
      height: 666 * scaleFactor,
      width: widget.width,
      decoration: BoxDecoration(
          color: Constants.pastelWhite,
          borderRadius: BorderRadius.circular(Constants.borderRadius)),
      child: Column(children: children),
    );
  }
}

class RSAUReef extends StatefulWidget {
  final SharedState sharedState;
  final double scaleFactor;
  const RSAUReef(
      {super.key, required this.sharedState, required this.scaleFactor});

  @override
  State<RSAUReef> createState() => _RSAUReefState();
}

class _RSAUReefState extends State<RSAUReef>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    DataEntry.exportData["autoCoralScored"] = [];
    DataEntry.exportData["autoAlgaeRemoved"] = [];
    super.initState();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sharedState.activeTriangle == null) {
      return Text(
        "No Section Selected",
        style: comfortaaBold(18, color: Colors.black),
      );
    }
    String at = widget.sharedState.activeTriangle!;
    return Container(
        height: 308 * widget.scaleFactor,
        width: 318 * widget.scaleFactor,
        padding: EdgeInsets.all(8 * widget.scaleFactor),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(Constants.borderRadius),
        ),
        child: Column(
          spacing: 2 * widget.scaleFactor,
          children: [
            Text("Section ${widget.sharedState.activeTriangle}",
                textAlign: TextAlign.center,
                style: comfortaaBold(18 * widget.scaleFactor,
                    color: const Color.fromARGB(255, 0, 0, 0))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral4,
                    location: "${at[0]}4",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral4,
                    location: "${at[1]}4",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral3,
                    location: "${at[0]}3",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.algae3FRCLogo,
                    location: "${at}3",
                    algae: true,
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral3,
                    location: "${at[1]}3",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral2,
                    location: "${at[0]}2",
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.algae2FRCLogo,
                    location: "${at}2",
                    algae: true,
                    scaleFactor: widget.scaleFactor),
                RSAUReefButton(
                    icon: CoralAlgaeIcons.coral2,
                    location: "${at[1]}2",
                    scaleFactor: widget.scaleFactor),
              ],
            ),
            RSAUTrough(
              scaleFactor: widget.scaleFactor,
            )
          ],
        ));
  }
}

class RSAUTrough extends StatefulWidget {
  final double scaleFactor;
  const RSAUTrough({super.key, required this.scaleFactor});

  @override
  State<RSAUTrough> createState() => _RSAUTroughState();
}

class _RSAUTroughState extends State<RSAUTrough> {
  late int counter;

  @override
  void initState() {
    super.initState();
    counter = 0;
  }

  void increment() {
    setState(() {
      if (counter < 99) {
        counter++;
      }
      DataEntry.exportData["autoCoralScoredL1"] = counter.toString();
    });
  }

  void decrement() {
    setState(() {
      if (counter > 0) {
        counter--;
      }
      DataEntry.exportData["autoCoralScoredL1"] = counter.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: increment,
      child: Container(
        height: 75 * widget.scaleFactor,
        width: 301 * widget.scaleFactor,
        decoration: BoxDecoration(
            color: counter > 0 ? Constants.pastelRed : Constants.pastelGray,
            border: Border.all(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: widget.scaleFactor)),
        child: Center(
          child: GestureDetector(
            onTap: increment,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CoralAlgaeIcons.coral,
                      size: 24 * widget.scaleFactor,
                      color: Colors.black,
                    ),
                    Text(
                      "Coral Scored L1 (Trough)",
                      textAlign: TextAlign.center,
                      style: comfortaaBold(15 * widget.scaleFactor,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    height: 49 * widget.scaleFactor,
                    child: Row(
                      spacing: 0,
                      children: [
                        SizedBox(
                            width: 250 * widget.scaleFactor,
                            //the number count of the coral being scored on that level
                            child: Text(
                              counter.toString(),
                              style: comfortaaBold(23 * widget.scaleFactor,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                            width: 24,
                            child: IconButton(
                                onPressed: decrement,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    size: 25 * widget.scaleFactor),
                                highlightColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                                splashColor: const Color.fromARGB(255, 0, 0, 0),
                                iconSize: 25 * widget.scaleFactor))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RSAUReefButton extends StatefulWidget {
  final IconData icon;
  final bool algae;
  final String location;
  final double scaleFactor;
  const RSAUReefButton(
      {super.key,
      required this.icon,
      required this.location,
      required this.scaleFactor,
      this.algae = false});

  @override
  State<RSAUReefButton> createState() => _RSAUReefButtonState();
}

class _RSAUReefButtonState extends State<RSAUReefButton> {
  late bool active;

  @override
  void initState() {
    super.initState();
    active = false;
  }

  void setActive() {
    setState(() {
      if (!active) {
        HapticFeedback.heavyImpact();
        if (widget.algae) {
          DataEntry.exportData["autoAlgaeRemoved"].add(widget.location);
        } else {
          DataEntry.exportData["autoCoralScored"].add(widget.location);
        }
      } else {
        HapticFeedback.lightImpact();
        if (widget.algae) {
          DataEntry.exportData["autoAlgaeRemoved"].remove(widget.location);
        } else {
          DataEntry.exportData["autoCoralScored"].remove(widget.location);
        }
      }
      active = !active;
    });
  }

  @override
  Widget build(BuildContext context) {
    active =
        DataEntry.exportData["autoCoralScored"].contains(widget.location) ||
            DataEntry.exportData["autoAlgaeRemoved"].contains(widget.location);
    return GestureDetector(
      onTap: setActive,
      child: Container(
          height: 60 * widget.scaleFactor,
          width: (widget.algae ? 75 : 100) * widget.scaleFactor,
          decoration: BoxDecoration(
              color: active ? Constants.pastelRed : Constants.pastelGray,
              border:
                  Border.all(color: Colors.black, width: widget.scaleFactor)),
          //coral icons for the corals that you can choose to click within the map within auto section within atlas section
          child: Center(
            child: IconButton(
              onPressed: setActive,
              icon: Icon(widget.icon, size: 45 * widget.scaleFactor),
              iconSize: 45 * widget.scaleFactor,
              color: Colors.black,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          )),
    );
  }
}

class RSAUHexagon extends StatelessWidget {
  final SharedState sharedState;
  final double scaleFactor;
  const RSAUHexagon(
      {super.key, required this.sharedState, required this.scaleFactor});

  @override
  Widget build(BuildContext context) {
    // TODO: Change these labels to more accurately match reef locations (top ones are flipped)
    final triangleLabels = [
      "IJ",
      "GH",
      "EF",
      "CD",
      "AB",
      "KL",
    ];
    return Container(
        color: Constants.pastelWhite,
        height: 275 * scaleFactor,
        width: 275 * scaleFactor,
        alignment: Alignment.center,
        child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                CustomPaint(size: Size.infinite, painter: HexagonPainter()),
                for (int i = 0; i < 6; i++)
                  TriangleTapRegion(
                      index: i,
                      label: triangleLabels[i],
                      sharedState: sharedState,
                      scaleFactor: scaleFactor),
              ],
            )));
  }
}

class HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double R = size.width / 2; // Radius of the hexagon
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Calculate the vertices of the hexagon
    final List<Offset> vertices = [];
    for (int k = 0; k < 6; k++) {
      double angle = k * (math.pi / 3);
      vertices.add(Offset(
        center.dx + R * math.cos(angle),
        center.dy + R * math.sin(angle),
      ));
    }

    // Draw the hexagon
    final Path hexagonPath = Path()..moveTo(vertices[0].dx, vertices[0].dy);
    for (int i = 1; i < vertices.length; i++) {
      hexagonPath.lineTo(vertices[i].dx, vertices[i].dy);
    }
    hexagonPath.close();
    canvas.drawPath(hexagonPath, paint);

    // Draw lines from the center to each vertex
    for (final vertex in vertices) {
      canvas.drawLine(center, vertex, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TriangleTapRegion extends StatefulWidget {
  final int index;
  final String label;
  final SharedState sharedState;
  final double scaleFactor;
  const TriangleTapRegion(
      {super.key,
      required this.index,
      required this.label,
      required this.sharedState,
      required this.scaleFactor});

  @override
  State<TriangleTapRegion> createState() => _TriangleTapRegionState();
}

class _TriangleTapRegionState extends State<TriangleTapRegion> {
  @override
  void initState() {
    super.initState();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.sharedState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget returnIfHighlighted =
        widget.sharedState.activeTriangle == widget.label
            ? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Container(
                    color: Constants.pastelGray,
                    child: Text(
                      widget.label,
                      style: comfortaaBold(14 * widget.scaleFactor,
                          color: Colors.black),
                    )),
              )
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Text(widget.label,
                    style: comfortaaBold(14 * widget.scaleFactor,
                        color: Colors.black)));
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double R = width / 2;
        final Offset center = Offset(width / 2, height / 2);

        // Calculate vertices of the hexagon
        final List<Offset> vertices = [];
        for (int k = 0; k < 6; k++) {
          double angle = k * (math.pi / 3);
          vertices.add(Offset(
            center.dx + R * math.cos(angle),
            center.dy + R * math.sin(angle),
          ));
        }

        // Define the triangle for this region
        final Offset vertex1 = vertices[widget.index];
        final Offset vertex2 = vertices[(widget.index + 1) % 6];

        // Calculate the centroid (approximate center) of the triangle
        final Offset labelPosition = Offset(
          (center.dx + vertex1.dx + vertex2.dx) / 3,
          (center.dy + vertex1.dy + vertex2.dy) / 3,
        );

        return Stack(
          children: [
            // Tap area for the triangle
            ClipPath(
              clipper: TriangleClipper(center, vertex1, vertex2),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  widget.sharedState.setActiveTriangle(widget.label);
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // Triangle label
            Positioned(
                left: labelPosition.dx - 10, // Adjust for text centering
                top: labelPosition.dy - 10, // Adjust for text centering
                child: returnIfHighlighted),
          ],
        );
      },
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  final Offset center;
  final Offset vertex1;
  final Offset vertex2;

  TriangleClipper(this.center, this.vertex1, this.vertex2);

  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(vertex1.dx, vertex1.dy)
      ..lineTo(vertex2.dx, vertex2.dy)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) {
    return center != oldClipper.center ||
        vertex1 != oldClipper.vertex1 ||
        vertex2 != oldClipper.vertex2;
  }
}

class RSAUCoralStation extends StatefulWidget {
  final String jsonKey;
  final String title;
  final double scaleFactor;
  final bool flipped;
  const RSAUCoralStation(
      {super.key,
      required this.jsonKey,
      required this.title,
      required this.scaleFactor,
      required this.flipped});

  @override
  State<RSAUCoralStation> createState() => _RSAUCoralStationState();
}

class _RSAUCoralStationState extends State<RSAUCoralStation> {
  @override
  void initState() {
    super.initState();
    DataEntry.exportData[widget.jsonKey] = [];
  }

  @override
  Widget build(BuildContext context) {
    double width = 55 * widget.scaleFactor;
    double height = 80 * widget.scaleFactor;
    List<Widget> rowChildren = [
      Container(
        width: width * 1.5,
        height: height,
        color: Constants.pastelRedMuted,
        child: TextButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              DataEntry.exportData[widget.jsonKey].add(widget.title.toLowerCase());
            },
            child: Text(
              "CS",
              style: comfortaaBold(35 * widget.scaleFactor,
                  color: Constants.pastelWhite.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            )),
      ),
      Container(
        height: height,
        width: width * 0.8,
        color: Constants.pastelGray,
        child: TextButton(
            onPressed: () {
              if (DataEntry.exportData[widget.jsonKey].length > 0) {
                HapticFeedback.lightImpact();
                DataEntry.exportData[widget.jsonKey].removeLast();
              }
            },
            child: Text("U\nN\nD\nO",
                style: comfortaaBold(10 * widget.scaleFactor,
                    color: Constants.pastelWhite.withValues(alpha: 0.75)),
                textAlign: TextAlign.center)),
      )
    ];

    return Row(
        children: widget.flipped ? rowChildren.reversed.toList() : rowChildren);
  }
}

class SharedState extends ChangeNotifier {
  String? activeTriangle;
  void setActiveTriangle(String triangle) {
    print(triangle);
    activeTriangle = triangle;
    notifyListeners();
  }
}
