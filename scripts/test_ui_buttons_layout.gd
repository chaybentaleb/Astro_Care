extends SceneTree

func _init() -> void:
	print("==================================================")
	print("TESTING SCI-FI UI BUTTONS & PLACEHOLDER HOOKS...")
	print("==================================================")

	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag: IntroDialogue = diag_scene.instantiate()
	root.add_child(diag)
	diag._ensure_nodes()

	# 1. Test Center Menu Buttons
	var action_center = diag.get_node_or_null("%ActionButtonsCenter")
	var btn_start: Button = diag.get_node_or_null("%BtnStartMission")
	var btn_how: Button = diag.get_node_or_null("%BtnHowToPlay")

	assert(action_center != null, "ActionButtonsCenter missing")
	assert(btn_start != null, "BtnStartMission missing")
	assert(btn_how != null, "BtnHowToPlay missing")

	print("Center Buttons: '%s' | '%s'" % [btn_start.text, btn_how.text])
	assert(btn_start.text == "START MISSION ▶", "BtnStartMission text mismatch")
	assert(btn_how.text == "HOW TO PLAY ❓", "BtnHowToPlay text mismatch")

	# Verify matching StyleBoxFlat on center buttons
	var style_start: StyleBoxFlat = btn_start.get_theme_stylebox("normal")
	var style_how: StyleBoxFlat = btn_how.get_theme_stylebox("normal")
	assert(style_start != null and style_how != null, "Center buttons must have normal StyleBoxFlat")
	print("Center Button Border Color: %s" % style_start.border_color.to_html(false))
	assert(style_start.border_color.to_html(false).begins_with("00d4"), "Start button border must be #00D4FF")
	assert(style_how.border_color.to_html(false).begins_with("00d4"), "How button border must be #00D4FF")
	print("✓ Center menu buttons match glowing cyan #00D4FF styling!")

	# 2. Test Top-Right Utility Buttons
	var btn_encyclopedia: Button = diag.get_node_or_null("%BtnEncyclopedia")
	var btn_badges: Button = diag.get_node_or_null("%BtnBadges")

	assert(btn_encyclopedia != null, "BtnEncyclopedia missing in top-right HUD")
	assert(btn_badges != null, "BtnBadges missing in top-right HUD")

	print("Top-Right Buttons: '%s' | '%s'" % [btn_encyclopedia.text, btn_badges.text])
	assert(btn_encyclopedia.text == "📚 ENCYCLOPEDIA", "BtnEncyclopedia text mismatch")
	assert(btn_badges.text == "🏆 BADGES", "BtnBadges text mismatch")

	# Verify signal connections and placeholder execution
	assert(btn_encyclopedia.pressed.is_connected(diag._on_encyclopedia_pressed), "BtnEncyclopedia must be connected")
	assert(btn_badges.pressed.is_connected(diag._on_badges_pressed), "BtnBadges must be connected")

	# Execute placeholder hooks to confirm safe no-op
	diag._on_encyclopedia_pressed()
	diag._on_badges_pressed()
	print("✓ Top-right button hooks safely connected with empty placeholder methods!")

	# 3. Test Step Advance & Signal Emission
	diag.handle_advance()
	assert(action_center.visible == true, "ActionButtonsCenter must be visible on step 1")

	var signal_box = [false]
	diag.intro_finished.connect(func(): signal_box[0] = true)
	diag._on_start_mission_pressed()
	assert(signal_box[0] == true, "BtnStartMission must emit intro_finished")
	print("✓ 'START MISSION ▶' correctly emits intro_finished transition signal!")

	# 4. Test How to Play Modal
	var modal: PanelContainer = diag.get_node_or_null("%HowToPlayModal")
	assert(modal != null, "HowToPlayModal missing")
	diag._on_how_to_play_pressed()
	assert(modal.visible == true, "HowToPlayModal must open on click")
	diag._on_close_modal_pressed()
	assert(modal.visible == false, "HowToPlayModal must close on close")
	print("✓ How to Play modal open/close functions verified!")

	diag.queue_free()

	print("==================================================")
	print("ALL SCI-FI UI BUTTONS & HOOKS VERIFIED!")
	print("==================================================")
	quit()
