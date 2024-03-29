-- By Smagumas

PFBUILD = "CLASSIC"
if select(4, GetBuildInfo()) > 20000 then
	PFBUILD = "RETAIL"
end


local PFLoaded = false

PFTAB = PFTAB or {}
PFTABPC = PFTABPC or {}

function GetConfig(key, value, pc)
	if PFLoaded then
		if PFTAB ~= nil and PFTABPC ~= nil then
			if pc then
				if PFTABPC[key] ~= nil then
					value = PFTABPC[key]
				else
					PFTABPC[key] = value
				end
			else
				if PFTAB[key] ~= nil then
					value = PFTAB[key]
				else
					PFTAB[key] = value
				end
			end
		end
	end
	return value
end



function CreateSlider(parent, key, vval, x, y, vmin, vmax, steps, lstr, w)
	local SL = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
	if w == nil then
		w = 200
	end
	SL:SetWidth(w)
	SL:SetPoint("TOPLEFT", x, y)

	SL.Low:SetText(vmin)
	SL.High:SetText(vmax)
	
	SL.Text:SetText(PFGT(lstr) .. ": " .. GetConfig(key, vval))

	SL:SetMinMaxValues(vmin, vmax)

	SL:SetValue(GetConfig(key, vval))

	SL:SetObeyStepOnDrag(steps)
	SL:SetValueStep(steps)

	SL:SetScript("OnValueChanged", function(self, val)
		val = string.format("%.0f", val)
		PFTAB[key] = val
		SL.Text:SetText(PFGT(lstr) .. ": " .. val)

		PFSizing = true
	end)

	return SL
end

function CreateCheckBox(parent, key, vval, x, y, lstr, pc)
	local CB = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
	CB:SetSize(18, 18)

	CB:SetPoint("TOPLEFT", x, y)

	CB.Text:SetPoint("LEFT", CB, "RIGHT", 0, 0)
	CB.Text:SetText(PFGT(lstr))

	CB:SetChecked(GetConfig(key, vval))

	CB:SetScript("OnClick", function(self, val)
		val = CB:GetChecked()
		if pc then
			PFTABPC[key] = val
		else
			PFTAB[key] = val
		end
		CB.Text:SetText(PFGT(lstr))

		PFSizing = true
	end)

	return CB
end

function CreateComboBox(parent, key, vval, x, y, lstr, tab)
	local CB = L_Create_UIDropDownMenu("Frame", parent)
	CB:SetPoint("TOPLEFT", x, y)

	
	CB.text = CB:CreateFontString(nil, "ARTWORK") 
	CB.text:SetFont("Fonts\\ARIALN.ttf", 12, "")
	CB.text:SetText(PFGT(lstr))
	CB.text:SetPoint("LEFT", CB, "RIGHT", 0, 3)

	L_UIDropDownMenu_SetWidth(CB, 120)
	L_UIDropDownMenu_SetText(CB, GetConfig(key, vval))

	-- Create and bind the initialization function to the dropdown menu
	L_UIDropDownMenu_Initialize(CB, function(self, level, menuList)
		for i, v in pairs(tab) do
			local info = L_UIDropDownMenu_CreateInfo()
			info.func = self.SetValue
			info.text = v
			info.arg1 = v
			L_UIDropDownMenu_AddButton(info)
		end
	end)

	function CB:SetValue(newValue)
		PFTAB[key] = newValue
		L_UIDropDownMenu_SetText(CB, newValue)
		L_CloseDropDownMenus()

		PFSizing = true
	end


	return CB
end



local Y = 0

local SORTTAB = {}
SORTTAB = {"Group", "Role"}

function InitSettings()
	local PFSettings = {}

	local PFname = "PartyFrames"

	local settingname = PFname
	PFSettings.panel = CreateFrame("FRAME")
	PFSettings.panel.name = settingname

	Y = 0
	XGAP = 250
	XDEFAULT = 50
	YGAP = 32
	-- local text = PFSettings.panel:CreateFontString(nil, "ARTWORK")
	-- text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
	-- text:SetPoint("TOPLEFT", PFSettings.panel, "TOPLEFT", 10, Y)
	-- text:SetText("Sample text")

	-- Parent panel stuff
	-- CreateSlider: parent, key, vval, x, y, vmin, vmax, steps, lstr
	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.panel, "DECIMALS", 0, X, Y, 0, 3, 1, "DECIMALS")
	X = X + XGAP
	CreateCheckBox(PFSettings.panel, "SHOW_POWER", true, X, Y, "SHOW_POWER")
	Y = Y - YGAP
	CreateCheckBox(PFSettings.panel, "SHOW_HP", true, X, Y, "SHOW_HP")
	Y = Y - YGAP
	CreateCheckBox(PFSettings.panel, "SHOW_CLASS", true, X, Y, "SHOW_CLASS")
	Y = Y - YGAP
	X = XDEFAULT
	CreateCheckBox(PFSettings.panel, "MISSING_HP_COLOR", true, X, Y, "MISSING_HP_COLOR")
	Y = Y - YGAP + 10;
	X = XDEFAULT
	CreateCheckBox(PFSettings.panel, "PLAY_SOUND_LOW_HP", true, X, Y, "PLAY_SOUND_LOW_HP")
	Y = Y - YGAP
	CreateSlider(PFSettings.panel, "MISSING_HP_YELLOW", 0, X, Y, 0, 100, 1, "MISSING_HP_YELLOW")
	X = X + XGAP
	CreateSlider(PFSettings.panel, "MISSING_HP_RED", 0, X, Y, 0, 100, 1, "MISSING_HP_RED")




	local b = CreateFrame("Button", "MyButton", PFSettings.panel, "UIPanelButtonTemplate")
	b:SetSize(200, 24) -- width, height
	b:SetText("Support development")
	b:SetPoint("BOTTOMLEFT", 10, 10)
	b:SetScript("OnClick", function()
		local iconbtn = 32
		local s = CreateFrame("Frame", nil, UIParent) -- parent
		s:SetSize(300, 2 * iconbtn + 2 * 10)
		s:SetPoint("CENTER")

		s.texture = s:CreateTexture(nil, "BACKGROUND")
		s.texture:SetColorTexture(0, 0, 0, 0.5)
		s.texture:SetAllPoints(s)

		s.text = s:CreateFontString(nil,"ARTWORK") 
		s.text:SetFont("Fonts\\ARIALN.ttf", 11, "")
		s.text:SetText("Support")
		s.text:SetPoint("CENTER", s, "TOP", 0, -10)

		local eb = CreateFrame("EditBox", "logEditBox", s, "InputBoxTemplate")
		eb:SetFrameStrata("DIALOG")
		eb:SetSize(280, iconbtn)
		eb:SetAutoFocus(false)
		eb:SetText("https://paypal.me/Smagumas")
		eb:SetPoint("TOPLEFT", 10, -10 - iconbtn)

		s.close = CreateFrame("Button", "closepaypal", s, "UIPanelButtonTemplate")
		s.close:SetFrameStrata("DIALOG")
		s.close:SetPoint("TOPLEFT", 300 - 10 - iconbtn, -10)
		s.close:SetSize(iconbtn, iconbtn)
		s.close:SetText("X")
		s.close:SetScript("OnClick", function(self, btn, down)
			s:Hide()
		end)
	end)

	InterfaceOptions_AddCategory(PFSettings.panel)

	local settinggname = PARTY
	PFSettings.gpanel = CreateFrame("FRAME", settinggname, PFSettings.panel)
	PFSettings.gpanel.name = settinggname
	PFSettings.gpanel.parent = settingname

	Y = 0
	Y = Y - 10
	local X = 360
	PFSettings.gpanel.Text = PFSettings.gpanel:CreateFontString(nil, "ARTWORK")
	PFSettings.gpanel.Text:SetFont("Fonts\\ARIALN.ttf", 11, "")
	PFSettings.gpanel.Text:SetPoint("TOPLEFT", PFSettings.gpanel, "TOPLEFT", X, Y)
	PFSettings.gpanel.Text:SetText(PFGT("DEBUFF_TYPES"))

	Y = Y - 18
	for i, v in pairs(DebuffTypeSymbol) do
		CreateCheckBox(PFSettings.gpanel, "G" .. i, true, X, Y, i, true) -- parent, key, vval, x, y, lstr)
		Y = Y - 18
	end
	CreateCheckBox(PFSettings.gpanel, "G" .. "None", true, X, Y, "None", true)

	XGAP = 250
	XDEFAULT = 20
	YGAP = 32

	Y = -10
	CreateComboBox(PFSettings.gpanel, "GSORT", "Role", 0, Y, "SORTTYPE", SORTTAB)

	Y = Y - YGAP
	CreateComboBox(PFSettings.gpanel, "GTETOTY", "Name", 0, Y, "TOP_TEXT_TYPE", {"Name", "Class", "Class + Name", "Name + Class", "None"})

	Y = Y - YGAP
	CreateComboBox(PFSettings.gpanel, "GTECETY", "Health in Percent", 0, Y, "HP_TEXT_TYPE", {"Health in Percent", "Only health", "None"})

	Y = Y - YGAP
	CreateCheckBox(PFSettings.gpanel, "HORIZ_PARTY", false, 12, Y, "HORIZ_PARTY") -- parent, key, vval, x, y, lstr)

	Y = Y - 20
	CreateCheckBox(PFSettings.gpanel, "GOVER", true, 12, Y, "OVERLAP") -- parent, key, vval, x, y, lstr)

	Y = Y - 48
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "OUTER_BORDER", 6, X, Y, 0, 20, 1, "OUTER_BORDER")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "ROW_SPACING", 6, X, Y, 0, 50, 1, "ROW_SPACING")

	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "COLUMN_SPACING", 6, X, Y, 0, 50, 1, "COLUMN_SPACING")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "HP_WIDTH", 120, X, Y, 20, 300, 1, "HP_WIDTH")

	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "HP_HEIGHT", 60, X, Y, 20, 300, 1, "HP_HEIGHT")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "POWER_WIDTH", 120, X, Y, 8, 300, 1, "POWER_WIDTH")

	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "POWER_HEIGHT", 20, X, Y, 8, 300, 1, "POWER_HEIGHT")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "DEBUFF_SIZE", 16, X, Y, 8, 64, 1, "DEBUFF_SIZE")

	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "BUFF_SIZE", 16, X, Y, 8, 64, 1, "BUFF_SIZE")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "HP_SIZE", 11, X, Y, 8, 64, 1, "HP_SIZE")

	Y = Y - YGAP
	X = XDEFAULT
	CreateSlider(PFSettings.gpanel, "HP_POS_X", 16, X, Y, -20, 20, 1, "HP_POS_X")
	X = X + XGAP
	CreateSlider(PFSettings.gpanel, "HP_POS_Y", 16, X, Y, -20, 20, 1, "HP_POS_Y")

	InterfaceOptions_AddCategory(PFSettings.gpanel)
end



local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("GROUP_ROSTER_UPDATE")
function f:OnEvent(event)
	if event == "GROUP_ROSTER_UPDATE" then
		PFSizing = true
	end

	if event == "PLAYER_ENTERING_WORLD" then
		PFLoaded = true

		PFSizing = true
		PFUpdateSize()

		PFUpdating = true
		PFOnUpdate()

		C_Timer.After(0, function()
            InitSettings()
		end)
	end
end
f:SetScript("OnEvent", f.OnEvent)

-- SLASH_PARTYFRAMES1 = "/partyframes";
-- SLASH_PF1 = "/pf";



-- local function runPartyFrames()
--     -- local name = UnitName("player");

--     print("Party Frames is running <3");
--     -- f();
-- end

-- SlashCmdList["PARTYFRAMES"] = runPartyFrames;
-- SlashCmdList["PF"] = runPartyFrames;