#define JUMP_HEIGHT 16
//#define HALF_JUMP_TIME 4

/turf
	icon = 'icons/turf.dmi'
	var/floor_z = 2

	proc/isShear(var/turf/other)
		return floor_z - other.floor_z > 1

	/*Enter(atom/movable/O, atom/newloc)
		. = ..()
		if(floor_z == 0)
			. = 0
		var/turf/T = newloc
		if(istype(T))
			if(isShear(T))
				. = 0*/

	/*Exit(atom/movable/O, atom/newloc)
		. = ..()
		var/mob/M = O

		var/turf/T = newloc
		if(istype(T))
			if(istype(M))
				if(M.flags & FLYING) // Flying mobs ignore falling and shiz.
					if(T.floor_z == 0)
						return 0
					return .
			if(T.isShear(src)) // Cannot climb up.
				return 0
			var/turf/fall_to = try_fall(T, floor_z)
			if(!istype(fall_to))
				return 0
			return ..(O, fall_to)

	Exited(atom/movable/O, atom/newloc)
		var/turf/T = newloc
		if(!istype(T))
			return ..()
		var/mob/M = O
		var/fly = 0
		if(istype(M))
			if(M.flags & FLYING) // Flying mobs ignore falling and shiz.
				fly = 1
		var/turf/fall_to = fly ? T : try_fall(T, floor_z)
		O.loc = fall_to
		var/HALF_JUMP_TIME = 4
		if(istype(M))
			HALF_JUMP_TIME = M.move_speed / 2
		if(abs(fall_to.floor_z - floor_z) > 1 && !fly)
			spawn(0)
				O.pixel_x = (x - fall_to.x) * 16
				O.pixel_y = (y - fall_to.y) * 16
				animate(O, pixel_x = O.pixel_x/2, pixel_y = O.pixel_y/2, time = HALF_JUMP_TIME)
				animate(O, pixel_y = JUMP_HEIGHT, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE, time = HALF_JUMP_TIME)
				if(istype(M) && istype(M.client))
					M.client.pixel_x = (x - fall_to.x) * 16
					M.client.pixel_y = (y - fall_to.y) * 16
					animate(M.client, pixel_x = M.client.pixel_x/2, pixel_y = M.client.pixel_y/2, time = HALF_JUMP_TIME)
					animate(M.client, pixel_y = JUMP_HEIGHT, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE, time = HALF_JUMP_TIME)
				spawn(HALF_JUMP_TIME)
					animate(O, pixel_x = 0, pixel_y = JUMP_HEIGHT, time = HALF_JUMP_TIME)
					animate(O, pixel_y = -JUMP_HEIGHT, easing = SINE_EASING | EASE_IN, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE, time = HALF_JUMP_TIME)
					if(istype(M) && istype(M.client))
						animate(M.client, pixel_x = 0, pixel_y = JUMP_HEIGHT, time = HALF_JUMP_TIME)
						animate(M.client, pixel_y = -JUMP_HEIGHT, easing = SINE_EASING | EASE_OUT, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE, time = HALF_JUMP_TIME)
		else // Move smoothly to the new location.
			spawn(0)
				O.pixel_x = (x - fall_to.x) * 16
				O.pixel_y = (y - fall_to.y) * 16
				animate(O, pixel_x = 0, pixel_y = 0, time = HALF_JUMP_TIME * 2)
				if(O.move_state)
					flick(O.move_state, O)

				if(istype(M) && istype(M.client))
					M.client.pixel_x = (x - fall_to.x) * 16
					M.client.pixel_y = (y - fall_to.y) * 16
					animate(M.client, pixel_x = 0, pixel_y = 0, time = HALF_JUMP_TIME * 2)*/

	Exit(atom/movable/O, atom/newloc)
		. = ..()
		var/turf/T = newloc
		if(istype(T))
			if(T.floor_z == 0)
				. = 0
			if(T.isShear(src))
				. = 0

	Exited(atom/movable/O, atom/newloc)
		. = ..()
		var/turf/T = newloc
		if(istype(T))
			if(newloc.pixel_z < pixel_z)
				var/mob/M = O
				O.pixel_z = pixel_z
				var/fall_time = (floor_z - T.floor_z) * 2
				if(istype(M))
					M.next_move = world.time + fall_time
					if(istype(M.client))
						M.client.pixel_z = pixel_z - newloc.pixel_z
						animate(M.client, pixel_z = 0, easing = QUAD_EASING, time = fall_time)
				animate(O, pixel_z = newloc.pixel_z, easing = QUAD_EASING, time = fall_time)

	Entered(atom/movable/O, atom/oldloc)
		O.pixel_z = pixel_z
		var/mob/M = O
		if(istype(M) && istype(M.client))
			M.client.fake_eye.loc = locate(x, y + pixel_z / 16, z)
		return ..()


/client
	var/obj/fake_eye
	New()
		fake_eye = new/obj()
		eye = fake_eye
		..()

/atom/movable
	New()
		..()
		if(istype(loc))
			pixel_z = loc.pixel_z

	Init()
		..()
		if(istype(loc))
			pixel_z = loc.pixel_z

/turf/floor
	desc = "A stone floor. Sturdy?"
	icon = 'icons/floor_placeholder.dmi'
	icon_state = "floor"
	Init()
		..()
		icon = 'icons/turf.dmi'
		icon_state = floor_z ? "floor" : "hole"
		desc = floor_z ? initial(desc) : "An endless abyss. Spooky."

		pixel_z = floor_z * 8
		var/N = floor_z
		while(N >= 2)
			N -= 2
			overlays += image('icons/turf.dmi', N?"cavewall":"cavewall_hole", pixel_z = -(floor_z - N) * 8)

		var/turf/north = locate(x, y+1, z)
		var/turf/east = locate(x+1, y, z)
		var/turf/south = locate(x, y-1, z)
		var/turf/west = locate(x-1, y, z)

		if(istype(north) && north.floor_z < floor_z)
			overlays += image('icons/cave_upper.dmi', "caveside", dir = NORTH)
		if(istype(east) && east.floor_z < floor_z)
			overlays += image('icons/cave_upper.dmi', "caveside", dir = EAST)
		if(istype(south) && south.floor_z < floor_z)
			overlays += image('icons/cave_upper.dmi', "caveside", dir = SOUTH)
		if(istype(west) && west.floor_z < floor_z)
			overlays += image('icons/cave_upper.dmi', "caveside", dir = WEST)

/*/turf/Init()
	..()
	var/turf/floor/south = locate(x, y-1, z)
	if(istype(south) && south.floor_z < floor_z && (isShear(south)))
		(new/turf/cavewall(south)).floor_z = floor_z - 2*/

/turf/wall
	desc = "A solid looking wall."
	opacity = 0

	isShear(var/turf/other)
		return istype(other, /turf/wall) ? 0 : ((floor_z+2) - other.floor_z) > 1

	Init()
		..()
		var/turf/wall/wallNorth = locate(x, y+1, z)
		var/turf/wall/wallSouth = locate(x, y-1, z)

		if(istype(wallNorth))
			if(istype(wallSouth))
				dir = EAST
			else
				dir = NORTH
		else
			if(istype(wallSouth))
				dir = WEST
			else
				dir = SOUTH

	Entered(atom/movable/O, turf/oldloc)
		O.pixel_z = 8

	Exited(atom/movable/O, turf/newloc)
		O.pixel_z = 0

/turf/wall/gray
	icon_state = "wall_gray"

/turf/wall/red
	icon_state = "wall_red"

/turf/cavewall
	icon_state = "cavewall"
	Init()
		..()
		var/turf/floor/south = locate(x, y-1, z)
		icon_state = floor_z ? "cavewall" : "cavewall_hole"
		if(floor_z > 0)
			if(!istype(south))
				return
			if(floor_z == south.floor_z)
				return
			//(new/turf/cavewall(south)).floor_z = floor_z - 2
			return


	Enter(atom/movable/O, turf/oldloc)
		if(!(get_dir(oldloc,src)==SOUTH || oldloc.floor_z > floor_z))
			return 0
		return get_step(src, SOUTH).Enter(O, src) && ..() // Can you slide into the next position?

	Entered(atom/movable/O, atom/oldloc)
		..()
		spawn(1)
			O.Move(get_step(src, SOUTH))

/turf/bridge

	floor_z = 90

	Init() // Does not spawn falling walls

	isShear(var/turf/other)
		var other_dir = get_dir(other, src)
		return !((other_dir == NORTH || other_dir == SOUTH) == (dir == NORTH || dir == SOUTH))


/turf/bridge/stone
	icon_state = "bridge_stone"

/turf/bridge/wood
	icon_state = "bridge_wood"