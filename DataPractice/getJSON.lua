require "json"
local t= json.decode(jsonFile("jsonPractice.json"))

local value = json.encode (t)
 	print (value)  --> {"name1":"value1","name3":null,"name2":[1,false,true,23.54,"a \u0015 string"]}
 
local t = json.decode(value)
	print(t.name2[4])  --> 23.54