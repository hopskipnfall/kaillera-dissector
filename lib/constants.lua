-- constants.lua

local class = require "lib.middleclass"
local Field = require "lib.field"
local Message = require "lib.message"

MESSAGE_TYPES = {
    [1] = "USER_QUIT",  -- empty, ff
    [2] = "USER_JOIN",
    [3] = "USER_INFO",
    [4] = "SERVER_STATUS",
    [5] = "SERVER_ACK",
    [6] = "CLIENT_ACK",
    [7] = "GLOBAL_CHAT",    -- empty
    [8] = "GAME_CHAT",      -- empty
    [9] = "KEEP_ALIVE",
    [10] = "GAME_CREATE",   -- empty, ff
    [11] = "GAME_QUIT",     -- empty, ff
    [12] = "GAME_JOIN",     -- empty, 00, ff
    [13] = "PLAYER_INFO",
    [14] = "GAME_STATUS",
    [15] = "GAME_KICK",
    [16] = "GAME_CLOSE",
    [17] = "GAME_START",    -- ff
    [18] = "GAME_INFO",     -- ??/same?
    [19] = "GAME_CACHE",    -- ??/same?
    [20] = "GAME_DROP",     -- empty, 00
    [21] = "GAME_READY",    -- ??/same
    [22] = "SERVER_REJECT",
    [23] = "SERVER_NOTICE"
}

CONNECTION_TYPE = {
    [1] = "LAN",
    [2] = "Excellent",
    [3] = "Good",
    [4] = "Average",
    [5] = "Low",
    [6] = "Bad"
}

KAILLERA_MESSAGES = {
    [0x1] = Message:new({
        name = "USER_QUIT",
        struct = {
            Field:new({name = "Username (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "UserID (unused by client)", type = ftypes.UINT8, size = 2, base = base.HEX}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        }
    }),
    [0x2] = Message:new({
        name = "USER_JOIN",
        struct = {
            Field:new({name = "Username", type = ftypes.STRINGZ}),
            Field:new({name = "UserID", type = ftypes.UINT8, size = 2, base = base.HEX}),
            Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0x3] = Message:new({
        name = "USER_LOGIN",
        struct = {
            Field:new({name = "Username", type = ftypes.STRINGZ}),
            Field:new({name = "Emulator", type = ftypes.STRINGZ}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    -- TODO: does not load list of users and games
    [0x4] = {
        name = "SERVER_STATUS",
        struct = {
            Field:new({name = "Empty", type = ftypes.STRINGZ}),
            Field:new({name = "Number of Users", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Number of Games", type = ftypes.UINT8, size = 4}),
        },
    },
    [0x5] = {
        name = "SERVER_ACK",
        struct = {
            Field:new({name = "Empty", type = ftypes.STRINGZ}),
            Field:new({name = "Unknown 0", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 1", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 2", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 3", type = ftypes.UINT8, size = 4}),
        },
    },
    [0x6] = {
        name = "CLIENT_ACK",
        struct = {
            Field:new({name = "Empty", type = ftypes.STRINGZ}),
            Field:new({name = "Unknown 0", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 1", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 2", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Unknown 3", type = ftypes.UINT8, size = 4}),
        },
    },
    [0x7] = {
        name = "GLOBAL_CHAT",
        struct = {
            Field:new({name = "Username (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        },
    },
    [0x8] = {
        name = "GAME_CHAT",
        struct = {
            Field:new({name = "Username (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        },
    },
    [0x9] = {
        name = "KEEP_ALIVE",
        struct = {
            Field:new({name = "Empty", type = ftypes.STRINGZ}),
        },
    },
    [0xA] = {
        name = "GAME_CREATE",
        struct = {
            Field:new({name = "Username (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "Game Name", type = ftypes.STRINGZ}),
            Field:new({name = "Emulator (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "GameID (unused by client)", type = ftypes.UINT8, size = 4}),
        },
    },
    [0xB] = {
        name = "GAME_QUIT",
        struct = {
            Field:new({name = "Username (unused by client)", type = ftypes.STRINGZ}),
            Field:new({name = "UserID (unused by client)", type = ftypes.UINT8, size = 2, base = base.HEX}),
        },
    },
    [0x17] = {
        name = "SERVER_NOTICE",
        struct = {
            Field:new({name = "'Server'", type = ftypes.STRINGZ}),
            Field:new({name = "Message", type = ftypes.STRINGZ}),
        },
    },
}
