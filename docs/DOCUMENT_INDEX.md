# Satriya Village — Peta Dokumen

Mulai di sini untuk menemukan dokumen proyek dan mengetahui fungsi masing-masing. **Status:** [PRD v1.1](PRD.md) tetap DRAFT dengan CONDITIONAL PASS reviewer; [Decision Register](DECISION_REGISTER.md) membedakan confirmed, persetujuan prinsip, PLANNING_BASELINE provisional, proposal, OPEN/TBD dan visi deferred. M0–M4 tetap dipertahankan; pilot/MVP belum disetujui. A02 gameplay NOT TESTED.

## Jalur baca

1. **Memahami proyek:** [README](../README.md) → [handoff perencanaan](../Satriya_Village_Planning_Handoff_v1.md).
2. **Mengetahui batas dan keputusan yang berlaku:** [AGENTS](../AGENTS.md) → [Task Log](TASK_LOG.md) → [DECISIONS](DECISIONS.md) → [Decision Register](DECISION_REGISTER.md) → [ROADMAP](ROADMAP.md).
3. **Meninjau produk:** [audit independen](reviews/Satriya_Village_Independent_Audit_2026-10-26.md) → [Gap Analysis](GAP_ANALYSIS.md) → [PRD v1.1](PRD.md). S12 menyediakan baseline sementara; data TBD tidak menghentikan dokumentasi.
4. **Spesifikasi slice terkini:** [Master GDD](MASTER_GDD.md) → [TDD](TDD.md) → [Save Format](SAVE_FORMAT.md) → [Art & UX Guide](ART_UX_GUIDE.md) → [AI Agent Execution Plan](AI_AGENT_EXECUTION_PLAN.md) → [Quality Gates](QUALITY_GATES.md) → [M0 Audit Plan](M0_AUDIT_PLAN.md). Semuanya draft; audit/stabilisasi dan kontrak fitur siap sebelum fitur baru.
5. **Latar proposal sebelumnya:** [Master Planning](MASTER_PLANNING.md) → [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) → [AI Agent Strategy](AI_AGENT_STRATEGY.md) → [Execution Blueprint](EXECUTION_BLUEPRINT.md). Gunakan register dan spesifikasi terkini untuk status, bukan menganggap seluruh proposal lama approved.

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
| [Master GDD](MASTER_GDD.md) | Aturan pengalaman slice, ekonomi/pemulihan, player/official, quest, UX dan parameter TBD. | DRAFT berbasis S12; detail gameplay belum otomatis disahkan. |
| [TDD](TDD.md) | Boundary model/view, modularisasi bertahap, ownership, command/tick, data dan kontrak minimum. | DRAFT; baseline historis dibedakan dari implementasi yang tervalidasi. |
| [Save Format](SAVE_FORMAT.md) | Proposal schema v1, snapshot, validasi, replacement/backup, recovery dan fixture. | DRAFT; O09/kontrak wajib ditinjau sebelum persistence. |
| [AI Agent Execution Plan](AI_AGENT_EXECUTION_PLAN.md) | Urutan task bersyarat, prasyarat, owner, allowed files, acceptance dan handoff. | Rencana aktivasi; tidak menjalankan agent atau fitur otomatis. |
| [Quality Gates](QUALITY_GATES.md) | Memisahkan kelulusan dokumen, audit, baseline, kontrak, slice dan Android/performa. | Rencana; PASS membutuhkan evidence per gate. |
| [M0 Audit Plan](M0_AUDIT_PLAN.md) | Task audit F5/input/placement/waktu/ledger dengan expected/actual dan evidence checklist. | NOT TESTED; bukan laporan hasil atau fix. |
| [Master Planning](MASTER_PLANNING.md) | Menjelaskan pengalaman inti, batas scope, dependensi sistem, dan rencana spesifikasi lanjutan. | Proposal pra-produksi. |
| [Architecture Blueprint](ARCHITECTURE_BLUEPRINT.md) | Mengusulkan pemisahan model dan tampilan, kontrak state, tick, save, serta pengujian. | Proposal teknis; bukan struktur yang sudah dibangun. |
| [AI Agent Strategy](AI_AGENT_STRATEGY.md) | Menetapkan peran logis, kepemilikan file, alur review, dan quality gates. | Proposal organisasi; tidak mengaktifkan agent otomatis. |
| [Execution Blueprint](EXECUTION_BLUEPRINT.md) | Mengurutkan pekerjaan dari audit baseline sampai pilot, dengan gate dan contoh task. | Backlog usulan; bukan otorisasi implementasi. |
| [Architecture](ARCHITECTURE.md) | Ringkasan struktur starter yang ada dan modul produksi yang direncanakan. | Catatan arsitektur awal; modul rencana belum tentu ada. |
| [Art & UX Guide](ART_UX_GUIDE.md) | Standar visual utama: identitas Nusantara, pixel art teknis, palet warna, karakter chibi, arsitektur, UI/UX, pipeline Godot, performa, QA, dan art brief template. | DRAFT v1.0; semua spesifikasi baru PROPOSED kecuali yang merujuk CONFIRMED di DECISIONS. |

## Cara memakai status

`CONFIRMED` keputusan; `PRINCIPLE_ACCEPTED` arah diterima; `PLANNING_BASELINE` rekomendasi provisional; `PROPOSED` opsi; `OPEN` keputusan tertunda; `TBD` data belum ada; `DEFERRED` visi ditunda; `VERIFY` kebutuhan bukti. PASS/FAIL/NOT TESTED status verifikasi terpisah. Jika sumber berbeda, lihat register/gap. Keberadaan dokumen/kode bukan bukti fitur telah diuji.

GDD/TDD/save/art/execution/gates/audit plan kini tersedia sebagai draft. AUDIT_REPORT runtime, lore source ledger lengkap, balancing final, profil perangkat dan release checklist masih keluaran berikutnya. Menulis spesifikasi provisional tidak sama dengan melewati gate implementasi.
