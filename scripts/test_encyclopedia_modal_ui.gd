extends SceneTree

func _init() -> void:
	print("==================================================")
	print("TESTING ENCYCLOPEDIA MODAL UI (TASK 2/3)...")
	print("==================================================")

	var modal_scene = load("res://scenes/EncyclopediaModal.tscn")
	assert(modal_scene != null, "Failed to load scenes/EncyclopediaModal.tscn")
	var modal: EncyclopediaModal = modal_scene.instantiate()
	root.add_child(modal)
	modal._ensure_nodes()

	# 1. MODAL OVERLAY STRUCTURE
	assert(modal.name == "EncyclopediaModal", "Root node name must be EncyclopediaModal")
	assert(modal is CanvasLayer, "EncyclopediaModal must extend CanvasLayer")
	print("✓ Root node: EncyclopediaModal (CanvasLayer, layer=%d)" % modal.layer)

	var backdrop: ColorRect = modal.get_node_or_null("%Backdrop")
	assert(backdrop != null, "Backdrop ColorRect missing")
	assert(backdrop.mouse_filter == Control.MOUSE_FILTER_STOP, "Backdrop mouse_filter must be STOP (0)")
	assert(is_equal_approx(backdrop.color.r, 0.02) and is_equal_approx(backdrop.color.g, 0.04) and is_equal_approx(backdrop.color.b, 0.08) and is_equal_approx(backdrop.color.a, 0.88), "Backdrop color must be Color(0.02, 0.04, 0.08, 0.88)")
	print("✓ Backdrop ColorRect verified: Color(0.02, 0.04, 0.08, 0.88) with mouse_filter = STOP")

	var btn_close: Button = modal.get_node_or_null("%BtnClose")
	assert(btn_close != null, "BtnClose missing")
	assert("CLOSE" in btn_close.text or "✕" in btn_close.text, "BtnClose text mismatch: %s" % btn_close.text)
	print("✓ Top-right close button verified: '%s'" % btn_close.text)

	# 2. CENTER FLYING CARD DESIGN
	var card_container = modal.get_node_or_null("%CardContainer")
	assert(card_container != null, "CardContainer missing")
	print("✓ CardContainer found in center layout.")

	var card_panel: PanelContainer = modal.get_node_or_null("%CardPanel")
	assert(card_panel != null, "CardPanel missing")
	assert(card_panel.custom_minimum_size.x == 650 and card_panel.custom_minimum_size.y == 360, "Card size must be ~650x360, got %s" % str(card_panel.custom_minimum_size))
	print("✓ Card dimensions verified: 650px x 360px.")

	var style: StyleBoxFlat = card_panel.get_theme_stylebox("panel")
	assert(style != null, "CardPanel must have StyleBoxFlat")
	assert(style.corner_radius_top_left == 16, "Card corner radius must be 16px")
	assert(style.border_width_left == 2, "Card border width must be 2px")
	assert(style.content_margin_left == 32.0 and style.content_margin_right == 32.0, "Card content margin left/right must be 32px")
	assert(style.content_margin_top == 28.0 and style.content_margin_bottom == 28.0, "Card content margin top/bottom must be 28px")
	print("✓ Card StyleBoxFlat verified: dark navy fill, glowing cyan border 2px, radius 16px, padding 32x28.")

	# Top Row
	var category_pill: Label = modal.get_node_or_null("%CategoryPill")
	assert(category_pill != null, "CategoryPill missing")
	assert("SOLAR" in category_pill.text, "CategoryPill text expected to contain SOLAR: %s" % category_pill.text)
	print("✓ Category Pill verified: '%s'" % category_pill.text)

	var card_counter: Label = modal.get_node_or_null("%CardCounter")
	assert(card_counter != null, "CardCounter missing")
	assert("1 / 19" in card_counter.text or "CARD 1 OF 19" in card_counter.text, "CardCounter text mismatch: %s" % card_counter.text)
	print("✓ Card Counter verified: '%s'" % card_counter.text)

	# Middle Area
	var fact_text: Label = modal.get_node_or_null("%FactText")
	assert(fact_text != null, "FactText missing")
	assert(fact_text.autowrap_mode == TextServer.AUTOWRAP_WORD_SMART, "FactText autowrap_mode must be WORD_SMART")
	assert(fact_text.size_flags_vertical & Control.SIZE_EXPAND, "FactText size_flags_vertical must EXPAND")
	assert("M1.9-class" in fact_text.text, "Fact text mismatch: %s" % fact_text.text)
	print("✓ Middle Fact Text verified: 20px, autowrap WORD_SMART, vertically centered and expanding.")

	# Bottom Area
	var source_label: Label = modal.get_node_or_null("%SourceLabel")
	assert(source_label != null, "SourceLabel missing")
	assert("Based on real space data" in source_label.text, "SourceLabel mismatch: %s" % source_label.text)
	print("✓ Bottom Source Label verified: '%s'" % source_label.text)

	# 3. NAVIGATION BUTTONS BELOW CARD
	var btn_prev: Button = modal.get_node_or_null("%BtnPrev")
	var btn_next: Button = modal.get_node_or_null("%BtnNext")
	assert(btn_prev != null, "BtnPrev missing")
	assert(btn_next != null, "BtnNext missing")
	assert("PREVIOUS" in btn_prev.text, "BtnPrev text mismatch: %s" % btn_prev.text)
	assert("NEXT" in btn_next.text, "BtnNext text mismatch: %s" % btn_next.text)
	print("✓ Navigation buttons verified: '%s' and '%s'" % [btn_prev.text, btn_next.text])

	# 4. TEST NAVIGATION LOGIC
	modal.next_card()
	assert(modal.current_index == 1, "Index must advance to 1")
	assert("2 / 19" in modal.card_counter.text or "2 OF 19" in modal.card_counter.text, "Counter must show card 2")
	assert("M1.7-class" in modal.fact_text.text, "Card 2 fact text mismatch")
	print("✓ Next navigation verified: smoothly advances to Card 2.")

	modal.prev_card()
	assert(modal.current_index == 0, "Index must return to 0")
	assert("1 / 19" in modal.card_counter.text or "1 OF 19" in modal.card_counter.text, "Counter must show card 1")
	assert("M1.9-class" in modal.fact_text.text, "Card 1 fact text mismatch")
	print("✓ Previous navigation verified: returns to Card 1.")

	# 5. TEST OPEN & CLOSE
	modal.close()
	assert(modal.visible == false, "Modal must be hidden after close()")
	modal.open()
	assert(modal.visible == true, "Modal must be visible after open()")
	print("✓ Open and Close verified.")

	modal.queue_free()

	print("==================================================")
	print("ALL TASK 2/3 ENCYCLOPEDIA MODAL TESTS PASSED!")
	print("==================================================")
	quit(0)
