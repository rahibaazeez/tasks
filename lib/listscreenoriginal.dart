import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListDisplay extends StatefulWidget {
  const ListDisplay({super.key});

  @override
  State<ListDisplay> createState() => _ListDisplayState();
}

class _ListDisplayState extends State<ListDisplay> {
  Future getData() async {
    Response response = await get(
        Uri.parse("https://reqres.in/api/users"));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return body;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List items"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          setState(() {

          });
        },
        child: FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data["data"].length,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Image.network(
                          snapshot.data["data"][index]["avatar"],
                          height: 130,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data["data"][index]["first_name"],
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                snapshot.data["data"][index]["email"],
                                style: const TextStyle(fontSize: 16.0),
                              ),

                            ],
                          ),

                        ),
                      ],
                    ),

                  );
                },
              );
            }else{
              return const Center(
                child: Text("Something went wrong"),
              );
            }
          },
        ),
      ),

    );
  }
}