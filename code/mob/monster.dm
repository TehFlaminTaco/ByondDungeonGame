/mob/living/monster
	real_name ="Monster"
	desc = "Definitely evil. Better kill it"

	var/see_range = 3
	var/next_idle = 0
	var/idle_wait = 10
	var/loot = list(/obj/item/resource/gold)
	var/reach = 1.5

	Tick()
		if(next_idle == 0)
			next_idle = world.time + rand(1, idle_wait)
		..()
		if(GetHealth() && istype(loc, /turf))
			Think()

	proc/Think()
		for(var/mob/living/player/P in orange(src.loc, reach))
			if(P.Fight(src))
				next_move = world.time + move_speed
				return

		for(var/mob/living/player/P in orange(src.loc, see_range))
			var/target_dir = get_dir(loc, P.loc)
			Move(get_step(loc, target_dir), target_dir)
			return

		if(next_idle <= world.time)
			next_idle = world.time + idle_wait + rand(1, 3)

			var/t_dir = pick(NORTH, SOUTH, EAST, WEST)
			Move(get_step(loc, t_dir), t_dir)

	GetReach(var/mob/living/other)
		return reach

	Die()
		var/t = pick(loot)
		new t(src.loc)

	CanAttack(var/mob/living/other)
		if(istype(other, /mob/living/monster))
			return 0 // Don't harm your fellow mosnter.
		return ..()


/mob/living/monster/bat
	real_name ="Bat"
	desc = "A winged monster. Be wary!"
	move_speed = 4
	see_range = 6
	max_hp = 3
	flags = FLYING
	icon_state = "bat"
	loot = list(/obj/item/resource/gold, /obj/item/resource/gold, /obj/item/resource/ammo, /obj/item/resource/ammo/five)

/mob/living/monster/slime
	real_name ="Slime"
	icon_state = "slime"
	desc = "A creature made of toxins and anger."
	move_speed = 3
	attack_delay = 10
	max_hp = 8
	attack_damage = 3

	loot = list(/obj/item/resource/gold/med, /obj/item/resource/gold/med, /obj/item/resource/gold/large, /obj/item/potion/health)


/mob/living/monster/spider
	real_name ="Spider"
	icon_state = "spider"
	desc = "Too fast for their own good. Jumps."
	move_speed = 1
	attack_delay = 20
	max_hp = 2
	attack_damage = 2
	dodge_chance = 50
	reach = 3
	Attack(var/datum/dminfo/dmg)
		if(get_dist(dmg.challenger,dmg.target)>1)
			pixel_x = (x - dmg.target.x) * 16
			pixel_y = (y - dmg.target.y) * 16
			spawn(0)
				animate(src, pixel_x = pixel_x/2, pixel_y = pixel_y/2, time = 2)
				animate(src, pixel_z = pixel_z + 14, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL, time = 2)
				spawn(2)
					animate(src, pixel_x = 0, pixel_y = 0, time = 2)
					animate(src, pixel_z = loc.pixel_z, easing = SINE_EASING | EASE_IN, flags = ANIMATION_PARALLEL, time = 2)
			loc = get_turf(dmg.target)
			next_move = world.time + 10
			next_attack = world.time + attack_delay
			return 0
		else
			..()

/mob/living/monster/fred
	real_name ="Fred"
	icon_state = "fred"
	desc = "Friendly, but in your way."
	max_hp = 28
	loot = list(/obj/item/resource/gold, /obj/item/resource/gold, /obj/item/resource/gold, /obj/item/resource/gold, /obj/item/resource/gold/med, /obj/item/resource/gold/med, /obj/item/resource/gold/large)

	Think()
