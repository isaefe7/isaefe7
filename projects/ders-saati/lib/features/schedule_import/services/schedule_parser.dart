import 'dart:typed_data';

import '../models/parsed_schedule.dart';
import 'csv_schedule_parser.dart';
import 'json_schedule_parser.dart';
import 'xml_schedule_parser.dart';
import 'xls_schedule_parser.dart';

enum ScheduleFileFormat { xls, csv, json, xml }

class ScheduleParser {
  ScheduleParser({
    XlsScheduleParser? xlsParser,
    CsvScheduleParser? csvParser,
    JsonScheduleParser? jsonParser,
    XmlScheduleParser? xmlParser,
  }) : _xlsParser = xlsParser ?? XlsScheduleParser(),
       _csvParser = csvParser ?? CsvScheduleParser(),
       _jsonParser = jsonParser ?? JsonScheduleParser(),
       _xmlParser = xmlParser ?? XmlScheduleParser();

  final XlsScheduleParser _xlsParser;
  final CsvScheduleParser _csvParser;
  final JsonScheduleParser _jsonParser;
  final XmlScheduleParser _xmlParser;

  // ÇÖZÜM: 'xlsx' uzantısı desteklenenler listesine eklendi
  static const supportedExtensions = ['xls', 'xlsx', 'csv', 'json', 'xml'];

  static ScheduleFileFormat? formatFromExtension(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'xls':
      case 'xlsx': // ÇÖZÜM: Hem xls hem xlsx aynı okuyucuya yönlendirildi
        return ScheduleFileFormat.xls;
      case 'csv':
        return ScheduleFileFormat.csv;
      case 'json':
        return ScheduleFileFormat.json;
      case 'xml':
        return ScheduleFileFormat.xml;
      default:
        return null;
    }
  }

  ParsedSchedule parseBytes(Uint8List bytes, ScheduleFileFormat format) {
    switch (format) {
      case ScheduleFileFormat.xls:
        return _xlsParser.parseBytes(bytes);
      case ScheduleFileFormat.csv:
        return _csvParser.parseBytes(bytes);
      case ScheduleFileFormat.json:
        return _jsonParser.parseBytes(bytes);
      case ScheduleFileFormat.xml:
        return _xmlParser.parseBytes(bytes);
    }
  }

  ParsedSchedule parseFile(String fileName, Uint8List bytes) {
    final extension = fileName.contains('.') ? fileName.split('.').last : null;
    final format = formatFromExtension(extension);
    if (format == null) {
      throw FormatException(
        'Desteklenmeyen dosya türü. Kabul edilen uzantılar: ${supportedExtensions.join(', ')}',
      );
    }

    return parseBytes(bytes, format);
  }
}
