# Satriya Village — Quality Gates v0.1

Tanggal: 26 Oktober 2026. **DRAFT / rencana verifikasi**, bukan hasil uji. Sumber: [PRD](PRD.md), [GDD](MASTER_GDD.md), [TDD](TDD.md), [SAVE_FORMAT](SAVE_FORMAT.md), [Decision Register](DECISION_REGISTER.md). CONDITIONAL PASS reviewer hanya penilaian dokumen; A02 gameplay tetap **NOT TESTED**.

## 1. Status bukti dan penerimaan

- PASS: expected terpenuhi pada kasus/build/perangkat yang dicatat.
- FAIL: expected tidak terpenuhi dengan observasi dan reproduksi.
- NOT TESTED: belum dieksekusi, tidak tersedia prasyarat, atau terhalang tahap sebelumnya. Jangan mengubahnya menjadi PASS dari inspeksi source.
- PENDING REVIEW: keputusan/kontrak belum diterima. Ini status readiness, bukan hasil pengujian.

Setiap laporan mencatat baseline commit, working tree, engine/build/perangkat, fixture, langkah, expected/actual, status, link bukti, known limitations dan next action. Pisahkan gejala, dugaan dan sebab terbukti. Director menerima milestone; author tidak meluluskan pengalaman pemain berdasarkan parser.

## 2. Gate berurutan dan batas aktivasi

| Gate | Syarat keluar / bukti minimum | Pemilik dan batas |
|---|---|---|
| Q0 — dokumen | Tautan relatif valid; ID/traceability terjaga; baseline provisional/TBD tidak berubah menjadi confirmed; game source tidak berubah pada task dokumen | Lead/editor. Review desain Director tetap terpisah dari pemeriksaan dokumen |
| Q1 — audit M0 selesai | Kasus [M0 plan](M0_AUDIT_PLAN.md) dieksekusi atau hambatannya jelas; log/evidence dan task fix terkecil tersedia | QA; selesai audit boleh menghasilkan FAIL/NOT TESTED, bukan otomatis M0 passed |
| Q2 — baseline M0 diterima | F5 dan kontrol inti teruji; bug blocker ditangani melalui task terpisah; regression expected starter lolos | QA + Director; belum tercapai, A02 NOT TESTED |
| Q3 — ready per fitur | Scope/otorisasi, keputusan O terkait, owner/allowed files, kontrak/error/invariants, fixture/expected/manual test cukup | Lead + Director untuk keputusan substansial. Dokumen draft saja tidak cukup |
| Q4 — implementasi fitur diterima | Parser/import, model/integration yang relevan dan manual case lolos; diff kecil; tidak ada blocker terbuka untuk scope tugas | Implementer + reviewer; jalankan hanya setelah Q2/Q3 |
| Q5 — slice Windows | Loop FR01–FR11 yang relevan + FR19; dua hasil quest dan pemulihan; avatar/interaksi; save/recovery; usability | QA + Director; touch Android tetap gate terpisah |
| Q6 — Android smoke | Perangkat fisik bernama, build/install/input/landscape/pause/lifecycle teruji setelah fondasi stabil | QA; data perangkat TBD memblokir eksekusi, bukan penulisan rencana |
| Q7 — slice Android/performa | Semua kontrol touch termasuk FR19; save/recovery dan lifecycle; workload/profile bernama memenuhi target yang telah dipilih | QA + Director; FPS/memori belum target terverifikasi |
| Q8 — pilot/MVP | Scope masing-masing disetujui terpisah, konten/konsekuensi/kapasitas dan rilis relevan terbukti | Director; tidak aktif dari kelulusan slice |

Q6 boleh dimulai setelah subset input/gameplay dasar stabil, tanpa menunggu seluruh konten slice Q5; setiap fitur belum tersedia tetap NOT TESTED. Q7 membutuhkan loop slice dan perangkat. Tidak perlu memutuskan seluruh sistem masa depan untuk Q3 suatu fitur.

## 3. Matriks verifikasi slice

Seluruh kasus runtime/model di bawah saat penyusunan **NOT TESTED**. Fixture ekonomi/quest yang memerlukan angka belum dipilih juga PENDING REVIEW.

| Kelompok / requirement | Kasus penting | Bukti dan manual minimum |
|---|---|---|
| Placement/input FR01/02 | Biaya tepat sekali; occupied/outside/biaya kurang no mutation; UI/drag/pinch tidak menempatkan | Nilai before/after, cell dan video; uji setelah pan/zoom |
| Waktu FR03 | Pause otomatis berhenti; explicit command tetap valid; tick/input sama menghasilkan state sama di speed berbeda | Model fixture + video pause/command; dekorasi dibedakan dari simulasi |
| Ekonomi FR04/05 | Ledger, stok nol, pekerja penuh, peta penuh, produksi tanpa pekerja, pemulihan | Parameter/expected disahkan; rekonsiliasi stok dan langkah pemulihan |
| Workforce/pejabat FR07/08 | Kapasitas/alokasi tidak ganda, named official tidak menambah pool, mandat/anggaran | Bandingkan alokasi, ubah prioritas, coba aksi di atas wewenang |
| Quest FR09/10 | ≥2 hasil berbeda; follow/reject/ignore, warning, efek sekali setelah load | Fixture masing-masing jalur, snapshot/response tokoh, reload sebelum/sesudah |
| Save FR06 | Round-trip, corrupt/version/ref gagal, backup, gagal tulis/interupsi, pause+command snapshot | Last good tetap dapat dipakai; load gagal tidak mengganti sesi aktif |
| Player FR19 | Avatar teridentifikasi dan ≥1 interaksi, tanpa locomotion/editor besar | Mouse dan touch, pause dan berjalan, panel dibuka ulang, save/load ID; tidak mengubah hitungan ekonomi |
| Android FR11 | Install, start, gesture, safe area/teks, suspend/resume, tutup/buka | Build/perangkat/OS bernama; duration/status sebelum-sesudah; tidak ada reward/transaksi ganda |

UI mudah dibaca dan aksesibilitas diperiksa melalui observasi pemain/perangkat, bukan hanya screenshot desktop. Kegagalan kontrol inti, crash, data loss, atau efek ekonomi/quest ganda adalah blocker gate terkait. Temuan visual minor dicatat terpisah tanpa menyembunyikan blocker.

## 4. Profil dan usability

Baseline desain provisional: 13+, Bahasa Indonesia, non-grafis, onboarding bertahap; bukan age rating. Target sesi evaluasi 10–15 menit. Jumlah peserta serta target 2 dari 3 pada PRD tetap proposal; jika peserta di bawah umur, tata cara partisipasi ditetapkan bersama wali sebelum tes. Catat kesulitan memahami pangan/prioritas, waktu menemukan interaksi pemain/pejabat, salah input, kebutuhan bantuan dan dua hasil quest. Pengukuran lokal manual; tidak menambah analytics.

Untuk profil, catat build/engine, model/RAM/OS/GPU, peta/entitas/alokasi/workload, durasi sesi, frame time p95, memori dan stabilitas. Angka 30 FPS/p95 33,3 ms dari PRD adalah kandidat yang masih perlu dipilih/diuji; tidak menjadi PASS otomatis. Minimum supported ditentukan terpisah dari ponsel uji awal. Jam kerja/budget yang TBD tidak diubah menjadi deadline atau biaya Rp0.

## 5. Checklist handoff dan regression

Task dianggap siap diulas bila scope, hasil, exact files, perintah/check aktual, expected/actual, bukti, keputusan tertunda dan satu next step tersedia. Ulang tes yang terkena perubahan atau risiko konkret; jangan membuat tes yang hanya meniru implementasi. Setelah checks relevan lulus, lakukan review dan checkpoint/commit terbatas. Catat satu entri [Task Log](TASK_LOG.md) per instruksi selesai, bukan per edit.

Dokumentasi saat ini dapat lolos Q0 teknis, tetapi tidak mengubah Q1–Q8 menjadi PASS. Laporan runtime diisi hanya sesudah audit dijalankan. Referensi source/audit lama bukan pengganti evidence F5 baru.
