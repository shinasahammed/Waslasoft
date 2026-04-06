// To parse this JSON data, do
//
//     final expenseentrymodel = expenseentrymodelFromJson(jsonString);

import 'dart:convert';

List<Expenseentrymodel> expenseentrymodelFromJson(String str) => List<Expenseentrymodel>.from(json.decode(str).map((x) => Expenseentrymodel.fromJson(x)));

String expenseentrymodelToJson(List<Expenseentrymodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expenseentrymodel {
    int? expenseEntryId;
    String? createdBy;
    String? paymentMethod;
    String? clientCode;
    String? amount;
    String? narration;
    DateTime? createdAt;
    bool? isCreated;
    bool? isUpdated;
    bool? isCreateSync;
    bool? isUpdateSync;
    int? expense;

    Expenseentrymodel({
        this.expenseEntryId,
        this.createdBy,
        this.paymentMethod,
        this.clientCode,
        this.amount,
        this.narration,
        this.createdAt,
        this.isCreated,
        this.isUpdated,
        this.isCreateSync,
        this.isUpdateSync,
        this.expense,
    });

    factory Expenseentrymodel.fromJson(Map<String, dynamic> json) => Expenseentrymodel(
        expenseEntryId: json["expense_entry_id"],
        createdBy: json["created_by"],
        paymentMethod: json["payment_method"],
        clientCode: json["client_code"],
        amount: json["amount"],
        narration: json["narration"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isCreated: json["is_created"],
        isUpdated: json["is_updated"],
        isCreateSync: json["is_create_sync"],
        isUpdateSync: json["is_update_sync"],
        expense: json["expense"],
    );

    Map<String, dynamic> toJson() => {
        "expense": expense,
        "payment_method": paymentMethod,
        "amount": amount,
        "narration": narration,
    };
}
