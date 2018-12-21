/datum/resource
	var/real_name ="Resource"
	var/desc = "A generic resource. Not really useful."
	var/max = -1
	var/current = 0
	var/icon = 'icons/item.dmi'
	var/icon_state = ""
	var/image/img = null

	New()
		..()
		img = image(icon, icon_state)

	proc/add(var/amount)
		var/dif = min(current + amount, max) - current
		current = min(current + amount, max)
		return dif

	proc/remove(var/amount)
		var/dif = min(current, amount)
		current = current - dif
		return dif

/datum/resource/gold
	real_name ="Gold"
	desc = "Dolla Dolla"

	max = 100
	icon_state = "gold"


/datum/resource/health
	real_name ="Health"
	desc = "How alive is you?"

	max = 14
	icon_state = "pot_health"

/datum/resource/ammo
	real_name ="Ammo"
	desc = "How many arrows you have."

	max = 50
	icon_state = "arrow"