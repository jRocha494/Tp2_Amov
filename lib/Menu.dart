import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tp2_amov/Utils.dart';
import 'package:flutter/widgets.dart';

class Menu{
  Menu.fromJson(Map<String, dynamic> json) {
    weekDay = json['weekDay'];
    soup = json['soup'];
    fish = json['fish'];
    meat = json['meat'];
    vegetarian = json['vegetarian'];
    desert = json['desert'];
    img = json['img'] != null ? "$address/images/${json['img']}" : null;
  }

  Menu.copy(Menu other):
      weekDay = other.weekDay,
      soup = other.soup,
      fish = other.fish,
      meat = other.meat,
      vegetarian = other.vegetarian,
      desert = other.desert,
      img = other.img;

  Map<String, dynamic> toJson()=>{
    'weekDay': weekDay,
    'soup': soup,
    'fish': fish,
    'meat': meat,
    'vegetarian': vegetarian,
    'desert': desert
  };


  String? weekDay;
  String? soup;
  String? fish;
  String? meat;
  String? vegetarian;
  String? desert;
  String? img;

  @override
  String toString() {
    return 'Soup: $soup\nFish: $fish\nMeat: $meat\nVegetarian: $vegetarian\nDessert: $desert';
  }

  @override
  bool operator ==(Object other){
    return other is Menu &&
      other.weekDay == weekDay &&
      other.soup == soup &&
      other.fish == fish &&
      other.meat == meat &&
      other.vegetarian == vegetarian &&
      other.desert == desert &&
      other.img == img;
  }

  @override
  int get hashCode => weekDay.hashCode^soup.hashCode^fish.hashCode^meat.hashCode^vegetarian.hashCode^desert.hashCode^img.hashCode;

}