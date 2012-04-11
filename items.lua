--PURPOSE: to create the info for each cookie item 

module(..., package.seeall)
local dimensions

--instead of creating an object for each cookie, let's only create objects that we'll actually use during this "round"
local shapes = {}
shapes[10] = {-30, -45,   8, -45,   25, 37,   23, 47,   -8, 47,   -30, -31}
shapes[100] = {-40, -36,   28, -36,   40, -30,   40, 36,   -30, 36,   -40, 26}
shapes[1000] = {-84, -54,   33, -54,   83, -8,   90, 48,   90, 54,   -40, 54,   -90, 6 }
shapes[10000] = {-90,-90,   34,-96,   91,-58,   90,87,   -54, 94,    -90,52}
shapes[100000] = {-86,-85,   71,-95,   86,-80,   86,85,   -72,95,    -86,79}

dimensions = {}
dimensions[1] = {w = 108, h = 98}
dimensions[2] =  {w = 66, h = 82}
dimensions[3]= {w = 70, h = 100}
dimensions[4] = {w = 76, h =119}
dimensions[5] = {w = 80, h =139}
dimensions[6] = {w = 88, h =158}
dimensions[7] = {w = 91, h =173}
dimensions[8] = {w = 97, h =190}
dimensions[9] = {w = 100, h =210}
dimensions[10] = {w = 111, h =134}
dimensions[20] = {w = 88, h =101}
dimensions[30] = {w = 119, h =101}
dimensions[40] = {w = 148, h =101}
dimensions[50] = {w = 178, h =101}
dimensions[60] = {w = 208, h =101}
dimensions[70] = {w = 238, h =101}
dimensions[80] = {w = 269, h =101}
dimensions[90] = {w = 295, h =101}
dimensions[100] = {w = 76, h =67}
dimensions[200] = {w = 161, h =76}
dimensions[300] = {w = 160, h =88}
dimensions[400] = {w = 173, h =87}
dimensions[500] = {w = 173, h =99}
dimensions[600] = {w = 186, h =99}
dimensions[700] = {w = 185, h =112}
dimensions[800] = {w = 198, h =112}
dimensions[900] = {w = 198, h =124}
dimensions[1000] = {w = 207, h =124}
dimensions[2000] = {w = 207,h = 73.35}
dimensions[3000] = {w = 207, h =109}
dimensions[4000] =  {w = 207, h =111}
dimensions[5000] = {w = 207, h =147}
dimensions[6000] = {w = 207, h =148}
dimensions[7000] = {w = 207, h =184}
dimensions[8000] = {w = 207, h =183}
dimensions[9000] = {w = 207, h =218}
dimensions[10000] = {w = 127, h =134}
dimensions[20000] = {w = 120, h =75}
dimensions[30000] = {w = 172, h =79}
dimensions[40000] = {w = 172, h =128}
dimensions[50000] = {w = 172, h =131}
dimensions[60000] = {w = 172, h =135}
dimensions[70000] = {w = 172, h =190}
dimensions[80000] = {w = 172, h =190}
dimensions[90000] = {w = 172, h =190}

function createItemsForThisLevel(theme)
	local items = {}
	items[1] = {name = theme, value = 1, w=48, h=48, units = 1, radius=24}
	items[10] = {name=theme, value = 10, w=134, h=95, units=10, radius=0, shape= shapes[10]}
	items[100] = {name=theme, value = 100, w=76,h=67, units=100, radius=0, shape=shapes[100]}
	items[1000] = {name=theme,value=1000, w=207,h=124, units=1000, radius=0, shape= shapes[1000]}
	items[10000] = {name=theme,value = 10000, w=127,h= 134, units=10000, radius=0, shape = shapes[10000] }
	for i=9,1.9, -1 do 
		items[i] = {name=theme, value = i, w=dimensions[i].w, h=dimensions[i].h, units=1, radius=0, shape=shapes[10]}
	end
	for i=90,19,-10 do 
		items[i] = {name=theme, value = i, w=dimensions[i].w, h=dimensions[i].h, units=10, radius=0, shape=shapes[100]}
	end
	for i=900, 199, -100 do 
		items[i] = {name=theme,value=i, w=dimensions[i].w, h=dimensions[i].h, units=100, radius=0, shape=shapes[1000]}
	end
	for i=9000,1999, -1000 do 
		items[i] = {name=theme,value = i, w=dimensions[i].w, h=dimensions[i].h, units=1000, radius=0, shape = shapes[10000]}
	end
	for i = 90000,19999, -10000 do 
		items[i] = {name=theme,value = i, w=dimensions[i].w, h=dimensions[i].h, units=10000, radius=0, shape = shapes[100000]}
	end
	return items
end

