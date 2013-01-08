-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
_W=display.contentWidth
_H=display.contentHeight
physics = require "physics"
mainFont = "Bell Gothic Std Black"
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
storyboard = require "storyboard"
storyboard.isDebug = true

-- load menu screen
storyboard.gotoScene( "menu" )
storyboard.purgeOnSceneChange = true
