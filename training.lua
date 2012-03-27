----------------------------------------------------------------------------------
--  PURPOSE:  To allow users to "build" and combine combinations of units to answer place value questions
-- note: uses official scenetemplate.lua
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget= require "widget"
local scene = storyboard.newScene()
local onBtnRelease, factoryBG, homeBtn
----------------------------------------------------------------------------------
--	NOTE:	Code outside of listener functions (below) will only be executed once, unless storyboard.removeScene() is called.
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
----------------- VARIABLES --------------------------
_H = display.contentHeight
_W = display.contentWidth
local moveRate = 2 -- how fast the cookie moves across the screen
local createRate = 2000 --how often a new cookie is spawned (in milliseconds)
local level = 4; local thisLevel
local showValue = display.newRetinaText("",-200,-200, "Arial",48) --for showing value of the dragged item
local cloud = display.newImageRect("cloud.png",256,256) --cloud for transformations
cloud.x = -200
cloud.y = -200 
local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel --forward reference fcns

--first, set the name of the current scene, so we can get it later, if needed
storyboard.currentScene = "training"

-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch
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
	homeBtn.x = _W*.06
	homeBtn.y = _H*.07
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
		
--I STOPPED RIGHT HERE ---
	
	
end




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