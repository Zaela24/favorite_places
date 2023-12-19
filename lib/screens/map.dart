import 'dart:math';

import 'package:favorite_places/misc/tile_providers.dart';
import 'package:favorite_places/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const LatLng(37.422, -122.084),
    this.isSelecting = true,
  });

  final LatLng location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LatLng? tappedCoords;
  Point<double>? tappedPoint;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget map = MapPreview(
      location: widget.location,
      mapZoom: 16,
      isMapScreen: true,
    );

    if (widget.isSelecting) {
      map = FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: widget.location,
          initialZoom: 16,
          onTap: (_, latLng) {
            final point =
                mapController.camera.latLngToScreenPoint(tappedCoords = latLng);
            setState(() {
              tappedPoint = Point(point.x, point.y);
            });
          },
        ),
        children: [
          openStreetMapTileLayer,
          if (tappedCoords != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: tappedCoords!,
                  child: const Icon(Icons.location_pin),
                ),
              ],
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Choose Your Location' : 'Photo Location',
        ),
        actions: widget.isSelecting
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(tappedCoords);
                  },
                  icon: const Icon(Icons.save),
                ),
              ]
            : [],
      ),
      body: map,
    );
  }
}
