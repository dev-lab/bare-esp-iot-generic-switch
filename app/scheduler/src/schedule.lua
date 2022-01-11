local function tx(cmd, f)
        require("vGenPin")(cmd, f)
end

local function tm(h, m) return h * 60 + m end

local function rj(n)
	if not file.exists(n) then return nil end
	local f = file.open(n)
	local j = cjson.decode(f:read())
	f:close()
	return j
end

local function rsch()
	local d = rj("sch.json")
	if not d or not d.sch or d.sch.e == 0 or not d.sch.d then return nil end
	d = d.sch.d
	local p = rj("ports.json")
	if not p or not p.gpio then return d end
	for _, s in ipairs(d) do
		for _, e in ipairs(p.gpio) do
			if e.p == s.p and e.v then s.v = e.v end
		end
		if not s.v then s.v = 0 end
	end
	return d
end


local function zzz(l)
	local d = 512
	local a = 8
	pwm.setup(l, 1000, d)
	pwm.start(l)
	local t = tmr.create()
	t:alarm(20, 1, function(t)
		if d == 1023 or d == 0 then t:interval(20) end
		d = d + a
		if d > 1023 or d < 0 then
			if d < 0 then d = 0 else d = 1023 end
			a = -a
			t:interval(2000)
		end
		pwm.setduty(l, d)
	end)
	return t
end

local function check()
--	local sch = {[6] = {{21, 0, 3, 59}} }
	local d = rsch()
	if not d then return nil end
	local c = rtctime.epoch2cal(rtctime.get())
	local n = tm(c.hour, c.min)
	for _, s in ipairs(d) do
		local pl = schp[s.p]
		local pn = s.v
		local pni = pn == 1 and 0 or 1
		for _, t in ipairs(s.t) do
			local from = tm(t[1], t[2])
			local to = tm(t[3], t[4])
			if from < to then
				if n >= from and n < to then pn = pni end
			else
				if n >= from or n < to then pn = pni end
			end
		end
		if pn ~= pl then
			schp[s.p] = pn
			tx("DS P"..s.p.." V"..pn, function(r) end)
		end
	end
	return 1
end

local function nopwm(l)
	pwm.close(l)
	gpio.mode(l, gpio.OUTPUT)
	gpio.write(l, gpio.LOW)
end

local function sync()
	local led = 7
	pwm.setup(led, 1, 512)
	pwm.start(led)
	local sok = false
	local function s1()
		pcall(function() sntp.sync(nil, function() sok = true end, nil, 1) end)
	end
	s1()
	local ts = 1
	local zz = nil
	tmr.create():alarm(5000, 1, function(t)
		if not sok then
			s1()
			return
		end
		if ts then
			nopwm(led)
			ts = nil
			if not schp then schp = {} end
		end
		local sec = 61 - rtctime.epoch2cal(rtctime.get()).sec
		t:interval(sec * 1000)
		if not check() then
			if not zz then
				zz = zzz(led)
				schp = {}
			end
		else
			if zz then
				zz:unregister()
				zz = nil
				nopwm(led)
			end
		end
	end)
end

do
	sync()
end
