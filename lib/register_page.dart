import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_navigation.dart';
import 'auth_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  Future<void> register() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if ([fullName, email, password, confirmPassword, phone, address].any((v) => v.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match.")),
      );
      return;
    }
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Store additional info in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'profileImageUrl': '', // For future profile images if needed
        'createdAt': DateTime.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.green.shade700;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              SizedBox(
                height: 150,
                child: Image.asset('assets/images/Screenshot_2025-06-14_020127-removebg-preview.png'), // Put your logo here!
              ),
              const SizedBox(height: 0),

              // App Name (green)
              Text(
                "Paddy.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 32),

              // Full Name
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: accentColor),
                  hintText: "Full Name",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, color: accentColor),
                  hintText: "Email",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Phone Number
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: accentColor),
                  hintText: "Phone Number",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Address
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.home_outlined, color: accentColor),
                  hintText: "Address",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Password
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: accentColor),
                  hintText: "Password",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: accentColor,
                    ),
                    onPressed: () => setState(() => passwordVisible = !passwordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Confirm Password
              TextField(
                controller: confirmPasswordController,
                obscureText: !confirmPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline, color: accentColor),
                  hintText: "Confirm Password",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 1.4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: accentColor, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: accentColor,
                    ),
                    onPressed: () => setState(() => confirmPasswordVisible = !confirmPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: register,
                  child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    shadowColor: accentColor.withOpacity(0.20),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Already have account? Sign In prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AuthPage()),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
