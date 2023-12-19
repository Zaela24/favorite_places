import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/map_preview.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:open_geocoder/model/geo_address.dart';
import 'package:open_geocoder/open_geocoder.dart';
import 'package:latlong2/latlong.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    getAddressWithLatLong(locationData.latitude!, locationData.longitude!);
  }

  void getAddressWithLatLong(double lat, double long) async {
    GeoLatLang? geoLatLong = await OpenGeocoder.getAddressWithLatLong(
        latitude: lat, longitude: long);
    if (geoLatLong != null) {
      setState(() {
        _pickedLocation = PlaceLocation(
          lat: lat,
          long: long,
          address: geoLatLong.displayName!,
        );
      });
      widget.onSelectLocation(_pickedLocation!);
    }
    setState(() {
      _isGettingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = MapPreview(
        location: LatLng(_pickedLocation!.lat, _pickedLocation!.long),
        mapZoom: 16,
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        ),
      ],
    );
  }
}
