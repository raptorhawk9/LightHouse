import 'dart:collection';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/constants.dart';
import 'package:lighthouse/filemgr.dart';
import 'package:lighthouse/widgets/game_agnostic/barchart.dart';

class AmongViewIndividual extends StatefulWidget {
  const AmongViewIndividual({super.key});

  @override
  State<AmongViewIndividual> createState() => _AmongViewIndividualState();
}

class _AmongViewIndividualState extends State<AmongViewIndividual>
    with SingleTickerProviderStateMixin {
  static late double scaleFactor;
  late AVISharedState state;
  late ValueNotifier<bool> sortCheckbox;
  late ScrollController scrollController;
  late TabController matchPitController;
  late double chartWidth;
  late bool forceRunOnce;

  @override
  void initState() {
    super.initState();
    state = AVISharedState();
    scrollController = ScrollController();
    sortCheckbox = ValueNotifier<bool>(false);
    forceRunOnce = true;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    matchPitController = TabController(
        length: 2,
        vsync: this,
        initialIndex:
            (ModalRoute.of(context)?.settings.arguments as List<int>)[1]);
    if (forceRunOnce) {
      state.activeTeam =
          (ModalRoute.of(context)?.settings.arguments as List<int>)[0];
      state.setActiveEvent(configData["eventKey"]!);
      state.getEnabledLayouts();
      if (state.enabledLayouts.isNotEmpty) {
        state.setActiveLayout(state.enabledLayouts[0]);
        state.setActiveSortKey(
            sortKeys[state.enabledLayouts[0]]!.keys.toList()[0]);
        state.loadPitData();
        state.addListener(() {
          setState(() {});
        });
        state.updateChartData();
      }
      forceRunOnce = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    chartWidth = state.matchesForTeam.length < 5
        ? 350
        : state.matchesForTeam.length * 75;
    if (state.enabledLayouts.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back)),
          ),
          body: Text("No data. i'm actually impressed that you got here",
              style: comfortaaBold(18, color: Constants.pastelBrown)));
    }

    state.activeTeam =
        (ModalRoute.of(context)?.settings.arguments as List<int>)[0];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    scaleFactor = screenHeight / 914;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.pastelRed,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Constants.pastelWhite),
          backgroundColor: themeColorPalettes[configData["theme"] ?? "Dark"]![0],
          title: Text(
            "Team ${state.activeTeam} - AmongView",
            style: TextStyle(
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.w900,
                color: Constants.pastelWhite),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/data-viewer-amongview",
                  (route) => false,
                );
              },
              icon: Icon(Icons.arrow_back_ios_new)),
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgrounds[configData["theme"]] ?? "assets/images/background-hires-dark.png"),
                    fit: BoxFit.cover)),
            child: Column(children: [
              Container(
                  width: 350 * scaleFactor,
                  height: 0.8 * screenHeight,
                  decoration: BoxDecoration(
                      color: Constants.pastelWhite,
                      borderRadius:
                          BorderRadius.circular(Constants.borderRadius)),
                  child: Column(children: [
                    Text("Showing data for ${state.activeEvent}: "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Layout:",
                            style: comfortaaBold(10, color: Colors.black)),
                        DropdownButton(
                          borderRadius: BorderRadius.circular(Constants.borderRadius),
                            value: state.activeLayout,
                            items: state.enabledLayouts.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e.toSentenceCase,
                                    style:
                                        comfortaaBold(12, color: Colors.black),
                                  ));
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                state.setActiveLayout(newValue ?? "");
                              });
                            }),
                      ],
                    ),
                    if (state.getSortKeys().contains(state.activeSortKey))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Sort by:",
                              style: comfortaaBold(10, color: Colors.black)),
                          DropdownButton(
                            borderRadius: BorderRadius.circular(Constants.borderRadius),
                              value: state.activeSortKey,
                              items: state.getSortKeys().map((e) {
                                return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toSentenceCase,
                                      style: comfortaaBold(12,
                                          color: Colors.black),
                                    ));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  state.setActiveSortKey(newValue ?? "");
                                });
                              }),
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        sortCheckbox.value = !sortCheckbox.value;
                        setState(() {
                          state.updateChartData(sort: sortCheckbox.value);
                        });
                      },
                      child: Container(
                        width: 325 * scaleFactor,
                        height: 40 * scaleFactor,
                        decoration: BoxDecoration(
                            color: Constants.pastelGray,
                            borderRadius:
                                BorderRadius.circular(Constants.borderRadius)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: sortCheckbox,
                                builder: (a, b, c) {
                                  return Checkbox(
                                      value: b,
                                      onChanged: (value) {
                                        sortCheckbox.value = value ?? false;
                                        setState(() => state.updateChartData(
                                            sort: sortCheckbox.value));
                                      });
                                }),
                            SizedBox(
                              height: 40 * scaleFactor,
                              child: Center(
                                  child: AutoSizeText(
                                "Sort Data?",
                                style: comfortaaBold(18 * scaleFactor),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.3 * screenHeight,
                      width: 350 * scaleFactor,
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        child: ListView(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            children: [
                              NRGBarChart(
                                title: state.activeSortKey.toSentenceCase,
                                height: 0.3 * screenHeight,
                                width: chartWidth * scaleFactor,
                                data: state.chartData,
                                color: Constants.pastelRed,
                                hashMap: state.hashMap,
                                amongviewMatches: state.matchesForTeam,
                                chartOnly: true,
                                sharedState: state,
                              ),
                            ]),
                      ),
                    ),
                    TabBar(controller: matchPitController, tabs: [
                      Tab(
                        text: "MATCH",
                      ),
                      Tab(
                        text: "PIT",
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400 * scaleFactor,
                        height: 0.25 * screenHeight,
                        child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: matchPitController,
                            children: [
                              Container(
                                height: 0.3 * screenHeight,
                                width: 350 * scaleFactor,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Constants.borderRadius),
                                    border: Border.all(width: scaleFactor * 2)),
                                child: (state.clickedMatch == null)
                                    ? Text("No match selected",
                                        style: comfortaaBold(10))
                                    : buildMatchData(context),
                              ),
                              Container(
                                  height: 0.3 * screenHeight,
                                  width: 350 * scaleFactor,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Constants.borderRadius),
                                      border:
                                          Border.all(width: scaleFactor * 2)),
                                  child: state.pitData.isEmpty
                                      ? Text("No pit data",
                                          style: comfortaaBold(10))
                                      : buildMatchData(context, pit: true))
                            ]),
                      ),
                    ),
                  ])),
            ])));
  }

  Widget buildMatchData(BuildContext context, {bool pit = false}) {
    dynamic match = {};
    if (pit) {
      match = state.pitData;
    } else {
      for (dynamic i in state.data) {
        if (i["matchType"] == getParsedMatchInfo(state.clickedMatch!)[0] &&
            i["matchNumber"] == getParsedMatchInfo(state.clickedMatch!)[1]) {
          match = i;
        }
      }
    }
    if (match == {}) {
      return Text("how did you get here? email infotech@nrg948.com",
          style: comfortaaBold(10));
    }

    List<Widget> listViewChildren = [
      Text(
        pit
            ? "Team ${match["teamNumber"]} Pit Data"
            : "Team ${match["teamNumber"]} ${match["matchType"]} ${match["matchNumber"]}",
        textAlign: TextAlign.center,
        style: comfortaaBold(18, color: Constants.pastelBrown),
      ),
    ];
    String layout = pit ? "Pit" : state.activeLayout;
    for (String i in displayKeys[layout].keys) {
      switch (displayKeys[layout][i]) {
        case "raw":
          listViewChildren.add(AutoSizeText(
            "${i.toSentenceCase}: ${match[i].toString()}",
            style:
                comfortaaBold(14 * scaleFactor, color: Constants.pastelBrown),
          ));
        case "autoPit":
          for (int auto = 0; auto < match[i].length; auto++) {
            listViewChildren.add(AutoSizeText(
              "Auto ${auto + 1}",
              style:
                  comfortaaBold(14 * scaleFactor, color: Constants.pastelBrown),
            ));
            for (String autoKey in [
              "bargeCS",
              "processorCS",
              "autoCoralScored",
              "autoAlgaeRemoved",
              "autoCoralScoredL1"
            ]) {
              listViewChildren.add(AutoSizeText(
                "    ${autoKey.toSentenceCase}: ${match[i][auto][autoKey]}",
                style: comfortaaBold(14 * scaleFactor,
                    color: Constants.pastelBrown),
              ));
            }
          }
      }
    }

    return Scrollbar(
      interactive: true,
      thumbVisibility: true,
      thickness: 10 * scaleFactor,
      child: ListView(children: listViewChildren),
    );
    //return Text("Showing ${getParsedMatchInfo(state.clickedMatch ?? 0)[0]} ${getParsedMatchInfo(state.clickedMatch ?? 0)[1]} for team ${state.activeTeam}");
  }
}

class AVISharedState extends ChangeNotifier {
  late String activeEvent;
  late String activeLayout;
  late String activeSortKey;
  late int activeTeam;
  List<String> enabledLayouts = [];
  late List<int> matchesForTeam = [];
  late List<dynamic> data;
  Map pitData = {};
  SplayTreeMap<int, double> chartData = SplayTreeMap();
  LinkedHashMap<int, double>? hashMap;
  int? clickedMatch;

  void setClickedMatch(int match) {
    clickedMatch = match;
    notifyListeners();
  }

  void getEnabledLayouts() {
    for (String i in ["Atlas", "Chronos", "Human Player"]) {
      if (loadDatabaseFile(activeEvent, i) != "" &&
          !enabledLayouts.contains(i)) {
        enabledLayouts.add(i);
      }
    }
  }

  void setActiveEvent(String event) {
    activeEvent = event;
    notifyListeners();
  }

  void setActiveLayout(String layout) async {
    activeLayout = layout;
    loadDatabase();
    setActiveSortKey(sortKeys[activeLayout]!.keys.toList()[0]);
    notifyListeners();
  }

  void setActiveSortKey(String key) {
    activeSortKey = key;
    updateChartData();
    notifyListeners();
  }

  void updateChartData({bool? sort}) {
    chartData.clear();
    matchesForTeam.clear();
    for (dynamic i in data) {
      if (!(matchesForTeam.contains(getParsedMatchNumber(i)))) {
        matchesForTeam.add(getParsedMatchNumber(i));
      }
    }
    matchesForTeam.sort((a, b) => a.compareTo(b));

    switch (sortKeys[activeLayout][activeSortKey]) {
      case "raw":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(
                getParsedMatchNumber(match), match[activeSortKey]!.toDouble())
          ]);
        }
      case "climb":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(
                getParsedMatchNumber(match),
                (match["endLocation"] == "Deep Climb" ||
                        match["endLocation"] == "Shallow Climb")
                    ? 1
                    : 0)
          ]);
        }
      case "viewAllMatches":
        for (dynamic match in data) {
          chartData.addEntries([MapEntry(getParsedMatchNumber(match), 1.0)]);
        }
      case "totalraw":
        Map<String, List<String>> searchTerms = {
          "coralScoredTotal": [
            "coralScoredL1",
            "coralScoredL2",
            "coralScoredL3",
            "coralScoredL4"
          ]
        };
        for (dynamic match in data) {
          double total = 0;
          for (String term in searchTerms[activeSortKey]!) {
            total += match[term]!;
          }
          chartData.addEntries([MapEntry(getParsedMatchNumber(match), total)]);
        }
      case "rawboolean":
        for (dynamic match in data) {
          if (match[activeSortKey.removeAfterSpace]! == true) {
            chartData.addEntries([MapEntry(getParsedMatchNumber(match), 1.0)]);
          } else {
            chartData.addEntries([MapEntry(getParsedMatchNumber(match), 0.0)]);
          }
        }
      case "rawbyitems":
        for (dynamic match in data) {
          chartData.addEntries([
            MapEntry(getParsedMatchNumber(match),
                match[activeSortKey]!.length.toDouble())
          ]);
        }
      case "hpraw":
        for (dynamic match in data) {
          if (match["redHPTeam"]! == activeTeam &&
              activeSortKey.contains("red")) {
            chartData.addEntries([
              MapEntry(
                  getParsedMatchNumber(match), match[activeSortKey].toDouble())
            ]);
          }
          if (match["blueHPTeam"]! == activeTeam &&
              activeSortKey.contains("blue")) {
            chartData.addEntries([
              MapEntry(
                  getParsedMatchNumber(match), match[activeSortKey].toDouble())
            ]);
          }
        }
      case "cycleTime":
        List searchTerms = [];
        if (activeSortKey.contains("Reef")) {
          searchTerms = ["AB", "CD", "EF", "GH", "IJ", "KL"];
        } else if (activeSortKey.contains("CS")) {
          searchTerms = ["BargeCS", "ProcessorCS"];
        } else if (activeSortKey.contains("Processor")) {
          searchTerms = ["Processor"];
        }

        for (dynamic match in data) {
          final List fullEventList;
          final List filteredEventList = [];
          if (activeSortKey.contains("Auto")) {
            fullEventList = match["autoEventList"]!;
          } else if (activeSortKey.contains("Teleop")) {
            fullEventList = match["teleopEventList"]!;
          } else {
            fullEventList = [];
          }
          for (List event in fullEventList) {
            if (searchTerms.any(
                (e) => (event[0] == "enter$e") || (event[0] == "exit$e"))) {
              filteredEventList.add(event);
            }
          }
          List<double> timeDiffs = [];
          //  Iterates through every other event (only the enter area events)
          for (int eventIndex = 0;
              eventIndex < filteredEventList.length;
              eventIndex = eventIndex + 2) {
            // Accounts for edge case in which last enter event has no corresponding exit event
            if (eventIndex == filteredEventList.length - 1) {
              continue;
            }
            // Gets time difference between this event (enter) and next event (exit)
            timeDiffs.add(filteredEventList[eventIndex + 1][1] -
                filteredEventList[eventIndex][1]);
          }
          if (timeDiffs.isNotEmpty) {
            chartData.addEntries([
              MapEntry(getParsedMatchNumber(match),
                  (timeDiffs.sum / timeDiffs.length).fourDigits)
            ]);
          }
        }
    }
    if (sort == true) {
      List<MapEntry<int, double>> sortedEntries = chartData.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      hashMap = LinkedHashMap<int, double>.fromEntries(sortedEntries);
      matchesForTeam = hashMap != null ? hashMap!.keys.toList() : [];
    } else {
      hashMap = null;
      matchesForTeam.sort();
    }
  }

  List<String> getSortKeys() {
    return sortKeys[activeLayout]!.keys.toList();
  }

  void loadDatabase() {
    data = jsonDecode(loadDatabaseFile(activeEvent, activeLayout));
    // Creates a buffer file to avoid concurrent access errors
    List<dynamic> tempData = [];
    for (dynamic i in data) {
      if (activeLayout != "Human Player") {
        if (i["teamNumber"]! == activeTeam) {
          tempData.add(i);
        }
      } else {
        if (i["redHPTeam"]! == activeTeam) {
          tempData.add(i);
        }
        if (i["blueHPTeam"]! == activeTeam) {
          tempData.add(i);
        }
      }
    }
    data = tempData;
  }

  void loadPitData() {
    List<dynamic> allPitData = [];
    if (loadDatabaseFile(activeEvent, "Pit") == "") {
      return;
    }
    allPitData = jsonDecode(loadDatabaseFile(activeEvent, "Pit"));
    if (allPitData.isEmpty) {
      return;
    }
    for (dynamic i in allPitData) {
      if (int.parse(i["teamNumber"]) == activeTeam) {
        pitData = i;
      }
    }
  }
}

// These keys are used by the chart to determine how to parse data
Map<String, dynamic> sortKeys = {
  "Atlas": {
    "viewAllMatches": "viewAllMatches",
    "coralPickups": "raw",
    "coralScoredTotal": "totalraw",
    "coralScoredL1": "raw",
    "coralScoredL2": "raw",
    "coralScoredL3": "raw",
    "coralScoredL4": "raw",
    "algaePickups": "raw",
    "algaeRemove": "raw",
    "algaeScoreProcessor": "raw",
    "algaeScoreNet": "raw",
    "climbStartTime": "raw",
    "climbedInMatch": "climb",
    "bargeCS Used in Auto": "rawboolean",
    "processorCS Used in Auto": "rawboolean",
    "hasNoAuto": "rawboolean",
    "groundIntake in Auto": "rawboolean",
    "autoCoralScored": "rawbyitems",
    "autoAlgaeRemoved": "rawbyitems",
  },
  "Chronos": {
    "Auto Reef Cycle Time": "cycleTime",
    "Auto CS Cycle Time": "cycleTime",
    "Teleop Reef Cycle Time": "cycleTime",
    "Teleop CS Cycle Time": "cycleTime",
    "Teleop Processor Cycle Time": "cycleTime",
  },
  "Human Player": {
    "redScore": "hpraw",
    "blueScore": "hpraw",
    "redMiss": "hpraw",
    "blueMiss": "hpraw",
    "redNetAlgae": "hpraw",
    "blueNetAlgae": "hpraw"
  }
};

// This map is used by the individual match viewer and pit scouting viewer to figure out how to display items
// Necessary for more complex data types like event lists
Map<String, dynamic> displayKeys = {
  "Atlas": {
    "scouterName": "raw",
    "replay": "raw",
    "driverStation": "raw",
    // TODO: CHANGE THIS
    "startingPosition": "raw",

    "preload": "raw",
    "hasNoAuto": "raw",
    "groundIntake": "raw",
    // TODO: Change these two
    "autoCoralScored": "raw",
    "autoCoralScoredL1": "raw",
    "autoAlgaeRemoved": "raw",

    "bargeCS": "raw",
    "processorCS": "raw",
    "coralPickups": "raw",
    "coralScoredL1": "raw",
    "coralScoredL2": "raw",
    "coralScoredL3": "raw",
    "coralScoredL4": "raw",
    "algaeRemove": "raw",
    "algaeScoreProcessor": "raw",
    "algaeScoreNet": "raw",
    "endLocation": "raw",
    "attemptedClimb": "raw",

    // TODO: Find a way to add a "seconds" label to this maybe?
    // we could spaghetti-code this w/ an if-else statement
    // or have a more elegant solution
    "climbStartTime": "raw",

    "robotDisabled": "raw",
    "robotDisableReason": "raw",
    "dataQuality": "raw",
    "comments": "raw",
    "crossedMidline": "raw",
    "timestamp": "raw"
  },
  "Chronos": {
    "scouterName": "raw",
    "replay": "raw",
    "driverStation": "raw",

    // TODO: Change this
    "startingPosition": "raw",

    // TODO: Change these
    "autoEventList": "raw",
    "teleopEventList": "raw",

    "generalStrategy": "raw",
    "dataQuality": "raw",
    "comments": "raw",
    "timestamp": "raw"
  },
  "Human Player": {
    "scouterName": "raw",
    "redHPTeam": "raw",
    "blueHPTeam": "raw",
    "replay": "raw",
    "redScore": "raw",
    "blueScore": "raw",
    "redMiss": "raw",
    "blueMiss": "raw",
    "redNetAlgae": "raw",
    "blueNetAlgae": "raw",
    "dataQuality": "raw",
    "timestamp": "raw"
  },
  "Pit": {
    "teamName": "raw",
    "intervieweeName": "raw",
    "interviewerName": "raw",
    "robotHeight": "raw",
    "robotLength": "raw",
    "robotWidth": "raw",
    "robotWeight": "raw",
    "robotDrivetrain": "raw",
    "robotMechanisms": "raw",
    "auto": "autoPit",
    "coralScoringAbilityL1": "raw",
    "coralScoringAbilityL2": "raw",
    "coralScoringAbilityL3": "raw",
    "coralScoringAbilityL4": "raw",
    "canIntakeStation": "raw",
    "canIntakeGround": "raw",
    "canRemoveAlgaeL2": "raw",
    "canRemoveAlgaeL3": "raw",
    "canScoreProcessor": "raw",
    "canScorenet": "raw",
    "canClimbShallow": "raw",
    "canClimbDeep": "raw",
    "averageClimbTime": "raw",
    "driveExperience": "raw",
    "humanPlayerPreference": "raw",
    "generalStrategyPreference": "raw",
    "averageCoralCycles": "raw",
    "averageAlgaeCycles": "raw",
    "idealAlliancePartnerQualities": "raw",
    "otherComments": "raw",
    "layout": "raw",
    "exportName": "raw",
    "timestamp": "raw"
  }
};

// This is a rlly stupid solution to the fact that the BarChart widget only takes an <int,double> map
// Essentially it just adds a four-digit identifier code (1111 for playoffs, 2222 for finals)
// if the match is anything other than a qual match
// in order for this to work, it's VERY important that match numbers are limited to 999 or less
// which shouldn't be a problem but still

int getParsedMatchNumber(dynamic match) {
  return match["matchType"]! == "Qualifications"
      ? match["matchNumber"] // Leave match number if Quals
      : match["matchType"]! == "Playoffs"
          ? int.parse("1111${match["matchNumber"]}") // Add 1111 if Playoffs
          : int.parse("2222${match["matchNumber"]}"); // Add 2222 if Finals
}

List<dynamic> getParsedMatchInfo(int parsedMatch, {bool? truncated}) {
  List<dynamic> infoList = parsedMatch.toString().startsWith("1111")
      ? ["Playoffs", int.parse(parsedMatch.toString().substring(4))]
      : parsedMatch.toString().startsWith("2222")
          ? ["Finals", int.parse(parsedMatch.toString().substring(4))]
          : ["Qualifications", parsedMatch];
  if (truncated == true) {
    return ["${infoList[0].toString().substring(0, 1)}${infoList[1]}"];
  } else {
    return infoList;
  }
}
