import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tracker/screens/Login_Screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnBoardingScreen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0288D1), // Water-themed blue
      body: Center(
        child: Lottie.asset(
          'images/splash.json', // Lottie JSON saved as an asset
          width: 200.w,
          height: 200.h,
          fit: BoxFit.contain,
        )
      ),
    );
  }
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  bool _isNavigating = false;
  int _currentPage = 0;

  // Water-themed colors
  final Color _primaryColor = const Color(0xFF0288D1); // Vibrant blue
  final Color _secondaryColor = const Color(0xFFBBDEFB); // Light blue
  final Color _accentColor = const Color(0xFF4FC3F7); // Bright blue
  final Color _lightColor = const Color(0xFFFFFFFF); // White

  // Animation controllers
  late AnimationController _backgroundAnimationController;
  late AnimationController _buttonAnimationController;

  // Define water tracker-themed onboarding data
  final List<Map<String, dynamic>> _onboardingData = [
    {
      'imagePath': 'images/icon.png',
      'title': 'STAY HYDRATED',
      'subtitle': 'Daily Water Goals',
      'description':
          'Set personalized daily water intake goals to keep your body hydrated and healthy.',
      'iconData': Icons.local_drink,
      'bgColor': const Color(0xFF0288D1),
    },
    {
      'imagePath': 'images/icon.png',
      'title': 'TRACK YOUR INTAKE',
      'subtitle': 'Smart Monitoring',
      'description':
          'Log your water consumption and get reminders to drink water throughout the day.',
      'iconData': Icons.water_drop,
      'bgColor': const Color(0xFF4FC3F7),
    },
    {
      'imagePath': 'images/icon.png',
      'title': 'BOOST YOUR HEALTH',
      'subtitle': 'Wellness Insights',
      'description':
          'Discover the benefits of hydration with insights and tips to improve your well-being.',
      'iconData': Icons.health_and_safety,
      'bgColor': const Color(0xFF81D4FA),
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });

      // Animate background when page changes
      if (_controller.page?.round() != _currentPage) {
        _backgroundAnimationController.forward(from: 0.0);
      }
    });

    // Initialize animation controllers
    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    _backgroundAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() async {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutQuint;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            var fadeAnimation = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(parent: animation, curve: curve));

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: fadeAnimation, child: child),
            );
          },
        ),
      );
    }
  }

  // Get adaptive sizes based on screen size
  double _getAdaptiveSize(BuildContext context, double size) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final smallerDimension =
        screenHeight < screenWidth ? screenHeight : screenWidth;

    // Scale factor based on screen size
    double scaleFactor = smallerDimension / 400; // Base size
    return size * scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    // Responsive padding
    final horizontalPadding = screenWidth * 0.06;
    final verticalPadding = screenHeight * 0.03;

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              // Animated background color
              final currentColor =
                  _onboardingData[_currentPage]['bgColor'] as Color;

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                            _secondaryColor,
                            currentColor.withAlpha((0.8 * 255).toInt()),
                            _backgroundAnimationController.value,
                          ) ??
                          _secondaryColor,
                      _secondaryColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Animated background elements
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutQuint,
                        top: -50.h + (_currentPage * 20),
                        right: -50.w + (_currentPage * 10),
                        child: Container(
                              width: _getAdaptiveSize(context, 200),
                              height: _getAdaptiveSize(context, 200),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _onboardingData[_currentPage]['bgColor']
                                    .withOpacity(0.15),
                              ),
                            )
                            .animate(
                              onPlay:
                                  (controller) =>
                                      controller.repeat(reverse: true),
                            )
                            .scale(
                              duration: 1200.ms,
                              curve: Curves.easeOutQuint,
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                            ),
                      ),

                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutQuint,
                        bottom: -80.h + (_currentPage * 15),
                        left: -80.w + (_currentPage * 15),
                        child: Container(
                              width: _getAdaptiveSize(context, 250),
                              height: _getAdaptiveSize(context, 250),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _accentColor.withOpacity(0.08),
                              ),
                            )
                            .animate(
                              onPlay:
                                  (controller) =>
                                      controller.repeat(reverse: true),
                            )
                            .scale(
                              duration: 1500.ms,
                              curve: Curves.easeOutQuint,
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.1, 1.1),
                            ),
                      ),

                      // App logo with parallax effect
                      Positioned(
                        top: 20.h,
                        left: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: Offset(
                            (_controller.hasClients
                                    ? _controller.page ?? 0
                                    : 0) *
                                -20.0,
                            0.0,
                          ),
                          child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "AQUA",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24.sp : 28.sp,
                                      fontWeight: FontWeight.w900,
                                      color: _lightColor,
                                      letterSpacing: 1.2,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    "TRACK",
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 24.sp : 28.sp,
                                      fontWeight: FontWeight.w900,
                                      color:
                                          _onboardingData[_currentPage]['bgColor'],
                                      letterSpacing: 1.2,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: 800.ms, delay: 200.ms)
                              .slideY(
                                begin: -0.2,
                                end: 0,
                                duration: 800.ms,
                                curve: Curves.easeOutQuint,
                              ),
                        ),
                      ),

                      // Main content
                      Column(
                        children: [
                          SizedBox(
                            height: _getAdaptiveSize(context, 70),
                          ), // Space for the logo
                          Expanded(
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: _onboardingData.length,
                              itemBuilder: (context, index) {
                                return _buildResponsivePage(
                                  context,
                                  imagePath:
                                      _onboardingData[index]['imagePath'],
                                  title: _onboardingData[index]['title'],
                                  subtitle: _onboardingData[index]['subtitle'],
                                  description:
                                      _onboardingData[index]['description'],
                                  iconData: _onboardingData[index]['iconData'],
                                  color: _onboardingData[index]['bgColor'],
                                  isActive: _currentPage == index,
                                );
                              },
                            ),
                          ),

                          // Bottom navigation with page indicator and buttons
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ),
                            child: Column(
                              children: [
                                // Custom animated page indicator
                                SizedBox(
                                  height: 8.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _onboardingData.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        height: 8.h,
                                        width:
                                            _currentPage == index ? 24.w : 8.w,
                                        decoration: BoxDecoration(
                                          color:
                                              _currentPage == index
                                                  ? _onboardingData[_currentPage]['bgColor']
                                                  : _lightColor.withOpacity(
                                                    0.3,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ).animate().scale(
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
                                ),

                                SizedBox(height: isSmallScreen ? 20.h : 30.h),

                                // Navigation buttons
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Skip button with ripple effect
                                    TextButton(
                                          onPressed:
                                              _isNavigating
                                                  ? null
                                                  : _navigateToLogin,
                                          style: TextButton.styleFrom(
                                            foregroundColor: _lightColor
                                                .withAlpha((0.8 * 255).toInt()),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 12.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          child: Text(
                                            "SKIP",
                                            style: TextStyle(
                                              fontSize:
                                                  isSmallScreen ? 14.sp : 16.sp,
                                              letterSpacing: 1.2,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(duration: 800.ms, delay: 200.ms)
                                        .shimmer(
                                          duration: 1800.ms,
                                          delay: 1200.ms,
                                          color: _lightColor.withOpacity(0.2),
                                        ),

                                    // Next/Get Started button with pulse animation
                                    GestureDetector(
                                          onTap:
                                              _isNavigating
                                                  ? null
                                                  : () {
                                                    _buttonAnimationController
                                                        .forward(from: 0.0);
                                                    if (_currentPage ==
                                                        _onboardingData.length -
                                                            1) {
                                                      _navigateToLogin();
                                                    } else {
                                                      _controller.nextPage(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 500,
                                                            ),
                                                        curve:
                                                            Curves.easeOutQuint,
                                                      );
                                                    }
                                                  },
                                          child: AnimatedBuilder(
                                            animation:
                                                _buttonAnimationController,
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale:
                                                    1.0 -
                                                    (_buttonAnimationController
                                                            .value *
                                                        0.05),
                                                child: AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _onboardingData[_currentPage]['bgColor'],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          30.r,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            _onboardingData[_currentPage]['bgColor']
                                                                .withOpacity(
                                                                  0.4,
                                                                ),
                                                        blurRadius: 12,
                                                        offset: const Offset(
                                                          0,
                                                          6,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        _currentPage ==
                                                                _onboardingData
                                                                        .length -
                                                                    1
                                                            ? 32.w
                                                            : 24.w,
                                                    vertical:
                                                        isSmallScreen
                                                            ? 12.h
                                                            : 16.h,
                                                  ),
                                                  child:
                                                      _isNavigating
                                                          ? SizedBox(
                                                            width: 20.w,
                                                            height: 20.h,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                    Color
                                                                  >(
                                                                    _lightColor,
                                                                  ),
                                                            ),
                                                          )
                                                          : Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                _currentPage ==
                                                                        _onboardingData.length -
                                                                            1
                                                                    ? "GET STARTED"
                                                                    : "NEXT",
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                          ? 13.sp
                                                                          : 15.sp,
                                                                  color:
                                                                      _lightColor,
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  letterSpacing:
                                                                      1.2,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8.w,
                                                              ),
                                                              Icon(
                                                                _currentPage ==
                                                                        _onboardingData.length -
                                                                            1
                                                                    ? Icons
                                                                        .local_drink
                                                                    : Icons
                                                                        .arrow_forward,
                                                                color:
                                                                    _lightColor,
                                                                size:
                                                                    isSmallScreen
                                                                        ? 16.sp
                                                                        : 18.sp,
                                                              ),
                                                            ],
                                                          ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .animate()
                                        .scale(
                                          duration: 800.ms,
                                          delay: 400.ms,
                                          curve: Curves.easeOut,
                                        )
                                        .shimmer(
                                          duration: 1800.ms,
                                          delay: 1200.ms,
                                          color: _lightColor.withOpacity(0.2),
                                        )
                                        .animate(
                                          onPlay:
                                              (controller) => controller.repeat(
                                                reverse: true,
                                              ),
                                        )
                                        .scale(
                                          duration: 2000.ms,
                                          begin: const Offset(1.0, 1.0),
                                          end: const Offset(1.05, 1.05),
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildResponsivePage(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String subtitle,
    required String description,
    required IconData iconData,
    required Color color,
    required bool isActive,
  }) {
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    // Responsive padding and sizing
    final horizontalPadding = screenWidth * 0.06;
    final verticalPadding = screenHeight * 0.02;
    final imageHeight =
        isSmallScreen ? screenHeight * 0.25 : screenHeight * 0.3;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            // Landscape layout
            return Row(
              children: [
                // Left side - Image
                Expanded(
                  flex: 5,
                  child: _buildImageSection(
                    context,
                    imagePath: imagePath,
                    iconData: iconData,
                    color: color,
                    isActive: isActive,
                  ),
                ),

                // Right side - Content
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildContentSection(
                      context,
                      title: title,
                      subtitle: subtitle,
                      description: description,
                      color: color,
                      isActive: isActive,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Portrait layout
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image with enhanced container
                  _buildImageSection(
                    context,
                    imagePath: imagePath,
                    iconData: iconData,
                    color: color,
                    isActive: isActive,
                    height: imageHeight,
                  ),

                  SizedBox(height: isSmallScreen ? 20.h : 30.h),

                  // Content section
                  _buildContentSection(
                    context,
                    title: title,
                    subtitle: subtitle,
                    description: description,
                    color: color,
                    isActive: isActive,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context, {
    required String imagePath,
    required IconData iconData,
    required Color color,
    required bool isActive,
    double? height,
  }) {
    return Container(
          height: height ?? 220.h,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero image with parallax effect
              Transform.scale(
                scale: 1.1,
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),

              // Gradient overlay for better text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _secondaryColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Animated water icon overlay
              if (isActive)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(iconData, color: Colors.white, size: 24),
                      )
                      .animate()
                      .scale(duration: 400.ms, curve: Curves.easeOutBack)
                      .animate(
                        onPlay:
                            (controller) => controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.1, 1.1),
                        duration: 1000.ms,
                      ),
                ),
            ],
          ),
        )
        .animate(target: isActive ? 1 : 0)
        .slideY(
          duration: 800.ms,
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutQuint,
          delay: 100.ms,
        )
        .animate(
          onPlay:
              (controller) =>
                  controller.repeat(period: const Duration(milliseconds: 3000)),
        )
        .shimmer(duration: 3000.ms, color: color.withOpacity(0.2));
  }

  Widget _buildContentSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required bool isActive,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        // Title with accent bar
        Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20.sp : 24.sp,
                    fontWeight: FontWeight.w800,
                    color: _lightColor,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            )
            .animate(target: isActive ? 1 : 0)
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 800.ms),

        SizedBox(height: 12.h),

        // Subtitle with color animation
        Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 16.sp : 18.sp,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Montserrat',
                letterSpacing: 0.5,
              ),
            )
            .animate(target: isActive ? 1 : 0)
            .fadeIn(duration: 800.ms, delay: 300.ms)
            .slideY(begin: 0.2, end: 0, duration: 800.ms),

        SizedBox(height: 16.h),

        // Description with typing animation
        Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 14.sp : 16.sp,
                fontWeight: FontWeight.w400,
                color: _lightColor.withOpacity(0.8),
                fontFamily: 'Montserrat',
                height: 1.6,
              ),
            )
            .animate(target: isActive ? 1 : 0)
            .fadeIn(duration: 800.ms, delay: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 800.ms)
            .animate(
              onPlay:
                  (controller) => controller.repeat(
                    period: const Duration(milliseconds: 3000),
                  ),
            )
            .shimmer(duration: 3000.ms, color: color.withOpacity(0.2)),
      ],
    );
  }
}
