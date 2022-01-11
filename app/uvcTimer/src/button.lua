local function tx(cmd, f)
        require("vGenPin")(cmd, f)
end

local function debounce(func)
	local last = 0
	local delay = 1000000
	return function (...)
	local now = tmr.now()
	local delta = now - last
	if delta < 0 then delta = delta + 2147483647 end;
	if delta < delay then return end;
	last = now
	return func(...) end
end

local function nopwm(l)
	pwm.close(l)
	gpio.mode(l, gpio.OUTPUT)
	gpio.write(l, gpio.LOW)
end

local function click(o, l, n)
	tx("DS P"..o.." V"..n, function(r)
		nopwm(l)
	end)
end

local function onButton()
	local o = 6
	local l = 7
	tx("DG P"..o, function(v)
		local n
		if v and #v > 4 then
			v = v:sub(5)
			n = tonumber(v)
		else
			n = 1
		end
		if btmr then n = 1 end
		if n == 1 then
			click(o, l, 0)
		else
			local p = 1
			btmr = tmr.create()
			pwm.setup(l, p, 512)
			pwm.start(l)
			btmr:alarm(2000, 1, function(t)
				p = p + 1
				if p < 10  then
					pwm.setup(l, p, 512)
					pwm.start(l)
				else
					click(o, l, 1)
				end
			end)
		end
	end)
end

do
	nopwm(7)
	gpio.trig(3, "down", debounce(onButton))
end
