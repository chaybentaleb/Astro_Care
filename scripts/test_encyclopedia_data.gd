extends SceneTree

const EncyclopediaDataClass = preload("res://scripts/EncyclopediaData.gd")

func _init() -> void:
	print("==================================================")
	print("STARTING VERIFICATION OF ENCYCLOPEDIA DATA...")
	print("==================================================")

	var cards: Array[Dictionary] = EncyclopediaDataClass.CARDS_DATA
	print("Total cards found: %d" % cards.size())
	assert(cards.size() == 19, "Must contain exactly 19 scientific fact cards! Got %d" % cards.size())
	print("✓ Exactly 19 cards verified.")

	var required_keys = ["id", "category", "icon", "fact", "source"]
	var seen_ids = {}

	var expected_cards = [
		{
			"id": "flr_20261107",
			"category": "☀️ SOLAR FLARES",
			"icon": "☀️",
			"fact": "On November 7, 2026, the Sun released an M1.9-class solar flare. It started at 18:21 UTC, peaked at 18:42 and ended at 18:56.",
			"source": "NASA DONKI (FLR 2026-11-07T18:21:00-FLR-001)"
		},
		{
			"id": "flr_20261108",
			"category": "☀️ SOLAR FLARES",
			"icon": "☀️",
			"fact": "On November 8, 2026, the Sun released an M1.7-class solar flare. It started at 07:33 UTC, peaked at 07:46 and ended at 07:54.",
			"source": "NASA DONKI (FLR 2026-11-08T07:33:00-FLR-001)"
		},
		{
			"id": "cme_20261108",
			"category": "💥 SOLAR ERUPTIONS",
			"icon": "💥",
			"fact": "On November 8, 2026, an eruption from the Sun (a CME) was measured at 367 km/s. Scientists used SOHO and STEREO A pictures to work out where it was heading.",
			"source": "NASA DONKI (CME 49459)"
		},
		{
			"id": "cme_20261109",
			"category": "💥 SOLAR ERUPTIONS",
			"icon": "💥",
			"fact": "On November 9, 2026, an eruption was measured at 726 km/s. A computer model predicted it would reach STEREO A on November 12, Mars on November 13 and Psyche on November 14.",
			"source": "NASA DONKI (CME 49468)"
		},
		{
			"id": "cme_20261111",
			"category": "💥 SOLAR ERUPTIONS",
			"icon": "💥",
			"fact": "An eruption that started on November 11, 2026 was measured at 367 km/s. The computer model predicted it would hit nothing.",
			"source": "NASA DONKI (CME 49505)"
		},
		{
			"id": "food_tortilla",
			"category": "🌱 FOOD IN SPACE",
			"icon": "🌱",
			"fact": "Astronauts often eat tortillas instead of bread, because bread makes crumbs that would float around and could get into equipment.",
			"source": "NASA"
		},
		{
			"id": "food_salt",
			"category": "🌱 FOOD IN SPACE",
			"icon": "🌱",
			"fact": "Astronauts use salt and pepper dissolved in liquid, because loose grains would float away and could get into machines or be breathed in.",
			"source": "NASA"
		},
		{
			"id": "food_tomato",
			"category": "🌱 FOOD IN SPACE",
			"icon": "🌱",
			"fact": "Tomatoes grew on the International Space Station for 101 days, from December 2022 to March 2023, to test two different lighting recipes.",
			"source": "NASA OSDR (OSD-766)"
		},
		{
			"id": "food_eden",
			"category": "🌱 FOOD IN SPACE",
			"icon": "🌱",
			"fact": "A test greenhouse called EDEN ISS was built in Antarctica to practice growing food for space. It grew lettuce, tomatoes, cucumbers, radishes and herbs.",
			"source": "NASA OSDR (OSD-895)"
		},
		{
			"id": "planet_venus",
			"category": "🪐 PLANETS",
			"icon": "🪐",
			"fact": "A day on Venus is longer than its year. Venus takes about 243 Earth days to spin once, but only about 225 Earth days to go around the Sun.",
			"source": "NASA"
		},
		{
			"id": "planet_saturn",
			"category": "🪐 PLANETS",
			"icon": "🪐",
			"fact": "Saturn is so light for its size that, on average, it is less dense than water. In a giant enough bathtub, it would float.",
			"source": "NASA"
		},
		{
			"id": "planet_neptune",
			"category": "🪐 PLANETS",
			"icon": "🪐",
			"fact": "One year on Neptune lasts about 165 Earth years. It was discovered in 1846, and it only finished its first full trip around the Sun since then in 2011.",
			"source": "NASA"
		},
		{
			"id": "mars_sol",
			"category": "🔴 MARS",
			"icon": "🔴",
			"fact": "A day on Mars is called a sol and lasts about 24 hours and 40 minutes, only a little longer than a day on Earth.",
			"source": "NASA Mars Facts"
		},
		{
			"id": "mars_year",
			"category": "🔴 MARS",
			"icon": "🔴",
			"fact": "A year on Mars lasts about 687 Earth days, almost twice as long as an Earth year.",
			"source": "NASA Mars Facts"
		},
		{
			"id": "mars_gravity",
			"category": "🔴 MARS",
			"icon": "🔴",
			"fact": "Gravity on Mars is only about 38 percent of Earth's. A person who weighs 50 kg on Earth would feel like they weigh about 19 kg on Mars.",
			"source": "NASA Mars Facts"
		},
		{
			"id": "mars_olympus",
			"category": "🔴 MARS",
			"icon": "🔴",
			"fact": "Mars has the tallest volcano in the solar system, Olympus Mons, about 22 km high. That is roughly two and a half times the height of Mount Everest.",
			"source": "NASA Mars Facts"
		},
		{
			"id": "space_sunlight",
			"category": "🌌 SPACE",
			"icon": "🌌",
			"fact": "Sunlight takes about 8 minutes and 20 seconds to reach Earth. When you look at the Sun, you see it as it was a little over 8 minutes ago.",
			"source": "NASA"
		},
		{
			"id": "space_silence",
			"category": "🌌 SPACE",
			"icon": "🌌",
			"fact": "Space is silent. Sound needs air or another material to travel through, and space is almost completely empty, so astronauts talk by radio.",
			"source": "NASA"
		},
		{
			"id": "space_iss",
			"category": "🌌 SPACE",
			"icon": "🌌",
			"fact": "The International Space Station travels at about 28,000 km/h and circles Earth roughly every 90 minutes.",
			"source": "NASA ISS Facts"
		}
	]

	for i in range(19):
		var card = cards[i]
		var exp = expected_cards[i]

		for k in required_keys:
			assert(card.has(k), "Card index %d missing required key '%s'" % [i, k])
			assert(card[k] is String and card[k].length() > 0, "Card index %d key '%s' must be non-empty string" % [i, k])

		assert(card["id"] == exp["id"], "ID mismatch at index %d: expected %s, got %s" % [i, exp["id"], card["id"]])
		assert(card["category"] == exp["category"], "Category mismatch for %s" % card["id"])
		assert(card["icon"] == exp["icon"], "Icon mismatch for %s" % card["id"])
		assert(card["fact"] == exp["fact"], "Fact text mismatch for %s" % card["id"])
		assert(card["source"] == exp["source"], "Source mismatch for %s" % card["id"])

		assert(not seen_ids.has(card["id"]), "Duplicate card ID '%s'" % card["id"])
		seen_ids[card["id"]] = true
		print("  ✓ [%s] %s %s: '%s' (%s)" % [card["id"], card["icon"], card["category"], card["fact"].substr(0, 35) + "...", card["source"]])

	print("✓ All 19 scientific fact cards verified exactly against specification!")

	# Verify Helper Functions
	var all_cards = EncyclopediaDataClass.get_all_cards()
	assert(all_cards.size() == 19, "get_all_cards must return 19 cards")

	var card_by_id = EncyclopediaDataClass.get_card_by_id("mars_olympus")
	assert(card_by_id.get("id") == "mars_olympus", "get_card_by_id failed")

	var mars_cards = EncyclopediaDataClass.get_cards_by_category("MARS")
	assert(mars_cards.size() == 4, "Mars category must have 4 cards, got %d" % mars_cards.size())

	var categories = EncyclopediaDataClass.get_categories()
	assert(categories.size() == 6, "Must have exactly 6 distinct categories, got %d" % categories.size())
	print("✓ Helper functions (get_all_cards, get_card_by_id, get_cards_by_category, get_categories) verified!")

	print("==================================================")
	print("ALL ENCYCLOPEDIA DATA TESTS PASSED SUCCESSFULLY!")
	print("==================================================")
	quit(0)
