import 'package:flutter/material.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/global_widgets/custom_text.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const MyCampusAppBar(title: 'Library'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_library_rounded, size: 80, color: AppColors.libraryColor.withOpacity(0.5)),
            const SizedBox(height: 16),
            const CustomText('Digital Library Coming Soon', type: TextType.titleMedium, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
