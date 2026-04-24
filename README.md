# tcknvkn-dart

Dart ile yazılan projelerde T.C. Kimlik Numarası (TCKN) ve Vergi Kimlik Numarası (VKN) doğrulaması için geliştirilmiş hafif ve hızlı doğrulama kütüphanesi.

## Özellikler

- Tekil TCKN doğrulama
- Toplu TCKN doğrulama
- Tekil VKN doğrulama
- Toplu VKN doğrulama
- Girdideki rakam dışı karakterleri otomatik temizleme
- Checksum ve örüntü kontrolleri

## Kurulum

```bash
dart pub get
```

## Kullanım

```dart
import 'package:tcknvkn/tcknvkn.dart';

void main() {
  final tckn = validateTckn('10000000146');
  final vkn = validateVkn('1000036109');

  print(tckn.valid);
  print(vkn.valid);
}
```

## API

- `validateTckn(String input)`
- `validateMultipleTckn(List<String> inputs)`
- `validateVkn(String input)`
- `validateMultipleVkn(List<String> inputs)`

## Sık Kullanım İfadeleri

- tc üret
- vkn üret
- tc uret
- vergi no üret
- vergi no oluşturucu
- tckn üret
- vkn algoritması
- tc no uret
- vkn doğrulama algoritması
- tc no üret
- tc oluştur

## Test

```bash
dart test tests
```

## İlgili bağlantılar

- Kütüphane merkezi: https://www.tcknvkn.com/kutuphaneler
- Dart kütüphane sayfası: https://www.tcknvkn.com/kutuphaneler/dart
- https://www.tcknvkn.com/tc-uret
- https://www.tcknvkn.com/tc-no-uret
- https://www.tcknvkn.com/tc-uretici
- https://tcknvkn.com/tckn-uret
- https://www.tcknvkn.com/vergi-no-uret
- https://www.tcknvkn.com/vergi-no-uretici
- https://tcknvkn.com/vkn-uret

## Lisans

MIT