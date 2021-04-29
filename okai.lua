-- okai.lua
-- http://p2p.okai.ru/

require "lib.constants"
local Message = require "lib.message"

OKAI_PROTOCOL = "Okai"
OKAI_DESCRIPTION = "Open Kaillera Protocol"

local okai = Proto(string.lower(OKAI_PROTOCOL), OKAI_DESCRIPTION)
okai.fields = {}
local fields = okai.fields

-- typed messages
fields.msg_count    = ProtoField.uint8("okai.cnt", "Messages")
fields.msg_id       = ProtoField.uint8("okai.id", "Message ID")
fields.msg_length   = ProtoField.uint8("okai.len", "Length")
fields.msg_type     = ProtoField.uint8("okai.type", "Type", base.HEX, Message.static:buildMessageTypes(OKAI_TYPES))

-- generated fields
for message, proto in pairs(Message.static:buildProtoFields(OKAI_TYPES, OKAI_PROTOCOL)) do
    fields[message] = proto
end

function okai.dissector(tvb, pinfo, tree)
    pinfo.cols.protocol = OKAI_PROTOCOL
    local payload = tree:add(okai, tvb())

    local count = tvb:range(0,1)
    local messages = payload:add_le(fields.msg_count, count)

    local offset = 1
    for i = 1, count:int() do
        local message = messages:add_le(fields.msg_id, tvb:range(offset, 1))
        local len = tvb:range(offset + 1, 1)
        message:add_le(fields.msg_length, len)

        local type = tvb:range(offset + 2, 1)
        local data = message:add_le(fields.msg_type, type)
        local messageType = OKAI_TYPES[type:int()]

        if messageType then
            messageType.protocol = OKAI_PROTOCOL
            if len:le_uint() > 1 then
                messageType:dissect(okai.fields, tvb:range(offset + 2, len:le_uint()), data)
            end

            message:set_len(len:le_uint() + 2)
        end

        offset = offset + 2 + len:le_uint()
    end
end

-- TODO: heuristic might not be possible, add a way to set this, Pref?
for i = 27000, 28000, 1 do
    DissectorTable.get("udp.port"):add(i, okai)
end
