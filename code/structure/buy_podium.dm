/obj/structure/buy_podium
	var/cost = 0
	var/hold_type = null
	var/obj/item/held = null
	icon_state = "buy_podium"

	Init()
		..()
		if(hold_type)
			held = new hold_type(src)

		update_icon()

	proc/update_icon()
		overlays.Cut()
		if(istype(held))
			real_name ="Buy: [held]"
			var/image/hold = image(held.icon, held.icon_state)
			hold.pixel_x = 0
			hold.pixel_y = 0
			hold.transform /= 2

			overlays += hold
		else
			real_name ="Buy: Nothing"
			desc = "There is nothing to buy. It's probably free."

	Examine()
		if(istype(held))
			usr << "It holds \an [held] \icon[held]"
			held.Examine()
			var/mob/living/player/P = usr
			if(istype(P))
				if(cost)
					usr << "It costs \icon[P.resources["gold"].img][cost]"
				else
					usr << "It's free."
			else
				usr << "You can't buy it. You're not real."

	Cross(atom/O)
		var/mob/living/player/P = O
		if(istype(P))
			if(held)
				var/datum/resource/gold = P.resources["gold"]
				if(gold.current >= cost)
					gold.remove(cost)
					held.loc = loc
					held.Pickup(P)
					P << "You buy \an [held] \icon[held]"
					held = null
					update_icon()
				else
					P << "You cannot afford \the [held] \icon[held]"

			return 0
		return 1