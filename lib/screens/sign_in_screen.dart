import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController(text: 'pierre@alustudent.com');
  final _passCtrl = TextEditingController(text: '••••••••••');
  bool _obscurePass = true;
  bool _isVerified = true;

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(Icons.storefront_rounded, color: Colors.white54, size: 60),
                ),
              ),
              const SizedBox(height: 28),
              Text('Welcome back', style: AppTheme.displayLg),
              const SizedBox(height: 4),
              Text('Sign in to your campus account',
                  style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 28),
              // Email field
              Text('ALU Email', style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) {
                  setState(() => _isVerified = v.endsWith('@alustudent.com'));
                },
                decoration: InputDecoration(
                  hintText: 'your@alustudent.com',
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              if (_isVerified) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.primary, size: 14),
                      const SizedBox(width: 5),
                      Text('Verified student',
                          style: AppTheme.labelMd.copyWith(color: AppTheme.primary)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Password field
              Text('Password', style: AppTheme.labelMd.copyWith(color: AppTheme.onSurfaceVariant)),
              const SizedBox(height: 6),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePass,
                decoration: InputDecoration(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppTheme.outline,
                    ),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Forgot password?',
                      style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Sign in',
                icon: Icons.arrow_forward,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTheme.bodyMd.copyWith(color: AppTheme.onSurfaceVariant),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/create_account'),
                          child: Text('Create one',
                              style: AppTheme.bodyMd.copyWith(
                                  color: AppTheme.primary, fontWeight: FontWeight.w700)),
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
                        style: AppTheme.labelMd.copyWith(color: AppTheme.outline)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _socialBtn('Google', Icons.g_mobiledata)),
                  const SizedBox(width: 12),
                  Expanded(child: _socialBtn('Facebook', Icons.facebook)),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('© 2024 Campus Market. All rights reserved.\nTrust & Safety Verified Community',
                    textAlign: TextAlign.center,
                    style: AppTheme.labelMd.copyWith(color: AppTheme.outline)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialBtn(String label, IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 6),
          Text(label, style: AppTheme.bodyMd.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
