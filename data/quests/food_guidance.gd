extends RefCounted
## Original local tutorial content; all choice/state identifiers are stable.
const DEFINITION: Dictionary = {
    "id": "food_guidance",
    "title": "Menjaga pangan desa",
    "objective": "Jalankan satu hari panen setelah menerima panduan. Petani harus menghasilkan cukup pangan untuk konsumsi harian tanpa kebutuhan yang belum terpenuhi. Setelah itu, laporkan panen kepada Laras.",
    "choices": {
        "accept": {"label": "Ikuti panduan", "from": ["offered"], "to": "active"},
        "decline": {"label": "Tolak panduan", "from": ["offered", "active"], "to": "declined"},
        "complete": {"label": "Laporkan panen", "from": ["ready"], "to": "completed"},
    },
    "states": {
        "offered": "Kepala desa, mari periksa apakah penugasan petani dapat mencukupi pangan. Panduan ini boleh diikuti atau ditolak.",
        "active": "Panduan diikuti. Atur petani lalu jalankan waktu untuk melihat hasil panen nyata. Sawah tanpa petani tidak menghasilkan pangan.",
        "ready": "Panen yang mencukupi kebutuhan sudah tercatat. Anda dapat melaporkan hasilnya sekarang, termasuk saat waktu dijeda.",
        "completed": "Panduan selesai. Anda telah membuktikan panen yang mencukupi kebutuhan harian. Pantau persediaan dan penugasan saat desa berkembang.",
        "declined": "Panduan ditolak. Anda tetap bebas membangun, mengatur petani, dan meminta laporan pangan dari Laras.",
    },
}
