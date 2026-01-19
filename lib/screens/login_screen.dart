import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/forgotpassword_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool isChecked = false;

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
                SizedBox(height: ScreenUtil().setHeight(53)),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello!',
                          style: GoogleFonts.inter(
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'I\'m waiting for you, please enter your detail',
                          style: GoogleFonts.inter(
                            fontSize: ScreenUtil().setSp(12),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(40)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username, Email, or Phone',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      0,
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(10),
                      0,
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
                  controller: usernameController,
                  validator: (value) => value!.isEmpty
                      ? 'Enter username, email, or phone number'
                      : null,
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
                      0,
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
                  validator: (value) =>
                      value!.isEmpty ? 'Enter password' : null,
                  onSaved: (value) => passwordController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Color(0xFF343341),
                          value: isChecked,
                          visualDensity: VisualDensity(
                            horizontal: -4.0,
                            vertical: -4.0,
                          ),
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                        ),
                        Text(
                          'Remember Me',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(12),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
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
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(12),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.popAndPushNamed(context, '/page');
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
                  child: Text('Log in'),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/signup');
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
                        'Sign Up',
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
