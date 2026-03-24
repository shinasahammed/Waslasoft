import 'package:flutter/material.dart';

class PurchaseReturnReportScreen extends StatefulWidget {
  const PurchaseReturnReportScreen({super.key});

  @override
  State<PurchaseReturnReportScreen> createState() =>
      _PurchaseReturnReportScreenState();
}

class _PurchaseReturnReportScreenState
    extends State<PurchaseReturnReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  DateTime _fromDate = DateTime(2026, 3, 12);
  DateTime _toDate = DateTime(2026, 3, 12);

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
                              "Purchase Return Report",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 130),

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
                      "PURCHASE ACTIVITY",
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
                                    sno: "1",
                                    billNo: "PUR-101",
                                    date: "12-3-2026",
                                    party: "Cash Customer",
                                    netTotal: "4,500.00",
                                    isLast: false,
                                  ),
                                  _buildActivityCard(
                                    sno: "2",
                                    billNo: "PUR-102",
                                    date: "12-3-2026",
                                    party: "ABC Enterprises",
                                    netTotal: "2,000.00",
                                    isLast: false,
                                  ),
                                  _buildActivityCard(
                                    sno: "3",
                                    billNo: "PUR-103",
                                    date: "12-3-2026",
                                    party: "XYZ Ltd (Very Long Name)",
                                    netTotal: "1,250.00",
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
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3A5F),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
                Text(
                  "NET TOTAL: ₹7,750.00",
                  style: TextStyle(
                    color: Colors.orange[300],
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildNavStat(String label, String value, Color color) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: TextStyle(
  //           color: color.withOpacity(0.6),
  //           fontSize: 9,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           color: color,
  //           fontWeight: FontWeight.w900,
  //           fontSize: 14,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
          _tableCell(width: 60, content: Text("#", style: _headerStyle())),
          _tableCell(
            width: 150,
            content: Text("BILL NO", style: _headerStyle()),
          ),
          _tableCell(width: 150, content: Text("DATE", style: _headerStyle())),
          _tableCell(width: 250, content: Text("PARTY", style: _headerStyle())),
          _tableCell(
            width: 150,
            content: Text(
              "NET TOTAL",
              textAlign: TextAlign.right,
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
    required String billNo,
    required String date,
    required String party,
    required String netTotal,
    bool isLast = false,
  }) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                const SizedBox(width: 20),
                // #
                _tableCell(
                  width: 60,
                  content: Text(
                    sno,
                    style: TextStyle(
                      color: Colors.blueGrey.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // BILL NO
                _tableCell(
                  width: 150,
                  content: Text(
                    billNo,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),

                // DATE
                _tableCell(
                  width: 150,
                  content: Text(
                    date,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // PARTY
                _tableCell(
                  width: 250,
                  content: Text(
                    party,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // NET TOTAL
                _tableCell(
                  width: 150,
                  content: Text(
                    "₹$netTotal",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
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
            child: Divider(
              height: 1,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
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
}
