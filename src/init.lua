ls = ""
cf = {}
local t = tmr.create()
t:register(2000,0,function(t)
	if not cjson then _G.cjson = sjson end
	local _, b = node.bootreason()
	if b == 0 then require("fpUpdate")() end
	require("connect")(function()
		local s = tmr.create()
		s:register(100,0,function(s)
			require("http")
			require("dnsLiar")
		end)
		s:start()
	end)
end)
t:start()
