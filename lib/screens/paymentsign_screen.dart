import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/models/payment_model.dart';
import 'package:waslasoft/services/payment_service.dart';
import 'package:waslasoft/services/expense_data_service.dart';
import 'package:waslasoft/widgets/purchase_party_dialog.dart';
import 'package:waslasoft/widgets/payment_method_dialog.dart';

class PaymentsignScreen extends StatefulWidget {
  final Expensedatamodel? initialParty;
  final double? initialAmount;

  const PaymentsignScreen({
    super.key,
    this.initialParty,
    this.initialAmount,
  });

  @override
  State<PaymentsignScreen> createState() => _PaymentsignScreenState();
}

class _PaymentsignScreenState extends State<PaymentsignScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: const Color(0xFF1F3A5F),
    exportBackgroundColor: Colors.white,
  );

  Expensedatamodel? _selectedParty;
  final TextEditingController _amountController = TextEditingController();
  final Color _primaryBlue = const Color(0xFF1F3A5F);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _amountController.addListener(_onAmountChanged);

    // Auto-select party and amount if provided (e.g., from Purchase flow)
    if (widget.initialParty != null) {
      _selectedParty = widget.initialParty;
    }
    if (widget.initialAmount != null && widget.initialAmount! > 0) {
      _amountController.text = widget.initialAmount!.toStringAsFixed(2);
    }
  }

  void _onAmountChanged() {
    setState(() {});
  }

  String get _currentBalance {
    if (_selectedParty == null) return "0.00";
    final originalBalance =
        double.tryParse(_selectedParty!.openBalance ?? "0") ?? 0.0;
    final debitAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    // Logic matching ExpenseScreen:
    // If the original balance is negative (e.g., -100), debiting a positive amount (e.g. 50)
    // should reduce the debt to -50. Therefore, we ADD the debit amount.
    // If positive, we subtract.
    final calculatedBalance = originalBalance < 0
        ? originalBalance + debitAmount
        : originalBalance - debitAmount;

    return calculatedBalance.toStringAsFixed(2);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    // AppBar Opacity - Matching the premium sharp fade (divisor 60)
    final newOpacity = (1.0 - (offset / 60)).clamp(0.0, 1.0);
    if (_appBarOpacityNotifier.value != newOpacity) {
      _appBarOpacityNotifier.value = newOpacity;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarOpacityNotifier.dispose();
    _amountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _savePayment() async {
    if (_selectedParty == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a party")),
      );
      return;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount")),
      );
      return;
    }

    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a signature")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Export signature to bytes
      final signatureBytes = await _controller.toPngBytes();

      if (signatureBytes != null) {
        // 2. Store signature in shared_preferences (base64)
        final prefs = await SharedPreferences.getInstance();
        final base64Signature = base64Encode(signatureBytes);
        await prefs.setString('last_payment_signature', base64Signature);
        print("Signature saved to SharedPreferences");
      }

      // 3. Get Payment Method
      double netAmount = double.tryParse(_amountController.text) ?? 0.0;
      final paymentMethod = await showDialog<String>(
        context: context,
        builder: (context) => PaymentMethodDialog(netAmount: netAmount),
      );

      if (paymentMethod != null) {
        // 4. Create model and call API
        final paymentModel = Paymentmodel(
          paymentDate: DateTime.now(),
          paidTo: _selectedParty!.name,
          amount: _amountController.text,
          paymentMethod: paymentMethod,
          clientCode: "1999", // Hardcoded as per other services
        );

        final success = await PaymentService().postData(paymentModel);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Payment Successful via $paymentMethod"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Modern off-white
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 5 * opacity,
                toolbarHeight: 120,
                leadingWidth: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20 * opacity),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const BackButton(color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                "assets/images/logo.jpeg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Payment Activity",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await showDialog<Expensedatamodel>(
                                context: context,
                                builder: (context) => 
                                  const SelectpurchasePartyDialog(),
                              );
                              if (result != null) {
                                setState(() {
                                  _selectedParty = result;
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 110,
                              margin: const EdgeInsets.only(left: 45),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  _selectedParty?.name ?? "SELECT PARTY",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 180),
            // Party Selection Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F3A5F).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(_selectedParty?.name ?? "?"),
                              style: const TextStyle(
                                color: Color(0xFF1F3A5F),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedParty == null
                                    ? "Party Not Selected"
                                    : _selectedParty!.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _selectedParty == null
                                    ? "Select a party to start payment"
                                    : "Active Party",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniInfo(Icons.phone, "No Phone"),
                        _buildMiniInfo(
                          Icons.account_balance_wallet,
                          "Bal: ${_selectedParty?.openBalance ?? "0.00"}",
                        ),
                        _buildMiniInfo(Icons.history, "Last: N/A"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Dynamic Balance Display (Like Expense Screen)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Balance",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _currentBalance,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "DEBIT AMOUNT",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 12),
            // Amount Entry Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: _primaryBlue,
                    ),
                    decoration: InputDecoration(
                      hintText: "0.00",
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      border: InputBorder.none,
                      prefixText: "SAR ",
                      prefixStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Plain Premium Signature Area
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "PARTY SIGNATURE",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Signature(
                  controller: _controller,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Modern Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: "CLEAR",
                    onPressed: () => _controller.clear(),
                    color: Colors.grey[200]!,
                    textColor: Colors.black87,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    label: _isLoading ? "SAVING..." : "SAVE PAYMENT",
                    onPressed: _isLoading ? () {} : _savePayment,
                    color: const Color(0xFFFFB74D),
                    textColor: Colors.black,
                    hasShadow: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    required Color textColor,
    bool hasShadow = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    List<String> words = name.trim().split(" ");
    if (words.length >= 2) {
      return (words[0][0] + words[1][0]).toUpperCase();
    } else if (words.isNotEmpty && words[0].isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return "?";
  }
}
