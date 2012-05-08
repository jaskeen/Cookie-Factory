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
local spawnCookie, onLocalCollision, itemHit, itemDisappear, itemCombo, generator, createItemsForThisLevel, spawnTimer, disappearTimer, onLocalCollisionTimer, itemHitTimer,onBtnRelease, factoryBG, homeBtn, levelBar, nextQuestion, lcdText, startSession, genQ, leftSlice,leftGroup, timeDisplay, countDisplay, numDisplay, trayGroup, genStars,generatedBlocks,spawnBlock,inArray,genKey, dropZone, itemSensor, cookieGroup, correct, attempted, timerDisplay, ordersDisplay, correctDisplay, timeCount, timeCounter,orderCount, orderCounter, correctCount, correctCounter, trayColors
local trayWidth = 133
local trayHeight = 44

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
	
	--[[if currMode == "timed" then
		countdown = timer.performWithDelay(1000, function()
			timeCount = timeCount -1
			timeCounter.text = tostring(timeCount)
		end, 60*levels[currLevel].timed)
	end 
	]]--count elseif
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
    _G.currNum = genQ()
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

function spawnBlock(x,colorIndex)
	local block = display.newGroup()
	local image = display.newRect(0, 0, 14,40)
	image:setReferencePoint(display.TopRightReferencePoint)
	image.y = -40; image.x = x;
	image:setFillColor(255)
	image:setStrokeColor(trayColors[colorIndex][1],trayColors[colorIndex][2],trayColors[colorIndex][3])
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
		--generate counting blocks 
		local startingX = 930 - (i-1)*133
		--figure out what the places are so you can match the color
		local colorValue = 10^(i-1)
		for j=1, reverseNumT[i] do 
			if (newNum.omittedReversedArray[i] ~= "_") then
				spawnBlock(startingX,colorValue)
				startingX = startingX - 13.3
			else 	-- if the item value is "_" make the tray a sensor
				dropZone.x = startingX 
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
	
	--[[
	local ceiling = display.newRect(0,0,_W,10)
	physics.addBody(ceiling, "static")
	local bottomFloor = display.newRect(0,_H-100,_W, 10)
	physics.addBody(bottomFloor, "static")
	local leftWall = display.newRect(10, _H/2, 0, _H/2)
	physics.addBody(leftWall, "static")
	--now, insert all these invisible walls into the cookiegroup so they can interact with the cookies
	cookieGroup:insert(ceiling)
	cookieGroup:insert(leftWall)
	cookieGroup:insert(bottomFloor)
	]]
	local bg = display.newImageRect("images/newBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	local conveyor = display.newImageRect("images/conveyor.png",932, 158)
	conveyor:setReferencePoint(display.TopLeftReferencePoint)
	conveyor.x = 35; conveyor.y = 180;
	--	physics.addBody(conveyor, "static", {shape=-360, 632,   360, 632,   456, 527,   456, 474,   -456, 474,   -456, 527})
	
	
	
	---------------------------------------- Number BOXES ----------------------------------------
	values = {1,10,100,1000,10000}
	numDisplay = {}
	local digTextX = 867
	for i=1, levels[currLevel].digits do 
		numDisplay[i] = {}
		numDisplay[i].value = values[i]
		numDisplay[i].text = display.newEmbossedText("0",digTextX,45,"BellGothicStd-Black",36)
		numDisplay[i].text:setTextColor(255)
		digTextX = digTextX - trayWidth
		trayGroup:insert(numDisplay[i].text)
	end
	--empty one of the number fields to begin with
	if numDisplay[2] then
		numDisplay[2].text:setText("__")
	else 
		numDisplay[1].text:setText("__")
	end
	local paletteColor = 180
	trayColors = {}
	trayColors[1000000] = {100,100,180}
	trayColors[100000] = {112,61,191}
	trayColors[10000] = {182,61,91}
	trayColors[1000] = {216,101,88}
	trayColors[100] = {225,203,60}
	trayColors[10] = {82,148,100}
	trayColors[1] = {54, 158,251}
	--1,000,000s
	local millionsTray = display.newRect(0,0, trayWidth, 40)
	millionsTray:setFillColor(trayColors[1000000][1],trayColors[1000000][2],trayColors[1000000][3])
	local millionsText = display.newEmbossedText("millions",trayWidth+5,10,trayWidth-10,40,"BellGothicStd-Black", 21)
	millionsText:setTextColor(255,255,255)
	millionsText:setReferencePoint(display.CenterReferencePoint)
	millionsText.x = 67
	local millionsPalette = display.newRect(0,0,133,40)
	millionsPalette:setFillColor(paletteColor)
	millionsPalette:setReferencePoint(display.TopLeftReferencePoint)
	millionsPalette.x = 0; millionsPalette.y = -40;
	--100,000s
	local hundredThousandsTray = display.newRect(trayWidth,0, trayWidth, trayHeight)
	hundredThousandsTray:setFillColor(trayColors[100000][1],trayColors[100000][2],trayColors[100000][3])
	local hundredThousandsText = display.newEmbossedText("hundred thousands",trayWidth+5,0,trayWidth-10,40,"BellGothicStd-Black", 21)
	hundredThousandsText:setTextColor(255,255,255)
	hundredThousandsText:setReferencePoint(display.CenterReferencePoint)
	hundredThousandsText.x = trayWidth+67
	local hundredThousandsPalette = display.newRect(133,0,133,trayHeight)
	hundredThousandsPalette:setFillColor(paletteColor)
	hundredThousandsPalette:setReferencePoint(display.TopLeftReferencePoint)
	hundredThousandsPalette.x = trayWidth; hundredThousandsPalette.y = -40;
	--10,000s
	local tenThousandsTray = display.newRect(trayWidth*2, 0, trayWidth, trayHeight)
	tenThousandsTray:setFillColor(trayColors[10000][1],trayColors[10000][2],trayColors[10000][3])
	local tenThousandsText = display.newEmbossedText("ten thousands",trayWidth*2+5,0,trayWidth-10,40,"BellGothicStd-Black", 21)
	tenThousandsText:setTextColor(255,255,255)
	tenThousandsText:setReferencePoint(display.CenterReferencePoint)
	tenThousandsText.x = trayWidth*2+67
	local tenThousandsPalette = display.newRect(0,0,133,trayHeight)
	tenThousandsPalette:setFillColor(paletteColor)
	tenThousandsPalette:setReferencePoint(display.TopLeftReferencePoint)
	tenThousandsPalette.x = trayWidth*2; tenThousandsPalette.y = -40;
	--1,000s
	local thousandsTray = display.newRect(trayWidth*3,0, trayWidth, trayHeight)
	thousandsTray:setFillColor(trayColors[1000][1],trayColors[1000][2],trayColors[1000][3])
	local thousandsText = display.newEmbossedText("thousands",trayWidth*3+5,10,"BellGothicStd-Black", 21)
	thousandsText:setTextColor(255,255,255)
	thousandsText:setReferencePoint(display.CenterReferencePoint)
	thousandsText.x = trayWidth*3+67
	local thousandsPalette = display.newRect(0,0,133,trayHeight)
	thousandsPalette:setFillColor(paletteColor)
	thousandsPalette:setReferencePoint(display.TopLeftReferencePoint)
	thousandsPalette.x = trayWidth*3; thousandsPalette.y = -40;
	--100s
	local hundredsTray = display.newRect(trayWidth*4, 0, trayWidth, trayHeight)
	hundredsTray:setFillColor(trayColors[100][1],trayColors[100][2],trayColors[100][3])
	local hundredsText = display.newEmbossedText("hundreds",trayWidth*4+5,10,"BellGothicStd-Black", 21)
	hundredsText:setTextColor(255,255,255)
	hundredsText:setReferencePoint(display.CenterReferencePoint)
	hundredsText.x = trayWidth*4+67
	local hundredsPalette = display.newRect(0,0,133,trayHeight)
	hundredsPalette:setFillColor(paletteColor)
	hundredsPalette:setReferencePoint(display.TopLeftReferencePoint)
	hundredsPalette.x = trayWidth*4; hundredsPalette.y = -40;
	--10s
	local tensTray = display.newRect(trayWidth*5, 0, trayWidth*2, trayHeight)
	tensTray:setFillColor(trayColors[10][1],trayColors[10][2],trayColors[10][3])
	local tensText = display.newEmbossedText("tens",trayWidth*5+5,10,"BellGothicStd-Black", 21)
	tensText:setTextColor(255,255,255)
	tensText:setReferencePoint(display.CenterReferencePoint)
	tensText.x = trayWidth*5+67
	local tensPalette = display.newRect(0,0,133,trayHeight)
	tensPalette:setFillColor(paletteColor)
	tensPalette:setReferencePoint(display.TopLeftReferencePoint)
	tensPalette.x = trayWidth*5; tensPalette.y = -40;
	--1s
	local onesTray = display.newRect(trayWidth*6, 0, trayWidth, trayHeight)
	onesTray:setFillColor(trayColors[1][1],trayColors[1][2],trayColors[1][3])
	local onesText = display.newEmbossedText("ones",trayWidth*6+5,10,"BellGothicStd-Black", 21)
	onesText:setTextColor(255,255,255)
	onesText:setReferencePoint(display.CenterReferencePoint)
	onesText.x = trayWidth*6+67
	local onesPalette = display.newRect(0,0,133,trayHeight)
	onesPalette:setFillColor(paletteColor)
	onesPalette:setReferencePoint(display.TopLeftReferencePoint)
	onesPalette.x = trayWidth*6; onesPalette.y = -40;


	--create a target block (i.e. "dropzone") for delivering the packaged cookies
	dropZone = display.newRect(0,0, trayWidth-6,125)
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
	trayGroup:insert(millionsPalette)
	trayGroup:insert(hundredThousandsPalette)
	trayGroup:insert(tenThousandsPalette)
	trayGroup:insert(thousandsPalette)
	trayGroup:insert(hundredsPalette)
	trayGroup:insert(tensPalette)
	trayGroup:insert(onesPalette)
	trayGroup:insert(millionsTray)
	trayGroup:insert(hundredThousandsTray)
	trayGroup:insert(tenThousandsTray)
	trayGroup:insert(thousandsTray)
	trayGroup:insert(hundredsTray)
	trayGroup:insert(tensTray)
	trayGroup:insert(onesTray)
	trayGroup:insert(millionsText)
	trayGroup:insert(hundredThousandsText)
	trayGroup:insert(tenThousandsText)
	trayGroup:insert(thousandsText)
	trayGroup:insert(hundredsText)
	trayGroup:insert(tensText)
	trayGroup:insert(onesText)
	trayGroup:insert(dropZone)
	trayGroup.x = 0;trayGroup.y = 640



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
		local chalkBoard = display.newImageRect("images/chalkBoard.png",756,92)
		chalkBoard:setReferencePoint(display.TopLeftReferencePoint)
		chalkBoard.x = 0; chalkBoard.y = 0;
		physics.addBody(chalkBoard, "static", {shape={-378, -40,  378,-40, 378, 40,  -378,40}})
		
		--[[
		timeDisplay = display.newText("Time: ",305,30, "BellGothicStd-Black",38 )
		timeDisplay:setTextColor(255, 150)
		
		timeCounter = display.newRetinaText(tostring(timeCount),415,30,"BellGothicStd-Black",38)
		timeCounter:setTextColor(255, 150)
		]]
		countDisplay = display.newText("Orders: ",505,30, "BellGothicStd-Black",38)
		countDisplay:setTextColor(255, 150)
	
		orderCounter = display.newRetinaText(tostring(orderCount).." / "..levels[currLevel].count,635,30,"BellGothicStd-Black",38)
		orderCounter:setTextColor(255, 150)
		
		homeBtn=widget.newButton{
		default="images/btnHome.png",
		width=60,
		height=54,
		onRelease = onBtnRelease	-- event listener function
		}
		homeBtn:setReferencePoint(display.CenterReferencePoint)
		homeBtn.x = 60
		homeBtn.y = 40
		homeBtn.scene="menu"
		--insert them all into one group
		feedbackGroup:insert(chalkBoard)
		--feedbackGroup:insert(timeDisplay)
		feedbackGroup:insert(countDisplay)
		--feedbackGroup:insert(timeCounter)
		feedbackGroup:insert(orderCounter)
		feedbackGroup:insert(homeBtn)
		feedbackGroup.x = 104; feedbackGroup.y = 0

	local sideBar = display.newGroup()
	levelBar = display.newImageRect("images/levelbar.png",93,_H)
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

		
		leftGroup:insert(leftSlice)
	
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
				--check to see if they've reached the goal for this level
				if correct == levels[currLevel].count then
					currLevel = currLevel +1
					if currLevel > #levels then 
						currLevel = #levels
						correct = 0 -- set it back to 0 for this level so they can never finish.  Mwah ha aha a ha ha ha ha!
					else 
						--reload page?
						storyboard.reload(storyboard.getScene())
					end
				end
				
			end
			timer.performWithDelay(300,function()
				_G.currNum = genQ()
				dropZone.alpha = 0		
				orderCount = orderCount+1
				orderCounter.text = tostring(orderCount).." / "..levels[currLevel].count
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