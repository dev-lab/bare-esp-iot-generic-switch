local z = ...

local function fI()
	tmr.create():alarm(60000, 1, function()
		require("wd")()
	end)
end

return function(t, ...)
	package.loaded[z] = nil
	z = nil
	local v1 = {I = fI}
	local v = t and v1[t] or fI
	if not v then return end
	return v(...)
end
