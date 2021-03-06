local z = ...

local function tx(s, f)
	require("vGenPin")(s, f)
end

local function loadP(p, f)
	if not p.t then
		f()
		return
	end
	tx(p.t.."G P"..(p.p or "0"), function(v)
		if v and #v > 4 then
			v = v:sub(5)
			p.v = tonumber(v)
		else
			p.v = 0
		end
		v = nil
		collectgarbage()
		f()
	end)
end

return function(co,p)
	package.loaded[z] = nil
	z = nil
	p = nil
	local fp = file.open("ports.json")
	local d = cjson.decode(fp:read())
	fp:close(); fp = nil
	local gp = d.gpio
	tmr.wdclr()
	local x = 1
	local i = #gp + 1
	tmr.create():alarm(10, 1, function(t)
		if not x then return end
		x = nil
		i = i - 1
		if i > 0 then
			loadP(gp[i], function() x = 1 end)
		else
			t:unregister()
			loadP = nil
			tx = nil
			collectgarbage()
			require("sendJson")(co,d)
		end
	end)
end
