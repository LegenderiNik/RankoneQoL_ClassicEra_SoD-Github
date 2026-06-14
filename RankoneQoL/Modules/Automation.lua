-- ============================================================================
-- RankoneQoL - Modul: Automation (Verkaufs-Fix für SoD)
-- ============================================================================

local L = RankoneQoL_Locals
local frame = CreateFrame("Frame")

frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("GOSSIP_SHOW")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_PROGRESS")
frame:RegisterEvent("QUEST_COMPLETE")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("CINEMATIC_START")

local function FormatMoneyWithIcons(totalCopper)
    if not totalCopper or totalCopper <= 0 then return "0 |TInterface\\MoneyFrame\\UI-CopperIcon:0|t" end
    local gold = math.floor(totalCopper / 10000)
    local silver = math.floor((totalCopper - (gold * 10000)) / 100)
    local copper = totalCopper % 100
    local result = ""
    if gold > 0 then result = result .. gold .. " |TInterface\\MoneyFrame\\UI-GoldIcon:0|t " end
    if silver > 0 then result = result .. silver .. " |TInterface\\MoneyFrame\\UI-SilverIcon:0|t " end
    if copper > 0 or result == "" then result = result .. copper .. " |TInterface\\MoneyFrame\\UI-CopperIcon:0|t" end
    return result
end

frame:SetScript("OnEvent", function(self, event, ...)
    if not RankoneQoL_Profile then return end

    -- ============================================================================
    -- HÄNDLER-LOGIK (VERKAUF & REPARATUR)
    -- ============================================================================
    if event == "MERCHANT_SHOW" then
        -- 1. Automatisches Reparieren
        if RankoneQoL_Profile.autoRepair and CanMerchantRepair() then
            local repairCost, canRepair = GetRepairAllCost()
            if canRepair and repairCost > 0 then
                if GetMoney() >= repairCost then
                    RepairAllItems()
                    local formattedPrice = FormatMoneyWithIcons(repairCost)
                    print(string.format(L["CHAT_REPAIR_SUCCESS"], formattedPrice))
                else
                    print(L["CHAT_REPAIR_ERROR"])
                end
            end
        end
        
        -- 2. Automatischer Schrottverkauf (Klassischer GetItemInfo-Fix für SoD)
        if RankoneQoL_Profile.autoSell then
            local totalProfit = 0
            for bag = 0, 4 do
                local numSlots = C_Container.GetContainerNumSlots(bag)
                if numSlots and numSlots > 0 then
                    for slot = 1, numSlots do
                        local info = C_Container.GetContainerItemInfo(bag, slot)
                        if info and info.hyperlink and info.quality == 0 then
                            -- Nutzt den klassischen, robusten Aufruf für den Classic-Client
                            local _, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(info.hyperlink)
                            
                            -- Falls GetItemInfo verzögert ist, versuchen wir den Fallback auf info.price
                            itemSellPrice = itemSellPrice or info.price
                            
                            if itemSellPrice and itemSellPrice > 0 then
                                totalProfit = totalProfit + (itemSellPrice * info.stackCount)
                                C_Container.UseContainerItem(bag, slot)
                            end
                        end
                    end
                end
            end
            if totalProfit > 0 then
                local formattedProfit = FormatMoneyWithIcons(totalProfit)
                print(string.format(L["CHAT_SELL_SUCCESS"], formattedProfit))
            end
        end

    -- ============================================================================
    -- AUTOMATISCHE BEUTE-EINNAHME (AUTO-LOOT ENGINE)
    -- ============================================================================
    elseif event == "LOOT_READY" then
        if RankoneQoL_Profile.autoLoot then
            local numItems = GetNumLootItems()
            if numItems and numItems > 0 then
                for i = numItems, 1, -1 do
                    LootSlot(i)
                end
            end
        end

    -- ============================================================================
    -- FILMSEQUENZEN ÜBERSPRINGEN
    -- ============================================================================
    elseif event == "CINEMATIC_START" then
        if RankoneQoL_Profile.autoCinematic then
            if CinematicFrame and CinematicFrame:IsShown() then
                CinematicFrame_CancelCinematic()
            end
        end

    -- ============================================================================
    -- QUEST-LOGIK (AUTOMATISIERUNG)
    -- ============================================================================
    elseif RankoneQoL_Profile.autoQuest then
        if event == "GOSSIP_SHOW" then
            local activeQuests = C_GossipInfo.GetActiveQuests()
            if activeQuests then
                for _, questInfo in ipairs(activeQuests) do
                    if questInfo.isComplete then
                        C_GossipInfo.SelectActiveQuest(questInfo.questID)
                        return
                    end
                end
            end
            
            local availableQuests = C_GossipInfo.GetAvailableQuests()
            if availableQuests then
                for _, questInfo in ipairs(availableQuests) do
                    if not C_QuestLog.IsQuestInQuestLog(questInfo.questID) then
                        C_GossipInfo.SelectAvailableQuest(questInfo.questID)
                        return
                    end
                end
            end

            local options = C_GossipInfo.GetOptions()
            if options then
                for _, optionInfo in ipairs(options) do
                    if optionInfo.type == "vendor" or optionInfo.status == "vendor" then
                        C_GossipInfo.SelectOption(optionInfo.gossipOptionID)
                        return
                    end
                end
            end

        elseif event == "QUEST_DETAIL" then
            AcceptQuest()

        elseif event == "QUEST_PROGRESS" then
            if IsQuestCompletable() then
                CompleteQuest()
            end

        elseif event == "QUEST_COMPLETE" then
            if GetNumQuestChoices() > 1 then
                print(L["CHAT_QUEST_REWARD_WARNING"])
            else
                GetQuestReward(GetNumQuestChoices() == 1 and 1 or 0)
            end
        end
    end
end)
