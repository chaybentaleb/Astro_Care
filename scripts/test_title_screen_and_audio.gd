extends SceneTree

func _init() -> void:
	_run_tests()

func _run_tests() -> void:
	print("==================================================")
	print("TESTING TITLE SCREEN OVERLAY & AUDIO STATE CONTROL...")
	print("==================================================")

	var diag_scene = load("res://scenes/dialogue.tscn")
	assert(diag_scene != null, "Failed to load scenes/dialogue.tscn")
	var diag = diag_scene.instantiate()
	root.add_child(diag)

	await process_frame
	await process_frame

	# 1. Verify Initial Title Screen Nodes
	var title_screen: Control = diag.get_node_or_null("%TitleScreen")
	assert(title_screen != null, "TitleScreen node (%TitleScreen) missing")
	assert(title_screen.visible == true, "TitleScreen must be visible on start")

	var btn_enter: Button = diag.get_node_or_null("%BtnEnterStation")
	assert(btn_enter != null, "BtnEnterStation node missing")
	assert(btn_enter.mouse_filter == Control.MOUSE_FILTER_STOP, "BtnEnterStation mouse_filter must be STOP (0)")
	assert("ENTER ARES-4 STATION" in btn_enter.text, "BtnEnterStation text expected")
	print("✓ %TitleScreen and %BtnEnterStation verified.")

	var emblem = title_screen.find_child("EmblemLabel", true, false)
	assert(emblem != null and "ARES-4" in emblem.text, "ARES-4 emblem missing")

	var main_title = title_screen.find_child("MainTitleLabel", true, false)
	assert(main_title != null and main_title.text == "ASTRO_CARE", "Main title ASTRO_CARE missing")

	var subtitle = title_screen.find_child("SubtitleLabel", true, false)
	assert(subtitle != null and "MARS SURVIVAL" in subtitle.text, "Subtitle missing")

	var telemetry = title_screen.find_child("TelemetryLabel", true, false)
	assert(telemetry != null and "LIVE TELEMETRY" in telemetry.text, "Telemetry label missing")
	print("✓ Holographic emblem, glowing title, subtitle, and live telemetry badge verified.")

	# 2. Verify Hidden Elements on Initial Title Screen
	var dialogue_anchor: Control = diag.get_node_or_null("IntroControl/DialogueAnchor")
	var crew_section: Control = diag.get_node_or_null("%CrewSection")
	var action_buttons: Control = diag.get_node_or_null("%ActionButtonsCenter")
	assert(dialogue_anchor.visible == false, "DialogueAnchor must be hidden on Title Screen")
	assert(crew_section.visible == false, "CrewSection must be hidden on Title Screen")
	assert(action_buttons.visible == false, "ActionButtonsCenter must be hidden on Title Screen")
	print("✓ Storytelling box, crew section, and menu buttons are correctly hidden on Title Screen.")

	# 3. Verify Background Music on Title Screen
	var music_player: AudioStreamPlayer = diag.get_node_or_null("%MusicPlayer")
	assert(music_player != null, "MusicPlayer node missing")
	assert(diag.sfx_music_space != null, "Music asset failed to load")
	assert(music_player.playing == true, "Background music should be playing on Title Screen")
	assert(diag.current_phase == "title", "Initial phase must be 'title'")
	print("✓ Background music is actively playing in loop on Title Screen.")

	# 4. Verify Random Clicks do NOT advance while on Title Screen
	var random_click = InputEventMouseButton.new()
	random_click.button_index = MOUSE_BUTTON_LEFT
	random_click.pressed = true
	diag._input(random_click)
	assert(diag.current_phase == "title", "Phase should remain 'title' after random click")
	assert(title_screen.visible == true, "TitleScreen should remain visible after random click")
	print("✓ Non-button clicks safely ignored during Title Screen state.")

	# 5. Click ENTER ARES-4 STATION
	print("\nClicking 'ENTER ARES-4 STATION ▶'...")
	diag._on_enter_station_pressed()
	await create_timer(0.7).timeout

	assert(diag.current_phase == "intro", "Phase must transition to 'intro'")
	assert(title_screen.visible == false, "TitleScreen must be hidden after entering station")
	assert(dialogue_anchor.visible == true, "DialogueAnchor must be visible in intro phase")
	assert(music_player.playing == false, "Music must be stopped so typewriter effects are clear")
	print("✓ Music smoothly faded out/stopped, TitleScreen hidden, Storytelling Step 1 initiated.")

	# 6. Test Music Fade-in on Menu reveal
	print("\nTesting Menu Transition & Music Resumption...")
	diag._transition_to_menu()
	await create_timer(0.3).timeout

	assert(diag.current_phase == "menu", "Phase must be 'menu'")
	assert(action_buttons.visible == true, "ActionButtonsCenter must be visible in menu phase")
	assert(music_player.playing == true, "Music should resume playing on Menu state")
	print("✓ Action buttons revealed and background music smoothly faded back in.")

	# 7. Test START MISSION Music Fade-out
	print("\nTesting 'START MISSION ▶' Music Fade-out...")
	diag._on_start_mission_pressed()
	await diag.intro_finished

	assert(music_player.playing == false, "Music must be stopped on transition to mission")
	print("✓ Music faded out completely and intro_finished emitted successfully.")

	# Cleanup
	diag.queue_free()
	print("\n==================================================")
	print("ALL TITLE SCREEN & AUDIO STATE TESTS PASSED!")
	print("==================================================")
	quit()
