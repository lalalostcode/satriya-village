# Satriya Village — M0 Gameplay Audit Plan

Tanggal: 26 Oktober 2026. ID: **AUDIT-M0-01**. Status eksekusi A02: **NOT TESTED**. Ini task card/rencana audit, bukan AUDIT_REPORT atau klaim perbaikan. Sumber: [PRD §19](PRD.md), [audit independen historis](reviews/Satriya_Village_Independent_Audit_2026-10-26.md), [Quality Gates Q1/Q2](QUALITY_GATES.md).

## 1. Tujuan dan batas

Buktikan launch dan interaksi starter pada Windows, kumpulkan error, dan reproduksi kegagalan sebelum diagnosis/refactor. Tidak mengubah kode, scene, project config, art atau aturan gameplay. Tidak menguji requirement masa depan seolah sudah ada. Player avatar/interaksi FR19, workforce AI, quest, save/load dan Android belum menjadi kemampuan starter yang dibuktikan.

Pengguna saat ini meminta persiapan dokumentasi; audit ini belum dijalankan. Untuk eksekusi read-only, gunakan salinan kerja terpisah agar cache/editor tidak mengubah repository sumber; simpan log/report/video di luar repository sumber. Jika lokasi salinan/evidence belum tersedia, tentukan saat task dimulai. Mencatat cache side effects lebih akurat daripada menyatakan editor tidak menulis file sama sekali.

## 2. Prasyarat dan baseline

- Catat commit penuh, branch, working-tree status before/after, path salinan dan sumber. Baseline penyusunan `3e014aa`; periksa ulang saat audit. Jangan reset atau menimpa perubahan pengguna.
- Saat editorial berlangsung muncul perubahan lokal main dan file simulasi/tes dari luar task dokumentasi. Expected tabel adalah snapshot starter yang diperiksa di awal; cocokkan dengan commit/diff aktual sebelum eksekusi. Pilih snapshot uji secara eksplisit dan jangan mencampur hasil dua versi atau mengklaim perubahan itu sudah lolos.
- Temukan executable dan rekam versi aktual; nama folder dan project feature string bukan bukti versi. Godot 4.7.2 Standard adalah constraint proyek. Jika executable tidak tersedia, status launch/interaksi NOT TESTED dan minta pemilik menjalankan F5 serta membagikan error.
- Rekam Windows, display scaling, viewport/window, cara launch (editor F5/standalone) dan log. Headless import/parser terpisah dari F5; exit 0 dengan error lingkungan tidak disebut bersih.
- Inspeksi source awal: GRID 10×10, wood 120, food 60, coins 150, population 8, day 1, speed 1×, selected Sawah. Bangunan awal Rumah (4,4), Sawah (3,4)/(4,5). Konfirmasi source tidak berubah sebelum menggunakan expected ini.

## 3. Kasus audit starter

Gunakan sesi baru untuk kasus independen. Pause segera saat mengisolasi placement. Jika hari sudah maju sebelum pause, rekam snapshot aktual atau mulai ulang; jangan mengarang day 1. Uji klik valid dengan anotasi cell/posisi layar, bukan koordinat tebakan ketika window berbeda.

| ID | Langkah | Expected source starter | Actual / bukti |
|---|---|---|---|
| M0-01 | Buka proyek, F5 | Scene/grid/HUD tampil; catat log/error dan kontrol yang terjangkau | NOT TESTED |
| M0-02 | Pause, klik Rumah/Sawah/Lumbung | Selected/status berubah; selector sendiri tidak membayar/menempatkan | NOT TESTED |
| M0-03 | Sesi baru, pause, Rumah di cell kosong | Wood 120→90, population 8→10, count 3→4; satu debit/entity | NOT TESTED |
| M0-04 | Sesi terpisah, Sawah valid | Wood 120→100, population tetap, count 3→4 | NOT TESTED |
| M0-05 | Sesi terpisah, Lumbung valid | Wood 120→75, population tetap, count 3→4; source belum memberi kapasitas storage | NOT TESTED |
| M0-06 | Klik cell terisi | State ekonomi/count tidak berubah; pesan petak terisi | NOT TESTED |
| M0-07 | Klik titik dunia jelas di luar grid | State tidak berubah; lokasi klik/viewport dicatat | NOT TESTED |
| M0-08 | Sesi baru, pause, enam Sawah berbeda, coba Rumah | Wood 0, count 9 sebelum Rumah; Rumah ditolak, tidak menambah population/entity, butuh 30 kayu | NOT TESTED |
| M0-09 | Klik tombol speed, selector dan blank HUD panel | Tidak ada placement/debit akibat klik UI | NOT TESTED |
| M0-10 | Pause pada snapshot, tunggu ≥10 detik | Day/food/coins tetap; NPC dekoratif dapat terus beranimasi | NOT TESTED |
| M0-11 | Peta awal, ukur antartransisi hari pada 1×/2×/3× | Sekitar 8/4/2,67 detik nyata per hari; catat actual/toleransi pengukuran | NOT TESTED |
| M0-12 | Peta awal tanpa perubahan, amati n transisi | Food 60+7n, coins 150+2n jika mulai baseline utuh; wood/population tetap | NOT TESTED |
| M0-13 | Pause di tengah hari, tunggu, resume | Tidak mengejar durasi pause; sisa interval sebelum pause dipertahankan | NOT TESTED |
| M0-14 | Ulang kasus gagal dari F5 baru | Catat konsistensi reproduksi dan error pertama; jangan menyimpulkan sebab tanpa bukti | NOT TESTED |

Mengukur antartransisi menghindari sisa interval ketika tombol speed diklik. Sawah tambahan memberi +5 pada perubahan pangan harian dalam source; konsumsi total tetap 3 walaupun rumah menambah warga. Ini observasi expected starter, bukan balancing final. Karakter dekoratif yang bergerak tidak membuktikan worker AI. Tidak ada asumsi bahwa semua tombol memiliki satu penyebab bug.

## 4. Evidence checklist dan laporan

Setiap kasus memiliki PASS/FAIL/NOT TESTED, langkah, initial snapshot, expected, actual, engine/build/display dan bukti screenshot/video. Simpan video F5/input peta vs HUD, before/after resource/count/day, cell atau koordinat klik, timestamp transisi, log lengkap terutama error pertama. Pisahkan environment/launch blocker, bug produk, keterbatasan starter yang memang belum fitur, dan ketidakpastian pengukuran.

Jika launch gagal, kasus interaksi NOT TESTED; jangan menandainya FAIL seolah telah diklik. Report audit boleh lengkap dengan hasil gagal/terhalang. Bila bukti hanya parser atau source, M0 tidak passed. Android, save/load, avatar FR19 dan quest di luar audit starter ditandai NOT TESTED/not implemented sesuai bukti; jangan dibangun pada task audit ini.

Laporan berikutnya memuat sumber baseline, matriks kasus, evidence paths, issue severity, reproduksi, dugaan vs sebab terbukti, known limitations dan rekomendasi task fix terkecil. Jangan menulis AUDIT_REPORT berisi hasil rekaan sekarang. Laporan masuk repository hanya bila scope penyerahan mengizinkannya; audit sumber tetap read-only.

## 5. Gate keluar dan tindak lanjut

Q1 selesai bila seluruh kasus dicoba atau alasan tidak diuji jelas, evidence tersimpan dan issue dapat ditindaklanjuti. Q2/M0 passed memerlukan F5 dan kontrol inti yang benar-benar lolos, termasuk biaya/waktu/ledger; bukan hanya selesainya laporan. Fix baseline adalah task terpisah dengan allowed files, satu bug, parser serta reproduksi/regression. Rebuild massal membutuhkan keputusan arsitektur terpisah.

Sebelum fitur baru, pastikan baseline stabil dan kontrak teknis terkait pada [TDD](TDD.md) siap. Retain nilai starter selama audit/fix agar perubahan desain tidak menutupi bug. Android smoke direncanakan setelah input/gameplay dasar stabil dan data perangkat tersedia.
