
import 'package:flutter/material.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
      subtitle: Text(subtitle, style: TextStyle(color: textColor)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
