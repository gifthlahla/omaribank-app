import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/utils/validators.dart';
import 'package:omari_bank_app/core/utils/extensions.dart';
import 'package:omari_bank_app/core/widgets/confirmation_dialog.dart';
import 'package:omari_bank_app/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/amount_input_field.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      
      final confirm = await ConfirmationDialog.show(
        context,
        title: AppStrings.depositTitle,
        content: 'Are you sure you want to deposit \$${amount.toStringAsFixed(2)}?',
      );

      if (confirm == true) {
        await ref.read(walletControllerProvider.notifier).deposit(amount);
        
        if (!mounted) return;
        
        final state = ref.read(walletControllerProvider);
        if (state.hasError) {
          context.showSnackBar(state.error.toString(), isError: true);
        } else {
          context.showSnackBar('Deposit successful!');
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final isLoading = walletState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.depositTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  'Enter amount to deposit',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                AmountInputField(
                  controller: _amountController,
                  validator: AppValidators.validateAmount,
                ),
                const Spacer(flex: 2),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm Deposit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
