# Satriya Village — Master Planning v0.1

Tanggal: 26 Oktober 2026. Bahasa kerja: Indonesia. Status: **proposal pra-produksi**, bukan persetujuan implementasi.

Catatan editorial S12: dokumen ini menyimpan proposal awal. Status terkini ada di [PRD](PRD.md)/[Decision Register](DECISION_REGISTER.md); reviewer CONDITIONAL PASS menjadi baseline provisional, bukan approval scope/angka. Spesifikasi slice kini tersedia sebagai draft [Master GDD](MASTER_GDD.md), [TDD](TDD.md), [SAVE_FORMAT](SAVE_FORMAT.md), [Execution Plan](AI_AGENT_EXECUTION_PLAN.md), [Quality Gates](QUALITY_GATES.md) dan [M0 Audit Plan](M0_AUDIT_PLAN.md). A02 NOT TESTED; pilot/MVP belum disetujui. Data jam/budget/perangkat TBD tidak menghentikan dokumentasi.

## 1. Mandat dan hierarki keputusan

Dokumen ini menyintesis Master Project Brief — Pre-Production v0.1 yang diberikan pemilik. Tujuan pekerjaan sekarang adalah menyusun rencana, bukan membuat gameplay. `AGENTS.md` dan [DECISIONS.md](DECISIONS.md) tetap menjadi batas kerja; [ROADMAP.md](ROADMAP.md) tetap roadmap yang berlaku. Perubahan lingkup, arsitektur besar, dan gameplay di bawah ini memerlukan keputusan Game Director sebelum dikerjakan.

Urutan baca paket: dokumen ini → [ARCHITECTURE_BLUEPRINT.md](ARCHITECTURE_BLUEPRINT.md) → [AI_AGENT_STRATEGY.md](AI_AGENT_STRATEGY.md) → [EXECUTION_BLUEPRINT.md](EXECUTION_BLUEPRINT.md). Arsitektur starter yang benar-benar ada tercatat dalam [ARCHITECTURE.md](ARCHITECTURE.md).

Label yang digunakan: **disepakati** untuk visi dalam DECISIONS; **usulan** untuk batas, angka, dan solusi baru; **teramati di kode** untuk hasil inspeksi; **tervalidasi** hanya jika ada hasil uji. Persetujuan visi tidak sama dengan komitmen rilis.

## 2. Inti pengalaman dan kelayakan

Pemain menjadi kepala desa fiksi kawasan Malang (Tirta Wening masih nama usulan), memahami kebutuhan warga, membangun ekonomi, memilih respons terhadap tekanan sosial, lalu melihat akibatnya. Identitas slice meliputi desa isometrik terbaca, karakter pemain visual/interaksi sederhana, pejabat bernama, kebutuhan pangan jelas dan pilihan dengan akibat terlihat. Nuansa Nusantara hadir melalui lingkungan dan cerita orisinal yang diteliti.

Core loop usulan: amati persediaan/kebutuhan → tentukan prioritas → bangun dan alokasikan pekerja → jalankan waktu → lihat hasil produksi dan konsumsi → berbicara dengan tokoh/menjawab event → sesuaikan rencana. Loop pilot memperluasnya dengan hubungan antardesa, risiko konflik, dan pewarisan kepemimpinan.

Visi akhir setara banyak proyek besar sekaligus. Untuk pemula solo, risiko terberat adalah ledakan interaksi antarsistem dan kebutuhan konten, bukan kecepatan menulis kode. Gunakan satu milestone aktif; satu fitur baru per tugas; ukur kapasitas melalui dua siklus audit/perbaikan sebelum menetapkan estimasi kalender. Tidak ada janji tanggal rilis atau jumlah bulan pada tahap ini.

## 3. Baseline dan review kritis

Inspeksi awal menemukan satu scene dan `scripts/main.gd` yang mencampur input, gambar, HUD, waktu, dan ekonomi. Kode berisi grid 10×10, tiga jenis bangunan, biaya kayu, pergantian hari, serta karakter dekoratif. Keberadaan kode tidak membuktikan interaksi bekerja. Laporan pemilik bahwa mekanik tidak berfungsi tetap menjadi masalah terbuka; paket 0.1.1 belum terkonfirmasi. Audit runtime mendahului refactor.

| Konflik / risiko desain | Rekomendasi usulan | Keputusan atau bukti yang dibutuhkan |
|---|---|---|
| Roadmap M0 terlihat sebagai first boot, tetapi mekanik dilaporkan gagal | Perlakukan M0 sebagai gate yang dibuka kembali, bukan selesai | Reproduksi F5, input UI dan peta, log dan hasil aktual |
| Brief menempatkan NPC, pejabat, cerita, Android dalam slice; repo menempatkannya lintas M1–M4 | Definisikan slice sebagai hasil lintas milestone, tanpa mengganti urutan roadmap diam-diam | Persetujuan batas slice dan build Android awal |
| Pilot kompleks dan MVP belum dibedakan | Pilot adalah validasi campaign; MVP adalah kandidat produk minimum sesudah pilot | Pilih kelengkapan chapter dan gate produk |
| Dinasti memerlukan rentang tahun, tetapi starter memakai 8 detik/hari | Pisahkan tick ekonomi, kalender naratif, dan lompatan chapter | Uji pacing; jangan turunkan usia dari 8 detik/hari secara otomatis |
| Kebebasan sandbox versus cerita wajib | Quest memberi arahan; event punya batas dan akibat yang jelas, tidak memaksa satu solusi | Uji jalur mengikuti, menolak, dan mengabaikan event |
| Offline consumption dapat menghukum pemain | Batasi progres dan tampilkan ringkasan; usulan tahan simulasi saat pangan habis atau keputusan muncul | Persetujuan aturan kelaparan dan offline sebelum implementasi |
| Rumah langsung menambah penduduk; konsumsi tetap 3 dalam starter | Pertahankan sebagai baseline audit; nanti pisahkan kapasitas rumah, penduduk, kebutuhan | Ekonomi baru harus disetujui dan punya skenario uji |
| Kayu terbatas tanpa sumber pemulihan | Slice membutuhkan jalur pemulihan sumber pembangunan | Pilih produksi kayu sederhana atau mekanik pemulihan lain |
| Kedalaman strategi versus audiens muda | Ajarkan satu keputusan per tahap, tampilkan sebab-akibat; kekerasan non-grafis | Playtest pemahaman dan kajian tone |
| Sejarah, naskah sastra, dan fantasi tercampur | Setiap klaim diberi kategori sumber dan tingkat kepastian | Riset sebelum mengunci tokoh, tanggal, jabatan, arsitektur |
| Pengepungan dan konsekuensi berat terlalu dini | Buktikan combat lapangan dahulu; siege tetap dalam roadmap lanjutan | Persetujuan penundaan, bukan penghapusan visi |
| Monetisasi dapat merusak pacing dan menambah beban rilis | Validasi loop tanpa iklan; keputusan monetisasi terpisah | Persetujuan pemilik dan verifikasi kebijakan saat relevan |

## 4. Lapisan scope dan prioritas

Semua batas kuantitatif berikut adalah usulan, bukan janji konten.

| Lapisan | Hasil minimum | Batas tegas | Gate keluar |
|---|---|---|---|
| A — Technical prototype, M0–M1 | Satu desa; placement; clock; inventori; produksi/konsumsi; save/load versi pertama | Placeholder; tanpa AI politik atau perang | Operasi valid/invalid teruji, pause konsisten, round-trip save benar |
| B — Vertical slice, M1–M2 + spike Android | Sesi 10–15 menit; rumah/sawah/lumbung dan jalur kayu; pekerja ringan; satu pejabat; satu quest bercabang; contoh pixel art | Satu desa, satu konflik pangan, tanpa world map penuh/dinasti hidup | Pemain menyelesaikan loop tanpa bantuan pengembang, dua hasil quest dapat dicapai, build perangkat bisa dimainkan |
| C — Playable pilot, M3–M4 | Satu chapter Tumapel dapat ditamatkan; desa utama dan satu tetangga; diplomasi terbatas; battle lapangan; konsekuensi kalah; satu demonstrasi suksesi | Tidak seluruh Jawa Timur; tanpa simulasi 30+ sistem; siege mendalam ditunda | Chapter dan alternatifnya dapat diselesaikan, kalah tidak otomatis memutus permainan, state tetap valid setelah load |
| MVP — kandidat rilis | Pilot yang lolos usability, tutorial, save recovery, touch, performa, konten, dan gate distribusi | Tanpa kewajiban iklan; bukan seluruh visi final | Game Director menyetujui kualitas dan daftar batas produk; kandidat Android terverifikasi |
| Visi lanjutan | Nusantara, banyak settlement, dinasti mendalam, intrik, intelijen, logistik, penelitian, kualitas barang, siege | Tidak masuk backlog aktif sebelum fondasi relevan stabil | Setiap perluasan mempunyai eksperimen, anggaran konten dan gate sendiri |

Prioritas Must: loop desa, interaksi tokoh, satu pilihan, save yang aman, touch yang terbaca. Should setelah stabil: contoh art final, bantuan kontekstual, balancing lanjutan. Could: variasi dekorasi dan quest sampingan. Won't pada slice: perang, suksesi, jaringan, iklan, ekonomi harga dinamis. Penundaan mempertahankan seluruh visi mendalam di katalog sistem.

## 5. Katalog sistem dan dependensi desain

| Sistem | Minimum yang direncanakan | Pengembangan berikutnya / dependensi |
|---|---|---|
| Building dan ekonomi | Grid, biaya atomik, stok lokal, produksi berbasis pekerja, kebutuhan pangan | Kapasitas, rantai padi→beras, pasar, upah/pajak, kualitas; membutuhkan balancing dan inventori |
| NPC dan workforce | Pekerja otomatis mengisi lowongan dengan aturan stabil; pemain mengatur prioritas | Keterampilan, rutinitas, kebutuhan; named NPC individual, kekayaan dan ambisi |
| Karakter | Satu tokoh dapat diajak bicara dan satu jabatan manual; enam atribut tetap dalam desain | Skala 1–100 belum final; trait berubah hanya karena event; relasi dan dinasti sesudah kalender |
| Pemerintahan | Satu pejabat dengan tugas dan batas anggaran yang terlihat | Jabatan tambahan, korupsi, pemberontakan, investigasi setelah authority dan event audit stabil |
| Narasi dan progresi | Krisis panen → solusi lokal → dampak terlihat | Upeti → Panawijen → politik → konflik sebagai outline usulan, bukan fakta sejarah |
| Quest dan living history | State inactive/active/resolved, prasyarat, pilihan, efek sekali | Rumor→tension→warning→intervention→resolution; resolusi AI hanya saat permainan aktif |
| Dinasti | Pilot: satu transisi pemimpin dengan pewaris yang diketahui | Pernikahan, anak, usia, intrik waris; membutuhkan relasi, save, kalender dan aturan tanpa pewaris |
| World map dan logistik | Pilot: ringkasan satu tetangga dan relasi | Stok per desa, karavan, rute, keamanan; settlement jauh menjalankan data saja |
| Combat | Pilot: battle lapangan, attack/defend/retreat dan pause-command | Formasi, target, kelas tombak/pedang/perisai/pemanah/kavaleri, aura/skill, siege memakai inti sama |
| Konsekuensi kalah | Retreat dan satu perubahan politik yang dapat dipahami | Tawanan, kerusakan, kehilangan wilayah, pengasingan dan kembali; butuh persistence lintas peta |
| Riset dan produksi lanjut | Dicatat sebagai visi; belum dibangun | Technology tree + guru/ahli/bahan/fasilitas, pewarisan ilmu, barang berkualitas dan pusaka |
| Fantasi dan spiritualitas | Satu motif fiksi ramah remaja bila sesuai quest | Ritual, berkah dan Lima Penjaga Bhumi harus berlabel lore orisinal |

Balancing dimulai dari ledger: stok akhir = stok awal + produksi + impor − konsumsi − biaya − ekspor. Catat surplus pangan, waktu pemulihan kekurangan, waktu keputusan pertama, dan kemampuan kembali membangun setelah salah pilih. Angka starter bukan desain final. Uji tanpa pekerja, stok nol, prioritas berubah, dan pilihan terburuk; hindari jalan buntu tanpa peringatan atau pemulihan.

## 6. Rencana dokumentasi berurutan

Tabel berikut adalah urutan rencana awal, bukan inventaris status terkini. GDD/TDD/save/execution/gates/audit plan kini tersedia sebagai draft melalui tautan di awal; modul kontrak/data minimum berada di TDD, ekonomi/quest awal di GDD. Lihat [Document Index](DOCUMENT_INDEX.md) untuk berkas yang benar-benar ada. Laporan runtime, riset lore, balancing final dan release checks belum tersedia. Dokumen provisional boleh disusun sambil data TBD ditunggu; fitur baru tetap menunggu audit dan kontrak siap.

| Urutan / dokumen rencana | Isi dan keluaran | Bergantung pada / penanggung jawab |
|---|---|---|
| 0. Paket fondasi saat ini | Master Planning, Architecture Blueprint, AI Agent Strategy, Execution Blueprint | Brief + repository / Lead |
| 1. AUDIT_REPORT.md | Reproduksi bug, baseline, bukti uji, prioritas perbaikan | Audit M0 / QA + Lead |
| 2. MASTER_GDD.md | Pilar, core loop, scope A/B/C/MVP, progression, UX dan non-goals | Keputusan scope + audit / Director + Lead |
| 3. LORE_BIBLE.md | Source ledger, fakta vs tradisi vs fiksi, tokoh, lokasi, tone, glosarium | GDD; riset sumber primer dan kajian / Narrative |
| 4. SYSTEMS_SPEC.md dan ECONOMY_BALANCE.md | Aturan placement, kebutuhan, tenaga kerja, ledger dan tabel parameter | GDD + audit / World + Simulation |
| 5. TDD.md dan MODULE_CONTRACTS.md | Struktur Godot, node, state ownership, commands/events, invariants | Spesifikasi minimum / Lead |
| 6. DATA_SCHEMAS.md dan SAVE_FORMAT.md | ID, definisi/runtime, format version, validasi, migrasi, recovery | Kontrak; wajib selesai sebelum persistence / Lead |
| 7. TEST_PLAN.md dan PERFORMANCE_BUDGET.md | Matriks uji, fixture, target perangkat dan profiling | TDD + baseline / QA |
| 8. CHARACTER_DYNASTY.md dan QUEST_EVENTS.md | AI, trait, enam atribut, suksesi, graph quest dan efek | Lore + clock + schema + GDD / Character + Narrative |
| 9. ART_UX_GUIDE.md | Pixel scale, sprite origin, occlusion, atlas, font, touch dan safe area | GDD + spike perangkat / UI |
| 10. WORLD_DIPLOMACY.md dan COMBAT_DESIGN.md | Relasi, world state, battle core, hasil kalah dan kontrak siege masa depan | Slice lolos, keputusan pilot / Narrative + Combat |
| 11. RELEASE_CHECKLIST.md | Build, signing, backup, device tests, rating, kebijakan terkini, keputusan monetisasi | Pilot teruji / QA + Director |

Setiap dokumen mempunyai status draft/approved/superseded, pemilik, dependensi, keputusan terbuka, acceptance criteria, dan revisi. Perubahan keputusan disimpan sebagai catatan keputusan setelah persetujuan; jangan mengubah DECISIONS berdasarkan rekomendasi agent saja.

## 7. Risk register dan keputusan berikutnya

| Risiko | Tingkat | Pemilik | Mitigasi / indikator pemicu |
|---|---|---|---|
| Scope tumbuh sebelum loop terbukti | Tinggi | Director | Bekukan milestone; fitur baru menukar scope atau masuk backlog |
| Refactor menyembunyikan bug awal | Tinggi | Lead | Reproduksi dahulu; patch sempit; pembanding sebelum/sesudah |
| Save rusak / efek quest ganda | Tinggi | Lead | Versioning, validasi, backup, effect ID dan uji round-trip |
| Simulasi tidak konsisten pada speed/offline | Tinggi | Simulation | Tick tetap, urutan stabil, batas offline, uji state setara |
| Narasi dianggap sejarah pasti | Tinggi | Narrative | Ledger sumber dan label fiksi; blok konten belum diteliti |
| UI sempit / panas pada Android | Tinggi | UI + QA | Spike perangkat lebih awal; ukur frame time dan suhu sesi |
| Beban aset dan dialog berlebihan | Tinggi | Director | Satu set art contoh dan satu chapter sebelum ekspansi |
| Integrasi agent saling menimpa | Sedang | Lead | Satu pemilik file, kontrak, perubahan kecil dan review |
| Kebijakan rilis berubah | Sedang | QA | Verifikasi sumber resmi menjelang distribusi; SDK tidak otomatis ditambah |

Keputusan yang perlu diratifikasi setelah membaca paket: batas slice/pilot/MVP di atas; spike Android sebelum M4; kalender naratif terpisah; aturan pemulihan ekonomi; batas offline; demonstrasi suksesi sederhana. Tidak ada keputusan tersebut yang otomatis diterapkan oleh paket ini.
