proc/floor(var/n)
	return n|0

proc/get_turf(var/atom/N)
	if(!istype(N))
		return null
	if(istype(N, /turf))
		return N
	return get_turf(N.loc)

proc/atan2(x, y)
    if(!x && !y) return 0
    return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))

proc/get_3d_dist(atom/A, atom/B)
	return get_dist(A, B) + abs(get_turf(A).floor_z - get_turf(B).floor_z)/2


proc/try_fall(atom/loc, var/target_z)
	if(target_z == 0)
		return 0
	if(!istype(loc))
		return 0
	if(istype(loc,/turf/cavewall) || get_turf(loc).floor_z+1 < target_z)
		var/turf/S = get_step(loc, SOUTH)
		if(S.floor_z+1 > target_z)
			S = loc
		return try_fall(S, target_z-2)
	return loc

proc/get_raw_dist(atom/A, atom/B)
	return get_dist(A, B)


proc/rotate180(var/d)
	switch(d)
		if(NORTH)
			return SOUTH
		if(SOUTH)
			return NORTH
		if(EAST)
			return WEST
		if(WEST)
			return EAST
		if(NORTHEAST)
			return SOUTHWEST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTHWEST)
			return NORTHEAST
		if(NORTHWEST)
			return SOUTHEAST
	return 0

#define get_dist get_3d_dist