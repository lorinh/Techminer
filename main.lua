----------------
---main of Techminer
----------------

VERSION = '1.0'


 -- load all the modules
require 'Vector2'
require 'buttons'
require 'textBox'
require 'loverun'
require 'loading'
require 'core'
require 'random' 
require 'animate'
require 'physics'
require 'characterMovement'
require 'backpack'
require 'townhall'
require 'stats'
require 'data'
require 'save'
require 'sky'
require 'config'
require 'chunks'
require 'terrain'
require 'blockIndex'
require 'assemble'
require 'userEvent'
require 'menu'
require 'background'
require 'trees'
require 'soundService'
require 'map'
require 'chat'
require 'blockAnimation'
require 'interface'
require 'smelting'
require 'flash'
require 'worldCraft'
json = love.filesystem.load('json.lua')()

 -- set up multi threading
terrainThread = love.thread.newThread('terrainThread.lua')
terrainChannelRequest = love.thread.getChannel('terrainRequest')
terrainChannelReturn = love.thread.getChannel('terrainReturn')

chunkThread = love.thread.newThread('chunkThread.lua')
chunkChannelRequest = love.thread.getChannel('chunkRequest')
chunkChannelReturn = love.thread.getChannel('chunkReturn')

defaultScreenSizeX = 1200


 -- for debug purposes
lastDugInChunk = '' 

function love.load()
	Camera = Vector2.new(0,0)
	zoom = 1
	frames = 0
	oldDelta = 0
	fpsLimit = 50
	debug = true
	times = {}
	times.all = 0
	time = {}
	delta = 0
	new = false
	newFrame = 100
	titleFrame = 500
	saveName = nil

	keyBindings = {
		['q'] = 'q',
		['d'] = 'd',
		['a'] = 'a',
		['e'] = 'e',
		['w'] = 'w'
	}

	sounds = {}

	images = {}
	images.load = {}
	images.load.background = love.graphics.newImage("Images/Background.png")
	images.load.title = love.graphics.newImage('Images/TitleCropped.png')
	random.setSeed(77)

	keys = {}

	loadingVariables = {}
	loadingVariables.index = 0
	loadingVariables.items = data.assets
	
	stepIndex = 0
	
	defaultFont = love.graphics.newFont("TimesNewRoman.ttf", 20)
	largeFont = love.graphics.newFont("TimesNewRoman.ttf", 100)
	love.graphics.setFont(defaultFont)
	--love.window.setFullscreen(true,'desktop')
	--love.window.setMode(1920,1080,{fullscreen = true,fullscreentype = 'normal',vsync = true})
	screenSize = Vector2.new(love.graphics.getWidth(),love.graphics.getHeight())
	currentMode = 'menu'--'loading'
	
	backgroundMenu.init()
	if save.initialized == true then
		menu.loadModules()
	end
end

function concat(tab,max)
	local str = ''
	for i,v in pairs(tab) do
		if i ~= 'memory' then
			str = str .. i .. ': ' .. math.floor((v/max)*100) .. '%\n'
		end
	end
	str = str .. 'memory' .. ': ' .. math.floor(tab.memory or 0) .. ' MB'
	return str
end

function love.draw(delta)
	screenSize = Vector2.new(love.graphics.getWidth(),love.graphics.getHeight())


	mouse = Vector2.new(love.mouse.getX(),love.mouse.getY())

	times = {}
	times.all = love.timer.getTime()

	if currentMode == 'menu' then

		--draw menu if current mode is menu
		menu.draw()

	elseif currentMode == 'loading' then

		--load assets and different modules
		loadingFunctions.loadAssets()

	elseif currentMode == 'loading save' then

		--load save file, or generate map
		loadingFunctions.loadSave()

	elseif currentMode == 'assemble' then

		assemble.draw()
		
	elseif currentMode == 'main' then

		--draw the sky in the background
		sky.draw()
		
		times.characterAnimation = love.timer.getTime()
		
		characterMovement.run()
		animate.player.climb()
		coreFunctions.mineBlock()

		if love.mouse.isDown('l') then
			coreFunctions.placeBlock()
		end
		
		times.characterAnimation = love.timer.getTime()-times.characterAnimation
		times.renderMap = love.timer.getTime()
		
		map:render()
		coreFunctions.hoverBlock()
		
		times.renderMap = love.timer.getTime()-times.renderMap
		times.sub = love.timer.getTime()
		
		townhall.run()
		animate.player.draw()
		interface.draw()
		smelting.run()
		backpack.draw()
		townhall.draw()
		terrain.autoGenerate()
		chunk.loadChunk()
		userEvent.draw()
		chat.draw()
		
		times.sub = love.timer.getTime()-times.sub
		times.physics = love.timer.getTime()
		
		physics.run(delta)
		
		times.physics = love.timer.getTime()-times.physics
		
		stats.draw()
		config.draw()
		
		times.all = love.timer.getTime()-times.all

		--draw debug info
		
		frames = (frames+1)%20
		if frames == 0 then
			oldDelta = delta
			time = times
			time.other = delta-(time.physics+time.renderMap+time.characterAnimation)
			time.memory = collectgarbage('count')/100
		end
		
		love.graphics.setColor(255,255,255)
		love.graphics.print('FPS: ' .. math.floor(1/oldDelta),3,3,0,.8,.8)
		if debug then
			love.graphics.print(concat(time,oldDelta),3,20,0,.8,.8)
			love.graphics.print('Pos: ' .. math.floor(Camera.X/100) .. ',' .. math.floor(Camera.Y/100),3,140,0,.8,.8)
			love.graphics.print('Zoom: ' .. math.floor(zoom*100),3,154,0,.8,.8)
			love.graphics.print('ChunkLoading: ' .. chunkChannelReturn:getCount()/3+terrainChannelReturn:getCount()/3,3,168,0,.8,.8)
			love.graphics.print('Diggin in chunk: ' .. lastDugInChunk,3,168+14,0,.8,.8)
			love.graphics.print('Resolution: ' .. love.graphics.getWidth() .. ' : ' .. love.graphics.getHeight(),3,168+14+14,0,.8,.8)
		end

		if new == true then
			if newFrame > 0 then
				love.graphics.setColor(0,0,0,255*newFrame/250)
			else
				love.graphics.setColor(0,0,0,0)
			end
			love.graphics.rectangle('fill',0,0,screenSize.X,screenSize.Y)
			if titleFrame > 50 then
				love.graphics.setColor(255,255,255)
			else
				love.graphics.setColor(255,255,255,255*titleFrame/50)
			end
			love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)
			newFrame = newFrame-1
			if newFrame <= -0 then
				titleFrame = titleFrame-1
				if titleFrame < 0 then
					new = false
				end
			end
		end
		
		if keys.b then
			for i = 1,10 do
				stats.addBlockBroken()
			end
		end
	end

	buttons.drawButtons()
	textBox.drawTextBoxes()

end

function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
end

function love.mousepressed(x,y,button)

	mouse = Vector2.new(love.mouse.getX(),love.mouse.getY())

	if button == 'l' then
		if currentMode == 'main' then

			if townhall.showMenu == true then
				townhall.mouseButton(mouse)

			else
				townhall.mouseButton(mouse)
				config.mouseButton(mouse)
				backpack.mouseButton(mouse)
				coreFunctions.mouseButton(mouse)

			end

		elseif currentMode == 'assemble' then
			assemble.mouseButton(mouse)

		elseif currentMode == 'menu' then
			--menu.mouseButton(mouse)

		end

	elseif button == 'r' then

		if currentMode == 'assemble' then
			assemble.mouseButtonRight(mouse)

		elseif currentMode == 'main' then
			interface.mouseButtonRight(mouse)
			backpack.mouseButtonRight(mouse)

		end

	elseif button == 'wu' then
		zoom = zoom*.9

	elseif button == 'wd' then
		zoom = zoom*(1/.9)

	end
end

function love.mousereleased()

	buttons.checkButtons(mouse)
	textBox.mouseButtonUp(mouse)
	
	if currentMode == 'main' then
		backpack.mouseReleased()
		coreFunctions.mouseReleased()

	end
end

function love.keypressed(key)
	keys[key] = true
	textBox.keyPressed(key)
	if currentMode == 'main' then

		if chat.typing == false then
			townhall.keyPressed(key)
			config.keyPressed(key)
			backpack.keyPressed(key)
			chat.keyPressed(key)
		else
			chat.keyPressed(key)
		end

	elseif currentMode == 'assemble' then
		assemble.keyPressed(key)
	end
end

function love.keyreleased(key)
	keys[key] = nil
end
