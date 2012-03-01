--COOKIE FACTORY MAIN--

_W=display.contentWidth
_H=display.contentHeight

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local director= require "director"

local mainGroup=display.newGroup()

local function main()
	--mainGroup:insert(director.directorView)
	director:changeScene("menu")
	return true
end

main()