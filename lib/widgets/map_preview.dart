import 'package:favorite_places/misc/tile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  MapPreview({
    super.key,
    required this.location,
    required this.mapZoom,
  });

  final LatLng location;
  final double mapZoom;

  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: location,
            initialZoom: mapZoom,
          ),
          children: [
            openStreetMapTileLayer,
            MarkerLayer(
              markers: [
                Marker(
                  point: location,
                  child: const Icon(Icons.location_on),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
