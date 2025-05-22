import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_chatter/screens/HomePage.dart';
import 'package:ai_chatter/screens/setup/user/UserSetupPage.dart';
import 'package:ai_chatter/screens/auth/RegisterPage.dart';
import 'package:ai_chatter/constants/FontSize.dart';
import 'package:ai_chatter/constants/BoxSize.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Sign in with email and password
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 2. Update last login timestamp
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid);
      
      // Get user data and update lastLoginAt
      final userData = await userDoc.get();
      await userDoc.update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        // Check if user setup is completed
        if (userData.exists && userData.data()?['isUserSet'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserSetupPage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(BoxSize.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and title
                    Icon(
                      Icons.chat_bubble_outline,
                      size: isSmallScreen ? BoxSize.iconLarge * 2 : BoxSize.iconLarge * 3,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: BoxSize.spacingL),
                    Text(
                      l10n.appTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSmallScreen ? FontSize.h2 : FontSize.h1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: BoxSize.spacingXXL),

                    // Login form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(BoxSize.inputRadius),
                              ),
                              contentPadding: EdgeInsets.all(BoxSize.inputPadding),
                            ),
                            style: TextStyle(fontSize: FontSize.inputText),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: BoxSize.inputSpacing),

                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(BoxSize.inputRadius),
                              ),
                              contentPadding: EdgeInsets.all(BoxSize.inputPadding),
                            ),
                            style: TextStyle(fontSize: FontSize.inputText),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: BoxSize.spacingXL),

                          // Login button
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: BoxSize.buttonPadding),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(BoxSize.buttonRadius),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(fontSize: FontSize.buttonMedium),
                                  ),
                          ),
                          SizedBox(height: BoxSize.spacingL),

                          // Register link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account? ',
                                style: TextStyle(fontSize: FontSize.bodyMedium),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(fontSize: FontSize.link),
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
        ),
      ),
    );
  }
} 