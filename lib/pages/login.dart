import 'package:find_medicine/services/auth_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),

                //lock icon
                Icon(
                  Icons.lock_rounded,
                  size: 100,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: 35),

                //weclome back, you've been missed!
                Text(
                  'Weclome back you\'ve been missed!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                //sign in/up using google button
                GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(
                    Scaffold.of(context).context
                  ),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),

                        //google image
                        Image.asset(
                          'assets/images/google.png',
                          height: 40,
                        ),

                        const SizedBox(width: 20),

                        //Sign in/up using google
                        const Text(
                          'Sign In/Up using Google',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                //or continue as guest design
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.grey[400],
                      ),
                    ),

                    //or continue as guest
                    Text(
                      'Or Continue as guest',
                      style: TextStyle(
                        color: Colors.grey[750],
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        thickness: 1.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                //guest button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //guest user
                    GestureDetector(
                      //navigate to home page with guest username
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/home');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[200],
                        ),
                        child: Image.asset(
                          'assets/images/guest.png',
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                //not a member?
                const Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 50, 30),
                  child: Text(
                    'Not a member? No problem, sign up using the signin button and the system will automatically register you',
                    style: TextStyle(
                      color: Color.fromRGBO(223, 46, 55, 1),
                      fontWeight: FontWeight.w500,
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
}