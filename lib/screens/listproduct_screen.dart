import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waslasoft/models/purchase_model.dart';
import 'package:waslasoft/services/purchase_service.dart';

class ListProductScreen extends StatefulWidget {
  const ListProductScreen({super.key});

  @override
  State<ListProductScreen> createState() => _ListProductScreenState();
}

class _ListProductScreenState extends State<ListProductScreen> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier<double>(
    1.0,
  );
  final ScrollController _scrollController = ScrollController();
  bool _isSearchVisible = false;

  final Color _primaryBlue = const Color(0xFF1F3A5F);

  final Color _accentColor = const Color(0xFF3B82F6);
  List<Purchasemodel> tasKitem = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchTask();
  }

  Future<void> fetchTask() async {
    setState(() => isLoading = true);

    try {
      tasKitem = await PurchaseService().fetchData();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        showMessage("Server Error");
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
                              "List product",
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
                            onTap: () {
                              Navigator.pushNamed(context, '/addproduct');
                            },
                            child: Container(
                              height: 40,
                              width: 130,
                              margin: const EdgeInsets.only(left: 45),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: Text(
                                  "Add new Product",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
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
                                  child: FaIcon(
                                    FontAwesomeIcons.solidFileExcel,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10),

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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Padding for the transparent AppBar
            const SizedBox(height: 160),

            // Search Bar (Optional visibility)
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Product...",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: _primaryBlue.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 30,
                    child: Text(
                      "#",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      "P.id",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Text(
                      "Product Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "Stock",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product List Items
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(50),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : tasKitem.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(50),
                      child: Center(child: Text("No products found")),
                    )
                  : Column(
                      children: List.generate(tasKitem.length, (index) {
                        final product = tasKitem[index];
                        final double stock =
                            double.tryParse(product.currentStock.toString()) ??
                            0.0;
                        final isLowStock = stock <= 5;
                        final isNegative = stock < 0;

                        return Column(
                          children: [
                            if (index > 0)
                              const Divider(
                                height: 2,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0xFFF1F5F9),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              product.id.toString(),
                                              style: TextStyle(
                                                color: _accentColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: _accentColor
                                                    .withValues(alpha: 0.3),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                product.itemName.isNotEmpty
                                                    ? product.itemName
                                                    : "No Name",
                                                style: TextStyle(
                                                  color: _primaryBlue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.2,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      stock.toStringAsFixed(2),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: isNegative
                                            ? Colors.redAccent
                                            : (isLowStock
                                                  ? Colors.orange
                                                  : Colors.green[600]),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
