----------------
---config
--brings up the ingame option menu
----------------


config = {}
config.buttons = {}

function config.init()
	config.showMenu = false
	config.buttonsAdded = false
	config.changeButton = false
	config.currentBinding = nil
	config.exit = false
	config.exitNow = false

	config.buttons.list = {}
end

function config.draw()
	love.graphics.draw(images.Gear,screenSize.X-30,5,nil,.5,.5)
	if config.showMenu then
		love.graphics.draw(images.SettingsMenu,screenSize.X/2-200,100,nil,1,1)
		
		--love.graphics.print('Reset Save',screenSize.X/2-180,204)
		
		love.graphics.print('Key bindings:',screenSize.X/2-180,230)
		local index = 0
		for i,v in pairs(keyBindings) do
			index = index + 1
			if i == config.currentBinding then
				love.graphics.print(i .. ': ' .. 'Press key',screenSize.X/2-150,223+(index*23))
			else
				love.graphics.print(i .. ': ' .. v,screenSize.X/2-150,223+(index*23))
			end
		end
		
		love.graphics.print('Exit to menu',screenSize.X/2-100,750,0,1.5,1.5)
		
		if not config.buttonsAdded then
			--config.buttons.addButton(Vector2.new(screenSize.X/2-180,200),Vector2.new(120,23),'reset')
			local index = 0
			for i,v in pairs(keyBindings) do
				index = index + 1
				love.graphics.print(i .. ': ' .. v,screenSize.X/2-150,223+(index*23))
				config.buttons.addButton(Vector2.new(screenSize.X/2-150,223+(index*23)),Vector2.new(50,23),{id = 'keyBinding',value = i})
			end
			config.buttons.addButton(Vector2.new(screenSize.X/2-100,750),Vector2.new(100,50),'exit')
			config.buttonsAdded = true
		end
	else
		config.buttonsAdded = false
	end
	if config.exit then
		love.graphics.setColor(0,0,0,127)
		love.graphics.rectangle('fill',0,0,screenSize.X,screenSize.Y)
		love.graphics.setColor(255,255,255)
		love.graphics.print('Saving game...',screenSize.X/2-100,350,0,2,2)
		love.graphics.present()
	end
	if config.exitNow then
		save.saveFile(menu.saveName)
		love.load()
		currentMode = 'menu'
		--love.event.quit()
	end
end

function config.keyPressed(key)
	if config.changeButton then
		keyBindings[config.currentBinding] = key
		config.currentBinding = nil
		config.changeButton = false
	end
	if key == 'escape' then
		if backpack.show == false then
			config.showMenu = not config.showMenu
		end
	end
end

function config.mouseButton(pos)
	if pos.X >= screenSize.X-30 and pos.X <= screenSize.X-5 then
		if pos.Y >= 5 and pos.Y <= 30 then
			config.showMenu = not config.showMenu
		end
	end
	if config.showMenu then
		local id = config.buttons.checkButtons(pos)
		if id then
			if id == 'reset' then
				save.ereaseSave()
				love.load()
				currentMode = 'loading'
			elseif id == 'exit' then
				--love.event.quit() 
				config.exit = true
				config.draw()
				config.exitNow = true
				--currentMode = 'menu'
				--save.saveFile()
			elseif type(id) == 'table' then
				if id.id == 'keyBinding' then
					config.changeButton = true
					config.currentBinding = id.value
				end
			end
		end
	end
end

function config.buttons.addButton(pos,size,identifier)
	config.buttons.list[#config.buttons.list+1] = {position = pos,size = size,id = identifier}
end

function config.buttons.resetButtons()
	config.buttons.list = {}
end

function config.buttons.removeButton(id)
	for i,v in pairs(config.buttons.list) do
		if v.id == id then
			table.remove(config.buttons.list,i)
		end
	end
end

function config.buttons.checkButtons(mouse)
	for i,v in pairs(config.buttons.list) do
		if mouse.X >= v.position.X and mouse.X <= v.position.X+v.size.X then
			if mouse.Y >= v.position.Y and mouse.Y <= v.position.Y+v.size.Y then
				return v.id
			end
		end
	end
end
