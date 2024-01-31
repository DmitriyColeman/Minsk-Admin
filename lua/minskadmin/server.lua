--[[
    by Dmitriy Coleman AKA ZloyNomernoy (vk.com/c.zombie)
    License: MIT
]]

-- ULIB TEST
--[[if not ULib then 
    MsgC(Color(255,0,0), "ALERT! YA NE PRIDUMAL CHTO SUDA PISAT")
end]]

util.AddNetworkString("minskadmin.action")
util.AddNetworkString("minskadmin.open")
util.AddNetworkString("minskadmin.openRequest")
util.AddNetworkString("minskadmin.update")

local uptodate = false

minskadmin.gData = {}
minskadmin.gData.lights = {}
minskadmin.gData.feeders = {}

--[[
    1.0 - 1
    1.1 - 2
    1.1.1 - 3
    1.1.2 - 4
]]

minskadmin.versionID = 4

do 
    if not file.Exists("minskadmin","DATA") then
        file.CreateDir("minskadmin")
    end

    for i, k in pairs(peregons) do 
        minskadmin.gData.lights[k] = {}
        minskadmin.gData.feeders[k] = {}
    
        minskadmin.gData.lights[k][1] = false
        minskadmin.gData.lights[k][2] = false
        minskadmin.gData.feeders[k][1] = false 
        minskadmin.gData.feeders[k][2] = false
    end 
end

local function HasPermission(ply,permission)
	if ULib then
		return ULib.ucl.query(ply,permission)
	end
	return ply:IsSuperAdmin()
end

function minskadmin:storePeregonsData()
    return minskadmin.gData 
end 

function minskadmin.Log(str)
	file.Append("minskadmin/log.txt","["..os.date("%X - %d/%m/%Y",os.time()).."] "..str.."\r\n")
end

function minskadmin:getFeederIDByName(name)
    for i, k in ipairs(peregonsAssoc) do 
        if k[2] == name then 
            return i+1
        end 
    end
end 

net.Receive("minskadmin.action", function(len, ply)
    local action = net.ReadInt(5)
    local num = net.ReadInt(5)
    local affect = net.ReadTable()
    if not HasPermission(ply, "madm.menu") then return end 
    if action == 1 then 
        for i, k in pairs(affect) do    
            RunConsoleCommand("minsk_tunnel_light_"..(minskadmin.gData.lights[k][num] and "off" or "on"), tostring(k), tostring(num))
            minskadmin.gData.lights[k][num] = not minskadmin.gData.lights[k][num] 
            minskadmin.Log(ply:Nick().." toggle "..(minskadmin.gData.lights[k][num] and "on" or "off").." lights in "..k.." ("..num..")")
        end 
        net.Start("minskadmin.update")
            net.WriteTable(minskadmin:storePeregonsData())
        net.Send(ply)
    --elseif action == 2 then   
    end 
end)

net.Receive("minskadmin.openRequest", function(len, ply)
    if not HasPermission(ply, "madm.menu") then return end 
    net.Start("minskadmin.Open")
        net.WriteTable(minskadmin:storePeregonsData())
    net.Send(ply)
end)

local function GetBranch()

    return "github"
end 

hook.Add("InitPostEntity","MinskAdminInit",function()
	if ULib then
		ULib.ucl.registerAccess("madm.menu", "superadmin", "Возможность открывать меню админки.", "Minsk admin")
	elseif CAMI then
		CAMI.RegisterPrivilege({Name="madm.menu",MinAccess="superadmin"})
	end
    timer.Simple(5, function()
        http.Post("https://api.dcoleman.ru/madmin/start",  {
            hostname = GetConVar( "hostname" ):GetString(),
            branch = GetBranch()
        },
            function(body,len,headers,code)
                if code == 200 then
                    body = util.JSONToTable(body)
                    if not body or body.error then 
                        local str = "Request error 'start'. (Code = "..code..") [BAD BODY]"
                        print("[MINSK ADMIN]: "..str)
                        minskadmin.Log(str)
                    else 
                        if body.data.versionID == tostring(minskadmin.versionID) then 
                            print("[Minsk admin]: You use last version")
							uptodate = true
                        else 
                            print(("[Minsk admin]: Update available (Version: %s, Branch: %s, VersionID: %s)"):format(body.data.version, body.data.branch, body.data.versionID))
                        end 
                    end 
                else
                    local str = "Request error 'start'. (Code = "..code..")"
                    print("[MINSK ADMIN]: "..str)
                    minskadmin.Log(str)
                end
            end
        )
    end)
end)
