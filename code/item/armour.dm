/obj/item/equipment/armour
	real_name ="Armour"
	slot = "armour"
	desc = "Blocks hits, maybe."

	var/fullblock_chance = 0
	var/partialblock_chance = 0
	var/partialblock_amount
	var/alwaysblock_amount = 0

	Stat()
		if(fullblock_chance)
			stat("", "[fullblock_chance]% chance to block all damage")
		if(partialblock_chance && partialblock_amount)
			stat("", "[partialblock_chance]% chance to block [partialblock_amount] damage")
		if(alwaysblock_amount)
			stat("", "always blocks [alwaysblock_amount] damage")

	Examine()
		..()
		if(fullblock_chance)
			usr << "[fullblock_chance]% chance to block all damage"
		if(partialblock_chance && partialblock_amount)
			usr << "[partialblock_chance]% chance to block [partialblock_amount] damage"
		if(alwaysblock_amount)
			usr << "always blocks [alwaysblock_amount] damage"

/obj/item/equipment/armour/standard
	real_name ="Standard Armour"
	desc = "Sometimes blocks hits"
	icon_state = "armour_standard"

	fullblock_chance = 10
	partialblock_chance = 10
	partialblock_amount = 4
	alwaysblock_amount = 0

/obj/item/equipment/armour/mithril
	real_name ="Mithril Armour"
	desc = "Absorbs Damage"
	icon_state = "armour_mith"

	fullblock_chance = 30
	partialblock_chance =40
	partialblock_amount = 8
	alwaysblock_amount = 3

/obj/item/equipment/armour/shield
	slot = "shield"

/obj/item/equipment/armour/shield/weak
	real_name ="Weak Shield"
	desc = "Sometimes blocks hits."
	icon_state = "shield_weak"

	fullblock_chance = 20
	partialblock_chance = 40
	partialblock_amount = 1
	alwaysblock_amount = 0

/obj/item/equipment/armour/shield/braced
	real_name ="Braced Shield"
	desc = "Better at blocking the hits it blocks."
	icon_state = "shield_braced"

	fullblock_chance = 20
	partialblock_chance = 40
	partialblock_amount = 3
	alwaysblock_amount = 0