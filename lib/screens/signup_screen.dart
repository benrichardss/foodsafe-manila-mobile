import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  final phoneRegex = RegExp(r'^(?:\D*\d){10,}\D*$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(35),
            vertical: ScreenUtil().setHeight(65),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: ScreenUtil().setSp(25),
                        color: Colors.black,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        visualDensity: VisualDensity(
                          horizontal: -4.0,
                          vertical: -4.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'FoodSafe',
                          style: GoogleFonts.inter(
                            fontSize: ScreenUtil().setSp(15),
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          size: ScreenUtil().setSp(25),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(49)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ScreenUtil().setWidth(290),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Welcome!',
                            style: GoogleFonts.inter(
                              fontSize: ScreenUtil().setSp(25),
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Let\'s create an account',
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email or Phone',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Inter'),
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email or phone number';
                    } else if (!emailRegex.hasMatch(value) &&
                        !phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid email or phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => emailController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Inter'),
                    errorMaxLines: 2,
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                  onSaved: (value) => nameController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Inter'),
                    errorMaxLines: 2,
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  controller: usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter username';
                    }
                    return null;
                  },
                  onSaved: (value) => usernameController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Inter'),
                    errorMaxLines: 2,
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscurePassword
                            ? Colors.grey
                            : Color(0xFF343341),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long.';
                    }
                    if (!passwordRegex.hasMatch(passwordController.text)) {
                      return 'Please choose a stronger password. Try a mix of uppercase and lowercase letters, numbers, and symbols.';
                    }
                    return null;
                  },
                  onSaved: (value) => passwordController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Inter'),
                    errorMaxLines: 2,
                    focusedErrorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: _obscureConfirmPassword
                            ? Colors.grey
                            : Color(0xFF343341),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  controller: confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm your password';
                    } else if (value != confirmPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onSaved: (value) => confirmPasswordController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Color(0xFF343341),
                    foregroundColor: Colors.white,
                    minimumSize: Size(
                      ScreenUtil().screenWidth,
                      ScreenUtil().setHeight(20),
                    ),
                    textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: Text('Sign Up'),
                ),
                const Spacer(flex: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity(
                          horizontal: -4.0,
                          vertical: -4.0,
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(12),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
