var/list/spawns = list()
/obj/player_spawn
	icon = 'icons/misc.dmi'
	icon_state = "spawn"

	New()
		spawns += loc
		qdel(src)

/mob/living/player
	icon = 'icons/mob.dmi'
	icon_state = "player_male"

	dodge_chance = 20

	move_speed = 3

	var/list/inventory = list()
	var/list/equipment = list(
		"weapon" = /obj/item/equipment/weapon/dagger,
		"armour" = /obj/item/equipment/armour/standard,
		"shield" = /obj/item/equipment/armour/shield/weak
	)

	var/list/resources = list(
		"gold" = new/datum/resource/gold(),
		"health" = new/datum/resource/health(),
		"ammo" = new/datum/resource/ammo()
	)

	New()
		spawn(1)
			//loc = pick(spawns)
			x = 127
			y = 127
			chunks[1].Spawn(120, 120, 1)
		for(var/id in equipment)
			var/T = equipment[id]
			if(T!=null)
				equipment[id] = new T(src)

		for(var/I = 1 to 3)
			inventory += new/obj/item/potion/health(src)

		..()

	Tick()
		..()


	GetHealth()
		return resources["health"].current

	GetMaxHealth()
		return resources["health"].max

	SetHealth(var/n)
		resources["health"].current = n

	Stat()
		stat("Resources", "")
		for(var/id in resources)
			var/datum/resource/R = resources[id]
			var/obj/O = new()
			O.icon = R.icon
			O.icon_state = R.icon_state
			O.name ="[R.current]"
			stat("", O)
		stat("============<",">============")
		stat("")
		stat("Equipment", "")
		for(var/N in equipment)
			var/obj/item/equipment/E = equipment[N]
			stat(N, E)
			if(istype(E))
				E.Stat()
		stat("============<",">============")
		stat("")
		stat("Inventory", "")
		for(var/obj/item/E in inventory)
			E.UpdateName()
			stat(E)
		stat("============<",">============")

	Attack(var/datum/dminfo/dmg)
		..()
		var/obj/item/equipment/weapon/S = equipment["weapon"]
		if(istype(S))
			S.Attack(dmg)
		else
			dmg.damage = rand(1, 2)
			if(prob(50))
				dmg.damage = 0

	CanAttack(var/datum/dminfo/dmg)
		var/obj/item/equipment/weapon/S = equipment["weapon"]
		if(istype(S))
			attack_delay = S.attack_speed
		else
			attack_delay = 1
		return ..()

	Attacked(var/datum/dminfo/dmg)
		..()
		if(!dmg.damage) // We dodged in this case
			return
		for(var/n in equipment)
			var/obj/item/equipment/armour/A = equipment[n]
			if(istype(A))
				if(prob(A.fullblock_chance - dmg.improve_hit))
					dmg.damage = 0

					var/image/swing = image(icon = A.icon, icon_state = A.icon_state)
					swing.x = x
					swing.y = y
					//swing.pixel_z = pixel_z
					swing.alpha = 255
					world << swing
					var/x_off = (dmg.target.x - dmg.challenger.x) * -4
					var/y_off = (dmg.target.y - dmg.challenger.y) * -4
					spawn(0)
						animate(swing, pixel_x = x_off, pixel_y = y_off, time = 5)
						spawn(5)
							qdel(swing)
				else if(prob(A.partialblock_chance - dmg.improve_hit))
					dmg.damage = max(dmg.damage - A.partialblock_amount, 0)

					var/image/swing = image(icon = A.icon, icon_state = A.icon_state)
					swing.x = x
					swing.y = y
					//swing.pixel_z = pixel_z
					swing.alpha = 127
					world << swing
					var/x_off = (dmg.target.x - dmg.challenger.x) * -4
					var/y_off = (dmg.target.y - dmg.challenger.y) * -4
					spawn(0)
						animate(swing, pixel_x = x_off, pixel_y = y_off, time = 5)
						spawn(5)
							qdel(swing)
				else
					dmg.damage = max(dmg.damage - A.alwaysblock_amount, 0)

	GetReach(var/mob/living/other)
		var/obj/item/equipment/weapon/S = equipment["weapon"]
		if(istype(S))
			return S.GetReach(src, other)
		return 1.5