-- ============================================================================
-- RankoneQoL - Modul: Core Automation Logic (Auto-Loot Engine Fixed)
-- ============================================================================

local L = RankoneQoL_Locals

local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("QUEST_GREETING")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_PROGRESS")
frame:RegisterEvent("QUEST_COMPLETE")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("CINEMATIC_START")
frame:RegisterEvent("PLAY_MOVIE")
frame:RegisterEvent("GOSSIP_SHOW")

frame:SetScript("OnEvent", function(self, event, ...)
    if not RankoneQoL_Profile then return end

    -- ============================================================================
    -- 1. HÄNDLER-AUTOMATION (AUTO-SELL & AUTO-REPAIR)
    -- ============================================================================
    if event == "MERCHANT_SHOW" then
        -- A) AUTOMATISCH GRAUEN SCHROTT VERKAUFEN
        if RankoneQoL_Profile.autoSell then
            local totalGoldGained = 0
            for bag = 0, 4 do
                for slot = 1, C_Container.GetContainerNumSlots(bag) do
                    local itemInfo = C_Container.GetContainerItemInfo(bag, slot)
                    if itemInfo and itemInfo.quality == 0 then -- 0 = Poor (Grey Junk)
                        local _, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemInfo.hyperlink)
                        if itemSellPrice and itemSellPrice > 0 then
                            totalGoldGained = totalGoldGained + (itemSellPrice * itemInfo.stackCount)
                            C_Container.UseContainerItem(bag, slot)
                        end
                    end
                end
            end
            if totalGoldGained > 0 then
                print(string.format(L["CHAT_SELL_SUCCESS"], GetCoinTextureString(totalGoldGained)))
            end
        end

        -- B) AUTOMATISCH AUSRÜSTUNG REPARIEREN
        if RankoneQoL_Profile.autoRepair and CanMerchantRepair() then
            local repairCost, canRepair = GetRepairAllCost()
            if canRepair and repairCost > 0 then
                if GetMoney() >= repairCost then
                    RepairAllItems(false)
                    print(string.format(L["CHAT_REPAIR_SUCCESS"], GetCoinTextureString(repairCost)))
                else
                    print(L["CHAT_REPAIR_ERROR"])
                end
            end
        end
    end

    -- ============================================================================
    -- 2. QUEST-AUTOMATION CORE ENGINE
    -- ============================================================================
    if event == "GOSSIP_SHOW" then
        if not RankoneQoL_Profile.autoQuest then return end
        
        local availableQuests = C_GossipInfo.GetAvailableQuests()
        if availableQuests then
            for _, questInfo in ipairs(availableQuests) do
                if questInfo.questID and not questInfo.isTrivial then
                    C_GossipInfo.SelectAvailableQuest(questInfo.questID)
                    return
                end
            end
        end

        local activeQuests = C_GossipInfo.GetActiveQuests()
        if activeQuests then
            for _, questInfo in ipairs(activeQuests) do
                if questInfo.questID and C_QuestLog.IsOnQuest(questInfo.questID) then
                    C_GossipInfo.SelectActiveQuest(questInfo.questID)
                    return
                end
            end
        end

    elseif event == "QUEST_GREETING" then
        if not RankoneQoL_Profile.autoQuest then return end
        local numActive = GetNumActiveQuests()
        local numAvailable = GetNumAvailableQuests()
        
        if numAvailable > 0 then
            SelectAvailableQuest(1)
        elseif numActive > 0 then
            SelectActiveQuest(1)
        end

    elseif event == "QUEST_DETAIL" then
        if RankoneQoL_Profile.autoQuest then
            AcceptQuest()
        end

    elseif event == "QUEST_PROGRESS" then
        if RankoneQoL_Profile.autoQuest and IsQuestCompletable() then
            CompleteQuest()
        end

    elseif event == "QUEST_COMPLETE" then
        if not RankoneQoL_Profile.autoQuest then return end
        
        if GetNumQuestChoices() > 1 then
            print(L["CHAT_QUEST_REWARD_WARNING"])
            return
        end
        
        GetQuestReward(1)

    -- ============================================================================
    -- 3. SCHNELLE BEUTE-BESCHLEUNIGUNG (FIX: Erzwingt Beuteaufnahme bedingungslos!)
    -- ============================================================================
    elseif event == "LOOT_READY" then
        if RankoneQoL_Profile.autoLoot then
            local numItems = GetNumLootItems()
            if numItems and numItems > 0 then
                for i = 1, numItems do
                    LootSlot(i)
                end
            end
        end

    -- ============================================================================
    -- 4. CINEMATIC & MOVIE AUTOSKIP PROTOCOL
    -- ============================================================================
    elseif event == "CINEMATIC_START" then
        if RankoneQoL_Profile.autoCinematic then
            CinematicFrame_CancelCinematic()
        end

    elseif event == "PLAY_MOVIE" then
        if RankoneQoL_Profile.autoCinematic then
            MovieFrame_CancelMovie()
        end
    end
end)
