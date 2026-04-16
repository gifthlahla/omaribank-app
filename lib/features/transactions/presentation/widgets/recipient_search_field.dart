import 'package:flutter/material.dart';

class RecipientSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final VoidCallback? onSearch;

  const RecipientSearchField({
    super.key,
    required this.controller,
    this.validator,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: 'Recipient ID', // For MVP, assuming they input UUID. You can extend this to email search later.
        hintText: 'Enter recipient ID',
        prefixIcon: const Icon(Icons.person_search_outlined),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearch,
        ),
      ),
    );
  }
}
