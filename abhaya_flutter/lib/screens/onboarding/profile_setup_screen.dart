import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late final TextEditingController _studentIdController;
  late int _selectedSem;
  late String _selectedTime;

  final List<String> _times = ['15 min', '30 min', '45 min', '60 min'];

  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    _studentIdController = TextEditingController(text: UserService.instance.studentId);
    _selectedSem = UserService.instance.semester;
    _selectedTime = UserService.instance.dailyStudyTime;
    _profileImageBytes = UserService.instance.profileImageBytes;
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
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
          _profileImageBytes = bytes;
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
                  'Add Profile Photo',
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
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: Color(0xFF1E6B63),
                    ),
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  subtitle: const Text(
                    'Select a photo from your device data',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7E908B)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
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
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFF1E6B63),
                    ),
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Figtree',
                    ),
                  ),
                  subtitle: const Text(
                    'Use your camera to snap a new photo',
                    style: TextStyle(fontSize: 12, color: Color(0xFF7E908B)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                if (_profileImageBytes != null) ...[
                  ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDE8E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _profileImageBytes = null;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar with Back Button and Centered Step 2 of 3 Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE6ECEA)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 24,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ),

                  // Step Indicator
                  Column(
                    children: [
                      const Text(
                        'Step 2 of 3',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStepBar(isActive: true),
                          const SizedBox(width: 6),
                          _buildStepBar(isActive: true),
                          const SizedBox(width: 6),
                          _buildStepBar(isActive: false),
                        ],
                      ),
                    ],
                  ),

                  // Placeholder for symmetry
                  const SizedBox(width: 44),
                ],
              ),

              const SizedBox(height: 18),

              // Title Headline
              const Text(
                'About you',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: -0.5,
                  fontFamily: 'Figtree',
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'so your plan fits your course',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E908B),
                  letterSpacing: -0.3,
                  fontFamily: 'Figtree',
                ),
              ),

              const SizedBox(height: 20),

              // Card 1: Profile Photo Picker
              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE7EDEB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEAF5F2),
                              border: Border.all(
                                color: const Color(0xFFA9C6BE),
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: ClipOval(
                              child: _profileImageBytes != null
                                  ? Image.memory(
                                      _profileImageBytes!,
                                      width: 64,
                                      height: 64,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 24,
                                        color: Color(0xFF1E6B63),
                                      ),
                                    ),
                            ),
                          ),
                          if (_profileImageBytes != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22645B),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profile photo',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                                fontFamily: 'Figtree',
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _profileImageBytes != null
                                  ? 'Photo added • Tap to change'
                                  : 'Optional. Camera or gallery.',
                              style: TextStyle(
                                fontSize: 13,
                                color: _profileImageBytes != null
                                    ? const Color(0xFF1E6B63)
                                    : const Color(0xFF7E908B),
                                fontWeight: _profileImageBytes != null
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8E9F9A),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Card 2: Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE7EDEB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Student ID
                    const Text(
                      'Student ID',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0xFFE2EAE7), width: 1.5),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextField(
                        controller: _studentIdController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                          fontFamily: 'Figtree',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g. BSN2024-117',
                          hintStyle: TextStyle(
                            color: Color(0xFF8E9F9A),
                            fontSize: 15,
                            fontFamily: 'Figtree',
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Semester
                    const Text(
                      'Semester',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2 rows of 4 semester pills
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: List.generate(8, (index) {
                        final sem = index + 1;
                        final isSelected = sem == _selectedSem;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSem = sem),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF132A26)
                                  : const Color(0xFFEBF0EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Sem $sem',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.ink,
                                fontFamily: 'Figtree',
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Daily study time
                    const Text(
                      'Daily study time',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink2,
                        fontFamily: 'Figtree',
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Study time segments
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF0EE),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: _times.map((t) {
                          final isSelected = t == _selectedTime;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTime = t),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.ink : AppColors.ink2,
                                    fontFamily: 'Figtree',
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Continue Button
              GestureDetector(
                onTap: () {
                  UserService.instance.updateProfileSetup(
                    newStudentId: _studentIdController.text,
                    newSemester: _selectedSem,
                    newStudyTime: _selectedTime,
                    newImageBytes: _profileImageBytes,
                  );
                  Navigator.pushNamed(context, '/interests');
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22645B),
                    borderRadius: BorderRadius.circular(27),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22645B).withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Figtree',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepBar({required bool isActive}) {
    return Container(
      width: 28,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1E6B63) : Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: !isActive ? Border.all(color: const Color(0xFFE2EAE7)) : null,
      ),
    );
  }
}
