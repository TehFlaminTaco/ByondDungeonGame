/obj/item
	icon = 'icons/item.dmi'

	OnLeftClick()
		var/mob/living/player/P = usr
		if(!istype(P))
			return
		if(loc == P) // Are we held by the user?
			Use(P)
		else if(get_dist(P, src)<=1)
			Pickup(P)

	proc/Use(var/mob/living/player/P)

	proc/Pickup(var/mob/living/player/P)
		MakeNoise('sounds/inventory/cloth-heavy.wav')
		loc = P
		P.inventory += src

	proc/Dropped(var/mob/living/player/P)
		return 1

	verb/Drop()
		set category = null
		var/mob/living/player/P = usr
		if(!istype(P))
			return
		if(!(src in P.inventory))
			return
		if(Dropped(loc))
			P.inventory -= src
			loc = P.loc
			pixel_z = loc.pixel_z

/obj/item/resource
	var/resource_name =""

	proc/get_amount()
		return 1

	Crossed(atom/O)
		if(istype(O, /mob/living/player))
			var/mob/living/player/P = O
			Pickup(P)
			return 1
		return 0


	Pickup(var/mob/living/player/P)
		MakeNoise(pick('sounds/inventory/coin1.wav','sounds/inventory/coin2.wav','sounds/inventory/coin3.wav'))
		var/datum/resource/R = P.resources[resource_name]
		if(istype(R))
			R.add(get_amount())
			qdel(src)


/obj/item/resource/gold
	icon_state = "gold"
	real_name ="gold"
	resource_name ="gold"

	get_amount()
		return rand(1, 5)

/obj/item/resource/gold/med
	get_amount()
		return rand(4, 10)

/obj/item/resource/gold/large
	get_amount()
		return rand(8, 20)

/obj/item/resource/ammo
	icon_state = "arrow"
	real_name = "arrow"
	resource_name = "ammo"

	get_amount()
		return 1

/obj/item/resource/ammo/five
	get_amount()
		return 5

/obj/item/resource/ammo/ten
	get_amount()
		return 10

/obj/item/potion
	real_name = "potion"
	desc = "Magical Effects!"
	var/max_charges = 5
	var/charge = 0

	New()
		..()
		charge = max_charges


	Use(var/mob/living/player/P)
		charge -= Effect(P)
		if(charge == 0)
			P.inventory += new/obj/item/empty_pot(P)
			qdel(src)

	Stat()
		stat("", "charges: [charge]")

	UpdateName()
		name = "[real_name] ([charge]/[max_charges])"

	proc/Effect(var/mob/living/player/P)

/obj/item/potion/health
	real_name ="health potion"
	desc = "Restores Health"
	icon_state = "pot_health"

	Effect(var/mob/living/player/P)
		var/i = 0
		while(i < charge && (P.GetHealth() < P.GetMaxHealth()))
			P.SetHealth(P.GetHealth() + 1)
			i++
		return i

	Examine()
		var/mob/living/player/P = usr
		if(istype(P))
			usr << "Restores up to \icon[P.resources["health"].img][charge]"
		else
			..()

/obj/item/potion/health_overheal
	real_name ="overheal potion"
	desc = "Heals the Healthy"
	icon_state = "pot_over"
	max_charges = 14

	Effect(var/mob/living/player/P)
		if(P.GetHealth() == P.GetMaxHealth())
			P.SetHealth(P.GetMaxHealth() + charge)
			return charge
		return 0


/obj/item/empty_pot
	real_name ="empty potion"
	desc = "Once held great magic."
	icon_state = "pot_empty"

