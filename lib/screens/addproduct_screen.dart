import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();

  // State variables for dropdowns
  String _selectedCategory = "NIL";
  String _baseUnit = "KG";
  String _secUnit = "KG";
  String _thirdUnit = "KG";
  String _outlet = "MAIN";
  String _type = "FINISHED GOODS";

  final Color _primaryBlue = const Color(0xFF1F3A5F);
  final Color _bgSubtle = const Color(0xFFF1F5F9);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final newOpacity = (1.0 - (offset / 100)).clamp(0.0, 1.0);
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
      backgroundColor: _bgSubtle,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ValueListenableBuilder<double>(
          valueListenable: _appBarOpacityNotifier,
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: AppBar(
                backgroundColor: _primaryBlue,
                elevation: 5 * opacity,
                toolbarHeight: 70,
                leadingWidth: 250,
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
                              "Add Product",
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
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 30),
        child: Column(
          children: [
            // Section 1: Basic Information
            _buildUniqueCard(
              title: "Basic Information",
              icon: Icons.info_outline,
              child: Column(
                children: [
                  _buildPremiumField(
                    label: "Item Name",
                    hint: "Enter product name",
                    icon: Icons.shopping_cart,
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumField(
                    label: "Arabic Name",
                    hint: "اسم المنتج",
                    icon: Icons.language,
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumDropdown(
                    label: "Category",
                    value: _selectedCategory,
                    items: ["NIL", "Beverages", "Snacks"],
                    icon: Icons.category,
                    onChanged: (v) => setState(() => _selectedCategory = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumField(
                          label: "Prefix",
                          hint: "0",
                          icon: Icons.tag,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildPremiumField(
                          label: "Item Code",
                          hint: "798022004",
                          icon: Icons.qr_code,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: Base Unit
            _buildUniqueCard(
              title: "Base Unit & Rates",
              icon: Icons.scale,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumDropdown(
                          label: "Base Unit",
                          value: _baseUnit,
                          items: ["KG", "PCS"],
                          icon: Icons.unfold_more,
                          onChanged: (v) => setState(() => _baseUnit = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Cost Rate",
                          hint: "0.00",
                          icon: Icons.add_card,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Retail Rate",
                          hint: "0.00",
                          icon: Icons.sell,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumField(
                          label: "Wholesale",
                          hint: "0.00",
                          icon: Icons.groups,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "3rd Rate",
                          hint: "0.00",
                          icon: Icons.add_card,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 3: Secondary Unit
            _buildUniqueCard(
              title: "Secondary Unit",
              icon: Icons.layers_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumDropdown(
                          label: "Sec Unit",
                          value: _secUnit,
                          items: ["KG", "PCS", "LTR"],
                          icon: Icons.unfold_more,
                          onChanged: (v) => setState(() => _secUnit = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Cost",
                          hint: "0.00",
                          icon: Icons.add_card,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Retail",
                          hint: "0.00",
                          icon: Icons.sell,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildPremiumField(
                          label: "Sec Barcode",
                          hint: "Enter",
                          icon: Icons.qr_code_2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Pack",
                          hint: "1",
                          icon: Icons.inventory,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 4: Third Unit
            _buildUniqueCard(
              title: "Third Unit",
              icon: Icons.view_module_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumDropdown(
                          label: "3rd Unit",
                          value: _thirdUnit,
                          items: ["KG", "PCS", "LTR"],
                          icon: Icons.unfold_more,
                          onChanged: (v) => setState(() => _thirdUnit = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Cost",
                          hint: "0.00",
                          icon: Icons.add_card,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Retail",
                          hint: "0.00",
                          icon: Icons.sell,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildPremiumField(
                          label: "Barcode",
                          hint: "Enter",
                          icon: Icons.qr_code_2,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Pack",
                          hint: "1",
                          icon: Icons.inventory,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 5: Inventory & Analytics
            _buildUniqueCard(
              title: "Inventory & Tax",
              icon: Icons.analytics_outlined,
              child: Column(
                children: [
                  _buildPremiumField(
                    label: "Sec Wholesale Rate",
                    hint: "0.00",
                    icon: Icons.price_change,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumDropdown(
                    label: "W.H/Outlet",
                    value: _outlet,
                    items: ["MAIN", "WAREHOUSE 1"],
                    icon: Icons.warehouse,
                    onChanged: (v) => setState(() => _outlet = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumField(
                          label: "Stock",
                          hint: "0",
                          icon: Icons.inventory_2,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Rack",
                          hint: "N/A",
                          icon: Icons.shelves,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPremiumField(
                          label: "Discount %",
                          hint: "0",
                          icon: Icons.percent,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPremiumField(
                          label: "Sales Tax",
                          hint: "15%",
                          icon: Icons.receipt_long,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumField(
                    label: "Purchase Tax",
                    hint: "15%",
                    icon: Icons.receipt,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildPremiumDropdown(
                    label: "Type",
                    value: _type,
                    items: ["FINISHED GOODS", "RAW MATERIAL"],
                    icon: Icons.category_rounded,
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Distinctive Save Button
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                color: Color(0xFFFFB74D),
                boxShadow: [
                  BoxShadow(
                    color: _primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(30),
                child: const Center(
                  child: Text(
                    "SAVE PRODUCT",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUniqueCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryBlue, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: _primaryBlue,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildPremiumField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: _bgSubtle.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!, width: 1.5),
          ),
          child: TextFormField(
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
              prefixIcon: Icon(
                icon,
                size: 18,
                color: _primaryBlue.withValues(alpha: 0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: _bgSubtle.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[200]!, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: _primaryBlue),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
