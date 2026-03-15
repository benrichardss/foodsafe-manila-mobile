import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../database/db.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9\s])[^\s]{8,}$',
  );
  String? _selectedSex;

  bool _showPass = false;
  bool _showConfirmPass = false;
  bool _loading = false;

  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      String phone = _phoneCtrl.text.replaceAll(" ", "");

      bool success = await Database.registerUser(
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        sex: _selectedSex!,
        phone: phone,
        password: _passCtrl.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );

        Navigator.pop(context); // return to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone number already registered")),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white70,
                          ),
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                          label: "First Name *",
                          child: TextFormField(
                            controller: _firstNameCtrl,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                            decoration: const InputDecoration(
                              hintText: "Juan",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Last Name *",
                          child: TextFormField(
                            controller: _lastNameCtrl,
                            textInputAction: TextInputAction.next,
                            validator: _required,
                            decoration: const InputDecoration(
                              hintText: "Dela Cruz",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Sex *",
                          child: DropdownButtonFormField<String>(
                            initialValue: _selectedSex,
                            validator: (v) =>
                                v == null ? "Please select sex" : null,
                            onChanged: (value) {
                              setState(() => _selectedSex = value);
                              FocusScope.of(context).nextFocus();
                            },
                            isExpanded: true, // 🔥 makes it full width
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),

                            decoration: InputDecoration(
                              hintText: "Select sex",
                              prefixIcon: const Icon(Icons.wc_outlined),

                              // same rounded style as your fields
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: Color(0xFF3B82F6),
                                  width: 2,
                                ),
                              ),
                            ),

                            borderRadius: BorderRadius.circular(
                              14,
                            ), // dropdown popup rounded
                            dropdownColor: Colors.white,

                            items: [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text("Male", style: GoogleFonts.inter()),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text(
                                  "Female",
                                  style: GoogleFonts.inter(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Phone Number *",
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (v) {
                              final value = (v ?? "").trim();

                              if (value.isEmpty) {
                                return "Phone number is required.";
                              }

                              // remove all spaces
                              String digitsOnly = value.replaceAll(
                                RegExp(r'\s+'),
                                '',
                              );

                              // must be exactly 11 digits
                              final phoneRegex = RegExp(r'^\d{11}$');

                              if (!phoneRegex.hasMatch(digitsOnly)) {
                                return "Enter a valid 11-digit phone number.";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "0912 345 6789",
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
                            focusNode: _passFocus,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(
                              context,
                            ).requestFocus(_confirmPassFocus),
                            obscureText: !_showPass,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password is required";
                              }
                              if (!passwordRegex.hasMatch(v)) {
                                return "Password must be at least 8 characters with uppercase, lowercase, numbers, and symbols";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _showPass = !_showPass),
                                icon: Icon(
                                  _showPass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                        ),

                        _helper(
                          'Must be at least 8 characters with uppercase, lowercase, numbers, and symbols',
                        ),

                        const SizedBox(height: 14),

                        _LabeledField(
                          label: "Confirm Password *",
                          child: TextFormField(
                            controller: _confirmPassCtrl,
                            focusNode: _confirmPassFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            obscureText: !_showConfirmPass,
                            validator: (v) {
                              if (v != _passCtrl.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "••••••••",
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () => setState(
                                  () => _showConfirmPass = !_showConfirmPass,
                                ),
                                icon: Icon(
                                  _showConfirmPass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
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
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
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
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.isEmpty) ? "Required field" : null;

  Widget _sectionTitle(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    ),
  );

  Widget _helper(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF6B7280)),
    ),
  );

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Divider(height: 1, color: Color(0xFFE5E7EB)),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF3B82F6),
                  width: 2,
                ),
              ),
              errorMaxLines: 2,
              errorStyle: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
