# SATRIYA VILLAGE — PLANNING HANDOFF v1.0
**Status:** Dokumen sintesis brainstorming; bukan PRD/GDD final.  
**Tanggal:** 26 Oktober 2026  
**Tujuan:** Memberi GPT Astra konteks desain yang memadai untuk menyusun PRD, GDD, TDD, roadmap, dan organisasi AI agents **sebelum coding**.

> **Aturan interpretasi:** `CONFIRMED` = pilihan eksplisit pengguna yang terlihat dalam percakapan; `PROPOSED` = rincian yang diajukan asisten, belum seluruhnya dikunci; `VERIFY` = perlu konfirmasi/riset. Penomoran keputusan sebelumnya tidak selalu konsisten; jangan menganggap semua rincian contoh sudah final.

## 1. Visi dan identitas
**Satriya Village** adalah game single-player Android landscape, strategi simulasi desa/kerajaan berlatar Nusantara dengan pixel art isometrik lucu/chibi. Inspirasi visual: *Ninja Village* (Kairosoft). Inspirasi mekanik: *Norland*, dengan kompleksitas antarmuka dan beban micromanagement dipangkas agar ramah anak/remaja. Jangan menyalin aset, kode, UI, maupun konten spesifik game referensi.

**Fantasi pemain:** bermula sebagai kepala desa kecil di kawasan Malang/Tumapel, mengembangkan ekonomi dan masyarakat, membangun dinasti, berpolitik, berdiplomasi, berperang, hingga berpeluang menyatukan Nusantara. Pemain boleh menjadi pengikut kerajaan atau mendirikan kerajaan sendiri. Ada sejarah dan jalur alternatif; unsur mistis Nusantara bernuansa lucu, bukan horor dominan.

**Pilar:** (1) desa hidup dan ekonomi saling terkait; (2) karakter penting punya kepribadian dan agenda; (3) kebebasan sandbox dengan quest penuntun; (4) politik/ekspansi dengan konsekuensi; (5) cerita sejarah-alternatif yang responsif; (6) keterbacaan mobile.

## 2. Setting dan lore
- **CONFIRMED:** Pilot di Jawa Timur, khususnya kawasan Malang, berpusat pada era kisah Ken Dedes dan Tumapel; ekspansi Nusantara adalah tujuan jangka panjang.
- **CONFIRMED:** Hybrid history: jalur sejarah dan alternatif yang dapat dibuka; dunia bergerak selama simulasi aktif dan pemain diberi kesempatan intervensi sebelum peristiwa besar.
- **PROPOSED:** Campaign `Babad Tanah Tumapel`, desa awal fiksi `Tirta Wening`, tahun sekitar 1219–1222 M, serta babak krisis panen → utusan upeti Tumapel → misteri sendang/Panawijen → konflik politik dan militer.
- **PROPOSED:** Ken Dedes, Ken Arok, Tunggul Ametung, Mpu Purwa, Kertajaya sebagai tokoh/rujukan naratif; legenda dan pusaka bertuah sebagai lapisan fantasi.
- **VERIFY:** Kronologi, tokoh, struktur pemerintahan, arsitektur, teknologi, dan geografis melalui sumber sejarah tepercaya. Bedakan prasasti, tafsir akademik, sastra seperti *Pararaton*, dan fiksi game. Jangan menganggap diagram wilayah sebagai peta historis.

## 3. Register keputusan eksplisit yang tersedia
| ID tematik | Status | Keputusan |
|---|---|---|
| D01 | CONFIRMED | Awal pemain kepala desa kecil |
| D02 | CONFIRMED | Campuran sejarah, fiksi, mistis yang lucu |
| D03 | CONFIRMED | Jalur sejarah asli + alternatif |
| D04 | CONFIRMED | Bisa menjadi pengikut kerajaan atau mendirikan kerajaan sendiri |
| D05 | CONFIRMED | Single-player dahulu, lore panjang |
| D06 | CONFIRMED | Waktu berjalan dan bisa dimanfaatkan untuk monetisasi iklan opsional |
| D07 | CONFIRMED | Offline progress terbatas; perang dan event penting berhenti |
| D08 | CONFIRMED | NPC biasa bekerja otomatis; pemain mengatur prioritas dan tokoh penting |
| D09 | CONFIRMED | Hybrid tactical battle: unit otomatis, pemain memberi perintah, formasi, skill senapati |
| D10 | CONFIRMED | Battlefield khusus perang terbuka; pengepungan di peta desa |
| D11 | CONFIRMED | Kekalahan berat, termasuk kehilangan kekuasaan |
| D12 | CONFIRMED | Pemain membuat karakter dan dinasti sendiri dalam dunia sejarah |
| D13 | CONFIRMED | Enam atribut karakter (jumlah enam eksplisit; nama atribut usulan) |
| D14 | CONFIRMED | Pejabat profesi termasuk urusan pertanian; tugas rutin otomatis, keputusan besar disetujui pemain |
| D15 | CONFIRMED | Hybrid world map + settlement map |
| D16 | CONFIRMED | Semua desa bisa dibangun manual atau didelegasikan |
| D17 | CONFIRMED | Hybrid logistics: stok tiap desa; transfer otomatis berdasar kebijakan |
| D18 | CONFIRMED | Hybrid economy: rakyat biasa berbasis kelompok, tokoh penting individual |
| D19 | CONFIRMED | Advanced production chains sebagai visi jangka panjang |
| D20 | CONFIRMED | Hybrid research: tech tree + keahlian/pengetahuan NPC |
| D21 | CONFIRMED | Progres tutorial, krisis, upeti, misteri bertahap |
| D22 | CONFIRMED | Sandbox bebas, misi sebagai panduan opsional |
| D23 | CONFIRMED | Hybrid living history; peristiwa besar tetap terjadi jika diabaikan setelah kesempatan intervensi |
| D24 | CONFIRMED | Landscape mobile |
| D25 | CONFIRMED | Solo developer Windows dengan Codex, Git, Godot, bantuan AI agents spesialis |
| D26 | CONFIRMED | Target rilis Google Play Store |
| D27 | CONFIRMED | Pengguna ingin dokumen planning dahulu, kemudian eksekusi |

**Catatan integritas:** Dalam percakapan sebelumnya ada beberapa jawaban pengguna berupa huruf `B`/`C` tanpa pertanyaan lengkap yang terlihat pada ringkasan. Jangan mengarang arti pilihan itu. Daftar ini tidak mengklaim merekonstruksi setiap satu dari “32 keputusan” secara verbatim. Verifikasi rincian yang belum eksplisit.

## 4. Sistem permainan — spesifikasi arah
### 4.1 Desa dan pembangunan
Grid isometrik; rumah, sawah, lumbung, pasar, bengkel, barak, bangunan pemerintahan. Pemain dapat mengunjungi tiap desa, membangun manual, atau menunjuk kepala desa/pejabat untuk menjalankan kebijakan. **Engineering proposal:** desa aktif memiliki visual NPC rinci; desa nonaktif dihitung dengan agregasi data.

### 4.2 Penduduk dan tokoh penting
NPC biasa bekerja semi-otomatis, dipengaruhi profesi, prioritas pekerjaan, dan kebutuhan. Tokoh bernama memiliki atribut, trait, hubungan, kekayaan, jabatan, loyalitas, dan ambisi. **PROPOSED enam atribut:** Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality. **PROPOSED:** dinasti, pernikahan, anak, pewaris, kematian, pergantian generasi; detail reproduksi/usia/balancing belum final.

### 4.3 Pemerintahan dan intrik
Jabatan contoh: Patih, Juru Tani, Bendahara, Juru Niaga, Senapati, kepala intelijen. Pejabat boleh mengurus rutinitas dalam mandat/anggaran; pajak, perang, kebijakan besar dan pembangunan besar harus disetujui pemain. Korupsi, pembelotan, kudeta dan konflik loyalitas adalah kandidat gameplay lanjutan; harus ada tanda, sebab, dan counterplay yang jelas.

### 4.4 Ekonomi dan produksi
Ekonomi hybrid: penduduk biasa disimulasikan per kelompok profesi/kesejahteraan; karakter penting memiliki aset dan transaksi lebih rinci. Pasar, harga, pajak, pangan, produksi, konsumsi, distribusi dan kelangkaan saling memengaruhi.
**Visi advanced crafting:** padi → beras; bijih → logam → senjata; kapas → benang → kain; kualitas produk, pengrajin, bahan langka, kerajinan/pusaka. Ini visi jangka panjang, **bukan seluruhnya P0**.

### 4.5 Logistik
Stok sumber daya terpisah per desa. Pemain menentukan kebijakan/target pasokan, sistem otomatis menjadwalkan pengiriman. Jarak, kapasitas, rute, risiko perang memengaruhi distribusi. Visual karavan tidak harus berarti simulasi objek individual di seluruh peta.

### 4.6 Pengetahuan
Hybrid research: pohon kemajuan kerajaan + tokoh ahli, guru/murid, fasilitas, bahan, atau penemuan. Pengetahuan tertentu dapat diwariskan. Jangan mengklaim “teknologi baru ditemukan” jika secara historis sudah ada; ini bisa berarti desa pemain baru menguasainya.

### 4.7 Perang
Pasukan infanteri dan kelas lain (contoh usulan: tombak, pedang/perisai, pemanah, kavaleri). Gerak/serangan dasar otomatis, pemain memberi perintah target, formasi, retreat, dan mengaktifkan skill senapati. Perang terbuka memakai arena khusus; pengepungan terjadi di settlement. Kekalahan bisa mengubah politik, merusak desa, menawan pemimpin, atau mencabut kekuasaan; bukan selalu game over.

### 4.8 Diplomasi, wilayah, intelijen
Peta politik dan peta settlement terhubung. Hubungan faksi, aliansi, upeti, perdagangan, penaklukan, status vasal/merdeka. Intelijen, sabotase logistik, dan kontraintelijen adalah kandidat fitur bertahap. AI faksi perlu agenda dan state yang bisa diinspeksi/debug.

### 4.9 Waktu dan offline
Pause, percepatan simulasi (contoh UI 1×/2×/3×, belum ditetapkan balancing final). Saat aplikasi ditutup, hanya produksi/konsumsi/pembangunan rutin aman yang boleh memperoleh progres terbatas. Perang, kudeta, event sejarah penting dan keputusan bercabang tidak maju. Monetisasi rewarded ads **opsional** dan tidak memblokir cerita; perlu tinjauan kebijakan anak, iklan, privasi dan Play Store.

### 4.10 Quest, tutorial, living history
Quest tutorial, cerita, dan dinamis sebagai *guidance*, bukan pagar untuk sandbox. Banyak solusi untuk satu masalah (krisis pangan: produksi, perdagangan, bantuan diplomatik, logistik). Peristiwa besar memiliki fase rumor → eskalasi → pemberitahuan/intervensi → resolusi AI/pemain → konsekuensi permanen. Jangan memproses peristiwa penting saat offline atau melompati pilihan saat time skip.

## 5. UX dan seni
Landscape, pixel art 2D isometrik chibi, lingkungan desa Jawa tropis yang hidup, bangunan/sawah/pasar/sumber air dan elemen mistis ramah remaja. **PROPOSED** reference design resolution 1280×720. UI harus responsif untuk layar Android, touch target memadai, tooltips jelas, kontrol kamera geser/zoom, keterbacaan saat banyak unit, opsi aksesibilitas. Buat aset orisinal, bukan menyalin Ninja Village.

## 6. Platform, proses dan status aktual
- **CONFIRMED:** Windows; Git dan Codex terpasang; Godot berhasil membuka prototype awal dan menampilkan visual sederhana.
- **CONFIRMED:** Pengguna melaporkan seluruh mekanik prototype 0.1 tidak bekerja.
- **UNVERIFIED:** paket revisi 0.1.1 pernah ditawarkan tetapi tidak ada konfirmasi berhasil. Jangan jadikan basis kode ini sebagai arsitektur yang sudah stabil.
- **PROPOSED stack:** Godot 4.x Standard + GDScript, Git, Codex; versi Godot yang terpasang perlu diverifikasi di perangkat.
- **FIRST TECHNICAL TASK:** audit proyek aktual dan error; tentukan apakah diperbaiki atau dibuat fondasi bersih berdasarkan biaya/risiko. Jangan mulai dengan visual polish.

## 7. Prioritas scope yang disarankan untuk dinilai Astra
| Fase | Outcome yang dapat diuji | Catatan |
|---|---|---|
| P0 Technical foundation | Proyek Godot valid, input, grid, build placement, waktu, sumber daya, save/load, tests | Harus berjalan pada Windows |
| P1 Vertical slice | 1 desa, NPC kerja dasar, pangan/ekonomi, 1 pejabat, quest krisis panen + upeti kecil, visual sampel, Android test build | Satu gameplay loop lengkap |
| P2 Pilot Tumapel | Beberapa settlement, world map, delegasi, logistik, diplomasi dasar, konflik/tactical battle sederhana, cerita bercabang | Perlu budget waktu realistis |
| P3 Expansion | Dinasti kompleks, intrik, intelijen, crafting mendalam, pengepungan penuh, skala Nusantara | Modular, bukan janji rilis awal |

Ini **rekomendasi prioritas**, bukan keputusan final pengguna; Astra harus menilai risiko dan mengusulkan batas scope yang dapat selesai.

## 8. Peta ketergantungan sistem
```text
Simulation Clock
  ├─ Production / Consumption ─ Market / Welfare ─ Politics / Unrest
  ├─ NPC Jobs ─ Building Capacity ─ Economy
  ├─ Character Traits / Relationships ─ Officials ─ Diplomacy / Intrigue
  └─ Event Scheduler ─ Quest / Historical Branches
Settlement Data ─ Building Grid ─ Local Siege
Settlement Data ─ Territory Graph ─ Logistics / Trade / World Map
Faction & Character Data ─ Diplomacy ─ War ─ Territorial Consequences
Research + Experts ─ Crafting / Building Unlocks / Equipment
Save/Load + Versioning spans ALL systems
```
**Arsitektur wajib:** pisahkan data model dari rendering; simulasi deterministic sejauh praktis; data-driven event/quest; event bus terkontrol; IDs stabil untuk NPC/desa/faksi; schema save berversi; simulation LOD untuk settlement tak aktif; headless tests dan profiling Android.

## 9. Organisasi AI agents yang diminta
**Human Game Director:** visi, approval, tes manual, keputusan scope.  
**Lead Architect / Integrator:** API, ownership, review, backlog, merge.  
**World/Settlement:** grid, peta, bangunan, navigasi.  
**Simulation/Economy:** clock, pekerjaan, produksi, pasar, logistik.  
**Character/AI:** perilaku, atribut, hubungan, dinasti.  
**Narrative/Politics:** quest, sejarah bercabang, faksi, pejabat.  
**Combat:** pasukan, taktik, formasi, pengepungan.  
**UI/Art Pipeline:** HUD, touch UX, tileset, sprite pipeline.  
**QA/Release:** tes, profil performa, Android build, Play Store.

**Aturan:** jangan mengaktifkan semua sekaligus; agent punya ownership file/modul; tugas kecil dengan acceptance criteria; branch/worktree bila paralel; tidak boleh menambah dependency tanpa approval; setiap perubahan harus diuji; Git checkpoint sebelum merge; dokumentasikan asumsi dan hasil. Skills khusus Godot/QA boleh dibuat setelah fondasi workflow jelas, bukan menjadi pengganti testing.

## 10. Risiko yang harus dibahas dalam PRD
1. Scope setara beberapa genre game sekaligus untuk solo developer.
2. Performa Android: pathfinding NPC, ekonomi, AI perang, render isometrik, memori.
3. Kompleksitas emergent narrative dan save migration.
4. Historical authenticity vs fantasi, sensitifitas representasi budaya.
5. Balancing ekonomi, logistik, politik dan reward ads.
6. Risiko konten/iklan untuk pemain anak dan remaja.
7. Lisensi aset, suara, fonts, dan referensi game.
8. Kualitas kode AI-generated, integrasi, dan regression testing.
9. Kebutuhan UI touch dan accessibility.
10. Ketidakpastian durasi, biaya, perangkat target dan kemampuan QA.

## 11. Pertanyaan terbuka yang jangan ditebak Astra
- Minimum spesifikasi Android, target FPS, RAM, ukuran unduhan.
- Segmentasi usia dan kebijakan konten/iklan yang akan dipakai.
- Model bisnis final: premium, gratis dengan rewarded ads, atau lain.
- Struktur kalender dan laju simulasi; batas offline progress.
- Detail enam atribut, kebutuhan, trait dan siklus hidup karakter.
- Jumlah wilayah, NPC, bangunan dan quest dalam pilot.
- Jenis unit historis, balancing combat, kamera siege.
- Definisi kemenangan, kekalahan dinasti, save slot dan autosave.
- Level akurasi sejarah yang ingin dipertahankan.
- Pipeline aset pixel art, audio, dan lisensi.
- Budget, waktu pengembangan mingguan, spesifikasi PC, perangkat Android uji.
- Apakah prototype lama layak diselamatkan.

## 12. Perintah handoff kepada GPT Astra
> Kamu adalah Principal Game Architect, Product Lead dan AI Engineering Orchestrator. Gunakan dokumen ini sebagai konteks desain Satriya Village. **Jangan coding dahulu.** Pertama buat (1) gap analysis dan daftar konflik/ketidakpastian, (2) **PRD v1.0** yang membedakan visi, MVP, vertical slice, pilot dan post-launch, (3) rencana GDD/TDD dengan dependency map, (4) AI-agent organization + ownership + quality gates, (5) milestone roadmap dan risk register. Jangan mengubah keputusan `CONFIRMED` diam-diam; rincian `PROPOSED` boleh dievaluasi dan `VERIFY` harus diteliti atau ditanyakan. Berikan acceptance criteria yang terukur dan strategi Android-first yang realistis untuk solo developer pemula. Tahan implementasi sampai PRD dan scope disetujui Game Director.

## 13. Urutan kerja berikutnya
1. Serahkan file MD ini ke GPT Astra.
2. Minta Astra menyusun gap analysis dan PRD; review dan putuskan open questions prioritas tinggi.
3. Finalisasi GDD gameplay pilot dan TDD modular berdasarkan PRD.
4. Tetapkan agent charter, `AGENTS.md`, QA gates, sprint backlog.
5. Audit prototype eksisting; putuskan salvage vs rebuild.
6. Baru eksekusi Codex per milestone dan uji build di PC/Android.

**Akhir dokumen.**
