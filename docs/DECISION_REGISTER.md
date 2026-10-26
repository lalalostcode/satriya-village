# Satriya Village — Decision Register

Tanggal: 26 Oktober 2026. Pemilik keputusan: Human Game Director. Register ini mencatat keputusan dan batas persetujuannya; **PRD v1.1 masih DRAFT, belum APPROVED**. [PRD](PRD.md) tetap dokumen produk utama, direvisi dari v1.0 pada berkas yang sama.

## Status dan kewenangan

| Status keputusan | Makna |
|---|---|
| CONFIRMED | Keputusan eksplisit atau baseline terkonfirmasi; tidak otomatis masuk rilis awal atau sudah diimplementasikan |
| PRINCIPLE_ACCEPTED | Arah diterima dengan syarat; manifest, parameter atau jadwal belum otomatis disetujui |
| PROPOSED | Opsi/rekomendasi yang belum dipilih Director |
| OPEN | Jawaban atau keputusan masih diperlukan |

VERIFY adalah kebutuhan bukti/riset. PASS/FAIL/NOT TESTED adalah status verifikasi, bukan tingkat persetujuan desain. Hanya Director yang dapat mengesahkan atau mengganti keputusan gameplay/scope/arsitektur substansial; agent mencatat bukti dan menyiapkan proposal. Jangan mengisi tanggal atau bukti persetujuan yang belum ada. [Task Log](TASK_LOG.md) mencatat pekerjaan, bukan approval.

Format entri: ID, keputusan, status, sumber, tanggal persetujuan atau belum ada, alasan, konsekuensi dan keputusan lanjutan. D01–D27 dari [handoff §3](../Satriya_Village_Planning_Handoff_v1.md) dan O01–O15 dari [PRD §16](PRD.md) dipertahankan. ID R11 di bawah hanya menandai hasil review v1.1; tidak menomori ulang keputusan asal. Koreksi berikutnya menambahkan riwayat, tidak menghapus bukti sebelumnya.

## Sumber persetujuan v1.1

**S11 — instruksi tertulis Director di chat ini, 26 Oktober 2026.** Director menerima secara prinsip arah A01/A03/A04/A05/A06/A07/A08 dengan ketentuan berikut, disalin agar bukti tidak bergantung tautan chat privat:

> 1. Vertical slice boleh dibatasi pada satu desa, tetapi seluruh visi Satriya Village—politik, dinasti, peperangan, ekonomi mendalam, living history, dan ekspansi Nusantara—tetap dipertahankan dalam roadmap.
> 2. Scope pilot dan MVP belum otomatis disetujui.
> 3. Pause menghentikan simulasi otomatis tetapi tetap mengizinkan perintah eksplisit pemain.
> 4. Ekonomi warga biasa berbasis agregasi; tokoh penting memiliki simulasi individual.
> 5. Mekanik pemulihan ekonomi, balancing, kalender, dan angka performa yang belum diputuskan tetap berstatus PROPOSED/OPEN.
> 6. A02, audit gameplay Godot, tetap NOT TESTED sampai ada bukti pengujian runtime.

Instruksi yang sama meminta revisi PRD v1.0 menjadi v1.1, register status, relative Markdown links, identifikasi pertanyaan O01–O04 sebelum APPROVED, dan belum mengizinkan kode/refactor Godot. Bukti ini bukan persetujuan global PRD atau otorisasi implementasi.

## Keputusan hasil review v1.1

| ID / audit / asal | Keputusan dan status | Tanggal / alasan / konsekuensi |
|---|---|---|
| R11-01 / A01 / O01 | PRINCIPLE_ACCEPTED: slice boleh satu desa; manifest rinci O01-S masih OPEN | 2026-10-26, S11. Menjaga kelayakan solo developer; tidak mengesahkan jumlah bangunan, durasi atau seluruh acceptance target |
| R11-02 / A07 / D01–D27 + DECISIONS | CONFIRMED: seluruh visi tetap dipertahankan dan ditelusuri dalam roadmap | 2026-10-26, S11. Fitur deferred memiliki sumber, gate/desain dan acceptance intent; tidak menjanjikan tanggal |
| R11-03 / A01 / O01-P/O01-M | CONFIRMED: scope pilot dan MVP belum otomatis disetujui; isi keduanya tetap PROPOSED/OPEN | 2026-10-26, S11. Persetujuan slice tidak mengesahkan pilot/rilis |
| R11-04 / A03 / O06 | CONFIRMED: pause menghentikan simulasi otomatis dan menerima command eksplisit pemain yang valid | 2026-10-26, S11. Selaraskan FR03 dan blueprint; kalender, daftar command dan detail transaksi belum dikunci |
| R11-05 / A04 / D08/D18/O07 | CONFIRMED: ekonomi warga biasa agregat; tokoh penting individual | 2026-10-26, S11. FR07/blueprint mengikuti batas ini; rumus workforce, perjalanan dan schema masih perlu spesifikasi |
| R11-06 / A05/A03/A08 / O06/O07/O14 | CONFIRMED: mekanik pemulihan, balancing, kalender dan angka performa yang belum dipilih tetap PROPOSED/OPEN | 2026-10-26, S11. Tidak mengunci pengumpulan kayu, rumah/populasi, rasio hari/tahun atau target FPS |
| R11-07 / A06 | PRINCIPLE_ACCEPTED: register keputusan dengan sumber, status dan batas kewenangan | 2026-10-26, S11. Dokumen ini memenuhi pencatatan; tidak menaikkan proposal lama secara massal |
| R11-08 / A08 / O04 | PRINCIPLE_ACCEPTED: arah validasi Android dini | 2026-10-26, S11. Ponsel, kesiapan, urutan pelaksanaan dan target O04/O14 masih OPEN; belum bukti Android |
| R11-09 / A02 | CONFIRMED sebagai ketentuan pelaporan: audit gameplay NOT TESTED sampai bukti runtime tersedia | 2026-10-26, S11. Tidak menyatakan bug fixed/M0 passed dari pembacaan source atau parser |
| R11-10 / batas kerja | CONFIRMED: pekerjaan saat ini revisi dokumentasi; belum kode/refactor Godot | 2026-10-26, S11. Perubahan dokumen tidak membuka gate engineering |

## Baseline lama dan konflik sumber

Visi [DECISIONS](DECISIONS.md) dan handoff D01–D27 tetap dipertahankan. Traceability lengkap ada di PRD §7 dan [ROADMAP](ROADMAP.md). Keputusan baru di atas melengkapi baseline; tidak mengklaim bahwa semua rincian contoh handoff sudah terkonfirmasi.

| Item | Status sumber / keputusan saat ini | Tindak lanjut |
|---|---|---|
| Enam atribut | Jumlah enam CONFIRMED; DECISIONS mencantumkan Leadership, Diplomacy, Strategy, Administration, Courage, Spirituality. Handoff menyebut nama sebagai usulan | Konflik C01 tetap ditandai; baseline nama tidak diganti; O08 menunggu ratifikasi eksplisit nama |
| Tirta Wening / Babad Tanah Tumapel / tahun 1219–1222 | PROPOSED; kronologi dan representasi membutuhkan VERIFY | O11, riset sebelum konten final |
| Rumah/sawah/lumbung, satu pejabat, quest ≥2 hasil, evaluasi 10–15 menit | Rincian proposal PRD v1.0; tidak seluruhnya disahkan oleh penerimaan prinsip satu desa | O01-S: pilih manifest secara eksplisit |
| Pemulihan kayu, populasi tetap, rumah hanya kapasitas, akibat kelaparan | PROPOSED/OPEN | O07; bandingkan opsi tanpa mengubah baseline audit |
| 8 detik/hari starter | Observasi source, bukan approval pacing/umur/sejarah | O06; saat audit tetap expected baseline jika source sama |
| 30 FPS / p95 33,3 ms / cap offline empat jam | PROPOSED; belum target yang diratifikasi atau bukti performa | O14/O10; tetapkan perangkat, beban dan aturan |

## Pertanyaan prioritas

Pertanyaan berikut benar-benar membutuhkan jawaban Director sebelum PRD dapat ditandai APPROVED. Jawaban parsial dicatat per ID; detail pilot/MVP boleh tetap ditunda. Tidak perlu meminta ulang dua aturan confirmed tentang pause dan agregasi.

| ID | Yang sudah diterima | Jawaban yang masih diperlukan | Rekomendasi yang belum diputuskan |
|---|---|---|---|
| O01-S | Boleh satu desa; visi luas dipertahankan | Apakah manifest slice PRD §4 diterima: tiga jenis bangunan inti + jalur pemulihan, pekerja otomatis, satu pejabat, satu quest ≥2 hasil, save/load dan touch? Apakah 10–15 menit hanya target sesi evaluasi diterima? Sebutkan bagian yang ingin diubah | Terima manifest sebagai batas slice, lalu pilih mekanik/angka melalui GDD; pilot dan MVP tetap ditunda |
| O02 | Arah mudah didekati anak/remaja | Rentang usia utama dan bahasa awal apa? Apakah Bahasa Indonesia dan tone non-grafis diterima sebagai baseline? | Bahasa Indonesia untuk prototipe; usia tidak ditebak dan bukan klaim rating toko |
| O03 | Pengembang solo pemula | Berapa jam pengembangan/tes per minggu dan plafon biaya untuk aset, audio, tooling/perangkat? Rp0 atau belum tersedia adalah jawaban yang valid | Gunakan kapasitas nyata; tahan tanggal rilis sampai throughput terukur |
| O04 | Arah Android dini diterima secara prinsip | Ponsel mana yang tersedia (model, RAM, Android) dan kapan dapat dipakai? Apakah smoke pertama dijadwalkan setelah baseline Windows stabil? Jika belum ada perangkat, pilih penundaan/perolehan perangkat | Gunakan ponsel tersedia untuk spike; belum otomatis menjadi spesifikasi minimum |

## Register O01–O15 dan dependensi

| ID | Status saat v1.1 | Keputusan yang tersisa / kapan diperlukan | Bukti approval detail |
|---|---|---|---|
| O01 | PRINCIPLE_ACCEPTED terbatas satu desa; O01-S OPEN; O01-P/O01-M PROPOSED/OPEN | Bekukan manifest slice sebelum approval dokumen; pilot/MVP keputusan terpisah setelah evaluasi | S11 hanya untuk prinsip/batas |
| O02 | OPEN; bahasa/tone usulan PROPOSED | Audiens/bahasa baseline sebelum approval dokumen | Belum ada |
| O03 | OPEN | Kapasitas/budget sebelum approval dokumen; belum estimasi kalender | Belum ada |
| O04 | PRINCIPLE_ACCEPTED arah; perangkat/pelaksanaan OPEN | Jawaban perangkat/rencana sebelum approval dokumen; bukti smoke kelak | S11 hanya untuk arah |
| O05 | OPEN; rekomendasi salvage bertahap PROPOSED | Audit dahulu, keputusan perbaikan/rebuild sebelum source edit | Belum ada |
| O06 | CONFIRMED hanya aturan pause; kalender/parameter OPEN | Kontrak waktu sebelum implementasi terkait/dinasti | S11 untuk pause |
| O07 | CONFIRMED batas agregasi; mekanik/rumus PROPOSED/OPEN | Pilih pemulihan, hunian, workforce dan konsumsi sebelum ekonomi diimplementasikan | S11 untuk agregasi, bukan rumus |
| O08 | OPEN pada konflik nama atribut | Ratifikasi nama sebelum spesifikasi atribut dikunci | Baseline DECISIONS dipertahankan; belum ratifikasi konflik |
| O09 | PROPOSED/OPEN | Slot/autosave/backup/format disahkan sebelum persistence | Belum ada |
| O10 | PROPOSED/OPEN | Penempatan di luar slice, allowlist/cap/konsumsi disahkan sebelum offline | Belum ada |
| O11 | PROPOSED/OPEN/VERIFY | Nama, kronologi dan source ledger sebelum konten final | Belum ada |
| O12 | PROPOSED/OPEN | Chapter, kalah, pewaris/tanpa pewaris sebelum desain pilot terkait | Belum ada |
| O13 | PROPOSED/OPEN | Bisnis, SDK/distribusi keputusan tersendiri saat rilis direncanakan | Belum ada |
| O14 | PROPOSED/OPEN | Beban, kapasitas dan angka performa setelah perangkat/spike | Belum ada |
| O15 | PROPOSED/OPEN | Pipeline art/audio dan lisensi sebelum produksi massal | Belum ada |

## Gate approval dan hasil audit

PRD belum APPROVED sampai jawaban O01-S/O02/O03/O04 tercatat dan Director secara eksplisit mengesahkan versi serta lingkupnya. O01-P/O01-M dan rincian lanjutan boleh deferred secara eksplisit; bukan komitmen rilis. Detail O06/O07/O09 dan kontrak terkait tetap menjadi gate sebelum implementasi fitur walaupun PRD nantinya disetujui.

Audit A01 memiliki penerimaan prinsip, tetapi manifest/kesiapan belum final. A03/A04 sudah memiliki dua aturan confirmed, tetapi spesifikasi belum lengkap. A05/A06/A07/A08 memiliki arah yang diterima dan pencatatan/traceability, bukan bukti implementasi. A02 **NOT TESTED**; penerimaan PRD tidak mensyaratkan mengarang kelulusan runtime dan tidak otomatis meluluskan M0. Engineering tetap menunggu otorisasi, audit baseline serta keputusan/kontrak prasyarat.
