import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constant.dart';
class WeatherToday extends StatelessWidget {

   WeatherToday({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [                    Text(
        "${weatherMap!["main"]["temp"]}°",
        style: TextStyle(
            color: lightColor,
            fontSize: 65,
            fontWeight: FontWeight.w700),
      ),
        const SizedBox(height: 10),
        Text(
          "${weatherMap!["weather"][0]["main"]}",
          style: TextStyle(
              color: lightColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              insp("assets/wind.svg", "Wind speed",
                  "${weatherMap!["wind"]["speed"]} km/h"),
              insp("assets/cloud.svg", "Cloud",
                  "${weatherMap!["clouds"]["all"]}%"),
              insp("assets/humidity.svg", "Humidity",
                  "${weatherMap!["main"]["humidity"]}%"),
            ],
          ),
        ),],
    );
  }

  insp(String imagelink, String fieldName, String value) {
    return SizedBox(
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SvgPicture.asset(
                imagelink,
                height: 30.0,
                width: 30.0,
                fit: BoxFit.cover,
                color: Colors.grey,
                allowDrawingOutsideViewBox: true,
              ),
              Text(
                fieldName,
                style: TextStyle(color: lightColor, fontSize: 12,fontWeight: FontWeight.w400),
              ),
            ],
          ),
          Text(
            "${value}",
            style: TextStyle(color: lightColor, fontSize: 16,fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
