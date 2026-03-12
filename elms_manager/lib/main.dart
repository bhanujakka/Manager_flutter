import 'package:elms_manager/manager/sidebarmg.dart';
import 'package:flutter/material.dart';
import 'package:elms_manager/manager/dashboardmg.dart';
import 'package:elms_manager/manager/teamoverviewmg.dart';
import 'package:elms_manager/manager/taskassignmg.dart';
import 'package:elms_manager/manager/attendanceapprovalsmg.dart';
import 'package:elms_manager/manager/leaveapprovalsmg.dart';
import 'package:elms_manager/manager/notificationsmg.dart';
import 'package:elms_manager/manager/profilemg.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ManagerThemeController.mode,
      builder: (BuildContext context, ThemeMode mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ELMS Manager',
          theme: ManagerPalette.lightTheme(),
          darkTheme: ManagerPalette.darkTheme(),
          themeMode: mode,
          home: _ManagerHome(
            isDarkMode: mode == ThemeMode.dark,
            onToggleThemeTap: ManagerThemeController.toggle,
          ),
        );
      },
    );
  }
}

class _ManagerHome extends StatefulWidget {
  const _ManagerHome({
    required this.isDarkMode,
    required this.onToggleThemeTap,
  });

  final bool isDarkMode;
  final VoidCallback onToggleThemeTap;

  @override
  State<_ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<_ManagerHome> {
  int _selectedIndex = 0;
  bool _showProfile = false;

  static const List<String> _titles = <String>[
    'Dashboard',
    'Team Overview',
    'Task Assign',
    'Attendance Approvals',
    'Leave Approvals',
    'Notifications',
  ];

  Widget _buildBody() {
    if (_showProfile) {
      return ProfileMgView();
    }

    switch (_selectedIndex) {
      case 0:
        return DashboardMgView(
          onViewFullTeamTap: () {
            setState(() {
              _selectedIndex = 1;
              _showProfile = false;
            });
          },
          onManageLeaveApprovalsTap: () {
            setState(() {
              _selectedIndex = 4;
              _showProfile = false;
            });
          },
        );
      case 1:
        return TeamOverviewMgView();
      case 2:
        return TaskAssignMgView();
      case 3:
        return AttendanceApprovalsMgView();
      case 4:
        return LeaveApprovalsMgView();
      case 5:
        return NotificationsPage();
      default:
        return DashboardMgView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SidebarMgScaffold(
      topTitle: _titles[_selectedIndex],
      selectedIndex: _selectedIndex,
      isDarkMode: widget.isDarkMode,
      onThemeTap: widget.onToggleThemeTap,
      onItemSelected: (int index) {
        if (_selectedIndex != index || _showProfile) {
          setState(() {
            _selectedIndex = index;
            _showProfile = false;
          });
        }
      },
      onNotificationsTap: () {
        if (_selectedIndex != 5 || _showProfile) {
          setState(() {
            _selectedIndex = 5;
            _showProfile = false;
          });
        }
      },
      onProfileTap: () {
        if (!_showProfile) {
          setState(() {
            _showProfile = true;
          });
        }
      },
      body: _buildBody(),
    );
  }
}
