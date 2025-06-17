import 'package:flutter/material.dart';
import 'package:weatherapp/weather_screen.dart';
void main()
{
  runApp(Myapp());
}

class Myapp extends StatelessWidget 
{
  const Myapp({super.key}) ;
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const WeatherScreen(),
    );
  }
}












