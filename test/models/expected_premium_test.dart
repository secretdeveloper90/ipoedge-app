import 'package:flutter_test/flutter_test.dart';
import 'package:ipo_edge/models/ipo.dart';

void main() {
  group('ExpectedPremium', () {
    test('should handle non-null range correctly', () {
      const expectedPremium = ExpectedPremium(
        range: '32-34',
        note: 'Test note',
      );

      expect(expectedPremium.displayRange, equals('32-34'));
      expect(expectedPremium.hasRange, isTrue);
    });

    test('should handle null range with fallback', () {
      const expectedPremium = ExpectedPremium(
        range: null,
        note: 'Test note',
      );

      expect(expectedPremium.displayRange, equals('-'));
      expect(expectedPremium.hasRange, isFalse);
    });

    test('should handle empty range with fallback', () {
      const expectedPremium = ExpectedPremium(
        range: '',
        note: 'Test note',
      );

      expect(expectedPremium.displayRange, equals(''));
      expect(expectedPremium.hasRange, isFalse);
    });

    test('should create from JSON with valid range', () {
      final json = {
        'range': '240-250',
        'note': 'Expected Premium provided is derived from market rumors.',
      };

      final expectedPremium = ExpectedPremium.fromJson(json);

      expect(expectedPremium.range, equals('240-250'));
      expect(expectedPremium.displayRange, equals('240-250'));
      expect(expectedPremium.hasRange, isTrue);
      expect(expectedPremium.note, equals('Expected Premium provided is derived from market rumors.'));
    });

    test('should create from JSON with null range', () {
      final json = {
        'range': null,
        'note': 'Expected Premium provided is derived from market rumors.',
      };

      final expectedPremium = ExpectedPremium.fromJson(json);

      expect(expectedPremium.range, isNull);
      expect(expectedPremium.displayRange, equals('-'));
      expect(expectedPremium.hasRange, isFalse);
      expect(expectedPremium.note, equals('Expected Premium provided is derived from market rumors.'));
    });

    test('should convert to JSON correctly', () {
      const expectedPremium = ExpectedPremium(
        range: '89-91',
        note: 'Test note',
      );

      final json = expectedPremium.toJson();

      expect(json['range'], equals('89-91'));
      expect(json['note'], equals('Test note'));
    });

    test('should convert to JSON with null range', () {
      const expectedPremium = ExpectedPremium(
        range: null,
        note: 'Test note',
      );

      final json = expectedPremium.toJson();

      expect(json['range'], isNull);
      expect(json['note'], equals('Test note'));
    });
  });
}
