import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotPasswordScreen> {
  final _phoneCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // TODO: replace with auth call
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signed in (demo)")),
      );
      Navigator.pushReplacementNamed(context, '/');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(-100, 0),
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
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
                        size: 56,
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

                  // Demo credentials card
                  

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
                      children: [
                        _LabeledField(
                          label: "Phone Number *",
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              hintText: "+63 912 345 6789",
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            validator: (v) {
                              final value = (v ?? "").trim();
                              if (value.isEmpty) return "Phone number is required.";
                              if (value.length < 8) return "Enter a valid phone number.";
                              return null;
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 8),

                        Text(
                          "Enter the phone number you used during registration",
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                        ),
                        
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _signIn,
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
                                    "Send Reset Code",
                                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
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
    );
  }
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
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}