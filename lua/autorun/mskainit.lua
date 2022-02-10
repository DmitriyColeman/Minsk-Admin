--[[
    by Dmitriy Coleman AKA ZloyNomernoy (vk.com/c.zombie)
    License: MIT
]]

if not Metrostroi or not Metrostroi.Version or Metrostroi.Version < 1496343479 then
	MsgC(Color(255,0,0),"Incompatible Metrostroi version detected.\nMinsk admin will not be loaded.\n")
	return
end

if (game.GetMap() != "gm_metro_minsk_1984") then return end

peregons = {
    ["ССВ ТЧ-1 - Институт Культуры"] = "ssv",
    ["Институт Культуры - Площадь Ленина"] = "ik-pl",
    ["Площадь Ленина - Октябрьская"] = "pl-okt",
    ["Октябрьская - Площадь Победы"] = "okt-pp",
    ["Площадь Победы - Площадь Якуба Коласа"] = "pp-jk",
    ["Площадь Якуба Коласа - Академия Наук"] = "jk-an",
    ["Академия Наук - Парк Челюскинцев"] = "an-pch",
    ["Парк Челюскинцев - Московская"] = "pch-ms" 
}

peregonsAssoc = {
    [1] = {"ССВ ТЧ-1 - Институт Культуры", "ssv"},
    [2] = {"Институт Культуры - Площадь Ленина", "ik-pl"},
    [3] = {"Площадь Ленина - Октябрьская", "pl-okt"},
    [4] = {"Октябрьская - Площадь Победы", "okt-pp"},
    [5] = {"Площадь Победы - Площадь Якуба Коласа", "pp-jk"},
    [6] = {"Площадь Якуба Коласа - Академия Наук", "jk-an"},
    [7] = {"Академия Наук - Парк Челюскинцев", "an-pch"},
    [8] = {"Парк Челюскинцев - Московская", "pch-ms"},
}
minskadmin = minskadmin or {}

if SERVER then 
    AddCSLuaFile("minskadmin/client.lua")
    include("minskadmin/server.lua")
else 
    include("minskadmin/client.lua")
end 