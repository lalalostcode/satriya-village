# Product Requirements Document — Satriya Village v1.1

Tanggal: 26 Oktober 2026. Pemilik keputusan: Human Game Director. Penyusun: Principal Game Architect / Product Lead.

**Status: DRAFT — arah revisi diterima secara prinsip; PRD secara keseluruhan belum APPROVED.** Audit gameplay A02: **NOT TESTED**. Pekerjaan saat ini hanya dokumentasi; implementasi dan refactor Godot belum diotorisasi.

Revisi ini memperbarui PRD v1.0 pada berkas yang sama. Struktur §1–17 dan ID FR01–FR18/O01–O15 dipertahankan. Persetujuan Director, batasnya, dan pertanyaan tersisa dicatat dalam [Decision Register](DECISION_REGISTER.md); riwayat revisi tersedia di §18.

Dokumen pendamping: [Gap Analysis](GAP_ANALYSIS.md). Sumber utama: [handoff](../Satriya_Village_Planning_Handoff_v1.md), [keputusan berlaku](DECISIONS.md), [roadmap](ROADMAP.md), [audit independen](reviews/Satriya_Village_Independent_Audit_2026-10-26.md), dan [instruksi proyek](../AGENTS.md). Blueprint lama tetap proposal pendukung; aturan yang kini dikonfirmasi dicatat secara spesifik, tanpa mengesahkan seluruh blueprint.

## 1. Cara membaca dan tata kelola

- **CONFIRMED:** keputusan eksplisit handoff atau baseline DECISIONS/AGENTS. Konfirmasi visi tidak menjamin fitur masuk rilis awal.
- **PRINCIPLE_ACCEPTED:** arah diterima Director, dengan detail/scope yang masih perlu diputuskan. Bukan persetujuan seluruh requirement atau rilis.
- **PROPOSED:** rekomendasi PRD, termasuk semua jumlah konten, target angka, pacing, dan batas rilis baru. Belum disetujui.
- **VERIFY:** memerlukan bukti, riset, atau uji; bukan fakta terverifikasi.
- **OPEN:** pilihan Game Director yang belum diputuskan. Konflik label sumber dicatat pada Gap Analysis C01–C14.

Hanya Director yang menetapkan persetujuan desain/scope. [Decision Register](DECISION_REGISTER.md) menyimpan sumber, tanggal, batas dan konsekuensi keputusan. Status keputusan dipisahkan dari hasil uji PASS/FAIL/NOT TESTED. Persetujuan prinsip tidak otomatis menutup gap planning, meluluskan M0, atau mengotorisasi coding. Requirement di bawah adalah spesifikasi target; belum menjadi klaim implementasi.

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

**PRINCIPLE_ACCEPTED:** vertical slice boleh dibatasi satu desa. Batas ini tidak menghapus politik, dinasti, perang, ekonomi mendalam, living history atau ekspansi Nusantara. Manifest rinci slice dan angka berikut masih **PROPOSED** melalui O01; scope pilot serta MVP belum disetujui.

| Lapisan | Tujuan dan isi | Tidak termasuk / gate |
|---|---|---|
| Technical foundation | M0–M1: satu desa, input, placement, stok, clock, kamera, save/load | Bukan produk rilis; lulus audit fungsi dan invariant data |
| Vertical slice | Hasil M1–M2 + spike Android usulan: 1 desa, 3 bangunan inti rumah/sawah/lumbung, 1 cara memulihkan kayu, pekerja otomatis, 1 pejabat bernama yang dapat diajak bicara, 1 quest krisis pangan dengan ≥2 hasil | Sesi evaluasi 10–15 menit; tanpa world map, combat, dinasti berjalan, offline, pasar dinamis atau ads |
| Pilot | M3–M4: 1 chapter Jawa Timur, desa utama + 1 tetangga, peta ringkas, diplomasi terbatas, 1 battle lapangan, konsekuensi kalah, 1 demonstrasi suksesi sederhana | Durasi chapter dan jumlah quest belum dikunci; tidak menjanjikan seluruh Jawa Timur atau siege penuh |
| MVP / kandidat rilis minimum | Definisi masih OPEN; usulan v1.0 berupa pilot yang dipoles tetap bahan evaluasi, bukan keputusan produk | Konten, durasi, kondisi akhir dan hubungan MVP dengan pilot membutuhkan keputusan tersendiri |
| Ekspansi / post-launch kandidat | Banyak settlement, delegasi lintas desa, logistik lanjut, dinasti mendalam, intrik/intelijen, riset hybrid, kualitas barang, siege lengkap, Nusantara | Bukan janji jadwal maupun daftar fitur pasti setelah rilis |

Jalur pemulihan kayu belum menentukan bangunan keempat: produksi sederhana, tindakan pemulihan, atau pilihan lain harus diputuskan pada GDD. Upeti tidak menjadi quest kedua pada slice; dapat menjadi konteks penutup menuju pilot.

O01 dibagi menjadi O01-S (manifest slice), O01-P (scope pilot), dan O01-M (definisi MVP) tanpa mengganti ID asal. Persetujuan salah satunya tidak mengesahkan yang lain. Sesi 10–15 menit adalah target evaluasi yang diusulkan, bukan durasi campaign. Daftar pengecualian slice pada tabel juga menunggu ratifikasi manifest; visi yang ditunda tetap ditelusuri pada §7 dan [ROADMAP](ROADMAP.md).

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

Acceptance criteria adalah **target usulan**, bukan hasil uji. Aturan pause dan batas agregasi di FR03/FR07 kini CONFIRMED; parameter, kontrak rinci dan uji penerimaannya tetap perlu diselesaikan. P0/P1/P2/Later adalah prioritas rancangan v1.0, bukan bukti persetujuan paket implementasi. Setiap implementasi kelak membutuhkan task card dan data uji tetap.

| ID / prioritas | Requirement | Acceptance criterion terukur | Manual test minimum |
|---|---|---|---|
| FR01 / P0 | Placement grid isometrik dengan biaya dan okupansi | 1 placement valid memberi tepat 1 bangunan dan 1 debit; occupied/luar/biaya kurang tidak mengubah state | Uji tiap bangunan pada petak kosong/terisi/luar dan stok kurang; bandingkan saldo |
| FR02 / P0 | Input UI, dunia dan kamera tidak saling salah memicu | Klik/tap UI dan drag kamera menghasilkan 0 placement tidak disengaja; cell terpilih benar setelah pan/zoom | Pilih bangunan, tekan HUD, pan/zoom, tempatkan di sudut peta |
| FR03 / P0 | Pause dan 1×/2×/3×; command eksplisit tetap diizinkan saat pause | Jumlah tick/input sama menghasilkan state ekonomi sama; pause menghentikan kemajuan otomatis; command valid diterapkan sekali tanpa memajukan waktu | Pause 10 detik, lakukan placement/perubahan prioritas yang diizinkan, periksa waktu tetap dan debit sekali; bandingkan fixture tick sama pada semua speed |
| FR04 / P0 | Inventori dan produksi/konsumsi lokal | Stok akhir = awal + produksi − konsumsi − biaya; tak ada stok negatif; penyebab perubahan terlihat | Catat ledger beberapa siklus, uji stok nol dan tanpa pekerja |
| FR05 / P1 | Ekonomi dapat dipulihkan; mekanik dan balancing masih PROPOSED/OPEN | Fixture kekurangan yang disepakati punya ≥1 jalur pemulihan; GDD menetapkan cara, prasyarat dan batas waktunya tanpa transaksi berbayar | Uji kayu/uang nol, pangan+kayu nol, seluruh pekerja teralokasi, dan peta penuh sesuai fixture valid yang disepakati |
| FR06 / P0 | Save/load berversi dan aman | Round-trip memulihkan state relevan; gagal load tidak mengganti sesi aktif; save rusak punya respons jelas | Simpan, tutup/buka, bandingkan stok/bangunan/tick/quest; uji file rusak dan versi tak didukung |
| FR07 / P1 | Ekonomi warga biasa agregat; tokoh penting individual; assignment mengikuti prioritas/kapasitas | Alokasi kelompok ≤ workforce/slot tersedia; tokoh tidak dihitung ganda; jumlah sprite tidak menentukan hasil ekonomi | Ubah prioritas, uji kapasitas dan alokasi tokoh; bandingkan hasil dengan jumlah sprite berbeda atau tanpa rendering |
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
| FR18 / Later | Scheduler living history luas dan time skip; warning lokal tetap bagian FR09/FR10 slice | Kesempatan intervensi diberikan sebelum resolusi; skip berhenti pada pilihan besar; offline tidak meresolusi | Abaikan event ketika aktif, coba skip dengan pilihan tertunda, lalu suspend; warning lokal diuji bersama quest slice |

FR03 kini mengikuti keputusan Director: pause menghentikan simulasi otomatis dan tetap menerima command eksplisit yang valid. Daftar command, urutan transaksi dan parameter waktu belum ditetapkan. FR16–18 tetap mencatat visi dan test intent, tanpa mengaktifkan implementasi.

## 7. Register pelestarian keputusan handoff

Visi pada sumber tetap CONFIRMED dengan konflik sumber yang ditandai di [Decision Register](DECISION_REGISTER.md). Penempatan tahap, dokumen desain yang belum ada, dan acceptance target berikut adalah PROPOSED. Tahap lanjutan dibuka setelah dependensi dan scope disetujui; tidak ada tanggal yang dijanjikan. Deferred berarti ditunda, bukan dihapus.

| Sumber / epic | Tahap atau gate bersyarat | Dokumen desain rencana | Acceptance target |
|---|---|---|---|
| D01/D02/D05 — kepala desa, single-player, sejarah/fiksi/mistis | Identitas slice; nama/lore setelah riset | MASTER_GDD, LORE_BIBLE | Awal kepala desa terbaca; sumber sejarah dan adaptasi dibedakan |
| D03/D23 — sejarah alternatif dan living history | Cabang pilot; scheduler luas setelah kontrak waktu/event | QUEST_EVENTS | Warning/intervensi mendahului resolusi; jalur sejarah dan alternatif dapat dibedakan |
| D04 — vasal atau penguasa merdeka | Setelah slice dan desain politik | WORLD_DIPLOMACY | Status berbeda memberi konsekuensi dan tindakan lanjutan |
| D06 — clock, kemungkinan rewarded ads opsional | Clock fondasi; monetisasi melalui keputusan bisnis terpisah | MASTER_GDD, RELEASE_CHECKLIST | Speed konsisten; cerita dan strategi tersedia tanpa ads |
| D07 — offline terbatas | Setelah save/ekonomi/lifecycle dan O10 | Aturan offline dalam TDD | Hanya allowlist rutin maju; perang/event besar berhenti; resume tidak menggandakan hasil |
| D08/D18 — workforce otomatis dan ekonomi hybrid | Slice setelah kontrak alokasi | SYSTEMS_SPEC, ECONOMY_BALANCE | Alokasi kelompok valid; aset tokoh individual; sprite tidak mengubah ekonomi |
| D09 — unit otomatis, perintah, formasi, skill senapati | Battle pilot usulan; kedalaman setelah battle core diterima | COMBAT_DESIGN | Perintah, formasi dan skill mempunyai efek terdefinisi |
| D10 — arena lapangan dan siege settlement | Arena pilot usulan; siege setelah kontrak combat/settlement | COMBAT_DESIGN | Siege memakai settlement terkait; kerusakan/kepemilikan bertahan setelah load |
| D11 — kekalahan berat, kehilangan kekuasaan, kemungkinan kembali | Akibat politik pilot usulan; kontinuitas lanjut setelah O12 | WORLD_DIPLOMACY, COMBAT_DESIGN | Kalah mengubah state dan menyediakan kelanjutan/pemulihan yang dirancang |
| D12/D13; DECISIONS karakter — pemimpin buatan pemain, enam atribut, trait, kepribadian, dinasti | Karakter awal; suksesi sederhana pilot sebagai visi; detail dan generasi lanjut setelah kalender/O08/O12 | CHARACTER_DYNASTY | Identitas/otoritas valid setelah suksesi; perubahan karakter memiliki sebab dan tersimpan |
| D14; DECISIONS pemerintahan/intrik — pejabat, mandat, diplomasi, intelijen | Pejabat slice; intrik setelah relasi/wewenang/event | SYSTEMS_SPEC, WORLD_DIPLOMACY | Rutinitas berbatas mandat; keputusan besar oleh pemain; intrik memiliki tanda/counterplay; kudeta tetap kandidat mekanik |
| D15/D16/D17 — world/settlement map, kendali manual/delegasi, stok lokal/logistik | Tetangga pilot usulan; multi-desa setelah ekonomi/save stabil | WORLD_DIPLOMACY, SYSTEMS_SPEC | Pergantian kendali tidak menggandakan stok; debit/transit/penerimaan transfer dapat direkonsiliasi |
| D19; DECISIONS kualitas — rantai produksi dan kualitas barang | Setelah produksi/inventori/pemulihan stabil | SYSTEMS_SPEC, ECONOMY_BALANCE | Input tiap tahap benar; kualitas berdampak dan tersimpan |
| D20 — knowledge tree + ahli NPC | Setelah progresi/karakter/fasilitas | SYSTEMS_SPEC, CHARACTER_DYNASTY | Unlock memeriksa kemajuan dan ahli; penguasaan desa dibedakan dari penemuan sejarah |
| D21/D22 — tutorial/krisis/upeti/misteri dan guidance opsional | Krisis slice; urutan berikut setelah review chapter | QUEST_EVENTS | Follow/reject/ignore tetap playable; solusi slice tidak bergantung fitur yang belum ada |
| D24 — Android landscape | Spike dini diterima secara prinsip; perangkat/jadwal O04; kapasitas O14 | ART_UX_GUIDE, TEST_PLAN, PERFORMANCE_BUDGET | Loop touch/lifecycle terbukti pada perangkat dan beban bernama |
| D25/D27 — solo Windows, spesialis logis, planning dahulu | Seluruh proses | AI_AGENT_STRATEGY, MODULE_CONTRACTS | Scope/owner/keputusan/bukti dapat ditelusuri; tanpa implementasi prematur |
| D26 — Google Play | Gate distribusi setelah definisi produk dan O13 | RELEASE_CHECKLIST | Persyaratan relevan diperiksa saat rencana rilis konkret |
| DECISIONS Premise — penyatuan Nusantara melalui beberapa strategi | Ekspansi setelah kapasitas multiwilayah/politik/logistik terbukti | MASTER_GDD, WORLD_DIPLOMACY | Tujuan penyatuan dan beberapa jalur politik dapat diuji |

Setiap review milestone memeriksa tabel ini: requirement deferred tetap memiliki sumber, gate dan acceptance intent. [ROADMAP](ROADMAP.md) mempertahankan visi lengkap tanpa mengesahkan scope pilot/MVP.

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

Urutan Android diterima secara prinsip: baseline stabil → smoke awal → loop slice di perangkat → profil kapasitas → hardening distribusi. Perangkat dan pelaksanaannya masih OPEN melalui O04. Ponsel uji awal belum otomatis menjadi spesifikasi minimum yang didukung. Catat model, chipset/GPU, RAM, OS, rasio layar dan build. Pengujian Windows tidak menggantikan Android. Gunakan pengukuran lokal yang tersedia; jangan menambah SDK tanpa persetujuan.

| Gate Android | Yang diuji ketika tersedia | Status saat revisi |
|---|---|---|
| Smoke awal setelah baseline dan perangkat siap | Install/cold start, landscape/HUD, tap, pause, suspend/resume | NOT TESTED |
| Loop touch setelah fitur slice tersedia | Placement, pan/zoom/pembatalan aksi, interaksi tokoh/quest, save/load | NOT TESTED |
| Profil sebelum konten pilot diperbesar | Beban bernama, frame time, memori, stabilitas sesi | NOT TESTED; angka target tetap PROPOSED |

Fitur belum ada ditandai NOT TESTED, bukan dibuat untuk mencentang smoke test. Angka NFR02 dan kapasitas lain memerlukan O14 serta bukti profil.

## 11. Batas arsitektur, data dan persistence

Arah yang dipertahankan: Godot 4.7.2 Standard + GDScript; model terpisah dari scene/render; definisi konten terpisah dari runtime; command tervalidasi; ID stabil; save berversi. Blueprint lama tetap kandidat TDD, bukan implementasi yang dianggap sudah ada.

Usulan ownership: session memiliki state otoritatif; placement mengubah okupansi dan biaya atomik; economy mengubah stok lewat transaksi; workforce tidak menggandakan pekerja; quest menyimpan effect ID; view/HUD hanya membaca state dan mengirim command. Command tidak bergantung listener UI untuk menghasilkan efek.

**CONFIRMED:** pause menghentikan simulasi otomatis dan tetap mengizinkan command eksplisit pemain yang valid. Pemrosesan command harus dapat bekerja saat tick berhenti. Kontrak antrean, validasi, atomicity, daftar command dan kebijakan dialog masih perlu TDD; persetujuan aturan ini bukan persetujuan seluruh arsitektur.

**CONFIRMED:** ekonomi warga biasa berbasis agregasi; tokoh penting memiliki simulasi individual. Rekomendasi kontrak: alokasi jumlah per kelompok/tempat kerja, ID individual untuk tokoh penting, dan pencegahan penghitungan ganda. ID visual/navigasi boleh dipakai tanpa menjadikan setiap sprite sumber otoritas ekonomi. Field, aturan perjalanan dan rumus kapasitas masih perlu spesifikasi.

### Kontrak waktu dan pemulihan yang belum dikunci

| Domain | Keputusan/spesifikasi yang masih diperlukan |
|---|---|
| Waktu nyata, tick dan hari ekonomi | Hubungan satuan, interval produksi/konsumsi, pembulatan, pergantian speed; 8 detik/hari hanya baseline starter |
| Kalender naratif dan umur | Hubungan tanggal/umur dengan siklus ekonomi; belum otomatis memakai hari starter; wajib sebelum dinasti |
| Deadline dan time skip | Domain deadline, warning, batas intervensi, kondisi berhenti sebelum pilihan besar |
| Pause dan command | Aturan dasarnya confirmed; daftar command, transaksi dan interaksi dialog masih perlu kontrak |
| Offline | Allowlist, cap, konsumsi, jam mundur, kondisi berhenti dan resume tepat sekali; empat jam belum keputusan |
| Pemulihan ekonomi | Cara memperoleh kayu, prasyarat, kapasitas rumah/populasi/workforce, konsumsi dan akibat kebutuhan tak terpenuhi |

Opsi pemulihan O07 tetap PROPOSED: pengumpulan berbasis workforce, bangunan produksi sederhana, atau mekanik lain. Rumah hanya kapasitas, populasi tetap, dan tanpa kematian karena lapar juga belum diputuskan. GDD membandingkan dampak scope, petak, suplai dan tenaga kerja sebelum memilih. Untuk fixture stok nol/pekerja penuh/peta penuh, tetapkan state yang valid, tindakan, waktu dan konsekuensinya; ledger harus dapat dihitung. Gap planning dapat ditutup melalui keputusan dan spesifikasi; kelulusan implementasi membutuhkan uji tersendiri.

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
| Review pra-produksi | Prinsip revisi diterima; dokumen belum APPROVED sampai pertanyaan prioritas dan persetujuan versi tercatat | O01-S/O02/O03/O04; pilot/MVP boleh tetap deferred; bukan izin implementasi |
| M0 audit dan baseline | Input/waktu/placement diuji; jika gagal, reproduksi dan bukti dicatat | A02 NOT TESTED; task card §19 belum dijalankan; keputusan salvage dan checkpoint hanya setelah bukti |
| M1 fondasi | Grid, ekonomi, kamera, save aman | GDD minimum, kontrak, SAVE_FORMAT; spike Android awal usulan |
| M2 / vertical slice | Pekerja, interaksi pejabat dan satu quest membentuk loop | M1; kriteria playtest dan perangkat |
| M3 konflik | Target arah: tetangga, diplomasi, battle dan akibat kalah | Slice diterima; scope O01-P dan GDD terkait belum disetujui |
| M4 pilot Android | Target arah: chapter, transisi sederhana, touch/performa | O01-P, budget konten/perangkat dan hasil M3; bukan approval isi pilot |
| MVP hardening | Kandidat produk dan distribusi, setelah definisi disepakati | O01-M masih OPEN; bukan otomatis pilot yang dipoles |

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

Register otoritatif status, sumber persetujuan, batas dan pertanyaan ada di [Decision Register](DECISION_REGISTER.md). Tabel berikut mempertahankan ID v1.0 sambil memperbarui status parsial. Dua aturan pause/agregasi sudah diputuskan; jangan meminta ratifikasi ulang atas aturan itu. Rincian lain tetap mengikuti gate masing-masing.

| ID | Keputusan | Rekomendasi PROPOSED | Dibutuhkan sebelum |
|---|---|---|---|
| O01 | Batas slice/pilot/MVP | PRINCIPLE_ACCEPTED satu desa; O01-S manifest rinci OPEN; O01-P pilot dan O01-M MVP tetap PROPOSED/OPEN | O01-S sebelum approval PRD; pilot/MVP keputusan terpisah |
| O02 | Audiens utama, bahasa dan tone | Bahasa Indonesia untuk prototipe, tone non-grafis; Director menetapkan rentang umur | UX/konten final dan playtest audiens |
| O03 | Kapasitas kerja dan dana | Catat jam/minggu, biaya art/audio/perangkat dan waktu tes; belum menetapkan tanggal rilis | Estimasi delivery |
| O04 | Perangkat Android dan spike dini | Arah diterima secara prinsip; model/RAM/OS/ketersediaan perangkat dan pelaksanaan masih OPEN; ponsel uji tidak otomatis perangkat minimum | Rencana perangkat sebelum approval PRD; validasi Android kelak |
| O05 | Audit, salvage/rebuild | Audit tanpa source edit; utamakan perbaikan bertahap bila biaya masuk akal | Perbaikan source |
| O06 | Kalender, pause dan command | CONFIRMED pause menghentikan otomatis dan menerima command eksplisit; kalender, pacing dan detail kontrak OPEN | GDD clock/input sebelum implementasi terkait |
| O07 | Ekonomi/workforce/pemulihan | CONFIRMED warga biasa agregat dan tokoh penting individual; mekanik pemulihan, rumus dan schema PROPOSED/OPEN | Spesifikasi ekonomi sebelum implementasi |
| O08 | Enam atribut | Ratifikasi nama baseline DECISIONS; skala dan rumus ditunda | Spesifikasi karakter |
| O09 | Save slot/autosave/backup | Usulan 1 slot manual + autosave + backup; format/rules dalam SAVE_FORMAT | Persistence |
| O10 | Offline cap dan konsumsi | Tunda dari slice; uji sesudah save stabil, tanpa perang/event besar | Offline |
| O11 | Nama/kronologi/akurasi lore | Tetap placeholder sampai source ledger dan review Director | Konten final |
| O12 | Akhir chapter, kekalahan dan suksesi | Pilot satu konsekuensi politik yang bisa dipulihkan dan satu transisi pewaris; aturan tanpa pewaris perlu diputuskan | GDD pilot |
| O13 | Monetisasi dan distribusi | Buktikan loop tanpa ads; pilih bisnis dan review kebijakan saat rilis direncanakan | Integrasi bisnis/rilis |
| O14 | Batas konten/performa pilot | Tetapkan jumlah bangunan/NPC/quest, memori/unduhan setelah spike dan sampel aset | Produksi pilot |
| O15 | Pipeline art/audio | Sample orisinal + ledger lisensi sebelum produksi massal | Pemesanan/pembuatan aset skala besar |

## 17. Status penerimaan dokumen

- PRD v1.1 adalah revisi di tempat atas v1.0; status keseluruhan **DRAFT**.
- Arah A01/A03/A04/A05/A06/A07/A08 diterima secara prinsip dengan batas pada Decision Register S11.
- Pause dengan command eksplisit, batas agregasi, dan pelestarian seluruh visi: **CONFIRMED** sesuai instruksi Director.
- Manifest rinci slice, audiens/bahasa, kapasitas/budget serta perangkat/rencana spike: masih memerlukan jawaban O01–O04.
- Scope pilot/MVP, mekanik pemulihan, balancing, kalender dan angka performa: belum otomatis disetujui.
- Audit gameplay Godot A02: **NOT TESTED**. Tidak ada klaim fixed, M0 passed atau Android lolos.
- Pekerjaan revisi ini hanya dokumentasi; kode/refactor belum diotorisasi.

### Sebelum status APPROVED

1. Director menjawab pertanyaan prioritas [O01-S/O02/O03/O04](DECISION_REGISTER.md), dengan penerimaan atau perubahan manifest yang spesifik dan rencana kapasitas/perangkat yang nyata.
2. Catat bagian pilot/MVP dan detail lanjutan yang tetap deferred, tanpa menghapus visi.
3. Director secara eksplisit menyetujui versi dan lingkup PRD. Status tidak naik otomatis karena dokumen telah ditulis.

Approval PRD, kelulusan runtime M0, dan otorisasi implementasi adalah gate terpisah. O06/O07/O09 serta kontrak yang diperlukan masih harus selesai sebelum fitur terkait dibangun; tidak perlu memutuskan seluruh sistem Nusantara sekarang.

Langkah berikut: review jawaban O01–O04, lalu audit baseline terpisah dan finalisasi GDD/TDD minimum menurut dependensi. Urutan ini mempertahankan [handoff §12–13](../Satriya_Village_Planning_Handoff_v1.md) dan batas instruksi Director terbaru.

### Catatan verifikasi penyusunan v1.0 — historis

Pemeriksaan 26 Oktober 2026: `git diff --check` tidak melaporkan masalah pada perubahan tracked; kedua dokumen baru masih untracked saat pemeriksaan. Godot headless editor dijalankan dengan `--headless --path . --editor --quit`; executable melaporkan **4.7.2.stable.official.ed1daf0bf**, exit code 0. Namun log berisi kegagalan akses direktori editor AppData/Godot, `user://`, dan penyimpanan editor settings; pemeriksaan tidak dinyatakan lulus bersih. Tidak terlihat laporan parse error GDScript pada output tersebut. Interaksi gameplay dan Android tetap belum diuji. Versi executable teramati ini melengkapi C04, tetapi tidak membuktikan baseline runtime berhasil.

Hanya `docs/GAP_ANALYSIS.md` dan `docs/PRD.md` dibuat oleh tugas ini; handoff yang sudah untracked sebelumnya dipertahankan. Tidak ada perubahan source gameplay, scene, konfigurasi, DECISIONS, atau ROADMAP. Dokumen tersimpan sebagai checkpoint draft lokal; belum dibuat commit milestone karena belum ada penerimaan scope atau milestone gameplay teruji.

Catatan di atas merekam tugas v1.0, bukan status Git atau hasil verifikasi v1.1. Hasil revisi terbaru dicatat dalam [Task Log](TASK_LOG.md).

## 18. Riwayat revisi dan tindak lanjut audit

| Versi / tanggal | Dasar | Perubahan dan batas |
|---|---|---|
| v1.0 / 26 Oktober 2026 | Handoff + DECISIONS + paket planning | Draft awal; baseline lengkap tersedia dalam riwayat Git `ef512596:docs/PRD.md` dan `86cfe43:docs/PRD.md` |
| Proposal v1.1 / 26 Oktober 2026 | Audit independen dan review di chat | Rekomendasi read-only; belum mengubah dokumen atau memberi approval |
| v1.1 / 26 Oktober 2026 | Persetujuan prinsip Director dengan enam ketentuan, dicatat sebagai S11 | Revisi pada berkas PRD yang sama; ID dan §1–17 dipertahankan; tambah register, traceability, gate approval dan task card; tetap DRAFT |

| Audit / sumber gap | Tindak lanjut v1.1 | Yang belum selesai |
|---|---|---|
| A01 / C06–C08, G01–G03 | §4/§16/§17, O01 dipisahkan slice/pilot/MVP | Jawaban O01–O04 dan approval versi |
| A03 / C09–C10, G05 | FR03/§11 dan register: pause confirmed, kontrak waktu dipetakan | Kalender, pacing, deadline/skip/offline dan spesifikasi |
| A04 / C13 | FR07/§11 serta blueprint: batas agregasi confirmed | Schema, rumus workforce dan aturan perjalanan |
| A05 / G06 | FR05/§11: opsi, fixture dan pemulihan tetap usulan | Pilihan mekanik/balancing dan expected fixture |
| A06 / C01–C02, G16 | Decision Register dengan sumber S11/status/batas | Konflik nama O08/O11 serta keputusan yang belum dijawab |
| A07 | §7 + ROADMAP melacak seluruh visi | Gate/desain rinci dan acceptance implementasi kelak |
| A08 / C08, G11–G12 | §10: arah Android dini, gate dan kebutuhan perangkat | O04/O14 dan hasil pengujian perangkat |
| A02 / C03, G04 | §19 menyiapkan audit read-only | NOT TESTED sampai bukti runtime |

## 19. Task card A02 — audit runtime read-only

**ID:** AUDIT-M0-01. **Status:** NOT TESTED; task card belum dijalankan. **Tujuan:** membuktikan perilaku starter dan mereproduksi kegagalan. **Batas:** tidak mengubah source, scene, konfigurasi, aset atau gameplay; tidak refactor/fix dalam audit.

Catat commit/working tree dan versi Godot aktual saat eksekusi. Audit independen memakai `ef512596`; saat revisi dimulai HEAD `86cfe43`, dengan source gameplay/scene/config yang sama menurut diff. Ini perbandingan source, bukan bukti F5. Untuk menjaga repository sumber read-only, jalankan salinan kerja terpisah dan simpan laporan/log/video di luar repository sumber. Catat side effect cache/editor. Kelanjutan tugas membutuhkan instruksi audit tersendiri.

Baseline source: kayu 120, pangan 60, uang 150, warga 8, hari 1, speed 1×, pilihan Sawah; Rumah (4,4), Sawah (3,4)/(4,5). Gunakan sesi baru untuk kasus independen. Pause segera; jika waktu sudah maju, catat snapshot aktual atau mulai ulang.

| Kasus | Expected dari source saat ini | Actual |
|---|---|---|
| F5 | Scene/grid/HUD muncul; catat error dan kontrol yang dapat dijangkau | NOT TESTED |
| Selector/HUD | Pilihan berubah, klik tombol/panel tidak menyebabkan debit/placement | NOT TESTED |
| Rumah valid | Kayu 120→90, warga 8→10, bangunan 3→4 | NOT TESTED |
| Sawah valid, sesi terpisah | Kayu 120→100, warga tetap, bangunan 3→4 | NOT TESTED |
| Lumbung valid, sesi terpisah | Kayu 120→75, warga tetap, bangunan 3→4; belum ada efek kapasitas | NOT TESTED |
| Petak terisi / luar peta | Tidak ada debit/bangunan tambahan; pesan terisi untuk petak terisi | NOT TESTED |
| Kayu kurang | Enam Sawah memakai 120 kayu; Rumah berikutnya ditolak tanpa perubahan state | NOT TESTED |
| Pause ≥10 detik | Hari/pangan/uang tetap; NPC dekoratif boleh beranimasi | NOT TESTED |
| Speed 1×/2×/3× | Antarpergantian hari sekitar 8/4/2,67 detik | NOT TESTED |
| Ledger peta awal | Tiap pergantian hari pangan +7, uang +2; kayu/warga tetap | NOT TESTED |
| Pause/resume | Durasi pause tidak menambah hari; sisa interval sebelumnya dipertahankan | NOT TESTED |

Ukur antarpergantian hari agar sisa interval saat klik speed tidak mengacaukan expected. Rumah +2 warga dan konsumsi tetap 3/hari adalah baseline starter, bukan balancing yang disahkan. Expected diperiksa ulang jika source berubah sebelum audit.

Evidence wajib: commit/status sebelum-sesudah; engine/OS/display scaling/viewport/metode launch; screenshot/video F5 dan input; HUD before/after serta cell/posisi klik; log lengkap terutama error pertama; waktu transisi hari; PASS/FAIL/NOT TESTED tiap kasus; reproduksi ulang kegagalan; gejala vs dugaan vs sebab terbukti; daftar yang belum diuji. Jika F5 gagal, kasus interaksi NOT TESTED. Parser saja tidak meluluskan M0. Output audit adalah laporan dan task fix terkecil yang direkomendasikan, bukan klaim issue fixed.
