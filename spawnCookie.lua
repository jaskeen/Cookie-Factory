-----------------------------------------------------------------------------------------
-- PURPOSE: To practice generating a random #, converting it to text, and remove one digit, at random
-----------------------------------------------------------------------------------------
module(..., package.seeall)

--public variables
moveRate = 2 -- how fast the cookie moves across the screen

--forward declarations
local disappear, itemHit, onLocalCollision, cookieGroup
cookieGroup = display.newGroup()
local showValue = display.newRetinaText("",-200,-200, "Arial",48) --for showing value of the dragged item
local cloud = display.newImageRect("images/cloud.png",256,256) --cloud for transformations
cloud.x = -200
cloud.y = -200 
generatedItems = {}


local function inArray(array, value)
    local is = false
    for i, thisValue in ipairs(array) do
        if thisValue == value then 
        	is = true; break end
    end
    return is
end
	
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
		cookieGroup:insert(cookie1)
		generatedItems[cookie1.key] = cookie1
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
		generatedItems[cookie2.key] = cookie2
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
		cookieGroup:insert(cookie1)
		cookieGroup:insert(cookie2)
		generatedItems[cookie1.key] = cookie1
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
		generatedItems[obj1.key] = nil
		obj1:removeSelf()
		Runtime:removeEventListener("enterFrame", obj1)
		obj1 = nil
		collectgarbage("collect")
	end
	if (obj2 ~= nil) then
		generatedItems[obj2.key] = nil
		obj2:removeSelf()
		Runtime:removeEventListener("enterFrame", obj2)
		obj2 = nil
		collectgarbage("collect")
	end
	cloud.x = -200
	cloud.y = -200
	--closure for passing arguments in a fcn inside of a timer 
	local closure = function() return comboItem(x,y,remainder,newItems,newValue,units) end
	disappearTimer = timer.performWithDelay(100,closure,1)
end

--handler for when boxes collide
function itemHit(x,y, obj1, obj2)
	print ("cloud should appear")
	--make the cloud appear on top
	--group:insert(cloud)
	cloud.x = x
	cloud.y = y
	--wrap the fcn I really want to run inside of a closure so that I can pass it an argument
	local closure = function() return disappear(x,y,obj1, obj2) end
	itemHitTimer = timer.performWithDelay(100, closure, 1)
end


function onLocalCollision(self, event)
	local hitX = self.x 
	local hitY = self.y 
	local obj1 = self
	local obj2 = event.other
	if event.phase == "began" then
		if ((obj1.units == obj2.units) and (obj1.y > 300) and (obj2.y >300)) then--units are the same
			--check to see if this is the 10,000 units hitting each other, b/c we don't have a graphic for that
			if (obj1.value + obj2.value >= 100000) then--too big so exit fcn
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


local function genKey(array)
	local key = "cookie"..math.random(1,100000000)
	if inArray(array,key) == true then return genKey(array) end
	return key
end

--couldn't seem to get external classes to work, so I'm going to use Rafael Hernandez's method of spawning objects as seen in the Bubble Ball exercise
function spawnCookie(name, value,w,h, units, radius, shape,x,y)
	--create a group to insert everything into about that cookie
	local cookie = display.newGroup()
	
	--cookie image
	local image = display.newImageRect("images/"..name..value..".png",w,h)
	image.x = 0; image.y = 0;
	cookie:insert(image)
	
	--cookie badge (needs text and a rounded rectangle grouped together)
	local badge = display.newGroup()
	local badgeText = display.newRetinaText(value,5,-2,"Public Gothic Circular",24)
	badgeText:setTextColor(255,255,255)
	local badgeRect = display.newRoundedRect(0,0,badgeText.width+10,badgeText.height, 12)
	badgeRect:setReferencePoint(display.TopLeftReferencePoint)
	badgeRect.strokeWidth = 4
	badgeRect:setFillColor(255,0,0)
	badgeRect:setStrokeColor(255)
	
	badge:insert(badgeRect)
	badge:insert(badgeText)
	cookie:insert(badge)
	badge.x=-25; badge.y = h*.3
	
	--cookie properties
	cookie.image = image
	cookie.badgeText = badgeText
	cookie.badgeRect = badgeRect
	cookie:setReferencePoint(display.BottomRightReferencePoint)
	cookie.name = name
	cookie.value = value or 1
	cookie.x = x or(_W+30)
	cookie.y = y or 270
	cookie.units = units
	physics.addBody(cookie, {radius=radius, shape=shape})
	cookie.isFixedRotation = true
	cookie.linearDamping = 9
	cookie.collision = onLocalCollision
	cookie:addEventListener("collision",cookie)
	--generate a unique key to refer to this cookie
	cookie.key = genKey(generatedItems)
	generatedItems[cookie.key] = cookie
	
	
	--table.insert(generatedItems,cookie)
	
	function cookie:touch(event)
		if event.phase == "began" then
			cookie:setReferencePoint(display.CenterReferencePoint)
			offset = self.height/2 + 20
		
			--show the value of the cookie on top of the cookie
			cookieGroup:insert(showValue)
			showValue.text = value
			showValue.x = self.x 
			showValue.y = self.y - offset
			
			display.getCurrentStage():setFocus( self, event.id)
			self.isFocus = true
			self.markX = self.x 
			self.markY = self.y 
			--return true
		elseif self.isFocus then
			if event.phase == "moved" then
				--set a variable to know that the cookie has been moved and should no longer move across the screen
				self.moved = "yes"
				--move the cookie around the screen
				self.x = event.x-event.xStart+self.markX 
				self.y = event.y - event.yStart+self.markY
				showValue.x = event.target.x 
				showValue.y = event.target.y - offset 
				return true
			elseif event.phase == "ended"  or event.phase == "cancelled" then
				--hide the item's value
				showValue.x = -200
				showValue.y = -200
				display.getCurrentStage():setFocus(self,nil)
				self.isFocus=false
				return true
			end
		end
		
	end
	
	--make the cookie move across the screen
	function cookie:enterFrame(event)
		if cookie.y < 250 - cookie.height/2 then -- cookie is in the marquee area
			cookie.y = 250 - cookie.height/2
		elseif cookie.y < 300-cookie.height/3 then --cookie is in conveyor area, so start it moving again
			cookie.moved = "no"
		end
		if (cookie.moved ~= "yes") then
			cookie.x = cookie.x - moveRate
		end
		if cookie.x < -50 then 
			Runtime:removeEventListener("enterFrame",cookie)
			generatedItems[cookie.key] = nil
			collectgarbage("collect")
			cookie:removeSelf()
			cookie = nil
		end
	end
	--attach listeners
	cookie:addEventListener("touch",cookie)
	Runtime:addEventListener("enterFrame", cookie)
	return cookie
end

function cleanUp()
	for k, v in pairs(generatedItems) do 
		print (k)
	end
	--delete all the cookies that were generated
	for k, v in pairs(generatedItems) do 
		print ("removing: "..k)
		generatedItems[k] = nil
		Runtime:removeEventListener("enterFrame", v)
		v:removeSelf()
		v = nil
	end	
	--generatedItems = nil
	--generatedItems = {}
end