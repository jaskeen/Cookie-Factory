----------------------------------------------------------------------------------
---- loadingDock.lua
------------------------------------------------------------------------------------
local generate = require "generateNumInfo"
local number = require "generateNumber"
local itemInfo= require "items"
local spawn= require "spawnCookie"
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
local factoryBG, homeBtn
local pallet
local myObject
local startDrag
local level
local totalTrucks
local totalItems
local itemsCreated
local newList
local inArray
local createKey

	--From generateNumInfo
	local newList
	local value
	local omittedNum
	
	--From generateNumber
	local generateNumber
	
	--From spawnCookie
	local items
	



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

--Get the level from the user's selection later... this controls the # trucks and items to spawn
level=4	
totalTrucks=level
totalItems=level-1
palletPositions={320, 470, 620}
print(palletPositions[3])

-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch
end



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
local themes= {"creme", "pb","jelly","chocchip"}
local theme = themes[level]

items=itemInfo.createItemsForThisLevel(theme)

	--the omitted# from the trucks (with the exception of 1) will determine the cookie to appear



-------------------General Scene Images-----------------

	factoryBG= display.newImageRect("images/TruckBG.png", _W, _H)
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
	
	
	group:insert(factoryBG)
	group:insert(homeBtn)
		
	return true
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
-----------------------------------------------------------------------------
-------ENTER SCENE----------
-----------------------------------------------------------------------------
--1 Generate 4 truck numbers (SessionNumbers)
createdItems={}
usedPositions={}

newList = generate.generateNumInfos(4,5)
themes= {"oreo", "pb","jelly","chocchip"}
level=3
theme = themes[level]
items=itemInfo.createItemsForThisLevel(theme)


function inArray(array, value)
	local is = false
	for i, thisValue in ipairs(array) do
		if thisValue == value then 
			is = true; break end
	end
	return is
end
    
	
function createKey(array)
	local key = "object"..math.random(1,100000000)
	if inArray(array,key) == true then return createKey(array) end
	return key
end

--[[
function palletPositionsTaken(array)
	local position = "position"..math.random(1,100000000)
	if inArray(array,position) == true then return palletPositionsTaken(array) end
	return position
end
]]


		
--Create a function that generates trucks
function createTruck(truckX,truckY, numObj)
	local truck=display.newGroup()
	truck:setReferencePoint(display.TopRightReferencePoint)
	local image=display.newImageRect("images/TruckOrange.png", 440, 272)
		truck:insert(image)
	local numberText=display.newEmbossedText(numObj.omittedNum, 0, 0, native.systemFontBold, 40)
		numberText.x = 0; numberText.y = -75
		numberText:setTextColor(75)
		truck:insert(numberText)
	truck.value=numObj.omittedValue
	key=createKey(createdItems)
	truck.key=key
	createdItems[key]=truck
	truck.x=truckX
	truck.y=truckY

	physics.addBody(truck, "static", {isSensor=true})
end

truckX=_W/2+35 --increase by 100
truckY=250 --increase by 125

for i=1, #newList do
	createTruck(truckX, truckY, newList[i])
	truckX=truckX+80
	truckY=truckY+125
end
	
--2 Generate 3 of the 4 cookie objects 		
function createPallet(palletY, numObj)
	pallet=display.newGroup()
	pallet:setReferencePoint(display.TopRightReferencePoint)
	local num = numObj.omittedValue
	local imagePallet=display.newImageRect("images/Palette.png", 213, 79)
	--local imageCookie=display.newImageRect()
		pallet:insert(imagePallet)
	local itemImage=display.newImageRect("images/"..theme..tostring(num)..".png", items[num].w, items[num].h)
		itemImage.y=-50
		pallet:insert(itemImage)
	numberText=tostring(numObj.omittedValue)
	print("numberText:"..numberText)
	local numberText=display.newRetinaText(numberText, 0,0, native.systemFontBold, 40)
		numberText.x=15 
		numberText.y=0
		pallet:insert(numberText)
	key=createKey(createdItems)
		pallet.key=key
		createdItems[key]=pallet
	--position=palletPositionsTaken(usedPositions)
	--	pallet.position=position
	--	usedPositions[position]=pallet
	pallet.value=numObj.omittedValue--should this actually be the omittedValue so it can be compared to the truck?
	pallet.x=120
	pallet.y=palletY
		physics.addBody(pallet,"kinetic", {friction=0.7})
end

for i=1, #newList-1 do
	createPallet(palletPositions[i], newList[i], items[i])
	print(palletPositions[i])
	print(items[i])
	pallet:addEventListener("touch", startDrag)
end


	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

		function cleanUp()
		 for key, value in pairs(createdItems) do
			  --first, remove the item from the array
			  createdItems[key] = nil
			  -- then, remove any event listeners that might be on or related to the item
			  --Runtime:removeEventListener("enterFrame", value)
			  --now, remove the item itself from the display
			  value:removeSelf()
			 --finally, destroy the item so it can get cleaned from memory
			 value = nil
			end
			
			usedPositions=nil
			
		end
	
	cleanUp()
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