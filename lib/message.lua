-- message.lua

local class = require "lib.middleclass"
local Message = class("Message")

function Message:initialize(args)
    -- required arguments
    self.name = assert(args.name)
    self.fields = assert(args.fields)

    -- optional arguments
    self.source = args.source or self.getSource
end

function Message:dissect(protoFields, data, tree)
    local offset = 1
    self.origin = "unknown"

    for index, field in ipairs(self.fields) do
        local value = field:getValue(data:range(offset):tvb())
        self.origin = self:source(field)

        if not field:isHidden(self.origin) then
            local name = Message.static:fieldAbbr("kaillera", self.name, index)
            tree:add_le(protoFields[name], value)
        end

        offset = offset + value:len()
    end
end

function Message:getSource(field)
    if self.origin ~= "unknown" then return self.origin end

    local client = field.client == 0 and field.value:bytes() == ByteArray.new("00")
    local server = field.server == 0 and field.value:bytes() == ByteArray.new("00")
    if client and not server then return "client" end
    if server and not client then return "server" end

    return "unknown"
end

function Message:protoFields(prefix, index)
    local abbr_base = string.format("%s.%s.", prefix, string.lower(self.name))

    if index ~= nil then
        return self.fields[index]:protoField(abbr_base .. index)
    else
        local protoFields = {}

        for i, field in ipairs(self.fields) do
            protoFields[abbr_base .. i] = field:protoField(abbr_base .. i)
        end

        return protoFields
    end
end

-- static methods

function Message.static:buildProtoFields(object, prefix)
    local protoFields = {}

    for id, messageType in pairs(object) do
        for index, field in ipairs(messageType.fields) do
            local abbr = Message.static:fieldAbbr(prefix, messageType.name, index)
            protoFields[abbr] = field:protoField(abbr)
        end
    end

    return protoFields
end

function Message.static:fieldAbbr(prefix, name, index)
    return string.format("%s.%s.%s", string.lower(prefix), string.lower(name), index)
end

function Message.static:getTypes(object)
    local types = {}
    for id, message in pairs(object) do
        types[id] = message.name
    end
    return types
end

return Message
