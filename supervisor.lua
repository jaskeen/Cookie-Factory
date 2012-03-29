----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget=require "widget"
local physics = require("physics")
physics.start()
local scene = storyboard.newScene()
local onBtnRelease
local factoryBG
local homeBtn
local truck1 
local truck2
local truck3
local truck4
local object1
local object2
local object3



----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
--Drag Function
local function startDrag( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
		
		-- Make body type temporarily "kinematic" (to avoid gravitional forces)
		event.target.bodyType = "kinematic"
		
		-- Stop current motion, if any
		event.target:setLinearVelocity( 0, 0 )
		event.target.angularVelocity = 0

	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			-- Switch body type back to "dynamic", unless we've marked this sprite as a platform
			if ( not event.target.isPlatform ) then
				event.target.bodyType = "dynamic"
			end

		end
	end
	-- Stop further propagation of touch event!
	return true
end

-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch
end
	

function scene:createScene( event )
	local group = self.view
	
	factoryBG= display.newImageRect("images/factoryBG.png", _W, _H)
	factoryBG:setReferencePoint(display.CenterReferencePoint)
	factoryBG.x = _W/2
	factoryBG.y = _H/2
	factoryBG.scene="menu"
	
	homeBtn=widget.newButton{
		default="images/homeBtn.png",
		width=80,
		height=80,
		onRelease = onBtnRelease	-- event listener function
		}
	homeBtn:setReferencePoint(display.CenterReferencePoint)
	homeBtn.x = _W*.06
	homeBtn.y = _H*.07
	homeBtn.scene="menu"
	
	local supervisorTitle=display.newImageRect("images/supervisorMode.png", 300, 60)
	supervisorTitle:setReferencePoint( display.CenterReferencePoint )
	supervisorTitle.x = _W/2 
	supervisorTitle.y = _H/2 

	local truck1 = display.newImageRect( "images/truckTemp.png" )
	truck1.x = 80
	truck1.y = 200
	physics.addBody( truck1, "kinematic", { friction=0.7 } )
	truck1.isPlatform = true -- custom flag, used in drag function above
	
	local truck2= display.newImageRect( "images/truckTemp.png" )
	truck2.x = 80
	truck2.y = 200
	physics.addBody( truck2, "kinematic", { friction=0.7 } )
	truck2.isPlatform = true -- custom flag, used in drag function above
	
	local truck3 = display.newImageRect( "images/truckTemp.png" )
	truck3.x = 80
	truck3.y = 200
	physics.addBody( truck3, "kinematic", { friction=0.7 } )
	truck3.isPlatform = true -- custom flag, used in drag function above
	
	local truck4 = display.newImageRect( "images/truckTemp.png" )
	truck4.x = 80
	truck4.y = 200
	physics.addBody( truck4, "kinematic", { friction=0.7 } )
	truck4.isPlatform = true -- custom flag, used in drag function above


	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	group:insert(factoryBG)
	group:insert(supervisorTitle)
	group:insert(homeBtn)
end






local cube = display.newImage( "house_red.png" ) -- I'm making a note here: huge success
cube.x = 80; cube.y = 150
physics.addBody( cube, { density=5.0, friction=0.3, bounce=0.4 } )


local crate = display.newImage( "crate.png" )
crate.x = 90; crate.y = 90
physics.addBody( crate, { density=3.0, friction=0.4, bounce=0.2 } )


local platform2 = display.newImage( "platform2.png" )
platform2.x = 240; platform2.y = 150
physics.addBody( platform2, "kinematic", { friction=0.7 } )
platform2.isPlatform = true -- custom flag again


local block = display.newImage( "books_red.png" )
block.x = 240; block.y = 125
physics.addBody( block, { density=1.0, bounce=0.4 } )
block.isFixedRotation = true -- books blocks don't rotate, they just fall straight down


-- Add touch event listeners to objects
platform1:addEventListener( "touch", startDrag )
platform2:addEventListener( "touch", startDrag )
cube:addEventListener( "touch", startDrag )
crate:addEventListener( "touch", startDrag )
block:addEventListener( "touch", startDrag )

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene