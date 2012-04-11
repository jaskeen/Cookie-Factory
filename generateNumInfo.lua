-----------------------------------------------------------------------------------------
--PURPOSE: to generate a random number for a specific level, and generate a missing value and form of that number
-----------------------------------------------------------------------------------------
module(..., package.seeall)

--local level = 5 --remember to get this from the user's data at some point

--to generate a random # for each level
----note: # should have level +1 digits.  hence, level 1 = 2 digits, level 2 has 3 digits, etc.
function genRandNum(digits)
	 local places = {1}
     for i=1,digits do
           table.insert(places, places[#places]*10)
     end
	
	local numberT = {}
	for i=1, digits do 
		table.insert(numberT,math.random(1,9))
	end
	local num = tonumber(table.concat(numberT))--concatentate all the items in the table to one string
	local omitPlace = math.random(1,#numberT)
	--don't forget to reverse the number to count from the right
	revT ={}
	local counter = 1
	for i=#numberT,1,-1 do 
		revT[counter] = numberT[i]
		counter = counter +1
	end
	
	local omitValue = revT[omitPlace]*places[omitPlace]
	--now remove that digit
	local numTReversedWithOmittedDigit = revT
	numTReversedWithOmittedDigit[omitPlace] = "_"
	local numInfo = {}
	numInfo.number = num
	numInfo.numberT = numberT
	numInfo.omittedValue = omitValue
	numInfo.omittedReversedArray = numTReversedWithOmittedDigit
	numInfo.place = places[omitPlace]
	numInfo.omittedNum = string.reverse(table.concat(numTReversedWithOmittedDigit))
	return numInfo
end

--generate a list of numInfo objects WARNING: howManyNumsToMake MUST be equal to or less than digitsInNum, or you'll get an infinite loop).
function generateNumInfos(howManyNumsToMake,digitsInNum)
    --[[ VARIABLES USED IN THIS FUNCTION 
         1. array: used in the inArray function
         2. value: value to be check for existence in the inArray fcn
         3. n: number of digits in our randomly generated number
         4. list: array of numbers created, used in the generateListNum() fcn
    ]]
	--create a list to store the randomly genereated numbers and their info
	local numList = {}
	
	--check if a value is in an array (http://developer.anscamobile.com/forum/2011/08/21/urgent-custom-fonts-ios-31)
	local function inArray(array, value)
	    local is = false
	    for i, thisValue in ipairs(array) do
	        if thisValue == value then 
	        	is = true; break end
	    end
	    return is
	end
	
	--generate a  number that is not currently in numList
	local function generateListNum(n,list)
		--first, we need to know which places are currenlty used, so let's get those out of the list
		local placesList ={}
		for i=1, #list do 
			placesList[i] = list[i].place
		end
		local newNum = genRandNum(n)
			if inArray(placesList,newNum.place) == true then --the # is in the list already
				print (newNum.place .." was already used.")
				return generateListNum(n, list)
			else 
				table.insert(list,newNum)
			end
	end
	
	--generate level+1 numbers
	for i=1,howManyNumsToMake do 
	 	generateListNum(digitsInNum,numList)
	end
	
	return numList
end

--[[
	--print the info about each num in the list
	print ("Num list has: "..#numList.." items.")
	for i=1,#numList do 
		print ("Number: "..numList[i].number, "places used: "..numList[i].place, "Value: "..numList[i].omittedValue,"Omitted Num: "..string.reverse(table.concat(numList[i].omittedReversedArray)))
	end
	]]