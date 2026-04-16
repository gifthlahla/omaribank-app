import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:omari_bank_app/core/constants/app_strings.dart';
import 'package:omari_bank_app/core/constants/app_constants.dart';
import 'package:omari_bank_app/core/utils/validators.dart';
import 'package:omari_bank_app/core/utils/extensions.dart';
import 'package:omari_bank_app/core/widgets/confirmation_dialog.dart';
import 'package:omari_bank_app/features/wallet/presentation/providers/wallet_provider.dart';
import 'package:omari_bank_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/amount_input_field.dart';
import 'package:omari_bank_app/features/transactions/presentation/widgets/recipient_search_field.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      final recipientId = _recipientController.text.trim();
      final description = _descriptionController.text.trim();
      
      final authState = ref.read(authStateProvider).value;
      if (authState == null) return;
      
      final walletState = ref.read(walletProvider(authState.id)).value;
      if (walletState == null || walletState.balance < amount) {
        context.showSnackBar(AppStrings.insufficientFunds, isError: true);
        return;
      }
      
      final confirm = await ConfirmationDialog.show(
        context,
        title: AppStrings.sendMoneyTitle,
        content: 'Are you sure you want to send \$${amount.toStringAsFixed(2)} to this user?',
      );

      if (confirm == true) {
        final reference = await ref.read(walletControllerProvider.notifier).transfer(
          recipientId: recipientId,
          amount: amount,
          description: description.isNotEmpty ? description : null,
        );
        
        if (!mounted) return;
        
        final state = ref.read(walletControllerProvider);
        if (state.hasError) {
          context.showSnackBar(state.error.toString(), isError: true);
        } else if (reference != null) {
          context.showSnackBar('Transfer successful! Ref: \$reference');
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletCtrlState = ref.watch(walletControllerProvider);
    final isLoading = walletCtrlState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.sendMoneyTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                RecipientSearchField(
                  controller: _recipientController,
                  validator: AppValidators.validateRequired,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                Text(
                  'Amount',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                AmountInputField(
                  controller: _amountController,
                  validator: AppValidators.validateAmount,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.description,
                    hintText: 'What is this for?',
                  ),
                  maxLength: 255,
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
                      : const Text('Send Money'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
