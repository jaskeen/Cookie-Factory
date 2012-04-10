----------------------------------------------------------------------------------
--  PURPOSE:  To allow users to "build" and combine combinations of units to answer place value questions
-- note: uses official scenetemplate.lua
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget= require "widget"
local itemInfo = require ("items")
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

local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn, levelBar, nextQuestion, lcdText, questionText, startSession, genQ, leftSlice,leftGroup, timeDisplay, countDisplay --forward reference fcns



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
	
	local bg = display.newImageRect("images/BG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	local conveyor = display.newImageRect("images/conveyor.png",912, 158)
	conveyor:setReferencePoint(display.TopLeftReferencePoint)
	conveyor.x = 35; conveyor.y = 200;
	--	physics.addBody(conveyor, "static", {shape=-360, 632,   360, 632,   456, 527,   456, 474,   -456, 474,   -456, 527})
	
	levelBar = display.newImageRect("images/levelbar.png",90,_H)
	levelBar:setReferencePoint(display.TopRightReferencePoint)
	levelBar.x = _W; levelBar.y=0
	
	
	
	---------------------------------------- Number BOXES ----------------------------------------
	
	--10,000s
	local tenThousandsTray = display.newRect(0,0, 140, 40)
	tenThousandsTray:setFillColor(182,61,91)
	local tenThousandsText = display.newRetinaText("ten thousands",5,0,"Helvetica",18)
	tenThousandsText.height = 40
	--1,000s
	local thousandsTray = display.newRect(140,0, 140, 40)
	thousandsTray:setFillColor(216,101,88)
	local thousandsText = display.newRetinaText("thousands",145,0,"Helvetica",18)
	thousandsText.height = 40
	--100s
	local hundredsTray = display.newRect(280, 0, 140, 40)
	hundredsTray:setFillColor(225,203,60)
	local hundredsText = display.newRetinaText("hundreds",285,0,"Helvetica",18)
	hundredsText.height = 40
	--10s
	local tensTray = display.newRect(420, 0, 140, 40)
	tensTray:setFillColor(82,148,100)
	local tensText = display.newRetinaText("tens",425,0,"Helvetica",18)
	tensText.height = 40
	--1s
	local onesTray = display.newRect(560, 0, 140, 40)
	onesTray:setFillColor(54, 158,251)
	local onesText = display.newRetinaText("ones",565,0,"Helvetica",18)
	onesText.height = 40
	onesText.align = "right"

	--now put them all into a group so you can move the group around with ease
	local trayGroup = display.newGroup()
	trayGroup:insert(tenThousandsTray)
	trayGroup:insert(thousandsTray)
	trayGroup:insert(hundredsTray)
	trayGroup:insert(tensTray)
	trayGroup:insert(onesTray)
	trayGroup:insert(tenThousandsText)
	trayGroup:insert(thousandsText)
	trayGroup:insert(hundredsText)
	trayGroup:insert(tensText)
	trayGroup:insert(onesText)
	trayGroup.x = 240; trayGroup.y = 665


	local themes= {"oreo", "pb","jelly","chocchip"}
	local theme = themes[level]
	items=itemInfo.createItemsForThisLevel(theme)
	
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

	 --marquee
		questionText = "Seven million, seven hundred seventy-seven thousand, seven hundred seventy-seven"
		lcdText = display.newRetinaText(questionText,135, 33, "Score Board", 16.5,{255,0,0})
		lcdText:setTextColor(0,255,0)
		
		-- time display 
		local feedbackGroup = display.newGroup()
		local timeBox = display.newRect(0,0,200,50)
		timeBox:setReferencePoint(display.TopLeftReferencePoint)
		timeBox.x = 0; timeBox.y = 0;
		timeBox:setFillColor(0)
		timeBox.strokeWidth = 3
		timeBox:setStrokeColor(0,255,0)
		timeDisplay = display.newText("Time: ",5,10, "Score Board",24 )
		timeDisplay:setTextColor(0,255,0)
		local countBox = display.newRect(0,0,200,50)
		countBox:setReferencePoint(display.TopLeftReferencePoint)
		countBox.x = 0; countBox.y = 65;
		countBox:setFillColor(0)
		countBox.strokeWidth = 3
		countBox:setStrokeColor(0,255,0)		
		countDisplay = display.newText("Orders: ",5,75, "Score Board",24)
		countDisplay:setTextColor(0,255,0)
		
		--insert them all into one group
		feedbackGroup:insert(timeBox)
		feedbackGroup:insert(timeDisplay)
		feedbackGroup:insert(countBox)
		feedbackGroup:insert(countDisplay)
		feedbackGroup.x = 30; feedbackGroup.y = _H-135
		--orders display (i.e., count)
	
	--insert everything into group in the desired order
	group:insert(lcdText)
	group:insert(bg)
	group:insert(conveyor)
	group:insert(feedbackGroup)
	group:insert(intro)
	group:insert(trayGroup)
	group:insert(levelBar)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
		leftGroup = display.newGroup()
		--left  wall slice is not part of the storyboard group so that it remains on top of everything.  Have to remove and add it when you leave/enter the screen
		leftSlice = display.newImageRect("images/BGsliceLeft.png",35,413)
		leftSlice:setReferencePoint(display.TopLeftReferencePoint)
		leftSlice.x = 0; leftSlice.y = 0;		
		
		homeBtn=widget.newButton{
		default="images/homeBtn.png",
		width=80,
		height=80,
		onRelease = onBtnRelease	-- event listener function
		}
		homeBtn:setReferencePoint(display.CenterReferencePoint)
		homeBtn.x = 35
		homeBtn.y = 40
		homeBtn.scene="menu"
		
		leftGroup:insert(leftSlice)
		leftGroup:insert(homeBtn)
	
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
	--have to remove the leftSlice b/c it's not actually part of the storyboard group so that it always remains on top
	leftGroup:removeSelf()
	leftGroup = nil
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