import '../models/expense_data_model.dart';
import '../models/purchase_data_model.dart' as purchase;
import '../models/purchase_return_model.dart' as p_return;

class SessionService {
  static Expensedatamodel? pendingPaymentParty;
  static double? pendingPaymentAmount;
  static bool isReturnPayment = false;
  static purchase.Datum? pendingPurchase;
  static p_return.Datum? pendingPurchaseReturn;

  /// Sets or adds to the transaction data for automatic pre-filling of the next Payment entry.
  /// If the party is the same as the existing one, the amount is added.
  static void setPendingPayment(
    Expensedatamodel? party,
    double amount, {
    bool isReturn = false,
    purchase.Datum? purchaseRecord,
    p_return.Datum? purchaseReturnRecord,
  }) {
    bool isSameParty = false;
    if (pendingPaymentParty != null && party != null) {
      if (pendingPaymentParty!.expenseId != null && party.expenseId != null) {
        isSameParty = pendingPaymentParty!.expenseId == party.expenseId;
      } else {
        isSameParty = pendingPaymentParty!.name == party.name;
      }
    }

    if (isSameParty && isReturnPayment == isReturn) {
      pendingPaymentAmount = (pendingPaymentAmount ?? 0) + amount;
      if (purchaseRecord != null) pendingPurchase = purchaseRecord;
      if (purchaseReturnRecord != null) {
        pendingPurchaseReturn = purchaseReturnRecord;
      }
    } else {
      pendingPaymentParty = party;
      pendingPaymentAmount = amount;
      isReturnPayment = isReturn;
      pendingPurchase = purchaseRecord;
      pendingPurchaseReturn = purchaseReturnRecord;
    }
  }

  /// Clears any pending transaction data.
  static void clearPendingPayment() {
    pendingPaymentParty = null;
    pendingPaymentAmount = null;
    isReturnPayment = false;
    pendingPurchase = null;
    pendingPurchaseReturn = null;
  }
}
