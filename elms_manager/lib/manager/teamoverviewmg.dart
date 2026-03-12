import 'dart:math' as math;

import 'package:elms_manager/manager/leave_balance_store.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:elms_manager/manager/widgets/popup_style.dart';
import 'package:flutter/material.dart';

class TeamOverviewMgView extends StatefulWidget {
  const TeamOverviewMgView({super.key});

  static Color get _pageBg => ManagerPalette.pageBg;
  static Color get _cardBg => ManagerPalette.surface;
  static Color get _cardHoverBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : _cardBg;
  static Color get _cardBorder => ManagerPalette.border;
  static Color get _titleText => ManagerPalette.titleText;
  static Color get _mutedText => ManagerPalette.mutedText;
  static const Color _primary = Color(0xFF7C3AED);
  static const Color _avatarAlt = Color(0xFF8E79E8);
  static Color get _buttonBg => ManagerPalette.subtleSurface;
  static Color get _pagerButtonBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : _buttonBg;
  static Color get _pagerButtonDisabledBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurface
      : const Color(0xFFF7F6FA);
  static Color get _leaveBg => ManagerPalette.subtleSurfaceAlt;
  static const int _pageSize = 8;

  static final List<_TeamMemberData> _members = _buildDummyMembers();

  static List<_TeamMemberData> _buildDummyMembers() {
    const List<String> firstNames = <String>[
      'John',
      'Sarah',
      'Mike',
      'Emily',
      'David',
      'Lisa',
      'Robert',
      'Emma',
      'Daniel',
      'Sophia',
      'James',
      'Olivia',
      'Noah',
      'Ava',
      'Liam',
      'Mia',
      'Ethan',
      'Isabella',
      'Lucas',
      'Charlotte',
      'Henry',
      'Amelia',
      'Logan',
      'Harper',
    ];
    const List<String> lastNames = <String>[
      'Doe',
      'Smith',
      'Johnson',
      'Davis',
      'Wilson',
      'Brown',
      'Taylor',
      'Anderson',
      'Thomas',
      'Moore',
      'Martin',
      'Clark',
      'Lewis',
      'Lee',
      'Walker',
      'Hall',
      'Allen',
      'Young',
      'King',
      'Wright',
      'Scott',
      'Green',
      'Baker',
      'Adams',
    ];
    const List<String> roles = <String>[
      'Senior Engineer',
      'Engineer',
      'Junior Engineer',
      'QA Engineer',
      'DevOps Engineer',
      'Product Analyst',
    ];
    const List<String> performanceLabels = <String>[
      'Excellent',
      'Very Good',
      'Good',
    ];

    return List<_TeamMemberData>.generate(24, (int index) {
      final String first = firstNames[index];
      final String last = lastNames[index];
      final String name = '$first $last';
      final String initials = '${first[0]}${last[0]}';
      final bool isOnLeave = index % 5 == 0;
      final int attendance = 88 + (index % 11);
      final int leaveDays = 5 + (index % 11);
      final int month = (index % 12) + 1;
      final int day = (index % 27) + 1;
      final int year = 2021 + (index % 4);
      final String mm = month.toString().padLeft(2, '0');
      final String dd = day.toString().padLeft(2, '0');
      final String joinedDate = '$year-$mm-$dd';
      final String phone =
          '+1 555 ${(100 + index).toString().padLeft(3, '0')} ${(700 + index).toString().padLeft(3, '0')}';

      return _TeamMemberData(
        initials: initials,
        name: name,
        role: roles[index % roles.length],
        attendance: attendance,
        leaveDays: leaveDays,
        status: isOnLeave ? 'on-leave' : 'present',
        isOnLeave: isOnLeave,
        email: '${first.toLowerCase()}.${last.toLowerCase()}@example.com',
        phone: phone,
        joinedDate: joinedDate,
        hoursWorked: (1400 + (index * 18)).toString(),
        performance: performanceLabels[index % performanceLabels.length],
      );
    });
  }

  @override
  State<TeamOverviewMgView> createState() => _TeamOverviewMgViewState();
}

class _TeamOverviewMgViewState extends State<TeamOverviewMgView> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    for (final _TeamMemberData member in TeamOverviewMgView._members) {
      LeaveBalanceStore.ensureBalance(member.name, member.leaveDays);
    }
  }

  int get _totalMembers => TeamOverviewMgView._members.length;

  int get _totalPages => (_totalMembers / TeamOverviewMgView._pageSize).ceil();

  int get _presentCount => TeamOverviewMgView._members
      .where((_TeamMemberData member) => !member.isOnLeave)
      .length;

  int get _avgAttendance {
    if (TeamOverviewMgView._members.isEmpty) {
      return 0;
    }
    final int total = TeamOverviewMgView._members.fold<int>(
      0,
      (int sum, _TeamMemberData member) => sum + member.attendance,
    );
    return (total / TeamOverviewMgView._members.length).round();
  }

  List<_TeamMemberData> get _pagedMembers {
    final int start = (_currentPage - 1) * TeamOverviewMgView._pageSize;
    final int end = math.min(
      start + TeamOverviewMgView._pageSize,
      _totalMembers,
    );
    return TeamOverviewMgView._members.sublist(start, end);
  }

  int _leaveBalanceFor(_TeamMemberData member) {
    return LeaveBalanceStore.balanceFor(
      member.name,
      fallbackDays: member.leaveDays,
    );
  }

  void _openMemberProfile(_TeamMemberData member, int leaveBalanceDays) {
    showDialog<void>(
      context: context,
      barrierColor: PopupStyle.overlay,
      builder: (BuildContext context) => _TeamMemberProfileDialog(
        member: member,
        leaveBalanceDays: leaveBalanceDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_MetricData> metrics = <_MetricData>[
      _MetricData(title: 'Team Size', value: '$_totalMembers'),
      _MetricData(title: 'Present Today', value: '$_presentCount'),
      _MetricData(title: 'Avg Attendance', value: '$_avgAttendance%'),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool isTablet = width >= 700;
        final bool isDesktop = width >= 1050;
        final int metricColumns = isDesktop ? 3 : (isTablet ? 2 : 1);
        final double horizontalPadding = width >= 1080 ? 24 : 16;
        final double metricAspectRatio = metricColumns == 1
            ? (width >= 520 ? 2.75 : 2.35)
            : (metricColumns == 2 ? 2.15 : 2.05);

        return Container(
          color: TeamOverviewMgView._pageBg,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                22,
                horizontalPadding,
                24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'My Team',
                        style: TextStyle(
                          color: TeamOverviewMgView._titleText,
                          fontSize: width < 480 ? 27 : 24,
                          fontWeight: FontWeight.w600,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_totalMembers team members',
                        style: TextStyle(
                          color: TeamOverviewMgView._mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      GridView.builder(
                        itemCount: metrics.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: metricColumns,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: metricAspectRatio,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return _MetricCard(
                            title: metrics[index].title,
                            value: metrics[index].value,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      _SectionCard(
                        title: 'Team Members',
                        child: ValueListenableBuilder<Map<String, int>>(
                          valueListenable: LeaveBalanceStore.balances,
                          builder:
                              (
                                BuildContext context,
                                Map<String, int> balances,
                                Widget? child,
                              ) {
                                return Column(
                                  children: _pagedMembers.map((
                                    _TeamMemberData member,
                                  ) {
                                    final int leaveBalanceDays =
                                        _leaveBalanceFor(member);
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _TeamMemberCard(
                                        member: member,
                                        leaveBalanceDays: leaveBalanceDays,
                                        onViewTap: () => _openMemberProfile(
                                          member,
                                          leaveBalanceDays,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _PaginationRow(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        onPreviousTap: _currentPage > 1
                            ? () => setState(() => _currentPage--)
                            : null,
                        onNextTap: _currentPage < _totalPages
                            ? () => setState(() => _currentPage++)
                            : null,
                      ),
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
}

class _MetricData {
  const _MetricData({required this.title, required this.value});

  final String title;
  final String value;
}

class _TeamMemberData {
  const _TeamMemberData({
    required this.initials,
    required this.name,
    required this.role,
    required this.attendance,
    required this.leaveDays,
    required this.status,
    required this.isOnLeave,
    required this.email,
    required this.phone,
    required this.joinedDate,
    required this.hoursWorked,
    required this.performance,
  });

  final String initials;
  final String name;
  final String role;
  final int attendance;
  final int leaveDays;
  final String status;
  final bool isOnLeave;
  final String email;
  final String phone;
  final String joinedDate;
  final String hoursWorked;
  final String performance;
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
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: _isHovered
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x187C3AED),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
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
  const _MetricCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final bool isCompact = MediaQuery.of(context).size.width < 430;

    return _HoverCard(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          34,
          isCompact ? 22 : 26,
          34,
          isCompact ? 22 : 26,
        ),
        decoration: BoxDecoration(
          color: TeamOverviewMgView._cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: TeamOverviewMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: TeamOverviewMgView._mutedText,
                fontSize: isCompact ? 12 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: TeamOverviewMgView._titleText,
                fontSize: isCompact ? 26 : 30,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
      ),
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        decoration: BoxDecoration(
          color: TeamOverviewMgView._cardBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: TeamOverviewMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: TeamOverviewMgView._titleText,
                fontSize: 18,
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

class _TeamMemberCard extends StatelessWidget {
  const _TeamMemberCard({
    required this.member,
    required this.leaveBalanceDays,
    required this.onViewTap,
  });

  final _TeamMemberData member;
  final int leaveBalanceDays;
  final VoidCallback onViewTap;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(16),
      builder: (BuildContext context, bool isHovered) {
        final Color background =
            isHovered ? TeamOverviewMgView._cardHoverBg : TeamOverviewMgView._cardBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: TeamOverviewMgView._cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _MemberAvatar(initials: member.initials),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      member.name,
                      style: TextStyle(
                        color: TeamOverviewMgView._titleText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      member.role,
                      style: TextStyle(
                        color: TeamOverviewMgView._mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Attendance: ${member.attendance}%',
                      style: TextStyle(
                        color: TeamOverviewMgView._mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Leave Balance: $leaveBalanceDays days',
                      style: TextStyle(
                        color: TeamOverviewMgView._mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _StatusChip(
                    label: member.status,
                    isOnLeave: member.isOnLeave,
                  ),
                  const SizedBox(width: 10),
                  _ViewButton(onTap: onViewTap),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            TeamOverviewMgView._primary,
            TeamOverviewMgView._avatarAlt,
          ],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.isOnLeave});

  final String label;
  final bool isOnLeave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isOnLeave
            ? TeamOverviewMgView._leaveBg
            : TeamOverviewMgView._primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOnLeave ? TeamOverviewMgView._titleText : Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: TeamOverviewMgView._buttonBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TeamOverviewMgView._cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.remove_red_eye_outlined,
                  size: 20,
                  color: TeamOverviewMgView._titleText,
                ),
                SizedBox(width: 8),
                Text(
                  'View',
                  style: TextStyle(
                    color: TeamOverviewMgView._titleText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamMemberProfileDialog extends StatelessWidget {
  const _TeamMemberProfileDialog({
    required this.member,
    required this.leaveBalanceDays,
  });

  final _TeamMemberData member;
  final int leaveBalanceDays;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: PopupStyle.surface,
      shape: PopupStyle.roundedShape(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Team Member Profile',
                          style: TextStyle(
                            color: TeamOverviewMgView._titleText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'View details of the selected team member.',
                          style: TextStyle(
                            color: TeamOverviewMgView._mutedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                    color: PopupStyle.mutedText,
                    splashRadius: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DialogAvatar(initials: member.initials),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          member.name,
                          style: TextStyle(
                            color: TeamOverviewMgView._titleText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.role,
                          style: TextStyle(
                            color: TeamOverviewMgView._mutedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Attendance: ${member.attendance}% | Leave Balance: $leaveBalanceDays days',
                          style: TextStyle(
                            color: TeamOverviewMgView._mutedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _ProfileDetailRow(icon: Icons.mail_outline, value: member.email),
              _ProfileDetailRow(
                icon: Icons.phone_outlined,
                value: member.phone,
              ),
              _ProfileDetailRow(
                icon: Icons.calendar_month_outlined,
                value: 'Joined: ${member.joinedDate}',
              ),
              _ProfileDetailRow(
                icon: Icons.access_time_outlined,
                value: 'Hours Worked: ${member.hoursWorked}',
              ),
              _ProfileDetailRow(
                icon: Icons.trending_up_outlined,
                value: 'Performance: ${member.performance}',
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: TeamOverviewMgView._titleText,
                      side: BorderSide(color: PopupStyle.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Close'),
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

class _DialogAvatar extends StatelessWidget {
  const _DialogAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            TeamOverviewMgView._primary,
            TeamOverviewMgView._avatarAlt,
          ],
        ),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: TeamOverviewMgView._mutedText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: TeamOverviewMgView._mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationRow extends StatelessWidget {
  const _PaginationRow({
    required this.currentPage,
    required this.totalPages,
    this.onPreviousTap,
    this.onNextTap,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onNextTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _PagerButton(
          icon: Icons.chevron_left,
          onTap: onPreviousTap,
          isDisabled: onPreviousTap == null,
        ),
        const SizedBox(width: 12),
        Text(
          'Page $currentPage of $totalPages',
          style: TextStyle(
            color: TeamOverviewMgView._titleText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        _PagerButton(
          icon: Icons.chevron_right,
          onTap: onNextTap,
          isDisabled: onNextTap == null,
        ),
      ],
    );
  }
}

class _PagerButton extends StatelessWidget {
  const _PagerButton({required this.icon, this.onTap, this.isDisabled = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return _HoverCard(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDisabled
                  ? TeamOverviewMgView._pagerButtonDisabledBg
                  : TeamOverviewMgView._pagerButtonBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TeamOverviewMgView._cardBorder),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDisabled
                  ? const Color(0xFFAAB1BF)
                  : TeamOverviewMgView._titleText,
            ),
          ),
        ),
      ),
    );
  }
}
