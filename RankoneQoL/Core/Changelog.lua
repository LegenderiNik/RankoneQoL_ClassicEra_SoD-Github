-- ============================================================================
-- RankoneQoL - Changelog Data Source (Multi-Page Architecture - v1.1 Update)
-- ============================================================================

RankoneQoL_ChangelogPages = {
    -- SEITE 1: DIE BRANDNEUE VERSION 1.1 (Frisch aus dieser Session)
    {
        version = "1.1",
        title = "|cFF00C0FFVersion 1.1 - The Navigation & Assistance Upgrade|r",
        text = [[

  |cFF00FF00[+] Added:|r
  - Sci-Fi Flight Time Left Tracker bar ('Modules\FlightTimer.lua') with live-theme synchronization.
  - Automated route triangulation engine that records and saves flight path data on new flights.
  - Full synchronization framework linking global tooltips and the flight tracker to active themes.
  - Unified character database factory-reset terminal function accessible via '/rqol reset'.
  - English & German chat assistance directories via localized commands '/rqol help' and 'hilfe'.

  |cFFFFD100[*] Improvements:|r
  - Engineered a modular pagination sub-engine dividing changelogs into clean book chapters.
  - Transferred and aligned the 'Themes' navigation tab seamlessly above system controls.
  - Integrated the global Blizzard hardware register to support interface closing via the ESC key.
  - Relocated and anchored the red 'Reload UI' system control button cleanly into sub-card spaces.
  - Scaled and centered the main menu header texture icon to 26x26px for enhanced brand presence.

  |cFFFF2222[FIX] Bugfixes:|r
  - Fixed a safety check constraint state crash inside the 'LOOT_READY' auto-loot engine loop.
  - Resolved an unexpected Quest-Log nil field failure under the new Season of Discovery client tree.
  - Patched dropdown macro loops to isolate vertex coloring strictly on arrow assets.
  - Fixed an initial position overlap hiding the minimap button behind the default clock texture.
]]
    },

    -- SEITE 2: DIE SOWIESO SCHON BESTEHENDE VERSION 1.0 (Rutscht automatisch nach hinten)
    {
        version = "1.0",
        title = "|cFF00C0FFVersion 1.0 - Release|r",
        text = [[

  |cFF00FF00[+] Added:|r
  - Flat Sci-Fi custom main user interface.
  - Automatic merchant junk sale (poor quality items).
  - Automatic gear repair at capable vendors.
  - Automatic quest accept and turn-in system.
  - Force-empty auto loot acceleration engine.
  - Game cinematic and cutscene skipper.
  - Brand-new "Speedrun" tab with modular options.
  - Intelligent Flightmaster skip (hides map if quests exist).
  - Brute-force text scanner for instant Hearthstone binding.
  - Auto-skip single gossip options for faster world travel.
  - Global Tooltip visual overhaul with custom rendering.
  - Multi-language Tooltip vendor value price generator.
  - Real-time steepless Tooltip scaling control slider (80%-120%).
  - Modular Theme tab engine for custom visual stylings.
  - Live UI Menu Theme Dropdown linked to custom 'UiMenuDesigns.lua'.
  - Synchronized Global Tooltip Skin Themes that match chosen styles.

  |cFFFFD100[*] Improvements:|r
  - Re-aligned main navigation tabs to vertical bottom.
  - Unified ALL menu button dimensions strictly to 130x24px.
  - Enhanced scrolling system via custom pure-Lua mechanics.
  - Perfectly synchronized live item stack counting for tooltips.
  - Integrated beautiful 0.82-alpha background translucency.
  - Added rounded Sci-Fi borders and inverted header glow lines.
  - Injected dynamic character class color themes for active profile.
  - Applied aggressive duplicate database profile cleaners.
]]
    },
    
    -- SEITE 3: DIE ZUKUNFTS-ROADMAP
    {
        version = "Roadmap",
        title = "|cFF00C0FFFuture Roadmap & Planned Features|r",
        text = [[
  The following modules are scheduled for upcoming deployment cyles.
  Priority ratings are color-coded based on gameplay impact.

  |cFFFF2222[HIGH]|r - "Smart Buy" Reagent Auto-Stock (Buy back candles/ankhs up to a target stack).
  |cFFFFD100[MED]|r  - Option to toggle the Minimap button on/off via settings.
  |cFFFFD100[MED]|r  - "Swift Mail" Bulk Sender (Rapidly attach and mail materials to bank alts).
  |cFFFFD100[MED]|r  - "HUD Tracker" Map Coordinates (Themed X/Y text directly onto the minimap).
  |cFF00FF00[LOW]|r  - Smart Audio Alerts (Sci-Fi click-triggers for combat locks and rare targets).

  Stay tuned for updates on CurseForge!
]]
    }
}
