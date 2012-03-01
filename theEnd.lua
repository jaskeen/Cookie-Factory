module(..., package.seeall)


function new()
	local localGroup= display.newGroup()
	
	_H= display.contentHeight
	_W= display.contentWidth
	
	local creditsImage= display.newImageRect("images/creditsBackground.png", _W, _H)
	creditsImage:setReferencePoint(display.CenterReferencePoint)
	creditsImage.x = _W/2
	creditsImage.y = _H/2
	creditsImage.scene="menu"
	
	localGroup:insert(creditsImage)
	
	function changeScene(event)
		if(event.phase=="ended")then
			director:changeScene(event.target.scene)
		end
	end
	
	creditsImage:addEventListener("touch", changeScene)
	
	return localGroup
end