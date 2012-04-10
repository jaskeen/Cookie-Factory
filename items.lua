--PURPOSE: to create the info for each cookie item 

module(..., package.seeall)

--instead of creating an object for each cookie, let's only create objects that we'll actually use during this "round"
local shapes = {}
shapes[10] = {-30, -45,   8, -45,   25, 37,   23, 47,   -8, 47,   -30, -31}
shapes[100] = {-40, -36,   28, -36,   40, -30,   40, 36,   -30, 36,   -40, 26}
shapes[1000] = {-84, -54,   33, -54,   83, -8,   90, 48,   90, 54,   -40, 54,   -90, 6 }
shapes[10000] = {-90,-90,   34,-96,   91,-58,   90,87,   -54, 94,    -90,52}

function createItemsForThisLevel(theme)
	local items = {}
	items[1] = {name = theme, value = 1, w=48, h=48, units = 1, radius=24}
	items[10] = {name=theme, value = 10, w=80, h=95, units=10, radius=0, shape= shapes[10]}
	items[100] = {name=theme, value = 100, w=80,h=71, units=100, radius=0, shape=shapes[100]}
	items[1000] = {name=theme,value=1000, w=180,h=108, units=1000, radius=0, shape= shapes[1000]}
	items[10000] = {name=theme,value = 10000, w=180,h= 189, units=10000, radius=0, shape = shapes[10000] }
	for i=9,1.9, -1 do 
		items[i] = {name=theme, value = 10, w=80, h=95, units=1, radius=0, shape=shapes[10]}
	end
	for i=90,19,-10 do 
		items[i] = {name=theme, value = 100, w=80,h=71, units=10, radius=0, shape=shapes[100]}
	end
	for i=900, 199, -100 do 
		items[i] = {name=theme,value=1000, w=180,h=108, units=100, radius=0, shape=shapes[1000]}
	end
	for i=9000,1999, -1000 do 
		items[i] = {name=theme,value = 10000, w=180,h= 189, units=1000, radius=0, shape = shapes[10000]}
	end
	return items
end

