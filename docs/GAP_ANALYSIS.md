# Gap Analysis — Satriya Village v1.0

Tanggal: 26 Oktober 2026. Status: **DRAFT UNTUK REVIEW GAME DIRECTOR**. Tidak mengotorisasi implementasi.

## 1. Kesimpulan arsitektur dan produk

Visi sudah jelas, tetapi kontrak produk yang dapat diuji belum lengkap. Kendala utama adalah cakupan gabungan simulasi ekonomi, karakter, politik, perang, dan narasi untuk satu pengembang pemula. Prioritas yang direkomendasikan: buktikan satu loop desa dengan konsekuensi pilihan yang dapat dipahami, kemudian perluas melalui gate. Belum ada dasar untuk menjanjikan tanggal rilis, kapasitas Android, atau keberhasilan prototype.

PRD pendamping: [PRD v1.0](PRD.md). Semua rekomendasi scope di sana masih usulan. Tidak ada kode, arsitektur runtime, keputusan terkonfirmasi, atau roadmap resmi yang diganti oleh analisis ini.

## 2. Cakupan pembacaan dan kekuatan bukti

Dokumen dibaca seluruhnya: `Satriya_Village_Planning_Handoff_v1.md`, `README.md`, `AGENTS.md`, `docs/DECISIONS.md`, `docs/ROADMAP.md`, `docs/MASTER_PLANNING.md`, `docs/ARCHITECTURE_BLUEPRINT.md`, `docs/AI_AGENT_STRATEGY.md`, `docs/EXECUTION_BLUEPRINT.md`, dan `docs/ARCHITECTURE.md`.

Handoff merupakan sintesis percakapan, bukan transkrip lengkap. Master Planning menyebut Master Project Brief yang tidak ditemukan sebagai berkas terpisah; isi asli brief itu tidak diverifikasi. Tidak ada rekonstruksi jawaban B/C atau klaim telah membaca lampiran lain yang tidak tersedia. Analisis ini berbasis dokumen, bukan audit source, uji interaksi, riset sejarah, maupun sertifikasi kebijakan toko.

Hierarki kerja: instruksi pengguna saat ini dan AGENTS mengatur pekerjaan; DECISIONS mempertahankan keputusan repository; handoff melengkapi konteks dan menunjukkan ketidakpastian; blueprint dan master planning tetap proposal. Ketika status dua sumber berbeda, catat konflik dan minta ratifikasi, bukan menyimpulkan salah satunya otomatis membatalkan yang lain.

## 3. Konflik lintas dokumen

| ID | Bukti / konflik | Perlakuan PRD | Keputusan atau bukti penutup |
|---|---|---|---|
| C01 | Handoff D13: jumlah enam terkonfirmasi, nama atribut usulan; DECISIONS: enam nama ditetapkan | Pertahankan Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality sebagai baseline repo; status lintas sumber belum selaras | Director meratifikasi nama; jangan ganti diam-diam |
| C02 | Handoff: Tirta Wening dan Babad Tanah Tumapel usulan; Master Planning menyebut Tirta Wening seolah identitas tetap | Gunakan desa fiksi kawasan Malang; nama sebagai placeholder | Persetujuan nama kampanye/desa |
| C03 | README mencantumkan fungsi starter; handoff melaporkan seluruh mekanik gagal; revisi 0.1.1 belum terkonfirmasi | Fitur terdokumentasi bukan bukti fungsi; M0 belum diterima | Audit input/runtime dengan expected/actual |
| C04 | Handoff stack 4.x perlu verifikasi; AGENTS/README menetapkan 4.7.2 Standard | Pertahankan Godot 4.7.2 + GDScript; nama executable bukan bukti versi runtime | Catat versi saat audit teknis |
| C05 | Handoff memberi 1×/2×/3× sebagai contoh; DECISIONS menetapkannya | Pertahankan kontrol pause/1×/2×/3×; pacing hari/tahun tetap terbuka | GDD kalender dan pacing |
| C06 | P0/P1/P2/P3 handoff tidak sama dengan M0–M4 repo atau A/B/C master | Gunakan M0–M4 sebagai urutan resmi; slice/pilot adalah hasil lintas milestone | Persetujuan pemetaan scope pada PRD |
| C07 | Handoff P1 mengusulkan panen + upeti; AGENTS first slice satu quest | Satu quest krisis pangan; upeti hanya konteks atau ditunda ke pilot | Persetujuan scope quest |
| C08 | Android diletakkan M4 pada roadmap; blueprint mengusulkan spike lebih awal | Spike Android pada fondasi adalah rekomendasi tambahan | Setujui waktu spike dan perangkat |
| C09 | Blueprint command pada batas tick; invariant pause tidak mengubah state | Bedakan waktu simulasi berhenti dengan command pemain saat pause; aturan belum final | Pilih apakah pembangunan tetap boleh saat pause sebelum kontrak input ditulis |
| C10 | Offline rutin boleh berjalan; konsumsi/kelangkaan dapat memicu kejadian besar | Cap dan aturan berhenti belum final; offline tidak masuk slice usulan | Tentukan konsumsi, kelaparan, dan resume idempotent |
| C11 | Kekalahan berat dan dinasti disetujui sebagai visi; bentuk exile, pewaris, durasi belum final | Pilot mengusulkan satu akibat politik dan demonstrasi suksesi; bukan keseluruhan visi | Tentukan batas pilot dan kondisi akhir permainan |
| C12 | Handoff membuka salvage/rebuild; AGENTS melarang mass refactor diam-diam | Audit dahulu; rekomendasi default perbaikan bertahap, rebuild hanya keputusan terpisah | Bukti biaya/risiko dan approval arsitektur |
| C13 | Ekonomi biasa berbasis kelompok; blueprint mencantumkan worker_ids individual | Kelompok menjadi sumber hitungan ekonomi; sprite tidak otomatis berarti warga individual | GDD menetapkan assignment agregat atau individu ringan sebelum schema |
| C14 | Master menyebut Lima Penjaga Bhumi yang tidak ada dalam register confirmed | Kandidat lore, tidak menjadi requirement | Review lore bila akan dipakai |

## 4. Gap yang menghalangi delivery

Prioritas: **B0** sebelum scope/implementasi disahkan; **B1** sebelum fitur terkait; **B2** sebelum pilot/rilis. Bukan severity bug runtime.

| ID | Gap dan dampak | Prioritas / pemilik logis | Artefak / kriteria penutupan |
|---|---|---|---|
| G01 | MVP belum menjadi janji produk yang terukur; scope dapat meluas terus | B0 / Director + Product | Scope PRD disetujui dengan daftar masuk/keluar |
| G02 | Target usia dan tingkat kompleksitas belum operasional | B0 / Director | Segmen utama, batas konten, kriteria pemahaman ditetapkan |
| G03 | Kapasitas waktu, dana, perangkat uji tidak tersedia | B0 / Director | Jam per minggu, plafon biaya, PC/Android tersedia dicatat; estimasi berbasis kapasitas |
| G04 | Baseline fungsi dan penyebab gagal tidak diketahui | B0 sebelum coding / QA | AUDIT_REPORT, reproduksi, versi, log dan rekomendasi salvage/rebuild |
| G05 | Kalender ekonomi, sejarah, umur dan time skip belum tersambung | B1 / Simulation + Narrative | GDD kalender: satuan waktu, deadline, pause, penuaan, skip; contoh timeline diuji |
| G06 | Ekonomi dapat buntu; biaya, kapasitas dan pemulihan belum dirancang | B1 / Simulation | Ledger dan skenario stok nol, tanpa pekerja, salah bangun; jalur pemulihan disetujui |
| G07 | Otonomi pejabat belum memiliki batas wewenang konkret | B1 / Character | Daftar tindakan rutin/besar, plafon, pelaporan, penolakan dan uji biaya |
| G08 | Save slot, autosave, migrasi, recovery belum menjadi kontrak | B1 / Lead | SAVE_FORMAT disahkan sebelum persistence; skenario gagal tulis/load jelas |
| G09 | Narasi opsional dan sejarah yang tetap bergerak berpotensi bertentangan | B1 / Narrative | Graph follow/refuse/ignore; warning dan resolusi aktif; efek sekali |
| G10 | Representasi sejarah/budaya belum memiliki source ledger | B1 sebelum konten final / Narrative | Fakta, tafsir, tradisi sastra, fiksi dipisahkan; klaim penting punya sumber |
| G11 | Belum ada kapasitas/FPS/memori Android yang terbukti | B1 spike, B2 rilis / QA | Perangkat minimum bernama, skenario beban, hasil frame time/memori/lifecycle |
| G12 | UX touch, aksesibilitas, ukuran teks dan occlusion belum teruji | B1 / UI | Prototipe interaksi dan playtest perangkat, termasuk tap/drag serta safe area |
| G13 | Diplomasi, perang, kehilangan kekuasaan, suksesi belum punya kondisi selesai | B2 / Director + Combat | Satu skenario menang/kalah/retreat/suksesi dan kelanjutan state disahkan |
| G14 | Volume art/audio, pipeline dan lisensi belum dibudgetkan | B1 sampel, B2 produksi / Art | Daftar aset, provenance, style sample, estimasi produksi terukur |
| G15 | Model bisnis, distribusi, rating dan privasi belum ditentukan | B2 / Director + Release | Keputusan bisnis; verifikasi resmi terkini menjelang distribusi; approval terpisah untuk SDK |
| G16 | Banyak dokumen proposal bisa disalahartikan sebagai keputusan | B0 / Lead | PRD berstatus draft, register keputusan dan rekam approval; dokumen lama tidak dihapus |

## 5. Urutan penyelesaian yang direkomendasikan

1. Review PRD: batas satu desa/satu quest, definisi pilot dan MVP, target pemain, kapasitas kerja, perangkat uji.
2. Lakukan audit terpisah tanpa perbaikan kode untuk membuktikan baseline. Audit dapat berjalan sebelum semua keputusan balancing selesai, tetapi bukan bagian dari klaim analisis ini.
3. Sahkan GDD minimum dan kontrak fondasi; tentukan salvage bertahap atau proposal rebuild berdasarkan audit.
4. Sahkan format save sebelum menulis persistence. Selesaikan ekonomi dan quest sebelum membahas offline.
5. Implementasi hanya setelah PRD/scope disetujui. Tahan ekspansi sampai gate slice tercapai.

Tidak ada angka durasi produksi yang dapat dipertanggungjawabkan sebelum kapasitas pengembang dan hasil audit tersedia. Riset sejarah dan kebijakan masih pekerjaan terbuka; dokumen ini tidak mengubah klaim yang belum terverifikasi menjadi fakta.
