----------------
---main menu for techminer
----------------
menu = {}

menu.mode = 'main'
menu.levelSelected = nil
menu.saveList = nil
menu.reverseHookUp = nil

menu.memory = nil -- save name of save for renaming

menu.saveName = nil

menu.images = {}
menu.images.singlePlayer = love.graphics.newImage('Images/Singleplayer.png')
menu.images.exit = love.graphics.newImage('Images/Exit.png')
menu.images.play = love.graphics.newImage('Images/Play.png')
menu.images.createWorld = love.graphics.newImage('Images/CreateWorld.png')
menu.images.rename = love.graphics.newImage('Images/Rename.png')
menu.images.delete = love.graphics.newImage('Images/Delete.png')
menu.images.backArrow = love.graphics.newImage('Images/BackArrow.png')

menu.largeFont = love.graphics.newFont("TimesNewRoman.ttf", 30)

function menu.loadModules()
	map:reset()
	coreFunctions.init()
	animate.init()
	physics.init()
	characterMovement.init()
	backpack.init()
	townhall.init()
	stats.init()
	sky.init()
	--buildings.init()
	config.init()
	--hotbar.init()
	chunk.init()
	terrain.init()
	blockIndexing.init()
	assemble.init()
	save.init()
	interface.init()
	blockAnimation.init()
	smelting.init()
	flash.init()
	--chat.init()
end

function menu.buttonSinglePlayer()
	buttons.removeButton('singlePlayer')
	buttons.removeButton('exit')
	menu.mode = 'levelChooser'
	--[[menu.loadModules()
	currentMode = 'loading'
	buttons.removeButton('singlePlayer')
	buttons.removeButton('exit')]]
end

function menu.buttonExit()
	save.initialized = false
	love.event.quit()
	buttons.removeButton('singlePlayer')
	buttons.removeButton('exit')
end

function menu.buttonLevel(id)
	if menu.levelSelected then
		buttons.changeImage(menu.levelSelected,menu.saveList[menu.levelSelected].button)
	end
	menu.levelSelected = id
	buttons.changeImage(id,menu.saveList[id].selected)
	buttons.activeButton('play',nil)
	buttons.activeButton('rename',nil)
	buttons.activeButton('delete',nil)
end

function menu.buttonCreateWorld()
	buttons.removeButton('createWorld')
	buttons.removeButton('play')
	buttons.removeButton('rename')
	buttons.removeButton('delete')
	buttons.removeButton('backArrow')
	menu.removeLevelList()
	menu.mode = 'createWorld'
end

function menu.buttonCreateWorld2()
	buttons.removeButton('createWorld')
	buttons.removeButton('backArrow')
	menu.saveName = textBox.getText('name')
	textBox.removeTextBox('name')
	menu.loadModules()
	currentMode = 'loading'
	menu.mode = 'main'
	menu.saveList = {}
	menu.levelSelected = nil
end

function menu.buttonPlay()
	menu.saveName = menu.reverseHookUp[menu.levelSelected]
	buttons.removeButton('createWorld')
	buttons.removeButton('play')
	buttons.removeButton('rename')
	buttons.removeButton('delete')
	buttons.removeButton('backArrow')
	menu.removeLevelList()
	menu.loadModules()
	currentMode = 'loading'
	menu.mode = 'main'
	menu.saveList = nil
	menu.levelSelected = nil
end

function menu.buttonRename()
	buttons.removeButton('createWorld')
	buttons.removeButton('play')
	buttons.removeButton('rename')
	buttons.removeButton('delete')
	buttons.removeButton('backArrow')
	menu.memory = menu.reverseHookUp[menu.levelSelected]
	menu.removeLevelList()
	menu.saveList = nil
	menu.mode = 'rename'
end

function menu.buttonRename2()
	buttons.removeButton('rename')
	buttons.removeButton('backArrow')
	local name = textBox.getText('name')
	textBox.removeTextBox('name')
	menu.mode = 'levelChooser'
	menu.saveList = nil
	menu.levelSelected = nil
	local oldFile = love.filesystem.newFile('Saves/'..menu.memory,'r')
	local oldFileData = oldFile:read()
	oldFile:close()
	local newFile = love.filesystem.newFile('Saves/'..name,'w')
	newFile:write(oldFileData)
	newFile:close()
	love.filesystem.remove('Saves/'..menu.memory)
end

function menu.buttonDelete()
	love.filesystem.remove('Saves/'..menu.reverseHookUp[menu.levelSelected])
	buttons.removeButton('createWorld')
	buttons.removeButton('play')
	buttons.removeButton('rename')
	buttons.removeButton('delete')
	buttons.removeButton('backArrow')
	menu.removeLevelList()
	menu.saveList = {}
	menu.levelSelected = nil
end

function menu.buttonBackArrow()
	buttons.removeButton('createWorld')
	buttons.removeButton('play')
	buttons.removeButton('rename')
	buttons.removeButton('delete')
	buttons.removeButton('backArrow')
	menu.removeLevelList()
	menu.saveList = nil
	menu.levelSelected = nil
	menu.mode = 'main'
end

function menu.buttonBackArrow2()
	buttons.removeButton('createWorld')
	buttons.removeButton('backArrow')
	textBox.removeTextBox('name')
	menu.mode = 'levelChooser'
	menu.saveList = nil
	menu.levelSelected = nil
end

function menu.buttonBackArrow3()
	buttons.removeButton('rename')
	buttons.removeButton('backArrow')
	textBox.removeTextBox('name')
	menu.mode = 'levelChooser'
	menu.saveList = nil
	menu.levelSelected = nil
end

function menu.removeLevelList()
	for i,v in pairs(menu.saveList) do
		buttons.removeButton(i)
	end
end

function menu.mainMenu()
	if buttons.checkForButton('singlePlayer') == false then
		
		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2-150,300),
			size = Vector2.new(300,50),
			zIndex = 1,
			image = menu.images.singlePlayer,
			clicked = menu.buttonSinglePlayer},
			'singlePlayer')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2-150,400),
			size = Vector2.new(300,50),
			zIndex = 1,
			image = menu.images.exit,
			clicked = menu.buttonExit},
			'exit')
	end
end


function menu.levelListMask()
	love.graphics.rectangle('fill',screenSize.X/2-200,125,400,800)
end

function menu.createLevelList()
	if not love.filesystem.exists('Saves') then
		love.filesystem.createDirectory('Saves')
	end

	local saveList = love.filesystem.getDirectoryItems('Saves')
	table.sort(saveList) -- get general order of saves

	menu.saveList = {}
	menu.reverseHookUp = {}

	love.graphics.setLineWidth(5)
	love.graphics.setFont(menu.largeFont)

	for i,v in pairs(saveList) do
		local i = 'levelButton'..i
		menu.reverseHookUp[i] = v
		menu.saveList[i] = {}
		menu.saveList[i].button = love.graphics.newCanvas(400,100)
		love.graphics.setCanvas(menu.saveList[i].button)

		love.graphics.rectangle('line',0,0,400,100)
		love.graphics.print(v,6,6)

		menu.saveList[i].selected = love.graphics.newCanvas(400,100)
		love.graphics.setCanvas(menu.saveList[i].selected)

		love.graphics.setColor(255,0,0)
		love.graphics.rectangle('line',2,2,396,96)
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('line',0,0,400,100)
		love.graphics.print(v,6,6)
	end

	love.graphics.setCanvas()
end

function menu.levelChooser()

	if not menu.saveList then
		menu.createLevelList()
	end

	if buttons.checkForButton('createWorld') == false then

		love.graphics.setStencil(menu.levelListMask)

		for i,v in pairs(menu.saveList) do
			local numerical = string.sub(i,12,#i)
			buttons.addButton(
				{pos = Vector2.new(screenSize.X/2-200,numerical*125+125),
				size = Vector2.new(400,100),
				zIndex = 1,
				image = v.button,
				clicked = menu.buttonLevel},
				i)
			--love.graphics.draw(v,screenSize.X/2-200,i*125+125)
		end

		love.graphics.setStencil()
		
		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2+250,250),
			size = Vector2.new(300,50),
			zIndex = 1,
			image = menu.images.createWorld,
			clicked = menu.buttonCreateWorld},
			'createWorld')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2+250,310),
			size = Vector2.new(300,50),
			zIndex = 1,
			image = menu.images.play,
			clicked = menu.buttonPlay,
			active = false},
			'play')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2+250,370),
			size = Vector2.new(140,50),
			zIndex = 1,
			image = menu.images.rename,
			clicked = menu.buttonRename,
			active = false},
			'rename')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2+410,370),
			size = Vector2.new(140,50),
			zIndex = 1,
			image = menu.images.delete,
			clicked = menu.buttonDelete,
			active = false},
			'delete')

		buttons.addButton(
			{pos = Vector2.new(200,100),
			size = Vector2.new(150,50),
			zIndex = 1,
			image = menu.images.backArrow,
			clicked = menu.buttonBackArrow},
			'backArrow')
	end


end

function menu.createWorld()
	if textBox.checkForTextBox('name') == false then
		textBox.addTextBox({
			pos = Vector2.new(screenSize.X/2-200,400),
			size = Vector2.new(400,50),
			borderSize = 4,
			font = menu.largeFont},
			'name')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2-150,480),
			size = Vector2.new(300,50),
			zIndex = 1,
			image = menu.images.createWorld,
			clicked = menu.buttonCreateWorld2},
			'createWorld')

		buttons.addButton(
			{pos = Vector2.new(200,100),
			size = Vector2.new(150,50),
			zIndex = 1,
			image = menu.images.backArrow,
			clicked = menu.buttonBackArrow2},
			'backArrow')

	end
end

function menu.rename()
	if textBox.checkForTextBox('name') == false then
		textBox.addTextBox({
			pos = Vector2.new(screenSize.X/2-200,400),
			size = Vector2.new(400,50),
			borderSize = 4,
			font = menu.largeFont,
			text = menu.memory},
			'name')

		buttons.addButton(
			{pos = Vector2.new(screenSize.X/2-70,480),
			size = Vector2.new(140,50),
			zIndex = 1,
			image = menu.images.rename,
			clicked = menu.buttonRename2},
			'rename')

		buttons.addButton(
			{pos = Vector2.new(200,100),
			size = Vector2.new(150,50),
			zIndex = 1,
			image = menu.images.backArrow,
			clicked = menu.buttonBackArrow3},
			'backArrow')

	end
end

function menu.draw()
	backgroundMenu.draw()
	love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)
	if menu.mode == 'main' then
		menu.mainMenu()
	elseif menu.mode == 'levelChooser' then
		menu.levelChooser()
	elseif menu.mode == 'createWorld' then
		menu.createWorld()
	elseif menu.mode == 'rename' then
		menu.rename()
	end
	love.graphics.print('Version: ' .. VERSION,screenSize.X-150,5)
end