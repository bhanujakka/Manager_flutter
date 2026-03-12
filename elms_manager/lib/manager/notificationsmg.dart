import 'dart:math' as math;

import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static bool get _isDark => ManagerThemeController.isDark;
  static Color get _bg =>
      _isDark ? const Color(0xFF09031B) : ManagerPalette.pageBg;
  static Color get _sectionBg =>
      _isDark ? const Color(0xFF1A1033) : Colors.white;
  static Color get _itemBg => _isDark ? const Color(0xFF211240) : Colors.white;
  static Color get _cardBorder =>
      _isDark ? const Color(0xFF3A2370) : ManagerPalette.border;
  static Color get _textMuted =>
      _isDark ? const Color(0xFF96A3C8) : ManagerPalette.mutedText;
  static Color get _textDark =>
      _isDark ? const Color(0xFFF2EEFF) : ManagerPalette.titleText;
  static Color get _primaryPurple =>
      _isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
  static Color get _tabBg =>
      _isDark ? const Color(0xFF33215C) : const Color(0xFFF2F0FB);
  static Color get _tabSelectedBg =>
      _isDark ? const Color(0xFF27184B) : Colors.white;
  static Color get _tabHoverBg =>
      _isDark ? const Color(0xFF3D2A69) : const Color(0xFFECE7FF);
  static Color get _tabTextMuted =>
      _isDark ? const Color(0xFF8FA0C8) : ManagerPalette.mutedText;
  static Color get _surfaceButton =>
      _isDark ? const Color(0xFF1D113A) : Colors.white;
  static Color get _controlHoverBg =>
      _isDark ? const Color(0xFF2A174F) : const Color(0xFFF3EEFF);
  static Color get _cardHoverBg =>
      _isDark ? const Color(0xFF29174D) : const Color(0xFFF9F6FF);
  static Color get _hoverOutline =>
      _isDark ? const Color(0xFF5E41A2) : const Color(0xFFC7B5FF);
  static Color get _hoverShadow =>
      _isDark ? const Color(0x55000000) : const Color(0x14000000);
  static Color get _disabledText =>
      _isDark ? const Color(0xFF5E5B74) : const Color(0xFF9CA3AF);
  static Color get _deleteText =>
      _isDark ? const Color(0xFFFF4B57) : const Color(0xFFEF4444);

  static const int _pageSize = 5;

  _NotificationFilter _activeFilter = _NotificationFilter.all;
  int _currentPage = 1;

  final List<_NotificationItem> _allNotifications = <_NotificationItem>[
    const _NotificationItem(
      id: 'n1',
      title: 'Leave Request Approved',
      body:
          'Your leave request for March 15-17 has been approved by your manager.',
      date: '30/1/2026',
      tone: _NotificationTone.success,
      isRead: false,
    ),
    const _NotificationItem(
      id: 'n2',
      title: 'Payslip Available',
      body: 'Your January 2026 payslip is now available for download.',
      date: '29/1/2026',
      tone: _NotificationTone.info,
      isRead: false,
    ),
    const _NotificationItem(
      id: 'n3',
      title: 'Attendance Regularization Required',
      body: 'Please regularize your attendance for January 28, 2026.',
      date: '29/1/2026',
      tone: _NotificationTone.warning,
      isRead: false,
    ),
    const _NotificationItem(
      id: 'n4',
      title: 'Policy Update',
      body: 'New Work From Home policy has been published. Please review.',
      date: '28/1/2026',
      tone: _NotificationTone.info,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n5',
      title: 'System Maintenance',
      body: 'WorkSphere will undergo maintenance on Feb 1, 2026 from 2-4 AM.',
      date: '27/1/2026',
      tone: _NotificationTone.info,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n6',
      title: 'Holiday Calendar Published',
      body: 'The holiday calendar for 2026 has been published in the portal.',
      date: '25/1/2026',
      tone: _NotificationTone.info,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n7',
      title: 'Profile Completion Reminder',
      body: 'Please complete your emergency contact details.',
      date: '24/1/2026',
      tone: _NotificationTone.warning,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n8',
      title: 'Expense Claim Approved',
      body: 'Your expense claim has been approved and queued for payout.',
      date: '23/1/2026',
      tone: _NotificationTone.success,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n9',
      title: 'Security Notice',
      body: 'Please reset your password within 7 days as per policy.',
      date: '21/1/2026',
      tone: _NotificationTone.warning,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n10',
      title: 'Team Event',
      body: 'Monthly team connect is scheduled for Feb 3, 2026.',
      date: '20/1/2026',
      tone: _NotificationTone.info,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n11',
      title: 'Bank Details Verified',
      body: 'Your bank account verification is complete.',
      date: '19/1/2026',
      tone: _NotificationTone.success,
      isRead: true,
    ),
    const _NotificationItem(
      id: 'n12',
      title: 'HR Circular',
      body: 'Updated reimbursement policy is now effective.',
      date: '18/1/2026',
      tone: _NotificationTone.info,
      isRead: true,
    ),
  ];

  int get _unreadCount =>
      _allNotifications.where((_NotificationItem n) => !n.isRead).length;
  int get _totalCount => _allNotifications.length;

  List<_NotificationItem> get _filteredNotifications {
    switch (_activeFilter) {
      case _NotificationFilter.unread:
        return _allNotifications
            .where((_NotificationItem n) => !n.isRead)
            .toList();
      case _NotificationFilter.read:
        return _allNotifications
            .where((_NotificationItem n) => n.isRead)
            .toList();
      case _NotificationFilter.all:
        return List<_NotificationItem>.from(_allNotifications);
    }
  }

  int get _totalPages =>
      math.max(1, (_filteredNotifications.length / _pageSize).ceil());

  List<_NotificationItem> get _pagedNotifications {
    final List<_NotificationItem> filtered = _filteredNotifications;
    final int start = (_currentPage - 1) * _pageSize;
    if (start >= filtered.length) {
      return const <_NotificationItem>[];
    }
    final int end = math.min(start + _pageSize, filtered.length);
    return filtered.sublist(start, end);
  }

  void _normalizePage() {
    if (_currentPage < 1) {
      _currentPage = 1;
    } else if (_currentPage > _totalPages) {
      _currentPage = _totalPages;
    }
  }

  void _setFilter(_NotificationFilter filter) {
    setState(() {
      _activeFilter = filter;
      _currentPage = 1;
    });
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page.clamp(1, _totalPages);
    });
  }

  void _markRead(String id) {
    setState(() {
      final int index = _allNotifications.indexWhere(
        (_NotificationItem n) => n.id == id,
      );
      if (index != -1 && !_allNotifications[index].isRead) {
        _allNotifications[index] = _allNotifications[index].copyWith(
          isRead: true,
        );
      }
      _normalizePage();
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _allNotifications.length; i++) {
        if (!_allNotifications[i].isRead) {
          _allNotifications[i] = _allNotifications[i].copyWith(isRead: true);
        }
      }
      _normalizePage();
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _allNotifications.removeWhere((_NotificationItem n) => n.id == id);
      _normalizePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _overviewCard(),
              const SizedBox(height: 12),
              _notificationSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: _isDark
              ? const <Color>[Color(0xFF7C3AED), Color(0xFFA78BFA)]
              : const <Color>[Color(0xFF7C3AED), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Stay updated with important alerts and messages',
                  style: TextStyle(
                    color: _isDark ? const Color(0xFFE4DAFC) : Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _overviewStat(label: 'Unread', value: '$_unreadCount'),
          const SizedBox(width: 16),
          _overviewStat(label: 'Total', value: '$_totalCount'),
        ],
      ),
    );
  }

  static Widget _overviewStat({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _notificationSection() {
    final List<_NotificationItem> visible = _pagedNotifications;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _sectionBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        children: <Widget>[
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget markAllButton = TextButton.icon(
                onPressed: _unreadCount == 0 ? null : _markAllAsRead,
                style:
                    TextButton.styleFrom(
                      foregroundColor: _textDark,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: _cardBorder),
                      ),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        Set<WidgetState> states,
                      ) {
                        if (_unreadCount == 0) {
                          return _surfaceButton;
                        }
                        if (states.contains(WidgetState.hovered)) {
                          return _controlHoverBg;
                        }
                        return _surfaceButton;
                      }),
                    ),
                icon: Icon(Icons.check, size: 18),
                label: Text(
                  'Mark All as Read',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              );

              return Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'All Notifications',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  markAllButton,
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _filterTabs(),
          const SizedBox(height: 16),
          if (visible.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _cardBorder),
                color: _surfaceButton,
              ),
              child: Text(
                'No notifications in this section.',
                style: TextStyle(
                  color: _textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            for (final _NotificationItem notification in visible) ...<Widget>[
              _notificationCard(notification),
              const SizedBox(height: 12),
            ],
          Divider(height: 32, color: _cardBorder),
          _paginationRow(),
        ],
      ),
    );
  }

  Widget _filterTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _tabBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: <Widget>[
          _filterTab(
            label: 'All ($_totalCount)',
            selected: _activeFilter == _NotificationFilter.all,
            onTap: () => _setFilter(_NotificationFilter.all),
          ),
          const SizedBox(width: 6),
          _filterTab(
            label: 'Unread ($_unreadCount)',
            selected: _activeFilter == _NotificationFilter.unread,
            onTap: () => _setFilter(_NotificationFilter.unread),
          ),
          const SizedBox(width: 6),
          _filterTab(
            label: 'Read (${_totalCount - _unreadCount})',
            selected: _activeFilter == _NotificationFilter.read,
            onTap: () => _setFilter(_NotificationFilter.read),
          ),
        ],
      ),
    );
  }

  Widget _filterTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    bool expand = true,
  }) {
    final Widget tab = _HoverStateBuilder(
      cursor: SystemMouseCursors.click,
      builder: (bool hovered) {
        final bool isHovered = hovered && !selected;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? _tabSelectedBg
                    : (isHovered ? _tabHoverBg : Colors.transparent),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? _textDark : _tabTextMuted,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (!expand) {
      return tab;
    }

    return Expanded(child: tab);
  }

  Widget _notificationCard(_NotificationItem entry) {
    final _ToneStyle tone = _tone(entry.tone);
    return _HoverStateBuilder(
      builder: (bool hovered) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: hovered ? _cardHoverBg : _itemBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: hovered ? _hoverOutline : _cardBorder),
            boxShadow: hovered
                ? <BoxShadow>[
                    BoxShadow(
                      color: _hoverShadow,
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: tone.soft,
                      shape: BoxShape.circle,
                      border: Border.all(color: tone.border),
                    ),
                    child: Icon(tone.icon, color: tone.color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          entry.title,
                          style: TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          entry.body,
                          style: TextStyle(color: _textMuted, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tone.chipBg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: tone.border),
                    ),
                    child: Text(
                      tone.label,
                      style: TextStyle(
                        color: tone.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _notificationActions(entry),
            ],
          ),
        );
      },
    );
  }

  Widget _notificationActions(_NotificationItem entry) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.maxWidth < 360;

        final Widget markReadButton = TextButton.icon(
          onPressed: () => _markRead(entry.id),
          style: TextButton.styleFrom(
            foregroundColor: _textDark,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          icon: Icon(Icons.check, size: 18),
          label: Text(
            'Mark Read',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );

        final Widget deleteButton = TextButton.icon(
          onPressed: () => _deleteNotification(entry.id),
          style: TextButton.styleFrom(
            foregroundColor: _deleteText,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
          icon: Icon(Icons.delete_outline, size: 18),
          label: Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                entry.date,
                style: TextStyle(color: _textMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  if (!entry.isRead) markReadButton,
                  const Spacer(),
                  deleteButton,
                ],
              ),
            ],
          );
        }

        return Row(
          children: <Widget>[
            Text(entry.date, style: TextStyle(color: _textMuted, fontSize: 12)),
            const Spacer(),
            if (!entry.isRead) ...<Widget>[
              markReadButton,
              const SizedBox(width: 8),
            ],
            deleteButton,
          ],
        );
      },
    );
  }

  Widget _paginationRow() {
    final int filteredCount = _filteredNotifications.length;
    final int start = filteredCount == 0
        ? 0
        : ((_currentPage - 1) * _pageSize) + 1;
    final int end = filteredCount == 0
        ? 0
        : math.min(_currentPage * _pageSize, filteredCount);
    final bool canGoPrevious = _currentPage > 1;
    final bool canGoNext = _currentPage < _totalPages;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final List<Widget> controls = <Widget>[
          _pageControl(
            label: 'Previous',
            icon: Icons.chevron_left,
            enabled: canGoPrevious,
            onTap: canGoPrevious ? () => _goToPage(_currentPage - 1) : null,
          ),
        ];
        for (int i = 1; i <= _totalPages; i++) {
          controls
            ..add(const SizedBox(width: 8))
            ..add(_pageNumber('$i', i == _currentPage, () => _goToPage(i)));
        }
        controls
          ..add(const SizedBox(width: 8))
          ..add(
            _pageControl(
              label: 'Next',
              icon: Icons.chevron_right,
              iconAfter: true,
              enabled: canGoNext,
              onTap: canGoNext ? () => _goToPage(_currentPage + 1) : null,
            ),
          );

        final Widget pageButtons = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: controls,
          ),
        );

        final String summary =
            'Showing $start to $end of $filteredCount notifications';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              summary,
              textAlign: TextAlign.center,
              style: TextStyle(color: _textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Align(alignment: Alignment.center, child: pageButtons),
          ],
        );
      },
    );
  }

  Widget _pageNumber(String label, bool active, VoidCallback onTap) {
    return _HoverStateBuilder(
      cursor: SystemMouseCursors.click,
      builder: (bool hovered) {
        final bool isHovered = hovered && !active;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOutCubic,
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active
                    ? _primaryPurple
                    : (isHovered ? _controlHoverBg : _surfaceButton),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isHovered ? _hoverOutline : _cardBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : _textDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _pageControl({
    required String label,
    required IconData icon,
    required bool enabled,
    required VoidCallback? onTap,
    bool iconAfter = false,
  }) {
    final Color color = enabled ? _textMuted : _disabledText;

    return _HoverStateBuilder(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      builder: (bool hovered) {
        final bool isHovered = hovered && enabled;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: enabled ? onTap : null,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isHovered ? _controlHoverBg : _surfaceButton,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isHovered ? _hoverOutline : _cardBorder,
                ),
              ),
              child: ClipRect(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!iconAfter) Icon(icon, size: 18, color: color),
                      if (!iconAfter) const SizedBox(width: 2),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (iconAfter) const SizedBox(width: 2),
                      if (iconAfter) Icon(icon, size: 18, color: color),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _ToneStyle _tone(_NotificationTone tone) {
    if (_isDark) {
      switch (tone) {
        case _NotificationTone.success:
          return const _ToneStyle(
            label: 'success',
            color: Color(0xFF13D6A6),
            soft: Color(0xFF102B2A),
            border: Color(0xFF1F6D65),
            chipBg: Color(0xFF153836),
            icon: Icons.check_circle_outline,
          );
        case _NotificationTone.warning:
          return const _ToneStyle(
            label: 'warning',
            color: Color(0xFFF7B23A),
            soft: Color(0xFF2B2110),
            border: Color(0xFF6F5422),
            chipBg: Color(0xFF3A2B14),
            icon: Icons.warning_amber_outlined,
          );
        case _NotificationTone.info:
          return const _ToneStyle(
            label: 'info',
            color: Color(0xFF4E9BFF),
            soft: Color(0xFF11223F),
            border: Color(0xFF27518C),
            chipBg: Color(0xFF193463),
            icon: Icons.info_outline,
          );
      }
    }

    switch (tone) {
      case _NotificationTone.success:
        return const _ToneStyle(
          label: 'success',
          color: Color(0xFF10B981),
          soft: Color(0xFFECFDF3),
          border: Color(0xFFBBF7D0),
          chipBg: Color(0xFFE8FFF2),
          icon: Icons.check_circle_outline,
        );
      case _NotificationTone.warning:
        return const _ToneStyle(
          label: 'warning',
          color: Color(0xFFF59E0B),
          soft: Color(0xFFFFF7ED),
          border: Color(0xFFFED7AA),
          chipBg: Color(0xFFFFF3E0),
          icon: Icons.warning_amber_outlined,
        );
      case _NotificationTone.info:
        return const _ToneStyle(
          label: 'info',
          color: Color(0xFF3B82F6),
          soft: Color(0xFFEFF6FF),
          border: Color(0xFFBFDBFE),
          chipBg: Color(0xFFE8F1FF),
          icon: Icons.info_outline,
        );
    }
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.tone,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final String date;
  final _NotificationTone tone;
  final bool isRead;

  _NotificationItem copyWith({bool? isRead}) {
    return _NotificationItem(
      id: id,
      title: title,
      body: body,
      date: date,
      tone: tone,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum _NotificationTone { success, info, warning }

enum _NotificationFilter { all, unread, read }

class _HoverStateBuilder extends StatefulWidget {
  const _HoverStateBuilder({
    required this.builder,
    this.cursor = SystemMouseCursors.basic,
  });

  final Widget Function(bool hovered) builder;
  final MouseCursor cursor;

  @override
  State<_HoverStateBuilder> createState() => _HoverStateBuilderState();
}

class _HoverStateBuilderState extends State<_HoverStateBuilder> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(_hovered),
    );
  }
}

class _ToneStyle {
  const _ToneStyle({
    required this.label,
    required this.color,
    required this.soft,
    required this.border,
    required this.chipBg,
    required this.icon,
  });

  final String label;
  final Color color;
  final Color soft;
  final Color border;
  final Color chipBg;
  final IconData icon;
}
