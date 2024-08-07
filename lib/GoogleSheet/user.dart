class Fields {
  static final String id = 'Id';
  static final String barcode = 'Barcode';
  static final String datetime = 'Datetime';
  static final String company = 'Company';

  static List<String> getFields() => [id, barcode, datetime, company];
}

class QR {
  final int? id;
  final String barcode;
  final String datetime;
  final String company;

  const QR({
    this.id,
    required this.barcode,
    required this.datetime,
    required this.company,
  });

  QR copy({
    int? id,
    String? barcode,
    String? datetime,
    String? company,
  }) =>
      QR(
          id: id ?? this.id,
          barcode: barcode ?? this.barcode,
          datetime: datetime ?? this.datetime,
          company: company ?? this.company);

  Map<String, dynamic> toJson() => {
        Fields.id: id,
        Fields.barcode: barcode,
        Fields.datetime: datetime,
        Fields.company: company,
      };
}
