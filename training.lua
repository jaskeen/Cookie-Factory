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
	
-- Called when the scene's view does not exist:
function scene:createScene( event ) 
	local group = self.view  --insert all display objects into this
	
	local bg = display.newImageRect("images/factoryBG.png",1024,768)
	bg.x = _W/2; bg.y = _H/2
	--local conveyorBelt = display.newImageRect("images/conveyorSprite.png",930, 190)
	--conveyorBelt:setReferencePoint(display.TopLeftReferencePoint)
	--conveyorBelt.x = 10; conveyorBelt.y = 70;
	local ipad = display.newImageRect("images/iPad.png",250, 200)
	ipad:setReferencePoint(display.TopLeftReferencePoint);
	ipad.x = 30; ipad.y = 550

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
	

	local trainingTitle=display.newImageRect("images/trainingMode.png", 300, 60)
	trainingTitle:setReferencePoint( display.CenterReferencePoint )
	trainingTitle.x = _W/2 
	trainingTitle.y = _H/2 

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	group:insert(factoryBG)
	group:insert(trainingTitle)
	group:insert(homeBtn)
	
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