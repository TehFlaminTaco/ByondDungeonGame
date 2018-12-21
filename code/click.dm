atom

	Click(var/loc, var/control, var/param)
		var/params = params2list(param)
		if(params["shift"])
			OnShiftClick()
		else if(params["left"])
			OnLeftClick()


	proc/OnLeftClick()

	proc/OnShiftClick()
		Examine()
