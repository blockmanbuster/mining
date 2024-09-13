TOOL.Mode = "mining_linker"
TOOL.Name = "Mining Linker"
TOOL.Category = "Mining"
TOOL.CurrentIndex = 1
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.Information = {
	{
		name = "left",
		icon = "gui/lmb.png",
	},
	{
		name = "right",
		icon = "gui/rmb.png",
	},
	{
		name = "reload",
		icon = "gui/r.png",
	},
}

function TOOL:LeftClick()
	return true
end

function TOOL:RightClick()
	return false
end

function TOOL:Reload()
	return true
end

if CLIENT then
	language.Add("tool.mining_linker.name", "Mining Linker")
	language.Add("tool.mining_linker.desc", "Link mining entities together")
	language.Add("tool.mining_linker.0", "Primary: Select an output or apply a link. Secondary: Change selection. Reload: Unlink an output or release current selection.")
	language.Add("tool.mining_linker.left", "Select an output or apply a link.")
	language.Add("tool.mining_linker.right", "Change selection.")
	language.Add("tool.mining_linker.reload", "Unlink an output or release current selection.")

	function TOOL:LeftClick(tr)
		if not IsFirstTimePredicted() then return end
		if not IsValid(tr.Entity) then return false end

		local ent = tr.Entity
		if ent.CPPIGetOwner and ent:CPPIGetOwner() ~= LocalPlayer() then
			surface.PlaySound("buttons/button8.wav")
			return false
		end

		local interfaces = self.SelectedOutput and _G.MA_Orchestrator.GetInputs(ent) or _G.MA_Orchestrator.GetOutputs(ent)
		local interface_count = table.Count(interfaces)
		if interface_count == 0 then return false end

		table.sort(interfaces, function(a, b) return a.Name < b.Name end) -- match hud

		if self.LastEntity ~= ent then
			self.CurrentIndex = 1
		end

		local interface_data = interfaces[self.CurrentIndex]
		if not interface_data then return false end

		if not self.SelectedOutput then
			self.SelectedOutput = interface_data
			surface.PlaySound("ui/buttonclick.wav")
		else
			if self.SelectedOutput.Type ~= interface_data.Type then
				surface.PlaySound("buttons/button8.wav")
				return false
			end

			_G.MA_Orchestrator.Link(self.SelectedOutput, interface_data)
			self.SelectedOutput = nil

			surface.PlaySound("buttons/button4.wav")
		end

		return true
	end

	function TOOL:RightClick(tr)
		if not IsFirstTimePredicted() then return end
		if not IsValid(tr.Entity) then return false end

		local ent = tr.Entity
		if ent.CPPIGetOwner and ent:CPPIGetOwner() ~= LocalPlayer() then
			surface.PlaySound("buttons/button8.wav")
			return false
		end

		local interfaces = self.SelectedOutput and _G.MA_Orchestrator.GetInputs(ent) or _G.MA_Orchestrator.GetOutputs(ent)
		local interface_count = table.Count(interfaces)
		if interface_count == 0 then return false end

		if self.LastEntity ~= ent then
			self.CurrentIndex = 1
		end

		self.CurrentIndex = input.IsShiftDown() and (self.CurrentIndex - 1) or (self.CurrentIndex + 1)
		self.LastEntity = ent

		if self.CurrentIndex > #interfaces then
			self.CurrentIndex = 1
		elseif self.CurrentIndex < 1 then
			self.CurrentIndex = #interfaces
		end

		surface.PlaySound("ui/buttonrollover.wav")

		return false
	end

	function TOOL:Reload(tr)
		if not IsFirstTimePredicted() then return end

		if self.SelectedOutput then
			self.SelectedOutput = nil
			surface.PlaySound("ui/buttonclickrelease.wav")
			return false
		end

		if not IsValid(tr.Entity) then return false end

		local ent = tr.Entity
		if ent.CPPIGetOwner and ent:CPPIGetOwner() ~= LocalPlayer() then
			surface.PlaySound("buttons/button8.wav")
			return false
		end

		local outputs = _G.MA_Orchestrator.GetOutputs(ent)
		local outputs_count = table.Count(outputs)
		if outputs_count == 0 then return false end

		table.sort(outputs, function(a, b) return a.Name < b.Name end)

		if self.LastEntity ~= ent then
			self.CurrentIndex = 1
		end

		local output_data = outputs[self.CurrentIndex]
		if not output_data then return false end

		_G.MA_Orchestrator.Unlink(true, output_data)
		surface.PlaySound("ui/buttonclickrelease.wav")

		return true
	end

	function TOOL:GetSelectedOutput()
		return self.SelectedOutput
	end
end