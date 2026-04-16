import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/utils/validators.dart';
import 'package:omari_bank_app/core/utils/extensions.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            fullName: _fullNameController.text.trim(),
            phoneNumber: _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
          );
      
      final state = ref.read(authControllerProvider);
      
      if (!mounted) return;
      
      if (state.hasError) {
        context.showSnackBar(state.error.toString(), isError: true);
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Text(
                    AppStrings.registerTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    AppStrings.registerSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.paddingXLarge),
                  AuthTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    hintText: AppStrings.fullNameHelper,
                    prefixIcon: Icons.person_outline,
                    validator: AppValidators.validateRequired,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  AuthTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: AppStrings.emailHelper,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.validateEmail,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  AuthTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number (Optional)',
                    hintText: AppStrings.phoneHelper,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  AuthTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: AppStrings.passwordHelper,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: AppValidators.validatePassword,
                  ),
                  const SizedBox(height: AppConstants.paddingXLarge),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(AppStrings.registerButton),
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(AppStrings.haveAccount),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
