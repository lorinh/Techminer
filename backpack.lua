---------------
--backpack
---------------
--Allows items to be positioned in the 9x3 grid when the player presses e

backpack = {}
backpack.buttons = {}

function backpack.init()
	backpack.UISIZE = Vector2.new(.75,.75)
	backpack.UIOFFSET = Vector2.new(screenSize.X/2-((backpack.UISIZE.X*108*10)/2),screenSize.Y/2-100)

	backpack.items = {}
	backpack.hotBar = {}
	backpack.show = false
	backpack.selectedId = 1
	backpack.mode = 'mine'

	backpack.mouse = {block = nil,amount = 0}

	--{block = str,amount = int}
	backpack.createBackpack()
	backpack.items[1] = {block = 'LogFire',amount = 100,durability = 0}
	backpack.items[2] = {block = 'Leaves',amount = 3000,durability = 0}
	backpack.items[3] = {block = 'Wood',amount = 3000,durability = 0}
	backpack.items[4] = {block = 'StoneStove',amount = 3,durability = 0}
	backpack.buttons.list = {}

	backpack.interface = {}

	backpack.interfaceItem = {}

	backpack.certificate = 0

	backpack.offset = 0

	backpack.lastPosition = Vector2.new(0,0)
	backpack.lastTime = 0
end

function backpack:getTool()
	backpack.updateMode()
	local tool = backpack.hotBar[backpack.selectedId].block
	if tool == nil then
		tool = 'Hand'
	end
	return tool
end

function backpack:removeDurability()
	local tool = backpack.hotBar[backpack.selectedId].block
	if tool ~= nil then
		backpack.hotBar[backpack.selectedId].durability = backpack.hotBar[backpack.selectedId].durability - 1
		if backpack.hotBar[backpack.selectedId].durability <= 0 then
			backpack.hotBar[backpack.selectedId] = {block = nil,amount = 0,durability = 0}
		end
	end
end

function backpack.addInterface(info,item)--{position = Vector2,name = string,filter = function}
	backpack.interface[#backpack.interface+1] = info
	backpack.interfaceItem[info.name] = item
	backpack.certificate = love.timer.getTime()
	print('Generated certificate is: ' .. backpack.certificate)
	return backpack.certificate
end

function backpack.drawInterface()
	local size = backpack.UISIZE
	for i,v in pairs(backpack.interface) do
		love.graphics.draw(images.backpackBox,v.position.X,v.position.Y,nil,size.X*2,size.Y*2)
		if backpack.interfaceItem[v.name].block ~= nil then
			love.graphics.draw(images[backpack.interfaceItem[v.name].block],v.position.X+3,v.position.Y+3,nil,size.X*.96,size.Y*.96)
			love.graphics.printf(backpack.interfaceItem[v.name].amount,v.position.X,v.position.Y+55,backpack.UISIZE.X*.96*100,'right')
		end
		backpack.buttons.addButton(Vector2.new(v.position.X+3,v.position.Y+3),Vector2.new(backpack.UISIZE.X*.96*100,backpack.UISIZE.Y*.96*100),{part = 'interface',index = v.name,dataIndex = i})
		-- Draw boxes with items in them here, along with hit events
	end
end

function backpack.getInterfaceData(name)
	return backpack.interfaceItem[name]
end

function backpack.setInterfaceData(name,info)
	if info.amount <= 0 then
		info.block = nil
	end
	backpack.interfaceItem[name] = info
end

function backpack.createBackpack()
	for i = 1,30 do
		backpack.items[i] = {block = nil,amount = 0,durability = 0}
	end
	for i = 1,10 do
		backpack.hotBar[i] = {block = nil, amount = 0,durability = 0}
	end
end

function backpack.updateMode()
	local info = data.itemInfo[backpack.hotBar[backpack.selectedId].block] or nil
	if info and info.type == 'block' then
		backpack.mode = 'build'
	elseif not info or info.type == 'tool' then
		backpack.mode = 'mine'
	end
end

function backpack.keyPressed(key)
	local key = string.lower(key)
	if key == keyBindings.e then
		if backpack.show == false then
			backpack.offset = 0
		elseif interface.current then
			interface.current = nil
			backpack.interface = {}
			backpack.interfaceItem = {}
			backpack.certificate = 0
			print('Reseting interfaces')
		end
		backpack.show = not backpack.show
	elseif key == 'escape' then
		backpack.show = false
		interface.current = nil
		backpack.interface = {}
		backpack.interfaceItem = {}
		backpack.certificate = 0
	elseif tonumber(key) and tonumber(key) > 0 and tonumber(key) <= 9 then
		backpack.selectedId = tonumber(key)
		backpack.updateMode()
	elseif key == '0' then
		backpack.selectedId = 10
		backpack.updateMode()
	end
end

function backpack.removeItem(item)
	local found = false
	for index,block in pairs(backpack.items) do
		if block.block == item and found == false then
			found = true
			block.amount = block.amount-1
			if block.amount == 0 then
				block.block = nil
			end
		end
	end
end

function backpack.addItemFirstIndex(item)
	local found = false
	for i,v in pairs(backpack.items) do
		if v.block == nil and found == false then
			found = true
			v.block = item
			v.amount = 1
			if data.itemInfo[v.block].durability then
				v.durability = data.itemInfo[v.block].durability
			end
		end
	end
	return found
end

function backpack.addItem(item)
	local found = false
	for index,block in pairs(backpack.items) do
		if block.block == item and found == false and block.durability == 0 then
			block.amount = block.amount+1
			found = true
		end
	end
	if found == false then
		found = backpack.addItemFirstIndex(item)
	end
	if not found then
		print('Unable to add item to inventory')
	end
end

function backpack.mouseButtonRight(mouse)
	local id = backpack.buttons.checkButtons(mouse)
	if id then
		if id.part == 'backpack' then
			if backpack.mouse.block == nil then
				backpack.mouse.block = backpack.items[id.index].block
				backpack.mouse.amount = math.floor(backpack.items[id.index].amount/2)
				if backpack.mouse.amount > 0 then
					backpack.items[id.index].amount = backpack.items[id.index].amount-backpack.mouse.amount
				else
					backpack.mouse = {amount = 0,block = nil}
				end
			elseif backpack.items[id.index].block == nil then
				if backpack.mouse.amount > 0 then
					backpack.items[id.index].block = backpack.mouse.block
					backpack.items[id.index].amount = 1
					backpack.mouse.amount = backpack.mouse.amount-1
					if backpack.mouse.amount == 0  then
						backpack.mouse.block = nil
					end
				end
			else
				--do nothing for now
			end
		elseif id.part == 'hotBar' then
			if backpack.show == true then
				if backpack.mouse.block == nil then
					backpack.mouse.block = backpack.hotBar[id.index].block
					backpack.mouse.amount = math.floor(backpack.hotBar[id.index].amount/2)
					if backpack.mouse.amount > 0 then
						backpack.hotBar[id.index].amount = backpack.hotBar[id.index].amount-backpack.mouse.amount
					else
						backpack.mouse = {amount = 0,block = nil}
					end
				elseif backpack.hotBar[id.index].block == nil then
					if backpack.mouse.amount > 0 then
						backpack.hotBar[id.index].block = backpack.mouse.block
						backpack.hotBar[id.index].amount = 1
						backpack.mouse.amount = bacpkac.mouse.amount - 1
						if backpack.mouse.amount == 0  then
							backpack.mouse.block = nil
						end
					end
				else
					--do nothing for now
				end
			else
				backpack.selectedId = id.index
			end
			backpack.updateMode()
		elseif id.part == 'interface' then
			if backpack.mouse.block == nil then
				backpack.mouse.block = backpack.interfaceItem[id.index].block
				backpack.mouse.amount = math.floor(backpack.interfaceItem[id.index].amount/2)
				if backpack.mouse.amount > 0 then
					backpack.interfaceItem[id.index].amount = backpack.interfaceItem[id.index].amount-backpack.mouse.amount
				else
					backpack.mouse = {amount = 0,block = nil}
				end
			elseif backpack.interfaceItem[id.index].block == nil then
				local interfaceData = backpack.interface[id.dataIndex]
				if interfaceData.filter(backpack.mouse.block) then
					if backpack.mouse.amount > 0 then
						backpack.interfaceItem[id.index].block = backpack.mouse.block
						backpack.interfaceItem.amount = 1
						backpack.mouse.amount = backpack.mouse.amount - 1
						if backpack.mouse.amount == 0  then
							backpack.mouse.block = nil
						end
					end
				end
			else
				--do nothing for now
			end
		end
	end
	print('End of function mouse has:',backpack.mouse.amount)
end

function backpack.mouseButton(mouse)
	local id = backpack.buttons.checkButtons(mouse)
	if id then
		if id.part == 'backpack' then
			if backpack.mouse.block == nil then
				backpack.mouse = backpack.items[id.index]
				backpack.items[id.index] = {block = nil,amount = 0,durability = 0}
			elseif backpack.items[id.index].block == nil then
				backpack.items[id.index] = backpack.mouse
				backpack.mouse = {block =  nil,amount = 0,durability = 0}
			else
				if backpack.mouse.block == backpack.items[id.index].block then
					backpack.items[id.index].amount = backpack.items[id.index].amount + backpack.mouse.amount
					backpack.mouse = {block = nil,amount = 0,durability = 0}
				else
					local store = backpack.items[id.index]
					backpack.items[id.index] = backpack.mouse
					backpack.mouse = store
				end
			end
		elseif id.part == 'hotBar' then
			if backpack.show == true then
				if backpack.mouse.block == nil then
					backpack.mouse = backpack.hotBar[id.index]
					backpack.hotBar[id.index] = {block = nil,amount = 0,durability = 0}
				elseif backpack.hotBar[id.index].block == nil then
					backpack.hotBar[id.index] = backpack.mouse
					backpack.mouse = {block =  nil,amount = 0,durability = 0}
				else
					if backpack.mouse.block == backpack.hotBar[id.index].block then
						backpack.hotBar[id.index].amount = backpack.hotBar[id.index].amount + backpack.mouse.amount
						backpack.mouse = {block = nil,amount = 0,durability = 0}
					else
						local store = backpack.hotBar[id.index]
						backpack.hotBar[id.index] = backpack.mouse
						backpack.mouse = store
					end
				end
			else
				backpack.selectedId = id.index
			end
			backpack.updateMode()
		elseif id.part == 'interface' then
			if backpack.mouse.block == nil then
				backpack.mouse = backpack.interfaceItem[id.index]
				backpack.interfaceItem[id.index] = {block = nil,amount = 0,durability = 0}
			elseif backpack.interfaceItem[id.index].block == nil then
				local interfaceData = backpack.interface[id.dataIndex]
				if interfaceData.filter(backpack.mouse.block) then
					backpack.interfaceItem[id.index] = backpack.mouse
					backpack.mouse = {block =  nil,amount = 0,durability = 0}
				end
			else
				if backpack.mouse.block == backpack.interfaceItem[id.index].block then
					backpack.interfaceItem[id.index].amount = backpack.interfaceItem[id.index].amount + backpack.mouse.amount
					backpack.mouse = {block = nil,amount = 0,durability = 0}
				else
					local interfaceData = backpack.interface[id.dataIndex]
					if interfaceData.filter(backpack.mouse.block) then
						local store = backpack.interfaceItem[id.index]
						backpack.interfaceItem[id.index] = backpack.mouse
						backpack.mouse = store
					end
				end
			end
		end
	end

end

function backpack.mouseReleased(mouse)
end

function backpack.draw()
	backpack.buttons.resetButtons()
	for x = 0,9 do
		if backpack.selectedId == x+1 then
			love.graphics.draw(images.hotBarBox,screenSize.X/2-272+(54*x),screenSize.Y-67,0,1,1)
		end
		love.graphics.setColor(255,255,255,25)
		love.graphics.rectangle('fill',screenSize.X/2-270+(54*x),screenSize.Y-65,50,50)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.backpackBox,screenSize.X/2-270+(54*x),screenSize.Y-65,0,1,1)
		if backpack.hotBar[x+1].block ~= nil then
			local size = data.itemInfo[backpack.hotBar[x+1].block].size
			local subSize
			if size then
				local scale = data.itemInfo[backpack.hotBar[x+1].block].scale
				subSize = size/scale*2
			else
				subSize = Vector2.new(2,2)
			end
			local subSize = math.max(subSize.X,subSize.Y)/2
			love.graphics.draw(images[backpack.hotBar[x+1].block],screenSize.X/2-267+(54*x),screenSize.Y-65+3,0,.46/subSize,.46/subSize)
			if data.itemInfo[backpack.hotBar[x+1].block].durability then
				love.graphics.setColor(100,100,100,127)
				love.graphics.rectangle('fill',screenSize.X/2-267+(54*x-54)+46+10,screenSize.Y-65+3+26+15,42,4)
				love.graphics.setColor(255,255,255)
				love.graphics.rectangle('fill',screenSize.X/2-267+(54*x-54)+46+10,screenSize.Y-65+3+26+15,backpack.hotBar[x+1].durability/data.itemInfo[backpack.hotBar[x+1].block].durability*42,4)
			else
				love.graphics.printf(backpack.hotBar[x+1].amount,screenSize.X/2-267+(54*x)+46,screenSize.Y-65+3+26,0,'right')
			end
		end
		backpack.buttons.addButton(Vector2.new(screenSize.X/2-276+(54*x),screenSize.Y-65+4,0),Vector2.new(.46*100,.46*100),{part = 'hotBar',index = x+1})
	end

	if backpack.show then
		love.graphics.setColor(25,25,25,210)
		love.graphics.rectangle('fill',backpack.UIOFFSET.X-6+backpack.offset,backpack.UIOFFSET.Y-6,backpack.UISIZE.X*108*10+12,backpack.UISIZE.Y*108*3+12)
		--love.graphics.draw(images.backpackBackground,screenSize.X/2-490,screenSize.Y/2-308)
		for x = 0,9 do
			for y = 0,2 do
				local size = backpack.UISIZE
				love.graphics.setColor(255,255,255)
				love.graphics.draw(images.backpackBox,backpack.UIOFFSET.X+(size.X*108*x)+backpack.offset,backpack.UIOFFSET.Y+(size.Y*108*y),0,2*size.X,2*size.Y)
				local index = x+1+(y*10)
				if backpack.items[index].block ~= nil then
					local blockSize = data.itemInfo[backpack.items[index].block].size
					local subSize
					if blockSize then
						local scale = data.itemInfo[backpack.items[index].block].scale
						subSize = blockSize/scale*2
					else
						subSize = Vector2.new(2,2)
					end
					local subSize = math.max(subSize.X,subSize.Y)/2
					love.graphics.setColor(255,255,255)
					love.graphics.draw(images[backpack.items[index].block],backpack.UIOFFSET.X+4+(size.X*108*x)+backpack.offset,backpack.UIOFFSET.Y+4+(size.Y*108*y),0,backpack.UISIZE.X*.96/subSize,backpack.UISIZE.Y*.96/subSize)
					if data.itemInfo[backpack.items[index].block].durability then
						love.graphics.setColor(100,100,100,127)
						love.graphics.rectangle('fill',backpack.UIOFFSET.X+4+(size.X*108*x)+backpack.offset+4,backpack.UIOFFSET.Y+4+(size.Y*108*y)+65,62,4)
						love.graphics.setColor(255,255,255)
						love.graphics.rectangle('fill',backpack.UIOFFSET.X+4+(size.X*108*x)+backpack.offset+4,backpack.UIOFFSET.Y+4+(size.Y*108*y)+65,backpack.items[index].durability/data.itemInfo[backpack.items[index].block].durability*62,4)
					else
						love.graphics.printf(backpack.items[index].amount,backpack.UIOFFSET.X+4+(size.X*108*x)+backpack.offset,backpack.UIOFFSET.Y+4+(size.Y*108*(y+1))-28,backpack.UISIZE.X*.96/subSize*100,'right')
					end
				end
				backpack.buttons.addButton(Vector2.new(backpack.UIOFFSET.X+4+(size.X*108*x)+backpack.offset,backpack.UIOFFSET.Y+4+(size.Y*108*y)),Vector2.new(backpack.UISIZE.X*.96*100,backpack.UISIZE.Y*.96*100),{part = 'backpack',index = index})
				--love.graphics.draw(images.backpackBox,screenSize.X/2-490+24+(108*x),screenSize.Y/2-308+24+(108*y),0,2,2)
			end
		end
		backpack.drawInterface()
		if backpack.mouse.block ~= nil then
			local size = data.itemInfo[backpack.mouse.block].size
			local subSize
			if size then
				local scale = data.itemInfo[backpack.mouse.block].scale
				subSize = size/scale*2
			else
				subSize = Vector2.new(2,2)
			end
			local subSize = math.max(subSize.X,subSize.Y)/2
			love.graphics.draw(images[backpack.mouse.block],mouse.X,mouse.Y,0,backpack.UISIZE.X*.96/subSize,backpack.UISIZE.Y*.96/subSize)
		else
			local mag = magnitude(mouse-backpack.lastPosition)
			if mag < 5 then
				if love.timer.getTime()-backpack.lastTime > .5 then
					local id = backpack.buttons.checkButtons(mouse)
					if id then
						if id.part == 'backpack' then
							local block = backpack.items[id.index].block
							if block then 
								love.graphics.setColor(0,0,0,200)
								love.graphics.print(block,mouse.X+14,mouse.Y-2)
								love.graphics.setColor(255,255,255)
								love.graphics.print(block,mouse.X+15,mouse.Y)
							end
						elseif id.part == 'hotBar' then
							local block = backpack.hotBar[id.index].block
							if block then
								love.graphics.setColor(0,0,0,200)
								love.graphics.print(block,mouse.X+14,mouse.Y-2)
								love.graphics.setColor(255,255,255)
								love.graphics.print(block,mouse.X+15,mouse.Y)
							end
						elseif id.part == 'interface' then
							local block = backpack.interfaceItem[id.index].block
							if block then
								love.graphics.setColor(0,0,0,200)
								love.graphics.print(block,mouse.X+14,mouse.Y-2)
								love.graphics.setColor(255,255,255)
								love.graphics.print(block,mouse.X+15,mouse.Y)
							end
						end
					end
				end
			else
				backpack.lastPosition = mouse
				backpack.lastTime = love.timer.getTime()
			end
		end
	end
end

function backpack.buttons.addButton(pos,size,identifier)
	backpack.buttons.list[#backpack.buttons.list+1] = {position = pos,size = size,id = identifier}
end

function backpack.buttons.resetButtons()
	backpack.buttons.list = {}
end

function backpack.buttons.removeButton(id)
	for i,v in pairs(backpack.buttons.list) do
		if v.id == id then
			table.remove(backpack.buttons.list,i)
		end
	end
end

function backpack.buttons.checkButtons(mouse)
	for i,v in pairs(backpack.buttons.list) do
		if mouse.X >= v.position.X and mouse.X <= v.position.X+v.size.X then
			if mouse.Y >= v.position.Y and mouse.Y <= v.position.Y+v.size.Y then
				return v.id
			end
		end
	end
end
