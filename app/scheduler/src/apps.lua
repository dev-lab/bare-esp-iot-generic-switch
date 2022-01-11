local z = ...

local function fI()
	pcall(function() require("button") end)
	pcall(function() require("schedule") end)
end

return function(t, ...)
	package.loaded[z] = nil
	z = nil
	local v1 = {I = fI}
	local v = t and v1[t] or fI
	if not v then return end
	return v(...)
end
