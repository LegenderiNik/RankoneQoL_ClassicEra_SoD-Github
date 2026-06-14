-- ============================================================================
-- RankoneQoL - Hauptzentrale (Core Kernel - Profil-Engine)
-- ============================================================================

local L = RankoneQoL_Locals
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")

local function GetCharacterProfileKey()
    local name, server = UnitFullName("player")
    server = server or GetRealmName()
    return name .. " - " .. server
end

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "RankoneQoL" then
        RankoneQoL_DB = RankoneQoL_DB or {}
        RankoneQoL_DB.profiles = RankoneQoL_DB.profiles or {}
        
        local profileKey = GetCharacterProfileKey()
        
        if not RankoneQoL_DB.profiles[profileKey] then
            RankoneQoL_DB.profiles[profileKey] = {
                autoSell = true,
                autoRepair = true,
                autoQuest = true,
                autoLoot = true,
                autoCinematic = true,
                speedFlight = true,
                speedHearth = true,
                speedGossip = true,
                menuFont = "WoW Friz Quadrata",
                menuFontSize = 12,
                tooltipScale = 1.0,
                menuTheme = "neon_cyan", -- FIX: Neues Standard-Theme hinterlegt!
                minimapPos = 45
            }
        else
            local p = RankoneQoL_DB.profiles[profileKey]
            if p.autoSell == nil then p.autoSell = true end
            if p.autoRepair == nil then p.autoRepair = true end
            if p.autoQuest == nil then p.autoQuest = true end
            if p.autoLoot == nil then p.autoLoot = true end
            if p.autoCinematic == nil then p.autoCinematic = true end
            if p.speedFlight == nil then p.speedFlight = true end
            if p.speedHearth == nil then p.speedHearth = true end
            if p.speedGossip == nil then p.speedGossip = true end
            if p.tooltipScale == nil then p.tooltipScale = 1.0 end
            if p.menuTheme == nil then p.menuTheme = "neon_cyan" end -- FIX: Absicherung bei Updates
            if p.menuFont == nil then p.menuFont = "WoW Friz Quadrata" end
            if p.menuFontSize == nil then p.menuFontSize = 12 end
            if p.minimapPos == nil then p.minimapPos = 45 end
        end
        
        RankoneQoL_Profile = RankoneQoL_DB.profiles[profileKey]
        self:UnregisterEvent("ADDON_LOADED")
        
    elseif event == "PLAYER_LOGIN" then
        print(L["WELCOME_MSG"])
    end
end)

-- ============================================================================
-- SLASH-BEFEHLE (CHAT-KOMMANDOS)
-- ============================================================================
SLASH_RANKONEQOL1 = "/rqol"
SLASH_RANKONEQOL2 = "/rankone"

SlashCmdList["RANKONEQOL"] = function()
    if RankoneQoL_ToggleUI then
        RankoneQoL_ToggleUI()
    end
end
