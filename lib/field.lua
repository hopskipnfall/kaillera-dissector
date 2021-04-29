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
    self.refName = args.refName or 0
    self.server = args.server or 1
    self.size = args.size or nil
    self.sizeOf = args.sizeOf or nil

    -- optional arguments for ProtoField
    self.valuestring = args.valuestring or nil
    self.base = args.base or nil
    self.mask = args.mask or nil
    self.descr = args.descr or nil

    -- optional arguments for Tree
    self.encoding = args.encoding or nil
    self.treeOnly = args.treeOnly or nil

    self.safe_name = string.lower(self.name:gsub(" ", "_"))
    self.realSize = nil
    self.value = nil
end

function Field:addToTree(trees, protoFields, name, origin)
    local parent = trees[self.childOf] and self.childOf or "default"

    if not self:isHidden(origin) then
        local newtree = nil

        if self.treeOnly then
            newtree = trees[parent].tree:add(self.name)
        elseif self.encoding then
            newtree = trees[parent].tree:add_packet_field(protoFields[name], self.value, self.encoding)
        else
            newtree = trees[parent].tree:add_le(protoFields[name], self.value)
        end

        if newtree then return newtree end
    end

    return trees
end

function Field:isHidden(source)
    local hiddenClient = self.client == 0 and source == "client"
    local hiddenServer = self.server == 0 and source == "server"
    return self.hidden == 1 or hiddenClient or hiddenServer or false
end

function Field:protoField(abbr)
    --if self.treeOnly then return ProtoField.none(abbr, self.name, self.desc) end
    return ProtoField.new(self.name, abbr, self.type, self.valuestring, self.base, self.mask, self.desc)
end

function Field:setData(data, trees)
    local size = self.size
    if trees and self.sizeOf then
        size = self.size and self.size or trees[self.sizeOf].field.value:le_uint()
    end
    self.realSize = (size ~= 0) and size or data:range():strsize()

    self.value = data:range(0, self.realSize)
end

return Field
