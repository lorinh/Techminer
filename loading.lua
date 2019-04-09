----------------
---loading
----------------
--loads all objects said to be loaded by data module
----------------
loadingFunctions = {}

function loadingFunctions.addItem()
	if loadingVariables.items[loadingVariables.index].type == 'image' then
		loadingFunctions.addImage()
	elseif loadingVariables.items[loadingVariables.index].type == 'sound' then
		loadingFunctions.addSound()
	end
end

function loadingFunctions.addSound()
	local name = loadingVariables.items[loadingVariables.index].name
	local source = loadingVariables.items[loadingVariables.index].file
	sounds[name] = soundService.addSound(source)
end

function loadingFunctions.addImage()
	if loadingVariables.items[loadingVariables.index].subTable then
		if not images[loadingVariables.items[loadingVariables.index].subTable] then
			images[loadingVariables.items[loadingVariables.index].subTable] = {}
		end
		images[loadingVariables.items[loadingVariables.index].subTable][loadingVariables.items[loadingVariables.index].name] = love.graphics.newImage(loadingVariables.items[loadingVariables.index].file)
	else
		images[loadingVariables.items[loadingVariables.index].name] = love.graphics.newImage(loadingVariables.items[loadingVariables.index].file)
	end
end

function loadingFunctions.stepLoad()
	if loadingVariables.index < #loadingVariables.items then
		loadingVariables.index = loadingVariables.index+1
		loadingFunctions.addItem()
	end
end

function loadingFunctions.loadAssets()
	love.graphics.setColor(255,255,255)
	backgroundMenu.draw()
	love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)

	love.graphics.setColor(0,0,0,50)
	love.graphics.setNewFont(35)
	love.graphics.rectangle('fill',screenSize.X/2-300+4,450+4,600*(loadingVariables.index/#loadingVariables.items),10)
	love.graphics.print('Loading assets...',screenSize.X/2-120+4,400+4)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill',screenSize.X/2-300,450,600*(loadingVariables.index/#loadingVariables.items),10)
	love.graphics.print('Loading assets...',screenSize.X/2-120,400)

	if loadingVariables.index < #loadingVariables.items then
		for _ = 1,2 do
			loadingFunctions.stepLoad()
		end
	else
		currentMode = 'loading save'
		stepIndex = 0
			
		love.graphics.setColor(255,255,255)
		backgroundMenu.draw()
		love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)

		love.graphics.setColor(0,0,0,50)
		love.graphics.setNewFont(35)
		love.graphics.rectangle('fill',screenSize.X/2-300+4,450+4,600*(stepIndex/11),10)
		love.graphics.print('Loading save...',screenSize.X/2-120+4,400+4)

		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill',screenSize.X/2-300,450,600*(stepIndex/11),10)
		love.graphics.print('Loading save...',screenSize.X/2-120,400)


	end
end

function loadingFunctions.loadSave()
	love.graphics.setColor(255,255,255)
	backgroundMenu.draw()
	love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)

	love.graphics.setColor(0,0,0,50)
	love.graphics.setNewFont(35)
	love.graphics.rectangle('fill',screenSize.X/2-300+4,450+4,600*(stepIndex/20),10)
	love.graphics.print('Loading save...',screenSize.X/2-120+4,400+4)

	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill',screenSize.X/2-300,450,600*(stepIndex/20),10)
	love.graphics.print('Loading save...',screenSize.X/2-120,400)
		
	--love.graphics.print('Step: ' .. stepIndex,screenSize.X/2-40,500)
		
	if stepIndex < 20 then
		stepIndex = stepIndex+1
		print(menu.saveName)
		if not save.loadFile(stepIndex,menu.saveName) then
			stepIndex = 20
			print('Generating random map')
			map:generate()
			new = true
		end
	else
		if new == true then
			if newFrame > 0 then
				love.graphics.setColor(0,0,0,255*(-newFrame/100+1))
			else
				love.graphics.setColor(0,0,0,255)
			end
			love.graphics.rectangle('fill',0,0,screenSize.X,screenSize.Y)
			love.graphics.setColor(255,255,255)
			love.graphics.draw(images.load.title,screenSize.X/2-320,50,nil,1,1)
			newFrame = newFrame-1
			if newFrame <= -20 then
				newFrame = 250
				terrain.getMinMax()
				blockIndexing.findBlocks()
				currentMode = 'main'
				love.graphics.setFont(defaultFont)
				loadingVariables = nil
			end
		else
			newFrame = 250
			terrain.getMinMax()
			blockIndexing.findBlocks()
			currentMode = 'main'
			love.graphics.setFont(defaultFont)
			loadingVariables = nil
		end
	end
end