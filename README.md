# Satriya Village — desa pixel art yang playable

**27 Oktober 2026:** F5 membuka satu scene utama, `scenes/visual_village.tscn`, dengan tampilan Nusantara dan simulasi yang terhubung. HUD, bangunan, pekerja, laporan Laras, waktu, serta save/load memakai settlement yang sama. `scenes/main.tscn` dipertahankan sebagai fixture regresi/controller lama; pemain tidak perlu berpindah ke F6.

## Menjalankan

1. Import `project.godot` di **Godot 4.7.2 Standard**, lalu tekan **F5**.
2. Klik **Kelola → Pause** atau tekan **Spasi** untuk menjeda/melanjutkan. Pilih **1x/2x/3x** di Kelola. Satu hari = 8 detik pada 1x.
3. Klik **Bangun**, pilih **Rumah / Sawah / Lumbung**, lalu klik/tap tanah kosong. Rumah membutuhkan 30 kayu, sawah 20, lumbung 45. Preview hijau berarti valid dan terjangkau; merah berarti ditolak. **Esc** membatalkan tool dan menutup panel.
4. Gunakan **Kelola → Petani -/+ / Otomatis**. Satu petani mengaktifkan satu sawah dengan 5 pangan/hari. HUD menampilkan pekerja, warga bebas dan perkiraan pangan bersih. Klik sawah untuk melihat penugasannya.
5. Klik sprite **Laras** di dekat jalan sawah, atau **Kelola → Laras**, untuk laporan **Pangan/Pekerja**. Klik kepala desa untuk identitas **Anda**. Laporan membaca model saat ini, tanpa memberi hadiah atau mengubah penugasan.
6. Gunakan **Kelola → Simpan / Muat / Cadangan**, atau slot otomatis. Muat mengganti sesi aktif hanya setelah validasi berhasil. Save lama tetap didukung; lihat catatan migrasi di bawah.
7. Di panel Laras, pilih **Panduan → Ikuti panduan**. Tutup panel, jalankan setidaknya satu hari dengan panen yang mencukupi kebutuhan, lalu kembali ke **Panduan → Laporkan panen**. Anda boleh memilih **Tolak panduan**; pembangunan, laporan dan waktu tetap tersedia. Hasil selesai/ditolak tersimpan dan tidak dapat diterapkan ulang. Quest ini merupakan panduan lokal tanpa hadiah sumber daya atau hukuman otomatis.

**Kamera:** geser mouse kiri/tengah atau satu jari; roda mouse/tombol -/+ atau cubit untuk zoom; **Reset** mengembalikan kamera. Drag/pinch tidak membangun. **G** menampilkan footprint. Klik bangunan saat tool bangun tidak aktif untuk melihat status **AWAL / IMPOR** atau **BANGUNAN BARU**. Tombol utama mengikuti desain landscape 1280×720; Android fisik belum diuji.

## Baseline dan aturan

- Arah pixel art Nusantara dipertahankan; **tile 48×24 px** pada 100% di 1280×720. Rumah/sawah/lumbung **2×2**, joglo **3×3**, pendopo **4×4**, gapura **3×1** dengan tengah terbuka. Jarak antargedung minimum satu tile; jalan, air dan landmark tidak dapat dibangun.
- Desa baru memiliki **1 rumah, 2 sawah, 8 warga, 120 kayu, 60 pangan, 150 uang**. Dua petani otomatis menghasilkan 10 pangan, konsumsi 3, sehingga +7 pangan/hari. Rumah baru menambah 2 warga. Tidak ada ekonomi kedua berdasarkan jumlah sprite.
- Pendopo, joglo dan gapura merupakan landmark awal non-ekonomi. Vegetasi/warga dekoratif bukan pekerja tambahan. Dressing yang tertutup footprint baru disembunyikan dari tampilan, tanpa menghapus aset.
- Komposisi desa awal tetap pada area 20×20. Lahan sekitar memperluas batas konstruksi menjadi 40×40, agar semua bangunan save lama yang padat dapat dipindahkan ke footprint legal tanpa kehilangan data. Area luar masih sederhana; geser kamera untuk menjangkaunya.

## Save dan kompatibilitas

Save visual memakai **schema v3 / visual-1**, dengan origin footprint dan penanda bangunan awal. Load v1/v2 memindahkan koordinat bangunan secara deterministik, mempertahankan jumlah/jenis bangunan, stok, warga, urutan alokasi petani, hari dan kecepatan. v1 tetap memakai kebijakan petani otomatis. **Load tidak menulis ulang file asal.** Save berikutnya menulis v3 dan mempertahankan snapshot sebelumnya sebagai cadangan. Versi game lama belum mendukung v3; gunakan versi ini untuk membukanya. [Kontrak save](docs/SAVE_FORMAT.md).

Setelah menerima/menolak panduan, save memakai **envelope v4 / food-guidance-1** yang memuat snapshot desa v2/v3 dan state quest sebagai satu transaksi file. Save lama tanpa quest dibaca sebagai panduan baru yang belum diterima; loading tidak menulis ulang sumber. V4 memulihkan tahap dan hasil persis tanpa mengulangi penyelesaian. Game lama tidak dapat membaca v4.

Manual: `user://saves/village.json`; otomatis: `user://saves/village-autosave.json`, masing-masing memiliki `.bak`. Autosave setiap 60 detik saat state berubah, saat background dan tutup normal. Slot otomatis yang sudah ada dilindungi pada startup: pilih **Muat otomatis / Cadangan auto**, atau aktifkan **Autosave** untuk memakai slot bagi sesi baru. Gagal autosave saat close membuat game tetap terbuka. Tidak ada progres offline.

## Bukti pengujian dan batas saat ini

Godot import/parser lulus. **634 pemeriksaan lulus, 0 gagal pada run akhir quest**: regresi mekanik 470, HUD 4, visual headless 21, integrasi headless 45, quest rendered 90, restart quest 4. Quest diuji pada session F5 yang sama melalui input viewport dan renderer Compatibility; save uji terisolasi. [Kontrak quest, rincian tes dan langkah manual](docs/M2_FOOD_QUEST.md). Bukti integrasi sebelumnya (544 pemeriksaan, termasuk screenshot renderer tambahan) tetap tersedia di [laporan integrasi](docs/VISUAL_GAMEPLAY_INTEGRATION.md).

[Desa awal](docs/screenshots/integration_village.png) · [Setelah membangun](docs/screenshots/integration_playable.png) · [Kelola](docs/screenshots/integration_controls.png) · [Footprint](docs/screenshots/integration_footprints.png)

[Panduan ditawarkan](docs/screenshots/food_guidance_offered.png) · [Panduan selesai](docs/screenshots/food_guidance_completed.png)

Batas yang tetap ada: kayu awal terbatas dan belum ada pengumpulan kayu; lumbung dapat dibangun/disimpan tetapi belum menambah kapasitas; karakter belum bergerak dengan AI. Quest saat ini hanya panduan panen dengan hasil selesai/ditolak; belum ada dua strategi penyelesaian krisis ekonomi, deadline, hadiah, politik, dinasti atau combat. Sprite masih kandidat AI dengan cleanup produksi tertunda; lahan/UI masih sederhana. Uji F5 manusia, Android fisik, dan performa desa maksimum belum menjadi bukti penerimaan produk.

## Dokumen proyek

[Keputusan](docs/DECISIONS.md) · [Roadmap](docs/ROADMAP.md) · [TASK_LOG](docs/TASK_LOG.md) · [Footprint](docs/PROPORTIONS_FOOTPRINTS.md) · [Inventaris aset](assets/visual/README.md) · [Peta dokumen](docs/DOCUMENT_INDEX.md) · [Pekerja](docs/M2_WORKFORCE_CONTRACT.md) · [Laras](docs/M2_OFFICIAL_INTERACTION.md).

Catatan status F5/F6 dalam dokumen historis sebelum integrasi telah digantikan oleh README dan bukti integrasi ini. Scope tetap satu desa kecil untuk belajar Godot/Codex, bukan implementasi penuh visi Nusantara atau build Play Store.
