--!strict
local HttpService = game:GetService("HttpService")
local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService: RunService = game:GetService("RunService")

local receiveDict: { [string]: string } = {}
local sendDict: { [string]: string } = {}
local numOfSerials: number = 0

--[=[
	@class SerdesLayer
	
	This module handles serialization and deserialization for you.
]=]
local SerdesLayer = {}

local AutoSerde: Folder = nil

type toSend = string

SerdesLayer.NilIdentifier = "null"

local function fromHex(toConvert: string): string
	return string.gsub(toConvert, "..", function(cc)
		return string.char(tonumber(cc, 16))
	end)
end

local function toHex(toConvert: string): string
	return string.gsub(toConvert, ".", function(c)
		return string.format("%02X", string.byte(c))
	end)
end

function SerdesLayer._start()
	if RunService:IsClient() then
		AutoSerde = ReplicatedStorage:WaitForChild("AutoSerde")
		for _, v in ipairs(AutoSerde:GetChildren()) do
			local strValue = v :: StringValue
			sendDict[strValue.Name] = strValue.Value
			receiveDict[strValue.Value] = strValue.Name
		end
		AutoSerde.ChildAdded:Connect(function(child: Instance)
			local strValue = child :: StringValue
			sendDict[strValue.Name] = strValue.Value
			receiveDict[strValue.Value] = strValue.Name
		end)
		AutoSerde.ChildRemoved:Connect(function(child: Instance)
			local strValue = child :: StringValue
			sendDict[strValue.Name] = nil
			receiveDict[strValue.Value] = nil
		end)
	else
		AutoSerde = Instance.new("Folder")
		AutoSerde.Name = "AutoSerde"
		AutoSerde.Parent = ReplicatedStorage
	end
end

function SerdesLayer._destroy()
	AutoSerde:Destroy()
end

--[=[
	Creates an identifier and associates it with a compressed value. This is shared between the server and the client.
	If the identifier already exists, it will be returned.
	
	```lua
		BridgeNet.CreateIdentifier("Something")
		
		print(BridgeNet.WhatIsThis("Something", "compressed"))
	```
	
	@param id string
	@return string
]=]
function SerdesLayer.CreateIdentifier(id: string): string
	if sendDict[id] then
		return sendDict[id] or SerdesLayer.WaitForIdentifier(id)
	end

	assert(RunService:IsServer(), "You cannot create identifiers on the client.")
	assert(type(id) == "string", "ID must be a string")

	if numOfSerials > 65536 then
		error("Over the identification cap: " .. id)
	end
	numOfSerials += 1

	local StringValue = Instance.new("StringValue")
	StringValue.Name = id
	StringValue.Value = string.pack("H", numOfSerials)
	StringValue.Parent = AutoSerde

	sendDict[id] = StringValue.Value
	receiveDict[StringValue.Value] = id

	return StringValue.Value
end

function SerdesLayer.WaitForIdentifier(id: string): string
	assert(not RunService:IsServer(), "WaitForIdentifier can only be called from the client!")

	repeat
		task.wait()
	until sendDict[id] ~= nil
	return sendDict[id]
end

function SerdesLayer.FromCompressed(compressed: string)
	return receiveDict[compressed]
end

function SerdesLayer.FromIdentifier(identifier: string)
	return sendDict[identifier]
end

--[=[
	Creates an identifier and associates it with a compressed value. This is shared between the server and the client.

	```lua
		BridgeNet.DestroyIdentifier("Something")
		
		print(BridgeNet.WhatIsThis("Something", "compressed")) -- Errors
	```
	
	@param id string
	@return nil
]=]
function SerdesLayer.DestroyIdentifier(id: string): nil
	assert(RunService:IsServer(), "You cannot destroy identifiers on the client.")
	assert(type(id) == "string", "ID must be a string")

	receiveDict[sendDict[id]] = nil
	sendDict[id] = nil

	numOfSerials -= 1

	AutoSerde:FindFirstChild(id):Destroy()
	return nil
end

--[=[
	Creates a UUID.

	```lua
		print(BridgeNet.CreateUUID()) -- Prints 93179AF839C94B9C975DB1B4A4352D75
	```
	
	@return string
]=]
function SerdesLayer.CreateUUID()
	return string.gsub(HttpService:GenerateGUID(false), "-", "")
end

--[=[
	Packs a UUID in hexadecimal form into a string, which can be sent over network as smaller.

	```lua
		print(BridgeNet.PackUUID(BridgeNet.CreateUUID())) -- prints something like �#F}ЉF��\�rY�*
	```
	
	@param uuid string
	@return string
]=]
function SerdesLayer.PackUUID(uuid: string): string
	return fromHex(uuid)
end

--[=[
	Takes a packed UUID and convetrs it into hexadecimal/readable form

	```lua
		print(BridgeNet.UnpackUUID(somePackedUUID)) -- Prints 93179AF839C94B9C975DB1B4A4352D75
	```
	
	@param uuid string
	@return string
]=]
function SerdesLayer.UnpackUUID(uuid: string): string
	return toHex(uuid)
end

--[=[
	Alphabetically sorts a dictionary and turns it into a table. Useful because string keys are typically unnecessary when sending things
	over the wire.
	
	Please note: This doesn't play too nicely with special characters.

	```lua
		print(BridgeNet.DictionaryToTable({ alpha = 999, bravo = 1000, charlie = 1001, delta = 1002 })) -- prints {999,1000,1001,1002}
	```
	
	@param dict {[string]: any}
	@return string
]=]
function SerdesLayer.DictionaryToTable(dict: { [string]: any })
	local keys = {}
	for key, _ in pairs(dict) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		return string.lower(a) < string.lower(b)
	end)
	local toReturn = {}
	for _, v in keys do
		table.insert(toReturn, dict[v])
	end
	return toReturn
end

return SerdesLayer
