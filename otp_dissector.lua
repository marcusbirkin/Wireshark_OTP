otp = Proto("otp", "Object Transform Protocol")
local OTP_PORT = 5568
local OTP_IDENT = ByteArray.new("4f 54 50 2d 45 31 2e 35 39 00 00 00")

local SIZE_VECTOR = 2
local SIZE_LENGTH = 2
local SIZE_OPTIONS = 1
local SIZE_RESERVED = 4
local SIZE_FOOTER_OPTIONS = SIZE_OPTIONS
local SIZE_FOOTER_LENGTH = 1
local SIZE_FOLIO = 4
local SIZE_PAGE = 2
local SIZE_CID = 16
local SIZE_NAME = 32
local SIZE_SYSTEM = 1
local SIZE_GROUP = 2
local SIZE_POINT = 4
local SIZE_TIMESTAMP = 8

local SIZE_OTPLAYER = OTP_IDENT:len() + SIZE_VECTOR + SIZE_LENGTH + SIZE_FOOTER_OPTIONS + SIZE_FOOTER_LENGTH + SIZE_CID + SIZE_FOLIO + SIZE_PAGE + SIZE_PAGE + SIZE_OPTIONS + SIZE_RESERVED + SIZE_NAME
OTPLayer_Ident = ProtoField.string("otp.ident", "OTP Packet Identifier", base.ASCII, "Identifies this message as OTP")
local OTPLater_Vectors = {
	[0xFF01] = "VECTOR_OTP_TRANSFORM_MESSAGE",
	[0xFF02] = "VECTOR_OTP_ADVERTISEMENT_MESSAGE"
}
OTPLayer_Vector = ProtoField.uint16("otp.vector", "Vector", base.HEX, OTPLater_Vectors, 0, "Identifies OTP Layer data as OTP Transform PDU")
OTPLayer_Length = ProtoField.uint16("otp.length", "Length", base.DEC) -- "Length of message"
OTPLayer_FooterOptions = ProtoField.uint8("otp.footer.options", "Footer Options", base.HEX) -- "Footer Options Flags"
OTPLayer_FooterLength = ProtoField.uint8("otp.footer.length", "Footer Length", base.DEC) -- "Length of footer"
OTPLayer_CID = ProtoField.guid("otp.cid", "CID", "Sender's CID")
OTPLayer_Folio = ProtoField.uint32("otp.folio", "Folio Number", base.DEC) -- "Identifies OTP Folios"
OTPLayer_Page = ProtoField.uint16("otp.page.current", "Page", base.DEC) -- "Page number"
OTPLayer_LastPage = ProtoField.uint16("otp.page.last", "Last Page", base.DEC) -- "Final page number"
OTPLayer_Options = ProtoField.uint8("otp.options", "Options", base.HEX) -- "Options Flags"
OTPLayer_Reserved = ProtoField.uint32("otp.reserved", "Reserved", base.HEX) -- "Reserved"
OTPLayer_Name = ProtoField.string("otp.name", "Component Name", base.UNICODE, "Component Name")

local SIZE_OTPADVERTISMENT = SIZE_VECTOR + SIZE_LENGTH + SIZE_RESERVED
local OTPAdvertisementLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_ADVERTISEMENT_MODULE",
	[0x0002] = "VECTOR_OTP_ADVERTISEMENT_NAME",
	[0x0003] = "VECTOR_OTP_ADVERTISEMENT_SYSTEM"
}
OTPAdvertisementLayer_Vector = ProtoField.uint16("otp.advertisement.vector", "Vector", base.HEX, OTPAdvertisementLayer_Vectors, 0, "Identifies the type of advertisement data in the PDU")
OTPAdvertisementLayer_Length = ProtoField.uint16("otp.advertisement.length", "Length", base.DEC) -- "Length of PDU"
OTPAdvertisementLayer_Reserved = ProtoField.uint32("otp.advertisement.reserved", "Reserved", base.HEX) -- "Reserved"

local SIZE_OTPADVERTISMENTMODULE = SIZE_VECTOR + SIZE_LENGTH + SIZE_RESERVED
local SIZE_MANUFACTURERID = 2
local SIZE_MODULENUMBER = 2
local OTPModuleAdvertisementLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_ADVERTISEMENT_MODULE_LIST"
}
OTPModuleAdvertisementLayer_Vector = ProtoField.uint16("otp.advertisement.module.vector", "Vector", base.HEX, OTPAdvertisementLayer_Vectors, 0, "Identifies Module Advertisement data as module list")
OTPModuleAdvertisementLayer_Length = ProtoField.uint16("otp.advertisement.module.length", "Length", base.DEC) -- "Length of PDU"
OTPModuleAdvertisementLayer_Reserved = ProtoField.uint32("otp.advertisement.module.reserved", "Reserved", base.HEX) -- "Reserved"
local OTPModuleAdvertisementLayer_ManufacturerIDs = {}
OTPModuleAdvertisementLayer_ManufacturerIDs[0x0000] = "ESTA"
OTPModuleAdvertisementLayer_ManufacturerID = ProtoField.uint16("otp.advertisement.module.manuid", "Manufacturer ID", base.HEX, OTPModuleAdvertisementLayer_ManufacturerIDs, 0)
local OTPModuleAdvertisementLayer_ModuleNumber = {
	[0x0001] = "Position",
	[0x0002] = "Position Velocity/Acceleration",
	[0x0003] = "Rotation",
	[0x0004] = "Rotation Velocity/Acceleration",
	[0x0005] = "Scale",
	[0x0006] = "Reference Frame"
}
OTPModuleAdvertisementLayer_ModuleNumber = ProtoField.uint16("otp.advertisement.module.number", "Module Number", base.HEX, OTPModuleAdvertisementLayer_ModuleNumber, 0)

local SIZE_OTPADVERTISMENTNAME = SIZE_VECTOR + SIZE_LENGTH + SIZE_OPTIONS + SIZE_RESERVED
local OTPNameAdvertisementLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_ADVERTISEMENT_NAME_LIST"
}
OTPNameAdvertisementLayer_Vector = ProtoField.uint16("otp.advertisement.name.vector", "Vector", base.HEX, OTPNameAdvertisementLayer_Vectors, 0, "Identifies Module Advertisement data as module list")
OTPNameAdvertisementLayer_Length = ProtoField.uint16("otp.advertisement.name.length", "Length", base.DEC) -- "Length of PDU"
OTPNameAdvertisementLayer_Request = ProtoField.uint8("otp.advertisement.name.request", "Request/Response", base.DEC, {[0] = "Request", [1] = "Response"}, 0x80, "Options Flags") 
OTPNameAdvertisementLayer_Reserved = ProtoField.uint32("otp.advertisement.name.reserved", "Reserved", base.HEX) -- "Reserved"
OTPNameAdvertisementLayer_SystemNumber = ProtoField.uint8("otp.advertisement.name.system", "System Number", base.DEC)
OTPNameAdvertisementLayer_GroupNumber = ProtoField.uint16("otp.advertisement.name.group", "Group Number", base.DEC)
OTPNameAdvertisementLayer_PointNumber = ProtoField.uint32("otp.advertisement.name.point", "Point Number", base.DEC)
OTPNameAdvertisementLayer_PointName = ProtoField.string("otp.name", "Point Name", base.UNICODE, "Point Name")

local SIZE_OTPADVERTISMENTSYSTEM = SIZE_VECTOR + SIZE_LENGTH + SIZE_OPTIONS + SIZE_RESERVED
local OTPSystemAdvertisementLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_ADVERTISEMENT_SYSTEM_LIST"
}
OTPSystemAdvertisementLayer_Vector = ProtoField.uint16("otp.advertisement.system.vector", "Vector", base.HEX, OTPSystemAdvertisementLayer_Vectors, 0, "Identifies System Advertisement data as system number list")
OTPSystemAdvertisementLayer_Length = ProtoField.uint16("otp.advertisement.system.length", "Length", base.DEC) -- "Length of PDU"
OTPSystemAdvertisementLayer_Request = ProtoField.uint8("otp.advertisement.system.request", "Request/Response", base.DEC, {[0] = "Request", [1] = "Response"}, 0x80, "Options Flags") 
OTPSystemAdvertisementLayer_Reserved = ProtoField.uint32("otp.advertisement.system.reserved", "Reserved", base.HEX) -- "Reserved"
OTPSystemAdvertisementLayer_SystemNumber = ProtoField.uint8("otp.advertisement.name.system", "System", base.DEC)
	
local SIZE_OTPTRANSFORM	= SIZE_VECTOR + SIZE_LENGTH + SIZE_SYSTEM + SIZE_TIMESTAMP + SIZE_OPTIONS + SIZE_RESERVED
local OTPTransformLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_POINT"
}
OTPTransformLayer_Vector = ProtoField.uint16("otp.transform.vector", "Vector", base.HEX, OTPTransformLayer_Vectors, 0, "Identifies transform data as OTP Point PDU")
OTPTransformLayer_Length = ProtoField.uint16("otp.transform.length", "Length", base.DEC) -- "Length of PDU"
OTPTransformLayer_SystemNumber = ProtoField.uint8("otp.transform.system", "System", base.DEC)
OTPTransformLayer_Timestamp = ProtoField.relative_time("otp.transform.timestamp", "Timestamp", "Microseconds since the Time Origin")
OTPTransformLayer_Pointset = ProtoField.uint8("otp.transform.pointset", "Full Point Set",  base.DEC, {[0] = "Subset", [1] = "Full set"}, 0x80, "Options Flags")
OTPTransformLayer_Reserved = ProtoField.uint32("otp.transform.reserved", "Reserved", base.HEX) -- "Reserved"

otp.fields = { 
	-- OTP Layer
	OTPLayer_Ident, 
	OTPLayer_Vector, 
	OTPLayer_Length, 
	OTPLayer_FooterOptions,
	OTPLayer_FooterLength, 
	OTPLayer_CID, 
	OTPLayer_Folio, 
	OTPLayer_Page, 
	OTPLayer_LastPage, 
	OTPLayer_Options, 
	OTPLayer_Reserved,
	OTPLayer_Name,
	
	-- Advertisement
	OTPAdvertisementLayer_Vector,
	OTPAdvertisementLayer_Length,
	OTPAdvertisementLayer_Reserved,
	
	-- Module Advertisement
	OTPModuleAdvertisementLayer_Vector,
	OTPModuleAdvertisementLayer_Length,
	OTPModuleAdvertisementLayer_Reserved,
	OTPModuleAdvertisementLayer_ManufacturerID,
	OTPModuleAdvertisementLayer_ModuleNumber,
	
	-- Name Advertisement
	OTPNameAdvertisementLayer_Vector,
	OTPNameAdvertisementLayer_Length,
	OTPNameAdvertisementLayer_Request,
	OTPNameAdvertisementLayer_Reserved,
	OTPNameAdvertisementLayer_SystemNumber,
	OTPNameAdvertisementLayer_GroupNumber,
	OTPNameAdvertisementLayer_PointNumber,
	OTPNameAdvertisementLayer_PointName,
	
	-- System Advertisement
	OTPSystemAdvertisementLayer_Vector,
	OTPSystemAdvertisementLayer_Length,
	OTPSystemAdvertisementLayer_Request,
	OTPSystemAdvertisementLayer_Reserved,
	OTPSystemAdvertisementLayer_SystemNumber,
	
	-- Transform
	OTPTransformLayer_Vector,
	OTPTransformLayer_Length,
	OTPTransformLayer_SystemNumber,
	OTPTransformLayer_Timestamp,
	OTPTransformLayer_Pointset,
	OTPTransformLayer_Reserved
}

function heuristic_checker(tvbuf, pktinfo, root)
	-- Check ident
	if tvbuf:len() < OTP_IDENT:len() then return false end
	if (tvbuf(0, OTP_IDENT:len()):bytes() ~= OTP_IDENT) then 
		return false
	else
		otp.dissector(tvbuf, pktinfo, root)
		pktinfo.conversation = otp
		return true
	end
end

function otp.dissector(tvbuf, pktinfo, root)
	local idx = 0

	pktinfo.cols.protocol = otp.name
	local tree = root:add(otp, tvbuf(), "Object Transform Protocol")

	-- OTP Layer
	if tvbuf:len() < SIZE_OTPLAYER then return end
	local subtree = tree:add(otp, tvbuf(0, SIZE_OTPLAYER), "OTP Layer")
	
	subtree:add(OTPLayer_Ident, tvbuf(idx, OTP_IDENT:len()))
	idx = idx + OTP_IDENT:len()
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	local lengthItem = subtree:add(OTPLayer_Length, length)
	local lengthOffset = tvbuf:len() - (length:uint() + (OTP_IDENT:len() + SIZE_VECTOR + SIZE_LENGTH))
	if lengthOffset > 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "Frame too long")
	elseif lengthOffset < 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "Frame too short")
	end
	
	local footer = subtree:add(otp, tvbuf(idx, SIZE_FOOTER_OPTIONS + SIZE_FOOTER_LENGTH), "Footer")
	footer:add(OTPLayer_FooterOptions, tvbuf(idx, SIZE_FOOTER_OPTIONS))
	idx = idx + SIZE_FOOTER_OPTIONS
	footer:add(OTPLayer_FooterLength, tvbuf(idx, SIZE_FOOTER_LENGTH))
	idx = idx + SIZE_FOOTER_LENGTH
	
	subtree:add(OTPLayer_CID, tvbuf(idx, SIZE_CID))
	idx = idx + SIZE_CID
	
	subtree:add(OTPLayer_Folio, tvbuf(idx, SIZE_FOLIO))
	idx = idx + SIZE_FOLIO
	
	local page = subtree:add(otp, tvbuf(idx, SIZE_PAGE + SIZE_PAGE), "Page")
	page:add(OTPLayer_Page, tvbuf(idx, SIZE_PAGE))
	idx = idx + SIZE_PAGE
	page:add(OTPLayer_LastPage, tvbuf(idx, SIZE_PAGE))
	idx = idx + SIZE_PAGE
	
	subtree:add(OTPLayer_Options, tvbuf(idx, SIZE_OPTIONS))
	idx = idx + SIZE_OPTIONS
	
	subtree:add(OTPLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	subtree:add(OTPLayer_Name, tvbuf(idx, SIZE_NAME))
	idx = idx + SIZE_NAME
	
	if OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_TRANSFORM_MESSAGE" then
		 TransformMessage(tvbuf, idx, tree)
	elseif OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_MESSAGE" then
		AdvertisementMessage(tvbuf, idx, tree)
	else
		return
	end
end

function TransformMessage(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPTRANSFORM then return false end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPTRANSFORM), "Transform Layer")
	
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPTransformLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	local lengthItem = subtree:add(OTPTransformLayer_Length, length)
	local lengthOffset = tvbuf:len() - start - (length:uint() + (SIZE_VECTOR + SIZE_LENGTH))
	if lengthOffset > 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "PDU too long")
	elseif lengthOffset < 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "PDU too short")
	end
	
	subtree:add(OTPTransformLayer_SystemNumber, tvbuf(idx, SIZE_SYSTEM))
	idx = idx + SIZE_SYSTEM
	
	subtree:add(OTPTransformLayer_Timestamp, tvbuf(idx, SIZE_TIMESTAMP))
	idx = idx + SIZE_TIMESTAMP
	
	subtree:add(OTPTransformLayer_Pointset, tvbuf(idx, SIZE_OPTIONS))
	idx = idx + SIZE_OPTIONS
	
	subtree:add(OTPTransformLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	
end

function AdvertisementMessage(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPADVERTISMENT then return false end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPADVERTISMENT), "Advertisement Layer")
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPAdvertisementLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	local lengthItem = subtree:add(OTPAdvertisementLayer_Length, length)
	local lengthOffset = tvbuf:len() - start - (length:uint() + (SIZE_VECTOR + SIZE_LENGTH))
	if lengthOffset > 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "PDU too long")
	elseif lengthOffset < 0 then
		lengthItem:add_expert_info(PI_MALFORMED, PI_ERROR, "PDU too short")
	end
	
	subtree:add(OTPAdvertisementLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	if OTPAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_MODULE" then
		 AdvertisementModule(tvbuf, idx, tree)
	elseif OTPAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_NAME" then
		AdvertisementName(tvbuf, idx, tree)
	elseif OTPAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_SYSTEM" then
		AdvertisementSystem(tvbuf, idx, tree)
	else
		return
	end
end

function AdvertisementModule(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPADVERTISMENTMODULE then return false end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPADVERTISMENTMODULE), "Module Advertisement Layer")
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPModuleAdvertisementLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	subtree:add(OTPModuleAdvertisementLayer_Length, length)
	
	subtree:add(OTPModuleAdvertisementLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	if OTPModuleAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_MODULE_LIST" then
		-- List of Module Identifiers
		local listLength = length:uint() - (SIZE_VECTOR + SIZE_LENGTH)
		local listOffset = SIZE_MANUFACTURERID + SIZE_MODULENUMBER
		local modules = subtree:add(otp, tvbuf(idx, listLength - 1), "Module List ("..listLength/listOffset..")")
		local moduleNum = 0
		for idx = idx, (idx + listLength) - 1, listOffset do
			local t = modules:add(otp, tvbuf(idx, 4), moduleNum)
			t:add(OTPModuleAdvertisementLayer_ManufacturerID, tvbuf(idx, SIZE_MANUFACTURERID))
			t:add(OTPModuleAdvertisementLayer_ModuleNumber, tvbuf(idx + SIZE_MANUFACTURERID, SIZE_MODULENUMBER))
			moduleNum = moduleNum + 1
		end
	else

	end
end

function AdvertisementName(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < SIZE_OTPADVERTISMENTNAME then return false end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPADVERTISMENTNAME), "Name Advertisement Layer")
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPNameAdvertisementLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	subtree:add(OTPNameAdvertisementLayer_Length, length)	
	
	local options = tvbuf(idx, SIZE_OPTIONS)
	idx = idx + SIZE_OPTIONS
	local t = subtree:add(otp, options, "Options")
	t:add(OTPNameAdvertisementLayer_Request, options)
	
	subtree:add(OTPNameAdvertisementLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	if OTPNameAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_NAME_LIST" then
		-- List of Address Point Descriptions
		local listLength = length:uint() - (SIZE_VECTOR + SIZE_LENGTH + SIZE_OPTIONS)
		local listOffset = (SIZE_SYSTEM + SIZE_GROUP + SIZE_POINT + SIZE_NAME)
		local addresses = subtree:add(otp, tvbuf(idx, listLength - 1), "Address Point Description List ("..listLength/listOffset..")")
		local addressNum = 0
		for idx = idx, (idx + listLength) - 1, listOffset do
			local system = tvbuf(idx, SIZE_SYSTEM)
			local group = tvbuf(idx + SIZE_SYSTEM, SIZE_GROUP)
			local point = tvbuf(idx + SIZE_SYSTEM + SIZE_GROUP, SIZE_POINT)
			local t = addresses:add(otp, tvbuf(idx, SIZE_SYSTEM + SIZE_GROUP + SIZE_POINT), system.."/"..group.."/"..point)
			t:add(OTPNameAdvertisementLayer_SystemNumber, system)
			t:add(OTPNameAdvertisementLayer_GroupNumber, group)
			t:add(OTPNameAdvertisementLayer_PointNumber, point)
			t:add(OTPNameAdvertisementLayer_PointName, tvbuf(idx + SIZE_SYSTEM + SIZE_GROUP + SIZE_POINT, SIZE_NAME))
			addressNum = addressNum + 1
		end
	else
	
	end
end

function AdvertisementSystem(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < SIZE_OTPADVERTISMENTSYSTEM then return false end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPADVERTISMENTSYSTEM), "System Advertisement Layer")
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	subtree:add(OTPSystemAdvertisementLayer_Vector, vector)
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	subtree:add(OTPSystemAdvertisementLayer_Length, length)	
	
	local options = tvbuf(idx, SIZE_OPTIONS)
	idx = idx + SIZE_OPTIONS
	local t = subtree:add(otp, options, "Options")
	t:add(OTPSystemAdvertisementLayer_Request, options)
	
	subtree:add(OTPSystemAdvertisementLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	if OTPSystemAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_SYSTEM_LIST" then
		-- List of System Numbers
		local listLength = length:uint() - (SIZE_VECTOR + SIZE_LENGTH + SIZE_OPTIONS)
		local listOffset = SIZE_SYSTEM
		local systems = subtree:add(otp, tvbuf(idx, listLength - 1), "System Numbers List ("..listLength/listOffset..")")
		for idx = idx, (idx + listLength) - 1, listOffset do
			systems:add(OTPSystemAdvertisementLayer_SystemNumber, tvbuf(idx, SIZE_SYSTEM))
		end
	else
	
	end
end

otp:register_heuristic("udp", heuristic_checker)