---------------------------------------------------------------------------------------------------------------------------------------
-- CFrameSerializer.lua
-- Written by CloneTrooper1019
---------------------------------------------------------------------------------------------------------------------------------------
-- Usage:
--         string CFrameSerializer:Encode(CFrame cf) <- Encodes a CFrame into a compressed string.
--         CFrame CFrameSerializer:Decode(string cf) <- Decodes a compressed string into a CFrame.
---------------------------------------------------------------------------------------------------------------------------------------
-- Description:
--
-- The goal of this library is to provide a light-weight compression scheme for CFrame data.
-- It isn't the most compression that can be done to a CFrame, but its very portable 
-- and will guarantee to encode CFrames with a length shorter than 'tostring(CFrame)'
--
-- There are a few key optimization techniques at play here:
--
--     • Truncated floating point numbers, with trailing zeros removed.
--     • Storing axis-aligned CFrame rotations with a single integer, which is 
--       the product of the NormalId values of a CFrame's UpVector and RightVector.
--     • Using quaternions instead of rotation matrices for non axis-aligned CFrames.  
-- 
-- This encoding works best when rotations are aligned in 90° increments, and positions are grid-aligned.
--
---------------------------------------------------------------------------------------------------------------------------------------
-- Utility Functions
---------------------------------------------------------------------------------------------------------------------------------------

local function fuzzyEquals(a, b)
	return math.abs(b - a) < 0.001
end

local function packNumber(num)
	local floor = math.floor(num)
	
	if fuzzyEquals(num, floor) then
		return tostring(floor)
	else
		local result = string.format("%.3f", num)
			:gsub("%.?0+$", "")
		
		return result
	end
end

local function packNumbers(...)
	local array = {...}
	
	for k,v in pairs(array) do
		array[k] = packNumber(v)
	end
	
	return table.concat(array, " ")
end

local function isAxisAligned(cf)
	local matrix = { cf:GetComponents() }
	local s0, s1 = 0, 0
	
	for i = 4, 12 do
		local t = matrix[i]
		local abs = math.abs(t)
		
		if fuzzyEquals(abs, 1) then
			s1 = s1 + 1
		elseif fuzzyEquals(abs, 0) then
			s0 = s0 + 1
		end
	end
	
	return (s0 == 6) and (s1 == 3)
end

local function toNormalId(vec)
	for _,normalId in pairs(Enum.NormalId:GetEnumItems()) do
		local normal = Vector3.FromNormalId(normalId)
		local dotProd = normal:Dot(vec)
		
		if fuzzyEquals(dotProd, 1) then
			return normalId.Value
		end
	end
	
	return -1
end

local function isLegalOrientId(orientId)
	local xNormalAbs = math.floor(orientId / 6) % 3;
	local yNormalAbs = orientId % 3;
	
	return (xNormalAbs ~= yNormalAbs);
end

local function getOrientId(cf)
	if not isAxisAligned(cf) then
		return -1
	end
	
	local xNormal = toNormalId(cf.RightVector)
	local yNormal = toNormalId(cf.UpVector)
	
	local orientId = (6 * xNormal) + yNormal
	
	if not isLegalOrientId(orientId) then
		return -1
	end
	
	return orientId
end

local function fromOrientId(pos, orientId)
	if not isLegalOrientId(orientId) then
		orientId = 1
	end

	local xn = orientId / 6
	local yn = orientId % 6
	
	local vx = Vector3.FromNormalId(xn)
	local vy = Vector3.FromNormalId(yn)
	
	return CFrame.fromMatrix(pos, vx, vy)
end

local function toQuaternion(cf)
	local w, x, y, z
	
	local m11, m12, m13, m21, m22, m23, m31, m32, m33 = select(4, cf:GetComponents())
	local trace = m11 + m22 + m33
	
	if trace > 0 then
        local s = math.sqrt(1 + trace)
        local r = 0.5 / s

        w = s * 0.5;
        x = (m32 - m23) * r;
        y = (m13 - m31) * r;
        z = (m21 - m12) * r;
	else
		local big = math.max(m11, m22, m33)
		
		if big == m11 then
			local s = math.sqrt(1 + m11 - m22 - m33)
			local r = 0.5 / s
			
			w = (m32 - m23) * r;
			x = 0.5 * s;
			y = (m21 + m12) * r;
			z = (m13 + m31) * r;
		elseif big == m22 then
			local s = math.sqrt(1 - m11 + m22 - m33)
			local r = 0.5 / s
			
			w = (m13 - m31) * r;
			x = (m21 + m12) * r;
			y = 0.5 * s;
			z = (m32 + m23) * r;
		elseif big == m33 then
			local s = math.sqrt(1 - m11 - m22 + m33)
			local r = 0.5 / s
			
			w = (m21 - m12) * r;
			x = (m13 + m31) * r;
			y = (m32 + m23) * r;
			z = 0.5 * s;
		end
	end
	
	return x, y, z, w
end

---------------------------------------------------------------------------------------------------------------------------------------
-- Serializer
---------------------------------------------------------------------------------------------------------------------------------------

local CFrameSerializer = {}

function CFrameSerializer:Encode(cf)
	local pos = cf.Position
	
	local orientId = getOrientId(cf)
	local x, y, z = pos.X, pos.Y, pos.Z
	
	if orientId < 0 then
		local qx, qy, qz, qw = toQuaternion(cf)
		return packNumbers(x, y, z, qx, qy, qz, qw)
	else
		return packNumbers(x, y, z, orientId)
	end
end

function CFrameSerializer:Decode(serialCF)
	local data = {}
	
	for str in serialCF:gmatch("[^ ]+") do
		local num = tonumber(str)
		table.insert(data, num)
	end
	
	if #data == 4 then
		local x, y, z, orientId = unpack(data)
		local pos = Vector3.new(x, y, z)
		
		return fromOrientId(pos, orientId)
	else
		return CFrame.new(unpack(data))
	end
end

return CFrameSerializer

---------------------------------------------------------------------------------------------------------------------------------------