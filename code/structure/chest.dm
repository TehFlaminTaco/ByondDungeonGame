/obj/structure/chest
	icon_state = "chest0"
	real_name ="Chest"
	desc = "Sometimes holds goodies. Sometimes, holds other things."

	var/opened = 0


	proc/update_icon()
		icon_state = "chest[opened]"

	Init()
		..()
		update_icon()
		for(var/atom/movable/I in loc.contents)
			if(I != src)
				contents += I

	Cross(atom/O)
		var/old_opened = opened
		opened = 1
		density = 0
		loc.contents += contents
		update_icon()
		return old_opened