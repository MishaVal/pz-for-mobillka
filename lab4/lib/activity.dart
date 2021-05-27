import 'dart:convert';

import 'package:http/http.dart' as http;

class Activity {
  String activity;
  final String type;
  final int participants;
  final double price;
  final String link;
  final String key;
  final double accessibility;

  Activity({
    this.activity,
    this.type,
    this.participants,
    this.price,
    this.link,
    this.key,
    this.accessibility,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    var price = json['price'].toDouble();

    return Activity(
      activity: json['activity'],
      type: json['type'],
      participants: json['participants'],
      price: price,
      link: json['link'],
      key: json['key'],
      accessibility: json['accessibility'].toDouble(),
    );
  }
}

Future<Activity> fetchNextActivity() async {
  var url = Uri.parse('https://www.boredapi.com/api/activity');
  var response = await http.get(url);
  var json = jsonDecode(response.body);
  return Activity.fromJson(json);
}
