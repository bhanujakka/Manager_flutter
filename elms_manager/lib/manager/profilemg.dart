import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elms_manager/manager/theme/manager_theme.dart';

class _ProfileTheme {
  const _ProfileTheme._();

  static bool get isDark => ManagerThemeController.isDark;

  static Color get pageBg =>
      isDark ? const Color(0xFF0F0A1A) : ManagerPalette.pageBg;
  static Color get cardBg =>
      isDark ? const Color(0xFF1A1229) : ManagerPalette.surface;
  static Color get cardBorder =>
      isDark ? const Color(0xFF2D1F4D) : ManagerPalette.border;
  static Color get titleText =>
      isDark ? const Color(0xFFF8FAFC) : ManagerPalette.titleText;
  static Color get mutedText =>
      isDark ? const Color(0xFF94A3B8) : ManagerPalette.mutedText;

  static Color get tabsTrackBg =>
      isDark ? const Color(0xFF2D1F4D) : const Color(0xFFEDEFF4);
  static Color get tabsUnselectedText =>
      isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563);

  static Color get fieldLabelText =>
      isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151);
  static Color get fieldBg => isDark ? const Color(0xFF2D1F4D) : Colors.white;
  static Color get fieldMutedBg =>
      isDark ? const Color(0xFF2D1F4D) : const Color(0xFFF3F4F6);
  static Color get fieldHoverBg =>
      isDark ? const Color(0xFF39285E) : const Color(0xFFF8FAFC);
  static Color get fieldMutedHoverBg =>
      isDark ? const Color(0xFF39285E) : const Color(0xFFECEFF4);
  static Color get fieldIcon => mutedText;
  static Color get fieldValueText =>
      isDark ? const Color(0xFFF8FAFC) : const Color(0xFF4B5563);
  static Color get helperText => mutedText;

  static Color get fieldBorder =>
      isDark ? const Color(0xFF2D1F4D) : const Color(0xFFD7DBE3);
  static Color get fieldHoverBorder =>
      isDark ? const Color(0xFF5B21B6) : const Color(0xFFB8A3F6);
  static Color get fieldHoverShadow =>
      isDark ? const Color(0x335B21B6) : const Color(0x147C3AED);

  static Color get primary =>
      isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);

  static Color get statusActiveBg =>
      isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
  static Color get statusActiveBorder =>
      isDark ? const Color(0xFF0F766E) : const Color(0xFFBBF7D0);
  static Color get statusActiveText =>
      isDark ? const Color(0xFF6EE7B7) : const Color(0xFF15803D);
}

class ProfileMgView extends StatefulWidget {
  const ProfileMgView({super.key});

  @override
  State<ProfileMgView> createState() => _ProfileMgViewState();
}

class _ProfileMgViewState extends State<ProfileMgView> {
  int _activeTab = 0;
  bool _isEditing = false;

  String _fullName = 'Michael Johnson';
  String _phoneNumber = '9876543210';
  String _location = 'New York, USA';
  String _contactName = 'Emma Johnson';
  String _contactNumber = '9876543211';

  String? _fullNameError;
  String? _phoneError;
  String? _contactNameError;
  String? _contactNumberError;

  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactNameController;
  late final TextEditingController _contactNumberController;

  static Color get _pageBg => _ProfileTheme.pageBg;
  static Color get _cardBg => _ProfileTheme.cardBg;
  static Color get _cardBorder => _ProfileTheme.cardBorder;
  static Color get _titleText => _ProfileTheme.titleText;
  static const Color _purpleStart = Color(0xFF7C3AED);
  static const Color _purpleEnd = Color(0xFFA78BFA);
  static final RegExp _nameRegex = RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$');
  static final RegExp _phoneRegex = RegExp(r'^[6-9][0-9]{9}$');

  late final TextInputFormatter _fullNameInputFormatter;
  late final TextInputFormatter _contactNameInputFormatter;
  static const TextInputFormatter _phoneInputFormatter = _PhoneInputFormatter();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: _fullName);
    _phoneController = TextEditingController(text: _phoneNumber);
    _locationController = TextEditingController(text: _location);
    _contactNameController = TextEditingController(text: _contactName);
    _contactNumberController = TextEditingController(text: _contactNumber);
    _fullNameInputFormatter = _NameInputFormatter(
      onInvalidInput: _onInvalidFullNameInput,
    );
    _contactNameInputFormatter = _NameInputFormatter(
      onInvalidInput: _onInvalidContactNameInput,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _contactNameController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  void _startEditing() {
    _fullNameController.text = _fullName;
    _phoneController.text = _phoneNumber;
    _locationController.text = _location;
    _contactNameController.text = _contactName;
    _contactNumberController.text = _contactNumber;
    setState(() {
      _isEditing = true;
      _clearValidationErrors();
    });
  }

  void _saveEditing() {
    if (!_validateEditingInputs()) {
      return;
    }

    setState(() {
      _fullName = _fullNameController.text.trim().isEmpty
          ? _fullName
          : _fullNameController.text.trim();
      _phoneNumber = _phoneController.text.trim().isEmpty
          ? _phoneNumber
          : _phoneController.text.trim();
      _location = _locationController.text.trim().isEmpty
          ? _location
          : _locationController.text.trim();
      _contactName = _contactNameController.text.trim().isEmpty
          ? _contactName
          : _contactNameController.text.trim();
      _contactNumber = _contactNumberController.text.trim().isEmpty
          ? _contactNumber
          : _contactNumberController.text.trim();
      _isEditing = false;
    });
  }

  bool _validateEditingInputs() {
    final String fullName = _fullNameController.text.trim();
    final String phoneNumber = _phoneController.text.trim();
    final String contactName = _contactNameController.text.trim();
    final String contactNumber = _contactNumberController.text.trim();

    final String? fullNameError = _nameErrorText(fullName);
    final String? phoneError = _phoneErrorText(phoneNumber);
    final String? contactNameError = _nameErrorText(contactName);
    final String? contactNumberError = _phoneErrorText(contactNumber);

    setState(() {
      _fullNameError = fullNameError;
      _phoneError = phoneError;
      _contactNameError = contactNameError;
      _contactNumberError = contactNumberError;
    });

    return fullNameError == null &&
        phoneError == null &&
        contactNameError == null &&
        contactNumberError == null;
  }

  String? _nameErrorText(String value) {
    const String message = '*Enter Valid Full Name Ex: John Ruthord';
    if (value.isEmpty) {
      return null;
    }
    if (!_nameRegex.hasMatch(value)) {
      return message;
    }
    return null;
  }

  String? _phoneErrorText(String value) {
    const String message = 'Enter valid Phonenumber Ex: 939820906';
    if (value.isEmpty) {
      return null;
    }
    if (!_phoneRegex.hasMatch(value)) {
      return message;
    }
    return null;
  }

  void _clearValidationErrors() {
    _fullNameError = null;
    _phoneError = null;
    _contactNameError = null;
    _contactNumberError = null;
  }

  void _onFullNameChanged(String value) {
    setState(() {
      _fullNameError = _nameErrorText(value.trim());
    });
  }

  void _onInvalidFullNameInput() {
    const String message = '*Enter Valid Full Name Ex: John Ruthord';
    if (_fullNameError == message) {
      return;
    }
    setState(() {
      _fullNameError = message;
    });
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phoneError = _phoneErrorText(value.trim());
    });
  }

  void _onContactNameChanged(String value) {
    setState(() {
      _contactNameError = _nameErrorText(value.trim());
    });
  }

  void _onInvalidContactNameInput() {
    const String message = '*Enter Valid Full Name Ex: John Ruthord';
    if (_contactNameError == message) {
      return;
    }
    setState(() {
      _contactNameError = message;
    });
  }

  void _onContactNumberChanged(String value) {
    setState(() {
      _contactNumberError = _phoneErrorText(value.trim());
    });
  }

  void _cancelEditing() {
    _fullNameController.text = _fullName;
    _phoneController.text = _phoneNumber;
    _locationController.text = _location;
    _contactNameController.text = _contactName;
    _contactNumberController.text = _contactNumber;
    setState(() {
      _isEditing = false;
      _clearValidationErrors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _pageBg,
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 700;
            final double sidePadding = constraints.maxWidth >= 1080 ? 24 : 16;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sidePadding, 16, sidePadding, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _buildHeroCard(compact),
                      const SizedBox(height: 16),
                      _buildTabs(compact),
                      const SizedBox(height: 16),
                      _buildActiveContent(compact),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroCard(bool compact) {
    return Container(
      padding: EdgeInsets.all(compact ? 16 : 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[_purpleStart, _purpleEnd],
        ),
      ),
      child: Wrap(
        runSpacing: 14,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: compact ? 64 : 84,
                height: compact ? 64 : 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x33FFFFFF),
                ),
                alignment: Alignment.center,
                child: Text(
                  'MJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 24 : 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: compact ? 12 : 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Michael Johnson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 20 : 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Engineering Manager',
                    style: TextStyle(
                      color: Color(0xFFEDE9FE),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const <Widget>[
                      _HeroBadge(label: 'MGR001'),
                      _HeroBadge(
                        label: 'Team of 8',
                        icon: Icons.groups_2_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _ProfileHeaderActions(
            compact: compact,
            isEditing: _isEditing,
            onEditTap: _startEditing,
            onSaveTap: _saveEditing,
            onCancelTap: _cancelEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(bool compact) {
    final List<String> tabs = <String>[
      compact ? 'Personal' : 'Personal Info',
      compact ? 'Work' : 'Employment',
      compact ? 'Emergency' : 'Emergency Contact',
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _ProfileTheme.tabsTrackBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List<Widget>.generate(tabs.length, (int index) {
          final bool selected = index == _activeTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? _cardBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: selected ? Border.all(color: _cardBorder) : null,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? _ProfileTheme.titleText
                        : _ProfileTheme.tabsUnselectedText,
                    fontSize: compact ? 12 : 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActiveContent(bool compact) {
    switch (_activeTab) {
      case 0:
        return _buildInfoCard(
          title: 'Personal Information',
          child: _PersonalInfoCardContent(
            isEditing: _isEditing,
            fullNameController: _fullNameController,
            phoneController: _phoneController,
            locationController: _locationController,
            nameInputFormatter: _fullNameInputFormatter,
            phoneInputFormatter: _phoneInputFormatter,
            fullNameError: _fullNameError,
            phoneError: _phoneError,
            onFullNameChanged: _onFullNameChanged,
            onPhoneChanged: _onPhoneChanged,
          ),
        );
      case 1:
        return _buildInfoCard(
          title: 'Employment Details',
          child: const _EmploymentInfoCardContent(),
        );
      case 2:
        return _buildInfoCard(
          title: 'Emergency Contact',
          child: _EmergencyInfoCardContent(
            isEditing: _isEditing,
            contactNameController: _contactNameController,
            contactNumberController: _contactNumberController,
            nameInputFormatter: _contactNameInputFormatter,
            phoneInputFormatter: _phoneInputFormatter,
            contactNameError: _contactNameError,
            contactNumberError: _contactNumberError,
            onContactNameChanged: _onContactNameChanged,
            onContactNumberChanged: _onContactNumberChanged,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: _titleText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _PersonalInfoCardContent extends StatelessWidget {
  const _PersonalInfoCardContent({
    required this.isEditing,
    required this.fullNameController,
    required this.phoneController,
    required this.locationController,
    required this.nameInputFormatter,
    required this.phoneInputFormatter,
    this.fullNameError,
    this.phoneError,
    this.onFullNameChanged,
    this.onPhoneChanged,
  });

  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController locationController;
  final TextInputFormatter nameInputFormatter;
  final TextInputFormatter phoneInputFormatter;
  final String? fullNameError;
  final String? phoneError;
  final ValueChanged<String>? onFullNameChanged;
  final ValueChanged<String>? onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    final bool twoColumns = MediaQuery.sizeOf(context).width >= 820;

    if (!twoColumns) {
      return Column(
        children: <Widget>[
          _PersonalFieldCard(
            label: 'Full Name',
            value: fullNameController.text,
            icon: Icons.person_outline,
            editable: true,
            isEditing: isEditing,
            controller: fullNameController,
            keyboardType: TextInputType.name,
            inputFormatters: <TextInputFormatter>[nameInputFormatter],
            errorText: fullNameError,
            onChanged: onFullNameChanged,
          ),
          const SizedBox(height: 16),
          _PersonalFieldCard(
            label: 'Email Address',
            value: 'michael.johnson@worksphere.com',
            icon: Icons.mail_outline,
            helper: 'Email cannot be changed',
            muted: true,
          ),
          const SizedBox(height: 16),
          _PersonalFieldCard(
            label: 'Phone Number',
            value: phoneController.text,
            icon: Icons.phone_outlined,
            editable: true,
            isEditing: isEditing,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[phoneInputFormatter],
            errorText: phoneError,
            onChanged: onPhoneChanged,
            hintText: 'Enter 10 digits only',
          ),
          const SizedBox(height: 16),
          _PersonalFieldCard(
            label: 'Location',
            value: locationController.text,
            icon: Icons.location_on_outlined,
            editable: true,
            isEditing: isEditing,
            controller: locationController,
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _PersonalFieldCard(
                label: 'Full Name',
                value: fullNameController.text,
                icon: Icons.person_outline,
                editable: true,
                isEditing: isEditing,
                controller: fullNameController,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[nameInputFormatter],
                errorText: fullNameError,
                onChanged: onFullNameChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PersonalFieldCard(
                label: 'Email Address',
                value: 'michael.johnson@worksphere.com',
                icon: Icons.mail_outline,
                helper: 'Email cannot be changed',
                muted: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _PersonalFieldCard(
                label: 'Phone Number',
                value: phoneController.text,
                icon: Icons.phone_outlined,
                editable: true,
                isEditing: isEditing,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[phoneInputFormatter],
                errorText: phoneError,
                onChanged: onPhoneChanged,
                hintText: 'Enter 10 digits only',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PersonalFieldCard(
                label: 'Location',
                value: locationController.text,
                icon: Icons.location_on_outlined,
                editable: true,
                isEditing: isEditing,
                controller: locationController,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmergencyInfoCardContent extends StatelessWidget {
  const _EmergencyInfoCardContent({
    required this.isEditing,
    required this.contactNameController,
    required this.contactNumberController,
    required this.nameInputFormatter,
    required this.phoneInputFormatter,
    this.contactNameError,
    this.contactNumberError,
    this.onContactNameChanged,
    this.onContactNumberChanged,
  });

  final bool isEditing;
  final TextEditingController contactNameController;
  final TextEditingController contactNumberController;
  final TextInputFormatter nameInputFormatter;
  final TextInputFormatter phoneInputFormatter;
  final String? contactNameError;
  final String? contactNumberError;
  final ValueChanged<String>? onContactNameChanged;
  final ValueChanged<String>? onContactNumberChanged;

  @override
  Widget build(BuildContext context) {
    final bool twoColumns = MediaQuery.sizeOf(context).width >= 820;

    if (!twoColumns) {
      return Column(
        children: <Widget>[
          _PersonalFieldCard(
            label: 'Contact Name',
            value: contactNameController.text,
            icon: Icons.person_2_outlined,
            editable: true,
            isEditing: isEditing,
            controller: contactNameController,
            keyboardType: TextInputType.name,
            inputFormatters: <TextInputFormatter>[nameInputFormatter],
            errorText: contactNameError,
            onChanged: onContactNameChanged,
          ),
          const SizedBox(height: 16),
          _PersonalFieldCard(
            label: 'Contact Number',
            value: contactNumberController.text,
            icon: Icons.call_outlined,
            editable: true,
            isEditing: isEditing,
            controller: contactNumberController,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[phoneInputFormatter],
            errorText: contactNumberError,
            onChanged: onContactNumberChanged,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _PersonalFieldCard(
            label: 'Contact Name',
            value: contactNameController.text,
            icon: Icons.person_2_outlined,
            editable: true,
            isEditing: isEditing,
            controller: contactNameController,
            keyboardType: TextInputType.name,
            inputFormatters: <TextInputFormatter>[nameInputFormatter],
            errorText: contactNameError,
            onChanged: onContactNameChanged,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _PersonalFieldCard(
            label: 'Contact Number',
            value: contactNumberController.text,
            icon: Icons.call_outlined,
            editable: true,
            isEditing: isEditing,
            controller: contactNumberController,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[phoneInputFormatter],
            errorText: contactNumberError,
            onChanged: onContactNumberChanged,
          ),
        ),
      ],
    );
  }
}

class _PersonalFieldCard extends StatelessWidget {
  const _PersonalFieldCard({
    required this.label,
    required this.value,
    required this.icon,
    this.helper,
    this.muted = false,
    this.editable = false,
    this.isEditing = false,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.onChanged,
    this.hintText,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? helper;
  final bool muted;
  final bool editable;
  final bool isEditing;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: _ProfileTheme.fieldLabelText,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _FieldHoverContainer(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: muted ? _ProfileTheme.fieldMutedBg : _ProfileTheme.fieldBg,
          hoverColor: muted
              ? _ProfileTheme.fieldMutedHoverBg
              : _ProfileTheme.fieldHoverBg,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 18, color: _ProfileTheme.fieldIcon),
              const SizedBox(width: 8),
              Expanded(
                child: editable && isEditing && controller != null
                    ? TextField(
                        controller: controller,
                        maxLines: 1,
                        keyboardType: keyboardType,
                        inputFormatters: inputFormatters,
                        onChanged: onChanged,
                        style: TextStyle(
                          color: _ProfileTheme.fieldValueText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: hintText,
                          hintStyle: TextStyle(
                            color: _ProfileTheme.helperText,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ProfileTheme.fieldValueText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (helper != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            helper!,
            style: TextStyle(
              color: _ProfileTheme.helperText,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _EmploymentInfoCardContent extends StatelessWidget {
  const _EmploymentInfoCardContent();

  @override
  Widget build(BuildContext context) {
    final bool twoColumns = MediaQuery.sizeOf(context).width >= 820;

    if (!twoColumns) {
      return const Column(
        children: <Widget>[
          _EmploymentInputField(label: 'Employee ID', value: 'MGR001'),
          SizedBox(height: 12),
          _EmploymentInputField(
            label: 'Department',
            value: 'Engineering',
            icon: Icons.work_outline,
          ),
          SizedBox(height: 12),
          _EmploymentInputField(
            label: 'Designation',
            value: 'Engineering Manager',
          ),
          SizedBox(height: 12),
          _EmploymentInputField(
            label: 'Join Date',
            value: '10/03/2022',
            icon: Icons.calendar_month_outlined,
          ),
          SizedBox(height: 12),
          _EmploymentInputField(
            label: 'Team Size',
            value: '8 members',
            icon: Icons.groups_outlined,
          ),
          SizedBox(height: 12),
          _EmploymentStatusField(label: 'Employment Status', value: 'Active'),
        ],
      );
    }

    return const Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _EmploymentInputField(
                label: 'Employee ID',
                value: 'MGR001',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmploymentInputField(
                label: 'Department',
                value: 'Engineering',
                icon: Icons.work_outline,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _EmploymentInputField(
                label: 'Designation',
                value: 'Engineering Manager',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmploymentInputField(
                label: 'Join Date',
                value: '10/03/2022',
                icon: Icons.calendar_month_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _EmploymentInputField(
                label: 'Team Size',
                value: '8 members',
                icon: Icons.groups_outlined,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmploymentStatusField(
                label: 'Employment Status',
                value: 'Active',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmploymentInputField extends StatelessWidget {
  const _EmploymentInputField({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: _ProfileTheme.fieldLabelText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _FieldHoverContainer(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: _ProfileTheme.fieldMutedBg,
          hoverColor: _ProfileTheme.fieldMutedHoverBg,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 18, color: _ProfileTheme.fieldIcon),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _ProfileTheme.fieldValueText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmploymentStatusField extends StatelessWidget {
  const _EmploymentStatusField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: _ProfileTheme.fieldLabelText,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _ProfileTheme.statusActiveBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _ProfileTheme.statusActiveBorder),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: _ProfileTheme.statusActiveText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldHoverContainer extends StatefulWidget {
  const _FieldHoverContainer({
    required this.child,
    required this.padding,
    required this.color,
    required this.hoverColor,
    required this.borderRadius,
    this.height,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color hoverColor;
  final BorderRadius borderRadius;
  final double? height;

  @override
  State<_FieldHoverContainer> createState() => _FieldHoverContainerState();
}

class _FieldHoverContainerState extends State<_FieldHoverContainer> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOutCubic,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: _hovered ? widget.hoverColor : widget.color,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: _hovered
                ? _ProfileTheme.fieldHoverBorder
                : _ProfileTheme.fieldBorder,
          ),
          boxShadow: _hovered
              ? <BoxShadow>[
                  BoxShadow(
                    color: _ProfileTheme.fieldHoverShadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: widget.child,
      ),
    );
  }
}

class _ProfileHeaderActions extends StatelessWidget {
  const _ProfileHeaderActions({
    required this.compact,
    required this.isEditing,
    required this.onEditTap,
    required this.onSaveTap,
    required this.onCancelTap,
  });

  final bool compact;
  final bool isEditing;
  final VoidCallback onEditTap;
  final VoidCallback onSaveTap;
  final VoidCallback onCancelTap;

  @override
  Widget build(BuildContext context) {
    if (!isEditing) {
      return _GhostPrimaryButton(
        icon: Icons.edit_square,
        label: compact ? 'Edit' : 'Edit Profile',
        onTap: onEditTap,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _GhostPrimaryButton(
          icon: Icons.check_rounded,
          label: 'Save',
          onTap: onSaveTap,
        ),
        const SizedBox(width: 8),
        _HeaderIconButton(icon: Icons.close_rounded, onTap: onCancelTap),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 18, color: _ProfileTheme.primary),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: const Color(0x33FFFFFF),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GhostPrimaryButton extends StatelessWidget {
  const _GhostPrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: _ProfileTheme.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: _ProfileTheme.primary,
                  fontSize: 13,
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

class _NameInputFormatter extends TextInputFormatter {
  const _NameInputFormatter({required this.onInvalidInput});

  final VoidCallback onInvalidInput;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    if (!RegExp(r'^[A-Za-z ]*$').hasMatch(text)) {
      onInvalidInput();
      return oldValue;
    }

    return newValue;
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  const _PhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    if (text.length == 1 && !RegExp(r'^[6-9]$').hasMatch(text)) {
      return oldValue;
    }

    if (text.length > 1 && !RegExp(r'^[6-9][0-9]*$').hasMatch(text)) {
      return oldValue;
    }

    if (text.length > 10) {
      return oldValue;
    }

    return newValue;
  }
}
