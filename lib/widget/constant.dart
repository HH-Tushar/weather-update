import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Map<String, dynamic>? weatherMap;
Map<String, dynamic>? forecastMap;
Map<String, dynamic>? airQualityMap;
Position? position;
Color darkColor=Color(0xff151515);
Color lightColor=Color(0xffF8F9FB);