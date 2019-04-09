--------------
--provides an interface for blocks that use the backpack and to right click the block
-------------

interface = {}

function interface.init()

	--{func = func,block = str}
	interface.interfaces = {}

	--holds data for blocks
	interface.data = {}

	interface.current = nil
end

function interface.addInterface(data)
	print('Add ' .. data.block .. ' to interfaces')
	interface.interfaces[#interface.interfaces+1] = data
	blockIndexing.addBlockIndex(data.block)
	if data.multiBlock then
		blockIndexing.addBlockIndex('_' .. data.block)
	end
end

function interface.mouseButtonRight(mouse)
	local map = map:getMap()

	for _,currentInterface in pairs(interface.interfaces) do
		local blocks = blockIndexing.getBlock(currentInterface.block)
		if currentInterface.multiBlock then
			blocks = {unpack(blocks),unpack(blockIndexing.getBlock('_' .. currentInterface.block))}
		end
		for i,v in pairs(blocks) do
			local localXPos = v.X*50+Camera.X
			local localYPos = v.Y*50+Camera.Y+450

			if mouse.X >= localXPos and mouse.X <= localXPos+50 then
				if mouse.Y >= localYPos and mouse.Y <= localYPos+50 then
					print('You have right clicked on an interface')
					backpack.offset = 150
					backpack.show = true
					if string.sub(map[v.X][v.Y],1,1) == '_' then
						v = Vector2.new(coreFunctions.getCoreOfMultiblock(v.X,v.Y))
					end
					interface.current = {interface = currentInterface,pos = v}
					local data = interface.getData(v.X,v.Y)
					data = currentInterface.setUp(data,v)
					interface.setData(v.X,v.Y,data)
				end
			end
		end
	end
end

function interface.draw()
	if interface.current then
		local data = interface.getData(interface.current.pos.X,interface.current.pos.Y)
		data = interface.current.interface.func(data,interface.current.pos)
		interface.setData(interface.current.pos.X,interface.current.pos.Y,data)
	end
end

function interface.getAllData()
	return interface.data
end

function interface.loadAllData(data)
	interface.data = data
end

function interface.getData(x,y)
	local dataName = x.. ':' .. y
	local data = interface.data[dataName]
	return data
end

function interface.setData(x,y,data)
	local dataName = x .. ':' .. y
	interface.data[dataName] = data
end


