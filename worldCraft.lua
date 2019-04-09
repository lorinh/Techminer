-----------
--Craft buildings based on buildings built in world
-----------

worldCraft = {}

function worldCraft.init()
	--[[for recipeIndex,recipe in pairs(data.worldCraftRecipes) do
		for xIndex,xTable in pairs(recipe) do
			for yIndex,value in pairs(xTable) do
				blockIndexing

	]]

end

function worldCraft.run()
	local mapObj = map
	local map = map:getMap()
	for recipeIndex,recipe in pairs(data.worldCraftRecipes) do
		local blocks = blockIndexing.getBlock(recipe[1][1])
		if blocks then
			for i,v in pairs(blocks) do
				found = true
				for yIndex,xTable in pairs(recipe) do
					for xIndex,value in pairs(xTable) do
						local pos = Vector2.new(v.X+xIndex-1,v.Y+yIndex-1)
						if map[pos.X] == nil then
							found = false
						end
						if found == false then break end
						if map[pos.X][pos.Y] ~= value then
							if value == 'air' and map[pos.X][pos.Y] == nil then
								--do nothing
							else
						 		found = false
						 	end
						 end
						if found == false then break end
					end
					if found == false then break end
				end
				if found then
					mapObj:setPoint(v.X,v.Y,'TownHall')
				end
			end
		end
	end
end