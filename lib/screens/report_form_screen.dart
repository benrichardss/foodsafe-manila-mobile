import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodsafe_manila/screens/report_history_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
import '../widgets/snackbar_widgets.dart';
import '../database/db.dart';
import '../services/location_service.dart';
import '../services/session.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  int _currentStep = 0;

  Future<void> _nextStep() async {
    if (_currentStep == 0) {
      setState(() => _currentStep = 1);
      return;
    }
    if (_currentStep == 1) {
      setState(() => _currentStep = 2);
      return;
    }
    if (_currentStep == 2) {
      final success = await _submit();

      if (!success) return;

      setState(() => _currentStep = 3);
      return;
    }
  }

  Future<bool> _submit() async {
    try {
      // Check if user is logged in
      if (Session.currentUser == null) {
        if (context.mounted) {
          SnackbarWidgets.error(context, "Please log in first");
        }
        return false;
      }

      // Get the current user's ID
      final userId = Session.currentUser!['_id'] as ObjectId?;
      if (userId == null) {
        if (context.mounted) {
          SnackbarWidgets.error(context, "User ID not found");
        }
        return false;
      }

      final allowed = await _checkCooldown(userId);
      if (!allowed) return false;

      // Convert symptoms set to comma-separated string
      final reportedSymptoms = selectedSymptoms.join(', ');

      // Call the database submitReport method
      final success = await Database.submitReport(
        reportId:
            'RPT-${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}',
        reportedBy: userId,
        reportLocation: locationText.split(',').first.trim(),
        symptoms: reportedSymptoms,
        foodSource: selectedFoodSource ?? 'Not specified',
        foodLocation: selectedAteFoodLocation == 'Same as my current location'
            ? locationText.split(',').first.trim()
            : selectedAteFoodLocation == 'Choose a different district'
            ? selectedDistrict ?? locationText.split(',').first.trim()
            : selectedAteFoodLocation == 'Not sure'
            ? 'Not sure'
            : locationText.split(',').first.trim(),
      );

      if (success) {
        if (mounted) {
          SnackbarWidgets.success(context, "Report submitted successfully!");
        }

        setState(() {
          _remainingCooldown = reportCooldown;
          isCooldown = true;
          _updateTimeText();
        });

        _startTimer();

        return true;
      } else {
        if (mounted) {
          SnackbarWidgets.error(context, "Failed to submit report");
        }
        return false;
      }
    } catch (e) {
      if (mounted) {
        SnackbarWidgets.error(context, "Error: $e");
      }
      return false;
    }
  }

  static const Duration reportCooldown = Duration(hours: 8);

  Duration? _remainingCooldown;
  Timer? _cooldownTimer;

  bool isCooldown = false;
  String timeLeft = "";

  Future<bool> _checkCooldown(ObjectId userId) async {
    final lastReportTime = await Database.getLastReportTime(userId);

    if (lastReportTime == null) return true;

    final difference = DateTime.now().difference(lastReportTime);

    if (difference >= reportCooldown) return true;

    final remaining = reportCooldown - difference;

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    if (mounted) {
      SnackbarWidgets.error(
        context,
        "You can submit again in $hours h $minutes m $seconds s",
      );
    }

    return false;
  }

  Future<void> _initCooldown() async {
    if (Session.currentUser == null) return;

    final userId = Session.currentUser!['_id'] as ObjectId?;
    if (userId == null) return;

    final lastReportTime = await Database.getLastReportTime(userId);

    if (lastReportTime == null) return;

    final diff = DateTime.now().difference(lastReportTime);

    if (diff < reportCooldown) {
      setState(() {
        _remainingCooldown = reportCooldown - diff;
        isCooldown = true;
        _updateTimeText();
      });

      _startTimer();
    }
  }

  void _updateTimeText() {
    if (_remainingCooldown == null) return;

    final h = _remainingCooldown!.inHours;
    final m = _remainingCooldown!.inMinutes % 60;
    final s = _remainingCooldown!.inSeconds % 60;

    timeLeft = "${h}h ${m}m ${s}s";
  }

  void _startTimer() {
    _cooldownTimer?.cancel();

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingCooldown == null) return;

      if (_remainingCooldown!.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          isCooldown = false;
          _remainingCooldown = null;
          timeLeft = "";
        });
      } else {
        setState(() {
          _remainingCooldown =
              Duration(seconds: _remainingCooldown!.inSeconds - 1);

          _updateTimeText();
        });
      }
    });
  }

  final List<String> symptoms = [
    'Nausea',
    'Vomiting',
    'Diarrhea',
    'Abdominal cramps',
    'Fever',
    'Headache',
    'Dehydration',
  ];

  final List<String> foodSources = [
    'Restaurant',
    'Street food vendor',
    'Home-cooked meal',
    'Food delivery',
    'Cafeteria',
    'Other',
  ];

  final List<String> ateFoodLocations = [
    'Same as my current location',
    'Choose a different district',
    'Not sure',
  ];

  final Set<String> selectedSymptoms = {};
  String? selectedAteFoodLocation;
  int affectedPeople = 1;
  String? selectedFoodSource;
  String? selectedDistrict;

  late String locationText;

  @override
  void initState() {
    super.initState();
    _loadHeader();
    locationText = LocationService.cachedAddress ?? "Fetching...";

    // Optionally, refresh in background
    LocationService.getUserAddress(forceRefresh: true).then((updated) {
      if (mounted) {
        setState(() {
          locationText = updated;
        });
      }
    });
    _initCooldown();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadHeader() async {
    LocationService.getUserAddress().then((address) {
      setState(() {
        locationText = address;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_currentStep > 0 && _currentStep < 3) {
                            setState(() => _currentStep--);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Report Symptoms',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _stepProgressBar(),
                ],
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    _currentStep != 3
                        ? Column(
                            children: [
                              isCooldown
                                  ? Container(
                                      padding: const EdgeInsets.all(12), // p-3
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFBEB), // bg-amber-50
                                        border: Border.all(color: const Color(0xFFFCD34D)), // border-amber-300
                                        borderRadius: BorderRadius.circular(12), // rounded-xl
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Icon container
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF59E0B), // bg-amber-500
                                              borderRadius: BorderRadius.circular(8), // rounded-lg
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                LucideIcons.clock,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12), // gap-3

                                          // Text content
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12, // text-xs
                                                      color: Color(0xFF78350F), // text-amber-900
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: "Cooldown Active: ",
                                                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                      ),
                                                      TextSpan(
                                                        text: "Next report available in",
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 2), // mb-0.5

                                                Text(
                                                  timeLeft, // e.g. "44s"
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14, // text-sm
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFB45309), // text-amber-700
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(12), // p-3
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF), // bg-blue-50
                                        border: Border.all(
                                          color: const Color(0xFFBFDBFE),
                                        ), // border-blue-200
                                        borderRadius: BorderRadius.circular(12), // rounded-xl
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Icon container
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2563EB), // bg-blue-600
                                              borderRadius: BorderRadius.circular(8), // rounded-lg
                                            ),
                                            child: const Center(
                                              child: Icon(LucideIcons.info, size: 16, color: Colors.white),
                                            ),
                                          ),

                                          const SizedBox(width: 12), // gap-3
                                          // Text
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                style: GoogleFonts.inter(
                                                  fontSize: 12, // text-xs
                                                  color: Color(0xFF1E40AF), // text-blue-800
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "Note: ",
                                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "You can submit a report every 8 hours to prevent spam.",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                              const SizedBox(height: 20),
                            ],
                          )
                        : SizedBox.shrink(),

                    buildStepContent()
                  ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepProgressBar() {
    int totalSteps = 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps, (index) {
        bool isActive = index <= _currentStep;
        bool isCurrent = index == _currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            decoration: BoxDecoration(
              color: isCurrent
                  ? const Color(0xFF2563EB)
                  : isActive
                  ? const Color(0xFF93C5FD)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _firstStep();
      case 1:
        return _secondStep();
      case 2:
        return _thirdStep();
      case 3:
        return _fourthStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _firstStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What symptoms are you experiencing?',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Select all that apply',
          style: GoogleFonts.inter(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),

        // Symptoms List
        ...symptoms.map((symptom) {
          final isSelected = selectedSymptoms.contains(symptom);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedSymptoms.remove(symptom);
                  } else {
                    selectedSymptoms.add(symptom);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        symptom,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // Food Source Dropdown
        Text(
          'Suspected food source (optional)',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(16),
          decoration: InputDecoration(
            hintText: 'Select source...',
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
          items: foodSources.map((source) {
            return DropdownMenuItem(
              value: source,
              child: Text(source, style: GoogleFonts.inter(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedFoodSource = value;
            });
          },
        ),

        const SizedBox(height: 32),

        // Next Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: selectedSymptoms.isEmpty
                ? null
                : () {
                    _nextStep();
                  },
            iconAlignment: IconAlignment.end,
            icon: const Icon(LucideIcons.arrowRight),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              disabledBackgroundColor: const Color(0xFF87ABFB),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _secondStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where did the food come from?',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'This will help us identify potential sources of contamination',
          style: GoogleFonts.inter(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            border: Border.all(color: Colors.blue[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.mapPin, color: Colors.white, size: 20),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You are currently in',
                    style: GoogleFonts.inter(
                      color: Colors.blue[700],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    locationText,
                    style: GoogleFonts.inter(
                      color: Colors.blue[900],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Where do you think you ate/bought the food?',
          style: GoogleFonts.inter(fontSize: 14, color: Color(0xFF6B7280)),
        ),
        SizedBox(height: 12),
        // Symptoms List
        ...ateFoodLocations.map((ateFoodLocation) {
          final isSelected = selectedAteFoodLocation == ateFoodLocation;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                setState(() {
                  selectedAteFoodLocation = ateFoodLocation;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        ateFoodLocation,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                        ),
                        color: isSelected
                            ? const Color(0xFF2563EB)
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        if (selectedAteFoodLocation == 'Choose a different district') ...[
          const SizedBox(height: 10),
          Text(
            'Select district where you ate the food',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
            decoration: InputDecoration(
              hintText: 'Choose district...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 2,
                ),
              ),
            ),
            initialValue: selectedDistrict,
            items:
                [
                  'Tondo',
                  'Binondo',
                  'Sampaloc',
                  'Santa Cruz',
                  'San Miguel',
                  'Quiapo',
                ].map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(
                      district,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDistrict = value;
              });
            },
          ),
          const SizedBox(height: 8),
        ],

        const SizedBox(height: 16),

        // Next Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                (selectedAteFoodLocation == null ||
                    (selectedAteFoodLocation == 'Choose a different district' &&
                        selectedDistrict == null))
                ? null
                : () {
                    _nextStep();
                  },
            iconAlignment: IconAlignment.end,
            icon: const Icon(LucideIcons.arrowRight),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              disabledBackgroundColor: const Color(0xFF87ABFB),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _thirdStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          "Review Your Report",
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          "Please confirm the details before submitting",
          style: GoogleFonts.inter(fontSize: 14, color: Color(0xFF6B7280)),
        ),

        const SizedBox(height: 20),

        // Card
        Container(
          padding: const EdgeInsets.all(2), // border thickness
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Gradient Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          LucideIcons.info,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report Summary",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Symptoms
                      Text(
                        "SYMPTOMS",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedSymptoms.map((symptom) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Text(
                              symptom,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 16),

                      // Location
                      Text(
                        "SUSPECTED FOOD SOURCE",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            LucideIcons.utensilsCrossed,
                            size: 16,
                            color: Colors.teal.shade600,
                          ),
                          SizedBox(width: 6),
                          Text(
                            selectedFoodSource ?? "Not specified",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 16),

                      // Location
                      Text(
                        "YOUR CURRENT LOCATION",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Colors.blue.shade600,
                          ),
                          SizedBox(width: 6),
                          Text(
                            locationText.split(',').first.trim(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 16),

                      // Location
                      Text(
                        "EXPOSURE LOCATION",
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            LucideIcons.map,
                            size: 16,
                            color: Colors.orange.shade600,
                          ),
                          SizedBox(width: 6),
                          Text(
                            selectedAteFoodLocation ==
                                    'Same as my current location'
                                ? locationText.split(',').first.trim()
                                : selectedAteFoodLocation ==
                                      'Choose a different district'
                                ? selectedDistrict ??
                                      locationText.split(',').first.trim()
                                : selectedAteFoodLocation == 'Not sure'
                                ? 'Not sure'
                                : locationText.split(',').first.trim(),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Warning Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.alertTriangle,
                size: 18,
                color: Color(0xFFD97706),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "By submitting this report, you confirm that the information provided is accurate to the best of your knowledge.",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Color(0xFF78350F),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Buttons
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Submit report?",
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                      content: Text(
                        "Are you sure you want to submit the report?",
                        style: GoogleFonts.inter(),
                      ),
                      actions: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF2563EB),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2563EB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Submit",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                  if (!context.mounted) return;

                  if (confirm == true) {
                    _nextStep();
                  }
                },
                iconAlignment: IconAlignment.start,
                icon: const Icon(Icons.send),
                label: const Text('Confirm & Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  disabledBackgroundColor: const Color(0xFF87ABFB),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: selectedSymptoms.isEmpty
                    ? null
                    : () {
                        setState(() {
                          _currentStep = 0;
                        });
                      },
                label: const Text('Edit report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  disabledBackgroundColor: const Color(0xFF87ABFB),
                  foregroundColor: Colors.black87,
                  disabledForegroundColor: Colors.white70,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fourthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 72),
        // Checkmark icon
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.green[100],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              LucideIcons.checkCircle,
              color: Colors.green[600],
              size: 48,
            ),
          ),
        ),

        // Report submitted message
        Column(
          children: [
            Text(
              'Report Submitted',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Thank you for helping the city monitor food-related illness signals.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),

        SizedBox(height: 48),

        // Done button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ReportHistoryScreen()),
              );
            },
            label: const Text('View reports'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),

        // Done button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: const Text('Done'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF2563EB),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: Color(0xFF2563EB)),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
