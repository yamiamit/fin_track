import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/utils/transaction_sheet/transaction_bottom_sheet.dart';
import 'package:fin_track/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.transactionController,
    required this.userName,
  });

  final TransactionController transactionController;
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showMonthly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);
    final panelColor = theme.cardColor;
    final selectedChipColor = isDarkMode
        ? const Color(0xFFE6EBF2)
        : colorScheme.primaryContainer;
    final recentTransactions = widget.transactionController.recentTransactions;
    final firstName = widget.userName.trim().split(' ').first;
    final cardHolderName = widget.userName.trim().toUpperCase();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return BottomTransactionSheet(
                transactionController: widget.transactionController,
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const TopBar(),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Hey, $firstName",
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      showMonthly
                          ? "Your monthly financial summary"
                          : "Add your yesterday's expense",
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD6BFA7), Color(0xFF4DB6AC)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ADRBank",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "8763 1111 2222 0329",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Card Holder Name",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    cardHolderName,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Available Balance",
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "\$${widget.transactionController.netBalance.toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      showMonthly ? "Monthly overview" : "Your expenses",
                      style: TextStyle(color: primaryTextColor, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: panelColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => showMonthly = false);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !showMonthly
                                      ? selectedChipColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Weekly",
                                    style: TextStyle(
                                      color: !showMonthly
                                          ? (isDarkMode
                                                ? Colors.black
                                                : colorScheme.onPrimaryContainer)
                                          : secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => showMonthly = true);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: showMonthly
                                      ? selectedChipColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Monthly",
                                    style: TextStyle(
                                      color: showMonthly
                                          ? (isDarkMode
                                                ? Colors.black
                                                : colorScheme.onPrimaryContainer)
                                          : secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (showMonthly) ...[
                      _summaryCard(
                        context,
                        title: "Total Income",
                        amount:
                            "\$${widget.transactionController.totalIncome.toStringAsFixed(2)}",
                        subtitle: "Money added this month",
                        accentColor: Colors.green,
                      ),
                      const SizedBox(height: 12),
                      _summaryCard(
                        context,
                        title: "Total Expenses",
                        amount:
                            "\$${widget.transactionController.totalExpense.toStringAsFixed(2)}",
                        subtitle: "Money spent this month",
                        accentColor: Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      _summaryCard(
                        context,
                        title: "Remaining Balance",
                        amount:
                            "\$${widget.transactionController.netBalance.toStringAsFixed(2)}",
                        subtitle: "Income minus expenses",
                        accentColor: Colors.teal,
                      ),
                    ] else if (recentTransactions.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: Text(
                          "No transactions yet. Add one with the + button.",
                          style: TextStyle(color: secondaryTextColor),
                        ),
                      )
                    else
                      ...recentTransactions.map(
                        (transaction) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _expenseCard(
                            context,
                            title: transaction.category.toUpperCase(),
                            subtitle: transaction.note.isEmpty
                                ? _formatDate(transaction.date)
                                : transaction.note,
                            amount:
                                "${transaction.isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}",
                            accentColor: transaction.isExpense
                                ? Colors.redAccent
                                : Colors.green,
                          ),
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context, {
    required String title,
    required String amount,
    required String subtitle,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.bar_chart_rounded, color: accentColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: secondaryTextColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: accentColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _expenseCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String amount,
    required Color accentColor,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.swap_horiz_rounded, color: accentColor),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: primaryTextColor, fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.circle, color: accentColor, size: 10),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF0B1220)
                      : const Color(0xFFE6ECF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(amount, style: TextStyle(color: primaryTextColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day/$month/${date.year}";
  }
}
