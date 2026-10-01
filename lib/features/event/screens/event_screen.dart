import 'package:flutter/material.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/global_widgets/custom_text.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const MyCampusAppBar(title: 'Campus Events'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_rounded, size: 80, color: AppColors.eventColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            const CustomText('No upcoming events', type: TextType.titleMedium, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
