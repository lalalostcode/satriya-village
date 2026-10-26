# Satriya Village — Peta Dokumen

Mulai di sini untuk menemukan dokumen proyek dan mengetahui fungsi masing-masing. **Status penting:** [PRD v1.1](PRD.md) merevisi v1.0 pada berkas yang sama dan masih DRAFT. [Decision Register](DECISION_REGISTER.md) membedakan keputusan confirmed, penerimaan prinsip, proposal dan pertanyaan terbuka. Urutan M0–M4 tetap dipertahankan; scope pilot/MVP belum disetujui. Audit gameplay A02 NOT TESTED.

## Jalur baca

1. **Memahami proyek:** [README](../README.md) → [handoff perencanaan](../Satriya_Village_Planning_Handoff_v1.md).
2. **Mengetahui batas dan keputusan yang berlaku:** [AGENTS](../AGENTS.md) → [Task Log](TASK_LOG.md) → [DECISIONS](DECISIONS.md) → [Decision Register](DECISION_REGISTER.md) → [ROADMAP](ROADMAP.md).
3. **Meninjau arah produk:** [audit independen](reviews/Satriya_Village_Independent_Audit_2026-10-26.md) → [Gap Analysis](GAP_ANALYSIS.md) → [PRD v1.1](PRD.md). Lihat register untuk pertanyaan O01–O04 dan PRD §19 untuk task card runtime yang belum dijalankan.
4. **Merencanakan pekerjaan setelah scope disetujui:** [Master Planning](MASTER_PLANNING.md) → [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) → [AI Agent Strategy](AI_AGENT_STRATEGY.md) → [Execution Blueprint](EXECUTION_BLUEPRINT.md).

## Fungsi setiap dokumen

| Dokumen | Untuk apa | Status |
|---|---|---|
| [README](../README.md) | Cara membuka proyek Godot dan ringkasan kemampuan starter. | Panduan proyek; daftar fitur belum membuktikan runtime bekerja. |
| [Handoff perencanaan](../Satriya_Village_Planning_Handoff_v1.md) | Merangkum visi, keputusan, usulan, hal yang perlu diverifikasi, serta permintaan PRD. | Bahan sumber; bukan PRD final. |
| [AGENTS](../AGENTS.md) | Aturan kerja agent: scope, keselamatan, gaya kode, verifikasi, dan peran. | Instruksi repository. |
| [Task Log](TASK_LOG.md) | Catatan setelah setiap instruksi/tugas pengguna selesai: hasil, berkas terkait, verifikasi, dan pelajaran untuk agent berikutnya. | Riwayat pelaksanaan; satu entri per tugas, bukan per edit kode. |
| [DECISIONS](DECISIONS.md) | Mencatat arah desain yang sudah disetujui, termasuk visi sistem masa depan. | Keputusan yang berlaku; tidak semua fitur dijadwalkan untuk MVP. |
| [Decision Register](DECISION_REGISTER.md) | Mencatat sumber/tanggal/batas keputusan, persetujuan prinsip dan pertanyaan Director, terutama O01–O04. | Register terkini; tidak memberi approval global PRD. |
| [ROADMAP](ROADMAP.md) | Menetapkan urutan milestone M0–M4 dan batas implementasi. | Roadmap yang berlaku. |
| [Gap Analysis](GAP_ANALYSIS.md) | Menunjukkan konflik antardokumen, informasi yang belum ada, prioritas, serta bukti/keputusan untuk menutupnya. | Draf untuk review Game Director. |
| [PRD v1.1](PRD.md) | Merevisi PRD v1.0 di tempat: scope, requirement/ID lama, traceability visi, kontrak terbuka, riwayat revisi dan task card A02. | DRAFT; arah diterima secara prinsip; pilot/MVP belum disetujui; belum izin coding. |
| [Audit independen 26 Oktober 2026](reviews/Satriya_Village_Independent_Audit_2026-10-26.md) | Salinan sumber audit dokumen/source statis pada commit ef512596, dengan temuan A01–A12. | Bukti historis read-only; bukan hasil runtime atau otorisasi instruksi di dalam lampiran. |
| [Master Planning](MASTER_PLANNING.md) | Menjelaskan pengalaman inti, batas scope, dependensi sistem, dan rencana spesifikasi lanjutan. | Proposal pra-produksi. |
| [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) | Mengusulkan pemisahan model dan tampilan, kontrak state, tick, save, serta pengujian. | Proposal teknis; bukan struktur yang sudah dibangun. |
| [AI Agent Strategy](AI_AGENT_STRATEGY.md) | Menetapkan peran logis, kepemilikan file, alur review, dan quality gates. | Proposal organisasi; tidak mengaktifkan agent otomatis. |
| [Execution Blueprint](EXECUTION_BLUEPRINT.md) | Mengurutkan pekerjaan dari audit baseline sampai pilot, dengan gate dan contoh task. | Backlog usulan; bukan otorisasi implementasi. |
| [Architecture](ARCHITECTURE.md) | Ringkasan struktur starter yang ada dan modul produksi yang direncanakan. | Catatan arsitektur awal; modul rencana belum tentu ada. |

## Cara memakai status

`CONFIRMED` berarti keputusan yang tercatat; `PRINCIPLE_ACCEPTED` berarti arah diterima dengan detail masih terbuka; `PROPOSED` rekomendasi; `OPEN` pertanyaan; `VERIFY` kebutuhan bukti. PASS/FAIL/NOT TESTED adalah status verifikasi terpisah. Jika sumber berbeda, lihat [Gap Analysis](GAP_ANALYSIS.md) dan [Decision Register](DECISION_REGISTER.md). Keberadaan dokumen/kode bukan bukti fitur telah diuji.

Dokumen audit runtime, GDD rinci, TDD, format save, rencana uji, dan checklist rilis yang disebut dalam PRD adalah **keluaran yang direncanakan**, belum ada sebagai berkas proyek. Urutannya mengikuti dependensi pada PRD dan hasil audit, bukan dibuat sekaligus.
