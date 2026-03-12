import 'package:flutter/material.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';

class PopupStyle {
  const PopupStyle._();

  static Color get surface => ManagerPalette.surface;
  static Color get border => ManagerPalette.border;
  static Color get titleText => ManagerPalette.titleText;
  static Color get mutedText => ManagerPalette.mutedText;
  static Color get primary => ManagerPalette.primary;
  static Color get danger => ManagerPalette.danger;
  static Color get overlay => ManagerPalette.overlay;

  static Color get dialogShadow => ManagerPalette.dialogShadow;
  static Color get popupShadow => ManagerPalette.popupShadow;

  static RoundedRectangleBorder roundedShape({double radius = 12}) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(color: border),
    );
  }

  static BoxDecoration surfaceDecoration({
    double radius = 12,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border),
      boxShadow: withShadow
          ? <BoxShadow>[
              BoxShadow(
                color: dialogShadow,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ]
          : const <BoxShadow>[],
    );
  }
}
