/obj/structure/generator
	var/max_count = 1
	var/spawn_delay = 5
	var/next_spawn = 0

	density = 0

	var/T = null
	var/list/spawns = null

	Init()
		..()
		spawns = list()
		for(var/atom/movable/A in loc.contents)
			if(A == src)
				continue
			T = A.type
			qdel(A)
			return

	Tick()
		..()
		for(var/atom/movable/I in spawns)
			if(!istype(I) || !I)
				spawns -= I
		for(var/mob/living/player/P in orange(src, 9)) // Don't spawn infront of the player.
			return
		if(spawns.len >= max_count)
			return
		//if(world.time >= next_spawn)
			//next_spawn = world.time + spawn_delay
		spawns += new T(src.loc)