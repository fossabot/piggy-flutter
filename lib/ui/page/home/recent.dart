import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggy_flutter/utils/uidata.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => new _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  List<dynamic> recentTransactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecentTransactions();
  }

  void getRecentTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(UIData.authToken);

    var url =
        'http://piggyvault.in/api/services/app/transaction/GetTransactionsAsync';
    var input = json.encode({
      "type": "tenant",
      "accountId": null,
      "startDate": new DateTime.now().add(new Duration(days: -100)).toString(),
      "endDate": new DateTime.now().add(new Duration(days: 1)).toString()
    });
    print('getRecentTransactions input is $input');
    http.post(url, body: input, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((response) async {
      var res = json.decode(response.body);
      print(res);
      print(res["success"]);
      print(res["result"]);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (res["success"]) {
        setState(() {
          recentTransactions = res["result"]["items"];
        });
      } else {}
      print('recentTransactions are $recentTransactions');
      print('recentTransaction[0] are ${recentTransactions[0]['description']}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: recentTransactions.length,
        padding: new EdgeInsets.symmetric(vertical: 4.0),

        itemBuilder: (BuildContext context, int position) {
          return new ListTile(
            title: Text(recentTransactions[position]['category']['name']),
            subtitle: new Text(
                "${recentTransactions[position]['description']}\n${recentTransactions[position]['creatorUserName']}'s ${recentTransactions[position]['account']['name']} on ${recentTransactions[position]['transactionTime']}"),
            isThreeLine: true,
            trailing: Text('${recentTransactions[position]['amount'].toString()} ${recentTransactions[position]['account']['currency']['symbol']}'),
            leading: CircleAvatar(backgroundColor: recentTransactions[position]['amount'] > 0 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor ,),
          );
        });
  }
}