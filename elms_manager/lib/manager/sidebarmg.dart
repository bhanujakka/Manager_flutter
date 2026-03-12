import 'package:flutter/material.dart';
import 'package:elms_manager/manager/appbarmg.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';

class SidebarMgItem {
  const SidebarMgItem({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

class SidebarMgScaffold extends StatefulWidget {
  const SidebarMgScaffold({
    super.key,
    required this.body,
    this.topTitle = 'Dashboard',
    this.notificationCount = 3,
    this.userInitials = 'MJ',
    this.userName = 'Michael Johnson',
    this.desktopBreakpoint = 1024,
    this.items = _defaultSidebarItems,
    this.initialSelectedIndex = 0,
    this.selectedIndex,
    this.onItemSelected,
    this.onNotificationsTap,
    this.onProfileTap,
    this.isDarkMode = false,
    this.onThemeTap,
  });

  final Widget body;
  final String topTitle;
  final int notificationCount;
  final String userInitials;
  final String userName;
  final double desktopBreakpoint;
  final List<SidebarMgItem> items;
  final int initialSelectedIndex;
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;
  final bool isDarkMode;
  final VoidCallback? onThemeTap;

  static const List<SidebarMgItem> _defaultSidebarItems = <SidebarMgItem>[
    SidebarMgItem(title: 'Dashboard', icon: Icons.dashboard_outlined),
    SidebarMgItem(title: 'Team Overview', icon: Icons.groups_outlined),
    SidebarMgItem(title: 'Task Assign', icon: Icons.assignment_outlined),
    SidebarMgItem(title: 'Attendance Approvals', icon: Icons.access_time),
    SidebarMgItem(
      title: 'Leave Approvals',
      icon: Icons.calendar_month_outlined,
    ),
  ];

  @override
  State<SidebarMgScaffold> createState() => _SidebarMgScaffoldState();
}

class _SidebarMgScaffoldState extends State<SidebarMgScaffold> {
  late int _internalSelectedIndex;
  final GlobalKey<ScaffoldState> _mobileScaffoldKey =
      GlobalKey<ScaffoldState>();
  bool _isDesktopSidebarExpanded = false;

  int get _resolvedSelectedIndex =>
      widget.selectedIndex ?? _internalSelectedIndex;

  @override
  void initState() {
    super.initState();
    _internalSelectedIndex = widget.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(covariant SidebarMgScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == null &&
        oldWidget.initialSelectedIndex != widget.initialSelectedIndex) {
      _internalSelectedIndex = widget.initialSelectedIndex;
    }
  }

  void _onMenuTap(int index, {required bool closeDrawer}) {
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(index);
    } else {
      setState(() {
        _internalSelectedIndex = index;
      });
    }

    if (closeDrawer) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        MediaQuery.sizeOf(context).width >= widget.desktopBreakpoint;
    const double desktopCollapsedSidebarWidth = 76;

    if (isDesktop) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: desktopCollapsedSidebarWidth,
              ),
              child: Column(
                children: <Widget>[
                  AppbarMg(
                    title: widget.topTitle,
                    notificationCount: widget.notificationCount,
                    userInitials: widget.userInitials,
                    userName: widget.userName,
                    isDarkMode: widget.isDarkMode,
                    onMenuTap: () {},
                    onThemeTap: widget.onThemeTap,
                    onNotificationsTap: widget.onNotificationsTap,
                    onProfileTap: widget.onProfileTap,
                  ),
                  Expanded(child: widget.body),
                ],
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: _SidebarMgPanel(
                items: widget.items,
                selectedIndex: _resolvedSelectedIndex,
                onItemTap: (int index) => _onMenuTap(index, closeDrawer: false),
                isDrawer: false,
                isDesktop: true,
                isExpanded: _isDesktopSidebarExpanded,
                onHoverChanged: (bool isHovered) {
                  if (_isDesktopSidebarExpanded != isHovered) {
                    setState(() {
                      _isDesktopSidebarExpanded = isHovered;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _mobileScaffoldKey,
      appBar: AppbarMg(
        title: widget.topTitle,
        notificationCount: widget.notificationCount,
        userInitials: widget.userInitials,
        userName: widget.userName,
        isDarkMode: widget.isDarkMode,
        onMenuTap: () => _mobileScaffoldKey.currentState?.openDrawer(),
        onThemeTap: widget.onThemeTap,
        onNotificationsTap: widget.onNotificationsTap,
        onProfileTap: widget.onProfileTap,
      ),
      drawer: Drawer(
        width: 280,
        child: _SidebarMgPanel(
          items: widget.items,
          selectedIndex: _resolvedSelectedIndex,
          onItemTap: (int index) => _onMenuTap(index, closeDrawer: true),
          isDrawer: true,
          isDesktop: false,
          isExpanded: true,
        ),
      ),
      body: widget.body,
    );
  }
}

class _SidebarMgPanel extends StatelessWidget {
  const _SidebarMgPanel({
    required this.items,
    required this.selectedIndex,
    required this.onItemTap,
    required this.isDrawer,
    required this.isDesktop,
    required this.isExpanded,
    this.onHoverChanged,
  });

  final List<SidebarMgItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemTap;
  final bool isDrawer;
  final bool isDesktop;
  final bool isExpanded;
  final ValueChanged<bool>? onHoverChanged;

  static Color get _sidebarBase => ManagerPalette.sidebarBase;
  static Color get _sidebarAccent => ManagerPalette.sidebarAccent;
  static Color get _sidebarAccentSoft => ManagerPalette.sidebarAccentSoft;
  static Color get _sidebarBorder => ManagerPalette.sidebarBorder;

  @override
  Widget build(BuildContext context) {
    final double panelWidth = (isDrawer || !isDesktop || isExpanded) ? 280 : 76;

    return MouseRegion(
      onEnter: isDesktop ? (_) => onHoverChanged?.call(true) : null,
      onExit: isDesktop ? (_) => onHoverChanged?.call(false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        width: panelWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[_sidebarBase, _sidebarAccent],
          ),
          border: Border(right: BorderSide(color: _sidebarBorder)),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool showExpandedContent =
                  isDrawer || !isDesktop || constraints.maxWidth >= 230;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: showExpandedContent
                        ? const EdgeInsets.fromLTRB(24, 24, 24, 20)
                        : const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: _sidebarBorder)),
                    ),
                    child: Stack(
                      children: <Widget>[
                        showExpandedContent
                            ? Row(
                                children: <Widget>[
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          _sidebarAccent,
                                          const Color(0xFFA78BFA),
                                        ],
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.shield_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'WorkSphere',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'ELMS',
                                        style: TextStyle(
                                          color: Color(0xB3FFFFFF),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Center(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: <Color>[
                                        _sidebarAccent,
                                        const Color(0xFFA78BFA),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.shield_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                        if (isDrawer)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                                size: 18,
                              ),
                              splashRadius: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final SidebarMgItem item = items[index];
                        final bool isSelected = index == selectedIndex;
                        final Widget row = Row(
                          mainAxisAlignment: showExpandedContent
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              item.icon,
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xCCFFFFFF),
                            ),
                            if (showExpandedContent) ...<Widget>[
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xCCFFFFFF),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );

                        final Widget tile = Material(
                          color: isSelected
                              ? _sidebarAccentSoft
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            hoverColor: _sidebarAccentSoft,
                            highlightColor: ManagerPalette.sidebarBorder,
                            splashColor: const Color(0x33FFFFFF),
                            onTap: () => onItemTap(index),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: showExpandedContent ? 16 : 0,
                                vertical: 12,
                              ),
                              child: row,
                            ),
                          ),
                        );

                        if (!showExpandedContent) {
                          return Tooltip(message: item.title, child: tile);
                        }

                        return tile;
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
