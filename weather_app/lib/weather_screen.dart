import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String selectedCity = 'Ahmedabad'; // Default city

  Future<Map<String, dynamic>> getCurrentWeather(String cityName) async {
    final res = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$selectedCity&APPID=$openWeatherApiKey'),
    );
    final data = jsonDecode(res.body);
    if (data['cod'] != '200') {
      throw 'an unexpected error occurred';
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedCity,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(selectedCity),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final currentTemp =
              ((data['list'][0]['main']['temp'] - 273.15).toStringAsFixed(2)) +
                  ' °C';
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          Color fixedColor = Colors.orange;
          if (currentSky == 'Clouds' || currentSky == 'Rain') {
            fixedColor = Colors.blue;
          }
          DateTime time;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
  value: selectedCity,
  onChanged: (String? newValue) {
    setState(() {
      selectedCity = newValue!;
    });
  },
  itemHeight: 70, // Adjust the item height as needed
  style: const TextStyle(
    color: Colors.white, // Custom text color
    fontSize: 16, // Custom font size
    fontWeight: FontWeight.bold, // Custom font weight
    
  ),
  items: <String>[
    'Ahmedabad',
    'Anand',
    'Bharuch',
    'Bhavnagar',
    'Bhuj',
    'Gandhinagar',
    'Jamnagar',
    'Junagadh',
    'Nadiad',
    'Navsari',
    'Rajkot',
    'Surat',
    'Valsad',
    'Vapi',
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: const TextStyle(
          // Add specific styles for dropdown items if needed
        ),
      ),
    );
  }).toList(),
),


                  // main
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  currentTemp,
                                  style: const TextStyle(
                                    fontSize: 32,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentSky == 'Clouds'
                                      ? Icons.cloud
                                      : currentSky == 'Rain'
                                          ? Icons.beach_access
                                          : Icons.sunny,
                                  size: 64,
                                  color: fixedColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // weather forecast card
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 8; i++)
                          hourlyForecastItem(
                            time =
                                DateTime.parse(data['list'][i + 1]['dt_txt']),
                            time: DateFormat.j().format(time),
                            icon: data['list'][i + 1]['weather'][0]['main'] ==
                                    'Clouds'
                                ? Icons.cloud
                                : data['list'][i + 1]['weather'][0]['main'] ==
                                        'Rain'
                                    ? Icons.beach_access
                                    : Icons.wb_sunny,
                            temperature:
                                ((data['list'][i + 1]['main']['temp'] - 273.15)
                                        .toStringAsFixed(2)) +
                                    ' °C',
                            fixedcolor: data['list'][i + 1]['weather'][0]
                                            ['main'] ==
                                        'Clouds' ||
                                    data['list'][i + 1]['weather'][0]['main'] ==
                                        'Rain'
                                ? Colors.blue
                                : Colors.orange,
                          ),
                      ],
                    ),
                  ),

                  // additional information
                  const SizedBox(height: 20),
                  const Text(
                    'Weather forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '$currentHumidity%',
                        fixedColor: Colors.blueAccent,
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '${currentWindSpeed}m/s',
                        fixedColor: Colors.blueGrey,
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: '${currentPressure}hPa',
                        fixedColor: Colors.red,
                      ),
                    ],
                  ),
                  // Dropdown selector for city names
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.black,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Designed by Hard Pansara')],
        ),
      ),
    );
  }
}
