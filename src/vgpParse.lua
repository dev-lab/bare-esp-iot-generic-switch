local z = ...

return function(cmd)
	package.loaded[z] = nil
	z = nil
	local i = 1
	local d, t, o, p1, p2, a2
	for a in cmd:gmatch("%w+") do
		if i == 1 then
			if a == "DEBUG" then
				d = true
				i = i - 1
			else
				d = d and true or false
				t = a:sub(1,1)
				a2 = a:sub(2,2)
				o = (a2 == "E" and 3 or
					(a2 == "S" and 2 or
					(a2 == "G" and 1 or 0)))
			end
		elseif i == 2 then
			p1 = a
		elseif i == 3 then
			p2 = a
			break
		end			
		i = i + 1
	end
	a2 = nil
	return d, t, o, p1, p2
end
