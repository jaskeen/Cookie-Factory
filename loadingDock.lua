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

--number of cookies
--[[c = 0
totalCookies=3
ready=false
]]

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
local loadingDockTitle
local truckNum
local truckNum2
local truckNum3
local truckNum4
local cookie
local spawnCookies
local cookie1
local cookie2
local cookie3



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
	
----Spawn Cookies Function
	
--[[function spawnCookies(name, value,w,h, units, radius, shape,x,y)
	image = ("images/"..name..value..".png")
	cookie = display.newImageRect(image, w,h)
	cookie: setReferencePoint(display.CenterReferencePoint)
	cookie.name = name
	cookie.value = value or 1
	cookie.x=100
	cookie.y=math.random(100,_H-200)
	cookie.units = units
	physics.addBody(cookie, {radius=radius, shape=shape})
	cookie.isFixedRotation = true
	cookie.linearDamping = 9
	
	--every time a cookie is spawn, increment c by 1
	c = c+1
	
	--track the number of cookies spawn(c)
	if(c == 3)then
		ready=true
	else
		ready=false
	end
	
	cookie:addEventListener("touch", cookie)
	return cookie
	
end
]]

function scene:createScene( event )
	local group = self.view

	
	---create 3 COOKIES----------------------------------------- 
	--PROBLEM: they are stuck... is it because of how I have them grouped? 
	cookie1=display.newImageRect("images/chocchip3.png", 150, 150)
	physics.addBody( cookie1, "kinematic", { friction=0.7 } )
		cookie1.x=150
		cookie1.y=200
	cookie2=display.newImageRect("images/chocchip300.png", 150, 150)
	physics.addBody( cookie2, "kinematic", { friction=0.7 } )
		cookie2.x=150
		cookie2.y=400
	cookie3=display.newImageRect("images/chocchip30.png", 150, 150)
	physics.addBody( cookie3, "kinematic", { friction=0.7 } )
		cookie3.x=150
		cookie3.y=600
		
	function cookieTouch(event)
		if(event.phase=="began")then
			print("began")
		elseif(event.phase=="moved")then
			print("moved")
		elseif(event.phase=="ended")then
			print("ended")
		end
	end
	
	cookie1:addEventListener("touch", cookieTouch)
	cookie2:addEventListener("touch", cookieTouch)
	cookie3:addEventListener("touch", cookieTouch)
	
	
	--[[cookieGroup = display.newGroup()
		cookieGroup:insert(cookie1)
		cookieGroup:insert(cookie2)
		cookieGroup:insert(cookie3)
	]]
			
	----Create TRUCKS--------------------------------
	
	truck1 = display.newImageRect( "images/truckTemp.png", 200, 150  )
	truck1.x = _W/2
	truck1.y = 85
	physics.addBody( truck1, "kinematic", { friction=0.7 } )
	--truck1.isPlatform = true -- custom flag, used in drag function above
	
	truck2= display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck2.x = _W/2
	truck2.y = 285
	physics.addBody( truck2, "kinematic", { friction=0.7 } )
	--truck2.isPlatform = true -- custom flag, used in drag function above
	
	truck3 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck3.x = _W/2
	truck3.y = 485
	physics.addBody( truck3, "kinematic", { friction=0.7 } )
	--truck3.isPlatform = true -- custom flag, used in drag function above
	
	truck4 = display.newImageRect( "images/truckTemp.png", 200, 150 )
	truck4.x = _W/2
	truck4.y = 675
	physics.addBody( truck4, "kinematic", { friction=0.7 } )
	--truck4.isPlatform = true -- custom flag, used in drag function above

	function truckNum()
		truckNum = math.random(0,9)
		print (truckNum)
		
	end
	
	truckNum= display.newText("truckNum",  (_W/2)-50, 75, native.systemFontBold, 20)
			--I want truckNum from the function to be the text, not "truckNum"
			--so it would be 4 random numbers concatinated
			--truckNum".."truckNum".."truckNum".."truckNum".."truckNum
			truckNum:setTextColor(255, 255, 255)
			
	truckNum2= display.newText("truckNum",  (_W/2)-50, 275, native.systemFontBold, 20)
			truckNum:setTextColor(255, 255, 255)
	
	truckNum3= display.newText("truckNum",  (_W/2)-50, 475, native.systemFontBold, 20)
			truckNum:setTextColor(255, 255, 255)
			
	truckNum4= display.newText("truckNum",  (_W/2)-50, 675, native.systemFontBold, 20)
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
	
	loadingDockTitle=display.newImageRect("images/supervisorMode.png", 300, 60)
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

--[[Runtime:addEventListener("touch", cookie1 )
Runtime:addEventListener("touch", cookie2)	
Runtime:addEventListener("touch", cookie3)
	]]
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