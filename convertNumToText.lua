-----------------------------------------------------------------------------------------
-- PURPOSE: To practice generating a random #, converting it to text, and remove one digit, at random
-----------------------------------------------------------------------------------------
module(..., package.seeall)

function convertNumToText(num)
    --create arrays of word equivalents for the numbers
    local ones = {"one","two","three","four","five","six","seven","eight","nine"}
    local teens = {"eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"}
    local  tens = {"ten","twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"}
    local tripletUnits = {"","thousand","million","billion","trillion","quadrillion","quintillion","sextillion","septillion","octillion","nonillion","decillion", "undecillion","duodecillion"}
   
    local revNum = string.reverse(num)
   
    --2. split # into triplets --------- (string.sub(string,begin, end))
    local start = 1
    local stop = 3
    local tripletTable = {}
   
    local stringNum = tostring(num) --convert to string so you can use string matching on it
    local numLen = string.len(stringNum) -- find out how many digits the # is
    local numTriplets = math.ceil(numLen/3)
    for i = 1, numTriplets do
        tripletTable[i] = tonumber(string.reverse(string.sub(revNum,start,stop)))
        start = start+3
        stop = stop +3
    end
   
   
    local fullName ={}
    --3. Go through each triplet and textualize the #s
    for i=1, #tripletTable do 
        local tripletName = ''   
        local str = tostring(tripletTable[i])
        local newString = string.rep("0",3-#str)..str  --pad the triplet so it is exactly 3 characters
        --local newString = string.lpad(tostring(tripletTable[i]),3,"0")
        local num1 = string.match(newString,"%d",1)
        local num2 = string.match(newString,"%d",2)
        local num3 = string.match(newString,"%d",3)
        if num1 ~= "0" then
            --format the "hundreds" #
            tripletName = ones[tonumber(num1)].." hundred "
        end
        if tonumber(num2) > 1 then
            tripletName = tripletName .. tens[tonumber(num2)]
            if num3 ~= "0" then
                tripletName= tripletName .. "-"
            end
        end
        if tonumber(num2) == 1 then -- we're in the teens
            if num3 == "0"  then --it's a 10
                tripletName = tripletName .. tens[tonumber(num2)]
            else
                tripletName = tripletName .. teens[tonumber(num3)]
            end
        elseif (num3 ~= "0") then
            tripletName = tripletName .. ones[tonumber(num3)]
        end
        fullName[i] = tripletName
    end
   
    local finalName =""
    for i = #fullName, 1, -1 do --traverse the table backwards so that you start with the highest #s first
        finalName = finalName.. fullName[i] .. " "..tripletUnits[i]
        if i ~= 1 then
            finalName = finalName..", "
        end
    end
    return finalName
end
