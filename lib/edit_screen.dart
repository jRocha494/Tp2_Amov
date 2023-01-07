import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tp2_amov/Menu.dart';
import 'package:tp2_amov/Utils.dart';
import 'package:tp2_amov/WeekDay.dart';
import 'package:http/http.dart' as http;

class EditScreen extends StatefulWidget{
  const EditScreen({super.key});
  final title = "TP2 / AMOV / CANTINA";

  @override
  State<StatefulWidget> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen>{
  late final Object? args = ModalRoute.of(context)?.settings.arguments;
  late final WeekDay? weekDay = args is WeekDay ? args as WeekDay : null;
  late final Menu _formData = Menu.copy(weekDay!.original);
  bool _updatingData = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _postFormData() async {
    try {
      setState(() => _updatingData = true);
      final response = await http.post(
        Uri.parse("$address/menu"),
        headers:{"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(_formData.toJson()),
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
      }
    } catch (ex) {
      debugPrint('Something went wrong: $ex');
    } finally {
      setState(() => _updatingData = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body:
        Center(child:
          SingleChildScrollView(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return SimpleDialog(
                                title: Text("Original Menu"),
                                children: [
                                  Column(
                                    children: [
                                      Text(weekDay!.original.toString()),
                                      ElevatedButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: Text('Original Menu'),
                    ),
                    if(weekDay!.update != null)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return SimpleDialog(
                                title: Text("Updated Menu"),
                                children: [
                                  Column(
                                    children: [
                                      Text(weekDay!.update.toString()),
                                      ElevatedButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }
                          );
                        },
                        child: Text('Updated Menu'),
                      )
                  ]
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Soup'),
                        onSaved: (value) =>
                        {
                          if(value != null && value.isNotEmpty)
                            _formData.soup = value
                        }
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Fish'),
                          onSaved: (value) =>
                          {
                            if(value != null && value.isNotEmpty)
                              _formData.fish = value
                          }
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Meat'),
                          onSaved: (value) =>
                          {
                            if(value != null && value.isNotEmpty)
                              _formData.meat = value
                          }
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Vegetarian'),
                          onSaved: (value) =>
                          {
                            if(value != null && value.isNotEmpty)
                              _formData.vegetarian = value
                          }
                      ),
                      TextFormField(
                          decoration: InputDecoration(labelText: 'Dessert'),
                          onSaved: (value) =>
                          {
                            if(value != null && value.isNotEmpty)
                              _formData.desert = value
                          }
                      ),
                      if (_updatingData) const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState != null &&
                                _formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if(!(_formData == weekDay!.original)) {
                                _postFormData();
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Submit'),
                        ),
                    ],
                  ),
                ),
              ],
            )
          )
      )
    );
  }
}