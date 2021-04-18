-- kaillera.lua
-- http://kaillera.com/

require "lib.constants"

local class = require "lib.middleclass"
local Message = require "lib.message"
local inspect = require "lib.inspect"

local kaillera = Proto("kaillera","Kaillera Middleware Protocol")
kaillera.fields = {}

-- parent message
local fields = kaillera.fields
fields.msg_count    = ProtoField.uint8("kaillera.cnt", "Messages")
fields.msg_id       = ProtoField.uint16("kaillera.id", "Transaction ID")
fields.msg_length   = ProtoField.uint16("kaillera.len", "Length")
fields.msg_type     = ProtoField.uint8("kaillera.type", "Type", base.HEX, Message.static:getTypes(KAILLERA_MESSAGES))

for message, proto in pairs(Message.static:buildProtoFields(KAILLERA_MESSAGES, "kaillera")) do
    fields[message] = proto
end

local function dissectMessage(data, type, tree)
    if KAILLERA_MESSAGES[type:int()] == nil then
        return
    end

    local message = KAILLERA_MESSAGES[type:int()]
    local offset = 1

    for index, field in ipairs(message.struct) do
        local name = string.format("%s.%s.%s", "kaillera", string.lower(message.name), index)

        if field.size == 0 then
            local len = data:range(offset):strsize()
            tree:add_le(fields[name], data:range(offset, len))
            offset = offset + len
        else
            tree:add_le(fields[name], data:range(offset, field.size))
            offset = offset + field.size
        end
    end
end

function kaillera.dissector(tvb, pinfo, tree)
    pinfo.cols.protocol = "Kaillera"

    local payload = tree:add(kaillera, tvb())
    local count = tvb:range(0,1)
    local messages = payload:add_le(fields.msg_count, count)

    local offset = 1
    for i = 1, count:int() do
        local message = messages:add_le(fields.msg_id, tvb:range(offset, 2))
        local len = tvb:range(offset + 2, 2)
        local type = tvb:range(offset + 4, 1)

        message:add_le(fields.msg_length, len)
        local data = message:add_le(fields.msg_type, type)
        dissectMessage(tvb:range(offset + 4, len:le_uint()), type, data)

        offset = offset + 4 + len:le_uint()
    end
end

for i = 27000, 28000, 1 do
    DissectorTable.get("udp.port"):add(i, kaillera)
end
