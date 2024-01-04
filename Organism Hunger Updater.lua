local Organism = script.Parent.Parent.Parent
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
local Male = StatsFolder:WaitForChild("Male")
local BirthReady = StatsFolder:WaitForChild("BirthReady")

while wait(1) do
	if BirthReady.Value == false then
		script.Parent.Value = script.Parent.Value - (10/(Genetics.Value/10))/100
	else
		script.Parent.Value = script.Parent.Value - (5/(Genetics.Value/10))/100
	end
end