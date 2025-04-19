import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'call_manager.dart';

final CallManager callManager = Get.find<CallManager>();

class CallButton extends StatelessWidget {
  final int userId;
  final String userType;
  final String name;
  final String image;

  const CallButton({
    super.key,
    required this.userId,
    required this.userType,
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        callManager.startCall(
          userId,
          userType,
          name,
          image,
        );
      },
      icon: Icon(Icons.phone, color: Theme.of(context).primaryColor, size: 20),
      label: const Text('Call'),
    );
  }
}

class CallControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  const CallControlButton({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 32,
        backgroundColor: background,
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
