--COOKIE FACTORY SUPERVISOR MODE--
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
local supervisorTitle=display.newImageRect("images/supervisorMode.png", 300, 60)
	supervisorTitle:setReferencePoint( display.CenterReferencePoint )
	supervisorTitle.x = _W/2 
	supervisorTitle.y = _H/2 
	
	localGroup:insert(factoryBG)
	localGroup:insert(supervisorTitle)
	
	function changeScene(event)
		if(event.phase=="ended")then
			director:changeScene(event.target.scene)
		end
	end
	
	factoryBG:addEventListener("touch", changeScene)
	
	return localGroup
end
