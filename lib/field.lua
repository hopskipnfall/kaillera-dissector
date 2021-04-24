-- field.lua

local class = require "lib.middleclass"
local Field = class("Field")

function Field:initialize(args)
    -- required arguments
    self.name = assert(args.name)
    self.type = assert(args.type)

    -- optional arguments for Message
    self.client = args.client or 1
    self.hidden = args.hidden or 0
    self.server = args.server or 1
    self.size = args.size or 0

    -- optional arguments from ProtoField
    self.valuestring = args.valuestring or nil
    self.base = args.base or nil
    self.mask = args.mask or nil
    self.descr = args.descr or nil

    self.value = nil
end

function Field:getValue(tvb)
    self.realSize = (self.size ~= 0) and self.size or tvb:range():strsize()
    self.value = tvb:range(0, self.realSize)
    return self.value
end

function Field:isHidden(source)
    local hiddenClient = self.client == 0 and source == "client"
    local hiddenServer = self.server == 0 and source == "server"
    return self.hidden == 1 or hiddenClient or hiddenServer or false
end

function Field:protoField(abbr)
    return ProtoField.new(self.name, abbr, self.type, self.valuestring, self.base, self.mask, self.desc)
end

return Field
