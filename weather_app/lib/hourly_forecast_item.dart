import 'package:flutter/material.dart';

class hourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  final Color fixedcolor;
  const hourlyForecastItem(DateTime dateTime, {super.key,
   required this.time,
    required this.icon,
     required this.temperature,
     required this.fixedcolor
      });

  @override
  Widget build(BuildContext context) {
    return Card(
                      elevation: 6,
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child:  Column(
                          children: [
                            Text(time,
                            style:const  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            ),
                           const SizedBox(height: 8,),
                          Icon(
                            icon,
                            size: 32,
                            color: fixedcolor,
                            
                          ),
                           Text(temperature,
                            ),
                          ],
                        ),
                      ),
                    );
  }
}