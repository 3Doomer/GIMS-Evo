local	IsCreating = false,
		VPMesh = undefined

fn UpdateUI = (
	/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
	/*<ERRHANDLERSTART>*/try (
	local	state = this.CustomCullingPlane,
			LightsRol = this.LightsRol
	LightsRol.cCPX.Enabled = LightsRol.cCPAngleX.Enabled = state
	LightsRol.cCPY.Enabled = LightsRol.cCPAngleY.Enabled = state
	LightsRol.cCPZ.Enabled = LightsRol.cCPAngleZ.Enabled = state
	LightsRol.cCPDistance.Enabled = state
	local	IsPoint = (this.Type == 1)
	LightsRol.Falloff.Enabled = IsPoint
	/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
	/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)

fn UpdateContainer = (
	/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
	/*<ERRHANDLERSTART>*/try (
	if IsCreating != true then (
		local	ParentObj = this.ParentObj
		ParentObj.Type = #(#Omni, #FreeSpot, #FreeDirect)[this.Type]
		ParentObj.Color = this.TheColor
		ParentObj.FarAttenEnd = this.TheDistance
		ParentObj.Multiplier = this.Intensity
		if this.Type == 1 then
			ParentObj.DecayRadius = this.Falloff
		else (
			ParentObj.DecayRadius = 10
			ParentObj.HotSpot = this.ConeInnerAngle
			ParentObj.Falloff = this.ConeOuterAngle
		)
	)
	/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
	/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)

parameters params rollout:LightsRol (
	ParentObj				Type:#MAXObject
	Type					Type:#Integer	Default:1			UI:cType
	BoneTag					Type:#Integer	Default:0			UI:BoneTag
	GroupId					Type:#Integer	Default:0			UI:GroupId
	LightHash				Type:#Integer	Default:0			UI:LightHash
	ProjectedTextureName	Type:#String	Default:""			UI:ProjectedTextureName
	Flags					Type:#BoolTab	Default:false		TabSize:32					UI:(
																								mcflag_1,
																								mcflag_2,
																								mcflag_3,
																								mcflag_4,
																								mcflag_5,
																								mcflag_6,
																								mcflag_7,
																								mcflag_8,
																								mcflag_9,
																								mcflag_10,
																								mcflag_11,
																								mcflag_12,
																								mcflag_13,
																								mcflag_14,
																								mcflag_15,
																								mcflag_16,
																								mcflag_17,
																								mcflag_18,
																								mcflag_19,
																								mcflag_20,
																								mcflag_21,
																								mcflag_22,
																								mcflag_23,
																								mcflag_24,
																								mcflag_25,
																								mcflag_26,
																								mcflag_27,
																								mcflag_28,
																								mcflag_29,
																								mcflag_30,
																								mcflag_31,
																								mcflag_32
																							)
	TimeFlags				Type:#BoolTab	Default:false		TabSize:32					UI:(
																								mtflag_1,
																								mtflag_2,
																								mtflag_3,
																								mtflag_4,
																								mtflag_5,
																								mtflag_6,
																								mtflag_7,
																								mtflag_8,
																								mtflag_9,
																								mtflag_10,
																								mtflag_11,
																								mtflag_12,
																								mtflag_13,
																								mtflag_14,
																								mtflag_15,
																								mtflag_16,
																								mtflag_17,
																								mtflag_18,
																								mtflag_19,
																								mtflag_20,
																								mtflag_21,
																								mtflag_22,
																								mtflag_23,
																								mtflag_24,
																								mtflag_25,
																								mtflag_26,
																								mtflag_27,
																								mtflag_28,
																								mtflag_29,
																								mtflag_30,
																								mtflag_31,
																								mtflag_32
																							)
	TheColor				Type:#Color		Default:White		UI:TheColor
	TheExtents				Type:#Float		Default:1			UI:TheExtents
	CustomCullingPlane		Type:#Boolean	Default:false		UI:cCustomCullingPlane
	CPAngles				Type:#AngleTab	Default:0			TabSize:3	UI:(
																				cCPX,
																				cCPY,
																				cCPZ
																			)
	CPDistance				Type:#Float		Default:10			UI:cCPDistance

	CoronaSize				Type:#Float		Default:3			UI:CoronaSize
	CoronaIntensity			Type:#Float		Default:2			UI:CoronaIntensity
	CoronaZBias				Type:#Float		Default:0.1			UI:CoronaZBias

	Flashiness				Type:#Integer	Default:0			UI:Flashiness
	Intensity				Type:#Float		Default:1			UI:Intensity
	Falloff					Type:#Float		Default:15			UI:Falloff
	FalloffExponent			Type:#Float		Default:45			UI:FalloffExponent

	VolumeOuterColor		Type:#Color		Default:White		UI:VolumeOuterColor			
	VolumeIntensity			Type:#Float		Default:1			UI:VolumeIntensity
	VolumeSizeScale			Type:#Float		Default:1			UI:VolumeSizeScale
	VolumeOuterIntensity	Type:#Float		Default:1			UI:VolumeOuterIntensity
	VolumeOuterExponent		Type:#Float		Default:1			UI:VolumeOuterExponent
	VolumetricFadeDistance	Type:#Integer	Default:0			UI:VolumetricFadeDistance

	TheDistance				Type:#Integer	Default:0			UI:LightFadeDistance
	SpecularFadeDistance	Type:#Integer	Default:0			UI:SpecularFadeDistance

	ShadowBlur				Type:#Integer	Default:0			UI:ShadowBlur
	ShadowFadeDistance		Type:#Integer	Default:0			UI:ShadowFadeDistance
	ShadowNearClip			Type:#Float		Default:0.01		UI:ShadowNearClip

	ConeInnerAngle			Type:#Float		Default:10			UI:ConeInnerAngle
	ConeOuterAngle			Type:#Float		Default:25			UI:ConeOuterAngle
	
	on Type set val do (
		VPMesh = undefined
		UpdateContainer()
		UpdateUI()
	)
	on TheColor set val do
		UpdateContainer()
	on CustomCullingPlane set Val do (
		VPMesh = undefined
		UpdateUI()
	)
	on CPAngles set val do
		VPMesh = undefined
	on CPAngles set val i do
		VPMesh = undefined
	on CPDistance set val do
		VPMesh = undefined
	on TheDistance set val do
		UpdateContainer()
	on Falloff set val do
		UpdateContainer()
	on Intensity set val do
		UpdateContainer()
	on ConeInnerAngle set val do
		UpdateContainer()
	on ConeOuterAngle set val do
		UpdateContainer()
)

rollout LightsRol "GTA V model light" (
	local	AngleRange = [0, 360, 0]
	
	Label	TypeTip	"Type:"	Across:2
	RadioButtons cType Labels:#("Dot", "Spot", "Capsule") Columns:1
	ColorPicker TheColor "Color" Align:#Right
	Label	pttip	"Projector texture name"
	EditText	ProjectedTextureName
	Spinner	LightHash					"Light hash"		Type:#Integer	Range:[0,255,0]
	Spinner	BoneTag						"Bone ID"			Type:#Integer	Range:[0,65535,0]
	Spinner	GroupId						"Group ID"			Type:#Integer	Range:[0,255,0]
	Spinner	Flashiness					"Flashiness"		Type:#Integer	Range:[0,255,0]
	Spinner	Intensity					"Intensity"			Type:#Float		Range:[0,100,1]
	Spinner	Falloff						"Falloff"			Type:#Float		Range:[0.01,179,15]
	Spinner	FalloffExponent				"FalloffExponent"	Type:#Float		Range:[0,512,1]
	Spinner	TheExtents					"Extents"			Type:#Float		Range:[0,1000,1]
	Group "Light cone" (
		Spinner	ConeInnerAngle			"Inner angle"		Type:#Float		Range:[0.01,179,10]
		Spinner	ConeOuterAngle			"Outer angle"		Type:#Float		Range:[0.01,179,25]
	)
	Group "Fade distance" (
		Spinner	LightFadeDistance		"Light"				Type:#Integer	Range:[0,255,0]
		Spinner	SpecularFadeDistance	"Specular"			Type:#Integer	Range:[0,255,0]
	)
	Group "Corona" (
		Spinner	CoronaSize				"Size"				Type:#Float		Range:[0,100,1]
		Spinner	CoronaIntensity			"Intensity"			Type:#Float		Range:[0,10,1]
		Spinner	CoronaZBias				"Z-Bias"			Type:#Float		Range:[0,1,0.1]
	)
	Group "Shadows" (
		Spinner	ShadowBlur				"Blur"				Type:#Integer	Range:[0,255,0]
		Spinner	ShadowFadeDistance		"Fade distance"		Type:#Integer	Range:[0,255,0]
		Spinner	ShadowNearClip			"Near clip"			Type:#Float		Range:[0,5,0.01]
	)
	Group "Light volume" (
		ColorPicker VolumeOuterColor 	"Outer color" 		Align:#Right
		Spinner	VolumeIntensity			"Intensity"			Type:#Float		Range:[0,10,1]
		Spinner	VolumeSizeScale			"Size scale"		Type:#Float		Range:[0,10,1]
		Spinner	VolumeOuterIntensity	"Outer intensity"	Type:#Float		Range:[0,1,0]
		Spinner	VolumeOuterExponent		"Outer exponent"	Type:#Float		Range:[0,512,1]
		Spinner	VolumetricFadeDistance	"Fade distance"		Type:#Integer	Range:[0,255,0]
	)
	Group "Culling plane" (
		CheckBox	cCustomCullingPlane	"Custom"
		Spinner	cCPDistance	"Distance"	Type:#Float		Range:[0,10000,10]	Align:#Right
		Label	lCP	"Direction:"	Align:#Center
		Angle	cCPAngleX	"X"	Color:Blue	Diameter:40	StartDegrees:-90	Dir:#CW	Range:AngleRange	Align:#Left	Across:3
		Angle	cCPAngleY	"Y"	Color:Blue	Diameter:40	StartDegrees:-90	Dir:#CW	Range:AngleRange	Align:#Center
		Angle	cCPAngleZ	"Z"	Color:Blue	Diameter:40	StartDegrees:-90	Dir:#CW	Range:AngleRange	Align:#Right
		Spinner	cCPX	Type:#Float	Range:AngleRange	FieldWidth:35	Align:#Left	Across:3
		Spinner	cCPY	Type:#Float	Range:AngleRange	FieldWidth:35	Align:#Center
		Spinner	cCPZ	Type:#Float	Range:AngleRange	FieldWidth:35	Align:#Right
	)
	Group "Flags" (
		checkbox mcflag_1 "unk 1"	Across:2
		checkbox mcflag_2 "unk 2"
		checkbox mcflag_3 "unk 3"	Across:2
		checkbox mcflag_4 "unk 4"
		checkbox mcflag_5 "unk 5"	Across:2
		checkbox mcflag_6 "unk 6"
		checkbox mcflag_7 "unk 7"	Across:2
		checkbox mcflag_8 "unk 8"
		checkbox mcflag_9 "unk 9"	Across:2
		checkbox mcflag_10 "unk 10"
		checkbox mcflag_11 "unk 11"	Across:2
		checkbox mcflag_12 "unk 12"
		checkbox mcflag_13 "unk 13"	Across:2
		checkbox mcflag_14 "unk 14"
		checkbox mcflag_15 "unk 15"	Across:2
		checkbox mcflag_16 "unk 16"
		checkbox mcflag_17 "unk 17"	Across:2
		checkbox mcflag_18 "unk 18"
		checkbox mcflag_19 "unk 19"	Across:2
		checkbox mcflag_20 "unk 30"
		checkbox mcflag_21 "unk 21"	Across:2
		checkbox mcflag_22 "unk 22"
		checkbox mcflag_23 "unk 23"	Across:2
		checkbox mcflag_24 "unk 24"
		checkbox mcflag_25 "unk 25"	Across:2
		checkbox mcflag_26 "unk 26"
		checkbox mcflag_27 "unk 27"	Across:2
		checkbox mcflag_28 "unk 28"
		checkbox mcflag_29 "unk 29"	Across:2
		checkbox mcflag_30 "unk 30"
		checkbox mcflag_31 "unk 31"	Across:2
		checkbox mcflag_32 "unk 32"
	)
	Group "Time flags" (
		checkbox mtflag_1 "unk 1"	Across:2
		checkbox mtflag_2 "unk 2"
		checkbox mtflag_3 "unk 3"	Across:2
		checkbox mtflag_4 "unk 4"
		checkbox mtflag_5 "unk 5"	Across:2
		checkbox mtflag_6 "unk 6"
		checkbox mtflag_7 "unk 7"	Across:2
		checkbox mtflag_8 "unk 8"
		checkbox mtflag_9 "unk 9"	Across:2
		checkbox mtflag_10 "unk 10"
		checkbox mtflag_11 "unk 11"	Across:2
		checkbox mtflag_12 "unk 12"
		checkbox mtflag_13 "unk 13"	Across:2
		checkbox mtflag_14 "unk 14"
		checkbox mtflag_15 "unk 15"	Across:2
		checkbox mtflag_16 "unk 16"
		checkbox mtflag_17 "unk 17"	Across:2
		checkbox mtflag_18 "unk 18"
		checkbox mtflag_19 "unk 19"	Across:2
		checkbox mtflag_20 "unk 30"
		checkbox mtflag_21 "unk 21"	Across:2
		checkbox mtflag_22 "unk 22"
		checkbox mtflag_23 "unk 23"	Across:2
		checkbox mtflag_24 "unk 24"
		checkbox mtflag_25 "unk 25"	Across:2
		checkbox mtflag_26 "unk 26"
		checkbox mtflag_27 "unk 27"	Across:2
		checkbox mtflag_28 "unk 28"
		checkbox mtflag_29 "unk 29"	Across:2
		checkbox mtflag_30 "unk 30"
		checkbox mtflag_31 "unk 31"	Across:2
		checkbox mtflag_32 "unk 32"
	)
	
	on cCPAngleX Changed Val do
		cCPX.Value = Val
	on cCPAngleY Changed Val do
		cCPY.Value = Val
	on cCPAngleZ Changed Val do
		cCPZ.Value = Val
		
	on cCPX Changed Val do
		cCPAngleX.Degrees = Val
	on cCPY Changed Val do
		cCPAngleY.Degrees = Val
	on cCPZ Changed Val do
		cCPAngleZ.Degrees = Val
		
	on cType Changed State do
		UpdateContainer()
	on cCustomCullingPlane Changed State do
		UpdateUI()
	on LightsRol open do (
		LightsRol.cCPAngleX.Degrees = LightsRol.cCPX.Value
		LightsRol.cCPAngleY.Degrees = LightsRol.cCPY.Value
		LightsRol.cCPAngleZ.Degrees = LightsRol.cCPZ.Value
		UpdateUI()
	)
)

fn Init Obj = (
	local	ParentObj = this.ParentObj = Obj
	ParentObj.UseFarAtten = true
	ParentObj.ShowFarAtten = true
	ParentObj.UseNearAtten = true
	ParentObj.ShowNearAtten = true
	ParentObj.CastShadows = true
	ParentObj.RaytracedShadows = true
	ParentObj.FarAttenStart = 0
	ParentObj.AttenDecay  = 3
	
	local	ObjClass = (ClassOf ParentObj)
	this.Type = (
		case ObjClass of (
			TargetDirectionalLight:
				3
			DirectionalLight:
				3
			TargetSpot:
				2
			FreeSpot:
				2
			OmniLight:
				1
			Default:
				throw "Unknown light container: " ObjClass
		)
	)
	
	this.TheColor = ParentObj.Color
	this.TheDistance = ParentObj.FarAttenEnd
	this.Intensity = ParentObj.Multiplier
	if this.Type == 1 then
		this.Falloff = ParentObj.DecayRadius
	else (
		ParentObj.DecayRadius = 10
		this.ConeInnerAngle = ParentObj.HotSpot
		this.ConeOuterAngle = ParentObj.Falloff
	)
	
	IsCreating = false
	UpdateContainer()
	UpdateUI()
)
/**
on GetDisplayMesh do (
	if No VPMesh then (
		local	baseMesh = (
					case this.Type of (
						1:	--point
							(CreateInstance GeoSphere Radius:0.5 Segs:1 BaseType:1).Mesh
						2: (	--spot
							local	h = 2,
									res = (CreateInstance Cone Radius1:0.5 Radius2:0 Height:h Sides:8 HeightSegs:0 Capsegs:0).Mesh
							for i = 1 to res.NumVerts do
								SetVert res i ((GetVert res i) - [0, 0, h])
							res
						)
						3: (	--capsule
							local	h = 1,
									res = (CreateInstance Capsule Radius:0.5 Height:h Sides:8 HeightSegs:1).Mesh
							for i = 1 to res.NumVerts do
								SetVert res i ((GetVert res i) - [0, 0, h])
							res
						)
						Default:
							throw "Unknown light type: " this.Type
					)
				)
		if this.CustomCullingPlane then (
			local	CPObj = (CreateInstance Plane Length:1 Width:1 LengthSegs:1 WidthSegs:1),
					CPMesh = CPObj.Mesh,
					CPAngles = this.CPAngles,
					CPDistance = this.CPDistance,
					CPRot = ((EulerAngles CPAngles[1] CPAngles[2] CPAngles[3]) as Quat),
					CPVec = ([0, 0, -1] * CPRot)
			for i = 1 to CPMesh.NumVerts do
				SetVert CPMesh i (((GetVert CPMesh i) * CPRot) + (CPVec * CPDistance))
			--TODO add tangent mesh
			VPMesh = (baseMesh + CPMesh.Mesh)
		) else
			VPMesh = baseMesh
	)
	VPMesh
)
/**/