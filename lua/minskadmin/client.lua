--[[
    by Dmitriy Coleman AKA ZloyNomernoy (vk.com/c.zombie)
    License: MIT

    Сука, я в рот ебал все эти ваши Derma дизайнеры
]]
menubutton = KEY_F3

local function T(phrase, ...)
	return string.format(Metrostroi.GetPhrase(phrase), ...)
end

local function HasPermission(permission)
	local ply = LocalPlayer()
	if ULib then
		return ULib.ucl.query(ply,permission)
	end
	return ply:IsSuperAdmin()
end

local function ShowMenu(data, forceOpen)
    if forceOpen then 
        if IsValid(menu) then menu:Remove() end
    end 
    if not IsValid(menu) then
        menu = vgui.Create("DFrame")
        menu:SetTitle("Minsk 1986 Admin")
        menu:SetPos( 0, 0 )
        menu:SetSize( 0.45607613469985 * ScrW(), 0.44921875 * ScrH() )
        menu:MakePopup() 
        menu:Center()

        local w, t = menu:GetWide(), menu:GetTall()

        tr = vgui.Create( "DListView", menu )
        tr:SetPos( 0.0096308186195827 * w, 0.078260869565217 * t )
        tr:SetSize( 0.69983948635634 * w, 0.90724637681159 * t )
        
        tr:SetMultiSelect(true)
        tr:AddColumn(T("minskadmin.line")):SetFixedWidth(300)
        tr:AddColumn(T("minskadmin.lightingStatus"))
        --tr:AddColumn("Напряжение")
        for i, k in ipairs(peregonsAssoc) do 
            local light = "?"
            local voltage = "?"
            local name = k[2]
            if data.lights and data.lights[name] then 
                light = "1: "..(data.lights[name][1] and T("minskadmin.on") or T("minskadmin.off")).." 2: "..(data.lights[name][2] and T("minskadmin.on") or T("minskadmin.off")) -- пример: 1: вкл, 2: откл
                --voltage = data[name].voltage
            end 
            local l = tr:AddLine(k[1], light)
            l.name = name
        end 

        local light1 = vgui.Create( "DButton", menu )
        light1:SetPos( 0.74959871589085 * w, 0.14202898550725 * t )
        light1:SetSize( 0.21669341894061 * w, 0.063768115942029 * t )
        light1:SetText(T("minskadmin.1stline"))

        light1.DoClick = function()
            local sel = tr:GetSelected()
            local out = {}
            for i, k in pairs(sel) do 
                table.insert(out, k.name)
            end  
            net.Start("minskadmin.action")
				net.WriteInt(1,5)
                net.WriteInt(1,5)
				net.WriteTable(out)
			net.SendToServer()
        end 

        local light2 = vgui.Create( "DButton", menu )
        light2:SetPos( 0.74959871589085 * w, 0.23768115942029 * t )
        light2:SetSize( 0.21669341894061 * w, 0.063768115942029 * t )
        light2:SetText(T("minskadmin.2ndline"))

        light2.DoClick = function()
            local sel = tr:GetSelected()
            local out = {}
            for i, k in pairs(sel) do 
                table.insert(out, k.name)
            end  
            net.Start("minskadmin.action")
				net.WriteInt(1,5)
                net.WriteInt(2,5)
				net.WriteTable(out)
			net.SendToServer()
        end 

        local e = vgui.Create( "DLabel", menu )
        e:SetPos( 0.74959871589085 * w, 0.078260869565217 * t )
        e:SetSize( 0.18459069020867 * w, 0.057971014492754 * t )
        e:SetText(T("minskadmin.lighting"))

        --[[local e = vgui.Create( "DLabel", menu )
        e:SetPos( 0.74959871589085 * w, 0.3304347826087 * t )
        e:SetSize( 0.18459069020867 * w, 0.057971014492754 * t )
        e:SetText("Фидеры")

        local fider1 = vgui.Create( "DButton", menu )
        fider1:SetPos( 0.74959871589085 * w, 0.4231884057971 * t )
        fider1:SetSize( 0.21669341894061 * w, 0.063768115942029 * t )
        fider1:SetText("Фидеры по 1 пути")

        local fider2 = vgui.Create( "DButton", menu )
        fider2:SetPos( 0.74959871589085 * w, 0.51304347826087 * t )
        fider2:SetSize( 0.21669341894061 * w, 0.063768115942029 * t )
        fider2:SetText("Фидеры по 2 пути")
        
        fider1.DoClick = function()
            local sel = tr:GetSelected()
            local out = {}
            for i, k in pairs(sel) do 
                table.insert(out, k.name)
            end  
            net.Start("minskadmin.action")
				net.WriteInt(2,5)
                net.WriteInt(1,5)
				net.WriteTable(out)
			net.SendToServer()
        end 
        fider2.DoClick = function()
            local sel = tr:GetSelected()
            local out = {}
            for i, k in pairs(sel) do 
                table.insert(out, k.name)
            end  
            net.Start("minskadmin.action")
				net.WriteInt(2,5)
                net.WriteInt(2,5)
				net.WriteTable(out)
			net.SendToServer()
        end ]]
    else 
        menu:Remove()
    end 
end 

net.Receive("minskadmin.open", function()
	local data = net.ReadTable()
    if IsValid(menu) then menu:Remove() return end
    ShowMenu(data, false)
end)

net.Receive("minskadmin.update", function()
	local data = net.ReadTable()
    ShowMenu(data, true)
end)

hook.Add("PlayerButtonDown","MinskAdminMenuOpenRequest",function(ply,key)

	if key == menubutton then

        --if IsValid(menu) then menu:Remove() return end
		if HasPermission("madm.menu") then
			net.Start("minskadmin.openRequest")
			net.SendToServer()
		end
	end
end)

return true