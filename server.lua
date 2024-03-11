--[[
    Configurable Settings
]]
local delayBetweenResources = 100 -- Time in milliseconds between each resource scan.

local scanableStates = { -- yes, it's possible to scan running resource. BUT due to the nature of how this exploit sometimes spreads itself, it'd just scan stopped resources to be safe.
    ["stopped"] = true,
    ["uninitialized"] = true
}

--[[
    Script
]]
local resources = {}

local function detectHexSequences(input)
    local hexStrings = {}
    input:gsub("(['\"])(.-)%1", function(quote, content)
        local hexSequence = ""
        for hexString in content:gmatch("(\\x[%x]+)") do
            hexSequence = hexSequence .. hexString
        end
        if #hexSequence > 0 then
            table.insert(hexStrings, hexSequence)
        end
    end)
    return hexStrings
end

local function decodeHex(hex)
    local decoded = ""
    for foundHex in hex:gmatch("\\x(%x%x)") do
        decoded = decoded .. string.char(tonumber(foundHex, 16))
    end
    return decoded
end

local function updateResources()
    local resourceCount = GetNumResources()

    for i = 0, resourceCount - 1 do
        local resourceName = GetResourceByFindIndex(i)
        local state = GetResourceState(resourceName)

        if scanableStates[state] then
            table.insert(resources, resourceName)
        end
    end
end

local function getAllScriptsFiles(path)
    return exports[GetCurrentResourceName()]:scanFolder(path)
end

local function convertFilePath(filePath, resourceName)
    local startPos, endPos = string.find(filePath, resourceName)

    if startPos then
        local newPath = string.sub(filePath, endPos + 2)
        return newPath
    end
end

local function startScan()
    updateResources()

    local output = "Beginning of scan:\n---------------------------------------------\n"
    print(string.format("Found %s stopped resources, starting scan...", #resources))
    for _, resourceName in ipairs(resources) do
        local path = GetResourcePath(resourceName)
        local files = getAllScriptsFiles(path)
        print(string.format("Scanning %s", resourceName))
        output = output .. string.format("Scanning %s:\n", resourceName)

        for _, file in ipairs(files) do
            local fileAfterResource = convertFilePath(file, resourceName)
            if not fileAfterResource then
                goto continue
            end

            local script = LoadResourceFile(resourceName, fileAfterResource)
            if script then
                local hexStrings = detectHexSequences(script)
                if hexStrings and #hexStrings > 0 then
                    print(string.format("^3Found hex encoded strings in %s (%s), if this is not your doing, please check the resource.^7", resourceName, fileAfterResource))
                    output = output .. string.format("    - Found hex encoded strings in %s (%s), if this is not your doing, please check the resource.\n", resourceName, fileAfterResource)

                    print(string.format("^1Decoded strings for your viewing pleasure:^7"))
                    output = output .. "    - Decoded strings for your viewing pleasure:\n"
                    for _, hexString in ipairs(hexStrings) do
                        local decoded = decodeHex(hexString)
                        print(string.format("^1%s^7", decoded))
                        output = output .. string.format("        - %s\n", decoded)
                    end
                end
            end

            ::continue::
        end

        print(string.format("Finished scanning %s", resourceName))
        Wait(delayBetweenResources)
    end

    SaveResourceFile(GetCurrentResourceName(), "output.txt", output, -1)
    print("Finished scanning all stopped resources. Wrote log to output file.")
    Wait(500)
    StopResource(GetCurrentResourceName())
end

CreateThread(function()
    Wait(500)
    startScan()
end)