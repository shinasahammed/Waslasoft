import 'package:flutter/material.dart';
import 'package:waslasoft/screens/addproduct_screen.dart';
import 'package:waslasoft/screens/homepage_Screen.dart';
import 'package:waslasoft/screens/listproduct_screen.dart';
import 'package:waslasoft/screens/paymentsign_screen.dart';
import 'package:waslasoft/screens/purchase_return_screen.dart';
import 'package:waslasoft/screens/purchase_screen.dart';
import 'package:waslasoft/screens/reports/item_wise_sale_report_screen.dart';
import 'package:waslasoft/screens/reports/purchase_return_report_screen.dart';
import 'package:waslasoft/screens/reports/sales_report_screen.dart';
import 'package:waslasoft/screens/reports/sales_return_report_screen.dart';
import 'package:waslasoft/screens/reports/order_report_screen.dart';
import 'package:waslasoft/screens/reports/receipt_report_screen.dart';
import 'package:waslasoft/screens/reports/expense_report_screen.dart';
import 'package:waslasoft/screens/reports/intrans_report_screen.dart';
import 'package:waslasoft/screens/reports/payment_report_screen.dart';
import 'package:waslasoft/screens/reports/intrans_ledger_report_screen.dart';
import 'package:waslasoft/screens/reports/purchase_report_screen.dart';
import 'package:waslasoft/screens/reports/outstanding_balance_report_screen.dart';
import 'package:waslasoft/screens/reports/stock_report_screen.dart';
import 'package:waslasoft/screens/reports/tax_summary_report_screen.dart';
import 'package:waslasoft/screens/reports/auditing_report_screen.dart';
import 'package:waslasoft/screens/sales_return_screen.dart';
import 'package:waslasoft/screens/salesb2b_screen.dart';
import 'package:waslasoft/screens/settings_screen.dart';
import 'package:waslasoft/screens/admin_panel_screen.dart';
import 'package:waslasoft/screens/listparty_screen.dart';
import 'package:waslasoft/screens/addparty_screen.dart';
import 'package:waslasoft/screens/editparty_screen.dart';
import 'package:waslasoft/screens/reports/report_screen.dart';
import 'package:waslasoft/screens/reports/ledger_report_screen.dart';
import 'package:waslasoft/screens/reports/holding_report_screen.dart';
import 'package:waslasoft/screens/reports/market_survey_report_screen.dart';
import 'package:waslasoft/screens/reports/pnl_report_screen.dart';
import 'package:waslasoft/screens/expense_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const Homeepage(),
        '/settings': (_) => const SettingsScreen(),
        '/adminpanel': (_) => const AdminPanelScreen(),
        '/salesB2B': (_) => const Salesscreen(),
        '/salesReturn': (_) => const Salesreturnscreen(),
        '/purchase': (_) => const PurchaseScreen(),
        '/purchasereturn': (_) => const PurchaseReturnScreen(),
        '/addproduct': (_) => const AddProductScreen(),
        '/listproduct': (_) => const ListProductScreen(),
        '/paymentsign': (_) => const PaymentsignScreen(),
        '/listparty': (_) => const ListPartyScreen(),
        '/addparty': (_) => const AddPartyScreen(),
        '/editparty': (_) => const EditPartyScreen(),
        '/reports': (_) => const ReportScreen(),
        '/ledgerReport': (_) => const LedgerReportScreen(),
        '/outstandingBalanceReport': (_) =>
            const OutstandingBalanceReportScreen(),
        '/intransReport': (_) => const IntransReportScreen(),
        '/paymentReport': (_) => const PaymentReportScreen(),
        '/expenseReport': (_) => const ExpenseReportScreen(),
        '/salesReport': (_) => const SalesReportScreen(),
        '/orderReport': (_) => const OrderReportScreen(),
        '/receiptReport': (_) => const ReceiptReportScreen(),
        '/purchaseReport': (_) => const PurchaseReportScreen(),
        '/stockReport': (_) => const StockReportScreen(),
        '/auditingReport': (_) => const AuditingReportScreen(),
        '/marketSurveyReport': (_) => const MarketSurveyReportScreen(),
        '/holdingReport': (_) => const HoldingReportScreen(),
        '/purchaseReturnReport': (_) => const PurchaseReturnReportScreen(),
        '/itemWiseSaleReport': (_) => const ItemWiseSaleReportScreen(),
        '/pnlReport': (_) => const PNLReportScreen(),
        '/salesReturnReport': (_) => const SalesReturnReportScreen(),
        '/intransLedger': (_) => const IntransLedgerReportScreen(),
        '/taxSummary': (_) => const TaxSummaryReportScreen(),
        '/expense': (_) => const ExpenseScreen(),
      },
    );
  }
}
