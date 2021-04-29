-- arrayfield.lua

local class = require "lib.middleclass"
local Field = require "lib.field"
local ArrayField = class("ArrayField")

function ArrayField:initialize(args)
    -- required arguments
    self.args = assert(args)
    self.name = assert(args.name)
    self.fields = assert(args.fields)

    -- required arguments (one of)
    self.size = args.size
    self.sizeOf = args.sizeOf
    assert(self.size or self.sizeOf)

    -- optional arguments for Message
    self.childOf = args.childOf or "default"
    self.client = args.client or 1
    self.hidden = args.hidden or 0
    self.refName = args.refName or 0
    self.server = args.server or 1

    -- apply optional arguments if they're not defined
    for _, field in ipairs(self.fields) do
        if field.class.name ~= Field.name then
            print(string.format("%s: %s", self.class.name, "Unknown field type"))
        else
            for _, optArg in ipairs({"childOf", "client", "hidden", "refName", "server"}) do
                field[optArg] = field.args[optArg] and field.args[optArg] or self[optArg]
            end
        end
    end

    self.safe_name = string.lower(self.name:gsub(" ", "_"))
    self.count = nil
end

function ArrayField:setSize(trees)
    self.count = self.size and self.size or trees[self.sizeOf].field.value:le_uint()
end

return ArrayField
