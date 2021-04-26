-- message.lua

local class = require "lib.middleclass"
local ArrayField = require "lib.arrayfield"
local Field = require "lib.field"
local Message = class("Message")

function Message:initialize(args)
    -- required arguments
    self.name = assert(args.name)
    self.fields = assert(args.fields)

    self.hierarchy = {}
    self.protocol = nil
end

function Message:dissect(protoFields, data, tree)
    self.origin = "unknown"
    self.hierarchy.default = {field = nil, tree = tree}

    self:dissectSection(protoFields, data:range(1):tvb(), self.fields)
end

function Message:dissectField(field, data)
    field:setData(data, self.hierarchy)

    if self.origin ~= "unknown" then return end

    local client = field.client == 0 and field.value:bytes() == ByteArray.new("00")
    local server = field.server == 0 and field.value:bytes() == ByteArray.new("00")
    if client and not server then self.origin = "client" return end
    if server and not client then self.origin = "server" return end

    self.origin = "unknown"
end

function Message:dissectSection(protoFields, data, fields, section)
    local offset = 0
    local section = section or "base"

    for index, field in ipairs(fields) do
        if field.class.name == ArrayField.name then
            field:setSize(self.hierarchy)

            for i = 1, field.count do
                local size = self:dissectSection(protoFields, data:range(offset):tvb(), field.fields, field.name)
                offset = offset + size
            end
        elseif field.class.name == Field.name then
            self:dissectField(field, data:range(offset):tvb())
            local subtree = field:addToTree(self.hierarchy, protoFields, self:fieldAbbr(self.name, section, index), self.origin)

            if field.parentId ~= 0 then
                self.hierarchy[field.parentId] = {field = field, tree = subtree}
            end

            offset = offset + field.value:len()
        else
            print("Error: Unknown field type")
        end
    end

    return offset
end

function Message:fieldAbbr(name, section, index)
    local protocol = self.protocol or "protocol"
    local name_section = section == "base" and name or string.format("%s.%s", name, section)

    return string.format("%s.%s.%s", string.lower(protocol), string.lower(name_section), index)
end

function Message:protoFields()
    local protoFields = {}

    for index, field in ipairs(self.fields) do
        if field.class.name == ArrayField.name then
            for aindex, afield in ipairs(field.fields) do
                local abbr = self:fieldAbbr(self.name, field.name, aindex)
                protoFields[abbr] = afield:protoField(abbr)
            end
        elseif field.class.name == Field.name then
            local abbr = self:fieldAbbr(self.name, "base", index)
            protoFields[abbr] = field:protoField(abbr)
        else
            print("Error: Unknown field type")
        end
    end

    return protoFields
end

-- static methods

function Message.static:buildProtoFields(object, protocol)
    local protoFields = {}
    for _, message in pairs(object) do
        message.protocol = protocol

        for key, value in pairs(message:protoFields()) do
            protoFields[key] = value
        end
    end
    return protoFields
end

function Message.static:buildMessageTypes(object)
    local types = {}
    for id, message in pairs(object) do
        types[id] = message.name
    end
    return types
end

return Message
