-- field.lua

local class = require "lib.middleclass"
local Field = class("Field")

function Field:initialize(args)
    -- https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Proto.html#lua_class_ProtoField
    -- ProtoField.new(name, abbr, type, [valuestring], [base], [mask], [descr])

    -- required arguments
    self.name = assert(args.name or args[1])
    self.type = assert(args.type or args[2])

    -- optional arguments for Message
    self.size = assert(args.size or args[3] or 0)
    self.client = assert(args.client or 1)
    self.server = assert(args.server or 1)

    -- optional arguments from ProtoField
    self.valuestring = args.valuestring or nil
    self.base = args.base or nil
    self.mask = args.mask or nil
    self.descr = args.descr or nil
end

function Field:protoField(abbr)
    return ProtoField.new(self.name, abbr, self.type, self.valuestring, self.base, self.mask, self.desc)
end

return Field
