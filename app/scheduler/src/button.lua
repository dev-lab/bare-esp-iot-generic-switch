local function tx(cmd, f)
        require("vGenPin")(cmd, f)
end

local function debounce(f)
	local l = 0
	local t = 1000000
	return function(...)
		local n = tmr.now()
		local d = n - l
		if d < 0 then d = d + 2147483647 end;
		if d < t then return end;
		l = n
		return f(...)
	end
end

do
	local o = 6
	gpio.trig(3, "down", debounce(function()
		tx("DG P"..o, function(v)
			if v and #v > 4 then
				v = v:sub(5)
				local n = tonumber(v)
				tx("DS P"..o.." V"..(n == 1 and 0 or 1), function(r) end)
			end
		end)
	end))
end
