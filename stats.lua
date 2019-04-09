----------------
---stats
----------------
--player stats
----------------

stats = {}

function stats.init()
	stats.money = 0
	stats.blockBroken = 0
end



function stats.addMoney(amount)
	stats.money = stats.money+amount
end

function stats.addBlockBroken()
	stats.blockBroken = stats.blockBroken+1
end

function stats.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print('Money: ' .. stats.money,screenSize.X-150,3)
	--print('Current num of blocks broken',stats.blockBroken)
	local level,percent = stats.getLevelFormula(stats.blockBroken)
	love.graphics.print('Level: ' .. level,screenSize.X/2-28,3)
	love.graphics.setColor(100,100,100,127)
	love.graphics.rectangle('fill',screenSize.X/2-100,25,200,4)
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('fill',screenSize.X/2-100,25,200*percent,4)
	
	love.graphics.print('Elevation: ' .. math.floor((Camera.Y)/100),screenSize.X/2-250,4)
end

function stats.getMineNum()
	--1*x
	local num = 1-((1-(1/stats.getLevelFormula(stats.blockBroken)))^6)
	return num
end

function stats.getLevelFormula(xp)
	local level = 1
	repeat
		xp = xp - ((level+5)^1.3+10)
		level = level + 1
	until xp < 0
	local need = ((level+5)^1.3+10)
	local current = xp+((level+4)^1.3+10)
	
	local percent = current/need
	return level-1,percent
end
function stats.getWalkSpeed(base)
	local level,percent = stats.getLevelFormula(stats.blockBroken)
	return (level)/25*base/math.abs(base)+base
end
--[[
current level up fomula

tab = {} for i = 1,20 do tab[#tab+1] = (i+5)^1.3+10 local z = 0 for i,v in pairs(tab) do z = z+v end print(z) end
20.270619156458
42.820148894105
67.748676758694
95.14731516308
125.09993831277
157.68443886302
192.97366965515
231.03616963263
271.93673648585
315.73688719849
362.4952345584
412.26779933098
465.10827227372
521.06823642198
580.19735746661
642.54354818596
708.1531115472
777.07086609655
849.34025651161
925.0034516217
]]