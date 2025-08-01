import 'package:flutter_test/flutter_test.dart';
import 'package:ipo_edge/services/ipo_service.dart';

void main() {
  group('IPOService', () {
    late IPOService ipoService;

    setUp(() {
      ipoService = IPOService();
    });

    test('should load all IPOs without errors', () async {
      final ipos = await ipoService.getAllIPOs();

      expect(ipos, isNotEmpty);
      expect(ipos.length, greaterThan(0));

      // Verify that all IPOs have valid expected premium data
      for (final ipo in ipos) {
        expect(ipo.expectedPremium, isNotNull);
        expect(ipo.expectedPremium.note, isNotEmpty);
        // Range can be null, but displayRange should always return a string
        expect(ipo.expectedPremium.displayRange, isA<String>());
      }
    });

    test('should handle IPOs with null expected premium range', () async {
      final ipos = await ipoService.getAllIPOs();

      // Find IPOs with null range (there should be some in the mock data)
      final iposWithNullRange =
          ipos.where((ipo) => !ipo.expectedPremium.hasRange).toList();

      expect(iposWithNullRange, isNotEmpty,
          reason: 'Should have some IPOs with null expected premium range');

      for (final ipo in iposWithNullRange) {
        expect(ipo.expectedPremium.displayRange, equals('-'));
        expect(ipo.expectedPremium.hasRange, isFalse);
      }
    });

    test('should handle IPOs with valid expected premium range', () async {
      final ipos = await ipoService.getAllIPOs();

      // Find IPOs with valid range
      final iposWithValidRange =
          ipos.where((ipo) => ipo.expectedPremium.hasRange).toList();

      expect(iposWithValidRange, isNotEmpty,
          reason: 'Should have some IPOs with valid expected premium range');

      for (final ipo in iposWithValidRange) {
        expect(ipo.expectedPremium.range, isNotNull);
        expect(ipo.expectedPremium.range, isNotEmpty);
        expect(ipo.expectedPremium.displayRange,
            equals(ipo.expectedPremium.range));
        expect(ipo.expectedPremium.hasRange, isTrue);
      }
    });

    test('should load IPOs by category without errors', () async {
      final mainboardIpos = await ipoService.getIPOsByCategory('mainboard');
      final smeIpos = await ipoService.getIPOsByCategory('sme');

      expect(mainboardIpos, isNotEmpty);
      expect(smeIpos, isNotEmpty);

      // Verify expected premium data for both categories
      for (final ipo in [...mainboardIpos, ...smeIpos]) {
        expect(ipo.expectedPremium, isNotNull);
        expect(ipo.expectedPremium.displayRange, isA<String>());
      }
    });

    test('should search IPOs without errors', () async {
      final searchResults = await ipoService.searchIPOs('Gold');

      expect(searchResults, isNotEmpty);

      // Verify expected premium data for search results
      for (final ipo in searchResults) {
        expect(ipo.expectedPremium, isNotNull);
        expect(ipo.expectedPremium.displayRange, isA<String>());
      }
    });
  });
}
