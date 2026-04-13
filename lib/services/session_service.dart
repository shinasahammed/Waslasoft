import '../models/expense_data_model.dart';

class SessionService {
  static Expensedatamodel? pendingPaymentParty;
  static double? pendingPaymentAmount;

  /// Sets or adds to the transaction data for automatic pre-filling of the next Payment entry.
  /// If the party is the same as the existing one, the amount is added.
  static void setPendingPayment(Expensedatamodel? party, double amount) {
    bool isSameParty = false;
    if (pendingPaymentParty != null && party != null) {
      if (pendingPaymentParty!.expenseId != null && party.expenseId != null) {
        isSameParty = pendingPaymentParty!.expenseId == party.expenseId;
      } else {
        isSameParty = pendingPaymentParty!.name == party.name;
      }
    }

    if (isSameParty) {
      pendingPaymentAmount = (pendingPaymentAmount ?? 0) + amount;
    } else {
      pendingPaymentParty = party;
      pendingPaymentAmount = amount;
    }
  }

  /// Clears any pending transaction data.
  static void clearPendingPayment() {
    pendingPaymentParty = null;
    pendingPaymentAmount = null;
  }
}
