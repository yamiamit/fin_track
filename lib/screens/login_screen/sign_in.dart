import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fin_track/models/sign_in/google_sign_in.dart';
import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/utils/main_navigation_screen/main_navigation_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignIn = true;
  bool obscure = true;
  String? name = "";
  bool isSubmitting = false;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ensureFirebaseInitialized();
  }


  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  void _openMainNavigation([String? userName]) {
    final transactionController = context.read<TransactionController>();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(
          transactionController: transactionController,
          userName: userName,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handlePrimaryAction() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Enter your email and password.');
      return;
    }

    if (!isSignIn) {
      if (fullName.isEmpty) {
        _showMessage('Enter your full name.');
        return;
      }
      if (confirmPassword.isEmpty) {
        _showMessage('Confirm your password.');
        return;
      }
      if (password != confirmPassword) {
        _showMessage('Passwords do not match.');
        return;
      }
    }

    setState(() => isSubmitting = true);

    try {
      //await _ensureFirebaseInitialized();

      if (isSignIn) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) {
        return;
      }
      _openMainNavigation(
        FirebaseAuth.instance.currentUser?.displayName ??
            fullNameController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage(e.message ?? 'Authentication failed.');
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage('Authentication failed: $e');
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    FocusScope.of(context).unfocus();
    setState(() => isSubmitting = true);

    try {
      name = await _googleSignInService.signInWithGoogle();
      print("Credentials are : $name");
      if (!mounted) {
        return;
      }
      _openMainNavigation(name);
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage(e.message ?? 'Google sign-in failed.');
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage('Google sign-in failed: $e');
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF141414),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 24),
            child: Column(
                children: [
                  const SizedBox(height: 60),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        "P",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome to PayU",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Send money globally with the real exchange rate",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Get started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Sign in to your account or create a new one",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => isSignIn = true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSignIn
                                          ? Colors.grey.shade300
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                          color: isSignIn
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => isSignIn = false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: !isSignIn
                                          ? Colors.grey.shade300
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          color: !isSignIn
                                              ? Colors.black
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!isSignIn) ...[
                          const Text(
                            "Full Name",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: fullNameController,
                            textInputAction: TextInputAction.next,
                            scrollPadding: const EdgeInsets.only(bottom: 220),
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              "Enter your full name",
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          scrollPadding: const EdgeInsets.only(bottom: 220),
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration("Enter your email"),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: passwordController,
                          obscureText: obscure,
                          textInputAction: isSignIn
                              ? TextInputAction.done
                              : TextInputAction.next,
                          scrollPadding: const EdgeInsets.only(bottom: 240),
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(
                            isSignIn
                                ? "Enter your password"
                                : "Create a password",
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => obscure = !obscure);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!isSignIn) ...[
                          const Text(
                            "Confirm Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: obscure,
                            textInputAction: TextInputAction.done,
                            scrollPadding: const EdgeInsets.only(bottom: 240),
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              "Confirm your password",
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (isSignIn)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isSubmitting
                                ? null
                                : _handlePrimaryAction,
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    isSignIn
                                        ? "Sign In"
                                        : "Create Account",
                                  ),
                          ),
                        ),
                        if (isSignIn) ...[
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade800),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  "or continue with",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade800),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed : isSubmitting ? null : _handleGoogleSignIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/google.svg',
                                    height: 24.0,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Sign in with Google",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
