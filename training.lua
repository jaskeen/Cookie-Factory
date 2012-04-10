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

local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn, ipad, levelBar, nextQuestion, lcd, lcdText, questionText, startSession, genQ --forward reference fcns



-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch and stops propagation
end

--generate the list of questions in the list per the current condition
function startSession(mode, timeLimit, totalQuestions)
	--first, determine what mode this is 
	--then, start timer 
	--then, start counter 
    -- if mode == counter then
	      -- show total number
	      -- on each question answered, reduce total by 1
	      -- when total reaches 0, end session
	      -- on session end, show how many they got right and how many they got wrong
	      --report session data to ACCEL
    -- if mode == timer then
    	-- start a count-down (i.e., initiate another time )
	if mode=="time" then -- as many qs as can be answered in a fixed amount of time 
		local timedGame = timer.performWithDelay()
	end
end

--generate a question
function genQ()
	-- gen random #
	-- convert # to textual format
	--place textual # in marquee
	-- iterate over omitted # array (in itemInfo object) and create the trays
	  -- if the item value is "_" make the tray a sensor
end

--check user's answer
function checkQ(mode, correctAnswer)
	--if the item is over a sensor
	    -- highlight the tray with a border (or something else to call attention to it)
	  -- if the event is  an ended event on the item, then animate it to the tray (reduce its size)
	  -- then change the # to the value of what was placed in the tray
	  -- mark the answer
	  --check the answer against the correct answer
	  --update the count accordingly (either up or down depending on  mode)
end


---------------------  CREATE SCENE: Called when the scene's view does not exist: ---------------------
	--	CREATE display objects and add them to 'group' here.
function scene:createScene( event ) 
	
	local group = self.view  --insert all display objects into this
	--group:insert(cloud)
	--group:insert(showValue)
	
	local bg = display.newImageRect("images/factoryBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	--local conveyorBelt = display.newImageRect("images/conveyorSprite.png",930, 190)
	--conveyorBelt:setReferencePoint(display.TopLeftReferencePoint)
	--conveyorBelt.x = 10; conveyorBelt.y = 70;
	ipad = display.newImageRect("images/iPad.png",250, 200)
	ipad:setReferencePoint(display.TopLeftReferencePoint);
	ipad.x = 30; ipad.y = 550
	
	levelBar = display.newImageRect("images/levelbar.png",90,_H)
	levelBar:setReferencePoint(display.TopRightReferencePoint)
	levelBar.x = _W; levelBar.y=0
	
	
	
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


	local themes= {"oreo", "pb","jelly","chocchip"}
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
		
		--create an intro message
		local intro = display.newGroup()
		local introBg = display.newRoundedRect(0,0,640,400,5)
		introBg.strokeWidth = 6
		introBg:setFillColor(200,100,50)
		introBg:setStrokeColor(255)
		intro:insert(introBg)
		local message = "Welcome to our factory. We need help packaging cookies for delivery, but someone seems to have forgotten to fill one of the places in each order.  Please help us by combining cookies to the right amount.  After combining them, drag the cookie to the empty spot below and they'll be packaged."
		local introText = display.newRetinaText(message,20,20,600,400, "Helvetica", 30)
		
		intro:insert(introText)
		intro:setReferencePoint(display.CenterReferencePoint)
		intro.x = _W/2; intro.y = _H/2

		lcd = display.newImageRect("images/lcd.png",850,60)
		lcd:setReferencePoint(display.TopLeftReferencePoint)
		lcd.x = 80; lcd.y = 5
	
		questionText = "Seven million, seven hundred seventy-seven thousand, seven hundred seventy-seven"
		lcdText = display.newRetinaText(questionText,110, 20, "Score Board", 19,{255,0,0})
		lcdText:setTextColor(255,0,0)
	--insert everything into group in the desired order
	group:insert(bg)
	group:insert(lcd)
	group:insert(lcdText)
	group:insert(ipad)
	group:insert(homeBtn)	
	group:insert(intro)
	group:insert(trayGroup)
	group:insert(levelBar)

end

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