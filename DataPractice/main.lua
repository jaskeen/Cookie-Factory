------------------------------------
--Using network.request to send and recieve over a network
------------------------------------
local network= require "network"

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

--I can't get the address correct for the class folder so I put it in the PGVT folder temporarily
network.request("http://byuipt.net/PGVT/DataPractice/formFun.php")


--SENDING DATA VIA HTTP post
local function networkListener(event)
	if (event.isError) then	
		print("Network Error!")
	else
		print("Response:".. event.response)
		--local response= display.newText("Response:"..event.response,100, 100, native.systemFont, 40)
		--response:setTextColor(255, 255, 255) 
	end
end

postData="fColor=green&fNumber=7"

local params={}
params.body=postData

--I can't get the address correct for the class folder so I put it in the PGVT folder temporarily
network.request("http://byuipt.net/PGVT/DataPractice/formFun.php", "POST", networkListener, params) 
				--(url, method("GET" or "POST"), listener, params)

------------------------------------
--Work with JSON objects
------------------------------------