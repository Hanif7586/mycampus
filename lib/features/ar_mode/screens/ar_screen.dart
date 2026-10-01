// lib/features/ar_mode/screens/ar_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/consts/app_colors.dart';
import '../../../core/global_widgets/custom_text.dart';
import '../../../core/global_widgets/app_bar_widget.dart';
import '../../../core/global_widgets/primary_button.dart';

class ArScreen extends StatefulWidget {
  const ArScreen({super.key});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _scanAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _rotateAnim;

  bool _isScanning = false;
  bool _isFound = false;
  String? _foundLocation;
  int _selectedMode = 0;

  final List<_ARMode> _modes = [
    _ARMode(
      icon: Icons.room_rounded,
      label: 'Find Room',
      description: 'Scan to navigate to your classroom',
      color: AppColors.primary,
    ),
    _ARMode(
      icon: Icons.person_search_rounded,
      label: 'Find Teacher',
      description: 'Locate your teacher\'s office or room',
      color: AppColors.accent,
    ),
    _ARMode(
      icon: Icons.local_library_rounded,
      label: 'Library',
      description: 'Navigate to the library & find books',
      color: AppColors.libraryColor,
    ),
    _ARMode(
      icon: Icons.local_cafe_rounded,
      label: 'Cafeteria',
      description: 'Find the cafeteria and canteen',
      color: AppColors.warning,
    ),
  ];

  final List<_CampusLocation> _locations = [
    _CampusLocation(name: 'Room 301 - CSE Building', floor: '3rd Floor', distance: '120m', direction: 'North Wing'),
    _CampusLocation(name: 'Lab-01 - Ground Floor', floor: '1st Floor', distance: '45m', direction: 'East Block'),
    _CampusLocation(name: 'Central Library', floor: 'All Floors', distance: '280m', direction: 'Main Campus'),
    _CampusLocation(name: 'Cafeteria', floor: 'Ground Floor', distance: '190m', direction: 'South Block'),
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _scanAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotateAnim = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() {
      _isScanning = true;
      _isFound = false;
    });
    _scanController.repeat(reverse: true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      _scanController.stop();
      setState(() {
        _isScanning = false;
        _isFound = true;
        _foundLocation = _locations[_selectedMode].name;
      });
    }
  }

  void _reset() {
    setState(() {
      _isFound = false;
      _isScanning = false;
      _foundLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: const MyCampusAppBar(title: 'AR Campus Navigator'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode Selector
              FadeInDown(
                child: SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _modes.length,
                    itemBuilder: (_, i) {
                      final mode = _modes[i];
                      final isSelected = i == _selectedMode;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedMode = i;
                          _reset();
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          width: 110,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? LinearGradient(
                                    colors: [mode.color, mode.color.withOpacity(0.7)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected ? null : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? mode.color.withOpacity(0.5)
                                  : AppColors.borderColor,
                            ),
                            boxShadow: isSelected
                                ? [BoxShadow(
                                    color: mode.color.withOpacity(0.3),
                                    blurRadius: 12)]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(mode.icon,
                                  color: isSelected
                                      ? Colors.white
                                      : mode.color,
                                  size: 24),
                              const SizedBox(height: 6),
                              CustomText(
                                mode.label,
                                type: TextType.labelSmall,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                textAlign: TextAlign.center,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AR Viewfinder
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0B15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isFound
                          ? AppColors.success
                          : _isScanning
                              ? AppColors.primary
                              : AppColors.borderColor,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Grid Pattern (simulating AR feed)
                        CustomPaint(
                          painter: _GridPainter(),
                          child: Container(),
                        ),

                        // Center Target
                        Center(
                          child: AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (_, __) => Transform.scale(
                              scale: _isScanning ? _pulseAnim.value : 1.0,
                              child: _buildTargetView(),
                            ),
                          ),
                        ),

                        // Scanning Line
                        if (_isScanning)
                          AnimatedBuilder(
                            animation: _scanAnim,
                            builder: (_, __) => Positioned(
                              top: _scanAnim.value * 300,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.primary,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Corner Decorations
                        ..._buildCorners(),

                        // Floating Location Markers
                        if (!_isScanning && !_isFound) ...[
                          _buildFloatingMarker('R-301', 60, 80, AppColors.primary),
                          _buildFloatingMarker('Library', 200, 140, AppColors.libraryColor),
                          _buildFloatingMarker('Cafeteria', 80, 220, AppColors.warning),
                        ],

                        // Found Result
                        if (_isFound)
                          _buildFoundResult(),

                        // Scanning Text
                        if (_isScanning)
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const CustomText(
                                  '🔍 Scanning campus...',
                                  type: TextType.labelMedium,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Scan Button
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: _isFound
                    ? Column(
                        children: [
                          PrimaryButton(
                            label: 'Navigate',
                            onPressed: () {},
                            gradientColors: [AppColors.success, AppColors.accent],
                            prefixIcon: const Icon(Icons.navigation_rounded,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(height: 10),
                          PrimaryButton(
                            label: 'Scan Again',
                            variant: ButtonVariant.outlined,
                            onPressed: _reset,
                          ),
                        ],
                      )
                    : PrimaryButton(
                        label: _isScanning ? 'Scanning...' : 'Start AR Scan',
                        isLoading: _isScanning,
                        onPressed: _isScanning ? null : _startScan,
                        prefixIcon: _isScanning
                            ? null
                            : const Icon(Icons.view_in_ar_rounded,
                                color: Colors.white, size: 22),
                      ),
              ),

              const SizedBox(height: 20),

              // Nearby Locations
              if (!_isScanning) ...[
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText('📍 Nearby Locations',
                          type: TextType.titleMedium,
                          fontWeight: FontWeight.w700),
                      const SizedBox(height: 12),
                      ..._locations.map(
                        (loc) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.place_rounded,
                                    color: AppColors.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(loc.name,
                                        type: TextType.titleSmall,
                                        maxLines: 1,
                                        fontWeight: FontWeight.w600),
                                    const SizedBox(height: 3),
                                    CustomText(
                                      '${loc.floor} • ${loc.direction}',
                                      type: TextType.bodySmall,
                                      fontSize: 11,
                                      color: AppColors.textHint,
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomText(
                                    loc.distance,
                                    type: TextType.titleSmall,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded,
                                      color: AppColors.textHint, size: 12),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetView() {
    return AnimatedBuilder(
      animation: _rotateAnim,
      builder: (_, __) => SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Ring
            Transform.rotate(
              angle: _isScanning ? _rotateAnim.value : 0,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (_isFound ? AppColors.success : AppColors.primary)
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Inner Circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isFound ? AppColors.success : AppColors.primary,
                  width: 2,
                ),
                color: (_isFound ? AppColors.success : AppColors.primary)
                    .withOpacity(0.05),
              ),
            ),
            // Center Dot
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isFound ? AppColors.success : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: (_isFound ? AppColors.success : AppColors.primary)
                        .withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
            // Cross Hairs
            _buildCrosshair(horizontal: true),
            _buildCrosshair(horizontal: false),
          ],
        ),
      ),
    );
  }

  Widget _buildCrosshair({required bool horizontal}) {
    return Container(
      width: horizontal ? 100 : 1,
      height: horizontal ? 1 : 100,
      color: AppColors.primary.withOpacity(0.4),
    );
  }

  List<Widget> _buildCorners() {
    const size = 20.0;
    const thickness = 2.0;
    final color = AppColors.primary;
    return [
      Positioned(
        top: 16, left: 16,
        child: _Corner(color: color, size: size, thickness: thickness,
            topLeft: true),
      ),
      Positioned(
        top: 16, right: 16,
        child: _Corner(color: color, size: size, thickness: thickness,
            topRight: true),
      ),
      Positioned(
        bottom: 16, left: 16,
        child: _Corner(color: color, size: size, thickness: thickness,
            bottomLeft: true),
      ),
      Positioned(
        bottom: 16, right: 16,
        child: _Corner(color: color, size: size, thickness: thickness,
            bottomRight: true),
      ),
    ];
  }

  Widget _buildFloatingMarker(String label, double left, double top, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: FadeInUp(
        delay: const Duration(milliseconds: 500),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.4), blurRadius: 8),
            ],
          ),
          child: CustomText(label,
              type: TextType.labelSmall,
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildFoundResult() {
    return Center(
      child: FadeInUp(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.bgCard.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.success.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 32),
              ),
              const SizedBox(height: 12),
              const CustomText('📍 Location Found!',
                  type: TextType.titleLarge,
                  color: AppColors.success,
                  fontWeight: FontWeight.w700),
              const SizedBox(height: 6),
              CustomText(
                _foundLocation ?? '',
                type: TextType.bodyMedium,
                textAlign: TextAlign.center,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 4),
              const CustomText(
                '120m • North Wing • 3rd Floor',
                type: TextType.bodySmall,
                color: AppColors.textHint,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ARMode {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  const _ARMode({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _CampusLocation {
  final String name;
  final String floor;
  final String distance;
  final String direction;
  const _CampusLocation({
    required this.name,
    required this.floor,
    required this.distance,
    required this.direction,
  });
}

class _Corner extends StatelessWidget {
  final Color color;
  final double size;
  final double thickness;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  const _Corner({
    required this.color,
    required this.size,
    required this.thickness,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(
          color: color,
          thickness: thickness,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool topLeft, topRight, bottomLeft, bottomRight;

  _CornerPainter({
    required this.color,
    required this.thickness,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    if (topLeft) {
      canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    }
    if (topRight) {
      canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
    if (bottomLeft) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
      canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    }
    if (bottomRight) {
      canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);
      canvas.drawLine(Offset(size.width, 0), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..strokeWidth = 1;

    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
