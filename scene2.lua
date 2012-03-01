--COOKIE FACTORY DELIVERY MODE--

--====================================================================--
-- SCENE: SCREEN 2
--====================================================================--

module(..., package.seeall)

_W=display.contentWidth
_H=display.contentHeight

function new()
	local localGroup= display.newGroup()
	
	_H= display.contentHeight
	_W= display.contentWidth
	
local factoryBG= display.newImageRect("images/factoryBG.png", _W, _H)
	factoryBG:setReferencePoint(display.CenterReferencePoint)
	factoryBG.x = _W/2
	factoryBG.y = _H/2
	factoryBG.scene="menu"
	
local deliveryTitle=display.newImageRect("images/deliveryMode.png", _W, _H)
	deliveryTitle:setReferencePoint( display.CenterReferencePoint )
	deliveryTitle.x = _W/2 
	deliveryTitle.y = _H/2 
	
	localGroup:insert(factoryBG)
	localGroup:insert(deliveryTitle)
	
	function changeScene(event)
		if(event.phase=="ended")then
			director:changeScene(event.target.scene)
		end
	end
	
	factoryBG:addEventListener("touch", changeScene)
	
	return localGroup
end
