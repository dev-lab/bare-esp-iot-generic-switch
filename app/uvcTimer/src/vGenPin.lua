local z = ...

local function cC(o, p1, v)
	return require("vgpCmd")(o, p1, v, false, "Config",
		function(p, m)
			if m == "OP" then
				pwm.setup(p, 500, 0)
				pwm.start(p)
			else
				pwm.close(p)
				gpio.mode(p, (m:sub(1,1) == "I" and gpio.INPUT or gpio.OUTPUT), (m == "I1" and gpio.PULLUP or gpio.FLOAT))
			end
		end,
		function(p) return v end)
end

local function cD(o, p1, v)
	return require("vgpCmd")(o, p1, v, true, "Digital",
		function(p, v) gpio.write(p, v > 0 and gpio.HIGH or gpio.LOW)
			require("apps")("P", p, v)
		end,
		function(p) return gpio.read(p) end)
end

local function cP(o, p1, v)
	return require("vgpCmd")(o, p1, v, true, "PWM",
		function(p, v) pwm.setduty(p, v) end,
		function(p) return pwm.getduty(p) end)
end

local function cA(o, p1, v)
	return require("vgpCmd")(o, p1, v, true, "Analog",
		nil, function(p) return gpio.read(p) end)
end

local function cN(o, p1, v)
	if o > 2 then name = p1 end
	return (o == 0 and false), nil, (o == 0 and "Unknown Name command" or name)
end

local function cF(o, p1, v)
	return true, nil, "Virtual"
end

local function cU(o, p1, v)
	return false, nil, "Unknown Command"
end

return function(cmd, f)
	package.loaded[z] = nil
	z = nil
	local d, t, o, p1, p2 = require("vgpParse")(cmd)
	local v1 = {C = cC, D = cD, P = cP, A = cA, N = cN, F = cF}
	local v = v1[t] or cU
	local r, p, e = v(o, p1, p2)
	v = nil
	collectgarbage()
	f(r and "OK "..e or (d and "ERROR at "..(e and (p..": "..e) or p) or ""))
end
