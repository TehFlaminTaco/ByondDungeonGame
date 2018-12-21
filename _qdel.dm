proc/qdel(atom/A)
	spawn(0)
		del(A)

#define del qdel