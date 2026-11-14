class_name RadLabEvents
extends RefCounted

## NASA RadLab (Radiation & Dosimetry Database - Galactic Cosmic Rays & Active Dosimeters)
## Events 15 through 18 with exact resource impacts.

static func get_all_events() -> Array[Dictionary]:
	return [
		{
			"id": 15,
			"title": "Quiet Day",
			"category": "RADLAB DOSIMETRY & BACKGROUND GCR",
			"radlab_code": "RADLAB-MON-101: Baseline Galactic Cosmic Ray Background",
			"scenario": "Space weather appears calm, but silent Galactic Cosmic Rays (GCR) continuously penetrate the hull. Personal dosimeters click steadily in the background.",
			"bot_advice": "Astro-Bot: \"Even during quiet solar periods, heavy ion background radiation accumulates. Inspecting shield coils reduces dose slightly but costs maintenance energy.\"",
			"choice_a": {
				"label": "Work as usual",
				"effects": {
					"energy": -1,
					"radiation": 10.5
				},
				"description": "Maintain standard operational schedule and absorb baseline background cosmic radiation."
			},
			"choice_b": {
				"label": "Check the shield",
				"effects": {
					"energy": -3,
					"shield": -1,
					"radiation": 9.0
				},
				"description": "Calibrate and power up low-frequency deflector fields to shave off GCR particle flux."
			}
		},
		{
			"id": 16,
			"title": "More Radiation Zone",
			"category": "RADLAB TRAPPED FLUX ANOMALY",
			"radlab_code": "RADLAB-ALT-204: High-Flux Particle Trapping Sector",
			"scenario": "The Astro-Care enters a high-density magnetic anomaly zone. Ambient radiation levels surge to three times nominal background.",
			"bot_advice": "Astro-Bot: \"Elevated ambient flux detected. Retreating into the inner cabin relies on atmospheric scrubbing, while activating active shields draws high wattage.\"",
			"choice_a": {
				"label": "Stay inside",
				"effects": {
					"oxygen": -2,
					"radiation": 5.0
				},
				"description": "Restrict crew movement to the central pressure vessel and seal auxiliary hatches."
			},
			"choice_b": {
				"label": "Turn on the shield",
				"effects": {
					"energy": -4,
					"shield": -3,
					"radiation": 3.0
				},
				"description": "Energize secondary deflector grid to actively deflect ionizing radiation particles."
			}
		},
		{
			"id": 17,
			"title": "A Thicker Wall",
			"category": "RADLAB PASSIVE SHIELDING & MATERIALS",
			"radlab_code": "RADLAB-EXP-308: Hydrogenous & Regolith Mass Shielding",
			"scenario": "Dosimetry models indicate the crew sleeping quarters require thicker passive bulkheads to attenuate secondary neutron scatter from cosmic rays.",
			"bot_advice": "Astro-Bot: \"Hydrogen-rich mass is the ultimate shield. Water and food ration bladders offer superior hydrogen density, or we can haul external Mars regolith blocks.\"",
			"choice_a": {
				"label": "Use water",
				"effects": {
					"water": -4,
					"energy": -2,
					"food": -2
				},
				"description": "Line cabin perimeter with greywater bags and dense food ration packs to absorb secondary radiation."
			},
			"choice_b": {
				"label": "Use Mars soil",
				"effects": {
					"energy": -6,
					"shield": -2
				},
				"description": "Deploy exterior robotic arms to compact and mount raw Martian regolith bricks onto outer hull tiles."
			}
		},
		{
			"id": 18,
			"title": "Dosimeter Alarm",
			"category": "RADLAB ACTIVE DOSIMETRY THREAT",
			"radlab_code": "RADLAB-WARN-415: Critical Threshold Dosimeter Alarm",
			"scenario": "ALARM! Crew wearable active dosimeters chirp violently during an exterior spacewalk. Unpredicted ionizing particle concentration detected outside the airlock.",
			"bot_advice": "Astro-Bot: \"Radiation dosimeter threshold breached! Immediate EVA abort uses airlock purge oxygen, or an emergency high-voltage shield surge can deflect the wavefront!\"",
			"choice_a": {
				"label": "Go back inside fast",
				"effects": {
					"oxygen": -3,
					"energy": -1,
					"radiation": 4.0
				},
				"description": "Execute emergency airlock repressurization and rapid egress to station interior."
			},
			"choice_b": {
				"label": "Emergency shield",
				"effects": {
					"energy": -5,
					"shield": -5,
					"radiation": 2.0
				},
				"description": "Overclock localized deflector emitters to throw an electromagnetic bubble around the EVA crew."
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
	if effects.has("food"):
		var val = effects["food"]
		parts.append("Food %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("water"):
		var val = effects["water"]
		parts.append("Water %s" % (str(val) if val < 0 else "+" + str(val)))
	if effects.has("radiation"):
		var val = float(effects["radiation"])
		if is_equal_approx(val, round(val)):
			parts.append("+%d mSv" % int(val) if val > 0 else "%d mSv" % int(val))
		else:
			parts.append("+%.1f mSv" % val if val > 0 else "%.1f mSv" % val)
	return " | ".join(parts)

