extends RefCounted
## Original prototype characters; read-only reports, no narrative effects.
const PLAYER_ID: String = "village_chief"
const OFFICIAL_ID: String = "agriculture_official"
const CHARACTERS: Dictionary = {
    PLAYER_ID: {"name": "Kepala desa (Anda)", "role": "Pemimpin desa", "label": "Anda", "cell": Vector2i(2, 6), "actions": ["identity"]},
    OFFICIAL_ID: {"name": "Laras", "role": "Pejabat pertanian", "label": "Laras", "cell": Vector2i(5, 3), "actions": ["food_report", "workforce_report"]},
}
const LINES: Dictionary = {
    "chief.identity": "Anda adalah kepala desa. Tentukan pembangunan dan batas petani melalui tombol desa. Laras dapat menjelaskan kondisi pangan dan tenaga kerja.\n\nPenanda tokoh tidak menambah jumlah warga atau pekerja.",
    "official.greeting": "Kepala desa, berikut keadaan desa kita pada hari %d.",
    "official.food": "Persediaan pangan: %d.\nPetani bekerja: %d dari %d tempat sawah.\nPerkiraan hari berikutnya: panen %d, konsumsi terpenuhi %d, kebutuhan belum terpenuhi %d. Perubahan pangan bersih: %+d.",
    "official.workers": "Warga dalam kelompok tenaga kerja: %d.\nPetani bekerja: %d; warga belum bekerja: %d.\nTempat kerja sawah: %d. Kebijakan: %s.\n\nSatu petani mengaktifkan satu sawah dan menghasilkan 5 pangan per hari. Gunakan Petani -/+, atau Otomatis agar sawah baru terisi sesuai tenaga kerja yang tersedia.",
    "advice.no_fields": "Belum ada sawah. Bangun sawah jika kayu mencukupi, lalu alokasikan petani.",
    "advice.no_workers": "Belum ada petani yang bekerja. Periksa jumlah warga dan batas petani; sawah tanpa pekerja tidak menghasilkan panen.",
    "advice.unstaffed": "Sebagian tempat sawah belum terisi. Tambah batas petani atau gunakan Otomatis bila masih ada warga yang belum bekerja.",
    "advice.shortage": "Kebutuhan pangan belum terpenuhi. Periksa penugasan petani dan sawah; persediaan belum cukup untuk konsumsi penuh.",
    "advice.surplus": "Penugasan sekarang mencukupi kebutuhan pangan harian. Pantau persediaan saat mengubah penugasan.",
}

func report(actor_id: String, target_id: String, action_id: String, settlement: RefCounted, clock: RefCounted) -> Dictionary:
    if actor_id != PLAYER_ID:
        return {"ok": false, "error": "invalid_actor"}
    if not CHARACTERS.has(target_id):
        return {"ok": false, "error": "invalid_target"}
    var character: Dictionary = CHARACTERS[target_id]
    if action_id not in character.actions:
        return {"ok": false, "error": "invalid_action"}
    var text: String
    var line_id: String
    if action_id == "identity":
        line_id = "chief.identity"
        text = LINES[line_id]
    else:
        var workers: Dictionary = settlement.workforce()
        var food: Dictionary = settlement.food_projection()
        var greeting: String = LINES["official.greeting"] % clock.day
        line_id = "official.food" if action_id == "food_report" else "official.workers"
        if action_id == "food_report":
            var advice: String = "advice.surplus"
            if workers.slots == 0:
                advice = "advice.no_fields"
            elif workers.assigned == 0:
                advice = "advice.no_workers"
            elif workers.assigned < workers.slots:
                advice = "advice.unstaffed"
            text = greeting + "\n\n" + (LINES[line_id] % [settlement.stocks.food, workers.assigned, workers.slots, food.produced, food.consumed, food.unmet, food.net]) + "\n\n" + LINES[advice]
            if food.unmet > 0:
                text += "\n" + LINES["advice.shortage"]
        else:
            var policy: String = "Otomatis" if settlement.farm_worker_target == -1 else "Batas %d petani" % settlement.farm_worker_target
            text = greeting + "\n\n" + (LINES[line_id] % [settlement.population, workers.assigned, workers.idle, workers.slots, policy])
    return {"ok": true, "speaker_id": target_id, "name": character.name, "role": character.role, "action_id": action_id, "line_id": line_id, "text": text}
