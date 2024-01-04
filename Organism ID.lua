local Organism = script.Parent.Parent
local OraganismsFolder = game.Workspace:WaitForChild("OrganismsFolder")
local StatsFolder = Organism:WaitForChild("Stats")
local Points = StatsFolder:WaitForChild("Points")
local Owner = StatsFolder:WaitForChild("Owner")
local Morality = StatsFolder:WaitForChild("Morality")
local Genetics = StatsFolder:WaitForChild("Genetics")
local Health = StatsFolder:WaitForChild("Health")
local Speed = StatsFolder:WaitForChild("Speed")
local Hunger = StatsFolder:WaitForChild("Hunger")
local ClaimButton = Organism:WaitForChild("ClaimButton")
local ID = Organism:WaitForChild("ID")
local RandomId = math.random(1,9999)
local IDFound = false
repeat
	for i, v in ipairs(OraganismsFolder:GetChildren()) do
	if v:IsA("Part") and v:FindFirstChild("ID") then
		if v.ID ~= RandomId then
			ID.Value = RandomId
			IDFound = true
		else
			IDFound = false
		end
	end
end
	wait()
until IDFound == true

