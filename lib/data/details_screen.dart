import 'package:flutter/material.dart';

class details_screen extends StatefulWidget {
  const details_screen({
    super.key,
    required this.fee,
    required this.city_pic,
    required this.current_location,
    required this.current_long,
    required this.current_lat,
    required this.city_name,
    required this.weather_main_status,
    required this.temp_min,
    required this.temp_max,
    required this.humidity,
  });

  final String fee;
  final String city_pic;
  final String city_name;
  final String current_location;
  final double current_long;
  final double current_lat;
  final String weather_main_status;
  final String temp_min;
  final String temp_max;
  final String humidity;

  @override
  State<details_screen> createState() => _details_screenState();
}

class _details_screenState extends State<details_screen> {
  final List<Map<String, dynamic>> _checklistItems = [
    {'name': 'Tent', 'checked': true},
    {'name': 'Sleeping Bag', 'checked': true},
    {'name': 'Food', 'checked': true},
    {'name': 'First Aid Kit', 'checked': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city_name),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                widget.city_pic.isNotEmpty
                    ? widget.city_pic
                    : "assets/default.png",
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            /// **Row to display temperature values before the fee**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Min Temp",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                      Text(
                        "${widget.temp_min}°C",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Max Temp",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                      Text(
                        "${widget.temp_max}°C",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Humidity",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                      ),
                      Text(
                        "${widget.humidity}%",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// **Price Box**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Fee: ${widget.fee}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Card(
                color: const Color.fromARGB(144, 158, 158, 158),
                elevation: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: _checklistItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value: _checklistItems[index]['checked'],
                          onChanged: null,
                          activeColor: Colors.blue,
                        ),
                        title: Text(
                          _checklistItems[index]['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
