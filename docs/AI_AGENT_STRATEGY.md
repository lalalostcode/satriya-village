# AI Agent Strategy v0.1

Status: rancangan organisasi kerja. Peran adalah spesialisasi logis, bukan delapan agent yang otomatis berjalan. [AGENTS.md](../AGENTS.md) tetap instruksi otoritatif. Paket ini tidak memasang skill atau mengubah instruksi agent global.

## Organisasi dan kewenangan

| Peran | Kapan aktif | Kepemilikan dan batas |
|---|---|---|
| Human Game Director | Setiap milestone | Visi, scope, gameplay, penerimaan manual, publikasi; menyetujui arsitektur besar |
| Lead Architect / integrator | Sejak audit | Kontrak, urutan tugas, review, integrasi; pemilik main scene dan konfigurasi |
| World & Settlement | M1 | Grid, occupancy, placement, kamera; tidak mengubah ekonomi tanpa kontrak |
| Simulation & Economy | M1 | Clock, stok, produksi/konsumsi; tidak mengubah visual dan cerita |
| Character & AI | M2 | Assignment, worker state, named NPC; dinasti baru pada pilot |
| Politics & Narrative | Riset awal; implementasi M2 | Lore, quest dan event; diplomasi M3; intrik/intelijen setelah pilot |
| Combat | M3 setelah slice stabil | Battle core dan hasil tempur; world state berubah lewat kontrak integrator |
| UI/UX & Art Pipeline | Audit input, lalu slice | UI, touch, sprite conventions dan provenance; tidak menulis aturan simulasi |
| QA / Performance / Release | Sejak audit | Reproduksi, tes, bukti, profiling; build Android awal dan gate rilis kemudian |

Untuk solo developer, satu agent dapat berganti peran. Default satu pekerjaan tulis aktif. Parallel agent hanya jika pemilik meminta delegasi dan kontrak/file ownership telah ditetapkan. Review read-only dapat dipisahkan, tetapi reviewer tidak memperbaiki file yang sedang dimiliki implementer.

## Workflow dan integrasi

1. Baca README, AGENTS, DECISIONS, ROADMAP dan kontrak terkait; cek Git status. Jangan menimpa perubahan pengguna.
2. Buat task card dengan satu hasil yang dapat diamati, file yang boleh disentuh, non-goals dan acceptance criteria.
3. Selesaikan keputusan prasyarat. Lead boleh memilih detail lokal yang reversible; perubahan gameplay/arsitektur substansial dikembalikan ke Director dengan proposal konkret.
4. Implementer mengerjakan perubahan kecil. Bila perlu menyentuh file milik peran lain, integrator memperbarui scope sebelum pekerjaan diperluas.
5. Jalankan parser/import, uji model yang relevan dan manual scenario. Laporkan expected versus actual; jangan mengklaim F5/touch lolos jika belum diuji.
6. Reviewer memeriksa kontrak, invariants, regresi, data ownership dan perubahan scope. Integrator menjalankan gate integrasi setelah menggabungkan hasil.
7. Buat commit/checkpoint terbatas pada file tugas yang lolos; catat keterbatasan dan persetujuan manual yang masih tertunda.

Jika parallel work disetujui, tetapkan satu branch/worktree per tugas, satu pemilik per file, dan urutan integrasi eksplisit. File bersama (`project.godot`, `main.gd`, `main.tscn`, schema dan kontrak) hanya ditulis integrator atau pemilik tunggal yang ditunjuk. Worker menyerahkan diff/commit dan bukti uji; konflik diselesaikan integrator berdasarkan kontrak, kemudian diuji ulang. Jangan memakai shared working directory untuk dua penulis file yang sama.

## Template task card / prompt

```text
Peran: [satu peran]
Tujuan: [satu perilaku/hasil yang bisa dibuktikan]
Konteks: baca AGENTS.md, DECISIONS.md, ROADMAP.md, [kontrak].
Baseline: [commit + status validasi, bukan asumsi].
Allowed files: [daftar eksplisit]. Shared-file owner: [nama peran].
Scope: [...]. Non-goals: [...].
Input/output contract: [tipe, ID, error, invariants].
Acceptance criteria: [Given / When / Then yang terukur].
Manual test: [langkah, expected, data awal].
Automated checks: [perintah yang relevan].
Stop condition: konflik instruksi, keputusan gameplay baru, perubahan lintas batas.
Deliverable: changed files, expected/actual, log ringkas, risiko, next step.
Jangan menambah package, SDK, layanan, atau menghapus aset pengguna.
```

## Quality gates dan Definition of Done

Task selesai bila scope dan kontrak dipenuhi, parser lolos, tes relevan lolos, tidak ada regresi diketahui yang memblokir, dokumen sesuai perilaku, dan perubahan bisa diulas sebagai diff kecil. Klaim penerimaan gameplay membutuhkan bukti manual. Milestone selesai setelah Director menerima pengalaman bermain, bukan hanya karena agent membuat commit.

Review wajib memeriksa: input UI tidak membangun bangunan tanpa sengaja; biaya dan placement atomik; model tidak tergantung renderer; tick/pause konsisten; ID stabil; save dapat ditolak dengan aman; dialog tidak menggandakan efek; tidak ada konten sejarah yang diklaim tanpa sumber; batas 16:9 dan touch diperhatikan.

Persetujuan manusia dibutuhkan untuk: perluasan scope, angka/aturan gameplay baru yang substansial, arsitektur lintas modul, perubahan format save yang memutus kompatibilitas, penghapusan art/scene, package/SDK/layanan, dan publikasi. Perbaikan lokal sesuai task yang sudah disetujui tidak meminta izin berulang. Sajikan keputusan sebagai masalah, opsi, rekomendasi, dampak dan artefak yang dapat diulas.

## Struktur instruksi dan rencana skill Godot

AGENTS root sudah memadai untuk fase awal: mission, read-first, scope/safety, coding, verification dan peran. Usulan penambahan setelah disetujui: link kontrak yang benar-benar ada, format laporan bukti, dan aturan satu pemilik file. Instruksi subfolder hanya diperlukan jika aturan khusus sudah berulang; jangan menduplikasi root.

Skill Godot khusus **belum dibuat**. Buat hanya setelah audit membuktikan workflow yang dapat diulang. Isi yang direncanakan: menemukan executable lokal dan memeriksa versi; import/parser headless; mengelola output log; checklist input mouse/touch; typed GDScript dan Resource validation; fixture tick; pemeriksaan save; pelaporan actual versus expected. Skill tidak boleh menyatakan runtime atau Android lolos dari hasil parser saja. Validasi skill pada satu tugas bug nyata sebelum dipakai umum; Android export dan narrative provenance menjadi skill terpisah hanya jika kebutuhannya berulang.
