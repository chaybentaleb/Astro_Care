class_name EncyclopediaData
extends RefCounted

## Encyclopedia Scientific Fact Cards Data for Astro-Care
## Contains 19 scientifically verified fact cards from NASA DONKI, NASA OSDR, and NASA Planetary science.

const CARDS_DATA: Array[Dictionary] = [
	# --- Solar Flares (☀️ SOLAR FLARES) ---
	{
		"id": "flr_20261107",
		"category": "☀️ SOLAR FLARES",
		"icon": "☀️",
		"fact": "On November 7, 2026, the Sun released an M1.9-class solar flare. It started at 18:21 UTC, peaked at 18:42 and ended at 18:56.",
		"source": "Based on real space data"
	},
	{
		"id": "flr_20261108",
		"category": "☀️ SOLAR FLARES",
		"icon": "☀️",
		"fact": "On November 8, 2026, the Sun released an M1.7-class solar flare. It started at 07:33 UTC, peaked at 07:46 and ended at 07:54.",
		"source": "Based on real space data"
	},

	# --- Solar Eruptions (💥 SOLAR ERUPTIONS) ---
	{
		"id": "cme_20261108",
		"category": "💥 SOLAR ERUPTIONS",
		"icon": "💥",
		"fact": "On November 8, 2026, an eruption from the Sun (a CME) was measured at 367 km/s. Scientists used SOHO and STEREO A pictures to work out where it was heading.",
		"source": "Based on real space data"
	},
	{
		"id": "cme_20261109",
		"category": "💥 SOLAR ERUPTIONS",
		"icon": "💥",
		"fact": "On November 9, 2026, an eruption was measured at 726 km/s. A computer model predicted it would reach STEREO A on November 12, Mars on November 13 and Psyche on November 14.",
		"source": "Based on real space data"
	},
	{
		"id": "cme_20261111",
		"category": "💥 SOLAR ERUPTIONS",
		"icon": "💥",
		"fact": "An eruption that started on November 11, 2026 was measured at 367 km/s. The computer model predicted it would hit nothing.",
		"source": "Based on real space data"
	},

	# --- Food in Space (🌱 FOOD IN SPACE) ---
	{
		"id": "food_tortilla",
		"category": "🌱 FOOD IN SPACE",
		"icon": "🌱",
		"fact": "Astronauts often eat tortillas instead of bread, because bread makes crumbs that would float around and could get into equipment.",
		"source": "Based on real space data"
	},
	{
		"id": "food_salt",
		"category": "🌱 FOOD IN SPACE",
		"icon": "🌱",
		"fact": "Astronauts use salt and pepper dissolved in liquid, because loose grains would float away and could get into machines or be breathed in.",
		"source": "Based on real space data"
	},
	{
		"id": "food_tomato",
		"category": "🌱 FOOD IN SPACE",
		"icon": "🌱",
		"fact": "Tomatoes grew on the International Space Station for 101 days, from December 2022 to March 2023, to test two different lighting recipes.",
		"source": "Based on real space data"
	},
	{
		"id": "food_eden",
		"category": "🌱 FOOD IN SPACE",
		"icon": "🌱",
		"fact": "A test greenhouse called EDEN ISS was built in Antarctica to practice growing food for space. It grew lettuce, tomatoes, cucumbers, radishes and herbs.",
		"source": "Based on real space data"
	},

	# --- Planets (🪐 PLANETS) ---
	{
		"id": "planet_venus",
		"category": "🪐 PLANETS",
		"icon": "🪐",
		"fact": "A day on Venus is longer than its year. Venus takes about 243 Earth days to spin once, but only about 225 Earth days to go around the Sun.",
		"source": "Based on real space data"
	},
	{
		"id": "planet_saturn",
		"category": "🪐 PLANETS",
		"icon": "🪐",
		"fact": "Saturn is so light for its size that, on average, it is less dense than water. In a giant enough bathtub, it would float.",
		"source": "Based on real space data"
	},
	{
		"id": "planet_neptune",
		"category": "🪐 PLANETS",
		"icon": "🪐",
		"fact": "One year on Neptune lasts about 165 Earth years. It was discovered in 1846, and it only finished its first full trip around the Sun since then in 2011.",
		"source": "Based on real space data"
	},

	# --- Mars (🔴 MARS) ---
	{
		"id": "mars_sol",
		"category": "🔴 MARS",
		"icon": "🔴",
		"fact": "A day on Mars is called a sol and lasts about 24 hours and 40 minutes, only a little longer than a day on Earth.",
		"source": "Based on real space data"
	},
	{
		"id": "mars_year",
		"category": "🔴 MARS",
		"icon": "🔴",
		"fact": "A year on Mars lasts about 687 Earth days, almost twice as long as an Earth year.",
		"source": "Based on real space data"
	},
	{
		"id": "mars_gravity",
		"category": "🔴 MARS",
		"icon": "🔴",
		"fact": "Gravity on Mars is only about 38 percent of Earth's. A person who weighs 50 kg on Earth would feel like they weigh about 19 kg on Mars.",
		"source": "Based on real space data"
	},
	{
		"id": "mars_olympus",
		"category": "🔴 MARS",
		"icon": "🔴",
		"fact": "Mars has the tallest volcano in the solar system, Olympus Mons, about 22 km high. That is roughly two and a half times the height of Mount Everest.",
		"source": "Based on real space data"
	},

	# --- Space (🌌 SPACE) ---
	{
		"id": "space_sunlight",
		"category": "🌌 SPACE",
		"icon": "🌌",
		"fact": "Sunlight takes about 8 minutes and 20 seconds to reach Earth. When you look at the Sun, you see it as it was a little over 8 minutes ago.",
		"source": "Based on real space data"
	},
	{
		"id": "space_silence",
		"category": "🌌 SPACE",
		"icon": "🌌",
		"fact": "Space is silent. Sound needs air or another material to travel through, and space is almost completely empty, so astronauts talk by radio.",
		"source": "Based on real space data"
	},
	{
		"id": "space_iss",
		"category": "🌌 SPACE",
		"icon": "🌌",
		"fact": "The International Space Station travels at about 28,000 km/h and circles Earth roughly every 90 minutes.",
		"source": "Based on real space data"
	}
]

## Returns all 19 fact cards
static func get_all_cards() -> Array[Dictionary]:
	return CARDS_DATA

## Returns a card dictionary by its unique string id, or an empty dictionary if not found
static func get_card_by_id(card_id: String) -> Dictionary:
	for card in CARDS_DATA:
		if card.get("id", "") == card_id:
			return card
	return {}

## Returns all cards belonging to the specified category
static func get_cards_by_category(category_name: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for card in CARDS_DATA:
		var cat: String = card.get("category", "")
		if cat == category_name or category_name in cat or cat.ends_with(category_name):
			result.append(card)
	return result

## Returns an array of distinct category names
static func get_categories() -> Array[String]:
	var categories: Array[String] = []
	for card in CARDS_DATA:
		var cat: String = card.get("category", "")
		if not categories.has(cat):
			categories.append(cat)
	return categories
