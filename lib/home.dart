// filepath: /E:/Flutter/developer_hub_week_3/lib/home.dart
import 'package:rhombix_task_3/sign_in.dart';
import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? currentAddress;
  double longi = 0.0;
  double lat = 0.0;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required')),
      );
      return;
    }

    fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      setState(() {
        lat = position.latitude;
        longi = position.longitude;
      });
      getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getAddressFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      Placemark place = placemarks[0];

      setState(() {
        currentAddress =
            "${place.locality}, ${place.street}, ,${place.country}";
      });
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_page'.tr()),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              Locale currentLocale = EasyLocalization.of(context)!.locale;

              Locale newLocale;
              if (currentLocale.languageCode == 'en') {
                newLocale = Locale('es', 'ES');
              } else if (currentLocale.languageCode == 'es') {
                newLocale = Locale('ur', 'PK');
              } else {
                newLocale = Locale('en', 'US');
              }

              context.setLocale(newLocale);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => sign_in(
                            current_location: currentAddress,
                            long: longi,
                            lat: lat)));
              },
              child: Text('sign_in'.tr()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => sign_up(
                            current_location: currentAddress,
                            long: longi,
                            lat: lat)));
              },
              child: Text('sign_up'.tr()),
            ),
            const SizedBox(height: 20),
            Icon(Icons.location_on, size: 50, color: Colors.blue),
            currentAddress != null
                ? Text(
                    currentAddress!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
