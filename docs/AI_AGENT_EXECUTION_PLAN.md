# Satriya Village — AI Agent Execution Plan v0.1

Tanggal: 26 Oktober 2026. **DRAFT / rencana aktivasi bersyarat**, bukan perintah menjalankan seluruh backlog. Sumber: [PRD](PRD.md), [Decision Register](DECISION_REGISTER.md), [Master GDD](MASTER_GDD.md), [TDD](TDD.md), [Quality Gates](QUALITY_GATES.md). Melengkapi [AI Agent Strategy](AI_AGENT_STRATEGY.md) dan [Execution Blueprint](EXECUTION_BLUEPRINT.md) yang lebih awal.

## 1. Organisasi dan kewenangan

Director memegang visi, approval desain/scope/arsitektur substansial dan penerimaan milestone. Lead/integrator menjaga kontrak, file bersama, integrasi dan checkpoint. Satu agent dapat berganti peran logis. Default satu tugas tulis aktif; rencana ini tidak otomatis memulai subagents, memasang skill, membuat worktree, atau menambah package.

| Peran logis | Ownership saat diaktifkan | Batas |
|---|---|---|
| Lead/integrator | Kontrak, main scene, project config, snapshot schema | File bersama hanya owner tunggal; tidak approve scope sendiri |
| World | Grid/placement/camera/input dunia | Biaya melalui transaksi model, bukan UI |
| Simulation | Clock, inventory, ekonomi, workforce pool | Tidak mengubah lore atau presentation sebagai sumber produksi |
| Character/Narrative | Player/official/interaksi/quest | ID/effect/mandat mengikuti kontrak; tidak membangun dinasti/intrik penuh |
| UI/Art | HUD/touch/player marker/dialog dan provenance aset | Tidak menambah locomotion/editor avatar atau menyalin referensi game |
| QA/Release | Audit/evidence, regression, Android smoke/profil | Tidak menyatakan PASS dari source/exit code saja |
| Combat | Belum aktif pada slice | Visi dipertahankan, implementasi menunggu scope pilot tersendiri |

Jika parallel agents nanti diminta, tetapkan ownership dan worktree/branch per tugas; shared schema/config hanya integrator. Review read-only tidak menulis file implementer. Kirim hasil sebagai diff/commit, kontrak, expected/actual dan risiko; integrator menguji ulang setelah gabungan. Tidak ada alasan membuat banyak agent sekaligus untuk fondasi kecil.

## 2. Ready gate setiap task

Task berisi satu outcome, baseline commit/status bukti, sumber keputusan, allowed files, owner file bersama, non-goals, input/output/error/invariants, fixture/expected, manual test, checks dan stop condition. Baseline provisional cukup untuk menulis spesifikasi, bukan untuk mengklaim approval Director.

Implementasi baru hanya diaktifkan setelah audit/stabilisasi baseline dan kontrak fitur terkait siap serta otorisasi scope tersedia. O06/O07/O09 ditutup sesuai fitur; TBD jam/budget tidak diisi palsu. Data perangkat diperlukan untuk task perangkat, bukan semua pekerjaan dokumen. Gunakan milestone berbasis bukti, tanpa tanggal fiktif.

## 3. Urutan task bersyarat

Path implementasi di bawah adalah target yang ditetapkan lebih tepat setelah audit; belum dibuat oleh rencana ini. Tiap task hanya mengambil allowed files yang diperlukan, bukan seluruh folder tanpa batas.

| ID / owner | Prasyarat | Scope dan allowed files target | Acceptance / handoff |
|---|---|---|---|
| DOC-01 / Lead | Instruksi dokumentasi S12 | PRD/register, GDD/TDD/save, gates/audit/execution dan navigasi/log | Baseline/TBD jelas, relative links valid, docs-only commit; bukan approval gameplay |
| AUDIT-M0-01 / QA | Godot/GUI tersedia, salinan/evidence siap | Tidak mengubah repo sumber; [M0 plan](M0_AUDIT_PLAN.md) | F5/input/time/placement expected vs actual, evidence dan rekomendasi; A02 tetap NOT TESTED sebelum eksekusi |
| FIX-M0-xx / owner dari sebab | Issue reproduktif audit, scope fix disepakati | Satu bug dan file yang terbukti terkait | Reproduksi kini lolos, regression terkait, tidak menambah gameplay/balancing |
| CONTRACT-01 / Lead + Director | Audit dan review GDD/TDD | Dokumen kontrak saja | Daftar command pause, O06/O07 ekonomi, schema dan fixture siap; SAVE_FORMAT sebelum persistence |
| M1-CLOCK / Simulation | Q2/Q3, clock contract | Ekstraksi clock dari main secara kecil | Tick/input setara; pause+command benar; baseline pacing tidak diam-diam diganti |
| M1-GRID / World | Clock/baseline dan kontrak transaksi | Grid/occupancy/placement dan adapter minimal | Valid/invalid atomic, UI isolation, mouse cell tepat; test model + manual |
| M1-ECON / Simulation | O07/fixture dan inventory contract | Stok/produksi/consumption/pengumpulan kayu sederhana | Ledger, aggregate allocation dan recovery; tidak menambah ekonomi penuh |
| M1-SAVE / Lead | State stabil, O09 dan SAVE_FORMAT ditinjau | Serializer/validator/staging/recovery | Round-trip/player/quest, corrupted file, unknown version, gagal tulis; sesi sehat terjaga |
| ANDROID-SMOKE / QA + UI | Input/gameplay dasar stabil, perangkat/build tersedia | Export/input/lifecycle sesuai scope task terpisah | Install/start/tap/pause/suspend/resume; device/build/evidence; belum janji FPS minimum |
| M2-CHAR / Character + UI | Data/interaction/input contracts | Player marker dan satu pejabat/dialog bersama | FR19 avatar/interaksi ≥1 mouse/touch; individual IDs; tanpa locomotion/editor besar |
| M2-QUEST / Narrative | Ekonomi/warning/choice/save siap | Satu quest pangan, ≥2 hasil dan follow/reject/ignore | Efek sekali, prasyarat valid, warning dan recovery, load sebelum/sesudah |
| SLICE-QA / QA + Director | Loop dan perangkat sesuai cakupan | Bukti/model/integration/manual/playtest/profile | Q5/Q7; evaluasi 10–15 menit termasuk player interaction; pilot/MVP tidak otomatis aktif |

Urutan dapat disesuaikan oleh integrator berdasarkan dependensi nyata, misalnya player/quest state ditambahkan sebelum menyelesaikan save fixture terkait. Android smoke tidak menunggu seluruh quest, tetapi tidak menguji fitur belum ada sebagai passed. Tidak ada janji sprint dua minggu atau jumlah bulan.

## 4. Stop condition dan integrasi

Hentikan perluasan task jika sebab belum terbukti, perubahan membutuhkan gameplay/arsitektur baru, ingin menghapus aset/scene pengguna, atau dependency/SDK belum diotorisasi. Selesaikan pekerjaan yang aman dalam scope dan siapkan proposal konkret. Jangan menggunakan refactor besar untuk menyamarkan bug starter.

Setelah implementasi yang diotorisasi: parser/import → tes invariants relevan → manual/Android sesuai dampak → review diff/kontrak → checkpoint terbatas → satu entri [Task Log](TASK_LOG.md). Milestone memerlukan penerimaan Director; commit semata tidak lulus gate. Dalam task dokumentasi, catat checks dokumen dan status runtime NOT TESTED secara terpisah.

## 5. Keputusan/data tersisa

Scope/produk provisional O01-S/O02 membutuhkan ratifikasi eksplisit sebelum disebut APPROVED. O03 jam/budget/PC TBD menghalangi estimasi, bukan dokumentasi. O04 perangkat TBD menghalangi smoke/profile. O06 kalender/kontrak pause rinci; O07 yield/hunian/konsumsi/pemulihan; O09 save policy harus siap untuk task terkait. O08/O11 nama atribut/lore tidak ditebak. Pilot/MVP dan seluruh visi deferred tetap [PRD §7](PRD.md)/[ROADMAP](ROADMAP.md).
