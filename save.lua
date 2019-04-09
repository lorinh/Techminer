----------------
---saves and loads save file
----------------
--Object
----------------

save = {}

function save.init()
	save.initialized = true
	--json = json()

	save.file = nil
	save.i = 1
	save.list = {}
end

save.loadFile = function(step,name)
	if step == 1 then
		if not save.file then
			save.file = love.filesystem.read('Saves/' .. name)
		end
		local file = save.file
		if not file then
			return false
		end
		local file = 'asdfa' .. file
		while true do
			local start = save.i
			save.i = string.find(file,'(~*$^',start+4,true)
			if save.i == start or save.i == nil then break end
			save.list[#save.list+1] = string.sub(file,start+5,save.i-1)
		end
		for i,v in pairs(save.list) do
			local value = json:decode(v)
			local ex = loadstring(value.ex)
			local data = value.data
			ex(data)
		end
	end
	return true
end

function save.getData()
	--table containing all data needed to save, and a function to execute one
	local data = 
	{
		{ex = string.dump(function(x) stats.blockBroken = x    end), data = stats.blockBroken},
		{ex = string.dump(function(x) Camera.X = x             end), data = Camera.X},
		{ex = string.dump(function(x) Camera.Y = x             end), data = Camera.Y},
		{ex = string.dump(function(x) backpack.hotBar = x      end), data = backpack.hotBar},
		{ex = string.dump(function(x) backpack.items = x       end), data = backpack.items},
		{ex = string.dump(function(x) map:load(x)              end), data = map:getIndexMap()},
		{ex = string.dump(function(x) map:loadBackground(x)    end), data = map:getIndexBackground()},
		{ex = string.dump(function(x) --[[Do nothing]]         end), data = VERSION},
		{ex = string.dump(function(x) interface.loadAllData(x) end), data = interface.getAllData()}
	}
	return data
end

function save.saveFile(name,data)
	local data = save.getData()
	local file,error = love.filesystem.newFile('Saves/' .. name,'w')
	for i,v in pairs(data) do
		print(i)
		file:write(json:encode(v) .. '(~*$^')
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