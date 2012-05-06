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
local proxy = require "proxy"
local convert = require ("convertNumToText")
local generate = require ("generateNumInfo")
local spawn = require ("spawnCookie")
local physics = require("physics")
physics.start()
physics.setGravity(0,0)
system.activate("multitouch")
----------------- VARIABLES --------------------------
_H = display.contentHeight
_W = display.contentWidth
local createRate = 2000 --how often a new cookie is spawned (in milliseconds)
local thisLevel

local currLevel = 6 --remember to get this from the user's personal data at some point
local currMode = "timed" -- or count; also switch this per user request


local levels = {}
levels[1] = { digits= 2, theme = "oreo", unlock = "next level", stars=1, starImg = "oreo_star.png", count = 10, timed = 3 }
levels[2] = { digits = 3, theme= "pb", unlock = "next level", stars = 2, starImg = "pb_star.png", count = 15, timed = 3}
levels[3] = { digits = 3, theme= "jelly", unlock = "multiplier", stars = 2, starImg = "jelly_star.png",  count = 20, timed = 3}
levels[4] = { digits = 4, theme= "jelly", unlock= "next level", stars = 3,  starImg = "timesTen.png", count = 25, timed = 3}
levels[5] = { digits = 5, theme= "chocchip", unlock= "divisor", stars = 4,  starImg = "chocchip_star.png", count = 30, timed = 3 }
levels[6] = { digits = 5, theme= "chocchip", unlock = "next level", stars = 4,  starImg = "mallet.png", count = 35, timed = 3}

--forward references
local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn, levelBar, nextQuestion, lcdText, startSession, genQ, leftSlice,leftGroup, timeDisplay, countDisplay, numDisplay, trayGroup, genStars,generatedBlocks,spawnBlock,inArray,genKey, dropZone, itemSensor, cookieGroup, currNum, correct, attempted, timerDisplay, ordersDisplay, correctDisplay, timeCount, timeCounter,orderCount, orderCounter, correctCount, correctCounter

local font = "Helvetica"

-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	-- go to scene1.lua scene
	print (event.target.scene)
	storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch and stops propagation
end

--generate the list of questions in the list per the current condition
function startSession(mode)
	orderCount = 0
	timeCount = levels[currLevel].timed*60
	orderCounter.text = tostring(orderCount)
	--first, determine what mode this is 
	if currMode == "timed" then
		countdown = timer.performWithDelay(1000, function()
			timeCount = timeCount -1
			timeCounter.text = tostring(timeCount)
		end, 60*levels[currLevel].timed)
	end --count elseif
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
    currNum = genQ()
	generator()
	spawnTimer = timer.performWithDelay(createRate, generator,0)	
end

--check if a value is in an array (http://developer.anscamobile.com/forum/2011/08/21/urgent-custom-fonts-ios-31)
function inArray(array, value)
    local is = false
    for i, thisValue in ipairs(array) do
        if thisValue == value then 
        	is = true; break end
    end
    return is
end
	
function genKey(array)
	local key = "item"..math.random(1,100000000)
	if inArray(array,key) == true then return genKey(array) end
	return key
end

table.invert = function( tbl, rangesize )
        rangesize = rangesize or 1
        local reversed = {}
        for i=1, #tbl-rangesize+1, rangesize do
                for t=rangesize-1, 0, -1 do
                        table.insert( reversed, 1, tbl[ i+t ] )
                end
        end
        return reversed
end

generatedBlocks = {}

function spawnBlock(x)
	local block = display.newGroup()
	local image = display.newRect(0, 0, 14,40)
	image:setReferencePoint(display.TopRightReferencePoint)
	image.y = -40; image.x = x;
	image:setFillColor(255)
	image:setStrokeColor(0)
	image.strokeWidth=2
	block:insert(image)
	block.key = genKey(generatedBlocks)
	generatedBlocks[block.key] = block
	trayGroup:insert(block)
	return block
end

--generate a question
function genQ()
	-- gen random #
	local newNum = generate.genRandNum(levels[currLevel].digits);
	print ("new num: "..newNum.number)
	--place textual # in marquee
	lcdText.align = "right"
	lcdText.text = convert.convertNumToText(newNum.number)
	lcdText:setReferencePoint(display.TopRightReferencePoint)
	lcdText.x = _W-100; lcdText.y = _H-30
	-- iterate over omitted # array (in itemInfo object) and create the trays
	local reverseNumT = table.invert(newNum.numberT,1)
  --clear out all the old blocks
		for k, v in pairs(generatedBlocks) do 
			--print ("removing: "..k)
			generatedBlocks[k] = nil
			v:removeSelf()
			v = nil
		end
	for i=1, #newNum.omittedReversedArray do 
		numDisplay[i].text:setText(tostring(newNum.omittedReversedArray[i]))
		--generate counting blocks (starting at x=700?)
		local startingX = 700 - (i-1)*140
		for j=1, reverseNumT[i] do 
			if (newNum.omittedReversedArray[i] ~= "_") then
				spawnBlock(startingX)
				startingX = startingX - 14
			else 	-- if the item value is "_" make the tray a sensor
				dropZone.x = startingX + 240
				dropZone.y = 595
				cookieGroup:insert(dropZone)
			end
		end
	end
	return newNum
end


--check user's answer
function checkAnswer(self, event)	
	--if the item is over a sensor
	if event.phase == "began" then
		dropZone.alpha = 1
		spawn.touchingOnRelease = true
	elseif event.phase == "ended" then
		dropZone.alpha = 0	
		spawn.touchingOnRelease = false
	end	
	return true
end


---------------------  CREATE SCENE: Called when the scene's view does not exist: ---------------------
	--	CREATE display objects and add them to 'group' here.
function scene:createScene( event ) 
	
	local group = self.view  --insert all display objects into this
	trayGroup = display.newGroup()
	--create group to put cookies into
	cookieGroup = display.newGroup()
	
	local bg = display.newImageRect("images/newBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	local conveyor = display.newImageRect("images/conveyor.png",932, 158)
	conveyor:setReferencePoint(display.TopLeftReferencePoint)
	conveyor.x = 35; conveyor.y = 180;
	--	physics.addBody(conveyor, "static", {shape=-360, 632,   360, 632,   456, 527,   456, 474,   -456, 474,   -456, 527})
	
	
	
	---------------------------------------- Number BOXES ----------------------------------------
	values = {1,10,100,1000,10000}
	numDisplay = {}
	local digTextX = 630
	for i=1, levels[currLevel].digits do 
		numDisplay[i] = {}
		numDisplay[i].value = values[i]
		numDisplay[i].text = display.newEmbossedText("0",digTextX,45,"BellGothicStd-Black",36)
		numDisplay[i].text:setTextColor(255)
		digTextX = digTextX - 140
		trayGroup:insert(numDisplay[i].text)
	end
	--empty one of the number fields to begin with
	if numDisplay[2] then
		numDisplay[2].text:setText("__")
	else 
		numDisplay[1].text:setText("__")
	end
	local paletteColor = 180
	--10,000s
	local tenThousandsTray = display.newRect(0,0, 140, 40)
	tenThousandsTray:setFillColor(182,61,91)
	local tenThousandsText = display.newEmbossedText("ten thousands",5,10,"BellGothicStd-Black", 21)
	tenThousandsText:setTextColor(255,255,255)
	tenThousandsText:setReferencePoint(display.CenterReferencePoint)
	tenThousandsText.x = 70
	local tenThousandsPalette = display.newRect(0,0,140,40)
	tenThousandsPalette:setFillColor(paletteColor)
	tenThousandsPalette:setReferencePoint(display.TopLeftReferencePoint)
	tenThousandsPalette.x = 0; tenThousandsPalette.y = -40;
	--1,000s
	local thousandsTray = display.newRect(140,0, 140, 40)
	thousandsTray:setFillColor(216,101,88)
	local thousandsText = display.newEmbossedText("thousands",145,10,"BellGothicStd-Black", 21)
	thousandsText:setTextColor(255,255,255)
	thousandsText:setReferencePoint(display.CenterReferencePoint)
	thousandsText.x = 210
	local thousandsPalette = display.newRect(0,0,140,40)
	thousandsPalette:setFillColor(paletteColor)
	thousandsPalette:setReferencePoint(display.TopLeftReferencePoint)
	thousandsPalette.x = 140; thousandsPalette.y = -40;
	--100s
	local hundredsTray = display.newRect(280, 0, 140, 40)
	hundredsTray:setFillColor(225,203,60)
	local hundredsText = display.newEmbossedText("hundreds",285,10,"BellGothicStd-Black", 21)
	hundredsText:setTextColor(255,255,255)
	hundredsText:setReferencePoint(display.CenterReferencePoint)
	hundredsText.x = 355
	local hundredsPalette = display.newRect(0,0,140,40)
	hundredsPalette:setFillColor(paletteColor)
	hundredsPalette:setReferencePoint(display.TopLeftReferencePoint)
	hundredsPalette.x = 280; hundredsPalette.y = -40;
	--10s
	local tensTray = display.newRect(420, 0, 140, 40)
	tensTray:setFillColor(82,148,100)
	local tensText = display.newEmbossedText("tens",425,10,"BellGothicStd-Black", 21)
	tensText:setTextColor(255,255,255)
	tensText:setReferencePoint(display.CenterReferencePoint)
	tensText.x = 495
	local tensPalette = display.newRect(0,0,140,40)
	tensPalette:setFillColor(paletteColor)
	tensPalette:setReferencePoint(display.TopLeftReferencePoint)
	tensPalette.x = 420; tensPalette.y = -40;
	--1s
	local onesTray = display.newRect(560, 0, 140, 40)
	onesTray:setFillColor(54, 158,251)
	local onesText = display.newEmbossedText("ones",565,10,"BellGothicStd-Black", 21)
	onesText:setTextColor(255,255,255)
	onesText:setReferencePoint(display.CenterReferencePoint)
	onesText.x = 635
	local onesPalette = display.newRect(0,0,140,40)
	onesPalette:setFillColor(paletteColor)
	onesPalette:setReferencePoint(display.TopLeftReferencePoint)
	onesPalette.x = 560; onesPalette.y = -40;


	--create a target block (i.e. "dropzone") for delivering the packaged cookies
	dropZone = display.newRect(0,0, 140,125)
	dropZone:setFillColor(255,255,255,30)
	dropZone.strokeWidth = 4
	dropZone.alpha = 0 -- make invisible to begin with
	dropZone:setStrokeColor(255,0,0)
	dropZone:setReferencePoint(display.TopRightReferencePoint)
	physics.addBody(dropZone)
	dropZone.isSensor = true
	dropZone.collision = checkAnswer
	dropZone:addEventListener("collision",dropZone)
	dropZone.y = -45
	
	--now put them all into a group so you can move the group around with ease
	trayGroup:insert(tenThousandsPalette)
	trayGroup:insert(thousandsPalette)
	trayGroup:insert(hundredsPalette)
	trayGroup:insert(tensPalette)
	trayGroup:insert(onesPalette)
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
	trayGroup:insert(dropZone)
	trayGroup.x = 235;trayGroup.y = 640



	items=itemInfo.createItemsForThisLevel(levels[currLevel].theme)
	
	--list which cookies are available on each level
	local levelObjects = {
		{items[1], items[1], items[1], items[10]},
		{items[1], items[10],items[1], items[1], items[100], items[10]},
		{items[1], items[10],items[100], items[1], items[1], items[1000]},
		{items[1], items[10],items[100], items[1], items[10], items[1], items[1000]},
		{items[1], items[10],items[100], items[1], items[10], items[1], items[1000], items[10000]},
		{items[1], items[10],items[100], items[1], items[10], items[1], items[1000], items[10000]},
	}
	thisLevel = levelObjects[currLevel]
		
		--[[
		--create an intro message
		local intro = display.newGroup()
		local introBg = display.newRoundedRect(0,0,640,400,5)
		introBg.strokeWidth = 6
		introBg:setFillColor(200,100,50)
		introBg:setStrokeColor(255)
		intro:insert(introBg)
		local message = "Welcome to our factory. We need help packaging cookies for delivery, but someone seems to have forgotten to fill one of the places in each order.  Please help us by combining cookies to the right amount.  After combining them, drag the cookie to the empty spot below and they'll be packaged."
		local introText = display.newRetinaText(message,20,20,600,400, "Helvetica", 30)
		--
		
		intro:insert(introText)
		intro:setReferencePoint(display.CenterReferencePoint)
		intro.x = _W/2; intro.y = _H/2
]]
	 --marquee
		lcdText = display.newRetinaText("",135, _H-30, "BellGothicStd-Black", 28)
		lcdText:setReferencePoint(display.TopRightReferencePoint)
		lcdText:setTextColor(0,255,0)
		
		-- time display 
		local feedbackGroup = display.newGroup()
		local timeBox = display.newRect(0,0,200,50)
		timeBox:setReferencePoint(display.TopLeftReferencePoint)
		timeBox.x = 0; timeBox.y = 0;
		timeBox:setFillColor(0)
		timeBox.strokeWidth = 3
		timeBox:setStrokeColor(0,255,0)
		timeDisplay = display.newText("Time: ",5,0, "BellGothicStd-Black",24 )
		timeDisplay:setTextColor(0,255,0)
		
		timeCounter = display.newRetinaText(tostring(timeCount),110,5,font,28)
		timeCounter:setTextColor(0,255,0)
				
		
		
		local countBox = display.newRect(0,0,200,50)
		countBox:setReferencePoint(display.TopLeftReferencePoint)
		countBox.x = 200; countBox.y = 0;
		countBox:setFillColor(0)
		countBox.strokeWidth = 3
		countBox:setStrokeColor(0,255,0)		
		countDisplay = display.newText("Orders: ",205,0, "BellGothicStd-Black",24)
		countDisplay:setTextColor(0,255,0)
	
		orderCounter = display.newRetinaText(tostring(orderCount),310,5,font,28)
		orderCounter:setTextColor(0,255,0)
		--insert them all into one group
		feedbackGroup:insert(timeBox)
		feedbackGroup:insert(timeDisplay)
		feedbackGroup:insert(countBox)
		feedbackGroup:insert(countDisplay)
		feedbackGroup:insert(timeCounter)
		feedbackGroup:insert(orderCounter)
		feedbackGroup.x = 250; feedbackGroup.y = 30

	local sideBar = display.newGroup()
	levelBar = display.newImageRect("images/levelbar.png",90,_H)
	levelBar:setReferencePoint(display.TopRightReferencePoint)
	levelBar.x = 0; levelBar.y=0
	sideBar:insert(levelBar)
	sideBar.x = _W; sideBar.y =0
	
	--generate stars on levelBar
	function genStars()
		local gradient = graphics.newGradient(
			{134,10,200},{100, 0},"down"
		)
		-- first, put the black stars on the screen
		local starY = _H - 50
		for i=1, #levels do 
			local star = display.newImageRect("images/black_star.png",66,67)
			star.x = -41; star.y = starY;
			starY = starY - 90
			sideBar:insert(star)
		end
		starY = _H - 50 -- return and fill in the completed levels
		--now, generate the levels the user has accomplished so far, greying out the last one
		for i=1, currLevel do 
			local star = display.newImageRect("images/"..levels[i].starImg,66,67)
			star.x = -41; star.y = starY
			starY = starY-90
			--check if this is the level they're currently working on.  If so, put a gradient on the image, or change it's opacity
			if i == currLevel then
				--star:setFillColor(gradient) -- for some reason I get an error "gradients cannot be applied to image objects"
				star.alpha = .3
			end
			sideBar:insert(star)
		end
	end
	
	leftGroup = display.newGroup()
		--left  wall slice is not part of the storyboard group so that it remains on top of everything.  Have to remove and add it when you leave/enter the screen
		leftSlice = display.newImageRect("images/BGsliceLeft.png",30,380)
		leftSlice:setReferencePoint(display.TopLeftReferencePoint)
		leftSlice.x = 0; leftSlice.y = 0;		

		homeBtn=widget.newButton{
		default="images/btnHome.png",
		width=80,
		height=80,
		onRelease = onBtnRelease	-- event listener function
		}
		homeBtn:setReferencePoint(display.CenterReferencePoint)
		homeBtn.x = 150
		homeBtn.y = 45
		homeBtn.scene="menu"
		
		leftGroup:insert(leftSlice)
		leftGroup:insert(homeBtn)
	
	--insert everything into group in the desired order
	group:insert(lcdText)
	group:insert(bg)
	group:insert(conveyor)
	group:insert(feedbackGroup)
	--group:insert(intro)
	group:insert(trayGroup)
	group:insert(cookieGroup)
	group:insert(leftGroup)
	group:insert(sideBar)
	--group:insert(testGroup)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
--[[
--turn timeCounter into proxy so that it can listen for property updates
		timeCounter = proxy.get_proxy_for(timeCounter)

		
		function timeCounter:propertyUpdate(event)
			if event.key == "text" then
				print "text updated"
			end
		end

		timeCounter:addEventListener("propertyUpdate")
	]]
	
		--set up a timer to generate cookies (NOTE: allow users to increase the speed of the cookies across the screen and the rate at which cookies are generated)
	function generator()
		-- make sure to move this code to a question controlling 
		local randNum = generate.genRandNum(levels[currLevel].digits)
		local newCookie = math.random(#thisLevel)
		local c = thisLevel[newCookie]
		local cookieSpawn = spawn.spawnCookie(c.name,c.value, c.w,c.h,c.units, c.radius, c.shape)
		cookieGroup:insert(cookieSpawn)
	end
	-----------------------------------------------------------------------------
	
	--run the function right at the beginning so we don't have to wait for the first timer to go off
	startSession(currMode)
	
	function reset()
		timer.pause(spawnTimer)
		spawn.cleanUp()
		timer.resume(spawnTimer)
	end

	genStars()

	function enterFrame() 
		--first, check for and clean up the garbage
		--garbage.text = "Garbage collected:  "..collectgarbage("count")
		--texture.text = "Texture memory: "..system.getInfo("textureMemoryUsed")
		collectgarbage("collect")
		if spawn.answerSent == true then
			spawn.answerSent = false
			local userAnswer = spawn.sentValue
			--check answer and register stats
			if currNum.omitttedValue == userAnswer  then--got it right
				correct = correct +1
			end
			timer.performWithDelay(300,function()
				currNum = genQ()
				dropZone.alpha = 0		
				orderCount = orderCount+1
				orderCounter.text = tostring(orderCount)
				end, 1)
		end
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