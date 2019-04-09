------------
---Block Animation
-------------
--Provides an interface to blocks that need animation

blockAnimation = {}

function blockAnimation.init()
	--index = block, value = func (x,y,data?)
	blockAnimation.animations = {}

	blockAnimation.addAnimation('LogFire',blockAnimation.fireAnimate)
	blockAnimation.addAnimation('StoneLogFire',blockAnimation.fireAnimate)
	blockAnimation.addAnimation('StoneStove',blockAnimation.stoveFireAnimation)
end

function blockAnimation.addAnimation(block,func)
	blockAnimation.animations[block] = func
end

function blockAnimation.playAnimation(block,x,y,scaleX,scaleY,id)
	if blockAnimation.animations[block] then
		local data = interface.getData(id.X,id.Y)
		data = blockAnimation.animations[block](x,y,scaleX,scaleY,data,block)
		interface.setData(id.X,id.Y,data)
	else
		print('Unable to find animation for block: ' .. block)
	end
end

function blockAnimation.fireAnimate(x,y,scaleX,scaleY,blockData,name)

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


	--draw bottom layer of block
	love.graphics.draw(images.LogFireBottom,x,y,nil,scaleX,scaleY)

	--draw fire image
	if blockData.burning > 0 then
		love.graphics.draw(images.fireAnimation[tostring(math.floor(blockData.frame))],x-2,y-40*scaleY,nil,scaleX,scaleY)
	end

	love.graphics.draw(images.LogFireTop,x,y,nil,scaleX,scaleY)

	if name == 'StoneLogFire' then
		love.graphics.draw(images.StoneLogFireTop,x,y,nil,scaleX,scaleY)
	end
	
	return blockData
end

function blockAnimation.stoveFireAnimation(x,y,scaleX,scaleY,blockData,name)
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

	--print('Loaded draw data is: ' .. blockData.frame,blockData.burning,blockData.smelting,blockData.temp,blockData.burning)


	--draw bottom layer of block
	love.graphics.draw(images.StoneStoveBottom,x,y,nil,scaleX,scaleY)

	--draw fire image
	if blockData.burning > 0 then
		love.graphics.draw(images.fireAnimation[tostring(math.floor(blockData.frame))],x+50*scaleX,y+68*scaleY,nil,scaleX,scaleY)
	end

	love.graphics.draw(images.StoneStove,x,y,nil,scaleX,scaleY)

	--print('End Loaded draw data is: ' .. blockData.frame,blockData.burning,blockData.smelting,blockData.temp,blockData.burning)
	
	return blockData
end