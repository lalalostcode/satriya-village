extends RefCounted
const Catalog = preload("res://data/quests/food_guidance.gd")
var state: String = "offered"
var accepted_day: int = 0
var observed_day: int = 0
var harvest_day: int = 0
var resolution_id: String = ""

func capture() -> Dictionary:
    return {"id": Catalog.DEFINITION.id, "state": state, "accepted_day": accepted_day,
        "observed_day": observed_day, "harvest_day": harvest_day, "resolution_id": resolution_id}

func is_pristine() -> bool:
    return state == "offered" and accepted_day == 0 and observed_day == 0 and harvest_day == 0 and resolution_id.is_empty()

func choose(choice_id: String, day: int) -> Dictionary:
    if state in ["completed", "declined"]:
        return {"ok": false, "error": "already_resolved"}
    if not Catalog.DEFINITION.choices.has(choice_id):
        return {"ok": false, "error": "invalid_choice"}
    var choice: Dictionary = Catalog.DEFINITION.choices[choice_id]
    if state not in choice.from or day < 1 or day < observed_day:
        return {"ok": false, "error": "unmet_condition"}
    if choice_id == "complete" and not (accepted_day < harvest_day and harvest_day <= day):
        return {"ok": false, "error": "unmet_condition"}
    state = choice.to
    if choice_id == "accept":
        accepted_day = day
        observed_day = day
    elif choice_id in ["complete", "decline"]:
        resolution_id = "food_guidance." + state
    return {"ok": true, "state": state}

func observe_day(day: int, report: Dictionary) -> void:
    if state != "active" or day <= observed_day:
        return
    observed_day = day
    if report.get("workers", 0) > 0 and report.get("unmet", 1) == 0 and report.get("produced", 0) >= report.get("consumed", 1):
        harvest_day = day
        state = "ready"

func describe(settlement: RefCounted) -> Dictionary:
    var choices: Array = []
    for id: String in Catalog.DEFINITION.choices:
        var choice: Dictionary = Catalog.DEFINITION.choices[id]
        if state in choice.from:
            choices.append({"id": id, "label": choice.label})
    var text: String = Catalog.DEFINITION.states[state] + "\n\n" + Catalog.DEFINITION.objective
    if accepted_day > 0:
        text += "\n\nPanduan dimulai hari %d." % accepted_day
    if harvest_day > 0:
        text += " Panen tercatat hari %d." % harvest_day
    var food: Dictionary = settlement.food_projection()
    text += "\n\nSaat ini: pangan %d; petani %d; perkiraan pangan bersih %+d/hari.\nTidak ada hadiah sumber daya dari panduan ini." % [settlement.stocks.food, food.workers, food.net]
    return {"title": Catalog.DEFINITION.title, "text": text, "choices": choices}

static func restore(data: Variant, current_day: int) -> RefCounted:
    if not data is Dictionary or data.size() != 6:
        return null
    for key: String in ["id", "state", "accepted_day", "observed_day", "harvest_day", "resolution_id"]:
        if not data.has(key): return null
    if data.id != Catalog.DEFINITION.id or not data.state is String or not Catalog.DEFINITION.states.has(data.state):
        return null
    for value: Variant in [data.accepted_day, data.observed_day, data.harvest_day]:
        if not (value is int or value is float) or not is_finite(float(value)):
            return null
        if value < 0 or value > current_day or floor(float(value)) != value:
            return null
    var accepted: int = int(data.accepted_day)
    var observed: int = int(data.observed_day)
    var harvest: int = int(data.harvest_day)
    if not data.resolution_id is String: return null
    match data.state:
        "offered":
            if accepted != 0 or observed != 0 or harvest != 0 or data.resolution_id != "": return null
        "active":
            if accepted < 1 or observed < accepted or harvest != 0 or data.resolution_id != "": return null
        "ready", "completed":
            if accepted < 1 or harvest <= accepted or observed != harvest: return null
            if data.resolution_id != ("food_guidance.completed" if data.state == "completed" else ""): return null
        "declined":
            if harvest != 0 or data.resolution_id != "food_guidance.declined": return null
            if accepted == 0 and observed != 0: return null
            if accepted > 0 and observed < accepted: return null
    var quest = new()
    quest.state = data.state
    quest.accepted_day = accepted
    quest.observed_day = observed
    quest.harvest_day = harvest
    quest.resolution_id = data.resolution_id
    return quest
