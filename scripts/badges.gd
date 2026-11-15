class_name BadgesModal
extends CanvasLayer

## Interactive Badges & Mission Achievements Modal for Astro-Care
## Displays the 6 scientific expedition achievements with live unlock state.

signal closed

@onready var backdrop: ColorRect = %Backdrop if has_node("%Backdrop") else null
@onready var modal_panel: PanelContainer = %ModalPanel if has_node("%ModalPanel") else null
@onready var btn_close: Button = %BtnClose if has_node("%BtnClose") else null
@onready var badges_counter: Label = %BadgesCounter if has_node("%BadgesCounter") else null
@onready var badges_container: VBoxContainer = %BadgesContainer if has_node("%BadgesContainer") else null

var is_animating: bool = false

# Badge card style resources for locked/unlocked
var style_locked: StyleBoxFlat = null
var style_unlocked: StyleBoxFlat = null

func _ready() -> void:
	_ensure_nodes()
	if btn_close and not btn_close.pressed.is_connected(close):
		btn_close.pressed.connect(close)
	if backdrop and not backdrop.gui_input.is_connected(_on_backdrop_gui_input):
		backdrop.gui_input.connect(_on_backdrop_gui_input)

	# Pre-build unlocked style (cyan glow border)
	style_unlocked = StyleBoxFlat.new()
	style_unlocked.bg_color = Color(0.04, 0.1, 0.18, 0.95)
	style_unlocked.border_width_left = 2
	style_unlocked.border_width_top = 2
	style_unlocked.border_width_right = 2
	style_unlocked.border_width_bottom = 2
	style_unlocked.border_color = Color(0.2, 1.0, 0.5, 0.9)
	style_unlocked.corner_radius_top_left = 8
	style_unlocked.corner_radius_top_right = 8
	style_unlocked.corner_radius_bottom_right = 8
	style_unlocked.corner_radius_bottom_left = 8
	style_unlocked.shadow_color = Color(0.2, 1.0, 0.5, 0.3)
	style_unlocked.shadow_size = 10

	style_locked = StyleBoxFlat.new()
	style_locked.bg_color = Color(0.05, 0.09, 0.16, 0.9)
	style_locked.border_width_left = 1
	style_locked.border_width_top = 1
	style_locked.border_width_right = 1
	style_locked.border_width_bottom = 1
	style_locked.border_color = Color(0, 0.6, 0.8, 0.45)
	style_locked.corner_radius_top_left = 8
	style_locked.corner_radius_top_right = 8
	style_locked.corner_radius_bottom_right = 8
	style_locked.corner_radius_bottom_left = 8

	refresh_badges()

func _ensure_nodes() -> void:
	if backdrop == null: backdrop = get_node_or_null("%Backdrop")
	if modal_panel == null: modal_panel = get_node_or_null("%ModalPanel")
	if btn_close == null: btn_close = get_node_or_null("%BtnClose")
	if badges_counter == null: badges_counter = get_node_or_null("%BadgesCounter")
	if badges_container == null: badges_container = get_node_or_null("%BadgesContainer")

func refresh_badges(game_stats: Dictionary = {}, history: Array[Dictionary] = []) -> void:
	_ensure_nodes()
	if not badges_container:
		return

	var all_badges = BadgesData.get_all_badges()
	var unlocked_count: int = 0

	# Use BadgeManager singleton for unlock state (primary source of truth)
	var use_manager: bool = Engine.has_singleton("BadgeManager") or get_node_or_null("/root/BadgeManager") != null
	var manager_node: Node = get_node_or_null("/root/BadgeManager")

	for i in range(mini(all_badges.size(), badges_container.get_child_count())):
		var card_node = badges_container.get_child(i)
		var badge_data = all_badges[i]
		var is_unlocked: bool = false

		if manager_node and manager_node.has_method("is_unlocked"):
			is_unlocked = manager_node.is_unlocked(badge_data["id"])
		else:
			# Fallback to static evaluation
			is_unlocked = _evaluate_badge_fallback(badge_data["id"], game_stats, history)

		if is_unlocked:
			unlocked_count += 1

		_update_badge_card(card_node, badge_data, is_unlocked)

	if badges_counter:
		badges_counter.text = "ACHIEVED: %d OF %d" % [unlocked_count, all_badges.size()]

func _evaluate_badge_fallback(badge_id: String, stats: Dictionary, history: Array[Dictionary]) -> bool:
	var completed: int = stats.get("events_completed", 0)
	var health: int = stats.get("health", 0)
	var radiation: float = float(stats.get("radiation", 0.0))

	match badge_id:
		"badge_solar_shield":
			return completed >= 8
		"badge_flight_surgeon":
			return completed >= 14 and health >= 70
		"badge_dosimetry_master":
			return completed >= 18 and radiation < 40.0
		"badge_martian_botanist":
			return completed >= 24
		"badge_stem_scholar":
			return completed >= 27 and stats.get("score", 0) >= 3
		"badge_mars_commander":
			return completed >= 30 and (health >= 60 and radiation < 80.0)
		_:
			return false

func _update_badge_card(card: Node, data: Dictionary, is_unlocked: bool) -> void:
	var icon_lbl: Label = card.find_child("Icon", true, false)
	var title_lbl: Label = card.find_child("Title", true, false)
	var cat_lbl: Label = card.find_child("Category", true, false)
	var desc_lbl: Label = card.find_child("Desc", true, false)
	var status_lbl: Label = card.find_child("Status", true, false)

	if icon_lbl: icon_lbl.text = data.get("icon", "🏆")
	if title_lbl: title_lbl.text = data.get("title", "")
	if cat_lbl: cat_lbl.text = data.get("category", "")
	if desc_lbl:
		desc_lbl.text = data.get("desc", "")
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	if status_lbl:
		if is_unlocked:
			status_lbl.text = "★ UNLOCKED"
			status_lbl.modulate = Color(0.3, 1.0, 0.5, 1.0)  # Green glow
			if card is PanelContainer and style_unlocked:
				card.add_theme_stylebox_override("panel", style_unlocked)
			if card is Control:
				card.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			status_lbl.text = "🔒 LOCKED"
			status_lbl.modulate = Color(0.6, 0.7, 0.8, 0.7)
			if card is PanelContainer and style_locked:
				card.add_theme_stylebox_override("panel", style_locked)
			if card is Control:
				card.modulate = Color(0.85, 0.9, 0.95, 0.8)

func animate_unlock_card(badge_id: String) -> void:
	## Called when a badge is freshly unlocked — scale-pop the matching card
	if not badges_container or not visible:
		return
	var all_badges = BadgesData.get_all_badges()
	for i in range(mini(all_badges.size(), badges_container.get_child_count())):
		if all_badges[i]["id"] == badge_id:
			var card = badges_container.get_child(i)
			_update_badge_card(card, all_badges[i], true)
			# Scale-pop animation
			if card is Control:
				card.pivot_offset = card.size / 2.0
				var tween = create_tween()
				tween.tween_property(card, "scale", Vector2(1.08, 1.08), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
				tween.tween_property(card, "scale", Vector2(1.0, 1.0), 0.12)
			break
	# Update counter
	refresh_badges()

func open(game_stats: Dictionary = {}, history: Array[Dictionary] = []) -> void:
	_ensure_nodes()
	refresh_badges(game_stats, history)
	visible = true
	is_animating = true

	if backdrop:
		backdrop.modulate.a = 0.0
		var tween_bg = create_tween()
		tween_bg.tween_property(backdrop, "modulate:a", 1.0, 0.25)

	if modal_panel:
		modal_panel.modulate.a = 0.0
		modal_panel.scale = Vector2(0.9, 0.9)
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

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel"):
		close()
		if get_viewport():
			get_viewport().set_input_as_handled()

func _on_backdrop_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		close()
