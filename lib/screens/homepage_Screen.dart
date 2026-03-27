import 'package:flutter/material.dart';
import 'settings_screen.dart';
import '../services/app_config.dart';

class Homeepage extends StatefulWidget {
  const Homeepage({super.key});

  @override
  State<Homeepage> createState() => _HomeepageState();
}

class _HomeepageState extends State<Homeepage> {
  bool isOnline = AppConfig.isTaxEnabled;
  bool showPopup = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!showPopup) {
          setState(() => showPopup = true);
        }
      } else {
        if (showPopup) {
          setState(() => showPopup = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff183e6d),
        toolbarHeight: 90,
        elevation: 5,
        leadingWidth: 140,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Text(
              "MPOS ERP",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
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

              const SizedBox(width: 6),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "WaslaSoft",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'orbitron',
                      ),
                    ),
                    Text(
                      "Activated",
                      style: TextStyle(
                        color: Color(0xff1975bb),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        actions: [
          Row(
            children: [
              Text(
                isOnline ? "Tax Enabled" : "Tax Disabled",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: isOnline,
                  onChanged: (value) {
                    setState(() {
                      isOnline = value;
                      AppConfig.isTaxEnabled = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureItem(
                          icon: Icons.business_center,
                          label: "Sales B2B",
                          onTap: () {
                            Navigator.pushNamed(context, '/salesB2B');
                          },
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.shopping_basket,
                          label: "Order",
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.shopping_bag,
                          label: "Sales B2C",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureItem(
                          icon: Icons.account_balance_wallet,
                          label: "Expenses",
                          onTap: () {
                            Navigator.pushNamed(context, '/expense');
                          },
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.assignment_return,
                          label: "Sales Return",
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.payments,
                          label: "Payments",
                          onTap: () {
                            Navigator.pushNamed(context, '/paymentsign');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureItem(
                          icon: Icons.add_shopping_cart,
                          label: "Add Product",
                          onTap: () {
                            Navigator.pushNamed(context, '/listproduct');
                          },
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.shopping_cart,
                          label: "Purchase",
                          onTap: () {
                            Navigator.pushNamed(context, '/purchase');
                          },
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.receipt_long,
                          label: "Receipt",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureItem(
                          icon: Icons.analytics,
                          label: "Reports",
                          onTap: () {
                            Navigator.pushNamed(context, '/reports');
                          },
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.man,
                          label: "Master",
                          onTap: () {
                            Navigator.pushNamed(context, "/listparty");
                          },
                        ),

                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.search,
                          label: "Market Survey",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureItem(
                          icon: Icons.swap_horiz,
                          label: "In Transaction",
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.inventory,
                          label: "Take Stock",
                        ),
                        _DividerLine(),
                        _FeatureItem(
                          icon: Icons.category,
                          label: "Add Category",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const _FeatureItem(
                          icon: Icons.question_answer,
                          label: "Enquiry/order",
                        ),
                        const _DividerLine(),
                        const _FeatureItem(
                          icon: Icons.menu_book,
                          label: "Cash book",
                        ),
                        const _DividerLine(),
                        _FeatureItem(
                          icon: Icons.settings,
                          label: "Settings",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const _BottomdividerLine(),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const _FeatureItem(
                          icon: Icons.qr_code_2,
                          label: "ZATCA",
                        ),
                        const _DividerLine(),
                        const _FeatureItem(
                          icon: Icons.pause_circle_outline,
                          label: "Hold Items",
                        ),
                        const _DividerLine(),
                        const _FeatureItem(
                          icon: Icons.assignment_return,
                          label: "Purchase Return",
                        ),
                      ],
                    ),

                    AnimatedSlide(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      offset: showPopup ? Offset.zero : const Offset(0, 0.3),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: showPopup ? 1 : 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 190,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xff183e6d),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 10),
                            ],
                          ),

                          child: Row(
                            children: [
                              /// LEFT SIDE (Avatars)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _Avathar(
                                            resource:
                                                Icons.admin_panel_settings,
                                            text: "Admin",
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/adminpanel',
                                              );
                                            },
                                          ),
                                          _Avathar(
                                            resource: Icons.more_horiz,
                                            text: "Others",
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _Avathar(
                                            resource: Icons.list_alt,
                                            text: "Catalogue",
                                            onTap: () {},
                                          ),
                                          _Avathar(
                                            resource: Icons.settings,
                                            text: "Settings",
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SettingsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// CENTER VERTICAL LINE
                              Container(
                                width: 1.5,
                                height: double.infinity,
                                color: Colors.black45,
                              ),

                              /// RIGHT SIDE (Text Section)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "IS ONLINE",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: const [
                                          Text(
                                            "Today Sales:",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "0.0K",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _Avathar(
                                            resource: Icons.upload,
                                            text: "Upload",
                                            onTap: () {},
                                          ),
                                          _Avathar(
                                            resource: Icons.help_outline,
                                            text: "Help",
                                            onTap: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              bottom: showPopup ? -80 : 20,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showPopup ? 0 : 1,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search features...",
                      hintStyle: TextStyle(color: Colors.black, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Color(0xff183e6d)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback? onTap;

  const _FeatureItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: icon is IconData
                ? Icon(icon, color: const Color(0xff183e6d), size: 28)
                : Image.asset(
                    icon as String,
                    height: 28,
                    width: 28,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(height: 40, width: 1, color: Colors.white24);
  }
}

class _BottomdividerLine extends StatelessWidget {
  const _BottomdividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, width: double.infinity, color: Colors.white24);
  }
}

class _Avathar extends StatelessWidget {
  final dynamic resource;
  final String text;
  final VoidCallback? onTap;

  const _Avathar({required this.resource, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: resource is IconData
                ? Icon(resource as IconData, color: Colors.white, size: 28)
                : ClipOval(
                    child: Image.asset(
                      resource as String,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 10, color: Colors.white)),
        ],
      ),
    );
  }
}
