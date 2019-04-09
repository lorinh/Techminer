----------------
---saves and loads save file
----------------
--File name is save
-------------
--needs to write:
----level
----money
----tools
----Camera
----tick(later)
----buildings
----backpack
----map
----background
----version
--------------

save = {}

function save.init()
	save.initialized = true
end

function save.ereaseSave()
	love.filesystem.remove('save')
	save.data = {}
	save.file = nil
	map:reset()
end

save.loadFile = function(step)--step to keep fps while loading, 20 steps
	if not save.file then
		save.file = love.filesystem.read('save')
	end
	local file = save.file
	if file then
		if step < 10 then
			if step == 1 then
				save.data = {}
				save.i = 0
			end
			local _ = save.i
			save.i = string.find(file, "\n", save.i+1)
			save.data[#save.data+1] = string.sub(file,_+1,save.i-2)
			if #save.data ~= 9 and step == 9 then
				return false
			end
		elseif step == 10 then
			for i,v in pairs(save.data) do
				if i < 6 then -- only decode values less than 6
					save.data[i] = save.decode(v)
				end
			end
		elseif step == 11 then
			stats.blockBroken = tonumber(save.data[1])
		elseif step == 12 then
			stats.money = tonumber(save.data[2])
		elseif step == 13 then
			Camera = save.reverseCamera(save.data[3])
			print('camera is at: ' .. tostring(Camera),'Data 4: ' .. save.data[4])
		elseif step == 14 then
			
		elseif step == 15 then
		--do nothing with data[5]

		elseif step == 16 then
			--buildings.buildings = save.reverseBuildingConcat(save.data[6]) ABRA CA DABRA
			--stats.ownedItems = save.reverseToolConcat(save.data[6])
			save.reverseHotBarConcat(save.data[6])
		elseif step == 17 then
			--backpack.items = save.reverseItemConcat(save.data[7])
			save.reverseItemConcat(save.data[7])
		elseif step == 18 then
			map:load(save.reverseMapConcat(save.data[8]))
		elseif step == 19 then
			background = save.reverseMapConcat(save.data[9])
			print('Save version is: ' , save.data[10])
		end
		return true
	else
		print("Couldn't Find File")
		return false
	end
end

save.reverseMapConcatIndex = function(index)
	for i,v in pairs(data.itemInfo) do
		if v.index == index then
			return i
		end
	end
end

save.reverseMapConcat = function(str)
	local map = {}
	local i = 0
	while true do
		local _ = i
		i = string.find(str, ";", i+1)
		if i == nil then break end
		map[#map+1] = (string.sub(str,_+1,i-1))
	end
	local maps = {}
	for i,v in pairs(map) do
		local numDivider = string.find(v,':')
		local x = tonumber(string.sub(v,2,numDivider-1))
		local numCloser = string.find(v,']')
		local y = tonumber(string.sub(v,numDivider+1,numCloser-1))
		local value = string.sub(v,numCloser+1,#v)
		if maps[x] == nil then
			maps[x] = {}
		end
		maps[x][y] = save.reverseMapConcatIndex(value)
	end
	return maps
end

save.reverseItemConcat = function(str)
	local item = {}
	local i = 0
	while true do
		local _ = i
		i = string.find(str, ";", i+1)
		if i == nil then break end
		item[#item+1] = string.sub(str,_+1,i-1)
	end
	local items = {}
	for i,v in pairs(item) do
		local divider = string.find(v,':')
		local block = string.sub(v,1,divider-1)
		local amount = tonumber(string.sub(v,divider+1,#v))
		if block == 'nil' then
			block = nil
		end
		items[i] = {amount = amount,block = block}
	end
	for i,v in pairs(items) do
		backpack.items[i] = v
	end
	--return items
end

save.reverseHotBarConcat = function(str)
	print('String argument for reverseHotBarConcat is: ' .. str)
	local item = {}
	local i = 0
	while true do
		local _ = i
		i = string.find(str, ";", i+1)
		if i == nil then break end
		item[#item+1] = string.sub(str,_+1,i-1)
	end
	local items = {}
	for i,v in pairs(item) do
		local divider = string.find(v,':')
		local block = string.sub(v,1,divider-1)
		local amount = tonumber(string.sub(v,divider+1,#v))
		if block == 'nil' then
			block = nil
		end
		items[i] = {amount = amount,block = block}
	end
	for i,v in pairs(items) do
		backpack.hotBar[i] = v
	end
	--return items
end


--[[save.reverseBuildingConcat = function(str)
	local building = {}
	local i = 0
	while true do
		local _ = i
		i = string.find(str, ";", i+1)
		if i == nil then break end
		building[#building+1] = string.sub(str,_+1,i-1)
	end
	local buildings = {}
	for i,v in pairs(building) do
		local first = string.find(v,':')
		local name = string.sub(v,1,first-1)
		local start = string.sub(v,first+1,#v)
		buildings[i] = {building = name,start = start,buildTime = data.buildings[save.getIndexFromValue(name,data.buildings)].time}
	end
	return buildings
end]]

save.getIndexFromValue = function(value,tab)
	for i,v in pairs(tab) do
		if v.name == value then
			return i
		end
	end
end

save.reverseCamera = function(str)
	local first = string.find(str,';')
	local x = tonumber(string.sub(str,1,first-1))
	local y = tonumber(string.sub(str,first+1,#str))
	return Vector2.new(x,y)
end

save.reverseToolConcat = function(str)
	local tool = {}
	local i = 0
	while true do
		local _ = i
		i = string.find(str, ";", i+1)
		if i == nil then break end
		tool[#tool+1] = string.sub(str,_+1,i-1)
	end
	local tools = {}
	for i,v in pairs(tool) do
		local split = string.find(v,':')
		tools[i] = data.tools[tonumber(string.sub(v,1,split-1))]
		tools[i].toolLevel = tonumber(string.sub(v,split+1,#v))
	end
	return tools
end

function save.itemsConcat()
	local str = ''
	for i,v in pairs(backpack.items) do
		str = str .. tostring(v.block) .. ':' .. v.amount .. ';'
	end
	return str
end

function save.hotBarConcat()
	local str = ''
	for i,v in pairs(backpack.hotBar) do
		str = str .. tostring(v.block) .. ':' .. v.amount .. ';'
	end
	return str
end

function save.mapConcat()
	local map = map:getMap()
	local str = ''
	for xIndex,xValue in pairs(map) do
		for yIndex,value in pairs(xValue) do
			str = str .. '[' .. xIndex .. ':' .. yIndex .. ']' .. data.itemInfo[value].index .. ';'
		end
	end
	return str
end

function save.backgroundConcat()
	local background = map:getBackground()
	local str = ''
	for xIndex,xValue in pairs(background) do
		for yIndex,value in pairs(xValue) do
			--print(xIndex,yIndex,value)
			str = str .. '[' .. xIndex .. ':' .. yIndex .. ']' .. data.itemInfo[value].index .. ';'
		end
	end
	return str
end

function save.saveFile()
	local data = {}
	data[1] = stats.blockBroken
	data[2] = stats.money
	--compile everything from 8
	print('Saving Camera position: ' .. tostring(Camera))
	data[3] = Camera.X .. ';' .. Camera.Y
	data[4] = os.time()
	data[5] = ''--save.buildingConcat()
	data[6] = save.hotBarConcat()
	data[7] = save.itemsConcat()
	data[8] = save.mapConcat()
	data[9] = save.backgroundConcat()
	data[10] = VERSION
	local file,error = love.filesystem.newFile('save','w')
	if file then
		for i,v in pairs(data) do
			if i < 6 then -- encode files with an index less than 6
				v = save.encode(tostring(v))
			end
			file:write(v .. '\r\n')
		end
	end
end

save.getCharacter = function(char)
	for i,v in pairs(save.pack) do
		if char == v then
			return i
		end
	end
	print('Couldnt find character: ' .. char)
	return 0
end

save.encode = function(str)
	local length = #str
	local encodedString = ''
	for i = 1,length do
		local char = string.sub(str,i,i)
		local pos = save.getCharacter(char) ~= 0 and save.getCharacter(char) or save.getCharacter(' ')
		encodedString = encodedString .. save.pack[(pos+i-1)%(#save.pack)+1]
	end
	return encodedString
end

save.decode = function(str)
	local length = #str
	local decodedString = ''
	for i = 1,length do
		local char = string.sub(str,i,i)
		local pos = save.getCharacter(char)
		pos = pos-i
		while pos<=0 do
			pos = pos + #save.pack
		end
		decodedString = decodedString..save.pack[pos]
	end
	--print(decodeString)
	return decodedString
end

save.pack = {
	'1',
	'q',
	'a',
	'z',
	'2',
	'w',
	's',
	'x',
	'3',
	'e',
	'd',
	'c',
	'p',
	';',
	'/',
	'4',
	'r',
	'f',
	'v',
	'5',
	't',
	'g',
	'b',
	'6',
	'y',
	'h',
	'n',
	'7',
	'u',
	'j',
	'm',
	'8',
	'i',
	'k',
	',',
	'9',
	'o',
	'l',
	'.',
	' ',
	'!',
	'Q',
	'A',
	'Z',
	'@',
	'W',
	'S',
	'X',
	'#',
	'E',
	'D',
	'C',
	'$',
	'R',
	'F',
	'V',
	'%',
	'T',
	'G',
	'B',
	'^',
	'Y',
	'H',
	'N',
	'&',
	'U',
	'J',
	'M',
	'*',
	'I',
	'K',
	'<',
	'(',
	'O',
	'L',
	'>',
	')',
	'P',
	':',
	'?',
	'-',
	'_',
	'=',
	'+',
	'[',
	'{',
	']',
	'}',
	'\\',
	'|',
	'`',
	'0',
	'~'
}