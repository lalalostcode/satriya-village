# Satriya Village — Master GDD: Vertical Slice v0.1

Tanggal: 26 Oktober 2026. Status: **DRAFT / baseline perencanaan provisional**, bukan approval Director atau fitur yang sudah bekerja. Sumber: [PRD v1.1](PRD.md), [Decision Register S11/S12](DECISION_REGISTER.md), [visi](DECISIONS.md). TDD, save dan tes mengikuti [TDD](TDD.md), [SAVE_FORMAT](SAVE_FORMAT.md), [QUALITY_GATES](QUALITY_GATES.md). Belum ada implementasi yang diotorisasi oleh dokumen ini.

## 1. Pengalaman yang dibuktikan

Pemain adalah kepala desa fiksi kawasan Malang/Tumapel. Ia terlihat di desa, memahami kebutuhan pangan, mengarahkan tenaga kerja, membangun, berbicara dengan pejabat, lalu melihat akibat pilihan. Sejarah/fantasi hadir sebagai konteks orisinal dengan klaim yang diteliti, bukan kewajiban membuat banyak sistem sekaligus.

Baseline reviewer S12: target desain utama 13+, Bahasa Indonesia, kekerasan non-grafis, strategi mendalam dengan onboarding bertahap, layar Android landscape terbaca. Ini provisional dan bukan rating Google Play. Evaluasi 10–15 menit adalah jendela playtest, bukan panjang campaign atau waktu yang membatasi pemain.

## 2. Manifest dan pagar scope

| Dalam baseline slice provisional | Batas |
|---|---|
| Satu desa isometrik; rumah, sawah, lumbung | Ukuran peta/kapasitas tetap parameter TBD; tidak membuat world map sekarang |
| Pengumpulan kayu sederhana | Satu aktivitas workforce yang diusulkan; tanpa rantai produksi kayu mendalam |
| Pause/1×/2×/3× | Pause menerima perintah eksplisit; rasio hari/kalender masih OPEN |
| Ekonomi agregat pekerja; satu pejabat individual | Tidak memodelkan kekayaan tiap rakyat biasa, intrik atau seluruh dinasti |
| Satu quest krisis pangan, ≥2 hasil | Solusi lokal; tidak membutuhkan perdagangan/diplomasi yang belum ada |
| Save/load aman; mouse dan Android touch | Data serta kontrak ditinjau dahulu; profil perangkat masih NOT TESTED |
| Karakter pemain visual dan ≥1 interaksi sederhana | Gunakan sprite/marker placeholder orisinal dan panel interaksi yang sama; tanpa kontrol gerak bebas, avatar editor atau sistem animasi baru |

Perang, ekonomi penuh, intrik dan dinasti kompleks berada di luar slice. Visi politik/vasal/diplomasi/pengkhianatan, dinasti/enam atribut, rantai produksi, multi-settlement/delegasi/logistik, taktik/komandan/siege, living history/alternatif Nusantara dan riset/ahli tetap pada [traceability PRD §7](PRD.md) dan [ROADMAP](ROADMAP.md). O01-P/O01-M tetap belum disetujui.

## 3. Loop dan onboarding

Amati stok/kebutuhan → pilih prioritas → bangun/alokasikan pekerja → jalankan waktu → baca produksi/konsumsi → interaksi/quest → sesuaikan rencana → simpan.

Usulan urutan onboarding tanpa memaksa satu solusi:

1. Sorot karakter pemain dan pilihan interaksi; tampilkan identitas “Kepala desa (Anda)”.
2. Kenalkan pangan, kayu, workforce dan pause; jelaskan penyebab angka berubah.
3. Ajarkan preview/biaya dan placement valid/invalid, lalu prioritas sawah/pengumpulan kayu.
4. Pejabat menjelaskan krisis dan alternatif respons. Pemain boleh menolak panduan atau menunda respons.
5. Tampilkan hasil, kondisi pemulihan dan cara save/load.

Teks boleh dilewati dan bantuan dapat dibuka kembali. Kontrol inti tidak dikunci ketika panduan ditolak. Jumlah prompt dan teks final PROPOSED, diuji saat usability.

## 4. Pembangunan dan input

Bangunan mempunyai ID definisi, footprint, biaya dan efek yang tertera. Preview dan commit memakai aturan validasi yang sama. Penempatan valid mengubah okupansi dan biaya atomik; invalid tidak membayar. Klik UI, drag dan pinch tidak membangun secara tidak sengaja.

Mouse: pilih bangunan, lihat preview, klik cell valid; kamera pan/zoom memakai gesture/input yang ditetapkan kontrak. Touch: tap memilih/preview lalu aksi konfirmasi yang mudah dibatalkan; drag menggeser dan pinch zoom. Detail tombol, ambang drag dan mode confirm PROPOSED sebelum uji perangkat. Tidak ada aksi yang hanya bergantung hover.

Rumah, sawah dan lumbung masing-masing harus mempunyai efek yang dijelaskan UI. Rumah sebagai kapasitas, pola pertumbuhan penduduk, fungsi kapasitas lumbung dan status konstruksi masih O07; tidak otomatis menyalin efek starter sebagai balancing final. Rotasi, demolition/refund dan bangunan baru tidak diperlukan untuk slice kecuali kontrak pemulihan terbukti membutuhkannya dan scope ditinjau.

## 5. Waktu, kalender dan lifecycle

**CONFIRMED S11:** pause menghentikan kemajuan simulasi otomatis; command eksplisit valid tetap diproses. Dekorasi boleh beranimasi. Produksi/konsumsi, deadline dan penuaan tidak berjalan otomatis selama pause. Command tidak boleh memajukan tick sebagai syarat eksekusinya.

Siklus ekonomi diperbarui dari tick model, bukan frame sprite. Ukuran tick, durasi siklus, pembulatan dan hubungan tanggal/umur TBD/O06. Delapan detik/hari starter hanya expected audit. Kalender sejarah, time skip dan penuaan mendalam tidak diimplementasikan dalam slice. Pendekatan tanpa penuaan slice adalah PROPOSED, tidak menghapus visi dinasti.

Rekomendasi sementara slice tanpa offline: suspend membekukan seluruh kemajuan otomatis; resume tidak mengejar durasi background. Ini detail lifecycle PROPOSED/O10. Fitur offline terbatas kelak hanya allowlist rutin; perang/event penting tetap berhenti. Aturan resume dan timestamp ditetapkan sebelum persistence/lifecycle dibangun.

## 6. Ekonomi dan pengumpulan kayu

**CONFIRMED S11:** rakyat biasa agregat, tokoh penting individual. Workforce pool membagi pekerja yang tersedia ke tempat/aktivitas; prioritas berubah tanpa menghitung pekerja dua kali. Named official dan pemain tidak otomatis menambah pool melalui keberadaan sprite.

Ledger per interval: stok akhir = awal + produksi + penerimaan − konsumsi terpenuhi − biaya − pengiriman. Slice tidak membutuhkan impor/ekspor; komponen itu nol sampai ada fitur. Kebutuhan yang tidak terpenuhi dicatat terpisah dari stok. Persamaan hitung berikut adalah rancangan, belum rumus balancing disetujui:

- Produksi sawah mengikuti alokasi produktif dan kapasitas; tanpa pekerja produktif tidak ada output.
- Kebutuhan pangan dihitung dari penduduk yang memenuhi aturan konsumsi; tokoh bernama dihitung sekali.
- Pengumpulan kayu memakai satu aktivitas/alokasi sederhana yang diusulkan, tanpa bangunan keempat. Prasyarat biaya, sumber terbarukan, durasi/yield dan pengaruh kelangkaan tetap O07.
- Pemain dapat memindahkan alokasi penuh untuk pemulihan; aturan pemulihan harus menjelaskan kondisi peta penuh dan stok kayu/uang nol.

| Parameter | Nilai produk | Pemilik keputusan / kapan |
|---|---|---|
| Stok awal, kapasitas hunian/lumbung, biaya bangunan | TBD; angka source hanya fixture audit | O07, sebelum implementasi ekonomi |
| Workforce tersedia, slot, prioritas/tie-break | TBD; invariant jumlah tidak terlampaui | O07 + kontrak TDD |
| Produksi sawah, kebutuhan per penduduk, rounding | TBD | O07, sebelum acceptance fixture ekonomi |
| Pengumpulan kayu: yield/waktu/prasyarat/sumber | TBD; bentuk sederhana PLANNING_BASELINE | O07, sebelum implementasi pengumpulan |
| Akibat pangan nol, pertumbuhan penduduk | OPEN; tidak menyimpulkan populasi tetap atau tanpa kematian telah dipilih | O07 |
| Batas waktu pemulihan dan waktu keputusan pertama | TBD; diukur melalui fixture/playtest | O07 + QA |

Fixture wajib: kayu=0/uang=0; kayu+pangan=0; seluruh pekerja teralokasi; peta penuh; produksi tanpa pekerja. Tandai state yang valid, langkah pemulihan, biaya/waktu/hasil expected. Fixture belum dianggap executable sampai nilai dipilih. Jangan menutupi kekurangan desain dengan reward gratis tak terbatas atau iklan.

## 7. Pemain, pejabat dan interaksi minimum

**FR19 / PLANNING_BASELINE S12:** satu representasi pemain yang dapat dikenali berada pada anchor/cell desa yang ditentukan. Rekomendasi hemat scope: sprite/marker orisinal berlabel, tanpa pathfinding baru. Cell/anchor visual tidak menjadi pekerjaan ekonomi dan aturan occupancy visual dijelaskan oleh view.

Satu interaksi memakai inspector/dialog yang sama dengan pejabat: pemain memilih pejabat atau aksi “Bicara”, lalu respons menyebut pemain sebagai kepala desa. Usulan ini memberi peran nyata pada avatar tanpa locomotion, combat, inventory personal atau editor karakter penuh. Identitas pemain individual disimpan; interaksi sederhana tidak memberi resource tambahan kecuali efek quest yang terdefinisi.

Pejabat pertanian menampilkan peran, mandat dan permintaan keputusan. Tindakan rutin tidak melampaui anggaran/wewenang yang ditetapkan; keputusan besar memerlukan respons. Besar anggaran, daftar rutin/besar dan efek atribut masih OPEN. Enam nama atribut baseline tetap tercatat dengan konflik O08; tidak perlu membangun rumus enam atribut hanya untuk dialog awal.

Acceptance FR19: avatar terlihat dan dikenali; ≥1 interaksi berhasil melalui mouse dan touch, termasuk ketika pause; pembukaan ulang panel tidak menggandakan efek; save/load mempertahankan player ID; hidden/reduced sprites tidak mengubah ekonomi. Semua hasil ini masih NOT TESTED.

## 8. Quest krisis pangan

Usulan graph: inactive → active/warning → respons atau diabaikan → resolved. Warning menampilkan masalah, pilihan dan domain deadline sebelum konsekuensi. Pilihan memeriksa ulang prasyarat saat dikonfirmasi dan menerapkan efek paling sekali.

| Jalur usulan | Mekanik lokal | Outcome yang dirancang |
|---|---|---|
| A: tingkatkan produksi | Alihkan workforce dan/atau bangun sawah sesuai biaya | Stok/kebutuhan mencapai kondisi A; pejabat merespons |
| B: stabilisasi berbeda | Kebijakan cadangan/konsumsi atau alternatif lokal yang dipilih O07 | Konsekuensi berbeda dari A, tetap menyediakan kelanjutan |
| Tolak panduan | Tutup/abaikan arahan | Pembangunan dan interaksi tetap tersedia |
| Abaikan sampai batas | Warning dahulu, resolusi sesuai kontrak waktu | Akibat terlihat dan jalur pemulihan; tidak diselesaikan offline |

Bukan dua tombol dengan hasil identik: sedikitnya dua hasil harus berbeda pada state/konsekuensi yang dapat dijelaskan. Mekanik jalur B, threshold, deadline, dialog dan reward masih PROPOSED/OPEN; GDD ini tidak menganggap graph final. Simpan stage, pilihan, deadline dan effect IDs. Reload sebelum/sesudah resolusi tidak menggandakan hasil.

## 9. Save, UX, art dan validasi

Save/load mengikuti [SAVE_FORMAT](SAVE_FORMAT.md): snapshot konsisten, versi, validasi, backup dan recovery; kegagalan tidak mengganti sesi yang sehat. Slot/autosave masih O09. Tidak perlu offline, cloud, SDK atau akun untuk slice.

Gunakan layout landscape dengan safe area, label stok/penyebab gagal, ukuran teks yang diuji di perangkat dan indikator selain warna. Pertahankan placeholder sampai loop terbukti. Catat asal/lisensi setiap aset/font/audio; tidak menyalin game referensi. Nama desa/kampanye/tanggal tetap placeholder sampai O11 diteliti.

Paket validasi ada di [QUALITY_GATES](QUALITY_GATES.md). Target playtest 10–15 menit diterapkan pada loop termasuk avatar/interaksi, quest dan save. Jumlah peserta/kriteria 2 dari 3 tetap proposal PRD, bukan bukti pasar. Tidak memakai analytics. Model perangkat/FPS/memori belum diklaim. Pilot/MVP tidak dibuka oleh kelulusan dokumen.

## 10. Gate sebelum implementasi

Ratifikasi scope/baseline produk yang membutuhkan Director; audit dan stabilisasi M0; kontrak teknis fitur terkait ditinjau; O06/O07/O09 diselesaikan sesuai fitur. Data jam/budget/perangkat boleh TBD untuk dokumen, tetapi memblokir estimasi atau pengujian yang membutuhkannya. Setelah prasyarat siap, ambil satu task kecil dari [Execution Plan](AI_AGENT_EXECUTION_PLAN.md), bukan seluruh slice sekaligus.
