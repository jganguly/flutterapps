import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:poly/poly.dart';
import 'dart:convert';

class Place{
  String name;
  String wiki;
  Point pos = Point(0,0); // x:long, y:lat
  static Place fromMap(Map m){
    Place p = Place();
    p.name = m["name"];
    p.wiki = m["wiki"];
    p.pos = Point( m["loc"][1] , m["loc"][0] );
    return p;
  }

}

class PlacesToVisit {

  String jsonString;
  Map<String,List<Place>> places;

  Future<String> _loadPlacesAsset() async {
    return await rootBundle.loadString('assets/data/places.json');
  }

  Future loadPlaces() async {
    jsonString = await _loadPlacesAsset();
    // now here, we do the decode and load
    Map<String,dynamic> m = jsonDecode(jsonString);
    places = Map();
    for ( String location in m.keys ){
      List<dynamic> list = m[location];
      List<Place> l = List();
      for ( Map p in list ){
        l.add( Place.fromMap(p as Map));
      }
      places[location] = l ;
    }
  }

  PlacesToVisit(){
    loadPlaces();
  }

  List<Place> within(List<Point> polyPoints ){
    Polygon poly = Polygon( polyPoints );
    // just check hyderabad now
    List<Place> current = places["hyderabad"];
    List<Place> contains = List();
    for ( Place p in current ){
      if ( poly.isPointInside( p.pos ) ){
        print("IN : ${p.name} : ${p.pos}");
        contains.add(p);
      }
    }
    return contains;
  }
}
