import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotPasswordScreen> {
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();     // NEW
  final _confirmPassCtrl = TextEditingController(); // NEW
  final _formKey = GlobalKey<FormState>();

  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  bool _showPass = false;
  bool _showConfirmPass = false;

  bool _loading = false;
  int _step = 1; // 1: send code, 2: verify code, 3: reset password


  @override
  void dispose() {
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      // STEP 1 → SEND CODE
      if (_step == 1) {
        setState(() => _step = 2);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset code sent via SMS")),
        );
      }

      // STEP 2 → VERIFY CODE
      else if (_step == 2) {
        setState(() => _step = 3);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code verified")),
        );
      }

      // STEP 3 → RESET PASSWORD
      else if (_step == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password successfully reset")),
        );

        Navigator.pop(context); // back to login
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
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.white70),
                          label: Text(
                            "Back to Login",
                            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

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
                          Icons.monitor_heart_outlined, // lucide-activity vibe
                          size: 44,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Title
                    Text(
                      "Forgot Password",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your phone number to receive password reset instructions",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: Color(0xFFBFDBFE)),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
              // White sheet (but still in SAME scroll)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF6FF),
                        border: Border.all(color: Color(0xFFBFDBFE)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Expanded(
                        child: Text(
                          "We'll send a verification code to your registered phone number via SMS. Use this code to reset your password.",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LabeledField(
                            label: "Phone Number *",
                            child: TextFormField(
                              enabled: _step == 1,
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: "0912 345 6789",
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              validator: (v) {
                                  final value = (v ?? "").trim();

                                  if (value.isEmpty) return "Phone number is required.";

                                  // remove all spaces
                                  String digitsOnly = value.replaceAll(RegExp(r'\s+'), '');

                                  // must be exactly 11 digits
                                  final phoneRegex = RegExp(r'^\d{11}$');

                                  if (!phoneRegex.hasMatch(digitsOnly)) {
                                    return "Enter a valid 11-digit phone number.";
                                  }
                                  return null;
                                },
                            ),
                          ),
                          
                          _helper('Enter the phone number you used during registration'),

                          const SizedBox(height: 18),
                          
                          if (_step >= 2) ...[
                            _LabeledField(
                              label: "Reset Code *",
                              child: TextFormField(
                                controller: _codeCtrl,
                                enabled: _step == 2,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Enter SMS code",
                                  prefixIcon: Icon(Icons.verified_outlined),
                                ),
                                validator: (v) {
                                  if (_step < 2) return null;
                                  final value = (v ?? "").trim();
                                  if (value.isEmpty) return "Reset code required.";
                                  if (value.length < 4) return "Invalid code.";
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],

                          if (_step == 3) ...[
                            _LabeledField(
                              label: "New Password *",
                              child: TextFormField(
                                controller: _newPassCtrl,
                                obscureText: !_showPass,
                                validator: (v) {
                                  if (_step != 3) return null;
                                  if (v == null || v.isEmpty) {
                                    return "New password is required";
                                  }
                                  if (!passwordRegex.hasMatch(v)) {
                                    return "Password must be at least 8 characters with uppercase, lowercase, numbers, and symbols";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Enter new password",
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

                            const SizedBox(height: 18),

                            _LabeledField(
                              label: "Confirm Password *",
                              child: TextFormField(
                                controller: _confirmPassCtrl,
                                obscureText: !_showConfirmPass,
                                validator: (v) {
                                  if (_step != 3) return null;
                                  if (v != _newPassCtrl.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Confirm new password",
                                  prefixIcon:
                                      const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _showConfirmPass = !_showConfirmPass),
                                    icon: Icon(_showConfirmPass
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : Text(
                                      _step == 1
                                          ? "Send Reset Code"
                                          : _step == 2
                                              ? "Verify Code"
                                              : "Reset Password",
                                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sign in redirect
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              text: "Remember your password? ",
                              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
                              children: [
                                TextSpan(
                                  text: "Sign in",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF2563EB),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      )
    );
  }
  
  Widget _helper(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: GoogleFonts.inter(
          fontSize: 11, color: const Color(0xFF6B7280)),
    ),
  );
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
              errorMaxLines: 2,
              errorStyle: TextStyle(
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