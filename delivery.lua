----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local widget= require"widget"
local scene = storyboard.newScene()
local onBtnRelease
local factoryBG
local homeBtn
local checkBtn
local selectionA
local selectionB
local selectionC
local numberSelect
local text


----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
-- 'onRelease' event listener for return to main menu
function onBtnRelease(event)
	
	-- go to scene1.lua scene
	print (event.target.scene)
		storyboard.gotoScene(event.target.scene)
	return true	-- indicates successful touch
end
	
--[[function numberSelect(event)
	
	-- go to scene1.lua scene
	print (event.target.id)
		
	if event.target.id==700 then 
		print("correct!")
		storyboard.number=event.target.id
		storyboard.gotoScene(event.target.scene)
		
	elseif event.target.id~=700 then 
		print("you are off by "..700-event.target.id)
		storyboard.gotoScene(event.target.scene)
		
	end

	return true	-- indicates successful touch
end
]]
function scene:createScene( event )
	local group = self.view
	
	factoryBG= display.newImageRect("images/factoryBG.png", _W, _H)
	factoryBG:setReferencePoint(display.CenterReferencePoint)
	factoryBG.x = _W/2
	factoryBG.y = _H/2
	factoryBG.scene="menu"
	
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
	
	--[[checkBtn=widget.newButton{
		id="check",
		default="images/checkBtn.png",
		width=80,
		height=80,
		onRelease = onBtnRelease	-- event listener function
		}
	checkBtn:setReferencePoint(display.CenterReferencePoint)
	checkBtn.x = _W*.06
	checkBtn.y = _H*.93
	checkBtn.scene="check"
	
	selectionA=widget.newButton{
		id=700,
		default="images/700.png",
		width=100,
		height=100,
		onRelease = numberSelect	-- event listener function
		}
	selectionA:setReferencePoint(display.CenterReferencePoint)
	selectionA.x = _W/2
	selectionA.y = _H*.7
	selectionA.scene="check"
	
	selectionB=widget.newButton{
		id=420,
		default="images/420.png",
		width=100,
		height=100,
		onRelease = numberSelect	-- event listener function
		}
	selectionB:setReferencePoint(display.CenterReferencePoint)
	selectionB.x = _W/2+150
	selectionB.y = _H*.7
	selectionB.scene="check"
	
	selectionC=widget.newButton{
		id=232,
		default="images/232.png",
		width=100,
		height=100,
		onRelease = numberSelect	-- event listener function
		}
	selectionC:setReferencePoint(display.CenterReferencePoint)
	selectionC.x = _W/2-150
	selectionC.y = _H*.7
	selectionC.scene="check"
	
	text=display.newText("Select the number Seven-Hundred below:", _W*.07, _H/2-200, native.systemFont, 40)
		text:setTextColor(255,255,255)
	]]
	local deliveryTitle=display.newImageRect("images/btnStandards.png", 300, 60)
	deliveryTitle:setReferencePoint( display.CenterReferencePoint )
	deliveryTitle.x = _W/2 
	deliveryTitle.y = _H/2 

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	group:insert(factoryBG)
	group:insert(deliveryTitle)
	group:insert(homeBtn)
	--group:insert(checkBtn)
	--group:insert(selectionA)
	--group:insert(selectionB)
	--group:insert(selectionC)
	--group:insert(text)
	
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