// To parse this JSON data, do
//
//     final salesreturnmodel = salesreturnmodelFromJson(jsonString);

import 'dart:convert';

Salesreturnmodel salesreturnmodelFromJson(String str) => Salesreturnmodel.fromJson(json.decode(str));

String salesreturnmodelToJson(Salesreturnmodel data) => json.encode(data.toJson());

class Salesreturnmodel {
    int? statuscode;
    String? title;
    List<Datum>? data;
    dynamic errors;
    String? message;

    Salesreturnmodel({
        this.statuscode,
        this.title,
        this.data,
        this.errors,
        this.message,
    });

    factory Salesreturnmodel.fromJson(Map<String, dynamic> json) => Salesreturnmodel(
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
    dynamic creditTotal;
    String? grandTotal;
    dynamic cashier;
    String? salespersonName;
    DateTime? entryDate;
    int? deliveryCustomerId;
    String? name;
    dynamic billClosedBy;
    dynamic billClosedTime;
    dynamic customerBillNo;
    bool? isCreated;
    bool? isUpdated;
    bool? isCreateSync;
    bool? isUpdateSync;
    List<SalesReturnItem>? salesReturnItems;

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
        this.salespersonName,
        this.entryDate,
        this.deliveryCustomerId,
        this.name,
        this.billClosedBy,
        this.billClosedTime,
        this.customerBillNo,
        this.isCreated,
        this.isUpdated,
        this.isCreateSync,
        this.isUpdateSync,
        this.salesReturnItems,
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
        salespersonName: json["salesperson_name"],
        entryDate: json["entry_date"] == null ? null : DateTime.parse(json["entry_date"]),
        deliveryCustomerId: json["delivery_customer_id"],
        name: json["name"],
        billClosedBy: json["bill_closed_by"],
        billClosedTime: json["bill_closed_time"],
        customerBillNo: json["customer_bill_no"],
        isCreated: json["is_created"],
        isUpdated: json["is_updated"],
        isCreateSync: json["is_create_sync"],
        isUpdateSync: json["is_update_sync"],
        salesReturnItems: json["sales_return_items"] == null ? <SalesReturnItem>[] : List<SalesReturnItem>.from(json["sales_return_items"]!.map((x) => SalesReturnItem.fromJson(x))),
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
        "salesperson_name": salespersonName,
        "entry_date": entryDate?.toIso8601String(),
        "delivery_customer_id": deliveryCustomerId,
        "name": name,
        "bill_closed_by": billClosedBy,
        "bill_closed_time": billClosedTime,
        "customer_bill_no": customerBillNo,
        "is_created": isCreated,
        "is_updated": isUpdated,
        "is_create_sync": isCreateSync,
        "is_update_sync": isUpdateSync,
        "sales_return_items": salesReturnItems == null ? [] : List<dynamic>.from(salesReturnItems!.map((x) => x.toJson())),
    };
}

class SalesReturnItem {
    int? id;
    String? clientCode;
    int? itemId;
    String? packageName;
    String? discountPercentage;
    String? discount;
    String? product;
    String? returnQty;
    String? returnAmount;
    DateTime? createdAt;
    bool? isEnabledTax;
    int? saleReturn;

    SalesReturnItem({
        this.id,
        this.clientCode,
        this.itemId,
        this.packageName,
        this.discountPercentage,
        this.discount,
        this.product,
        this.returnQty,
        this.returnAmount,
        this.createdAt,
        this.isEnabledTax,
        this.saleReturn,
    });

    factory SalesReturnItem.fromJson(Map<String, dynamic> json) => SalesReturnItem(
        id: json["id"],
        clientCode: json["client_code"],
        itemId: json["item_id"],
        packageName: json["package_name"],
        discountPercentage: json["discount_percentage"],
        discount: json["discount"],
        product: json["product"],
        returnQty: json["return_qty"],
        returnAmount: json["return_amount"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        isEnabledTax: json["is_enabled_tax"],
        saleReturn: json["sale_return"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_code": clientCode,
        "item_id": itemId,
        "package_name": packageName,
        "discount_percentage": discountPercentage,
        "discount": discount,
        "product": product,
        "return_qty": returnQty,
        "return_amount": returnAmount,
        "created_at": createdAt?.toIso8601String(),
        "is_enabled_tax": isEnabledTax,
        "sale_return": saleReturn,
    };
}
