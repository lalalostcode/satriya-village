# Satriya Village — Art Direction & Visual Production Bible v1.0

Tanggal: 26 Oktober 2026. Pemilik: Human Game Director. Penyusun: Art Direction task.

**Status: DRAFT.** Dokumen ini adalah standar visual utama untuk seluruh produksi aset Satriya Village. Keputusan yang sudah CONFIRMED di [DECISIONS](DECISIONS.md) dan [Decision Register](DECISION_REGISTER.md) tidak diubah. Spesifikasi baru dalam dokumen ini berstatus **PROPOSED** kecuali dinyatakan lain. Detail sejarah yang belum terverifikasi berstatus **VERIFY**. Dokumen ini tidak mengubah source code, scene, konfigurasi, atau gameplay Godot.

Dokumen pendamping: [PRD v1.1](PRD.md), [Master GDD](MASTER_GDD.md), [TDD](TDD.md), [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md), [ROADMAP](ROADMAP.md).

---

## Daftar Isi

1. [Executive Art Vision](#1-executive-art-vision)
2. [Art Pillars & Non-Goals](#2-art-pillars--non-goals)
3. [Historical and Cultural Reference Policy](#3-historical-and-cultural-reference-policy)
4. [Nusantara Architecture Library](#4-nusantara-architecture-library)
5. [Isometric Pixel Art Technical Standards](#5-isometric-pixel-art-technical-standards)
6. [Silhouette, Shapes & Building Tiers](#6-silhouette-shapes--building-tiers)
7. [Color Palette](#7-color-palette)
8. [Chibi Character Art](#8-chibi-character-art)
9. [Environment / Biome Art](#9-environment--biome-art)
10. [UI/UX Art Direction](#10-uiux-art-direction)
11. [Animation & Lightweight VFX](#11-animation--lightweight-vfx)
12. [Settlement-to-Kingdom Visual Progression](#12-settlement-to-kingdom-visual-progression)
13. [Asset Production Matrix](#13-asset-production-matrix)
14. [Godot Art Pipeline](#14-godot-art-pipeline)
15. [Android Performance Principles](#15-android-performance-principles)
16. [Art QA & Acceptance Criteria](#16-art-qa--acceptance-criteria)
17. [AI Art Director Agent Charter](#17-ai-art-director-agent-charter)
18. [Reusable Art Brief Templates](#18-reusable-art-brief-templates)
19. [Open Decisions / Research Backlog](#19-open-decisions--research-backlog)
20. [Immediate Next Art Tasks](#20-immediate-next-art-tasks)

---

## 1. Executive Art Vision

**CONFIRMED** (sesuai DECISIONS dan handoff): Satriya Village adalah game 2D isometric pixel art chibi, cerah, hidup, dan mudah dibaca. Platform utama Android landscape. Lingkungan terinspirasi sejarah alternatif Nusantara, khususnya kawasan Malang/Tumapel pada awal abad ke-13.

### Ringkasan Visi

> Satriya Village terasa seperti diorama Nusantara yang hidup — sawah hijau, atap rumbia cokelat, candi batu abu-abu, karakter chibi yang ekspresif, dan langit tropis yang cerah. Pemain harus langsung merasakan bahwa ini adalah desa Nusantara, bukan desa Eropa abad pertengahan, kota feodal Jepang, atau fantasy kingdom generik.

### Target Perasaan Pemain

| Aspek | Target Emosi |
|---|---|
| Desa | Hangat, hidup, ada aktivitas |
| Lingkungan | Tropis Jawa yang khas — sawah, sungai, pohon tropis |
| Karakter | Lucu tetapi memiliki identitas dan profesi yang terbaca |
| Bangunan | Mudah dikenali dalam ukuran kecil, Nusantara otentik |
| Progresi | Perkembangan desa → pusat kekuasaan terlihat secara visual |
| Politik/perang | Strategis, bermakna, tanpa menuntut efek grafis berat |
| Informasi | Gameplay tetap mudah dipahami melalui layar ponsel |

### Inspirasi & Batas

- **Terinspirasi**: Kesederhanaan visual dan keterbacaan *Ninja Village* (Kairosoft) — tetapi identitas visual harus **orisinal sepenuhnya**.
- **TIDAK menyalin**: Aset, karakter, UI, komposisi, sprite, atau gaya spesifik Ninja Village atau Kairosoft lainnya.
- **Gaya yang diinginkan**: *Lightweight Nusantara Isometric Pixel Art*.

---

## 2. Art Pillars & Non-Goals

### Art Pillars — PROPOSED

| # | Pilar | Penjelasan |
|---|---|---|
| P1 | **Identitas Nusantara** | Setiap elemen visual — bangunan, lingkungan, pakaian, ornamen — harus segera terasa Nusantara, bukan generik |
| P2 | **Keterbacaan Mobile** | Siluet, warna, dan skala harus terbaca pada layar 6" Android. Satu pandangan cukup untuk memahami fungsi bangunan |
| P3 | **Efisiensi Produksi** | Sprite sederhana, modular, dan reusable. Solo developer harus mampu memproduksi aset yang dibutuhkan |
| P4 | **Konsistensi Visual** | Semua aset mengikuti grid, palet, proporsi, dan perspektif yang sama. Tidak ada aset yang "terlihat dari game lain" |
| P5 | **Progresi Terbaca** | Pemain melihat perkembangan desa secara visual — dari pondok sederhana hingga kompleks kekuasaan |
| P6 | **Performa Ringan** | Pixel art dipilih bukan hanya karena estetika, tetapi karena efisiensi render dan memori di Android |

### Non-Goals

| Yang Bukan Gaya Satriya Village | Alasan |
|---|---|
| 3D realistis | Terlalu berat untuk Android dan kapasitas produksi solo |
| 3D isometric render dengan tekstur berat | Mismatch dengan identitas pixel art |
| Lukisan digital yang sekadar diberi efek pixel | Tidak konsisten dan sulit diproduksi modular |
| Pixel art ultra-detail (48×48+ per karakter) | Produksi terlalu mahal untuk solo developer |
| Tiruan langsung aset Ninja Village / Kairosoft | Melanggar aturan orisinalitas proyek |
| Pencahayaan dinamis kompleks / shader berat | Beban GPU tidak sesuai target perangkat |
| Animasi mahal (30+ frame per aksi) | Tidak efisien untuk skala aset yang dibutuhkan |

---

## 3. Historical and Cultural Reference Policy

### Prinsip Dasar

Setting awal Satriya Village berada di sekitar Tumapel pada **awal abad ke-13** (masa krisis politik Tumapel/Kadiri). Ini berarti:

1. **Tidak semua bentuk arsitektur tradisional Jawa otomatis ada pada masa tersebut.**
2. Setiap referensi arsitektur dan budaya harus diklasifikasikan ke dalam salah satu dari empat kategori berikut.
3. Fiksi dan adaptasi kreatif diperbolehkan — tetapi harus **dilabeli jujur**, bukan diklaim sebagai rekonstruksi autentik.

### Klasifikasi Referensi — PROPOSED

| Kategori | Kode | Definisi | Contoh |
|---|---|---|---|
| **Historically Supported** | `HS` | Memiliki dasar sumber yang relevan untuk masa dan wilayah yang digambarkan (prasasti, relief, arkeologi, kajian akademik) | Candi batu andesit gaya Singhasari, atap ijuk/rumbia |
| **Historical Interpretation** | `HI` | Rekonstruksi yang masuk akal berdasarkan bukti tidak langsung, tetapi belum pasti | Bentuk rumah kayu/bambu berdasarkan analogi relief Candi Jago |
| **Stylized Nusantara Inspiration** | `SNI` | Bentuk Nusantara yang diadaptasi demi identitas game, meskipun periodenya tidak tepat | Joglo sebagai referensi bentuk atap bangunan elite |
| **Fictional / Alternate History** | `FAH` | Desain kreatif yang disengaja untuk kebutuhan gameplay atau narasi | Benteng maju dengan desain unik Satriya Village |

### Aturan Pemakaian

- **Jangan mengklaim** bangunan sebagai "rekonstruksi autentik Tumapel abad ke-13" tanpa sumber yang diverifikasi.
- **Boleh menggunakan** bentuk arsitektur Nusantara dari periode lain (joglo, candi bentar) sebagai **inspirasi visual** — tetapi label harus jelas (SNI atau FAH).
- **Setiap aset arsitektur** harus memiliki label klasifikasi di Asset Production Matrix.
- **Sumber** dicantumkan bila tersedia; jika tidak, tulis `VERIFY` dan catat apa yang perlu diteliti.

### Catatan Evaluasi Kritis

| Elemen | Status | Catatan |
|---|---|---|
| Rumah joglo | `SNI` — VERIFY periode | Joglo sebagai bentuk bangunan elite historisnya terkait dengan bangsawan Jawa; referensi relief serupa ada di Prambanan (abad ke-9). Bentuk joglo yang dikenal luas umumnya berasal dari abad ke-18–19. Sebagai game sejarah alternatif, bentuk atap joglo yang disederhanakan dapat menjadi inspirasi bangunan elite, tetapi **tidak boleh diklaim** sebagai rekonstruksi abad ke-13 |
| Gapura candi bentar | `SNI` — VERIFY periode | Candi bentar tertua yang masih ada ditemukan di Trowulan (Majapahit, abad ke-14), bukan Tumapel/Singhasari. Untuk game ini, bentuk serupa dapat digunakan sebagai inspirasi gerbang sakral, dengan label adaptasi |
| Bangunan bata merah | `HI` | Penggunaan bata merah di Jawa Timur berkembang pesat pada era Majapahit. Pada awal Singhasari, batu andesit lebih dominan untuk struktur monumental. Bata merah untuk struktur non-monumental memerlukan verifikasi |
| Pendopo | `HI` — VERIFY | Konsep balai terbuka tanpa dinding diperkirakan ada sejak lama di arsitektur Nusantara, tetapi bentuk pendopo yang formalized mungkin berkembang kemudian. Dapat digunakan sebagai interpretasi |
| Candi batu andesit | `HS` | Candi Kidal dan Candi Jago berada di wilayah sekitar Tumapel dan berasal dari era Singhasari (abad ke-13). Gaya candi Singhasari yang ramping dan vertikal adalah referensi valid |
| Atap ijuk/rumbia | `HS` | Material atap tradisional yang sangat umum di Nusantara; didukung bukti tidak langsung dari relief dan catatan |
| Konstruksi kayu dan bambu | `HS` | Dominan untuk hunian dan bangunan non-monumental di Jawa Kuno; didukung relief, analogi arsitektur tradisional, dan catatan sejarah |

### Daftar Referensi dan Sumber

| Sumber | Relevansi | Tanggal Akses |
|---|---|---|
| Relief Candi Jago (abad ke-13, Tumpang, Malang) | Gambaran arsitektur kayu, atap bertingkat, kehidupan sehari-hari | VERIFY — belum dikonsultasi langsung |
| Relief Candi Borobudur/Prambanan (abad ke-8–9) | Referensi bentuk rumah kayu Jawa Kuno, kapal, kehidupan pertanian | VERIFY |
| Situs Trowulan, Mojokerto | Gerbang, bata merah, tata kota Majapahit (abad ke-14, satu abad setelah setting) | 26 Oktober 2026 (web search) |
| Candi Kidal dan Candi Singhasari | Gaya arsitektur candi batu andesit era Singhasari | 26 Oktober 2026 (web search) |
| Kawruh Griya (manuskrip arsitektur Jawa) | Kodifikasi standar rumah Jawa termasuk joglo | VERIFY — kemungkinan dari era lebih kemudian |
| Kajian akademik arsitektur Nusantara (ResearchGate, jurnal arsitektur) | Transisi gaya Jawa Tengah ke Jawa Timur | 26 Oktober 2026 (web search) |

---

## 4. Nusantara Architecture Library

### 4A. Tabel Arsitektur Lengkap — PROPOSED

#### Bangunan Permukiman

| Nama | Fungsi | Material Utama | Ciri Siluet | Status Historis | Sumber | Adaptasi Pixel Art |
|---|---|---|---|---|---|---|
| Rumah rakyat sederhana | Tempat tinggal warga biasa | Kayu, bambu, atap rumbia/ijuk | Persegi rendah, atap pelana sederhana | `HS` — kayu/bambu umum di Jawa Kuno | Relief Candi Jago (VERIFY) | 1×1 tile, atap cokelat gelap, dinding kayu |
| Rumah beratap genteng | Tempat tinggal warga menengah | Kayu, atap genteng tanah liat | Persegi, atap pelana dengan warna merah terakota | `HI` — genteng kemungkinan ada tetapi belum dominan di abad ke-13 | VERIFY | 1×1 tile, atap merah, sedikit lebih besar |
| Rumah panggung | Tempat tinggal di daerah basah/rawa | Kayu, bambu, tiang-tiang tinggi | Tinggi dengan kolong, tangga kecil | `HI` — arsitektur panggung umum di Nusantara | Tradisi arsitektur Nusantara | 1×1 tile, kaki tiang terlihat |
| Rumah berhalaman | Tempat tinggal dengan pekarangan | Kayu, pagar bambu, halaman tanah | Rumah + area terbuka di sekitarnya | `HI` | Analogi kehidupan pedesaan | 2×2 tile footprint |
| Rumah keluarga terpandang | Tempat tinggal elite lokal | Kayu pilihan, ukiran sederhana, atap lebih tinggi | Lebih besar, atap lebih kompleks | `HI` | Analogi stratifikasi sosial Jawa | 2×1 tile, ornamen tambahan |
| Rumah joglo (adaptasi) | Kediaman penguasa/bangsawan | Kayu jati, empat tiang utama (saka guru), atap bertingkat | Atap piramid bertingkat yang khas | `SNI` — bentuk joglo digunakan sebagai inspirasi; periode historis kemungkinan lebih kemudian | Tradisi arsitektur Jawa, Kawruh Griya (VERIFY) | 2×2 tile, atap bertingkat yang ikonik |

#### Bangunan Komunitas dan Pemerintahan

| Nama | Fungsi | Material Utama | Ciri Siluet | Status Historis | Sumber | Adaptasi Pixel Art |
|---|---|---|---|---|---|---|
| Balai desa | Pertemuan warga, pusat administrasi awal | Kayu, atap rumbia, terbuka tanpa dinding | Lebar, rendah, terbuka di sisi-sisinya | `HI` — konsep balai pertemuan sangat umum | Analogi arsitektur komunal | 2×1 tile |
| Pendopo (adaptasi) | Balai pertemuan resmi, menerima tamu | Kayu, tanpa dinding, atap luas | Lebar, terbuka penuh, atap tinggi | `SNI` — VERIFY bentuk formal pendopo | Tradisi arsitektur Jawa | 2×2 tile |
| Paseban / ruang pertemuan | Ruang sidang/pertemuan resmi | Kayu, semi-tertutup | Persegi, ada dinding parsial | `HI` | Analogi pemerintahan lokal | 2×1 tile |
| Rumah kepala desa | Kediaman pemimpin desa | Kayu pilihan, lebih besar dari rumah biasa | Lebih megah dari rumah rakyat | `HI` | Stratifikasi sosial | 2×1 tile |
| Bangunan administrasi | Penyimpanan dokumen, pemerintahan | Kayu, semi-tertutup | Persegi, tampak resmi | `HI` | Analogi birokrasi lokal | 1×1 tile |
| Kompleks pemerintahan | Pusat kekuasaan pada fase lanjut | Kayu + batu, multiple bangunan, pelataran | Kompleks bangunan besar | `SNI/FAH` | Visi game — progres ke kerajaan | 3×3 tile |
| Kompleks kediaman elite | Tempat tinggal penguasa | Kayu pilihan, ukiran, pekarangan luas | Megah, atap bertingkat | `SNI` | Analogi stratifikasi | 2×2 tile |

#### Bangunan Pertanian dan Ekonomi

| Nama | Fungsi | Material Utama | Ciri Siluet | Status Historis | Sumber | Adaptasi Pixel Art |
|---|---|---|---|---|---|---|
| Sawah | Produksi pangan utama | Tanah, air, pematang | Flat, kotak-kotak berair, hijau muda | `HS` — pertanian padi di Jawa sudah ada sejak zaman prasejarah | Bukti arkeologis, relief | 1×1 tile, warna hijau air |
| Petak irigasi | Saluran air ke sawah | Tanah, batu kecil | Garis-garis saluran air | `HS` — sistem irigasi subak/serupa ada di Nusantara | Tradisi pertanian | Tile dekorasi |
| Lumbung padi | Penyimpanan hasil panen | Kayu, bambu, atap tinggi | Tinggi, kecil, atap curam | `HS` — lumbung tradisional umum | Tradisi arsitektur agraris | 1×1 tile |
| Tempat pengeringan panen | Menjemur padi/hasil panen | Bambu, tikar, area terbuka | Flat, area terbuka dengan tikar | `HS` | Tradisi pertanian | Tile dekorasi |
| Bengkel kayu | Produksi kayu/perabotan | Kayu, area semi-terbuka | Atap miring, tampak alat kerja | `HI` | Analogi kerajinan | 1×1 tile |
| Tempat pengerjaan logam | Menempa logam | Batu, atap semi-terbuka, perapian | Kecil, asap/api terlihat | `HI` — VERIFY pandai besi abad ke-13 | Bukti arkeologis (VERIFY) | 1×1 tile |
| Pasar kecil | Perdagangan lokal | Kayu, kios-kios terbuka | Deretan kios, atap sederhana | `HI` | Analogi kehidupan ekonomi | 2×1 tile |
| Kios pedagang | Unit perdagangan tunggal | Kayu, bambu | Kecil, satu meja/rak | `HI` | Analogi perdagangan | Dekorasi 1×1 |
| Gudang bahan | Penyimpanan material | Kayu, tertutup | Persegi, polos | `HI` | Analogi logistik | 1×1 tile |
| Tempat produksi kerajinan | Kerajinan tangan | Kayu, semi-terbuka | Mirip bengkel, dengan barang display | `HI` | Analogi kerajinan | 1×1 tile |

#### Bangunan Budaya dan Monumental

| Nama | Fungsi | Material Utama | Ciri Siluet | Status Historis | Sumber | Adaptasi Pixel Art |
|---|---|---|---|---|---|---|
| Gapura tradisional | Gerbang masuk area penting | Kayu, batu | Dua pilar dengan palang atas | `HI` | Analogi arsitektur gerbang | 1×1 tile |
| Candi bentar (adaptasi) | Gerbang sakral/monumental | Batu andesit / bata | Dua sisi simetris, terbuka di tengah | `SNI` — VERIFY; contoh tertua di Trowulan (Majapahit, abad ke-14) | Wikipedia, Trowulan | 1×2 tile, siluet ikonik |
| Candi kecil | Bangunan pemujaan / perabuan | Batu andesit | Tinggi ramping, bertingkat (gaya Singhasari) | `HS` — Candi Kidal, Candi Jago | Situs arkeologi | 1×1 tile, vertikal |
| Bangunan bata merah | Struktur bata | Bata merah | Persegi, merah | `HI` — VERIFY untuk awal abad ke-13 | Analogi Trowulan | 1×1 tile |
| Struktur batu andesit | Pelataran/altar batu | Batu andesit abu-abu | Rendah, lebar, abu-abu | `HS` | Arkeologi Singhasari | 1×2 tile |
| Pelataran batu | Area upacara/pertemuan terbuka | Batu rata | Flat, abu-abu, terbuka | `HI` | Analogi tata ruang candi | Tile ground |
| Kompleks bangunan suci | Area pemujaan lengkap | Batu, kayu, ornamen | Multiple struktur, pelataran | `SNI/FAH` | Visi game | 3×3 tile |

#### Bangunan Pertahanan dan Militer

| Nama | Fungsi | Material Utama | Ciri Siluet | Status Historis | Sumber | Adaptasi Pixel Art |
|---|---|---|---|---|---|---|
| Pos penjagaan | Titik pengawasan | Kayu, bambu | Kecil, tinggi satu orang | `HI` | Analogi pertahanan | 1×1 tile |
| Pagar pertahanan kayu | Batas pertahanan desa | Kayu, bambu runcing | Garis vertikal berjajar | `HI` | Analogi pertahanan | Tile edge/dekorasi |
| Gerbang desa | Pintu masuk desa | Kayu tebal | Dua pilar dengan palang kayu | `HI` | Analogi pertahanan | 1×1 tile |
| Menara pengawasan | Pengawasan area luas | Kayu, tinggi | Vertikal, mencolok | `HI` | Analogi pertahanan | 1×1 tile, tinggi |
| Barak | Tempat prajurit | Kayu, panjang | Persegi panjang, rendah | `HI` | Analogi militer | 2×1 tile |
| Gudang perlengkapan | Menyimpan senjata/perlengkapan | Kayu, tertutup | Persegi, kokoh | `HI` | Analogi logistik militer | 1×1 tile |
| Benteng lokal | Pertahanan kuat | Kayu + batu | Tebal, kokoh, menjulang | `FAH` | Visi game | 2×2 tile |

---

## 5. Isometric Pixel Art Technical Standards

### 5.1. Tile Isometrik — Alternatif dan Rekomendasi — PROPOSED

Proyek saat ini menggunakan `TILE_HALF_WIDTH = 40, TILE_HALF_HEIGHT = 20` di [main.gd](../scripts/main.gd), yang menghasilkan tile diamond **80×40 px** dengan rasio **2:1** — sudah sesuai standar isometrik dimetrik.

| Opsi | Ukuran Diamond | Rasio | Kelebihan | Kekurangan | Kompatibilitas Starter |
|---|---|---|---|---|---|
| **A — 64×32 px** | 64 wide, 32 tall | 2:1 | Industry sweet spot; cukup detail untuk bangunan kecil; banyak referensi/tutorial | Sedikit lebih kecil dari starter saat ini | Perlu ubah `TILE_HALF_WIDTH` dari 40 → 32 |
| **B — 80×40 px** ⭐ | 80 wide, 40 tall | 2:1 | Sesuai kode starter saat ini; lebih lega untuk detail bangunan Nusantara; baik untuk atap bertingkat | Sedikit lebih besar dari standar umum; atlas lebih besar | Kompatibel langsung |
| **C — 96×48 px** | 96 wide, 48 tall | 2:1 | Sangat lega untuk ornamen dan atap; terlihat premium | Sprite besar; atlas cepat membengkak; lebih berat untuk Android | Perlu ubah `TILE_HALF_WIDTH` ke 48 |

**Rekomendasi: Opsi B (80×40 px)** — PROPOSED

Alasan:
- Kompatibel dengan kode starter yang sudah ada.
- Ukuran 80×40 memberikan ruang cukup untuk menggambar atap Nusantara yang khas (bertingkat/curam) tanpa terlalu detail.
- Masih efisien untuk Android.
- Perubahan ke 64×32 tetap menjadi opsi fallback jika performa bermasalah.

> **Catatan**: Keputusan ini PROPOSED. Uji dengan 3–5 sprite percobaan sebelum mengunci standar. Jangan memaksakan perubahan grid atau kode dalam tugas dokumentasi ini.

### 5.2. Resolusi dan Viewport — PROPOSED

| Parameter | Nilai | Status | Catatan |
|---|---|---|---|
| Viewport Godot | 1280×720 | CONFIRMED (project.godot) | `canvas_items` stretch mode |
| Logical render resolution | 1280×720 | CONFIRMED | Sudah di project.godot |
| Default texture filter | Nearest (0) | CONFIRMED | `textures/canvas_textures/default_texture_filter=0` |
| Renderer | GL Compatibility | CONFIRMED | `gl_compatibility` untuk mobile |
| Pixel scale | 1:1 (satu pixel art = satu screen pixel pada 1× zoom) | PROPOSED | Sprite digambar di resolusi target |

> **1280×720 adalah resolusi antarmuka referensi**, bukan berarti seluruh aset harus digambar pada resolusi tersebut. Aset digambar pada ukuran sprite yang ditentukan, lalu ditempatkan pada viewport ini.

### 5.3. Ukuran Sprite — PROPOSED

| Kategori | Ukuran Canvas (px) | Footprint Grid | Contoh |
|---|---|---|---|
| Tile tanah | 80×40 | 1×1 | Rumput, tanah, sawah |
| Bangunan kecil (1×1) | 80×80 | 1×1 | Rumah rakyat, pos jaga, kios |
| Bangunan sedang (2×1) | 160×100 | 2×1 | Pasar, barak, bengkel |
| Bangunan besar (2×2) | 160×140 | 2×2 | Pendopo, rumah joglo, benteng |
| Bangunan sangat besar (3×3) | 240×180 | 3×3 | Kompleks pemerintahan, candi besar |
| Karakter chibi | 16×24 | — | Villager, pejabat, prajurit |
| Pohon / vegetasi besar | 48×64 | — | Pohon beringin, kelapa |
| Vegetasi kecil | 24×32 | — | Semak, pohon pisang kecil |
| Dekorasi tile | 80×40 | 1×1 | Jalan, sungai, irigasi |
| Ikon UI | 16×16 atau 24×24 | — | Ikon sumber daya, tombol |

### 5.4. Anchor dan Origin — PROPOSED

| Tipe Sprite | Anchor Point | Alasan |
|---|---|---|
| Tile tanah | Center-bottom dari diamond | Agar tile saling menyambung rapi |
| Bangunan | Center-bottom dari footprint tile terendah (depan) | Konsistensi depth sorting |
| Karakter | Center-bottom (kaki) | Y-sort berdasarkan posisi kaki |
| Vegetasi | Center-bottom (pangkal batang) | Konsistensi overlap |

### 5.5. Depth Sorting dan Overlap — PROPOSED

```
Z-order (belakang ke depan):
1. Tile tanah (ground layer)
2. Sawah / air / irigasi (ground decoration)
3. Jalan / jalur (ground overlay)
4. Bangunan (sorted by footprint Y + X)
5. Vegetasi (sorted by Y position)
6. Karakter / NPC (sorted by Y position kaki)
7. Dekorasi overlay (efek, seleksi, highlight)
8. UI (CanvasLayer terpisah)
```

- Gunakan **Y-sort** pada `Node2D` container untuk bangunan, vegetasi, dan karakter.
- Godot 4.x mendukung `y_sort_enabled` pada `Node2D`.
- Bangunan multi-tile: Y-sort berdasarkan **baris terdepan** footprint.

### 5.6. Outline dan Garis — PROPOSED

| Parameter | Nilai |
|---|---|
| Outline sprite karakter | 1px hitam atau gelap, selektif (atas dan sisi) |
| Outline bangunan | 1px di sisi luar untuk membedakan dari tanah |
| Anti-aliasing | **TIDAK** — gunakan nearest-neighbor penuh |
| Sub-pixel movement | Hindari — snap ke integer pixel |
| Ketebalan garis internal | 1px |

### 5.7. Atlas dan Sprite Sheet — PROPOSED

| Aspek | Standar |
|---|---|
| Format file | PNG 32-bit RGBA transparan |
| Sprite sheet karakter | Satu sheet per karakter, baris per animasi |
| Sprite sheet bangunan | Satu sprite per bangunan per state (built/constructing/damaged) |
| Tileset tanah | Satu atlas per biome (desa, hutan, sungai) |
| Padding antar frame | 1px transparan (mencegah bleeding) |
| Power-of-two atlas | PROPOSED — belum wajib; Godot menangani non-POT |
| Import filter Godot | Nearest (sudah diatur di project.godot) |

### 5.8. Pixel-Perfect Movement dan Kamera — PROPOSED

| Aspek | Rekomendasi |
|---|---|
| Kamera | Snap posisi kamera ke integer pixel saat rendering |
| Karakter movement | Posisi logis bisa float; tampilan di-snap ke integer |
| Zoom level | Diskrit: 1.0×, 1.5×, 2.0× (bukan continuous) — PROPOSED |
| Android aspect ratio | Viewport 1280×720 dengan `canvas_items` stretch; layar lebih lebar mendapat area pandang tambahan di sisi kiri/kanan |

---

## 6. Silhouette, Shapes & Building Tiers

### 6.1. Prinsip Bahasa Bentuk — PROPOSED

**Aturan utama**: Pemain harus dapat membedakan kategori bangunan dari **siluet saja**, tanpa membaca nama, pada ukuran gameplay normal.

| Kategori | Bentuk Dominan | Ciri Siluet | Tinggi Relatif | Kompleksitas Ornamen |
|---|---|---|---|---|
| Rumah sederhana | Persegi + atap pelana | Rendah, sederhana, simetris | 1× | Tidak ada |
| Bangunan elite | Persegi + atap bertingkat | Lebih tinggi, atap berlapis | 1.5–2× | Rendah–sedang |
| Bangunan ekonomi | Persegi/kotak + atap miring | Variasi tinggi, ada elemen fungsional (kios, rak) | 1–1.5× | Tidak ada |
| Pertanian | Flat / sangat rendah | Horizontal, pola berulang | 0.5× | Tidak ada |
| Bangunan suci | Vertikal + bertingkat | Tinggi, ramping, simetris kuat | 2–3× | Tinggi |
| Pemerintahan | Lebar + atap tinggi | Lebar, terbuka, atap dominan | 1.5–2× | Sedang |
| Pertahanan | Kokoh + vertikal | Tebal, sudut tajam, vertikal | 1.5× | Rendah |
| Militer | Panjang + rendah | Horizontal, solid | 1× | Tidak ada |

### 6.2. Aturan Visual per Kategori — PROPOSED

| Aspek | Aturan |
|---|---|
| **Proporsi bangunan terhadap tile** | Bangunan 1×1 tidak boleh melebihi 80×80 canvas; sprite menjulang dari footprint, bukan melebar |
| **Bentuk atap** | Atap pelana untuk rumah biasa; atap piramid/bertingkat untuk bangunan penting; atap datar/miring untuk bangunan fungsional |
| **Arah bukaan/pintu** | Menghadap depan-kiri (sudut bawah-kiri diamond isometrik) agar terlihat dari sudut pandang kamera |
| **Material utama** | Kayu/bambu = warna cokelat; batu = abu-abu; bata = merah terakota; rumbia/ijuk = cokelat gelap |
| **Warna dasar per kategori** | Lihat [§7 Color Palette](#7-color-palette) |
| **Penempatan ornamen** | Hanya pada bangunan penting dan monumental; rumah rakyat tetap polos |
| **Tingkatan kompleksitas** | Level 1 (dasar): tanpa ornamen; Level 2 (upgraded): sedikit ornamen; Level 3 (advanced): ornamen penuh |
| **Perubahan visual saat upgrade** | Warna atap berubah; ukuran sedikit bertambah; ornamen muncul bertahap; material visual berubah (kayu → batu) |

### 6.3. Panduan Siluet per Bangunan Inti — PROPOSED

```
RUMAH RAKYAT          SAWAH              LUMBUNG
  ___/\___            ════════           ___/^\___
 |  |  |  |          |≈≈≈≈≈≈|          |  /  \  |
 |__|__|__|          |≈≈≈≈≈≈|          |_/    \_|
   [pintu]           ════════             [kecil]

BALAI DESA           PENDOPO             CANDI
  ___/\___         ___/‾‾‾\___            /\
 /        \       /            \          /  \
|          |     |  (terbuka)   |        |    |
 ----------       ==============         |    |
                                         |____|
```

*(Diagram di atas adalah sketch konseptual ASCII, bukan proporsi aktual)*

---

## 7. Color Palette

### 7.1. Palet Global Nusantara Tropis — PROPOSED

> Nilai HEX berikut adalah **PROPOSED**, bukan keputusan final. Gunakan sebagai titik awal; sesuaikan setelah sprite percobaan dibuat.

#### Warna Utama Lingkungan

| Nama Palet | HEX | Fungsi | Catatan |
|---|---|---|---|
| Hijau Sawah Muda | `#A8D86A` | Sawah aktif, padi muda | Saturasi sedang, cerah |
| Hijau Sawah Tua | `#7EAB4F` | Padi siap panen, semak | Lebih gelap |
| Hijau Daun | `#5C8C3E` | Pohon, hutan dekat | Hijau natural |
| Hijau Hutan | `#3D6B2E` | Hutan lebat, latar belakang | Gelap, kedalaman |
| Hijau Rumput | `#83BF7A` | Tile rumput dasar | Sesuai starter saat ini |
| Hijau Rumput Alt | `#8CC982` | Tile rumput alternatif | Sesuai starter |

#### Warna Material Bangunan

| Nama Palet | HEX | Fungsi |
|---|---|---|
| Cokelat Kayu Muda | `#D4A76A` | Dinding kayu baru |
| Cokelat Kayu Tua | `#A67C4B` | Dinding kayu tua, bambu |
| Cokelat Bambu | `#C4A55A` | Elemen bambu |
| Merah Terakota | `#B85A3C` | Atap genteng, bata merah |
| Merah Terakota Gelap | `#8E4530` | Bayangan atap genteng |
| Cokelat Rumbia | `#7A6548` | Atap rumbia/ijuk |
| Cokelat Rumbia Gelap | `#5C4A35` | Bayangan atap rumbia |
| Abu Andesit | `#8C8E8A` | Batu candi, pelataran |
| Abu Andesit Gelap | `#6B6D69` | Bayangan batu |
| Abu Andesit Terang | `#A8AAA6` | Highlight batu |

#### Warna Tanah dan Air

| Nama Palet | HEX | Fungsi |
|---|---|---|
| Cokelat Tanah | `#9B7653` | Jalan tanah, lahan kosong |
| Cokelat Tanah Gelap | `#7A5C3E` | Bayangan tanah |
| Biru Sungai | `#5B9ECC` | Sungai, air dalam |
| Biru Irigasi | `#7BB8D4` | Saluran irigasi, sawah berair |
| Biru Dangkal | `#A3D4E8` | Kolam, sendang |

#### Warna Aksen dan Status

| Nama Palet | HEX | Fungsi |
|---|---|---|
| Emas Lembut | `#D4A847` | Elemen pemerintahan, kerajaan |
| Emas Terang | `#F0C75E` | Highlight prestige |
| Merah Peringatan | `#CC4444` | Bahaya, kekurangan pangan |
| Hijau Positif | `#5CB85C` | Status baik, cukup |
| Kuning Perhatian | `#E8B84D` | Perhatian, informasi |
| Putih UI | `#F5F0E8` | Teks terang, background panel |
| Hitam UI | `#2B2520` | Teks gelap, outline |

### 7.2. Aturan Penggunaan Warna — PROPOSED

| Aturan | Penjelasan |
|---|---|
| **Kontras sprite terhadap tanah** | Bangunan dan karakter harus memiliki kontras minimal 30% brightness terhadap tile tanah di bawahnya |
| **Saturasi bertahap** | Objek latar belakang (hutan, gunung) menggunakan saturasi lebih rendah; objek gameplay (bangunan, karakter) saturasi lebih tinggi |
| **Warna status bangunan** | Sehat = warna normal; rusak = desaturasi + retak; konstruksi = warna setengah transparan + scaffolding |
| **Musim/cuaca** | Musim hujan = tint biru lembut; musim kemarau = tint kuning hangat — PROPOSED, belum tentu diimplementasi di slice |
| **Variasi wilayah** | Dekat sungai = lebih hijau; dataran = lebih kering; hutan = lebih gelap — visi masa depan |
| **Seleksi/selection** | Outline kuning `#DF9834` (sesuai kode starter) + glow tipis |
| **Peringatan** | Ikon merah `#CC4444` + flash sederhana |
| **Bahaya** | Border merah + desaturasi area |

### 7.3. Prinsip Anti-Visual-Noise

- **JANGAN** membuat semua objek bersaturasi tinggi. Prioritaskan: karakter > bangunan penting > bangunan biasa > tanah > dekorasi.
- Tanah dan vegetasi berfungsi sebagai **panggung netral** tempat bangunan dan karakter tampil.
- UI menggunakan warna yang **kontras** tetapi **tidak bersaing** dengan gameplay area.

---

## 8. Chibi Character Art

### 8.1. Standar Proporsi Chibi — PROPOSED

| Parameter | Nilai | Catatan |
|---|---|---|
| **Rasio kepala:tubuh** | 1:1.5 (kepala besar, tubuh pendek) | Chibi yang mudah dibaca pada ukuran kecil |
| **Ukuran sprite** | 16×24 px | Cukup untuk detail minimal pada zoom gameplay |
| **Ukuran kepala** | ~8×8 px | Dominan dalam proporsi |
| **Lebar bahu** | ~10 px | Sedikit lebih lebar dari kepala |
| **Tinggi kaki** | ~6 px | Pendek, chibi |
| **Warna kulit** | `#E7BA91` (sesuai starter) atau variasi: `#D4A67A`, `#C49565` | Nusantara range |
| **Outline** | 1px hitam/gelap pada sisi luar | Keterbacaan |

### 8.2. Keterbacaan Profesi — PROPOSED

Pemain harus bisa membedakan profesi dari:
1. **Warna pakaian** (paling penting)
2. **Penutup kepala / aksesori** (sekunder)
3. **Item yang dibawa** (tersier)

| Peran | Warna Dominan | Penutup Kepala | Item | Catatan Budaya |
|---|---|---|---|---|
| Pemimpin pemain | Putih + emas | Ikat kepala (destar) | — | Inspirasi busana pemimpin Jawa |
| Petani | Hijau tua / cokelat | Caping (topi petani) | Cangkul kecil | `HS` — caping sangat umum |
| Penebang kayu | Cokelat muda | Tanpa | Kapak kecil | |
| Pengrajin | Biru gelap | Ikat kepala sederhana | Palu / alat | |
| Pedagang | Merah marun / batik hint | Blangkon sederhana | Bakul / kain | `SNI` — blangkon kemungkinan era lebih kemudian |
| Pejabat desa | Kuning/emas + putih | Destar lebih formal | Gulungan | Stratifikasi sosial |
| Senapati | Merah + hitam | Helm/ikat kepala perang | Tombak / pedang | `HI` — perlengkapan perang Jawa |
| Prajurit | Merah gelap / cokelat | Helm sederhana | Tombak / perisai | |
| Tokoh elite | Ungu / biru royal | Mahkota sederhana | — | Warna prestise |
| Penduduk umum | Cokelat / abu | Tanpa | Variasi | Sprite ringan |

### 8.3. Tingkat Produksi Karakter — PROPOSED

| Tingkat | Siapa | Sprite Req | Animasi | Portrait | Variasi |
|---|---|---|---|---|---|
| **Tier 1 — Warga biasa** | Petani, penduduk, pekerja | Template + recolor | Idle, walk | Tidak ada | 3–4 warna pakaian |
| **Tier 2 — Tokoh penting** | Pejabat, senapati, pedagang utama | Sprite unik | Idle, walk, interact | Portrait sederhana | Outfit unik |
| **Tier 3 — Tokoh utama** | Pemimpin, karakter historis/narasi | Sprite detail | Idle, walk, interact + ekspresi | Portrait detail | Kostum penuh |

> Ekonomi warga biasa tetap berbasis agregasi (CONFIRMED). Sprite individual warga biasa **tidak mewajibkan** simulasi ekonomi per orang. Mereka adalah representasi visual, bukan unit ekonomi.

### 8.4. Animasi Karakter Minimal — PROPOSED

| Animasi | Frame | Prioritas | Catatan |
|---|---|---|---|
| **Idle** | 2–4 frame | MUST (P0) | Napas / gerakan ringan |
| **Walk** | 4–6 frame (4 arah iso) | MUST (P1) | Gerakan dasar untuk 4 arah |
| **Work** | 3–4 frame | SHOULD (P1) | Mengayun alat, membungkuk |
| **Interact** | 2–3 frame | SHOULD (P1) | Berbicara, memberi/menerima |
| **Carry** | 4–6 frame (walk + item) | SHOULD (P2) | Walk variant dengan barang |
| **Attack/defend** | 4–6 frame | LATER (P2–P3) | Untuk sistem tempur |
| **Ekspresi/reaksi** | 2 frame | LATER (P2) | Senang, sedih, marah (portrait) |

> **Prioritas vertical slice**: Idle + Walk + Work saja sudah cukup. Jangan memproduksi seluruh animasi perang pada fase awal.

### 8.5. Representasi Gender/Usia — PROPOSED

- Tampilan gender dibedakan melalui **pakaian dan rambut**, bukan proporsi tubuh (chibi sulit membedakan).
- Variasi usia: anak (lebih kecil ~12×18), dewasa (16×24), tua (16×24 + rambut putih/bungkuk ringan).
- Tone representasi harus **inklusif** dan **sesuai konteks budaya** tanpa stereotip.

---

## 9. Environment / Biome Art

### 9.1. Katalog Visual Lingkungan — PROPOSED

| Kategori | Fungsi Visual | Bentuk Sederhana | Variasi Tile | Cara Hindari Repetisi | Collider? | Prioritas |
|---|---|---|---|---|---|---|
| **Sawah & pematang** | Area produksi pangan; hijau berair | Diamond flat, garis pematang, refleksi air | 3–4 varian (air, padi muda, padi tua, kosong) | Rotasi + variasi warna | Occupancy grid | P0 |
| **Sungai & anak sungai** | Batas alami, sumber air | Tile kurva, lurus, dan pertigaan; biru mengalir | 4–6 tile (lurus, belok, percabangan) | Randomisasi tile | Collider batas | P1 |
| **Saluran irigasi** | Distribusi air ke sawah | Garis tipis biru, lebih kecil dari sungai | 3 tile (lurus, belok, ujung) | — | Visual only | P1 |
| **Sendang / kolam** | Sumber air, elemen naratif | Lingkaran biru-hijau | 1–2 varian | — | Collider | P2 |
| **Tanah / jalan setapak** | Jalur pergerakan | Cokelat tanah, sedikit tekstur | 2–3 varian | Random | Visual only | P0 |
| **Jalan batu** | Jalur formal (fase lanjut) | Abu-abu batu rata | 2 varian + edge | — | Visual only | P2 |
| **Hutan tropis** | Batas peta, latar belakang | Kelompok pohon gelap | Tidak tile-based; cluster sprite | Variasi posisi | Collider batas | P1 |
| **Semak** | Dekorasi, pengisi ruang | Hijau bulat kecil | 2–3 varian | Random placement | Visual only | P1 |
| **Rumpun bambu** | Dekorasi khas, material | Vertikal hijau-kuning tipis | 2 varian | Random | Visual only | P1 |
| **Pohon pisang** | Tanaman tropis khas | Daun lebar hijau muda | 1–2 varian | — | Visual only | P1 |
| **Pohon kelapa** | Tanaman tropis ikonik | Batang melengkung, mahkota daun | 2 varian (tinggi, muda) | — | Visual only | P1 |
| **Pohon beringin** | Pohon besar, elemen budaya | Besar, akar tergantung, lebar | 1 sprite (landmark) | — | Collider | P2 |
| **Kebun** | Area pertanian sekunder | Variasi tanaman rendah | 2–3 tile | Pola tanam berbeda | Occupancy | P2 |
| **Perbukitan** | Latar belakang, batas peta | Gundukan hijau gelap | Parallax layer | — | Batas peta | P1 |
| **Bebatuan** | Dekorasi, material | Abu-abu, bentuk organik | 2–3 varian kecil | Random | Visual / collider | P2 |
| **Pagar** | Batas area, pertahanan ringan | Kayu/bambu vertikal | 3 tile (lurus, sudut, gerbang) | — | Collider | P1 |
| **Jembatan** | Menyeberangi sungai | Kayu melintang | 1–2 varian | — | Walkable path | P2 |
| **Pekarangan rumah** | Area sekitar rumah | Tanah + tanaman kecil + barang | Dekorasi acak | Variasi per rumah | Visual only | P2 |
| **Dekorasi desa** | Atmosphere; pot bunga, batu nisan kecil, tiang bendera | Kecil, bervariasi | 4–6 item dekorasi | Random scatter | Visual only | P2 |

### 9.2. Aturan Kepadatan Dekorasi — PROPOSED

- Dekorasi **tidak boleh menutupi** jalur placement bangunan.
- Dekorasi **tidak boleh mengganggu** pathfinding NPC.
- Dekorasi **tidak boleh menghalangi** keterbacaan karakter dan bangunan.
- Maksimum **30% tile kosong** terisi dekorasi pada gameplay normal — PROPOSED.
- Dekorasi yang hanya visual **tidak membutuhkan collider** dan tidak masuk occupancy grid.
- Dekorasi yang memblokir pergerakan **membutuhkan collider** ringan.

---

## 10. UI/UX Art Direction

### 10.1. Arah Visual UI — PROPOSED

| Prinsip | Penerapan |
|---|---|
| Panel sederhana dan kontras | Background panel semi-transparan gelap atau bertekstur kayu |
| Material Nusantara | Border kayu, aksen kain/batik halus, warna tanah |
| Ikon mudah dikenali | Ikon 16×16 atau 24×24 dengan siluet jelas |
| Font mudah dibaca | Google Fonts: Noto Sans (untuk teks sistem) atau font pixel custom |
| Sentuhan budaya halus | Ornamen sudut panel, separator bergaya Nusantara — JANGAN berlebihan |
| Area gameplay dominan | HUD menggunakan <25% layar; panel muncul on-demand |
| Hindari panel permanen besar | Panel minimalis; expandable/collapsible |

### 10.2. Komponen UI — PROPOSED

| Komponen | Posisi (landscape) | Ukuran Maks | Konten | Prioritas |
|---|---|---|---|---|
| **HUD sumber daya** | Top bar | 1240×67 px (sesuai starter) | Kayu, pangan, uang, warga | P0 |
| **Kalender & waktu** | Top-right | Dalam HUD | Hari, kecepatan waktu | P0 |
| **Pause/speed** | Bottom-right | 4 tombol | Pause, 1×, 2×, 3× | P0 |
| **Menu pembangunan** | Bottom bar | 1240×116 px (sesuai starter) | Daftar bangunan + biaya | P0 |
| **Panel info bangunan** | Center-right popup | 300×400 px | Info bangunan terpilih | P1 |
| **Panel karakter** | Center popup | 350×450 px | Info NPC, atribut, peran | P1 |
| **Panel jabatan/pejabat** | Center popup | 350×400 px | Daftar pejabat, mandat | P1 |
| **Quest & dialog** | Bottom-center | 800×200 px | Teks dialog, pilihan | P1 |
| **Notifikasi** | Top-center toast | 400×60 px | Peringatan, info, event | P1 |
| **Peta desa (minimap)** | Toggle overlay | 200×150 px | Overview grid | P2 |
| **World map** | Fullscreen overlay | 1280×720 | Peta wilayah | P2 (visi) |
| **Panel diplomasi** | Fullscreen overlay | 1280×720 | Relasi, faksi | P3 (visi) |
| **Kontrol peperangan** | Bottom bar replacement | 1240×116 px | Perintah, formasi | P3 (visi) |
| **Menu save/load** | Center popup | 500×400 px | Slot save, info | P1 |

### 10.3. Spesifikasi UX Mobile — PROPOSED

| Aspek | Standar | Catatan |
|---|---|---|
| **Touch target minimum** | 48×48 dp (PROPOSED untuk uji) | Belum klaim kepatuhan platform; uji pada perangkat |
| **Tap** | Seleksi tile, bangunan, karakter, tombol | Aksi utama |
| **Drag** | Pan kamera | Harus dibedakan dari tap — threshold 8px |
| **Pinch zoom** | Zoom in/out kamera | Diskrit level atau smooth → snap |
| **Placement feedback** | Preview transparan hijau (valid) / merah (invalid) | Sebelum konfirmasi build |
| **Biaya info** | Tampil pada preview placement | Kayu, efek, dll |
| **Tooltip alternatif** | Long-press atau info button (bukan hover) | Touch tidak ada hover |
| **Safe area** | Respek notch, navbar, status bar | `SafeArea` atau margin di Godot |
| **Scaling teks** | Minimum 12sp, target 14sp body text | PROPOSED — uji di perangkat |
| **Layar berbeda** | Viewport 1280×720 + stretch `canvas_items` + expand horizontal | Layar lebih lebar = lebih banyak terlihat |
| **Kondisi pause** | Visual jelas: overlay tipis atau label "PAUSED" | Pemain tahu simulasi berhenti |
| **Accessibility dasar** | Info tidak hanya warna; label teks untuk ikon penting; ukuran teks bisa diperbesar; suara bisa diatur; opsi kurangi animasi dekoratif | PROPOSED |

### 10.4. Gaya Panel UI — PROPOSED

```
┌──── Kayu border (2px, #7A6548) ────────────────┐
│ ╔══════════════════════════════════════════════╗ │
│ ║  Background: semi-transparan #2B2520 @ 85%  ║ │
│ ║  Teks: #F5F0E8 (putih hangat)               ║ │
│ ║  Aksen: #D4A847 (emas lembut)               ║ │
│ ║  Separator: garis tipis #7A6548             ║ │
│ ╚══════════════════════════════════════════════╝ │
└─── Ornamen sudut kecil bergaya Nusantara ───────┘
```

> Mockup UI **bukan** implementasi yang sudah berfungsi. Desain ini perlu diimplementasikan dan diuji.

---

## 11. Animation & Lightweight VFX

### 11.1. Standar Efek Visual — PROPOSED

| Efek | Teknik | Frame | Prioritas | Catatan |
|---|---|---|---|---|
| **Panen** | Partikel biji padi naik + angka "+5 Pangan" | 3–4 frame sprite | SHOULD (P1) | Feedback produksi |
| **Pembangunan** | Sprite konstruksi → flash → bangunan selesai | 2 state + flash | MUST (P0) | Konfirmasi build |
| **Pekerja bergerak** | Walk animation pada jalur | 4–6 frame per arah | SHOULD (P1) | Desa terasa hidup |
| **Asap dapur** | Sprite asap kecil yang naik dari bangunan | 3–4 frame loop | SHOULD (P1) | Atmosphere |
| **Air mengalir** | Tile animasi 2–3 frame untuk sawah/sungai | 2–3 frame tile | SHOULD (P1) | Terasa hidup |
| **Daun/rumput bergerak** | Subtle sprite swap atau offset | 2 frame swap (lambat) | LATER (P2) | Atmosphere |
| **Bangunan bekerja** | Indikator kecil (hammer, spark) di atas bangunan | 2 frame loop | SHOULD (P1) | Status produksi |
| **Notifikasi sumber daya** | Teks popup "+10 Kayu" floating up | Tween animasi UI | MUST (P0) | Feedback ekonomi |
| **Seleksi bangunan** | Outline highlight kuning | Toggle on/off | MUST (P0) | Sudah ada di starter |
| **Perayaan desa** | Konfeti/partikel kecil | 6–8 frame sprite | LATER (P2) | Event khusus |
| **Pertempuran sederhana** | Flash, impact, shake | 3–4 frame | LATER (P3) | Sistem tempur nanti |

### 11.2. Batasan VFX — PROPOSED

| JANGAN | Alasan |
|---|---|
| Particle system GPU berlebihan | Beban performa |
| Shader custom mahal | Kompatibilitas dan performa |
| Lighting real-time kompleks | GL Compatibility tidak mendukung optimal |
| Efek yang menghalangi UI/gameplay | Keterbacaan |
| Animasi dekoratif untuk semua objek sekaligus | Frame budget |
| Bloom/glow berat | Shader cost |

### 11.3. Budget Animasi — PROPOSED

| Layer | Max elemen animasi simultaneous | Catatan |
|---|---|---|
| Tile tanah (air/sawah) | 20–30 tile animasi visible | Frame rate lambat (4 FPS) |
| Karakter/NPC on screen | 8–12 karakter beranimasi | Walk/idle |
| Efek bangunan (asap, dll) | 5–8 efek | Sparse |
| UI feedback | 3–5 popup | Tween, bukan sprite |

---

## 12. Settlement-to-Kingdom Visual Progression

### 12.1. Tahapan Progresi Visual — PROPOSED

> Semua tahap berikut adalah **kandidat perkembangan visual**, bukan otomatis isi vertical slice. Jangan mengunci urutan sejarah atau tipe bangunan tanpa riset dan keputusan desain.

#### TAHAP A — DESA AWAL (Vertical Slice Target)

| Elemen | Karakteristik Visual |
|---|---|
| Rumah rakyat | 2–4 rumah kayu sederhana, atap rumbia |
| Sawah | 2–3 petak sawah hijau |
| Lumbung | 1 lumbung kecil |
| Balai desa | 1 balai kayu terbuka |
| Jalan | Jalan tanah |
| Lingkungan | Hijau subur, beberapa pohon tropis |
| Pagar | Pagar bambu sederhana |
| Karakter | 4–6 chibi warga bergerak |
| **Kesan** | Desa kecil, damai, awal mula |

#### TAHAP B — DESA MAJU

| Elemen | Perubahan dari Tahap A |
|---|---|
| Rumah | Lebih beragam: rumah genteng muncul |
| Pasar | 1 pasar kecil |
| Bengkel | 1 bengkel |
| Pendopo | Muncul sebagai balai lebih besar |
| Irigasi | Saluran irigasi terlihat |
| Jalan | Jalan tanah lebih teratur, beberapa jalan batu |
| Pagar/gerbang | Pagar lebih kokoh, gerbang desa |
| **Kesan** | Desa berkembang, mulai ramai |

#### TAHAP C — PUSAT PEMERINTAHAN

| Elemen | Perubahan dari Tahap B |
|---|---|
| Balai pemerintahan | Bangunan lebih besar, atap bertingkat |
| Gapura | Gapura masuk area pemerintahan |
| Bangunan pejabat | Rumah-rumah pejabat yang lebih mewah |
| Bangunan elite | Kediaman dengan ornamen |
| Pelataran | Area batu terbuka |
| Identitas faksi | Warna/bendera faksi terlihat |
| Militer | Pos jaga, menara pengawasan |
| **Kesan** | Pusat kekuasaan regional |

#### TAHAP D — PUSAT KEKUASAAN / KERAJAAN (Visi Masa Depan)

| Elemen | Perubahan dari Tahap C |
|---|---|
| Kompleks pemerintahan | Area pemerintahan besar (3×3) |
| Struktur monumental | Candi / struktur batu |
| Bangunan suci | Candi kecil atau kompleks pemujaan |
| Infrastruktur militer | Barak, benteng, gudang senjata |
| Arsitektur representatif | Bangunan dengan ornamen penuh |
| Jalan | Jalan batu penuh |
| **Kesan** | Kerajaan yang berkuasa, megah namun tetap pixel art |

### 12.2. Aturan Transisi Visual — PROPOSED

1. **Gradual, bukan mendadak**: Perubahan visual terjadi bangunan per bangunan, bukan seluruh desa berubah sekaligus.
2. **Material upgrade**: Kayu → kayu + batu → dominan batu.
3. **Atap upgrade**: Rumbia → genteng → atap bertingkat.
4. **Ornamen bertahap**: Polos → ornamen ringan → ornamen penuh.
5. **Jalan upgrade**: Tanah → tanah dipadatkan → batu.
6. **Warna aksen**: Cokelat/hijau → mulai muncul emas dan merah → dominan emas/merah.

---

## 13. Asset Production Matrix

### 13.1. Matrix Aset — PROPOSED

> Prioritas: P0 = Prototype foundation, P1 = Vertical slice, P2 = Playable pilot, P3 = Future vision.

| Asset ID | Nama | Kategori | Fungsi | Footprint | Jenis | Animasi Min | Varian | Prioritas | Milestone | Dependensi | Status Historis | Status Produksi | Acceptance Criteria |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T-001 | Tile rumput | Terrain | Ground dasar | 1×1 | Tileset | — | 2 | P0 | M0–M1 | — | `HS` | Ada (draw code) | Seamless pada grid |
| T-002 | Tile sawah | Terrain | Sawah aktif | 1×1 | Tileset | 2 frame air | 3 | P0 | M1 | T-001 | `HS` | Belum | Berbeda dari rumput |
| T-003 | Tile tanah | Terrain | Jalan tanah | 1×1 | Tileset | — | 2 | P0 | M1 | — | `HS` | Belum | Kontras dengan rumput |
| T-004 | Tile sungai | Terrain | Air mengalir | 1×1 | Tileset | 2 frame | 4 | P1 | M1 | — | `HS` | Belum | Seamless kurva |
| T-005 | Tile irigasi | Terrain | Saluran air | 1×1 | Tileset | — | 3 | P1 | M2 | T-004 | `HS` | Belum | Terhubung sawah |
| B-001 | Rumah rakyat | Bangunan | Tempat tinggal | 1×1 | Sprite | — | 2 | P0 | M1 | T-001 | `HS` | Ada (draw code) | Siluet rumah terbaca |
| B-002 | Sawah (bangunan) | Bangunan | Produksi pangan | 1×1 | Sprite | — | 1 | P0 | M1 | T-001 | `HS` | Ada (draw code) | Berbeda dari tile sawah |
| B-003 | Lumbung | Bangunan | Penyimpanan | 1×1 | Sprite | — | 1 | P0 | M1 | T-001 | `HS` | Ada (draw code) | Siluet lumbung terbaca |
| B-004 | Balai desa | Bangunan | Administrasi | 2×1 | Sprite | — | 1 | P1 | M2 | B-001 | `HI` | Belum | Lebih besar dari rumah |
| B-005 | Pasar kecil | Bangunan | Perdagangan | 2×1 | Sprite | — | 1 | P1 | M2 | B-001 | `HI` | Belum | Ada kios terlihat |
| B-006 | Bengkel kayu | Bangunan | Produksi kayu | 1×1 | Sprite | — | 1 | P1 | M2 | B-001 | `HI` | Belum | Alat terlihat |
| B-007 | Pendopo | Bangunan | Pemerintahan | 2×2 | Sprite | — | 1 | P2 | M3 | B-004 | `SNI` | Belum | Atap lebar terbuka |
| B-008 | Rumah joglo | Bangunan | Kediaman elite | 2×2 | Sprite | — | 1 | P2 | M3 | B-001 | `SNI` | Belum | Atap bertingkat |
| B-009 | Gapura | Bangunan | Gerbang area | 1×2 | Sprite | — | 1 | P2 | M3 | — | `SNI` | Belum | Siluet gerbang terbaca |
| B-010 | Candi kecil | Bangunan | Bangunan suci | 1×1 | Sprite | — | 1 | P3 | M4+ | — | `HS` | Belum | Vertikal, ramping |
| B-011 | Pos penjagaan | Bangunan | Pertahanan | 1×1 | Sprite | — | 1 | P1 | M2 | — | `HI` | Belum | Menara kecil terbaca |
| B-012 | Pagar kayu | Bangunan | Pertahanan | Edge | Tileset | — | 3 | P1 | M2 | — | `HI` | Belum | Seamless edge |
| B-013 | Gerbang desa | Bangunan | Akses masuk | 1×1 | Sprite | — | 1 | P1 | M2 | B-012 | `HI` | Belum | Terbaca sebagai pintu masuk |
| B-014 | Barak | Bangunan | Militer | 2×1 | Sprite | — | 1 | P2 | M3 | — | `HI` | Belum | Panjang, rendah |
| B-015 | Kompleks pemerintahan | Bangunan | Pusat kekuasaan | 3×3 | Sprite | — | 1 | P3 | M4+ | B-007 | `FAH` | Belum | Megah |
| C-001 | Karakter pemimpin | Karakter | Avatar pemain | — | Sprite sheet | Idle, walk | 1 | P0 | M1 | — | — | Belum | Terbaca sebagai pemimpin |
| C-002 | Petani | Karakter | NPC pekerja | — | Sprite sheet | Idle, walk, work | 3 recolor | P1 | M2 | — | `HS` | Belum | Caping terbaca |
| C-003 | Pejabat pertanian | Karakter | Tokoh penting | — | Sprite sheet | Idle, walk, interact | 1 | P1 | M2 | — | `HI` | Belum | Outfit berbeda |
| C-004 | Penduduk umum | Karakter | NPC latar | — | Sprite sheet | Idle, walk | 4 recolor | P1 | M2 | C-002 | — | Ada (draw code) | Variasi terlihat |
| C-005 | Prajurit | Karakter | Militer | — | Sprite sheet | Idle, walk, attack | 2 recolor | P2 | M3 | — | `HI` | Belum | Senjata terbaca |
| V-001 | Pohon kelapa | Vegetasi | Dekorasi | — | Sprite | — | 2 | P1 | M1 | — | `HS` | Belum | Siluet tropis |
| V-002 | Pohon pisang | Vegetasi | Dekorasi | — | Sprite | — | 1 | P1 | M1 | — | `HS` | Belum | Daun lebar |
| V-003 | Semak | Vegetasi | Dekorasi | — | Sprite | — | 3 | P1 | M1 | — | `HS` | Belum | Kecil, variasi |
| V-004 | Rumpun bambu | Vegetasi | Dekorasi | — | Sprite | — | 2 | P1 | M2 | — | `HS` | Belum | Vertikal tipis |
| V-005 | Pohon beringin | Vegetasi | Landmark | — | Sprite | — | 1 | P2 | M3 | — | `HS` | Belum | Besar, ikonik |
| U-001 | Ikon sumber daya | UI | HUD | — | Icon set | — | 4+ | P0 | M1 | — | — | Belum | Jelas pada 16×16 |
| U-002 | Panel background | UI | Container | — | 9-patch | — | 2 | P0 | M1 | — | — | Belum | Scalable |
| U-003 | Tombol | UI | Interactive | — | Sprite states | — | 3 state | P0 | M1 | — | — | Belum | Normal/hover/press |
| U-004 | Portrait frame | UI | Karakter info | — | Frame sprite | — | 2 tier | P1 | M2 | — | — | Belum | Cocok dengan portrait |

### 13.2. Ringkasan Prioritas Produksi

| Prioritas | Jumlah Aset | Tujuan | Catatan |
|---|---|---|---|
| **P0** | ~12 aset | Validasi grid, placement, bangunan inti, UI placeholder | Prototype foundation — bisa pakai draw code dulu |
| **P1** | ~20 aset | Desa hidup, NPC, pejabat, quest pangan, contoh art konsisten | Vertical slice — aset pixel art pertama yang konsisten |
| **P2** | ~15 aset | Arsitektur lanjut, tetangga, diplomasi, peperangan dasar | Playable pilot |
| **P3** | ~15+ aset | Kerajaan, variasi Nusantara, dinasti, pengepungan | Future vision — katalog referensi |

> Rumah joglo, gapura, candi, dan pendopo **masuk ke katalog referensi/visi** tetapi prioritas implementasi ditetapkan berdasarkan fungsi gameplay dan kapasitas produksi solo developer.

---

## 14. Godot Art Pipeline

### 14.1. Alur Produksi Aset — PROPOSED

```
1. Visual Brief          → Deskripsi aset: fungsi, ukuran, referensi, siluet
2. Concept Reference     → Kumpulkan referensi; sketch kasar (opsional)
3. Pixel Art Sample      → Gambar sprite di Aseprite/Libresprite/GIMP
4. Art Director Review   → Cek siluet, skala, warna, perspektif, konsistensi
5. Export Sprite          → PNG 32-bit RGBA, nearest-neighbor, no anti-alias
6. Import Godot          → Masukkan ke folder assets/; set import filter
7. Scene Integration     → Tempatkan di scene; atur anchor, z-order, collision
8. Mobile Test           → Uji di viewport 1280×720 dan perangkat jika tersedia
9. Revision              → Perbaiki berdasarkan feedback
10. Approval              → Game Director menyetujui; catat di task log
```

### 14.2. Struktur Folder Aset — PROPOSED

```
assets/
├── sprites/
│   ├── buildings/           # Sprite bangunan per file
│   │   ├── house_simple.png
│   │   ├── rice_field.png
│   │   └── granary.png
│   ├── characters/          # Sprite sheet karakter
│   │   ├── player_leader.png
│   │   ├── farmer.png
│   │   └── official.png
│   ├── environment/         # Vegetasi dan dekorasi
│   │   ├── coconut_tree.png
│   │   ├── banana_tree.png
│   │   └── bushes.png
│   └── effects/             # Efek visual
│       ├── smoke.png
│       └── harvest_particles.png
├── tilesets/
│   ├── terrain_village.png  # Atlas tile tanah desa
│   └── terrain_water.png    # Atlas tile air
├── ui/
│   ├── icons/               # Ikon sumber daya dan UI
│   │   ├── icon_wood.png
│   │   ├── icon_food.png
│   │   └── icon_coins.png
│   ├── panels/              # 9-patch panel
│   │   └── panel_wood.png
│   └── buttons/             # Tombol states
│       └── button_default.png
├── portraits/               # Portrait karakter (Tier 2–3)
│   └── portrait_official.png
└── provenance.md            # Catatan pembuat, sumber, lisensi
```

### 14.3. Konvensi Nama File — PROPOSED

| Aturan | Contoh | Anti-contoh |
|---|---|---|
| snake_case | `house_simple.png` | `HouseSimple.png` |
| Kategori sebagai prefix folder, bukan nama | `buildings/house_simple.png` | `building_house_simple.png` |
| Variasi dengan suffix angka | `bush_01.png`, `bush_02.png` | `bush.png`, `bush_v2.png` |
| Animasi sheet tanpa frame number | `farmer.png` (1 sheet) | `farmer_frame1.png` |
| State sebagai suffix | `house_simple_constructing.png` | `constructing_house_simple.png` |

### 14.4. Import Settings Godot — PROPOSED

| Parameter | Nilai | Catatan |
|---|---|---|
| **Filter** | `Nearest` | Sudah default di project.godot (`default_texture_filter=0`) |
| **Mipmaps** | `Off` | Pixel art tidak membutuhkan mipmap |
| **Repeat** | `Disabled` (kecuali tileset) | Tileset bisa `Enabled` |
| **Compress/Mode** | `Lossless` atau `VRAM Uncompressed` untuk sprite kecil | PROPOSED — uji performa |
| **SVG Import** | Tidak digunakan | Pixel art only |

> Verifikasi nama pengaturan/API terhadap Godot 4.7.2 sebelum menyatakannya sebagai instruksi final. Nama-nama di atas berdasarkan dokumentasi Godot 4.x umum — VERIFY pada versi proyek.

### 14.5. Aturan Teknis Tambahan — PROPOSED

| Aspek | Standar |
|---|---|
| **Origin / anchor** | Set di Godot per sprite; anchor ke bottom-center footprint |
| **Sprite sheet** | Baris = animasi/state; kolom = frame; catat frame count |
| **Konsistensi antar sprite** | Perspektif isometrik yang sama; cahaya dari kiri-atas (PROPOSED); outline konsisten |
| **Versioning** | Git track semua PNG; gunakan `.gitattributes` untuk binary |
| **Lisensi & provenance** | Setiap aset punya entry di `assets/provenance.md`: pembuat, sumber, lisensi, tanggal |
| **Memperbarui sprite** | Ganti file PNG dengan nama yang sama; Godot otomatis reimport. JANGAN rename jika sudah dipakai di scene — akan memutus referensi |
| **Texture atlas** | Godot dapat membuat atlas otomatis; aktifkan jika banyak sprite kecil. Manual atlas untuk tileset |

---

## 15. Android Performance Principles

### 15.1. Mengapa Pixel Art Ringan — PROPOSED

Gaya pixel art ringan dipilih karena tiga alasan strategis:

| Alasan | Penjelasan |
|---|---|
| **Artistik** | Pixel art chibi cocok dengan tone lucu, hidup, dan mudah didekati. Identitas visual yang kuat tanpa perlu realism |
| **Produksi** | Solo developer dapat membuat pixel art berkualitas lebih cepat daripada 3D atau lukisan digital. Modular dan reusable |
| **Performa** | Sprite 2D kecil menggunakan memori minimal, render cepat tanpa shader/lighting kompleks, cocok untuk Android low-mid |

### 15.2. Rekomendasi Performa — PROPOSED

> Semua angka target berikut adalah **PROPOSED** sampai diuji pada perangkat nyata. Jangan mengklaim performa sudah lolos.

| Aspek | Rekomendasi | Status |
|---|---|---|
| **Batas variasi aset awal** | Maks 50 sprite unik untuk P0–P1; reuse dengan recolor | PROPOSED |
| **Tileset reuse** | 2–3 tile tanah + rotasi = coverage penuh ground | PROPOSED |
| **Sprite atlas** | Gabungkan sprite kecil (<32×32) ke atlas 512×512 atau 1024×1024 | PROPOSED |
| **Overdraw** | Hindari layer transparan bertumpuk >3 layer di satu titik | PROPOSED |
| **Frame animasi** | Max 6 frame per animasi karakter; 2–3 frame untuk efek | PROPOSED |
| **NPC on screen** | Render max 15–20 NPC sprite visible; sembunyikan yang jauh | PROPOSED |
| **Desa tidak tampil** | Desa yang tidak di-view hanya menjalankan data — tanpa sprite/render | CONFIRMED (Blueprint) |
| **Asset loading** | Load sprite on-demand atau per-scene; jangan preload semua | PROPOSED |
| **Ukuran tekstur** | Max 1024×1024 per atlas; individual sprite max 240×180 | PROPOSED |
| **FPS target** | 30 FPS baseline; 60 FPS jika terbukti di perangkat | PROPOSED |
| **Pengukuran** | Profil FPS dan memori di perangkat nyata; gunakan Godot Profiler | PROPOSED — belum ada data |

### 15.3. Apa yang TIDAK Boleh Diklaim

- ❌ FPS sudah tercapai (belum diuji)
- ❌ Spesifikasi minimum Android (belum ditentukan)
- ❌ Jumlah NPC/bangunan maksimum (perlu profiling)
- ❌ Ukuran unduhan (belum ada aset final)
- ❌ Waktu startup/save/load (belum diukur)

---

## 16. Art QA & Acceptance Criteria

### 16.1. Acceptance Criteria per Aset — PROPOSED

Setiap aset harus memenuhi kriteria berikut sebelum dianggap selesai:

| # | Kriteria | Cara Verifikasi |
|---|---|---|
| 1 | Siluet dapat dikenali pada zoom gameplay normal (1×) | Screenshot gameplay; tanyakan 3 orang apa ini |
| 2 | Sprite sesuai perspektif grid isometrik 2:1 | Overlay pada template grid |
| 3 | Tidak memiliki tepi blur akibat scaling yang salah | Zoom 400%: setiap pixel tajam |
| 4 | Bentuk dan skala konsisten dengan aset lain | Letakkan berdampingan dengan aset sejenis |
| 5 | Palet warna sesuai standar (§7) | Bandingkan HEX dengan palet referensi |
| 6 | Visual tidak tertutup panel UI pada posisi biasa | Screenshot dengan UI aktif |
| 7 | Berfungsi pada renderer GL Compatibility | Jalankan di Godot; tidak error |
| 8 | Perubahan sprite tidak merusak footprint/collider | Cek occupancy grid masih sesuai |
| 9 | Lisensi dan sumber aset terdokumentasi | Entry di `assets/provenance.md` |
| 10 | Aset orisinal, bukan salinan game referensi | Self-certification + review |
| 11 | Konteks budaya/historis sudah diberi label (§3) | Label di Asset Matrix |
| 12 | Performa tidak diklaim lolos tanpa pengujian | Tidak ada klaim FPS tanpa profiling |
| 13 | Import filter set ke Nearest | Cek di Godot import settings |
| 14 | Anchor/origin sesuai standar (§5.4) | Cek posisi di scene |

### 16.2. Checklist Review Art Director — Reusable

```markdown
## Art Review Checklist — [Nama Aset]

- [ ] Siluet terbaca pada zoom 1×?
- [ ] Perspektif isometrik 2:1 konsisten?
- [ ] Pixel-perfect (no blur/anti-alias)?
- [ ] Skala konsisten dengan aset sejenis?
- [ ] Warna sesuai palet §7?
- [ ] Tidak tertutup UI?
- [ ] GL Compatibility renderer OK?
- [ ] Footprint/collider sesuai?
- [ ] Provenance tercatat?
- [ ] Orisinal (bukan copy)?
- [ ] Label historis ada?
- [ ] Tidak ada klaim performa tanpa uji?
- [ ] Import filter = Nearest?
- [ ] Anchor sesuai standar?

**Status:** [ ] PASS  [ ] REVISE  [ ] REJECT
**Catatan review:**
**Reviewer:**
**Tanggal:**
```

---

## 17. AI Art Director Agent Charter

### 17.1. Identitas dan Tanggung Jawab

AI Art Director bertindak sebagai penjaga konsistensi visual Satriya Village. Tanggung jawab:

| Area | Tugas |
|---|---|
| Konsistensi visual | Memastikan semua aset mengikuti standar ART_UX_GUIDE ini |
| Art brief | Menyusun brief per aset menggunakan template §18 |
| Siluet/readability | Memeriksa apakah aset terbaca pada zoom gameplay |
| Skala tile/sprite | Memverifikasi ukuran, footprint, dan anchor |
| Arsitektur Nusantara | Mengawasi kesesuaian referensi dan label historis |
| Provenance & lisensi | Memastikan setiap aset punya catatan sumber |
| Beban performa | Menilai apakah aset sesuai budget performa |
| Revisi | Mengusulkan revisi sebelum aset dianggap selesai |

### 17.2. Batas Kewenangan

| BOLEH | TIDAK BOLEH |
|---|---|
| Menyusun brief dan mengevaluasi aset | Mengubah keputusan gameplay (economy, combat, quest) |
| Menyarankan revisi visual | Mengubah spesifikasi teknis inti tanpa koordinasi Lead Engineer |
| Menolak aset yang tidak memenuhi checklist | Mengganti art style yang sudah disetujui Game Director |
| Menambah referensi dan label historis | Mengklaim rekonstruksi sejarah tanpa sumber |
| Mengatur prioritas produksi aset | Memproduksi aset massal tanpa sample yang disetujui |
| Menandai performa concerns | Menghapus aset pengguna |
| Mengusulkan palet warna baru | Menyalin aset Kairosoft atau game lain |
| | Menambah plugin, SDK, atau dependency |

### 17.3. Workflow Art Director Agent

```
1. Terima permintaan aset (dari Game Director, Lead, atau task card)
2. Baca ART_UX_GUIDE, cek Asset Matrix, cek konsistensi
3. Buat Art Brief (template §18)
4. Implementer/artist membuat sprite
5. Review menggunakan Checklist §16.2
6. Jika PASS → approve, catat di task log
7. Jika REVISE → berikan feedback spesifik, ulangi step 4
8. Jika REJECT → jelaskan alasan, berikan alternatif
```

---

## 18. Reusable Art Brief Templates

### 18.1. Template Art Brief — Bangunan

```markdown
# Art Brief — Bangunan: [NAMA]

## Identitas
- **Asset ID:** [B-XXX]
- **Kategori:** [Permukiman / Ekonomi / Pemerintahan / Budaya / Militer]
- **Fungsi Gameplay:** [Apa yang dilakukan bangunan ini dalam game]
- **Fungsi Visual:** [Apa peran visualnya — identitas desa, prestige, dll]

## Spesifikasi Teknis
- **Footprint:** [1×1 / 2×1 / 2×2 / 3×3]
- **Canvas Size:** [80×80 / 160×100 / 160×140 / 240×180 px]
- **Anchor:** Bottom-center footprint
- **Perspektif:** Isometrik 2:1, pandang dari depan-kiri
- **Outline:** 1px gelap di sisi luar
- **Import filter:** Nearest

## Referensi Arsitektur
- **Referensi Nusantara:** [Deskripsi bentuk arsitektur yang menginspirasi]
- **Status Historis:** [HS / HI / SNI / FAH]
- **Sumber:** [Sumber referensi atau VERIFY]
- **Periode:** [Abad ke-13 / adaptasi / alternate history]

## Visual Direction
- **Siluet:** [Deskripsi bentuk umum — tinggi, rendah, lebar, dll]
- **Material utama:** [Kayu / bambu / batu / bata]
- **Warna atap:** [HEX dari palet §7]
- **Warna dinding:** [HEX dari palet §7]
- **Ornamen:** [Tidak ada / ringan / penuh — sesuai tier]
- **Perbedaan dari bangunan serupa:** [Apa yang membedakan siluet ini]

## Animasi & State
- **State visual:** [Normal / constructing / damaged]
- **Efek:** [Asap? Partikel? Tidak ada?]
- **Animasi minimum:** [Tidak ada / 2 frame / dll]

## Acceptance Criteria
- [ ] Siluet terbaca pada zoom 1× tanpa label
- [ ] Perspektif konsisten dengan grid
- [ ] Palet warna sesuai standar
- [ ] Footprint sesuai spesifikasi
- [ ] Provenance tercatat
- [ ] Label historis ada
- [ ] Tidak ada copy dari game lain

## Prioritas & Milestone
- **Prioritas:** [P0 / P1 / P2 / P3]
- **Milestone target:** [M0 / M1 / M2 / M3 / M4]
- **Dependensi:** [Aset lain yang harus ada dulu]
```

### 18.2. Template Art Brief — Karakter

```markdown
# Art Brief — Karakter: [NAMA/PERAN]

## Identitas
- **Asset ID:** [C-XXX]
- **Peran:** [Petani / Pejabat / Prajurit / Pemimpin / Penduduk]
- **Tier Produksi:** [Tier 1 warga biasa / Tier 2 tokoh penting / Tier 3 tokoh utama]
- **Fungsi Gameplay:** [NPC latar / NPC interaktif / Avatar pemain]

## Spesifikasi Teknis
- **Sprite Size:** 16×24 px (standar chibi)
- **Sheet Layout:** Baris per animasi, kolom per frame
- **Anchor:** Bottom-center (kaki)
- **Outline:** 1px gelap, sisi atas dan samping
- **Import filter:** Nearest

## Visual Direction
- **Proporsi:** Chibi 1:1.5 (kepala:tubuh)
- **Warna pakaian dominan:** [HEX dari palet / deskripsi]
- **Penutup kepala:** [Caping / destar / blangkon / helm / tanpa]
- **Aksesori/item:** [Cangkul / tombak / gulungan / tanpa]
- **Warna kulit:** [HEX dari range §8.1]
- **Perbedaan dari karakter serupa:** [Apa yang membuat unik]

## Referensi Budaya
- **Inspirasi pakaian:** [Deskripsi referensi budaya Nusantara]
- **Status Historis:** [HS / HI / SNI]
- **Catatan:** [Pertimbangan budaya, gender, usia]

## Animasi
- **Idle:** [Jumlah frame — 2–4]
- **Walk:** [Jumlah frame × arah — 4–6 × 4 dir]
- **Work:** [Jumlah frame — 3–4, jika ada]
- **Interact:** [Jumlah frame — 2–3, jika ada]
- **Lainnya:** [Carry / attack / dll — jika diperlukan]

## Portrait (Tier 2–3 saja)
- **Ukuran:** 64×64 px atau 96×96 px
- **Gaya:** Chibi lebih detail, ekspresi jelas
- **Background:** Transparan atau frame Nusantara

## Acceptance Criteria
- [ ] Profesi terbaca dari warna dan siluet
- [ ] Proporsi chibi konsisten
- [ ] Animasi smooth (no jitter antar frame)
- [ ] Warna sesuai palet
- [ ] Budaya Nusantara terbaca tanpa stereotip
- [ ] Provenance tercatat
- [ ] Bukan copy dari game lain

## Prioritas & Milestone
- **Prioritas:** [P0 / P1 / P2 / P3]
- **Milestone target:** [M0 / M1 / M2]
- **Dependensi:** [Aset lain / keputusan desain]
```

### 18.3. Contoh Brief Terisi — Rumah Rakyat Sederhana

```markdown
# Art Brief — Bangunan: Rumah Rakyat Sederhana

## Identitas
- **Asset ID:** B-001
- **Kategori:** Permukiman
- **Fungsi Gameplay:** Menambah kapasitas penduduk (+2 warga)
- **Fungsi Visual:** Bangunan dasar, menunjukkan desa berpenghuni

## Spesifikasi Teknis
- **Footprint:** 1×1
- **Canvas Size:** 80×80 px
- **Anchor:** Bottom-center footprint (40, 80)
- **Perspektif:** Isometrik 2:1, pandang depan-kiri
- **Outline:** 1px #2B2520
- **Import filter:** Nearest

## Referensi Arsitektur
- **Referensi Nusantara:** Rumah kayu/bambu sederhana dengan atap rumbia
- **Status Historis:** HS — konstruksi kayu/bambu umum di Jawa Kuno
- **Sumber:** Analogi relief Candi Jago, tradisi arsitektur Nusantara
- **Periode:** Sesuai setting awal abad ke-13

## Visual Direction
- **Siluet:** Persegi rendah dengan atap pelana sederhana. Tinggi total ~45px
- **Material utama:** Kayu dan bambu
- **Warna atap:** Cokelat rumbia #7A6548
- **Warna dinding:** Cokelat kayu muda #D4A76A
- **Ornamen:** Tidak ada — ini rumah rakyat biasa
- **Perbedaan:** Paling kecil dan sederhana; baseline visual

## Animasi & State
- **State visual:** Normal only (P0); constructing dan damaged di P1
- **Efek:** Tidak ada
- **Animasi minimum:** Tidak ada (statis)

## Acceptance Criteria
- [x] Siluet "rumah" terbaca pada zoom 1×
- [ ] Perspektif konsisten dengan grid starter
- [ ] Palet warna sesuai
- [ ] Footprint 1×1 sesuai
- [ ] Provenance tercatat
- [ ] Label HS ada
- [ ] Orisinal

## Prioritas & Milestone
- **Prioritas:** P0
- **Milestone target:** M1
- **Dependensi:** T-001 (tile rumput)
```

---

## 19. Open Decisions / Research Backlog

### 19.1. Keputusan yang Masih PROPOSED

| ID | Keputusan | Status | Diperlukan Sebelum |
|---|---|---|---|
| ART-01 | Ukuran tile 80×40 px sebagai standar | PROPOSED | Produksi sprite pertama |
| ART-02 | Ukuran sprite karakter 16×24 px | PROPOSED | Produksi karakter pertama |
| ART-03 | Palet warna global (§7) | PROPOSED | Produksi aset konsisten |
| ART-04 | Struktur folder aset (§14.2) | PROPOSED | Organisasi file aset |
| ART-05 | Zoom level diskrit (1×, 1.5×, 2×) | PROPOSED | Implementasi kamera |
| ART-06 | Arah cahaya dari kiri-atas | PROPOSED | Produksi sprite |
| ART-07 | Font UI (Noto Sans / pixel custom) | PROPOSED | Implementasi UI |
| ART-08 | Touch target 48 dp | PROPOSED | Implementasi UI mobile |
| ART-09 | Max 50 sprite unik untuk P0–P1 | PROPOSED | Perencanaan produksi |
| ART-10 | Depth sorting menggunakan Y-sort | PROPOSED | Implementasi rendering |

### 19.2. Riset yang Masih Diperlukan (VERIFY)

| ID | Topik | Apa yang Perlu Diteliti | Dampak pada Art |
|---|---|---|---|
| RES-01 | Joglo pada abad ke-13 | Apakah bentuk proto-joglo sudah ada? Sumber? | Label bangunan elite |
| RES-02 | Candi bentar pra-Majapahit | Apakah ada bentuk gerbang belah sebelum Trowulan? | Label gapura |
| RES-03 | Bata merah era Singhasari | Seberapa luas penggunaan bata merah pada awal abad ke-13? | Material bangunan |
| RES-04 | Pakaian rakyat abad ke-13 | Referensi busana dari relief Singhasari | Desain karakter |
| RES-05 | Perlengkapan perang Tumapel | Jenis senjata, armor, dan formasi yang masuk akal | Sprite prajurit |
| RES-06 | Sistem irigasi Jawa abad ke-13 | Bentuk dan skala saluran irigasi | Tile irigasi |
| RES-07 | Relief Candi Jago detail | Gambaran bangunan kayu dan kehidupan sehari-hari | Referensi bangunan |
| RES-08 | Kawruh Griya — periode | Kapan manuskrip ini ditulis? Relevansi untuk abad ke-13? | Referensi arsitektur |
| RES-09 | Pendopo sebagai tipe bangunan | Sejak kapan bentuk pendopo dikenal? | Label bangunan |
| RES-10 | Nama import settings Godot 4.7.2 | Verifikasi nama parameter import texture | Pipeline instruksi |

### 19.3. Referensi Gambar Konsep — Status

Game Director telah menyukai konsep gambar desa Nusantara isometrik yang memiliki rumah tradisional, atap genteng dan rumbia, bangunan menyerupai joglo/pendopo, gapura, sawah beririgasi, pohon tropis, karakter chibi, dan UI bertema desa/kerajaan Nusantara.

**Status**: Gambar konsep tersebut **belum tersedia sebagai file dalam repository**. Deskripsi tertulis di atas digunakan sebagai brief. Referensi gambar **perlu dilampirkan** bila tersedia.

**Interpretasi**: Gunakan komposisi, suasana, palet warna, dan identitas Nusantara sebagai inspirasi. **Sederhanakan** aset final menjadi sprite pixel art 2D yang ringan dan konsisten. Gambar konsep yang terlalu detail **bukan target produksi langsung**.

---

## 20. Immediate Next Art Tasks

### Urutan Langkah Art Production Berikutnya — PROPOSED

| # | Langkah | Output | Dependensi | Status |
|---|---|---|---|---|
| 1 | **Buat 1 tile tanah pixel art** | `terrain_village.png` — 1 tile 80×40 rumput | Keputusan ART-01 | Belum |
| 2 | **Buat 1 sprite rumah rakyat** | `house_simple.png` — 80×80 dengan perspektif iso | ART-01 + palet §7 | Belum |
| 3 | **Buat 1 sprite karakter chibi** | `player_leader.png` — 16×24 idle (2 frame) | ART-02 + palet §7 | Belum |
| 4 | **Review konsistensi 3 aset** | Checklist §16.2 pada tile + rumah + karakter | Langkah 1–3 | Belum |
| 5 | **Uji di Godot** | Import, tempatkan di scene, cek perspektif dan zoom | Langkah 4 pass | Belum |
| 6 | **Approval Game Director** | Sample art disetujui sebagai standar produksi | Langkah 5 OK | Belum |
| 7 | **Produksi aset P0 sisanya** | Tile sawah, lumbung, ikon UI | Langkah 6 | Belum |
| 8 | **Produksi aset P1** | NPC, vegetasi, bangunan tambahan | P0 selesai | Belum |

> **Rekomendasi langkah pertama**: Buat **satu set sample art** — 1 tile tanah + 1 rumah + 1 karakter chibi — sebagai proof of concept visual. Review dan setujui sebelum produksi massal.

---

## Lampiran A — Glosarium

| Istilah | Definisi |
|---|---|
| Chibi | Gaya gambar Jepang dengan proporsi kepala besar dan tubuh kecil/pendek |
| Diamond / tile diamond | Bentuk belah ketupat yang menjadi dasar grid isometrik |
| Dimetric | Proyeksi isometrik dengan rasio 2:1 (bukan 30° true iso) |
| Footprint | Area grid yang ditempati oleh sebuah bangunan |
| Nearest-neighbor | Metode scaling yang mempertahankan pixel tajam tanpa blur |
| 9-patch | Teknik sprite yang bisa di-scale tanpa merusak border/corner |
| Provenance | Catatan asal-usul aset: siapa pembuat, sumber, lisensi |
| Sprite sheet | Satu gambar yang berisi banyak frame animasi atau variasi |
| Tileset | Kumpulan tile yang digunakan untuk merakit peta |
| Y-sort | Teknik pengurutan render berdasarkan posisi Y untuk kedalaman |

## Lampiran B — Status Keputusan yang Digunakan

| Status | Makna |
|---|---|
| CONFIRMED | Keputusan eksplisit Game Director atau baseline DECISIONS/AGENTS |
| PROPOSED | Rekomendasi dalam dokumen ini; belum disetujui |
| VERIFY | Memerlukan riset atau bukti sebelum dipastikan |
| PLANNING_BASELINE | Rekomendasi reviewer yang diadopsi secara provisional |

---

**Akhir dokumen.**

*Satriya Village — Art Direction & Visual Production Bible v1.0*
*Tanggal pembuatan: 26 Oktober 2026*
*Dokumen ini adalah standar produksi visual. Perubahan memerlukan review Art Director dan persetujuan Game Director.*
