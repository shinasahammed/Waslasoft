import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:waslasoft/widgets/payment_method_dialog.dart';
import 'package:waslasoft/widgets/select_party_dialog.dart';

class PaymentsignScreen extends StatefulWidget {
  const PaymentsignScreen({super.key});

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

  String _selectedParty = "SELECT PARTY";
  final TextEditingController _amountController = TextEditingController();
  final Color _primaryBlue = const Color(0xFF1F3A5F);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    super.dispose();
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
                              final result = await showDialog<String>(
                                context: context,
                                builder: (context) => const SelectPartyDialog(),
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
                                  _selectedParty,
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1F3A5F,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF1F3A5F),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedParty == "Select Party"
                                    ? "Customer Not Selected"
                                    : _selectedParty,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                _selectedParty == "Select Party"
                                    ? "Select a party to start billing"
                                    : "Active Customer",
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
                          "Bal: 0.00",
                        ),
                        _buildMiniInfo(Icons.history, "Last: N/A"),
                      ],
                    ),
                  ],
                ),
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
                "CUSTOMER SIGNATURE",
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
                    label: "SAVE PAYMENT",
                    onPressed: () async {
                      double netAmount =
                          double.tryParse(_amountController.text) ?? 57.50;
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) =>
                            PaymentMethodDialog(netAmount: netAmount),
                      );

                      if (result != null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Payment Successful via $result"),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
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
