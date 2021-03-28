-- Small helpers similar to those found in "metastruct/preinit.lua" of the metastruct repo
local function includeShared(f)
	if SERVER then AddCSLuaFile(f..".lua") end
	include(f..".lua")
end

local function includeClient(f)
	if SERVER then
		AddCSLuaFile(f..".lua")
	else
		include(f..".lua")
	end
end

local function includeServer(f)
	if SERVER then include(f..".lua") end
end

local guiFiles = {}

local function includeGuiFile(f)
	if SERVER then
		AddCSLuaFile(f..".lua")
	else
		guiFiles[#guiFiles+1] = f..".lua"
	end
end

local tag = "ms.Ores.IncludeGui"
hook.Add("InitPostEntity",tag,function()
	for k,v in next,guiFiles do
		include(v)
	end

	hook.Remove("InitPostEntity",tag)
end)

-- File initialisation starts here...
includeShared("mining/logic/sh_ores")
includeServer("mining/logic/sv_ores")
includeShared("mining/logic/sh_miner")
includeServer("mining/logic/sv_miner")
includeShared("mining/logic/sh_pickaxe")
includeServer("mining/logic/sv_pickaxe")
includeServer("mining/logic/sv_rock_spawning")
includeServer("mining/logic/sv_savedata")
includeServer("mining/logic/sv_settings")
includeServer("mining/logic/sv_special_days")
includeClient("mining/logic/cl_settings")
includeGuiFile("mining/gui/miner_menu")
includeServer("mining/logic/sv_anticheat")
