-- arrayfield.lua

local class = require "lib.middleclass"
local ArrayField = class("ArrayField")

function ArrayField:initialize(args)
    -- required arguments
    self.args = assert(args)
    self.name = assert(args.name)
    self.fields = assert(args.fields)

    -- required arguments (only one)
    self.size = args.size
    self.sizeOf = args.sizeOf
    assert(self.size or self.sizeOf)

    -- optional arguments for Message
    self.childOf = args.childOf or "default"
    self.client = args.client or 1
    self.hidden = args.hidden or 0
    self.parentId = args.parentId or 0
    self.server = args.server or 1

    self.count = nil

    -- apply optional arguments if they're not defined
    for _, field in ipairs(self.fields) do
        local optArgs = {"childOf", "client", "hidden", "parentId", "server"}

        for _, optArg in ipairs(optArgs) do
            field[optArg] = field.args[optArg] and field.args[optArg] or self[optArg]
        end
    end
end

function ArrayField:setSize(trees)
    self.count = self.size and self.size or trees[self.sizeOf].field.value:le_uint()
end

return ArrayField
