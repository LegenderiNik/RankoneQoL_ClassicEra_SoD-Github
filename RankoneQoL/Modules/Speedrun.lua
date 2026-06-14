-- ============================================================================
-- RankoneQoL - Modul: Speedrun Interactions (Gossip & Flightmaster Core Fixed)
-- ============================================================================

local frame = CreateFrame("Frame")
frame:RegisterEvent("GOSSIP_SHOW")

frame:SetScript("OnEvent", function(self, event, ...)
    if not RankoneQoL_Profile then return end

    -- ============================================================================
    -- NPC INTERAKTIONEN (GOSSIP & FLUGMEISTER)
    -- ============================================================================
    if event == "GOSSIP_SHOW" then
        local activeQuests = C_GossipInfo.GetActiveQuests()
        local availableQuests = C_GossipInfo.GetAvailableQuests()
        
        -- INTELLIGENTE LOGIK: Wenn Quests da sind, brechen wir SOFORT ab!
        if (activeQuests and #activeQuests > 0) or (availableQuests and #availableQuests > 0) then
            return
        end

        local options = C_GossipInfo.GetOptions()
        if not options or #options == 0 then return end

        -- A) INTELLIGENTER FLUGMEISTER-SKIP
        if RankoneQoL_Profile.speedFlight then
            for _, optionInfo in ipairs(options) do
                local lowerText = string.lower(optionInfo.name or optionInfo.text or "")
                local optionType = optionInfo.type or optionInfo.status or ""
                
                -- Sucht nach dem Taxi-Typ ODER nach den Signalwörtern im Text
                if optionType == "taxi" or optionType == "status" or string.find(lowerText, "ride") or string.find(lowerText, "flug") then
                    if optionInfo.gossipOptionID then
                        C_GossipInfo.SelectOption(optionInfo.gossipOptionID)
                        return
                    end
                end
            end
        end

        -- B) EINFACHE DIALOGE AUTOMATISCH ÜBERSPRINGEN (GOSSIP SKIPPER)
        if RankoneQoL_Profile.speedGossip then
            -- Wenn exakt nur eine einzige Dialog-Option existiert
            if #options == 1 then
                local firstOption = options[1] -- FIX: Korrekter Index-Zugriff auf den ersten Eintrag!
                if firstOption and firstOption.gossipOptionID then
                    local optionType = firstOption.type or firstOption.status or ""
                    
                    -- Verhindert, dass Händler, Banken oder der Ruhestein unkontrolliert geklickt werden
                    if optionType ~= "vendor" and optionType ~= "bank" and optionType ~= "binder" then
                        C_GossipInfo.SelectOption(firstOption.gossipOptionID)
                        return
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- BRUTE FORCE TEXT KLICKER (Fängt das Ruhestein-Fenster ab)
-- ============================================================================
local scanFrame = CreateFrame("Frame")
scanFrame:SetScript("OnUpdate", function(self, elapsed)
    if not RankoneQoL_Profile or not RankoneQoL_Profile.speedHearth then return end
    
    for i = 1, 4 do
        local popup = _G["StaticPopup"..i]
        if popup and popup:IsShown() then
            local textFrame = _G["StaticPopup"..i.."Text"]
            if textFrame and textFrame:GetText() then
                local currentText = string.lower(textFrame:GetText())
                if string.find(currentText, "new home") or string.find(currentText, "heimatort") then
                    local acceptButton = _G["StaticPopup"..i.."Button1"]
                    if acceptButton and acceptButton:IsShown() and acceptButton:IsEnabled() then
                        acceptButton:Click()
                    end
                end
            end
        end
    end
end)
