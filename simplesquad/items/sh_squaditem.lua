ITEM.name = "Squad Identification Device"
ITEM.description = "A device that allows for easy identification of squad members."
ITEM.model = "models/Items/battery.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Utility"
ITEM.functions.create = {
    name = "Create Squad",
    icon = "icon16/asterisk_yellow.png",
    OnRun = function(item, data)
        net.Start("CreateSquad")
        net.Send(item.player)
        return false
    end
}
ITEM.functions.join = {
	name = "Join Squad",
	icon = "icon16/add.png",
	OnRun = function(item, data)
		net.Start("JoinSquad")
            net.WriteTable(ix.squadsystem.squads)
        net.Send(item.player)
		return false
	end
}
ITEM.functions.manage = {
    name = "Manage Squad",
    icon = "icon16/wrench.png",
    OnRun = function(item, data)
        local char = item.player:GetCharacter()
        local squadName = char:GetSquad() or nil
        local squad = ix.squadsystem.squads[squadName] or nil
        if (squad) and (squad[1].member == item.player) then
            net.Start("ManageSquad")
            net.Send(item.player)
        else
            item.player:Notify("You are not a squad leader.")
        end
        return false
    end
}
ITEM.functions.leave = {
    name = "Leave Squad",
    icon = "icon16/delete.png",
    OnRun = function(item, data)
        ix.squadsystem.LeaveSquad(item.player)
        return false
    end
}
ITEM.functions.setcolor = {
    name = "Set Color",
    icon = "icon16/color_wheel.png",
    isMulti = true,
    multiOptions = function(item, ply)
        options = {
            {
                name = "Red",
                data = {
                    color = "red"
                }
            },
            {
                name = "Blue",
                data = {
                    color = "blue"
                }
            },
            {
                name = "Green",
                data = {
                    color = "green"
                }
            },
            {
                name = "Yellow",
                data = {
                    color = "yellow"
                }
            },
            {
                name = "White",
                data = {
                    color = "white"
                }
            }
        }

        return options
    end,
    OnRun = function(item, data)
        item.player:GetCharacter():SetSquadColor(data.color)
        return false
    end
}

ITEM.functions.seticon = {
    name = "Set Icon",
    icon = "icon16/arrow_refresh.png",
    isMulti = true,
    multiOptions = function(item, ply)
        options = {
            {
                name = "Team Leader",
                data = {
                    icon = "tl"
                }
            },
            {
                name = "Marksman",
                data = {
                    icon = "dmr"
                }
            },
            {
                name = "Squad Automatic Weapon",
                data = {
                    icon = "saw"
                }
            },
            {
                name = "Engineer",
                data = {
                    icon = "eng"
                }
            },
            {
                name = "Medic",
                data = {
                    icon = "med"
                }
            },
            {
                name = "None",
                data = {
                    icon = "none"
                }
            }
        }

        return options
    end,
    OnRun = function(item, data)
        local client = item.player
        local char = client:GetCharacter()
        local squadinfo = char:GetData("squadInfo")
        local icon = squadinfo["icon"]

        if ( icon ) and ( icon != "lead" ) then
           char:SetSquadIcon(data.icon)
        elseif ( icon ) and ( icon == "lead") then
            client:Notify("You can not change your icon, you are a squad leader.")
        else
            client:Notify("You can not change your icon.")
        end

        return false
    end
} 