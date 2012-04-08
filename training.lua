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
local generate = require ("generateNumInfo")
local spawn = require ("spawnCookie")
local physics = require("physics")
physics.start()
physics.setGravity(0,0)
--physics.setDrawMode("hybrid")
--local gameUI = require("gameUI")
system.activate("multitouch")
----------------- VARIABLES --------------------------
_H = display.contentHeight
_W = display.contentWidth
local createRate = 2000 --how often a new cookie is spawned (in milliseconds)
local level = 4; local thisLevel

local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn, ipad, levelBar --forward reference fcns



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
	--group:insert(cloud)
	--group:insert(showValue)
	
	local bg = display.newImageRect("images/factoryBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	group:insert(bg)
	--local conveyorBelt = display.newImageRect("images/conveyorSprite.png",930, 190)
	--conveyorBelt:setReferencePoint(display.TopLeftReferencePoint)
	--conveyorBelt.x = 10; conveyorBelt.y = 70;
	ipad = display.newImageRect("images/iPad.png",250, 200)
	ipad:setReferencePoint(display.TopLeftReferencePoint);
	ipad.x = 30; ipad.y = 550
	group:insert(ipad)
	
	levelBar = display.newImageRect("images/levelbar.png",90,_H)
	levelBar:setReferencePoint(display.TopRightReferencePoint)
	levelBar.x = _W; levelBar.y=0
	group:insert(levelBar)
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

	local themes= {"creme", "pb","jelly","chocchip"}
	local theme = themes[level]
	items=spawn.createItemsForThisLevel(theme)
	
	--list which cookies are available on each level
	local levelObjects = {
		{items[1], items[1], items[1], items[10]},
		{items[1], items[10],items[1], items[1], items[100], items[10]},
		{items[1], items[10],items[100], items[1], items[1], items[1000]},
		{items[1], items[10],items[100], items[1], items[10], items[1], items[1000], items[10000]},
	}
	thisLevel = levelObjects[level]
		

end


--something to erase

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
		--set up a timer to generate cookies (NOTE: allow users to increase the speed of the cookies across the screen and the rate at which cookies are generated)
	function generator()
		-- make sure to move this code to a question controlling 
		local randNum = generate.genRandNum(level)
		--print (randNum.n`umber,randNum.omittedNum)
		--print (convert.convertNumToText(randNum.number))
		local newCookie = math.random(#thisLevel)
		local c = thisLevel[newCookie]
		local cookieSpawn = spawn.spawnCookie(c.name,c.value, c.w,c.h,c.units, c.radius, c.shape)
		group:insert(cookieSpawn)
		group:insert(levelBar)
	end
	-----------------------------------------------------------------------------
		
	--run the function right at the beginning so we don't have to wait for the first timer to go off
	generator()
	spawnTimer = timer.performWithDelay(createRate, generator,0)

	function reset()
		timer.pause(spawnTimer)
		spawn.cleanUp()
		timer.resume(spawnTimer)
	end
	--created a cleanup btn for testing purposes
	ipad:addEventListener("tap",reset)

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
	
	--get rid of all the cookies that were created
	spawn.cleanUp()
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