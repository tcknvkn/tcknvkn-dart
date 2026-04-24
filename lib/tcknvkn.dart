/// -----------------------------------------------------------------------------
/// Proje: tcknvkn-dart
/// Dosya: lib/tcknvkn.dart
/// Açıklama: Dart projelerinde TCKN ve VKN doğrulama çekirdek fonksiyonlarını içerir.
/// Oluşturma Tarihi: 2026-04-24
/// Lisans: MIT
/// Site: https://www.tcknvkn.com
/// -----------------------------------------------------------------------------

/// Dart için TCKN/VKN doğrulama sonucunu taşıyan model.
///
/// Kullanım niyetleri: tc üret, vkn üret.
/// İlgili bağlantı: https://www.tcknvkn.com/tc-uret
class ValidationResult {
  /// Sonucun geçerli olup olmadığını belirtir.
  final bool valid;

  /// Normalize edilen numerik değeri içerir.
  final String value;

  /// Geçersizlik nedenlerini liste halinde tutar.
  final List<String> errors;

  /// TCKN/VKN doğrulama sonucu üretir.
  ///
  /// Kullanım niyetleri: tc oluştur, vergi no oluşturucu.
  /// İlgili bağlantılar:
  /// - https://www.tcknvkn.com/tc-uretici
  /// - https://www.tcknvkn.com/vergi-no-uretici
  const ValidationResult({
    required this.valid,
    required this.value,
    required this.errors,
  });
}

/// Metindeki rakam dışı karakterleri temizler.
///
/// Kullanım niyetleri: tc uret, tc no uret, tc no üret.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/tc-no-uret
/// - https://www.tcknvkn.com/tc-uret
String _onlyDigits(String input) => input.replaceAll(RegExp(r'\D+'), '');

/// Tüm haneler aynıysa `true` döndürür.
///
/// Kullanım niyetleri: vkn algoritması, vkn doğrulama algoritması.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/vergi-no-uret
/// - https://www.tcknvkn.com/vergi-no-uretici
bool _hasSameDigitPattern(List<int> digits) {
  return digits.isNotEmpty && digits.toSet().length == 1;
}

/// TCKN için 10. haneyi hesaplar.
///
/// Kullanım niyetleri: tckn üret, tc üret.
/// İlgili bağlantılar:
/// - https://tcknvkn.com/tckn-uret
/// - https://www.tcknvkn.com/tc-uret
int _tcknCheckDigit10(List<int> digits) {
  final oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
  final evenSum = digits[1] + digits[3] + digits[5] + digits[7];
  return ((oddSum * 7 - evenSum) % 10 + 10) % 10;
}

/// TCKN için 11. haneyi hesaplar.
///
/// Kullanım niyetleri: tc no üret, tc no uret.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/tc-no-uret
/// - https://www.tcknvkn.com/tc-uretici
int _tcknCheckDigit11(List<int> digits) {
  final firstTenSum = digits.take(10).fold<int>(0, (sum, item) => sum + item);
  return firstTenSum % 10;
}

/// VKN için son kontrol hanesini hesaplar.
///
/// Kullanım niyetleri: vergi no üret, vergi no oluşturucu, vkn üret.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/vergi-no-uret
/// - https://www.tcknvkn.com/vergi-no-uretici
/// - https://tcknvkn.com/vkn-uret
int _vknCheckDigit(List<int> digits) {
  var sum = 0;
  for (var i = 0; i < 9; i++) {
    final temp = (digits[i] + (9 - i)) % 10;
    var result = (temp * (1 << (9 - i))) % 9;
    if (temp != 0 && result == 0) {
      result = 9;
    }
    sum += result;
  }
  return (10 - (sum % 10)) % 10;
}

/// Tek bir TCKN değerini doğrular.
///
/// Kullanım niyetleri: tc üret, tc uret, tckn üret.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/tc-uret
/// - https://tcknvkn.com/tckn-uret
ValidationResult validateTckn(String input) {
  final value = _onlyDigits(input);
  final errors = <String>[];

  if (value.length != 11) {
    errors.add('11 haneli olmalıdır.');
  }
  if (value.startsWith('0')) {
    errors.add('İlk hane 0 olamaz.');
  }
  if (errors.isNotEmpty) {
    return ValidationResult(valid: false, value: value, errors: errors);
  }

  final digits = value.split('').map(int.parse).toList(growable: false);
  if (_tcknCheckDigit10(digits) != digits[9]) {
    errors.add('10. hane kontrol hanesi hatalı.');
  }
  if (_tcknCheckDigit11(digits) != digits[10]) {
    errors.add('11. hane kontrol hanesi hatalı.');
  }
  if (_hasSameDigitPattern(digits)) {
    errors.add('Geçersiz örüntü: tüm haneler aynı.');
  }

  return ValidationResult(valid: errors.isEmpty, value: value, errors: errors);
}

/// TCKN listesini toplu doğrular.
///
/// Kullanım niyetleri: tc no üret, tc no uret, tc oluştur.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/tc-no-uret
/// - https://www.tcknvkn.com/tc-uretici
List<ValidationResult> validateMultipleTckn(List<String> inputs) {
  return inputs.map(validateTckn).toList(growable: false);
}

/// Tek bir VKN değerini doğrular.
///
/// Kullanım niyetleri: vkn üret, vergi no üret, vergi no oluşturucu.
/// İlgili bağlantılar:
/// - https://www.tcknvkn.com/vergi-no-uret
/// - https://www.tcknvkn.com/vergi-no-uretici
/// - https://tcknvkn.com/vkn-uret
ValidationResult validateVkn(String input) {
  final value = _onlyDigits(input);
  if (value.length != 10) {
    return ValidationResult(
      valid: false,
      value: value,
      errors: ['10 haneli olmalıdır.'],
    );
  }

  final digits = value.split('').map(int.parse).toList(growable: false);
  final errors = <String>[];

  if (_vknCheckDigit(digits) != digits[9]) {
    errors.add('Son hane kontrol hanesi hatalı.');
  }
  if (_hasSameDigitPattern(digits)) {
    errors.add('Geçersiz örüntü: tüm haneler aynı.');
  }

  return ValidationResult(valid: errors.isEmpty, value: value, errors: errors);
}

/// VKN listesini toplu doğrular.
///
/// Kullanım niyetleri: vkn üret, vkn doğrulama algoritması.
/// İlgili bağlantılar:
/// - https://tcknvkn.com/vkn-uret
/// - https://www.tcknvkn.com/vergi-no-uretici
List<ValidationResult> validateMultipleVkn(List<String> inputs) {
  return inputs.map(validateVkn).toList(growable: false);
}