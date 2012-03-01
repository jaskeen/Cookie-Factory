module(..., package.seeall)


function new()
	local localGroup=display.newGroup()

	_H= display.contentHeight
	_W= display.contentWidth

mRand=math.random

--number of bananas
b = 0
time_remain=20
time_up=false
total_bananas=25
ready=false

--sounds
local soundtrack=audio.loadStream("media/congo_drums.mp3")
local banana_sound=audio.loadSound("media/crunch1.mp3")
local win_sound=audio.loadSound("media/gong1.mp3")
local fail_sound=audio.loadSound("media/squeakPop.mp3")

--create display text
local display_txt = display.newText("Wait", 0, 0, native.SystemFontBold, 50)
display_txt.xScale=.5
display_txt.yScale=.5
display_txt: setReferencePoint(display.BottomLeftReferencePoint)
display_txt.x=10
display_txt.y=_H-20

localGroup:insert(display_txt)

local countdowntxt = display.newText(time_remain, 0, 0, native.SystemFont, 50)
countdowntxt.xScale=.5
countdowntxt.yScale=.5
countdowntxt: setReferencePoint(display.BottonRightReferencePoint)
countdowntxt.x=_W-50
countdowntxt.y=_H-40

localGroup:insert(countdowntxt)

local replay = display.newImageRect("images/replay.png", 320, 80)
replay:setReferencePoint(display.CenterReferencePoint)
replay.x=_W/2
replay.y=_H/2 - replay.height
replay.isVisible=false
replay.alpha = 0
replay.scene= nil

local backtomenu = display.newImageRect("images/backtomenu.png", 320, 80)
backtomenu:setReferencePoint(display.CenterReferencePoint)
backtomenu.x=_W/2
backtomenu.y=_H/2 + backtomenu.height
backtomenu.isVisible=false
backtomenu.alpha=0
backtomenu.scene= "menu"


-----------------------------
--FUNCTIONS
-----------------------------


local function winLose(condition)
	replay.isVisible =true
	backtomenu.isVisible=true
	
	transition.to(replay, {time=500, alpha=1})
	transition.to(backtomenu, {time=500, alpha=1})
	
	if(condition=="win")then
		display_txt.text="You eat like a MONKEY!"
		display_txt.x=260
	elseif(condition=="fail")then
		audio.play(fail_sound)
		display_txt.text="Try Again"
		display_txt.x=100
		ready=false
	end
end


local function trackBananas(obj)
	obj:removeSelf()
	b = b-1
	
	if (time_up ~= true) then
		--If all the bananas are removed from display,then call winLose
		if(b==0) then
			audio.play(win_sound)
			timer.cancel(gameTmr)
			winLose("win")
		end
	end
end

--create the counter
local function countdown(event)
	if(time_remain==time_remain)then
		ready=true
		display_txt.text="Go!"
		backgroundmusic= audio.play(soundtrack,{loops=-1})
	end

	time_remain=time_remain-1
	countdowntxt.text=time_remain
	
	if (time_remain==0)then
		
		time_up=true
		
		if(b~=0)then
			audio.play(fail_sound)
			winLose("fail")
			ready=false
		end
	end
end

--spawn Banana function with 75 pixel and 100 pixel padding on each side
local function SpawnBanana()
	local banana= display.newImageRect("images/banana.png", 50, 50)
	banana: setReferencePoint(display.CenterReferencePoint)
	banana.x=mRand(75, _W-75)
	banana.y=mRand(75,_H-150)
	
	
	function banana:touch(event)
		if (ready==true) then
			if (time_up ~= true) then	
				if(event.phase=="ended")then
				--play the banana sound
					audio.play(banana_sound)
				--remove the bananas
					trackBananas(self)
				end
			end
		end
		return true
		
	end
	
	--every time a banana is spawn, increment b by 1
	
	b = b+1
	
	banana:addEventListener("touch", banana)

	--track the number of bananas spawn(b), if all bananas are created, start the countdowntmr
	if(b == total_bananas)then
		gameTmr=timer.performWithDelay(1000, countdown, time_remain)
	else
		ready=false
	end
	
	localGroup:insert(banana)

end

--time 

tmr= timer.performWithDelay(20, SpawnBanana, total_bananas)

function changeScene(event)
	if(event.phase=="ended")then
		
		audio.stop(soundtrack)
		audio.rewind(soundtrack)
		
		replay.isVisible =false
		replay.alpha=0
		backtomenu.isVisible=false
		backtomenu.alpha=0
		
		
		if(event.target.scene)then
		--Load Main Menu
			audio.stop(soundtrack)
			director: changeScene(event.target.scene)
		else
		--Load Game Again
		b=0
		time_remain=20
		time_up=false
		total_bananas=25
		ready=false
		
		--clear the game timer
		gameTmr=nil
		
		--clear the banana timer
		tmr=nil
		
		--create the bananas and start over
		tmr= timer.performWithDelay(20, SpawnBanana, total_bananas)
		end
	end	
end

replay:addEventListener("touch", changeScene)
backtomenu: addEventListener("touch", changeScene)



	return localGroup
end