"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[57],{51235:e=>{e.exports=JSON.parse('{"functions":[{"name":"CreateBridge","desc":"Creates a ServerBridge or a ClientBridge depending on if it\'s the server or client calling. If a Bridge of that name already exists, it\'ll return that Bridge object.\\nThis can be used to fetch bridges, but .WaitForBridge is recommended.\\n\\n```lua\\nlocal Bridge = BridgeNet.CreateBridge(\\"Remote\\")\\n```","params":[{"name":"remoteName","desc":"","lua_type":"string"}],"returns":[{"desc":"","lua_type":"ServerBridge | ClientBridge"}],"function_type":"static","source":{"line":39,"path":"src/init.lua"}},{"name":"WaitForBridge","desc":"Waits for a BridgeObject to be created, then resumes the thread.\\nThis does NOT replicate. If the server creates a BridgeObject, it will NOT replicate to the client.\\nThis will wait until a BridgeObject is created for the client/server respectively.\\n\\n```lua\\nprint(\\"client is waiting for the bridge to be created on the client..\\")\\nlocal Bridge = BridgeNet.WaitForBridge(\\"Remote\\")\\nprint(\\"client is done waiting! was created in another script.\\")\\n```","params":[],"returns":[{"desc":"","lua_type":"BridgeObject"}],"function_type":"static","source":{"line":56,"path":"src/init.lua"}},{"name":"CreateBridgesFromDictionary","desc":"Loops through the dictionary given and creates ``Bridge``s for the dictionary keys.\\nExample usage:\\n```lua\\nlocal Network = BridgeNet.CreateBridgesFromDictionary({\\n\\tRemoteA = \\"RemoteA\\",\\n\\tRemoteB = \\"Rem_B\\", -- Creates bridge \\"Rem_B\\" with index \\"RemoteB\\"\\n\\tOtherRemotes = {\\n\\t\\tPrintStuff = \\"Print\\",\\n\\t\\tDoStuff = \\"DoStuff\\",\\n\\t},\\n})","params":[],"returns":[],"function_type":"static","source":{"line":73,"path":"src/init.lua"}},{"name":"Start","desc":"This function starts BridgeNet. It must be called on both the client and server.\\n\\t\\nAll possible parameters:\\n\\t- DefaultReceive (BridgeNet.DefaultReceive) sets the rate of which incoming data is handled. Defaults to 60 hz\\n\\t- DefaultSend (BridgeNet.DefaultSend) sets the rate of which outgoing data is sent. Defaults to 60 hz\\n\\t- SendLogFunction (BridgeNet.SendLogFunction) sets the custom logging function for all outgoing data. Default is none [UNSTABLE]\\n\\t- ReceiveLogFunction (BridgeNet.ReceiveLogFunction) sets the custom logging function for all incoming data. Default is none [UNSTABLE]\\n```lua\\n\\tBridgeNet.Start({ -- server\\n\\t\\t[BridgeNet.DefaultReceive] = 60,\\n\\t\\t[BridgeNet.DefaultSend] = 60,\\n\\t\\t[SendLogFunction] = function(remote, plrs, ...) \\n\\t\\t\\tlocal args = table.pack(...)\\n\\t\\t\\tprint(remote, plrs, args)\\n\\t\\tend,\\n\\t\\t[ReceiveLogFunction] = function(remote, plr, ...)\\n\\t\\t\\tprint(remote, plr, args)\\n\\t\\tend,\\n\\t})\\n```","params":[{"name":"options","desc":"","lua_type":"{}"}],"returns":[{"desc":"","lua_type":"nil"}],"function_type":"static","source":{"line":102,"path":"src/init.lua"}}],"properties":[],"types":[],"name":"BridgeNet","desc":"The interface for the package.","source":{"line":24,"path":"src/init.lua"}}')}}]);