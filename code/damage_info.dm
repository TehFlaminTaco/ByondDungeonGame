

/datum/dminfo
	var/damage = 0
	var/damage_type = 0
	var/improve_hit = 0
	var/mob/living/challenger = null
	var/mob/living/target = null
	var/hg_adv = 0 // IT'S OVER ANAKIN!

	New(var/mob/living/c, var/mob/living/t, var/amt, var/typ = SLASH)
		damage = amt
		damage_type = typ
		challenger = c
		target = t

		hg_adv = (get_turf(challenger).floor_z - get_turf(target).floor_z) * 10