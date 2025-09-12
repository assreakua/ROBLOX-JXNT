local ImageConverter = {}

function ImageConverter:rgb2lab(color)
    local r = color[1] / 255
    local g = color[2] / 255
    local b = color[3] / 255
    if r > 0.04045 then r = ((r + 0.055) / 1.055) ^ 2.4 else r = r / 12.92 end
    if g > 0.04045 then g = ((g + 0.055) / 1.055) ^ 2.4 else g = g / 12.92 end
    if b > 0.04045 then b = ((b + 0.055) / 1.055) ^ 2.4 else b = b / 12.92 end
    local x = r * 0.4124 + g * 0.3576 + b * 0.1805
    local y = r * 0.2126 + g * 0.7152 + b * 0.0722
    local z = r * 0.0193 + g * 0.1192 + b * 0.9505
    local x_ref = 0.9642
    local y_ref = 1.0000
    local z_ref = 0.8249
    local x_ratio = x / x_ref
    local y_ratio = y / y_ref
    local z_ratio = z / z_ref
    if x_ratio > 0.008856 then x_ratio = x_ratio ^ (1/3) else x_ratio = (7.787 * x_ratio) + (16/116) end
    if y_ratio > 0.008856 then y_ratio = y_ratio ^ (1/3) else y_ratio = (7.787 * y_ratio) + (16/116) end
    if z_ratio > 0.008856 then z_ratio = z_ratio ^ (1/3) else z_ratio = (7.787 * z_ratio) + (16/116) end
    local l = (116 * y_ratio) - 16
    local a = 500 * (x_ratio - y_ratio)
    local b = 200 * (y_ratio - z_ratio)
    return {l, a, b}
end
  
function ImageConverter:colorDiff(color1, color2)
    local lab1 = ImageConverter:rgb2lab(color1)
    local lab2 = ImageConverter:rgb2lab(color2)
    local delta_l = lab2[1] - lab1[1]
    local c1 = math.sqrt(lab1[2] * lab1[2] + lab1[3] * lab1[3])
    local c2 = math.sqrt(lab2[2] * lab2[2] + lab2[3] * lab2[3])
    local c_mean = (c1 + c2) / 2
    local g = 0.5 * (1 - math.sqrt(c_mean ^ 7 / (c_mean ^ 7 + 25 ^ 7)))
    local a1 = (1 + g) * lab1[2]
    local a2 = (1 + g) * lab2[2]
    local c1_ = math.sqrt(a1 * a1 + lab1[3] * lab1[3])
    local c2_ = math.sqrt(a2 * a2 + lab2[3] * lab2[3])
    local h1_ = math.atan2(lab1[3], a1) * 180 / math.pi
    local h2_ = math.atan2(lab2[3], a2) * 180 / math.pi
    if h1_ < 0 then h1_ = h1_ + 360 end
    if h2_ < 0 then h2_ = h2_ + 360 end
    local delta_l_ = lab2[1] - lab1[1]
    local delta_c_ = c2_ - c1_
    local delta_h_ = 0
    if c1_ * c2_ ~= 0 then
        if math.abs(h2_ - h1_) <= 180 then
            delta_h_ = h2_ - h1_
        elseif h2_ - h1_ > 180 then
            delta_h_ = h2_ - h1_ - 360
        else
            delta_h_ = h2_ - h1_ + 360
        end
    end
    local delta_h_prime = 2 * math.sqrt(c1_ * c2_) * math.sin(delta_h_ / 2 * math.pi / 180)
    local h_mean_prime = 0
    if c1_ * c2_ ~= 0 then
        if math.abs(h2_ - h1_) <= 180 then
            h_mean_prime = (h1_ + h2_) / 2
        elseif h1_ + h2_ < 360 then
            h_mean_prime = (h1_ + h2_ + 360) / 2
        else
            h_mean_prime = (h1_ + h2_ - 360) / 2
        end
    end
    local t = 1 - 0.17 * math.cos((h_mean_prime - 30) * math.pi / 180) + 0.24 * math.cos((2 * h_mean_prime) * math.pi / 180) + 0.32 * math.cos((3 * h_mean_prime + 6) * math.pi / 180)
    local s_l = 1 + (0.015 * (lab1[1] - 50) ^ 2) / math.sqrt(20 + (lab1[1] - 50) ^ 2)
    local s_c = 1 + 0.045 * c_mean
    local s_h = 1 + 0.015 * c_mean * t
    local r_t = -2 * math.sqrt(c_mean ^ 7 / (c_mean ^ 7 + 25 ^ 7)) * math.sin(60 * math.exp(-((h_mean_prime - 275) / 25) ^ 2) * math.pi / 180)
    local delta_e = math.sqrt((delta_l_ / s_l) ^ 2 + (delta_c_ / s_c) ^ 2 + (delta_h_prime / s_h) ^ 2 + r_t * (delta_c_ / s_c) * (delta_h_prime / s_h))
    return delta_e
end

function ImageConverter:ImageResize(Image, Size)
    local Size = Vector2.new(Image.size.X/Size,Image.size.Y/Size)
    local NewImage = {}
    local Checking = Vector2.new(Image.size.X/Size.X, Image.size.Y/Size.Y)
    local Skip = 0
    for x = 1,Size.X do
        for y = 1,Size.Y do
            local Pixel = Image.image[tostring(Vector2.new(math.floor(x*Checking.X+0.5),math.floor(y*Checking.Y+0.5)))]
            Pixel.x = x
            Pixel.y = y
            NewImage[#NewImage+1] = Pixel
        end
        task.wait()
    end
    return NewImage
end

function ImageConverter:GetNearestColor(Color)
    local Minimum = math.huge
    local LastColor = ""
    local TestVariable = false
    local NewColor = nil
    local NewName = nil
    for i,v in next, getgenv().Colors2 do
        if v[1] == Color[1] and v[2] == Color[2] and v[3] == Color[3] then
            NewColor = {getgenv().Colors[i][1], getgenv().Colors[i][2], getgenv().Colors[i][3]}
            NewName = i
            break
        end
    end
    if not NewColor then
        for i,v in next, getgenv().Colors do
            local Distance = ImageConverter:colorDiff(v, Color)
            if Distance < Minimum then
                LastColor = i
                Minimum = Distance
            end
        end
        getgenv().Colors2[LastColor] = Color
        return LastColor
    elseif NewColor then
        return NewName
    end
end

function ImageConverter:ImageConvert(PNGImage)
    PNGImage = game:HttpGet(PNGImage)
	local PNG = {}
	local Bytes = {}
	PNG.__index = PNG

	local ImageChunks = {}
	local function IDAT(File, Chunk)
		local CRC = Chunk.CRC
		local Hash = File.Hash or 0
		local Buffer = Chunk.Data.Buffer
		File.Hash = bit32.bxor(Hash, CRC)
		File.ZlibStream = File.ZlibStream..Buffer
	end
	ImageChunks["IDAT"] = IDAT

	local function IEND(File)
		File.Reading = nil
	end
	ImageChunks["IEND"] = IEND

	local function IHDR(File, Chunk)
		local Data = Chunk.Data
		File.Width = Data:ReadInt32()
		File.Height = Data:ReadInt32()
		File.BitDepth = Data:ReadByte()
		File.ColorType = Data:ReadByte()
		File.Methods = {Compression = Data:ReadByte(), Filtering = Data:ReadByte(), Interlace = Data:ReadByte()}
	end
	ImageChunks["IHDR"] = IHDR

	local function PLTE(File, Chunk)
		if not File.Palette then
			File.Palette = {}
		end

		local Palette = Chunk.Data:ReadAllBytes()
		if #Palette % 3 ~= 0 then
			return print("PLTE Chunk - nil")
		end

		for i = 1, #Palette, 3 do
			local R = Palette[i]
			local G = Palette[i + 1]
			local B = Palette[i + 2]
			File.Palette[#File.Palette + 1] = Color3.fromRGB(R, G, B)
		end
	end
	ImageChunks["PLTE"] = PLTE

	local function bKGD(File, Chunk)
		local Data = Chunk.Data
		local Depth = File.BitDepth
		local Type = File.ColorType
		Depth = (2 ^ Depth) - 1
		if Type == 3 then
			File.BackgroundColor = File.Palette[Data:ReadByte()]
		elseif Type == 0 or Type == 4 then
			File.BackgroundColor = Color3.fromHSV(0, 0, Data:ReadUInt16() / Depth)
		elseif Type == 2 or Type == 6 then
			local R = Data:ReadUInt16() / Depth
			local G = Data:ReadUInt16() / Depth
			local B = Data:ReadUInt16() / Depth
			File.BackgroundColor = Color3.new(R, G, B)
		end
	end
	ImageChunks["bKGD"] = bKGD

	local Colors = {"White", "Red", "Green", "Blue"}
	local function cHRM(File, Chunk)
		local Chrome = {}
		local Data = Chunk.Data
		for i = 1, 4 do
			Chrome[Colors[i]] = {Data:ReadUInt32() / 10e4, Data:ReadUInt32() / 10e4}
		end
		File.Chromaticity = Chrome
	end
	ImageChunks["cHRM"] = cHRM

	local function gAMA(File, Chunk)
		File.Gamma = Chunk.Data:ReadUInt32() / 10e4
	end
	ImageChunks["gAMA"] = gAMA

	local function sRGB(File, Chunk)
		File.RenderIntent = Chunk.Data:ReadByte()
	end
	ImageChunks["sRGB"] = sRGB

	local function tEXt(File, Chunk)
		local Key = ""
		local Value = ""
		for i in Chunk.Data:IterateBytes() do
			local StrChar = string.char(i)
			if StrChar == "\0" then
				Key = Value
				Value = ""
			else
				Value = Value..StrChar
			end
		end
		if File.Metadata[key] then
			File.Metadata[key] = Value			
		end
	end
	ImageChunks["tEXt"] = tEXt

	local function tIME(File, Chunk)
		local Data = Chunk.Data
		File.TimeStamp = {Year = Data:ReadUInt16(), Month = Data:ReadByte(), Day = Data:ReadByte(), Hour = Data:ReadByte(), Minute = Data:ReadByte(), Second = Data:ReadByte()}
	end
	ImageChunks["tIME"] = tIME

	local function tRNS(File, Chunk)
		local Data = Chunk.Data
		local Depth = File.BitDepth
		local Type = File.ColorType
		Depth = (2 ^ Depth) - 1
		if Type == 3 then
			local Map = {}
			for i = 1, #File.Palette do
				local A = Data:ReadByte()
				if not A then
					A = 255
				end
				Map[i] = A
			end
			File.AlphaData = Map
		elseif Type == 0 then
			File.Alpha = Data:ReadUInt16() / Depth
		elseif Type == 2 then
			local R = Data:ReadUInt16() / Depth
			local G = Data:ReadUInt16() / Depth
			local B = Data:ReadUInt16() / Depth
			File.Alpha = Color3.new(R, G, B)
		end	
	end
	ImageChunks["tRNS"] = tRNS

	local Deflate = {}
	local band = bit32.band
	local lshift = bit32.lshift
	local rshift = bit32.rshift
	local BTYPE_NO_COMPRESSION = 0
	local BTYPE_FIXED_HUFFMAN = 1
	local BTYPE_DYNAMIC_HUFFMAN = 2

	local lens =
		{
			[0] = 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
			35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258
		}

	local lext =
		{
			[0] = 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
			3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0
		}

	local dists =
		{
			[0] = 1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
			257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
			8193, 12289, 16385, 24577
		}

	local dext =
		{
			[0] = 0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
			7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
			12, 12, 13, 13
		}

	local order =
		{
			16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 
			11, 4, 12, 3, 13, 2, 14, 1, 15
		}

	local fixedLit = {0, 8, 144, 9, 256, 7, 280, 8, 288}

	local fixedDist = {0, 5, 32}

	local function createState(bitStream)
		local state = 
			{
				Output = bitStream;
				Window = {};
				Pos = 1;
			}

		return state
	end

	local function write(state, byte)
		local pos = state.Pos
		state.Output(byte)
		state.Window[pos] = byte
		state.Pos = pos % 32768 + 1
	end

	local function memoize(fn)
		local meta = {}
		local memoizer = setmetatable({}, meta)

		function meta:__index(k)
			local v = fn(k)
			memoizer[k] = v

			return v
		end

		return memoizer
	end

	local pow2 = memoize(function (n) 
		return 2 ^ n 
	end)

	local isBitStream = setmetatable({}, { __mode = "k" })

	local function createBitStream(reader)
		local buffer = 0
		local bitsLeft = 0

		local stream = {}
		isBitStream[stream] = true

		function stream:GetBitsLeft()
			return bitsLeft
		end

		function stream:Read(count)
			count = count or 1

			while bitsLeft < count do
				local byte = reader:ReadByte()

				if not byte then 
					return 
				end

				buffer = buffer + lshift(byte, bitsLeft)
				bitsLeft = bitsLeft + 8
			end

			local bits

			if count == 0 then
				bits = 0
			elseif count == 32 then
				bits = buffer
				buffer = 0
			else
				bits = band(buffer, rshift(2^32 - 1, 32 - count))
				buffer = rshift(buffer, count)
			end

			bitsLeft = bitsLeft - count
			return bits
		end

		return stream
	end

	local function getBitStream(obj)
		if isBitStream[obj] then
			return obj
		end

		return createBitStream(obj)
	end

	local function sortHuffman(a, b)
		return a.NumBits == b.NumBits and a.Value < b.Value or a.NumBits < b.NumBits
	end

	local function msb(bits, numBits)
		local res = 0

		for i = 1, numBits do
			res = lshift(res, 1) + band(bits, 1)
			bits = rshift(bits, 1)
		end

		return res
	end

	local function createHuffmanTable(init, isFull)
		local hTable = {}

		if isFull then
			for val, numBits in pairs(init) do
				if numBits ~= 0 then
					hTable[#hTable + 1] = 
						{
							Value = val;
							NumBits = numBits;
						}
				end
			end
		else
			for i = 1, #init - 2, 2 do
				local firstVal = init[i]

				local numBits = init[i + 1]
				local nextVal = init[i + 2]

				if numBits ~= 0 then
					for val = firstVal, nextVal - 1 do
						hTable[#hTable + 1] = 
							{
								Value = val;
								NumBits = numBits;
							}
					end
				end
			end
		end

		table.sort(hTable, sortHuffman)

		local code = 1
		local numBits = 0

		for i, slide in ipairs(hTable) do
			if slide.NumBits ~= numBits then
				code = code * pow2[slide.NumBits - numBits]
				numBits = slide.NumBits
			end

			slide.Code = code
			code = code + 1
		end

		local minBits = math.huge
		local look = {}

		for i, slide in ipairs(hTable) do
			minBits = math.min(minBits, slide.NumBits)
			look[slide.Code] = slide.Value
		end

		local firstCode = memoize(function (bits) 
			return pow2[minBits] + msb(bits, minBits) 
		end)

		function hTable:Read(bitStream)
			local code = 1
			local numBits = 0

			while true do
				if numBits == 0 then
					local index = bitStream:Read(minBits)
					numBits = numBits + minBits
					code = firstCode[index]
				else
					local bit = bitStream:Read()
					numBits = numBits + 1
					code = code * 2 + bit
				end

				local val = look[code]

				if val then
					return val
				end
			end
		end

		return hTable
	end

	local function parseZlibHeader(bitStream)
		local cm = bitStream:Read(4)

		local cinfo = bitStream:Read(4)  

		local fcheck = bitStream:Read(5)

		local fdict = bitStream:Read(1)

		local flevel = bitStream:Read(2)

		local cmf = cinfo * 16  + cm

		local flg = fcheck + fdict * 32 + flevel * 64 

		if cm ~= 8 then
			error("compression: "..cm)
			--error("unrecognized zlib compression method: " .. cm)
		end

		if cinfo > 7 then
			error("cinfo: "..cinfo)
			--error("invalid zlib window size: cinfo=" .. cinfo)
		end

		local windowSize = 2 ^ (cinfo + 8)

		if (cmf * 256 + flg) % 31 ~= 0 then
			error("fcheck")
			--error("invalid zlib header (bad fcheck sum)")
		end

		if fdict == 1 then
			error("not")
			--error("FIX:TODO - FDICT not currently implemented")
		end

		return windowSize
	end

	local function parseHuffmanTables(bitStream)
		local numLits  = bitStream:Read(5)
		local numDists = bitStream:Read(5)
		local numCodes = bitStream:Read(4)

		local codeLens = {}

		for i = 1, numCodes + 4 do
			local index = order[i]
			codeLens[index] = bitStream:Read(3)
		end

		codeLens = createHuffmanTable(codeLens, true)

		local function decode(numCodes)
			local init = {}
			local numBits
			local val = 0

			while val < numCodes do
				local codeLen = codeLens:Read(bitStream)
				local numRepeats

				if codeLen <= 15 then
					numRepeats = 1
					numBits = codeLen
				elseif codeLen == 16 then
					numRepeats = 3 + bitStream:Read(2)
				elseif codeLen == 17 then
					numRepeats = 3 + bitStream:Read(3)
					numBits = 0
				elseif codeLen == 18 then
					numRepeats = 11 + bitStream:Read(7)
					numBits = 0
				end

				for i = 1, numRepeats do
					init[val] = numBits
					val = val + 1
				end
			end

			return createHuffmanTable(init, true)
		end

		local numLitCodes = numLits + 257
		local numDistCodes = numDists + 1

		local litTable = decode(numLitCodes)
		local distTable = decode(numDistCodes)

		return litTable, distTable
	end

	local function parseCompressedItem(bitStream, state, litTable, distTable)
		local val = litTable:Read(bitStream)

		if val < 256 then
			write(state, val)
		elseif val == 256 then
			return true
		else
			local lenBase = lens[val - 257]
			local numExtraBits = lext[val - 257]

			local extraBits = bitStream:Read(numExtraBits)
			local len = lenBase + extraBits

			local distVal = distTable:Read(bitStream)
			local distBase = dists[distVal]

			local distNumExtraBits = dext[distVal]
			local distExtraBits = bitStream:Read(distNumExtraBits)

			local dist = distBase + distExtraBits

			for i = 1, len do
				local pos = (state.Pos - 1 - dist) % 32768 + 1
				local byte = assert(state.Window[pos], "far")
				write(state, byte)
			end
		end

		return false
	end

	local function parseBlock(bitStream, state)
		local bFinal = bitStream:Read(1)
		local bType = bitStream:Read(2)

		if bType == BTYPE_NO_COMPRESSION then
			local left = bitStream:GetBitsLeft()
			bitStream:Read(left)

			local len = bitStream:Read(16)
			local nlen = bitStream:Read(16)

			for i = 1, len do
				local byte = bitStream:Read(8)
				write(state, byte)
			end
		elseif bType == BTYPE_FIXED_HUFFMAN or bType == BTYPE_DYNAMIC_HUFFMAN then
			local litTable, distTable

			if bType == BTYPE_DYNAMIC_HUFFMAN then
				litTable, distTable = parseHuffmanTables(bitStream)
			else
				litTable = createHuffmanTable(fixedLit)
				distTable = createHuffmanTable(fixedDist)
			end

			repeat until parseCompressedItem(bitStream, state, litTable, distTable)
		else
		end

		return bFinal ~= 0
	end

	function Deflate:Inflate(io)
		local state = createState(io.Output)
		local bitStream = getBitStream(io.Input)

		repeat until parseBlock(bitStream, state)
	end

	function Deflate:InflateZlib(io)
		local bitStream = getBitStream(io.Input)
		local windowSize = parseZlibHeader(bitStream)

		self:Inflate
		{
			Input = bitStream;
			Output = io.Output;
		}

		local bitsLeft = bitStream:GetBitsLeft()
		bitStream:Read(bitsLeft)
	end

	local Unfilter = {}

	function Unfilter:None(scanline, pixels, bpp, row)
		for i = 1, #scanline do
			pixels[row][i] = scanline[i]
		end
	end

	function Unfilter:Sub(scanline, pixels, bpp, row)
		for i = 1, bpp do
			pixels[row][i] = scanline[i]
		end

		for i = bpp + 1, #scanline do
			local x = scanline[i]
			local a = pixels[row][i - bpp]
			pixels[row][i] = bit32.band(x + a, 0xFF)
		end
	end

	function Unfilter:Up(scanline, pixels, bpp, row)
		if row > 1 then
			local upperRow = pixels[row - 1]

			for i = 1, #scanline do
				local x = scanline[i]
				local b = upperRow[i]
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
		else
			self:None(scanline, pixels, bpp, row)
		end
	end

	function Unfilter:Average(scanline, pixels, bpp, row)
		if row > 1 then
			for i = 1, bpp do
				local x = scanline[i]
				local b = pixels[row - 1][i]

				b = bit32.rshift(b, 1)
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end

			for i = bpp + 1, #scanline do
				local x = scanline[i]
				local b = pixels[row - 1][i]

				local a = pixels[row][i - bpp]
				local ab = bit32.rshift(a + b, 1)

				pixels[row][i] = bit32.band(x + ab, 0xFF)
			end
		else
			for i = 1, bpp do
				pixels[row][i] = scanline[i]
			end

			for i = bpp + 1, #scanline do
				local x = scanline[i]
				local b = pixels[row - 1][i]

				b = bit32.rshift(b, 1)
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end
		end
	end

	function Unfilter:Paeth(scanline, pixels, bpp, row)
		if row > 1 then
			local pr

			for i = 1, bpp do
				local x = scanline[i]
				local b = pixels[row - 1][i]
				pixels[row][i] = bit32.band(x + b, 0xFF)
			end

			for i = bpp + 1, #scanline do
				local a = pixels[row][i - bpp]
				local b = pixels[row - 1][i]
				local c = pixels[row - 1][i - bpp]

				local x = scanline[i]
				local p = a + b - c

				local pa = math.abs(p - a)
				local pb = math.abs(p - b)
				local pc = math.abs(p - c)

				if pa <= pb and pa <= pc then
					pr = a
				elseif pb <= pc then
					pr = b
				else
					pr = c
				end

				pixels[row][i] = bit32.band(x + pr, 0xFF)
			end
		else
			self:Sub(scanline, pixels, bpp, row)
		end
	end


	local BinaryReader = {}
	BinaryReader.__index = BinaryReader

	function BinaryReader.new(buffer)
		local reader = 
			{
				Position = 1;
				Buffer = buffer;
				Length = #buffer;
			}

		return setmetatable(reader, BinaryReader)
	end

	function BinaryReader:ReadByte()
		local buffer = self.Buffer
		local pos = self.Position

		if pos <= self.Length then
			local result = buffer:sub(pos, pos)
			self.Position = pos + 1

			return result:byte()
		end
	end

	function BinaryReader:ReadBytes(count, asArray)
		local values = {}

		for i = 1, count do
			values[i] = self:ReadByte()
		end

		if asArray then
			return values
		end

		return unpack(values)
	end

	function BinaryReader:ReadAllBytes()
		return self:ReadBytes(self.Length, true)
	end

	function BinaryReader:IterateBytes()
		return function ()
			return self:ReadByte()
		end
	end

	function BinaryReader:TwosComplementOf(value, numBits)
		if value >= (2 ^ (numBits - 1)) then
			value = value - (2 ^ numBits)
		end

		return value
	end

	function BinaryReader:ReadUInt16()
		local upper, lower = self:ReadBytes(2)
		return (upper * 256) + lower
	end

	function BinaryReader:ReadInt16()
		local unsigned = self:ReadUInt16()
		return self:TwosComplementOf(unsigned, 16)
	end

	function BinaryReader:ReadUInt32()
		local upper = self:ReadUInt16()
		local lower = self:ReadUInt16()

		return (upper * 65536) + lower
	end

	function BinaryReader:ReadInt32()
		local unsigned = self:ReadUInt32()
		return self:TwosComplementOf(unsigned, 32)
	end

	function BinaryReader:ReadString(length)
		if length == nil then
			length = self:ReadByte()
		end

		local pos = self.Position
		local nextPos = math.min(self.Length, pos + length)

		local result = self.Buffer:sub(pos, nextPos - 1)
		self.Position = nextPos

		return result
	end

	function BinaryReader:ForkReader(length)
		local chunk = self:ReadString(length)
		return BinaryReader.new(chunk)
	end


	local function getBytesPerPixel(colorType)
		if colorType == 0 or colorType == 3 then
			return 1
		elseif colorType == 4 then
			return 2
		elseif colorType == 2 then
			return 3
		elseif colorType == 6 then
			return 4
		else
			return 0
		end
	end

	local function clampInt(value, min, max)
		local num = tonumber(value) or 0
		num = math.floor(num + .5)

		return math.clamp(num, min, max)
	end

	local function indexBitmap(file, x, y)
		local width = file.Width
		local height = file.Height

		local x = clampInt(x, 1, width) 
		local y = clampInt(y, 1, height)

		local bitmap = file.Bitmap
		local bpp = file.BytesPerPixel

		local i0 = ((x - 1) * bpp) + 1
		local i1 = i0 + bpp

		return bitmap[y], i0, i1
	end

	function PNG:GetPixel(t,x, y)
		local row, i0, i1 = indexBitmap(t, x, y)
		local colorType = t.ColorType
		self = t;

		local color, alpha do
			if colorType == 0 then
				local gray = unpack(row, i0, i1)
				color = Color3.fromHSV(0, 0, gray)
				alpha = 255
			elseif colorType == 2 then
				local r, g, b = unpack(row, i0, i1)
				color = Color3.fromRGB(r, g, b)
				alpha = 255
			elseif colorType == 3 then
				local palette = self.Palette
				local alphaData = self.AlphaData

				local index = unpack(row, i0, i1)
				if type(index) ~= "number" then
					return warn("Error, Invalid PNG")
				end
				index = index + 1

				if palette then
					color = palette[index]
				end

				if alphaData then
					alpha = alphaData[index]
				end
			elseif colorType == 4 then
				local gray, a = unpack(row, i0, i1)
				color = Color3.fromHSV(0, 0, gray)
				alpha = a
			elseif colorType == 6 then
				local r, g, b, a = unpack(row, i0, i1)
				color = Color3.fromRGB(r, g, b, a)
				alpha = a
			end
		end

		if not color then
			color = Color3.new()
		end

		if not alpha then
			alpha = 255
		end

		return color, alpha
	end

	function PNG.new(buffer)
		local reader = BinaryReader.new(buffer)

		local file =
			{
				Chunks = {};
				Metadata = {};

				Reading = true;
				ZlibStream = "";
			}

		local header = reader:ReadString(8)

		if header ~= "\137PNG\r\n\26\n" then
			local errored = "n/a"
		end

		while file.Reading do
			local length = reader:ReadInt32()
			local chunkType = reader:ReadString(4)

			local data, crc

			if length > 0 then
				data = reader:ForkReader(length)
				crc = reader:ReadUInt32()
			end

			local chunk = 
				{
					Length = length;
					Type = chunkType;

					Data = data;
					CRC = crc;
				}

			local handler = ImageChunks[chunkType];

			if handler then
				handler(file, chunk)
			end

			table.insert(file.Chunks, chunk)
		end

		local success, response = pcall(function ()
			local result = {}
			local index = 0

			Deflate:InflateZlib
			{
				Input = BinaryReader.new(file.ZlibStream);

				Output = function (byte)
					index = index + 1
					result[index] = string.char(byte)
				end
			}

			return table.concat(result)
		end)

		if not success then
			local errored = "not"
		end

		local width = file.Width
		local height = file.Height

		local bitDepth = file.BitDepth
		local colorType = file.ColorType

		local buffer = BinaryReader.new(response)
		file.ZlibStream = nil

		local bitmap = {}
		file.Bitmap = bitmap

		local channels = getBytesPerPixel(colorType)
		file.NumChannels = channels

		local bpp = math.max(1, channels * (bitDepth / 8))
		file.BytesPerPixel = bpp

		for row = 1, height do	
			local filterType = buffer:ReadByte()
			local scanline = buffer:ReadBytes(width * bpp, true)

			bitmap[row] = {}

			if filterType == 0 then
				Unfilter:None(scanline, bitmap, bpp, row)
			elseif filterType == 1 then
				Unfilter:Sub(scanline, bitmap, bpp, row)
			elseif filterType == 2 then
				Unfilter:Up(scanline, bitmap, bpp, row)
			elseif filterType == 3 then
				Unfilter:Average(scanline, bitmap, bpp, row)
			elseif filterType == 4 then
				Unfilter:Paeth(scanline, bitmap, bpp, row)
			end
		end
		return setmetatable(file, PNG)
	end

	local Skip = 0
	local Output = PNG.new(PNGImage)
	for Y = 1, Output.Height do
		for X = 1, Output.Width do
			if Skip >= 1000 then
				Skip = 0
				task.wait()
			end
			Skip = Skip + 1

			local Color, Alpha = PNG:GetPixel(Output, X, Y)
			Bytes[tostring(Vector2.new(X, Y))] = {x = X, y = Y, r = Color.R, g = Color.G, b = Color.B, a = Alpha * 0.00392156862}
		end
	end
	return {image = Bytes, size = Vector2.new(Output.Width, Output.Height)}
end

return ImageConverter