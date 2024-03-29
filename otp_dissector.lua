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
local SIZE_PRIORITY = 1
local SIZE_MANUFACTURERID = 2
local SIZE_MODULENUMBER = 2

local OTP_MANUFACTURERIDS = {
	[0x0000] = "ESTA"
}

local OTP_MODULENUMBERS = {
	[0x0001] = "Position",
	[0x0002] = "Position Velocity/Acceleration",
	[0x0003] = "Rotation",
	[0x0004] = "Rotation Velocity/Acceleration",
	[0x0005] = "Scale",
	[0x0006] = "Reference Frame"
}

local SIZE_OTPLAYER = OTP_IDENT:len() + SIZE_VECTOR + SIZE_LENGTH + SIZE_FOOTER_OPTIONS + SIZE_FOOTER_LENGTH + SIZE_CID + SIZE_FOLIO + SIZE_PAGE + SIZE_PAGE + SIZE_OPTIONS + SIZE_RESERVED + SIZE_NAME
OTPLayer_Ident = ProtoField.string("otp.ident", "OTP Packet Identifier", base.ASCII, "Identifies this message as OTP")
local OTPLater_Vectors = {
	[0x0001] = "VECTOR_OTP_TRANSFORM_MESSAGE",
	[0x0002] = "VECTOR_OTP_ADVERTISEMENT_MESSAGE",
	[0xFF01] = "VECTOR_OTP_TRANSFORM_MESSAGE_DRAFT",
	[0xFF02] = "VECTOR_OTP_ADVERTISEMENT_MESSAGE_DRAFT"
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
local OTPModuleAdvertisementLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_ADVERTISEMENT_MODULE_LIST"
}
OTPModuleAdvertisementLayer_Vector = ProtoField.uint16("otp.advertisement.module.vector", "Vector", base.HEX, OTPAdvertisementLayer_Vectors, 0, "Identifies Module Advertisement data as module list")
OTPModuleAdvertisementLayer_Length = ProtoField.uint16("otp.advertisement.module.length", "Length", base.DEC) -- "Length of PDU"
OTPModuleAdvertisementLayer_Reserved = ProtoField.uint32("otp.advertisement.module.reserved", "Reserved", base.HEX) -- "Reserved"
OTPModuleAdvertisementLayer_ManufacturerID = ProtoField.uint16("otp.advertisement.module.manuid", "Manufacturer ID", base.HEX, OTP_MANUFACTURERIDS, 0)
OTPModuleAdvertisementLayer_ModuleNumber = ProtoField.uint16("otp.advertisement.module.number", "Module Number", base.HEX, OTP_MODULENUMBERS, 0)

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
OTPTransformLayer_Pointset = ProtoField.uint8("otp.transform.pointset", "Full Point Set", base.DEC, {[0] = "Subset", [1] = "Full set"}, 0x80, "Options Flags")
OTPTransformLayer_Reserved = ProtoField.uint32("otp.transform.reserved", "Reserved", base.HEX) -- "Reserved"

local SIZE_OTPPOINT = SIZE_VECTOR + SIZE_LENGTH + SIZE_PRIORITY + SIZE_GROUP + SIZE_POINT + SIZE_TIMESTAMP + SIZE_OPTIONS + SIZE_RESERVED
local OTPPointLayer_Vectors = {
	[0x0001] = "VECTOR_OTP_MODULE"
}
OTPPointLayer_Vector = ProtoField.uint16("otp.transform.point.vector", "Vector", base.HEX, OTPPointLayer_Vectors, 0, "Identifies Point data as OTP Module PDU")
OTPPointLayer_Length = ProtoField.uint16("otp.transform.point.length", "Length", base.DEC) -- "Length of PDU"
OTPPointLayer_Priority = ProtoField.uint8("otp.transform.point.priority", "Priority", base.DEC) -- "Data priority if multiple sources for this Address"
OTPPointLayer_GroupNumber = ProtoField.uint16("otp.transform.point.group", "Group Number", base.DEC)
OTPPointLayer_PointNumber = ProtoField.uint32("otp.transform.point.point", "Point Number", base.DEC)
OTPPointLayer_Timestamp = ProtoField.relative_time("otp.transform.point.timestamp", "Timestamp", "Microseconds since the Time Origin")
OTPPointLayer_Options = ProtoField.uint8("otp.transform.point.options", "Options", base.HEX) -- "Options Flags"
OTPPointLayer_Reserved = ProtoField.uint32("otp.transform.point.reserved", "Reserved", base.HEX) -- "Reserved"

local SIZE_OTPMODULE = SIZE_MANUFACTURERID + SIZE_LENGTH + SIZE_MODULENUMBER
OTPModuleLayer_ManufacturerID = ProtoField.uint16("otp.transform.module.manuid", "Manufacturer ID", base.HEX, OTP_MANUFACTURERIDS, 0)
OTPModuleLayer_Length = ProtoField.uint16("otp.transform.module.length", "Length", base.DEC) -- "Length of PDU"
OTPModuleLayer_ModuleNumber = ProtoField.uint16("otp.transform.module.number", "Module Number", base.HEX, OTP_MODULENUMBERS, 0)

local SIZE_ESTAPOSITION = 4
local SIZE_OTPMODULEESTAPOSITION = SIZE_OPTIONS + SIZE_ESTAPOSITION + SIZE_ESTAPOSITION + SIZE_ESTAPOSITION
OTPModuleESTAPosition_Scaling = ProtoField.uint8("otp.transform.module.esta.position.scaling", "Scaling", base.DEC, {[0] = "μm", [1] = "mm"}, 0x80, "Options Flags")
OTPModuleESTAPosition_X = {
	[0] = ProtoField.int32("otp.transform.module.esta.position.x", "X", base.UNIT_STRING, {" μm"}), -- "The X location of the Point in μm"
	[1] = ProtoField.int32("otp.transform.module.esta.position.x", "X", base.UNIT_STRING, {" mm"}) -- "The X location of the Point in mm"
}
OTPModuleESTAPosition_Y = {
	[0] = ProtoField.int32("otp.transform.module.esta.position.y", "Y", base.UNIT_STRING, {" μm"}), -- "The Y location of the Point in μm"
	[1] = ProtoField.int32("otp.transform.module.esta.position.y", "Y", base.UNIT_STRING, {" mm"}) -- "The Y location of the Point in mm"
}
OTPModuleESTAPosition_Z = {
	[0] = ProtoField.int32("otp.transform.module.esta.position.z", "Z", base.UNIT_STRING, {" μm"}), -- "The Z location of the Point in μm"
	[1] = ProtoField.int32("otp.transform.module.esta.position.z", "Z", base.UNIT_STRING, {" mm"}) -- "The Z location of the Point in mm"
}

local SIZE_ESTAVELOCITY = 4
local SIZE_ESTAACCELERATION = 4
local SIZE_OTPMODULEESTAVELOCITY = SIZE_ESTAVELOCITY + SIZE_ESTAVELOCITY + SIZE_ESTAVELOCITY + SIZE_ESTAACCELERATION + SIZE_ESTAACCELERATION + SIZE_ESTAACCELERATION
OTPModuleESTAPositionVelocity_X = ProtoField.int32("otp.transform.module.esta.position.vx", "Vx", base.UNIT_STRING, {" μm/s"}) -- "The linear velocity in the X direction of the Point in μm/s"
OTPModuleESTAPositionVelocity_Y = ProtoField.int32("otp.transform.module.esta.position.vy", "Vy", base.UNIT_STRING, {" μm/s"}) -- "The linear velocity in the Y direction of the Point in μm/s"
OTPModuleESTAPositionVelocity_Z = ProtoField.int32("otp.transform.module.esta.position.vz", "Vz", base.UNIT_STRING, {" μm/s"}) -- "The linear velocity in the Z direction of the Point in μm/s"
OTPModuleESTAPositionAcceleration_X = ProtoField.int32("otp.transform.module.esta.position.ax", "Ax", base.UNIT_STRING, {" μm/s/s"}) -- "The linear acceleration in the X direction of the Point in μm/s2"
OTPModuleESTAPositionAcceleration_Y = ProtoField.int32("otp.transform.module.esta.position.ay", "Ay", base.UNIT_STRING, {" μm/s/s"}) -- "The linear acceleration in the X direction of the Point in μm/s2"
OTPModuleESTAPositionAcceleration_Z = ProtoField.int32("otp.transform.module.esta.position.az", "Az", base.UNIT_STRING, {" μm/s/s"}) -- "The linear acceleration in the X direction of the Point in μm/s2"

local SIZE_ESTAROTATION = 4
local SIZE_OTPMODULEESTAROTATION = SIZE_ESTAROTATION + SIZE_ESTAROTATION + SIZE_ESTAROTATION
OTPModuleESTARotation_X = ProtoField.uint32("otp.transform.module.esta.rotaion.x", "Rx", base.UNIT_STRING, {" x10^(−6)°"}) -- "The Euler X rotation of the Point in millionths of a decimal degree"
OTPModuleESTARotation_Y = ProtoField.uint32("otp.transform.module.esta.rotaion.y", "Ry", base.UNIT_STRING, {" x10^(−6)°"}) -- "The Euler Y rotation of the Point in millionths of a decimal degree"
OTPModuleESTARotation_Z = ProtoField.uint32("otp.transform.module.esta.rotaion.z", "Rz", base.UNIT_STRING, {" x10^(−6)°"}) -- "The Euler Z rotation of the Point in millionths of a decimal degree"

local SIZE_ESTAROTATIONVELOCITY = 4
local SIZE_ESTAROTATIONACCELERATION = 4
local SIZE_OTPMODULEESTAROTATIONVELOCITY = SIZE_ESTAROTATIONVELOCITY + SIZE_ESTAROTATIONVELOCITY + SIZE_ESTAROTATIONVELOCITY + SIZE_ESTAROTATIONACCELERATION + SIZE_ESTAROTATIONACCELERATION + SIZE_ESTAROTATIONACCELERATION
OTPModuleESTARotationVelocity_X = ProtoField.int32("otp.transform.module.esta.rotation.vrx", "Vrx", base.UNIT_STRING, {" x10^(−3)°/s"}) -- "The velocity of Euler X rotation of the Point in thousandths of a decimal degree/s"
OTPModuleESTARotationVelocity_Y = ProtoField.int32("otp.transform.module.esta.rotation.vry", "Vry", base.UNIT_STRING, {" x10^(−3)°/s"}) -- "The velocity of Euler Y rotation of the Point in thousandths of a decimal degree/s"
OTPModuleESTARotationnVelocity_Z = ProtoField.int32("otp.transform.module.esta.rotation.vrz", "Vrz", base.UNIT_STRING, {" x10^(−3)°/s"}) -- "The velocity of Euler Z rotation of the Point in thousandths of a decimal degree/s"
OTPModuleESTARotationAcceleration_X = ProtoField.int32("otp.transform.module.esta.rotation.arx", "Arx", base.UNIT_STRING, {" x10^(−3)°/s/s"}) -- "The acceleration of Euler X rotation of the Point in thousandths of a decimal degree/s2"
OTPModuleESTARotationAcceleration_Y = ProtoField.int32("otp.transform.module.esta.rotation.ary", "Ary", base.UNIT_STRING, {" x10^(−3)°/s/s"}) -- "The acceleration of Euler Y rotation of the Point in thousandths of a decimal degree/s2"
OTPModuleESTARotationAcceleration_Z = ProtoField.int32("otp.transform.module.esta.rotation.arz", "Arz", base.UNIT_STRING, {" x10^(−3)°/s/s"}) -- "The acceleration of Euler Z rotation of the Point in thousandths of a decimal degree/s2"

local SIZE_ESTASCALE = 4
local SIZE_OPTMODULEESTASCALE = SIZE_ESTASCALE + SIZE_ESTASCALE + SIZE_ESTASCALE
OTPModuleESTAScale_X = ProtoField.int32("otp.transform.module.esta.scale.x", "X", base.DEC) -- "The scale of the Point in the X direction in unitless millionths. A value of 1 (encoded as 1,000,000) indicates that this point is at its reference size"
OTPModuleESTAScale_Y = ProtoField.int32("otp.transform.module.esta.scale.y", "Y", base.DEC) -- "The scale of the Point in the Y direction in unitless millionths. A value of 1 (encoded as 1,000,000) indicates that this point is at its reference size"
OTPModuleESTAScale_Z = ProtoField.int32("otp.transform.module.esta.scale.z", "Z", base.DEC) -- "The scale of the Point in the X direction in unitless millionths. A value of 1 (encoded as 1,000,000) indicates that this point is at its reference size"

local SIZE_OTPMODULEESTAREFERENCE = SIZE_SYSTEM + SIZE_GROUP + SIZE_POINT
OTPModuleEstaReference_SystemNumber = ProtoField.uint8("otp.transform.module.esta.reference.system", "Reference System", base.DEC)
OTPModuleEstaReference_GroupNumber = ProtoField.uint16("otp.transform.module.esta.reference.group", "Reference Group", base.DEC)
OTPModuleEstaReference_PointNumber = ProtoField.uint32("otp.transform.module.esta.reference.point", "Reference Point", base.DEC)

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
	OTPTransformLayer_Reserved,
	
	-- Point Layer
	OTPPointLayer_Vector,
	OTPPointLayer_Length,
	OTPPointLayer_Priority,
	OTPPointLayer_GroupNumber,
	OTPPointLayer_PointNumber,
	OTPPointLayer_Timestamp,
	OTPPointLayer_Options,
	OTPPointLayer_Reserved,
	
	-- Module Layer
	OTPModuleLayer_ManufacturerID,
	OTPModuleLayer_Length,
	OTPModuleLayer_ModuleNumber,
	
	-- Module ESTA Position
	OTPModuleESTAPosition_Scaling,
	OTPModuleESTAPosition_X[0],OTPModuleESTAPosition_X[1],
	OTPModuleESTAPosition_Y[0],OTPModuleESTAPosition_Y[1],
	OTPModuleESTAPosition_Z[0],OTPModuleESTAPosition_Z[1],
	
	-- Module ESTA Position Velocity/Acceleration
	OTPModuleESTAPositionVelocity_X,
	OTPModuleESTAPositionVelocity_Y,
	OTPModuleESTAPositionVelocity_Z,
	OTPModuleESTAPositionAcceleration_X,
	OTPModuleESTAPositionAcceleration_Y,
	OTPModuleESTAPositionAcceleration_Z,
	
	-- Module ESTA Rotation Module
	OTPModuleESTARotation_X,
	OTPModuleESTARotation_Y,
	OTPModuleESTARotation_Z,
	
	-- Module ESTA Rotation Velocity/Acceleration 
	OTPModuleESTARotationVelocity_X,
	OTPModuleESTARotationVelocity_Y,
	OTPModuleESTARotationnVelocity_Z,
	OTPModuleESTARotationAcceleration_X,
	OTPModuleESTARotationAcceleration_Y,
	OTPModuleESTARotationAcceleration_Z,
	
	-- Module ESTA Scale
	OTPModuleESTAScale_X,
	OTPModuleESTAScale_Y,
	OTPModuleESTAScale_Z,
	
	-- Module ESTA Reference
	OTPModuleEstaReference_SystemNumber,
	OTPModuleEstaReference_GroupNumber,
	OTPModuleEstaReference_PointNumber
}

-- Bitwise helper functions from https://gist.github.com/kaeza/8ee7e921c98951b4686d
local bitty = require "bitty"

function formatCID(tvrange) 
	if tvrange:len() ~= SIZE_CID then return "Invalid CID" end
	return tvrange:range(0,4).."-"..tvrange:range(4,2).."-"..tvrange:range(6,2).."-"..tvrange:range(8,2).."-"..tvrange:range(10,6)
end

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
	local vectorItem = subtree:add(OTPLayer_Vector, vector)
	if OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_TRANSFORM_MESSAGE_DRAFT" 
		or OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_MESSAGE_DRAFT" then
			vectorItem:add_expert_info(PI_PROTOCOL, PI_ERROR, "Draft Vector")
	end
	
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
	
	local cid = tvbuf(idx, SIZE_CID)
	subtree:add(OTPLayer_CID, cid)
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
	
	local name = tvbuf(idx, SIZE_NAME)
	subtree:add_packet_field(OTPLayer_Name, tvbuf(idx, SIZE_NAME), ENC_UTF_8 + ENC_STRING)
	idx = idx + SIZE_NAME
	
	local info = {}
	if OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_TRANSFORM_MESSAGE" then
		TransformMessage(tvbuf, idx, tree, info)
	elseif OTPLater_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_MESSAGE" then
		AdvertisementMessage(tvbuf, idx, tree, info)
	else
		return
	end

	pktinfo.cols.info = info.strVector..", "..string.gsub(name:string(ENC_UTF_8), "\0*$", "").." ("..formatCID(cid)..")"
end

function TransformMessage(tvbuf, start, tree, info)
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
	
	if OTPTransformLayer_Vectors[vector:uint()] == "VECTOR_OTP_POINT" then
		info.strVector = "Point Transform"
		-- Point PDUs
		while (idx < start + length:uint() ) do
			local res = Point(tvbuf, idx, subtree)
			if (res == 0) then break end --TODO Hightlight this has an error state
			idx = idx + res
		end
	else
		info.strVector = "Unknown Transform"
		return
	end
end

function Point(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPPOINT then return 0 end
	
	local vector = tvbuf(idx, SIZE_VECTOR)
	idx = idx + SIZE_VECTOR
	
	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH
	
	local PDULength = (length:uint() + (SIZE_VECTOR + SIZE_LENGTH))
	if tvbuf:len() < start + PDULength then return 0 end
	local subtree = tree:add(otp, tvbuf(start, PDULength), "Point Layer")
	subtree:add(OTPPointLayer_Vector, vector)
	subtree:add(OTPPointLayer_Length, length)

	subtree:add(OTPPointLayer_Priority, tvbuf(idx, SIZE_PRIORITY))
	idx = idx + SIZE_PRIORITY
	
	subtree:add(OTPPointLayer_GroupNumber, tvbuf(idx, SIZE_GROUP))
	idx = idx + SIZE_GROUP
	
	subtree:add(OTPPointLayer_PointNumber, tvbuf(idx, SIZE_POINT))
	idx = idx + SIZE_POINT
	
	subtree:add(OTPPointLayer_Timestamp, tvbuf(idx, SIZE_TIMESTAMP))
	idx = idx + SIZE_TIMESTAMP
	
	subtree:add(OTPPointLayer_Options, tvbuf(idx, SIZE_OPTIONS))
	idx = idx + SIZE_OPTIONS
	
	subtree:add(OTPPointLayer_Reserved, tvbuf(idx, SIZE_RESERVED))
	idx = idx + SIZE_RESERVED
	
	if OTPPointLayer_Vectors[vector:uint()] == "VECTOR_OTP_MODULE" then
		-- Module PDUs
		while (idx < start + length:uint() ) do
			local res = Module(tvbuf, idx, subtree)
			if (res == 0) then break end --TODO Hightlight this has an error state
			idx = idx + res
		end
	end
	
	return PDULength
end

function Module(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULE then return 0 end
	
	local manuid = tvbuf(idx, SIZE_MANUFACTURERID)
	idx = idx + SIZE_MANUFACTURERID

	local length = tvbuf(idx, SIZE_LENGTH)
	idx = idx + SIZE_LENGTH

	local modulenum = tvbuf(idx, SIZE_MODULENUMBER)
	idx = idx + SIZE_MODULENUMBER
	
	local PDULength = (length:uint() + (SIZE_MANUFACTURERID + SIZE_LENGTH))
	if tvbuf:len() < start + PDULength then return 0 end
	local subtree = tree:add(otp, tvbuf(start, PDULength), "Module Layer")
	subtree:add(OTPModuleLayer_ManufacturerID, manuid)
	subtree:add(OTPModuleLayer_Length, length)
	subtree:add(OTPModuleLayer_ModuleNumber, modulenum)
	
	if OTP_MANUFACTURERIDS[manuid:uint()] == "ESTA" then
		if OTP_MODULENUMBERS[modulenum:uint()] == "Position" then
			ModuleEstaPosition(tvbuf, idx, subtree)
		elseif OTP_MODULENUMBERS[modulenum:uint()] == "Position Velocity/Acceleration" then
			ModuleEstaPositionVelocityAcceleration(tvbuf, idx, subtree)
		elseif OTP_MODULENUMBERS[modulenum:uint()] == "Rotation" then
			ModuleEstaRotation(tvbuf, idx, subtree)
		elseif OTP_MODULENUMBERS[modulenum:uint()] == "Rotation Velocity/Acceleration" then
			ModuleEstaRotationVelocityAcceleration(tvbuf, idx, subtree)
		elseif OTP_MODULENUMBERS[modulenum:uint()] == "Scale" then
			ModuleEstaScale(tvbuf, idx, subtree)
		elseif OTP_MODULENUMBERS[modulenum:uint()] == "Reference Frame" then
			ModuleEstaReference(tvbuf, idx, subtree)
		end
	end
	
	return PDULength
end

function ModuleEstaPosition(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULEESTAPOSITION then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPMODULEESTAPOSITION), "ESTA Position")
	
	local scaling = tvbuf(idx, SIZE_OPTIONS)
	subtree:add(OTPModuleESTAPosition_Scaling, scaling)
	idx = idx + SIZE_OPTIONS

	local scale = bitty.brshift(bitty.band(scaling:uint(),0x80), 7)
	subtree:add(OTPModuleESTAPosition_X[scale], tvbuf(idx, SIZE_ESTAPOSITION))
	idx = idx + SIZE_ESTAPOSITION

	subtree:add(OTPModuleESTAPosition_Y[scale], tvbuf(idx, SIZE_ESTAPOSITION))
	idx = idx + SIZE_ESTAPOSITION
	
	subtree:add(OTPModuleESTAPosition_Z[scale], tvbuf(idx, SIZE_ESTAPOSITION))
	idx = idx + SIZE_ESTAPOSITION
end

function ModuleEstaPositionVelocityAcceleration(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULEESTAVELOCITY then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPMODULEESTAVELOCITY), "ESTA Velocity/Acceleration")

	subtree:add(OTPModuleESTAPositionVelocity_X, tvbuf(idx, SIZE_ESTAVELOCITY))
	idx = idx + SIZE_ESTAVELOCITY
	
	subtree:add(OTPModuleESTAPositionVelocity_Y, tvbuf(idx, SIZE_ESTAVELOCITY))
	idx = idx + SIZE_ESTAVELOCITY
	
	subtree:add(OTPModuleESTAPositionVelocity_Z, tvbuf(idx, SIZE_ESTAVELOCITY))
	idx = idx + SIZE_ESTAVELOCITY
	
	subtree:add(OTPModuleESTAPositionAcceleration_X, tvbuf(idx, SIZE_ESTAACCELERATION))
	idx = idx + SIZE_ESTAACCELERATION
	
	subtree:add(OTPModuleESTAPositionAcceleration_Y, tvbuf(idx, SIZE_ESTAACCELERATION))
	idx = idx + SIZE_ESTAACCELERATION
	
	subtree:add(OTPModuleESTAPositionAcceleration_Z, tvbuf(idx, SIZE_ESTAACCELERATION))
	idx = idx + SIZE_ESTAACCELERATION
end

function ModuleEstaRotation(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULEESTAROTATION then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPMODULEESTAROTATION), "ESTA Rotation")
	
	subtree:add(OTPModuleESTARotation_X, tvbuf(idx, SIZE_ESTAROTATION))
	idx = idx + SIZE_ESTAPOSITION

	subtree:add(OTPModuleESTARotation_Y, tvbuf(idx, SIZE_ESTAROTATION))
	idx = idx + SIZE_ESTAPOSITION
	
	subtree:add(OTPModuleESTARotation_Z, tvbuf(idx, SIZE_ESTAROTATION))
	idx = idx + SIZE_ESTAPOSITION	
end

function ModuleEstaRotationVelocityAcceleration(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULEESTAROTATIONVELOCITY then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPMODULEESTAROTATIONVELOCITY), "ESTA Rotation Velocity/Acceleration")

	subtree:add(OTPModuleESTARotationVelocity_X, tvbuf(idx, SIZE_ESTAROTATIONVELOCITY))
	idx = idx + SIZE_ESTAROTATIONVELOCITY
	
	subtree:add(OTPModuleESTARotationVelocity_Y, tvbuf(idx, SIZE_ESTAROTATIONVELOCITY))
	idx = idx + SIZE_ESTAROTATIONVELOCITY
	
	subtree:add(OTPModuleESTARotationnVelocity_Z, tvbuf(idx, SIZE_ESTAROTATIONVELOCITY))
	idx = idx + SIZE_ESTAROTATIONVELOCITY
	
	subtree:add(OTPModuleESTARotationAcceleration_X, tvbuf(idx, SIZE_ESTAROTATIONACCELERATION))
	idx = idx + SIZE_ESTAROTATIONACCELERATION
	
	subtree:add(OTPModuleESTARotationAcceleration_Y, tvbuf(idx, SIZE_ESTAROTATIONACCELERATION))
	idx = idx + SIZE_ESTAROTATIONACCELERATION
	
	subtree:add(OTPModuleESTARotationAcceleration_Z, tvbuf(idx, SIZE_ESTAROTATIONACCELERATION))
	idx = idx + SIZE_ESTAROTATIONACCELERATION
end

function ModuleEstaScale(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OPTMODULEESTASCALE then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OPTMODULEESTASCALE), "ESTA Scale")
	
	subtree:add(OTPModuleESTAScale_X, tvbuf(idx, SIZE_ESTASCALE))
	idx = idx + SIZE_ESTASCALE

	subtree:add(OTPModuleESTAScale_Y, tvbuf(idx, SIZE_ESTASCALE))
	idx = idx + SIZE_ESTASCALE
	
	subtree:add(OTPModuleESTAScale_Z, tvbuf(idx, SIZE_ESTASCALE))
	idx = idx + SIZE_ESTASCALE	
end

function ModuleEstaReference(tvbuf, start, tree)
	local idx = start
	if tvbuf:len() < start + SIZE_OTPMODULEESTAREFERENCE then return end
	local subtree = tree:add(otp, tvbuf(start, SIZE_OTPMODULEESTAREFERENCE), "ESTA Reference")
	
	subtree:add(OTPModuleEstaReference_SystemNumber, tvbuf(idx, SIZE_SYSTEM))
	idx = idx + SIZE_SYSTEM

	subtree:add(OTPModuleEstaReference_GroupNumber, tvbuf(idx, SIZE_GROUP))
	idx = idx + SIZE_GROUP
	
	subtree:add(OTPModuleEstaReference_PointNumber, tvbuf(idx, SIZE_POINT))
	idx = idx + SIZE_POINT		
end

function AdvertisementMessage(tvbuf, start, tree, info)
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
		info.strVector = "Module Advertisement"
		AdvertisementModule(tvbuf, idx, tree)
	elseif OTPAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_NAME" then
		info.strVector = "Name Advertisement"
		AdvertisementName(tvbuf, idx, tree)
	elseif OTPAdvertisementLayer_Vectors[vector:uint()] == "VECTOR_OTP_ADVERTISEMENT_SYSTEM" then
		info.strVector = "System Advertisement"
		AdvertisementSystem(tvbuf, idx, tree)
	else
		info.strVector = "Unknown Advertisement"
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
