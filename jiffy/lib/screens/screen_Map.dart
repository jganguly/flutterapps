import 'package:flutter/material.dart';
import 'package:flutterapp/data_store.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class MyMap extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyMap> {

    GoogleMapController mapController;
    PlacesToVisit placesToVisit = PlacesToVisit();
    var rng = new Random();
    final Map<String, Marker> _markers = {};
    final List<LatLng> _bookMarks = [];
    final Set<Polyline>_polylines = {};

    void _getLocation() async {
        var currentLocation = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

        setState(() {
            // _markers.clear();
            final marker = Marker(
                markerId: MarkerId("curr_loc"),
                position: LatLng(currentLocation.latitude, currentLocation.longitude),
                infoWindow: InfoWindow(title: 'Your Location'),
            );
            _markers["Current Location"] = marker;
            _center = marker.position ;
        });
    }

    LatLng _center = LatLng(17.3850, 78.4867); // Hyd

    void _onMapCreated(GoogleMapController controller) {
        mapController = controller;
        _getLocation();
    }

    bool _bookMarking = false ;

    void _onTapMap(LatLng position){
        if ( _bookMarking ) {
            _addMarkerLongPressed(position);
        }
    }

    String getUniqueId( ){
        var s = new DateTime.now().millisecondsSinceEpoch.toString() + "_" + rng.nextInt(10000).toString() ;
        return s;
    }

    Future _addMarkerLongPressed(LatLng latlang) async {
        // add to the bookmarks
        var myUniqueId = getUniqueId() ;
        print(latlang);
        _bookMarks.add(latlang);
        setState(() {
            final MarkerId markerId = MarkerId( myUniqueId );
            Marker marker = Marker(
                markerId: markerId,
                draggable: true,
                position: latlang, //With this parameter you automatically obtain latitude and longitude
                infoWindow: InfoWindow(
                    title: "Marker here",
                    snippet: 'This looks good',
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue( BitmapDescriptor.hueAzure ),
            );
            _markers[markerId.toString()] = marker;
        });

        //This is optional, it will zoom when the marker has been created
        //GoogleMapController controller = await _controller.future;
        //controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
    }

    final double _zoomState = 13.0;

    Marker placeToMarker(Place place){
        final MarkerId markerId = MarkerId( place.wiki );
        Marker marker = Marker(
            markerId: markerId,
            draggable: true,
            position: LatLng( place.pos.y, place.pos.x),
            infoWindow: InfoWindow(
                title: place.name ,
                snippet: place.wiki ,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue( BitmapDescriptor.hueMagenta ),
        );
        return marker;
    }

    void drawPolygon(){
        // setup polyline
        var polyPoints = List<Point>();
        var closedPoints = new List<LatLng>();
        for ( LatLng p in _bookMarks ){
            closedPoints.add(p);
            Point pt = Point(p.longitude,p.latitude);
            print("POLY : $pt");
            polyPoints.add(pt);
        }
        // close it ...
        polyPoints.add(polyPoints[0]);
        closedPoints.add(_bookMarks[0]); // close it out
        // add found places ...
        List<Place> places = placesToVisit.within( polyPoints);
        for ( Place p in places){
            Marker m = placeToMarker(p);
            _markers[m.markerId.toString()] = m ;
        }

        // draw polygon
        _polylines.clear();
        _polylines.add(Polyline(
            polylineId: PolylineId( "custom_draw" ),
            visible: true,
            points: closedPoints ,
            color: Colors.blue,
            width: 3,
        ));
    }

    @override
    Widget build(BuildContext context) {
        GoogleMap googleMap = GoogleMap(
            polylines: _polylines,
            zoomGesturesEnabled: true,
            onTap: _onTapMap,
            onMapCreated: _onMapCreated,
            markers: _markers.values.toSet(),
            initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _zoomState,
            ),
        );

        mapControls() {
            return  <Widget>[
                IconButton(
                    icon: Icon(Icons.polymer),
                    tooltip: 'Mark/Stop Boundary',
                    onPressed: () {
                        setState(() {
                            // do something nice ...
                            _bookMarking = ! _bookMarking ;
                            if ( _bookMarking ) return ;
                            _bookMarks.clear();
                            _markers.clear();
                            _polylines.clear();
                        });
                    },
                ),
                IconButton(
                    icon: Icon(Icons.assessment),
                    tooltip: 'Show Custom Boundary',
                    onPressed: () {
                        setState(() {
                            // do something nice ...
                            // paint polygon
                            drawPolygon();
                        });
                    },
                ),
                IconButton(
                    icon: Icon(Icons.zoom_in),
                    tooltip: 'Zoom In',
                    onPressed: () {
                        setState(() {
                            mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                            );
                        });
                    },
                ),
                IconButton(
                    icon: Icon(Icons.zoom_out),
                    tooltip: 'Zoom Out',
                    onPressed: () {
                        setState(() {
                            mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                            );
                        });
                    },
                ),
                IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: 'Reset Zoom',
                    onPressed: () {
                        setState(() {
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: _center ,
                                        zoom: _zoomState,
                                    )
                                ),
                            );
                        });
                    },
                )
            ];
        }

        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    title: Text('Flutter Map App'),
                    actions: mapControls(),
                    backgroundColor: Colors.green[700],
                ),
                body: googleMap ,
            ),
        );
    }
}

