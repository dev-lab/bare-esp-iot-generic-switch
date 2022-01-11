local z = ...

local function fI()
	pcall(function() require("button") end)
end

local function onSocket(v)
	local l = 7
	if btmr then
		btmr:unregister()
		btmr = nil
		pwm.close(l)
	end
	if otmr then
		otmr:unregister()
		otmr = nil
	end
	if v == 1 then
		otmr = tmr.create()
		otmr:alarm(1200000, 0, function(t)
			require("vGenPin")("DS P6 V0", function(x) end)
		end)
	end
end

local function fP(p, v)
	if p == 6 then onSocket(v) end
end

return function(t, ...)
	package.loaded[z] = nil
	z = nil
	local v1 = {I = fI, P = fP}
	local v = t and v1[t] or fI
	if not v then return end
	return v(...)
end
