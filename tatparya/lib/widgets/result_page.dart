/*
   Result Page
*/
import 'dart:js' as js;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'package:intl/intl.dart';

import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tatparya/widgets/centered_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:http/http.dart' as http;
import 'package:division/division.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:pie_chart/pie_chart.dart' as lol;

///*************************************///
///import 'package:syncfusion_flutter_charts/charts.dart';
///
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:expansion_card/expansion_card.dart';

//import 'package:pie_chart/pie_chart.dart';
//import 'package:syncfusion_flutter_gauges/gauges.dart';

// Use this gauage charts : https://pub.dev/packages/syncfusion_flutter_gauges

int _status = 0, p1 = 0, p2 = 0, p3 = 0, p4 = 0, ts = 0;
double avg = 3.6;
String? social_media;

List<dynamic> tweets = [
  {
    'This is a tweet example 1': {
      'toxicity': 0.8281899,
      'severe_toxicity': 0.041792102,
      'obscene': 0.040942732,
      'threat': 0.7770545,
      'insult': 0.07080291,
      'identity_attack': 0.025330964
    }
  },
  {
    'This is a tweet example 2': {
      'toxicity': 0.9189266,
      'severe_toxicity': 0.0024823097,
      'obscene': 0.016442569,
      'identity_attack': 0.027524859,
      'insult': 0.031409487,
      'threat': 0.78440434,
      'sexual_explicit': 0.002125398
    }
  },
  {
    'This is a tweet example 3': {
      'toxicity': 0.9307302,
      'severe_toxicity': 0.006120356,
      'obscene': 0.011674217,
      'identity_attack': 0.019972492,
      'insult': 0.02199859,
      'threat': 0.81099695,
      'sexual_explicit': 0.0084620705
    }
  }
];

List<dynamic> top_mentioned = [
  {"Dev": 11},
  {"Ankur": 8},
  {"Dexter": 7},
  {"Ash": 5},
  {"Devv": 4},
  {"Ank": 3},
  {"Dextf": 2},
  {"Ashfd": 1},
];
List<dynamic> top_hashtags = [
  {"#Dev": 11},
  {"#Ankur": 8},
  {"#Dexter": 7},
  {"#Ash": 5},
  {"#Devv": 4},
  {"#Ank": 3},
  {"#Dextf": 2},
  {"#Ashfd": 1},
];
List<dynamic> sentiment = [
  {
    'original': {
      'toxicity': 0.8281899,
      'severe_toxicity': 0.041792102,
      'obscene': 0.040942732,
      'threat': 0.7770545,
      'insult': 0.07080291,
      'identity_attack': 0.025330964
    }
  },
  {
    'unbiased': {
      'toxicity': 0.9189266,
      'severe_toxicity': 0.0024823097,
      'obscene': 0.016442569,
      'identity_attack': 0.027524859,
      'insult': 0.031409487,
      'threat': 0.78440434,
      'sexual_explicit': 0.002125398
    }
  },
  {
    'multilingual': {
      'toxicity': 0.9307302,
      'severe_toxicity': 0.006120356,
      'obscene': 0.011674217,
      'identity_attack': 0.019972492,
      'insult': 0.02199859,
      'threat': 0.81099695,
      'sexual_explicit': 0.0084620705
    }
  }
];

/*

[
  {'original': {'toxicity': 0.8281899, 'severe_toxicity': 0.041792102, 'obscene': 0.040942732, 'threat': 0.7770545, 'insult': 0.07080291, 'identity_attack': 0.025330964}}, 
  {'unbiased': {'toxicity': 0.9189266, 'severe_toxicity': 0.0024823097, 'obscene': 0.016442569, 'identity_attack': 0.027524859, 'insult': 0.031409487, 'threat': 0.78440434, 'sexual_explicit': 0.002125398}}, 
  {'multilingual': {'toxicity': 0.9307302, 'severe_toxicity': 0.006120356, 'obscene': 0.011674217, 'identity_attack': 0.019972492, 'insult': 0.02199859, 'threat': 0.81099695, 'sexual_explicit': 0.0084620705}}
]

*/

/// ************************************* ///
http.Client _getClient() {
  return http.Client();
}

/// ************************************* ///
String handle = "";
String url = 'https://aae8-103-158-217-96.in.ngrok.io/fetch_profile';
Map<String, dynamic>? json_output;

class Output {}

class FrequentUserData {
  FrequentUserData(this.x, this.y);

  final String x;
  final int y;
}

class Sentiment_score {
  Sentiment_score(this.sentiment, this.score);
  final sentiment;
  final double score;
}

class ScatterData {
  ScatterData(this.date, this.sentiment_score);
  DateTime date;
  final double sentiment_score;
}

late List<Sentiment_score> sentiment_score_list = [];
late List<FrequentUserData> frequent_mentions_chart = [];
late List<ScatterData> tweet_sentiments = [];

int totalTweets = 0;

class ResultPage extends StatefulWidget {
  final String input;
  ResultPage(this.input);
  @override
  _ResultPage createState() => _ResultPage();
}

class _ResultPage extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    print(widget.input.toString());
    _status = 0;
    social_media = widget.input.toString();
    sendDataToAPI(widget.input.toString());
  }

  /// ************************** API ********************************
  Future<void> sendDataToAPI(String input) async {
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({"username": "scump", "no_of_tweets": "20"}),
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json"
      },
    );

    print("----------------------------------------------------------");
    //final json_output = jsonDecode(response.body);
    //final Map json_output = jsonDecode(response.body);

    json_output = jsonDecode(response.body) as Map<String, dynamic>;
    //json_output = json.decode(response.body);

    //print("----------------- Frequent Mentions ----------------------------");

    //print(json_output?['profile_data']['followers_count']);
    for (int i = 0; i < json_output?['frequent_mentions'].length; i++) {
      //print(json_output?['frequent_mentions'].values.elementAt(i)[0]);
      String key = json_output?['frequent_mentions'].keys.elementAt(i);
      int val = json_output?['frequent_mentions'].values.elementAt(i)[0];
      frequent_mentions_chart.add(FrequentUserData(key, val));
    }

    print("---------------- Sentiment Analysis -------------------------");

    double toxicity_score = 0.0,
        severe_toxicity = 0.0,
        obscene_score = 0.0,
        threat_score = 0.0,
        insult_score = 0.0,
        identity_attack_score = 0.0;

    int len = 0;
    //print(json_output?['sentiment_analysis'][0]['score']);
    for (int i = 0;
        i < json_output?['sentiment_analysis'].length;
        i++, len++, totalTweets++) {
      print(json_output?['sentiment_analysis'][i]
          .values
          .elementAt(2)['toxicity']);

      toxicity_score += double.parse(json_output?['sentiment_analysis'][i]
          .values
          .elementAt(2)['toxicity']);
      severe_toxicity += double.parse(json_output?['sentiment_analysis'][i]
          .values
          .elementAt(2)['severe_toxicity']);
      obscene_score += double.parse(
          json_output?['sentiment_analysis'][i].values.elementAt(2)['obscene']);
      threat_score += double.parse(
          json_output?['sentiment_analysis'][i].values.elementAt(2)['threat']);
      insult_score += double.parse(
          json_output?['sentiment_analysis'][i].values.elementAt(2)['insult']);
      identity_attack_score += double.parse(json_output?['sentiment_analysis']
              [i]
          .values
          .elementAt(2)['identity_attack']);

      double avg_score = double.parse(json_output?['sentiment_analysis'][i]
              .values
              .elementAt(2)['toxicity']) +
          double.parse(json_output?['sentiment_analysis'][i]
              .values
              .elementAt(2)['severe_toxicity']) +
          double.parse(json_output?['sentiment_analysis'][i]
              .values
              .elementAt(2)['obscene']) +
          double.parse(json_output?['sentiment_analysis'][i]
              .values
              .elementAt(2)['threat']) +
          double.parse(json_output?['sentiment_analysis'][i]
              .values
              .elementAt(2)['insult']) +
          double.parse(
              json_output?['sentiment_analysis'][i].values.elementAt(2)['identity_attack']);

      avg_score /= 6;

      /* DATE TIME CONVERSION HERE*/
      var parsedDate = DateTime.parse(
          json_output?['sentiment_analysis'][i].values.elementAt(3));

      tweet_sentiments.add(ScatterData(parsedDate, avg_score));
    }

    sentiment_score_list.add(Sentiment_score('toxicity', toxicity_score / len));
    sentiment_score_list
        .add(Sentiment_score('severe_toxicity', severe_toxicity / len));
    sentiment_score_list.add(Sentiment_score('obscene', obscene_score / len));
    sentiment_score_list.add(Sentiment_score('threat', threat_score / len));
    sentiment_score_list.add(Sentiment_score('insult', insult_score / len));
    sentiment_score_list
        .add(Sentiment_score('identity_attack', identity_attack_score / len));

    print("-------------------- Tweets ----------------------------");

    print("----------------------------------------------------------");

    if (response.statusCode == 200) {
      //print(jsonDecode(response.body));
      setState(() {
        _status = 1;
      });
    } else {
      print("404 Error Lol!!");
      setState(() {
        _status = 2;
      });
    }
  }

  Widget buildList(BuildContext context) {
    final icons = [
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_dissatisfied,
    ];

    return ListView.builder(
      itemCount: sentiment.length,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.only(left: 175, right: 175),
          child: Card(
            elevation: 5,
            child: ListTile(
              subtitle: Text(
                "${sentiment[index]["score"]}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              tileColor: ((sentiment[index]["point"] == "neutral")
                  ? Colors.grey
                  : (sentiment[index]["point"] == "good"
                      ? Colors.green
                      : Colors.red)),
              leading: ((sentiment[index]["point"] == "neutral")
                  ? Icon(icons[0])
                  : (sentiment[index]["point"] == "good"
                      ? Icon(icons[1])
                      : Icon(icons[2]))),
              title: Text("${sentiment[index]["title"]}"),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Colors.red, //                   <--- border color
        width: 5.0,
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }

  Widget ErrorPage(BuildContext context) {
    return build(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: (_status == 0)
            ? Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    SpinKitFadingCircle(color: Colors.black, size: 68.5),
                    SizedBox(
                      height: 17.5,
                    ),
                    Text("Loading NLP Model & Processing License "),
                  ]))
            : (_status == 1
                ? SafeArea(child: UserPage()) //SafeArea(child: UserPage())
                : SafeArea(
                    child: ErrorPage(
                        context))), //SafeArea(child: ErrorPage(widget.input))),
      )),
    );
  }
}

class UserPage extends StatelessWidget {
  final contentStyle = (BuildContext context) => ParentStyle()
    ..overflow.scrollable()
    ..padding(vertical: 30, horizontal: 20)
    ..minHeight(MediaQuery.of(context).size.height - (2 * 30));

  final titleStyle = TxtStyle()
    ..bold()
    ..fontSize(32)
    ..margin(bottom: 20)
    ..alignmentContent.centerLeft();

  final ParentStyle userCardStyleCustom = ParentStyle()
    ..height(300)
    ..width(800)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#3977FF')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);
  final titleStyleCustom = TxtStyle()
    ..bold()
    ..fontSize(30)
    ..margin(bottom: 20)
    ..alignmentContent.centerLeft();

  @override
  Widget build(BuildContext context) {
    return Parent(
        style: contentStyle(context),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              //Txt('JustBoring.io', style: titleStyle),
              UserCard(),

              //ActionsRow(),
              SizedBox(width: 25),
              UserCard2(),
              //Settings(),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(children: [
            UserCard3(),
            SizedBox(width: 25),
            UserCard4(),
          ]),
          SizedBox(height: 25),
          Row(
            // Last row
            children: [
              UserCard5(),
            ],
          ),
          SizedBox(height: 50),
          Column(children: <Widget>[
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.only(left: 125),
              child: Txt(
                "In Depth Profile Analysis",
                style: titleStyleCustom,
              ),
            ),
            SizedBox(height: 25),
            Container(
                child: Card(
              elevation: 10,
              color: hex('#3977FF'),
              child: Container(
                  padding: const EdgeInsets.all(25),
                  child: Txt("sum", style: nameTextStyleCustom)),
            ))
          ]),
        ]));
  }
}

class UserCard5 extends StatelessWidget {
  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        // Parent(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt("Tweet Analysis over Time with specific Sentiment Score",
                style: nameTextStyleCustom),
            SizedBox(height: 5),
            Txt('n can be altered', style: nameDescriptionTextStyle)
          ],
        )
      ],
    );
  }

  Widget buildMeter(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: 400,
          alignment: Alignment.center,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Gold',
                    color: Color.fromRGBO(8, 142, 255, 1))
              ])),
    ]);
  }

  Widget buildChart(BuildContext context) {
    Map<String, double> dataMap = {
      "Bad": p3.roundToDouble(),
      "Good": p1.roundToDouble(),
      "Neutral": p2.roundToDouble(),
      "Block": p4.roundToDouble(),
    };

    return Container();
  }

  Widget buildList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        ListTile(
            title: Text("Battery Full"),
            leading: Icon(Icons.battery_full),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Anchor"),
            leading: Icon(Icons.anchor),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Alarm"),
            leading: Icon(Icons.access_alarm),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Ballot"),
            leading: Icon(Icons.ballot),
            trailing: Icon(Icons.star))
      ],
    );
  }

  Widget _buildUserStats() {
    return Parent(
        style: userStatsStyle,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                _buildUserStatsItem('avg', 'T1'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$p4', 'T2'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$ts', 'T3'),
              ]),
              /*   Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 1.0,
                  width: 400,
                  color: Colors.black,
                ),
              ),*/
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: [
                        //Builder(builder: (context) => buildMeter(context)),
                        Container(
                            width: 700,
                            child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  interval: 2,
                                ),
                                primaryYAxis: NumericAxis(
                                  interval: 5,
                                ),
                                series: <ChartSeries>[
                                  ScatterSeries<ScatterData, DateTime>(
                                      dataSource: tweet_sentiments,
                                      xValueMapper: (ScatterData data, _) =>
                                          data.date,
                                      yValueMapper: (ScatterData data, _) =>
                                          data.sentiment_score,
                                      markerSettings: MarkerSettings(
                                          height: 10,
                                          width: 10,
                                          // Scatter will render in diamond shape
                                          shape: DataMarkerType.circle))
                                ]))
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      children: [
                        Txt('Tweet Analysis using NLP', style: nameTextStyle),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 500,
                          height: 500,
                          child: Settings(),
                        ),
                        /*Container(
                      width: 250,
                      height: 400,
                      child: ListView(
                        children: [
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: AssetImage(
                                      "images/hash_tag.png",
                                    ),
                                  ),
                                  title: Text(
                                      "${top_hashtags[index].keys.elementAt(0)}"),
                                  // subtitle: Text("This is subtitle"),
                                ),
                              );
                            },
                            itemCount: top_mentioned.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          )
                        ],
                        padding: EdgeInsets.all(10),
                      ),
                    ),*/
                      ],
                    )
                  ]),

              //Builder(builder: (context) => buildMeter(context)),
            ],
          ),
        ));
  }

  Widget _buildUserStatsItem(String value, String text) {
    final TxtStyle textStyle = TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.black);
    return Column(
      children: <Widget>[
        Txt(value, style: textStyle),
        SizedBox(height: 5),
        Txt(text, style: nameDescriptionTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildUserRow(),
                SizedBox(
                  height: 25,
                ),
                _buildUserStats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(800)
    ..width(1800)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#f8f8f8')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 5)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(22)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.black.withOpacity(0.6))
    ..fontSize(12);
}

class Settings extends StatelessWidget {
  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.white.withOpacity(0.3))
    ..fontSize(12);
  final titleStyleCustom = TxtStyle()
    ..bold()
    ..fontSize(32)
    ..margin(bottom: 20)
    ..alignmentContent.centerLeft();

  int currIcon = 0;
  late String color;
  List<IconData> iconList = [
    (Icons.warning),
    (Icons.location_on),
    (Icons.notifications),
    (Icons.credit_card),
    (Icons.data_usage),
    (Icons.voice_chat),
    (Icons.wifi),
    (Icons.privacy_tip_rounded),
    (Icons.perm_identity),
    (Icons.track_changes),
    (Icons.message),
    (Icons.copyright),
    (Icons.fingerprint),
  ];
  void fun(String title) {
    if (title.contains("Location") || title.contains("location")) {
      currIcon = 1;
      color = "#8D7AEE";
      return;
    } else if (title.contains("WiFi") || title.contains("wifi")) {
      currIcon = 6;
      color = "#FEC85C";
      return;
    } else if (title.contains("copyright") || title.contains("Copyright")) {
      currIcon = 11;
      color = "#009688";
      return;
    } else if (title.contains("fingerprint") || title.contains("Fingerprint")) {
      currIcon = 12;
      color = "#FEC85C";
      return;
    } else if (title.contains("tracks") || title.contains("Tracks")) {
      currIcon = 9;
      color = "#E91E63";
      return;
    } else if (title.contains("messages") || title.contains("Messages")) {
      currIcon = 10;
      color = "#FEC85C";
      return;
    } else if (title.contains("Notification") ||
        title.contains("notification")) {
      currIcon = 2;
      color = "#5FD0D3";
      return;
    } else if (title.contains("Credit") || title.contains("credit")) {
      currIcon = 3;
      color = "#76FF03";
      return;
    } else if (title.contains("Voice") || title.contains("voice")) {
      currIcon = 5;
      color = "#BFACAA";
      return;
    } else if (title.contains("privacy") || title.contains("Privacy")) {
      currIcon = 5;
      color = "#F468B7";
      return;
    } else {
      color = "#00B0FF";
      currIcon = 0;
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        //margin: EdgeInsets.only(right: 500),
        child: Column(
      children: <Widget>[
        Container(
            height: 500,
            width: 800,
            child: SizedBox(
                child: ListView.builder(
                    itemCount: totalTweets,
                    itemBuilder: (BuildContext ctxt, int index) {
                      fun("tweets");
                      return SettingsItem(
                          iconList[currIcon],
                          hex(color),
                          "${json_output?['sentiment_analysis'][index].values.elementAt(0)}",
                          "2",
                          "3",
                          "${json_output?['sentiment_analysis'][index].values.elementAt(2)}");
                    })))
        /*SettingsItem(Icons.location_on, hex('#8D7AEE'), 'Address',
            'Ensure your harvesting address'),*/

        /*
        SettingsItem(
            Icons.lock, hex('#F468B7'), 'Privacy', 'System permission change'),
        SettingsItem(
            Icons.menu, hex('#FEC85C'), 'General', 'Basic functional settings'),
        SettingsItem(Icons.notifications, hex('#5FD0D3'), 'Notifications',
            'Take over the news in time'),
        SettingsItem(Icons.question_answer, hex('#BFACAA'), 'Support',
            'We are here to help'),
*/
        /*
        Container(
            height: 500,
            width: 750,
            child: Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(25),
                    //margin: EdgeInsets.only(left: 175, right: 175),
                    child: Card(
                      elevation: 5,
                      child: Center(
                          child: ExpansionCard(
                        backgroundColor: ((reviews[index]["point"] == "neutral")
                            ? Colors.grey
                            : (reviews[index]["point"] == "good"
                                ? Colors.green
                                : Colors.red)),
                        //background: Image.asset("assets/animations/sleep.gif"),
                        title: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${reviews[index]["title"]}",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${reviews[index]["score"]}",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.symmetric(horizontal: 7),
                            child: Txt(
                              "${reviews[index]["description"]}",
                              style: nameDescriptionTextStyle,
                            ),
                          )
                        ],
                      )), /*SettingsItem(
                            Icons.question_answer,
                            hex('#BFACAA'),
                            '${reviews[index]["title"]}',
                            '${reviews[index]["score"]}'),*/
                    ),
                  );
                },
              ),
            ))*/
      ],
    ));
  }
}

class SettingsItem extends StatefulWidget {
  SettingsItem(this.icon, this.iconBgColor, this.title, this.description,
      this.point, this.desc);

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;
  final String point;
  final String desc;

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 800,
        child: Card(
            child: ExpansionCard(
          margin: EdgeInsets.zero,
          title: Parent(
            style: settingsItemStyleCustom(pressed),
            gesture: Gestures()
              ..isTap((isTapped) => setState(() => pressed = isTapped)),
            child: Row(
              children: <Widget>[
                Parent(
                  style: settingsItemIconStyle(widget.iconBgColor),
                  child: Icon(widget.icon, color: Colors.white, size: 20),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Text((widget.title),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: ((widget.point == "neutral")
                                    ? Colors.grey
                                    : (widget.point == "good"
                                        ? Colors.green
                                        : Colors.red)),
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
                    SizedBox(height: 5),
                    Txt(widget.description,
                        style: itemDescriptionTextStyleCustom),
                  ],
                )),
              ],
            ),
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.symmetric(horizontal: 7),
              child: Txt(widget.desc, style: itemDescriptionTextStyle),
            ),
          ],
        )));
  }

  final settingsItemStyleCustom = (pressed) => ParentStyle()
    ..elevation(pressed ? 0 : 50, color: Colors.white)
    ..scale(pressed ? 0.95 : 1.0)
    ..alignmentContent.center()
    ..height(70)
    ..margin(vertical: 10)
    ..borderRadius(all: 15)
    ..background.hex('#ffffff')
    ..ripple(true)
    ..animate(150, Curves.easeOut);

  final settingsItemStyle = (pressed) => ParentStyle()
    ..elevation(pressed ? 0 : 50, color: Colors.grey)
    ..scale(pressed ? 0.95 : 1.0)
    ..alignmentContent.center()
    ..height(70)
    ..margin(vertical: 10)
    ..borderRadius(all: 15)
    ..background.hex('#ffffff')
    ..ripple(true)
    ..animate(150, Curves.easeOut);

  final settingsItemIconStyle = (Color color) => ParentStyle()
    ..background.color(color)
    ..margin(left: 15)
    ..padding(all: 12)
    ..borderRadius(all: 30);

  final TxtStyle itemTitleTextStyle = TxtStyle()
    ..bold()
    ..fontSize(16);

  final TxtStyle itemDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.black87)
    ..bold()
    ..fontSize(12);

  final TxtStyle itemDescriptionTextStyleCustom = TxtStyle()
    ..textColor(Colors.green)
    ..bold()
    ..fontSize(13);
}

class UserCard4 extends StatelessWidget {
  Widget buildList4(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        ListTile(
            title: Text("Battery Full"),
            leading: Icon(Icons.battery_full),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Anchor"),
            leading: Icon(Icons.anchor),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Alarm"),
            leading: Icon(Icons.access_alarm),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Ballot"),
            leading: Icon(Icons.ballot),
            trailing: Icon(Icons.star))
      ],
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        /* Parent(
            style: userImageStyle,
            child: Image.network(
              "logo",
              scale: 0.5,
            )),*/
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt('Detailed Sentimental Analysis', style: nameTextStyleCustom),
          ],
        )
      ],
    );
  }

  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  Widget buildMeter(BuildContext context) {
    return Row(children: <Widget>[
      // Put the bar graph here

      Container(
        width: 200,
        alignment: Alignment.center,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<Sentiment_score, String>>[
              BarSeries<Sentiment_score, String>(
                  dataSource: sentiment_score_list,
                  xValueMapper: (Sentiment_score data, _) => data.sentiment,
                  yValueMapper: (Sentiment_score data, _) => data.score,
                  name: 'Sentiment Score',
                  color: Color.fromARGB(255, 8, 255, 82))
            ]),
      ),
    ]);
  }

  Widget buildChart(BuildContext context) {
    Map<String, double> dataMap = {
      "Bad": p3.roundToDouble(),
      "Good": p1.roundToDouble(),
      "Neutral": p2.roundToDouble(),
      "Block": p4.roundToDouble(),
    };

    return SizedBox(
      width: 250,
      height: 200,
      child: lol.PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 4000),
        chartLegendSpacing: 32,
        chartRadius: 175,
        colorList: [Colors.orangeAccent, Colors.green, Colors.grey, Colors.red],
        initialAngleInDegree: 0,
        chartType: lol.ChartType.disc,
        ringStrokeWidth: 30,
        centerText: "$avg",
        legendOptions: lol.LegendOptions(
          showLegendsInRow: false,
          legendPosition: lol.LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        chartValuesOptions: lol.ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: true,
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Parent(
        style: userStatsStyle,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                _buildUserStatsItem('avg', 'Original'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$p4', 'Unbiased'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$ts', 'Multilingual'),
              ]),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: 1.0,
                  width: 335,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(children: <Widget>[
                Builder(builder: (context) => buildMeter(context)),
                SizedBox(
                  width: 15,
                ),
                Txt('Bar Graph', style: nameTextStyle),
                Container(
                  width: 225,
                  height: 350,
                  child: ListView(
                    children: [
                      Card(
                          child: ListTile(
                        title: Text("Toxicity"),
                      )),
                      Card(
                        child: ListTile(
                          title: Text("Severe Toxicity"),
                        ),
                      ),
                      Card(
                          child: ListTile(
                        title: Text("Obscene"),
                      )),
                      Card(
                          child: ListTile(
                        title: Text("Threat"),
                      )),
                      Card(
                          child: ListTile(
                        title: Text("Insult"),
                      )),
                      Card(
                          child: ListTile(
                        title: Text("Identity Attack"),
                      )),
                    ],
                    shrinkWrap: true,
                  ),
                ),
              ]),
              Builder(builder: (context) => buildChart(context)),
            ],
          ),
        ));
  }

  Widget _buildUserStatsItem(String value, String text) {
    final TxtStyle textStyle = TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.white);
    return Column(
      children: <Widget>[
        Txt(value, style: textStyle),
        SizedBox(height: 5),
        Txt(text, style: nameDescriptionTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildUserRow(),
                SizedBox(
                  height: 15,
                ),
                _buildUserStats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(800)
    ..width(800)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#9499A4')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 5)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(22)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.white.withOpacity(0.6))
    ..fontSize(12);
}

class UserCard3 extends StatelessWidget {
  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        // Parent(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt("Top 'n' Hashtags", style: nameTextStyleCustom),
            SizedBox(height: 5),
            Txt('n can be altered', style: nameDescriptionTextStyle)
          ],
        )
      ],
    );
  }

  Widget buildMeter(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: 400,
          alignment: Alignment.center,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: 'Gold',
                    color: Color.fromRGBO(8, 142, 255, 1))
              ])),
    ]);
  }

  Widget buildChart(BuildContext context) {
    Map<String, double> dataMap = {
      "Bad": p3.roundToDouble(),
      "Good": p1.roundToDouble(),
      "Neutral": p2.roundToDouble(),
      "Block": p4.roundToDouble(),
    };

    return Container();
  }

  Widget buildList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        ListTile(
            title: Text("Battery Full"),
            leading: Icon(Icons.battery_full),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Anchor"),
            leading: Icon(Icons.anchor),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Alarm"),
            leading: Icon(Icons.access_alarm),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Ballot"),
            leading: Icon(Icons.ballot),
            trailing: Icon(Icons.star))
      ],
    );
  }

  Widget _buildUserStats() {
    return Parent(
        style: userStatsStyle,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                _buildUserStatsItem('avg', 'Hashtag Score'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$p4', 'Hashtag Count'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$ts', 'Profile Link'),
              ]),
              /*   Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 1.0,
                  width: 400,
                  color: Colors.black,
                ),
              ),*/
              Row(children: <Widget>[
                Column(
                  children: [
                    Builder(builder: (context) => buildMeter(context)),
                    Container(
                        height: 250,
                        child: SfCircularChart(series: <CircularSeries>[
                          // Renders radial bar chart
                          RadialBarSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y)
                        ]))
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 100,
                ),
                Column(
                  children: [
                    Txt('Frequent Hashtags', style: nameTextStyle),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 250,
                      height: 400,
                      child: ListView(
                        children: [
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: AssetImage(
                                      "images/hash_tag.png",
                                    ),
                                  ),
                                  title: Text(
                                      "${top_hashtags[index].keys.elementAt(0)}"),
                                  // subtitle: Text("This is subtitle"),
                                ),
                              );
                            },
                            itemCount: top_mentioned.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          )
                        ],
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                )
              ]),

              //Builder(builder: (context) => buildMeter(context)),
            ],
          ),
        ));
  }

  Widget _buildUserStatsItem(String value, String text) {
    final TxtStyle textStyle = TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.black);
    return Column(
      children: <Widget>[
        Txt(value, style: textStyle),
        SizedBox(height: 5),
        Txt(text, style: nameDescriptionTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildUserRow(),
                SizedBox(
                  height: 25,
                ),
                _buildUserStats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(800)
    ..width(1000)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#f8f8f8')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 5)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(22)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.black.withOpacity(0.6))
    ..fontSize(12);
}

/****/
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

late List<_ChartData> data = [
  _ChartData('CHN', 12),
  _ChartData('GER', 15),
  _ChartData('RUS', 30),
  _ChartData('BRZ', 6.4),
  _ChartData('IND', 14),
];

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

late List<ChartData> data2 = [
  ChartData('David', 25, Color(0xFFFFC100)),
  ChartData('Steve', 38, Color(0xFF91FAFF)),
  ChartData('Jack', 34, Color(0xFF00D1FF)),
  ChartData('Others', 52, Color(0xFF009BEE))
];

/****/

class UserCard2 extends StatelessWidget {
  @override
  late TooltipBehavior _tooltip = TooltipBehavior(enable: true);

  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        // Parent(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt("Frequent mentioned users", style: nameTextStyleCustom),
            SizedBox(height: 5),
            Txt('n can be altered', style: nameDescriptionTextStyle)
          ],
        )
      ],
    );
  }

  Widget buildMeter(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: 400,
          alignment: Alignment.center,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
              tooltipBehavior: _tooltip,
              series: <ChartSeries<FrequentUserData, String>>[
                ColumnSeries<FrequentUserData, String>(
                    dataSource: frequent_mentions_chart,
                    xValueMapper: (FrequentUserData data, _) => data.x,
                    yValueMapper: (FrequentUserData data, _) => data.y,
                    name: 'User',
                    color: Color.fromRGBO(8, 142, 255, 1))
              ])),
    ]);
  }

  Widget buildChart(BuildContext context) {
    Map<String, double> dataMap = {
      "Bad": p3.roundToDouble(),
      "Good": p1.roundToDouble(),
      "Neutral": p2.roundToDouble(),
      "Block": p4.roundToDouble(),
    };

    return Container();
  }

  Widget buildList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(2),
      children: <Widget>[
        ListTile(
            title: Text("Battery Full"),
            leading: Icon(Icons.battery_full),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Anchor"),
            leading: Icon(Icons.anchor),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Alarm"),
            leading: Icon(Icons.access_alarm),
            trailing: Icon(Icons.star)),
        ListTile(
            title: Text("Ballot"),
            leading: Icon(Icons.ballot),
            trailing: Icon(Icons.star))
      ],
    );
  }

  Widget _buildUserStats() {
    return Parent(
        style: userStatsStyle,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                _buildUserStatsItem('avg', 'Sentiment Score'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$p4', 'Tweet Count'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem('$ts', 'Profile Link'),
              ]),
              /*   Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 1.0,
                  width: 400,
                  color: Colors.black,
                ),
              ),*/
              Row(children: <Widget>[
                Column(
                  children: [
                    Builder(builder: (context) => buildMeter(context)),
                    Container(
                        height: 250,
                        child: SfCircularChart(series: <CircularSeries>[
                          // Renders radial bar chart
                          RadialBarSeries<FrequentUserData, String>(
                              dataSource: frequent_mentions_chart,
                              xValueMapper: (FrequentUserData data, _) =>
                                  data.x,
                              yValueMapper: (FrequentUserData data, _) =>
                                  data.y)
                        ]))
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                SizedBox(
                  width: 100,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Txt('Most Tagged/Mentioned Users', style: nameTextStyle),
                    Container(
                      width: 250,
                      height: 400,
                      child: ListView(
                        children: [
                          ListView.builder(
                            itemBuilder: (BuildContext, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () => {
                                    js.context.callMethod('open', [
                                      '${json_output?['frequent_mentions'].values.elementAt(index)[1]}'
                                    ])
                                  },
                                  leading: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: AssetImage(
                                      "images/profile.jpg",
                                    ),
                                  ),
                                  title: Text(
                                      "${json_output?['frequent_mentions'].keys.elementAt(index)}"),
                                  // subtitle: Text("This is subtitle"),
                                ),
                              );
                            },
                            itemCount: json_output?['frequent_mentions'].length,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                          )
                        ],
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ],
                )
              ]),

              //Builder(builder: (context) => buildMeter(context)),
            ],
          ),
        ));
  }

  Widget _buildUserStatsItem(String value, String text) {
    final TxtStyle textStyle = TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.black);
    return Column(
      children: <Widget>[
        Txt(value, style: textStyle),
        SizedBox(height: 5),
        Txt(text, style: nameDescriptionTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildUserRow(),
                SizedBox(
                  height: 25,
                ),
                _buildUserStats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(800)
    ..width(1000)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#f8f8f8')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 5)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(22)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.black)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.black.withOpacity(0.6))
    ..fontSize(12);
}

/****************************************************************************************** */

class UserCard extends StatelessWidget {
  Widget _buildUserRow() {
    return Row(
      children: <Widget>[
        Parent(
            style: userImageStyle,
            child: Image.network(
              "${json_output?['profile_data']['profile_image_url']}",
              scale: 0.5,
              width: 50,
              height: 50,
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt('${json_output?['profile_data']['name']}',
                style: nameTextStyleCustom),
            SizedBox(height: 5),
            Txt('Twitter', style: nameDescriptionTextStyle)
          ],
        )
      ],
    );
  }

  double twitter_score = 21.5;
  Widget buildMeter(BuildContext context) {
    return Row(children: <Widget>[
      // Put the bar graph here

      Container(
        width: 200,
        alignment: Alignment.center,
        child: SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 5000,
          axes: <RadialAxis>[
            RadialAxis(
                showLabels: true,
                showAxisLine: false,
                showTicks: true,
                minimum: 0,
                maximum: 100,
                ranges: <GaugeRange>[
                  GaugeRange(
                      startValue: 0,
                      endValue: 25,
                      color: Colors.green,
                      label: 'Good',
                      sizeUnit: GaugeSizeUnit.factor,
                      labelStyle: GaugeTextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(1)),
                      startWidth: 0.65,
                      endWidth: 0.65),
                  GaugeRange(
                      startValue: 25,
                      endValue: 50,
                      color: Colors.grey,
                      label: 'Neutral',
                      sizeUnit: GaugeSizeUnit.factor,
                      labelStyle: GaugeTextStyle(
                          fontSize: 12, color: Colors.white.withOpacity(1)),
                      startWidth: 0.65,
                      endWidth: 0.65),
                  GaugeRange(
                    startValue: 50,
                    endValue: 75,
                    color: Colors.orangeAccent,
                    label: 'Bad',
                    labelStyle: GaugeTextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(1)),
                    startWidth: 0.65,
                    endWidth: 0.65,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 75,
                    endValue: 100,
                    color: Colors.red,
                    label: 'Block',
                    labelStyle: GaugeTextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(1)),
                    sizeUnit: GaugeSizeUnit.factor,
                    startWidth: 0.65,
                    endWidth: 0.65,
                  ),
                ],
                pointers: <GaugePointer>[
                  NeedlePointer(value: twitter_score)
                ])
          ],
        ),
      ),
    ]);
  }

  Widget buildChart(BuildContext context) {
    Map<String, double> dataMap = {
      "Bad": p3.roundToDouble(),
      "Good": p1.roundToDouble(),
      "Neutral": p2.roundToDouble(),
      "Block": p4.roundToDouble(),
    };

    return SizedBox(
      width: 250,
      height: 200,
      child: lol.PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 4000),
        chartLegendSpacing: 32,
        chartRadius: 175,
        colorList: [Colors.orangeAccent, Colors.green, Colors.grey, Colors.red],
        initialAngleInDegree: 0,
        chartType: lol.ChartType.disc,
        ringStrokeWidth: 30,
        centerText: "$avg",
        legendOptions: lol.LegendOptions(
          showLegendsInRow: false,
          legendPosition: lol.LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
          legendTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        chartValuesOptions: lol.ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: true,
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Parent(
        style: userStatsStyle,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                _buildUserStatsItem(
                    '${json_output?['profile_data']['followers_count']}',
                    'Followers'),
                SizedBox(
                  width: 50,
                ),
                _buildUserStatsItem(
                    '${json_output?['profile_data']['location']}', 'Location'),
                SizedBox(
                  width: 20,
                ),
                _buildUserStatsItem('2013-04-12', 'Created at'),
              ]),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: 1.0,
                  width: 335,
                  color: Colors.white,
                ),
              ),
              Row(children: <Widget>[
                Builder(builder: (context) => buildMeter(context)),
                SizedBox(
                  width: 15,
                ),
                Txt('Tatparya-Scale', style: nameTextStyle),
              ]),
              Builder(builder: (context) => buildChart(context)),
            ],
          ),
        ));
  }

  Widget _buildUserStatsItem(String value, String text) {
    final TxtStyle textStyle = TxtStyle()
      ..fontSize(20)
      ..textColor(Colors.white);
    return Column(
      children: <Widget>[
        Txt(value, style: textStyle),
        SizedBox(height: 5),
        Txt(text, style: nameDescriptionTextStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Parent(
      style: userCardStyle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 30),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildUserRow(),
                SizedBox(
                  height: 15,
                ),
                _buildUserStats()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Styling

  final ParentStyle userCardStyle = ParentStyle()
    ..height(800)
    ..width(500)
    ..padding(horizontal: 20.0, vertical: 10)
    ..alignment.center()
    ..background.hex('#3977FF')
    ..borderRadius(all: 20.0)
    ..elevation(10, color: hex('#3977FF'));

  final ParentStyle userImageStyle = ParentStyle()
    ..height(50)
    ..width(50)
    ..margin(right: 10.0)
    ..borderRadius(all: 5)
    ..background.hex('ffffff');

  final ParentStyle userStatsStyle = ParentStyle()..margin(vertical: 10.0);

  final TxtStyle nameTextStyleCustom = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(22)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameTextStyle = TxtStyle()
    ..textColor(Colors.white)
    ..fontSize(18)
    ..fontWeight(FontWeight.w600);

  final TxtStyle nameDescriptionTextStyle = TxtStyle()
    ..textColor(Colors.white.withOpacity(0.6))
    ..fontSize(12);
}

class ActionsRow extends StatelessWidget {
  Widget _buildActionsItem(String title, IconData icon) {
    return Parent(
      style: actionsItemStyle,
      child: Column(
        children: <Widget>[
          Parent(
            style: actionsItemIconStyle,
            child: Icon(icon, size: 20, color: Color(0xFF42526F)),
          ),
          Txt(title, style: actionsItemTextStyle)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildActionsItem('Wallet', Icons.attach_money),
        _buildActionsItem('Delivery', Icons.card_giftcard),
        _buildActionsItem('Message', Icons.message),
        _buildActionsItem('Service', Icons.room_service),
      ],
    );
  }

  final ParentStyle actionsItemIconStyle = ParentStyle()
    ..alignmentContent.center()
    ..width(50)
    ..height(50)
    ..margin(bottom: 5)
    ..borderRadius(all: 30)
    ..background.hex('#F6F5F8')
    ..ripple(true);

  final ParentStyle actionsItemStyle = ParentStyle()..margin(vertical: 20.0);

  final TxtStyle actionsItemTextStyle = TxtStyle()
    ..textColor(Colors.black.withOpacity(0.8))
    ..fontSize(12);
}
