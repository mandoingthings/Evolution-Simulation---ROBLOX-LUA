local Organism = script.Parent.Parent.Parent
local OraganismsFolder = game.Workspace:WaitForChild("OrganismsFolder")
local StatsFolder = Organism:WaitForChild("Stats")
local Points = StatsFolder:WaitForChild("Points")
local Morality = StatsFolder:WaitForChild("Morality")
local Genetics = StatsFolder:WaitForChild("Genetics")
local BreedingIncentive = StatsFolder:WaitForChild("BreedingIncentive")
local Health = StatsFolder:WaitForChild("Health")
local Energy = StatsFolder:WaitForChild("Energy")
local HuntingFood = StatsFolder:WaitForChild("HuntingFood")
local Speed = StatsFolder:WaitForChild("Speed")
local Hunger = StatsFolder:WaitForChild("Hunger")
local Male = StatsFolder:WaitForChild("Male")
local BirthReady = StatsFolder:WaitForChild("BirthReady")

Hunger.Changed:Connect(function()
	
	

	
	
	if Hunger.Value >= 51 then
		Organism.Color = Color3.new(1, 0, 0)
	elseif Hunger.Value <= 50 and Hunger.Value >= 26 then
		Organism.Color = Color3.new(0.721569, 0, 0)
	elseif Hunger.Value <= 25 and Hunger.Value >= 11  then
		Organism.Color = Color3.new(0.34902, 0, 0)
	elseif Hunger.Value <= 10 then
		Organism.Color = Color3.new(0, 0, 0)
		if Hunger.Value < 1 then
			Organism:Destroy()
		end
	end
end)