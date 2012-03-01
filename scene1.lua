--COOKIE FACTORY TRAINING MODE--

module(..., package.seeall)

--====================================================================--
-- SCENE: SCREEN 1
--====================================================================--
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
	
	local trainingTitle=display.newImageRect("images/trainingMode.png", 300, 60)
	trainingTitle:setReferencePoint( display.CenterReferencePoint )
	trainingTitle.x = _W/2 
	trainingTitle.y = _H/2 
	
	localGroup:insert(factoryBG)
	localGroup:insert(trainingTitle)
	
	function changeScene(event)
		if(event.phase=="ended")then
			director:changeScene(event.target.scene)
		end
	end
	
	factoryBG:addEventListener("touch", changeScene)
	
	return localGroup
end

