/obj/item/equipment
	var/slot

	Use(var/mob/living/player/P)
		if(src in P.inventory)
			Equip()
		else
			UnEquip()

	proc/Equip()
		MakeNoise('sounds/inventory/cloth-heavy.wav')
		var/mob/living/player/P = loc
		if(!istype(P))
			return 0 // Cannot Equip into a non-player.
		if(src in P.inventory)
			var/obj/item/equipment/in_slot = P.equipment[slot]
			if(in_slot != null)
				if(!in_slot.UnEquip()) // Something preventing it from unequipting, like a curse perhaps.
					return 0 // Cannot equip over a filled slot.
			P.equipment[slot] = src
			P.inventory -= src
			return 1 // We succeded.
		return 0 // We're not in the players inventory..?

	proc/UnEquip()
		MakeNoise('sounds/inventory/cloth-heavy.wav')
		var/mob/living/player/P = loc
		if(!istype(P))
			return 0 // Cannot Equip into a non-player.
		P.equipment[slot] = null // Remove us from the slot.
		P.inventory += src // Add to the inventory
		return 1

