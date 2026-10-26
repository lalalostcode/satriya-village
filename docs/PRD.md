# Product Requirements Document — Satriya Village v1.0

Tanggal: 26 Oktober 2026. Pemilik keputusan: Human Game Director. Penyusun: Principal Game Architect / Product Lead.

**Status: DRAFT — MENUNGGU PERSETUJUAN PRD DAN SCOPE. Tidak menjadi izin coding.**

Dokumen pendamping: [Gap Analysis](GAP_ANALYSIS.md). Sumber utama: [handoff](../Satriya_Village_Planning_Handoff_v1.md), [keputusan berlaku](DECISIONS.md), [roadmap berlaku](ROADMAP.md), dan [instruksi proyek](../AGENTS.md). Seluruh paket planning lama sudah dibaca; tetap menjadi proposal pendukung, bukan keputusan baru.

## 1. Cara membaca dan tata kelola

- **CONFIRMED:** keputusan eksplisit handoff atau baseline DECISIONS/AGENTS. Konfirmasi visi tidak menjamin fitur masuk rilis awal.
- **PROPOSED:** rekomendasi PRD, termasuk semua jumlah konten, target angka, pacing, dan batas rilis baru. Belum disetujui.
- **VERIFY:** memerlukan bukti, riset, atau uji; bukan fakta terverifikasi.
- **OPEN:** pilihan Game Director yang belum diputuskan. Konflik label sumber dicatat pada Gap Analysis C01–C14.

Persetujuan parsial harus menyebut ID requirement/keputusan, opsi, tanggal dan dampak scope. Tidak boleh mengubah DECISIONS atau ROADMAP hanya karena proposal ini tersedia. Requirement produk di bawah adalah spesifikasi target; tidak ada yang diklaim telah selesai.

## 2. Ringkasan produk dan masalah pemain

**CONFIRMED:** game single-player Android landscape dengan desa/kerajaan 2D isometrik, pixel art chibi, budaya Nusantara dan mistis lucu. Pemain membuat pemimpin serta dinasti sendiri, berawal sebagai kepala desa kecil di kawasan Malang/Tumapel, lalu dapat menjadi vasal atau penguasa merdeka. Pilot dibatasi Jawa Timur; penyatuan Nusantara adalah visi jangka panjang.

**Hipotesis produk — PROPOSED:** pemain yang menyukai membangun desa dan cerita karakter membutuhkan strategi dengan sebab-akibat yang terbaca, keputusan bermakna, serta tugas rutin yang dapat didelegasikan. Kompleksitas sistem tidak boleh menuntut pengelolaan setiap penduduk. Hipotesis ini perlu playtest, bukan klaim riset pasar.

Target audiens terkonfirmasi secara arah: anak/remaja dan pengalaman yang mudah didekati. Rentang umur utama, tingkat kemampuan membaca, bahasa rilis, dan rating konten masih OPEN. Bahasa Indonesia sebagai bahasa prototipe diusulkan; jangan mengasumsikan segmentasi kebijakan anak sudah diselesaikan.

Nilai yang ingin dibuktikan: pemain memahami kebutuhan desa, memilih tindakan, melihat warga dan persediaan merespons, lalu menghadapi pilihan naratif dengan dampak yang terlihat.

## 3. Pilar dan batas identitas

| Pilar | Bukti pengalaman yang dituju | Batas desain |
|---|---|---|
| Desa hidup | Pekerja dan keputusan pembangunan memengaruhi pangan | Sprite ramai saja tidak membuktikan simulasi |
| Karakter penting | Tokoh memiliki peran dan respons terhadap keputusan | Jangan memaksa micromanagement seluruh rakyat |
| Sandbox terbimbing | Quest mengajarkan solusi dan dapat ditolak | Quest opsional; konsekuensi dunia tetap transparan |
| Politik berkonsekuensi | Pilihan vasal/merdeka dan kekalahan berpengaruh | Ditambahkan setelah loop desa stabil |
| Sejarah alternatif | Dunia terinspirasi sejarah dengan kesempatan intervensi | Fakta, sastra dan fiksi harus dibedakan |
| Keterbacaan mobile | HUD, tindakan dan sebab kegagalan dapat dipahami lewat touch | Tidak bergantung hover, teks kecil atau ketepatan mouse |

Inspirasi Ninja Village/Norland tidak mengizinkan penyalinan aset, kode, dialog, UI, atau konten spesifik. Identitas visual, narasi dan implementasi harus orisinal.

## 4. Hasil produk, lapisan scope dan non-goals

Semua batas jumlah berikut **PROPOSED**, mengikuti batas first slice AGENTS tanpa memperluasnya.

| Lapisan | Tujuan dan isi | Tidak termasuk / gate |
|---|---|---|
| Technical foundation | M0–M1: satu desa, input, placement, stok, clock, kamera, save/load | Bukan produk rilis; lulus audit fungsi dan invariant data |
| Vertical slice | Hasil M1–M2 + spike Android usulan: 1 desa, 3 bangunan inti rumah/sawah/lumbung, 1 cara memulihkan kayu, pekerja otomatis, 1 pejabat bernama yang dapat diajak bicara, 1 quest krisis pangan dengan ≥2 hasil | Sesi evaluasi 10–15 menit; tanpa world map, combat, dinasti berjalan, offline, pasar dinamis atau ads |
| Pilot | M3–M4: 1 chapter Jawa Timur, desa utama + 1 tetangga, peta ringkas, diplomasi terbatas, 1 battle lapangan, konsekuensi kalah, 1 demonstrasi suksesi sederhana | Durasi chapter dan jumlah quest belum dikunci; tidak menjanjikan seluruh Jawa Timur atau siege penuh |
| MVP / kandidat rilis minimum | Pilot yang sudah lolos touch, onboarding, save recovery, performa, review konten dan distribusi; loop tetap bisa dilanjutkan setelah chapter sesuai aturan akhir yang disetujui | MVP bukan sinonim prototype; gate rilis terpisah, tidak wajib ada iklan |
| Ekspansi / post-launch kandidat | Banyak settlement, delegasi lintas desa, logistik lanjut, dinasti mendalam, intrik/intelijen, riset hybrid, kualitas barang, siege lengkap, Nusantara | Bukan janji jadwal maupun daftar fitur pasti setelah rilis |

Jalur pemulihan kayu belum menentukan bangunan keempat: produksi sederhana, tindakan pemulihan, atau pilihan lain harus diputuskan pada GDD. Upeti tidak menjadi quest kedua pada slice; dapat menjadi konteks penutup menuju pilot.

Tidak ada multiplayer, backend, analytics, ads SDK, pembayaran, paket eksternal, atau pengumpulan data pada scope kerja ini. Penambahan membutuhkan approval pemilik. Tidak ada penghapusan art/scene atau refactor besar otomatis.

## 5. Core loop, perjalanan pemain dan motivasi

**PROPOSED loop slice:** amati stok/kebutuhan → pilih prioritas → bangun dan atur tenaga kerja → jalankan/pause waktu → baca hasil → bicara dengan pejabat atau pilih respons quest → sesuaikan ekonomi.

Perjalanan sesi uji:
1. Masuk desa; melihat pangan, bahan bangunan, penduduk/pekerja, waktu dan bantuan ringkas.
2. Memilih sawah, melihat biaya/preview validitas, menempatkan bangunan, dan memahami perubahan stok.
3. Mengamati produksi dengan pekerja; mengubah prioritas dan melihat akibatnya.
4. Membaca masalah pangan dari tokoh bernama; memilih satu dari sedikitnya dua respons yang masuk akal dalam ekonomi lokal.
5. Melihat akibat pilihan pada stok/status quest/respons tokoh; melanjutkan pembangunan dan menyimpan permainan.

Solusi quest slice tidak boleh bergantung perdagangan/diplomasi yang belum dibangun. Jenis pilihan dan angka efek disahkan dalam QUEST_EVENTS. Menolak panduan tidak mengunci kontrol dasar. Mengabaikan masalah dapat memiliki konsekuensi saat waktu aktif, tetapi harus ada penjelasan dan jalur pemulihan yang disetujui.

Loop pilot memperluas surplus → relasi tetangga → keputusan politik → konflik/penyelesaian → perubahan status → pemulihan. Victory besar penyatuan Nusantara bukan kondisi selesai slice atau pilot.

## 6. Requirement fungsional dan penerimaan

Semua acceptance criteria adalah **target usulan**, bukan hasil uji. P0 = wajib fondasi; P1 = wajib slice; P2 = pilot; Later = visi. Setiap implementasi membutuhkan task card dan data uji tetap.

| ID / prioritas | Requirement | Acceptance criterion terukur | Manual test minimum |
|---|---|---|---|
| FR01 / P0 | Placement grid isometrik dengan biaya dan okupansi | 1 placement valid memberi tepat 1 bangunan dan 1 debit; occupied/luar/biaya kurang tidak mengubah state | Uji tiap bangunan pada petak kosong/terisi/luar dan stok kurang; bandingkan saldo |
| FR02 / P0 | Input UI, dunia dan kamera tidak saling salah memicu | Klik/tap UI dan drag kamera menghasilkan 0 placement tidak disengaja; cell terpilih benar setelah pan/zoom | Pilih bangunan, tekan HUD, pan/zoom, tempatkan di sudut peta |
| FR03 / P0 | Pause dan 1×/2×/3× | Jumlah tick sama menghasilkan state ekonomi sama pada ketiga speed; pause tidak memajukan tick | Amati pause 10 detik, lalu fixture jumlah tick sama pada semua speed |
| FR04 / P0 | Inventori dan produksi/konsumsi lokal | Stok akhir = awal + produksi − konsumsi − biaya; tak ada stok negatif; penyebab perubahan terlihat | Catat ledger beberapa siklus, uji stok nol dan tanpa pekerja |
| FR05 / P1 | Ekonomi dapat dipulihkan | Fixture salah pembangunan/kekurangan punya ≥1 jalur pemulihan yang terdokumentasi tanpa transaksi berbayar | Habiskan bahan sesuai fixture, ikuti jalur pemulihan, bangun kembali |
| FR06 / P0 | Save/load berversi dan aman | Round-trip memulihkan state relevan; gagal load tidak mengganti sesi aktif; save rusak punya respons jelas | Simpan, tutup/buka, bandingkan stok/bangunan/tick/quest; uji file rusak dan versi tak didukung |
| FR07 / P1 | Worker otomatis mengikuti prioritas dan kapasitas | Alokasi total ≤ workforce tersedia; tidak double assignment; produksi mengikuti alokasi, bukan sprite | Kurangi pekerja, ubah prioritas, uji lowongan kosong dan kapasitas penuh |
| FR08 / P1 | Tokoh bernama dan satu pejabat pertanian | Dapat diajak interaksi; mandat/anggaran terlihat; tindakan di atas wewenang tidak berjalan tanpa pilihan pemain | Buka tokoh, ubah penugasan, uji batas anggaran dan permintaan keputusan besar |
| FR09 / P1 | Satu quest krisis pangan data-driven | ≥2 hasil dapat dicapai dari fixture; efek diterapkan sekali, termasuk setelah load | Mainkan kedua jalur terpisah, reload sebelum/sesudah resolusi; coba pilih ulang |
| FR10 / P1 | Guidance opsional dengan akibat terbaca | Kontrol dasar tetap tersedia setelah menolak panduan; warning muncul sebelum resolusi berkonsekuensi | Ikuti, tolak dan abaikan quest; catat warning, kondisi pemulihan dan outcome |
| FR11 / P1 | Touch dan lifecycle Android | Place/pan/zoom/dialog dapat dilakukan tanpa mouse; suspend/resume tidak menggandakan transaksi atau memajukan event penting | Mainkan loop di perangkat, background/foreground sebelum dan sesudah pilihan/save |
| FR12 / P2 | World map dan satu tetangga | Relasi/status politik tampil konsisten setelah kembali ke desa dan load | Ubah relasi melalui tindakan yang disahkan, pindah tampilan, save/load |
| FR13 / P2 | Battle lapangan hybrid | Unit bergerak/menyerang otomatis; command yang disahkan, retreat dan skill senapati memberi hasil terukur; outcome diterapkan sekali | Jalankan fixture menang/kalah/retreat dan reload masing-masing |
| FR14 / P2 | Kekalahan bermakna dengan kelanjutan | ≥1 outcome kalah mengubah status politik dan menyediakan tindakan lanjutan yang dapat dimainkan | Kalah, lihat status baru, jalankan tindakan pemulihan; load mempertahankan status |
| FR15 / P2 | Dinasti sederhana | 1 transisi pemimpin mempertahankan desa dan quest dengan ID/otoritas pemimpin baru yang valid | Picu fixture suksesi, lanjutkan interaksi dan save/load |
| FR16 / Later | Offline terbatas | Hanya allowlist rutin yang maju sampai cap; perang/event besar tidak maju; resume ganda tidak menggandakan reward | Uji durasi nol/negatif/melebihi cap, stok habis, pilihan tertunda, resume berulang |
| FR17 / Later | Multi-settlement dan logistik | Stok terpisah; transfer debit/kredit dapat direkonsiliasi; desa aktif/nonaktif setara pada input sama | Kirim muatan, berpindah desa dan load; bandingkan ledger |
| FR18 / Later | Living history, time skip | Kesempatan intervensi diberikan sebelum resolusi; skip berhenti pada pilihan besar; offline tidak meresolusi | Abaikan event ketika aktif, coba skip dengan pilihan tertunda, lalu suspend |

FR03 tidak memutuskan apakah command membangun boleh saat pause. Usulan: waktu berhenti tetapi command pemain tetap diterima; keputusan O06 harus ditutup sebelum kontrak diimplementasikan. FR16–18 mencatat visi dan test intent, tidak mengaktifkan backlog implementasi.

## 7. Register pelestarian keputusan handoff

| Referensi | Keputusan yang dipertahankan | Penempatan target / detail yang tetap terbuka |
|---|---|---|
| D01–D05 | Kepala desa, sejarah/fiksi/mistis, alternatif sejarah, vasal/merdeka, single-player | Identitas sejak slice; politik/cabang sejarah pilot; nama/tanggal rinci belum final |
| D06–D07 | Waktu berjalan; kemungkinan iklan opsional; offline terbatas tanpa perang/event penting | Clock fondasi; bisnis/cap offline terbuka, tidak ada integrasi iklan |
| D08 | Pekerja otomatis, prioritas pemain, pengelolaan tokoh | Slice; aturan agregasi dan assignment perlu GDD |
| D09–D11 | Combat hybrid, arena lapangan, siege settlement, kekalahan berat | Combat pilot terbatas; siege dan exile lengkap ditunda |
| D12–D14 | Karakter/dinasti sendiri, enam atribut, pejabat dengan keputusan besar oleh pemain | Slice tokoh/pejabat; pilot suksesi; nama atribut konflik C01, rumus/skala terbuka |
| D15–D18 | Peta dunia + settlement, kendali manual/delegasi, stok lokal/logistik, ekonomi hybrid | Lokal slice, tetangga pilot, multi-desa lebih lanjut; tidak diganti stok global |
| D19–D20 | Rantai produksi lanjut; knowledge tree + ahli NPC | Visi lanjutan, bukan seluruhnya MVP |
| D21–D23 | Tutorial/krisis/upeti/misteri bertahap, quest opsional, living history | Krisis slice; urutan babak pilot masih usulan; deadline/skip perlu desain |
| D24–D27 | Landscape mobile, solo Windows dengan Codex/Git, target Google Play, planning dahulu | Mengikat proses; agent spesialis adalah peran logis, bukan otomatis berjalan |
| DECISIONS tambahan | Kepribadian dinamis, wewenang belanja terbatas, kualitas barang, time jump per chapter | Dipertahankan sebagai visi; belum otomatis masuk slice |

Enam nama atribut baseline repo tetap Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality sampai ratifikasi. Tidak menetapkan skala 1–100, rumus trait, reproduksi, umur, atau jabatan sejarah sebagai fakta.

## 8. UX, aksesibilitas, visual dan audio

**CONFIRMED:** landscape 16:9, isometrik chibi, lingkungan Jawa tropis dan mistis ringan. 1280×720 adalah baseline starter; ukuran desain final PROPOSED. UI harus menangani rasio Android lebih lebar dan safe area.

**PROPOSED:** HUD persisten untuk stok/waktu, panel bangunan, inspector tokoh, dialog quest, menu save/settings. Satu aksi utama per panel; alasan gagal berbentuk teks singkat. Tap memilih/konfirmasi, drag menggeser, pinch zoom; aturan pembatalan placement perlu uji agar drag tidak membangun. Tidak ada fitur yang hanya bisa dijangkau melalui hover.

Aksesibilitas minimum usulan: informasi tidak bergantung warna saja, label teks untuk ikon penting, ukuran teks dapat diperbesar, suara dapat diatur, pilihan mengurangi animasi dekoratif. Target sentuh awal 48 dp diusulkan untuk uji perangkat, bukan klaim kepatuhan platform. Ukuran font, konversi dp, kontras dan skala pixel diuji pada perangkat minimum sebelum dikunci.

Art pipeline: satu style sample desa/karakter/HUD sebelum produksi massal; catat origin sprite, tile size, occlusion, atlas dan skala dalam ART_UX_GUIDE. Setiap aset/font/audio memiliki pembuat, sumber, lisensi, perubahan dan bukti izin. Musik/instrumen budaya tidak otomatis dianggap cocok secara sejarah. Audio memberi umpan balik tindakan tanpa menjadi satu-satunya pembawa informasi.

## 9. Narasi, sejarah dan batas konten

**CONFIRMED:** sekitar krisis Tumapel awal abad ke-13; Ken Dedes/Ken Arok/Kadiri sebagai inspirasi historis-literer. Tahun 1219–1222, Tirta Wening, Babad Tanah Tumapel, tokoh spesifik, Panawijen dan struktur babak masih PROPOSED/VERIFY sesuai handoff. PRD tidak menegaskan kronologi atau batas wilayah sebagai fakta sejarah.

LORE_BIBLE harus memberi source ledger: klaim, sumber, kategori (prasasti/penelitian/tradisi sastra/fiksi), tingkat kepastian, adaptasi dan reviewer. Riset primer/akademik diperlukan sebelum konten final. Fiksi harus ditandai sebagai adaptasi; hindari penyajian agama/etnis sebagai atribut moral bawaan. Kekerasan non-grafis adalah usulan tone; detail penawanan, kematian, pernikahan dan suksesi disesuaikan setelah target usia diputuskan.

## 10. Requirement nonfungsional dan strategi Android-first

| ID | Target PROPOSED | Verifikasi / gate |
|---|---|---|
| NFR01 | Model simulasi independen rendering, data-driven, ID stabil; hasil reproducible sejauh praktis | Fixture state sama pada tick/input/seed sama dalam versi yang sama; bukan janji determinisme lintas engine |
| NFR02 | 30 FPS baseline perangkat minimum; p95 frame time ≤33,3 ms pada sesi beban slice 15 menit | Profil build perangkat, catat model/OS/beberapa beban; 60 FPS opsional setelah bukti |
| NFR03 | Tidak ada crash atau kerusakan save pada skenario wajib; load gagal aman | Uji cold start, suspend, tutup saat save, korupsi, backup; dokumentasikan actual |
| NFR04 | Konsistensi ekonomi dan efek tepat sekali | Ledger, speed equivalence, pilihan quest berulang, save/load, resume |
| NFR05 | Touch utuh pada 16:9 dan layar lebih lebar tanpa kontrol penting terpotong | Uji perangkat fisik, safe area, teks panjang, dialog dan occlusion |
| NFR06 | Tidak ada paket/SDK/data collection di luar approval | Review perubahan dependency dan build; metrik playtest dicatat lokal secara manual |
| NFR07 | Modifikasi kecil, typed GDScript praktis, main.gd dipisah bertahap | Review kontrak dan regression; hindari framework generik prematur |

RAM minimum, chipset/GPU, versi OS minimum, populasi, jumlah bangunan maksimum, peak memory, ukuran unduhan, waktu startup/save/load masih **TBD**. Nilai ini wajib ditetapkan setelah perangkat diketahui dan profiling; NFR02 belum dapat diterima tanpa perangkat serta fixture beban yang bernama.

Urutan Android usulan: setelah baseline input terbukti, spike build/install/landscape/touch/suspend → loop slice di perangkat → profil beban pilot → hardening distribusi. Pengujian Windows tidak menggantikan Android. Tidak menambah SDK untuk pengukuran; gunakan profiling/debug lokal yang tersedia. Verifikasi versi engine/template saat audit, jangan menentukannya dari nama folder.

## 11. Batas arsitektur, data dan persistence

Arah yang dipertahankan: Godot 4.7.2 Standard + GDScript; model terpisah dari scene/render; definisi konten terpisah dari runtime; command tervalidasi; ID stabil; save berversi. Blueprint lama tetap kandidat TDD, bukan implementasi yang dianggap sudah ada.

Usulan ownership: session memiliki state otoritatif; placement mengubah okupansi dan biaya atomik; economy mengubah stok lewat transaksi; workforce tidak menggandakan pekerja; quest menyimpan effect ID; view/HUD hanya membaca state dan mengirim command. Command tidak bergantung listener UI untuk menghasilkan efek. Pisahkan kebijakan pause, tick, dan lifecycle.

SAVE_FORMAT wajib disahkan sebelum persistence: envelope versi, ID konten, tick/remainder, RNG bila dipakai, stok/bangunan/assignment/tokoh/quest; validasi sebelum swap state; temporary save dan backup; versi tak dikenal ditolak; aturan migrasi serta recovery. Format JSON dan jumlah slot belum menjadi keputusan final. Jangan menyimpan Node sebagai state produk.

Offline baru setelah save/ekonomi/lifecycle stabil. Cap empat jam dalam blueprint hanyalah usulan lama, belum keputusan. Simpan checkpoint resume agar perhitungan tidak terduplikasi; putuskan kondisi stok habis, jam mundur, time skip dan pilihan tertunda sebelum implementasi.

## 12. Ukuran keberhasilan dan strategi validasi

**PROPOSED untuk slice:** 3 sesi playtest pemain baru; sekurangnya 2 dari 3 menyelesaikan loop dasar dalam 15 menit tanpa bantuan verbal, dapat menjelaskan mengapa pangan berubah, dan menemukan cara berinteraksi dengan tokoh. Catat waktu tindakan pertama, salah tap/placement, panel membingungkan, penyebab gagal dan kebutuhan bantuan. Sampel ini menguji usability awal, bukan bukti pasar/statistik. Jika melibatkan anak, tata cara partisipasi ditetapkan bersama wali sebelum pengujian.

Gate teknis slice: semua FR01–FR11 yang berlaku lulus; nol blocker crash/data loss/aksi inti gagal; dua hasil quest dan pemulihan ekonomi terbukti; touch perangkat lulus. Tidak ada klaim gate selesai hanya dari parser. Gate pilot menambah FR12–FR15; gate MVP menambah penerimaan konten, performa dan rilis.

Metode: model test untuk invariant penting; integration test command→state→HUD dan load→view; manual test dari tabel FR; playtest pengalaman; profil perangkat. Laporan memuat versi/commit, fixture, expected/actual, pass/fail/not tested, log, known limitations dan penerimaan Director. Tidak perlu analytics eksternal untuk mengukur tahap ini.

## 13. Roadmap dan rencana dokumen lanjutan

Roadmap resmi tetap M0–M4. Estimasi kalender ditahan sampai kapasitas pengembang dan dua siklus tugas terukur tersedia.

| Gate | Outcome | Dependensi / keputusan |
|---|---|---|
| Review pra-produksi | PRD dan scope disetujui; keputusan prioritas tercatat | O01–O04; bukan izin menjalankan seluruh visi |
| M0 audit dan baseline | Bug dapat direproduksi; input/waktu/placement terbukti | Audit terpisah, keputusan salvage; checkpoint setelah milestone teruji |
| M1 fondasi | Grid, ekonomi, kamera, save aman | GDD minimum, kontrak, SAVE_FORMAT; spike Android awal usulan |
| M2 / vertical slice | Pekerja, interaksi pejabat dan satu quest membentuk loop | M1; kriteria playtest dan perangkat |
| M3 konflik | Tetangga, diplomasi, battle dan akibat kalah | Slice diterima; GDD combat/politik disetujui |
| M4 pilot Android | Chapter, transisi sederhana, touch/performa | Budget konten/perangkat dan hasil M3 |
| MVP hardening | Kandidat produk diterima dan distribusi siap | Definisi akhir chapter, model bisnis, review rilis |

Dependency desain: scope/audit → core loop dan ekonomi → clock/placement/inventory → workforce/character → quest/official; state + schema → save; save + lifecycle + ekonomi → offline (kelak); slice → world/diplomacy → combat/outcome → pilot; kalender + karakter → suksesi. Touch/performa mengikuti fondasi sampai pilot. Lore dan provenance berjalan sebelum konten dikunci.

| Paket berikut | Isi minimum | Exit criterion |
|---|---|---|
| AUDIT_REPORT | Versi, reproduksi, expected/actual, salvage vs rebuild | Baseline terukur; tidak mengubah source pada audit |
| MASTER_GDD + ECONOMY_BALANCE | Loop, aturan pause/kalender, biaya/tenaga kerja, pemulihan, batas konten | Keputusan gameplay minimum disahkan |
| QUEST_EVENTS + LORE_BIBLE | Graph dua hasil/follow-refuse-ignore, source ledger, pilihan dan deadline | Efek konsisten dan klaim konten diteliti |
| TDD + MODULE_CONTRACTS | Model/view, ownership, command, tick order, error/invariant | Kontrak fondasi cukup untuk task kecil; tanpa membangun seluruh framework |
| DATA_SCHEMAS + SAVE_FORMAT | Definisi/runtime, ID, versi, backup/recovery | Disahkan sebelum persistence |
| TEST_PLAN + PERFORMANCE_BUDGET + ART_UX_GUIDE | Fixture, perangkat, beban, input, style/provenance | Kriteria slice bisa direproduksi |
| WORLD_DIPLOMACY + COMBAT_DESIGN + CHARACTER_DYNASTY | Aturan pilot yang dibutuhkan saja | Slice lolos, scope pilot disetujui |
| RELEASE_CHECKLIST | Distribusi, signing, rating, privasi, kebijakan resmi terkini | Hanya setelah rencana rilis konkret; bukan pernyataan compliance saat ini |

## 14. Organisasi kerja dan quality gates

Peran logis mengikuti AI_AGENT_STRATEGY: Director memutuskan visi/scope; Lead memiliki kontrak/integrasi dan file bersama; World memiliki grid/kamera; Simulation memiliki clock/inventory; Character memiliki workforce/tokoh; Narrative memiliki quest/lore; Combat aktif sesudah slice; UI/Art memiliki interaksi/presentasi; QA memiliki bukti/performa/rilis. Tidak mengaktifkan agent otomatis.

Default satu pekerjaan tulis aktif. Jika delegasi diminta, tetapkan satu owner per file, allowed files dan kontrak; gunakan branch/worktree untuk pekerjaan paralel. Lead menangani main scene, konfigurasi, shared schema dan integrasi. Tiap task memiliki outcome, non-goals, acceptance criteria dan manual test.

Quality gates: keputusan prasyarat selesai → review kontrak → implementasi kecil → import/parser → tes relevan → manual/Android sesuai dampak → review diff dan dokumen → checkpoint Git terbatas → penerimaan milestone oleh Director. Semua langkah implementasi masih tertahan sampai PRD/scope disetujui sesuai handoff §12–13.

## 15. Risk register

| Risiko / tingkat | Pemilik | Pemicu | Mitigasi / tindakan |
|---|---|---|---|
| Scope berlebih / tinggi | Director | Fitur baru masuk sebelum gate selesai | Tukar scope secara eksplisit atau pindahkan backlog; satu milestone aktif |
| Prototype tidak bekerja / tinggi | Lead + QA | Reproduksi gagal/hasil tidak konsisten | Audit sebelum refactor; perbaikan sempit; rebuild hanya proposal terpisah |
| Softlock ekonomi / tinggi | Simulation | Stok nol dan tak ada aksi pemulihan | Fixture kegagalan dan jalur pemulihan sebelum balancing lanjutan |
| Save/efek ganda / tinggi | Lead | Load/resume mengubah stok atau outcome ulang | Versioning, transaksi, effect ID, backup, failure tests |
| Android lambat/panas / tinggi | QA | Gagal target di perangkat minimum | Spike dini, profil, kurangi kapasitas/visual berdasarkan bukti |
| Narasi meledak bercabang / tinggi | Narrative | Kombinasi outcome tak teruji bertambah | Sedikit cabang dengan konsekuensi terdefinisi; state graph dan fixture |
| Representasi sejarah / tinggi | Narrative + Director | Klaim tanpa sumber atau adaptasi membingungkan | Ledger, label fiksi, review budaya sebelum publikasi |
| Usia/konten/iklan / tinggi | Director | Audiens/rating belum jelas menjelang distribusi | Tetapkan audiens, review resmi; jangan integrasikan ads lebih awal |
| Produksi aset/lisensi / tinggi | Art | Provenance hilang atau biaya melebihi kapasitas | Sample dahulu, inventaris aset, scope konten dibatasi |
| Integrasi AI / sedang | Lead | Kontrak/file disentuh beberapa penulis | Owner tunggal, diff kecil, regression dan checkpoint |
| Kalender/dinasti tidak cocok / tinggi | Product | Umur berubah terlalu cepat atau cerita terlewat | Pisahkan pacing ekonomi/naratif sebagai usulan; uji timeline sebelum suksesi |
| Waktu/biaya tidak diketahui / tinggi | Director | Target tanggal muncul tanpa throughput | Catat kapasitas dan hasil dua siklus; estimasi rentang kemudian |

## 16. Decision log terbuka dan rekomendasi

Semua item berikut **OPEN**, bukan persetujuan tersirat. Director dapat menerima sebagian; jangan meminta semua detail lanjutan sekaligus.

| ID | Keputusan | Rekomendasi PROPOSED | Dibutuhkan sebelum |
|---|---|---|---|
| O01 | Batas slice/pilot/MVP | Terima scope §4; satu quest slice, satu tetangga pilot; MVP adalah pilot yang dipoles dan divalidasi | Scope/implementasi |
| O02 | Audiens utama, bahasa dan tone | Bahasa Indonesia untuk prototipe, tone non-grafis; Director menetapkan rentang umur | UX/konten final dan playtest audiens |
| O03 | Kapasitas kerja dan dana | Catat jam/minggu, biaya art/audio/perangkat dan waktu tes; belum menetapkan tanggal rilis | Estimasi delivery |
| O04 | Perangkat Android dan spike dini | Gunakan perangkat fisik tersedia untuk spike; pilih perangkat minimum sebelum anggaran final | Validasi Android |
| O05 | Audit, salvage/rebuild | Audit tanpa source edit; utamakan perbaikan bertahap bila biaya masuk akal | Perbaikan source |
| O06 | Kalender, pause dan command | Pause menghentikan tick, command eksplisit tetap boleh; kalender naratif tidak otomatis mengikuti umur tick ekonomi | GDD clock/input |
| O07 | Ekonomi/workforce/pemulihan | Model kelompok ringan, alokasi stabil, satu jalur pemulihan bahan | Schema ekonomi |
| O08 | Enam atribut | Ratifikasi nama baseline DECISIONS; skala dan rumus ditunda | Spesifikasi karakter |
| O09 | Save slot/autosave/backup | Usulan 1 slot manual + autosave + backup; format/rules dalam SAVE_FORMAT | Persistence |
| O10 | Offline cap dan konsumsi | Tunda dari slice; uji sesudah save stabil, tanpa perang/event besar | Offline |
| O11 | Nama/kronologi/akurasi lore | Tetap placeholder sampai source ledger dan review Director | Konten final |
| O12 | Akhir chapter, kekalahan dan suksesi | Pilot satu konsekuensi politik yang bisa dipulihkan dan satu transisi pewaris; aturan tanpa pewaris perlu diputuskan | GDD pilot |
| O13 | Monetisasi dan distribusi | Buktikan loop tanpa ads; pilih bisnis dan review kebijakan saat rilis direncanakan | Integrasi bisnis/rilis |
| O14 | Batas konten/performa pilot | Tetapkan jumlah bangunan/NPC/quest, memori/unduhan setelah spike dan sampel aset | Produksi pilot |
| O15 | Pipeline art/audio | Sample orisinal + ledger lisensi sebelum produksi massal | Pemesanan/pembuatan aset skala besar |

## 17. Status penerimaan dokumen

- Pembacaan handoff dan seluruh dokumen Markdown proyek yang ditemukan: selesai.
- Gap analysis dan PRD: tersedia sebagai draft untuk review.
- Ratifikasi konflik, angka scope, target perangkat dan keputusan terbuka: belum.
- Audit interaksi prototype, riset sejarah dan verifikasi kebijakan: belum dilakukan dalam tugas dokumentasi ini.
- Implementasi fitur: belum dimulai. Milestone gameplay tidak dinyatakan lulus.

Langkah berikut: Director mereview O01–O04 terlebih dahulu; kemudian audit baseline terpisah dan finalisasi GDD/TDD minimum sesuai hasil review. Handoff §12 secara eksplisit meminta implementasi ditahan sampai PRD dan scope disetujui.

### Catatan verifikasi penyusunan

Pemeriksaan 26 Oktober 2026: `git diff --check` tidak melaporkan masalah pada perubahan tracked; kedua dokumen baru masih untracked saat pemeriksaan. Godot headless editor dijalankan dengan `--headless --path . --editor --quit`; executable melaporkan **4.7.2.stable.official.ed1daf0bf**, exit code 0. Namun log berisi kegagalan akses direktori editor AppData/Godot, `user://`, dan penyimpanan editor settings; pemeriksaan tidak dinyatakan lulus bersih. Tidak terlihat laporan parse error GDScript pada output tersebut. Interaksi gameplay dan Android tetap belum diuji. Versi executable teramati ini melengkapi C04, tetapi tidak membuktikan baseline runtime berhasil.

Hanya `docs/GAP_ANALYSIS.md` dan `docs/PRD.md` dibuat oleh tugas ini; handoff yang sudah untracked sebelumnya dipertahankan. Tidak ada perubahan source gameplay, scene, konfigurasi, DECISIONS, atau ROADMAP. Dokumen tersimpan sebagai checkpoint draft lokal; belum dibuat commit milestone karena belum ada penerimaan scope atau milestone gameplay teruji.
