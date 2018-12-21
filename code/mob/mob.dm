/mob
	var/move_speed = 1
	var/next_move = 0
	var/flags = 0
	icon = 'icons/mob.dmi'

	Move(var/newloc, var/newdir)
		if(world.time >= next_move || !newdir)
			. = ..()
			next_move = world.time + move_speed