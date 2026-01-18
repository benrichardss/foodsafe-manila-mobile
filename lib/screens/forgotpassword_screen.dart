import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                      icon: Icon(Icons.arrow_back,
                        size: ScreenUtil().setSp(25),
                        color: Colors.black,
                      ),
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        visualDensity: VisualDensity(
                          horizontal: -4.0,
                          vertical: -4.0,
                        )
                      ),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
                      }
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
                        Icon(Icons.location_on_outlined,
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
                            'Oh, no! I forgot',
                            style: GoogleFonts.inter(
                              fontSize: ScreenUtil().setSp(25),
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            )
                          ),
                          Text(
                            'Enter your email, phone, or username and we\'ll send you a link to change a new password.',
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              fontSize: ScreenUtil().setSp(12),
                              color: Colors.black,
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(34)),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username, Email, or Phone',
                    labelStyle: GoogleFonts.inter(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w400
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
                  controller: usernameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter username, email, or phone' : null,
                  onSaved: (value) => usernameController.text = value!,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Colors.black,
                  ),
                  cursorColor: Colors.black,
                  cursorErrorColor: Colors.red,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
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
                  Text('Forgot Password'),
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
                      )
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