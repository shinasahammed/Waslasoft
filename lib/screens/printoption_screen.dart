import 'package:flutter/material.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/screens/paymentsign_screen.dart';

class PrintOptionScreen extends StatefulWidget {
  final String orderId;
  final String orderDate;
  final double totalAmount;
  final Expensedatamodel? selectedParty;
  final bool isReturn;
  final bool hidePaymentOption;

  const PrintOptionScreen({
    super.key,
    this.orderId = "#WSL-2489",
    this.orderDate = "11 Mar 2026",
    this.totalAmount = 2450.00,
    this.selectedParty,
    this.isReturn = false,
    this.hidePaymentOption = false,
  });

  @override
  State<PrintOptionScreen> createState() => _PrintOptionScreenState();
}

class _PrintOptionScreenState extends State<PrintOptionScreen> {
  bool _istoggle = true;

  final Color _primaryBlue = const Color(0xFF1F3A5F);
  final Color _accentOrange = const Color(0xFFFFAB00);
  final Color _accentGreen = const Color(0xFF00C853);
  final Color _accentBlue = const Color(0xFF29B6F6);
  final Color _accentPurple = const Color(0xFF7E57C2);
  final Color _bgSubtle = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgSubtle,
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 250,
        backgroundColor: _primaryBlue,
        elevation: 0,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
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
                      "Print Option",
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
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _istoggle,
                  onChanged: (value) {
                    setState(() {
                      _istoggle = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Summary Card
            _buildSectionHeader("Transaction Summary"),
            const SizedBox(height: 12),
            _buildTransactionCard(),
            const SizedBox(height: 32),

            // Quick Actions Grid
            _buildSectionHeader("Quick Actions"),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                if (!widget.hidePaymentOption)
                  _buildActionCard(
                    icon: Icons.payments_rounded,
                    label: "PAYMENT",
                    sublabel: "History/Gateway",
                    color: _accentPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentsignScreen(
                            initialParty: widget.selectedParty,
                            initialAmount: widget.totalAmount,
                            isReturn: widget.isReturn,
                          ),
                        ),
                      );
                    },
                  ),
                _buildActionCard(
                  icon: Icons.bluetooth_rounded,
                  label: "BLUETOOTH",
                  sublabel: "Thermal Printer",
                  color: _accentBlue,
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.share_rounded,
                  label: "SHARE",
                  sublabel: "WhatsApp/Email",
                  color: _accentGreen,
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.description_rounded,
                  label: "RECEIPT",
                  sublabel: "Digital Copy",
                  color: _accentOrange,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: _primaryBlue.withValues(alpha: 0.5),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTransactionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryBlue, _primaryBlue.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem("ORDER ID", widget.orderId, Colors.white),
              _buildInfoItem("DATE", widget.orderDate, Colors.white),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white24, height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL AMOUNT",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "₹ ${widget.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withValues(alpha: 0.6),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String sublabel,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: _primaryBlue,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
