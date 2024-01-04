local Organism = script.Parent.Parent.Parent
local OraganismsFolder = game.Workspace:WaitForChild("OrganismsFolder")
local StatsFolder = Organism:WaitForChild("Stats")
local Points = StatsFolder:WaitForChild("Points")
local Morality = StatsFolder:WaitForChild("Morality")
local Genetics = StatsFolder:WaitForChild("Genetics")
local Health = StatsFolder:WaitForChild("Health")
local Speed = StatsFolder:WaitForChild("Speed")
local Hunger = StatsFolder:WaitForChild("Hunger")

if Hunger and Genetics then
	Speed.Value = (Hunger.Value / 15) * Genetics.Value
end

Hunger.Changed:Connect(function()
	Speed.Value = (Hunger.Value / 15) * Genetics.Value
end)