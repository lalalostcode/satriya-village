# Architecture Blueprint v0.1

Status: usulan, bukan struktur yang sudah diimplementasikan. Baca [Master Planning](MASTER_PLANNING.md). Gunakan Godot 4.7.2 Standard + typed GDScript sesuai keputusan proyek; tidak menambah package.

## Baseline dan arah migrasi

Saat ini `scenes/main.tscn` hanya mempunyai Node2D yang menjalankan `scripts/main.gd`; HUD dibentuk lewat kode. Jangan mengganti seluruh scene. Setelah audit lolos, ekstrak satu tanggung jawab per tugas: clock → placement/grid → inventori/ekonomi → persistence → pekerja → quest. Setiap ekstraksi mempertahankan perilaku teruji sebelum menambah aturan baru.

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
| Clock | set_speed(0/1/2/3), advance_tick; tick_completed(tick_id) | Pause tidak mengubah state simulasi |
| Settlement | try_place(definition_id, cell) → success/reason/entity_id | Di luar peta, occupied, atau biaya kurang tidak mengubah stok/peta |
| Inventory | can_afford(cost), apply_transaction(delta, reason) | Satu transaksi atomik; stok tidak negatif; bilangan bulat |
| Economy | step(tick_id, assignments) → ledger | Produksi tidak bergantung frame render atau jumlah sprite |
| Workforce | set_priority(sector), assign_official(character_id, role) | Satu warga tidak bekerja pada dua tempat; jabatan dan anggaran tervalidasi |
| Narrative | choose(event_instance_id, choice_id) → result | Prasyarat dicek ulang; efek yang sama diterapkan paling sekali |
| Persistence | save(snapshot), load(path) → validated state/error | Load gagal tidak mengganti sesi aktif |
| Battle (kelak) | start(snapshot), command(order), resolve() → outcome | Hasil diterapkan sekali ke world state; tidak berjalan offline |

Command diproses berurutan pada batas tick. Perubahan placement dan stok harus selesai sebagai satu operasi sebelum signal diterbitkan; tidak ada listener yang boleh mengulang efek ekonomi. Result gagal memiliki reason stabil untuk UI dan tes. Signal membawa ID dan data ringkas; subscriber tidak menjadi sumber kebenaran kedua.

## Model data yang perlu disahkan

| Model | Field minimum yang diusulkan |
|---|---|
| BuildingDefinition | id stabil, display_name, footprint_cells, cost, recipe_id, worker_slots |
| BuildingState | entity_id, definition_id, cell_x/y, construction_progress, worker_ids |
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

AI pekerja pertama memakai state sederhana idle/travel/work/rest. Alokasi kerja berdasarkan lowongan dan prioritas stabil, bukan pencarian tiap frame. Produksi mengikuti state pekerja pada tick; animasi berjalan mengikuti model dan tidak menghasilkan barang sendiri. Pathfinding detail baru setelah aturan lokasi kerja diputuskan. Desa yang tidak dilihat kelak menjalankan data tanpa sprite, dengan aturan produksi yang setara.

Event besar memakai state rumor/tension/warning/intervention/resolved. Simpan deadline, pilihan tertunda, dan effect IDs. Pause dialog keputusan melalui kebijakan clock yang eksplisit. Tidak ada perang, kudeta, atau resolusi cerita utama saat aplikasi ditutup maupun berada di background.

## Save/load: rancangan sebelum implementasi

SAVE_FORMAT.md harus disetujui sebelum persistence dikerjakan. Usulan v1: JSON di `user://`, envelope dengan schema_version, content_version, timestamp UTC, tick, remainder, RNG, dan seluruh state runtime. Vector cell diserialisasi sebagai dua integer, bukan Dictionary key Vector2i. Jangan serialisasi Node atau resource path arbitrer dari berkas save.

Simpan snapshot konsisten di akhir tick ke temporary file; baca-validasi hasilnya; pertahankan backup save lama; baru ganti save aktif. Verifikasi perilaku penggantian berkas pada Windows dan Android. Saat load: parse → validasi tipe/range/ID/reference → migrasi versi dikenal → buat state terpisah → tukar state aktif bila seluruh langkah sukses. Versi lebih baru ditolak dengan pesan jelas; korupsi menawarkan backup, bukan reset diam-diam. Uji disk penuh/kegagalan tulis tanpa merusak salinan baik.

Offline ditunda sampai save dan ekonomi stabil. Usulan delta = clamp(now_utc − saved_utc, 0, cap); cap empat jam masih perlu keputusan balancing. Rollback jam menghasilkan nol; loncatan jam dibatasi, bukan dianggap mekanisme anti-cheat. Hanya produksi/konsumsi dan konstruksi yang sudah disetujui masuk allowlist. Berhenti pada batas keputusan atau kondisi pemulihan yang disepakati. Gunakan transaksi/state snapshot agar resume dua kali tidak menggandakan hasil. Ringkasan menunjukkan durasi, produksi, konsumsi, dan alasan berhenti. Background Android diperlakukan seperti suspend; tidak menjalankan loop tersembunyi.

## Android dan strategi pengujian

Compatibility renderer tetap baseline. Target perangkat RAM, chipset dan versi OS ditentukan dari perangkat pemilik sebelum menjanjikan kapasitas. Anggaran usulan: 30 FPS stabil (sekitar 33,3 ms/frame) pada perangkat minimum, lalu 60 FPS bila terbukti; catat p95 frame time, memori puncak, durasi save, serta perilaku panas selama sesi 15 menit. Angka populasi maksimum ditentukan melalui profiling, bukan dugaan.

Gunakan redraw ketika state/visual berubah, atlas untuk aset yang sudah ada, dan pembaruan UI berbasis perubahan. Jangan melakukan optimasi luas sebelum profiling. Uji layout 1280×720, rasio lebih lebar, safe area, drag versus tap, touch tanpa hover, dan suspend/resume.

Uji model tanpa render: placement invalid tidak bermutasi; biaya tepat; saldo setara setelah jumlah tick sama pada speed berbeda; pause; konsumsi saat stok nol; quest effect sekali; save round-trip dan backup. Uji integrasi: command UI→state→HUD, load→view, resume→ringkasan. Uji manual: keterbacaan isometrik, occlusion, sentuhan, tutorial dan dua cabang quest. Import/parser tidak membuktikan gameplay benar; kelulusan teknis dan penerimaan Game Director dicatat terpisah.
