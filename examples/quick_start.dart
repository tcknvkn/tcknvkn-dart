/// -----------------------------------------------------------------------------
/// Proje: tcknvkn-dart
/// Dosya: examples/quick_start.dart
/// Açıklama: Dart doğrulama kütüphanesi için temel kullanım örneğini içerir.
/// Oluşturma Tarihi: 2026-04-24
/// Lisans: MIT
/// Site: https://www.tcknvkn.com
/// -----------------------------------------------------------------------------
import 'package:tcknvkn/tcknvkn.dart';

void main() {
  final tcknResult = validateTckn('10000000146');
  final vknResult = validateVkn('1000036109');

  print('TCKN geçerli: ${tcknResult.valid} | değer: ${tcknResult.value}');
  print('VKN geçerli: ${vknResult.valid} | değer: ${vknResult.value}');
}