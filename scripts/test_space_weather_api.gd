extends SceneTree

## Comprehensive Verification Test for SpaceWeatherAPI
## Tests: Autoload initialization, HTTPRequest configuration, parsing logic,
## dynamic game & encyclopedia injection, and graceful fallback to AstrobotEventsData.

func _init() -> void:
	print("==================================================")
	print("STARTING TEST: SpaceWeatherAPI REAL-TIME SYSTEM")
	print("==================================================")

	var api_script = load("res://scripts/SpaceWeatherAPI.gd")
	assert(api_script != null, "SpaceWeatherAPI.gd failed to load")
	var api = api_script.new()
	root.add_child(api)

	# 1. TEST CONFIGURATION & INITIALIZATION
	print("\n--- 1. Testing API Manager Configuration ---")
	assert(api.API_KEY == "LmfRrHHGtFGTT6RgTBzKnkLwKMWjkkGq9nB8PMrP", "API Key mismatch")
	assert(api.BASE_URL == "https://api.nasa.gov/DONKI/", "Base URL mismatch")
	assert(api.is_using_fallback == true, "Must default to fallback on startup")
	assert(api.is_live_data_available == false, "Live data must be false initially")
	
	api._init_http_node()
	assert(api.http_node != null, "HTTPRequest node must be created")
	assert(api.http_node is HTTPRequest, "http_node must be HTTPRequest instance")
	assert(api.http_node.timeout > 0, "HTTPRequest must have positive timeout")
	print("✓ SpaceWeatherAPI initialized with correct NASA endpoint & API Key.")
	print("✓ HTTPRequest child node correctly created with timeout = %.1fs." % api.http_node.timeout)

	# 2. TEST ERROR HANDLING & FALLBACK (AstrobotEventsData)
	print("\n--- 2. Testing Graceful Fallback Handling ---")
	var fallback_signal_received: Array[bool] = [false]
	api.fallback_activated.connect(func(reason): fallback_signal_received[0] = true)
	
	# Simulate rate limit 429
	api._on_request_completed(HTTPRequest.RESULT_SUCCESS, 429, PackedStringArray(), PackedByteArray())
	assert(fallback_signal_received[0] == true, "Must emit fallback_activated on HTTP 429")
	assert(api.is_live_data_available == false, "Live data must remain false on rate limit")
	assert(api.is_using_fallback == true, "Fallback mode must be active on rate limit")
	
	# Verify offline event database is intact and functional
	var offline_ev1 = AstrobotEventsData.get_event(1)
	assert(not offline_ev1.is_empty(), "AstrobotEventsData event 1 must exist")
	assert(offline_ev1.category == "DONKI", "Event 1 category must be DONKI")
	var offline_dialogue = AstrobotEventsData.get_dialogue(1)
	assert("Commander! Small solar flare detected!" in offline_dialogue, "Offline dialogue must remain intact")
	print("✓ Fallback activated smoothly on simulated rate limit (HTTP 429).")
	print("✓ AstrobotEventsData offline database completely preserved without crashing.")

	# 3. TEST JSON PARSING OF NASA DONKI PAYLOAD
	print("\n--- 3. Testing JSON Parsing of DONKI Space Weather Notifications ---")
	var sample_donki_notifications: Array = [
		{
			"messageType": "CME",
			"messageID": "20261110-AL-001",
			"messageIssueTime": "2026-11-10T13:06Z",
			"messageBody": "## Summary:\nC-type CME detected by GOES.\nStart time of the event: 2026-11-09T18:15Z.\nEstimated speed: ~726 km/s.\nDirection: 65/-2.\nImpact targets: STEREO A, Mars (glancing blow), Psyche."
		},
		{
			"messageType": "FLR",
			"messageID": "20261108-FLR-001",
			"messageIssueTime": "2026-11-08T07:33Z",
			"messageBody": "## Summary:\nM1.9-class solar flare observed peaking at 18:42 UTC from active region AR-3412."
		},
		{
			"messageType": "GST",
			"messageID": "20261031-GST-001",
			"messageIssueTime": "2026-10-31T18:00Z",
			"messageBody": "## Summary:\nGeomagnetic storm active. Kp index = 6.0 reported by NOAA."
		},
		{
			"messageType": "RBE",
			"messageID": "20261108-AL-001",
			"messageIssueTime": "2026-11-08T21:18Z",
			"messageBody": "## Summary:\nRadiation Belt Enhancement alert."
		}
	]

	var parsed = api.parse_donki_notifications(sample_donki_notifications)
	assert(parsed.cme.speed == 726, "CME speed must parse to 726 km/s, got %d" % parsed.cme.speed)
	assert("Mars" in parsed.cme.target_locations, "CME targets must include Mars")
	assert(parsed.solar_flare.class_type == "M1.9", "Flare class must parse to M1.9, got %s" % parsed.solar_flare.class_type)
	assert(parsed.geomagnetic_storm.kp_index == 6.0, "Storm Kp must parse to 6.0, got %f" % parsed.geomagnetic_storm.kp_index)
	assert(parsed.rbe.message_id == "20261108-AL-001", "RBE message ID mismatch")
	print("✓ Real-time parameters extracted: Flare=%s, CME Speed=%d km/s, Storm Kp=%.1f, Targets=%s" % [
		parsed.solar_flare.class_type,
		parsed.cme.speed,
		parsed.geomagnetic_storm.kp_index,
		str(parsed.cme.target_locations)
	])

	# 4. TEST DYNAMIC INJECTION INTO GAME EVENTS
	print("\n--- 4. Testing Dynamic Injection into Game Event Generator ---")
	api.apply_live_data(parsed)
	assert(api.is_live_data_available == true, "Live data state must be true after apply")
	assert(api.is_using_fallback == false, "Fallback must be false after applying live data")

	var default_events = DonkiEvents.get_all_events()
	var injected_events = api.inject_into_donki_events(default_events)
	
	# Verify Event 1 (Solar Flare)
	var ev1 = injected_events[0]
	assert("FLR-M1.9" in ev1.donki_code, "Event 1 code must reflect live flare: %s" % ev1.donki_code)
	assert("Class M1.9" in ev1.scenario, "Event 1 scenario must reflect live flare: %s" % ev1.scenario)
	
	# Verify Event 3 (CME)
	var ev3 = injected_events[2]
	assert("726 km/s" in ev3.donki_code, "Event 3 code must reflect live CME speed: %s" % ev3.donki_code)
	assert("726 km/s" in ev3.scenario, "Event 3 scenario must reflect live CME speed")
	assert("Mars" in ev3.scenario, "Event 3 scenario must reflect target locations")
	
	# Verify Event 4 (Geomagnetic Storm)
	var ev4 = injected_events[3]
	assert("Kp 6.0" in ev4.donki_code, "Event 4 code must reflect live Kp index: %s" % ev4.donki_code)
	print("✓ Live data injected into Event 1 (FLR-M1.9), Event 3 (CME 726 km/s), Event 4 (GST Kp 6.0).")

	# 5. TEST DYNAMIC INJECTION INTO ENCYCLOPEDIA FACTS
	print("\n--- 5. Testing Dynamic Injection into Encyclopedia Facts ---")
	var enc_class = load("res://scripts/EncyclopediaData.gd")
	var cme_card = null
	for c in enc_class.CARDS_DATA:
		if c.id == "cme_20261109":
			cme_card = c
			break
	assert(cme_card != null, "CME card must exist in EncyclopediaData")
	assert("726 km/s" in cme_card.fact, "CME card fact must reflect live 726 km/s speed")
	print("✓ Encyclopedia CME card updated with live NASA telemetry: '%s'" % cme_card.fact)

	# 6. TEST ASTROBOT DIALOGUE DYNAMIC INTEGRATION
	print("\n--- 6. Testing Astrobot Live Dialogue Integration ---")
	var live_dialogue = AstrobotEventsData.get_dialogue(1)
	assert("Class M1.9" in live_dialogue, "Astrobot dialogue must reflect live flare: %s" % live_dialogue)
	print("✓ Astrobot live dialogue verified: '%s'" % live_dialogue)

	api.queue_free()
	print("\n==================================================")
	print("ALL SPACE WEATHER API & REAL-TIME TESTS PASSED! ✓")
	print("==================================================")
	quit(0)
