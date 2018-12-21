/datum/mob_ticker
	var/list/mobs = list()
	New()
		mob_tick()


	proc/mob_tick()
		set background = 1
		spawn(1)
			for(var/mob/M in mobs)
				M.Tick()
			mob_tick()

/mob
	proc/Tick()
	Init()
		. = ..()
		ssMob.mobs += src

	Del()
		ssMob.mobs -= src
		. = ..()

var/datum/mob_ticker/ssMob = new()