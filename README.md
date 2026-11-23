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

### Tugas 8

Pada Tugas 8, aplikasi dilanjutkan dengan formulir Edukasi (`lib/screens/education_form.dart`) berisi nama institusi, jenjang, program studi, tanggal mulai dan selesai (`showDatePicker`), IPK, dan deskripsi. Formulir dibuka dari kartu "Tambah Pendidikan" dan dari opsi "Add Education" di drawer.

1. **Perbedaan push, pushReplacement, dan pop.** `Navigator.push()` menambahkan route baru di atas tumpukan (stack) sehingga route lama tetap ada di bawahnya dan pengguna bisa kembali dengan tombol Back. `Navigator.pushReplacement()` menggantikan route teratas dengan route baru, jadi route yang diganti hilang dari stack dan tidak bisa dikembalikan lewat Back. `Navigator.pop()` membuang route teratas sehingga pengguna kembali ke route di bawahnya. Untuk membuka formulir dari kartu aksi saya memakai `Navigator.push()` di `ItemCard`, sehingga tombol Back bawaan perangkat mengembalikan pengguna ke halaman utama. Opsi Home di drawer memakai `Navigator.pushReplacement()` dengan `MaterialPageRoute(builder: (context) => MyHomePage())`: halaman yang sedang tampil (misalnya formulir) diganti dengan halaman utama yang baru, sehingga pengguna langsung sampai di halaman utama. Karena yang diganti hanya route teratas, route di bawahnya tetap ada di stack, misalnya halaman utama lama jika formulir dibuka lewat kartu.

2. **Scaffold, AppBar, dan Drawer untuk konsistensi.** `Scaffold` menyediakan kerangka halaman dengan slot `appBar`, `drawer`, dan `body`, dan pola yang sama dipakai di `MyHomePage`, `ProjectFormPage`, dan `EducationFormPage`. Drawer dibuat sekali sebagai widget `LeftDrawer` lalu dipakai di semua halaman, sehingga menu navigasi selalu sama dan perubahan cukup dilakukan di satu tempat. Contoh warna tema yang dipakai di lebih dari satu halaman: warna indigo. Tema aplikasi di `main.dart` memakai `seedColor: Colors.indigo`, yang dipakai AppBar halaman utama (`colorScheme.primary`), sedangkan AppBar formulir proyek dan formulir edukasi, header drawer, serta tombol Simpan memakai `Colors.indigo`, sehingga tampilan terasa satu kesatuan.

3. **Alasan tata letak formulir.** Formulir disusun dengan `Form` yang berisi `SingleChildScrollView` dan `Column`, karena isian ditampilkan berurutan dari atas ke bawah. Setiap isian dibungkus `Padding` agar ada jarak dengan tepi layar dan antar isian sehingga tidak berhimpitan dan mudah disentuh. `SingleChildScrollView` penting ketika ruang layar terbatas, misalnya di layar sempit atau saat papan ketik tampil, karena tanpa itu `Column` akan overflow dan tombol Simpan bisa tidak terjangkau. Dengan widget penggulir, seluruh isian dan tombol Simpan tetap bisa dijangkau dengan menggulir.

4. **Peran GlobalKey, validator, dan validate().** `GlobalKey<FormState>` dipasang pada `Form` sebagai pengenal agar kode di luar field, yaitu tombol Simpan, bisa mengakses state form untuk memanggil `validate()` dan `reset()`. `validator` adalah fungsi pada tiap field yang mengembalikan pesan kesalahan jika isian tidak sesuai, atau `null` jika valid. Saat Simpan ditekan, `_formKey.currentState!.validate()` menjalankan semua validator, menampilkan pesan error pada kolom yang bermasalah, dan mengembalikan `true` hanya jika semuanya valid; dialog ringkasan baru ditampilkan jika hasilnya `true`. Contoh nilai yang ditolak: nama institusi yang hanya berisi spasi, atau IPK `5.0` karena di luar rentang 0 sampai 4. Memilih jenis input atau papan ketik saja belum cukup karena papan ketik angka hanya mempermudah pengetikan dan tidak membatasi nilai: pengguna tetap bisa mengetik `5.0`, `3.5.1`, atau menempelkan teks, dan aturan seperti tanggal selesai tidak boleh sebelum tanggal mulai tidak bisa ditegakkan oleh jenis papan ketik.

### AI Disclosure (Tugas 8)

Tugas 8 saya kerjakan secara kolaboratif dengan Claude (claude.ai) lewat diskusi bolak-balik, melanjutkan Tutorial 09. Claude membantu menyusun kode Tutorial 09 (drawer, formulir proyek, refactor ke `screens/` dan `widgets/`, migrasi ke `material_ui`), kode Tugas 8 (halaman `EducationFormPage` beserta validator, kartu aksi, dan opsi drawer). Saya yang menyiapkan lingkungan dan menjalankan semua perintah di Mac saya, memasukkan kode ke proyek, menguji formulir dari kartu dan drawer dengan input valid maupun tidak valid di Chrome, memeriksa tampilan pada lebar jendela ponsel, menjalankan `flutter analyze`, serta melakukan commit dan push. Kami juga menyesuaikan halaman utama bersama: grid dibuat 2 kolom dan body dibuat bisa di-scroll karena empat kartu berisiko overflow di layar pendek. 