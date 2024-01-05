import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List<MyCard> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?f=b"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<MyCard> cards = [];

      data.forEach((item) {
        cards.add(MyCard(
          title: item['title'],
          description: item['description'],
          imageUrl: item['imageUrl'],
        ));
      });

      setState(() {
        _data = cards;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter REST API Demo'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: () async {
          await _fetchData();
          _refreshController.refreshCompleted();
        },
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return _data[index];
          },
        ),
      ),
    );
  }
}

class MyCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  MyCard({required this.title, required this.description, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          ListTile(
            title: Text(title),
            subtitle: Text(description),
          ),
        ],
      ),
    );
  }
}
