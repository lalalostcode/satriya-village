# Satriya Village — Save Format v1 Proposal

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
