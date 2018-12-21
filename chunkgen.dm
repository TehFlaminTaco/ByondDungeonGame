/area/the_void
	name = "The Void"
	desc = "If you're here, be concerned..."

/area/spawned
	name = "The World"
	desc = "Something exists here."

var/list/chunks = list()
/obj/chunkgen
	var/size_x = 16
	var/size_y = 16
	icon = 'icons/huge.dmi'
	icon_state = "chunkgen"

	var/list/turfstorages = list()
	var/list/borders = list()

	var/lower_z = 12
	var/upper_z = 0
	New()
		..()
		spawn(0)
			for(var/X = 1 to size_x)
				for(var/Y = 1 to size_y)
					var/turf/T = locate(x + X - 1, y + Y - 1, z)
					if(T.floor_z == 0)
						continue // Ignore holes
					lower_z = min(lower_z, T.floor_z)
					upper_z = max(upper_z, T.floor_z)

			turfstorages.len = size_x
			for(var/X = 1 to size_x)
				var/list/current_x = list()
				current_x.len = size_y
				turfstorages[X] = current_x
				for(var/Y = 1 to size_y)
					var/datum/turf_info/i = new()
					current_x[Y] = i
					var/turf/T = locate(x + X - 1, y + Y - 1, z)
					i.turf_type = T.type
					i.floor_z = T.floor_z - lower_z + 2
					for(var/atom/A in T.contents)
						if(A == src)
							continue
						if(istype(A, /turf) || istype(A, /area))
							continue
						if(istype(A, /mob/living/player))
							continue
						if(istype(A, /obj/chunk_border))
							borders += new/datum/border_info(src, A, X, Y, T.floor_z - lower_z + 2)
							qdel(A)
							continue
						i.contents += new/datum/object_clone(A) // Clone the object.
						qdel(A)									// Destroy the object.
					(new/turf/floor(T)).floor_z = 0
			chunks += src
			loc = /area/the_void

	proc/GetBridges(var/d = 0)
		var/list/bridges = list()
		for(var/datum/border_info/B in borders)
			if(B.dir == d)
				bridges += B
		return bridges
	proc/GetOtherBridges(var/d = 0)
		var/list/bridges = list()
		for(var/datum/border_info/B in borders)
			if(B.dir != d)
				bridges += B
		return bridges

	proc/Spawn(var/x, var/y, var/z = 1, var/low_z = 6, var/d = 0, var/depth = 0)
		if(depth > 50)
			return 0
		if(low_z < 2)
			return 0
		if(low_z > 12)
			return 0
		// Check for spawned area.
		for(var/X = 1 to size_x)
			for(var/Y = 1 to size_y)
				var/datum/turf_info/i = turfstorages[X][Y]
				var/turf/T = locate(x + X - 1, y + Y - 1, z)
				if(!istype(T)) // Doesn't fit
					return 0
				if(i.floor_z && istype(T.loc, /area/spawned))
					return 0

		for(var/X = 1 to size_x)
			for(var/Y = 1 to size_y)
				var/datum/turf_info/i = turfstorages[X][Y]
				if(i.floor_z)
					var/turf/T = new i.turf_type(locate(x + X - 1, y + Y - 1, z)) // Spawn the turf at the location.
					T.floor_z = i.floor_z + low_z - 2
					new/area/spawned(T)
					for(var/datum/object_clone/A in i.contents)
						A.Spawn(T)

		// Create some random bridges.
		var/list/bridges = GetOtherBridges(d)
		for(var/N = 1 to 3) // Max of three bridges
			if(!bridges.len) // Out of bridges? End.
				break
			var/datum/border_info/B = pick(bridges) // Select a random bridge.
			bridges -= B
			var/dist = rand(1, 8)
			var/turf/targ = locate(x + B.x - 1, y + B.y - 1, z)
			var/giveup = 0
			for(var/S = 1 to dist)
				targ = get_step(targ, B.dir)
				if(!istype(targ)) // Outside of the bounds, give up.
					giveup = 1
					break
				if(istype(targ.loc, /area/spawned))
					giveup = 1
					break
			if(giveup)
				continue
			var/list/islands = chunks.Copy()
			var/obj/chunkgen/island = null
			while(islands.len && !istype(island))
				island = pick(islands)
				islands -= island
				var/list/oth_bridges = island.GetBridges(rotate180(B.dir))
				if(!oth_bridges.len)
					island = null
					continue
				var/datum/border_info/is_b = pick(oth_bridges) // Get a random island that can connect these two.
				if(!istype(is_b))
					island = null
					continue
				var/did_spawn = island.Spawn(targ.x - (is_b.x - 1), targ.y - (is_b.y - 1), z, low_z + (B.floor_z - is_b.floor_z), depth = depth + 1)
				if(!did_spawn)
					island = null

			if(island)
				for(var/datum/border_info/I in bridges)
					if(I.dir == B.dir) // Remove all similar bridges
						bridges -= I
				//targ = get_step(targ, B.dir)
				for(var/S = 1 to dist)
					var/turf/bT = (new/turf/floor(targ))
					bT.floor_z = B.floor_z + low_z - 2
					new/area/spawned(bT)
					targ = get_step(targ, rotate180(B.dir))

		return 1

/obj/chunk_border
	icon = 'icons/editor.dmi'
	icon_state = "chunk_border"

/datum/border_info
	var/dir = 0
	var/x = 0
	var/y = 0
	var/floor_z = 2
	New(var/obj/chunkgen/B, var/obj/chunk_border/B, var/X, var/Y, var/Z)
		..()
		x = X
		y = Y
		floor_z = Z
		dir = B.dir

/datum/object_clone
	var/obj_type = null
	var/list/obj_vars = null

	New(var/atom/A)
		obj_type = A.type
		obj_vars = list()
		for(var/i in A.vars)
			if(i in list("locs", "loc", "x", "y", "z", "verbs", "procs", "group"))
				continue
			if(A.vars[i] != initial(A.vars[i]))
				obj_vars[i] = A.vars[i]

	proc/Spawn(var/atom/loc)
		var/atom/movable/O = new obj_type(loc)
		for(var/name in obj_vars)
			O.vars[name] = obj_vars[name]

/datum/turf_info
	var/turf_type = null
	var/floor_z = 2
	var/list/contents = list()