# Satriya Village — Decision Register

Tanggal: 26 Oktober 2026. Pemilik keputusan: Human Game Director. Register ini mencatat keputusan dan batas persetujuannya; **PRD v1.1 masih DRAFT dengan CONDITIONAL PASS reviewer, belum APPROVED Director**. [PRD](PRD.md) tetap dokumen produk utama, direvisi dari v1.0 pada berkas yang sama. Pembaruan editorial ini memakai baseline provisional S12.

## Status dan kewenangan

| Status keputusan | Makna |
|---|---|
| CONFIRMED | Keputusan eksplisit atau baseline terkonfirmasi; tidak otomatis masuk rilis awal atau sudah diimplementasikan |
| PRINCIPLE_ACCEPTED | Arah diterima dengan syarat; manifest, parameter atau jadwal belum otomatis disetujui |
| PLANNING_BASELINE | Rekomendasi reviewer diadopsi untuk melanjutkan perencanaan secara provisional; bukan fakta terverifikasi atau approval eksplisit Director atas desain |
| PROPOSED | Opsi/rekomendasi yang belum dipilih Director |
| OPEN | Jawaban atau keputusan masih diperlukan |

VERIFY adalah kebutuhan bukti/riset; TBD berarti nilai belum diketahui. DEFERRED menandai penjadwalan fitur visi, bukan pembatalan atau tingkat approval. PASS/FAIL/NOT TESTED adalah status verifikasi. Kolom yang memerlukan keputusan Director tetap OPEN meskipun baseline perencanaannya tersedia. Hanya Director yang mengesahkan desain/scope/arsitektur substansial. [Task Log](TASK_LOG.md) mencatat pekerjaan, bukan approval.

Format entri: ID, keputusan, status, sumber, tanggal persetujuan atau belum ada, alasan, konsekuensi dan keputusan lanjutan. D01–D27 dari [handoff §3](../Satriya_Village_Planning_Handoff_v1.md) dan O01–O15 dari [PRD §16](PRD.md) dipertahankan. ID R11 di bawah hanya menandai hasil review v1.1; tidak menomori ulang keputusan asal. Koreksi berikutnya menambahkan riwayat, tidak menghapus bukti sebelumnya.

## Sumber persetujuan v1.1

**S11 — instruksi tertulis Director di chat ini, 26 Oktober 2026.** Director menerima secara prinsip arah A01/A03/A04/A05/A06/A07/A08 dengan ketentuan berikut, disalin agar bukti tidak bergantung tautan chat privat:

> 1. Vertical slice boleh dibatasi pada satu desa, tetapi seluruh visi Satriya Village—politik, dinasti, peperangan, ekonomi mendalam, living history, dan ekspansi Nusantara—tetap dipertahankan dalam roadmap.
> 2. Scope pilot dan MVP belum otomatis disetujui.
> 3. Pause menghentikan simulasi otomatis tetapi tetap mengizinkan perintah eksplisit pemain.
> 4. Ekonomi warga biasa berbasis agregasi; tokoh penting memiliki simulasi individual.
> 5. Mekanik pemulihan ekonomi, balancing, kalender, dan angka performa yang belum diputuskan tetap berstatus PROPOSED/OPEN.
> 6. A02, audit gameplay Godot, tetap NOT TESTED sampai ada bukti pengujian runtime.

Instruksi yang sama meminta revisi PRD v1.0 menjadi v1.1, register status, relative Markdown links, identifikasi pertanyaan O01–O04 sebelum APPROVED, dan belum mengizinkan kode/refactor Godot. Bukti ini bukan persetujuan global PRD atau otorisasi implementasi.

## Keputusan hasil review v1.1

Entri R11 berikut merekam S11 secara historis. Register O terkini dan sumber S12 di bawah melengkapi baseline tersebut tanpa mengubah riwayat approval menjadi seolah-olah sudah diberikan saat S11.

| ID / audit / asal | Keputusan dan status | Tanggal / alasan / konsekuensi |
|---|---|---|
| R11-01 / A01 / O01 | PRINCIPLE_ACCEPTED: slice boleh satu desa; manifest rinci O01-S masih OPEN | 2026-10-26, S11. Menjaga kelayakan solo developer; tidak mengesahkan jumlah bangunan, durasi atau seluruh acceptance target |
| R11-02 / A07 / D01–D27 + DECISIONS | CONFIRMED: seluruh visi tetap dipertahankan dan ditelusuri dalam roadmap | 2026-10-26, S11. Fitur deferred memiliki sumber, gate/desain dan acceptance intent; tidak menjanjikan tanggal |
| R11-03 / A01 / O01-P/O01-M | CONFIRMED: scope pilot dan MVP belum otomatis disetujui; isi keduanya tetap PROPOSED/OPEN | 2026-10-26, S11. Persetujuan slice tidak mengesahkan pilot/rilis |
| R11-04 / A03 / O06 | CONFIRMED: pause menghentikan simulasi otomatis dan menerima command eksplisit pemain yang valid | 2026-10-26, S11. Selaraskan FR03 dan blueprint; kalender, daftar command dan detail transaksi belum dikunci |
| R11-05 / A04 / D08/D18/O07 | CONFIRMED: ekonomi warga biasa agregat; tokoh penting individual | 2026-10-26, S11. FR07/blueprint mengikuti batas ini; rumus workforce, perjalanan dan schema masih perlu spesifikasi |
| R11-06 / A05/A03/A08 / O06/O07/O14 | CONFIRMED: mekanik pemulihan, balancing, kalender dan angka performa yang belum dipilih tetap PROPOSED/OPEN | 2026-10-26, S11. Tidak mengunci pengumpulan kayu, rumah/populasi, rasio hari/tahun atau target FPS |
| R11-07 / A06 | PRINCIPLE_ACCEPTED: register keputusan dengan sumber, status dan batas kewenangan | 2026-10-26, S11. Dokumen ini memenuhi pencatatan; tidak menaikkan proposal lama secara massal |
| R11-08 / A08 / O04 | PRINCIPLE_ACCEPTED: arah validasi Android dini | 2026-10-26, S11. Ponsel, kesiapan, urutan pelaksanaan dan target O04/O14 masih OPEN; belum bukti Android |
| R11-09 / A02 | CONFIRMED sebagai ketentuan pelaporan: audit gameplay NOT TESTED sampai bukti runtime tersedia | 2026-10-26, S11. Tidak menyatakan bug fixed/M0 passed dari pembacaan source atau parser |
| R11-10 / batas kerja | CONFIRMED: pekerjaan saat ini revisi dokumentasi; belum kode/refactor Godot | 2026-10-26, S11. Perubahan dokumen tidak membuka gate engineering |

## Baseline lama dan konflik sumber

Tabel konflik berikut berasal dari review S11; status manifest, audiens dan strategi Android kini dilengkapi S12 serta register O terkini. Pilihan gameplay yang belum ditentukan tidak otomatis berubah karena rekomendasi reviewer.

Visi [DECISIONS](DECISIONS.md) dan handoff D01–D27 tetap dipertahankan. Traceability lengkap ada di PRD §7 dan [ROADMAP](ROADMAP.md). Keputusan baru di atas melengkapi baseline; tidak mengklaim bahwa semua rincian contoh handoff sudah terkonfirmasi.

| Item | Status sumber / keputusan saat ini | Tindak lanjut |
|---|---|---|
| Enam atribut | Jumlah enam CONFIRMED; DECISIONS mencantumkan Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality. Handoff menyebut nama sebagai usulan | Konflik C01 tetap ditandai; baseline nama tidak diganti; O08 menunggu ratifikasi eksplisit nama |
| Tirta Wening / Babad Tanah Tumapel / tahun 1219–1222 | PROPOSED; kronologi dan representasi membutuhkan VERIFY | O11, riset sebelum konten final |
| Rumah/sawah/lumbung, satu pejabat, quest ≥2 hasil, evaluasi 10–15 menit, avatar pemain | PLANNING_BASELINE dari S12, belum approval eksplisit scope Director | O01-S: ratifikasi manifest sebelum scope dinyatakan approved |
| Pengumpulan kayu sederhana | PLANNING_BASELINE dari S12; bentuk aksi, yield, waktu, prasyarat dan konsekuensi masih PROPOSED/OPEN | O07; susun kontrak dan fixture sebelum fitur ditulis |
| Populasi tetap, rumah hanya kapasitas, akibat kelaparan | PROPOSED/OPEN | O07; tidak disahkan oleh rekomendasi pengumpulan kayu |
| 8 detik/hari starter | Observasi source, bukan approval pacing/umur/sejarah | O06; saat audit tetap expected baseline jika source sama |
| 30 FPS / p95 33,3 ms / cap offline empat jam | PROPOSED; belum target yang diratifikasi atau bukti performa | O14/O10; tetapkan perangkat, beban dan aturan |

## Sumber reviewer dan adopsi provisional S12

**S12 — hasil review yang disampaikan pengguna, 26 Oktober 2026: CONDITIONAL PASS.** Pengguna menginstruksikan melanjutkan dokumentasi memakai rekomendasi reviewer sebagai baseline dan secara eksplisit melarang klaim bahwa angka usia, anggaran, perangkat atau scope sudah disetujui Director hanya dari review ini. Ringkasan isi untuk jejak sumber:

- Slice: satu desa, rumah/sawah/lumbung, pengumpulan kayu sederhana, pause/1×/2×/3×, ekonomi pekerja agregat, satu pejabat/interaksi, quest pangan ≥2 hasil, save/load aman, mouse/touch, serta karakter pemain visual dengan ≥1 interaksi; evaluasi 10–15 menit.
- Desain provisional: 13+, Bahasa Indonesia, kekerasan non-grafis, strategi mendalam dengan onboarding bertahap dan UI Android terbaca. Ini bukan age rating Google Play.
- Operasional: solo pemula dengan Codex, budget-minimal dan lisensi jelas; jam/budget nominal/PC/tanggal rilis TBD; tidak menganggap biaya Rp0.
- Android: smoke setelah input/gameplay dasar stabil, perangkat fisik tersedia sebagai rencana; identitas/kapasitas perangkat TBD; test device dibedakan dari minimum supported; FPS membutuhkan profil.
- Seluruh visi besar tetap dipertahankan; pilot/MVP tidak ikut disetujui. Siapkan GDD, TDD, execution plan, quality gates dan rencana audit M0. Pekerjaan sekarang dokumentasi dengan commit terpisah, tanpa fitur/refactor.

| ID / asal | Status adopsi saat ini | Dampak dan batas |
|---|---|---|
| R12-01 / O01-S | PLANNING_BASELINE | Manifest slice dipakai GDD, ditambah FR19 avatar/interaksi. Approval scope Director tetap OPEN; tanpa perang, ekonomi penuh, intrik/dinasti kompleks di slice |
| R12-02 / O02 | PLANNING_BASELINE | Desain utama 13+, Indonesia, non-grafis, onboarding bertahap; belum rating resmi atau approval eksplisit Director |
| R12-03 / O03 | PLANNING_BASELINE; data TBD | Asumsi budget-minimal/solo; tidak membuat angka biaya, jam, PC atau tanggal. Tidak memblokir penulisan dokumen |
| R12-04 / O04 | PLANNING_BASELINE; perangkat TBD | Smoke setelah fondasi stabil; data perangkat sebelum eksekusi/profil. Bukan bukti perangkat tersedia, batas minimum atau FPS tercapai |
| R12-05 / O07 | PLANNING_BASELINE untuk pengumpulan kayu sederhana | Mekanik rinci/balancing tetap PROPOSED/OPEN; tidak mengunci rumah/populasi/kelaparan |
| R12-06 / batas kerja | CONFIRMED sebagai instruksi pekerjaan, S12 | Diotorisasi: editorial/dokumen dan commit dokumentasi. Tidak menyiratkan approval desain di atas atau izin fitur baru |

## Pertanyaan prioritas

S12 memungkinkan dokumentasi berlanjut dengan baseline provisional. Pertanyaan berikut tidak menghentikan semua dokumen. Approval global PRD/scope tetap membutuhkan keputusan eksplisit Director; data O03/O04 yang belum tersedia tetap TBD dan memiliki gate pemakaian masing-masing. Jangan meminta ulang dua aturan confirmed tentang pause/agregasi atau berpura-pura baseline reviewer adalah ratifikasi.

| ID | Yang sudah diterima | Jawaban yang masih diperlukan | Rekomendasi yang belum diputuskan |
|---|---|---|---|
| O01-S | Prinsip satu desa; manifest S12 sebagai PLANNING_BASELINE | Ratifikasi eksplisit manifest, termasuk FR19 avatar/interaksi, sebelum scope disebut approved | Lanjutkan GDD sekarang dengan manifest provisional; pilot/MVP tetap deferred |
| O02 | Baseline reviewer: 13+, Indonesia, non-grafis, onboarding | Ratifikasi target desain untuk approval produk; rating toko diverifikasi menjelang rilis | Desain provisional dapat dipakai dokumentasi; bukan rating resmi |
| O03 | Asumsi budget-minimal/solo/Codex | Jam nyata, plafon nominal dan PC TBD; diperlukan sebelum estimasi kalender/biaya, bukan sebelum menulis GDD | Gunakan milestone berbasis acceptance; jangan isi Rp0 atau deadline fiktif |
| O04 | Strategi smoke setelah fondasi stabil | Model/RAM/OS/GPU/ketersediaan TBD; diperlukan sebelum tes perangkat dan klaim kapasitas | Lanjutkan desain touch/tes sekarang; jangan menyebut minimum supported atau hasil FPS |

## Register O01–O15 dan dependensi

| ID | Status saat v1.1 | Keputusan yang tersisa / kapan diperlukan | Bukti approval detail |
|---|---|---|---|
| O01 | PRINCIPLE_ACCEPTED satu desa; O01-S PLANNING_BASELINE, ratifikasi OPEN; O01-P/O01-M PROPOSED/OPEN | Ratifikasi scope sebelum menyatakan approved; dokumentasi memakai S12 | S11 prinsip; S12 rekomendasi, bukan approval rinci |
| O02 | PLANNING_BASELINE; ratifikasi OPEN | 13+/Indonesia/non-grafis untuk desain provisional; keputusan Director sebelum approved; rating kelak | S12 reviewer, belum approval Director |
| O03 | PLANNING_BASELINE; nilai TBD | Jam/budget/PC sebelum estimasi dan komitmen biaya; tidak memblokir dokumen | S12 asumsi; belum data nyata |
| O04 | PRINCIPLE_ACCEPTED arah; PLANNING_BASELINE urutan smoke; data TBD | Perangkat sebelum smoke/profil; target minimum/performa sesudah bukti | S11 arah; S12 rekomendasi |
| O05 | OPEN; rekomendasi salvage bertahap PROPOSED | Audit dahulu, keputusan perbaikan/rebuild sebelum source edit | Belum ada |
| O06 | CONFIRMED hanya aturan pause; kalender/parameter OPEN | Kontrak waktu sebelum implementasi terkait/dinasti | S11 untuk pause |
| O07 | CONFIRMED agregasi; pengumpulan kayu PLANNING_BASELINE; detail PROPOSED/OPEN | Pilih prasyarat/yield, hunian, workforce dan konsumsi sebelum implementasi ekonomi | S11 agregasi; S12 arah pengumpulan, bukan balancing |
| O08 | OPEN pada konflik nama atribut | Ratifikasi nama sebelum spesifikasi atribut dikunci | Baseline DECISIONS dipertahankan; belum ratifikasi konflik |
| O09 | PROPOSED/OPEN | Slot/autosave/backup/format disahkan sebelum persistence | Belum ada |
| O10 | PROPOSED/OPEN | Penempatan di luar slice, allowlist/cap/konsumsi disahkan sebelum offline | Belum ada |
| O11 | PROPOSED/OPEN/VERIFY | Nama, kronologi dan source ledger sebelum konten final | Belum ada |
| O12 | PROPOSED/OPEN | Chapter, kalah, pewaris/tanpa pewaris sebelum desain pilot terkait | Belum ada |
| O13 | PROPOSED/OPEN | Bisnis, SDK/distribusi keputusan tersendiri saat rilis direncanakan | Belum ada |
| O14 | PROPOSED/OPEN | Beban, kapasitas dan angka performa setelah perangkat/spike | Belum ada |
| O15 | PROPOSED/OPEN | Pipeline art/audio dan lisensi sebelum produksi massal | Belum ada |

## Gate approval dan hasil audit

PRD tetap DRAFT dengan CONDITIONAL PASS reviewer. Sebelum global APPROVED, Director mengesahkan versi/lingkup O01-S dan baseline produk O02 secara eksplisit serta mencatat batas asumsi/TBD yang diterima. Data O03/O04 boleh tetap TBD pada dokumen; estimasi biaya/kalender dan tes/performa menunggu data terkait. O01-P/O01-M tetap deferred. Kontrak O06/O07/O09 dan [quality gates](QUALITY_GATES.md) harus siap untuk fitur terkait sebelum implementasi, terpisah dari penulisan dokumen.

Audit A01 memiliki penerimaan prinsip, tetapi manifest/kesiapan belum final. A03/A04 sudah memiliki dua aturan confirmed, tetapi spesifikasi belum lengkap. A05/A06/A07/A08 memiliki arah yang diterima dan pencatatan/traceability, bukan bukti implementasi. A02 **NOT TESTED**; penerimaan PRD tidak mensyaratkan mengarang kelulusan runtime dan tidak otomatis meluluskan M0. Engineering tetap menunggu otorisasi, audit baseline serta keputusan/kontrak prasyarat.
