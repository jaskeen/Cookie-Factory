-----------------------------------------------------------------------------------------
-- PURPOSE: To practice generating a random #, converting it to text, and remove one digit, at random
-----------------------------------------------------------------------------------------
module(..., package.seeall)

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
