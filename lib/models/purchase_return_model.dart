// To parse this JSON data, do
//
//     final purchasereturnmodel = purchasereturnmodelFromJson(jsonString);

import 'dart:convert';

Purchasereturnmodel purchasereturnmodelFromJson(String str) => Purchasereturnmodel.fromJson(json.decode(str));

String purchasereturnmodelToJson(Purchasereturnmodel data) => json.encode(data.toJson());

class Purchasereturnmodel {
    int? statuscode;
    String? title;
    List<Datum>? data;
    dynamic errors;
    String? message;

    Purchasereturnmodel({
        this.statuscode,
        this.title,
        this.data,
        this.errors,
        this.message,
    });

    factory Purchasereturnmodel.fromJson(Map<String, dynamic> json) => Purchasereturnmodel(
        statuscode: json["statuscode"],
        title: json["title"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        errors: json["errors"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "statuscode": statuscode,
        "title": title,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "errors": errors,
        "message": message,
    };
}

class Datum {
    int? id;
    DateTime? returnDate;
    String? reason;
    String? totalReturnAmount;
    String? clientCode;
    String? companyName;
    int? companyId;
    String? invoiceAmount;
    String? paymentModeCash;
    String? paymentModeCreditcard;
    String? creditTotal;
    String? grandTotal;
    dynamic cashier;
    DateTime? entryDate;
    dynamic supplierName;
    String? buyer;
    dynamic billClosedBy;
    dynamic billClosedTime;
    dynamic customerBillNo;
    bool? isCreated;
    bool? isUpdated;
    bool? isCreateSync;
    bool? isUpdateSync;
    String? supplierId;
    List<PurchaseReturnItem>? purchaseReturnItems;

    Datum({
        this.id,
        this.returnDate,
        this.reason,
        this.totalReturnAmount,
        this.clientCode,
        this.companyName,
        this.companyId,
        this.invoiceAmount,
        this.paymentModeCash,
        this.paymentModeCreditcard,
        this.creditTotal,
        this.grandTotal,
        this.cashier,
        this.entryDate,
        this.supplierName,
        this.buyer,
        this.billClosedBy,
        this.billClosedTime,
        this.customerBillNo,
        this.isCreated,
        this.isUpdated,
        this.isCreateSync,
        this.isUpdateSync,
        this.supplierId,
        this.purchaseReturnItems,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        returnDate: json["return_date"] == null ? null : DateTime.parse(json["return_date"]),
        reason: json["reason"],
        totalReturnAmount: json["total_return_amount"],
        clientCode: json["client_code"],
        companyName: json["company_name"],
        companyId: json["company_id"],
        invoiceAmount: json["invoice_amount"],
        paymentModeCash: json["payment_mode_cash"],
        paymentModeCreditcard: json["payment_mode_creditcard"],
        creditTotal: json["credit_total"],
        grandTotal: json["grand_total"],
        cashier: json["cashier"],
        entryDate: json["entry_date"] == null ? null : DateTime.parse(json["entry_date"]),
        supplierName: json["supplier_name"],
        buyer: json["buyer"],
        billClosedBy: json["bill_closed_by"],
        billClosedTime: json["bill_closed_time"],
        customerBillNo: json["customer_bill_no"],
        isCreated: json["is_created"],
        isUpdated: json["is_updated"],
        isCreateSync: json["is_create_sync"],
        isUpdateSync: json["is_update_sync"],
        supplierId: json["supplier_id"],
        purchaseReturnItems: json["purchase_return_items"] == null ? [] : List<PurchaseReturnItem>.from(json["purchase_return_items"]!.map((x) => PurchaseReturnItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "return_date": returnDate?.toIso8601String(),
        "reason": reason,
        "total_return_amount": totalReturnAmount,
        "client_code": clientCode,
        "company_name": companyName,
        "company_id": companyId,
        "invoice_amount": invoiceAmount,
        "payment_mode_cash": paymentModeCash,
        "payment_mode_creditcard": paymentModeCreditcard,
        "credit_total": creditTotal,
        "grand_total": grandTotal,
        "cashier": cashier,
        "entry_date": entryDate?.toIso8601String(),
        "supplier_name": supplierName,
        "buyer": buyer,
        "bill_closed_by": billClosedBy,
        "bill_closed_time": billClosedTime,
        "customer_bill_no": customerBillNo,
        "is_created": isCreated,
        "is_updated": isUpdated,
        "is_create_sync": isCreateSync,
        "is_update_sync": isUpdateSync,
        "supplier_id": supplierId,
        "purchase_return_items": purchaseReturnItems == null ? [] : List<dynamic>.from(purchaseReturnItems!.map((x) => x.toJson())),
    };
}

class PurchaseReturnItem {
    int? id;
    String? clientCode;
    int? itemId;
    String? packageName;
    String? product;
    String? returnQty;
    String? returnAmount;
    DateTime? createdAt;
    bool? isEnabledTax;
    int? purchaseReturn;

    PurchaseReturnItem({
        this.id,
        this.clientCode,
        this.itemId,
        this.packageName,
        this.product,
        this.returnQty,
        this.returnAmount,
        this.createdAt,
        this.isEnabledTax,
        this.purchaseReturn,
    });

    factory PurchaseReturnItem.fromJson(Map<String, dynamic> json) => PurchaseReturnItem(
        id: json["id"],
        clientCode: json["client_code"],
        itemId: json["item_id"],
        packageName: json["package_name"],
        product: json["product"],
        returnQty: json["return_qty"],
        returnAmount: json["return_amount"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isEnabledTax: json["is_enabled_tax"],
        purchaseReturn: json["purchase_return"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_code": clientCode,
        "item_id": itemId,
        "package_name": packageName,
        "product": product,
        "return_qty": returnQty,
        "return_amount": returnAmount,
        "created_at": createdAt?.toIso8601String(),
        "is_enabled_tax": isEnabledTax,
        "purchase_return": purchaseReturn,
    };
}
