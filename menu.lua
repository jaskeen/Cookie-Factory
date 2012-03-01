--COOKIE FACTORY MENU--

module(..., package.seeall)

_W=display.contentWidth
_H=display.contentHeight

--this "new" method is required here
function new()
	local localGroup= display.newGroup()
			
	local background = display.newImageRect( "images/Splash-background.png", _W, _H )
	background:setReferencePoint( display.CenterReferencePoint )
	background.x=_W/2
	background.y=_H/2
	
	local trainingBtn = newImageRect("images/trainingMode.png", _W, _H)
	trainingBtn:setReferencePoint(display.CenterReferencePoint)
	trainingBtn.x = _W/2 - 60
	trainingBtn.y = _H/2 - 60
	trainingBtn.scene="scene1"
	
	local deliveryBtn = newImageRect("images/deliveryMode.png", _W, _H)
	deliveryBtn:setReferencePoint( display.CenterReferencePoint )
	deliveryBtn.x = _W/2 - 60
	deliveryBtn.y = _H/2 + 15
	deliveryBtn.scene = "scene2"
	
	local supervisorBtn = newImageRect("images/supervisorMode.png", _W, _H)
	supervisorBtn: setReferencePoint(display.CenterReferencePoint)
	supervisorBtn.x = _W/2 - 60
	supervisorBtn.y = _H/2 + 90
	supervisorBtn.scene = "scene3"
	
	function changeScene(event)
		if(event.phase=="ended") then
			director:changeScene(event.target.scene)
		end
		
	end
	
	localGroup: insert(background)
	localGroup: insert(trainingBtn)
	localGroup: insert(deliveryBtn)
	localGroup: insert(supervisorBtn)
	
	trainingBtn:addEventListener("touch", changeScene)
	deliveryBtn:addEventListener("touch", changeScene)
	supervisorBtn:addEventListener("touch", changeScene)
	
	return localGroup
	
end