import 'package:rhombix_task_3/data/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({
    super.key,
    required this.currentLocation,
    required this.lat,
    required this.long,
    required this.productName,
    required this.productPrice,
    required this.productQuality,
    required this.productWarranty,
    required this.sellerName,
    required this.productImageLink,
  });

  final String currentLocation;
  final double lat;
  final double long;
  final String productName;
  final String productPrice;
  final String productQuality;
  final String productWarranty;
  final String sellerName;
  final String productImageLink;

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  late MapController _mapController;
  TextEditingController searchController = TextEditingController();
  LatLng? searchedLocation;
  bool check = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _searchLocation() async {
    String query = searchController.text;
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        setState(() {
          check = true;
          searchedLocation =
              LatLng(firstLocation.latitude, firstLocation.longitude);
          _mapController.move(searchedLocation!, 15);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location not found: $query")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location not found: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentLocation),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (check == false) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => product_details(
                      current_location: widget.currentLocation,
                      long: widget.long,
                      lat: widget.lat,
                      product_name: widget.productName,
                      product_price: widget.productPrice,
                      product_quality: widget.productQuality,
                      product_warranty: widget.productWarranty,
                      seller_name: widget.sellerName,
                      product_image_link: widget.productImageLink,
                    ),
                  ),
                  (route) => false,
                );
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => product_details(
                      current_location: searchController.text,
                      long: widget.long,
                      lat: widget.lat,
                      product_name: widget.productName,
                      product_price: widget.productPrice,
                      product_quality: widget.productQuality,
                      product_warranty: widget.productWarranty,
                      seller_name: widget.sellerName,
                      product_image_link: widget.productImageLink,
                    ),
                  ),
                  (route) => false,
                );
              }
            }),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Search for a location...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: (_) => _searchLocation(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.lat, widget.long),
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 50,
                    height: 40,
                    point: LatLng(widget.lat, widget.long),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                  if (searchedLocation != null)
                    Marker(
                      width: 50,
                      height: 40,
                      point: searchedLocation!,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
