import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:fin_track/models/transaction/transaction_model.dart';
import 'package:flutter/material.dart';

class BottomTransactionSheet extends StatefulWidget {
  const BottomTransactionSheet({
    super.key,
    required this.transactionController,
  });

  final TransactionController transactionController;

  @override
  State<BottomTransactionSheet> createState() =>
      _BottomTransactionSheetState();
}

class _BottomTransactionSheetState extends State<BottomTransactionSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final amountFocusNode = FocusNode();
  final noteFocusNode = FocusNode();

  String category = "Food";
  DateTime selectedDate = DateTime.now();
  bool isExpense = true;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    amountFocusNode.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveTransaction() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) return;

    await widget.transactionController.addTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      amount: amount,
      isExpense: isExpense,
      category: category,
      date: selectedDate,
      note: noteController.text,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.45,
        maxChildSize: 0.8,
        builder: (_, controller) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                controller: controller,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    TextField(
                      controller: amountController,
                      focusNode: amountFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      scrollPadding: const EdgeInsets.only(bottom: 140),
                      onSubmitted: (_) => noteFocusNode.requestFocus(),
                      decoration: const InputDecoration(hintText: "Amount"),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _toggleButton(
                            "Expense",
                            isExpense,
                            Colors.red,
                            () => setState(() => isExpense = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _toggleButton(
                            "Income",
                            !isExpense,
                            Colors.green,
                            () => setState(() => isExpense = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Theme.of(context).cardColor,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: category,
                        borderRadius: BorderRadius.circular(12),
                        items: TransactionController.predefinedCategories.map((
                          entry,
                        ) {
                          final visual = categoryVisualFor(entry);

                          return DropdownMenuItem(
                            value: entry,
                            child: Row(
                              children: [
                                Icon(visual.icon, color: visual.color, size: 20),
                                const SizedBox(width: 10),
                                Text(entry),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => category = value!);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      focusNode: noteFocusNode,
                      textInputAction: TextInputAction.done,
                      minLines: 1,
                      maxLines: 3,
                      scrollPadding: const EdgeInsets.only(bottom: 180),
                      onSubmitted: (_) => saveTransaction(),
                      decoration: const InputDecoration(hintText: "Note"),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: saveTransaction,
                        child: const Text("Add Transaction"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _toggleButton(
    String text,
    bool selected,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
