-- ============================================================================
-- RankoneQoL - Hauptzentrale (Core Kernel - Profil-Engine & Localization Sync)
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

-- Hilfsfunktion für die exakten Standard-Werkseinstellungen
local function GetDefaultSettings()
    return {
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
        menuTheme = "neon_cyan",
        minimapPos = 210, -- FIX: Von 45 auf 210 verschoben, damit der Button unten links startet und nicht hinter dem Mond versteckt ist!
        flightTimes = {}
    }
end

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "RankoneQoL" then
        RankoneQoL_DB = RankoneQoL_DB or {}
        RankoneQoL_DB.profiles = RankoneQoL_DB.profiles or {}
        
        local profileKey = GetCharacterProfileKey()
        
        if not RankoneQoL_DB.profiles[profileKey] then
            RankoneQoL_DB.profiles[profileKey] = GetDefaultSettings()
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
            if p.menuTheme == nil then p.menuTheme = "neon_cyan" end
            if p.menuFont == nil then p.menuFont = "WoW Friz Quadrata" end
            if p.menuFontSize == nil then p.menuFontSize = 12 end
            if p.minimapPos == nil then p.minimapPos = 210 end -- FIX: Absicherung bei Updates
            if p.flightTimes == nil then p.flightTimes = {} end
        end
        
        RankoneQoL_Profile = RankoneQoL_DB.profiles[profileKey]
        self:UnregisterEvent("ADDON_LOADED")
        
    elseif event == "PLAYER_LOGIN" then
        print(L["WELCOME_MSG"])
    end
end)

-- ============================================================================
-- SLASH-BEFEHLE (CHAT-KOMMANDOS INKLUSIVE LOKALISIERTER ENGINES)
-- ============================================================================
SLASH_RANKONEQOL1 = "/rqol"
SLASH_RANKONEQOL2 = "/rankone"

SlashCmdList["RANKONEQOL"] = function(msg)
    local cleanedMsg = msg and string.lower(string.trim(msg)) or ""

    -- 1. LOKALISIERTER PROFIL-RESET BEFEHL
    if cleanedMsg == "reset" then
        local profileKey = GetCharacterProfileKey()
        if RankoneQoL_DB and RankoneQoL_DB.profiles and RankoneQoL_DB.profiles[profileKey] then
            RankoneQoL_DB.profiles[profileKey] = GetDefaultSettings()
            print(L["CHAT_RESET_SUCCESS"])
            C_UI.Reload()
        end

    -- 2. LOKALISIERTER HILFE-BEFEHL (/rqol help oder /rqol hilfe)
    elseif cleanedMsg == "help" or cleanedMsg == "hilfe" then
        print(L["HELP_HEADER"])
        print(L["HELP_CMD_MAIN"])
        print(L["HELP_CMD_HELP"])
        print(L["HELP_CMD_RESET"])

    -- 3. STANDARD: ÖFFNET DAS MENÜ
    else
        if RankoneQoL_ToggleUI then
            RankoneQoL_ToggleUI()
        end
    end
end
