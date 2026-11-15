class_name EncyclopediaModal
extends CanvasLayer

## Interactive Flying Cards Encyclopedia for Astro-Care
## Displays 19 scientifically verified space facts from NASA DONKI, NASA OSDR, and NASA Planetary science.

signal closed
signal card_changed(card_data: Dictionary, index: int, total: int)

# Nodes
@onready var backdrop: ColorRect = %Backdrop if has_node("%Backdrop") else null
@onready var modal_panel: PanelContainer = %ModalPanel if has_node("%ModalPanel") else null
@onready var btn_close: Button = %BtnClose if has_node("%BtnClose") else null
@onready var card_counter: Label = %CardCounter if has_node("%CardCounter") else null
@onready var filter_bar: HBoxContainer = %FilterBar if has_node("%FilterBar") else null

# Card Visual Elements
@onready var card_anchor: Control = %CardAnchor if has_node("%CardAnchor") else null
@onready var card_panel: PanelContainer = %CardPanel if has_node("%CardPanel") else null
@onready var category_badge: Label = %CategoryBadge if has_node("%CategoryBadge") else null
@onready var card_id_label: Label = %CardIdLabel if has_node("%CardIdLabel") else null
@onready var card_icon: Label = %CardIcon if has_node("%CardIcon") else null
@onready var fact_text: Label = %FactText if has_node("%FactText") else null
@onready var source_text: Label = %SourceText if has_node("%SourceText") else null

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

func _ready() -> void:
	_ensure_nodes()
	if card_panel:
		default_card_position = card_panel.position
	
	# Load cards from EncyclopediaData
	current_cards = EncyclopediaData.get_all_cards().duplicate()
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
	_update_card_display(0, 0)

func _ensure_nodes() -> void:
	if backdrop == null: backdrop = get_node_or_null("%Backdrop")
	if modal_panel == null: modal_panel = get_node_or_null("%ModalPanel")
	if btn_close == null: btn_close = get_node_or_null("%BtnClose")
	if card_counter == null: card_counter = get_node_or_null("%CardCounter")
	if filter_bar == null: filter_bar = get_node_or_null("%FilterBar")
	if card_anchor == null: card_anchor = get_node_or_null("%CardAnchor")
	if card_panel == null: card_panel = get_node_or_null("%CardPanel")
	if category_badge == null: category_badge = get_node_or_null("%CategoryBadge")
	if card_id_label == null: card_id_label = get_node_or_null("%CardIdLabel")
	if card_icon == null: card_icon = get_node_or_null("%CardIcon")
	if fact_text == null: fact_text = get_node_or_null("%FactText")
	if source_text == null: source_text = get_node_or_null("%SourceText")
	if btn_prev == null: btn_prev = get_node_or_null("%BtnPrev")
	if btn_next == null: btn_next = get_node_or_null("%BtnNext")
	if btn_random == null: btn_random = get_node_or_null("%BtnRandom")
	if progress_bar == null: progress_bar = get_node_or_null("%ProgressBar")

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
		current_cards = EncyclopediaData.get_all_cards().duplicate()
	else:
		current_cards = EncyclopediaData.get_cards_by_category(category_key).duplicate()
	
	current_index = 0
	_update_card_display(0, 0)

func open() -> void:
	_ensure_nodes()
	visible = true
	is_animating = true
	
	if backdrop:
		backdrop.modulate.a = 0.0
		var tween_bg = create_tween()
		tween_bg.tween_property(backdrop, "modulate:a", 1.0, 0.25)
		
	if modal_panel:
		modal_panel.modulate.a = 0.0
		modal_panel.scale = Vector2(0.88, 0.88)
		modal_panel.pivot_offset = modal_panel.size / 2.0
		var tween = create_tween().set_parallel(true)
		tween.tween_property(modal_panel, "modulate:a", 1.0, 0.25)
		tween.tween_property(modal_panel, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		await tween.finished
		
	is_animating = false

func close() -> void:
	if is_animating:
		return
	is_animating = true
	
	if modal_panel:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(modal_panel, "modulate:a", 0.0, 0.2)
		tween.tween_property(modal_panel, "scale", Vector2(0.9, 0.9), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		if backdrop:
			tween.tween_property(backdrop, "modulate:a", 0.0, 0.2)
		await tween.finished
		
	visible = false
	is_animating = false
	closed.emit()

func next_card() -> void:
	if current_cards.is_empty() or is_animating:
		return
	current_index = (current_index + 1) % current_cards.size()
	_update_card_display(current_index, 1)

func prev_card() -> void:
	if current_cards.is_empty() or is_animating:
		return
	current_index = (current_index - 1 + current_cards.size()) % current_cards.size()
	_update_card_display(current_index, -1)

func random_card() -> void:
	if current_cards.size() <= 1 or is_animating:
		return
	var new_idx = current_index
	while new_idx == current_index:
		new_idx = randi() % current_cards.size()
	current_index = new_idx
	_update_card_display(current_index, 0)

func _update_card_display(index: int, fly_direction: int = 0) -> void:
	_ensure_nodes()
	if current_cards.is_empty():
		if fact_text: fact_text.text = "No cards available in this category."
		if card_counter: card_counter.text = "0 / 0"
		return
		
	var card = current_cards[index]
	var total = current_cards.size()
	
	# Update text labels
	if card_counter:
		card_counter.text = "CARD %d OF %d" % [index + 1, total]
		
	if category_badge:
		category_badge.text = card.get("category", "SCIENCE")
		_style_category_badge(card.get("category", ""))
		
	if card_id_label:
		card_id_label.text = "ARCHIVE // %s" % card.get("id", "").to_upper()
		
	if card_icon:
		card_icon.text = card.get("icon", "🚀")
		
	if fact_text:
		fact_text.text = card.get("fact", "")
		fact_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
	if source_text:
		source_text.text = "DATA SOURCE: %s" % card.get("source", "NASA")
		source_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		
	if progress_bar:
		progress_bar.max_value = total
		progress_bar.value = index + 1
		
	card_changed.emit(card, index, total)
	
	# Flying Card Animation
	_animate_flying_card(fly_direction)

func _animate_flying_card(fly_direction: int) -> void:
	if card_panel == null or not is_inside_tree():
		return
		
	card_panel.pivot_offset = card_panel.size / 2.0
	
	var tween = create_tween().set_parallel(true)
	
	if fly_direction > 0:
		# Flying in from Right
		card_panel.position.x = default_card_position.x + 140.0
		card_panel.modulate.a = 0.0
		card_panel.scale = Vector2(0.9, 0.9)
		tween.tween_property(card_panel, "position:x", default_card_position.x, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "scale", Vector2(1.0, 1.0), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "modulate:a", 1.0, 0.2)
	elif fly_direction < 0:
		# Flying in from Left
		card_panel.position.x = default_card_position.x - 140.0
		card_panel.modulate.a = 0.0
		card_panel.scale = Vector2(0.9, 0.9)
		tween.tween_property(card_panel, "position:x", default_card_position.x, 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "scale", Vector2(1.0, 1.0), 0.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "modulate:a", 1.0, 0.2)
	else:
		# Center pop / zoom
		card_panel.position = default_card_position
		card_panel.scale = Vector2(0.93, 0.93)
		card_panel.modulate.a = 0.3
		tween.tween_property(card_panel, "scale", Vector2(1.0, 1.0), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "modulate:a", 1.0, 0.2)

func _style_category_badge(category: String) -> void:
	if not category_badge:
		return
	if "FLARE" in category:
		category_badge.modulate = Color(1.0, 0.75, 0.2, 1.0)
	elif "ERUPTION" in category:
		category_badge.modulate = Color(1.0, 0.35, 0.25, 1.0)
	elif "FOOD" in category:
		category_badge.modulate = Color(0.3, 1.0, 0.45, 1.0)
	elif "PLANET" in category:
		category_badge.modulate = Color(0.75, 0.45, 1.0, 1.0)
	elif "MARS" in category:
		category_badge.modulate = Color(1.0, 0.4, 0.3, 1.0)
	elif "SPACE" in category:
		category_badge.modulate = Color(0.2, 0.85, 1.0, 1.0)
	else:
		category_badge.modulate = Color(0.3, 0.9, 1.0, 1.0)

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
