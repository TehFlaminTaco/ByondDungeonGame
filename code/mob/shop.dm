/mob/living/shop_keeper
	var/item1 = null
	var/item2 = null
	var/item3 = null
	var/hold_pos = null
	var/list/podiums = list()
	var/cost1 = 0
	var/cost2 = 0
	var/cost3 = 0

	icon_state = "player_male"

	Init()
		next_move = 0
		..()
		hold_pos = loc
		if(item1)	// If we have an item1
			var/obj/structure/buy_podium/b = new(locate(x - 2, y - 1, z))
			b.hold_type = item1
			podiums[b] = item1
			b.cost = cost1
		if(item2)	// If we have an item2
			var/obj/structure/buy_podium/b = new(locate(x , y - 2, z))
			b.hold_type = item2
			podiums[b] = item2
			b.cost = cost2
		if(item3)	// If we have an item3
			var/obj/structure/buy_podium/b = new(locate(x + 2, y - 1, z))
			b.hold_type = item3
			podiums[b] = item3
			b.cost = cost3

	var/shop_wait = 0

	Tick() // Keep the shelves stocked.
		. = ..()
		if(world.time < shop_wait)
			return
		shop_wait = world.time+5
		for(var/obj/structure/buy_podium/b in oview(src, 3))
			var/T = podiums[b]
			if(!T) // Incase we see a podium we don't run.
				continue
			if(!istype(b.held)) // Run to it!
				if(get_dist(b, src) > 1)
					step_towards(src, b)
				else
					b.held = new T(b) // Restock it.
					b.update_icon()
				return


		step_towards(src, hold_pos)

/mob/living/shop_keeper/random
	var/list/products = list(
		/obj/item/potion/health = 3, \
		/obj/item/potion/health_overheal = 8, \
		/obj/item/resource/ammo/five = 2, \
		/obj/item/resource/ammo/ten = 3, \
		/obj/item/equipment/weapon/sword = 10, \
		/obj/item/equipment/weapon/ranged/bow = 10, \
		/obj/item/equipment/armour/shield/braced = 20, \
		/obj/item/equipment/weapon/spear = 20, \
		/obj/item/equipment/armour/mithril = 100, \
	)

	Init()
		var/list/P = products.Copy()
		item1 = pick(P)
		cost1 = products[item1]
		P -= item1
		item2 = pick(P)
		cost2 = products[item2]
		P -= item2
		item3 = pick(P)
		cost3 = products[item3]
		P -= item3
		..()