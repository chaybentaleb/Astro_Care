extends SceneTree

func _init() -> void:
	print("==================================================")
	print("TESTING TASK 3/3: FLYING CARDS TWEEN & HUD INTEGRATION...")
	print("==================================================")

	# 1. Load EncyclopediaModal Scene
	var modal_scene = load("res://scenes/EncyclopediaModal.tscn")
	assert(modal_scene != null, "Failed to load scenes/EncyclopediaModal.tscn")
	var modal: EncyclopediaModal = modal_scene.instantiate()
	root.add_child(modal)
	modal._ensure_nodes()

	# 1.1 Verify CARDS_DATA tracking & Initial State
	assert(modal.current_cards.size() == 19, "Must have 19 cards loaded from CARDS_DATA, got %d" % modal.current_cards.size())
	assert(modal.current_index == 0, "Initial card index must be 0")
	assert(modal.is_animating == false, "is_animating must initially be false")
	assert("1 / 19" in modal.card_counter.text or "CARD 1 OF 19" in modal.card_counter.text, "Initial counter mismatch: %s" % modal.card_counter.text)
	print("✓ Card data tracking verified: 19 cards loaded, starting at index 0.")

	# 1.2 Test Navigation: NEXT button wrap-around
	modal.current_index = 18 # Card 19
	modal._display_card_data(18)
	assert("19 / 19" in modal.card_counter.text or "19 OF 19" in modal.card_counter.text, "Card 19 counter check")
	
	modal.next_card() # Should wrap to 0 (Card 1)
	assert(modal.current_index == 0, "next_card() from card 19 must wrap to 0, got %d" % modal.current_index)
	print("✓ NEXT wrap-around verified: Card 19 -> Card 1.")

	# 1.3 Test Navigation: PREVIOUS button wrap-around
	modal.current_index = 0
	modal.prev_card() # Should wrap to 18 (Card 19)
	assert(modal.current_index == 18, "prev_card() from card 1 must wrap to 18, got %d" % modal.current_index)
	print("✓ PREVIOUS wrap-around verified: Card 1 -> Card 19.")

	# 1.4 Test Direct Card Click Interaction (_on_card_gui_input)
	modal.current_index = 0
	modal._display_card_data(0)
	var click_event = InputEventMouseButton.new()
	click_event.button_index = MOUSE_BUTTON_LEFT
	click_event.pressed = true
	modal._on_card_gui_input(click_event)
	assert(modal.current_index == 1, "Clicking card must advance to next card (index 1), got %d" % modal.current_index)
	print("✓ Direct card click interaction verified: advancing via _on_card_gui_input().")

	# 1.5 Test Animation Lock (is_animating guard)
	modal.is_animating = true
	var prev_idx = modal.current_index
	modal.next_card()
	assert(modal.current_index == prev_idx, "next_card() must be blocked when is_animating == true")
	modal.prev_card()
	assert(modal.current_index == prev_idx, "prev_card() must be blocked when is_animating == true")
	modal._on_card_gui_input(click_event)
	assert(modal.current_index == prev_idx, "_on_card_gui_input must be blocked when is_animating == true")
	modal.is_animating = false
	print("✓ Animation lock guard verified: rapid clicks safely blocked during transitions.")

	modal.queue_free()

	# 2. Test Connection to Intro/Main Menu Scene & HUD Button
	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag = diag_scene.instantiate()
	root.add_child(diag)
	diag._ready()

	# Verify EncyclopediaModal instance exists and is hidden by default
	assert(diag.encyclopedia_instance != null, "EncyclopediaModal instance must be created in _ready()")
	assert(diag.encyclopedia_instance.visible == false, "EncyclopediaModal must start hidden (visible == false)")
	print("✓ EncyclopediaModal instanced in Intro/Main Menu and hidden by default.")

	# Verify clicking 📚 ENCYCLOPEDIA resets to card 0 and opens modal
	diag.encyclopedia_instance.current_index = 5
	var btn_enc: Button = diag.get_node_or_null("%BtnEncyclopedia")
	assert(btn_enc != null, "BtnEncyclopedia must be present in dialogue.tscn")
	assert("ENCYCLOPEDIA" in btn_enc.text, "BtnEncyclopedia text expected to contain ENCYCLOPEDIA")

	diag._on_encyclopedia_pressed()
	assert(diag.encyclopedia_instance.visible == true, "EncyclopediaModal must be visible after _on_encyclopedia_pressed()")
	assert(diag.encyclopedia_instance.current_index == 0, "current_index must reset to 0 upon pressing ENCYCLOPEDIA")
	assert("M1.9-class" in diag.encyclopedia_instance.fact_text.text, "Card 0 fact text must be displayed")
	print("✓ HUD button hook verified: resets to Card 0 and opens EncyclopediaModal with smooth fade-in!")

	diag.queue_free()

	print("==================================================")
	print("ALL TASK 3/3 TESTS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit(0)
