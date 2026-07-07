import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _restoreLastEmail(); // SharedPreferences: pre-fill the last used email
  }

  Future<void> _restoreLastEmail() async {
    final last = await context.read<AuthProvider>().getLastEmail();
    if (last != null && mounted) {
      setState(() {
        _emailCtrl.text = last;
        _isVerified = last.endsWith('@alustudent.com');
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  Future<void> _handleSignIn() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    // Input validation before touching Firebase
    if (email.isEmpty || !email.contains('@')) {
      _showError('Please enter a valid email address.');
      return;
    }
    if (pass.isEmpty) {
      _showError('Please enter your password.');
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(email, pass);
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _showError(auth.errorMessage ?? 'Sign in failed.');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _showError(auth.errorMessage ?? 'Google sign-in failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Banner area (green gradient)
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B7A5F), Color(0xFF7BD8B6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.storefront_rounded,
                      color: Colors.white54, size: 60),
                ),
              ),
              const SizedBox(height: 28),
              Text('Welcome back', style: AppTheme.displayLg),
              const SizedBox(height: 4),
              Text('Sign in to your campus account',
                  style: AppTheme.bodyMd
                      .copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 28),
              // Email field
              Text('ALU Email',
                  style: AppTheme.labelMd
                      .copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) {
                  setState(
                      () => _isVerified = v.endsWith('@alustudent.com'));
                },
                decoration: _inputDecoration('your@alustudent.com'),
              ),
              if (_isVerified) ...[
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppTheme.primary, size: 14),
                      const SizedBox(width: 5),
                      Text('Verified student',
                          style: AppTheme.labelMd
                              .copyWith(color: AppTheme.primary)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Password field
              Text('Password',
                  style: AppTheme.labelMd
                      .copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePass,
                decoration: _inputDecoration(null).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.outline,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forgot_password'),
                  child: Text('Forgot password?',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: isLoading ? 'Signing in...' : 'Sign in',
                icon: Icons.arrow_forward,
                onPressed: isLoading ? () {} : _handleSignIn,
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.bodyMd
                        .copyWith(color: AppTheme.onSurfaceVariant),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/create_account'),
                          child: Text('Create one',
                              style: AppTheme.bodyMd.copyWith(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR CONTINUE WITH',
                        style: AppTheme.labelMd
                            .copyWith(color: AppTheme.outline)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              // Google sign-in (working) — Facebook removed since we only
              // implement the two required methods: Email/Password + Google.
              OutlinedButton.icon(
                onPressed: isLoading ? null : _handleGoogleSignIn,
                icon: const Icon(Icons.g_mobiledata,
                    color: AppTheme.primary, size: 28),
                label: Text('Continue with Google', style: AppTheme.bodyMd),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppTheme.outlineVariant),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                    '© 2024 Campus Market. All rights reserved.\nTrust & Safety Verified Community',
                    textAlign: TextAlign.center,
                    style:
                        AppTheme.labelMd.copyWith(color: AppTheme.outline)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppTheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}