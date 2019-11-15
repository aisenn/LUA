
function writeToFile(fileToRead, fileToWrite)
    fh,err = io.open(fileToRead)
    fho,err = io.open(fileToWrite, "w")

    while true do
            line = fh:read()
            if line == nil then break end
            num = toNumeral(line)
            string = toRoman(num);
            
            fho:write(string)
            fho:write("\n")
    end
    fh:close()
    fho:close()
end

function readFromInput(input)
    local num = { M = 1000, D = 500, C = 100, L = 50, X = 10, V = 5, I = 1 }
    if (string.len(input) and tonumber(input) ~= nil) then
        string = toRoman(tonumber(input));
        io.write(string)
    elseif input ~= nil then
        string = toNumeral(input);
        io.write(string)
    end
    print()
end

function toRoman(num) 
    local tab = { {"M", 1000}, {"CM", 900}, {"D", 500}, {"CD", 400}, {"C", 100}, {"XC", 90},
            {"L", 50}, {"XL", 40}, {"X", 10}, {"IX", 9}, {"V", 5}, {"IV", 4}, {"I", 1} }

    local res = ""
    for _, value in ipairs(tab) do
        while num >= value[2] do
            num = num - value[2]
            res = res .. value[1]
        end
    end
    return res
end


function toNumeral( roman )
    local num = { M = 1000, CM = 900, D = 500, CD = 400, C = 100, XC = 90,
                  L = 50, XL = 40, X = 10, IX = 9, V = 5, IV = 4, I = 1 }
    local res = 0    
    local strlen = string.len(roman)
    local i = 1

    while i <= strlen do        
        local l = num[string.sub(roman, i, i + 1)]
        if l ~= nil then
            res = res + l
        else
            local l = num[string.sub(roman, i, i)]
            local r = num[string.sub(roman, i+1, i+1)]
            res = res + l + r
        end
        i = i + 2    
    end 
    return res    
end


if arg[1] == nil and arg[2] == nil then
    print("usage: lua convert.lua fileToRead fileToWrite");
    print("   or: lua convert.lua CMXL or 777");
elseif arg[1] ~= nil and arg[2] ~= nil then
    writeToFile(arg[1], arg[2])
elseif arg[1] ~= nil then
    readFromInput(arg[1])
end