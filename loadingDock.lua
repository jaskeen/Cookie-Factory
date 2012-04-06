----------------------------------------------------------------------------------
---- loadingDock.lua
------------------------------------------------------------------------------------
local generate = require "generateNumInfo"
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
local factoryBG, homeBtn,truck1,truck2,truck3,truck4,object1,object2,object3
local loadingDockTitle,truckNum,truckNum2,truckNum3,truckNum4,cookie,spawnCookies
local cookie1,cookie2,cookie3
local myObject
local startDrag
local level
	--From generateNumInfo
	local newList



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
level=5	

-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch
end
	



--Traffic light with the #of cookies as red circles
	--when one correct match is made, one of the red circles becomes green
	--when all of the circles are green, the timer stops and the game is finished
--Timer: the amount of time it takes to get all of the trucks loaded correctly
	
function scene:createScene( event )
	local group = self.view

	
	
--DRAG FUNCTION	
function startDrag( event )
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
		event.target.isFixedRotation= true
		
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
	--end the touch event when ended
	return true
end

--Spawn cookies, which should be the #trucks-1
	--the omitted# from the trucks (with the exception of 1) will determine the cookie to appear
	
--Create the Cookies
	cookie1=display.newText("Value#1",  (_W/2)-50, 275, native.systemFontBold, 30)
	physics.addBody( cookie1, "kinematic", { friction=0.7 } )
				cookie1.x=150
		cookie1.y=200
	cookie2=display.newText("Value#2",  (_W/2)-50, 275, native.systemFontBold, 30)
	physics.addBody( cookie2, "kinematic", { friction=0.7 } )
		cookie2.x=150
		cookie2.y=400
	cookie3=display.newText("Value#3",  (_W/2)-50, 275, native.systemFontBold, 30)
	physics.addBody( cookie3, "kinematic", { friction=0.7 } )
		cookie3.x=150
		cookie3.y=600


-- Add touch event listeners to objects
	--make cookies DRAGGABLE
cookie1:addEventListener( "touch", startDrag )
cookie2:addEventListener( "touch", startDrag )
cookie3:addEventListener( "touch", startDrag )
	
	
	
	----Create TRUCKS--------------------------------
--Spawn trucks, which should either be a constant 4 trucks OR the level+2 trucks
	--each truck will have a random number with one ommitted# displayed on it
	--make trucks SENSORS
	
	truck1 = display.newImageRect( "images/truckTemp.png", 200, 150  )
	truck1.x = _W/2
	truck1.y = 85
	physics.addBody( truck1, "kinematic", { isSensor=true } )
	--truck1.isPlatform = true -- custom flag, used in drag function above
	
	truck2= display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck2.x = _W/2
	truck2.y = 285
	physics.addBody( truck2, "kinematic", { isSensor=true } )
	--truck2.isPlatform = true -- custom flag, used in drag function above
	
	truck3 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck3.x = _W/2
	truck3.y = 485
	physics.addBody( truck3, "kinematic", { isSensor=true } )
	--truck3.isPlatform = true -- custom flag, used in drag function above
	
	truck4 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck4.x = _W/2
	truck4.y = 675
	physics.addBody( truck4, "kinematic", { isSensor=true } )
	--truck4.isPlatform = true -- custom flag, used in drag function above

	function truckNum()
		truckNum = math.random(0,9)
		print (truckNum)
		
	end
	
	truckNum= display.newText("Omitted#1",  (_W/2)-50, 75, native.systemFontBold, 20)
			--I want truckNum from the function to be the text, not "truckNum"
			--so it would be 4 random numbers concatinated
			--truckNum".."truckNum".."truckNum".."truckNum".."truckNum
			truckNum:setTextColor(255, 255, 255)
			
	truckNum2= display.newText("Omitted#2",  (_W/2)-50, 275, native.systemFontBold, 20)
			truckNum:setTextColor(255, 255, 255)
	
	truckNum3= display.newText("Omitted#3",  (_W/2)-50, 475, native.systemFontBold, 20)
			truckNum:setTextColor(255, 255, 255)
			
	truckNum4= display.newText("Omitted#4",  (_W/2)-50, 675, native.systemFontBold, 20)
			truckNum:setTextColor(255, 255, 255)
----Create a truck group so they can move together-------------------------
	
	truckGroup = display.newGroup()
		truckGroup:insert(truck1)
		truckGroup:insert(truck2)
		truckGroup:insert(truck3)
		truckGroup:insert(truck4)
		truckGroup:insert(truckNum)
		truckGroup:insert(truckNum2)
		truckGroup:insert(truckNum3)
		truckGroup:insert(truckNum4)
			
	truckGroup.x=300
	
-------------------General Scene Images-----------------

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
	
	loadingDockTitle=display.newText("Loading Dock",  (_W/2)-50, 275, native.systemFontBold, 40)
	loadingDockTitle:setReferencePoint( display.CenterReferencePoint )
	loadingDockTitle.x = _W/2 
	loadingDockTitle.y = _H/2 
	
	
	group:insert(factoryBG)
	group:insert(loadingDockTitle)
	group:insert(homeBtn)
	group:insert(truckGroup)
	group:insert(cookie1)
	group:insert(cookie2)
	group:insert(cookie3)
	
	
		
	return true
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end

-- Add touch event listeners to objects


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	local newList = generate.generateNumInfos(3,5)
		--print the info about each num in the list
	print ("Num list has: "..#newList.." items.")
	for i=1,#newList do 
		print ("Number: "..newList[i].number, "places used: "..newList[i].place, "Value: "..newList[i].omittedValue,"Omitted Num: "..string.reverse(table.concat(newList[i].omittedReversedArray)))
	end
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