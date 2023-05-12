import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/Extensions/StringExtensions.dart';

import '../main.dart';
import '../model/CurrentRequestModel.dart';
import '../model/RiderModel.dart';
import '../utils/Common.dart';
import '../utils/Constants.dart';

generateInvoiceCall(RiderModel? riderModel, {Payment? payment}) async {
  List<InvoiceItem> list = [
    InvoiceItem(
      product: '',
      description: language.basePrice,
      price: riderModel!.baseFare!.toString(),
    ),
    InvoiceItem(
      product: '',
      description: language.distancePrice,
      price: riderModel.perDistanceCharge!.toString(),
    ),
    InvoiceItem(
      product: '',
      description: language.duration,
      price: riderModel.perMinuteDriveCharge!.toString(),
    ),
    InvoiceItem(
      product: '',
      description: language.waitTime,
      price: riderModel.perMinuteWaitingCharge!.toString(),
    ),
    InvoiceItem(
      product: '',
      description: language.tip,
      price: payment!.driverTips!.toString(),
    ),
    if (riderModel.extraCharges!.isNotEmpty)
      InvoiceItem(
        product: '',
        description: language.extraCharges,
        price: '',
      ),
    if (riderModel.couponDiscount != 0)
      InvoiceItem(
        product: '',
        description: language.couponDiscount,
        price: '${riderModel.couponDiscount.toString()}',
        isDiscount: false,
      ),
  ];

  if (riderModel.extraCharges != null)
    riderModel.extraCharges!.forEach((element) {
      list.add(
        InvoiceItem(
          product: '',
          description: element.key.validate(),
          price: element.value!.toString(),
        ),
      );
    });

  final invoice = Invoice(
    supplier: Supplier(name: PDF_NAME, address: PDF_ADDRESS, contactNumber: PDF_CONTACT_NUMBER),
    customer: Customer(name: '${riderModel.riderName!}', sourceAddress: '${riderModel.startAddress.validate()}', destinationAddress: '${riderModel.endAddress.validate()}'),
    info: InvoiceInfo(
      number: '${riderModel.id}',
      invoiceDate: DateTime.now(),
      orderedDate: DateTime.parse(riderModel.createdAt!).toLocal(),
    ),
    items: list,
    totalAmount: payment.driverTips != 0 ? riderModel.subtotal! + payment.driverTips!.toDouble() : riderModel.subtotal!.toDouble(),
    paymentType: riderModel.paymentType.validate(),
    paymentStatus: riderModel.paymentStatus.validate(),
  );

  final pdfFile = await PdfInvoiceApi.generate(invoice);

  PdfApi.openFile(pdfFile);
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    String path;
    if (Platform.isAndroid) {
      Directory? directory = await getExternalStorageDirectory();
      path = directory!.path;
    } else if (Platform.isIOS) {
      Directory directory = await getApplicationDocumentsDirectory();
      path = directory.path;
    } else {
      throw "Unsupported platform";
    }
    final file = File('$path/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document(
      theme: ThemeData.withFont(fontFallback: [
        await PdfGoogleFonts.hindRegular(),
        await PdfGoogleFonts.iBMPlexSansArabicRegular(),
        await PdfGoogleFonts.notoSansSymbols2Regular(),
        await PdfGoogleFonts.beVietnamProRegular(),
        await PdfGoogleFonts.robotoRegular(),
      ]),
    );

    pdf.addPage(MultiPage(
      build: (context) => [
        buildTitle(invoice),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildHeader(invoice),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Invoice_${invoice.info.number}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language.customerName, style: TextStyle(color: PdfColors.blue)),
            SizedBox(height: 4),
            Text('${invoice.customer.name}'),
            SizedBox(height: 16),
            Text(language.sourceLocation, style: TextStyle(color: PdfColors.blue)),
            SizedBox(height: 4),
            Text('${invoice.customer.sourceAddress}'),
            SizedBox(height: 4),
            Text(language.destinationLocation, style: TextStyle(color: PdfColors.blue)),
            SizedBox(height: 4),
            Text('${invoice.customer.destinationAddress}'),
            SizedBox(height: 16),
            Text('${language.paymentType}: ${invoice.paymentType}'),
            SizedBox(height: 4),
            Text('${language.paymentStatus}: ${invoice.paymentStatus}'),
          ],
        ),
      ),
      Spacer(),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${language.invoiceNo} ${invoice.info.number}'),
        Text('${language.invoiceDate} ${Utils.formatDate(invoice.info.invoiceDate)}'),
        Text('${language.orderedDate} ${Utils.formatDate(invoice.info.orderedDate)}'),
      ]),
    ]);
  }

  static Widget buildTitle(Invoice invoice) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: PdfColors.blue),
          ),
          pw.Text('${invoice.supplier.name}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      SizedBox(height: 4),
      pw.Text('${invoice.supplier.address}', style: TextStyle(fontSize: 16)),
      SizedBox(height: 4),
      pw.Text('${invoice.supplier.contactNumber}', style: TextStyle(fontSize: 16)),
    ]);
  }

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Product', 'Description', 'Price'];
    final data = invoice.items.map((item) {
      return [
        item.product,
        item.description,
        item.isDiscount
            ? item.price.isNotEmpty
                ? '${printAmount(item.price)}'
                : ''
            : item.price.isNotEmpty
                ? '-${printAmount(item.price)}'
                : '',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2 * PdfPageFormat.mm),
                buildText(
                  title: 'Total',
                  value: Utils.formatPrice(invoice.totalAmount),
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'Address', value: invoice.supplier.address),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: unite ? style : null)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}

class Utils {
  static formatPrice(double price) => price.toString();

  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class Customer {
  final String name;
  final String sourceAddress;
  final String destinationAddress;

  const Customer({
    required this.name,
    required this.sourceAddress,
    required this.destinationAddress,
  });
}

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;
  final double totalAmount;
  final String paymentType;
  final String paymentStatus;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
    required this.totalAmount,
    required this.paymentType,
    required this.paymentStatus,
  });
}

class InvoiceInfo {
  final String number;
  final DateTime orderedDate;
  final DateTime invoiceDate;

  const InvoiceInfo({
    required this.number,
    required this.orderedDate,
    required this.invoiceDate,
  });
}

class InvoiceItem {
  final String product;
  final String description;
  final String price;
  final bool isDiscount;

  const InvoiceItem({
    required this.product,
    required this.description,
    required this.price,
    this.isDiscount = true,
  });
}

class Supplier {
  final String name;
  final String address;
  final String contactNumber;

  const Supplier({
    required this.name,
    required this.address,
    required this.contactNumber,
  });
}
