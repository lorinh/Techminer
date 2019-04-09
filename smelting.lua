---------------
--All smelting objecs
---------------
--LogFire

smelting = {}

function smelting.init()
	interface.addInterface({func = smelting.draw,block = 'LogFire',setUp = smelting.setUp})
	interface.addInterface({func = smelting.draw,block = 'StoneLogFire',setUp = smelting.setUp})
	interface.addInterface({func = smelting.draw,block = 'StoneStove',setUp = smelting.setUp,multiBlock = true})

	smelting.objects = {'LogFire','StoneLogFire','StoneStove'}
end

function smelting.setUp(blockData,id)
	--create some blockdata if it doesn't exist
	if blockData.bottomBoxData == nil or blockData.bottomBoxData.amount == 0 then
		blockData.bottomBoxData = {block = nil,amount = 0}
	end
	if blockData.inputBoxData == nil or blockData.inputBoxData.amount == 0 then
		blockData.inputBoxData = {block = nil,amount = 0}
	end
	if blockData.outputBoxData == nil or blockData.outputBoxData.amount == 0 then
		blockData.outputBoxData = {block = nil,amount = 0}
	end

	--set up the backpack buttons
	backpack.addInterface({position = Vector2.new(162,screenSize.Y/2+100),name = 'BottomBox',filter = smelting.woodFilter},blockData.bottomBoxData)

	backpack.addInterface({position = Vector2.new(224,screenSize.Y/2-150),name = 'OutputBox',filter = smelting.outPutFilter},blockData.outputBoxData)

	local cert = backpack.addInterface({position = Vector2.new(100,screenSize.Y/2-150),name = 'InputBox',filter = smelting.smeltingFilter},blockData.inputBoxData)
	blockData.certificate = cert
	return blockData
end

function smelting.woodFilter(name)
	return data.itemInfo[name].burnTime ~= nil
end

function smelting.smeltingFilter(name)
	return data.itemInfo[name].forms ~= nil
end

function smelting.outPutFilter(name)
	return name == nil
end

function smelting.draw(blockData,id)
	--draw background of backpack
	love.graphics.setColor(25,25,25,210)
	love.graphics.rectangle('fill',50,screenSize.Y/2-200,300,400)
	love.graphics.setColor(255,255,255)

	--play animation
	local block = map:getMap()[id.X][id.Y]
	local itemData = data.itemInfo[block]
	blockAnimation.playAnimation(map:getMap()[id.X][id.Y],150,screenSize.Y/2-50,1/itemData.size.X,1/itemData.size.X,id)

	--print fire tempature
	love.graphics.print(math.floor(blockData.temp) .. '°',60,screenSize.Y/2-50)

	--draw percent bar
	if blockData.inputBoxData.block then
		local percent = blockData.smelting / data.itemInfo[blockData.inputBoxData.block].forms.time
		love.graphics.rectangle('fill',100+75+3,screenSize.Y/2-75-(75*percent),3,75*percent)
	end

	--update the local block data from backpack data
	local bottomBoxData = backpack.getInterfaceData('BottomBox')
	blockData.bottomBoxData = {block = bottomBoxData.block,amount = bottomBoxData.amount}

	local inputBoxData = backpack.getInterfaceData('InputBox')
	blockData.inputBoxData = {block = inputBoxData.block,amount = inputBoxData.amount}

	local outputBoxData = backpack.getInterfaceData('OutputBox')
	blockData.outputBoxData = {block = outputBoxData.block,amount = outputBoxData.amount}

	return blockData
		--screenSize.X/2-6+backpack.offset,backpack.UIOFFSET.Y-6,backpack.UISIZE.X*108*10+12,backpack.UISIZE.Y*108*3+12)
end

function smelting.LogFireRun(pos,blockData)

	--set up the block's data if it doesn't exist
	if not blockData then
		blockData = {}
		blockData.frame = 1
		blockData.burning = 0
		blockData.bottomBoxData = {amount = 0,block = nil}
		blockData.inputBoxData  = {amount = 0,block = nil}
		blockData.outputBoxData = {amount = 0,block = nil}
		blockData.smelting = 0
		blockData.temp = 0
		blockData.blockBurning = nil
	end

	--add 1/4 frame
	blockData.frame = blockData.frame+.25

	--remove one block from bottombox and start burning it.
	if blockData.burning <= 0 then

		if blockData.bottomBoxData.amount > 0 then

			blockData.burning = data.itemInfo[blockData.bottomBoxData.block].burnTime
			blockData.bottomBoxData.amount = blockData.bottomBoxData.amount-1
			blockData.blockBurning = blockData.bottomBoxData.block

			--update backpack if interface is open
			if blockData.certificate == backpack.certificate then
				local backpackBottom = backpack.getInterfaceData('BottomBox')
				backpackBottom.amount = backpackBottom.amount-1
				backpack.setInterfaceData('BottomBox',backpackBottom)
			end

		end
	elseif blockData.burning > 0 and blockData.blockBurning == nil then
		blockData.burning = 0
		blockData.blockBurning = nil
	end

	--let heat leave
	blockData.temp = blockData.temp*data.itemInfo.LogFire.efficency

	local blockInfo = data.itemInfo[blockData.inputBoxData.block]

	--decrease burning, add block tempature to fire tempature
	if blockData.burning > 0 then
		blockData.burning = blockData.burning - 1/50
		blockData.temp = blockData.temp + data.itemInfo[blockData.blockBurning].burnTemp
	end

	--only smelt the ore if the tempature is above the ore's melting point
	if blockInfo and blockInfo.forms.temp <= blockData.temp then

		blockData.smelting = blockData.smelting + blockInfo.forms.multi(blockData.temp)

		if blockData.smelting >= data.itemInfo[blockData.inputBoxData.block].forms.time then
			local forms = blockInfo.forms.block

			if blockData.outputBoxData.block == nil or blockData.outputBoxData.block == forms then

				--move ore from input box to smelted ore in output
				blockData.outputBoxData.block = forms
				blockData.outputBoxData.amount = blockData.outputBoxData.amount + 1
				blockData.inputBoxData.amount = blockData.inputBoxData.amount - 1

				--remove input box item if none in it
				if blockData.inputBoxData.amount <= 0 then
					blockData.inputBoxData.block = nil
					blockData.inputBoxData.amount = 0
				end

				--update backpack if current interface is open
				if blockData.certificate == backpack.certificate then
					local backpackInput = backpack.getInterfaceData('InputBox')
					local backpackOutput = backpack.getInterfaceData('OutputBox')

					backpackInput.amount = blockData.inputBoxData.amount
					backpackInput.block  = blockData.inputBoxData.block

					backpackOutput.amount = blockData.outputBoxData.amount
					backpackOutput.block  = blockData.outputBoxData.block

					backpack.setInterfaceData('InputBox',backpackInput)
					backpack.setInterfaceData('OutputBox',backpackOutput)
				end
				blockData.smelting = 0
			end
		end
	else
		blockData.smelting = 0
	end
	
	if blockData.frame > 75 then
		blockData.frame = 1
	end

	return blockData
end

function smelting.StoneStoveRun(pos,blockData)
		--set up the block's data if it doesn't exist
	--print('PreLoaded step data is: ' .. blockData.frame,blockData.burning,blockData.smelting,blockData.temp,blockData.burning)
	if not blockData then
		blockData = {}
		blockData.frame = 1
		blockData.burning = 0
		blockData.bottomBoxData = {amount = 0,block = nil}
		blockData.inputBoxData  = {amount = 0,block = nil}
		blockData.outputBoxData = {amount = 0,block = nil}
		blockData.smelting = 0
		blockData.temp = 0
		blockData.blockBurning = nil
	end
	--print('Loaded step data is: ' .. blockData.frame,blockData.burning,blockData.smelting,blockData.temp,blockData.burning)

	--add 1/4 frame
	blockData.frame = blockData.frame+.25

	--remove one block from bottombox and start burning it.
	if blockData.burning <= 0 then

		if blockData.bottomBoxData.amount > 0 then

			blockData.burning = data.itemInfo[blockData.bottomBoxData.block].burnTime
			blockData.bottomBoxData.amount = blockData.bottomBoxData.amount-1
			blockData.blockBurning = blockData.bottomBoxData.block

			--update backpack if interface is open
			if blockData.certificate == backpack.certificate then
				local backpackBottom = backpack.getInterfaceData('BottomBox')
				backpackBottom.amount = backpackBottom.amount-1
				backpack.setInterfaceData('BottomBox',backpackBottom)
			end

		end
	elseif blockData.burning > 0 and blockData.blockBurning == nil then
		blockData.burning = 0
		blockData.blockBurning = nil
	end

	--let heat leave
	blockData.temp = blockData.temp*data.itemInfo.StoneStove.efficency

	local blockInfo = data.itemInfo[blockData.inputBoxData.block]

	--decrease burning, add block tempature to fire tempature
	if blockData.burning > 0 then
		blockData.burning = blockData.burning - 1/50
		blockData.temp = blockData.temp + data.itemInfo[blockData.blockBurning].burnTemp
	end

	--only smelt the ore if the tempature is above the ore's melting point
	if blockInfo and blockInfo.forms.temp <= blockData.temp then

		blockData.smelting = blockData.smelting + blockInfo.forms.multi(blockData.temp)

		if blockData.smelting >= data.itemInfo[blockData.inputBoxData.block].forms.time then
			local forms = blockInfo.forms.block

			if blockData.outputBoxData.block == nil or blockData.outputBoxData.block == forms then

				--move ore from input box to smelted ore in output
				blockData.outputBoxData.block = forms
				blockData.outputBoxData.amount = blockData.outputBoxData.amount + 1
				blockData.inputBoxData.amount = blockData.inputBoxData.amount - 1

				--remove input box item if none in it
				if blockData.inputBoxData.amount <= 0 then
					blockData.inputBoxData.block = nil
					blockData.inputBoxData.amount = 0
				end

				--update backpack if current interface is open
				if blockData.certificate == backpack.certificate then
					local backpackInput = backpack.getInterfaceData('InputBox')
					local backpackOutput = backpack.getInterfaceData('OutputBox')

					backpackInput.amount = blockData.inputBoxData.amount
					backpackInput.block  = blockData.inputBoxData.block

					backpackOutput.amount = blockData.outputBoxData.amount
					backpackOutput.block  = blockData.outputBoxData.block

					backpack.setInterfaceData('InputBox',backpackInput)
					backpack.setInterfaceData('OutputBox',backpackOutput)
				end
				blockData.smelting = 0
			end
		end
	else
		blockData.smelting = 0
	end
	
	if blockData.frame > 75 then
		blockData.frame = 1
	end

	--print('End Loaded step data is: ' .. blockData.frame,blockData.burning,blockData.smelting,blockData.temp,blockData.burning)

	return blockData
end

function smelting.run()
	for _,blockType in pairs(smelting.objects) do
		local blocks = blockIndexing.getBlock(blockType)
		for _,position in pairs(blocks) do
			local blockData = interface.getData(position.X,position.Y)
			local blockData = smelting[blockType .. 'Run'](position,blockData)
			interface.setData(position.X,position.Y,blockData)
		end
	end
end
