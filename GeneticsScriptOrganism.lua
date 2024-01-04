if script.Parent.SetGenes.Value == false then
	script.Parent.Value = math.random(1, 5)
	script.Parent.SetGenes.Value = true
end

script.Parent.SetGenes.Changed:Connect(function()
	if script.Parent.SetGenes.Value == false then
			script.Parent.Value = math.random(1, 5)
	end
end)

