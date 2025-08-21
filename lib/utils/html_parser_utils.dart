import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import '../models/ipo.dart';

class HtmlParserUtils {
  /// Parses HTML financial table and returns a list of Financial objects
  static List<Financial> parseFinancialTable(String htmlContent) {
    if (htmlContent.isEmpty) return [];

    try {
      // Parse the HTML content
      final document = html_parser.parse(htmlContent);

      // Find the table element
      final table = document.querySelector('table');
      if (table == null) return [];

      // Get all table rows
      final rows = table.querySelectorAll('tr');
      if (rows.length < 2) return []; // Need at least header + 1 data row

      // Parse header row to understand column structure
      final headerRow = rows.first;
      final headerCells = headerRow.querySelectorAll('td');

      // Map column indices
      final columnMap = <String, int>{};
      for (int i = 0; i < headerCells.length; i++) {
        final cellText = headerCells[i].text.trim().toLowerCase();
        if (cellText.contains('period')) {
          columnMap['period'] = i;
        } else if (cellText.contains('revenue from operations')) {
          columnMap['revenue'] = i;
        } else if (cellText.contains('net profit')) {
          columnMap['profit'] = i;
        } else if (cellText.contains('cash flow from operations')) {
          columnMap['cashFlow'] = i;
        } else if (cellText.contains('free cash flow')) {
          columnMap['freeCashFlow'] = i;
        } else if (cellText.contains('margins')) {
          columnMap['margins'] = i;
        }
      }

      // Parse data rows
      final financials = <Financial>[];
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        final cells = row.querySelectorAll('td');

        if (cells.length < headerCells.length) continue;

        // Extract year/period
        final yearIndex = columnMap['period'] ?? 0;
        final year = cells[yearIndex].text.trim();
        if (year.isEmpty) continue;

        // Extract financial values
        final revenue =
            _parseFinancialValue(cells, columnMap['revenue'], 'revenue');
        final profit =
            _parseFinancialValue(cells, columnMap['profit'], 'profit');
        final cashFlow =
            _parseFinancialValue(cells, columnMap['cashFlow'], 'cashFlow');
        final freeCashFlow = _parseFinancialValue(
            cells, columnMap['freeCashFlow'], 'freeCashFlow');
        final margins =
            _parseFinancialValue(cells, columnMap['margins'], 'margins');

        financials.add(Financial(
          year: year,
          revenue: revenue,
          profit: profit,
          cashFlowFromOperations: cashFlow,
          freeCashFlow: freeCashFlow,
          margins: margins,
        ));
      }

      return financials;
    } catch (e) {
      return [];
    }
  }

  /// Helper method to parse financial values from table cells
  static double? _parseFinancialValue(
      List<dom.Element> cells, int? columnIndex, String fieldName) {
    if (columnIndex == null || columnIndex >= cells.length) return null;

    final cellText = cells[columnIndex].text.trim();
    if (cellText.isEmpty || cellText == '-') return null;

    try {
      // Handle percentage values (for margins)
      if (fieldName == 'margins' && cellText.contains('%')) {
        final numericPart = cellText.replaceAll('%', '').trim();
        return double.tryParse(numericPart);
      }

      // Handle regular numeric values
      // Remove common formatting characters
      final cleanText = cellText
          .replaceAll(',', '')
          .replaceAll('₹', '')
          .replaceAll('Rs', '')
          .replaceAll('crore', '')
          .replaceAll('Cr', '')
          .trim();

      return double.tryParse(cleanText);
    } catch (e) {
      return null;
    }
  }

  /// Parses a simple HTML table and returns structured data
  static Map<String, List<Map<String, String>>> parseGenericTable(
      String htmlContent) {
    if (htmlContent.isEmpty) return {};

    try {
      final document = html_parser.parse(htmlContent);
      final tables = document.querySelectorAll('table');

      final result = <String, List<Map<String, String>>>{};

      for (int tableIndex = 0; tableIndex < tables.length; tableIndex++) {
        final table = tables[tableIndex];
        final rows = table.querySelectorAll('tr');

        if (rows.isEmpty) continue;

        // Get headers from first row
        final headerRow = rows.first;
        final headers = headerRow
            .querySelectorAll('td, th')
            .map((cell) => cell.text.trim())
            .toList();

        if (headers.isEmpty) continue;

        // Parse data rows
        final tableData = <Map<String, String>>[];
        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          final cells = row.querySelectorAll('td, th');

          final rowData = <String, String>{};
          for (int j = 0; j < headers.length && j < cells.length; j++) {
            rowData[headers[j]] = cells[j].text.trim();
          }

          if (rowData.isNotEmpty) {
            tableData.add(rowData);
          }
        }

        result['table_$tableIndex'] = tableData;
      }

      return result;
    } catch (e) {
      return {};
    }
  }
}
