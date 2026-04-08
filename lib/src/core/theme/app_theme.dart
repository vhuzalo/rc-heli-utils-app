import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFFFF6A1A);
  const secondary = Color(0xFF00A3FF);
  const surface = Color(0xFFF2F5F9);
  const surfaceContainer = Color(0xFFE3E9F0);
  const background = Color(0xFFD7DEE8);
  const onSurface = Color(0xFF132033);
  const onSurfaceVariant = Color(0xFF4B5A70);
  const outline = Color(0xFF8D9AAF);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: primary,
    secondary: secondary,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: onSurface,
          displayColor: onSurface,
        ),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.82),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.45)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.92),
      labelStyle: const TextStyle(
        color: onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: surfaceContainer),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: onSurface,
        side: const BorderSide(color: outline),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: onSurface,
        backgroundColor: Colors.white.withOpacity(0.75),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 74,
      backgroundColor: const Color(0xFFE6ECF3),
      indicatorColor: primary.withOpacity(0.16),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        return IconThemeData(
          color: states.contains(MaterialState.selected) ? primary : onSurfaceVariant,
        );
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        return TextStyle(
          fontWeight: FontWeight.w800,
          color: states.contains(MaterialState.selected) ? onSurface : onSurfaceVariant,
        );
      }),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary.withOpacity(0.14);
          }
          return Colors.white.withOpacity(0.72);
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return states.contains(MaterialState.selected) ? onSurface : onSurfaceVariant;
        }),
        side: MaterialStateProperty.all(
          const BorderSide(color: outline),
        ),
        textStyle: const MaterialStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700),
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1B2738),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE7EEF6),
      selectedColor: primary.withOpacity(0.14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      side: BorderSide.none,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
    ),
  );
}
