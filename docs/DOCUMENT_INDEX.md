# Satriya Village — Peta Dokumen

Mulai di sini untuk menemukan dokumen proyek dan mengetahui fungsi masing-masing. **Status penting:** keputusan di `DECISIONS.md` dan urutan milestone di `ROADMAP.md` tetap berlaku. PRD, gap analysis, dan blueprint adalah draf untuk ditinjau Game Director; isinya belum otomatis disetujui sebagai scope implementasi.

## Jalur baca

1. **Memahami proyek:** [README](../README.md) → [handoff perencanaan](../Satriya_Village_Planning_Handoff_v1.md).
2. **Mengetahui batas dan keputusan yang berlaku:** [AGENTS](../AGENTS.md) → [DECISIONS](DECISIONS.md) → [ROADMAP](ROADMAP.md).
3. **Meninjau arah produk:** [Gap Analysis](GAP_ANALYSIS.md) → [PRD](PRD.md). Mulai dari gap untuk melihat konflik, lalu baca PRD untuk scope, requirement, dan keputusan terbuka.
4. **Merencanakan pekerjaan setelah scope disetujui:** [Master Planning](MASTER_PLANNING.md) → [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) → [AI Agent Strategy](AI_AGENT_STRATEGY.md) → [Execution Blueprint](EXECUTION_BLUEPRINT.md).

## Fungsi setiap dokumen

| Dokumen | Untuk apa | Status |
|---|---|---|
| [README](../README.md) | Cara membuka proyek Godot dan ringkasan kemampuan starter. | Panduan proyek; daftar fitur belum membuktikan runtime bekerja. |
| [Handoff perencanaan](../Satriya_Village_Planning_Handoff_v1.md) | Merangkum visi, keputusan, usulan, hal yang perlu diverifikasi, serta permintaan PRD. | Bahan sumber; bukan PRD final. |
| [AGENTS](../AGENTS.md) | Aturan kerja agent: scope, keselamatan, gaya kode, verifikasi, dan peran. | Instruksi repository. |
| [DECISIONS](DECISIONS.md) | Mencatat arah desain yang sudah disetujui, termasuk visi sistem masa depan. | Keputusan yang berlaku; tidak semua fitur dijadwalkan untuk MVP. |
| [ROADMAP](ROADMAP.md) | Menetapkan urutan milestone M0–M4 dan batas implementasi. | Roadmap yang berlaku. |
| [Gap Analysis](GAP_ANALYSIS.md) | Menunjukkan konflik antardokumen, informasi yang belum ada, prioritas, serta bukti/keputusan untuk menutupnya. | Draf untuk review Game Director. |
| [PRD](PRD.md) | Mendefinisikan sasaran produk, lapisan scope, requirement, acceptance criteria, strategi Android, risiko, dan keputusan terbuka. | Draf untuk review Game Director; belum memberi izin coding. |
| [Master Planning](MASTER_PLANNING.md) | Menjelaskan pengalaman inti, batas scope, dependensi sistem, dan rencana spesifikasi lanjutan. | Proposal pra-produksi. |
| [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) | Mengusulkan pemisahan model dan tampilan, kontrak state, tick, save, serta pengujian. | Proposal teknis; bukan struktur yang sudah dibangun. |
| [AI Agent Strategy](AI_AGENT_STRATEGY.md) | Menetapkan peran logis, kepemilikan file, alur review, dan quality gates. | Proposal organisasi; tidak mengaktifkan agent otomatis. |
| [Execution Blueprint](EXECUTION_BLUEPRINT.md) | Mengurutkan pekerjaan dari audit baseline sampai pilot, dengan gate dan contoh task. | Backlog usulan; bukan otorisasi implementasi. |
| [Architecture](ARCHITECTURE.md) | Ringkasan struktur starter yang ada dan modul produksi yang direncanakan. | Catatan arsitektur awal; modul rencana belum tentu ada. |

## Cara memakai status

`CONFIRMED` berarti keputusan yang tercatat; `PROPOSED` berarti rekomendasi; `VERIFY` membutuhkan riset atau uji; `OPEN` membutuhkan keputusan Game Director. Jika dua dokumen berbeda status atau rincian, lihat tabel konflik di [Gap Analysis](GAP_ANALYSIS.md). Jangan menganggap keberadaan dokumen, kode, atau tombol sebagai bukti fitur telah diuji.

Dokumen audit runtime, GDD rinci, TDD, format save, rencana uji, dan checklist rilis yang disebut dalam PRD adalah **keluaran yang direncanakan**, belum ada sebagai berkas proyek. Urutannya mengikuti dependensi pada PRD dan hasil audit, bukan dibuat sekaligus.
