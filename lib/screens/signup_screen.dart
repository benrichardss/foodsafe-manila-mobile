import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cityCtrl = TextEditingController(text: "Manila");
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  String? _barangay;
  String? _district;

  bool _pushNotif = true;
  bool _locationService = true;
  bool _showPass = false;
  bool _showConfirmPass = false;

  final barangays = [
    "Barangay 1 - Tondo",
    "Barangay 123 - Tondo",
    "Barangay 234 - Binondo",
    "Barangay 456 - Sampaloc",
    "Barangay 567 - Sta. Cruz",
    "Barangay 789 - Quiapo",
    "Barangay 890 - Ermita",
  ];

  final districts = [
    "District 1",
    "District 2",
    "District 3",
    "District 4",
    "District 5",
    "District 6",
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created (demo)")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white70),
                          label: Text(
                            "Back",
                            style: GoogleFonts.inter(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 24,
                                offset: Offset(0, 12),
                                color: Color(0x33000000),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.monitor_heart_outlined,
                            size: 44,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        "Create Account",
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Register to receive health alerts in your area",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFFBFDBFE),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),

                /// WHITE SHEET
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle(
                          "Personal Information",
                          "Tell us a bit about yourself",
                        ),

                        _LabeledField(
                          label: "Full Name *",
                          child: TextFormField(
                            controller: _nameCtrl,
                            validator: _required,
                            decoration: const InputDecoration(
                              hintText: "Juan Dela Cruz",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Phone Number *",
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              final value = (v ?? "").trim();
                              if (value.isEmpty) return "Phone number is required.";
                              if (value.length < 8) return "Enter a valid phone number.";
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "+63 912 345 6789",
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                        ),

                        _helper("We'll send SMS alerts to this number"),

                        _divider(),

                        _sectionTitle(
                          "Account Security",
                          "Set a password for your account",
                        ),

                        _LabeledField(
                          label: "Password *",
                          child: TextFormField(
                            controller: _passCtrl,
                            obscureText: !_showPass,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password is required";
                              }
                              if (v.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              prefixIcon:
                                  const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _showPass = !_showPass),
                                icon: Icon(_showPass
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),

                        _helper('Must be at least 6 characters'),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Confirm Password *",
                          child: TextFormField(
                            controller: _confirmPassCtrl,
                            obscureText: !_showConfirmPass,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Please confirm your password";
                              }
                              if (v != _passCtrl.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              prefixIcon:
                                  const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                    () => _showConfirmPass =
                                        !_showConfirmPass),
                                icon: Icon(_showConfirmPass
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),

                        _divider(),

                        _sectionTitle(
                          "Location Information",
                          "Help us send you relevant alerts for your area",
                        ),

                        _LabeledField(
                          label: "Barangay *",
                          child: DropdownButtonFormField<String>(
                            initialValue: _barangay,
                            hint: const Text("Select your barangay"),
                            items: barangays
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            validator: _required,
                            onChanged: (v) =>
                                setState(() => _barangay = v),
                            decoration: const InputDecoration(
                              prefixIcon:
                                  Icon(Icons.location_on_outlined),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "District *",
                          child: DropdownButtonFormField<String>(
                            initialValue: _district,
                            hint: const Text("Select your district"),
                            items: districts
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            validator: _required,
                            onChanged: (v) =>
                                setState(() => _district = v),
                            decoration: const InputDecoration(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "City / Municipality",
                          child: TextFormField(
                            controller: _cityCtrl,
                            decoration: const InputDecoration(),
                          ),
                        ),

                        _divider(),

                        _sectionTitle(
                          "Notification Preferences",
                          "Choose how you want to receive alerts",
                        ),

                        _toggleTile(
                          title: "Push Notifications",
                          subtitle:
                              "Receive instant disease outbreak alerts",
                          value: _pushNotif,
                          onChanged: (v) =>
                              setState(() => _pushNotif = v),
                        ),
                        _toggleTile(
                          title: "Location Services",
                          subtitle:
                              "For location-based health alerts",
                          value: _locationService,
                          onChanged: (v) =>
                              setState(() => _locationService = v),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          "By creating an account, you agree to our Terms of Service and Privacy Policy. "
                          "Your data is protected under the Data Privacy Act of 2012.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: const Color(0xFF4B5563),
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              "Create Account",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? "Required field" : null;

  Widget _sectionTitle(String title, String subtitle) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF4B5563))),
          ],
        ),
      );

  Widget _helper(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          text,
          style: GoogleFonts.inter(
              fontSize: 11, color: const Color(0xFF6B7280)),
        ),
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Divider(height: 1, color: Color(0xFFE5E7EB)),
      );

  Widget _toggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF6B7280))),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
              activeTrackColor: Color(0xFF2563EB),
              inactiveTrackColor: Color(0xFFE5E7EB),
              trackOutlineColor: const WidgetStatePropertyAll<Color>(
                Colors.white,
              ),
            ),
          ],
        ),
      );
}

/// SHARED INPUT STYLE (SAME AS LOGIN)
class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                    color: Color(0xFF3B82F6), width: 2),
              ),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
