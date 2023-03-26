import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'constant.dart';

class AirQuality extends StatelessWidget {
  const AirQuality({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int quality = airQualityMap!["list"][0]["main"]["aqi"] as int;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 40,
          width: 200,
          decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                quality > 3
                    ? "assets/mask5.svg"
                    : (quality == 3)
                        ? "assets/mask2.svg"
                        : "assets/wind1.svg",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
               // color: lightColor,
              ),
              SizedBox(width: 5),
              Text(
                "AQI level $quality",
                style: TextStyle(
                    color: lightColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Text(
          quality > 3
              ? "Poor Air Quality"
              : (quality == 3)
                  ? "Average Air Quality"
                  : "Fresh Air",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: lightColor),
        ),

        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Column(children: [
              components(" CO", airQualityMap!["list"][0]["components"]["co"].toString()),
              components(" NO", airQualityMap!["list"][0]["components"]["no"].toString()),
              components(" NO2", airQualityMap!["list"][0]["components"]["no2"].toString()),
            ],),
            Divider(
              thickness: 2,
              height: 2,
              indent: 5,
              endIndent: 5,
              color: Colors.transparent.withOpacity(0.2),
            ),
            Column(children: [
              components(" O3", airQualityMap!["list"][0]["components"]["o3"].toString()),
              components(" SO2", airQualityMap!["list"][0]["components"]["so2"].toString()),
              components(" pm2_5", airQualityMap!["list"][0]["components"]["pm2_5"].toString()),
            ],),

          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }

  components(String name,String value){
    return SizedBox(
      width: 170,
      height: 30,
      child: Card(
        child: Text("$name : $value  μg/m3",textAlign: TextAlign.center,style: TextStyle(color: lightColor,fontSize: 16,fontWeight: FontWeight.w500),),
        color: Colors.transparent.withOpacity(0.05),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

}
