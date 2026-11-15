class_name EncyclopediaModal
extends CanvasLayer

## Interactive Sci-Fi Encyclopedia Modal for Astro-Care
## Displays 19 scientifically verified space facts from NASA DONKI, NASA OSDR, and NASA Planetary science.

signal closed
signal card_changed(card_data: Dictionary, index: int, total: int)

# Nodes
@onready var backdrop: ColorRect = %Backdrop if has_node("%Backdrop") else null
@onready var modal_panel: PanelContainer = %ModalPanel if has_node("%ModalPanel") else null
@onready var card_container: Control = %CardContainer if has_node("%CardContainer") else null
@onready var btn_close: Button = %BtnClose if has_node("%BtnClose") else null
@onready var card_counter: Label = %CardCounter if has_node("%CardCounter") else null
@onready var filter_bar: HBoxContainer = %FilterBar if has_node("%FilterBar") else null

# Card Visual Elements
@onready var card_anchor: Control = %CardAnchor if has_node("%CardAnchor") else null
@onready var card_panel: PanelContainer = %CardPanel if has_node("%CardPanel") else null
@onready var category_badge: Label = %CategoryBadge if has_node("%CategoryBadge") else null
@onready var category_pill: Label = %CategoryPill if has_node("%CategoryPill") else null
@onready var card_id_label: Label = %CardIdLabel if has_node("%CardIdLabel") else null
@onready var card_icon: Label = %CardIcon if has_node("%CardIcon") else null
@onready var fact_text: Label = %FactText if has_node("%FactText") else null
@onready var source_text: Label = %SourceText if has_node("%SourceText") else null
@onready var source_label: Label = %SourceLabel if has_node("%SourceLabel") else null

# Navigation Controls
@onready var btn_prev: Button = %BtnPrev if has_node("%BtnPrev") else null
@onready var btn_next: Button = %BtnNext if has_node("%BtnNext") else null
@onready var btn_random: Button = %BtnRandom if has_node("%BtnRandom") else null
@onready var progress_bar: ProgressBar = %ProgressBar if has_node("%ProgressBar") else null

# State
var current_cards: Array[Dictionary] = []
var current_index: int = 0
var current_filter: String = "ALL"
var is_animating: bool = false
var default_card_position: Vector2 = Vector2.ZERO
var use_card_prefix: bool = false

func _ready() -> void:
	_ensure_nodes()
	if card_panel:
		default_card_position = card_panel.position
		card_panel.mouse_filter = Control.MOUSE_FILTER_STOP
		if not card_panel.gui_input.is_connected(_on_card_gui_input):
			card_panel.gui_input.connect(_on_card_gui_input)
	
	# Load cards from EncyclopediaData.CARDS_DATA
	current_cards = EncyclopediaData.CARDS_DATA.duplicate()
	current_index = 0
	current_filter = "ALL"
	
	# Connect buttons
	if btn_close and not btn_close.pressed.is_connected(close):
		btn_close.pressed.connect(close)
	if btn_prev and not btn_prev.pressed.is_connected(prev_card):
		btn_prev.pressed.connect(prev_card)
	if btn_next and not btn_next.pressed.is_connected(next_card):
		btn_next.pressed.connect(next_card)
	if btn_random and not btn_random.pressed.is_connected(random_card):
		btn_random.pressed.connect(random_card)
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_gui_input):
		backdrop.gui_input.connect(_on_backdrop_gui_input)
		
	_connect_filter_buttons()
	_display_card_data(0)

func _ensure_nodes() -> void:
	if backdrop == null:
		backdrop = get_node_or_null("%Backdrop")
		if backdrop == null:
			backdrop = get_node_or_null("Backdrop")
	if modal_panel == null:
		modal_panel = get_node_or_null("%ModalPanel")
	if card_panel == null:
		card_panel = get_node_or_null("%CardPanel")
	if card_container == null:
		card_container = get_node_or_null("%CardContainer")
	if btn_close == null:
		btn_close = get_node_or_null("%BtnClose")
	if card_counter == null:
		card_counter = get_node_or_null("%CardCounter")
	if card_counter and card_counter.text.begins_with("CARD"):
		use_card_prefix = true
	if filter_bar == null:
		filter_bar = get_node_or_null("%FilterBar")
	if card_anchor == null:
		card_anchor = get_node_or_null("%CardAnchor")
	if category_badge == null:
		category_badge = get_node_or_null("%CategoryBadge")
	if category_pill == null:
		category_pill = get_node_or_null("%CategoryPill")
	if category_badge == null and category_pill != null:
		category_badge = category_pill
	if category_pill == null and category_badge != null:
		category_pill = category_badge
	if card_id_label == null:
		card_id_label = get_node_or_null("%CardIdLabel")
	if card_icon == null:
		card_icon = get_node_or_null("%CardIcon")
	if fact_text == null:
		fact_text = get_node_or_null("%FactText")
	if source_text == null:
		source_text = get_node_or_null("%SourceText")
	if source_label == null:
		source_label = get_node_or_null("%SourceLabel")
	if source_text == null and source_label != null:
		source_text = source_label
	if source_label == null and source_text != null:
		source_label = source_text
	if btn_prev == null:
		btn_prev = get_node_or_null("%BtnPrev")
	if btn_next == null:
		btn_next = get_node_or_null("%BtnNext")
	if btn_random == null:
		btn_random = get_node_or_null("%BtnRandom")
	if progress_bar == null:
		progress_bar = get_node_or_null("%ProgressBar")

func _connect_filter_buttons() -> void:
	if not filter_bar:
		return
	for child in filter_bar.get_children():
		if child is Button:
			var btn: Button = child
			var cat_name: String = btn.name.replace("BtnFilter", "").to_upper()
			if not btn.pressed.is_connected(_on_filter_btn_pressed.bind(cat_name, btn)):
				btn.pressed.connect(_on_filter_btn_pressed.bind(cat_name, btn))

func _on_filter_btn_pressed(filter_key: String, clicked_button: Button) -> void:
	filter_by_category(filter_key)
	_update_filter_button_styles(clicked_button)

func _update_filter_button_styles(active_button: Button) -> void:
	if not filter_bar:
		return
	for child in filter_bar.get_children():
		if child is Button:
			if child == active_button:
				child.modulate = Color(1.0, 1.0, 1.0, 1.0)
			else:
				child.modulate = Color(0.7, 0.85, 0.95, 0.75)

func filter_by_category(category_key: String) -> void:
	current_filter = category_key
	if category_key == "ALL":
		current_cards = EncyclopediaData.CARDS_DATA.duplicate()
	else:
		current_cards = EncyclopediaData.get_cards_by_category(category_key).duplicate()
	
	current_index = 0
	_display_card_data(0)

func open() -> void:
	_ensure_nodes()
	visible = true
	is_animating = false
	current_index = 0
	_display_card_data(0)
	
	if backdrop:
		backdrop.modulate.a = 0.0
		var tween_bg = create_tween()
		tween_bg.tween_property(backdrop, "modulate:a", 1.0, 0.2)
		
	var target = card_panel if card_panel else modal_panel
	if target:
		target.position = default_card_position
		target.modulate.a = 0.0
		target.scale = Vector2(0.92, 0.92)
		target.pivot_offset = target.size / 2.0
		var tween = create_tween().set_parallel(true)
		tween.tween_property(target, "modulate:a", 1.0, 0.25)
		tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close() -> void:
	if is_animating:
		return
	is_animating = true
	
	var target = card_panel if card_panel else modal_panel
	if target:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(target, "modulate:a", 0.0, 0.18)
		tween.tween_property(target, "scale", Vector2(0.9, 0.9), 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		if backdrop:
			tween.tween_property(backdrop, "modulate:a", 0.0, 0.18)
		await tween.finished
		
	visible = false
	is_animating = false
	closed.emit()

func next_card() -> void:
	if is_animating or current_cards.is_empty():
		return
	var total = current_cards.size()
	current_index = (current_index + 1) % total
	_animate_flying_transition(1)

func prev_card() -> void:
	if is_animating or current_cards.is_empty():
		return
	var total = current_cards.size()
	current_index = (current_index - 1 + total) % total
	_animate_flying_transition(-1)

func random_card() -> void:
	if current_cards.size() <= 1 or is_animating:
		return
	var new_idx = current_index
	while new_idx == current_index:
		new_idx = randi() % current_cards.size()
	current_index = new_idx
	_display_card_data(current_index)

func _on_card_gui_input(event: InputEvent) -> void:
	if is_animating:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		next_card()

func _animate_flying_transition(direction: int) -> void:
	var target = card_panel if card_panel else modal_panel
	if target == null or not is_inside_tree():
		_display_card_data(current_index)
		return
		
	is_animating = true
	target.pivot_offset = target.size / 2.0
	
	# Slide current card out horizontally shifted by -120 * direction
	# fading modulate.a to 0.0 and scaling down to 0.94 over 0.18s (TRANS_CUBIC, EASE_IN)
	var tween_out = create_tween().set_parallel(true)
	var slide_out_x = default_card_position.x - (120.0 * direction)
	tween_out.tween_property(target, "position:x", slide_out_x, 0.18).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween_out.tween_property(target, "modulate:a", 0.0, 0.18)
	tween_out.tween_property(target, "scale", Vector2(0.94, 0.94), 0.18)
	await tween_out.finished
	
	# Update card contents to CARDS_DATA[current_index]
	_display_card_data(current_index)
	
	# Reset card position to opposite side (+120 * direction)
	target.position.x = default_card_position.x + (120.0 * direction)
	target.modulate.a = 0.0
	target.scale = Vector2(0.94, 0.94)
	
	# Second parallel Tween (0.22s, TRANS_BACK, EASE_OUT) gliding back to center,
	# fading modulate.a to 1.0, and popping scale to Vector2(1.0, 1.0)
	var tween_in = create_tween().set_parallel(true)
	tween_in.tween_property(target, "position:x", default_card_position.x, 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_in.tween_property(target, "modulate:a", 1.0, 0.22)
	tween_in.tween_property(target, "scale", Vector2(1.0, 1.0), 0.22)
	await tween_in.finished
	
	target.position = default_card_position
	is_animating = false

func _display_card_data(index: int) -> void:
	_ensure_nodes()
	if current_cards.is_empty():
		if fact_text: fact_text.text = "No cards available in this category."
		if card_counter:
			card_counter.text = "CARD 0 OF 0" if use_card_prefix else "0 / 0"
		return
		
	var card = current_cards[index]
	var total = current_cards.size()
	
	# Update text labels
	if card_counter:
		if use_card_prefix:
			card_counter.text = "CARD %d OF %d" % [index + 1, total]
		else:
			card_counter.text = "%d / %d" % [index + 1, total]
		
	if category_pill:
		category_pill.text = card.get("category", "SCIENCE")
		_style_category_badge(card.get("category", ""))
		
	if category_badge and category_badge != category_pill:
		category_badge.text = card.get("category", "SCIENCE")
		_style_category_badge(card.get("category", ""))
		
	if card_id_label:
		card_id_label.text = "ARCHIVE // %s" % card.get("id", "").to_upper()
		
	if card_icon:
		card_icon.text = card.get("icon", "🚀")
		
	if fact_text:
		fact_text.text = card.get("fact", "")
		fact_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
	if source_label:
		source_label.text = "Source: %s" % card.get("source", "NASA")
		source_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
	if source_text and source_text != source_label:
		source_text.text = "Source: %s" % card.get("source", "NASA")
		source_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
	if progress_bar:
		progress_bar.max_value = total
		progress_bar.value = index + 1
		
	card_changed.emit(card, index, total)

func _update_card_display(index: int, fly_direction: int = 0) -> void:
	current_index = index
	if fly_direction != 0:
		_animate_flying_transition(fly_direction)
	else:
		_display_card_data(index)

func _animate_flying_card(fly_direction: int) -> void:
	if fly_direction != 0:
		_animate_flying_transition(fly_direction)
	else:
		_display_card_data(current_index)

func _style_category_badge(category: String) -> void:
	var badge = category_pill if category_pill else category_badge
	if not badge:
		return
	if "FLARE" in category:
		badge.modulate = Color(1.0, 0.75, 0.2, 1.0)
	elif "ERUPTION" in category:
		badge.modulate = Color(1.0, 0.35, 0.25, 1.0)
	elif "FOOD" in category:
		badge.modulate = Color(0.3, 1.0, 0.45, 1.0)
	elif "PLANET" in category:
		badge.modulate = Color(0.75, 0.45, 1.0, 1.0)
	elif "MARS" in category:
		badge.modulate = Color(1.0, 0.4, 0.3, 1.0)
	elif "SPACE" in category:
		badge.modulate = Color(0.2, 0.85, 1.0, 1.0)
	else:
		badge.modulate = Color(0.3, 0.9, 1.0, 1.0)

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		close()
		if get_viewport():
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_left"):
		prev_card()
		if get_viewport():
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		next_card()
		if get_viewport():
			get_viewport().set_input_as_handled()

func _on_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		close()
