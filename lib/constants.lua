-- constants.lua

local Field = require "lib.field"
local Message = require "lib.message"

CONNECTION_TYPE = {
    [1] = "LAN",
    [2] = "Excellent",
    [3] = "Good",
    [4] = "Average",
    [5] = "Low",
    [6] = "Bad"
}

GAME_STATUS = {
    [0] = "Waiting",
    [1] = "Playing",
    [2] = "Syncing"
}

RAW_KAILLERA = {
    client_hello = "HELLO0.83",
    client_ping = "PING",
    server_hello = "HELLOD00D([0-9]+)",
    server_pong = "PONG",
}

TYPES_KAILLERA = {
    [0x1] = Message:new({
        name = "CLIENT_QUIT",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, base = base.HEX, client = 0}),
            Field:new({name = "Quit Message", type = ftypes.STRINGZ}),
        }
    }),
    [0x2] = Message:new({
        name = "CLIENT_JOIN",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, base = base.HEX}),
            Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0x3] = Message:new({
        name = "CLIENT_INFO",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ}),
            Field:new({name = "Emulator Name", type = ftypes.STRINGZ}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0x4] = Message:new({
        name = "SERVER_STATUS",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Number of Players", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Number of Games", type = ftypes.UINT8, size = 4}),
            -- TODO: does not load list of users and games
        }
    }),
    [0x5] = Message:new({
        name = "SERVER_ACK",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Unknown 0", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 1", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 2", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 3", type = ftypes.UINT8, size = 4}),
        }
    }),
    [0x6] = Message:new({
        name = "CLIENT_ACK",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Unknown 0", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 1", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 2", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 3", type = ftypes.UINT8, size = 4}),
        }
    }),
    [0x7] = Message:new({
        name = "CHAT_GLOBAL",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        }
    }),
    [0x8] = Message:new({
        name = "CHAT_GAME",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        }
    }),
    [0x9] = Message:new({
        name = "KEEP_ALIVE",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
        }
    }),
    [0xA] = Message:new({
        name = "GAME_CREATE",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Game Name", type = ftypes.STRINGZ}),
            Field:new({name = "Emulator Name", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4, client = 0}),
        }
    }),
    [0xB] = Message:new({
        name = "GAME_QUIT",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, client = 0}),
        }
    }),
    [0xC] = Message:new({
        name = "GAME_JOIN",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, client = 0}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0xD] = Message:new({
        name = "GAME_PLAYER",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Number of Players", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, client = 0}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0xE] = Message:new({
        name = "GAME_STATUS",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Game Status", type = ftypes.UINT8, size = 1, valuestring = GAME_STATUS}),
            Field:new({name = "Number of Players", type = ftypes.UINT8, size = 1}),
            Field:new({name = "Maximum Players", type = ftypes.UINT8, size = 1}),
        }
    }),
    [0xF] = Message:new({
        name = "GAME_KICK",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2}),
        }
    }),
    [0x10] = Message:new({
        name = "GAME_CLOSE",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4}),
        }
    }),
    [0x11] = Message:new({
        name = "GAME_START",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Frame Delay", type = ftypes.UINT8, size = 2, client = 0}),
            Field:new({name = "Player Number", type = ftypes.UINT8, size = 1, client = 0}),
            Field:new({name = "Total Players", type = ftypes.UINT8, size = 1, client = 0}),
        }
    }),
    [0x12] = Message:new({
        name = "GAME_DATA",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Length", type = ftypes.UINT8, size = 2}),
            Field:new({name = "Data", type = ftypes.STRINGZ}),
            -- TODO: parse data
        }
    }),
    [0x13] = Message:new({
        name = "GAME_CACHE",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Index", type = ftypes.UINT8, size = 1}),
            -- TODO: ???
        }
    }),
    [0x14] = Message:new({
        name = "GAME_DROP",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Player Number", type = ftypes.UINT8, size = 1}),
        }
    }),
    [0x15] = Message:new({
        name = "GAME_READY",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
        }
    }),
    [0x16] = Message:new({
        name = "SERVER_REJECT",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        }
    }),
    [0x17] = Message:new({
        name = "SERVER_NOTICE",
        fields = {
            Field:new({name = "'server'", type = ftypes.STRINGZ}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        }
    }),
}
