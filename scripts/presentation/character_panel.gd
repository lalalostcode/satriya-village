extends Control
## One panel for chief identity and the official's current reports.
signal topic_requested(action_id: String)
signal closed
var title_label: Label
var role_label: Label
var body_label: Label
var food_button: Button
var workers_button: Button
var close_button: Button
var card: PanelContainer

func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    var shade := ColorRect.new()
    shade.color = Color(0.04, 0.08, 0.07, 0.7)
    shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    shade.mouse_filter = Control.MOUSE_FILTER_STOP
    add_child(shade)
    card = PanelContainer.new()
    card.position = Vector2(220, 120)
    card.size = Vector2(840, 430)
    add_child(card)
    var margin := MarginContainer.new()
    for side: String in ["left", "right", "top", "bottom"]:
        margin.add_theme_constant_override("margin_" + side, 22)
    card.add_child(margin)
    var column := VBoxContainer.new()
    column.add_theme_constant_override("separation", 12)
    margin.add_child(column)
    title_label = Label.new()
    title_label.add_theme_font_size_override("font_size", 24)
    column.add_child(title_label)
    role_label = Label.new()
    column.add_child(role_label)
    body_label = Label.new()
    body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
    column.add_child(body_label)
    var actions := HBoxContainer.new()
    actions.add_theme_constant_override("separation", 12)
    column.add_child(actions)
    food_button = _button("Pangan", actions)
    food_button.pressed.connect(func() -> void: topic_requested.emit("food_report"))
    workers_button = _button("Pekerja", actions)
    workers_button.pressed.connect(func() -> void: topic_requested.emit("workforce_report"))
    var spacer := Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    actions.add_child(spacer)
    close_button = _button("Tutup", actions)
    close_button.pressed.connect(func() -> void: closed.emit())
    hide()

func _button(text: String, parent: Control) -> Button:
    var button := Button.new()
    button.text = text
    button.custom_minimum_size = Vector2(100, 44)
    button.add_to_group("interaction_controls")
    parent.add_child(button)
    return button

func show_report(response: Dictionary) -> void:
    var was_visible: bool = visible
    title_label.text = response.name
    role_label.text = response.role
    body_label.text = response.text
    var official: bool = response.action_id != "identity"
    food_button.visible = official
    workers_button.visible = official
    show()
    if not was_visible:
        close_button.grab_focus()
