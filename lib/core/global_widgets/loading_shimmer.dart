// lib/core/global_widgets/loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../consts/app_colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 12,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// --- Specific Shimmer Layouts ---

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const LoadingShimmer(width: 48, height: 48, borderRadius: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoadingShimmer(width: 120, height: 16),
                    const SizedBox(height: 6),
                    LoadingShimmer(width: 80, height: 12, borderRadius: 6),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Banner
          const LoadingShimmer(height: 160, borderRadius: 20),
          const SizedBox(height: 24),
          // Quick Access Grid
          const LoadingShimmer(width: 100, height: 16, borderRadius: 8),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: 8,
            itemBuilder: (_, __) => const LoadingShimmer(borderRadius: 16),
          ),
          const SizedBox(height: 24),
          // Notice List
          const LoadingShimmer(width: 80, height: 16, borderRadius: 8),
          const SizedBox(height: 16),
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: LoadingShimmer(height: 80, borderRadius: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class NoticeShimmer extends StatelessWidget {
  const NoticeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 14,
                          color: AppColors.bgSurface,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 10,
                          width: 100,
                          color: AppColors.bgSurface,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 10, color: AppColors.bgSurface),
              const SizedBox(height: 6),
              Container(height: 10, width: 200, color: AppColors.bgSurface),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceShimmer extends StatelessWidget {
  const AttendanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              5,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerBase,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardShimmer extends StatelessWidget {
  final int count;
  const CardShimmer({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => LoadingShimmer(
        height: 90,
        borderRadius: 16,
        margin: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
