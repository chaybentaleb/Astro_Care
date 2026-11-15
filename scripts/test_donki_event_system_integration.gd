extends SceneTree

func _init() -> void:
	print("==================================================")
	print("TESTING DONKI EVENT SYSTEM INTEGRATION & UI HOOKS...")
	print("==================================================")

	var donki_scene = load("res://scenes/donki_event_system.tscn")
	assert(donki_scene != null, "Failed to load scenes/donki_event_system.tscn")
	var donki = donki_scene.instantiate()
	root.add_child(donki)

	# 1. Verify TopBanner buttons
	var btn_hint: Button = donki.get_node_or_null("%BtnHint")
	assert(btn_hint != null, "BtnHint node (%BtnHint) missing in donki_event_system.tscn")
	assert("HINT" in btn_hint.text, "BtnHint text expected to contain HINT")
	print("✓ %BtnHint found with text: '%s'" % btn_hint.text)

	var btn_enc: Button = donki.get_node_or_null("%BtnEncyclopedia")
	assert(btn_enc != null, "BtnEncyclopedia node (%BtnEncyclopedia) missing in donki_event_system.tscn")
	assert("ARCHIVES" in btn_enc.text or "ENCYCLOPEDIA" in btn_enc.text, "BtnEncyclopedia text expected")
	print("✓ %BtnEncyclopedia found with text: '%s'" % btn_enc.text)

	var btn_badges: Button = donki.get_node_or_null("%BtnBadges")
	assert(btn_badges != null, "BtnBadges node (%BtnBadges) missing in donki_event_system.tscn")
	assert("BADGES" in btn_badges.text, "BtnBadges text expected to contain BADGES")
	print("✓ %BtnBadges found with text: '%s'" % btn_badges.text)

	# 2. Verify BotAdvicePanel
	var bot_advice_panel: PanelContainer = donki.get_node_or_null("%BotAdvicePanel")
	assert(bot_advice_panel != null, "BotAdvicePanel node (%BotAdvicePanel) missing in donki_event_system.tscn")
	assert(bot_advice_panel.visible == false, "BotAdvicePanel must start hidden (visible == false)")
	print("✓ %BotAdvicePanel found and verified initially hidden.")

	var bot_advice_text: Label = donki.get_node_or_null("%BotAdviceText")
	assert(bot_advice_text != null, "BotAdviceText node missing in donki_event_system.tscn")

	var bot_icon: Label = donki.get_node_or_null("%BotIcon")
	assert(bot_icon != null, "BotIcon node missing in donki_event_system.tscn")
	print("✓ %BotIcon and %BotAdviceText verified.")

	# 3. Verify Hint Toggle Behavior
	donki._on_hint_pressed()
	assert(bot_advice_panel.visible == true, "BotAdvicePanel should be visible after _on_hint_pressed()")
	print("✓ Hint button toggle: hidden -> visible")

	donki._on_hint_pressed()
	assert(bot_advice_panel.visible == false, "BotAdvicePanel should be hidden after second _on_hint_pressed()")
	print("✓ Hint button toggle: visible -> hidden")

	# 4. Verify Encyclopedia Modal opening from in-game event screen
	assert(donki.encyclopedia_instance == null, "encyclopedia_instance should be null before first click")
	donki._on_encyclopedia_pressed()
	assert(donki.encyclopedia_instance != null, "encyclopedia_instance must be instantiated")
	assert(donki.encyclopedia_instance.visible == true, "EncyclopediaModal must be visible after open()")
	donki.encyclopedia_instance.close()
	assert(donki.encyclopedia_instance.visible == false, "EncyclopediaModal must be hidden after close()")
	print("✓ In-game Encyclopedia modal opening and closing verified!")

	# 5. Verify Badges Modal opening from in-game event screen
	assert(donki.badges_instance == null, "badges_instance should be null before first click")
	donki._on_badges_pressed()
	assert(donki.badges_instance != null, "badges_instance must be instantiated")
	assert(donki.badges_instance.visible == true, "BadgesModal must be visible after open()")
	donki.badges_instance.close()
	assert(donki.badges_instance.visible == false, "BadgesModal must be hidden after close()")
	print("✓ In-game Badges modal opening and closing verified!")

	donki.queue_free()

	print("==================================================")
	print("ALL DONKI EVENT SYSTEM INTEGRATION TESTS PASSED!")
	print("==================================================")
	quit(0)
