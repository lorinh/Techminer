----------------
---BlockIndexing
----------------
--Saves indexes of specail blocks to stop intense searches.
----------------

blockIndexing = {}

 function blockIndexing.init()
	blockIndexing.TownHall = {}
	blockIndexing.ToolsShop = {}
	blockIndexing.BlackSmith = {}
	blockIndexing.Market = {}

	blockIndexing.Leaves = {}
end

function blockIndexing.addBlockIndex(blockName)
	blockIndexing[blockName] = {}
	blockIndexing.findBlocksCustom(blockName)
end

function blockIndexing.findBlocksCustom(blockName)
	for xIndex,xValue in pairs(map:getMap()) do
		for yIndex,value in pairs(xValue) do
			if value == blockName then
				blockIndexing[blockName][#blockIndexing[blockName]+1] = Vector2.new(xIndex,yIndex)
			end
		end
	end
end

function blockIndexing.findBlocks()--depreciated
	for xIndex,xValue in pairs(map:getMap()) do
		for yIndex,value in pairs(xValue) do
			blockIndexing.addBlock(value,xIndex,yIndex)
		end
	end
end

 function blockIndexing.addBlock(block,x,y)
	if blockIndexing[block] then
		blockIndexing[block][#blockIndexing[block]+1] = Vector2.new(x,y)
	end
end

function blockIndexing.removeBlock(block,x,y)
	--print('Searching for block: ' .. tostring(block))
	if blockIndexing[block] then
		for i,v in pairs(blockIndexing[block]) do
			if v.X == x and v.Y == y then
				table.remove(blockIndexing[block],i)
				return nil
			end
		end
	end
end

function blockIndexing.getBlock(block)
	if blockIndexing[block] then
		--print('Returning: ' .. table.concat(blockIndexing[block],', ') .. ' for: ' .. block)
		return blockIndexing[block]
	end
end