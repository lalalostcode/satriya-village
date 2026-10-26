# SATRIYA VILLAGE — INDEPENDENT DESIGN & REPOSITORY AUDIT
**Tanggal:** 26 Oktober 2026  
**Lingkup:** Audit *read-only* terhadap repository `lalalostcode/satriya-village` pada branch `main` (commit yang teramati: `ef512596e1fddb67443c49078952f376df14abdf`), dibandingkan dengan `Satriya_Village_Planning_Handoff_v1.md` dan keputusan brainstorming yang tercatat.  
**Jenis audit:** Pemeriksaan dokumen dan source statis. **Bukan** uji Godot runtime, uji Android, kajian akademis sejarah, atau validasi Play Store. Tidak ada perubahan repository.

## 1. Executive verdict
**CONDITIONAL PASS untuk kesetiaan visi; HOLD untuk persetujuan scope dan engineering execution.** Konsep pokok tetap terjaga; PRD menunjukkan disiplin pemisahan visi masa depan dan slice pendek. Namun keputusan Game Director belum diratifikasi, serta interaksi prototype pernah dilaporkan gagal dan belum diuji ulang dengan bukti. Jangan menganggap PRD *approved*, M0 *passed*, atau fitur *implemented* berdasarkan keberadaan dokumen.

## 2. Referensi yang diperiksa
- `Satriya_Village_Planning_Handoff_v1.md`
- `README.md`, `AGENTS.md`, `.gitignore`, `project.godot`
- `docs/DECISIONS.md`, `ROADMAP.md`, `DOCUMENT_INDEX.md`, `GAP_ANALYSIS.md`, `PRD.md`, `MASTER_PLANNING.md`, `ARCHITECTURE_BLUEPRINT.md`, `AI_AGENT_STRATEGY.md`, `EXECUTION_BLUEPRINT.md`
- `scenes/main.tscn`, `scripts/main.gd`, keberadaan folder `assets`, `data`, `docs`, `tests`

Repo: https://github.com/lalalostcode/satriya-village

## 3. Kesesuaian terhadap konsep brainstorming
| Pilar asli | Status dokumen | Bukti / catatan |
|---|---|---|
| Android landscape, pixel-art isometrik chibi, identitas Nusantara | **TERJAGA** | Handoff §1/5, DECISIONS Premise, PRD §2/8 |
| Kepala desa Malang/Tumapel → kerajaan/vasal/kemerdekaan → potensi penyatuan Nusantara | **TERJAGA** | Handoff §1–2, DECISIONS Premise, PRD §2/7 |
| Sejarah alternatif, cerita bercabang, event warning/intervention | **TERJAGA TAPI BELUM DISPESIFIKASIKAN** | PRD FR09–10/FR18; tenggat dan resolusi belum GDD |
| NPC rakyat bekerja otomatis; named characters rinci dan bereaksi | **TERJAGA TAPI ADA RISIKO MODEL DATA** | PRD FR07/08; worker IDs individual di blueprint harus diselaraskan dengan ekonomi agregat |
| Enam atribut, dinasti, suksesi | **TERJAGA** | DECISIONS dan PRD FR15; status nama atribut antara handoff vs DECISIONS perlu ratifikasi |
| Pejabat semi-autonomous, wewenang anggaran, intrik | **TERJAGA SECARA VISI** | Slice hanya satu pejabat; intrik disimpan untuk perluasan |
| Ekonomi hybrid, produksi mendalam, kualitas barang, stok per desa, logistik | **TERJAGA SECARA VISI** | Tidak masuk seluruhnya ke slice; jangan kehilangan requirement ketika roadmap bertambah |
| Hybrid riset/ahli | **TERJAGA SECARA VISI** | PRD katalog sistem; belum ada spesifikasi teknis |
| Perang taktis, perintah, commander skills, open-field + settlement siege, konsekuensi kalah | **TERJAGA SECARA VISI** | Pilot mengusulkan battle lapangan dulu; siege ditunda, **bukan dibatalkan** |
| Sandbox bebas, guidance opsional, multiple solutions | **TERJAGA** | PRD FR09/10; diperlukan acceptance case follow/reject/ignore |
| Offline routine terbatas, bukan perang/event besar | **TERJAGA SECARA VISI** | PRD FR16 Later; keputusan batas offline OPEN |
| Solo pemula + Codex specialist agents | **TERJAGA** | AI_AGENT_STRATEGY: peran logis, satu writer aktif, kualitas berbasis acceptance test |

**Kesimpulan:** Tidak ditemukan penghapusan eksplisit pilar konsep; risiko utama adalah fitur “Later” kehilangan jalur roadmap/kontrak saat scope dieksekusi. Pertahankan *Vision Backlog* yang traceable ke decision ID.

## 4. Temuan prioritas

### BLOCKER — wajib sebelum implementasi
**A01 — Scope PRD masih DRAFT; belum ada persetujuan owner.**  
Bukti: `docs/PRD.md` header serta §16–17 menandai O01–O15 OPEN. PRD mengusulkan satu desa, tiga bangunan + sumber pemulihan kayu, satu pejabat, satu quest, sesi 10–15 menit; pilot dua settlement dan satu battle. Ini masuk akal sebagai **proposal**, tidak otomatis kesepakatan baru.  
**Tindakan:** Direktur menyetujui/menolak O01–O04 terlebih dahulu dan mencatat keputusan; ratifikasi O05–O15 bertahap sesuai dependensi.

**A02 — Milestone M0 belum terbukti lulus.**  
Bukti: pengguna melaporkan mekanik tidak jalan; README menguraikan tombol seolah fungsional; `scripts/main.gd` memiliki handler bangunan/kecepatan tetapi tidak ada bukti F5 saat ini. `tests/` tidak memuat tes yang dapat dieksekusi.  
**Tindakan:** Audit runtime Godot pada mesin pemilik: catat versi, log, klik HUD vs peta, build valid/invalid, biaya sekali, pause/1×/2×/3×, akumulasi hari; beri status PASS/FAIL/NOT TESTED dan langkah reproduksi. Jangan mengira ada bug spesifik tanpa uji.

**A03 — Dua skala waktu belum disepakati.**  
Bukti: starter memakai `SECONDS_PER_DAY=8`; visi game mengharapkan penuaan, suksesi, pergolakan sejarah, time skip dan offline limited. Jika dipakai literal sebagai usia karakter, timeline cerita akan tidak masuk akal.  
**Tindakan:** Definisikan tick simulasi, durasi hari, kalender naratif, durasi usia, event deadline, time skip, offline cap, dan perilaku pause sebagai GDD tersendiri sebelum dinasti.

### HIGH — sebelum spesifikasi modul terkait
**A04 — Model warga agregat dan ID worker individual masih tegang.**  
Bukti: handoff dan keputusan memilih masyarakat biasa agregat; Architecture Blueprint `BuildingState.worker_ids` dan uji tidak-double-assignment mendekati individu penuh.  
**Tindakan:** Pilih batas agregasi yang jelas: penduduk biasa dalam workforce pool/kelompok, named NPC punya ID; sprite dekoratif tidak identik dengan satu agen ekonomi. Tentukan pengecualian jika diperlukan.

**A05 — Ketersediaan sumber daya bisa menyebabkan *softlock*.**  
Bukti: source `wood=120`, biaya rumah/sawah/lumbung, tidak ada regenerasi kayu; food dihitung sederhana. PRD sudah menyadari dan meminta satu jalur pemulihan.  
**Tindakan:** GDD tetapkan cara memperoleh kayu, jalur keluar dari stok nol, kapasitas rumah, konsumsi menurut penduduk, dan rumus pekerja. Jangan menambah mekanik permanen hanya untuk memoles prototype.

**A06 — Salah tafsir status planning vs sumber keputusan.**  
Bukti: `DECISIONS.md` mengunci enam nama atribut, sedangkan handoff menjelaskan nama belum dikunci; draft PRD mendokumentasikan konflik, namun belum diratifikasi. Nama `Tirta Wening` dan `Babad Tanah Tumapel` juga hanya usulan.  
**Tindakan:** Buat satu *Decision Log* dengan ID, status, sumber, alasan, tanggal persetujuan dan konsekuensi; putuskan siapa yang boleh menaikkan `PROPOSED` ke `APPROVED`.

**A07 — Fitur strategis nanti harus punya jejak penerimaan.**  
Bukti: M0–M4 hanya memasukkan combat lapangan, satu tetangga, demonstrasi suksesi; logistik kompleks, riset, intelijen, siege dan banyak settlement masih ekspansi. Itu sah untuk solo developer, tetapi bisa hilang jika tidak ditrace.  
**Tindakan:** Tambahkan `VISION_BACKLOG.md` atau tabel traceability requirement D01–D27 → epic → milestone bersyarat → dokumen desain → acceptance target. Jangan menetapkan tanggal palsu.

**A08 — Android-first masih proposal belum bukti.**  
Bukti: rencana spike Android lebih dini belum disahkan, device minimum tidak tersedia, target FPS usulan belum diuji.  
**Tindakan:** Tetapkan satu ponsel uji, fitur input touch yang harus lolos, dan smoke test install/pause/suspend/resume sebelum memproduksi aset banyak.

### MEDIUM — kebersihan dan kontrol proses
**A09 — `.gitignore` memiliki byte null/teks UTF-16 campur dalam trailing lines.**  
Bukti: file terbaca sebagai normal ASCII di awal tetapi bagian akhir mengandung pola `G\0o\0d\0o\0t...` berulang.  
**Tindakan:** Pada *task maintenance terpisah*, tulis ulang sebagai UTF-8 tanpa NUL; jangan mengunggah executable Godot. Verifikasi `git check-ignore -v` dan `git status` setelahnya.

**A10 — Starter adalah monolith tanpa automatic tests.**  
Bukti: satu `Node2D` scene, `scripts/main.gd` mengurus HUD, grid, state, economy tick, input, dan rendering; `tests/.gitkeep` saja.  
**Tindakan:** Setelah M0 lolos, ekstrak clock dan state/placement per tugas kecil; tulis tes invariants sebelum/selama ekstraksi. Jangan mengganti seluruh arsitektur sekaligus.

**A11 — README overstates readiness relative to actual evidence.**  
Bukti: instruksi menyatakan tombol menjalankan aksi dan bagian “yang sudah ada” menyebut mekanik; pelaporan pemilik sebaliknya. README sudah menambahkan catatan “belum tervalidasi” di akhir.  
**Tindakan:** Tampilkan banner `prototype runtime unverified / M0 BLOCKED` di awal README hingga uji lulus; jangan menilai fitur selesai dari kode.

**A12 — Realisme sejarah dan target usia belum operationalized.**  
Bukti: setting sekitar era Tumapel; sumber sejarah, umur sasaran, tone perang, rating, dan advertising compliance belum disahkan.  
**Tindakan:** Tentukan rentang umur utama; buat lore source ledger dan panduan klaim prasasti/Pararaton/fiksi. Tidak perlu memasang ads SDK dalam prototype.

## 5. Observasi source Godot (statis, bukan diagnosis runtime)
- `project.godot` mengacu `res://scenes/main.tscn` dan Compatibility renderer, resolusi baseline 1280×720.
- `scenes/main.tscn` menghubungkan root Node2D ke `scripts/main.gd`.
- `scripts/main.gd`: `_unhandled_input` menangani klik dunia; Button HUD terhubung via signal `pressed.connect`; `_process` mengakumulasi `delta*speed` dan memanggil `_advance_day()` per 8 detik game.
- Penempatan bangunan mengurangi `wood`; Rumah langsung menambah `population` dua orang; dua Sawah awal memberi pangan `(fields*5)-3` per hari.
- Dua NPC yang terlihat hanyalah animasi dekoratif, bukan AI; tidak ada save/load atau metode untuk mendapatkan kayu.
- **Tidak ada penyebab tunggal kegagalan semua tombol yang dapat dibuktikan dari pembacaan source.** Perlu reproduksi Godot pada perangkat pengguna. UI time tidak menampilkan progress detik, sehingga pada 1× perubahan hari baru terlihat sesudah ~8 detik jika kode berjalan.

## 6. Rekomendasi keputusan Product Director
**Terima secara prinsip:** identitas dunia/pilar, pemisahan core loop kecil dengan visi luas, pembatasan satu desa/satu quest untuk vertical slice, satu orang pengendali perubahan Git, tidak ada fitur iklan sebelum game menyenangkan, dan audit M0 sebelum implementasi.

**Belum boleh dikunci tanpa review:** definisi MVP sebagai *pilot yang dipoles* (durasi/konten tetap perlu diputuskan), isi persis pilot, pemisahan kalender sim/naratif, enam nama atribut, bahasa/usia utama, model workforce, batas Android, nama desa/kampanye, dan nilai balancing.

**Jangan ditafsirkan sebagai penghapusan visi:** combat formasi, village siege, dinasti kompleks, intrik/kudeta, riset hybrid, advanced production chains dan kualitas, stock per settlement/logistik, penggabungan Nusantara.

## 7. Rencana berikutnya, berurutan
1. **Planning review:** setujui batas vertical slice secara prinsip; catat target audiens awal, device uji, kapasitas jam per minggu dan budget. Ratifikasi hanya keputusan yang dibutuhkan sekarang.
2. **M0 runtime audit:** jalankan Godot pada repository saat ini, simpan log dan video/screenshot interaksi; identifikasi error reproduktif tanpa langsung refactor.
3. **Fix baseline:** sesudah sebab jelas, patch kecil, tes input/time/build dengan expected/actual, checkpoint Git.
4. **GDD minimum:** clock/calendar, ekonomi/pemulihan, agregasi workforce, quest dua solusi, status keputusan, definisi satu desa.
5. **TDD + contracts minimum:** model/view boundary, invariant, save format, QA test harness, lalu implementasi M1/M2 bertahap.
6. **Android smoke test** sedini mungkin setelah baseline stabil dan target device diketahui; jangan menunggu seluruh fitur pilot.

## 8. Instruksi siap tempel untuk Astra
> Review audit independen `Satriya_Village_Independent_Audit_2026-10-26.md` bersama handoff, DECISIONS, GAP_ANALYSIS dan PRD. Jangan mengubah repository atau menulis kode. Susun **PRD revision proposal** yang menutup A01, A03, A04, A05, A06, A07, dan A08; pertahankan semua visi yang disetujui sebagai traceable deferred requirements. Tandai keputusan Director yang perlu ratifikasi, sebutkan dokumen/section asal, usulkan perubahan minimal, dan jangan menaikkan PROPOSED menjadi APPROVED. Untuk A02 dan masalah runtime, keluarkan task card audit Godot read-only dengan expected/actual dan evidence checklist; jangan mengklaim issue fixed tanpa F5.

**Hasil final audit:** **Design aligned; planning conditionally ready for approval review; engineering not authorized; runtime baseline unverified.**
