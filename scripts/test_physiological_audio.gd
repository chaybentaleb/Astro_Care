extends SceneTree

func _init() -> void:
	_run_tests()

func _run_tests() -> void:
	print("==================================================")
	print("TESTING PHYSIOLOGICAL & FAILURE AUDIO SYSTEMS...")
	print("==================================================")

	var donki_scene = load("res://scenes/donki_event_system.tscn")
	assert(donki_scene != null, "Failed to load scenes/donki_event_system.tscn")
	var donki = donki_scene.instantiate()
	root.add_child(donki)

	await process_frame
	await process_frame

	# 1. Verify AudioStreamPlayer nodes exist
	assert(donki.heartbeat_audio != null, "HeartbeatAudio node missing")
	assert(donki.breathing_audio != null, "BreathingAudio node missing")
	assert(donki.failure_audio != null, "FailureAudio node missing")
	print("✓ AudioStreamPlayer nodes found: HeartbeatAudio, BreathingAudio, FailureAudio")

	# 2. Verify Audio assets loaded
	assert(donki.sfx_heartbeat != null, "Heartbeat audio asset failed to load")
	assert(donki.sfx_breathing != null, "Breathing audio asset failed to load")
	assert(donki.sfx_failure != null, "Failure audio asset failed to load")
	print("✓ Audio assets loaded successfully: Heartbeat, Breathing, Failure")

	# 3. Test Heartbeat on Low Health (<= 25%)
	print("\nTesting Heartbeat Audio on Health <= 25%...")
	donki._on_resources_changed({"health": 20, "oxygen": 60, "energy": 50, "shield": 50, "radiation": 10.0, "food": 30, "water": 50}, {"health": -10})
	assert(donki.is_heartbeat_playing == true, "Heartbeat should be playing when health <= 25%")
	assert(donki.heartbeat_audio.playing == true, "HeartbeatAudio should be active")
	print("✓ Heartbeat started playing on low health (20%)")

	# Test Heartbeat stops when Health recovers (> 25%)
	donki._on_resources_changed({"health": 60, "oxygen": 60, "energy": 50, "shield": 50, "radiation": 10.0, "food": 30, "water": 50}, {"health": 40})
	assert(donki.is_heartbeat_playing == false, "Heartbeat flag should be false when health > 25%")
	print("✓ Heartbeat fading out / stopping on health recovery (60%)")

	# 4. Test Heavy Breathing on Low Oxygen (<= 25%)
	print("\nTesting Breathing Audio on Oxygen <= 25%...")
	donki._on_resources_changed({"health": 70, "oxygen": 15, "energy": 50, "shield": 50, "radiation": 10.0, "food": 30, "water": 50}, {"oxygen": -35})
	assert(donki.is_breathing_playing == true, "Breathing should be playing when oxygen <= 25%")
	assert(donki.breathing_audio.playing == true, "BreathingAudio should be active")
	print("✓ Breathing started playing on low oxygen (15%)")

	# Test Breathing stops when Oxygen recovers (> 25%)
	donki._on_resources_changed({"health": 70, "oxygen": 55, "energy": 50, "shield": 50, "radiation": 10.0, "food": 30, "water": 50}, {"oxygen": 40})
	assert(donki.is_breathing_playing == false, "Breathing flag should be false when oxygen > 25%")
	print("✓ Breathing fading out / stopping on oxygen recovery (55%)")

	# 5. Test Mission Failed: stops looping physiological audio and triggers failure audio
	print("\nTesting Game Over / Mission Failed audio handling...")
	# Start both sounds
	donki._start_heartbeat()
	donki._start_breathing()
	assert(donki.heartbeat_audio.playing == true, "Heartbeat started for test")
	assert(donki.breathing_audio.playing == true, "Breathing started for test")

	# Trigger Game Over
	var stats = donki.game_manager.get_stats()
	donki._on_game_over("CRITICAL FAILURE: Atmospheric oxygen exhausted!", stats)

	assert(donki.is_heartbeat_playing == false, "Heartbeat should be stopped on game over")
	assert(donki.is_breathing_playing == false, "Breathing should be stopped on game over")
	assert(donki.heartbeat_audio.playing == false, "Heartbeat audio player should be stopped")
	assert(donki.breathing_audio.playing == false, "Breathing audio player should be stopped")
	assert(donki.failure_audio.playing == true, "FailureAudio should be playing on game over")
	print("✓ Looping physiological sounds stopped immediately on game over")
	print("✓ FailureAudio played simultaneously with game over panel")

	# Cleanup
	donki.queue_free()
	print("\n==================================================")
	print("ALL PHYSIOLOGICAL & FAILURE AUDIO TESTS PASSED!")
	print("==================================================")
	quit()
