local Organism = script.Parent.Parent.Parent
local OraganismsFolder = game.Workspace:WaitForChild("OrganismsFolder")
local StatsFolder = Organism:WaitForChild("Stats")
local Points = StatsFolder:WaitForChild("Points")
local Morality = StatsFolder:WaitForChild("Morality")
local Genetics = StatsFolder:WaitForChild("Genetics")
local BreedingIncentive = StatsFolder:WaitForChild("BreedingIncentive")
local Health = StatsFolder:WaitForChild("Health")
local Partner = StatsFolder:WaitForChild("Partner")
local BirthReady = StatsFolder:WaitForChild("BirthReady")
local Owner = StatsFolder:WaitForChild("Owner")
local Claimed = StatsFolder:WaitForChild("Claimed")
local ID = Organism:WaitForChild("ID")
local Male = StatsFolder:WaitForChild("Male")
local Energy = StatsFolder:WaitForChild("Energy")
local Task = StatsFolder:WaitForChild("Task")
local HuntingFood = StatsFolder:WaitForChild("HuntingFood")
local Speed = StatsFolder:WaitForChild("Speed")
local Hunger = StatsFolder:WaitForChild("Hunger")
local RepStorage = game:GetService("ReplicatedStorage")
local StartEvent = RepStorage:FindFirstChild("StartEvent")
local PauseEvent = RepStorage:FindFirstChild("PauseEvent")
local TweenService = game:GetService("TweenService")
local FoodFolder = game.Workspace.Food
local Tweeninfo
local Time = 0
local Target = {}
local Hunting = "Food1"
local Distance
local PointsEarned = {"Food", nil}
local Object
local FoodHunt = false
local Prize = 0
local NeedFood = false
local MateFound
local FoundPartner = false
local cooldown = false

wait(1.5)


local function FindFood()
	local highestPrize = -math.huge
	local closestPrize = math.huge
	local selectedFood = nil

	for _, v in ipairs(FoodFolder:GetChildren()) do
		local distance = (v.Position - Organism.Position).Magnitude
		local prize = v.Worth.Value - (distance / 100)

		if distance < closestPrize then
			closestPrize = distance
		end

		if prize > highestPrize then
			highestPrize = prize
			selectedFood = v
		end
	end

	local closestFood = nil
	local closestDistance = math.huge

	for _, v in ipairs(FoodFolder:GetChildren()) do
		local distance = (v.Position - Organism.Position).Magnitude

		if distance < closestDistance then
			closestDistance = distance
			closestFood = v
		end
	end

	if selectedFood then
		local extraPoints = 1 
		if Hunger.Value <= 50 and Hunger.Value >=26 then
			extraPoints = 15
			if (selectedFood.Position - Organism.Position).Magnitude > ((closestFood.Position - Organism.Position).Magnitude)-1.5 then
				selectedFood = closestFood
			end

		elseif Hunger.Value <= 25 then
			extraPoints = 25
			selectedFood = closestFood
		end
		if selectedFood ~= closestFood then
			for i, v in ipairs(OraganismsFolder:GetChildren()) do
				if v ~= Organism then
					if v:IsA("Part") or v.Name == "Organism" then
						local TimeCompare = ((selectedFood.Position - v.Position).Magnitude) / v:FindFirstChild("Stats"):FindFirstChild("Speed").Value
						if (selectedFood.Position - v.Position).Magnitude < (selectedFood.Position - Organism.Position).Magnitude or TimeCompare < ((selectedFood.Position - Organism.Position).Magnitude) / Speed.Value then
							if v:FindFirstChild("Stats"):FindFirstChild("Genetics").Value > Genetics.Value and (selectedFood.Position - Organism.Position).Magnitude + 3 < (selectedFood.Position - v.Position).Magnitude then
								closestDistance = math.huge
								for _, v in ipairs(FoodFolder:GetChildren()) do
									if v ~= selectedFood then
										local distance = (v.Position - Organism.Position).Magnitude

										if distance < closestDistance then
											closestDistance = distance
											closestFood = v
										end
									end
								end
								selectedFood = closestFood


							elseif v:FindFirstChild("Stats"):FindFirstChild("Genetics").Value == Genetics.Value then
								highestPrize = -math.huge
								closestPrize = math.huge
								for _, newT in ipairs(FoodFolder:GetChildren()) do
									if newT ~= selectedFood then

										local distance = (newT.Position - Organism.Position).Magnitude
										local prize = newT.Worth.Value - (distance / 100)

										-- Reward the closest food with extra points
										if distance < closestPrize then
											closestPrize = distance
										end

										if prize > highestPrize then
											highestPrize = prize
											selectedFood = newT

										end
									end										
								end	
							elseif v:FindFirstChild("Stats"):FindFirstChild("Genetics").Value < Genetics.Value and ((v.Position - Organism.Position).Magnitude) < ((selectedFood.Position - v.Position).Magnitude) and v:FindFirstChild("Stats"):FindFirstChild("Speed").Value < Speed.Value then

							elseif v:FindFirstChild("Stats"):FindFirstChild("Genetics").Value < Genetics.Value and ((v.Position - Organism.Position).Magnitude) > ((selectedFood.Position - v.Position).Magnitude) or v:FindFirstChild("Stats"):FindFirstChild("Speed").Value > Speed.Value then
								highestPrize = -math.huge
								closestPrize = math.huge
								for _, newT in ipairs(FoodFolder:GetChildren()) do
									if newT ~= selectedFood then
										local distance = (newT.Position - Organism.Position).Magnitude
										local prize = newT.Worth.Value - (distance / 100)

										if distance < closestPrize then
											closestPrize = distance
										end

										if prize > highestPrize then
											highestPrize = prize
											selectedFood = newT


										end
									end										
								end	

							end				
						end
					end
				end					
			end
		end


		highestPrize = highestPrize + extraPoints

		Target = {selectedFood.Name, highestPrize}
		Object = selectedFood
	else
		Target = nil
		Object = nil
		Time = 0
	end

end

local function reverseSort(a, b)
	return a > b 
end
local function randomFifty()
	return math.random(1,2)
end


local function FindMate()
	local Closest = {}
	local HighestRewarding = {}

	for i, v in ipairs(OraganismsFolder:GetChildren()) do
		if v:IsA("Part") and v:FindFirstChild("ID").Value ~= ID.Value and v:FindFirstChild("Stats"):FindFirstChild("Male").Value ~= Male.Value and v:FindFirstChild("Stats"):FindFirstChild("Partner").Value == "" then
			local Distance = (v.Position - Organism.Position).Magnitude
			local PartnerGene = v:FindFirstChild("Stats"):FindFirstChild("Genetics").Value
			table.insert(Closest, {v:FindFirstChild("ID").Value, Distance, PartnerGene})
			table.insert(HighestRewarding, {v:FindFirstChild("ID").Value, PartnerGene})
		end
	end

	local bestMate = nil
	local bestScore = -math.huge

	local BestEntry = {}
	local combinedScore

	for i, v in ipairs(Closest) do
		table.insert(BestEntry, {v[3]+((-v[2])/5), v[1]})
	end

	-- Check if BestEntry is not empty before sorting
	if #BestEntry > 0 then
		table.sort(BestEntry, function(a, b) return a[1] > b[1] end)
		MateFound = BestEntry[1][2]
	else
		MateFound = nil
	end

end





local function FindClosestFood()
	local closestFood = nil
	local closestDistance = math.huge

	for _, v in ipairs(FoodFolder:GetChildren()) do
		local distance = (v.Position - Organism.Position).Magnitude

		if distance < closestDistance then
			closestDistance = distance
			closestFood = v
		end
	end

	return closestFood, closestDistance
end

local closestFood, closestDistance = FindClosestFood()

local function FoodDesperate()

	if Genetics.Value == 1 then
		return 85
	elseif Genetics.Value == 2 then
		return 80
	elseif Genetics.Value == 3 then
		return 75
	elseif Genetics.Value == 4 then
		return 70
	elseif Genetics.Value == 5 then
		return 65
	end

end

local function TaskChange()
	if BirthReady.Value == true and HuntingFood.Value == false then
		script.Parent.Value = "Birth"

		repeat 
			FindMate()
			if cooldown == false then
				for i, v in ipairs(OraganismsFolder:GetChildren()) do
					if v:IsA("Part") and v:FindFirstChild("ID").Value == MateFound then
						Object = v
					end
				end
				Time = ((Object.Position - Organism.Position).Magnitude) / Speed.Value
				Tweeninfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false)
				local GetMate = TweenService:Create(Organism, Tweeninfo, {Position = Object.Position})
				GetMate:Play()
				if (Object.Position - Organism.Position).Magnitude <= 3 then
					BirthReady.Value = false
					if Partner.Value ~= "" then
						for i, v in ipairs(OraganismsFolder:GetChildren()) do
							if Partner.Value == v.Name then
								FoundPartner = true
							else
								FoundPartner = false
							end
						end

					end
					cooldown = true
					local children = math.random(1,3)
					repeat
						children = children - 1
						if Partner.Name == "" or FoundPartner == false then
							Partner.Value = Object.Name
							local Clone = Organism:Clone()
							Clone.Parent = OraganismsFolder
							Clone.Stats.Points.Value = 8
							Clone.Stats.Health.Value = 50
							Clone.Stats.Hunger.Value = Hunger.Value - 20
							Owner.Value = ""
							Claimed.Value = false

							if randomFifty() == 1 then
								Clone.Stats.Male.Value = true
							else
								Clone.Stats.Male.Value = false
							end
							if randomFifty() == 1 then
								Clone.Stats.Morality.Value = true
							else
								Clone.Stats.Morality.Value = false
							end
							Clone.Stats.Genetics.SetGenes.Value = true
							local function lowestGene()
								if Genetics.Value - 1 <= 0 then
									return 1
								else
									return Genetics.Value - 1
								end
							end
							local function highestGene()
								if Genetics.Value + 1 >= 6 then
									return 5
								else
									return Genetics.Value + 1
								end
							end
							Clone.Stats.Genetics.Value = math.random(lowestGene(), highestGene())
							local FamilyFolder = Instance.new("Folder")
							FamilyFolder.Name = "FamilyFolder"
							FamilyFolder.Parent = Clone
							local Father = Instance.new("StringValue")
							Father.Value = ""
							Father.Name = "Father"
							Father.Parent = FamilyFolder
							local Mother = Instance.new("StringValue")
							Mother.Value = ""
							Mother.Name = "Mother"
							Mother.Parent = FamilyFolder

							if Male.Value == false then
								Mother.Value = ID.Value
							else
								Father.Value = ID.Value
							end
							if Partner.Value ~= "" then
								local CoParent = OraganismsFolder:FindFirstChild(Partner.Value)
								if CoParent then
									local GenderMale = CoParent:FindFirstChild("Stats"):FindFirstChild("Male")
									if GenderMale.Value == true then
										Father.Value = CoParent:FindFirstChild("ID").Value
									else
										Mother.Value = CoParent:FindFirstChild("ID").Value
									end
								end
							end
						end
						wait(0.5)
					until children <= 0

				end


				wait(20)
				cooldown = false

			end
			wait(0.5)
		until BirthReady.Value == false 


	elseif BirthReady.Value == false and HuntingFood.Value == true then
		script.Parent.Value = "Food"
		repeat 
			FindFood()
			Time = ((Object.Position - Organism.Position).Magnitude) / Speed.Value
			Tweeninfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false)
			local GetFood = TweenService:Create(Organism, Tweeninfo, {Position = Object.Position})
			GetFood:Play()
			if HuntingFood.Value == false then
				GetFood:Stop()
			end
			HuntingFood.Value = false
			while HuntingFood.Value == false do
				for i, v in ipairs(FoodFolder:GetChildren()) do
					if (v.Position - Organism.Position).Magnitude < 1.75 then
						Hunger.Value = Hunger.Value + v.Worth.Value
						Points.Value = Points.Value + v.Worth.Value

						v:Destroy()
						HuntingFood.Value = true
					end
				end
				wait()
			end

			wait(Time)

		until HuntingFood.Value == false

	elseif BirthReady.Value == true and HuntingFood.Value == true then
		script.Parent.Value = "Food"
		repeat 
			FindFood()
			Tweeninfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false)
			local GetFood = TweenService:Create(Organism, Tweeninfo, {Position = Object.Position})
			GetFood:Play()
			if HuntingFood.Value == false then
				GetFood:Stop()
			end
			HuntingFood.Value = false
			while HuntingFood.Value == false do
				for i, v in ipairs(FoodFolder:GetChildren()) do
					if (v.Position - Organism.Position).Magnitude < 1.75 then
						Hunger.Value = Hunger.Value + v.Worth.Value
						Points.Value = Points.Value + v.Worth.Value

						v:Destroy()
						HuntingFood.Value = true
					end
				end
				wait()
			end

			wait(Time)

		until HuntingFood.Value == false

	end
end


HuntingFood.Changed:Connect(function()

	TaskChange()
end)
BirthReady.Changed:Connect(function()

	TaskChange()
end)


Hunger.Changed:Connect(function()
	if Hunger.Value <= FoodDesperate() then

		HuntingFood.Value = true
	elseif Hunger.Value > FoodDesperate() + 20 then

		HuntingFood.Value = false
	end
end)

--HuntingFood.Changed:Connect(function()

--	if HuntingFood.Value == true then

--			Task.Value = "Food"
--			if BirthReady.Value == true and NeedFood == false then
--				if Hunger.Value < FoodDesperate() then
--					NeedFood = true
--				else
--					NeedFood = false
--				end
--			else
--				repeat 
--				FindFood()
--				Tweeninfo = TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false)
--				local GetFood = TweenService:Create(Organism, Tweeninfo, {Position = Object.Position})
--				GetFood:Play()
--				if HuntingFood.Value == false then
--					GetFood:Stop()
--				end
--				HuntingFood.Value = false
--				while HuntingFood.Value == false do
--					for i, v in ipairs(FoodFolder:GetChildren()) do
--						if (v.Position - Organism.Position).Magnitude < 1.75 then
--							Hunger.Value = Hunger.Value + v.Worth.Value
--							Points.Value = Points.Value + v.Worth.Value

--							v:Destroy()
--							HuntingFood.Value = true
--						end
--					end
--					wait()
--				end

--				wait(Time)

--			until HuntingFood.Value == false
--		end
--	end
--end)


script.Parent.Changed:Connect(function()
	if script.Parent.Value == "Food" then

	end
end)
