--PURPOSE: Practice Multitouch

--two display objects on screen
--one display object to appear
--ability to touch multiple objects at the same time and have them each detected
--detect when objects touch one another/collide
	--track the location of the object
	--collision- depends on the physics bodies
	
------------------
--FIRST----------
--2 display objects
--move to objects at the same time
------------------
system.activate( "multitouch" )

--globals
_W=display.contentWidth
_H=display.contentHeight

--Creating squares on the screen
--[[
local arguments =
{
	{ x=50, y=10, w=100, h=100, r=10, red=255, green=0, blue=128 },
	{ x=10, y=50, w=100, h=100, r=10, red=0, green=128, blue=255 },
	{ x=90, y=90, w=100, h=100, r=10, red=255, green=255, blue=0 }
}
]]

--display objects
local background=display.newImageRect("images/background.png", _W, _H)
	background:setReferencePoint(display.CenterReferencePoint)
	background.x= _W/2
	background.y=_H/2

local square=display.newImageRect("images/square.png", 100,100)
	square:setReferencePoint(display.CenterReferencePoint)
	square.x=100
	square.y=100
	
local circle=display.newImageRect("images/circle.png", 100, 100)
	circle:setReferencePoint(display.CenterReferencePoint)
	circle.x=250
	circle.y=150
	

--function that indicates where the objects are located
local function printTouch( event )
 	if event.target then 
 		local bounds = event.target.contentBounds
		print( "event(" .. event.phase .. ") ("..event.x..","..event.y..") bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax )
	end 
end

-- Display the Event info on the screen
local function showEvent( event )
	txtPhase.text = "Phase: " .. event.phase
	txtXY.text = "(" .. event.x .. "," .. event.y .. ")"
	txtId.text = "Id: " .. tostring( event.id )
	--Create a similar piece in the function, but you'll need to know the start and 
	--end of each x and y for each object to calculate their distance
	--for example A(5,20) B(10,30) Distance= square root of ((x1-x2)squared + (y2-y1)squared)
	txtDist.text= "Distance: "..(event.x - event.y)
end

local function onTouch( event )
	local t = event.target
	showEvent( event )
	
	print ("onTouch - event: " .. tostring(event.target), event.phase, event.target.x, tostring(event.id) )

	-- Print info about the event. For actual production code, you should
	-- not call this function because it wastes CPU resources.
	printTouch(event)

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t, event.id )

		-- **tjn: I don't this this comment applies in Beta 6 Multitouch
		-- I also don't think we need t.isFocus.
		--
		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		
		elseif "ended" == phase or "cancelled" == phase then
			if not(nil == t.id) then
--				print("Removing object from stage")
				t:removeSelf()
			else
				display.getCurrentStage():setFocus( t, nil )
				t.isFocus = false
			end
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end



-- Iterate through arguments array and create rounded rects (vector objects) for each item
--[[for _,item in ipairs( arguments ) do
	local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
	button:setFillColor( item.red, item.green, item.blue )
	button.strokeWidth = 6
	button:setStrokeColor( 200,200,200,255 )

	-- Make the button instance respond to touch events
	button:addEventListener( "touch", onTouch )
end
]]


-- listener used by Runtime object. This gets called if no other display object
-- intercepts the event.
--
-- Create a circle where the user touched the screen.
-- Multiple touches will generate multiple circles
-- Moving the object is handled in onTouch()
--[[local function otherTouch( event )
	
	print( "otherTouch: event(" .. event.phase .. ") ("..event.x..","..event.y..")" .. tostring(event.id) )
	local s = display.getCurrentStage() 
					
	if "began" == event.phase then
		showEvent( event )
--This is creates the blue circles on touch
--		print("Found otherTouch -- began", display.getCurrentStage())
		local circle = display.newCircle(event.x, event.y, 45)
		circle:setFillColor(  0, 0, 255, 255 )		-- start with Alpha = 0
		
		-- Store initial position
		circle.x0 = event.x - circle.x
		circle.y0 = event.y - circle.y
		circle.isFocus = true		-- **tbr - remove later
		touchCircle = circle		-- **tbr - temp
		circle.id = event.id		-- save our id so we can access the object later
--		print( "new circle:", tostring(circle) ); print()

		circle:addEventListener( "touch", onTouch )
		event.target = circle
		onTouch( event )
	end	
end
]]
-- Define text areas on the screen
txtPhase = display.newText( "Phase: _____", 20, _H-80, "Verdana-Bold", 24 )
txtPhase:setTextColor( 255,255,255 )

txtXY = display.newText( "(___,___)", 20, _H-40, "Verdana-Bold", 24 )
txtXY:setTextColor( 255,255,255 )

txtId = display.newText( "Id: ______", 300, _H-80, "Verdana-Bold", 24 )
txtId:setTextColor( 255,255,255 )

txtDist = display.newText( "Distance: ______", 20, _H-120, "Verdana-Bold", 24 )
txtId:setTextColor( 255,255,255 )


--Runtime:addEventListener( "touch", otherTouch )
--	Runtime:addEventListener( "touch", printTouch2 )	-- **tjn No longer used                  

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Multitouch Events not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Multitouch not supported on Simulator!", 0, _H/2, "Verdana-Bold", 24 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

square:addEventListener( "touch", onTouch )
circle:addEventListener( "touch", onTouch )

------------------
--SECOND---------
--test the distance between two touches
--detect if distance increasing, then it's considered a pinch
--detect a pinch
--------------------
--***Go to line 63 for the distance formula so far, detecting the distance between 2 points
--if this number decreases we can call it a "pinch" OR we can just place physics and when they touch call it a collide

