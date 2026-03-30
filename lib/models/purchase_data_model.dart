// To parse this JSON data, do
//
//     final purchasedatamodel = purchasedatamodelFromJson(jsonString);

import 'dart:convert';

Purchasedatamodel purchasedatamodelFromJson(String str) => Purchasedatamodel.fromJson(json.decode(str));

String purchasedatamodelToJson(Purchasedatamodel data) => json.encode(data.toJson());

class Purchasedatamodel {
    int? statuscode;
    String? title;
    List<Datum>? data;
    dynamic errors;
    String? message;

    Purchasedatamodel({
        this.statuscode,
        this.title,
        this.data,
        this.errors,
        this.message,
    });

    factory Purchasedatamodel.fromJson(Map<String, dynamic> json) => Purchasedatamodel(
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
    int? tmpId;
    String? companyName;
    int? companyId;
    dynamic invSequence;
    String? clientCode;
    bool? isCreated;
    bool? isUpdated;
    bool? isCreateSync;
    bool? isUpdateSync;
    DateTime? createdAt;
    int? orderId;
    String? orderNo;
    dynamic orderTrnNo;
    DateTime? purchaseDate;
    DateTime? orderDate;
    String? invoiceAmount;
    String? paymentModeCash;
    String? paymentModeCreditcard;
    String? creditTotal;
    String? grandTotal;
    String? supplier;
    String? buyer;
    DateTime? entryDate;
    dynamic receivedBy;
    dynamic billNo;
    String? supplierId;
    List<PurchaseItem>? purchaseItems;

    Datum({
        this.id,
        this.tmpId,
        this.companyName,
        this.companyId,
        this.invSequence,
        this.clientCode,
        this.isCreated,
        this.isUpdated,
        this.isCreateSync,
        this.isUpdateSync,
        this.createdAt,
        this.orderId,
        this.orderNo,
        this.orderTrnNo,
        this.purchaseDate,
        this.orderDate,
        this.invoiceAmount,
        this.paymentModeCash,
        this.paymentModeCreditcard,
        this.creditTotal,
        this.grandTotal,
        this.supplier,
        this.buyer,
        this.entryDate,
        this.receivedBy,
        this.billNo,
        this.supplierId,
        this.purchaseItems,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        tmpId: json["tmp_id"],
        companyName: json["company_name"],
        companyId: json["company_id"],
        invSequence: json["inv_sequence"],
        clientCode: json["client_code"],
        isCreated: json["is_created"],
        isUpdated: json["is_updated"],
        isCreateSync: json["is_create_sync"],
        isUpdateSync: json["is_update_sync"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        orderId: json["order_id"],
        orderNo: json["order_no"],
        orderTrnNo: json["order_trn_no"],
        purchaseDate: json["purchase_date"] == null ? null : DateTime.parse(json["purchase_date"]),
        orderDate: json["order_date"] == null ? null : DateTime.parse(json["order_date"]),
        invoiceAmount: json["invoice_amount"],
        paymentModeCash: json["payment_mode_cash"],
        paymentModeCreditcard: json["payment_mode_creditcard"],
        creditTotal: json["credit_total"],
        grandTotal: json["grand_total"],
        supplier: json["supplier"],
        buyer: json["buyer"],
        entryDate: json["entry_date"] == null ? null : DateTime.parse(json["entry_date"]),
        receivedBy: json["received_by"],
        billNo: json["bill_no"],
        supplierId: json["supplier_id"],
        purchaseItems: json["purchase_items"] == null ? [] : List<PurchaseItem>.from(json["purchase_items"]!.map((x) => PurchaseItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tmp_id": tmpId,
        "company_name": companyName,
        "company_id": companyId,
        "inv_sequence": invSequence,
        "client_code": clientCode,
        "is_created": isCreated,
        "is_updated": isUpdated,
        "is_create_sync": isCreateSync,
        "is_update_sync": isUpdateSync,
        "created_at": createdAt?.toIso8601String(),
        "order_id": orderId,
        "order_no": orderNo,
        "order_trn_no": orderTrnNo,
        "purchase_date": purchaseDate?.toIso8601String(),
        "order_date": orderDate?.toIso8601String(),
        "invoice_amount": invoiceAmount,
        "payment_mode_cash": paymentModeCash,
        "payment_mode_creditcard": paymentModeCreditcard,
        "credit_total": creditTotal,
        "grand_total": grandTotal,
        "supplier": supplier,
        "buyer": buyer,
        "entry_date": entryDate?.toIso8601String(),
        "received_by": receivedBy,
        "bill_no": billNo,
        "supplier_id": supplierId,
        "purchase_items": purchaseItems == null ? [] : List<dynamic>.from(purchaseItems!.map((x) => x.toJson())),
    };
}

class PurchaseItem {
    int? id;
    int? orderDetId;
    int? orderId;
    int? itemId;
    dynamic itemCode;
    String? product;
    String? packageName;
    String? clientCode;
    String? price;
    String? discountPercentage;
    String? discount;
    String? qty;
    String? returnQty;
    String? itemPrice;
    String? subtotal;
    String? subPrice;
    String? taxPercentage;
    String? taxAmount;
    dynamic enteredBy;
    DateTime? entryDate;
    dynamic arabicName;
    bool? isEnabledTax;

    PurchaseItem({
        this.id,
        this.orderDetId,
        this.orderId,
        this.itemId,
        this.itemCode,
        this.product,
        this.packageName,
        this.clientCode,
        this.price,
        this.discountPercentage,
        this.discount,
        this.qty,
        this.returnQty,
        this.itemPrice,
        this.subtotal,
        this.subPrice,
        this.taxPercentage,
        this.taxAmount,
        this.enteredBy,
        this.entryDate,
        this.arabicName,
        this.isEnabledTax,
    });

    factory PurchaseItem.fromJson(Map<String, dynamic> json) => PurchaseItem(
        id: json["id"],
        orderDetId: json["order_det_id"],
        orderId: json["order_id"],
        itemId: json["item_id"],
        itemCode: json["item_code"],
        product: json["product"],
        packageName: json["package_name"],
        clientCode: json["client_code"],
        price: json["price"],
        discountPercentage: json["discount_percentage"],
        discount: json["discount"],
        qty: json["qty"],
        returnQty: json["return_qty"],
        itemPrice: json["item_price"],
        subtotal: json["subtotal"],
        subPrice: json["sub_price"],
        taxPercentage: json["tax_percentage"],
        taxAmount: json["tax_amount"],
        enteredBy: json["entered_by"],
        entryDate: json["entry_date"] == null ? null : DateTime.parse(json["entry_date"]),
        arabicName: json["arabic_name"],
        isEnabledTax: json["is_enabled_tax"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "order_det_id": orderDetId,
        "order_id": orderId,
        "item_id": itemId,
        "item_code": itemCode,
        "product": product,
        "package_name": packageName,
        "client_code": clientCode,
        "price": price,
        "discount_percentage": discountPercentage,
        "discount": discount,
        "qty": qty,
        "return_qty": returnQty,
        "item_price": itemPrice,
        "subtotal": subtotal,
        "sub_price": subPrice,
        "tax_percentage": taxPercentage,
        "tax_amount": taxAmount,
        "entered_by": enteredBy,
        "entry_date": entryDate?.toIso8601String(),
        "arabic_name": arabicName,
        "is_enabled_tax": isEnabledTax,
    };
}
