# Ders Saati

Ders Saati, Excel formatındaki ders programını okuyup ders başlangıç saatlerine göre bildirim/alarm oluşturan bir Flutter uygulamasıdır. Uygulama, ders programını manuel olarak tek tek eklemek yerine mevcut Excel dosyasını içeri aktarır, dersleri ayrıştırır ve kullanıcıya otomatik alarm planı sunar.

Bu proje özellikle mobil programlama dersi kapsamında, dosya okuma, veri ayrıştırma, zaman planlama, yerel bildirim ve çok platformlu Flutter mimarisi konularını bir arada göstermek için hazırlanmıştır.

## Projenin Amacı

Bu uygulamanın temel amacı, öğrencinin ders programını elle takip etmek zorunda kalmadan:

- Excel dosyasından dersleri okumak,
- Ders gününü ve saatini algılamak,
- Her ders için bildirim/alarm oluşturmak,
- Bildirimleri isteğe göre açıp kapatmak,
- Bildirimin dersten kaç dakika veya saat önce çalacağını ayarlamak,
- Uygulama içinde kalan süreyi canlı olarak göstermek.

Yani proje, "ders saati yaklaşınca bana haber ver" ihtiyacını otomatikleştiren bir zamanlayıcı uygulaması olarak çalışır.

## Ana Özellikler

- `.xls` uzantılı Excel dosyası yükleme
- Ders programını otomatik ayrıştırma
- Gün, ders kodu, ders adı, başlangıç ve bitiş saatlerini okuma
- Aynı dersin ardışık zaman bloklarını birleştirme
- Yerel bildirim ile haftalık tekrar eden alarm oluşturma
- Her ders için bildirimi açma/kapatma
- Bildirimin dersten önce kaç dakika/saat gösterileceğini seçme
- Test alarmı gönderme
- Sonraki alarm süresini ekranda geri sayım olarak gösterme
- Mobil ve web tarafı için ayrı alarm sesi davranışı

## Kullanıcı Akışı

Uygulamanın genel akışı çok basittir:

1. Kullanıcı ana ekrandan Excel dosyasını seçer.
2. Dosya okunur ve ders blokları ayrıştırılır.
3. Dersler için uygun bildirimler planlanır.
4. Sonuç ekranında oluşturulan alarmlar listelenir.
5. Kullanıcı isterse her dersin bildirimini açıp kapatır.
6. Kullanıcı bildirimin ne kadar önce geleceğini değiştirebilir.
7. Test alarmı ile sistemin çalışıp çalışmadığı kontrol edilebilir.

## Proje Yapısı

Proje, özellik bazlı bir klasör yapısıyla organize edilmiştir. Ana mantık `schedule_import` özelliği içinde toplanmıştır.

```text
lib/
	main.dart
	app.dart
	features/
		schedule_import/
			models/
				alarm_lesson.dart
				parsed_schedule.dart
			presentation/
				schedule_import_page.dart
				schedule_results_page.dart
			services/
				xls_schedule_parser.dart
				notification_service.dart
				alarm_sound.dart
				alarm_sound_web.dart
				alarm_sound_stub.dart
```

### Dosyaların Görevleri

- `main.dart`: Uygulamayı başlatır.
- `app.dart`: Tema, MaterialApp ve başlangıç ekranını tanımlar.
- `schedule_import_page.dart`: Excel yükleme, test alarmı ve geri sayım ekranı.
- `schedule_results_page.dart`: Ayrıştırılan dersleri listeler ve alarm ayarlarını yönetir.
- `xls_schedule_parser.dart`: Excel içeriğini okuyup ders verisine dönüştürür.
- `notification_service.dart`: Yerel bildirimleri kurar, planlar ve iptal eder.
- `alarm_sound.dart`: Platforma göre uygun alarm ses dosyasını dışa aktarır.
- `alarm_sound_web.dart`: Web için alarm sesi davranışı.
- `alarm_sound_stub.dart`: Desteklenmeyen platformlar için yedek davranış.
- `alarm_lesson.dart`: Tek bir ders alarmını temsil eden model.
- `parsed_schedule.dart`: Ayrıştırılmış program sonucunu taşıyan model.

## Mimari Mantık

Proje 3 ana katmanda düşünülebilir:

### 1. Sunum Katmanı

Kullanıcıyla görünen ekranlar burada yer alır:

- Dosya seçme ekranı
- Sonuç ekranı
- Bildirim ayarları

Bu katmanın görevi sadece kullanıcı arayüzünü göstermek ve kullanıcı etkileşimlerini toplamak.

### 2. İş Mantığı Katmanı

Bu katmanda Excel dosyasının okunması, ders bloklarının bulunması, bildirim zamanlarının hesaplanması ve haftalık tekrar eden alarmların kurulması yer alır.

### 3. Veri Katmanı

Bu katmanda ders verisini taşıyan modeller bulunur. Örneğin:

- Dersin günü
- Ders kodu
- Ders adı
- Başlangıç ve bitiş saati
- Bildirim açık mı
- Kaç dakika önce uyarı verilecek

Bu ayrım kodun daha anlaşılır ve sunumda anlatılabilir olmasını sağlar.

## Excel Dosyası Nasıl İşleniyor?

Uygulama, Excel dosyasını doğrudan `.xls` formatında bekler. Dosya seçildikten sonra şu mantık izlenir:

1. Sayfalar tek tek taranır.
2. Türkçe gün adları aranır: Pazartesi, Salı, Çarşamba, Perşembe, Cuma, Cumartesi, Pazar.
3. Gün adının altındaki satırlar ders bloğu olarak okunur.
4. Başlık satırında ders kodu, başlangıç saati, bitiş saati ve varsa ders adı bulunur.
5. Geçerli ders satırları `AlarmLesson` nesnelerine dönüştürülür.
6. Ardışık zaman dilimlerine sahip aynı dersler birleştirilir.

Bu yaklaşım sayesinde Excel’deki program yapısı otomatik olarak alarm planına çevrilmiş olur.

## Bildirim Sistemi

Bildirimler `flutter_local_notifications` paketi ile oluşturulmuştur. Ayrıca zamanlamanın doğru çalışması için `timezone` ve cihazın yerel saat dilimini okumak için `flutter_timezone` kullanılmıştır.

Bildirim sistemi şu işleri yapar:

- Uygulama açılınca bildirim altyapısını başlatır
- Android için izin ister
- Her ders için haftalık tekrar eden bildirim planlar
- Dersin başlangıç saatine göre, istenen dakika/saat öncesine alarm kurar
- Gerekirse bildirimi iptal eder

Bu yapı sayesinde kullanıcı uygulamayı kapatsa bile bildirimler planlandığı şekilde çalışır.

## Test Alarmı

Ana ekranda bir test alarmı bulunur. Bu özellik, gerçek ders programı yüklemeden sistemin çalıştığını kontrol etmek için eklenmiştir.

- Mobil cihazlarda test bildirimi yaklaşık 10 saniye sonra gönderilir.
- Web tarafında test alarmı için kısa bir gecikmeyle ses çalma davranışı kullanılır.

Bu özellik, sunum sırasında "uygulama gerçekten çalışıyor mu?" sorusunu göstermek için özellikle faydalıdır.

## Ekranlar

### Ana Ekran

Ana ekranda kullanıcı:

- Excel dosyası yükler,
- Test alarmı gönderir,
- Sonraki alarm için kalan süreyi görür,
- İşlem sonucunu durum mesajı olarak izler.

### Sonuç Ekranı

Dosya ayrıştırıldıktan sonra sonuç ekranı açılır. Bu ekranda:

- Günlere göre gruplanmış dersler listelenir,
- Her ders için bildirim anahtarı bulunur,
- Bildirimin ne kadar önce geleceği seçilir,
- Başlangıç ve bitiş saatleri gösterilir.

Bu ekran, kullanıcıya kurulan alarmları doğrulama fırsatı verir.

## Kullanılan Teknolojiler

- Flutter
- Dart
- `excel2003`
- `file_picker`
- `flutter_local_notifications`
- `flutter_timezone`
- `timezone`
- `google_fonts`

## Bağımlılıkların Rolü

- `excel2003`: `.xls` dosyalarını okumak için.
- `file_picker`: Dosya seçme işlemi için.
- `flutter_local_notifications`: Yerel bildirim ve alarm planlama için.
- `flutter_timezone`: Cihazın saat dilimini almak için.
- `timezone`: Doğru tarih/saat hesaplamaları için.
- `google_fonts`: Arayüz tipografisini daha düzenli göstermek için.

## Platform Desteği

Proje çok platformlu Flutter yapısında hazırlanmıştır. Klasörde Android, iOS, web, Windows, macOS ve Linux dizinleri bulunduğu için proje farklı platformlarda çalışabilecek şekilde yapılandırılmıştır. Uygulamanın bildirim ve alarm davranışı platforma göre farklılık gösterebilir.

## Kurulum ve Çalıştırma

### Gereksinimler

- Flutter SDK
- Dart SDK
- Uygun bir editör veya IDE
- Android emulator, iOS simulator ya da fiziksel cihaz

### Projeyi Çalıştırma

```bash
flutter pub get
flutter run
```

Belirli bir cihazda çalıştırmak için önce cihazların listesi alınabilir:

```bash
flutter devices
```

## Örnek Kullanım Senaryosu

1. Kullanıcı ders programını `.xls` olarak hazırlar.
2. Uygulamada dosyayı seçer.
3. Uygulama dersleri otomatik algılar.
4. Haftalık bildirimler oluşturulur.
5. Kullanıcı sonuç ekranından dersleri görür.
6. Bildirimleri açıp kapatır veya erteleme süresini değiştirir.
7. Ders saati yaklaşınca sistem uyarı verir.

## Sunumda Nasıl Anlatılabilir?

Bu projeyi sunarken şu çerçeve çok anlaşılır olur:

- Problem: Ders programını takip etmek ve her dersi manuel hatırlamak zahmetli.
- Çözüm: Excel dosyasını içeri alıp otomatik alarm kuran bir mobil uygulama.
- Çalışma mantığı: Dosya okunur, dersler ayrıştırılır, bildirim planlanır.
- Sonuç: Kullanıcıya hem görsel bir özet hem de zamanında bildirim sunulur.

## Gelecekte Geliştirilebilecek Noktalar

- `.xlsx` desteği eklenebilir.
- Ders programı manuel düzenlenebilir.
- Bildirim geçmişi gösterilebilir.
- Kullanıcıya tema seçenekleri sunulabilir.
- Daha gelişmiş hata mesajları eklenebilir.
- Program dosyası için önizleme ekranı hazırlanabilir.

## Kısa Özet

Bu proje, Excel tabanlı ders programını otomatik alarmlara dönüştüren bir Flutter uygulamasıdır. Temel güç noktası, dosya okuma ile yerel bildirimleri bir araya getirerek kullanıcıya pratik bir ders hatırlatma sistemi sunmasıdır.
