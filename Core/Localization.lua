-- ============================================================================
-- RankoneQoL - Lokalisierung (Zentrales Sprachpaket & Vorlagen)
-- ============================================================================

RankoneQoL_Locals = {}

local L = setmetatable({}, {
    __index = function(t, k) return k end
})

-- ============================================================================
-- [1. ENGLISCHE TEXTE] - Standard-Client (enUS / enGB)
-- ============================================================================

-- A) SYSTEM- & CHAT-BENACHRICHTIGUNGEN
L["WELCOME_MSG"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFFFFFsuccessfully loaded! Type|r |cFFFFD100/rqol|r |cFFFFFFFFfor settings.|r"
L["CHAT_REPAIR_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFBBBBBBRepaired gear for:|r %s"
L["CHAT_REPAIR_ERROR"] = "|cFFFF2222[RankoneQoL]|r |cFFBBBBBBNicht genug Gold für automatische Reparatur!|r"
L["CHAT_SELL_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFBBBBBBSchrott verkauft für:|r %s"
L["CHAT_QUEST_REWARD_WARNING"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFD100Please choose your quest reward manually!|r"
L["CHAT_PROFILE_COPIED"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFFFFFSuccessfully copied settings from profile:|r |cFFFFD100%s|r"

-- B) TITELZEILEN & KACHEL-ÜBERSCHRIFTEN
L["TITLE_SETTINGS"] = "|cFF00C0FFRankøneQoL|r |cFFFFFFFFSettings|r"
L["RELOAD_UI"] = "|cFF00C0FFReload UI|r"
L["CARD_SPEEDRUN_OPS"] = "SPEEDRUN INTERACTIONS"
L["CARD_THEME_SETTINGS"] = "VISUAL THEME SETTINGS"

-- C) MINIMAP BUTTON INTERAKTION
L["MINIMAP_TITLE"] = "|cFF00C0FFRankoneQoL|r"
L["MINIMAP_LEFT_CLICK"] = "|cFFFFD100Left-Click:|r Open Settings"
L["MINIMAP_RIGHT_CLICK"] = "|cFFFFD100Right-Click:|r Reload User Interface"
L["MINIMAP_DRAG"] = "|cFF888888(Hold to drag button)|r"

-- D) NAVIGATIONSTABS (LINKE SEITE)
L["TAB_AUTOMATION"] = "Automation"
L["TAB_SPEEDRUN"] = "Speedrun"
L["TAB_THEMES"] = "Themes"
L["TAB_OPTIONS"] = "Options"
L["TAB_CHANGELOG"] = "Changelog"

-- E) MENÜ-CHECKBOXEN (LABELS)
L["OPT_AUTO_SELL"] = "|cFFFFFFFFAutomatically sell grey junk|r"
L["OPT_AUTO_REPAIR"] = "|cFFFFFFFFAutomatically repair equipment|r"
L["OPT_AUTO_QUEST"] = "|cFFFFFFFFAutomatically accept & turn in quests|r"
L["OPT_AUTO_LOOT"] = "|cFFFFFFFFEnable Automatic Looting (Auto-Loot)|r"
L["OPT_AUTO_CINEMATIC"] = "|cFFFFFFFFAutomatically skip cinematics|r"

L["OPT_SPEED_FLIGHT"] = "|cFFFFFFFFSmart Flightmaster Skip|r"
L["OPT_SPEED_HEARTH"] = "|cFFFFFFFFInstant Hearthstone Binder|r"
L["OPT_SPEED_GOSSIP"] = "|cFFFFFFFFAuto-Skip Single Gossip Options|r"

-- F) GRAFISCHE EINSTELLUNGEN (SLIDER & DROPDOWNS)
L["LABEL_FONT_SIZE"] = "|cFFFFFFFFFont Size:|r"
L["LABEL_TOOLTIP_SCALE"] = "|cFFFFFFFFTooltip Scale:|r"
L["LABEL_SELECT_FONT"] = "|cFFFFFFFFSelect Font:|r"
L["LABEL_SELECT_THEME"] = "|cFFFFFFFFSelect Menu Theme:|r"
L["LABEL_COPY_PROFILE"] = "|cFFFFFFFFCopy Settings from Profile:|r"
L["DROP_SELECT_PROFILE"] = "Select Profile..."

-- THEME NAMES
L["THEME_CYAN"] = "Neon Cyan"
L["THEME_GREEN"] = "Matrix Green"
L["THEME_ORANGE"] = "Oblivion Orange"
L["THEME_DARK"] = "Minimalist Dark"

-- G) TOOLTIPS
L["TT_AUTO_SELL"] = "Automatically sells all grey junk items as soon as you talk to a merchant."
L["TT_AUTO_REPAIR"] = "Automatically repairs your damaged gear at any repair-capable merchant."
L["TT_AUTO_QUEST"] = "Automatically accepts and completes quests (stops if a reward choice is required)."
L["TT_AUTO_LOOT"] = "Forces the loot window to instantly empty itself when looting a corpse."
L["TT_AUTO_CINEMATIC"] = "Automatically skips in-game cinematics and movie cutscenes."

L["TT_SPEED_FLIGHT"] = "Instantly opens the flight map when talking to a flightmaster, unless they have quests for you."
L["TT_SPEED_HEARTH"] = "Bypasses the confirmation popup when setting a new hearthstone home location."
L["TT_SPEED_GOSSIP"] = "Automatically clicks the NPC dialog option if there is only a single choice available."

-- H) TOOLTIP PREIS-ANZEIGEN
L["TOOLTIP_SELL_VALUE"] = "Vendor Value:"
L["TOOLTIP_STACK_VALUE"] = "Vendor Value (%d):"

-- I) CHAT HELP COMMANDS (ENGLISCH)
L["HELP_HEADER"] = "|cFF00C0FF[RankoneQoL] — Available Chat Commands:|r"
L["HELP_CMD_MAIN"] = "  |cFFFFD100/rqol|r or |cFFFFD100/rankone|r — Opens the main configuration interface."
L["HELP_CMD_HELP"] = "  |cFFFFD100/rqol help|r — Displays this visual command assistance directory."
L["HELP_CMD_RESET"] = "  |cFFFFD100/rqol reset|r — |cFFFF2222Wipes current character database and restores factory defaults.|r"
L["CHAT_RESET_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFFF2222Your character profile has been reset to factory defaults! Reloading UI...|r"

-- ============================================================================
-- [2. DEUTSCHE ÜBERSETZUNGEN] - Wird aktiv, wenn WoW auf Deutsch läuft (deDE)
-- ============================================================================
if GetLocale() == "deDE" then
    L["WELCOME_MSG"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFFFFFerfolgreich geladen! Tippe|r |cFFFFD100/rqol|r |cFFFFFFFFfür das Einstellungsmenü.|r"
    L["CHAT_REPAIR_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFBBBBBBAusrüstung repariert für:|r %s"
    L["CHAT_REPAIR_ERROR"] = "|cFFFF2222[RankoneQoL]|r |cFFBBBBBBNicht genug Gold für automatische Reparatur!|r"
    L["CHAT_SELL_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFBBBBBBSchrott verkauft für:|r %s"
    L["CHAT_QUEST_REWARD_WARNING"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFD100Bitte wähle deine Questbelohnung manuell aus!|r"
    L["CHAT_PROFILE_COPIED"] = "|cFF00C0FF[RankoneQoL]|r |cFFFFFFFFEinstellungen erfolgreich kopiert von Profil:|r |cFFFFD100%s|r"
    
    L["TITLE_SETTINGS"] = "|cFF00C0FFRankøneQoL|r |cFFFFFFFFEinstellungen|r"
    L["RELOAD_UI"] = "|cFF00C0FFUI neu laden|r"
    L["CARD_SPEEDRUN_OPS"] = "SPEEDRUN INTERAKTIONEN"
    L["CARD_THEME_SETTINGS"] = "VISUELLE DESIGN OPTIONEN"
    
    L["MINIMAP_LEFT_CLICK"] = "|cFFFFD100Links-Klick:|r Einstellungen öffnen"
    L["MINIMAP_RIGHT_CLICK"] = "|cFFFFD100Rechts-Klick:|r Benutzeroberfläche neu laden (Reload)"
    L["MINIMAP_DRAG"] = "|cFF888888(Gedrückt halten zum Verschieben)|r"
    
    L["TAB_AUTOMATION"] = "Automation"
    L["TAB_SPEEDRUN"] = "Speedrun"
    L["TAB_THEMES"] = "Designs"
    L["TAB_OPTIONS"] = "Optionen"
    L["TAB_CHANGELOG"] = "Changelog"
    
    L["OPT_AUTO_SELL"] = "|cFFFFFFFFAutomatisch grauen Schrott verkaufen|r"
    L["OPT_AUTO_REPAIR"] = "|cFFFFFFFFAutomatisch Ausrüstung reparieren|r"
    L["OPT_AUTO_QUEST"] = "|cFFFFFFFFAutomatisch Quests annehmen & abgeben|r"
    L["OPT_AUTO_LOOT"] = "|cFFFFFFFFAutomatisches Plünnern aktivieren|r"
    L["OPT_AUTO_CINEMATIC"] = "|cFFFFFFFFAutomatisch Filmsequenzen überspringen|r"
    
    L["OPT_SPEED_FLIGHT"] = "|cFFFFFFFFIntelligenter Flugmeister-Skip|r"
    L["OPT_SPEED_HEARTH"] = "|cFFFFFFFFSofortiges Ruhestein-Binden|r"
    L["OPT_SPEED_GOSSIP"] = "|cFFFFFFFFEinfache NPC-Texte überspringen|r"
    
    L["LABEL_FONT_SIZE"] = "|cFFFFFFFFSchriftgröße:|r"
    L["LABEL_TOOLTIP_SCALE"] = "|cFFFFFFFFTooltip-Größe:|r"
    L["LABEL_SELECT_FONT"] = "|cFFFFFFFFSchriftart wechseln:|r"
    L["LABEL_SELECT_THEME"] = "|cFFFFFFFFMenü-Design wechseln:|r"
    L["LABEL_COPY_PROFILE"] = "|cFFFFFFFFEinstellungen von Profil kopieren:|r"
    L["DROP_SELECT_PROFILE"] = "Profil auswählen..."
    
    L["THEME_CYAN"] = "Neon Cyan"
    L["THEME_GREEN"] = "Matrix Green"
    L["THEME_ORANGE"] = "Oblivion Orange"
    L["THEME_DARK"] = "Minimalist Dark"
    
    L["TT_AUTO_SELL"] = "Verkauft automatisch alle grauen Gegenstände, sobald du einen Händler ansprichst."
    L["TT_AUTO_REPAIR"] = "Repariert deine Ausrüstung automatisch bei reparierfähigen Händlern."
    L["TT_AUTO_QUEST"] = "Nimmt Quests automatisch an und gibt sie ab (stoppt bei Belohnungsauswahlen)."
    L["TT_AUTO_LOOT"] = "Zwingt das Beutefenster dazu, sich beim Plündern sofort komplett von selbst zu leeren."
    L["TT_AUTO_CINEMATIC"] = "Überspringt automatisch Ingame-Zwischensequenzen und Videos."
    
    L["TT_SPEED_FLIGHT"] = "Öffnet sofort die Flugkarte beim Ansprechen eines Flugmeisters, es sei denn, er hat Quests für dich."
    L["TT_SPEED_HEARTH"] = "Überspringt das Blizzard-Bestätigungsfenster beim Binden eines neuen Heimatortes."
    L["TT_SPEED_GOSSIP"] = "Klickt die Dialogzeile des NPCs automatisch an, wenn es für dich nur eine einzige Option zur Auswahl gibt."
    
    L["TOOLTIP_SELL_VALUE"] = "Händlerwert:"
    L["TOOLTIP_STACK_VALUE"] = "Händlerwert (%d):"

    -- I) CHAT HELP COMMANDS (DEUTSCH)
    L["HELP_HEADER"] = "|cFF00C0FF[RankoneQoL] — Verfügbare Chat-Befehle:|r"
    L["HELP_CMD_MAIN"] = "  |cFFFFD100/rqol|r oder |cFFFFD100/rankone|r — Öffnet das Einstellungsmenü."
    L["HELP_CMD_HELP"] = "  |cFFFFD100/rqol help|r — Zeigt diese Übersicht der Chat-Befehle an."
    L["HELP_CMD_RESET"] = "  |cFFFFD100/rqol reset|r — |cFFFF2222Löscht die Datenbank dieses Charakters und lädt die Werkseinstellungen.|r"
    L["CHAT_RESET_SUCCESS"] = "|cFF00C0FF[RankoneQoL]|r |cFFFF2222Das Charakterprofil wurde auf die Werkseinstellungen zurückgesetzt! UI wird neu geladen...|r"
end

RankoneQoL_Locals = L
