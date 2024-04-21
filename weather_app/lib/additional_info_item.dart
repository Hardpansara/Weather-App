import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color fixedColor;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.fixedColor
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: fixedColor,
          ),
        const SizedBox(height: 8,),
          Text(label),
        const SizedBox(height: 8,),
         Text(
          value,
          style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold  
          ),)
    
      ],
    );
  }
}
