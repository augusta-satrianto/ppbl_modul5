import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> generatePolylineLabels(
    List<LatLng> points, String labelText)
{
  if (points.isEmpty) {
    return [];
  }

  // Find the midpoint of the polyline
  final int middleIndex = (points.length / 2).floor();
  final LatLng midpoint = points[middleIndex];

  return [
    Marker(
      point: midpoint,
      width: 100, // Adjust the size as needed
      height: 40,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Text(
            labelText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  ];
}

class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({super.key});

  @override
  State<SimpleMapScreen> createState() => SimpleMapState();
}

class SimpleMapState extends State<SimpleMapScreen> {
  late final List<LatLng> daftarKoorinat;
  late final List<Marker> labelMarkers;

  final LatLng point1 = LatLng(-6.973141110592442, 107.63129581108053);
  final LatLng point2 = LatLng(-6.975901620078193, 107.63661619542846);


  void initState() {
    super.initState();
    daftarKoorinat = const [
      LatLng(-6.973141110592442, 107.63129581108053),
      LatLng(-6.975901620078193, 107.63661619542846)
    ];

     labelMarkers = generatePolylineLabels(daftarKoorinat, 'Jarak: ${distanceInMeters.toStringAsFixed(2)} m' );
  }


  double get distanceInMeters {
    final Distance distance = const Distance();
    return distance(point1, point2);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coba Open Street Map',
      home: Scaffold(
        appBar: AppBar(title: Text('Coba OpenStreetMap')),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(-6.973141110592442, 107.63129581108053),
            initialZoom: 10,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.ppbl',
            ),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: [LatLng(30, 40), LatLng(20, 50), LatLng(25, 45)],
                  color: Colors.blue,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(-6.973141110592442, 107.63129581108053),
                  width: 100,
                  height: 100,
                  child: Icon(Icons.accessible_forward, color: Colors.blueGrey, size: 40),
                ),
              ],
            ),
            //-6.976306580282505, 107.62937819070501
            MarkerLayer(markers: [
              Marker(
                point: LatLng(-6.976306580282505, 107.62937819070501),
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],),
            MarkerLayer(markers: [
              Marker(
                point: LatLng(-6.975901620078193, 107.63661619542846),
                width: 80,
                height: 80,
                child: Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: [
                    LatLng(-6.976306580282505, 107.62937819070501),
                    LatLng(-6.975901620078193, 107.63661619542846),
                    LatLng(-6.970938119861664, 107.63690100750935)],

                  color: Colors.blue,
                ),
              ],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: [
                    LatLng(-6.976306580282505, 107.62937819070501),
                    LatLng(-6.975901620078193, 107.63661619542846)],
                  color: Colors.blue,

                ),
              ],

            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: daftarKoorinat,
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: daftarKoorinat,
                  strokeWidth: 4,
                  color: Colors.blue,
                ),
              ],
            ),
            MarkerLayer(
              markers: labelMarkers,
            ),
            MarkerLayer(
              markers: labelMarkers,
            ),
          ],


        ),
      ),
    );
  }
}