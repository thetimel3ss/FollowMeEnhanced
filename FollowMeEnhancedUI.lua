-- FollowMeEnhanced configuration, Vanilla WoW 1.12.1, Lua 5.0.
-- No remote cast, macro, Nampower or ClassicAPI dependencies.
local optionsFrame
local checks = {}

local function FME_Label(parent, value, x, y, font)
   local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontNormal")
   label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
   label:SetText(value)
   return label
end

local function FME_Check(parent, key, text, description, x, y, labelWidth)
   local check = CreateFrame("CheckButton", "FMECheck" .. key, parent,
      "UICheckButtonTemplate")
   check:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
   check:SetWidth(26)
   check:SetHeight(26)
   local caption = check:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
   caption:SetPoint("LEFT", check, "RIGHT", 2, 0)
   caption:SetText(text)

   local function ShowTooltip(owner)
      GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
      GameTooltip:SetText(text, 1, 0.82, 0.15)
      GameTooltip:AddLine(description, 1, 1, 1, true)
      GameTooltip:Show()
   end

   check:SetScript("OnClick", function()
      FME_SetOption(key, this:GetChecked() and true or false)
   end)
   check:SetScript("OnEnter", function() ShowTooltip(this) end)
   check:SetScript("OnLeave", function() GameTooltip:Hide() end)

   -- The caption may be hovered and clicked just like the checkbox.
   local labelButton = CreateFrame("Button", nil, parent)
   labelButton:SetPoint("LEFT", check, "RIGHT", 0, 0)
   labelButton:SetWidth(labelWidth or 170)
   labelButton:SetHeight(26)
   labelButton:SetScript("OnEnter", function() ShowTooltip(this) end)
   labelButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
   labelButton:SetScript("OnClick", function()
      FME_SetOption(key, not FollowMe_Options[key])
   end)
   checks[key] = check
   return check
end

function FME_RefreshOptions()
   if not optionsFrame then return end
   FollowMe_InitOptions()
   for key, check in pairs(checks) do
      check:SetChecked(FollowMe_Options[key] and 1 or nil)
   end
end

local function FME_CreateOptions()
   if optionsFrame then return end

   optionsFrame = CreateFrame("Frame", "FMEOptionsFrame", UIParent)
   optionsFrame:SetWidth(450)
   optionsFrame:SetHeight(400)
   optionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
   optionsFrame:SetFrameStrata("DIALOG")
   optionsFrame:EnableMouse(true)
   optionsFrame:SetMovable(true)
   optionsFrame:RegisterForDrag("LeftButton")
   optionsFrame:SetScript("OnDragStart", function() this:StartMoving() end)
   optionsFrame:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
   optionsFrame:SetBackdrop({
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
      edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
      tile = true, tileSize = 32, edgeSize = 32,
      insets = { left = 11, right = 12, top = 12, bottom = 11 }
   })
   optionsFrame:Hide()
   table.insert(UISpecialFrames, "FMEOptionsFrame")

   FME_Label(optionsFrame, "FollowMe Enhanced - Options", 27, -22,
      "GameFontNormalLarge")
   local close = CreateFrame("Button", nil, optionsFrame, "UIPanelCloseButton")
   close:SetPoint("TOPRIGHT", optionsFrame, "TOPRIGHT", -5, -5)
   close:SetScript("OnClick", function() optionsFrame:Hide() end)

   FME_Label(optionsFrame, "Remote follow", 27, -65)
   FME_Check(optionsFrame, "Enabled", "Enable",
      "Master switch for incoming @follow requests. When off, nobody can request follow.",
      27, -83, 165)
   -- Permission matrix: friends | guildmates, then party | raid.
   FME_Check(optionsFrame, "FollowFriends", "Allow friends",
      "Allow characters on your friends list to request @follow, regardless of party or raid membership.",
      27, -120, 165)
   FME_Check(optionsFrame, "FollowGuild", "Allow guildmates",
      "Allow members of your guild to request @follow, regardless of party or raid membership.",
      235, -120, 165)
   FME_Check(optionsFrame, "AllowParty", "Allow party",
      "Allow members of your current party to request @follow. This does not grant access to raid members.",
      27, -157, 165)
   FME_Check(optionsFrame, "AllowRaid", "Allow raid",
      "Allow members of your current raid to request @follow. This setting is independent of Allow party.",
      235, -157, 165)

   FME_Label(optionsFrame, "Announcements", 27, -243)
   FME_Check(optionsFrame, "Group", "Party",
      "Announce in party chat when you start or stop auto-following. This does not grant follow permission.",
      27, -262, 150)
   FME_Check(optionsFrame, "Raid", "Raid",
      "Announce in raid chat when you start or stop auto-following. Party announcements take precedence if both qualify.",
      235, -262, 150)

   FME_Label(optionsFrame, "Whisper commands: @follow  |  @status",
      30, -309, "GameFontHighlightSmall")

   local help = CreateFrame("Button", "FMEHelpButton", optionsFrame,
      "UIPanelButtonTemplate")
   help:SetWidth(115)
   help:SetHeight(23)
   help:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -28, 26)
   help:SetText("Chat commands")
   help:SetScript("OnClick", function()
      FollowMe_CmdParser("help")
   end)

   FME_Label(optionsFrame, "Use /fm help for the full list",
      30, -358, "GameFontHighlightSmall")
   optionsFrame:SetScript("OnShow", FME_RefreshOptions)
   FME_RefreshOptions()
end

function FME_ToggleOptions()
   FME_CreateOptions()
   if optionsFrame:IsShown() then
      optionsFrame:Hide()
   else
      optionsFrame:Show()
   end
end
