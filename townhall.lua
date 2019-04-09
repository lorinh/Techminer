----------------
---townhall DEPRECIATED
----------------
--drawing and selling
----------------

townhall = {}
townhall.buttons = {}

function townhall.init()
	townhall.showMenu = false
	townhall.mode = 'Selling'
	townhall.buttons.list = {}
	townhall.lastFound = Vector2.new(0,0)
end
	

function townhall.getTownHall()
	townhall.lastFound = blockIndexing.getBlock('TownHall')[1]
	if townhall.lastFound then
		return townhall.lastFound*50+Vector2.new(50,425)
	end
	return nil
end

function townhall.getTownHallPositions()
	townhall.townhalls = {unpack(blockIndexing.getBlock('TownHall'))}
	for i,v in pairs(townhall.townhalls) do
		townhall.townhalls[i] = v*50+Vector2.new(50,425)
	end
	return townhall.townhalls
end

function townhall.keyPressed(key)
	for i,v in pairs(townhall.getTownHallPositions()) do
		if magnitude((Camera*-1+Vector2.new(screenSize.X/2,375))-v) < 200 then
			local key = key:lower()
			if key == keyBindings.q then
				--townhall.showMenu = not townhall.showMenu
				currentMode = 'assemble'
				assemble.init()
			end
		end
		if key == 'escape' then
			townhall.showMenu = false
		end
	end
end

function townhall.buttons.addButton(pos,size,identifier)
	townhall.buttons.list[#townhall.buttons.list+1] = {position = pos,size = size,id = identifier}
end

function townhall.buttons.resetButtons()
	townhall.buttons.list = {}
end

function townhall.buttons.removeButton(id)
	for i,v in pairs(townhall.buttons.list) do
		if v.id == id then
			table.remove(townhall.buttons.list,i)
		end
	end
end

function townhall.buttons.checkButtons(mouse)
	for i,v in pairs(townhall.buttons.list) do
		if mouse.X >= v.position.X and mouse.X <= v.position.X+v.size.X then
			if mouse.Y >= v.position.Y and mouse.Y <= v.position.Y+v.size.Y then
				return v.id
			end
		end
	end
end


function townhall.run()
	--love.graphics.setColor(255,255,255)
	--love.graphics.draw(images.TownHall,600+Camera.X,150+Camera.Y,nil,1.5,1.5)
	--print('Townhall at:',townhall.getTownHall(),'Camera at:',(Camera*-1+Vector2.new(screenSize.X/2,375)))
	love.graphics.setColor(255,255,255)
	for i,v in pairs(townhall.getTownHallPositions()) do
		if magnitude((Camera*-1+Vector2.new(screenSize.X/2,375))-v) < 200 then
			love.graphics.print('Press ' .. keyBindings.q .. ' to access the TownHall',screenSize.X/2-100,screenSize.Y-200)
		elseif townhall.showMenu then
			townhall.showMenu = false
		end
	end
end

function townhall.getBuildings()
	list = {}
	for i,v in pairs(data.buildings) do
		if not buildings.checkBuilding(v.name) then
			v.index = i
			list[#list+1] = v
		end
	end
	return list
end

function townhall.draw()
	if townhall.showMenu then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(images.TownHallMenu,screenSize.X/2-400,60)
		--love.graphics.setFont(defaultFont)
		love.graphics.print('Mode: ' .. townhall.mode,screenSize.X/2-80,200)
		townhall.buttons.resetButtons()
		townhall.buttons.addButton(Vector2.new(screenSize.X/2-80,200),Vector2.new(130,23),{mode = 'changeMode'})
		if townhall.mode == 'Selling' then
			for i,v in pairs(backpack.items) do
				love.graphics.print(v.block,screenSize.X/2-400+10,200+i*25)
				love.graphics.print(v.amount,screenSize.X/2-400+100,200+i*25)
				love.graphics.print('Value: ' .. data.itemInfo[v.block].value,screenSize.X/2-400+200,200+i*25)
				love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2+400-10,200+i*25+20)
				love.graphics.print('Sell 1',screenSize.X/2-400+600,200+i*25)
				love.graphics.print('Sell All',screenSize.X/2-400+700,200+i*25)
				--id format = {index = i,mode = sellall/sell1}
				townhall.buttons.addButton(Vector2.new(screenSize.X/2-400+600,200+i*25),Vector2.new(50,23),{index = i,mode = 'single'})
				townhall.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{index = i, mode = 'all'})
			end
		elseif townhall.mode == 'Buying' then
			for i,v in pairs(townhall.getBuildings()) do
				love.graphics.print(v.name,screenSize.X/2-400+10,200+i*25)
				love.graphics.print('Cost: ' .. v.cost,screenSize.X/2-400+200,200+i*25)
				love.graphics.line(screenSize.X/2-400+10,200+i*25+20,screenSize.X/2-400+790,200+i*25+20)
				love.graphics.print('Buy',screenSize.X/2-400+700,200+i*25)
				townhall.buttons.addButton(Vector2.new(screenSize.X/2-400+700,200+i*25),Vector2.new(50,23),{index = v.index, mode = 'buy'})
			end
		end
	end
end

function townhall.mouseButton(pos)
	if townhall.showMenu then
		local id = townhall.buttons.checkButtons(pos)
		if id then
			if id.mode == 'single' then
				backpack.items[id.index].amount = backpack.items[id.index].amount-1
				stats.addMoney(data.itemInfo[backpack.items[id.index].block].value)
				userEvent.addEvent('Selling one of ' .. backpack.items[id.index].block)
				if backpack.items[id.index].amount <= 0 then
					table.remove(backpack.items,id.index)
					--townhall.buttons.removeButton(id)
				end
			elseif id.mode == 'all' then
				stats.addMoney(data.itemInfo[backpack.items[id.index].block].value*backpack.items[id.index].amount)
				userEvent.addEvent('Selling all of ' .. backpack.items[id.index].block)
				table.remove(backpack.items,id.index)
				--townhall.buttons.removeButton(id)
			elseif id.mode == 'changeMode' then
				townhall.buttons.resetButtons()
				if townhall.mode == 'Selling' then
					townhall.mode = 'Buying'
				else
					townhall.mode = 'Selling'
				end
			elseif id.mode == 'buy' then
				if stats.money >= data.buildings[id.index].cost then
					stats.money = stats.money-data.buildings[id.index].cost
					--buildings.addBuilding(data.buildings[id.index].name,data.buildings[id.index].time)
					backpack.addItem(data.buildings[id.index].name)
					userEvent.addEvent(data.buildings[id.index].name .. ' bought!')
					--data.buildings[id.index] = nil
				else
					userEvent.addEvent('Not enough money!')
				end
			end
		end
	end
end
