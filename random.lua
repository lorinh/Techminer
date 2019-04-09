----------------
---random functions
--allows for persedural generation
----------------

random = {}
random.seed = 0
random.P1 = 16807
random.P2 = 0
random.lastValue = 0
random.maxValue = 2147483647

function random.setSeed(num)
	random.seed = num
	random.lastValue = num
end

function random.range(num1,num2,p1,p2,level)
	level = level and level or 1
	local range = math.max(num1,num2)-math.min(num1,num2)
	random.P1 = math.abs(p1)--+level
	random.P2 = math.abs(p2)--+level
	random.lastValue = (random.maxValue%(random.P1+random.P2)*random.P1)*random.seed*level
	random.lastValue = (random.P1*random.lastValue+random.P2)%random.maxValue
	return (random.lastValue%range)+math.min(num1,num2)
end
