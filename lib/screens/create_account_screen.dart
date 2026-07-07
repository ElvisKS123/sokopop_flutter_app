import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isAluEmail = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.error),
    );
  }

  /// Validates all inputs, then creates the Firebase account.
  Future<void> _handleCreateAccount() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty) {
      _showError('Please enter your full name.');
      return;
    }
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showError('Please enter a valid email address.');
      return;
    }
    if (pass.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }
    if (pass != confirm) {
      _showError('Passwords do not match.');
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(name, email, pass);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Account created! A verification email has been sent to your inbox.'),
          backgroundColor: AppTheme.primary,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _showError(auth.errorMessage ?? 'Could not create account.');
    }
  }

  Future<void> _handleGoogleSignUp() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;
    if (ok) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      _showError(auth.errorMessage ?? 'Google sign-up failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Campus Market',
            style: TextStyle(
                color: AppTheme.primary, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Create account',
                style:
                    AppTheme.displayLg.copyWith(color: AppTheme.primary)),
            const SizedBox(height: 4),
            Text('Join your campus community',
                style: AppTheme.bodyMd
                    .copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 28),
            SokoTextField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameCtrl,
            ),
            const SizedBox(height: 16),
            // ALU Email
            Text('ALU Email',
                style: AppTheme.labelMd
                    .copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              onChanged: (v) =>
                  setState(() => _isAluEmail = v.endsWith('@alustudent.com')),
              decoration: _inputDecoration('student@alustudent.com'),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  _isAluEmail
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  size: 13,
                  color: _isAluEmail ? AppTheme.primary : AppTheme.outline,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _isAluEmail
                        ? 'Verified ALU email'
                        : 'Verification required for @alustudent.com addresses',
                    style: AppTheme.labelMd.copyWith(
                      color:
                          _isAluEmail ? AppTheme.primary : AppTheme.outline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Password
            Text('Password',
                style: AppTheme.labelMd
                    .copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            TextField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              decoration: _inputDecoration('Create password').copyWith(
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
            const SizedBox(height: 16),
            // Confirm Password
            Text('Confirm Password',
                style: AppTheme.labelMd
                    .copyWith(color: AppTheme.onSurfaceVariant)),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmCtrl,
              obscureText: _obscureConfirm,
              decoration: _inputDecoration('Confirm password').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppTheme.outline,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: isLoading ? 'Creating account...' : 'Create account',
              icon: Icons.arrow_forward,
              onPressed: isLoading ? () {} : _handleCreateAccount,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR SIGN UP WITH',
                      style:
                          AppTheme.labelMd.copyWith(color: AppTheme.outline)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: isLoading ? null : _handleGoogleSignUp,
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
            const SizedBox(height: 16),
            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTheme.bodyMd
                      .copyWith(color: AppTheme.onSurfaceVariant),
                  children: [
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacementNamed(
                            context, '/sign_in'),
                        child: Text('Sign in',
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
            Text(
              'By creating an account, you agree to our Terms of Service and Privacy Policy. We only allow verified students to ensure a safe environment.',
              textAlign: TextAlign.center,
              style: AppTheme.labelMd.copyWith(color: AppTheme.outline),
            ),
            const SizedBox(height: 24),
          ],
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