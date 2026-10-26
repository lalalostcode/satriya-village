# Architecture Blueprint v0.1

Status: usulan, bukan struktur yang sudah diimplementasikan. Baca [Master Planning](MASTER_PLANNING.md). Gunakan Godot 4.7.2 Standard + typed GDScript sesuai keputusan proyek; tidak menambah package.

Pembaruan dokumentasi v1.1: [Decision Register](DECISION_REGISTER.md) mencatat dua aturan confirmed dari Director, yaitu pause dengan command eksplisit dan ekonomi warga biasa agregat/tokoh penting individual. Rincian teknis di bawah tetap proposal; tidak ada approval arsitektur menyeluruh atau otorisasi implementasi. [PRD](PRD.md) masih DRAFT; audit gameplay A02 NOT TESTED.

Detail kontrak terkini dirangkum dalam draft [TDD](TDD.md) dan [SAVE_FORMAT](SAVE_FORMAT.md), termasuk snapshot setelah explicit command saat pause dan avatar/interaksi FR19. Baseline monolith di bawah adalah snapshot planning awal, bukan sertifikasi working tree saat ini. Perubahan source lain yang sedang berlangsung harus diaudit terpisah.

## Baseline dan arah migrasi

Pada snapshot awal, `scenes/main.tscn` menjalankan `scripts/main.gd`; HUD dibentuk lewat kode. Jangan mengganti seluruh scene. Setelah audit/stabilisasi dan kontrak siap, ekstrak satu tanggung jawab per tugas; pertahankan perilaku teruji sebelum menambah aturan baru. Urutan detail mengikuti Execution Plan dan dependensi nyata.

## Struktur target bertahap

```text
scenes/main.tscn              composition root, tetap entry point
scenes/settlement/            presentasi desa (dibuat saat diperlukan)
scenes/ui/                    HUD, panel pilihan, dialog
scripts/simulation/          clock, settlement, inventory, economy
scripts/characters/          worker state, named character, assignment
scripts/narrative/           quest dan event state
scripts/persistence/         serializer, validator, migration
scripts/presentation/        input adapter, renderer, UI binding
data/                        definisi bangunan, recipe, karakter, quest
tests/                       uji invariants dan integration fixture
assets/                      aset orisinal beserta provenance
```

Tidak semua folder/modul perlu dibuat sekarang. Model awal dapat memakai `RefCounted` dan Resource bertipe; scene hanya untuk lifecycle dan presentasi. Hindari ECS, framework generik, banyak autoload, atau global event bus sebelum ada kebutuhan nyata.

Scene tree target usulan:

```text
Main (Node)
├── GameSession (Node; memegang model dan clock)
├── SettlementView (Node2D)
│   ├── Ground
│   ├── Entities (urutan gambar berdasarkan posisi kaki)
│   ├── PlacementPreview
│   └── Camera2D
└── UI (CanvasLayer)
    ├── HUD (Control + Containers)
    ├── BuildingPanel
    ├── CharacterPanel
    └── EventDialog
```

Model tidak menyimpan Node, posisi layar, atau referensi HUD. Kamera dan transform input menjadi tanggung jawab view. UI mengonsumsi input terlebih dahulu; klik/touch yang tidak dipakai UI diterjemahkan ke koordinat dunia lalu cell. Preview dan commit memakai validasi placement yang sama.

## State dan kontrak antarmodul

`GameSession` memegang satu state otoritatif. Definisi statis read-only terpisah dari runtime state. UI mengirim command, model memvalidasi dan mengubah state, kemudian mengirim signal hasil. UI tidak mengurangi stok sendiri.

| Pemilik | Command / keluaran konseptual | Invariant |
|---|---|---|
| Clock | set_speed(0/1/2/3), advance_tick; tick_completed(tick_id) | Pause menghentikan kemajuan otomatis; command eksplisit valid tetap dapat mengubah state tanpa memajukan waktu |
| Settlement | try_place(definition_id, cell) → success/reason/entity_id | Di luar peta, occupied, atau biaya kurang tidak mengubah stok/peta |
| Inventory | can_afford(cost), apply_transaction(delta, reason) | Satu transaksi atomik; stok tidak negatif; bilangan bulat |
| Economy | step(tick_id, assignments) → ledger | Produksi tidak bergantung frame render atau jumlah sprite |
| Workforce | set_priority(sector), assign_official(character_id, role) | Total alokasi kelompok tidak melebihi workforce/slot; tokoh tidak dihitung ganda; jabatan dan anggaran tervalidasi |
| Narrative | choose(event_instance_id, choice_id) → result | Prasyarat dicek ulang; efek yang sama diterapkan paling sekali |
| Persistence | save(snapshot), load(path) → validated state/error | Load gagal tidak mengganti sesi aktif |
| Battle (kelak) | start(snapshot), command(order), resolve() → outcome | Hasil diterapkan sekali ke world state; tidak berjalan offline |

Aturan confirmed: command eksplisit yang valid dapat diproses saat pause. Usulan kontrak teknis: command diproses berurutan pada titik transaksi yang aman, termasuk saat tick berhenti; kemajuan simulasi otomatis tetap pada tick. Perubahan placement dan stok selesai sebagai satu operasi sebelum signal diterbitkan; listener tidak mengulang efek ekonomi. Result gagal memiliki reason stabil untuk UI dan tes. Signal membawa ID dan data ringkas; subscriber tidak menjadi sumber kebenaran kedua. Detail antrean/urutan masih perlu TDD.

## Model data yang perlu disahkan

| Model | Field minimum yang diusulkan |
|---|---|
| BuildingDefinition | id stabil, display_name, footprint_cells, cost, recipe_id, worker_slots |
| BuildingState | entity_id, definition_id, cell_x/y, construction_progress, workforce_allocations (jumlah per kelompok), named_assignee_ids; bentuk field masih usulan |
| SettlementState | id, map_width/height, buildings, stocks, population, assignments |
| CharacterState | id, name, enam atribut, trait_ids, role_id, relationship values; dynasty_id nanti |
| RecipeDefinition | id, inputs, outputs, ticks_required; quality ditunda |
| QuestDefinition | id, prerequisites, stages, choices, effects |
| QuestState | instance_id, definition_id, stage, selected_choice, applied_effect_ids |
| SessionState | schema_version, content_version, tick_id, clock_remainder, seed/RNG state, settlement, characters, quests |

Nama tampilan bukan primary key. ID stabil tidak diterjemahkan. Definisi harus divalidasi: ID unik, reference ada, biaya nonnegatif, footprint valid, dan graph quest tidak mengarah ke stage hilang. Gunakan Resource untuk authoring awal atau JSON tervalidasi jika lebih mudah; pilih satu jalur dalam DATA_SCHEMAS, jangan memelihara dua sumber definisi.

## Tick, NPC dan event

Usulan awal: tick simulasi tetap satu detik game, ekonomi diperbarui pada interval yang dikonfigurasi. Hubungan tick–hari starter dipertahankan saat ekstraksi; pacing baru menunggu persetujuan. Accumulator mengumpulkan delta × speed; batasi pekerjaan catch-up per frame tetapi pertahankan sisa waktu agar state tidak kehilangan tick. Ukur batas tersebut di perangkat.

Urutan usulan: command → assignment → produksi → konsumsi → kebutuhan → evaluasi event → snapshot untuk UI. Urutan dan pembulatan harus terdokumentasi dan diuji; jangan mengubah urutan diam-diam. Seed dan urutan ID stabil diperlukan untuk reproducibility dalam versi yang sama, bukan janji determinisme lintas versi engine.

Ekonomi warga biasa memakai kelompok/alokasi jumlah; tokoh penting individual. State idle/travel/work/rest dapat menjadi proposal presentasi, bukan kewajiban membuat tiap sprite agen ekonomi penuh. Alokasi mengikuti lowongan/prioritas; produksi mengikuti model agregat, bukan animasi. ID visual/navigasi boleh dipakai tanpa menjadi otoritas hitungan ekonomi. Pengaruh perjalanan/pathfinding terhadap produksi masih OPEN. Desa yang tidak dilihat kelak menjalankan data tanpa sprite dengan aturan produksi yang setara.

Event besar memakai state rumor/tension/warning/intervention/resolved. Simpan deadline, pilihan tertunda, dan effect IDs. Pause dialog keputusan melalui kebijakan clock yang eksplisit. Tidak ada perang, kudeta, atau resolusi cerita utama saat aplikasi ditutup maupun berada di background.

## Save/load: rancangan sebelum implementasi

[SAVE_FORMAT](SAVE_FORMAT.md) kini tersedia sebagai draft dan harus ditinjau/disahkan sebelum persistence. Usulan v1: JSON di lokasi data aplikasi, envelope dengan schema/content version, timestamp, tick/remainder, state_revision dan state yang benar-benar digunakan. Cell sebagai dua integer; tanpa Node atau resource path arbitrer.

Simpan snapshot setelah transaksi/tick selesai; saat pause snapshot setelah command tidak menunggu tick. Candidate tervalidasi dan backup menjaga last good sebelum penggantian current. Verifikasi replacement pada Windows/Android. Load melalui parse/validasi/migrasi dikenal/staging lalu swap bila sukses; versi baru ditolak dan corrupt menawarkan recovery, bukan reset diam-diam. Uji interupsi/gagal tulis tanpa merusak last good.

Offline ditunda sampai save dan ekonomi stabil. Usulan delta = clamp(now_utc − saved_utc, 0, cap); cap empat jam masih perlu keputusan balancing. Rollback jam menghasilkan nol; loncatan jam dibatasi, bukan dianggap mekanisme anti-cheat. Hanya produksi/konsumsi dan konstruksi yang sudah disetujui masuk allowlist. Berhenti pada batas keputusan atau kondisi pemulihan yang disepakati. Gunakan transaksi/state snapshot agar resume dua kali tidak menggandakan hasil. Ringkasan menunjukkan durasi, produksi, konsumsi, dan alasan berhenti. Background Android diperlakukan seperti suspend; tidak menjalankan loop tersembunyi.

## Android dan strategi pengujian

Compatibility renderer tetap baseline. Target perangkat RAM, chipset dan versi OS ditentukan dari perangkat pemilik sebelum menjanjikan kapasitas. Anggaran usulan: 30 FPS stabil (sekitar 33,3 ms/frame) pada perangkat minimum, lalu 60 FPS bila terbukti; catat p95 frame time, memori puncak, durasi save, serta perilaku panas selama sesi 15 menit. Angka populasi maksimum ditentukan melalui profiling, bukan dugaan.

Gunakan redraw ketika state/visual berubah, atlas untuk aset yang sudah ada, dan pembaruan UI berbasis perubahan. Jangan melakukan optimasi luas sebelum profiling. Uji layout 1280×720, rasio lebih lebar, safe area, drag versus tap, touch tanpa hover, dan suspend/resume.

Uji model tanpa render: placement invalid tidak bermutasi; biaya tepat; saldo setara setelah jumlah tick sama pada speed berbeda; pause; konsumsi saat stok nol; quest effect sekali; save round-trip dan backup. Uji integrasi: command UI→state→HUD, load→view, resume→ringkasan. Uji manual: keterbacaan isometrik, occlusion, sentuhan, tutorial dan dua cabang quest. Import/parser tidak membuktikan gameplay benar; kelulusan teknis dan penerimaan Game Director dicatat terpisah.
