# Satriya Village — Prototype 0.2

Implementasi 26 Oktober 2026: state desa, transaksi stok, definisi bangunan dan clock terpisah dari presentasi; kamera memakai drag mouse tengah dan roda mouse. Aturan ekonomi starter tetap baseline pengujian. Lihat [hasil audit, kontrak minimum, dan langkah tes](docs/IMPLEMENTATION_M0_M1.md). Save/load dan kontrol touch belum tersedia.

Prototipe **belajar Godot + Codex** untuk Windows; bukan permainan lengkap atau build Play Store.

**Status verifikasi:** audit gameplay M0/A02 **NOT TESTED**; langkah di bawah adalah cara mencoba prototype, bukan bukti fitur telah lolos. Perencanaan memakai baseline provisional reviewer (CONDITIONAL PASS), tanpa approval otomatis scope pilot/MVP. Mulai dokumentasi dari [Peta Dokumen](docs/DOCUMENT_INDEX.md), [PRD](docs/PRD.md) dan [Decision Register](docs/DECISION_REGISTER.md). [M0 Audit Plan](docs/M0_AUDIT_PLAN.md) menjelaskan bukti F5 yang masih diperlukan.

## Menjalankan (Windows)

1. Ekstrak ZIP ini ke `C:\Dev\SatriyaVillage` sehingga `project.godot` ada langsung di folder itu (bukan di subfolder lain).
2. Jalankan **Godot 4.7.2 Standard**.
3. Klik **Import**, arahkan ke `C:\Dev\SatriyaVillage\project.godot`, lalu **Import & Edit**.
4. Tekan **F5** (**Run Project**) untuk menjalankan demo.
5. Pilih `Rumah`, `Sawah`, atau `Lumbung`, lalu klik petak kosong.
6. Ubah kecepatan waktu dengan tombol **Pause, 1x, 2x, 3x**.
7. Buka folder yang sama di **Codex**, lalu minta perbaikan atau fitur berikutnya secara bertahap.

> Catatan: `scenes/main.tscn` adalah scene utama yang ditetapkan oleh `project.godot`, jadi F5 dapat langsung menjalankan proyek.

## Yang sudah ada

- Kerangka proyek Godot 4.7.2 GDScript, Compatibility renderer.
- Layar landscape 1280×720.
- Grid isometrik buatan kode dan bangunan placeholder (rumah, sawah, lumbung).
- UI sumber daya; laju waktu pause, 1x, 2x, 3x; ekonomi sangat sederhana.
- NPC yang **hanya animasi dekoratif** (AI NPC belum dibuat).
- Instruksi `AGENTS.md` untuk Codex dan roadmap pengembangan.

## Yang belum ada

Save/load, NPC AI, produksi berantai, quest cerita, diplomasi, militer, Android export, sprite pixel-art asli. Jangan mengklaim modul ini telah selesai.

## Catatan untuk coding agent

- Baca `AGENTS.md` dan `docs/DECISIONS.md` sebelum mengubah kode.
- Ubah satu fitur per tugas, jalankan Godot setelah perubahan, dan laporkan error yang ditemukan.
- Perubahan `project.godot` harus tetap compatible dengan Godot 4.7.2.

## Paket pra-produksi

Mulai dari [Master Planning](docs/MASTER_PLANNING.md), lalu [Architecture Blueprint](docs/ARCHITECTURE_BLUEPRINT.md), [AI Agent Strategy](docs/AI_AGENT_STRATEGY.md), dan [Execution Blueprint](docs/EXECUTION_BLUEPRINT.md). Paket ini berisi proposal scope, kontrak, urutan dokumentasi dan audit awal; bukan fitur yang sudah diimplementasikan atau perubahan keputusan yang otomatis disetujui. Status gameplay prototype tetap belum tervalidasi sampai audit interaksi selesai.
