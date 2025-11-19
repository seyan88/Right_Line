import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();
    final existingEmail = prefs.getString('registeredEmail');

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
      );
      return;
    }

    if (existingEmail != null && existingEmail == email) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar!')),
      );
      return;
    }

    // Simpan data ke SharedPreferences
    await prefs.setString('registeredEmail', email);
    await prefs.setString('registeredPassword', password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil!')),
    );

    // Navigasi kembali ke halaman sebelumnya 
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Register to get started",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _register,
                    child: const Text(
                      "Register",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);  // Kembali ke halaman sebelumnya
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}