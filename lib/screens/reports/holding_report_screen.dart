import 'package:flutter/material.dart';

class HoldingReportScreen extends StatefulWidget {
  const HoldingReportScreen({super.key});

  @override
  State<HoldingReportScreen> createState() => _HoldingReportScreenState();
}

class _HoldingReportScreenState extends State<HoldingReportScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  DateTime _fromDate = DateTime(2026, 3, 16);
  DateTime _toDate = DateTime(2026, 3, 16);

  final List<Map<String, String>> _mockData = [
    {
      "sno": "1",
      "party": "Main Branch Store",
      "salesQty": "150",
      "returnQty": "5",
    },
    {
      "sno": "2",
      "party": "City Center Depot",
      "salesQty": "85",
      "returnQty": "2",
    },
    {
      "sno": "3",
      "party": "Express Logistics",
      "salesQty": "42",
      "returnQty": "0",
    },
  ];

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
      backgroundColor: const Color(0xFFF1F5F9),
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
                        "Holding Report",
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
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            const SizedBox(height: 130),
            _buildFilterCard(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      "HOLDING ACTIVITY",
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
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTableHeader(),
                              const Divider(height: 1),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: _mockData.length,
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Divider(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                                itemBuilder: (context, index) {
                                  final item = _mockData[index];
                                  return _buildRow(item);
                                },
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
      bottomNavigationBar: _buildSummaryBar(),
    );
  }

  Widget _buildFilterCard() {
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
      child: Row(
        children: [
          Expanded(child: _buildDatePickerItem("FROM", _fromDate, true)),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.2),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(child: _buildDatePickerItem("TO", _toDate, false)),
        ],
      ),
    );
  }

  Widget _buildDatePickerItem(String label, DateTime date, bool isFrom) {
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
                "${date.day} ${_getMonthName(date.month)} ${date.year}",
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

  String _getMonthName(int month) {
    const months = [
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
    ];
    return months[month - 1];
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xFF1F3A5F)),
      child: Row(
        children: [
          _cell(width: 40, text: "#", isHeader: true),
          _cell(width: 200, text: "PARTY NAME", isHeader: true),
          _cell(width: 110, text: "SALES QTY", isHeader: true),
          _cell(width: 110, text: "RETURN QTY", isHeader: true),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          _cell(width: 40, text: item["sno"] ?? ""),
          _cell(width: 140, text: item["party"] ?? "N/A", isBold: true),
          _cell(
            width: 110,
            text: item["salesQty"] ?? "0",
            align: TextAlign.right,
            color: Colors.teal,
            isBold: true,
          ),
          _cell(
            width: 110,
            text: item["returnQty"] ?? "0",
            align: TextAlign.right,
            color: Colors.redAccent,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _cell({
    required double width,
    required String text,
    bool isHeader = false,
    bool isBold = false,
    TextAlign align = TextAlign.left,
    Color? color,
  }) {
    return Container(
      width: width,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: isHeader ? Colors.white : (color ?? const Color(0xFF1F2937)),
          fontWeight: (isHeader || isBold) ? FontWeight.w900 : FontWeight.w500,
          fontSize: isHeader ? 13 : 14,
          letterSpacing: isHeader ? 1.2 : 0,
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      child: Center(
        child: SizedBox(
          width: 200,
          height: 48,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[400],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.4),
            ),
            child: const Text(
              "FETCH REPORT",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
