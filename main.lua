-- By Smagumas

local PFUNITSGROUP = {}
for i = 1, 4 do
	tinsert(PFUNITSGROUP, "PARTY" .. i)
end

local texCoords = {
	["Raid-AggroFrame"] = {  0.00781250, 0.55468750, 0.00781250, 0.27343750 },
	["Raid-TargetFrame"] = { 0.00781250, 0.55468750, 0.28906250, 0.55468750 },
}
ClickCastFrames = ClickCastFrames or {} -- "Clicked" Support



-- Main Frame
local PF = CreateFrame("Frame", "PF", UIParent)
PF:SetMovable(true)
PF:EnableMouse(true)
PF:RegisterForDrag("LeftButton")
PF:SetClampedToScreen(true)
PF.isMoving = false
PF:SetScript("OnDragStart", function(self)
	PF:StartMoving()
	PF.isMoving = true
end)
PF:SetScript("OnDragStop",  function(self)
	PF:StopMovingOrSizing()
	PF.isMoving = false
end)
PF:SetPoint("CENTER", 0, 0)

PF.texture = PF:CreateTexture(nil, "BACKGROUND")
PF.texture:SetAllPoints(PF)
PF.texture:SetColorTexture(0, 0, 0, 0.5)
PF:HookScript("OnUpdate", function(self)
	if MouseIsOver(self) then
		self.texture:SetAlpha(0.6)
	else
		self.texture:SetAlpha(0.2)
	end
end)


function PFGetRoleTexCoord(role)
	if role == "HEALER" then
		return 0.3, 0.6, 0, 0.3
	elseif role == "TANK" then
		return 0, 0.3, 0.33, 0.63
	elseif role == "DAMAGER" then
		return 0.3, 0.6, 0.33, 0.63
	else
		return 0, 1, 0, 1
	end
end

function PFInitDropDown(self)
	local unit = self:GetParent().unit;
	if ( not unit ) then
		return;
	end
	local menu;
	local name;
	local id = nil;
	if ( UnitIsUnit(unit, "player") ) then
		menu = "SELF";
	elseif ( UnitIsUnit(unit, "vehicle") ) then
		-- NOTE: vehicle check must come before pet check for accuracy's sake because
		-- a vehicle may also be considered your pet
		menu = "VEHICLE";
	elseif ( UnitIsUnit(unit, "pet") ) then
		menu = "PET";
	elseif ( UnitIsPlayer(unit) ) then
		if ( UnitInParty(unit) ) then
			menu = "PARTY";
		else
			menu = "PLAYER";
		end
	else
		menu = "TARGET";
		name = RAID_TARGET_ICON;
	end
	if ( menu ) then
		UnitPopup_ShowMenu(self, menu, unit, name, id);
	end
end



function PFDropDown_Initialize(self)
	local unit = self:GetParent().unit;
	if ( not unit ) then
		return;
	end
	local menu;
	local name;
	local id = nil;
	if ( UnitIsUnit(unit, "player") ) then
		menu = "SELF";
	elseif ( UnitIsUnit(unit, "vehicle") ) then
		-- NOTE: vehicle check must come before pet check for accuracy's sake because
		-- a vehicle may also be considered your pet
		menu = "VEHICLE";
	elseif ( UnitIsUnit(unit, "pet") ) then
		menu = "PET";
	elseif ( UnitIsPlayer(unit) ) then
		if ( UnitInParty(unit) ) then
			menu = "PARTY";
		else
			menu = "PLAYER";
		end
	else
		menu = "TARGET";
		name = RAID_TARGET_ICON;
	end
	if ( menu ) then
		UnitPopup_ShowMenu(self, menu, unit, name, id);
	end
end



PF.FRAMES = {}
-- Player Frames
local id = 1
for group = 1, 8 do
	for ply = 1, 5 do
		-- Player Box
		PF.FRAMES[id] = CreateFrame("Frame", "PF" .. id, PF)
		PF.FRAMES[id].id = id


		-- Health Bar
		PF.FRAMES[id].HealthBackground = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
		PF.FRAMES[id].HealthBackground:SetColorTexture(0, 0, 0, 0.4)

		PF.FRAMES[id].HealthBar = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
		PF.FRAMES[id].HealthBar:SetTexture("Interface/RaidFrame/Raid-Bar-Hp-Fill")--"Interface/Addons/PartyFrames/assets/bar")
		PF.FRAMES[id].HealthBar:SetColorTexture(0.8, 0.8, 0.8)

		if PFBUILD ~= "CLASSIC" then
			PF.FRAMES[id].Prediction = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
			PF.FRAMES[id].Prediction:SetTexture("Interface/Addons/PartyFrames/assets/bar")--"Interface/RaidFrame/Raid-Bar-Hp-Fill")
			PF.FRAMES[id].Prediction:SetVertexColor(0, 0, 0)

			PF.FRAMES[id].Absorb = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
			PF.FRAMES[id].Absorb.tileSize = 32
			PF.FRAMES[id].Absorb:SetTexture("Interface/RaidFrame/Shield-Fill")
			PF.FRAMES[id].Absorb:SetTexCoord(0, 1, 0, 0.53125);
			PF.FRAMES[id].Absorb:SetVertexColor(0.5, 0.5, 0.5)

			PF.FRAMES[id].AbsorbOverlay = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
			PF.FRAMES[id].AbsorbOverlay:SetTexture("Interface/RaidFrame/Shield-Overlay", true, true);	--Tile both vertically and horizontally
			PF.FRAMES[id].AbsorbOverlay:SetAllPoints(PF.FRAMES[id].Absorb);
			PF.FRAMES[id].AbsorbOverlay.tileSize = 32;

			PF.FRAMES[id].AbsorbOverlay:SetHorizTile(true) -- fix
			PF.FRAMES[id].AbsorbOverlay:SetVertTile(true) -- fix
		end
		
		PF.FRAMES[id].HealthTextTop = PF.FRAMES[id]:CreateFontString(nil, "OVERLAY") 
		PF.FRAMES[id].HealthTextTop:SetFont("Fonts\\ARIALN.ttf", 11, "")
		PF.FRAMES[id].HealthTextTop:SetText("")
		PF.FRAMES[id].HealthTextTop:SetPoint("TOP", PF.FRAMES[id].HealthBackground, "TOP", 0, -3)

		PF.FRAMES[id].HealthTextCen = PF.FRAMES[id]:CreateFontString(nil, "OVERLAY") 
		PF.FRAMES[id].HealthTextCen:SetFont("Fonts\\ARIALN.ttf", 11, "")
		PF.FRAMES[id].HealthTextCen:SetText("")
		PF.FRAMES[id].HealthTextCen:SetPoint("CENTER", PF.FRAMES[id].HealthBackground, "CENTER", 0, 1)

		PF.FRAMES[id].HealthTextBot = PF.FRAMES[id]:CreateFontString(nil, "OVERLAY") 
		PF.FRAMES[id].HealthTextBot:SetFont("Fonts\\ARIALN.ttf", 11, "")
		PF.FRAMES[id].HealthTextBot:SetText("")
		PF.FRAMES[id].HealthTextBot:SetPoint("BOTTOM", PF.FRAMES[id].HealthBackground, "BOTTOM", 0, 3)
		


		-- Power Bar
		PF.FRAMES[id].PowerBackground = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
		PF.FRAMES[id].PowerBackground:SetColorTexture(0, 0, 0, 0.4)

		PF.FRAMES[id].PowerBar = PF.FRAMES[id]:CreateTexture(nil, "BACKGROUND")
		PF.FRAMES[id].PowerBar:SetTexture("Interface/Addons/PartyFrames/assets/bar")
		PF.FRAMES[id].PowerBar:SetColorTexture(1, 1, 1)

		PF.FRAMES[id].PowerTextCen = PF.FRAMES[id]:CreateFontString(nil, "ARTWORK") 
		PF.FRAMES[id].PowerTextCen:SetFont("Fonts\\ARIALN.ttf", 11, "")
		PF.FRAMES[id].PowerTextCen:SetText("ID " .. id)
		PF.FRAMES[id].PowerTextCen:SetPoint("CENTER", PF.FRAMES[id].PowerBackground, "CENTER", 0, 0)



		-- Raid Icon
		PF.FRAMES[id].RaidIcon = PF.FRAMES[id]:CreateTexture(nil, "ARTWORK")
		PF.FRAMES[id].RaidIcon:SetSize(18, 18)
		PF.FRAMES[id].RaidIcon:SetPoint("BOTTOM", PF.FRAMES[id].HealthBackground, "BOTTOM", 0, 0)
		PF.FRAMES[id].RaidIcon:SetTexture(nil)



		-- Buff
		PF.FRAMES[id].BuffBar = CreateFrame("Frame", "PFBUFFBAR" .. id, PF.FRAMES[id])
		PF.FRAMES[id].BuffBar:SetSize(7 * 18, 18)
		PF.FRAMES[id].BuffBar:SetPoint("BOTTOMRIGHT", PF.FRAMES[id].HealthBackground, "BOTTOMRIGHT", 0, 0)
		for i = 1, 7 do
			PF.FRAMES[id].BuffBar[i] = CreateFrame("Button", "PFBUFF" .. id .. "_" .. i, PF.FRAMES[id].BuffBar, "BuffButtonTemplate");
			PF.FRAMES[id].BuffBar[i].parent = PF.FRAMES[id].BuffBar;

			if PF.FRAMES[id].BuffBar[i].Icon == nil then
				PF.FRAMES[id].BuffBar[i].Icon = _G["PFBUFF" .. id .. "_" .. i .. "Icon"]
			end

			PF.FRAMES[id].BuffBar[i]:EnableMouse(false)

			PF.FRAMES[id].BuffBar[i]:SetSize(18, 18)

			PF.FRAMES[id].BuffBar[i].cooldown = CreateFrame("Cooldown", "PFBUFF" .. id .. "_" .. i .. "Cooldown", PF.FRAMES[id].BuffBar[i], "CooldownFrameTemplate")
			PF.FRAMES[id].BuffBar[i].cooldown:SetSize(18, 18)
			PF.FRAMES[id].BuffBar[i].cooldown:SetAllPoints(PF.FRAMES[id].BuffBar[i])
			PF.FRAMES[id].BuffBar[i].cooldown:SetHideCountdownNumbers(true)
			PF.FRAMES[id].BuffBar[i].cooldown:SetReverse(true)
		end

		-- Debuff
		PF.FRAMES[id].DebuffBar = CreateFrame("Frame", "PFDEBUFFBAR" .. id, PF.FRAMES[id])
		PF.FRAMES[id].DebuffBar:SetSize(7 * 18, 18)
		PF.FRAMES[id].DebuffBar:SetPoint("BOTTOMLEFT", PF.FRAMES[id].HealthBackground, "BOTTOMLEFT", 0, 0)
		for i = 1, 7 do
			PF.FRAMES[id].DebuffBar[i] = CreateFrame("Button", "PFDEBUFF" .. id .. "_" .. i, PF.FRAMES[id].DebuffBar, "DebuffButtonTemplate");
			PF.FRAMES[id].DebuffBar[i].parent = PF.FRAMES[id].DebuffBar;

			if PF.FRAMES[id].DebuffBar[i].Icon == nil then
				PF.FRAMES[id].DebuffBar[i].Icon = _G["PFDEBUFF" .. id .. "_" .. i .. "Icon"]
			end

			if PF.FRAMES[id].DebuffBar[i].Border == nil then
				PF.FRAMES[id].DebuffBar[i].Border = _G["PFDEBUFF" .. id .. "_" .. i .. "Border"]
			end
			PF.FRAMES[id].DebuffBar[i].Border:Hide()
			PF.FRAMES[id].DebuffBar[i].Border:SetSize(18, 18)

			PF.FRAMES[id].DebuffBar[i]:EnableMouse(false)

			PF.FRAMES[id].DebuffBar[i]:SetSize(18, 18)

			PF.FRAMES[id].DebuffBar[i].cooldown = CreateFrame("Cooldown", "PFDEBUFF" .. id .. "_" .. i .. "Cooldown", PF.FRAMES[id].DebuffBar[i], "CooldownFrameTemplate")
			PF.FRAMES[id].DebuffBar[i].cooldown:SetSize(18, 18)
			PF.FRAMES[id].DebuffBar[i].cooldown:SetAllPoints(PF.FRAMES[id].DebuffBar[i])
			PF.FRAMES[id].DebuffBar[i].cooldown:SetHideCountdownNumbers(true)
			PF.FRAMES[id].DebuffBar[i].cooldown:SetReverse(true)
		end


		
		-- Aggro
		PF.FRAMES[id].Aggro = PF.FRAMES[id]:CreateTexture(nil, "ARTWORK")
		PF.FRAMES[id].Aggro:SetTexture("Interface\\RaidFrame\\Raid-FrameHighlights");
		PF.FRAMES[id].Aggro:SetTexCoord(unpack(texCoords["Raid-AggroFrame"]));
		PF.FRAMES[id].Aggro:SetVertexColor(1, 0.2, 0.2)



		-- Role Icon
		if PFBUILD ~= "CLASSIC" then
			PF.FRAMES[id].HealthBackground.RoleIcon = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
			PF.FRAMES[id].HealthBackground.RoleIcon:SetSize(18, 18)
			PF.FRAMES[id].HealthBackground.RoleIcon:SetPoint("TOPRIGHT", PF.FRAMES[id].HealthBackground, "TOPRIGHT", -1, -2)
			PF.FRAMES[id].HealthBackground.RoleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
		end



		-- Class Icon
		PF.FRAMES[id].HealthBackground.ClassIcon = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
		PF.FRAMES[id].HealthBackground.ClassIcon:SetSize(18, 18)
		PF.FRAMES[id].HealthBackground.ClassIcon:SetPoint("RIGHT", PF.FRAMES[id].HealthBackground, "RIGHT", 0, 0)
		PF.FRAMES[id].HealthBackground.ClassIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")

		-- Lang Icon
		PF.FRAMES[id].HealthBackground.LangIcon = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
		PF.FRAMES[id].HealthBackground.LangIcon:SetSize(18, 9)
		PF.FRAMES[id].HealthBackground.LangIcon:SetPoint("LEFT", PF.FRAMES[id].HealthBackground, "LEFT", 0, 0)
		PF.FRAMES[id].HealthBackground.LangIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")

		-- Leader / Assist Icon
		PF.FRAMES[id].HealthBackground.RankIcon = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
		PF.FRAMES[id].HealthBackground.RankIcon:SetSize(18, 18)
		PF.FRAMES[id].HealthBackground.RankIcon:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 1, -1)
		PF.FRAMES[id].HealthBackground.RankIcon:SetTexture(nil)

		PF.FRAMES[id].HealthBackground.RankIcon2 = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
		PF.FRAMES[id].HealthBackground.RankIcon2:SetSize(18, 18)
		PF.FRAMES[id].HealthBackground.RankIcon2:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 1, -1 - 16 - 1)
		PF.FRAMES[id].HealthBackground.RankIcon2:SetTexture(nil)



		-- READY CHECK
		PF.FRAMES[id].HealthBackground.ReadyCheck = PF.FRAMES[id]:CreateTexture(nil, "OVERLAY")
		PF.FRAMES[id].HealthBackground.ReadyCheck:SetSize(18, 18)
		PF.FRAMES[id].HealthBackground.ReadyCheck:SetPoint("CENTER", PF.FRAMES[id], "CENTER", 0, 0)
		PF.FRAMES[id].HealthBackground.ReadyCheck:SetTexture(nil)



		-- BTN
		PF.FRAMES[id].btn = CreateFrame("Button", "PFbtn" .. id, PF, "SecureActionButtonTemplate")
		PF.FRAMES[id].btn.id = id
		PF.FRAMES[id].btn:SetAttribute("*type1", "target");
		PF.FRAMES[id].btn:SetAttribute("*type2", "menu");
		PF.FRAMES[id].btn:RegisterForClicks("LeftButtonDown", "RightButtonUp");
		
		PF.FRAMES[id].btn.Highlight = PF.FRAMES[id].btn:CreateTexture(nil, "ARTWORK")
		PF.FRAMES[id].btn.Highlight:SetAllPoints(PF.FRAMES[id].btn)
		PF.FRAMES[id].btn.Highlight:SetColorTexture(1, 1, 1, 0.25)

		PF.FRAMES[id].btn:HookScript("OnUpdate", function(self)
			if MouseIsOver(self) or self.unit and UnitIsUnit("TARGET", self.unit) then
				self.Highlight:SetAlpha(1)
			else
				self.Highlight:SetAlpha(0)
			end
		end)
		
		id = id + 1
	end
end

function SortByRole(a, b)
	local arole = "NONE" --UnitGroupRolesAssigned(a)
	local brole = "NONE" --UnitGroupRolesAssigned(b)

	if UnitGroupRolesAssigned ~= nil then
		arole = UnitGroupRolesAssigned(a)
		brole = UnitGroupRolesAssigned(b)
	end

	local av = 1 -- 1 = NONE
	local bv = 1 -- 1 = NONE

	if arole == "TANK" then
		av = 4
	elseif arole == "HEALER" then
		av = 3
	elseif arole == "DAMAGER" then
		av = 2
	elseif not UnitExists(a) then
		av = 0
	end

	if brole == "TANK" then
		bv = 4
	elseif brole == "HEALER" then
		bv = 3
	elseif brole == "DAMAGER" then
		bv = 2
	elseif not UnitExists(b) then
		bv = 0
	end
	
	if av == bv then
		a = string.gsub(a, "PLAYER", "0")
		b = string.gsub(b, "PLAYER", "0")

		a = string.gsub(a, "PARTY", "")
		b = string.gsub(b, "PARTY", "")

		a = string.gsub(a, "RAID", "")
		b = string.gsub(b, "RAID", "")

		a = tonumber(a)
		b = tonumber(b)

		return a < b
	else
		return av > bv
	end
end

local PFSortedUnits = {}
function PFSortUnits()
	PFSortedUnits = {}

	if IsInGroup() then
		tinsert(PFSortedUnits, "PLAYER")
		for i, v in pairs(PFUNITSGROUP) do
			tinsert(PFSortedUnits, v)
		end
	else
		tinsert(PFSortedUnits, "PLAYER")
	end

	
	if GetConfig("GSORT", "Role") == "Group" then

	elseif GetConfig("GSORT", "Role") == "Role" then
		table.sort(PFSortedUnits, SortByRole)
	end
end

local OUTER_BORDER = 4
local COLUMN_SPACING = 4
local ROW_SPACING = 40
local HP_WIDTH = 180
local HP_HEIGHT = 68
local POWER_WIDTH = 180
local POWER_HEIGHT = 20
local PLWI = 0
local PLHE = 0
local SHOW_POWER = true
local SHOW_HP = true
local SHOW_CLASS = true
local MISSING_HP_COLOR = true;
local PLAY_SOUND_LOW_HP = true;
local MISSING_HP_RED = 35;
local MISSING_HP_YELLOW = 75;
local GroupHorizontal = false
local OVERLAP = true
local BUFF_SIZE = 16
local DEBUFF_SIZE = 16
local TOP_TEXT_TYPE = "Name"
local HP_TEXT_TYPE = "Health in Percent"

PFSizing = true
PFUpdating = true

function PFUpdateSize()
	if PFSizing and not InCombatLockdown() then
		PFSizing = false

		PFSortUnits()

		OUTER_BORDER = GetConfig("OUTER_BORDER", 6)
		COLUMN_SPACING = GetConfig("COLUMN_SPACING", 4)
		ROW_SPACING = GetConfig("ROW_SPACING", 4)
		HP_WIDTH = GetConfig("HP_WIDTH", 180)
		HP_HEIGHT = GetConfig("HP_HEIGHT", 60)
		POWER_WIDTH = GetConfig("POWER_WIDTH", 180)
		POWER_HEIGHT = GetConfig("POWER_HEIGHT", 20)

		SHOW_POWER = GetConfig("SHOW_POWER", true)
		SHOW_HP = GetConfig("SHOW_HP", true)
		SHOW_CLASS = GetConfig("SHOW_CLASS", true)
		MISSING_HP_COLOR = GetConfig("MISSING_HP_COLOR", true)
		PLAY_SOUND_LOW_HP = GetConfig("PLAY_SOUND_LOW_HP", true)
		MISSING_HP_RED = tonumber(GetConfig("MISSING_HP_RED", 35))
		MISSING_HP_YELLOW = tonumber(GetConfig("MISSING_HP_YELLOW", 75))

		GroupHorizontal = GetConfig("HORIZ_PARTY", false)

		BUFF_SIZE = GetConfig("BUFF_SIZE", 16)
		DEBUFF_SIZE = GetConfig("DEBUFF_SIZE", 16)

		HP_SIZE = GetConfig("HP_SIZE", 33);
		HP_POS_X = GetConfig("HP_POS_X", 1);
		HP_POS_Y = GetConfig("HP_POS_Y", -2);

		TOP_TEXT_TYPE = GetConfig("GTETOTY", "Name")
		HP_TEXT_TYPE = GetConfig("GTECETY", "Health in Percent")

		OVERLAP = GetConfig("GOVER", true)

		if not SHOW_POWER then
			POWER_WIDTH = 0
			POWER_HEIGHT = 0
		end

		PLWI = HP_WIDTH + POWER_WIDTH
		PLHE = HP_HEIGHT + POWER_HEIGHT

		local sw = 1
		local sh = GetNumGroupMembers()
		if sh == 0 then
			sh = 1
		end
		if GetNumGroupMembers() > 5 then
			sw = ceil(GetNumGroupMembers() / 5)
			sh = 5
		end

		if GroupHorizontal then
			PF:SetWidth(OUTER_BORDER + sh * HP_WIDTH + (sh - 1) * COLUMN_SPACING + OUTER_BORDER)
			PF:SetHeight(OUTER_BORDER + sw * PLHE + (sw - 1) * ROW_SPACING + OUTER_BORDER)
		else
			PF:SetWidth(OUTER_BORDER + sw * HP_WIDTH + (sw - 1) * COLUMN_SPACING + OUTER_BORDER)
			PF:SetHeight(OUTER_BORDER + sh * PLHE + (sh - 1) * ROW_SPACING + OUTER_BORDER)
		end

		local id = 1
		for group = 1, 8 do
			for ply = 1, 5 do
				-- Player Box
				if GroupHorizontal then
					PF.FRAMES[id]:SetSize(PLWI, HP_HEIGHT)
					PF.FRAMES[id]:SetPoint("TOPLEFT", PF, "TOPLEFT", OUTER_BORDER + (ply - 1) * (HP_WIDTH + COLUMN_SPACING), -(OUTER_BORDER + (group - 1) * (PLHE + ROW_SPACING)))
				else
					PF.FRAMES[id]:SetSize(HP_WIDTH, PLHE)
					PF.FRAMES[id]:SetPoint("TOPLEFT", PF, "TOPLEFT", OUTER_BORDER + (group - 1) * (HP_WIDTH + COLUMN_SPACING), -(OUTER_BORDER + (ply - 1) * (PLHE + ROW_SPACING)))
				end


				-- Health Bar
				PF.FRAMES[id].HealthBackground:SetSize(HP_WIDTH, HP_HEIGHT)
				PF.FRAMES[id].HealthBackground:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 0, 0)
				
				PF.FRAMES[id].HealthBar:SetSize(HP_WIDTH, HP_HEIGHT)
				PF.FRAMES[id].HealthBar:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 0, 0)
				
				
				if PFBUILD ~= "CLASSIC" then
					PF.FRAMES[id].Prediction:ClearAllPoints()
					PF.FRAMES[id].Absorb:ClearAllPoints()

					PF.FRAMES[id].Prediction:SetSize(HP_WIDTH, HP_HEIGHT)
					PF.FRAMES[id].Prediction:SetPoint("TOPLEFT", PF.FRAMES[id].HealthBar, "TOPRIGHT", 0, 0)

					PF.FRAMES[id].Absorb:SetSize(HP_WIDTH, HP_HEIGHT)
					PF.FRAMES[id].Absorb:SetPoint("TOPLEFT", PF.FRAMES[id].Prediction, "TOPRIGHT", 0, 0)
				end

				PF.FRAMES[id].HealthTextTop:SetPoint("TOP", PF.FRAMES[id].HealthBackground, "TOP", 0, -3)

				PF.FRAMES[id].HealthTextCen:SetPoint("CENTER", PF.FRAMES[id].HealthBackground, "CENTER", HP_POS_X, HP_POS_Y)
				PF.FRAMES[id].HealthTextCen:SetFont("Fonts\\ARIALN.ttf", HP_SIZE, "")

				PF.FRAMES[id].HealthTextBot:SetPoint("BOTTOM", PF.FRAMES[id].HealthBackground, "BOTTOM", 0, 3)
				


				-- Power Bar
				if SHOW_POWER then
					PF.FRAMES[id].PowerBackground:SetSize(HP_WIDTH, POWER_HEIGHT)
					PF.FRAMES[id].PowerBackground:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 0, -HP_HEIGHT)

					PF.FRAMES[id].PowerBar:SetSize(HP_WIDTH, POWER_HEIGHT)
					PF.FRAMES[id].PowerBar:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 0, -HP_HEIGHT)
					
					PF.FRAMES[id].PowerTextCen:SetPoint("CENTER", PF.FRAMES[id].PowerBackground, "CENTER", 0, 0)
				else
					PF.FRAMES[id].PowerBackground:Hide()
					PF.FRAMES[id].PowerBar:Hide()
					PF.FRAMES[id].PowerTextCen:Hide()
				end



				PF.FRAMES[id].BuffBar:SetSize(7 * BUFF_SIZE, BUFF_SIZE)
				PF.FRAMES[id].BuffBar:SetPoint("BOTTOMRIGHT", PF.FRAMES[id].HealthBackground, "BOTTOMRIGHT", -1, 1)

				PF.FRAMES[id].DebuffBar:SetSize(7 * DEBUFF_SIZE, DEBUFF_SIZE)
				PF.FRAMES[id].DebuffBar:SetPoint("BOTTOMLEFT", PF.FRAMES[id].HealthBackground, "BOTTOMLEFT", 1, 1)

				for i = 1, 7 do
					PF.FRAMES[id].BuffBar[i]:SetPoint("TOPRIGHT", PF.FRAMES[id].BuffBar, "TOPRIGHT", -(i - 1) * BUFF_SIZE, 0)
					PF.FRAMES[id].BuffBar[i]:SetSize(BUFF_SIZE, BUFF_SIZE)

					PF.FRAMES[id].DebuffBar[i]:SetPoint("TOPLEFT", PF.FRAMES[id].DebuffBar, "TOPLEFT", (i - 1) * DEBUFF_SIZE, 0)
					PF.FRAMES[id].DebuffBar[i]:SetSize(DEBUFF_SIZE, DEBUFF_SIZE)
					if PF.FRAMES[id].DebuffBar[i].Border ~= nil then
						PF.FRAMES[id].DebuffBar[i].Border:SetSize(DEBUFF_SIZE, DEBUFF_SIZE)
					end
				end



				-- Aggro
				PF.FRAMES[id].Aggro:ClearAllPoints()
				PF.FRAMES[id].Aggro:SetAllPoints(PF.FRAMES[id])
					
				if PFBUILD ~= "CLASSIC" then
					PF.FRAMES[id].HealthBackground.RoleIcon:SetSize(18, 18)
					PF.FRAMES[id].HealthBackground.RoleIcon:SetPoint("TOPRIGHT", PF.FRAMES[id].HealthBackground, "TOPRIGHT", -1, -2)
				end

				PF.FRAMES[id].HealthBackground.RankIcon:SetSize(18, 18)
				PF.FRAMES[id].HealthBackground.RankIcon:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 1, -1)

				PF.FRAMES[id].HealthBackground.RankIcon2:SetSize(18, 18)
				PF.FRAMES[id].HealthBackground.RankIcon2:SetPoint("TOPLEFT", PF.FRAMES[id], "TOPLEFT", 1, -1 - 16 - 1)
				
				PF.FRAMES[id].HealthBackground.ReadyCheck:SetSize(18, 18)
				PF.FRAMES[id].HealthBackground.ReadyCheck:SetPoint("CENTER", PF.FRAMES[id], "CENTER", 0, 0)
				
				PF.FRAMES[id].RaidIcon:SetSize(18, 18)
				PF.FRAMES[id].RaidIcon:SetPoint("BOTTOM", PF.FRAMES[id].HealthBackground, "BOTTOM", 0, 1)



				-- PLAYER BUTTON
				if GroupHorizontal then
					PF.FRAMES[id].btn:SetSize(HP_WIDTH, PLHE)
					PF.FRAMES[id].btn:SetPoint("TOPLEFT", PF, "TOPLEFT", OUTER_BORDER + (ply - 1) * (HP_WIDTH + COLUMN_SPACING), -(OUTER_BORDER + (group - 1) * (PLHE + ROW_SPACING)))
				else
					PF.FRAMES[id].btn:SetSize(HP_WIDTH, PLHE)
					PF.FRAMES[id].btn:SetPoint("TOPLEFT", PF, "TOPLEFT", OUTER_BORDER + (group - 1) * (HP_WIDTH + COLUMN_SPACING), -(OUTER_BORDER + (ply - 1) * (PLHE + ROW_SPACING)))
				end

				id = id + 1
			end
		end
	end
	C_Timer.After(0.5, function()
		PFUpdateSize()
	end)
end

function UpdateUnitInfo(uf, unit)
	if UnitExists(unit) then
		uf:Hide()

		if not InCombatLockdown() then
			uf.btn:SetAttribute("unit", unit);
			uf.btn.unit = unit
		end

		local ID = PFSortedUnits[uf.id]
		ID = string.gsub(ID, "RAID", "")
		ID = tonumber(ID)

		-- Health
		uf.HealthBar:SetWidth(HP_WIDTH)
		uf.HealthBar:SetPoint("TOPLEFT", uf, "TOPLEFT", 0, 0)
		if UnitHealth(unit) > 0 and UnitHealthMax(unit) > 0 then
			uf.HealthBar:SetWidth(UnitHealth(unit) / UnitHealthMax(unit) * HP_WIDTH)

			if MISSING_HP_COLOR then
				local currentHpPercent = UnitHealth(unit) / UnitHealthMax(unit) * 100
				if currentHpPercent <= MISSING_HP_RED then
					if PLAY_SOUND_LOW_HP then
						PlaySound(10571, "Sound")
					end
					uf.HealthBar:SetColorTexture(1, 0, 0)
				elseif currentHpPercent > MISSING_HP_RED and currentHpPercent < MISSING_HP_YELLOW then
					uf.HealthBar:SetColorTexture(1, 1, 0)
				else
					uf.HealthBar:SetColorTexture(0.1, 1, 0.1)
				end
			else
				uf.HealthBar:SetColorTexture(0.8, 0.8, 0.8)
			end
			uf.HealthBar:Show()
		else
			uf.HealthBar:Hide()
		end

		if PFBUILD ~= "CLASSIC" then
			local PREDICTION = UnitGetIncomingHeals(unit);

			if PREDICTION and PREDICTION > 0 then
				local rec = PREDICTION / UnitHealthMax(unit) * HP_WIDTH
				if not OVERLAP then
					if rec + uf.HealthBar:GetWidth() > uf.HealthBackground:GetWidth() + 1 then
						rec = uf.HealthBackground:GetWidth() - uf.HealthBar:GetWidth()
						if rec <= 0 then
							rec = 1
						end
					end
				end
				uf.Prediction:SetWidth(rec)

				uf.Prediction:Show()
			else
				uf.Prediction:SetWidth(0.1)

				uf.Prediction:Hide()
			end

			local ABSORB = UnitGetTotalAbsorbs(unit);
			
			if uf.Prediction:IsShown() then
				uf.Absorb:SetSize(0, HP_HEIGHT)
				uf.Absorb:SetPoint("TOPLEFT", uf.Prediction, "TOPRIGHT", 0, 0)
			else
				uf.Absorb:SetSize(0, HP_HEIGHT)
				uf.Absorb:SetPoint("TOPLEFT", uf.HealthBar, "TOPRIGHT", 0, 0)
			end

			if ABSORB and ABSORB > 0 then
				local rec = ABSORB / UnitHealthMax(unit) * HP_WIDTH
				if not OVERLAP then
					if rec + uf.HealthBar:GetWidth() + uf.Prediction:GetWidth() > uf.HealthBackground:GetWidth() + 1 then
						rec = uf.HealthBackground:GetWidth() - uf.HealthBar:GetWidth() - uf.Prediction:GetWidth()
						if rec <= 0 then
							rec = 1
						end
					end
				end
				uf.Absorb:SetWidth(rec)
				uf.Absorb:Show()
				uf.AbsorbOverlay:Show()
			else
				uf.Absorb:Hide()
				uf.AbsorbOverlay:Hide()
			end
		end

		-- TOP TEXT STUFF
		local text = ""
		local class = UnitClass(unit)
		local name = UnitName(unit)
		if class == nil then
			class = ""
		end
		if name == nil then
			name = ""
		end
		if TOP_TEXT_TYPE == "Name" then
			text = name
		elseif TOP_TEXT_TYPE == "Class" then
			text = class
		elseif TOP_TEXT_TYPE == "Class + Name" then
			text = string.sub(class, 0, 3) .. ". " .. name
		elseif TOP_TEXT_TYPE == "Name + Class" then
			text = string.sub(name, 0, 3) .. ". " .. class
		end
		if HP_WIDTH - 16 * 2 > 0 then
			uf.HealthTextTop:SetWidth(HP_WIDTH - 16 * 2)
		else
			uf.HealthTextTop:SetWidth(1)
		end
		uf.HealthTextTop:SetHeight(14)
		uf.HealthTextTop:SetText(text)

		-- CENTER TEXT STUFF
		local HealthTextCen = ":O"
		if HP_TEXT_TYPE == "Health in Percent" and SHOW_HP then
			local rec = UnitHealth(unit) / UnitHealthMax(unit) * 100
			local val = string.format("%." .. GetConfig("DECIMALS", 0) .. "f", rec)
			if rec > 0 then
				HealthTextCen = val .. "%"
			else
				HealthTextCen = ""
			end
		elseif HP_TEXT_TYPE == "Only health" and SHOW_HP then
			local val = string.format(UnitHealth(unit))
			HealthTextCen = val
		else
			HealthTextCen = ""
		end
		if not UnitIsConnected(unit) then
			HealthTextCen = PLAYER_OFFLINE
		elseif UnitIsDead(unit) then
			HealthTextCen = DEAD
		end

		uf.HealthTextCen:SetText(HealthTextCen)

		-- BOTTOM TEXT STUFF
		if UnitLevel(unit) > 9 and SHOW_CLASS then
			uf.HealthTextBot:SetText(class);
		else
			uf.HealthTextBot:SetText("")
		end

		local class, classEng, classIndex = UnitClass(unit)
		if class ~= nil then
			local r, g, b, argbHex = GetClassColor(classEng)
			uf.HealthBar:SetVertexColor(r, g, b, 1)
			if PFBUILD ~= "CLASSIC" then
				uf.Prediction:SetVertexColor(r + 0.2, g + 0.2, b + 0.2)

				uf.Absorb:SetVertexColor(1, 1, 1)
			end
		end
		
		local status = UnitThreatSituation(unit);
		if status and status > 0 then
			if GetThreatStatusColor ~= nil then
				uf.Aggro:SetVertexColor(GetThreatStatusColor(status))
			else
				uf.Aggro:SetVertexColor(1, 0, 0)
			end
			uf.Aggro:SetAlpha(0.9)

			uf.Aggro:Show()
		else
			uf.Aggro:Hide()
		end



		if PFBUILD ~= "CLASSIC" then
			if UnitGroupRolesAssigned(unit) ~= "NONE" then
				uf.HealthBackground.RoleIcon:SetTexCoord(GetTexCoordsForRoleSmallCircle(UnitGroupRolesAssigned(unit)));
				uf.HealthBackground.RoleIcon:Show()
			else
				uf.HealthBackground.RoleIcon:Hide()
			end
		end



		local class, classEng, classID = UnitClass(unit)
		local t = CLASS_ICON_TCOORDS[select(2, UnitClass(unit))]
		if t and UnitIsPlayer(unit) then
			uf.HealthBackground.ClassIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
			uf.HealthBackground.ClassIcon:SetTexCoord(unpack(t))
		end

		local guid = UnitGUID(unit)
		local lang = nil
		if guid then
			local server = tonumber(strmatch(guid, "^Player%-(%d+)"))
			local realm = PFRealms[server]
			if realm then
				local s, e = string.find(realm, ",")
				realm = string.sub(realm, s + 1)

				local s2, e2 = string.find(realm, ",")
				if e2 then
					lang = string.sub(realm, 0, e2 - 1)
				else
					lang = realm
				end
			end
		end
		if PFBUILD == "CLASSIC" then
			uf.HealthBackground.LangIcon:Hide()
		elseif lang ~= nil and UnitIsPlayer(unit) and uf.HealthBackground.LangIcon.lang ~= lang then
			uf.HealthBackground.LangIcon.lang = lang
			uf.HealthBackground.LangIcon:SetTexture("Interface\\Addons\\PartyFrames\\assets\\" .. lang)
			uf.HealthBackground.LangIcon:Show()
		elseif lang == nil then
			uf.HealthBackground.LangIcon:Hide()
		end


		if UnitIsGroupLeader(unit) then
			uf.HealthBackground.RankIcon:SetTexture("Interface/GroupFrame/UI-Group-LeaderIcon")
		elseif UnitIsGroupAssistant(unit) then
			uf.HealthBackground.RankIcon:SetTexture("Interface/GroupFrame/UI-Group-AssistantIcon")
		else
			uf.HealthBackground.RankIcon:SetTexture(nil)
		end



		-- READY CHECK
		local readyCheckStatus = GetReadyCheckStatus(unit);
		if PF.rcts and PF.rcts > GetTime() then
			if PF.rcfinished then
				if uf.HealthBackground.ReadyCheck.readyCheckStatus == "waiting" then
					uf.HealthBackground.ReadyCheck:SetTexture(READY_CHECK_NOT_READY_TEXTURE);
					uf.HealthBackground.ReadyCheck:Show();
				end
			else
				if readyCheckStatus ~= nil then
					uf.HealthBackground.ReadyCheck.readyCheckStatus = readyCheckStatus
				end
				if readyCheckStatus == "ready" then
					uf.HealthBackground.ReadyCheck:SetTexture(READY_CHECK_READY_TEXTURE);
					uf.HealthBackground.ReadyCheck:Show();
				elseif readyCheckStatus == "notready" then
					uf.HealthBackground.ReadyCheck:SetTexture(READY_CHECK_NOT_READY_TEXTURE);
					uf.HealthBackground.ReadyCheck:Show();
				elseif readyCheckStatus == "waiting" then
					uf.HealthBackground.ReadyCheck:SetTexture(READY_CHECK_WAITING_TEXTURE);
					uf.HealthBackground.ReadyCheck:Show();
				end
			end
		else
			uf.HealthBackground.ReadyCheck:Hide();
		end



		-- RaidIcon
		if GetRaidTargetIndex(unit) then
			uf.RaidIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. GetRaidTargetIndex(unit))
		else
			uf.RaidIcon:SetTexture(nil)
		end



		local _, class = UnitClass(unit);
		-- POWER
		if SHOW_POWER then
			local power = UnitPower(unit, Enum.PowerType.Mana)
			local powermax = UnitPowerMax(unit, Enum.PowerType.Mana)
			if class == "MONK" then
				power = UnitPower(unit)
				powermax = UnitPowerMax(unit)
			elseif powermax == 0 then
				power = UnitPower(unit)
				powermax = UnitPowerMax(unit)
			end

			uf.PowerBar:SetHeight(POWER_HEIGHT)
			if power and powermax and power > 0 and powermax > 0 and power <= powermax then
				uf.PowerBar:SetWidth(power / powermax * HP_WIDTH)

				uf.PowerTextCen:SetText(string.format("%." .. GetConfig("DECIMALS", 0) .. "f", power / powermax * 100) .. "%")

				uf.PowerBar:Show()
			else
				uf.PowerTextCen:SetText("0.0%")

				uf.PowerBar:Hide()
			end
			uf.PowerBackground:Show()
			uf.PowerTextCen:Show()
		else
			uf.PowerBackground:Hide()
			uf.PowerBar:Hide()
			uf.PowerTextCen:Hide()
		end



		local powerType, powerToken, altR, altG, altB = nil
		local powermax = UnitPowerMax(unit, Enum.PowerType.Mana)
		if powermax and powermax > 0 and class ~= "MONK" then
			local info = PowerBarColor["MANA"];
			powerType = 0
			powerToken = "MANA"
			altR = info.r
			altG = info.g
			altB = info.b
			if ( info ) then
				uf.PowerBar:SetVertexColor(info.r, info.g, info.b, 1)
			end
		else
			powerType, powerToken, altR, altG, altB = UnitPowerType(unit);
			local info = PowerBarColor[powerToken];
			if ( info ) then
				uf.PowerBar:SetVertexColor(info.r, info.g, info.b)
			end
		end



		-- Buff
		local idbu = 1
		for i = 1, 20 do
			local name, icon, count, debuffType, duration, expirationTime, unitCaster = UnitBuff(unit, i, "RAID")
			if idbu > 7 then
				break
			end
			if PFBUILD == "CLASSIC" then
				duration = 1
			end
			if name and duration > 0 then
				if uf.BuffBar[idbu].Icon ~= nil then
					uf.BuffBar[idbu].Icon:SetTexture(icon);
				end

				if count and count > 1 then
					local countText = count;
					if ( count >= 100 ) then
						countText = BUFF_STACKS_OVERFLOW;
					end
					uf.BuffBar[idbu].count:Show();
					uf.BuffBar[idbu].count:SetText(countText);
				else
					uf.BuffBar[idbu].count:Hide();
				end

				if unitCaster == "player" then
					uf.BuffBar[idbu]:SetAlpha(1.0);
				else
					uf.BuffBar[idbu]:SetAlpha(0.5);
				end

				local enabled = expirationTime and expirationTime ~= 0;
				if enabled then
					local startTime = expirationTime - duration;
					CooldownFrame_Set(uf.BuffBar[idbu].cooldown, startTime, duration, true);
				else
					CooldownFrame_Clear(uf.BuffBar[idbu].cooldown);
				end

				idbu = idbu + 1
			elseif name == nil then
				break
			end
		end
		for i = idbu, 7 do
			CooldownFrame_Clear(uf.BuffBar[i].cooldown);
			if uf.BuffBar[i].Icon ~= nil then
				uf.BuffBar[i].Icon:SetTexture(nil);
			end

			if uf.BuffBar[i].count ~= nil then
				uf.BuffBar[i].count:Hide();
			end

			uf.BuffBar[i].count:Hide();
		end

		-- Debuff
		local idde = 1
		for i = 1, 20 do
			local name, icon, count, debuffType, duration, expirationTime, unitCaster = UnitDebuff(unit, i)
			if idde > 7 then
				break
			end
			local allowed = false
			if debuffType ~= nil then

					allowed = GetConfig("G" .. debuffType, true, true)

			else
					allowed = GetConfig("G" .. "None", true, true)
			end

			if name ~= nil and (unitCaster == "player" or debuffType ~= nil) and allowed then
				if uf.DebuffBar[idde].Icon ~= nil then
					uf.DebuffBar[idde].Icon:SetTexture(icon);
				end

				if count and count > 1 then
					local countText = count;
					if ( count >= 100 ) then
						countText = BUFF_STACKS_OVERFLOW;
					end
					uf.DebuffBar[idde].count:Show();
					uf.DebuffBar[idde].count:SetText(countText);
				else
					uf.DebuffBar[idde].count:Hide();
				end

				if uf.DebuffBar[idde].Border then
					local color = DebuffTypeColor["none"]
					if DebuffTypeColor[debuffType] ~= nil then
						color = DebuffTypeColor[debuffType]
					end
					uf.DebuffBar[idde].Border:SetVertexColor(color.r, color.g, color.b);
					uf.DebuffBar[idde].Border:Show()

					if uf.DebuffBar[idde].symbol then
						local fontFamily, fontSize, fontFlags = uf.DebuffBar[idde].symbol:GetFont()
						uf.DebuffBar[idde].symbol:SetFont(fontFamily, 9, fontFlags)
						uf.DebuffBar[idde].symbol:SetWidth(DEBUFF_SIZE)
						uf.DebuffBar[idde].symbol:SetHeight(DEBUFF_SIZE / 2)
						if DebuffTypeSymbol[debuffType] ~= nil then
							uf.DebuffBar[idde].symbol:SetText(DebuffTypeSymbol[debuffType]);
						end
						uf.DebuffBar[idde].symbol:SetVertexColor(color.r, color.g, color.b);
					end
				end

				uf.DebuffBar[idde]:SetID(i);
				uf.DebuffBar[idde].unit = unit;
				uf.DebuffBar[idde].filter = nil;
				uf.DebuffBar[idde]:SetAlpha(1.0);
				uf.DebuffBar[idde].exitTime = nil;
				uf.DebuffBar[idde]:Show();

				local enabled = expirationTime and expirationTime ~= 0;
				if enabled then
					local startTime = expirationTime - duration;
					CooldownFrame_Set(uf.DebuffBar[idde].cooldown, startTime, duration, true);
				else
					CooldownFrame_Clear(uf.DebuffBar[idde].cooldown);
				end

				idde = idde + 1
			elseif name == nil then
				break
			end
		end
		for i = idde, 7 do
			if uf.DebuffBar[i].Icon ~= nil then
				uf.DebuffBar[i].Icon:SetTexture(nil);
			end

			if uf.DebuffBar[i].symbol then
				uf.DebuffBar[i].symbol:SetText("");
			end

			if uf.DebuffBar[i].Border ~= nil then
				uf.DebuffBar[i].Border:Hide()
			end

			if uf.DebuffBar[i].count ~= nil then
				uf.DebuffBar[i].count:Hide();
			end

			CooldownFrame_Clear(uf.DebuffBar[i].cooldown);
		end


		if UnitInRange(unit) or unit == "PLAYER" then
			uf:SetAlpha(1)
		else
			uf:SetAlpha(0.2)
		end



		uf:Show()
		if not InCombatLockdown() then
			uf.btn:Show()
			ClickCastFrames[uf.btn] = true -- "Clicked" Support
		end
	else
		uf:Hide()
		if not InCombatLockdown() then
			uf.btn:Hide()
			ClickCastFrames[uf.btn] = false -- "Clicked" Support
		end
	end
end

function PFOnUpdate()
	if PFUpdating then
		PFUpdating = false
		if PF.size ~= GetNumGroupMembers() then
			PF.size = GetNumGroupMembers()
			
			PFSizing = true
		end

		if PF.typ ~= "group" then
			PF.typ = "group"
			PFSizing = true
		end


		if not InCombatLockdown() and not PF:IsShown() then
			PF:Show()
		end
		for i, uf in pairs(PF.FRAMES) do
			local unit = PFSortedUnits[uf.id]
			if unit and UnitExists(unit) then
				UpdateUnitInfo(uf, unit)
			else
				uf:Hide()
				if not InCombatLockdown() then
					uf.btn:Hide()
				end
			end
		end
	end
	C_Timer.After(0.3, function()
		PFUpdating = true
		PFOnUpdate()
	end)
end

PF:RegisterEvent("READY_CHECK")
PF:RegisterEvent("READY_CHECK_CONFIRM")
PF:RegisterEvent("READY_CHECK_FINISHED")
function PF:OnEvent(event)
	if event == "READY_CHECK" then
		PF.rcts = GetTime() + 11
		PF.rcfinished = false
	elseif event == "READY_CHECK_FINISHED" then
		PF.rcfinished = true
	end
	PFUpdating = true
end
PF:SetScript("OnEvent", PF.OnEvent)




function ShowPartyFrame()
	-- placeholder
end

-- Hide Group Frame
for i = 1, 4 do
	local partyframe = _G["PartyMemberFrame" .. i]
	if partyframe ~= nil then
		partyframe:UnregisterAllEvents()
		partyframe.OldShow = partyframe.Show
		function partyframe:Show()
			-- placeholder
		end
		partyframe:Hide()
	end
end

-- Hide Raid Frame
if _G["CompactRaidFrameContainer"] ~= nil then
	local crfc = _G["CompactRaidFrameContainer"]
	crfc:UnregisterAllEvents()
	crfc.OldShow = crfc.Show
	function crfc:Show()
		-- placeholder
	end
	crfc:Hide()
end