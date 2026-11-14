class_name MarsStemEvents
extends RefCounted

## CSA STEM Quizzes & Mars Trek / Base Survival Events
## Events 20, 25, 26, 27, 28, 29, 30

static func get_all_events() -> Array[Dictionary]:
	return [
		{
			"id": 20,
			"title": "Time to Move (Mars Map Selection)",
			"category": "MARS TREK EXPEDITION SITE",
			"code": "MARS-TREK-LOC-20: Base Relocation Vector",
			"scenario": "Astro-Care survey rovers have charted 4 strategic sectors across the Martian surface. Select the final outpost coordinate for long-term habitat deployment.",
			"bot_advice": "Astro-Bot: \"Jezero offers rich scientific discovery score; Arcadia holds shallow ice for continuous water; Deuteronilus features massive glaciers but cold nights; Hellas has thick atmosphere that cuts radiation!\"",
			"choice_a": {
				"label": "Jezero Crater (Ancient Delta)",
				"effects": {
					"energy": -10,
					"oxygen": -4,
					"score_per_turn": 3
				},
				"description": "Ancient river delta rich in biosignature fossils. Boosts mission science score +3 every turn."
			},
			"choice_b": {
				"label": "Arcadia Planitia (Subsurface Ice Plains)",
				"effects": {
					"energy": -8,
					"oxygen": -4,
					"water_per_turn": 3
				},
				"description": "Widespread shallow water-ice sheet. Yields +3 water every turn."
			},
			"choice_c": {
				"label": "Deuteronilus Mensae (Glacial Mesas)",
				"effects": {
					"energy": -12,
					"oxygen": -5,
					"water_per_turn": 4,
					"energy_per_turn": -2
				},
				"description": "Deep buried glaciers. Abundant ice (+4 water/turn) but high heating power consumption (-2 energy/turn)."
			},
			"choice_d": {
				"label": "Hellas Basin (Deep Impact Lowlands)",
				"effects": {
					"energy": -12,
					"oxygen": -5,
					"radiation_multiplier": 0.85,
					"dust_multiplier": 1.5
				},
				"description": "Deepest depression on Mars. Dense atmosphere reduces radiation x0.85, but frequent dust storms x1.5."
			}
		},
		{
			"id": 25,
			"title": "Quiz: Does Water Protect?",
			"category": "CSA STEM QUIZ • RADIATION SHIELDING",
			"code": "STEM-QUIZ-25: Physics of Radiation Attenuation",
			"scenario": "MISSION FLIGHT SURGEON QUIZ: Is water an effective shield against space radiation? Think of the hydrogen density in H2O molecules.",
			"bot_advice": "Astro-Bot: \"STEM Trivia Question, Commander! Water molecules contain two hydrogen atoms per oxygen atom. Does hydrogen absorb cosmic ray neutrons?\"",
			"choice_a": {
				"label": "True",
				"effects": {
					"health": 3
				},
				"description": "CORRECT! Water is hydrogen-rich; light nuclei absorb secondary neutrons, shielding astronauts."
			},
			"choice_b": {
				"label": "False",
				"effects": {
					"shield": -3,
					"radiation": 5.0
				},
				"description": "INCORRECT! Misjudging shielding protocols leads to poor deflector calibration and unnecessary radiation exposure."
			}
		},
		{
			"id": 26,
			"title": "Quiz: Why Exercise?",
			"category": "CSA STEM QUIZ • HUMAN PHYSIOLOGY",
			"code": "STEM-QUIZ-26: Countermeasures in Microgravity",
			"scenario": "MISSION BIOMEDICAL QUIZ: Why do astronauts spend 2 to 2.5 hours every single day exercising in space?",
			"bot_advice": "Astro-Bot: \"Think of the musculoskeletal consequences of zero gravity on the human body over long durations, Commander!\"",
			"choice_a": {
				"label": "Only for fun",
				"effects": {
					"energy": -2,
					"health": -2
				},
				"description": "INCORRECT! Neglecting conditioning protocols causes rapid muscular atrophy and bone demineralization."
			},
			"choice_b": {
				"label": "To keep muscles and bones strong",
				"effects": {
					"energy": -1,
					"health": 6
				},
				"description": "CORRECT! High-load resistance and aerobic exercise prevent critical bone calcium loss and cardiac deconditioning."
			}
		},
		{
			"id": 27,
			"title": "Quiz: The Sun",
			"category": "CSA STEM QUIZ • SOLAR DYNAMICS",
			"code": "STEM-QUIZ-27: Heliophysics & Space Weather",
			"scenario": "MISSION HELIOPHYSICS QUIZ: True or False: The Sun's 11-year solar cycle fluctuates between periods of solar minimum and solar maximum, directly influencing space weather storms.",
			"bot_advice": "Astro-Bot: \"Solar magnetohydrodynamics, Commander! Does solar activity follow an oscillating magnetic cycle?\"",
			"choice_a": {
				"label": "True",
				"effects": {
					"energy": 3,
					"health": 2
				},
				"description": "CORRECT! Solar cycles dictate coronal mass ejections, solar flares, and particle storms throughout the solar system."
			},
			"choice_b": {
				"label": "False",
				"effects": {
					"energy": -3,
					"shield": -3
				},
				"description": "INCORRECT! Failing heliophysics telemetry leads to unexpected battery brownouts and shield misalignment."
			}
		},
		{
			"id": 28,
			"title": "Dust Storm on Mars",
			"category": "MARS BASE SURVIVAL • ATMOSPHERIC CRISIS",
			"code": "MARS-SURV-28: Global Aeolian Dust Front",
			"scenario": "A massive regional dust storm has blackened the Martian sky. Fine iron-oxide dust particles coat the solar photovoltaic arrays and reduce power output by 80%.",
			"bot_advice": "Astro-Bot: \"Solar generation has cratered! We can enter low-power hibernation, or send crew into the storm to scrub the panels at high life-support cost.\"",
			"choice_a": {
				"label": "Save energy",
				"effects": {
					"energy": -6,
					"oxygen": -2
				},
				"description": "Shut down non-essential computers, lower cabin temperature, and weather the dust front on batteries."
			},
			"choice_b": {
				"label": "Clean the panels",
				"effects": {
					"oxygen": -5,
					"energy": -3,
					"shield": -2
				},
				"description": "Conduct emergency EVA in howling 60 km/h winds using compressed gas blowers to wipe the panels clean."
			}
		},
		{
			"id": 29,
			"title": "The Cold Mars Night",
			"category": "MARS BASE SURVIVAL • THERMAL CONTROL",
			"code": "MARS-SURV-29: Nocturnal Sub-Zero Thermal Drop",
			"scenario": "Night falls over the Martian plateau. Exterior ambient temperature plummets to -125°C. Habitat hull thermal seals begin to contract and groan.",
			"bot_advice": "Astro-Bot: \"Severe freeze hazard! Electric heating strips can warm the hab from internal battery banks, or we fire up the secondary fuel combustion generator.\"",
			"choice_a": {
				"label": "Use the batteries",
				"effects": {
					"energy": -12,
					"shield": -1
				},
				"description": "Draw heavily from reserve lithium-ion banks to power resistive life-support heating coils."
			},
			"choice_b": {
				"label": "Turn on the generator",
				"effects": {
					"oxygen": -5,
					"energy": -6
				},
				"description": "Ignite the auxiliary closed-cycle methane-oxygen generator to supply radiant hydronic thermal heat."
			}
		},
		{
			"id": 30,
			"title": "Oxygen Leak",
			"category": "MARS BASE SURVIVAL • HABITAT COMPROMISE",
			"code": "MARS-SURV-30: Airlock Micrometeoroid Puncture",
			"scenario": "SIRENS BLARING! Pressure sensor in Sector 2 reports rapid depressurization. A micrometeorite has punctured the composite airlock bladder!",
			"bot_advice": "Astro-Bot: \"CRITICAL DECOMPRESSION! An EVA patch kit can seal the puncture directly, or we isolate and depressurize the entire breached module!\"",
			"choice_a": {
				"label": "Plug the hole",
				"effects": {
					"energy": -3,
					"oxygen": -5
				},
				"description": "Rally emergency response team with rapid-curing epoxy resin patches to seal the puncture from within."
			},
			"choice_b": {
				"label": "Close the module",
				"effects": {
					"oxygen": -8,
					"energy": -1,
					"shield": -2
				},
				"description": "Slam the blast bulkhead doors shut and sacrifice the module volume to preserve the main habitat."
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
			
	# Per-turn base passive modifiers (Event 20)
	if effects.has("score_per_turn"):
		parts.append("Score +%d/tour" % effects["score_per_turn"])
	if effects.has("water_per_turn"):
		parts.append("Water +%d/tour" % effects["water_per_turn"])
	if effects.has("energy_per_turn"):
		parts.append("Energy %d/tour" % effects["energy_per_turn"])
	if effects.has("radiation_multiplier"):
		parts.append("Radiation x%.2f" % effects["radiation_multiplier"])
	if effects.has("dust_multiplier"):
		parts.append("Dust x%.1f" % effects["dust_multiplier"])
		
	return " | ".join(parts)

