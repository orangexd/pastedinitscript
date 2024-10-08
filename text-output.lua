--!native
--!optimize 2

if not game:IsLoaded() then game.Loaded:Wait() end

local ExploitInfo = {
    ["Name"] = "%VIRTUE%",
}

warn(string.format("%s initialized. Please report any bugs you find in our Discord server.", ExploitInfo["Name"]))      --!native
--!optimize 2

if not game:IsLoaded() then game.Loaded:Wait() end

local ExploitInfo = {
    ["Name"] = "%VIRTUE%",
}

local RobloxEnvironment = {
	["print"] = print, ["warn"] = warn, ["error"] = error, ["assert"] = assert, ["collectgarbage"] = collectgarbage, ["require"] = require,
	["select"] = select, ["tonumber"] = tonumber, ["tostring"] = tostring, ["type"] = type, ["xpcall"] = xpcall,
	["pairs"] = pairs, ["next"] = next, ["ipairs"] = ipairs, ["newproxy"] = newproxy, ["rawequal"] = rawequal, ["rawget"] = rawget,
	["rawset"] = rawset, ["rawlen"] = rawlen, ["gcinfo"] = gcinfo,

	["coroutine"] = {
		["create"] = coroutine.create, ["resume"] = coroutine.resume, ["running"] = coroutine.running,
		["status"] = coroutine.status, ["wrap"] = coroutine.wrap, ["yield"] = coroutine.yield,
	},

	["bit32"] = {
		["arshift"] = bit32.arshift, ["band"] = bit32.band, ["bnot"] = bit32.bnot, ["bor"] = bit32.bor, ["btest"] = bit32.btest,
		["extract"] = bit32.extract, ["lshift"] = bit32.lshift, ["replace"] = bit32.replace, ["rshift"] = bit32.rshift, ["xor"] = bit32.xor,
	},

	["math"] = {
		["abs"] = math.abs, ["acos"] = math.acos, ["asin"] = math.asin, ["atan"] = math.atan, ["atan2"] = math.atan2, ["ceil"] = math.ceil,
		["cos"] = math.cos, ["cosh"] = math.cosh, ["deg"] = math.deg, ["exp"] = math.exp, ["floor"] = math.floor, ["fmod"] = math.fmod,
		["frexp"] = math.frexp, ["ldexp"] = math.ldexp, ["log"] = math.log, ["log10"] = math.log10, ["max"] = math.max, ["min"] = math.min,
		["modf"] = math.modf, ["pow"] = math.pow, ["rad"] = math.rad, ["random"] = math.random, ["randomseed"] = math.randomseed,
		["sin"] = math.sin, ["sinh"] = math.sinh, ["sqrt"] = math.sqrt, ["tan"] = math.tan, ["tanh"] = math.tanh
	},

	["string"] = {
		["byte"] = string.byte, ["char"] = string.char, ["find"] = string.find, ["format"] = string.format, ["gmatch"] = string.gmatch,
		["gsub"] = string.gsub, ["len"] = string.len, ["lower"] = string.lower, ["match"] = string.match, ["pack"] = string.pack,
		["packsize"] = string.packsize, ["rep"] = string.rep, ["reverse"] = string.reverse, ["sub"] = string.sub,
		["unpack"] = string.unpack, ["upper"] = string.upper,
	},

	["table"] = {
		["concat"] = table.concat, ["insert"] = table.insert, ["pack"] = table.pack, ["remove"] = table.remove, ["sort"] = table.sort,
		["unpack"] = table.unpack,
	},

	["utf8"] = {
		["char"] = utf8.char, ["charpattern"] = utf8.charpattern, ["codepoint"] = utf8.codepoint, ["codes"] = utf8.codes,
		["len"] = utf8.len, ["nfdnormalize"] = utf8.nfdnormalize, ["nfcnormalize"] = utf8.nfcnormalize,
	},

	["os"] = {
		["clock"] = os.clock, ["date"] = os.date, ["difftime"] = os.difftime, ["time"] = os.time,
	},

	["delay"] = delay, ["elapsedTime"] = elapsedTime, ["spawn"] = spawn, ["tick"] = tick, ["time"] = time, ["typeof"] = typeof,
	["UserSettings"] = UserSettings, ["version"] = version, ["wait"] = wait, ["_VERSION"] = _VERSION,

	["task"] = {
		["defer"] = task.defer, ["delay"] = task.delay, ["spawn"] = task.spawn, ["wait"] = task.wait,
	},

	["debug"] = {
		["traceback"] = debug.traceback, ["profilebegin"] = debug.profilebegin, ["profileend"] = debug.profileend,
	},

	["game"] = game, ["workspace"] = workspace, ["Game"] = game, ["Workspace"] = workspace,

	["getmetatable"] = getmetatable, ["setmetatable"] = setmetatable
}

table.freeze(RobloxEnvironment)

getgenv().getrenv = newcclosure(function()
	return RobloxEnvironment
end)

getgenv().require = newcclosure(function(...)
    local OriginalIdentity = getidentity()
    setidentity(1)
    local Table = getrenv().require(...)
    setidentity(OriginalIdentity)
    return Table
end)

getgenv().dumpstring = GetScriptBytecode

getgenv().hookmetamethod = newcclosure(function(a, b, c)
    local L = getrawmetatable(a)
    if not L then
        return error "No metatable detected!"
    elseif not rawget(L, b) then
        return error(b .. " Is not in metatable!")
    elseif type(c) ~= "function" then
        return error("Need function at 3rd argument!")
    end
    return hookfunction(rawget(L, b), c)
end)

-- Crypt library (temporary, will use CryptoPP soon)
local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

getgenv().getc = newcclosure(function(str)
    local sum = 0
    for _, code in utf8.codes(str) do
        sum = sum + code
    end
    return sum
end)

getgenv().str2hexa = newcclosure(function(a)
    return string.gsub(
        a,
        ".",
        function(b)
            return string.format("%02x", string.byte(b))
        end
    )
end)

getgenv().num2s = newcclosure(function(c, d)
    local a = ""
    for e = 1, d do
        local f = c % 256
        a = string.char(f) .. a
        c = (c - f) / 256
    end
    return a
end)

getgenv().s232num = newcclosure(function(a, e)
    local d = 0
    for g = e, e + 3 do
        d = d * 256 + string.byte(a, g)
    end
    return d
end)

getgenv().preproc = newcclosure(function(h, i)
    local j = 64 - (i + 9) % 64
    i = num2s(8 * i, 8)
    h = h .. "\128" .. string.rep("\0", j) .. i
    assert(#h % 64 == 0)
    return h
end)

getgenv().k = newcclosure(function(h, e, l)
    local m = {}
    local n = {
        0x428a2f98,
        0x71374491,
        0xb5c0fbcf,
        0xe9b5dba5,
        0x3956c25b,
        0x59f111f1,
        0x923f82a4,
        0xab1c5ed5,
        0xd807aa98,
        0x12835b01,
        0x243185be,
        0x550c7dc3,
        0x72be5d74,
        0x80deb1fe,
        0x9bdc06a7,
        0xc19bf174,
        0xe49b69c1,
        0xefbe4786,
        0x0fc19dc6,
        0x240ca1cc,
        0x2de92c6f,
        0x4a7484aa,
        0x5cb0a9dc,
        0x76f988da,
        0x983e5152,
        0xa831c66d,
        0xb00327c8,
        0xbf597fc7,
        0xc6e00bf3,
        0xd5a79147,
        0x06ca6351,
        0x14292967,
        0x27b70a85,
        0x2e1b2138,
        0x4d2c6dfc,
        0x53380d13,
        0x650a7354,
        0x766a0abb,
        0x81c2c92e,
        0x92722c85,
        0xa2bfe8a1,
        0xa81a664b,
        0xc24b8b70,
        0xc76c51a3,
        0xd192e819,
        0xd6990624,
        0xf40e3585,
        0x106aa070,
        0x19a4c116,
        0x1e376c08,
        0x2748774c,
        0x34b0bcb5,
        0x391c0cb3,
        0x4ed8aa4a,
        0x5b9cca4f,
        0x682e6ff3,
        0x748f82ee,
        0x78a5636f,
        0x84c87814,
        0x8cc70208,
        0x90befffa,
        0xa4506ceb,
        0xbef9a3f7,
        0xc67178f2
    }
    for g = 1, 16 do
        m[g] = s232num(h, e + (g - 1) * 4)
    end
    for g = 17, 64 do
        local o = m[g - 15]
        local p = bit32.bxor(bit32.rrotate(o, 7), bit32.rrotate(o, 18), bit32.rshift(o, 3))
        o = m[g - 2]
        local q = bit32.bxor(bit32.rrotate(o, 17), bit32.rrotate(o, 19), bit32.rshift(o, 10))
        m[g] = (m[g - 16] + p + m[g - 7] + q) % 2 ^ 32
    end
    local r, s, b, t, u, v, w, x = l[1], l[2], l[3], l[4], l[5], l[6], l[7], l[8]
    for e = 1, 64 do
        local p = bit32.bxor(bit32.rrotate(r, 2), bit32.rrotate(r, 13), bit32.rrotate(r, 22))
        local y = bit32.bxor(bit32.band(r, s), bit32.band(r, b), bit32.band(s, b))
        local z = (p + y) % 2 ^ 32
        local q = bit32.bxor(bit32.rrotate(u, 6), bit32.rrotate(u, 11), bit32.rrotate(u, 25))
        local A = bit32.bxor(bit32.band(u, v), bit32.band(bit32.bnot(u), w))
        local B = (x + q + A + n[e] + m[e]) % 2 ^ 32
        x = w
        w = v
        v = u
        u = (t + B) % 2 ^ 32
        t = b
        b = s
        s = r
        r = (B + z) % 2 ^ 32
    end
    l[1] = (l[1] + r) % 2 ^ 32
    l[2] = (l[2] + s) % 2 ^ 32
    l[3] = (l[3] + b) % 2 ^ 32
    l[4] = (l[4] + t) % 2 ^ 32
    l[5] = (l[5] + u) % 2 ^ 32
    l[6] = (l[6] + v) % 2 ^ 32
    l[7] = (l[7] + w) % 2 ^ 32
    l[8] = (l[8] + x) % 2 ^ 32
end)

getgenv().crypt = {
    ["base64encode"] = newcclosure(function(data)
        return (data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b64:sub(c+1,c+1)
		end)..({'','==','='})[#data%3+1]
    end),
    ["base64decode"] = newcclosure(function(data)
        data = data:gsub('[^'..b64..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',b64:find(x)-1
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end)) 
    end),
    ["base64_decode"] = base64decode,
    ["base64_encode"] = base64encode,
    ["base64"] = {
        ["encode"] = base64encode,
        ["decode"] = base64decode
    },
    ["encrypt"] = newcclosure(function(data, key, iv, mode)
        assert(type(data) == "string", "Data must be a string")
		assert(type(key) == "string", "Key must be a string")

		mode = mode or "CBC"
		iv = iv or crypt.generatebytes(16)

		local byteChange = (getc(mode) + getc(iv) + getc(key)) % 256
		local res = {}

		for i = 1, #data do
			local byte = (string.byte(data, i) + byteChange) % 256
			table.insert(res, string.char(byte))
		end

		local encrypted = table.concat(res)
		return crypt.base64encode(encrypted), iv
    end),
    ["decrypt"] = newcclosure(function(data, key, iv, mode)
        assert(type(data) == "string", "Data must be a string")
		assert(type(key) == "string", "Key must be a string")
		assert(type(iv) == "string", "IV must be a string")

		mode = mode or "CBC"

		local decodedData = crypt.base64decode(data)
		local byteChange = (getc(mode) + getc(iv) + getc(key)) % 256
		local res = {}

		for i = 1, #decodedData do
			local byte = (string.byte(decodedData, i) - byteChange) % 256
			table.insert(res, string.char(byte))
		end

		return table.concat(res)
    end),
    ["generatebytes"] = newcclosure(function(size)
        local bytes = table.create(size)

		for i = 1, size do
			bytes[i] = string.char(math.random(0, 255))
		end

		return crypt.base64encode(table.concat(bytes))
    end),
    ["generatekey"] = newcclosure(function()
        return crypt.generatebytes(32)
    end),
    ["hash"] = newcclosure(function(h)
        h = preproc(h, #h)
        local l = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
        for e = 1, #h, 64 do
            k(h, e, l)
        end
        return str2hexa(
            num2s(l[1], 4) ..
                num2s(l[2], 4) ..
                    num2s(l[3], 4) .. num2s(l[4], 4) .. num2s(l[5], 4) .. num2s(l[6], 4) .. num2s(l[7], 4) .. num2s(l[8], 4)
        )
    end)
}

local IsWindowFocused = true
getgenv().isrbxactive = newcclosure(function()
    return IsWindowFocused
end)

getgenv().isgameactive = isrbxactive

local UserInputService = game:GetService("UserInputService")
UserInputService["WindowFocused"]:Connect(function()
    IsWindowFocused = true
end)

UserInputService["WindowFocusReleased"]:Connect(function()
    IsWindowFocused = false
end)

local RunService = game:GetService("RunService")

getgenv().gethiddenproperty = newcclosure(function(inst, idx) 
	assert(typeof(script) == "Instance", "invalid argument #1 to 'gethiddenproperty' [Instance expected]", 2);
	local was = isscriptable(inst, idx);
	setscriptable(inst, idx, true)

	local value = inst[idx]
	setscriptable(inst, idx, was)

	return value, not was
end)

getgenv().sethiddenproperty = newcclosure(function(inst, idx, value) 
	assert(typeof(script) == "Instance", "invalid argument #1 to 'sethiddenproperty' [Instance expected]", 2);
	local was = isscriptable(inst, idx);
	setscriptable(inst, idx, true)

	inst[idx] = value

	setscriptable(inst, idx, was)

	return not was
end)


getgenv().lz4compress = newcclosure(function(data)
    local out, i, dataLen = {}, 1, #data

    while i <= dataLen do
        local bestLen, bestDist = 0, 0

        for dist = 1, math.min(i - 1, 65535) do
            local matchStart, len = i - dist, 0

            while i + len <= dataLen and data:sub(matchStart + len, matchStart + len) == data:sub(i + len, i + len) do
                len += 1
                if len == 65535 then break end
            end

            if len > bestLen then bestLen, bestDist = len, dist end
        end

        if bestLen >= 4 then
            table.insert(out, string.char(0) .. string.pack(">I2I2", bestDist - 1, bestLen - 4))
            i += bestLen
        else
            local litStart = i

            while i <= dataLen and (i - litStart < 15 or i == dataLen) do i += 1 end
            table.insert(out, string.char(i - litStart) .. data:sub(litStart, i - 1))
        end
    end

    return table.concat(out)
end)

getgenv().lz4decompress = newcclosure(function(data, size)
    local out, i, dataLen = {}, 1, #data

    while i <= dataLen and #table.concat(out) < size do
        local token = data:byte(i)
        i = i + 1

        if token == 0 then
            local dist, len = string.unpack(">I2I2", data:sub(i, i + 3))

            i = i + 4
            dist = dist + 1
            len = len + 4

            local start = #table.concat(out) - dist + 1
            local match = table.concat(out):sub(start, start + len - 1)

            while #match < len do
                match = match .. match
            end

            table.insert(out, match:sub(1, len))
        else
            table.insert(out, data:sub(i, i + token - 1))
            i = i + token
        end
    end

    return table.concat(out):sub(1, size)
end)

getgenv().getloadedmodules = newcclosure(function()
    local LoadedModules = {}
	for _, v in pairs(getinstances()) do
		if v:IsA("ModuleScript") then 
			table.insert(LoadedModules, v)
		end
	end
	return LoadedModules
end)

getgenv().getrunningscripts = newcclosure(function()
    local RunningScripts = {}
	for _, v in pairs(getinstances()) do
		if v:IsA("LocalScript") and v.Enabled then table.insert(RunningScripts, v) end
	end
	return RunningScripts
end)

getgenv().getscripts = getrunningscripts

getgenv().getscripthash = newcclosure(function(instance)
    assert(typeof(instance) == "Instance", "invalid argument #1 to 'getscripthash' (Instance expected, got " .. typeof(instance) .. ") ", 2)
	assert(instance:IsA("LuaSourceContainer"), "invalid argument #1 to 'getscripthash' (LuaSourceContainer expected, got " .. instance.ClassName .. ") ", 2)
	return instance:GetHash()
end)

getgenv().getsenv = newcclosure(function(script)
    assert(typeof(script) == "Instance", "invalid argument #1 to 'getsenv' [ModuleScript or LocalScript expected]", 2);
	assert((script:IsA("LocalScript") or script:IsA("ModuleScript")), "invalid argument #1 to 'getsenv' [ModuleScript or LocalScript expected]", 2)
	if (script:IsA("LocalScript") == true) then 
		for _, v in getreg() do
			if (type(v) == "function") then
				if getfenv(v).script then
					if getfenv(v).script == script then
						return getfenv(v)
					end
				end
			end
		end
	else
		local Reg = getreg()
		local Senv = {}

		if #Reg == 0 then
			return require(script)
		end

		for _, v in next, Reg do
			if type(v) == "function" and islclosure(v) then
				local Fenv = getfenv(v)
				local Raw = rawget(Fenv, "script")
				if Raw and Raw == script then
					for i, k in next, Fenv do
						if i ~= "script" then
							rawset(Senv, i, k)
						end
					end
				end
			end
		end
		return Senv
	end
end)

local _require = require
getgenv().require = newcclosure(function(TargetModule)
    if typeof(TargetModule) ~= "Instance" then error("Attempted to call require with invalid argument(s).") end
    if not TargetModule:IsA("ModuleScript") then error("Attempted to call require with invalid argument(s).") end
    local OriginalIdentity = getthreadidentity()
    setthreadidentity(2)

	Require_Handler(TargetModule)

    local Success, Result = pcall(_require, TargetModule)
    setthreadidentity(OriginalIdentity)
    if not Success then error(Result) end
    return result
end)

local coreGui = game:GetService("CoreGui")
local camera = game.Workspace.CurrentCamera
local drawingUI = Instance.new("ScreenGui")
drawingUI.Name = "rrawrewtrtjwhr"
drawingUI.IgnoreGuiInset = true
drawingUI.DisplayOrder = 0x7fffffff
drawingUI.Parent = coreGui
local drawingIndex = 0
local uiStrokes = table.create(0)
local baseDrawingObj = setmetatable({
	Visible = true,
	ZIndex = 0,
	Transparency = 1,
	Color = Color3.new(),
	Remove = function(self)
		setmetatable(self, nil)
	end
}, {
	__add = function(t1, t2)
		local result = table.clone(t1)

		for index, value in t2 do
			result[index] = value
		end
		return result
	end
})
local drawingFontsEnum = {
	[0] = Font.fromEnum(Enum.Font.Roboto),
	[1] = Font.fromEnum(Enum.Font.Legacy),
	[2] = Font.fromEnum(Enum.Font.SourceSans),
	[3] = Font.fromEnum(Enum.Font.RobotoMono),
}
-- function
local function getFontFromIndex(fontIndex: number): Font
	return drawingFontsEnum[fontIndex]
end

local function convertTransparency(transparency: number): number
	return math.clamp(1 - transparency, 0, 1)
end



-- main
local DrawingLib = {}
DrawingLib.Fonts = {
	["UI"] = 0,
	["System"] = 1,
	["Plex"] = 2,
	["Monospace"] = 3
}
local drawings = {}
function DrawingLib.new(drawingType)
	drawingIndex += 1
	if drawingType == "Line" then
		local lineObj = ({
			From = Vector2.zero,
			To = Vector2.zero,
			Thickness = 1
		} + baseDrawingObj)

		local lineFrame = Instance.new("Frame")
		lineFrame.Name = drawingIndex
		lineFrame.AnchorPoint = (Vector2.one * .5)
		lineFrame.BorderSizePixel = 0

		lineFrame.BackgroundColor3 = lineObj.Color
		lineFrame.Visible = lineObj.Visible
		lineFrame.ZIndex = lineObj.ZIndex
		lineFrame.BackgroundTransparency = convertTransparency(lineObj.Transparency)

		lineFrame.Size = UDim2.new()

		lineFrame.Parent = drawingUI
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(lineObj[index]) == "nil" then return end

				if index == "From" then
					local direction = (lineObj.To - value)
					local center = (lineObj.To + value) / 2
					local distance = direction.Magnitude
					local theta = math.deg(math.atan2(direction.Y, direction.X))

					lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
					lineFrame.Rotation = theta
					lineFrame.Size = UDim2.fromOffset(distance, lineObj.Thickness)
				elseif index == "To" then
					local direction = (value - lineObj.From)
					local center = (value + lineObj.From) / 2
					local distance = direction.Magnitude
					local theta = math.deg(math.atan2(direction.Y, direction.X))

					lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
					lineFrame.Rotation = theta
					lineFrame.Size = UDim2.fromOffset(distance, lineObj.Thickness)
				elseif index == "Thickness" then
					local distance = (lineObj.To - lineObj.From).Magnitude

					lineFrame.Size = UDim2.fromOffset(distance, value)
				elseif index == "Visible" then
					lineFrame.Visible = value
				elseif index == "ZIndex" then
					lineFrame.ZIndex = value
				elseif index == "Transparency" then
					lineFrame.BackgroundTransparency = convertTransparency(value)
				elseif index == "Color" then
					lineFrame.BackgroundColor3 = value
				end
				lineObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						lineFrame:Destroy()
						lineObj.Remove(self)
						return lineObj:Remove()
					end
				end
				return lineObj[index]
			end
		})
	elseif drawingType == "Text" then
		local textObj = ({
			Text = "",
			Font = DrawingLib.Fonts.UI,
			Size = 0,
			Position = Vector2.zero,
			Center = false,
			Outline = false,
			OutlineColor = Color3.new()
		} + baseDrawingObj)

		local textLabel, uiStroke = Instance.new("TextLabel"), Instance.new("UIStroke")
		textLabel.Name = drawingIndex
		textLabel.AnchorPoint = (Vector2.one * .5)
		textLabel.BorderSizePixel = 0
		textLabel.BackgroundTransparency = 1

		textLabel.Visible = textObj.Visible
		textLabel.TextColor3 = textObj.Color
		textLabel.TextTransparency = convertTransparency(textObj.Transparency)
		textLabel.ZIndex = textObj.ZIndex

		textLabel.FontFace = getFontFromIndex(textObj.Font)
		textLabel.TextSize = textObj.Size

		textLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
			local textBounds = textLabel.TextBounds
			local offset = textBounds / 2

			textLabel.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
			textLabel.Position = UDim2.fromOffset(textObj.Position.X + (if not textObj.Center then offset.X else 0), textObj.Position.Y + offset.Y)
		end)

		uiStroke.Thickness = 1
		uiStroke.Enabled = textObj.Outline
		uiStroke.Color = textObj.Color

		textLabel.Parent, uiStroke.Parent = drawingUI, textLabel
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(textObj[index]) == "nil" then return end

				if index == "Text" then
					textLabel.Text = value
				elseif index == "Font" then
					value = math.clamp(value, 0, 3)
					textLabel.FontFace = getFontFromIndex(value)
				elseif index == "Size" then
					textLabel.TextSize = value
				elseif index == "Position" then
					local offset = textLabel.TextBounds / 2

					textLabel.Position = UDim2.fromOffset(value.X + (if not textObj.Center then offset.X else 0), value.Y + offset.Y)
				elseif index == "Center" then
					local position = (
						if value then
							camera.ViewportSize / 2
							else
							textObj.Position
					)

					textLabel.Position = UDim2.fromOffset(position.X, position.Y)
				elseif index == "Outline" then
					uiStroke.Enabled = value
				elseif index == "OutlineColor" then
					uiStroke.Color = value
				elseif index == "Visible" then
					textLabel.Visible = value
				elseif index == "ZIndex" then
					textLabel.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)

					textLabel.TextTransparency = transparency
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					textLabel.TextColor3 = value
				end
				textObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						textLabel:Destroy()
						textObj.Remove(self)
						return textObj:Remove()
					end
				elseif index == "TextBounds" then
					return textLabel.TextBounds
				end
				return textObj[index]
			end
		})
	elseif drawingType == "Circle" then
		local circleObj = ({
			Radius = 150,
			Position = Vector2.zero,
			Thickness = .7,
			Filled = false
		} + baseDrawingObj)

		local circleFrame, uiCorner, uiStroke = Instance.new("Frame"), Instance.new("UICorner"), Instance.new("UIStroke")
		circleFrame.Name = drawingIndex
		circleFrame.AnchorPoint = (Vector2.one * .5)
		circleFrame.BorderSizePixel = 0

		circleFrame.BackgroundTransparency = (if circleObj.Filled then convertTransparency(circleObj.Transparency) else 1)
		circleFrame.BackgroundColor3 = circleObj.Color
		circleFrame.Visible = circleObj.Visible
		circleFrame.ZIndex = circleObj.ZIndex

		uiCorner.CornerRadius = UDim.new(1, 0)
		circleFrame.Size = UDim2.fromOffset(circleObj.Radius, circleObj.Radius)

		uiStroke.Thickness = circleObj.Thickness
		uiStroke.Enabled = not circleObj.Filled
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

		circleFrame.Parent, uiCorner.Parent, uiStroke.Parent = drawingUI, circleFrame, circleFrame
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(circleObj[index]) == "nil" then return end

				if index == "Radius" then
					local radius = value * 2
					circleFrame.Size = UDim2.fromOffset(radius, radius)
				elseif index == "Position" then
					circleFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Thickness" then
					value = math.clamp(value, .6, 0x7fffffff)
					uiStroke.Thickness = value
				elseif index == "Filled" then
					circleFrame.BackgroundTransparency = (if value then convertTransparency(circleObj.Transparency) else 1)
					uiStroke.Enabled = not value
				elseif index == "Visible" then
					circleFrame.Visible = value
				elseif index == "ZIndex" then
					circleFrame.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)

					circleFrame.BackgroundTransparency = (if circleObj.Filled then transparency else 1)
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					circleFrame.BackgroundColor3 = value
					uiStroke.Color = value
				end
				circleObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						circleFrame:Destroy()
						circleObj.Remove(self)
						return circleObj:Remove()
					end
				end
				return circleObj[index]
			end
		})
	elseif drawingType == "Square" then
		local squareObj = ({
			Size = Vector2.zero,
			Position = Vector2.zero,
			Thickness = .7,
			Filled = false
		} + baseDrawingObj)

		local squareFrame, uiStroke = Instance.new("Frame"), Instance.new("UIStroke")
		squareFrame.Name = drawingIndex
		squareFrame.BorderSizePixel = 0

		squareFrame.BackgroundTransparency = (if squareObj.Filled then convertTransparency(squareObj.Transparency) else 1)
		squareFrame.ZIndex = squareObj.ZIndex
		squareFrame.BackgroundColor3 = squareObj.Color
		squareFrame.Visible = squareObj.Visible

		uiStroke.Thickness = squareObj.Thickness
		uiStroke.Enabled = not squareObj.Filled
		uiStroke.LineJoinMode = Enum.LineJoinMode.Miter

		squareFrame.Parent, uiStroke.Parent = drawingUI, squareFrame
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(squareObj[index]) == "nil" then return end

				if index == "Size" then
					squareFrame.Size = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Position" then
					squareFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Thickness" then
					value = math.clamp(value, 0.6, 0x7fffffff)
					uiStroke.Thickness = value
				elseif index == "Filled" then
					squareFrame.BackgroundTransparency = (if value then convertTransparency(squareObj.Transparency) else 1)
					uiStroke.Enabled = not value
				elseif index == "Visible" then
					squareFrame.Visible = value
				elseif index == "ZIndex" then
					squareFrame.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)

					squareFrame.BackgroundTransparency = (if squareObj.Filled then transparency else 1)
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					uiStroke.Color = value
					squareFrame.BackgroundColor3 = value
				end
				squareObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						squareFrame:Destroy()
						squareObj.Remove(self)
						return squareObj:Remove()
					end
				end
				return squareObj[index]
			end
		})
	elseif drawingType == "Image" then
		local imageObj = ({
			Data = "",
			DataURL = "rbxassetid://0",
			Size = Vector2.zero,
			Position = Vector2.zero
		} + baseDrawingObj)

		local imageFrame = Instance.new("ImageLabel")
		imageFrame.Name = drawingIndex
		imageFrame.BorderSizePixel = 0
		imageFrame.ScaleType = Enum.ScaleType.Stretch
		imageFrame.BackgroundTransparency = 1

		imageFrame.Visible = imageObj.Visible
		imageFrame.ZIndex = imageObj.ZIndex
		imageFrame.ImageTransparency = convertTransparency(imageObj.Transparency)
		imageFrame.ImageColor3 = imageObj.Color

		imageFrame.Parent = drawingUI
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(imageObj[index]) == "nil" then return end

				if index == "Data" then
					-- later
				elseif index == "DataURL" then -- temporary property
					imageFrame.Image = value
				elseif index == "Size" then
					imageFrame.Size = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Position" then
					imageFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Visible" then
					imageFrame.Visible = value
				elseif index == "ZIndex" then
					imageFrame.ZIndex = value
				elseif index == "Transparency" then
					imageFrame.ImageTransparency = convertTransparency(value)
				elseif index == "Color" then
					imageFrame.ImageColor3 = value
				end
				imageObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						imageFrame:Destroy()
						imageObj.Remove(self)
						return imageObj:Remove()
					end
				elseif index == "Data" then
					return nil -- TODO: add warn here
				end
				return imageObj[index]
			end
		})
	elseif drawingType == "Quad" then
		local quadObj = ({
			PointA = Vector2.zero,
			PointB = Vector2.zero,
			PointC = Vector2.zero,
			PointD = Vector3.zero,
			Thickness = 1,
			Filled = false
		} + baseDrawingObj)

		local _linePoints = table.create(0)
		_linePoints.A = DrawingLib.new("Line")
		_linePoints.B = DrawingLib.new("Line")
		_linePoints.C = DrawingLib.new("Line")
		_linePoints.D = DrawingLib.new("Line")
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(quadObj[index]) == "nil" then return end

				if index == "PointA" then
					_linePoints.A.From = value
					_linePoints.B.To = value
				elseif index == "PointB" then
					_linePoints.B.From = value
					_linePoints.C.To = value
				elseif index == "PointC" then
					_linePoints.C.From = value
					_linePoints.D.To = value
				elseif index == "PointD" then
					_linePoints.D.From = value
					_linePoints.A.To = value
				elseif (index == "Thickness" or index == "Visible" or index == "Color" or index == "ZIndex") then
					for _, linePoint in _linePoints do
						linePoint[index] = value
					end
				elseif index == "Filled" then
					-- later
				end
				quadObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" then
					return function()
						for _, linePoint in _linePoints do
							linePoint:Remove()
						end

						quadObj.Remove(self)
						return quadObj:Remove()
					end
				end
				if index == "Destroy" then
					return function()
						for _, linePoint in _linePoints do
							linePoint:Remove()
						end

						quadObj.Remove(self)
						return quadObj:Remove()
					end
				end
				return quadObj[index]
			end
		})
	elseif drawingType == "Triangle" then
		local triangleObj = ({
			PointA = Vector2.zero,
			PointB = Vector2.zero,
			PointC = Vector2.zero,
			Thickness = 1,
			Filled = false
		} + baseDrawingObj)

		local _linePoints = table.create(0)
		_linePoints.A = DrawingLib.new("Line")
		_linePoints.B = DrawingLib.new("Line")
		_linePoints.C = DrawingLib.new("Line")
		local bs = table.create(0)
		table.insert(drawings,bs)
		return setmetatable(bs, {
			__newindex = function(_, index, value)
				if typeof(triangleObj[index]) == "nil" then return end

				if index == "PointA" then
					_linePoints.A.From = value
					_linePoints.B.To = value
				elseif index == "PointB" then
					_linePoints.B.From = value
					_linePoints.C.To = value
				elseif index == "PointC" then
					_linePoints.C.From = value
					_linePoints.A.To = value
				elseif (index == "Thickness" or index == "Visible" or index == "Color" or index == "ZIndex") then
					for _, linePoint in _linePoints do
						linePoint[index] = value
					end
				elseif index == "Filled" then
					-- later
				end
				triangleObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" then
					return function()
						for _, linePoint in _linePoints do
							linePoint:Remove()
						end

						triangleObj.Remove(self)
						return triangleObj:Remove()
					end
				end
				if index == "Destroy" then
					return function()
						for _, linePoint in _linePoints do
							linePoint:Remove()
						end

						triangleObj.Remove(self)
						return triangleObj:Remove()
					end
				end
				return triangleObj[index]
			end
		})
	end
end
getgenv().Drawing = DrawingLib

getgenv().isrenderobj = newcclosure(function(...)
    if table.find(drawings,...) then
        return true
    else
        return false
    end
end)

getgenv().getrenderproperty = newcclosure(function(a,b)
    return a[b]
end)

getgenv().setrenderproperty = newcclosure(function(a,b,c)
    a[b] = c
end)

getgenv().cleardrawcache = newcclosure(function()
    return true
end)

getgenv().GetObjects = newcclosure(function(asset)
    return { game:GetService("InsertService"):LoadLocalAsset(asset) }
end)

local VirtualInputManager = game:GetService("VirtualInputManager")

getgenv().mouse1click = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

getgenv().mouse1press = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
end)

getgenv().mouse1release = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end)

getgenv().mouse2click = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 1)
end)

getgenv().mouse2press = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 1)
end)

getgenv().mouse2release = newcclosure(function()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 1)
end)

getgenv().mousemoveabs = newcclosure(function(x, y)
    VirtualInputManager:SendMouseMoveEvent(x, y, game)
end)

getgenv().mousemoverel = newcclosure(function(x, y)
    local MouseLocation = UserInputService:GetMouseLocation()
    VirtualInputManager:SendMouseMoveEvent(MouseLocation.X + x, MouseLocation.Y + y, game)
end)

getgenv().mousescroll = newcclosure(function(Pixels)
    VirtualInputManager:SendMouseWheelEvent(0, 0, Pixels > 0, game)
end)

getgenv().fireclickdetector = newcclosure(function(Target)
	assert(typeof(Target) == "Instance", "invalid argument #1 to 'fireclickdetector' (Instance expected, got " .. type(Target) .. ") ", 2)
	local ClickDetector = Target:FindFirstChild("ClickDetector") or Target
	local PreviousParent = ClickDetector.Parent

	local NewPart = Instance.new("Part", workspace)
	do
		NewPart.Transparency = 1
		NewPart.Size = Vector3.new(30, 30, 30)
		NewPart.Anchored = true
		NewPart.CanCollide = false
		task.delay(15, function()
			if NewPart:IsDescendantOf(game) then
				NewPart:Destroy()
			end
		end)
		ClickDetector.Parent = NewPart
		ClickDetector.MaxActivationDistance = math.huge
	end

	local VirtualUser = game:FindService("VirtualUser") or game:GetService("VirtualUser")

	local HeartbeatConnection = RunService.Heartbeat:Connect(function()
		local CurrentCamera = workspace.CurrentCamera or workspace.Camera
		NewPart.CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, -20) * CFrame.new(CurrentCamera.CFrame.LookVector.X, CurrentCamera.CFrame.LookVector.Y, CurrentCamera.CFrame.LookVector.Z)
		VirtualUser:ClickButton1(Vector2.new(20, 20), CurrentCamera.CFrame)
	end)

	ClickDetector.MouseClick:Once(function()
		HeartbeatConnection:Disconnect()
		ClickDetector.Parent = PreviousParent
		NewPart:Destroy()
	end)
end)--!native
--!optimize 2

if not game:IsLoaded() then game.Loaded:Wait() end

local BlacklistedFunctions = {
	"OpenVideosFolder",
	"OpenScreenshotsFolder",
	"GetRobuxBalance",
	"PerformPurchase",
	"PromptBundlePurchase",
	"PromptNativePurchase",
	"PromptProductPurchase",
	"PromptPurchase",
    "PromptGamePassPurchase",
    "PromptRobloxPurchase",
	"PromptThirdPartyPurchase",
	"Publish",
	"GetMessageId",
	"OpenBrowserWindow",
    "OpenNativeOverlay",
	"RequestInternal",
	"ExecuteJavaScript",
    "EmitHybridEvent",
    "AddCoreScriptLocal",
    "HttpRequestAsync",
    "ReportAbuse",
    "SaveScriptProfilingData",
    "OpenUrl",
    "DeleteCapture",
    "DeleteCapturesAsync"
}

local BlacklistedServices = {
    "BrowserService",
    "HttpRbxApiService",
    "OpenCloudService",
    "MessageBusService",
    "OmniRecommendationsService",
    "LinkingService",
    "CaptureService",
    "CorePackages"
}

local _string_match = clonefunction(string.match)
local _string_lower = clonefunction(string.lower)
local _httpget = clonefunction(HttpGet)
local _request = clonefunction(request)

local Metatable = getrawmetatable(game)

local OldMetatable = Metatable.__namecall

setreadonly(Metatable, false)
Metatable.__namecall = function(Self, ...)
	local Method = getnamecallmethod()

	for _, v in pairs(BlacklistedFunctions) do
		if _string_match(_string_lower(Method), _string_lower(v)) then
			return error("This function has been disabled for security reasons.")
		end
	end

	if _string_match(_string_lower(Method), _string_lower("GetService")) or _string_match(_string_lower(Method), _string_lower("FindService")) then
		for _, v in pairs(BlacklistedServices) do
			if _string_match(_string_lower(select(1, ...)), _string_lower(v)) then
				return error("This service has been removed for safety reasons.")
			end
		end
	end

	if Method == "HttpGet" or Method == "HttpGetAsync" then
			return HttpGet(...)
	elseif Method == "GetObjects" then 
			return GetObjects(...)
	end

	return OldMetatable(Self, ...)
end

local OldIndex = Metatable.__index

setreadonly(Metatable, false)
Metatable.__index = function(Self, i)
	for _, v in pairs(BlacklistedFunctions) do
		if _string_match(i, v) then
			return error("This function has been disabled for security reasons.")
		end
	end

    if _string_match(_string_lower(i), _string_lower("GetService")) or _string_match(_string_lower(i), _string_lower("FindService")) then
        return newcclosure(function(a, b)
                return a:GetService(b)
        end)
    end

	if Self == game then
		if i == "HttpGet" or i == "HttpGetAsync" then 
			return HttpGet
		elseif i == "GetObjects" then 
			return GetObjects
		end
	end
	return OldIndex(Self, i)
end --!native
--!optimize 2

if not game:IsLoaded() then game.Loaded:Wait() end

-- Some games like Arsenal watch for errors as a detection mechanism.
local ErrorWatchGames = {
	286090429, -- Arsenal
}

for _, v in pairs(ErrorWatchGames) do
	if game.PlaceId == v then
		getgenv().error = newcclosure(function(...)
			return warn(...)
		end)
	end
end

-- TODO: Override print, warn and error functions to write to DevConsole manually to bypass LogService.MessageOut event connection.
