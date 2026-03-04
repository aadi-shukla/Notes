import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color color;
  final double opacity;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const GlassContainer({
    Key? key,
    required this.child,
    this.blur = 15,
    this.color = Colors.white,
    this.opacity = 0.1,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveOpacity =
        isDark ? opacity : opacity * 3; // Higher opacity in light mode
    final borderOpacity = isDark ? 0.3 : 0.6;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? 200, // Default height instead of infinity
        borderRadius: 20,
        blur: blur,
        alignment: Alignment.bottomCenter,
        border: isDark ? 2 : 1.5,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(effectiveOpacity),
            color.withOpacity(effectiveOpacity / 2),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(borderOpacity),
            color.withOpacity(borderOpacity * 0.5),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
