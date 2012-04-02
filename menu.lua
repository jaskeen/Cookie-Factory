-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------


local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------


-- forward declarations and other locals
local trainingBtn
local deliveryBtn
local supervisorBtn
--local onTrainingBtnRelease={}


-- 'onRelease' event listener for trainingBtn
function onBtnRelease(event)
	
	-- go to scene1.lua scene
	storyboard.gotoScene( event.target.scene)
	print ("width:".._W, "height:".._H)
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "images/Splash-background.png", _W, _H)
	background:setReferencePoint( display.CenterReferencePoint )
	background.x=_W/2
	background.y=_H/2
	
	
	-- create a widget button (which will loads scene1.lua on release)
	trainingBtn = widget.newButton{
		default="images/trainingMode.png",
		onRelease = onBtnRelease	-- event listener function
		}
	trainingBtn:setReferencePoint( display.CenterReferencePoint )
	trainingBtn.x = _W/2 - 60
	trainingBtn.y = _H/2 - 60
	trainingBtn.scene="training"


	deliveryBtn = widget.newButton{
		default="images/deliveryMode.png",
		onRelease = onBtnRelease	-- event listener function
	}
	deliveryBtn:setReferencePoint( display.CenterReferencePoint )
	deliveryBtn.x = _W*0.5 - 60
	deliveryBtn.y = _H/2 + 15
	deliveryBtn.scene= "delivery"
	
	
	loadingDockBtn = widget.newButton{
		default="images/supervisorMode.png",
		onRelease = onBtnRelease	-- event listener function
	}
	loadingDockBtn:setReferencePoint( display.CenterReferencePoint )
	loadingDockBtn.x = _W*0.5 - 60
	loadingDockBtn.y = _H/2 + 90
	loadingDockBtn.scene= "loadingDock"

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( trainingBtn )
	group:insert( deliveryBtn )
	group:insert( loadingDockBtn )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		print "playBtn exists"
		playBtn:removeSelf( )	-- widgets must be manually removed
		playBtn = nil
	end
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene