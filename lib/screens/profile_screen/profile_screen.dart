import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:flutter/material.dart';

import '../../widgets/top_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.transactionController,
  });

  final TransactionController transactionController;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isPreview = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = colorScheme.onSurface;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const TopBar(),
              const SizedBox(height: 10),
              Expanded(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? const Color(0xFFE6EBF2)
                                    : colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.black
                                        : colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Alex Yu',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildToggle(),
                        const SizedBox(height: 20),
                        if (isPreview) ...[
                          _infoCard(
                            title: 'Total Spending',
                            value:
                                '\$${widget.transactionController.totalExpense.toStringAsFixed(2)}',
                            icon: Icons.trending_up,
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            title: 'Balance',
                            value:
                                '\$${widget.transactionController.netBalance.toStringAsFixed(2)}',
                            icon: Icons.account_balance_wallet,
                          ),
                          const SizedBox(height: 12),
                          _infoCard(
                            title: 'Transactions',
                            value:
                                '${widget.transactionController.transactions.length} tracked',
                            icon: Icons.receipt_long,
                          ),
                        ],
                        if (!isPreview)
                          Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildField('Full Name', 'Enter your full name'),
                              const SizedBox(height: 16),
                              _buildField('Email', 'Enter your email'),
                              const SizedBox(height: 16),
                              _buildPasswordField(),
                              const SizedBox(height: 16),
                              _buildField(
                                'Confirm Password',
                                'Confirm your password',
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode
                                        ? const Color(0xFFE6EBF2)
                                        : colorScheme.primaryContainer,
                                    foregroundColor: isDarkMode
                                        ? Colors.black
                                        : colorScheme.onPrimaryContainer,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Update Details'),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: primaryTextColor)),
        const SizedBox(height: 6),
        TextField(
          enabled: !isPreview,
          textInputAction: TextInputAction.next,
          scrollPadding: const EdgeInsets.only(bottom: 140),
          style: TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: secondaryTextColor),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password', style: TextStyle(color: primaryTextColor)),
        const SizedBox(height: 6),
        TextField(
          enabled: !isPreview,
          obscureText: obscure,
          textInputAction: TextInputAction.next,
          scrollPadding: const EdgeInsets.only(bottom: 160),
          style: TextStyle(color: primaryTextColor),
          decoration: InputDecoration(
            hintText: 'Create a password',
            hintStyle: TextStyle(color: secondaryTextColor),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
                color: secondaryTextColor,
              ),
              onPressed: () {
                setState(() => obscure = !obscure);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final selectedColor = isDarkMode
        ? const Color(0xFFE6EBF2)
        : colorScheme.primaryContainer;
    final selectedTextColor = isDarkMode
        ? Colors.black
        : colorScheme.onPrimaryContainer;
    final unselectedTextColor = colorScheme.onSurface.withValues(alpha: 0.65);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isPreview = true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isPreview ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Preview',
                    style: TextStyle(
                      color: isPreview
                          ? selectedTextColor
                          : unselectedTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => isPreview = false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isPreview ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: !isPreview
                          ? selectedTextColor
                          : unselectedTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF0B1220)
                  : const Color(0xFFE6ECF5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryTextColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: secondaryTextColor, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
