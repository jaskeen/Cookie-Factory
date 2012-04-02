------------------------------------
--Using network.request to send and recieve over a network
------------------------------------
local network= require "network"
local json = require "json"

--Data = 
sessionID= "1234112123412341234f1243"
--[[ 
	{
	appID= "Cookie Factory" ,
	subject= "Math",
	topic= "Place Value",
	standards= "3.4, 4.2",
	studentID= "StudentID",
	level= "4",
	mode= "Timed",
	numQuestSkipped= 1,
	numQuestCorrect= 2,
	numQuestIncorrect= 3,
	}
]]
--RECEIVING DATA
local function networkListener(event)
	if (event.isError) then
		print("Network Error!")
	else
		print("Response:".. event.response)
		--local response= display.newText("Response:"..event.response, 100, 100, native.systemFont, 40)
		--response:setTextColor(255, 255, 255) 
	end
end

url="http://byuipt.net/760/W12/DataPractice/dataForm.php"
--request form from php
network.request(url)


--SENDING DATA VIA HTTP post
local function networkListener(event)
	if (event.isError) then	
		print("Network Error!")
	else
		print("Response:".. event.response)
		
	end
end

--data is a variable with all of the json variables 
--if not a variable list as a string "variablex=x&variabley=y&variablez=z" and so on
postData= "sessionID=this%20session&name=Jen&class=IP%2760";

local params={}
params.body=postData

--post the data so it can be pulling into a php page and database
network.request(url, "POST", networkListener, params) 
				--(url, method("GET" or "POST"), listener, params)

------------------------------------
--Work with JSON objects
------------------------------------