# myportofolio_mobile

Aplikasi mobile portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fasilkom UI, Gasal 2026/2027. Aplikasi ini adalah klien mobile dari portofolio pribadi yang sebelumnya dibangun dengan Django.

## Identitas

- Nama: Immanuel Marvin Pandjaitan
- NPM: 2506623881
- Kelas: PBP D

## Fitur

- Halaman utama di `lib/menu.dart` (StatelessWidget), terpisah dari `lib/main.dart`.
- Tiga `InfoCard` berisi NPM, nama, dan kelas.
- Tiga `ItemCard` (Lihat Proyek, Tambah Proyek, Logout) dengan warna berbeda, diatur lewat atribut `color` pada model `ItemHomepage`.
- `SnackBar` bertuliskan "Kamu telah menekan tombol [Nama Tombol]!" saat tombol ditekan.

## Cara Menjalankan

1. Pasang Flutter SDK, lalu pastikan `flutter doctor` menunjukkan Flutter dan Chrome berstatus baik.
2. Jalankan `flutter pub get`.
3. Jalankan `flutter run -d chrome`.
4. Periksa kualitas kode dengan `flutter analyze`.

### Tugas 7

1. **Widget tree dan hubungan parent-child.** Di Flutter, seluruh antarmuka adalah widget, dan widget-widget itu tersusun bertingkat seperti pohon yang disebut widget tree. Widget di atas disebut parent, widget yang dibungkusnya disebut child. Parent menerima child lewat properti `child` (satu anak) atau `children` (banyak anak). Constraint (batas ukuran) mengalir dari parent ke child, child melaporkan ukurannya ke parent, lalu parent menentukan posisinya. Saat sebuah widget dibangun ulang, child di bawahnya ikut dibangun ulang. Contoh di proyek ini: `MaterialApp` -> `MyHomePage` -> `Scaffold` -> `AppBar` dan `Padding` -> `Column` -> `Row` (berisi tiga `InfoCard`) dan `Center` -> `Column` -> `GridView.count` (berisi tiga `ItemCard`).

2. **Widget yang digunakan dan fungsinya.**
   - `MaterialApp`: root aplikasi yang menyediakan tema, judul, dan halaman awal (`home`).
   - `Scaffold`: kerangka halaman (AppBar, body, dan tempat SnackBar tampil).
   - `AppBar`: bar judul di bagian atas halaman.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling child.
   - `Column`: menyusun child secara vertikal.
   - `Row`: menyusun child secara horizontal (tiga InfoCard sejajar).
   - `SizedBox`: memberi jarak kosong dengan ukuran tetap.
   - `Center`: menempatkan child di tengah.
   - `GridView.count`: menampilkan child dalam kisi dengan jumlah kolom tetap (3 kolom untuk ItemCard).
   - `Card`: kartu Material dengan bayangan (dipakai InfoCard).
   - `Container`: kotak serbaguna untuk lebar, padding, dan dekorasi.
   - `Material`: permukaan Material yang bisa diberi warna dan sudut membulat (dipakai ItemCard).
   - `InkWell`: area yang bisa disentuh dengan efek ripple dan `onTap`.
   - `Icon`: menampilkan ikon.
   - `SnackBar`: pesan singkat di bagian bawah layar saat tombol ditekan.
   - Widget buatan sendiri: `MyApp` (root), `MyHomePage` (halaman utama), `InfoCard` (kartu identitas), dan `ItemCard` (kartu tombol aksi).

3. **Fungsi MaterialApp dan alasan menjadi root.** `MaterialApp` membungkus aplikasi dengan fondasi Material Design: tema (`ThemeData`), judul aplikasi, halaman awal (`home`), navigasi (Navigator dan routes), dan `ScaffoldMessenger` untuk menampilkan SnackBar. Widget lain seperti `Scaffold` dan `AppBar` membutuhkan fondasi itu. Misalnya, `Theme.of(context)` baru bisa bekerja karena ada `MaterialApp` di atasnya. Karena itu `MaterialApp` ditaruh paling atas (root) agar seluruh widget di bawahnya mendapat tema, navigasi, dan layanan yang sama.

4. **StatelessWidget vs StatefulWidget.** `StatelessWidget` tidak menyimpan state yang berubah. Tampilannya hanya ditentukan oleh data yang diberikan lewat konstruktor, dan ia hanya punya method `build`. `StatefulWidget` punya objek `State` terpisah yang menyimpan data yang bisa berubah, dan tampilan diperbarui lewat `setState()`. Pilih StatelessWidget untuk tampilan statis, seperti halaman menu, `InfoCard`, dan `ItemCard` di proyek ini. Pilih StatefulWidget jika tampilan harus berubah mengikuti interaksi atau data, misalnya counter pada aplikasi bawaan Flutter, input form, atau checkbox.

5. **BuildContext.** `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Lewat context, widget bisa mengambil informasi dari widget-widget di atasnya (ancestor). Context diterima sebagai parameter method `build(BuildContext context)`. Di proyek ini dipakai pada `Theme.of(context)` untuk warna tema, `MediaQuery.of(context)` untuk lebar layar pada `InfoCard`, dan `ScaffoldMessenger.of(context)` untuk menampilkan SnackBar.

6. **Hot reload vs hot restart.** Hot reload menyuntikkan kode baru ke aplikasi yang sedang berjalan lalu membangun ulang widget, dalam hitungan detik, dan state aplikasi tetap dipertahankan. Hot restart memulai ulang aplikasi dari `main()` sehingga seluruh state kembali ke awal, tetapi tetap lebih cepat daripada menjalankan ulang penuh. Hot reload tidak cukup, dan perlu hot restart, ketika kita mengubah fungsi `main()`, nilai awal variabel global atau static, atau nilai awal state. Full restart (hentikan lalu `flutter run` lagi) diperlukan ketika mengubah `pubspec.yaml` (dependensi atau aset), kode native Android/iOS, konfigurasi platform, atau menambah plugin baru.

### AI Disclosure

Tugas 7 ini saya kerjakan secara kolaboratif dengan Claude (claude.ai) lewat diskusi bolak-balik. Claude menyusun kode `main.dart` dan `menu.dart` (termasuk atribut `color` pada `ItemHomepage` sesuai petunjuk soal). Saya yang menjalankan, menguji, dan memperbaikinya di lingkungan saya sendiri, lalu melaporkan hasilnya ke Claude untuk didiskusikan dan menyusun jawaban untuk pertanyaan refelektif.

Bagian yang saya kerjakan sendiri: menyiapkan lingkungan di Mac saya (Homebrew, Flutter SDK, Chrome), memasukkan kode ke proyek, menjalankan aplikasi di Chrome untuk menguji tampilan, warna tombol, dan SnackBar, mengisi data identitas (NPM, nama, kelas) sesuai data asli saya, membuat repositori GitHub, serta melakukan commit dan push.

Kesalahan yang terjadi dan kami perbaiki bersama: baris perintah Terminal (`cat > ...` dan `EOF`) ikut masuk ke dalam file Dart sehingga aplikasi gagal dikompilasi. Saya menemukan penyebabnya dari pesan error, lalu membersihkannya. Commit pertama ke GitHub juga hanya berisi `README.md` karena folder proyek belum di-add, jadi saya menjalankan `git add .`, commit, dan push ulang. Hasil akhir saya periksa dengan `flutter analyze` (No issues found).

Jawaban pertanyaan reflektif di atas awalnya berupa draf dari Claude, yang kemudian saya baca ulang dan sesuaikan dengan pemahaman saya.