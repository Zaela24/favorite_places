import 'package:favorite_places/misc/tile_providers.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPreview extends StatelessWidget {
  MapPreview({
    super.key,
    required this.location,
    required this.mapZoom,
    this.isMapScreen = false,
  });

  final LatLng location;
  final double mapZoom;
  final bool isMapScreen;

  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: location,
        initialZoom: mapZoom,
        onTap: (_, loc) {
          if (!isMapScreen) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MapScreen(
                  location: location,
                  isSelecting: false,
                ),
              ),
            );
          }
        },
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
    );
  }
}
