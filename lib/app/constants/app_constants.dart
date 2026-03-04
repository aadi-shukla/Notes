class AppConstants {
  // App Info
  static const String appName = 'Notes';
  static const String appVersion = '1.0.0';

  // Sizes
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSm = 8.0;
  static const double borderRadiusMd = 12.0;
  static const double borderRadiusLg = 16.0;
  static const double borderRadiusXl = 20.0;

  // Font Sizes
  static const double fontXSmall = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 18.0;
  static const double fontTitle = 24.0;
  static const double fontHeading = 32.0;

  // Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortDuration = Duration(milliseconds: 200);

  // Validation
  static const int minTitleLength = 1;
  static const int maxTitleLength = 200;
  static const int maxContentLength = 50000;

  // Default Colors
  static const List<String> noteColors = [
    '#FFE4B5', // Moccasin
    '#FFB6C1', // Light Pink
    '#ADD8E6', // Light Blue
    '#90EE90', // Light Green
    '#F0E68C', // Khaki
    '#DDA0DD', // Plum
    '#FFA07A', // Light Salmon
    '#98D8C8', // Mint
  ];

  // Empty States
  static const String emptyNotesMessage =
      'No notes yet! Create your first note.';
  static const String emptySearchMessage =
      'No notes found matching your search.';
  static const String emptyCategoriesMessage = 'No categories yet!';
}
