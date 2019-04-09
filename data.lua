----------------
---data for blocks, images and properties
----------------

data = {}


--[[data.tools = {
	{name = 'hand',speed = 2,frames = 12,rate = .3,index = 1,level = 0,toolLevel = 1},
	{name = 'trowel',speed = 1.75, frames = 11,rate = .3,cost = 10,index = 2,level = 0,toolLevel = 1},
	{name = 'pickaxe',speed = 1.5, frames = 12,rate = .3, cost = 200, index = 3,level = 1,toolLevel = 1}
}]]

-------------------------------------

data.itemInfo = {} --Info for every item that can be in the player's backpack and every block in the map

data.itemInfo = {

	------Blocks
	Grass = {
		type = 'block',
		breakFrames = 200,
		level = 0,
		index = 'b1',
		physics = true,
		returns = 'Dirt'
	},

	Dirt = {
		type = 'block',
		breakFrames = 200,
		level = 0,
		index = 'b2',
		physics = true
	},

	Stone = {
		type = 'block',
		breakFrames = 500,
		level = 2,
		index = 'b3',
		physics = true
	},

	UnbreakingStone = {
		type = 'block',
		breakFrames = math.huge,
		level = math.huge,
		index = 'b4',
		physics = true
	},

	air = {
		type = 'block',
		breakFrames = math.huge,
		level = math.huge,
		index = 'b5',
		physics = false
	},

	IronOre = {
		type = 'block',
		breakFrames = 750,
		level = 2,
		index = 'b6',
		physics = true
	},

	Sand = {
		type = 'block',
		breakFrames = 100,
		level = 0,
		index = 'b7',
		physics = true
	},

	WoodenPad = {
		type = 'block',
		breakFrames = 110,
		level = 0,
		index = 'b8',
		solid = false,
		physics = true
	},

	Clay = {
		type = 'block',
		breakFrames = 150,
		level = 0,
		index = 'b9',
		physics = true
	},

	Wood = {
		type = 'block',
		breakFrames = 50,
		level = 0,
		index = 'b10',
		physics = true,
		burnTime = 32,
		burnTemp = .2
	},

	Leaves = {
		type = 'block',
		breakFrames = 20,
		level = 0,
		index = 'b11',
		physics = false,
		solid = false,
		returns = nil,
		burnTime = .5,
		burnTemp = .4
	},

	Flat = {
		type = 'block',
		breakFrames = 100,
		level = 0,
		index = 'b12',
		physics = true
	},

	DirtCopper = {
		type = 'block',
		level = 0,
		index = 'b13',
		breakFrames = 400,
		physics = true,
		forms = {block = 'BrassBar', temp = 375, time = 6000,multi = function(x) return (x-375)/100+1 end}
	},

	WoodPlanks = {
		type = 'block',
		level = 0,
		index = 'b14',
		breakFrames = 100,
		physics = true
	},

	DirtStone = {
		type = 'block',
		level = 1,
		index = 'b15',
		breakFrames = 200,
		physics = true,
		returns = 'StoneShards'
	},

	Flash = {
		type = 'block',
		level = 0,
		index = 'b16',
		breakFrames = 10,
		physics = true,
		animation = true
	},


	---------interactive blocks

	LogFire = {
		type = 'block',
		breakFrames = 200,
		level = 0,
		index = 'int0',
		physics = false,
		customData = true,
		animation = true,
		efficency = .9995
	},

	StoneLogFire = {
		type = 'block',
		breakFrames = 200,
		level = 0,
		index = 'int1',
		physics = false,
		customData = true,
		animation = true,
		efficency = .9997
	},

	StoneStove = {
		type = 'block',
		breakFrames = 400,
		level = 1,
		size = Vector2.new(2,2),
		index = 'int2',
		physics = false,
		scale = 1,
		customData = true,
		animation = true,
		efficency = .9999
	},

	_StoneStove = {
		type = 'block',
		index = 'int3',
		physics = false,
		solid = false,
	},

	---------Buildings

	TownHall = {
		type = 'block',
		value = 1,
		breakFrames = 200,
		level = 0,
		index = 'b0',
		size = Vector2.new(4,4),
		scale = 2,
		physics = false
	},

	ToolsShop = {
		type = 'block',
		value = 1,
		breakFrames = 200,
		level = 0,
		index = 'ba',
		size = Vector2.new(3,3),
		scale = 1.5,
		physics = false
	},

	BlackSmith = {
		type = 'block',
		value = 1,
		breakFrames = 200,
		level = 0,
		index = 'bb',
		size = Vector2.new(2,2),
		physics = false
	},

	Market = {
		type = 'block',
		value = 1,
		breakFrames = 200,
		level = 0,
		index = 'bc',
		size = Vector2.new(2,2),
		physics = false
	},

	_TownHall = {
		type = 'block',
		index = 'bd',
		physics = false,
		solid = false,
	},

	_ToolsShop = {
		type = 'block',
		index = 'be',
		physics = false,
		solid = false,
	},

	_BlackSmith = {
		type = 'block',
		index = 'bf',
		physics = false,
		solid = false,
	},

	_Market = {
		type = 'block',
		index = 'bg',
		physics = false,
		solid = false,
	},

	-------------Items

	Twig = {
		type = 'item',
		index = 'i1',
		burnTime = 10
	},

	Stick = {
		type = 'item',
		index = 'i2',
		burnTime = 10
	},

	ShovelHead = {
		type = 'item',
		index = 'i3'
	},

	Vine = {
		type = 'item',
		index = 'i4'
	},

	StoneShards = {
		type = 'item',
		index = 'i5'
	},

	IronBar = {
		type = 'item',
		index = 'i6'
	},

	CopperBar = {
		type = 'item',
		index = 'i7'
	},

	BrassBar = {
		type = 'item',
		index = 'i8'
	},

	------------Tools

	Hand = {
		type = 'tool',
		index = 't1',
		speed = 2,
		frames = 12,
		rate = .3,
		level = 5,
		toolLevel = 1,
		name = 'hand'
	},

	WoodenTrowel = {
		type = 'tool',
		index = 't2',
		speed = 1.5,
		frames = 11,
		rate = .3,
		level = 0,
		toolLevel = 1,
		name = 'trowel',
		durability = 50
	},

	Pickaxe = {
		type = 'tool',
		index = 't3',
		speed = .9,
		frames = 12,
		rate = .3,
		level = 2,
		toolLevel = 1,
		name = 'pickaxe'
	},

	BrassTrowel = {
		type = 'tool',
		index = 't4',
		speed = 1,
		frames = 11,
		rate = .3,
		level = 1,
		toolLevel = 1,
		name = 'trowel',
		durability = 175
	},

	BrassPickaxe = {
		type = 'tool',
		index = 't5',
		speed = 1,
		frames = 12,
		rate = .3,
		level = 2,
		toolLevel = 1,
		name = 'pickaxe',
		durability = 150
	},
}




------------------

data.ores = {
	Dirt = {func = function(x) 
		return .7
	end},
	
	Stone = {func = function(x)
		return .66
	end},
	
	IronOre = {func = function(x)
		return .66
	end},
	
	Sand = {func = function(x)
		return .66
	end},
}

data.dirtOres = {
	DirtCopper = {func = function(x)
		return .66
	end},

	DirtStone = {func = function(x)
		return .66
	end},

	Clay = {func = function(x)
		return .66
	end},
}

data.fullRecipe = {}

data.worldCraftRecipes = {
	TownHall = {{'Leaves','Leaves','Leaves','Leaves'},
				{'Leaves','Leaves','Leaves','Leaves'},
				{'Leaves','Wood'  ,'Wood'  ,'Leaves'},
				{'Leaves','Wood'  ,'Wood'  ,'Leaves'}},
}

data.patternRecipe = {

	[{block = 'Twig',amount = 4}] = {
		{'Wood'},
		{'Wood'}
	},

	[{block = 'Stick',amount = 1}] = {
		{'Twig'}
	},

	[{block = 'Flat',amount = 6}] = {
		{'Wood','Wood'}
	},

	[{block = 'WoodPlanks',amount = 4}] = {
		{'Wood'}
	},

	--[[[{block = 'WoodenTrowel',amount = 1}] = {
		{'air','WoodPlanks','air'},
		{'WoodPlanks','WoodPlanks','WoodPlanks'},
		{'WoodPlanks','WoodPlanks','WoodPlanks'},
		{'air','Vine','air'},
		{'air','Stick','air'}
	},]]

	[{block = 'WoodenTrowel',amount = 1}] = {
		{'air',       'WoodPlanks','air'},
		{'WoodPlanks','Stick',     'WoodPlanks'},
		{'air',       'Stick',     'air'},
		{'air',       'Stick',     'air'}
	},

	[{block = 'BrassTrowel',amount = 1}] = {
		{'air',     'BrassBar','air'},
		{'BrassBar','Stick',   'BrassBar'},
		{'air',     'Stick',   'air'},
		{'air',     'Stick',   'air'}
	},


	[{block = 'Vine',amount = 6}] = {
		{'Leaves'}
	},

	[{block = 'Flash',amount = 6}] = {
		{'Leaves','Leaves'}

	},

	[{block = 'LogFire',amount = 1}] = {
		{'Wood','Wood'},
		{'Wood','Wood'}
	},

	[{block = 'StoneLogFire',amount = 1}] = {
		{'StoneShards','Wood','Wood','StoneShards'},
		{'StoneShards','Wood','Wood','StoneShards'},
		{'StoneShards','StoneShards','StoneShards','StoneShards'}
	},


	[{block = 'BrassPickaxe',amount = 1}] = {
		{'BrassBar','BrassBar','BrassBar','BrassBar','BrassBar'},
		{'air',     'air',     'Stick'},
		{'air',     'air',     'Stick'},
		{'air',     'air',     'Stick'},
		{'air',     'air',     'Stick'}
	},
}

data.containRecipe = {}

-------------------------------------


data.assets = {
	{type = 'sound',file = 'Sounds/Break.mp3',name = 'BlockBreak'},
	--------------------------------------------Images
	--Blocks
	{type = 'image',file = 'Images/Grass.png',name = 'Grass'},
	{type = 'image',file = 'Images/Dirt.png',name = 'Dirt'},
	{type = 'image',file = 'Images/Stone.png',name = 'Stone'},
	{type = 'image',file = 'Images/UnbreakingStone.png',name = 'UnbreakingStone'},
	{type = 'image',file = 'Images/IronOre.png',name = 'IronOre'},
	{type = 'image',file = 'Images/Sand.png',name = 'Sand'},
	{type = 'image',file = 'Images/Clay.png',name = 'Clay'},
	{type = 'image',file = 'Images/WoodenPad.png',name = 'WoodenPad'},
	{type = 'image',file = 'Images/Wood.png',name = 'Wood'},
	{type = 'image',file = 'Images/Leaves.png',name = 'Leaves'},
	{type = 'image',file = 'Images/Flat.png',name = 'Flat'},
	{type = 'image',file = 'Images/DirtCopper.png',name = 'DirtCopper'},
	{type = 'image',file = 'Images/WoodPlanks.png',name = 'WoodPlanks'},
	{type = 'image',file = 'Images/DirtStone.png',name = 'DirtStone'},
	{type = 'image',file = 'Images/LogFire.png',name = 'LogFire'},
	{type = 'image',file = 'Images/LogFireTop.png',name = 'LogFireTop'},
	{type = 'image',file = 'Images/LogFireBottom.png',name = 'LogFireBottom'},
	{type = 'image',file = 'Images/StoneLogFire.png',name = 'StoneLogFire'},
	{type = 'image',file = 'Images/StoneLogFireTop.png',name = 'StoneLogFireTop'},
	{type = 'image',file = 'Images/StoneStove.png',name = 'StoneStove'},
	{type = 'image',file = 'Images/StoneStoveBottom.png',name = 'StoneStoveBottom'},
	{type = 'image',file = 'Images/WhiteFlash.png',name = 'Flash'},
	{type = 'image',file = 'Images/BlackFlash.png',name = 'Flash1'},
	{type = 'image',file = 'Images/WhiteFlash.png',name = 'Flash2'},
	{type = 'image',file = 'Images/Connector.png',name = 'Connector'},
	--items
	{type = 'image',file = 'Images/Twig.png',name = 'Twig'},
	{type = 'image',file = 'Images/Stick.png',name = 'Stick'},
	{type = 'image',file = 'Images/ShovelHead.png',name = 'ShovelHead'},
	{type = 'image',file = 'Images/Handle.png',name = 'Handle'},
	{type = 'image',file = 'Images/Vine.png',name = 'Vine'},
	{type = 'image',file = 'Images/BraidedVine.png',name = 'BraidedVine'},
	{type = 'image',file = 'Images/Binding.png',name = 'Binding'},
	{type = 'image',file = 'Images/StoneShards.png',name = 'StoneShards'},

	{type = 'image',file = 'Images/IronBar.png',name = 'IronBar'},
	{type = 'image',file = 'Images/CopperBar.png',name = 'CopperBar'},
	{type = 'image',file = 'Images/BrassBar.png',name = 'BrassBar'},
	--Dark Blocks
	{type = 'image',file = 'Images/GrassDark.png',name = 'GrassDark'},
	{type = 'image',file = 'Images/DirtDark.png',name = 'DirtDark'},
	{type = 'image',file = 'Images/StoneDark.png',name = 'StoneDark'},
	--{file = 'Images/Iron.png',name = 'Iron'},
	{type = 'image',file = 'Images/SandDark.png',name = 'SandDark'},
	--buildings
	{type = 'image',file = 'Images/TownHall.png',name = 'TownHall'},
	{type = 'image',file = 'Images/ToolShop.png',name = 'ToolsShop'},
	{type = 'image',file = 'Images/ToolShopConstruct.png', name = 'ToolsShopConstruct'},
	{type = 'image',file = 'Images/BlackSmith.png',name = 'BlackSmith'},
	{type = 'image',file = 'Images/BlackSmithConstruct.png',name = 'BlackSmithConstruct'},
	{type = 'image',file = 'Images/Market.png',name = 'Market'},
	{type = 'image',file = 'Images/MarketConstruct.png',name = 'MarketConstruct'},
	--UI
	{type = 'image',file = 'Images/Backpack.png',name = 'Backpack'},
	{type = 'image',file = 'Images/ToolsPack.png',name = 'Toolspack'},
	{type = 'image',file = 'Images/ToolSelected.png',name = 'toolSelected'},
	{type = 'image',file = 'Images/MineIcon.png',name = 'mineIcon'},
	{type = 'image',file = 'Images/BuildIcon.png',name = 'buildIcon'},
	{type = 'image',file = 'Images/iconSelected.png',name = 'iconSelect'},
	{type = 'image',file = 'Images/BackpackBackground.png',name = 'backpackBackground'},
	{type = 'image',file = 'Images/BackpackBox.png',name = 'backpackBox'},
	{type = 'image',file = 'Images/HotBarBox.png',name = 'hotBarBox'},
	--menus
	{type = 'image',file = 'Images/TownHallMenu.png',name = 'TownHallMenu'},
	{type = 'image',file = 'Images/BlackSmithMenu.png',name = 'BlackSmithMenu'},
	{type = 'image',file = 'Images/ToolsShopMenu.png',name = 'ToolsShopMenu'},
	{type = 'image',file = 'Images/ShopMenu.png',name = 'ShopMenu'},
	{type = 'image',file = 'Images/SettingsMenu.png',name = 'SettingsMenu'},
	--other
	{type = 'image',file = 'Images/Clouds.png',name = 'Clouds'},
	{type = 'image',file = 'Images/BlurredClouds.png',name = 'BlurredClouds'},
	{type = 'image',file = 'Images/Stars.png',name = 'Stars'},
	{type = 'image',file = 'Images/Gear.png',name = 'Gear'},
	{type = 'image',file = 'Images/Background.png',name = 'Background'},
	--tools
	{type = 'image',file = 'Images/Hand.png',name = 'hand'},
	{type = 'image',file = 'Images/Trowel.png',name = 'WoodenTrowel'},
	{type = 'image',file = 'Images/Trowel.png',name = 'BrassTrowel'},
	--{file = 'Images/TrowelModule.png',name = 'trowelModule'},
	{type = 'image',file = 'Images/Pickaxe.png',name = 'Pickaxe'},
	{type = 'image',file = 'Images/Pickaxe.png',name = 'BrassPickaxe'},
	
	--animations
	{type = 'image',file = 'Images/Player/PlayerStanding.png',subTable = 'playerAnimation',name = 'Standing'},
	{type = 'image',file = 'Images/Player/PlayerStep1.png',subTable = 'playerAnimation',name = 'Step1'},
	{type = 'image',file = 'Images/Player/PlayerStep2.png',subTable = 'playerAnimation',name = 'Step2'},
	{type = 'image',file = 'Images/Player/PlayerStep3.png',subTable = 'playerAnimation',name = 'Step3'},
	{type = 'image',file = 'Images/Player/PlayerStep4.png',subTable = 'playerAnimation',name = 'Step4'},
	{type = 'image',file = 'Images/Player/PlayerStep5.png',subTable = 'playerAnimation',name = 'Step5'},
	{type = 'image',file = 'Images/Player/PlayerStep6.png',subTable = 'playerAnimation',name = 'Step6'},
	{type = 'image',file = 'Images/Player/PlayerStep7.png',subTable = 'playerAnimation',name = 'Step7'},
	{type = 'image',file = 'Images/Player/PlayerStep8.png',subTable = 'playerAnimation',name = 'Step8'},

	{type = 'image',file = 'Images/FireAnimation/Final_00000.png',subTable = 'fireAnimation',name = '1'},
	{type = 'image',file = 'Images/FireAnimation/Final_00001.png',subTable = 'fireAnimation',name = '2'},
	{type = 'image',file = 'Images/FireAnimation/Final_00002.png',subTable = 'fireAnimation',name = '3'},
	{type = 'image',file = 'Images/FireAnimation/Final_00003.png',subTable = 'fireAnimation',name = '4'},
	{type = 'image',file = 'Images/FireAnimation/Final_00004.png',subTable = 'fireAnimation',name = '5'},
	{type = 'image',file = 'Images/FireAnimation/Final_00005.png',subTable = 'fireAnimation',name = '6'},
	{type = 'image',file = 'Images/FireAnimation/Final_00006.png',subTable = 'fireAnimation',name = '7'},
	{type = 'image',file = 'Images/FireAnimation/Final_00007.png',subTable = 'fireAnimation',name = '8'},
	{type = 'image',file = 'Images/FireAnimation/Final_00008.png',subTable = 'fireAnimation',name = '9'},
	{type = 'image',file = 'Images/FireAnimation/Final_00009.png',subTable = 'fireAnimation',name = '10'},
	{type = 'image',file = 'Images/FireAnimation/Final_00010.png',subTable = 'fireAnimation',name = '11'},
	{type = 'image',file = 'Images/FireAnimation/Final_00011.png',subTable = 'fireAnimation',name = '12'},
	{type = 'image',file = 'Images/FireAnimation/Final_00012.png',subTable = 'fireAnimation',name = '13'},
	{type = 'image',file = 'Images/FireAnimation/Final_00013.png',subTable = 'fireAnimation',name = '14'},
	{type = 'image',file = 'Images/FireAnimation/Final_00014.png',subTable = 'fireAnimation',name = '15'},
	{type = 'image',file = 'Images/FireAnimation/Final_00015.png',subTable = 'fireAnimation',name = '16'},
	{type = 'image',file = 'Images/FireAnimation/Final_00016.png',subTable = 'fireAnimation',name = '17'},
	{type = 'image',file = 'Images/FireAnimation/Final_00017.png',subTable = 'fireAnimation',name = '18'},
	{type = 'image',file = 'Images/FireAnimation/Final_00018.png',subTable = 'fireAnimation',name = '19'},
	{type = 'image',file = 'Images/FireAnimation/Final_00019.png',subTable = 'fireAnimation',name = '20'},
	{type = 'image',file = 'Images/FireAnimation/Final_00020.png',subTable = 'fireAnimation',name = '21'},
	{type = 'image',file = 'Images/FireAnimation/Final_00021.png',subTable = 'fireAnimation',name = '22'},
	{type = 'image',file = 'Images/FireAnimation/Final_00022.png',subTable = 'fireAnimation',name = '23'},
	{type = 'image',file = 'Images/FireAnimation/Final_00023.png',subTable = 'fireAnimation',name = '24'},
	{type = 'image',file = 'Images/FireAnimation/Final_00024.png',subTable = 'fireAnimation',name = '25'},
	{type = 'image',file = 'Images/FireAnimation/Final_00025.png',subTable = 'fireAnimation',name = '26'},
	{type = 'image',file = 'Images/FireAnimation/Final_00026.png',subTable = 'fireAnimation',name = '27'},
	{type = 'image',file = 'Images/FireAnimation/Final_00027.png',subTable = 'fireAnimation',name = '28'},
	{type = 'image',file = 'Images/FireAnimation/Final_00028.png',subTable = 'fireAnimation',name = '29'},
	{type = 'image',file = 'Images/FireAnimation/Final_00029.png',subTable = 'fireAnimation',name = '30'},
	{type = 'image',file = 'Images/FireAnimation/Final_00030.png',subTable = 'fireAnimation',name = '31'},
	{type = 'image',file = 'Images/FireAnimation/Final_00031.png',subTable = 'fireAnimation',name = '32'},
	{type = 'image',file = 'Images/FireAnimation/Final_00032.png',subTable = 'fireAnimation',name = '33'},
	{type = 'image',file = 'Images/FireAnimation/Final_00033.png',subTable = 'fireAnimation',name = '34'},
	{type = 'image',file = 'Images/FireAnimation/Final_00034.png',subTable = 'fireAnimation',name = '35'},
	{type = 'image',file = 'Images/FireAnimation/Final_00035.png',subTable = 'fireAnimation',name = '36'},
	{type = 'image',file = 'Images/FireAnimation/Final_00036.png',subTable = 'fireAnimation',name = '37'},
	{type = 'image',file = 'Images/FireAnimation/Final_00037.png',subTable = 'fireAnimation',name = '38'},
	{type = 'image',file = 'Images/FireAnimation/Final_00038.png',subTable = 'fireAnimation',name = '39'},
	{type = 'image',file = 'Images/FireAnimation/Final_00039.png',subTable = 'fireAnimation',name = '40'},
	{type = 'image',file = 'Images/FireAnimation/Final_00040.png',subTable = 'fireAnimation',name = '41'},
	{type = 'image',file = 'Images/FireAnimation/Final_00041.png',subTable = 'fireAnimation',name = '42'},
	{type = 'image',file = 'Images/FireAnimation/Final_00042.png',subTable = 'fireAnimation',name = '43'},
	{type = 'image',file = 'Images/FireAnimation/Final_00043.png',subTable = 'fireAnimation',name = '44'},
	{type = 'image',file = 'Images/FireAnimation/Final_00044.png',subTable = 'fireAnimation',name = '45'},
	{type = 'image',file = 'Images/FireAnimation/Final_00045.png',subTable = 'fireAnimation',name = '46'},
	{type = 'image',file = 'Images/FireAnimation/Final_00046.png',subTable = 'fireAnimation',name = '47'},
	{type = 'image',file = 'Images/FireAnimation/Final_00047.png',subTable = 'fireAnimation',name = '48'},
	{type = 'image',file = 'Images/FireAnimation/Final_00048.png',subTable = 'fireAnimation',name = '49'},
	{type = 'image',file = 'Images/FireAnimation/Final_00049.png',subTable = 'fireAnimation',name = '50'},
	{type = 'image',file = 'Images/FireAnimation/Final_00050.png',subTable = 'fireAnimation',name = '51'},
	{type = 'image',file = 'Images/FireAnimation/Final_00051.png',subTable = 'fireAnimation',name = '52'},
	{type = 'image',file = 'Images/FireAnimation/Final_00052.png',subTable = 'fireAnimation',name = '53'},
	{type = 'image',file = 'Images/FireAnimation/Final_00053.png',subTable = 'fireAnimation',name = '54'},
	{type = 'image',file = 'Images/FireAnimation/Final_00054.png',subTable = 'fireAnimation',name = '55'},
	{type = 'image',file = 'Images/FireAnimation/Final_00055.png',subTable = 'fireAnimation',name = '56'},
	{type = 'image',file = 'Images/FireAnimation/Final_00056.png',subTable = 'fireAnimation',name = '57'},
	{type = 'image',file = 'Images/FireAnimation/Final_00057.png',subTable = 'fireAnimation',name = '58'},
	{type = 'image',file = 'Images/FireAnimation/Final_00058.png',subTable = 'fireAnimation',name = '59'},
	{type = 'image',file = 'Images/FireAnimation/Final_00059.png',subTable = 'fireAnimation',name = '60'},
	{type = 'image',file = 'Images/FireAnimation/Final_00060.png',subTable = 'fireAnimation',name = '61'},
	{type = 'image',file = 'Images/FireAnimation/Final_00061.png',subTable = 'fireAnimation',name = '62'},
	{type = 'image',file = 'Images/FireAnimation/Final_00062.png',subTable = 'fireAnimation',name = '63'},
	{type = 'image',file = 'Images/FireAnimation/Final_00063.png',subTable = 'fireAnimation',name = '64'},
	{type = 'image',file = 'Images/FireAnimation/Final_00064.png',subTable = 'fireAnimation',name = '65'},
	{type = 'image',file = 'Images/FireAnimation/Final_00065.png',subTable = 'fireAnimation',name = '66'},
	{type = 'image',file = 'Images/FireAnimation/Final_00066.png',subTable = 'fireAnimation',name = '67'},
	{type = 'image',file = 'Images/FireAnimation/Final_00067.png',subTable = 'fireAnimation',name = '68'},
	{type = 'image',file = 'Images/FireAnimation/Final_00068.png',subTable = 'fireAnimation',name = '69'},
	{type = 'image',file = 'Images/FireAnimation/Final_00069.png',subTable = 'fireAnimation',name = '70'},
	{type = 'image',file = 'Images/FireAnimation/Final_00070.png',subTable = 'fireAnimation',name = '71'},
	{type = 'image',file = 'Images/FireAnimation/Final_00071.png',subTable = 'fireAnimation',name = '72'},
	{type = 'image',file = 'Images/FireAnimation/Final_00072.png',subTable = 'fireAnimation',name = '73'},
	{type = 'image',file = 'Images/FireAnimation/Final_00073.png',subTable = 'fireAnimation',name = '74'},
	{type = 'image',file = 'Images/FireAnimation/Final_00074.png',subTable = 'fireAnimation',name = '75'},
	{type = 'image',file = 'Images/FireAnimation/Final_00075.png',subTable = 'fireAnimation',name = '76'},
	
	{type = 'image',file = 'Images/Player/PlayerClimb1.png',subTable = 'playerAnimation',name = 'Climb1'},
	{type = 'image',file = 'Images/Player/PlayerClimb2.png',subTable = 'playerAnimation',name = 'Climb2'},
	{type = 'image',file = 'Images/Player/PlayerClimb3.png',subTable = 'playerAnimation',name = 'Climb3'},
	{type = 'image',file = 'Images/Player/PlayerClimb4.png',subTable = 'playerAnimation',name = 'Climb4'},
	{type = 'image',file = 'Images/Player/PlayerClimb5.png',subTable = 'playerAnimation',name = 'Climb5'},
	{type = 'image',file = 'Images/Player/PlayerClimb6.png',subTable = 'playerAnimation',name = 'Climb6'},
	{type = 'image',file = 'Images/Player/PlayerClimb7.png',subTable = 'playerAnimation',name = 'Climb7'},
	{type = 'image',file = 'Images/Player/PlayerClimb8.png',subTable = 'playerAnimation',name = 'Climb8'},
	{type = 'image',file = 'Images/Player/PlayerClimb9.png',subTable = 'playerAnimation',name = 'Climb9'},
	{type = 'image',file = 'Images/Player/PlayerClimb10.png',subTable = 'playerAnimation',name = 'Climb10'},
	{type = 'image',file = 'Images/Player/PlayerClimb11.png',subTable = 'playerAnimation',name = 'Climb11'},
	
	{type = 'image',file = 'Images/BreakingAnimation/0.png',subTable = 'breakingAnimation',name = 'breaking0'},
	{type = 'image',file = 'Images/BreakingAnimation/1.png',subTable = 'breakingAnimation',name = 'breaking1'},
	{type = 'image',file = 'Images/BreakingAnimation/2.png',subTable = 'breakingAnimation',name = 'breaking2'},
	{type = 'image',file = 'Images/BreakingAnimation/3.png',subTable = 'breakingAnimation',name = 'breaking3'},
	{type = 'image',file = 'Images/BreakingAnimation/4.png',subTable = 'breakingAnimation',name = 'breaking4'},
	{type = 'image',file = 'Images/BreakingAnimation/5.png',subTable = 'breakingAnimation',name = 'breaking5'},
	
	{type = 'image',file = 'Images/Player/Hand1.png',subTable = 'playerAnimation',name = 'hand1'},
	{type = 'image',file = 'Images/Player/Hand2.png',subTable = 'playerAnimation',name = 'hand2'},
	{type = 'image',file = 'Images/Player/Hand3.png',subTable = 'playerAnimation',name = 'hand3'},
	{type = 'image',file = 'Images/Player/Hand4.png',subTable = 'playerAnimation',name = 'hand4'},
	{type = 'image',file = 'Images/Player/Hand5.png',subTable = 'playerAnimation',name = 'hand5'},
	{type = 'image',file = 'Images/Player/Hand6.png',subTable = 'playerAnimation',name = 'hand6'},
	{type = 'image',file = 'Images/Player/Hand7.png',subTable = 'playerAnimation',name = 'hand7'},
	{type = 'image',file = 'Images/Player/Hand8.png',subTable = 'playerAnimation',name = 'hand8'},
	{type = 'image',file = 'Images/Player/Hand9.png',subTable = 'playerAnimation',name = 'hand9'},
	{type = 'image',file = 'Images/Player/Hand10.png',subTable = 'playerAnimation',name = 'hand10'},
	{type = 'image',file = 'Images/Player/Hand11.png',subTable = 'playerAnimation',name = 'hand11'},
	
	{type = 'image',file = 'Images/Player/Trowel1.png',subTable = 'playerAnimation',name = 'trowel1'},
	{type = 'image',file = 'Images/Player/Trowel2.png',subTable = 'playerAnimation',name = 'trowel2'},
	{type = 'image',file = 'Images/Player/Trowel3.png',subTable = 'playerAnimation',name = 'trowel3'},
	{type = 'image',file = 'Images/Player/Trowel4.png',subTable = 'playerAnimation',name = 'trowel4'},
	{type = 'image',file = 'Images/Player/Trowel5.png',subTable = 'playerAnimation',name = 'trowel5'},
	{type = 'image',file = 'Images/Player/Trowel6.png',subTable = 'playerAnimation',name = 'trowel6'},
	{type = 'image',file = 'Images/Player/Trowel7.png',subTable = 'playerAnimation',name = 'trowel7'},
	{type = 'image',file = 'Images/Player/Trowel8.png',subTable = 'playerAnimation',name = 'trowel8'},
	{type = 'image',file = 'Images/Player/Trowel9.png',subTable = 'playerAnimation',name = 'trowel9'},
	{type = 'image',file = 'Images/Player/Trowel10.png',subTable = 'playerAnimation',name = 'trowel10'},
	{type = 'image',file = 'Images/Player/Trowel11.png',subTable = 'playerAnimation',name = 'trowel11'},
	
	{type = 'image',file = 'Images/Player/Pickaxe1.png',subTable = 'playerAnimation',name = 'pickaxe1'},
	{type = 'image',file = 'Images/Player/Pickaxe2.png',subTable = 'playerAnimation',name = 'pickaxe2'},
	{type = 'image',file = 'Images/Player/Pickaxe3.png',subTable = 'playerAnimation',name = 'pickaxe3'},
	{type = 'image',file = 'Images/Player/Pickaxe4.png',subTable = 'playerAnimation',name = 'pickaxe4'},
	{type = 'image',file = 'Images/Player/Pickaxe5.png',subTable = 'playerAnimation',name = 'pickaxe5'},
	{type = 'image',file = 'Images/Player/Pickaxe6.png',subTable = 'playerAnimation',name = 'pickaxe6'},
	{type = 'image',file = 'Images/Player/Pickaxe7.png',subTable = 'playerAnimation',name = 'pickaxe7'},
	{type = 'image',file = 'Images/Player/Pickaxe8.png',subTable = 'playerAnimation',name = 'pickaxe8'},
	{type = 'image',file = 'Images/Player/Pickaxe9.png',subTable = 'playerAnimation',name = 'pickaxe9'},
	{type = 'image',file = 'Images/Player/Pickaxe10.png',subTable = 'playerAnimation',name = 'pickaxe10'},
	{type = 'image',file = 'Images/Player/Pickaxe11.png',subTable = 'playerAnimation',name = 'pickaxe11'},
}