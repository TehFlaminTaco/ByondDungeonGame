/obj/structure
	icon = 'icons/structure.dmi'
	density = 1

/datum/struct_ticker
	var/list/objs = list()
	New()
		obj_tick()


	proc/obj_tick()
		set background = 1
		spawn(1)
			for(var/obj/structure/S in objs)
				S.Tick()
			obj_tick()

/obj/structure
	proc/Tick()
	Init()
		. = ..()
		ssStruct.objs += src

	Del()
		ssStruct.objs -= src
		. = ..()

var/datum/struct_ticker/ssStruct = new()