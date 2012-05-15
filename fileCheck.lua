module(..., package.seeall)
local json = require "json"

 --Check if a file exists in the Resource directory.  If not, copy it from a base directory to the Documents Directory
function checkForFile(file) 
	local checkPath = system.pathForFile(file,system.DocumentsDirectory)
	local isFileThere = io.open(checkPath,"r")
	if isFileThere == nil then
	--file doesn't exist, so copy file from base directory to target Directory)
		local existingPath = system.pathForFile(file,system.ResourceDirectory)
		print (existingPath)
		if existingPath == nil then
			print ("ERROR: There is no "..file.." in the Resource Directory")
		else -- file exists, so copy it from the Resource Directory to the Documents directory
			local readFile = io.open(existingPath,"r")
			fileContents = readFile:read("*a")
			io.close(readFile)
			readFile = nil
			path = nil
			--now copy to new directory
			local newPath = system.pathForFile(file,system.DocumentsDirectory)
			local newFile = io.open(newPath,"w")
			newFile:write(fileContents)
			io.close(newFile)
			newFile = nil
			path2 = nil
			print (file.." copied successfully")
		end
	else --file already exists
		print(file.." already exists in the Documents Directory")
	end
end

function copyContents(file)
	local path = system.pathForFile(file,system,DocumentsDirectory)
	local readFile = io.open(path,"r")
	local contents = readFile:read("*a")
	io.close(readFile)
	readFile = nil
	path = nil
	return contents
end

function replaceContents(file,newContents)
	local encodedContents = json.encode(newContents)
	local path = system.pathForFile(file,system,DocumentsDirectory)
	local writeFile = io.open(path,"w")
	writeFile:write(encodedContents)
	io.close(writeFile)
	print("writing data")
	writeFile = nil
	path = nil
end