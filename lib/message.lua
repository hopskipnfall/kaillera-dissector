-- message.lua

local class = require "lib.middleclass"
local Field = require "lib.field"
local Message = class("Message")

function Message:initialize(args)
    self.name = assert(args.name or args[1])
    self.struct = assert(args.struct or args[2])
end

-- static methods

function Message.static:buildProtoFields(object, prefix)
    local protoFields = {}

    for id, messageType in pairs(object) do
        for index, message in ipairs(messageType.struct) do
            local abbr = string.format("%s.%s.%s", prefix, string.lower(messageType.name), index)
            protoFields[abbr] = message:protoField(abbr)
        end
    end

    return protoFields
end

function Message.static:getTypes(object)
    local types = {}
    for id, message in pairs(object) do
        types[id] = message.name
    end
    return types
end

return Message
