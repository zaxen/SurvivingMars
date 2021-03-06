DefineClass.ShiftsBuilding = {
	__parents = { "Building"},
	
	properties = {		
		{ template = true,id = "active_shift",    name = T{738, "Single Active shift"},   default = 0, category = "ShiftsBuilding", editor = "number"},
		{ template = true,id = "closed_shifts_persist",    name = T{739, "Persisted closed shift"},  no_edit = true, editor = "text", default = ""},
	},
	
	max_shifts = 3,
	closed_shifts = false,-- per shift
	current_shift = false,
}

local shift_names = {
	T{740, "Start Shift Enabled 1"},
	T{741, "Start Shift Enabled 2"},
	T{742, "Start Shift Enabled 3"},
}

for i = 1, ShiftsBuilding.max_shifts do
	assert(shift_names[i])
	table.insert(ShiftsBuilding.properties, { template = true, id = "enabled_shift_" .. i, name = shift_names[i], default = true, category = "ShiftsBuilding", editor = "bool"})
end

function ShiftsBuilding:Init()
	self.closed_shifts = {}
end

function ShiftsBuilding:GameInit()
	for i = 1, self.max_shifts do
		if (not self["enabled_shift_" .. i]) or (self.active_shift > 0 and self.active_shift ~= i) then
			self.closed_shifts[i] = true
		end
	end	
	self:InitPersistShifts()
	for i = 1, self.max_shifts do
		if self.closed_shifts[i] then
			self:CloseShift(i)		
		end
	end
	
	self.city:AddToLabel("ShiftsBuilding", self)
	self:SetWorkshift(CurrentWorkshift)
end

function ShiftsBuilding:Done()
	self.city:RemoveFromLabel("ShiftsBuilding", self)
end

function ShiftsBuilding:GetUnitsInShifts()
	return empty_table
end

function OnMsg.NewWorkshift(workshift)
	for _, city in ipairs(Cities) do
		city:ForEachLabelObject("ShiftsBuilding", "SetWorkshift", workshift)
	end
end

function ShiftsBuilding:SetWorkshift(workshift)
	self:OnChangeWorkshift(self.current_shift, workshift)							
	self.current_shift = workshift
	self:SetWorkplaceWorking()
	self:UpdateAttachedSigns()
	self:UpdateNotWorkingBuildingsNotification()
end

function ShiftsBuilding:UpdateAttachedSigns()
end

function ShiftsBuilding:InitPersistShifts()
	local shift = self.closed_shifts_persist
	if shift ~= "" then 
		local idx = 1
		for closed in string.gmatch(shift, "[0-9]") do
			if closed == "1" then
				self.closed_shifts[idx] = true
			else
				self.closed_shifts[idx] = false
			end
			idx = idx + 1
		end
	end
end

function OnMsg.SaveMap()
	local buildings = GetObjects{class = "ShiftsBuilding"}
	for i=1, #buildings do
		local building = buildings[i]
		local persist_shifts = ""
		for j=1, building.max_shifts do
			persist_shifts = persist_shifts..(building:IsClosedShift(j) and "1" or "0")
		end
		building.closed_shifts_persist = persist_shifts
	end
end

function ShiftsBuilding:SetWorkplaceWorking()
	local shift = self.active_shift > 0 and self.active_shift or self.current_shift
	if self.closed_shifts[shift] then
		self:OnSetWorkplaceWorking()
		self:UpdateWorking(false)
	else	
		self:OnSetWorkplaceWorking()
		self:UpdateWorking()
	end
end

function ShiftsBuilding:OnChangeWorkshift(old_shift, new_shift)
end

function ShiftsBuilding:OnSetWorkplaceWorking()
	self:UpdateConsumption()
end

function ShiftsBuilding:GetWorkNotPermittedReason()
	local is_work_permitted = self.active_shift > 0 or not self:IsClosedShift(self.current_shift)
	if not is_work_permitted then
		return "InactiveWorkshift"
	end
	return Building.GetWorkNotPermittedReason(self)
end		

function ShiftsBuilding:IsClosedShift(shift)
	return self.closed_shifts[shift]
end

function ShiftsBuilding:IsShiftUIActive(shift)
	return self.current_shift==shift
end

function ShiftsBuilding:AreAllShiftsClosed()
	for idx = 1, self.max_shifts do
		if not self.closed_shifts[idx] then
			return false
		end
	end
	return true
end

function ShiftsBuilding:CloseShift(shift)
	self.closed_shifts[shift] = true
	if self:AreAllShiftsClosed() then
		self:SetUIWorking(false)
	end
	if shift == self.current_shift then
		self:UpdateWorking()
		self:UpdateConsumption()
	end
	if self.active_shift > 0 or self.current_shift then
		self:UpdateAttachedSigns()
	end
end

function ShiftsBuilding:OpenShift(shift)
	if self.active_shift > 0 then
		self:CloseShift(self.active_shift)
		self.active_shift = shift
	end
	if self:AreAllShiftsClosed() then
		self:SetUIWorking(true)
	end
	self.closed_shifts[shift] = false
	if shift == self.current_shift then
		self:UpdateWorking()
		self:UpdateConsumption()
	end
	self:UpdateAttachedSigns()
end

function ShiftsBuilding:ToggleShift(shift)
	if self:IsClosedShift(shift) then
		self:OpenShift(shift)
	else
		self:CloseShift(shift)
	end
	ObjModified(self)
end

function ShiftsBuilding:UpdateNotWorkingBuildingsNotification()
	if not self.destroyed and self:IsWorkPermitted() and not self:IsWorkPossible() then
		if self.priority > 1 and not self:IsClosedShift(self.current_shift) then
			table.insert_unique(g_NotWorkingBuildings, self)
		end
	else
		table.remove_entry(g_NotWorkingBuildings, self)
	end
end
