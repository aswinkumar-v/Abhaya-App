import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/abhaya_scaffold.dart';
import '../../core/widgets/nurse_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _studentIdController;
  late String _semester;
  late String _dailyStudy;
  Uint8List? _imageBytes;
  bool _isSaved = false;

  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];

  final List<String> _studyTimes = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
  ];

  @override
  void initState() {
    super.initState();
    final user = UserService.instance;
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _studentIdController = TextEditingController(text: user.studentId);
    _semester = 'Semester ${user.semester}';
    if (!_semesters.contains(_semester)) {
      _semester = 'Semester 1';
    }
    _dailyStudy = user.dailyStudyTime;
    if (!_studyTimes.contains(_dailyStudy)) {
      _dailyStudy = '30 min';
    }
    _imageBytes = user.profileImageBytes;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2DCD7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Change Profile Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    fontFamily: 'Figtree',
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt_outlined, color: AppColors.teal, size: 20),
                  ),
                  title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.photo_library_outlined, color: AppColors.teal, size: 20),
                  ),
                  title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_imageBytes != null)
                  ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDEAE8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_outline, color: Color(0xFFD44538), size: 20),
                    ),
                    title: const Text('Remove Photo', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFD44538))),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() => _imageBytes = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() {
    final semNum = int.tryParse(_semester.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;

    UserService.instance.updateProfile(
      newName: _nameController.text.trim(),
      newEmail: _emailController.text.trim(),
      newStudentId: _studentIdController.text.trim(),
      newSemester: semNum,
      newStudyTime: _dailyStudy,
      newImageBytes: _imageBytes,
    );

    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AbhayaScaffold(
      title: 'Edit profile',
      subtitle: '${UserService.instance.degree} · Sem ${UserService.instance.semester}',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Photo Avatar with Camera Button
              Center(
                child: GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          NurseAvatar(
                            size: 88,
                            imageBytes: _imageBytes,
                            listenToUserService: false,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.deep,
                                border: Border.all(color: Colors.white, width: 2.5),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Change photo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form fields card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Full name'),
                    const SizedBox(height: 6),
                    _customTextField(_nameController, hint: 'e.g. Maya Sharma'),
                    const SizedBox(height: 16),

                    _fieldLabel('Email'),
                    const SizedBox(height: 6),
                    _customTextField(_emailController, keyboardType: TextInputType.emailAddress, hint: 'you@college.edu'),
                    const SizedBox(height: 16),

                    _fieldLabel('Student ID'),
                    const SizedBox(height: 6),
                    _customTextField(_studentIdController, hint: 'e.g. BSN2024-001'),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Semester'),
                              const SizedBox(height: 6),
                              _dropdown(
                                value: _semester,
                                items: _semesters,
                                onChanged: (v) => setState(() => _semester = v!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _fieldLabel('Daily study'),
                              const SizedBox(height: 6),
                              _dropdown(
                                value: _dailyStudy,
                                items: _studyTimes,
                                onChanged: (v) => setState(() => _dailyStudy = v!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaved ? const Color(0xFF2E9979) : AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Text(
                    _isSaved ? 'Profile updated ✓' : 'Save changes',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink3),
    );
  }

  Widget _customTextField(TextEditingController ctrl, {TextInputType keyboardType = TextInputType.text, String hint = ''}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EBE8)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF8E9F9A), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _dropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EBE8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.ink2),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
