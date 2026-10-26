# Satriya Village — Save Format v1

## Prototype implementation contract — 2026-10-26

This section supersedes the broader proposal below for the current three-building prototype. The Director requested continuation after the recommendation to implement safe save/load. This is a small manual-persistence implementation, not approval of all future O09 policies. The original proposal is retained as design history.

- One manual slot: `user://saves/village.json`; previous validated primary at `village.json.bak`. Candidate files use `.tmp` and `.bak.tmp` in the same directory. No autoload, autosave or offline progression. Buttons: Simpan, Muat, Cadangan. Loading is an explicit replacement of the active session; failed loads leave all active state untouched. Cadangan explicitly selects the previous snapshot; it is never loaded silently.
- JSON UTF-8 with exact fields: `schema_version: 1`, `content_version: "prototype-1"`, `saved_at_utc` (nonnegative integer Unix seconds, metadata only), `clock`, `settlement`. Unknown versions/content/fields are rejected, not migrated or silently discarded. There is no released older schema to migrate.
- `clock`: `day` integer 1..1,000,000,000, `elapsed` finite number in [0,8), `speed` exactly 0/1/2/3. Saved speed and remainder are restored; no elapsed wall time is applied.
- `settlement`: `id: "village-1"`, `width: 10`, `height: 10`, `population` integer 0..1,000,000,000, `stocks` with exactly `wood`, `food`, `coins` (integers 0..1,000,000,000), and `buildings` (at most 100 entries). Each entry has exactly `id` (known catalog ID), `x`, `y` (integers 0..9); duplicate cells are invalid. Numeric JSON values are converted only after finite/integer/range validation; booleans and strings are not numbers.
- Defensive file-size ceiling: 1 MiB, a parser guard for this small snapshot, not an Android performance claim. Future features must explicitly revise schema/content compatibility. No engine objects, script paths, RNG, characters, quests, workforce or revision counter are serialized because none exists in the active model. Snapshot capture is synchronous between commands/ticks. Camera, selected tool and decorative animation are presentation only; successful load resets camera/gesture/animation for a clear view.
- Save sequence: validate snapshot; create directory; write/flush/close candidate and read-validate it; if primary is valid, write/verify a staged backup then promote it; if primary is corrupt, retain its bytes in a uniquely named `.rejected-*` file before replacing it and keep the existing backup. Unsupported-version/content primary or backup blocks saving to protect newer data. Promote candidate, read-validate final primary, report success only then. Every I/O error returns failure without changing live gameplay. A healthy primary is never replaced until a healthy backup exists.
- Recovery: failed primary load offers Cadangan only when that file validates. Missing/partial temporary files are never promoted automatically. A first-ever interrupted save may leave only a candidate and no published save; later interrupted replacements retain the last good backup. Rejected files are retained for diagnosis; no automatic deletion. Simultaneous writers from multiple game instances are unsupported. Flush/rename is not an fsync/power-loss guarantee, and Windows replacement is not claimed POSIX-atomic.
- Acceptance: state round-trip including pause/remainder; second save preserves previous snapshot; explicit backup recovery; malformed/truncated/oversized/unknown-version/unknown-ID/duplicate/out-of-bounds/type/range rejection; write/backup/promotion failures preserve a readable prior save; actual HUD input updates state/HUD only after successful full validation. Physical disk-full, forced power loss and Android require separate device tests.

## Earlier broader proposal (historical, not implemented in full)

## M1 autosave extension — 2026-10-26

The Director requested all remaining M1 foundation work. Manual schema/content remains v1 / prototype-1: this extension adds storage policy, not payload fields. Autosave uses `user://saves/village-autosave.json` and its own `.bak`, `.tmp`, `.bak.tmp` and rejected files through the same validated store; it never writes the manual slot. Every 60 seconds of active application time (unscaled by simulation speed), save only if domain state/clock differs from the last successful autosave baseline. Explicit paused commands can therefore be autosaved; unchanged paused state does not churn backups. Failure retains dirty state and retries after the next interval, without per-frame disk writes. Background/focus loss attempts one dirty autosave and suspends automatic simulation/intervals until foreground; no offline catch-up. Snapshot capture occurs after complete commands/ticks.

If an autosave or its backup already exists on startup, automatic writes start disabled. The HUD offers Muat Otomatis/Cadangan Otomatis and an explicit Autosave toggle whose tooltip explains enabling for a new session. Successful autosave load enables future autosaves and resets the comparison baseline/timer. Failed load changes neither live state nor that protection. An entirely new slot starts enabled. A manual load does not silently unlock protected prior-session autosaves. Simultaneous game instances remain unsupported. These desktop notifications are tested by injection; actual Android suspend/resume/device storage still require physical-device testing.

Normal window close also flushes dirty enabled autosaves. If this save fails, the window remains open with a retry message; the player may manually save or explicitly disable autosave before closing. Force-kill/crash has no close notification and only previously successful snapshots are recoverable. Unchanged/protected/disabled autosaves cause no write on close.

Tanggal: 26 Oktober 2026. **DRAFT / PROPOSED — belum disahkan dan belum diimplementasikan.** Sumber: [PRD FR06/O09](PRD.md), [TDD](TDD.md), [Decision Register](DECISION_REGISTER.md). Dokumen ini memenuhi persiapan spesifikasi sebelum persistence; keberadaannya tidak menyatakan save/load sudah ada.

## 1. Format, lokasi dan ownership

Usulan: satu snapshot JSON UTF-8 pada lokasi data aplikasi yang didukung platform, tanpa cloud/network. Path konkret user data dan izin diuji di Windows/Android. Jangan menyimpan secret atau resource/Node yang dieksekusi dari file save. O09 masih memutuskan slot manual/autosave/backup dan interval; usulan satu manual + autosave + backup belum approval.

Session menghasilkan snapshot immutable setelah transaksi selesai. Saat pause, snapshot dapat dibuat setelah explicit command; tidak menunggu automatic tick. UI/view tidak menjadi serializer state otoritatif.

## 2. Envelope dan payload minimum

| Field usulan | Tipe / makna / validasi |
|---|---|
| schema_version | Integer positif; usulan versi pertama 1; hanya versi yang dikenal dibaca |
| content_version | Stable content revision untuk resolusi definition IDs; aturan compatibility eksplisit |
| saved_at_utc | Timestamp metadata; bukan bukti anti-cheat dan bukan pemicu offline penuh |
| snapshot_id / state_revision | Identitas snapshot dan urutan transaksi; menangkap command saat tick pause |
| clock | Tick nonnegatif, remainder dalam range interval, speed/pause state sesuai kebijakan load |
| rng | Seed/state hanya bila randomness digunakan; bentuk ditetapkan implementasi |
| settlement | ID/map/dimensi; bangunan cell; stok; population/workforce group/alokasi |
| characters / player | Stable character IDs, field individual yang dipakai, player ID/anchor atau cell valid |
| quests | Instance/definition IDs, stage, selected choice, domain/deadline, applied effect IDs |

Cell disimpan sebagai dua integer, bukan key objek engine. Alokasi berupa hitungan group/job dan named assignees terpisah. Named official/player tidak dihitung dua kali. Field presentasi seperti Node, HUD, input gesture, jumlah sprite dekoratif dan posisi animasi tidak diperlukan sebagai sumber ekonomi.

Validation memeriksa tipe, range, ID unik/reference ada, footprint dalam peta/tidak overlap, resource nonnegatif, workforce tidak melebihi pool/slots, player valid, serta stage/effect IDs konsisten. Kapasitas maksimum/ukuran file wajar ditetapkan melalui profiling, belum angka final. Unknown IDs menghasilkan error yang dapat dijelaskan; jangan diam-diam menghapus bangunan/tokoh untuk memaksa load berhasil.

## 3. Save transaction dan kegagalan

1. Ambil snapshot konsisten setelah command/tick, tanpa state setengah diterapkan.
2. Serialize ke temporary candidate terpisah; periksa hasil tulis dan validasi candidate.
3. Pertahankan last known good/backup; gantikan current hanya setelah candidate lengkap dan valid.
4. Laporkan success setelah prosedur storage benar-benar berhasil. Saat error, pertahankan salinan baik dan beri retry/recovery; tidak reset sesi.

Detail urutan replacement dan backup harus menghindari menimpa satu-satunya file sehat. Uji interupsi pada tiap tahap, disk penuh/izin gagal, file nol byte/terpotong, dan startup setelah proses berhenti. Pemakaian file API serta jaminan replacement dipilih saat implementasi dan diverifikasi per platform; dokumen tidak mengklaim atomicity OS yang belum diuji.

## 4. Load, versi dan recovery

Parse → validasi envelope → migrasi versi lama yang dikenal pada salinan → validasi seluruh payload/references → bentuk staging state → swap session hanya bila seluruh langkah sukses. View kemudian dibangun ulang, termasuk avatar pemain. Load error tidak mengganti sesi aktif. Versi lebih baru ditolak dengan pesan jelas. Belum ada migrator karena belum ada save format yang dirilis; jangan mengklaim dukungan versi hipotetis.

Saat current rusak, validasi backup dan tawarkan pemulihan; jangan mereset otomatis atau menghapus file pengguna. Catat alasan/recovery tanpa memuat seluruh data pribadi ke log. Satu quest effect tetap sekali setelah reload. Sistem tidak menjalankan offline progress hanya karena timestamp berubah.

## 5. Kebijakan yang harus diputuskan sebelum implementasi

- O09: jumlah slot, manual/autosave triggers/interval, backup retention, pesan dan alur recovery, pause saat load dan kebijakan speed setelah load.
- O06/O07: clock remainder/rounding, state populasi/workforce, fungsi bangunan dan pilihan quest final yang benar-benar disimpan.
- Player: stable character ID serta anchor/cell; pastikan load tidak membuat aktor ekonomi kedua.
- Storage: lokasi, candidate/backup naming, replacement strategy dan batas ukuran berdasarkan pengujian perangkat.
- Offline masih deferred/O10: allowlist/cap/consumption/resume ID hanya ditambahkan setelah aturan disetujui, bukan melalui schema generik sekarang.

## 6. Acceptance target

Round-trip membandingkan state relevan, bukan bytes JSON/urutan key. Fixture meliputi command saat pause, player/official/alokasi, quest sebelum/sesudah pilihan; corrupted/truncated/unknown version/unknown reference; current rusak dengan backup baik; gagal tulis/interupsi tanpa kehilangan last good; load gagal mempertahankan sesi; load ulang tidak menggandakan efek. Jalankan di Windows lalu perangkat Android ketika tersedia. Semua kasus **NOT TESTED**. Gate persistence belum siap sampai keputusan dan kontrak di atas ditinjau, sekalipun draft sudah disimpan.
