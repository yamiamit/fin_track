import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/utils/transaction_sheet/transaction_bottom_sheet.dart';
import 'package:fin_track/widgets/top_bar.dart';
import 'package:country_flags/country_flags.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({
    super.key,
    required this.transactionController,
  });

  final TransactionController transactionController;

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  static const List<Color> _chartColors = [
    Color(0xFF4DB6AC),
    Color(0xFFFF8A65),
    Color(0xFF7986CB),
    Color(0xFFFFD54F),
    Color(0xFF81C784),
    Color(0xFFBA68C8),
    Color(0xFF90A4AE),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryTextColor = colorScheme.onSurface;
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.65);
    final spendRatio = widget.transactionController.totalIncome <= 0
        ? 0.0
        : (widget.transactionController.totalExpense /
                widget.transactionController.totalIncome)
            .clamp(0.0, 1.0);
    final expenseByCategory = widget.transactionController.expenseByCategory;
    final totalExpenses = widget.transactionController.totalExpense;

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
                      'Your Balances',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track balance health and where your money goes',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 180,
                                width: 180,
                                child: CircularProgressIndicator(
                                  value: spendRatio,
                                  strokeWidth: 10,
                                  backgroundColor: isDarkMode
                                      ? const Color(0xFF1A2235)
                                      : const Color(0xFFDDE5F0),
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.teal,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${widget.transactionController.netBalance.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: primaryTextColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Net balance after tracked transactions',
                            style: TextStyle(color: primaryTextColor),
                          ),
                          Text(
                            '${widget.transactionController.transactions.length} transactions loaded',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Available Currencies',
                      style: TextStyle(color: primaryTextColor),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CountryFlag.fromCountryCode('ca',
                                theme: const ImageTheme(
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CAD', style: TextStyle(fontSize: 18,color: primaryTextColor)),
                                  Text(
                                    'Canadian Dollar',
                                    style: TextStyle(color: secondaryTextColor),
                                  ),
                                  Text(
                                    'Primary wallet',
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? const Color(0xFF0B1220)
                                  : const Color(0xFFE6ECF5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Active',
                              style: TextStyle(color: primaryTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Expense Categories',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Category-wise breakdown of your tracked expenses',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: expenseByCategory.isEmpty
                          ? Column(
                              children: [
                                const SizedBox(height: 12),
                                Icon(
                                  Icons.pie_chart_outline_rounded,
                                  size: 42,
                                  color: secondaryTextColor,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No expense data yet',
                                  style: TextStyle(
                                    color: primaryTextColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Add some expense transactions to see a category-wise chart.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                                const SizedBox(height: 12),
                              ],
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: PieChart(
                                    PieChartData(
                                      centerSpaceRadius: 48,
                                      sectionsSpace: 4,
                                      pieTouchData: PieTouchData(
                                        enabled: true,
                                      ),
                                      sections: _buildSections(
                                        expenseByCategory,
                                        totalExpenses,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? const Color(0xFF0B1220)
                                        : const Color(0xFFF4F7FB),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total spent',
                                            style: TextStyle(
                                              color: secondaryTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${totalExpenses.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color: primaryTextColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Top category',
                                            style: TextStyle(
                                              color: secondaryTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            expenseByCategory.entries.first.key,
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ...expenseByCategory.entries.toList().asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final categoryEntry = entry.value;
                                    final color =
                                        _chartColors[index % _chartColors.length];
                                    final amount = categoryEntry.value;
                                    final percentage = totalExpenses <= 0
                                        ? 0.0
                                        : (amount / totalExpenses) * 100;

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: _CategoryLegendRow(
                                        color: color,
                                        title: categoryEntry.key,
                                        amount: amount,
                                        percentage: percentage,
                                        textColor: primaryTextColor,
                                        secondaryTextColor: secondaryTextColor,
                                      ),
                                    );
                                  },
                                ),
                              ],
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

  List<PieChartSectionData> _buildSections(
    Map<String, double> expenseByCategory,
    double totalExpenses,
  ) {
    return expenseByCategory.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final value = category.value;
      final percentage = totalExpenses <= 0 ? 0.0 : (value / totalExpenses) * 100;

      return PieChartSectionData(
        color: _chartColors[index % _chartColors.length],
        value: value,
        radius: 54,
        title: '${percentage.toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
    }).toList();
  }
}

class _CategoryLegendRow extends StatelessWidget {
  const _CategoryLegendRow({
    required this.color,
    required this.title,
    required this.amount,
    required this.percentage,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final Color color;
  final String title;
  final double amount;
  final double percentage;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: secondaryTextColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
