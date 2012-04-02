----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require "storyboard" 
local widget= require "widget"
local scene = storyboard.newScene()
local physics = require "physics"
physics.start()
physics.setGravity(0,0)

_H = display.contentHeight
_W = display.contentWidth

--Variables and Functions

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
	
	local loadingDockTitle=display.newImageRect("images/supervisorMode.png", 300, 60)
	loadingDockTitle:setReferencePoint( display.CenterReferencePoint )
	loadingDockTitle.x = _W/2 
	loadingDockTitle.y = _H/2 
	
	group:insert(factoryBG)
	group:insert(loadingDockTitle)
	group:insert(homeBtn)
	
----Create TRUCKS--------------------------------
	
	local truck1 = display.newImageRect( "images/truckTemp.png", 200, 150  )
	truck1.x = _W/2
	truck1.y = 85
	--physics.addBody( truck1, "kinematic", { friction=0.7 } )
	--truck1.isPlatform = true -- custom flag, used in drag function above
	
	local truck2= display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck2.x = _W/2
	truck2.y = 285
	--physics.addBody( truck2, "kinematic", { friction=0.7 } )
	--truck2.isPlatform = true -- custom flag, used in drag function above
	
	local truck3 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck3.x = _W/2
	truck3.y = 485
	--physics.addBody( truck3, "kinematic", { friction=0.7 } )
	--truck3.isPlatform = true -- custom flag, used in drag function above
	
	local truck4 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck4.x = _W/2
	truck4.y = 675
	--physics.addBody( truck4, "kinematic", { friction=0.7 } )
	--truck4.isPlatform = true -- custom flag, used in drag function above

----Create a truck group so they can move together-------------------------
	
	function truckNum1()
		local randNum = math.random(0,1000)
		print (randNum)
		local truckNum1= display.newText(randNum,  _W/2, 75, native.systemFont, 16)
			truckNum1:setTextColor(255, 255, 255)
	end
	
	local truckGroup = display.newGroup()
		truckGroup:insert(truck1)
		truckGroup:insert(truck2)
		truckGroup:insert(truck3)
		truckGroup:insert(truck4)
		--truckGroup:insert(truckNum1)
	
		truckGroup.x=300
	
	
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Add touch event listeners to objects

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