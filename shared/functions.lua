DebugTable = function(tbl)
    if not Config.Debug then
        return
    end

    if type(tbl) ~= "table" then
        DebugPrint("Invalid input. Expected a table.")
        return
    end

    local function printTableHelper(tbl, indent)
        indent = indent or 0
        local indentStr = string.rep("  ", indent)

        for key, value in pairs(tbl) do
            if type(value) == "table" then
                print(indentStr .. key .. " = {")
                printTableHelper(value, indent + 1)
                print(indentStr .. "}")
            else
                print(indentStr .. key .. " = " .. tostring(value))
            end
        end
    end

    printTableHelper(tbl)
end

DebugPrint = function(...)
    if not Config.Debug then
        return
    end

    local args = { ... }

    if type(args[1]) == 'table' then
        DebugTable(args[1])
        return
    end

    local appendStr = ''
    for _, v in ipairs(args) do
        appendStr = appendStr .. ' ' .. tostring(v)
    end

    local msgTemplate = '^3[%s]^0%s'
    local finalMsg = msgTemplate:format('mvrp_repairkit', appendStr)
    print(finalMsg)
end