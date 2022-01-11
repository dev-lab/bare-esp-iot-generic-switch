local z = ...

local function tx(cmd)
        require("vGenPin")(cmd, function(v)
		collectgarbage()
	end)	
end

return function()
        package.loaded[z] = nil
        z = nil
	local pwp = 7
	local rp = "DS P6 V"
	if not wdfm then wdfm = 2 end
	if roff then
		tx(rp..1)
		roff = nil
		wdf = 0		
	else
		net.dns.resolve("www.google.com", function(sk, ip)
			wdf = ip and 0 or ((wdf or 0) + 1)
			if wdf > 0 then
				pwm.setup(pwp, wdf, 512)
				pwm.start(pwp)
				if wdf > wdfm then
					roff = true
					tx(rp..0)
					wdfm = wdfm + (wdfm < 15 and 2 or 0)
					if wdfm < 15 then wdfm = wdfm + 2 end
				end
			else
				pwm.stop(pwp)
				wdfm = 2
			end
		end)
	end
end
