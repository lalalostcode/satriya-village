# Aturan Proporsi & Footprint — Satriya Village

Baseline awal Game Director: **27 Oktober 2026**. Arah visual Nusantara pixel art **APPROVED**. Revisi komposisi/proporsi ini menunggu review hasil; persetujuan arah bukan pengesahan setiap sprite sebagai aset produksi final. Dokumen ini menggantikan angka tile/footprint PROPOSED yang berbeda di ART_UX_GUIDE untuk slice visual saat ini.

## Ukuran dan satuan

- Target visual tile **48×24 px**, rasio isometrik **2:1**, pada viewport desain **1280×720, zoom 100%**.
- Scene merender dunia **640×360**, sehingga tile internal **24×12 px** diperbesar nearest-neighbor **2×**. Setengah tile internal = (12,6). Pada zoom atau ukuran jendela lain, ukuran layar ikut berubah. Ini pilihan sampling pixel, bukan dua ukuran tile yang bertentangan.
- Ukuran dan footprint di bawah memakai **jumlah sel**, bukan ukuran canvas PNG. Koordinat origin adalah sel kiri-atas bidang grid; batas akhir bersifat eksklusif.
- `iso(x,y) = ((x-y)×12, (x+y)×6)` dalam koordinat dunia internal.
- PNG sumber dan sprite kategori dipertahankan. Scene membuat tekstur presentasi yang di-resize sekali dengan nearest ke dimensi integer dan di-cache per jenis; Sprite2D tetap scale (1,1).

## Tabel baseline footprint

| Elemen | Footprint | Tier visual | Aturan |
|---|---|---|---|
| Rumah rakyat standar | **2×2** | 1 | Acuan skala bangunan biasa |
| Lumbung | **2×2** | 1 | Seimbang dengan rumah; boleh lebih tinggi karena panggung |
| Sawah minimum | **2×2** | 0 | Bidang tanah/pematang, menyatu dengan saluran |
| Sawah memanjang | **3×2** | 0 | Varian data; belum ditampilkan di scene |
| Sawah luas | **4×4** | 0 | Varian data; belum ditampilkan di scene |
| Gapura standar | **3×1** | 2 | Kolom 0 pilar, kolom 1 jalan, kolom 2 pilar |
| Gapura besar | **3×2** | 3 | Kolom tengah tetap koridor 1×2; varian belum ditampilkan |
| Pendopo kecil | **3×3** | 2 | Varian data; belum ditampilkan |
| Pendopo utama / balai penting | **4×4** | 3 | Focal point terbesar di pusat desa |
| Rumah Jawa penting (penerapan scene) | **3×3** | 2 | Satu tier di atas rumah biasa; memakai sprite joglo yang ada |
| Jalan utama | **Lebar 1 tile** | — | Cabang/junction boleh bertemu; bukan boulevard 2 tile |
| Ruang antarbangunan | **Default minimum 1 tile kosong** | — | Sel ini dapat berisi jalan, taman rendah, atau irigasi yang sesuai |

Aturan 1–12 Director berlaku sebagai baseline. Bangunan penting minimal satu tier di atas rumah biasa; tier bukan level ekonomi atau upgrade gameplay. Joglo, pendopo, gapura dan candi tetap inspirasi visual Nusantara dengan akurasi periode Tumapel perlu riset.

## Footprint, overhang dan titik pijak

- Footprint menyatakan bidang lantai/okupansi. Atap, daun dan ornamen boleh **overhang**; jangan memperbesar okupansi hanya karena canvas PNG lebar.
- Pusat sprite = pusat bidang footprint. Kaki visual disejajarkan ke tepi depan footprint: kedalaman internal `(lebar+tinggi)×6/2`. Posisi gambar dibulatkan ke pixel integer.
- Overhang harus menjaga pintu, wajah NPC, jalan dan gapura tetap terbaca. Ruang satu tile adalah minimum; tambah halaman pada bangunan besar bila atap menghalangi bangunan lain. Hindari merapatkan sprite hanya berdasarkan bounding box PNG.
- Bangunan/vegetasi disortir berdasarkan tepi depan bidang; sawah/jembatan berada pada lapisan tanah. Dua pilar gapura disortir dan dipilih terpisah, tetapi membuka informasi objek gapura yang sama.
- Gapura standar menggunakan dua bagian sprite pilar yang sudah ada, ditempatkan pada sel luar. **Sel tengah adalah jalan dan tidak solid.** Koridor besar harus menyisakan seluruh kolom tengah. Data ini belum mengimplementasikan navigasi/AI atau mengubah placement sim lama.
- Klik diuji terhadap alpha tekstur presentasi, sesuai ukuran render. Klik celah gapura menembus objek. Overlay **G** memperlihatkan seluruh bidang; kuning = footprint, biru muda = jalan tengah gapura.

## Layout yang diterapkan

Peta visual 20×20. Semua sel bidang bangunan/sawah memiliki origin integer. Antarbidang tidak overlap dan memiliki sekurangnya satu baris/kolom sel kosong.

| Objek | Origin (x,y) | Ukuran |
|---|---|---|
| Rumah rumbia | (2,9) | 2×2 |
| Rumah bambu | (2,13) | 2×2 |
| Balai Waringin | (5,5) | 4×4 |
| Rumah Jawa penting | (12,3) | 3×3 |
| Lumbung | (11,12) | 2×2 |
| Sawah | (14,7), (17,7), (14,10), (17,10) | 2×2 per petak |
| Gapura standar | (8,16) | 3×1 |

Jalan utama kolom x=9 melewati (9,16). Pilar di (8,16)/(10,16). Jalan perumahan kolom x=4; cabang y=9/y=12 menghubungkan desa. Irigasi x=16 mengisi jarak antarpetak dan y=12 sisi depan sawah; saluran depan desa berada pada y=18, dengan jembatan pada jalur utama. Sel jalan tidak melintasi bidang solid bangunan/sawah. Ground tetap renderer sementara yang datar tanpa warna kotak berselang; gaya sprite dipertahankan.

Lebar presentasi internal: rumah 52 px, lumbung 50 px, rumah penting 78 px, balai 104 px; padi 48 px untuk bidang 2×2. Pohon 38 px, kelapa 34 px, pisang 26 px, bambu 28 px. NPC tinggi 22 px agar profesi tetap terbaca tanpa menyaingi bangunan. Angka ini merupakan penyesuaian presentasi terhadap footprint, bukan perubahan PNG sumber.

## Sebelum/sesudah dan cara review

[BEFORE](screenshots/proportion_before.png) adalah scene sprite terakhir yang disetujui arahnya, sebelum revisi proporsi. [AFTER](screenshots/proportion_after.png) adalah hasil penerapan baseline ini. [Overlay footprint](screenshots/footprints_overlay.png) menunjukkan hubungan sel dengan sprite. Percobaan proporsi sementara sebelum Director memberi baseline ini tidak menjadi aturan baru.

Buka project.godot di Godot 4.7.2, **F5**. Tekan **G** untuk overlay; klik rumah/sawah/balai/gapura untuk ukuran bidang. Periksa pintu/wajah, megahnya balai, padi pada tanah, celah gapura dan lebar jalan. Bangun/quest tetap mock UI; pan, zoom, Reset dan Esc tetap tersedia. Nilai proporsi pada zoom **100%**. Varian 3×2/4×4/3×3/3×2 di tabel yang tidak diinstansiasi masih memerlukan komposisi/sprite saat dipakai kelak.

Data aktif: [footprint_rules.json](../assets/visual/footprint_rules.json). Implementasi: [village_art.gd](../scripts/visual/village_art.gd). Kriteria penerimaan: tile layar 48×24; tidak ada footprint overlap; jarak ≥1 sel; koridor gapura terbuka; jalan bebas bidang solid; objek tetap dapat dipilih; komposisi disetujui Director. Smoke test merender screenshot dan memeriksa geometri/klik dasar; bukan bukti performa atau navigasi Android.
