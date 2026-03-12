import 'package:flutter/material.dart';
import 'package:elms_manager/manager/widgets/popup_style.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';

enum _ProfileAction { profile, notifications, logout }

class AppbarMg extends StatelessWidget implements PreferredSizeWidget {
  const AppbarMg({
    super.key,
    this.title = 'Dashboard',
    this.notificationCount = 3,
    this.userInitials = 'MJ',
    this.userName = 'Michael Johnson',
    this.onMenuTap,
    this.isDarkMode = false,
    this.onThemeTap,
    this.onNotificationsTap,
    this.onProfileTap,
  });

  final String title;
  final int notificationCount;
  final String userInitials;
  final String userName;
  final VoidCallback? onMenuTap;
  final bool isDarkMode;
  final VoidCallback? onThemeTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;

  static Color get _card => ManagerPalette.appBarBg;
  static Color get _text => ManagerPalette.titleText;
  static Color get _border => ManagerPalette.appBarBorder;
  static Color get _accent => ManagerPalette.appBarAccent;
  static const Color _primary = Color(0xFF7C3AED);
  static const Color _destructive = Color(0xFFEF4444);

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool showMenuButton = width < 1024;
    final bool showUserName = width >= 768;

    return Material(
      color: _card,
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: width >= 1024 ? 24 : 16),
        decoration: BoxDecoration(
          color: _card,
          border: Border(bottom: BorderSide(color: _border)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  if (showMenuButton) ...<Widget>[
                    _SquareIconButton(
                      icon: Icons.menu,
                      onTap:
                          onMenuTap ??
                          () => Scaffold.maybeOf(context)?.openDrawer(),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: _text,
                        fontWeight: FontWeight.w600,
                        fontSize: showMenuButton ? 16 : 18,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _CircleIconButton(
                  icon: isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  onTap: onThemeTap,
                ),
                const SizedBox(width: 8),
                _NotificationButton(
                  count: notificationCount,
                  onTap: onNotificationsTap,
                ),
                const SizedBox(width: 8),
                _ProfileMenuButton(
                  userInitials: userInitials,
                  userName: userName,
                  showUserName: showUserName,
                  onProfileTap: onProfileTap,
                  onNotificationsTap: onNotificationsTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatefulWidget {
  const _SquareIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_SquareIconButton> createState() => _SquareIconButtonState();
}

class _SquareIconButtonState extends State<_SquareIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? AppbarMg._accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(widget.icon, size: 20, color: AppbarMg._text),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? AppbarMg._accent : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(widget.icon, size: 20, color: AppbarMg._text),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatefulWidget {
  const _NotificationButton({required this.count, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  State<_NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<_NotificationButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final String label = widget.count > 99 ? '99+' : widget.count.toString();

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _hovered ? AppbarMg._accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Icons.notifications_none,
                  size: 20,
                  color: AppbarMg._text,
                ),
              ),
              if (widget.count > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppbarMg._destructive,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuButton extends StatefulWidget {
  const _ProfileMenuButton({
    required this.userInitials,
    required this.userName,
    required this.showUserName,
    this.onProfileTap,
    this.onNotificationsTap,
  });

  final String userInitials;
  final String userName;
  final bool showUserName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationsTap;

  @override
  State<_ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<_ProfileMenuButton> {
  final GlobalKey<PopupMenuButtonState<_ProfileAction>> _menuKey =
      GlobalKey<PopupMenuButtonState<_ProfileAction>>();
  bool _hovered = false;
  bool _menuOpen = false;
  String get _userEmail =>
      '${widget.userName.toLowerCase().replaceAll(RegExp(r'\s+'), '.')}@worksphere.com';

  void _handleSelection(_ProfileAction action) {
    switch (action) {
      case _ProfileAction.profile:
        widget.onProfileTap?.call();
        break;
      case _ProfileAction.notifications:
        widget.onNotificationsTap?.call();
        break;
      case _ProfileAction.logout:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ProfileAction>(
      key: _menuKey,
      tooltip: '',
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      elevation: 10,
      color: PopupStyle.surface,
      surfaceTintColor: PopupStyle.surface,
      shadowColor: PopupStyle.dialogShadow,
      shape: PopupStyle.roundedShape(),
      constraints: const BoxConstraints.tightFor(width: 230),
      onOpened: () {
        if (!_menuOpen) {
          setState(() => _menuOpen = true);
        }
      },
      onCanceled: () {
        if (_menuOpen) {
          setState(() => _menuOpen = false);
        }
      },
      onSelected: (_ProfileAction action) {
        if (_menuOpen) {
          setState(() => _menuOpen = false);
        }
        _handleSelection(action);
      },
      itemBuilder: (_) => <PopupMenuEntry<_ProfileAction>>[
        PopupMenuItem<_ProfileAction>(
          enabled: false,
          height: 56,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.userName,
                style: TextStyle(
                  color: AppbarMg._text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _userEmail,
                style: TextStyle(
                  color: ManagerPalette.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem<_ProfileAction>(
          value: _ProfileAction.profile,
          height: 40,
          child: _MenuRow(icon: Icons.person_outline, text: 'Profile'),
        ),
        PopupMenuItem<_ProfileAction>(
          value: _ProfileAction.notifications,
          height: 40,
          child: _MenuRow(
            icon: Icons.notifications_none_rounded,
            text: 'Notifications',
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem<_ProfileAction>(
          value: _ProfileAction.logout,
          height: 40,
          child: _MenuRow(
            icon: Icons.logout_rounded,
            text: 'Logout',
            textColor: AppbarMg._destructive,
          ),
        ),
      ],
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _hovered || _menuOpen
                ? AppbarMg._accent
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered || _menuOpen
                  ? const Color(0x337C3AED)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppbarMg._primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.userInitials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.showUserName) ...<Widget>[
                const SizedBox(width: 8),
                Text(
                  widget.userName,
                  style: TextStyle(
                    color: AppbarMg._text,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.text, this.textColor});

  final IconData icon;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Color resolvedTextColor = textColor ?? AppbarMg._text;
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: resolvedTextColor),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: resolvedTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
