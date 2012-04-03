----------------------------------------------------------------------------------
--  PURPOSE:  To allow users to "build" and combine combinations of units to answer place value questions
-- note: uses official scenetemplate.lua
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget= require "widget"
local scene = storyboard.newScene()
--first, set the name of the current scene, so we can get it later, if needed
storyboard.currentScene = "training"
----------------------------------------------------------------------------------
--	NOTE:	Code outside of listener functions (below) will only be executed once, unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
display.setStatusBar( display.HiddenStatusBar )  -- hide the status bar
--import physics,  gameUI, activate multitouch
local convert = require ("convertNumToText")
local physics = require("physics")
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
--local gameUI = require("gameUI")
system.activate("multitouch")
----------------- VARIABLES --------------------------
_H = display.contentHeight
_W = display.contentWidth
local moveRate = 2 -- how fast the cookie moves across the screen
local createRate = 2000 --how often a new cookie is spawned (in milliseconds)
local level = 4; local thisLevel
local showValue = display.newRetinaText("",-200,-200, "Arial",48) --for showing value of the dragged item
local cloud = display.newImageRect("images/cloud.png",256,256) --cloud for transformations
cloud.x = -200
cloud.y = -200 
local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn --forward reference fcns



-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch and stops propagation
end


---------------------  CREATE SCENE: Called when the scene's view does not exist: ---------------------
	--	CREATE display objects and add them to 'group' here.
function scene:createScene( event ) 
	
	local group = self.view  --insert all display objects into this
	group:insert(cloud)
	group:insert(showValue)
	
	local bg = display.newImageRect("images/factoryBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	group:insert(bg)
	--local conveyorBelt = display.newImageRect("images/conveyorSprite.png",930, 190)
	--conveyorBelt:setReferencePoint(display.TopLeftReferencePoint)
	--conveyorBelt.x = 10; conveyorBelt.y = 70;
	local ipad = display.newImageRect("images/iPad.png",250, 200)
	ipad:setReferencePoint(display.TopLeftReferencePoint);
	ipad.x = 30; ipad.y = 550
	group:insert(ipad)
	---------------------------------------- Number BOXES ----------------------------------------
	local tenThousandsTray = display.newRect(0,0, 130, 40)
	tenThousandsTray:setFillColor(175)
	local thousandsTray = display.newRect(130,0, 130, 40)
	thousandsTray:setFillColor(100)
	local hundredsTray = display.newRect(260, 0, 130, 40)
	hundredsTray:setFillColor(200)
	local tensTray = display.newRect(390, 0, 130, 40)
	tensTray:setFillColor(150)
	local onesTray = display.newRect(520, 0, 130, 40)
	onesTray:setFillColor(255)
	--now put them all into a group so you can move the group around with ease
	local trayGroup = display.newGroup()
	trayGroup:insert(tenThousandsTray)
	trayGroup:insert(thousandsTray)
	trayGroup:insert(hundredsTray)
	trayGroup:insert(tensTray)
	trayGroup:insert(onesTray)
	trayGroup.x = 298; trayGroup.y = 645
	group:insert(trayGroup)
	
	
	homeBtn=widget.newButton{
		default="images/homeBtn.png",
		width=80,
		height=80,
		onRelease = onBtnRelease	-- event listener function
		}
	homeBtn:setReferencePoint(display.CenterReferencePoint)
	homeBtn.x = 45
	homeBtn.y = 35
	homeBtn.scene="menu"
	group:insert(homeBtn)

	
	--instead of creating an object for each cookie, let's only create objects that we'll actually use during this "round"
	local themes= {"creme", "pb","jelly","chocchip"}
	local theme = themes[level]
	local shapes = {}
	shapes[10] = {-30, -45,   8, -45,   25, 37,   23, 47,   -8, 47,   -30, -31}
	shapes[100] = {-40, -36,   28, -36,   40, -30,   40, 36,   -30, 36,   -40, 26}
	shapes[1000] = {-84, -54,   33, -54,   83, -8,   90, 48,   90, 54,   -40, 54,   -90, 6 }
	shapes[10000] = {-90,-90,   34,-96,   91,-58,   90,87,   -54, 94,    -90,52}
	local items = {}
	createItemsForThisLevel = function(theme)
		items[1] = {name = theme, value = 1, w=48, h=48, units = 1, radius=24}
		items[10] = {name=theme, value = 10, w=80, h=95, units=10, radius=0, shape= shapes[10]}
		items[100] = {name=theme, value = 100, w=80,h=71, units=100, radius=0, shape=shapes[100]}
		items[1000] = {name=theme,value=1000, w=180,h=108, units=1000, radius=0, shape= shapes[1000]}
		items[10000] = {name=theme,value = 10000, w=180,h= 189, units=10000, radius=0, shape = shapes[10000] }
		for i=9,1.9, -1 do 
			items[i] = {name=theme, value = 10, w=80, h=95, units=1, radius=0, shape=shapes[10]}
		end
		for i=90,19,-10 do 
			items[i] = {name=theme, value = 100, w=80,h=71, units=10, radius=0, shape=shapes[100]}
		end
		for i=900, 199, -100 do 
			items[i] = {name=theme,value=1000, w=180,h=108, units=100, radius=0, shape=shapes[1000]}
		end
		for i=9000,1999, -1000 do 
			items[i] = {name=theme,value = 10000, w=180,h= 189, units=1000, radius=0, shape = shapes[10000]}
		end
	end
	createItemsForThisLevel(theme)
	
	--list which cookies are available on each level
	local levelObjects = {
		{items[1], items[1], items[1], items[10]},
		{items[1], items[10],items[1], items[1], items[100]},
		{items[1], items[10],items[100], items[1], items[1], items[1000]},
		{items[1], items[10],items[100], items[1], items[10], items[1], items[1000], items[10000]},
	}
	thisLevel = levelObjects[level]
		
	
	----------------------------------------- FUNCTIONS ----------------------------------------------
	--handler for making a new item appear
	local function comboItem(x,y, remainder, newItems, newValue,units)
		--cancel all the timers
		timer.cancel(disappearTimer)
		timer.cancel(itemHitTimer)
		timer.cancel(onLocalCollisionTimer)
		if (newItems == "same" or newItems=="nextItem") then
			--see if this stays in the same units or if it moves up a unit
			if (newItems == "nextItem") then
				thisValue = units*10
			else
				thisValue = newValue
			end
			local i = items[thisValue]
			local newUnits = i.units
			local name = i.name
			local w = i.w 
			local h = i.h 
			local radius = i.radius
			local shape = i.shape 
			local cookie1=spawnCookie(name, thisValue ,w,h, newUnits, radius, shape, x+i.w/2, y+i.h/3)
			cookie1.moved="yes"
			group:insert(cookie1)
			return true
		elseif (newItems == "twoItems") then
			--get the info for an item 1 type up 
			print ("creating an image a unit up")
			local newUnits = units*10
			local n = items[newUnits]
			local newName = n.name
			local newW = n.w 
			local newH = n.h 
			local newUnits = n.units
			local newRadius = n.radius
			local newShape = n.shape
			local cookie2 = spawnCookie(newName, units*10,newW,newH, newUnits, newRadius, newShape, x-30, y)
			cookie2.moved ="yes"
			--now create the same kind of item, with the remaining value
			local j = items[remainder]
			local newUnits = j.units
			local name = j.name
			local w = j.w 
			local h = j.h 
			local radius = j.radius
			local shape = j.shape 
			local cookie1=spawnCookie(name, remainder ,w,h, units, radius, shape, x+j.w/2, y+j.h/3)
			cookie1.moved="yes"
			group:insert(cookie1)
			group:insert(cookie2)
			return true
		end
	end
	
	--handler to make the cloud disappear
	function disappear(x,y,obj1, obj2)
		--first, get info about these two items before we destroy them
		print ("value1: "..obj1.value, "v2: "..obj2.value)
		local total = obj1.value + obj2.value
		print ("total: "..total)
		local newItems --use this to see how many and what type of new items I'll need to create
		--check to see if we need to create 1 or 2 new objects
		if (total > (obj1.units*10)) then
			print ("create TWO items")
			newItems = "twoItems"
			remainder = total - (obj1.units*10)
		elseif (total == obj1.units*10) then 
			newItems = "nextItem"
			newValue = obj1.units*10
			remainder = 0
		elseif (total < obj1.units*10) then
			newItems = "same"
			newValue = total
			remainder = 0
		end
		local units = obj1.units
		--check to see if I got all of the needed values
		print ("remainder: "..remainder,"newItems: "..newItems,"new value: "..newValue)
		print ("units1: "..obj1.units,"units2: "..obj2.units)
		--now get rid of the old items
		if (obj1) then
			obj1:removeSelf()
			Runtime:removeEventListener("enterFrame", obj1)
			obj1 = nil
		end
		if (obj2 ~= nil) then
			obj2:removeSelf()
			Runtime:removeEventListener("enterFrame", obj2)
			obj2 = nil
		end
		cloud.x = -200
		cloud.y = -200
		--closure for passing arguments in a fcn inside of a timer 
		local closure = function() return comboItem(x,y,remainder,newItems,newValue,units) end
		disappearTimer = timer.performWithDelay(300,closure,1)
	end
	
	--handler for when boxes collide
	function itemHit(x,y, obj1, obj2)
		print ("cloud should appear")
		--make the cloud appear on top
		group:insert(cloud)
		cloud.x = x
		cloud.y = y
		--wrap the fcn I really want to run inside of a closure so that I can pass it an argument
		local closure = function() return disappear(x,y,obj1, obj2) end
		itemHitTimer = timer.performWithDelay(300, closure, 1)
	end
	
	
	function onLocalCollision(self, event)
		local hitX = self.x 
		local hitY = self.y 
		local obj1 = self
		local obj2 = event.other
		if event.phase == "began" then
			if ((obj1.units == obj2.units) and (obj1.y > 300) and (obj2.y >300)) then--units are the same
				--check to see if this is the 10,000 units hitting each other, b/c we don't have a graphic for that
				if (obj1.units == 10000) then--too big so exit fcn
					--TODO: play "bonk!" sound and exit
					print ("sorry, crates can't combine")
					return false
				else
					--commence transformation
					print ("obj1:"..obj1.units, "obj2: "..obj2.units)
					print ("collision began")		
					local closure = function() return itemHit(hitX,hitY,obj1, obj2) end
					onLocalCollisionTimer = timer.performWithDelay(100, closure, 1)
					return true;
				end
			else --units are different, so play sound and exit fcn
				--print ("sorry, these two objects are not from the same mother")
				return false
			end
		end
		
		return true
	end
	
	--couldn't seem to get external classes to work, so I'm going to use Rafael Hernandez's method of spawning objects as seen in the Bubble Ball exercise
	function spawnCookie(name, value,w,h, units, radius, shape,x,y)
		image = ("images/"..name..value..".png")
		local cookie = display.newImageRect(image, w,h)
		cookie:setReferencePoint(display.BottomRightReferencePoint)
		cookie.name = name
		cookie.value = value or 1
		cookie.x = x or(_W + 100)
		cookie.y = y or 200
		cookie.units = units
		physics.addBody(cookie, {radius=radius, shape=shape})
		cookie.isFixedRotation = true
		cookie.linearDamping = 9
		cookie.collision = onLocalCollision
		cookie:addEventListener("collision",cookie)
	
		function cookie:touch(event)
			if event.phase == "began" then
				cookie:setReferencePoint(display.CenterReferencePoint)
				offset = self.height/2 + 20
			
				--show the value of the cookie on top of the cookie
				group:insert(showValue)
				showValue.text = value
				showValue.x = self.x 
				showValue.y = self.y - offset
				return true
			elseif event.phase == "moved" then
				--set a variable to know that the cookie has been moved and should no longer move across the screen
				self.moved = "yes"
				--move the cookie around the screen
				self.x = event.x 
				self.y = event.y
				showValue.x = event.target.x 
				showValue.y = event.target.y - offset 
				return true
			elseif event.phase == "ended"  or event.phase == "cancelled" then
				--hide the item's value
				showValue.x = -200
				showValue.y = -200
				return true
			end
			
		end
		
		--make the cookie move across the screen
		function cookie:enterFrame()
			if cookie.y < 250-cookie.height/3 then --cookie is in conveyor area, so start it moving again
				cookie.moved = "no"
			end
			if (cookie.moved ~= "yes") then
				cookie.x = cookie.x - moveRate
			end
			if cookie.x < -50 then 
				Runtime:removeEventListener("enterFrame",cookie)
				cookie:removeSelf()
				cookie = nil
			end
		end
		--attach listeners
		cookie:addEventListener("touch",cookie)
		Runtime:addEventListener("enterFrame", cookie)
		return cookie
	end
	
end


--something to erase

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
		--set up a timer to generate cookies (NOTE: allow users to increase the speed of the cookies across the screen and the rate at which cookies are generated)
	function generator()
		-- make sure to move this code to a question controlling 
		local randNum = math.random(0,100000000)
		print (randNum)
		print (convert.convertNumToText(randNum))
		local newCookie = math.random(#thisLevel)
		local c = thisLevel[newCookie]
		--print (c.name)
		local cookieSpawn = spawnCookie(c.name,c.value, c.w,c.h,c.units, c.radius, c.shape)
		group:insert(cookieSpawn)
	end
	-----------------------------------------------------------------------------
		
	--run the function right at the beginning so we don't have to wait for the first timer to go off
	generator()
	spawnTimer = timer.performWithDelay(createRate, generator,0)


	function enterFrame() 
		--first, check for and clean up the garbage
		--garbage.text = "Garbage collected:  "..collectgarbage("count")
		--texture.text = "Texture memory: "..system.getInfo("textureMemoryUsed")
		collectgarbage("collect")
		--second, look for collisions (code from http://omnigeek.robmiracle.com/2011/12/14/collision-detection-without-physics/)
	end
	
	Runtime:addEventListener("enterFrame",enterFrame)
		
	-----------------------------------------------------------------------------
	
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	timer.cancel(spawnTimer)
	Runtime:removeEventListener("enterFrame",enterFrame)
	-----------------------------------------------------------------------------
	--storyboard.purgeScene(storyboard.currentScene)
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	print ("I just destroyed a scene")
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