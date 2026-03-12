import 'package:flutter/material.dart';
import 'package:elms_manager/manager/widgets/bottom_right_popup.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:elms_manager/manager/widgets/popup_style.dart';

class DashboardMgView extends StatelessWidget {
  const DashboardMgView({
    super.key,
    this.onViewFullTeamTap,
    this.onManageLeaveApprovalsTap,
  });

  final VoidCallback? onViewFullTeamTap;
  final VoidCallback? onManageLeaveApprovalsTap;

  static Color get _pageBg => ManagerPalette.pageBg;
  static Color get _cardBg => ManagerPalette.surface;
  static Color get _cardHoverBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : _cardBg;
  static Color get _reviewButtonBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurface
      : const Color(0xFFF2F2F7);
  static Color get _reviewButtonText =>
      ManagerThemeController.isDark ? _titleText : const Color(0xFF111827);
  static Color get _cardBorder => ManagerPalette.border;
  static Color get _mutedText => ManagerPalette.mutedText;
  static Color get _titleText => ManagerPalette.titleText;
  static const Color _purpleStart = Color(0xFF7C3AED);
  static const Color _purpleEnd = Color(0xFF8E79E8);
  static const Color _green = Color(0xFF00B86B);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: const TextScaler.linear(0.9)),
      child: Container(
        color: _pageBg,
        child: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final bool isWide = width >= 1180;
              final bool isTablet = width >= 700;
              final int metricColumns = isWide ? 4 : (isTablet ? 2 : 1);

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isWide ? 24 : 16,
                  16,
                  isWide ? 24 : 16,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 1220 : 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildHeroCard(),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: metricColumns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isWide
                              ? 1.65
                              : (isTablet ? 1.45 : 2.15),
                          children: <Widget>[
                            _MetricCard(
                              title: 'Team Size',
                              value: '12',
                              subtitle: 'Active Members',
                              icon: Icons.groups_2_outlined,
                              iconBackground: Color(0xFF3B82F6),
                            ),
                            _MetricCard(
                              title: 'Present Today',
                              value: '11',
                              subtitle: '91.7% Attendance',
                              icon: Icons.check_circle_outline,
                              iconBackground: Color(0xFF00C853),
                            ),
                            _MetricCard(
                              title: 'Pending Leave Approvals',
                              value: '3',
                              subtitle: 'Requires Action',
                              icon: Icons.event_outlined,
                              iconBackground: Color(0xFFFF6D00),
                            ),
                            _MetricCard(
                              title: 'Attendance Approvals',
                              value: '2',
                              subtitle: 'Regularization',
                              icon: Icons.history_toggle_off,
                              iconBackground: Color(0xFF9333EA),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _PendingApprovalsCard(),
                        const SizedBox(height: 12),
                        _TeamPerformanceCard(),
                        const SizedBox(height: 12),
                        if (isTablet)
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: _ActionCard(
                                  title: 'View Full Team',
                                  icon: Icons.groups_2_outlined,
                                  onTap: onViewFullTeamTap,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _ActionCard(
                                  title: 'Manage Leave Approvals',
                                  icon: Icons.calendar_today_outlined,
                                  onTap: onManageLeaveApprovalsTap,
                                ),
                              ),
                            ],
                          )
                        else ...<Widget>[
                          _ActionCard(
                            title: 'View Full Team',
                            icon: Icons.groups_2_outlined,
                            onTap: onViewFullTeamTap,
                          ),
                          const SizedBox(height: 12),
                          _ActionCard(
                            title: 'Manage Leave Approvals',
                            icon: Icons.calendar_today_outlined,
                            onTap: onManageLeaveApprovalsTap,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return _HoverCard(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[_purpleStart, _purpleEnd],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Team Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Manage your team's attendance and leave requests",
              style: TextStyle(
                color: Color(0xFFEDE9FE),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  const _HoverCard({
    required this.borderRadius,
    this.child,
    this.builder,
  }) : assert(
          child != null || builder != null,
          'Provide either child or builder.',
        );

  final Widget? child;
  final Widget Function(BuildContext context, bool isHovered)? builder;
  final BorderRadius borderRadius;

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Widget content =
        widget.builder?.call(context, _isHovered) ?? widget.child!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: _isHovered
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A7C3AED),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ]
              : const <BoxShadow>[
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                ],
        ),
        child: content,
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 700;

    return _HoverCard(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 22),
        decoration: BoxDecoration(
          color: DashboardMgView._cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DashboardMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: DashboardMgView._mutedText,
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: isMobile ? 34 : 40,
                  height: isMobile ? 34 : 40,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isMobile ? 18 : 22,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: DashboardMgView._titleText,
                fontSize: isMobile ? 18 : 21,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            SizedBox(height: isMobile ? 2 : 4),
            Text(
              subtitle,
              style: TextStyle(
                color: DashboardMgView._mutedText,
                fontSize: isMobile ? 13 : 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingApprovalsCard extends StatelessWidget {
  const _PendingApprovalsCard();

  @override
  Widget build(BuildContext context) {
    return _PendingApprovalsContent(
      items: const <_ApprovalReviewItem>[
        _ApprovalReviewItem(
          dotColor: Color(0xFFEF4444),
          name: 'John Doe',
          detail: 'Annual Leave - Mar 15-17',
          leaveType: 'Annual Leave',
          dates: 'Mar 15-17, 2026 (3 days)',
          reason: 'Family vacation',
          leaveBalance: '12 days remaining',
          appliedOn: '2026-01-28',
        ),
        _ApprovalReviewItem(
          dotColor: Color(0xFFF59E0B),
          name: 'Sarah Smith',
          detail: 'Regularization - Jan 28',
          leaveType: 'Attendance Regularization',
          dates: 'Jan 28, 2026 (1 day)',
          reason: 'System login issue',
          leaveBalance: 'N/A',
          appliedOn: '2026-01-29',
        ),
        _ApprovalReviewItem(
          dotColor: Color(0xFF6B7280),
          name: 'Mike Johnson',
          detail: 'Sick Leave - Feb 10',
          leaveType: 'Sick Leave',
          dates: 'Feb 10, 2026 (1 day)',
          reason: 'Medical appointment',
          leaveBalance: '8 days remaining',
          appliedOn: '2026-01-30',
        ),
      ],
    );
  }
}

class _PendingApprovalsContent extends StatefulWidget {
  const _PendingApprovalsContent({required this.items});

  final List<_ApprovalReviewItem> items;

  @override
  State<_PendingApprovalsContent> createState() =>
      _PendingApprovalsContentState();
}

class _PendingApprovalsContentState extends State<_PendingApprovalsContent> {
  late final List<_ApprovalReviewItem> _pendingItems;

  @override
  void initState() {
    super.initState();
    _pendingItems = List<_ApprovalReviewItem>.of(widget.items);
  }

  Future<void> _openReview(_ApprovalReviewItem item) async {
    final _ReviewDecision? decision = await showDialog<_ReviewDecision>(
      context: context,
      barrierDismissible: true,
      barrierColor: PopupStyle.overlay,
      builder: (BuildContext dialogContext) {
        return _ReviewApprovalDialog(item: item);
      },
    );

    if (!mounted || decision == null) {
      return;
    }

    if (decision != _ReviewDecision.none) {
      setState(() {
        _pendingItems.remove(item);
      });
      final String actionText = decision == _ReviewDecision.approved
          ? 'approved'
          : 'rejected';
      BottomRightPopup.show(context, '${item.name} request $actionText.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Pending Approvals',
      child: Column(
        children: <Widget>[
          if (_pendingItems.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'No pending approvals.',
                style: TextStyle(
                  color: DashboardMgView._mutedText,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ..._pendingItems.asMap().entries.map((
            MapEntry<int, _ApprovalReviewItem> entry,
          ) {
            final int index = entry.key;
            final _ApprovalReviewItem item = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _pendingItems.length - 1 ? 0 : 12,
              ),
              child: _ApprovalTile(
                dotColor: item.dotColor,
                name: item.name,
                detail: item.detail,
                onReviewTap: () => _openReview(item),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ApprovalTile extends StatelessWidget {
  const _ApprovalTile({
    required this.dotColor,
    required this.name,
    required this.detail,
    required this.onReviewTap,
  });

  final Color dotColor;
  final String name;
  final String detail;
  final VoidCallback onReviewTap;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(12),
      builder: (BuildContext context, bool isHovered) {
        final Color background =
            isHovered ? DashboardMgView._cardHoverBg : DashboardMgView._cardBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DashboardMgView._cardBorder),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: DashboardMgView._titleText,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      detail,
                      style: TextStyle(
                        color: DashboardMgView._mutedText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ReviewButton(onTap: onReviewTap),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewButton extends StatefulWidget {
  const _ReviewButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_ReviewButton> createState() => _ReviewButtonState();
}

class _ReviewButtonState extends State<_ReviewButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = ManagerThemeController.isDark;
    final Color textColor = isDark && _isHovered
        ? ManagerPalette.primary
        : DashboardMgView._reviewButtonText;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: DashboardMgView._reviewButtonBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: DashboardMgView._cardBorder),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: const Text('Review'),
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamPerformanceCard extends StatelessWidget {
  const _TeamPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Team Performance Overview',
      child: Column(
        children: <Widget>[
          _PerformanceTile(
            initials: 'JD',
            name: 'John Doe',
            detail: 'Attendance: 95% - Leaves: 2 days',
            status: 'Excellent',
          ),
          SizedBox(height: 12),
          _PerformanceTile(
            initials: 'SS',
            name: 'Sarah Smith',
            detail: 'Attendance: 88% - Leaves: 4 days',
            status: 'Good',
          ),
          SizedBox(height: 12),
          _PerformanceTile(
            initials: 'MJ',
            name: 'Mike Johnson',
            detail: 'Attendance: 92% - Leaves: 3 days',
            status: 'Very\nGood',
          ),
        ],
      ),
    );
  }
}

class _PerformanceTile extends StatelessWidget {
  const _PerformanceTile({
    required this.initials,
    required this.name,
    required this.detail,
    required this.status,
  });

  final String initials;
  final String name;
  final String detail;
  final String status;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(12),
      builder: (BuildContext context, bool isHovered) {
        final Color background =
            isHovered ? DashboardMgView._cardHoverBg : DashboardMgView._cardBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DashboardMgView._cardBorder),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF7C3AED), Color(0xFF8B7AE9)],
                  ),
                ),
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: DashboardMgView._titleText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      style: TextStyle(
                        color: DashboardMgView._mutedText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                status,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: DashboardMgView._green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.title, required this.icon, this.onTap});

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(10),
      builder: (BuildContext context, bool isHovered) {
        final Color background =
            isHovered ? DashboardMgView._cardHoverBg : DashboardMgView._cardBg;
        final Color titleColor = ManagerThemeController.isDark && isHovered
            ? ManagerPalette.primary
            : DashboardMgView._titleText;
        final Color iconColor = titleColor;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: DashboardMgView._cardBorder),
              ),
              child: Column(
                children: <Widget>[
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(height: 10),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutCubic,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    child: Text(title),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DashboardMgView._cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DashboardMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: DashboardMgView._titleText,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

enum _ReviewDecision { approved, rejected, none }

class _ApprovalReviewItem {
  const _ApprovalReviewItem({
    required this.dotColor,
    required this.name,
    required this.detail,
    required this.leaveType,
    required this.dates,
    required this.reason,
    required this.leaveBalance,
    required this.appliedOn,
  });

  final Color dotColor;
  final String name;
  final String detail;
  final String leaveType;
  final String dates;
  final String reason;
  final String leaveBalance;
  final String appliedOn;
}

class _ReviewApprovalDialog extends StatelessWidget {
  const _ReviewApprovalDialog({required this.item});

  final _ApprovalReviewItem item;

  @override
  Widget build(BuildContext context) {
    final bool isCompact = MediaQuery.of(context).size.width < 720;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: PopupStyle.surfaceDecoration(radius: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          DashboardMgView._purpleStart,
                          DashboardMgView._purpleEnd,
                        ],
                      ),
                    ),
                    child: Icon(Icons.assignment_outlined, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: TextStyle(
                            color: DashboardMgView._titleText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.leaveType,
                          style: TextStyle(
                            color: DashboardMgView._mutedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_ReviewDecision.none),
                    icon: Icon(Icons.close),
                    color: PopupStyle.mutedText,
                    splashRadius: 18,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ReviewInfoRow(label: 'Request', value: item.detail),
              const SizedBox(height: 8),
              _ReviewInfoRow(label: 'Dates', value: item.dates),
              const SizedBox(height: 8),
              _ReviewInfoRow(label: 'Reason', value: item.reason),
              const SizedBox(height: 8),
              _ReviewInfoRow(label: 'Leave Balance', value: item.leaveBalance),
              const SizedBox(height: 8),
              _ReviewInfoRow(label: 'Applied On', value: item.appliedOn),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: <Widget>[
                  _DialogActionButton(
                    icon: Icons.cancel_outlined,
                    label: 'Reject',
                    backgroundColor: PopupStyle.surface,
                    foregroundColor: PopupStyle.danger,
                    borderColor: PopupStyle.border,
                    onTap: () =>
                        Navigator.of(context).pop(_ReviewDecision.rejected),
                  ),
                  _DialogActionButton(
                    icon: Icons.check_circle_outline,
                    label: 'Approve',
                    backgroundColor: DashboardMgView._purpleStart,
                    foregroundColor: Colors.white,
                    borderColor: Colors.transparent,
                    onTap: () =>
                        Navigator.of(context).pop(_ReviewDecision.approved),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewInfoRow extends StatelessWidget {
  const _ReviewInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 104,
          child: Text(
            '$label:',
            style: TextStyle(
              color: DashboardMgView._mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: DashboardMgView._titleText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogActionButton extends StatelessWidget {
  const _DialogActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 16, color: foregroundColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
