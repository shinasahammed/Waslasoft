import 'package:flutter/material.dart';

class PNLReportScreen extends StatefulWidget {
  const PNLReportScreen({super.key});

  @override
  State<PNLReportScreen> createState() => _PNLReportScreenState();
}

class _PNLReportScreenState extends State<PNLReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  DateTime _fromDate = DateTime(2026, 3, 16);
  DateTime _toDate = DateTime(2026, 3, 16);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
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

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1F3A5F),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F3A5F),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 4 * opacity,
                toolbarHeight: 80,
                leadingWidth: 350,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24 * opacity),
                  ),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const BackButton(color: Colors.white),
                      Container(
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
                      const SizedBox(width: 15),
                      const Text(
                        "PNL Report",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
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
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 120),
            _buildModernFilterCard(),
            const SizedBox(height: 24),
            _buildPNLCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFilterCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildRefinedDatePicker("FROM", _fromDate, true)),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(child: _buildRefinedDatePicker("TO", _toDate, false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefinedDatePicker(String label, DateTime date, bool isFrom) {
    return InkWell(
      onTap: () => _selectDate(context, isFrom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey.withValues(alpha: 0.6),
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: Colors.blue[400],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "${date.day} ${_getMonth(date.month)} ${date.year}",
                style: const TextStyle(
                  color: Color(0xFF1F3A5F),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonth(int m) => [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ][m - 1];

  Widget _buildPNLCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFE5E7EB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: const Row(
              children: [
                Text(
                  "Particular",
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Fields
          _buildPNLRow("NET SALES", "0.00", Colors.green[600]!),
          const Divider(height: 1),
          _buildPNLRow("NET DISCOUNT", "0.00", Colors.green[600]!),
          const Divider(height: 1),
          _buildPNLRow("COST OF GOODS SOLD", "0.00", Colors.red[600]!),
          const Divider(height: 1),
          _buildPNLRow("GROSS PROFIT", "0.00", Colors.red[600]!),
          const Divider(height: 1),
          _buildPNLRow("TOTAL EXPENSES", "0.00", Colors.red[600]!),
          const Divider(height: 1),
          _buildPNLRow("NET PROFIT", "0.00", Colors.red[600]!, isLast: true),
        ],
      ),
    );
  }

  Widget _buildPNLRow(
    String label,
    String value,
    Color valueColor, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(24))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
