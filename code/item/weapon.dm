/obj/item/equipment/weapon
	real_name ="Weapon"
	slot = "weapon"
	desc = "A weapon. Stabs things. Maybe."
	var/damage_type = SLASH
	var/damage_bonus = 0
	var/damage_dice = 6
	var/dice_amount = 1
	var/hit_bonus = 0
	var/reach = 1
	var/miss_prob = 30
	var/attack_speed = 5

	proc/GetReach(var/mob/living/player/P, var/mob/living/other)
		return reach + 0.5

	proc/Attack(var/datum/dminfo/dmg)
		dmg.damage = damage_bonus
		dmg.improve_hit = hit_bonus
		for(var/i=1 to dice_amount)
			dmg.damage += rand(1,damage_dice)

		if(prob(miss_prob - dmg.hg_adv))
			dmg.damage = 0

		var/image/swing = image(icon = src.icon, icon_state = src.icon_state)
		swing.x = dmg.challenger.x
		swing.y = dmg.challenger.y
		//swing.pixel_z = dmg.challenger.pixel_z
		if(dmg.damage == 0)
			swing.alpha = 127
		world << swing
		var/x_off = (dmg.target.x - dmg.challenger.x) * 16
		var/y_off = (dmg.target.y - dmg.challenger.y) * 16
		spawn(0)
			animate(swing, pixel_x = x_off, pixel_y = y_off, time = 5)
			spawn(5)
				qdel(swing)


	Stat()
		stat("damage: [damage_dice ? "[dice_amount ? "[dice_amount]d" : ""][damage_dice]" : ""][damage_bonus ? "+[damage_bonus]" : ""]")
		if(hit_bonus)
			stat("hit bonus: [hit_bonus]%")
		if(reach > 1)
			stat("reach: [reach * 5]ft")

	Examine()
		..()
		usr << "damage: [damage_dice ? "[dice_amount ? "[dice_amount]d" : ""][damage_dice]" : ""][damage_bonus ? "+[damage_bonus]" : ""]"
		if(hit_bonus)
			usr << "hit bonus: [hit_bonus]%"
		if(reach > 1)
			usr << "reach: [reach * 5]ft"

/obj/item/equipment/weapon/dagger
	real_name ="Dagger"
	desc = "A thin, agile dagger. Small damage, but attacks quickly."
	icon_state = "dagger"
	damage_dice = 2
	damage_bonus = 1
	hit_bonus = 10
	attack_speed = 3

/obj/item/equipment/weapon/sword
	real_name ="Sword"
	desc = "An actual sword. Sounds more useful."
	miss_prob = 20
	icon_state = "sword"

/obj/item/equipment/weapon/spear
	real_name ="Spear"
	desc = "Longer reach. Harder to stab."
	dice_amount = 2
	damage_dice = 6
	attack_speed = 8
	reach = 2
	icon_state = "spear"

/obj/item/equipment/weapon/ranged
	desc = "Hits things at a distance."
	reach = 8
	attack_speed = 10
	var/proj_icon = ""
	GetReach(var/mob/living/player/P, var/mob/living/other)
		return reach + 0.5 + (get_turf(P).floor_z - get_turf(other).floor_z) // Range weapons shoot downhill a *lot* easier than melee.

	Attack(var/datum/dminfo/dmg)
		var/mob/living/player/P = dmg.challenger
		if(istype(P))
			if(!SpendAmmo(P))
				dmg.damage = 0
				return

		dmg.damage = damage_bonus
		dmg.improve_hit = hit_bonus
		for(var/i=1 to dice_amount)
			dmg.damage += rand(1,damage_dice)

		if(prob(miss_prob - dmg.hg_adv))
			dmg.damage = 0

		var/image/swing = image(icon = src.icon, icon_state = proj_icon)
		swing.x = dmg.challenger.x
		swing.y = dmg.challenger.y
		//swing.pixel_z = dmg.challenger.pixel_z
		swing.transform = turn(swing.transform, atan2(dmg.target.y - dmg.challenger.y, dmg.target.x - dmg.challenger.x)-45)
		if(dmg.damage == 0)
			swing.alpha = 127
		world << swing
		var/x_off = (dmg.target.x - dmg.challenger.x) * 16
		var/y_off = (dmg.target.y - dmg.challenger.y) * 16
		spawn(0)
			animate(swing, pixel_x = x_off, pixel_y = y_off, time = 3)
			spawn(3)
				qdel(swing)

	proc/SpendAmmo(var/mob/living/player/P)
		return 1

/obj/item/equipment/weapon/ranged/bow
	real_name = "Bow"
	desc = "A bow. Shoots arrows."
	icon_state = "bow"
	proj_icon = "arrow"

	SpendAmmo(var/mob/living/player/P)
		return P.resources["ammo"].remove(1)