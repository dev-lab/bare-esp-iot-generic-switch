local z = ...

local function tonum(s, p)
	if not s or (p and s:sub(1, 1) ~= p) then return 9 end
	return tonumber(s:sub(2, 2))
end

local function uc(n)
	return "Unknown "..n.." command"
end

return function(o, p1, p2, pv, n, wf, rf)
	package.loaded[z] = nil
	z = nil
	local p = tonum(p1, 'P')
	local e = not p and "Port not specified" or (o == 0 and uc(n) or nil)
	if not e and o > 1 then
		local v = pv and tonum(p2, 'V') or p2
		e = wf and (not v and n.." value to set not specified" or wf(p, v)) or uc(n)
		return true, p, v
	end
	if e then
		return false, p, e
	else
		return true, p, (pv and "V" or "")..rf(p)
	end
end
