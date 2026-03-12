import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:elms_manager/manager/sidebarmg.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskAssignMgView extends StatefulWidget {
  const TaskAssignMgView({super.key});

  static Color get _pageBg => ManagerPalette.pageBg;
  static Color get _surface => ManagerPalette.surface;
  static Color get _border => ManagerPalette.border;
  static Color get _title => ManagerPalette.titleText;
  static Color get _muted => ManagerPalette.mutedText;
  static const Color _purple = Color(0xFF6E3FE8);
  static const Color _purpleAlt = Color(0xFF8F74EC);
  static Color get _chipOff => ManagerPalette.subtleSurfaceAlt;
  static List<Color> get _addMemberGradient => ManagerThemeController.isDark
      ? <Color>[const Color(0xFF4C1D95), ManagerPalette.primary]
      : <Color>[_purpleAlt, _purple];
  static List<Color> get _createProjectGradient => ManagerThemeController.isDark
      ? <Color>[const Color(0xFF4C1D95), ManagerPalette.primary]
      : <Color>[_purple, _purpleAlt];
  static String? persistedProjectTitle;
  static List<Color> get _memberAvatarGradient => ManagerThemeController.isDark
      ? <Color>[const Color(0xFF5B21B6), ManagerPalette.primary]
      : <Color>[_purpleAlt, _purple];
  static Color get _memberAvatarBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : const Color(0xFFE9E4F8);
  static Color get _memberActionBg => ManagerThemeController.isDark
      ? ManagerPalette.subtleSurfaceAlt
      : const Color(0xFFF1F0F7);

  @override
  State<TaskAssignMgView> createState() => _TaskAssignMgViewState();
}

enum _TaskStatusFilter { all, active, completed }

class _TaskAssignMgViewState extends State<TaskAssignMgView> {
  final TextEditingController _searchController = TextEditingController();
  _TaskStatusFilter _activeFilter = _TaskStatusFilter.all;
  _ProjectItem? _selectedProject;

  final List<_ProjectItem> _projects = <_ProjectItem>[
    _ProjectItem(
      title: 'E-Commerce Platform',
      description:
          'Full-stack e-commerce platform with React, Node.js, and MongoDB',
      dueDateLabel: 'Apr 15, 2026',
      daysRemainingLabel: '42 days remaining',
      teamLabel: 'Team: 5 members',
      timeRemainingLabel: '41 days',
      teamSizeLabel: '7 members',
      repositoryUrl: 'https://github.com/company/ecommerce-platform',
      teamMembers: <_TeamMember>[
        _TeamMember(
          name: 'Sarah Johnson',
          role: 'Project Manager',
          email: 'sarah.johnson@company.com',
        ),
        _TeamMember(
          name: 'John Smith',
          role: 'Frontend Developer',
          email: 'john.smith@company.com',
          level: 1,
          canDelete: true,
        ),
        _TeamMember(
          name: 'Michael Brown',
          role: 'Backend Developer',
          email: 'michael.brown@company.com',
          level: 1,
          canDelete: true,
        ),
        _TeamMember(
          name: 'Lisa Anderson',
          role: 'QA Team Lead',
          email: 'lisa.anderson@company.com',
          level: 1,
          canDelete: true,
        ),
      ],
      status: _ProjectStatus.active,
    ),
    _ProjectItem(
      title: 'Mobile Banking App',
      description:
          'Secure mobile banking application with biometric authentication',
      dueDateLabel: 'Mar 30, 2026',
      daysRemainingLabel: '26 days remaining',
      teamLabel: 'Team: 4 members',
      timeRemainingLabel: '26 days',
      teamSizeLabel: '6 members',
      repositoryUrl: 'https://github.com/company/mobile-banking-app',
      teamMembers: <_TeamMember>[
        _TeamMember(
          name: 'Priya Mehta',
          role: 'Product Owner',
          email: 'priya.mehta@company.com',
        ),
        _TeamMember(
          name: 'Daniel Kim',
          role: 'iOS Developer',
          email: 'daniel.kim@company.com',
          level: 1,
          canDelete: true,
        ),
        _TeamMember(
          name: 'Aarav Singh',
          role: 'Android Developer',
          email: 'aarav.singh@company.com',
          level: 1,
          canDelete: true,
        ),
        _TeamMember(
          name: 'Nina Lopez',
          role: 'Security Engineer',
          email: 'nina.lopez@company.com',
          level: 1,
          canDelete: true,
        ),
      ],
      status: _ProjectStatus.active,
    ),
    _ProjectItem(
      title: 'AI Chatbot Integration',
      description: 'Customer service chatbot powered by GPT-4',
      dueDateLabel: 'Feb 28, 2026',
      teamLabel: 'Team: 3 members',
      timeRemainingLabel: 'Completed',
      teamSizeLabel: '5 members',
      repositoryUrl: 'https://github.com/company/ai-chatbot-integration',
      teamMembers: <_TeamMember>[
        _TeamMember(
          name: 'Emily Davis',
          role: 'AI Lead',
          email: 'emily.davis@company.com',
        ),
        _TeamMember(
          name: 'Ryan Walker',
          role: 'ML Engineer',
          email: 'ryan.walker@company.com',
          level: 1,
          canDelete: true,
        ),
        _TeamMember(
          name: 'Sophia Clark',
          role: 'Prompt Engineer',
          email: 'sophia.clark@company.com',
          level: 1,
          canDelete: true,
        ),
      ],
      status: _ProjectStatus.completed,
    ),
  ];

  List<_ProjectItem> get _filteredProjects {
    final String q = _searchController.text.trim().toLowerCase();
    return _projects.where((_ProjectItem item) {
      final bool statusMatch = switch (_activeFilter) {
        _TaskStatusFilter.all => true,
        _TaskStatusFilter.active => item.status == _ProjectStatus.active,
        _TaskStatusFilter.completed => item.status == _ProjectStatus.completed,
      };
      if (!statusMatch) {
        return false;
      }
      if (q.isEmpty) {
        return true;
      }
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openCreateProjectDialog() async {
    final _CreateProjectFormData? formData =
        await showDialog<_CreateProjectFormData>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          builder: (BuildContext context) {
            return const _CreateProjectDialog();
          },
        );

    if (!mounted || formData == null) {
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    int daysRemaining = formData.deadline.difference(today).inDays;
    if (daysRemaining < 0) {
      daysRemaining = 0;
    }
    final String dayText = daysRemaining == 1 ? 'day' : 'days';
    final String timeRemaining = '$daysRemaining $dayText';
    final String normalizedName = formData.projectName.toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '.',
    );
    final String slug = normalizedName.replaceAll(RegExp(r'(^\.+)|(\.+$)'), '');
    final String leadEmail =
        '${slug.isEmpty ? 'project' : slug}.lead@company.com';

    setState(() {
      _projects.insert(
        0,
        _ProjectItem(
          title: formData.projectName,
          description: formData.description,
          dueDateLabel: _formatDueDate(formData.deadline),
          daysRemainingLabel: '$timeRemaining remaining',
          teamLabel: 'Team: 1 member',
          timeRemainingLabel: timeRemaining,
          teamSizeLabel: '1 member',
          repositoryUrl: formData.repositoryUrl,
          teamMembers: <_TeamMember>[
            _TeamMember(
              name: 'Unassigned Lead',
              role: 'Project Lead',
              email: leadEmail,
            ),
          ],
          status: _ProjectStatus.active,
        ),
      );
    });
  }

  String _formatDueDate(DateTime date) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedProject = _projectFromTitle(TaskAssignMgView.persistedProjectTitle);
  }

  _ProjectItem? _projectFromTitle(String? title) {
    if (title == null) {
      return null;
    }
    for (final _ProjectItem item in _projects) {
      if (item.title == title) {
        return item;
      }
    }
    return null;
  }

  void _setSelectedProject(_ProjectItem? item) {
    setState(() {
      _selectedProject = item;
      TaskAssignMgView.persistedProjectTitle = item?.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final bool isDesktop = width >= 1080;
        final bool isTablet = width >= 760;
        final bool isMobile = width < 760;
        final double sidePadding = isDesktop ? 24 : 16;
        final bool isDetailDesktop = width >= 1100;
        final double detailSidePadding = isDetailDesktop ? 28 : 16;
        final bool useGrid = width >= 980;

        if (_selectedProject != null) {
          return Container(
            color: TaskAssignMgView._pageBg,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  detailSidePadding,
                  20,
                  detailSidePadding,
                  28,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: isDetailDesktop ? 1280 : 980),
                    child: _ProjectDetailContent(
                      project: _selectedProject!,
                      isDesktop: isDetailDesktop,
                      onBack: () => _setSelectedProject(null),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Container(
          color: TaskAssignMgView._pageBg,
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sidePadding, 22, sidePadding, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1260),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (isDesktop) ...<Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Task Assign',
                                    style: TextStyle(
                                      color: TaskAssignMgView._title,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700,
                                      height: 1.05,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Create and manage project assignments',
                                    style: TextStyle(
                                      color: TaskAssignMgView._muted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            _CreateProjectButton(
                              isCompact: width < 460,
                              onTap: _openCreateProjectDialog,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ] else ...<Widget>[
                        Text(
                          'Task Assign',
                          style: TextStyle(
                            color: TaskAssignMgView._title,
                            fontSize: isTablet ? 30 : 23,
                            fontWeight: FontWeight.w700,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create and manage project assignments',
                          style: TextStyle(
                            color: TaskAssignMgView._muted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _CreateProjectButton(
                          isCompact: width < 460,
                          onTap: _openCreateProjectDialog,
                        ),
                        const SizedBox(height: 24),
                      ],
                      _SearchAndFilterCard(
                        searchController: _searchController,
                        activeFilter: _activeFilter,
                        onSearchChanged: (_) => setState(() {}),
                        onFilterChanged: (_TaskStatusFilter value) {
                          if (_activeFilter == value) {
                            return;
                          }
                          setState(() => _activeFilter = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints content) {
                              final double spacing = isMobile ? 12 : 16;
                              final int columnCount = isDesktop
                                  ? 3
                                  : (useGrid ? 2 : 1);
                              final double totalSpacing =
                                  spacing * (columnCount - 1);
                              final double cardWidth =
                                  (content.maxWidth - totalSpacing) /
                                  columnCount;
                              final List<_ProjectItem> visible =
                                  _filteredProjects;

                              if (visible.isEmpty) {
                                return _EmptyStateCard(width: content.maxWidth);
                              }

                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: visible
                                    .map(
                                      (_ProjectItem item) => SizedBox(
                                        width: cardWidth,
                                        child: _ProjectCard(
                                          item: item,
                                          onTap: () => _setSelectedProject(item),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
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

enum _ProjectStatus { active, completed }

class _ProjectItem {
  const _ProjectItem({
    required this.title,
    required this.description,
    required this.dueDateLabel,
    required this.teamLabel,
    required this.timeRemainingLabel,
    required this.teamSizeLabel,
    required this.repositoryUrl,
    required this.teamMembers,
    required this.status,
    this.daysRemainingLabel,
  });

  final String title;
  final String description;
  final String dueDateLabel;
  final String teamLabel;
  final String timeRemainingLabel;
  final String teamSizeLabel;
  final String repositoryUrl;
  final List<_TeamMember> teamMembers;
  final _ProjectStatus status;
  final String? daysRemainingLabel;
}

class _TeamMember {
  const _TeamMember({
    required this.name,
    required this.role,
    required this.email,
    this.level = 0,
    this.canDelete = false,
  });

  final String name;
  final String role;
  final String email;
  final int level;
  final bool canDelete;
}

class _CreateProjectButton extends StatelessWidget {
  const _CreateProjectButton({required this.isCompact, required this.onTap});

  final bool isCompact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 14 : 18,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: TaskAssignMgView._createProjectGradient,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Create Project',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isCompact ? 12 : (isDesktop ? 13 : 14),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateProjectFormData {
  const _CreateProjectFormData({
    required this.projectName,
    required this.description,
    required this.deadline,
    required this.repositoryUrl,
  });

  final String projectName;
  final String description;
  final DateTime deadline;
  final String repositoryUrl;
}

class _CreateProjectDialog extends StatefulWidget {
  const _CreateProjectDialog();

  @override
  State<_CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<_CreateProjectDialog> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _repositoryController = TextEditingController();
  DateTime? _deadline;
  String? _errorText;

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    _repositoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final DateTime now = DateTime.now();
    final DateTime first = DateTime(now.year, now.month, now.day);
    final DateTime initial = _deadline ?? first;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(first.year + 5),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  String get _deadlineLabel {
    if (_deadline == null) {
      return '';
    }
    final String y = _deadline!.year.toString().padLeft(4, '0');
    final String m = _deadline!.month.toString().padLeft(2, '0');
    final String d = _deadline!.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  bool _isValidUrl(String value) {
    final Uri? uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _createProject() {
    final String projectName = _projectNameController.text.trim();
    final String description = _descriptionController.text.trim();
    final String repository = _repositoryController.text.trim();

    if (projectName.isEmpty ||
        description.isEmpty ||
        repository.isEmpty ||
        _deadline == null) {
      setState(() {
        _errorText = 'Please fill all required fields.';
      });
      return;
    }

    if (!_isValidUrl(repository)) {
      setState(() {
        _errorText = 'Please enter a valid repository URL.';
      });
      return;
    }

    Navigator.of(context).pop(
      _CreateProjectFormData(
        projectName: projectName,
        description: description,
        deadline: _deadline!,
        repositoryUrl: repository,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 640;
    final double dialogWidth = isMobile ? 360 : 550;
    final bool isDark = ManagerThemeController.isDark;
    final Color dialogBg = isDark ? TaskAssignMgView._surface : Colors.white;

    return Dialog(
      elevation: 14,
      backgroundColor: dialogBg,
      surfaceTintColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          minWidth: isMobile ? 320 : 520,
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Create New Project',
                    style: TextStyle(
                      color: TaskAssignMgView._title,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _DialogFieldLabel(text: 'Project Name *'),
                  const SizedBox(height: 8),
                  _DialogInputField(
                    controller: _projectNameController,
                    hint: 'Enter project name',
                  ),
                  const SizedBox(height: 14),
                  _DialogFieldLabel(text: 'Description *'),
                  const SizedBox(height: 8),
                  _DialogInputField(
                    controller: _descriptionController,
                    hint: 'Enter project description',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),
                  _DialogFieldLabel(text: 'Deadline *'),
                  const SizedBox(height: 8),
                  _DialogDateField(
                    value: _deadlineLabel,
                    hint: 'yyyy-mm-dd',
                    onTap: _pickDeadline,
                  ),
                  const SizedBox(height: 14),
                  _DialogFieldLabel(text: 'GitHub Repository Link *'),
                  const SizedBox(height: 8),
                  _DialogInputField(
                    controller: _repositoryController,
                    hint: 'https://github.com/...',
                    keyboardType: TextInputType.url,
                  ),
                  if (_errorText != null) ...<Widget>[
                    const SizedBox(height: 10),
                    Text(
                      _errorText!,
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(96, 38),
                          side: BorderSide(color: Color(0xFFD4D8E1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: TaskAssignMgView._title,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _createProject,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 38),
                          backgroundColor: isDark
                              ? ManagerPalette.primary
                              : TaskAssignMgView._purple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Create Project',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 10,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 18,
                icon: Icon(
                  Icons.close,
                  color: TaskAssignMgView._muted,
                  size: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogFieldLabel extends StatelessWidget {
  const _DialogFieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: TaskAssignMgView._title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DialogInputField extends StatelessWidget {
  const _DialogInputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final Color fieldFill = ManagerThemeController.isDark
        ? ManagerPalette.subtleSurfaceAlt
        : Colors.white;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: TaskAssignMgView._title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: TaskAssignMgView._muted,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: maxLines == 1 ? 10 : 11,
        ),
        filled: true,
        fillColor: fieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TaskAssignMgView._border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TaskAssignMgView._border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: TaskAssignMgView._purple),
        ),
      ),
    );
  }
}

class _DialogDateField extends StatelessWidget {
  const _DialogDateField({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  final String value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String displayText = value.isEmpty ? hint : value;
    final Color textColor = value.isEmpty
        ? TaskAssignMgView._muted
        : TaskAssignMgView._title;
    final Color fieldFill = ManagerThemeController.isDark
        ? ManagerPalette.subtleSurfaceAlt
        : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: TaskAssignMgView._border),
          color: fieldFill,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.calendar_month_outlined,
              color: TaskAssignMgView._muted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilterCard extends StatelessWidget {
  const _SearchAndFilterCard({
    required this.searchController,
    required this.activeFilter,
    required this.onSearchChanged,
    required this.onFilterChanged,
  });

  final TextEditingController searchController;
  final _TaskStatusFilter activeFilter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<_TaskStatusFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;
    final List<Widget> filterButtons = <Widget>[
      _FilterChipButton(
        label: 'All',
        selected: activeFilter == _TaskStatusFilter.all,
        onTap: () => onFilterChanged(_TaskStatusFilter.all),
      ),
      _FilterChipButton(
        label: 'Active',
        selected: activeFilter == _TaskStatusFilter.active,
        onTap: () => onFilterChanged(_TaskStatusFilter.active),
      ),
      _FilterChipButton(
        label: 'Completed',
        selected: activeFilter == _TaskStatusFilter.completed,
        onTap: () => onFilterChanged(_TaskStatusFilter.completed),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: TaskAssignMgView._surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TaskAssignMgView._border),
      ),
      child: Column(
        children: <Widget>[
          if (isDesktop)
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    style: TextStyle(
                      color: TaskAssignMgView._title,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search_rounded,
                        color: TaskAssignMgView._muted,
                        size: 15,
                      ),
                      hintText: 'Search projects...',
                      hintStyle: TextStyle(
                        color: TaskAssignMgView._muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ...<Widget>[
                  filterButtons[0],
                  const SizedBox(width: 8),
                  filterButtons[1],
                  const SizedBox(width: 8),
                  filterButtons[2],
                ],
              ],
            )
          else ...<Widget>[
            TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: TextStyle(
                color: TaskAssignMgView._title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                icon: Icon(
                  Icons.search_rounded,
                  color: TaskAssignMgView._muted,
                  size: 15,
                ),
                hintText: 'Search projects...',
                hintStyle: TextStyle(
                  color: TaskAssignMgView._muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(spacing: 10, runSpacing: 10, children: filterButtons),
          ],
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 760;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? TaskAssignMgView._purple
                : TaskAssignMgView._chipOff,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: TaskAssignMgView._border),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : TaskAssignMgView._title,
              fontSize: isDesktop ? 11 : (isMobile ? 13 : 12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.item, required this.onTap});

  final _ProjectItem item;
  final VoidCallback onTap;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;
  bool _suppressNextCardTap = false;

  Uri _fallbackRepositoryUri() {
    final String slug = widget.item.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final String safeSlug = slug.isEmpty ? 'sample-project' : slug;
    return Uri.parse('https://github.com/demo/$safeSlug/tree/main');
  }

  Uri _repositoryUriFromRaw() {
    final String raw = widget.item.repositoryUrl.trim();
    if (raw.isEmpty) {
      return _fallbackRepositoryUri();
    }

    final Uri? parsed = Uri.tryParse(raw);
    if (parsed == null) {
      return _fallbackRepositoryUri();
    }

    if (parsed.scheme == 'http' || parsed.scheme == 'https') {
      return parsed;
    }

    if (!parsed.hasScheme) {
      final Uri? prefixed = Uri.tryParse('https://$raw');
      if (prefixed != null &&
          (prefixed.scheme == 'http' || prefixed.scheme == 'https')) {
        return prefixed;
      }
    }

    return _fallbackRepositoryUri();
  }

  Future<void> _openRepositoryLink() async {
    final Uri targetUri = _repositoryUriFromRaw();
    bool opened = await launchUrl(
      targetUri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
    if (!opened) {
      opened = await launchUrl(targetUri, mode: LaunchMode.externalApplication);
    }
    if (!mounted) {
      return;
    }
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open repository link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= 1080;
    final bool isMobile = width < 760;
    final bool enableHover = !isMobile;
    final bool isHovered = enableHover && _isHovered;
    final bool isDark = ManagerThemeController.isDark;
    final Color titleColor = isHovered
        ? const Color(0xFF4C1D95)
        : TaskAssignMgView._title;
    final Color repositoryLinkColor = isHovered
        ? (isDark ? ManagerPalette.primary : const Color(0xFF4C1D95))
        : (isDark ? TaskAssignMgView._title : const Color(0xFF000000));

    return MouseRegion(
      cursor: enableHover ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enableHover ? (_) => setState(() => _isHovered = true) : null,
      onExit: enableHover ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: () {
          if (_suppressNextCardTap) {
            _suppressNextCardTap = false;
            return;
          }
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translateByDouble(0.0, isHovered ? -4.0 : 0.0, 0.0, 1.0),
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 10 : 12,
            isMobile ? 10 : 12,
            isMobile ? 10 : 12,
            isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: TaskAssignMgView._surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isHovered
                  ? TaskAssignMgView._purple.withValues(alpha: 0.45)
                  : TaskAssignMgView._border,
            ),
            boxShadow: isHovered
                ? <BoxShadow>[
                    BoxShadow(
                      color: TaskAssignMgView._purple.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: isMobile ? 38 : 44,
                    height: isMobile ? 38 : 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          TaskAssignMgView._purple,
                          TaskAssignMgView._purpleAlt,
                        ],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.folder_outlined,
                      color: Colors.white,
                      size: isMobile ? 17 : 19,
                    ),
                  ),
                  const Spacer(),
                  _StatusChip(status: widget.item.status),
                ],
              ),
              SizedBox(height: isMobile ? 8 : 10),
              Text(
                widget.item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontSize: isDesktop ? 13 : (isMobile ? 12 : 14),
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              SizedBox(height: isMobile ? 4 : 6),
              Text(
                widget.item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: TaskAssignMgView._muted,
                  fontSize: isDesktop ? 11 : (isMobile ? 11 : 12),
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              ),
              SizedBox(height: isMobile ? 6 : 8),
              _InfoRow(
                icon: Icons.calendar_month_outlined,
                text: 'Due: ${widget.item.dueDateLabel}',
                textColor: TaskAssignMgView._muted,
              ),
              if (widget.item.daysRemainingLabel != null) ...<Widget>[
                SizedBox(height: isMobile ? 3 : 5),
                _InfoRow(
                  icon: Icons.access_time_outlined,
                  text: widget.item.daysRemainingLabel!,
                  textColor: TaskAssignMgView._muted,
                ),
              ],
              SizedBox(height: isMobile ? 3 : 5),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () async {
                    _suppressNextCardTap = true;
                    await _openRepositoryLink();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: _InfoRow(
                      icon: Icons.code_outlined,
                      text: 'Repository Link',
                      textColor: repositoryLinkColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Divider(height: 1, color: TaskAssignMgView._border),
              SizedBox(height: isMobile ? 6 : 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.item.teamLabel,
                      style: TextStyle(
                        color: TaskAssignMgView._muted,
                        fontSize: isDesktop ? 11 : (isMobile ? 11 : 12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: TaskAssignMgView._muted,
                    size: isMobile ? 15 : 17,
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

class _ProjectDetailContent extends StatefulWidget {
  const _ProjectDetailContent({
    required this.project,
    required this.isDesktop,
    this.onBack,
  });

  final _ProjectItem project;
  final bool isDesktop;
  final VoidCallback? onBack;

  @override
  State<_ProjectDetailContent> createState() => _ProjectDetailContentState();
}

class _ProjectDetailContentState extends State<_ProjectDetailContent> {
  bool _isParentExpanded = true;
  final Set<String> _expandedChildKeys = <String>{};
  late final List<_TeamMember> _teamMembers;
  static const List<String> _roleOptions = <String>[
    'UI/UX Designer',
    'Frontend Developer',
    'Backend Developer',
    'QA Engineer',
    'QA Team Lead',
    'Database Admin',
    'Project Manager',
  ];

  @override
  void initState() {
    super.initState();
    _teamMembers = List<_TeamMember>.from(widget.project.teamMembers);
  }

  bool _isChildExpanded(_TeamMember member) {
    return _expandedChildKeys.contains(member.email);
  }

  void _toggleChild(_TeamMember member) {
    setState(() {
      if (_expandedChildKeys.contains(member.email)) {
        _expandedChildKeys.remove(member.email);
      } else {
        _expandedChildKeys.add(member.email);
      }
    });
  }

  Future<void> _openAddMemberDialog({_TeamMember? parent}) async {
    final _AddTeamMemberFormData? formData =
        await showDialog<_AddTeamMemberFormData>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          builder: (BuildContext context) {
            return _AddTeamMemberDialog(roleOptions: _roleOptions);
          },
        );

    if (!mounted || formData == null) {
      return;
    }

    final _TeamMember insertUnder =
        parent ??
        _teamMembers.firstWhere(
          (_TeamMember member) => member.level == 0,
          orElse: () =>
              const _TeamMember(name: '', role: '', email: '', level: -1),
        );
    final bool hasValidParent = insertUnder.level >= 0;
    final int nextLevel = hasValidParent ? insertUnder.level + 1 : 0;
    int insertIndex = _teamMembers.length;

    if (hasValidParent) {
      final int parentIndex = _teamMembers.indexOf(insertUnder);
      if (parentIndex >= 0) {
        insertIndex = parentIndex + 1;
        while (insertIndex < _teamMembers.length &&
            _teamMembers[insertIndex].level > insertUnder.level) {
          insertIndex++;
        }
      }
    }

    final _TeamMember newMember = _TeamMember(
      name: formData.fullName,
      role: formData.role,
      email: formData.email,
      level: nextLevel,
      canDelete: nextLevel > 0,
    );

    setState(() {
      _teamMembers.insert(insertIndex, newMember);
      _expandedChildKeys.add(newMember.email);
    });

    _showMemberAddedPopup();
  }

  void _showMemberAddedPopup() {
    if (!mounted) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final double screenWidth = MediaQuery.sizeOf(context).width;
    const double horizontalPadding = 16;
    const double popupWidth = 320;
    final bool useBottomRightLayout =
        screenWidth >= popupWidth + (horizontalPadding * 2);
    final EdgeInsets margin = useBottomRightLayout
        ? EdgeInsets.only(
            left: screenWidth - popupWidth - horizontalPadding,
            right: horizontalPadding,
            bottom: 16,
          )
        : const EdgeInsets.fromLTRB(16, 0, 16, 16);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Row(
            children: <Widget>[
              Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF16A34A),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Team Member added successfully',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          margin: margin,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
      );
  }

  void _removeTeamMember(_TeamMember member) {
    if (member.level == 0) {
      return;
    }

    final int startIndex = _teamMembers.indexWhere(
      (_TeamMember existing) => existing.email == member.email,
    );
    if (startIndex < 0) {
      return;
    }

    int endIndex = startIndex + 1;
    while (endIndex < _teamMembers.length &&
        _teamMembers[endIndex].level > member.level) {
      endIndex++;
    }

    final List<_TeamMember> removedMembers = _teamMembers.sublist(
      startIndex,
      endIndex,
    );

    setState(() {
      _teamMembers.removeRange(startIndex, endIndex);
      for (final _TeamMember removed in removedMembers) {
        _expandedChildKeys.remove(removed.email);
      }
    });
  }

  Uri _fallbackRepositoryUri() {
    final String slug = widget.project.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final String safeSlug = slug.isEmpty ? 'sample-project' : slug;
    return Uri.parse('https://github.com/demo/$safeSlug/tree/main');
  }

  Uri _repositoryUriFromRaw() {
    final String raw = widget.project.repositoryUrl.trim();
    if (raw.isEmpty) {
      return _fallbackRepositoryUri();
    }

    final Uri? parsed = Uri.tryParse(raw);
    if (parsed == null) {
      return _fallbackRepositoryUri();
    }

    if (parsed.scheme == 'http' || parsed.scheme == 'https') {
      return parsed;
    }

    if (!parsed.hasScheme) {
      final Uri? prefixed = Uri.tryParse('https://$raw');
      if (prefixed != null &&
          (prefixed.scheme == 'http' || prefixed.scheme == 'https')) {
        return prefixed;
      }
    }

    return _fallbackRepositoryUri();
  }

  Future<void> _openRepositoryLink() async {
    final Uri targetUri = _repositoryUriFromRaw();
    bool opened = await launchUrl(
      targetUri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
    if (!opened) {
      opened = await launchUrl(targetUri, mode: LaunchMode.externalApplication);
    }
    if (!mounted) {
      return;
    }
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open repository link.')),
      );
    }
  }

  bool _areAncestorsExpanded(List<_TeamMember> orderedChildren, int index) {
    final _TeamMember member = orderedChildren[index];
    if (member.level <= 1) {
      return true;
    }

    int requiredLevel = member.level - 1;
    int searchIndex = index - 1;
    while (requiredLevel >= 1) {
      while (searchIndex >= 0 &&
          orderedChildren[searchIndex].level > requiredLevel) {
        searchIndex--;
      }
      if (searchIndex < 0 ||
          orderedChildren[searchIndex].level != requiredLevel) {
        return false;
      }
      if (!_isChildExpanded(orderedChildren[searchIndex])) {
        return false;
      }
      requiredLevel--;
      searchIndex--;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !widget.isDesktop;
    final String repositoryDisplay = _repositoryUriFromRaw().toString();
    final List<_TeamMember> allChildMembers = _teamMembers
        .where((_TeamMember member) => member.level > 0)
        .toList();
    final List<_TeamMember> childMembers = <_TeamMember>[
      for (int i = 0; i < allChildMembers.length; i++)
        if (_areAncestorsExpanded(allChildMembers, i)) allChildMembers[i],
    ];
    final List<_TeamMember> parentMembers = _teamMembers
        .where((_TeamMember member) => member.level == 0)
        .toList();
    final _TeamMember? parentMember = parentMembers.isEmpty
        ? null
        : parentMembers.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: TaskAssignMgView._title,
                size: widget.isDesktop ? 28 : 26,
              ),
              onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.project.title,
                        style: TextStyle(
                          color: TaskAssignMgView._title,
                          fontSize: widget.isDesktop ? 22 : 28,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                        ),
                      ),
                      _StatusChip(status: widget.project.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    style: TextStyle(
                      color: TaskAssignMgView._muted,
                      fontSize: widget.isDesktop ? 14 : 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.isDesktop)
          Row(
            children: <Widget>[
              Expanded(
                child: _DetailInfoCard(
                  icon: Icons.calendar_month_outlined,
                  iconColor: const Color(0xFF3B82F6),
                  iconBackground: const Color(0xFFDBEAFE),
                  label: 'Deadline',
                  value: widget.project.dueDateLabel,
                  isDesktop: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailInfoCard(
                  icon: Icons.access_time_rounded,
                  iconColor: const Color(0xFF22C55E),
                  iconBackground: const Color(0xFFDCFCE7),
                  label: 'Time Remaining',
                  value: widget.project.timeRemainingLabel,
                  isDesktop: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailInfoCard(
                  icon: Icons.group_outlined,
                  iconColor: const Color(0xFFA855F7),
                  iconBackground: const Color(0xFFF3E8FF),
                  label: 'Team Size',
                  value: widget.project.teamSizeLabel,
                  isDesktop: true,
                ),
              ),
            ],
          )
        else ...<Widget>[
          _DetailInfoCard(
            icon: Icons.calendar_month_outlined,
            iconColor: const Color(0xFF3B82F6),
            iconBackground: const Color(0xFFDBEAFE),
            label: 'Deadline',
            value: widget.project.dueDateLabel,
            isDesktop: false,
          ),
          const SizedBox(height: 16),
          _DetailInfoCard(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF22C55E),
            iconBackground: const Color(0xFFDCFCE7),
            label: 'Time Remaining',
            value: widget.project.timeRemainingLabel,
            isDesktop: false,
          ),
          const SizedBox(height: 16),
          _DetailInfoCard(
            icon: Icons.group_outlined,
            iconColor: const Color(0xFFA855F7),
            iconBackground: const Color(0xFFF3E8FF),
            label: 'Team Size',
            value: widget.project.teamSizeLabel,
            isDesktop: false,
          ),
        ],
        const SizedBox(height: 12),
        _DetailInfoCard(
          icon: Icons.code_rounded,
          iconColor: const Color(0xFF6B7280),
          iconBackground: const Color(0xFFE5E7EB),
          label: 'Repository',
          value: repositoryDisplay,
          valueColor: TaskAssignMgView._purple,
          isDesktop: widget.isDesktop,
          isLink: true,
          linkUri: _repositoryUriFromRaw(),
          onTap: _openRepositoryLink,
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 12 : 14,
            isMobile ? 14 : 16,
            isMobile ? 12 : 14,
            isMobile ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: TaskAssignMgView._surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: TaskAssignMgView._border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Team Structure',
                      style: TextStyle(
                        color: TaskAssignMgView._title,
                        fontSize: widget.isDesktop ? 18 : 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _AddTeamMemberButton(
                    isMobile: isMobile,
                    onTap: () => _openAddMemberDialog(parent: parentMember),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (parentMember != null)
                _TeamMemberTile(
                  member: parentMember,
                  isMobile: isMobile,
                  isExpanded: _isParentExpanded,
                  onAddMemberTap: () =>
                      _openAddMemberDialog(parent: parentMember),
                  onArrowTap: () {
                    setState(() => _isParentExpanded = !_isParentExpanded);
                  },
                  onDeleteTap: () => _removeTeamMember(parentMember),
                ),
              if (_isParentExpanded)
                ...childMembers.asMap().entries.map(
                  (MapEntry<int, _TeamMember> entry) => _IndentedTeamMember(
                    member: entry.value,
                    isMobile: isMobile,
                    isLast: entry.key == childMembers.length - 1,
                    isExpanded: _isChildExpanded(entry.value),
                    onArrowTap: () => _toggleChild(entry.value),
                    onAddMemberTap: () =>
                        _openAddMemberDialog(parent: entry.value),
                    onDeleteTap: () => _removeTeamMember(entry.value),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailInfoCard extends StatelessWidget {
  const _DetailInfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
    required this.isDesktop,
    this.valueColor,
    this.isLink = false,
    this.linkUri,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final bool isDesktop;
  final Color? valueColor;
  final bool isLink;
  final Uri? linkUri;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !isDesktop;
    final Color resolvedValueColor = valueColor ?? TaskAssignMgView._title;
    final bool isDark = ManagerThemeController.isDark;
    final Color resolvedIconBackground =
        isDark ? iconColor.withValues(alpha: 0.18) : iconBackground;

    final Widget card = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 14,
        vertical: isMobile ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: TaskAssignMgView._surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: TaskAssignMgView._border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: isMobile ? 52 : 56,
            height: isMobile ? 52 : 56,
            decoration: BoxDecoration(
              color: resolvedIconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: isMobile ? 26 : 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: TaskAssignMgView._muted,
                    fontSize: isMobile ? 16 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: resolvedValueColor,
                    fontSize: isMobile ? 18 : 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    decoration: isLink
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: resolvedValueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (linkUri != null && onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: card,
        ),
      );
    }

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}

class _AddTeamMemberFormData {
  const _AddTeamMemberFormData({
    required this.fullName,
    required this.role,
    required this.email,
  });

  final String fullName;
  final String role;
  final String email;
}

class _AddTeamMemberDialog extends StatefulWidget {
  const _AddTeamMemberDialog({required this.roleOptions});

  final List<String> roleOptions;

  @override
  State<_AddTeamMemberDialog> createState() => _AddTeamMemberDialogState();
}

class _AddTeamMemberDialogState extends State<_AddTeamMemberDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    if (widget.roleOptions.isNotEmpty) {
      _selectedRole = widget.roleOptions.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String input) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(input);
  }

  void _submit() {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String role = (_selectedRole ?? '').trim();

    if (name.isEmpty || email.isEmpty || role.isEmpty) {
      setState(() => _errorText = 'Please fill all required fields.');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _errorText = 'Enter a valid email address.');
      return;
    }

    Navigator.of(
      context,
    ).pop(_AddTeamMemberFormData(fullName: name, role: role, email: email));
  }

  InputDecoration _fieldDecoration(String hintText) {
    final Color fillColor = ManagerThemeController.isDark
        ? ManagerPalette.subtleSurfaceAlt
        : Colors.white;

    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: TaskAssignMgView._muted,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: TaskAssignMgView._border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: TaskAssignMgView._purple),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      backgroundColor: TaskAssignMgView._surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, isMobile ? 16 : 18, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Team Member',
                style: TextStyle(
                  color: TaskAssignMgView._title,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Full Name *',
                style: TextStyle(
                  color: TaskAssignMgView._title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: _fieldDecoration('Enter full name'),
              ),
              const SizedBox(height: 12),
              Text(
                'Role *',
                style: TextStyle(
                  color: TaskAssignMgView._title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                isExpanded: true,
                decoration: _fieldDecoration('Select role'),
                items: widget.roleOptions
                    .map(
                      (String role) => DropdownMenuItem<String>(
                        value: role,
                        child: Text(
                          role,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TaskAssignMgView._title,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() => _selectedRole = value);
                },
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: TaskAssignMgView._muted,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Email *',
                style: TextStyle(
                  color: TaskAssignMgView._title,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration('email@company.com'),
              ),
              if (_errorText != null) ...<Widget>[
                const SizedBox(height: 10),
                Text(
                  _errorText!,
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  if (isMobile) ...<Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: TaskAssignMgView._border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: Icon(Icons.person_add_alt_1_outlined, size: 18),
                        label: Text('Add Member'),
                        style: FilledButton.styleFrom(
                          backgroundColor: TaskAssignMgView._purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ] else ...<Widget>[
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: TaskAssignMgView._border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: Icon(Icons.person_add_alt_1_outlined, size: 18),
                      label: Text('Add Member'),
                      style: FilledButton.styleFrom(
                        backgroundColor: ManagerThemeController.isDark
                            ? ManagerPalette.primary
                            : TaskAssignMgView._purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTeamMemberButton extends StatelessWidget {
  const _AddTeamMemberButton({required this.isMobile, required this.onTap});

  final bool isMobile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 14,
            vertical: isMobile ? 8 : 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: TaskAssignMgView._addMemberGradient,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                'Add Team Member',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IndentedTeamMember extends StatelessWidget {
  const _IndentedTeamMember({
    required this.member,
    required this.isMobile,
    required this.isLast,
    required this.isExpanded,
    required this.onArrowTap,
    required this.onAddMemberTap,
    required this.onDeleteTap,
  });

  final _TeamMember member;
  final bool isMobile;
  final bool isLast;
  final bool isExpanded;
  final VoidCallback onArrowTap;
  final VoidCallback onAddMemberTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final int nestedDepth = member.level > 1 ? member.level - 1 : 0;
    final double nestedOffset = nestedDepth * (isMobile ? 18 : 24);

    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: (isMobile ? 12 : 30) + nestedOffset,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: isMobile ? 26 : 34,
            height: isMobile ? 80 : 96,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: isMobile ? 10 : 14,
                  top: 0,
                  bottom: isLast ? (isMobile ? 45 : 52) : 0,
                  child: Container(width: 2, color: TaskAssignMgView._border),
                ),
                Positioned(
                  left: isMobile ? 10 : 14,
                  top: isMobile ? 42 : 48,
                  child: Container(
                    width: isMobile ? 14 : 20,
                    height: 2,
                    color: TaskAssignMgView._border,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _TeamMemberTile(
              member: member,
              isMobile: isMobile,
              isExpanded: isExpanded,
              onArrowTap: onArrowTap,
              onAddMemberTap: onAddMemberTap,
              onDeleteTap: onDeleteTap,
              collapseDetailsWhenClosed: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  const _TeamMemberTile({
    required this.member,
    required this.isMobile,
    required this.isExpanded,
    required this.onArrowTap,
    required this.onAddMemberTap,
    this.onDeleteTap,
    this.collapseDetailsWhenClosed = false,
  });

  final _TeamMember member;
  final bool isMobile;
  final bool isExpanded;
  final VoidCallback onArrowTap;
  final VoidCallback onAddMemberTap;
  final VoidCallback? onDeleteTap;
  final bool collapseDetailsWhenClosed;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isMobile ? 50 : 52;
    final bool showExtraDetails = !collapseDetailsWhenClosed || isExpanded;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 9 : 10,
        vertical: isMobile ? 8 : 9,
      ),
      decoration: BoxDecoration(
        color: TaskAssignMgView._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: TaskAssignMgView._border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: onArrowTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.chevron_right_rounded,
                color: TaskAssignMgView._title,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: member.level == 0
                  ? LinearGradient(colors: TaskAssignMgView._memberAvatarGradient)
                  : null,
              color:
                  member.level == 0 ? null : TaskAssignMgView._memberAvatarBg,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person_outline_rounded,
              color: member.level == 0
                  ? Colors.white
                  : TaskAssignMgView._purple,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  member.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: TaskAssignMgView._title,
                    fontSize: isMobile ? 17 : 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  member.role,
                  style: TextStyle(
                    color: TaskAssignMgView._muted,
                    fontSize: isMobile ? 13 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: showExtraDetails
                      ? Text(
                          member.email,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: TaskAssignMgView._muted,
                            fontSize: isMobile ? 11 : 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            child: showExtraDetails
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(width: 8),
                      _MemberActionButton(
                        isMobile: isMobile,
                        onTap: onAddMemberTap,
                      ),
                      if (member.canDelete && onDeleteTap != null) ...<Widget>[
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: onDeleteTap,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                color: const Color(0xFFEF4444),
                                size: isMobile ? 19 : 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MemberActionButton extends StatelessWidget {
  const _MemberActionButton({required this.isMobile, required this.onTap});

  final bool isMobile;
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 10,
            vertical: isMobile ? 6 : 7,
          ),
          decoration: BoxDecoration(
            color: TaskAssignMgView._memberActionBg,
            border: Border.all(color: TaskAssignMgView._border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.person_add_alt_1_outlined,
                size: isMobile ? 16 : 18,
                color: TaskAssignMgView._title,
              ),
              if (!isMobile) ...<Widget>[
                const SizedBox(width: 6),
                Text(
                  'Add Member',
                  style: TextStyle(
                    color: TaskAssignMgView._title,
                    fontSize: 12,
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _ProjectStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 760;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;
    final bool isActive = status == _ProjectStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? TaskAssignMgView._purple : TaskAssignMgView._chipOff,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        isActive ? 'Active' : 'Completed',
        style: TextStyle(
          color: isActive ? Colors.white : TaskAssignMgView._title,
          fontSize: isDesktop ? 10 : (isMobile ? 12 : 11),
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.textColor,
  });

  final IconData icon;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 760;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 16, color: TaskAssignMgView._muted),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: isDesktop ? 11 : (isMobile ? 13 : 12),
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 760;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1080;

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: TaskAssignMgView._surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TaskAssignMgView._border),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.inbox_outlined, color: TaskAssignMgView._muted, size: 28),
          const SizedBox(height: 8),
          Text(
            'No projects found',
            style: TextStyle(
              color: TaskAssignMgView._title,
              fontSize: isDesktop ? 12 : (isMobile ? 14 : 13),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
