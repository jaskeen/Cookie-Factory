-----------------------------------------------------------------------------------------
--PURPOSE: to generate a random number for a specific level, and generate a missing value and form of that number
-----------------------------------------------------------------------------------------
module(..., package.seeall)

local level = 4 --remember to get this from the user's data at some point

--to generate a random # for each level
----note: # should have level +1 digits.  hence, level 1 = 2 digits, level 2 has 3 digits, etc.
function genRandNum(level)
	 local places = {1}
     for i=1,level do
           table.insert(places, places[#places]*10)
     end
	
	local numberT = {}
	for i=1, level+1 do 
		table.insert(numberT,math.random(1,9))
	end
	local num = tonumber(table.concat(numberT))--concatentate all the items in the table to one string
	local omitPlace = math.random(1,#numberT)
	--don't forget to reverse the number to count from the right
	revT ={}
	for i,v in ipairs(numberT) do
      revT[v] = i
    end
	local omitValue = revT[omitPlace]*places[omitPlace]
	--now remove that digit
	local numTReversedWithOmittedDigit = revT
	numTReversedWithOmittedDigit[omitPlace] = "__"
	local numInfo = {}
	numInfo.number = num
	numInfo.omittedValue = omitValue
	numInfo.omittedArray = numTReversedWithOmittedDigit
	
	return numInfo
end