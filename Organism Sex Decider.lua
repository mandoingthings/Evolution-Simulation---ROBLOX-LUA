local random = math.random(1,2)
if script.Parent.SetGender.Value == false then
	print(random)
	if random == 1 then
		script.Parent.Value = true
	else 
		script.Parent.Value = false
	end
end
