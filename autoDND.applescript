-- Note: export as application, checking "stay open after run handler"

global busyTimeout
global status

on run
	set busyTimeout to 0
	set status to "online"
end run

on idle
	tell application "PyCharm"
		if it is frontmost then
			set busyTimeout to 45 -- DND for at least 15 minutes
		end if
	end tell
	if busyTimeout > 0 then
		if status = "online" then
			tell application "Skype" to send command "SET USERSTATUS DND" script name "Working"
			set status to "dnd"
		end if
		set busyTimeout to busyTimeout - 1
	else if status = "dnd" then
		tell application "Skype" to send command "SET USERSTATUS ONLINE" script name "Working"
		set status to "online"
	end if
	return 20 -- check every 20 seconds
end idle

on quit
	tell application "Skype" to send command "SET USERSTATUS ONLINE" script name "Working"
	continue quit
end quit
