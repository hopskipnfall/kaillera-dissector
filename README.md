# kaillera-dissector
Wireshark plugin to decode kaillera middleware and p2p packets

# Getting Started

- Install [Wireshark](https://www.wireshark.org/#download)
- Download an emulator with [Kaillera](http://kaillera.com/download.php) support (for server)
- Download an emualtor with [Kaillera P2P](http://p2p.kaillera.ru/#) support (for p2p)
- [Download](https://github.com/smash64-dev/kaillera-dissector/archive/refs/heads/main.zip) or clone this into Wireshark's plugin directory (**Help > About Wireshark > Folders > Personal Lua Plugins**)

# Usage

## Dissector Heuristics

Both dissectors have heuristics to detect connections when *connecting* to a server or another player. If you don't have the connection packets, you can still decode the packets by right-clicking and selecting **Decode as...**.
- Kaillera Middleware: `Kaillera`
- Open Kaillera P2P: `Okai`

# Contributing

The included libraries (`lib/*`) are OOP classes using [middleclass](https://github.com/kikito/middleclass) and written to be reusable for other similarly formatted packets. They allow for defining the protocols in `constants.lua`. Eventually, they might be refactored into their own package and submitted to [LuaRocks](https://luarocks.org/). So any contributions should make sure the classes stay as generic as possible.

# Todo

- [x] Basic Kaillera and Open Kaillera support
- [x] Dissector hueristics
- [ ] Identify the few remaining unknown fields
- [ ] Formatter support to process the data further
- [ ] Decode game data per-emulator
- [ ] Implement preferences support for emulator selection ([Pref](https://www.wireshark.org/docs/wsdg_html_chunked/lua_module_Proto.html))
- [ ] Add some anonymous sample PCAP files
- [ ] Refactor library out into [LuaRocks](https://luarocks.org/) package

# Acknowledgements

- [middleclass](https://github.com/kikito/middleclass) library
- Anthem, SupraFast, Moosehead, and anyone else who helped analyze kaillera

# License

License is [MIT](LICENSE.md).
