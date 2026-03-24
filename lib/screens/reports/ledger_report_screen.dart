import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waslasoft/widgets/select_party_dialog.dart';

class LedgerReportScreen extends StatefulWidget {
  const LedgerReportScreen({super.key});

  @override
  State<LedgerReportScreen> createState() => _LedgerReportScreenState();
}

class _LedgerReportScreenState extends State<LedgerReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  DateTime _fromDate = DateTime(2026, 3, 12);
  DateTime _toDate = DateTime(2026, 3, 12);
  String _selectedParty = "SELECT PARTY";

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
      backgroundColor: const Color(0xFFF1F5F9), // Premium light slate
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
                elevation: 4 * opacity,
                toolbarHeight: 120,
                leadingWidth: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24 * opacity),
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
                              "Ledger Report",
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
                              width: 140, // Increased for readability
                              margin: const EdgeInsets.only(left: 45),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _selectedParty,
                                  style: const TextStyle(
                                    color: Color(0xFF1F3A5F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.solidFileExcel,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 170),
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
            SizedBox(height: 20),
            // 1. Premium Control Card
            _buildModernFilterCard(),

            const SizedBox(height: 24),

            // 3. Unified Activity Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: const Text(
                      "LEDGER ACTIVITY",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 780,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildListHeader(),
                              const Divider(height: 1),
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                children: [
                                  _buildActivityCard(
                                    sno: "01",
                                    date: "12 Mar 2026",
                                    time: "14:59:59",
                                    description: "Opening Balance",
                                    amount: "0.00",
                                    isDebit: true,
                                    type: "SYSTEM",
                                    isLast: false,
                                  ),
                                  _buildActivityCard(
                                    sno: "02",
                                    date: "12 Mar 2026",
                                    time: "15:10:22",
                                    description: "Sales Invoice #INV-102",
                                    amount: "4,500.00",
                                    isDebit: true,
                                    type: "SALE",
                                    isLast: false,
                                  ),
                                  _buildActivityCard(
                                    sno: "03",
                                    date: "12 Mar 2026",
                                    time: "16:45:00",
                                    description: "Payment Received",
                                    amount: "2,000.00",
                                    isDebit: false,
                                    type: "RECEIPT",
                                    isLast: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSummaryBar(),
    );
  }

  Widget _buildBottomSummaryBar() {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3A5F),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "FINANCIAL SUMMARY",
                  style: TextStyle(
                    color: Colors.white60,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _buildNavStat("DEBIT", "₹4.5K", Colors.indigo[100]!),
                    const SizedBox(width: 15),
                    _buildNavStat("CREDIT", "₹2.0K", Colors.teal[100]!),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "NET BALANCE: ₹2,500.00",
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB74D),
              foregroundColor: Colors.black,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
            child: const Text(
              "DONE!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.6),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
      ],
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
            color: Colors.black.withOpacity(0.04),
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
                color: Colors.grey.withOpacity(0.2),
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
              color: Colors.blueGrey.withOpacity(0.6),
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
                "${date.day} ${_getMonth(date.month)}",
                style: const TextStyle(
                  color: Color(0xFF1F3A5F),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
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

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(color: Color(0xFF1F3A5F)),
      child: Row(
        children: [
          const SizedBox(width: 20),
          _tableCell(width: 80, content: Text("S.NO", style: _headerStyle())),
          _tableCell(width: 200, content: Text("DATE", style: _headerStyle())),
          _tableCell(
            width: 150,
            content: Text(
              "DEBIT",
              textAlign: TextAlign.right,
              style: _headerStyle(),
            ),
          ),
          _tableCell(
            width: 150,
            content: Text(
              "CREDIT",
              textAlign: TextAlign.right,
              style: _headerStyle(),
            ),
          ),
          _tableCell(
            width: 180,
            content: Text(
              "BILL TYPE",
              textAlign: TextAlign.center,
              style: _headerStyle(),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() => const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 14,
    letterSpacing: 1.2,
  );

  Widget _buildActivityCard({
    required String sno,
    required String date,
    required String time,
    required String description,
    required String amount,
    required bool isDebit,
    required String type,
    bool isLast = false,
  }) {
    final Color themeColor = isDebit ? Colors.indigo : Colors.teal;

    return Column(
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                const SizedBox(width: 20),
                // S.NO
                _tableCell(
                  width: 80,
                  content: Text(
                    sno,
                    style: TextStyle(
                      color: Colors.blueGrey.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // DATE & TIME
                _tableCell(
                  width: 200,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          color: Color(0xFF1F2937),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.25),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // DEBIT
                _tableCell(
                  width: 150,
                  content: Text(
                    isDebit ? "₹$amount" : "-",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isDebit ? Colors.indigo : Colors.grey[400],
                      fontWeight: isDebit ? FontWeight.w900 : FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),

                // CREDIT
                _tableCell(
                  width: 150,
                  content: Text(
                    !isDebit ? "₹$amount" : "-",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: !isDebit ? Colors.teal : Colors.grey[400],
                      fontWeight: !isDebit
                          ? FontWeight.w900
                          : FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),

                // BILL TYPE
                _tableCell(
                  width: 180,
                  content: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          ),
      ],
    );
  }

  Widget _tableCell({required double width, required Widget content}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: content,
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
}
