import 'package:flutter/material.dart';
import 'package:rhombix_task_3/data/details_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class trip_screen extends StatefulWidget {
  const trip_screen(
      {super.key,
      required this.current_location,
      required double this.long,
      required double this.lat});

  final double long;
  final double lat;
  final current_location;

  @override
  State<trip_screen> createState() => _trip_screenState();
}

class _trip_screenState extends State<trip_screen> {
  final String apiKey = '3815b6de9a4872e1ce2e75b336012da3';
  String? weather_main_status;
  String? temp_min;
  String? temp_max;
  String? humidity;

  Future<void> calculate_weather_for_me(String cityName) async {
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        weather_main_status = jsonDecode(response.body)['weather'][0]['main'];
        temp_min = jsonDecode(response.body)['main']['temp_min'].toString();
        temp_max = jsonDecode(response.body)['main']['temp_min'].toString();
        humidity = jsonDecode(response.body)['main']['humidity'].toString();

        print('Weather: $weather_main_status');
        print(temp_min.toString());
        print(temp_max.toString());

        print(humidity.toString());
        // print(data_from_weather_api);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  final List<Map<String, String>> cities = [
    {"name": "Karachi", "image": "assets/karachi.png", "fee": "1000"},
    {"name": "Lahore", "image": "assets/lahore.png", "fee": "2000"},
    {"name": "Islamabad", "image": "assets/isb.png", "fee": "3000"},
    {"name": "Peshawar", "image": "assets/peshawar.png", "fee": "4000"},
    {"name": "Quetta", "image": "assets/quetta.png", "fee": "5000"},
    {"name": "Multan", "image": "assets/multan.png", "fee": "6000"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Screen'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                await calculate_weather_for_me(
                    cities[index]["name"]!); // Wait for weather data

                if (weather_main_status != null &&
                    temp_min != null &&
                    temp_max != null &&
                    humidity != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => details_screen(
                      weather_main_status: weather_main_status!,
                      temp_min: temp_min!,
                      temp_max: temp_max!,
                      humidity: humidity!,
                      fee: cities[index]["fee"]!,
                      city_name: cities[index]["name"]!,
                      city_pic: cities[index]["image"]!,
                      current_location: widget.current_location,
                      current_long: widget.long,
                      current_lat: widget.lat,
                    ),
                  ));
                } else {
                  print("Weather data not available!");
                }
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10)),
                        child: Image.asset(
                          cities[index]["image"]!.isNotEmpty
                              ? cities[index]["image"]!
                              : "assets/default.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 100,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported,
                                  size: 40, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        cities[index]["name"]!,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
