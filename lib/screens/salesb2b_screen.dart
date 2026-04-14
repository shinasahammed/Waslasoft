import 'package:flutter/material.dart';
import 'package:waslasoft/models/sales_data_model.dart';
import 'package:waslasoft/services/sales_data_service.dart';
import 'package:waslasoft/models/expense_data_model.dart';
import 'package:waslasoft/services/expense_data_service.dart';
import 'package:waslasoft/screens/sales_summary_screen.dart';
import 'package:waslasoft/widgets/customer_party_dialog.dart';
import '../services/app_config.dart';
import '../widgets/select_party_dialog.dart';
import '../storage/sales_storage.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:waslasoft/widgets/discount_dialog.dart';

class Salesscreen extends StatefulWidget {
  const Salesscreen({super.key});

  @override
  State<Salesscreen> createState() => _SalesscreenState();
}

class _SalesscreenState extends State<Salesscreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  List<SaleItem> tasKitem = [];
  bool isLoading = false;
  String _selectedCategory = "All";
  Expensedatamodel? _selectedParty;
  bool _isSearchVisible = false;
  final Map<int, int> _cartQuantities = {};
  final Map<int, bool> _cartUnits = {};

  double get _totalAmount {
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      try {
        final item = tasKitem.firstWhere(
          (element) => (element.itemId ?? element.id) == itemId,
        );
        total += (double.tryParse(item.price ?? '0') ?? 0) * qty;
      } catch (e) {
        debugPrint("Item not found: $itemId");
      }
    });
    return total;
  }

  double get _totalVat {
    if (!AppConfig.isTaxEnabled) return 0.0;
    double total = 0;
    _cartQuantities.forEach((itemId, qty) {
      try {
        final item = tasKitem.firstWhere(
          (element) => (element.itemId ?? element.id) == itemId,
        );
        total += (double.tryParse(item.taxAmount ?? '0') ?? 0) * qty;
      } catch (e) {
        debugPrint("Item not found: $itemId");
      }
    });
    return total;
  }

  int get _totalItems =>
      _cartQuantities.values.fold(0, (sum, qty) => sum + qty);

  void _updateQuantity(SaleItem item, int newQuantity) {
    final id = item.itemId ?? item.id;
    if (id == null) return;
    setState(() {
      if (newQuantity <= 0) {
        _cartQuantities.remove(id);
        _cartUnits.remove(id);
      } else {
        _cartQuantities[id] = newQuantity;
        if (!_cartUnits.containsKey(id)) {
          _cartUnits[id] = true; // Default to PCS
        }
      }
    });
  }

  void _updateUnit(SaleItem item, bool isPcs) {
    final id = item.itemId ?? item.id;
    if (id == null) return;
    setState(() {
      _cartUnits[id] = isPcs;
    });
  }

  final List<String> _categories = [
    "All",
    "Beverages",
    "Snacks",
    "Dairy",
    "Electronics",
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchTask();
  }

  Future<void> fetchTask() async {
    // 1. Try to load from cache first
    try {
      final cachedItems = await SalesStorage.getSalesItems();
      if (cachedItems.isNotEmpty) {
        setState(() {
          tasKitem = cachedItems;
          isLoading = false;
        });
        // Data found in cache, return early without calling API
        return;
      }
    } catch (e) {
      debugPrint("Cache Load Error: $e");
    }

    // 2. Fetch fresh data from API ONLY if cache is empty
    setState(() => isLoading = true);

    try {
      final freshItems = await SalesDataService().fetchData();
      if (freshItems.isNotEmpty) {
        setState(() {
          tasKitem = freshItems;
        });
        // 3. Save to cache for subsequent opens
        await SalesStorage.saveSalesItems(freshItems);
      }
    } catch (e) {
      debugPrint("API Fetch Error: $e");
      if (tasKitem.isEmpty) {
        showMessage("Failed to load products. Please check your connection.");
      }
    }

    setState(() => isLoading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
      backgroundColor: const Color(0xFFF5F7FA),
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
                              "Sales B2B",
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
                                builder: (context) => SelectcustomerPartyDialog(
                                  onRefresh: () =>
                                      ExpenseDataService().fetchData(),
                                ),
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
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  _selectedParty?.name ?? "Select Party",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          Container(
                            height: 40,
                            width: 110,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                isExpanded: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                                items: _categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCategory = newValue!;
                                  });
                                },
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
                    padding: EdgeInsets.only(right: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSearchVisible = !_isSearchVisible;
                                    });
                                  },
                                  child: const Center(
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 18,
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
                ],
              ),
            );
          },
        ),
      ),
      body: CustomRefreshIndicator(
          onRefresh: () async {
          await SalesStorage.clearCache();
          await fetchTask();
        },
          builder:
            (
              BuildContext context,
              Widget child,
              IndicatorController controller,
            ) {
              return AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final double opacity = controller.value.clamp(0.0, 1.0);
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      if (!controller.isIdle)
                        Positioned(
                          top: 120 + (40.0 * controller.value),
                          child: Column(
                            children: [
                              Opacity(
                                opacity: opacity,
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF1F3A5F,
                                        ).withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: CircularProgressIndicator(
                                    value: controller.isLoading
                                        ? null
                                        : controller.value,
                                    strokeWidth: 3,
                                    valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFF1F3A5F),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Opacity(
                                opacity: (opacity - 0.5).clamp(0, 1) * 2,
                                child: Text(
                                  controller.isLoading
                                      ? "Refreshing"
                                      : (controller.value >= 1.0
                                            ? "Release to refresh"
                                            : "Pull down to refresh"),
                                  style: const TextStyle(
                                    color: Color(0xFF1F3A5F),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(0, 100.0 * controller.value),
                        child: child,
                      ),
                    ],
                  );
                },
              );
            },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 160),
        
              if (_isSearchVisible)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearchVisible = false;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ),
        
              // Party Details Section
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
                                  _selectedParty == null
                                      ? "Customer Not Selected"
                                      : (_selectedParty?.name ?? "Unknown"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  _selectedParty == null
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
        
              // Categories Section
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryItem("ALL PRODUCTS", isSelected: true),
                    _buildCategoryItem("BEVERAGES"),
                    _buildCategoryItem("SNACKS"),
                    _buildCategoryItem("DAIRY"),
                    _buildCategoryItem("ELECTRONICS"),
                  ],
                ),
              ),
        
              // Product Grid Placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: CircularProgressIndicator(),
                      )
                    : tasKitem.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Text("No products found"),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.only(top: 15),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                        itemCount: tasKitem.length,
                        itemBuilder: (context, index) {
                          final item = tasKitem[index];
                          return ProductCardWidget(
                            name: item.product ?? "Unnamed Product",
                            price: "₹${item.price ?? '0'}",
                            stock: item.qty ?? "0",
                            taxPercentage: item.taxPercentage ?? "0",
                            taxAmount: item.taxAmount ?? "0",
                            initialQuantity:
                                _cartQuantities[item.itemId ?? item.id] ?? 0,
                            initialIsPcs:
                                _cartUnits[item.itemId ?? item.id] ?? true,
                            onQuantityChanged: (newQty) =>
                                _updateQuantity(item, newQty),
                            onUnitChanged: (isPcs) => _updateUnit(item, isPcs),
                          );
                        },
                      ),
              ),
        
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomCartBar(),
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

  Widget _buildCategoryItem(String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1F3A5F) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey[300]!,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCartBar() {
    return Container(
      height: 130,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$_totalItems Items | ₹${(_totalAmount + _totalVat).toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Net: ${_totalAmount.toStringAsFixed(2)}| VAT: ${_totalVat.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (_selectedParty == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a customer first"),
                        backgroundColor: Color(0xFF1F3A5F),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  if (_cartQuantities.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cart is empty"),
                        backgroundColor: Color(0xFF1F3A5F),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  // Find items currently in cart
                  final cartItems = tasKitem.where((item) {
                    final id = item.itemId ?? item.id;
                    return _cartQuantities.containsKey(id);
                  }).toList();

                  final discountResult = await showDialog<double>(
                    context: context,
                    builder: (context) => DiscountDialog(
                      maxAmount: _totalAmount + _totalVat,
                    ),
                  );

                  if (discountResult != null) {
                    // Navigate to Summary Screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesSummaryScreen(
                          items: cartItems,
                          initialQuantities: _cartQuantities,
                          initialUnits: _cartUnits,
                          selectedParty: _selectedParty,
                          discountAmount: discountResult,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB74D),
                  foregroundColor: Colors.black87,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  minimumSize: const Size(100, 45),
                ),
                child: const Text(
                  "CONFIRM INVOICE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _cartQuantities.clear();
                    _cartUnits.clear();
                    _selectedParty = null;
                  });
                  showMessage("Cart cleared");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    "CLEAR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductCardWidget extends StatefulWidget {
  final String name;
  final String price;
  final String stock;
  final String taxPercentage;
  final String taxAmount;
  final int initialQuantity;
  final bool initialIsPcs;
  final Function(int) onQuantityChanged;
  final Function(bool) onUnitChanged;

  const ProductCardWidget({
    super.key,
    required this.name,
    required this.price,
    required this.stock,
    required this.taxPercentage,
    required this.taxAmount,
    required this.initialQuantity,
    required this.initialIsPcs,
    required this.onQuantityChanged,
    required this.onUnitChanged,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool isPcs = true;

  void _toggleUnit() {
    widget.onUnitChanged(!widget.initialIsPcs);
  }

  void _increment() {
    final maxStock = double.tryParse(widget.stock)?.toInt() ?? 0;
    if (widget.initialQuantity < maxStock) {
      widget.onQuantityChanged(widget.initialQuantity + 1);
    }
  }

  void _decrement() {
    if (widget.initialQuantity > 0) {
      widget.onQuantityChanged(widget.initialQuantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Tap functionality
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    "assets/images/image.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F3A5F).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Stock: ${widget.stock}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F3A5F),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                          color: Color(0xFF1F3A5F),
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: _toggleUnit,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F4F8),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "pcs",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: widget.initialIsPcs
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: widget.initialIsPcs
                                          ? const Color(0xFF1F3A5F)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.swap_horiz,
                                    size: 10,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "kg",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: !widget.initialIsPcs
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: !widget.initialIsPcs
                                          ? const Color(0xFF1F3A5F)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (AppConfig.isTaxEnabled) ...[
                    const SizedBox(height: 4),
                    Text(
                      "(${widget.taxPercentage}%)0.00+0.00=${widget.taxAmount}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _decrement,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Color(0xFF1F3A5F),
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "${widget.initialQuantity}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: _increment,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1F3A5F),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
