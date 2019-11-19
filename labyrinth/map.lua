FINISH = 'E'
START = 'I'
WALL = '0'

td = {}

map = {width = 20, height = 20, star = {}, finish = {},
visited_={}, nodeDistance_={}}

function map:heuristic(a, b)
	return math.abs(a.x - b.x) + math.abs(a.y - b.y);
end

function map:isObstacle(pos)
	if map:inBounds(pos) then
		return td[pos.y]:sub(pos.x, pos.x) ~= WALL
	else
		return false
	end
end

function map:inBounds(pos)
	return (pos.x >= 1 and pos.y >= 1) and (pos.x < map.width and pos.y < map.height);
end

function map:getCharPositionOnField(ch)
    for rowIndex,row in ipairs(td) do
		for i = 1, string.len(row) do
			if row:sub(i,i) == ch then
				return {x = i, y = rowIndex}
			end
		end
	end
end

function map:reachablePaths(obj)
	local res = {};

	local dirs = {{x = 1, y = 0}, {x = 0, y = -1}, {x = -1, y = 0}, {x = 0, y = 1}}

	local i = next(dirs)
	while (i ~= nil) do
		local tmp = {x = (obj.x + dirs[i].x), y = (obj.y + dirs[i].y)};
		if (map:inBounds(tmp) and map:isObstacle(tmp)) then
			table.insert(res, tmp)
		end
		i = next(dirs, i)
	end
	return res;
end