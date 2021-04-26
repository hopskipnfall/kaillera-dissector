-- field.lua

local class = require "lib.middleclass"
local Field = class("Field")

function Field:initialize(args)
    -- required arguments
    self.args = assert(args)
    self.name = assert(args.name)
    self.type = assert(args.type)

    -- optional arguments for Message
    self.childOf = args.childOf or "default"
    self.client = args.client or 1
    self.hidden = args.hidden or 0
    self.parentId = args.parentId or 0
    self.server = args.server or 1
    self.size = args.size or 0

    -- optional arguments for ProtoField
    self.valuestring = args.valuestring or nil
    self.base = args.base or nil
    self.mask = args.mask or nil
    self.descr = args.descr or nil

    -- optional arguments for Tree
    self.encoding = args.encoding or nil

    self.realSize = nil
    self.value = nil
end

function Field:addToTree(trees, protoFields, name, origin)
    local parent = trees[self.childOf] and self.childOf or "default"

    if not self:isHidden(origin) then
        if self.encoding then
            return trees[parent].tree:add_packet_field(protoFields[name], self.value, self.encoding)
        else
            return trees[parent].tree:add_le(protoFields[name], self.value)
        end
    end

    return trees
end

function Field:isHidden(source)
    local hiddenClient = self.client == 0 and source == "client"
    local hiddenServer = self.server == 0 and source == "server"
    return self.hidden == 1 or hiddenClient or hiddenServer or false
end

function Field:protoField(abbr)
    return ProtoField.new(self.name, abbr, self.type, self.valuestring, self.base, self.mask, self.desc)
end

function Field:setData(data)
    self.realSize = (self.size ~= 0) and self.size or data:range():strsize()
    self.value = data:range(0, self.realSize)
end

return Field
