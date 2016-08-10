
local name = ...

local frame = CreateFrame("Frame", "LegionInvasionTimer", UIParent)
frame:SetPoint("CENTER", UIParent, "CENTER")
frame:SetWidth(180)
frame:SetHeight(15)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetClampedToScreen(true)
frame:SetScript("OnDragStart", function(f) f:StartMoving() end)
frame:SetScript("OnDragStop", function(f) f:StopMovingOrSizing() end)
frame:RegisterEvent("PLAYER_LOGIN")

local bg = frame:CreateTexture(nil, "PARENT")
bg:SetAllPoints(frame)
bg:SetColorTexture(0, 1, 0, 0.3)

local header = frame:CreateFontString("TargetPercentText", "OVERLAY", "TextStatusBarText")
header:SetAllPoints(frame)
header:SetText(name)

-- LIBRARIES
local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")

local function startBar(timeLeft)
	local bar = candy:New(media:Fetch("statusbar", "BantoBar"), 200, 30)
	bar:SetLabel("Invasion")
	bar.candyBarLabel:SetJustifyH("LEFT")
	bar:SetDuration(timeLeft)
	bar:SetIcon(236292) -- Interface\\Icons\\Ability_Warlock_DemonicEmpowerment
	bar:SetPoint("TOP", LegionInvasionTimer, "BOTTOM")
	bar:Start()
end

frame:SetScript("OnEvent", function()
	local found = false

	for i=1, 300 do
		local name, timeLeftMinutes, rewardQuestID = GetInvasionInfoByMapAreaID(i)
		if timeLeftMinutes and timeLeftMinutes > 0 then
			found = true
			invasionTimerDB = {GetTime(), timeLeftMinutes}

			startBar(timeLeftMinutes * 60)
			break
		end
	end

	if not found and invasionTimerDB then
		local t, rem = invasionTimerDB[1], invasionTimerDB[2]
		if t and rem then
			local deduct = (GetTime() - t) / 60
			local timeLeftMinutes = rem - deduct
			startBar(timeLeftMinutes * 60)
		end
	end
end)

