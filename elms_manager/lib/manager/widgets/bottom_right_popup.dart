import 'dart:async';

import 'package:elms_manager/manager/widgets/popup_style.dart';
import 'package:flutter/material.dart';

class BottomRightPopup {
  static OverlayEntry? _activeEntry;
  static Timer? _dismissTimer;

  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    _dismissTimer?.cancel();
    _activeEntry?.remove();

    final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      return;
    }

    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        final double bottomInset = MediaQuery.of(overlayContext).padding.bottom;
        return IgnorePointer(
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 16,
                bottom: 16 + bottomInset,
                child: _PopupCard(message: message),
              ),
            ],
          ),
        );
      },
    );

    _activeEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(duration, () {
      if (identical(_activeEntry, entry)) {
        entry.remove();
        _activeEntry = null;
      }
    });
  }
}

class _PopupCard extends StatelessWidget {
  const _PopupCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: PopupStyle.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PopupStyle.border),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: PopupStyle.popupShadow,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 1),
              child: Icon(
                Icons.check_circle_outline,
                size: 18,
                color: PopupStyle.primary,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: PopupStyle.titleText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
