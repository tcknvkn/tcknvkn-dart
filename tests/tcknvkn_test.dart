/// -----------------------------------------------------------------------------
/// Proje: tcknvkn-dart
/// Dosya: tests/tcknvkn_test.dart
/// Açıklama: TCKN ve VKN doğrulama fonksiyonları için birim test senaryolarını içerir.
/// Oluşturma Tarihi: 2026-04-24
/// Lisans: MIT
/// Site: https://www.tcknvkn.com
/// -----------------------------------------------------------------------------
import 'package:test/test.dart';
import 'package:tcknvkn/tcknvkn.dart';

void main() {
  group('validateTckn', () {
    test('geçerli TCKN kabul edilir', () {
      final result = validateTckn('10000000146');
      expect(result.valid, isTrue);
      expect(result.value, '10000000146');
      expect(result.errors, isEmpty);
    });

    test('formatlı TCKN normalize edilerek doğrulanır', () {
      final result = validateTckn('100-000 00146');
      expect(result.valid, isTrue);
      expect(result.value, '10000000146');
    });

    test('uzunluk hatası döner', () {
      final result = validateTckn('12345');
      expect(result.valid, isFalse);
      expect(result.errors, contains('11 haneli olmalıdır.'));
    });

    test('ilk hane sıfır hatası döner', () {
      final result = validateTckn('01234567890');
      expect(result.valid, isFalse);
      expect(result.errors, contains('İlk hane 0 olamaz.'));
    });

    test('10. hane checksum hatası yakalanır', () {
      final result = validateTckn('10000000156');
      expect(result.valid, isFalse);
      expect(result.errors, contains('10. hane kontrol hanesi hatalı.'));
    });

    test('11. hane checksum hatası yakalanır', () {
      final result = validateTckn('10000000145');
      expect(result.valid, isFalse);
      expect(result.errors, contains('11. hane kontrol hanesi hatalı.'));
    });

    test('aynı haneli değer reddedilir', () {
      final result = validateTckn('11111111111');
      expect(result.valid, isFalse);
      expect(result.errors, contains('Geçersiz örüntü: tüm haneler aynı.'));
    });
  });

  group('validateMultipleTckn', () {
    test('toplu doğrulamada sıra korunur', () {
      final results = validateMultipleTckn([
        '10000000146',
        '10000000145',
        '11111111111',
        '100-000 00146',
      ]);
      expect(results.length, 4);
      expect(results[0].valid, isTrue);
      expect(results[1].valid, isFalse);
      expect(results[2].valid, isFalse);
      expect(results[3].valid, isTrue);
    });
  });

  group('validateVkn', () {
    test('geçerli VKN kabul edilir', () {
      final result = validateVkn('1000036109');
      expect(result.valid, isTrue);
      expect(result.value, '1000036109');
      expect(result.errors, isEmpty);
    });

    test('formatlı VKN normalize edilerek doğrulanır', () {
      final result = validateVkn('100-003-6109');
      expect(result.valid, isTrue);
      expect(result.value, '1000036109');
    });

    test('uzunluk hatası döner', () {
      final result = validateVkn('1234');
      expect(result.valid, isFalse);
      expect(result.errors, contains('10 haneli olmalıdır.'));
    });

    test('checksum hatası yakalanır', () {
      final result = validateVkn('1000036108');
      expect(result.valid, isFalse);
      expect(result.errors, contains('Son hane kontrol hanesi hatalı.'));
    });

    test('aynı haneli değer reddedilir', () {
      final result = validateVkn('1111111111');
      expect(result.valid, isFalse);
      expect(result.errors, contains('Geçersiz örüntü: tüm haneler aynı.'));
    });
  });

  group('validateMultipleVkn', () {
    test('toplu doğrulamada sıra korunur', () {
      final results = validateMultipleVkn([
        '1000036109',
        '1000036108',
        '1111111111',
        '100-003-6109',
      ]);
      expect(results.length, 4);
      expect(results[0].valid, isTrue);
      expect(results[1].valid, isFalse);
      expect(results[2].valid, isFalse);
      expect(results[3].valid, isTrue);
    });
  });
}