class_name CsaEvents
extends RefCounted

## CSA (Canadian Space Agency & Controlled Environment Agriculture / Space Greenhouse)
## Events 19, 21, 22, 23, 24 with greenhouse food production and hydroponic recycling.

static func get_all_events() -> Array[Dictionary]:
	return [
		{
			"id": 19,
			"title": "Grow Food (Pick a Crop)",
			"category": "CSA HYDROPONIC HORTICULTURE",
			"csa_code": "CSA-BIO-19: Hydroponic Crop Selection",
			"scenario": "The Astro-Care hydroponic bay has cleared sterile beds. Choose a strategic crop rotation to balance nutrient density against harvest cycle times and life-support costs.",
			"bot_advice": "Astro-Bot: \"Lettuce grows fast for rapid calories; potatoes yield substantial starch after two turns; dwarf tomatoes take three turns but provide massive caloric yields.\"",
			"choice_a": {
				"label": "Lettuce (~30 days)",
				"effects": {
					"water": -3,
					"energy": -3,
					"delayed_food": 10,
					"delay_turns": 1
				},
				"description": "Fast-growing microgreen romaine. Low water requirement; ready for harvest in 1 turn."
			},
			"choice_b": {
				"label": "Potatoes (60+ days)",
				"effects": {
					"water": -5,
					"energy": -4,
					"delayed_food": 18,
					"delay_turns": 2
				},
				"description": "High-density carbohydrate tubers. Moderate water; ready for harvest in 2 turns."
			},
			"choice_c": {
				"label": "Dwarf tomatoes (~80 days)",
				"effects": {
					"water": -8,
					"energy": -6,
					"delayed_food": 26,
					"delay_turns": 3
				},
				"description": "Antioxidant-rich micro-tomatoes. Heavy water and LED power; huge yield in 3 turns."
			}
		},
		{
			"id": 21,
			"title": "Recycling Water",
			"category": "CSA CLOSED-LOOP ENVIRONMENTAL CONTROL",
			"csa_code": "CSA-ECLSS-21: Greywater Distillation & Nutrient Recovery",
			"scenario": "Cabin wastewater tanks and plant evapotranspiration condensate have reached processing thresholds. Engage the vapor compression distillation reclamation processor.",
			"bot_advice": "Astro-Bot: \"Max power reclamation extracts maximum potable water and nutrient sludge for the algae vats, but requires high electrical current.\"",
			"choice_a": {
				"label": "Full power",
				"effects": {
					"water": 6,
					"energy": -5,
					"food": 7,
					"oxygen": 2
				},
				"description": "Engage high-temperature catalytic oxidation: maximum water, enriched crop nutrients, and O2 byproduct."
			},
			"choice_b": {
				"label": "Gently",
				"effects": {
					"water": 3,
					"energy": -2,
					"food": 4
				},
				"description": "Low-power membrane filtration: modest water and nutrient recovery at minimal energy draw."
			}
		},
		{
			"id": 22,
			"title": "Mold in the Greenhouse",
			"category": "CSA BIO-CONTAMINATION OUTBREAK",
			"csa_code": "CSA-PATH-22: Cladosporium Aeroponic Mycosis",
			"scenario": "High humidity and microgravity condensation in Chamber 3 have spawned fungal mold along the seedling root mesh. Pathogen spores threaten station air quality.",
			"bot_advice": "Astro-Bot: \"Deep UV sterilization purges the mold but expends energy and scrubbing oxygen. Culling infected crops saves power but reduces our food supply.\"",
			"choice_a": {
				"label": "Clean it",
				"effects": {
					"oxygen": -3,
					"energy": -3,
					"food": -3
				},
				"description": "Deploy UV ozone scrubbers, sanitize root nozzles, and salvage surviving vegetation."
			},
			"choice_b": {
				"label": "Throw away the sick plants",
				"effects": {
					"oxygen": -1,
					"food": -8
				},
				"description": "Eject infected hydroponic trays into deep space to preserve cabin atmospheric hygiene."
			}
		},
		{
			"id": 23,
			"title": "Low on Food",
			"category": "CSA METABOLIC RATIONING",
			"csa_code": "CSA-NUTRI-23: Caloric Reserve Depletion Protocol",
			"scenario": "Primary harvest reserves are running low before the next transport window. The commander must decide the crew's daily caloric allotment.",
			"bot_advice": "Astro-Bot: \"Standard meal distribution boosts food stores from emergency crates but burns prep energy; caloric reduction strains physical stamina.\"",
			"choice_a": {
				"label": "Normal meals",
				"effects": {
					"energy": -1,
					"food": 7,
					"health": -2
				},
				"description": "Unseal reserve pre-packaged astronaut meal pouches to keep crew fed at standard 2800 kcal."
			},
			"choice_b": {
				"label": "Small portions",
				"effects": {
					"energy": -2,
					"food": 4,
					"health": -1
				},
				"description": "Institute strict 1800 kcal rationing to stretch supplies while rationing fuel paste."
			}
		},
		{
			"id": 24,
			"title": "Mars Potatoes",
			"category": "CSA REGOLITH AGRICULTURE",
			"csa_code": "CSA-REG-24: In-Situ Martian Soil Tuber Cultivation",
			"scenario": "Botanists have washed perchlorates from collected Martian regolith and inoculated the soil with compost. It is time to plant Mars potatoes.",
			"bot_advice": "Astro-Bot: \"High-volume planting yields bountiful starch reserves but consumes lighting power and oxygen during initial aerobic germination.\"",
			"choice_a": {
				"label": "Plant a lot",
				"effects": {
					"energy": -5,
					"oxygen": -1,
					"food": 12
				},
				"description": "Seed the entire regolith dome with Martian potato eyes for large harvest yield."
			},
			"choice_b": {
				"label": "Plant a few",
				"effects": {
					"energy": -2,
					"food": 6
				},
				"description": "Plant a conservative test patch to conserve station electricity and life support."
			}
		}
	]

static func format_effects(effects: Dictionary) -> String:
	var parts: Array[String] = []
	if effects.has("health"):
		var val = effects["health"]
		parts.append("Health %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("energy"):
		var val = effects["energy"]
		parts.append("Energy %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("oxygen"):
		var val = effects["oxygen"]
		parts.append("Oxygen %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("shield"):
		var val = effects["shield"]
		parts.append("Shield %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("water"):
		var val = effects["water"]
		parts.append("Water %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("food"):
		var val = effects["food"]
		parts.append("Food %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("delayed_food") and effects.has("delay_turns"):
		var amt = effects["delayed_food"]
		var turns = effects["delay_turns"]
		parts.append("Food +%d after %d turn%s" % [amt, turns, "s" if turns > 1 else ""])
	if effects.has("radiation"):
		var val = float(effects["radiation"])
		if is_equal_approx(val, round(val)):
			parts.append("+%d mSv" % int(val) if val > 0 else "%d mSv" % int(val))
		else:
			parts.append("+%.1f mSv" % val if val > 0 else "%.1f mSv" % val)
	return " | ".join(parts)

