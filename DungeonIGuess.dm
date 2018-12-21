/*
	These are simple defaults for your project.
 */

var/start_time

world
	fps = 30		// 30 frames per second
	icon_size = 16	// 32x32 icon size by default

	view = 7		// show up to 6 tiles outward from center (13x13 view)
	mob = /mob/living/player
	turf = /turf/floor
	map_format = SIDE_MAP
	New()
		..()
		start_time = world.time + 30

mob
	step_size = 16

obj
	step_size = 16

atom
	New()
		..()
		UpdateName()
		spawn(0)
			spawn(max(world.time - start_time, 1))
				Init()

	proc/Init()

	proc/Examine()
		usr << desc

	proc/MakeNoise(var/noise)
		var/sound/S = sound(noise)
		for(var/mob/M in world)
			S.x = x - M.x
			S.y = y - M.y
			S.z = pixel_z - M.pixel_z
			M << S

	var/real_name

	proc/UpdateName()
		name = real_name
