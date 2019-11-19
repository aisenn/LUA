require "map"

function readFromFile(fileToRead)
	fh,err = io.open(fileToRead)
	local i = 0
    while true do
            line = fh:read()
            if line == nil then break end

			table.insert(td, line)
			i = i + 1
	end
	map.width = i

	local nx = next(td)
	map.height = td[nx]:len()
    fh:close()
end

function writeToFile(fileToWrite)
    fho,err = io.open("solved_" ..fileToWrite, "w")

    for rowIndex,row in ipairs(td) do
		fho:write(row)
		fho:write("\n")
	end
    fho:close()
end

function getPriority(front)
	if next(front) == nil then
		return nil
	else
		local key = next(front)
		local max = front[key].priority
		
		for k, v in pairs(front) do
			if front[k].priority < max then
				key, max = k, v.priority
			end
		end

		local res = table.remove(front, key).pos
		return res
	end
end

function aStar()
	local front = {
		{priority = 0, pos = map.start},
	}

	map.visited_[map.start] = map.start;
	map.nodeDistance_[map.start] = 0;

	local current = getPriority(front)
	while current ~= nil do
		if ((current.x == map.finish.x) and (current.y == map.finish.y)) then
			print("finish")
			break;
		end

		local possiblePaths = map:reachablePaths(current)
		local nex = next(possiblePaths)
		while nex ~= nil do
			local newCost = map.nodeDistance_[current] + 1
			
			if map.nodeDistance_[possiblePaths[nex]] == nil or newCost < map.nodeDistance_[possiblePaths[nex]] then
				map.nodeDistance_[possiblePaths[nex]] = newCost
				local pCost = newCost + map:heuristic(possiblePaths[nex], map.finish)
				table.insert(front, {priority = pCost, pos = possiblePaths[nex]})
				map.visited_[possiblePaths[nex]] = current
			end
			nex = next(possiblePaths, nex)
		end
		current = getPriority(front)
	end
end

function replaceChar(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

function path()
	local path = {}
	local current = map.finish;

	local current = next(map.visited_)
	local pos = {}
	while current ~= nil do
		pos = map.visited_[current]
		td[pos.y] = replaceChar(pos.x, td[pos.y], '.')
		current = next(map.visited_, current)
	end
	return path;
end

if arg[1] == nil then
    print("usage: lua main.lua fileToRead");
elseif arg[1] ~= nil then
	readFromFile(arg[1])
	map.start = map:getCharPositionOnField(START)
	map.finish = map:getCharPositionOnField(FINISH)

	aStar()
	path()
	writeToFile(arg[1])
end



