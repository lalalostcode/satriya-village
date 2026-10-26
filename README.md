# Current F5 target — sprite visual review

26 October 2026: Director rejected the procedural visual prototype. F5 now opens `scenes/visual_village.tscn` with 16 transparent PNG sprite candidates, a compact HUD, hidden detail/build panels, object selection and camera controls. **Visual status: REVISE, awaiting Director review.** All UI data is mock data; this scene does not write saves or run the economy.

Press **F5** in Godot 4.7.2. Use **Bangun**, **Krisis pangan**, click an object, drag, scroll, and **Reset**. **Esc** closes panels; **Space** pauses decorative idle. The preserved mechanics demo is `scenes/main.tscn`: open it and press **F6**.

[Asset inventory, replacement pipeline and manual review](assets/visual/README.md) · [BEFORE](docs/screenshots/visual_before.png) · [AFTER](docs/screenshots/visual_after.png). Sprite art is AI-generated and unapproved; ground tiles and UI borders remain placeholders. Parser/import and 15 focused rendered checks passed; Android and human acceptance of the rework remain untested. No complex mechanics expansion before visual approval.

---

The following describes the preserved **legacy mechanics scene**, not the current F5 visual demo.
# Satriya Village — Prototype 0.3

Implementasi 26 Oktober 2026: state desa, transaksi stok, definisi bangunan dan clock terpisah dari presentasi. Kamera mendukung drag mouse tengah/roda mouse serta touch tap/drag/pinch. Save/load manual, autosave terpisah, dan pemulihan cadangan tersedia. M2 kini memiliki pekerja agregat: sawah membutuhkan petani untuk menghasilkan pangan. Lihat [kontrak/tes pekerja M2](docs/M2_WORKFORCE_CONTRACT.md), [fondasi M1](docs/M1_FOUNDATION_VERIFICATION.md), dan [kontrak save v2](docs/SAVE_FORMAT.md).

Prototipe **belajar Godot + Codex** untuk Windows; bukan permainan lengkap atau build Play Store.

**Status verifikasi (26 Oktober 2026):** import/parser PASS; 406 assertion gameplay/persistence/touch/autosave/pekerja/migrasi/restart PASS; renderer Compatibility dan layout tombol 1280×720 PASS. Uji F5 manusia lengkap dan Android fisik masih NOT TESTED. Penerimaan milestone oleh Director tetap terpisah dari tes otomatis. Perencanaan memakai baseline provisional reviewer (CONDITIONAL PASS), tanpa approval otomatis scope pilot/MVP. Mulai dokumentasi dari [Peta Dokumen](docs/DOCUMENT_INDEX.md), [PRD](docs/PRD.md) dan [Decision Register](docs/DECISION_REGISTER.md).

## Menjalankan (Windows)

1. Ekstrak ZIP ini ke `C:\Dev\SatriyaVillage` sehingga `project.godot` ada langsung di folder itu (bukan di subfolder lain).
2. Jalankan **Godot 4.7.2 Standard**.
3. Klik **Import**, arahkan ke `C:\Dev\SatriyaVillage\project.godot`, lalu **Import & Edit**.
4. Untuk prototype simulasi/pekerja 0.3, buka `scenes/main.tscn` lalu tekan **F6** (**Run Current Scene**). F5 mengikuti scene utama pada konfigurasi proyek; pekerjaan visual lain dapat mengarahkannya ke `scenes/visual_village.tscn`.
5. Pilih `Rumah`, `Sawah`, atau `Lumbung`, lalu klik petak kosong.
6. Ubah kecepatan waktu dengan tombol **Pause, 1x, 2x, 3x**.
7. Klik **Simpan** untuk menyimpan desa. Setelah membuka ulang game, klik **Muat** untuk melanjutkan. **Cadangan** memuat snapshot sebelum simpan terakhir yang berhasil; tersedia setelah dua kali simpan. Load mengganti sesi aktif dan mengembalikan kecepatan waktu yang tersimpan.
8. Buka folder yang sama di **Codex**, lalu minta perbaikan atau fitur berikutnya secara bertahap.

**Touch:** tap petak kosong membangun saat jari dilepas; geser satu jari menggerakkan kamera; cubit dua jari melakukan zoom. Drag/pinch tidak membangun. Tombol tetap dapat diketuk melalui input touch Godot.

**Petani:** satu petani mengaktifkan satu sawah dengan hasil 5 pangan/hari. **Petani -/+** mengatur batas penugasan; **Otomatis** mengisi sawah sesuai warga tersedia. Perubahan boleh saat pause dan berlaku untuk panen berikutnya. Awal desa: 2 petani, 6 warga belum bekerja, panen 10 dan konsumsi 3 = +7 pangan/hari. HUD menampilkan perkiraan serta laporan panen saat hari berganti. Batas penugasan ikut disimpan; file v1 lama dimuat melalui migrasi otomatis ke kebijakan petani Otomatis.

**Autosave:** slot terpisah diperbarui tiap 60 detik bila state berubah, serta saat aplikasi kehilangan fokus/suspend atau ditutup normal. Jika slot otomatis sudah ada saat membuka game, penulisannya dilindungi: pilih **Muat Otomatis** atau **Cadangan Otomatis** untuk melanjutkan, atau aktifkan **Autosave: Mati** untuk menggunakan slot bagi sesi baru. Simpanan manual tetap terpisah. Kegagalan autosave saat menutup membuat game tetap terbuka agar bisa dicoba lagi.

> Catatan: pengujian gameplay pada tugas ini secara eksplisit memuat `scenes/main.tscn`. Scene visual yang sedang dikerjakan terpisah belum diintegrasikan dengan simulasi pekerja ini.

## Yang sudah ada

- Kerangka proyek Godot 4.7.2 GDScript, Compatibility renderer.
- Layar landscape 1280×720.
- Grid isometrik buatan kode dan bangunan placeholder (rumah, sawah, lumbung).
- UI sumber daya; laju waktu pause, 1x, 2x, 3x; ekonomi sangat sederhana.
- Save/load manual JSON berversi, validasi data, serta cadangan terakhir yang sehat.
- Autosave terpisah, perlindungan simpanan sesi sebelumnya, retry terjadwal, dan penghentian simulasi saat aplikasi berada di background.
- Kamera mouse/touch, tap versus drag/pinch, serta tombol setinggi minimum 44 unit desain.
- Pekerja pertanian agregat, batas manual/otomatis, produksi sesuai tenaga kerja, dan laporan pangan harian. Ini belum AI gerak NPC individual.
- NPC yang **hanya animasi dekoratif** (AI NPC belum dibuat).
- Instruksi `AGENTS.md` untuk Codex dan roadmap pengembangan.

## Yang belum ada

NPC AI, produksi berantai, quest cerita, diplomasi, militer, progres offline, Android export/perangkat fisik, sprite pixel-art asli. Jangan mengklaim modul ini telah selesai.

## Catatan untuk coding agent

- Baca `AGENTS.md` dan `docs/DECISIONS.md` sebelum mengubah kode.
- Ubah satu fitur per tugas, jalankan Godot setelah perubahan, dan laporkan error yang ditemukan.
- Perubahan `project.godot` harus tetap compatible dengan Godot 4.7.2.

## Paket pra-produksi

Mulai dari [Master Planning](docs/MASTER_PLANNING.md), lalu [Architecture Blueprint](docs/ARCHITECTURE_BLUEPRINT.md), [AI Agent Strategy](docs/AI_AGENT_STRATEGY.md), dan [Execution Blueprint](docs/EXECUTION_BLUEPRINT.md). Paket ini berisi proposal scope, kontrak, urutan dokumentasi dan audit awal; bukan fitur yang sudah diimplementasikan atau perubahan keputusan yang otomatis disetujui. Status gameplay prototype tetap belum tervalidasi sampai audit interaksi selesai.
