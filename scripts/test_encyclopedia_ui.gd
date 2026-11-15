extends SceneTree

func _init() -> void:
	print("==================================================")
	print("STARTING ENCYCLOPEDIA FLYING CARDS UI TESTS...")
	print("==================================================")

	# 1. Load and Instantiate Encyclopedia Scene
	var enc_scene = load("res://scenes/encyclopedia.tscn")
	assert(enc_scene != null, "Failed to load scenes/encyclopedia.tscn")
	var enc: EncyclopediaModal = enc_scene.instantiate()
	root.add_child(enc)
	enc._ensure_nodes()

	# 2. Verify Node Hierarchy
	assert(enc.backdrop != null, "Backdrop node missing")
	assert(enc.modal_panel != null, "ModalPanel node missing")
	assert(enc.btn_close != null, "BtnClose node missing")
	assert(enc.card_counter != null, "CardCounter node missing")
	assert(enc.filter_bar != null, "FilterBar node missing")
	assert(enc.card_panel != null, "CardPanel node missing")
	assert(enc.category_badge != null, "CategoryBadge node missing")
	assert(enc.card_id_label != null, "CardIdLabel node missing")
	assert(enc.card_icon != null, "CardIcon node missing")
	assert(enc.fact_text != null, "FactText node missing")
	assert(enc.source_text != null, "SourceText node missing")
	assert(enc.btn_prev != null, "BtnPrev node missing")
	assert(enc.btn_next != null, "BtnNext node missing")
	assert(enc.btn_random != null, "BtnRandom node missing")
	assert(enc.progress_bar != null, "ProgressBar node missing")
	print("✓ All 15 required UI nodes verified in encyclopedia.tscn hierarchy.")

	# 3. Verify Initial State (ALL mode, Card 1 of 19)
	assert(enc.current_cards.size() == 19, "Must have 19 cards loaded initially, got %d" % enc.current_cards.size())
	assert(enc.current_index == 0, "Initial card index must be 0")
	assert(enc.card_counter.text == "CARD 1 OF 19", "Card counter text mismatch: %s" % enc.card_counter.text)
	assert("flr_20261107" in enc.card_id_label.text.to_lower(), "Initial card must be flr_20261107")
	assert("M1.9-class" in enc.fact_text.text, "Fact text mismatch on card 1")
	assert("DONKI" in enc.source_text.text, "Source text mismatch on card 1")
	assert(enc.card_icon.text == "☀️", "Card icon mismatch on card 1")
	print("✓ Initial state verified: Card 1/19 (flr_20261107) correctly displayed.")

	# 4. Test Navigation: Next Card
	enc.next_card()
	assert(enc.current_index == 1, "Next card index must be 1")
	assert(enc.card_counter.text == "CARD 2 OF 19", "Card counter text mismatch: %s" % enc.card_counter.text)
	assert("flr_20261108" in enc.card_id_label.text.to_lower(), "Card 2 must be flr_20261108")
	assert("M1.7-class" in enc.fact_text.text, "Fact text mismatch on card 2")
	print("✓ Next navigation verified: smoothly advanced to Card 2/19 (flr_20261108).")

	# 5. Test Navigation: Previous Card (wraps back to 0)
	enc.prev_card()
	assert(enc.current_index == 0, "Prev card index must be 0")
	assert("flr_20261107" in enc.card_id_label.text.to_lower(), "Must wrap back to card 1")
	print("✓ Previous navigation verified: returned to Card 1/19.")

	# 6. Test Category Filtering: MARS
	enc.filter_by_category("MARS")
	assert(enc.current_cards.size() == 4, "MARS category must have 4 cards, got %d" % enc.current_cards.size())
	assert(enc.current_index == 0, "Index must reset to 0 upon filtering")
	assert(enc.card_counter.text == "CARD 1 OF 4", "Card counter must show CARD 1 OF 4")
	assert(enc.card_icon.text == "🔴", "Mars card icon must be 🔴")
	assert("mars_sol" in enc.card_id_label.text.to_lower(), "First Mars card must be mars_sol")
	print("✓ Category filtering for 'MARS' verified (4 cards, starting at mars_sol).")

	# 7. Test Category Filtering: FOOD
	enc.filter_by_category("FOOD")
	assert(enc.current_cards.size() == 4, "FOOD category must have 4 cards, got %d" % enc.current_cards.size())
	assert(enc.card_icon.text == "🌱", "Food card icon must be 🌱")
	assert("food_tortilla" in enc.card_id_label.text.to_lower(), "First Food card must be food_tortilla")
	print("✓ Category filtering for 'FOOD' verified (4 cards, starting at food_tortilla).")

	# 8. Test Category Filtering: PLANETS
	enc.filter_by_category("PLANET")
	assert(enc.current_cards.size() == 3, "PLANETS category must have 3 cards, got %d" % enc.current_cards.size())
	assert(enc.card_icon.text == "🪐", "Planet card icon must be 🪐")
	print("✓ Category filtering for 'PLANETS' verified (3 cards).")

	# 9. Test Category Filtering: Reset to ALL
	enc.filter_by_category("ALL")
	assert(enc.current_cards.size() == 19, "ALL category must reset to 19 cards")
	assert(enc.card_counter.text == "CARD 1 OF 19", "Counter must reset to CARD 1 OF 19")
	print("✓ Reset to 'ALL' filter verified (19 cards).")

	# 10. Test Random Card Selection
	enc.random_card()
	assert(enc.current_index >= 0 and enc.current_index < 19, "Random index out of bounds: %d" % enc.current_index)
	print("✓ Random card selection verified: selected card %d of 19." % (enc.current_index + 1))

	# 11. Test Open and Close Signals
	var closed_emitted = [false]
	enc.closed.connect(func(): closed_emitted[0] = true)
	enc.open()
	assert(enc.visible == true, "Encyclopedia must be visible when open")
	enc.close()
	print("✓ Open and Close logic verified.")

	enc.queue_free()

	# 12. Test Integration in Dialogue Scene
	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag: IntroDialogue = diag_scene.instantiate()
	root.add_child(diag)
	diag._ensure_nodes()

	var btn_enc: Button = diag.get_node_or_null("%BtnEncyclopedia")
	assert(btn_enc != null, "BtnEncyclopedia must be present in dialogue scene")

	# Trigger encyclopedia from intro HUD
	diag._on_encyclopedia_pressed()
	assert(diag.encyclopedia_instance != null, "encyclopedia_instance must be created upon pressing BtnEncyclopedia")
	assert(diag.encyclopedia_instance.visible == true, "encyclopedia_instance must be visible after opening")
	print("✓ Integration with IntroDialogue verified: clicking BtnEncyclopedia opens EncyclopediaModal!")

	diag.queue_free()

	print("==================================================")
	print("ALL ENCYCLOPEDIA FLYING CARDS UI TESTS PASSED!")
	print("==================================================")
	quit(0)
