import 'package:rhombix_task_3/data/location_map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class product_details extends StatefulWidget {
  final String product_name;
  final String product_price;
  final String product_quality;
  final String product_warranty;
  final String seller_name;
  final String product_image_link;
  final current_location;
  final double lat;
  final double long;

  const product_details({
    super.key,
    required this.product_name,
    required this.product_price,
    required this.product_quality,
    required this.product_warranty,
    required this.seller_name,
    required this.product_image_link,
    this.current_location,
    required this.lat,
    required this.long,
  });

  @override
  State<product_details> createState() => _product_detailsState();
}

class _product_detailsState extends State<product_details> {
  String get current_location_user => widget.current_location;
  double get long => widget.long;
  double get lat => widget.lat;

  Future<void> createPaymentIntent() async {
    final url = Uri.parse('http://192.168.100.14:5000/create-payment-intent');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': int.parse(widget.product_price) * 100, // Amount in cents
        'currency': 'usd',
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final clientSecret = responseData['client_secret'];
      print('Client Secret: $clientSecret');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print('Failed to create payment intent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product_name),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.brown[50],
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.product_image_link,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.product_name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.brown,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Price: \$${widget.product_price}',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                Text(
                  'Quality: ${widget.product_quality}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Warranty: ${widget.product_warranty}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Seller: ${widget.seller_name}',
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 35,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      current_location_user,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => LocationMap(
                                currentLocation: widget.current_location,
                                long: long,
                                lat: lat,
                                productName: widget.product_name,
                                productPrice: widget.product_price,
                                productQuality: widget.product_quality,
                                productWarranty: widget.product_warranty,
                                sellerName: widget.seller_name,
                                productImageLink: widget.product_image_link,
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text('Change Current Location')),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          createPaymentIntent();
                        },
                        child: Icon(Icons.add_shopping_cart)),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.cancel)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
