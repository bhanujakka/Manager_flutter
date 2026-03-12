import 'package:flutter/material.dart';
import 'package:elms_manager/manager/widgets/bottom_right_popup.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:elms_manager/manager/widgets/popup_style.dart';

class AttendanceApprovalsMgView extends StatefulWidget {
  const AttendanceApprovalsMgView({super.key});

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
  static const Color _pendingText = Color(0xFFEA8A00);
  static Color get _pendingBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : const Color(0xFFFFF4E5);
  static Color get _pendingBorder => ManagerThemeController.isDark
      ? ManagerPalette.border
      : const Color(0xFFF4CCA2);
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

  static const List<_PendingRequest> _initialPending = <_PendingRequest>[
    _PendingRequest(
      name: 'John Doe',
      employeeId: 'EMP001',
      date: 'Jan 28, 2026',
      reason: 'Medical emergency',
      checkIn: '\u2014',
      checkOut: '\u2014',
    ),
    _PendingRequest(
      name: 'Sarah Smith',
      employeeId: 'EMP002',
      date: 'Jan 27, 2026',
      reason: 'System login issue',
      checkIn: '09:15',
      checkOut: '18:00',
    ),
    _PendingRequest(
      name: 'Mike Johnson',
      employeeId: 'EMP003',
      date: 'Jan 26, 2026',
      reason: 'Power outage at home',
      checkIn: '10:30',
      checkOut: '18:00',
    ),
  ];

  static const _PendingRequest _seedApprovedRequest = _PendingRequest(
    name: 'Emily Davis',
    employeeId: 'EMP010',
    date: 'Jan 24, 2026',
    reason: 'Client visit delay',
    checkIn: '09:45',
    checkOut: '18:05',
  );

  @override
  State<AttendanceApprovalsMgView> createState() =>
      _AttendanceApprovalsMgViewState();
}

class _AttendanceApprovalsMgViewState extends State<AttendanceApprovalsMgView> {
  late final List<_PendingRequest> _pendingRequests;
  late final List<_ApprovedRequest> _approvedRequests;

  @override
  void initState() {
    super.initState();
    _pendingRequests = List<_PendingRequest>.of(
      AttendanceApprovalsMgView._initialPending,
    );
    _approvedRequests = <_ApprovedRequest>[
      const _ApprovedRequest(
        request: AttendanceApprovalsMgView._seedApprovedRequest,
        approvedOn: '2026-01-25',
      ),
    ];
  }

  void _approveRequest(_PendingRequest request) {
    setState(() {
      _pendingRequests.remove(request);
      _approvedRequests.insert(
        0,
        _ApprovedRequest(request: request, approvedOn: _todayIso()),
      );
    });
    BottomRightPopup.show(
      context,
      'Approved Attendance Regularization for ${request.name}',
    );
  }

  void _rejectRequest(_PendingRequest request) {
    setState(() {
      _pendingRequests.remove(request);
    });
  }

  void _openRejectDialog(_PendingRequest request) async {
    final String? reason = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: PopupStyle.overlay,
      builder: (BuildContext dialogContext) => const _RejectAttendanceDialog(),
    );
    if (!mounted || reason == null) {
      return;
    }
    _rejectRequest(request);
    BottomRightPopup.show(
      context,
      'Rejected Attendance regularization for ${request.name}',
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
        final double headingSize = isTablet ? 28 : 24;

        return Container(
          color: AttendanceApprovalsMgView._pageBg,
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
                        'Attendance Approvals',
                        style: TextStyle(
                          color: AttendanceApprovalsMgView._titleText,
                          fontSize: headingSize,
                          fontWeight: FontWeight.w600,
                          height: 1.08,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_pendingRequests.length} pending requests',
                        style: TextStyle(
                          color: AttendanceApprovalsMgView._mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _PendingSection(
                        requests: _pendingRequests,
                        onApprove: _approveRequest,
                        onReject: _openRejectDialog,
                      ),
                      const SizedBox(height: 16),
                      _ApprovedSection(approvedRequests: _approvedRequests),
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

class _PendingRequest {
  const _PendingRequest({
    required this.name,
    required this.employeeId,
    required this.date,
    required this.reason,
    required this.checkIn,
    required this.checkOut,
  });

  final String name;
  final String employeeId;
  final String date;
  final String reason;
  final String checkIn;
  final String checkOut;
}

class _ApprovedRequest {
  const _ApprovedRequest({required this.request, required this.approvedOn});

  final _PendingRequest request;
  final String approvedOn;
}

class _RejectAttendanceDialog extends StatefulWidget {
  const _RejectAttendanceDialog();

  @override
  State<_RejectAttendanceDialog> createState() =>
      _RejectAttendanceDialogState();
}

class _RejectAttendanceDialogState extends State<_RejectAttendanceDialog> {
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
                      'Reject Attendance Regularization',
                      style: TextStyle(
                        color: AttendanceApprovalsMgView._titleText,
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
                  color: AttendanceApprovalsMgView._mutedText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Rejection Reason *',
                style: TextStyle(
                  color: AttendanceApprovalsMgView._titleText,
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
                  hintText: 'e.g., Insufficient documentation provided...',
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
                      foregroundColor: AttendanceApprovalsMgView._titleText,
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

class _PendingSection extends StatelessWidget {
  const _PendingSection({
    required this.requests,
    required this.onApprove,
    required this.onReject,
  });

  final List<_PendingRequest> requests;
  final ValueChanged<_PendingRequest> onApprove;
  final ValueChanged<_PendingRequest> onReject;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        decoration: BoxDecoration(
          color: AttendanceApprovalsMgView._cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AttendanceApprovalsMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pending Requests',
              style: TextStyle(
                color: AttendanceApprovalsMgView._titleText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            if (requests.isEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'No pending attendance requests.',
                  style: TextStyle(
                    color: AttendanceApprovalsMgView._mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ...requests.map(
              (_PendingRequest request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PendingTile(
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

class _PendingTile extends StatelessWidget {
  const _PendingTile({
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  final _PendingRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(14),
      builder: (BuildContext context, bool isHovered) {
        final Color background = isHovered
            ? AttendanceApprovalsMgView._cardHoverBg
            : AttendanceApprovalsMgView._cardBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AttendanceApprovalsMgView._cardBorder),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth < 640;

              final Widget requestHead = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _RequestAvatar(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          request.name,
                          style: TextStyle(
                            color: AttendanceApprovalsMgView._titleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${request.employeeId} \u2022 ${request.date}',
                          style: TextStyle(
                            color: AttendanceApprovalsMgView._mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  compact
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: requestHead),
                            const SizedBox(width: 8),
                            const _PendingChip(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: requestHead),
                            const SizedBox(width: 12),
                            const _PendingChip(),
                          ],
                        ),
                  const SizedBox(height: 12),
                  Text(
                    'Reason: ${request.reason}',
                    style: TextStyle(
                      color: AttendanceApprovalsMgView._titleText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Check-in: ${request.checkIn} \u2022 Check-out: ${request.checkOut}',
                    style: TextStyle(
                      color: AttendanceApprovalsMgView._mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _RejectButton(onTap: onReject),
                      _ApproveButton(onTap: onApprove),
                    ],
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

class _RequestAvatar extends StatelessWidget {
  const _RequestAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AttendanceApprovalsMgView._primary,
            AttendanceApprovalsMgView._primarySoft,
          ],
        ),
      ),
      child: Icon(Icons.access_time, color: Colors.white, size: 22),
    );
  }
}

class _PendingChip extends StatelessWidget {
  const _PendingChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AttendanceApprovalsMgView._pendingBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AttendanceApprovalsMgView._pendingBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.schedule,
            size: 14,
            color: AttendanceApprovalsMgView._pendingText,
          ),
          SizedBox(width: 4),
          Text(
            'Pending',
            style: TextStyle(
              color: AttendanceApprovalsMgView._pendingText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
              color: AttendanceApprovalsMgView._cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AttendanceApprovalsMgView._cardBorder),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.cancel_outlined,
                  size: 16,
                  color: AttendanceApprovalsMgView._rejectText,
                ),
                SizedBox(width: 8),
                Text(
                  'Reject',
                  style: TextStyle(
                    color: AttendanceApprovalsMgView._rejectText,
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
              color: AttendanceApprovalsMgView._primary,
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

class _ApprovedSection extends StatelessWidget {
  const _ApprovedSection({required this.approvedRequests});

  final List<_ApprovedRequest> approvedRequests;

  @override
  Widget build(BuildContext context) {
    return _HoverSurface(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          color: AttendanceApprovalsMgView._cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AttendanceApprovalsMgView._cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  size: 22,
                  color: AttendanceApprovalsMgView._successText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Approved Requests (${approvedRequests.length})',
                  style: TextStyle(
                    color: AttendanceApprovalsMgView._titleText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (approvedRequests.isEmpty)
              Text(
                'No approved attendance requests yet.',
                style: TextStyle(
                  color: AttendanceApprovalsMgView._mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ...approvedRequests.map(
              (_ApprovedRequest approved) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ApprovedTile(approved: approved),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovedTile extends StatelessWidget {
  const _ApprovedTile({required this.approved});

  final _ApprovedRequest approved;

  @override
  Widget build(BuildContext context) {
    final _PendingRequest request = approved.request;

    return _HoverSurface(
      borderRadius: BorderRadius.circular(12),
      builder: (BuildContext context, bool isHovered) {
        final Color background = isHovered
            ? AttendanceApprovalsMgView._approvedHoverBg
            : AttendanceApprovalsMgView._successBg;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AttendanceApprovalsMgView._successBorder),
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth < 560;
              final Widget details = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: AttendanceApprovalsMgView._successText,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          request.name,
                          style: TextStyle(
                            color: AttendanceApprovalsMgView._titleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          request.date,
                          style: TextStyle(
                            color: AttendanceApprovalsMgView._mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Approved on ${approved.approvedOn}',
                          style: TextStyle(
                            color: AttendanceApprovalsMgView._mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    details,
                    const SizedBox(height: 10),
                    const _ApprovedChip(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: details),
                  const SizedBox(width: 12),
                  const _ApprovedChip(),
                ],
              );
            },
          ),
        );
      },
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

class _ApprovedChip extends StatelessWidget {
  const _ApprovedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AttendanceApprovalsMgView._approvedChipBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AttendanceApprovalsMgView._successBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AttendanceApprovalsMgView._successText,
          ),
          SizedBox(width: 4),
          Text(
            'Approved',
            style: TextStyle(
              color: AttendanceApprovalsMgView._successText,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
