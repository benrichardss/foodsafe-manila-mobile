import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_textformfield.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(35),
                    vertical: ScreenUtil().setHeight(60),
                  ),
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
                          Icon(Icons.location_on_outlined,
                            size: ScreenUtil().setSp(25),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(53)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                )
                              ),
                              Text(
                                'I\'m waiting for you, please enter your detail',
                                style: GoogleFonts.inter(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.black,
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(65)),
                      CustomTextformfield(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: usernameController,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter username' : null,
                        onSaved: (value) => usernameController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: Colors.black,
                        hintTextSize: ScreenUtil().setSp(12),
                        hintText: 'Username, Email, or Phone',
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      CustomTextformfield(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(10),
                        controller: passwordController,
                        isObscure: _obscurePassword,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) => passwordController.text = value!,
                        fontSize: ScreenUtil().setSp(15),
                        fontColor: Colors.black,
                        hintTextSize: ScreenUtil().setSp(12),
                        hintText: 'Password',
                        toggleIcon: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.black,
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
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(36)),
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
                            ScreenUtil().setHeight(20)
                          ),
                          textStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.w800,
                          ),
                        ), 
                        child: 
                        Text('Log in'),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(230)),
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
                          GestureDetector(
                            onTap: () =>
                                Navigator.popAndPushNamed(context, '/register'),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(12),
                                fontWeight: FontWeight.bold,
                              ),
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
      ),
    );
  }
}
