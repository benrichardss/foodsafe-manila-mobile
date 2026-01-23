import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _showPass = false;
  bool _remember = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
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
                      "FoodSafe",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Stay safe, stay informed",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: Color(0xFFBFDBFE)),
                    ),

                    const SizedBox(height: 22),

                    // Demo credentials card
                    Container(
                      padding: const EdgeInsets.all(14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Demo Credentials:", style: GoogleFonts.inter(fontSize: 11, color: Color(0xFFBFDBFE))),
                          SizedBox(height: 6),
                          Text("+63 912 345 6789", style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                          SizedBox(height: 2),
                          Text("Password: demo123", style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                        ],
                      ),
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
                    Text(
                      "Welcome Back",
                      style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Sign in to continue",
                      style: GoogleFonts.inter(fontSize: 13, color: Color(0xFF4B5563)),
                    ),
                    const SizedBox(height: 14),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _LabeledField(
                            label: "Phone Number",
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
                          const SizedBox(height: 14),

                          _LabeledField(
                            label: "Password",
                            child: TextFormField(
                              controller: _passCtrl,
                              obscureText: !_showPass,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _signIn(),
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(() => _showPass = !_showPass),
                                  icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off),
                                ),
                              ),
                              validator: (v) {
                                final value = (v ?? "");
                                if (value.isEmpty) return "Password is required.";
                                if (value.length < 4) return "Password looks too short.";
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Checkbox(
                                value: _remember,
                                onChanged: (v) => setState(() => _remember = v ?? false),
                                activeColor: const Color(0xFF2563EB),
                              ),
                              Expanded(
                                child: Text(
                                  "Remember me",
                                  style: GoogleFonts.inter(fontSize: 13, color: Color(0xFF4B5563)),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/forgot_password');
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

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
                                      "Sign In",
                                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    const SizedBox(height: 14),

                    Text(
                      "Don't have an account?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 13, color: Color(0xFF4B5563)),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2563EB), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          "Create Account",
                          style: GoogleFonts.inter(color: Color(0xFF2563EB), fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "By signing in, you agree to our Terms of Service and Privacy Policy. "
                      "Your data is protected under the Data Privacy Act of 2012.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF4B5563), height: 1.35),
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