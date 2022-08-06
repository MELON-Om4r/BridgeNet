---
sidebar_position: 3
---

# Getting Started
BridgeNet requires you to run the ``Start`` function with a configuration object passed in. This should look like:
```lua title="init.lua"
local BridgeNet = require(ReplicatedStorage.Packages.BridgeNet)

BridgeNet.Start({
	default_send_rate = 60,
	default_receive_rate = 60,
})
```
This starts up all the internal BridgeNet processes, and allows you to use the library. It should be called once per server/client. You do not
need to call this anywhere else.

## Using BridgeNet
BridgeNet uses objects known as "bridges". These objects are the equivelant of RemoteEvents in normal Roblox. They are created as such:
```lua title="init.lua"
local Bridge = BridgeNet.CreateBridge("RemoteNameHere")
Bridge:FireAll("Firing all players")
```
All the optimizations are handled for you! These is packaged, sent out with a compressed string ID, and received on the client.

## Using the identifier system
A common pattern in Roblox are constant strings that are sent over the client/server boundary. These are typically
static, and can depict things like action requests, item names, all of that. This library provides an easy system to optimize
these: the 3 functions ``CreateIdentifier``, ``WhatIsThis``, and ``DestroyIdentifier``. They are used as such:
```lua title="spellHandler.client.lua"
local SpellCaster = BridgeNet.CreateBridge("SpellCaster")

local Fireball = BridgeNet.CreateIdentifier("Fireball")

SomeUserInputSignalHere:Connect(function()
	SpellCaster:Fire(Fireball) -- Fires a 1 or 2 character string, much smaller than an 8-character string.
end)
```