-- jsonFile() loads json file & returns contents as a string
local jsonFile = function( jsonData, base )

	-- set default base dir if none specified
	if not base then base = system.ResourceDirectory; end

	-- create a file path for corona i/o (open and close)
	local path = system.pathForFile( filename, base )

	-- will hold contents of file
	local data

	-- io.open opens a file at path. returns nil if no file found (r=read)
	local file = io.open( path, "r" )
	if file then
	   -- read all contents of file into a string (*a=all)
	   data = file:read( "*a" )
	   io.close( file )	-- close the file after using it
	end

	return data
end

--encode the string, or turn a string into a JSON string that can then be passed through a php post
local jsonString = json.encode( myLuaTable )