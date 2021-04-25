ls = ""
cf = {}
tmr.create():alarm(2000, 0, function()
	if not cjson then _G.cjson = sjson end
	local _, b = node.bootreason()
	if b == 0 then pcall(function() require("fpUpdate")() end) end
	require("connect")(function()
		tmr.create():alarm(100, 0, function()
			require("http")
			require("dnsLiar")
			pcall(function() require("apps")() end)
		end)
	end)
end)
