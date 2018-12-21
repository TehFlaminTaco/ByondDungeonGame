/mob/living
	var/hp = 0
	var/max_hp = 10

	var/image/hp_bar = null

	var/attack_damage = 1
	var/dodge_chance = 10
	var/attack_delay = 5
	var/next_attack = 0

	Init()
		..()
		SetHealth(GetMaxHealth())
		hp_bar = image(icon = 'icons/hpbar.dmi', icon_state = "bar14", pixel_y = 4)
		overlays += hp_bar

	Tick()
		var/n = min(max(floor((GetHealth() / GetMaxHealth()) * 14), 0), 28)
		overlays -= hp_bar
		hp_bar = image(icon = 'icons/hpbar.dmi', icon_state = "bar[n]", pixel_y = 4)
		overlays += hp_bar
		..()

	Cross(var/mob/living/other)
		.=!GetHealth()
		if(istype(other))
			Fight(other)


	OnLeftClick()
		var/mob/living/O = usr
		if(istype(O))
			Fight(O)

	proc/Fight(var/mob/living/other)
		// Only phase ourselves with other monsters.
		if(!istype(other))
			return

		if(other.CanAttack(src))
			var/datum/dminfo/dmg = new(other, src, 0)
			other.Attack(dmg)
			if(dmg.damage)
				Attacked(dmg)
				if(dmg.damage)
					Damage(dmg)




		. = !GetHealth()


	proc/CanAttack(var/mob/living/other)
		// Also out of range
		if(get_dist(src, other) > GetReach(other))
			return 0


		// Dead thing
		if(other.GetHealth() == 0)
			return 0

		// Already attacked
		if(world.time >= next_attack)
			next_attack = world.time + attack_delay
			return 1
		return 0

	proc/Attack(var/datum/dminfo/dmg)
		dmg.damage = attack_damage
		MakeNoise(pick('sounds/battle/swing1.wav','sounds/battle/swing2.wav','sounds/battle/swing3.wav'))
		spawn(0)
			var/d = max(1, get_dist(dmg.target, dmg.challenger))
			var/x_off = (dmg.target.x - dmg.challenger.x) * 4 / d
			var/y_off = (dmg.target.y - dmg.challenger.y) * 4 / d
			animate(src, pixel_x = x_off, pixel_y = y_off, time = 1)
			spawn(1)
				animate(src, pixel_x = 0, pixel_y = 0, time = 1)

	proc/Attacked(var/datum/dminfo/dmg)
		if(prob(dodge_chance - dmg.hg_adv - dmg.improve_hit))
			Dodged(dmg)
			dmg.damage = 0

	proc/Damage(var/datum/dminfo/dmg)
		SetHealth(max(0, GetHealth() - dmg.damage))
		if(GetHealth() == 0)
			spawn(10)
				qdel(src)
			Die()
			icon_state = GetDeadIcon()

	proc/Dodged(var/datum/dminfo/dmg)
		spawn(0)
			var/d = max(1, get_dist(dmg.target, dmg.challenger))
			var/x_off = (dmg.target.x - dmg.challenger.x) * 4 / d
			var/y_off = (dmg.target.y - dmg.challenger.y) * 4 / d
			animate(src, pixel_x = x_off, pixel_y = y_off, time = 1)
			spawn(1)
				animate(src, pixel_x = 0, pixel_y = 0, time = 1)

	proc/GetReach(var/mob/living/other)
		return 1.5

	proc/GetDeadIcon()
		return "[icon_state]_dead"

	proc/Die()

	proc/GetHealth()
		return hp

	proc/GetMaxHealth()
		return max_hp

	proc/SetHealth(var/n)
		hp = n