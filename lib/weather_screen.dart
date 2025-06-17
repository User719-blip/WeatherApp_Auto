import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http; // Importing the http package for network requests
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget
{
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
 // bool isLoading = false; // used insted of temp == 0
  
  Future<Map<String,dynamic>> getWeatherData() async {
    // Here you would typically make an HTTP request to a weather API
    // and return the weather data.
    // For this example, we will just simulate a delay.
    // String city = 'London,uk';
    // String apiKey = '08751c4124e070e3ec102c17f1e54770';
    final position = await getUserLocation();
    final lat = position.latitude;
    final lon = position.longitude;
    String apiKey = 'YOUR_API_KEY';// this is just place holder for the api key
    try{
    final result = await http.get(
    Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&APPID=$apiKey'),
   );
  //  return result.body;
    if (result.statusCode == 200) {
      //  final data = result.body ;
      // Here you would typically parse the JSON data and update your state.
      final data = jsonDecode(result.body);
      return data;
        //decodedData['list'][0]['main']['temp'];
        //isLoading = true; //rebuilds the build function every time
        // 
      // For demonstration, we just print the dat
    } else {
      // If the server did not return an OK response, throw an exception.
      throw Exception('Failed to load weather data');
    }
  } catch (e) {
     throw e.toString;
    }
  }
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
          style: TextStyle(fontWeight:  FontWeight.bold)
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  // This will trigger a rebuild of the widget
                  // and call the getWeatherData function again.
                });
              },
            ),
          ],
        centerTitle: true,
      ),
    body: 
      FutureBuilder( //pass any Future and then build 
        future: getWeatherData() ,
        builder: (context , snapshot) //snapsort allows us to handle the state of future object
        {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final data = snapshot.data!; // Unwrapping the data from the snapshot
          // Assuming the data is a Map<String, dynamic>
          final temp = (data['list'][0]['main']['temp']-273.15).toStringAsFixed(1); // Accessing the temperature from the data
          final sky  = data['list'][0]['weather'][0]['main'] ; // Accessing the sky condition
          final pressure = data['list'][0]['main']['pressure']; // Accessing the pressure
          final windSpeed = data['list'][0]['wind']['speed']; // Accessing the wind speed
          final humidity = data['list'][0]['main']['humidity']; // Accessing the humidity
           //snapshot.data is the data returned by the future
          // print(snapshot);
          // print (snapshot.runtimeType);
          return   Padding(
          padding: const EdgeInsets.all(16.0),
          child:Column(
          children: [
          SizedBox(
            width: double.infinity ,
            child : Card(
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0), 
              ), 
              elevation: 0,
              child : ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
              // This is the background image of the card
              child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),   
              child :  Padding(
              padding: const EdgeInsets.all(16.0),
              child:Column(
                children: [
                Text('$temp °C',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                ), 
                Icon(
                  sky == 'Clear'
                      ? Icons.wb_sunny
                      : sky == 'Clouds'
                          ? Icons.cloud
                          : sky == 'Rain'
                              ? Icons.beach_access
                              : Icons.error, // Default icon for unknown weather
                  size: 64,
                  color: const Color.fromARGB(255, 252, 252, 252),
                ), 
                Text('$sky',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ), 
              ],
              ),
             ),
           ),
              )
            ),
          ),
            const Text(
              'Weather Forecast',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
           
           SizedBox(
             height: 120,
             child: ListView.builder(
              itemCount: 8, // Assuming you want to show 24 hours of forecast
              // Adjust the itemCount based on your data
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Assuming the data['list'] contains the hourly forecast data
                final hourlyData = data['list'][index+1]; // Taking the first 5 items for hourly forecast
                final time = DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000).toLocal().toString().substring(11, 16); // Extracting time from timestamp
                final temperature = '${(hourlyData['main']['temp'] - 273.15).toStringAsFixed(1)}°C'; // Accessing temperature
                final icon = hourlyData['weather'][0]['main'] == 'Clear'
                    ? Icons.wb_sunny
                    : hourlyData['weather'][0]['main'] == 'Clouds'
                        ? Icons.cloud
                        : hourlyData['weather'][0]['main'] == 'Rain'
                            ? Icons.beach_access
                            : Icons.error; // Default icon for unknown weather
             
                return HourlyForcast(
                  icon: icon,
                  time: time,
                  temperature: temperature,
              // Taking the first 5 items for hourly forecast
               );
              },
             ),
           ),
            
            SizedBox(height: 16),
            const Text(
              'Additional Information',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(11.0),//16 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Additionalinfo(
                    icon: Icons.water_drop,
                    text: 'Humidity',
                    value: '${humidity.toString()}  %', // Convert humidity to string and append ' %'
                  ),
                  Additionalinfo(
                    icon: Icons.air,
                    text: 'Wind Speed',
                    value: '${windSpeed.toString()}   m/s', // Convert wind speed to string and append ' m/s'
                  ),
                  Additionalinfo(
                    icon: Icons.thermostat,
                    text: 'Pressure',
                    value: '${pressure.toString()} hPa', // Convert pressure to string and append ' hPa'
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      }
      )
    );
  }
}


class HourlyForcast extends StatelessWidget
{
  final IconData icon;
  final String time;
  final String temperature;
  const HourlyForcast({super.key
  ,required this.icon , required this.time , required this.temperature});
  @override

  Widget build(BuildContext context) 
  {
    return SizedBox(
                  width: 100,
                  child : Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child : Container(
                      width : 100,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          children : [
                          Text(
                          time,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(icon,
                          size: 32),
                        SizedBox(height: 8),
                          Text(
                            temperature,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
  }
}


class Additionalinfo extends StatelessWidget
{
  final IconData icon;
  final String text;
  final String value;
  const Additionalinfo({super.key
  , required this.icon , required this.text , required this.value});
  @override
  Widget build(BuildContext context) 
  {
    return Column(
      children: [
        Text(text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Icon(icon ,
          size: 32,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),        
        SizedBox(height: 4),
        Text(value,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Call this function to get the user's current position
Future<Position> getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever
    return Future.error('Location permissions are permanently denied.');
  }

  // When permissions are granted, get the position
  return await Geolocator.getCurrentPosition();
}
