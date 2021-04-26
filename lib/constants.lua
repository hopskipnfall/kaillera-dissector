-- constants.lua

local ArrayField = require "lib.arrayfield"
local Field = require "lib.field"
local Message = require "lib.message"

-- kaillera constants
KAILLERA_PROTOCOL = "Kaillera"

CONNECTION_TYPE = {
    [1] = "LAN",
    [2] = "Excellent",
    [3] = "Good",
    [4] = "Average",
    [5] = "Low",
    [6] = "Bad",
}

GAME_STATUS = {
    [0] = "Waiting",
    [1] = "Playing",
    [2] = "Syncing",
}

PLAYER_STATUS = {
    [0] = "Playing",
    [1] = "Waiting",
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
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, base = base.HEX, client = 0}),
            Field:new({name = "Quit Message", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
        }
    }),
    [0x2] = Message:new({
        name = "CLIENT_JOIN",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, base = base.HEX}),
            Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0x3] = Message:new({
        name = "CLIENT_INFO",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
            Field:new({name = "Emulator Name", type = ftypes.STRINGZ}),
            Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
        }
    }),
    [0x4] = Message:new({
        name = "SERVER_STATUS",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Number of Players", type = ftypes.UINT8, size = 4, parentId = "users"}),
            Field:new({name = "Number of Games", type = ftypes.UINT8, size = 4, parentId = "games"}),
            ArrayField:new({name = "Users", sizeOf = "users", fields = {
                Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, parentId = "user", childOf = "users"}),
                Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4, childOf = "user"}),
                Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE, childOf = "user"}),
                Field:new({name = "User ID", type = ftypes.UINT8, size = 2, base = base.HEX, childOf = "user"}),
                Field:new({name = "Player Status", type = ftypes.UINT8, size = 1, valuestring = PLAYER_STATUS, childOf = "user"}),
            }}),
            ArrayField:new({name = "Games", sizeOf = "games", fields = {
                Field:new({name = "Game Name", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, parentId = "game", childOf = "games"}),
                Field:new({name = "Game ID", type = ftypes.UINT8, size = 4, childOf = "game"}),
                Field:new({name = "Emulator Name", type = ftypes.STRINGZ, childOf = "game"}),
                Field:new({name = "Owner", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, childOf = "game"}),
                Field:new({name = "Player Count", type = ftypes.STRINGZ, childOf = "game"}),
                Field:new({name = "Game Status", type = ftypes.UINT8, size = 1, valuestring = GAME_STATUS, childOf = "game"}),
            }})
        },
    }),
    [0x5] = Message:new({
        name = "SERVER_ACK",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            ArrayField:new({name = "Unknown", size = 4, fields = {
                Field:new({name = "Unknown", type = ftypes.UINT8, size = 4}),
            }}),
        }
    }),
    [0x6] = Message:new({
        name = "CLIENT_ACK",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            ArrayField:new({name = "Unknown", size = 4, fields = {
                Field:new({name = "Unknown", type = ftypes.UINT8, size = 4}),
            }}),
        }
    }),
    [0x7] = Message:new({
        name = "CHAT_GLOBAL",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            Field:new({name = "Message", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
        }
    }),
    [0x8] = Message:new({
        name = "CHAT_GAME",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            Field:new({name = "Message", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
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
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            Field:new({name = "Game Name", type = ftypes.STRINGZ}),
            Field:new({name = "Emulator Name", type = ftypes.STRINGZ, client = 0}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4, client = 0}),
        }
    }),
    [0xB] = Message:new({
        name = "GAME_QUIT",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2, client = 0}),
        }
    }),
    [0xC] = Message:new({
        name = "GAME_JOIN",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Game ID", type = ftypes.UINT8, size = 4}),
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
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
            --Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
            --Field:new({name = "Ping (ms)", type = ftypes.UINT8, size = 4, client = 0}),
            --Field:new({name = "User ID", type = ftypes.UINT8, size = 2, client = 0}),
            --Field:new({name = "Connection Type", type = ftypes.UINT8, size = 1, valuestring = CONNECTION_TYPE}),
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
            Field:new({name = "Empty", type = ftypes.STRINGZ, client = 0, hidden = 1}),
            Field:new({name = "Frame Delay", type = ftypes.UINT8, size = 2, client = 0}),
            Field:new({name = "Player Number", type = ftypes.UINT8, size = 1, client = 0}),
            Field:new({name = "Total Players", type = ftypes.UINT8, size = 1, client = 0}),
        }
    }),
    [0x12] = Message:new({
        name = "GAME_DATA",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Length", type = ftypes.UINT8, size = 2, parentId = "length"}),
            Field:new({name = "Data", type = ftypes.BYTES, sizeOf = "length"}),
            -- TODO: parse data
        }
    }),
    [0x13] = Message:new({
        name = "GAME_CACHE",
        fields = {
            Field:new({name = "Empty", type = ftypes.STRINGZ, hidden = 1}),
            Field:new({name = "Index", type = ftypes.UINT8, size = 1}),
        }
    }),
    [0x14] = Message:new({
        name = "GAME_DROP",
        fields = {
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1, client = 0}),
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
            Field:new({name = "Username", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
            Field:new({name = "User ID", type = ftypes.UINT8, size = 2}),
            Field:new({name = "Message", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
        }
    }),
    [0x17] = Message:new({
        name = "SERVER_NOTICE",
        fields = {
            Field:new({name = "'server'", type = ftypes.STRINGZ}),
            Field:new({name = "Message", type = ftypes.STRINGZ, encoding = ENC_ISO_8859_1}),
        }
    }),
}
