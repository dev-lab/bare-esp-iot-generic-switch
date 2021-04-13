local z = ...

return function(co,p)
	package.loaded[z] = nil
	z = nil
	require("vGenPin")(p.cmd or "NG", function(re)
		require("rs")(co, 200, node.heap().."\n"..re)
	end)
end
