import 'package:flutter/material.dart';
import 'package:elms_manager/manager/widgets/bottom_right_popup.dart';
import 'package:elms_manager/manager/leave_balance_store.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:elms_manager/manager/widgets/popup_style.dart';

class LeaveApprovalsMgView extends StatefulWidget {
  const LeaveApprovalsMgView({super.key});

  static Color get _pageBg => ManagerPalette.pageBg;
  static Color get _cardBg => ManagerPalette.surface;
  static Color get _cardHoverBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : _cardBg;
  static Color get _cardBorder => ManagerPalette.border;
  static Color get _titleText => ManagerPalette.titleText;
  static Color get _mutedText => ManagerPalette.mutedText;
  static const Color _primary = Color(0xFF7C3AED);
  static const Color _primarySoft = Color(0xFF9D8BF0);
  static const Color _rejectText = Color(0xFFFF3B30);
  static const Color _successText = Color(0xFF0BAB73);
  static Color get _successBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : const Color(0xFFEAF8F1);
  static const Color _successBorder = Color(0xFFA6DDC8);
  static Color get _approvedHoverBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurface
      : _successBg;
  static Color get _approvedChipBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : const Color(0xFFDDF3E8);

  static const List<_LeaveRequest> _initialRequests = <_LeaveRequest>[
    _LeaveRequest(
      name: 'John Doe',
      leaveType: 'Annual Leave',
      dates: 'Mar 15-17, 2026 (3 days)',
      reason: 'Family vacation',
      leaveBalance: '12 days remaining',
      appliedOn: '2026-01-28',
    ),
    _LeaveRequest(
      name: 'Sarah Smith',
      leaveType: 'Sick Leave',
      dates: 'Feb 10, 2026 (1 day)',
      reason: 'Medical appointment',
      leaveBalance: '8 days remaining',
      appliedOn: '2026-01-29',
    ),
    _LeaveRequest(
      name: 'Mike Johnson',
      leaveType: 'Casual Leave',
      dates: 'Feb 5-6, 2026 (2 days)',
      reason: 'Personal work',
      leaveBalance: '4 days remaining',
      appliedOn: '2026-01-29',
    ),
    _LeaveRequest(
      name: 'Emily Davis',
      leaveType: 'Annual Leave',
      dates: 'Feb 20-22, 2026 (3 days)',
      reason: 'Travel',
      leaveBalance: '15 days remaining',
      appliedOn: '2026-01-30',
    ),
    _LeaveRequest(
      name: 'David Wilson',
      leaveType: 'Sick Leave',
      dates: 'Jan 25, 2026 (1 day)',
      reason: 'Flu symptoms',
      leaveBalance: '7 days remaining',
      appliedOn: '2026-01-20',
    ),
    _LeaveRequest(
      name: 'Lisa Brown',
      leaveType: 'Casual Leave',
      dates: 'Jan 18-19, 2026 (2 days)',
      reason: 'Personal errands',
      leaveBalance: '3 days remaining',
      appliedOn: '2026-01-15',
    ),
  ];

  @override
  State<LeaveApprovalsMgView> createState() => _LeaveApprovalsMgViewState();
}

class _LeaveApprovalsMgViewState extends State<LeaveApprovalsMgView> {
  late final List<_LeaveRequest> _pendingRequests;
  final List<_ApprovedLeaveRequest> _approvedRequests =
      <_ApprovedLeaveRequest>[];

  @override
  void initState() {
    super.initState();
    _pendingRequests = List<_LeaveRequest>.of(
      LeaveApprovalsMgView._initialRequests,
    );
  }

  void _approveRequest(_LeaveRequest request) {
    final int requestedDays = LeaveBalanceStore.extractRequestedDays(
      request.dates,
    );
    final int fallbackBalance = LeaveBalanceStore.parseFirstInt(
      request.leaveBalance,
    );
    LeaveBalanceStore.consumeLeave(
      memberName: request.name,
      daysTaken: requestedDays,
      fallbackBalance: fallbackBalance,
    );
    setState(() {
      _pendingRequests.remove(request);
      _approvedRequests.insert(
        0,
        _ApprovedLeaveRequest(request: request, approvedOn: _todayIso()),
      );
    });
    BottomRightPopup.show(
      context,
      'Approved Leave request for ${request.name}',
    );
  }

  void _rejectRequest(_LeaveRequest request) {
    setState(() {
      _pendingRequests.remove(request);
    });
  }

  void _openRejectDialog(_LeaveRequest request) async {
    final String? reason = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: PopupStyle.overlay,
      builder: (BuildContext dialogContext) => const _RejectLeaveDialog(),
    );
    if (!mounted || reason == null) {
      return;
    }
    _rejectRequest(request);
    BottomRightPopup.show(
      context,
      'Rejected Leave request for ${request.name}',
    );
  }

  String _todayIso() {
    final DateTime now = DateTime.now();
    final String mm = now.month.toString().padLeft(2, '0');
    final String dd = now.day.toString().padLeft(2, '0');
    return '${now.year}-$mm-$dd';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool isDesktop = width >= 1080;
        final bool isTablet = width >= 700;
        final double horizontalPadding = isDesktop ? 24 : 16;
        final double headingSize = isTablet ? 20 : 16;

        return Container(
          color: LeaveApprovalsMgView._pageBg,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                28,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1220),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Leave Approvals',
                        style: TextStyle(
                          color: LeaveApprovalsMgView._titleText,
                          fontSize: headingSize,
                          fontWeight: FontWeight.w600,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_pendingRequests.length} pending requests',
                        style: TextStyle(
                          color: LeaveApprovalsMgView._mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _PendingLeaveSection(
                        requests: _pendingRequests,
                        onApprove: _approveRequest,
                        onReject: _openRejectDialog,
                      ),
                      const SizedBox(height: 16),
                      _ApprovedLeaveSection(
                        approvedRequests: _approvedRequests,
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

class _LeaveRequest {
  const _LeaveRequest({
    required this.name,
    required this.leaveType,
    required this.dates,
    required this.reason,
    required this.leaveBalance,
    required this.appliedOn,
  });

  final String name;
  final String leaveType;
  final String dates;
  final String reason;
  final String leaveBalance;
  final String appliedOn;
}

class _ApprovedLeaveRequest {
  const _ApprovedLeaveRequest({
    required this.request,
    required this.approvedOn,
  });

  final _LeaveRequest request;
  final String approvedOn;
}

class _RejectLeaveDialog extends StatefulWidget {
  const _RejectLeaveDialog();

  @override
  State<_RejectLeaveDialog> createState() => _RejectLeaveDialogState();
}

class _RejectLeaveDialogState extends State<_RejectLeaveDialog> {
  late final TextEditingController _reasonController;

  bool get _canReject => _reasonController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: PopupStyle.surface,
      shape: PopupStyle.roundedShape(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.cancel_outlined,
                    size: 20,
                    color: PopupStyle.danger,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reject Leave Request',
                      style: TextStyle(
                        color: LeaveApprovalsMgView._titleText,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 20,
                    splashRadius: 18,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: PopupStyle.mutedText),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Please provide a reason for rejection. This will be shared with the employee.',
                style: TextStyle(
                  color: LeaveApprovalsMgView._mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Rejection Reason *',
                style: TextStyle(
                  color: LeaveApprovalsMgView._titleText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reasonController,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText:
                      'e.g., Insufficient staffing during requested period...',
                  hintStyle: TextStyle(
                    color: Color(0xFF98A2B3),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PopupStyle.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PopupStyle.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: PopupStyle.primary),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: LeaveApprovalsMgView._titleText,
                      side: BorderSide(color: PopupStyle.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _canReject
                        ? () => Navigator.of(
                            context,
                          ).pop(_reasonController.text.trim())
                        : null,
                    icon: Icon(Icons.cancel_outlined, size: 16),
                    label: Text('Reject Request'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PopupStyle.danger,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFF1B0AD),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _PendingLeaveSection extends StatelessWidget {
  const _PendingLeaveSection({
    required this.requests,
    required this.onApprove,
    required this.onReject,
  });

  final List<_LeaveRequest> requests;
  final ValueChanged<_LeaveRequest> onApprove;
  final ValueChanged<_LeaveRequest> onReject;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        decoration: BoxDecoration(
          color: LeaveApprovalsMgView._cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: LeaveApprovalsMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pending Leave Requests',
              style: TextStyle(
                color: LeaveApprovalsMgView._titleText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            if (requests.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'No pending leave requests.',
                  style: TextStyle(
                    color: LeaveApprovalsMgView._mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ...requests.map(
              (_LeaveRequest request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _LeaveRequestTile(
                  request: request,
                  onApprove: () => onApprove(request),
                  onReject: () => onReject(request),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaveRequestTile extends StatelessWidget {
  const _LeaveRequestTile({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final _LeaveRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final int fallbackBalance = LeaveBalanceStore.parseFirstInt(
      request.leaveBalance,
    );
    final String leaveBalanceLabel = LeaveBalanceStore.remainingLabel(
      request.name,
      fallbackDays: fallbackBalance,
    );

    return _HoverSurface(
      borderRadius: BorderRadius.circular(14),
      builder: (BuildContext context, bool isHovered) {
        final Color background = isHovered
            ? LeaveApprovalsMgView._cardHoverBg
            : LeaveApprovalsMgView._cardBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LeaveApprovalsMgView._cardBorder),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth < 560;
              final double detailsIndent = compact ? 82 : 88;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: const Color(0xFFD3D7E0),
                            width: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const _LeaveIconBox(),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              request.name,
                              style: TextStyle(
                                color: LeaveApprovalsMgView._titleText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              request.leaveType,
                              style: TextStyle(
                                color: LeaveApprovalsMgView._mutedText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.only(left: detailsIndent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Dates: ${request.dates}',
                          style: TextStyle(
                            color: LeaveApprovalsMgView._titleText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Reason: ${request.reason}',
                          style: TextStyle(
                            color: LeaveApprovalsMgView._titleText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Leave Balance: $leaveBalanceLabel',
                          style: TextStyle(
                            color: LeaveApprovalsMgView._mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Applied: ${request.appliedOn}',
                          style: TextStyle(
                            color: LeaveApprovalsMgView._titleText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <Widget>[
                            _RejectButton(onTap: onReject),
                            _ApproveButton(onTap: onApprove),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _ApprovedLeaveSection extends StatelessWidget {
  const _ApprovedLeaveSection({required this.approvedRequests});

  final List<_ApprovedLeaveRequest> approvedRequests;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        decoration: BoxDecoration(
          color: LeaveApprovalsMgView._cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: LeaveApprovalsMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: LeaveApprovalsMgView._successText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Approved Requests (${approvedRequests.length})',
                  style: TextStyle(
                    color: LeaveApprovalsMgView._titleText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (approvedRequests.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'No approved leave requests yet.',
                  style: TextStyle(
                    color: LeaveApprovalsMgView._mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ...approvedRequests.map(
              (_ApprovedLeaveRequest approved) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ApprovedLeaveTile(approved: approved),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovedLeaveTile extends StatelessWidget {
  const _ApprovedLeaveTile({required this.approved});

  final _ApprovedLeaveRequest approved;

  @override
  Widget build(BuildContext context) {
    final _LeaveRequest request = approved.request;

    return _HoverSurface(
      borderRadius: BorderRadius.circular(12),
      builder: (BuildContext context, bool isHovered) {
        final Color background = isHovered
            ? LeaveApprovalsMgView._approvedHoverBg
            : LeaveApprovalsMgView._successBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: LeaveApprovalsMgView._successBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                size: 18,
                color: LeaveApprovalsMgView._successText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${request.name} • ${request.leaveType}',
                      style: TextStyle(
                        color: LeaveApprovalsMgView._titleText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      request.dates,
                      style: TextStyle(
                        color: LeaveApprovalsMgView._mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Approved on ${approved.approvedOn}',
                      style: TextStyle(
                        color: LeaveApprovalsMgView._mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const _ApprovedChip(),
            ],
          ),
        );
      },
    );
  }
}

class _ApprovedChip extends StatelessWidget {
  const _ApprovedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: LeaveApprovalsMgView._approvedChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LeaveApprovalsMgView._successBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: LeaveApprovalsMgView._successText,
          ),
          SizedBox(width: 4),
          Text(
            'Approved',
            style: TextStyle(
              color: LeaveApprovalsMgView._successText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverSurface extends StatefulWidget {
  const _HoverSurface({
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
  State<_HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<_HoverSurface> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Widget content =
        widget.builder?.call(context, _isHovered) ?? widget.child!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: _isHovered
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A7C3AED),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 3),
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

class _LeaveIconBox extends StatelessWidget {
  const _LeaveIconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            LeaveApprovalsMgView._primary,
            LeaveApprovalsMgView._primarySoft,
          ],
        ),
      ),
      child: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 24),
    );
  }
}

class _RejectButton extends StatelessWidget {
  const _RejectButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: LeaveApprovalsMgView._cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: LeaveApprovalsMgView._cardBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.cancel_outlined,
                  size: 16,
                  color: LeaveApprovalsMgView._rejectText,
                ),
                SizedBox(width: 8),
                Text(
                  'Reject',
                  style: TextStyle(
                    color: LeaveApprovalsMgView._rejectText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _ApproveButton extends StatelessWidget {
  const _ApproveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: LeaveApprovalsMgView._primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Approve',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
