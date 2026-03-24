import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isOnline = true;
  bool printReceipt = true;
  String selectedPrinter = "Web View A4Printer";
  String selectedLanguage = "English";

  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ValueNotifier<bool> _showPopupNotifier = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();

  final List<String> printers = [
    "Epson Printer",
    "Balaji Printer",
    "Epson WiFi Printer",
    "Web View Printer",
    "Web View A4Printer",
    "Preprinted Web View A4Printer",
    "GST Print",
    "Bluetooth 3inch Printer",
    "TVS Bluetooth Printer",
    "WebView 4inch",
    "Handheld RFID Reader Printer",
    "WebView-Pre Printer2",
    "WebView 4.25inch",
    "Bluetooth 4.25Inch Printer",
    "None",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // AppBar Opacity - Shorter, sharper fade to avoid "blur"
    final newOpacity = (1.0 - (offset / 60)).clamp(0.0, 1.0);
    if (_appBarOpacityNotifier.value != newOpacity) {
      _appBarOpacityNotifier.value = newOpacity;
    }

    // Popup Visibility
    final showPopup = offset >= maxScroll - 20;
    if (_showPopupNotifier.value != showPopup) {
      _showPopupNotifier.value = showPopup;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarOpacityNotifier.dispose();
    _showPopupNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: const Color(0xFF1F3A5F),
                elevation: 5 * opacity,
                toolbarHeight: 90,
                leadingWidth: 200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20 * opacity),
                  ),
                ),
                leading: Row(
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
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Center(
                      child: Text(
                        "naveen2000",
                        style: TextStyle(
                          color: Colors.orange.shade300,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
                iconTheme: const IconThemeData(color: Colors.white),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 105),
                _buildSectionHeader("SYNC"),
                _buildActionCard([
                  _buildListTile(Icons.sync, "SYNC INTRANSACTION", () {}),
                  _buildDivider(),
                  _buildListTile(Icons.receipt_long, "SYNC ORDER BILL", () {}),
                  _buildDivider(),
                  _buildListTile(
                    Icons.pause_circle_outline,
                    "SYNC HOLD ITEMS",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    Icons.shopping_cart,
                    "SYNC PURCHASE BILL",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    Icons.assignment_return,
                    "SYNC PURCHASE RETURN BILL",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(Icons.payments, "SYNC EXPENSE", () {}),
                ]),

                _buildSectionHeader("REFRESH"),
                _buildActionCard([
                  _buildListTile(Icons.contacts, "REFRESH CASH PARTY", () {}),
                  _buildDivider(),
                  _buildListTile(
                    Icons.inventory,
                    "REFRESH PRODUCT AND PARTY",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    Icons.pause_circle_outline,
                    "REFRESH HOLD ITEMS",
                    () {},
                  ),
                ]),

                _buildSectionHeader("UPLOAD"),
                _buildActionCard([
                  _buildListTile(Icons.upload, "UPLOAD", () {}),
                  _buildDivider(),
                  _buildListTile(Icons.person_add, "UPLOAD SUPPLIER", () {}),
                  _buildDivider(),
                  _buildListTile(
                    Icons.add_shopping_cart,
                    "UPLOAD PRODUCT",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(Icons.location_on, "UPLOAD GPS", () {}),
                ]),

                _buildSectionHeader("DATABASE"),
                _buildActionCard([
                  _buildListTile(Icons.save_alt, "DATABASE EXPORT", () {}),
                  _buildDivider(),
                  _buildListTile(
                    Icons.open_in_browser,
                    "DATABASE IMPORT",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(
                    Icons.cloud_upload,
                    "EXPORT DB TO CLOUD",
                    () {},
                  ),
                  _buildDivider(),
                  _buildListTile(Icons.storage, "EXPORT DB2", () {}),
                ]),

                _buildSectionHeader("SETTINGS"),
                _buildActionCard([
                  SwitchListTile(
                    secondary: const Icon(Icons.wifi, color: Color(0xFF1F3A5F)),
                    title: const Text(
                      "IS ONLINE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    value: isOnline,
                    activeColor: const Color(0xFF1F3A5F),
                    onChanged: (v) => setState(() => isOnline = v),
                  ),
                  _buildDivider(),
                  SwitchListTile(
                    secondary: const Icon(
                      Icons.print,
                      color: Color(0xFF1F3A5F),
                    ),
                    title: const Text(
                      "PRINT RECEIPT WITH INVOICE",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    value: printReceipt,
                    activeColor: const Color(0xFF1F3A5F),
                    onChanged: (v) => setState(() => printReceipt = v),
                  ),
                ]),

                _buildSectionHeader("PRINTER"),
                _buildActionCard([
                  ...printers.map((printer) {
                    return Column(
                      children: [
                        RadioListTile<String>(
                          title: Text(
                            printer,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          value: printer,
                          groupValue: selectedPrinter,
                          activeColor: const Color(0xFF1F3A5F),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedPrinter = value!;
                            });
                          },
                        ),
                        if (printer != printers.last) _buildDivider(),
                      ],
                    );
                  }).toList(),
                ]),

                _buildSectionHeader("LANGUAGE"),
                _buildActionCard([
                  RadioListTile<String>(
                    title: const Text(
                      "English",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: "English",
                    groupValue: selectedLanguage,
                    activeColor: const Color(0xFF1F3A5F),
                    onChanged: (v) => setState(() => selectedLanguage = v!),
                  ),
                  _buildDivider(),
                  RadioListTile<String>(
                    title: const Text(
                      "Arabic",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    value: "Arabic",
                    groupValue: selectedLanguage,
                    activeColor: const Color(0xFF1F3A5F),
                    onChanged: (v) => setState(() => selectedLanguage = v!),
                  ),
                ]),

                _buildSectionHeader("SYSTEM"),
                _buildActionCard([
                  _buildListTile(
                    Icons.admin_panel_settings,
                    "ADMIN PANEL",
                    () => Navigator.pushNamed(context, '/adminpanel'),
                    color: Colors.green.shade700,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    Icons.logout,
                    "SIGN OUT",
                    () {},
                    color: const Color(0xFFFF7043),
                  ),
                ]),

                const SizedBox(height: 20), // Space for search bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey[700],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildActionCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF1F3A5F)).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? const Color(0xFF1F3A5F), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: color ?? Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 0.5, color: Colors.grey[200]);
  }
}
