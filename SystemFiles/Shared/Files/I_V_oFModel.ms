parameters params rollout:rol (
	LODGroupValues	Type:#FloatTab	Default:9998		TabSize:4	UI:(LODGroupVal1, LODGroupVal2, LODGroupVal3, LODGroupVal4)
	UseBones		Type:#Boolean	Default:true				UI:UseBones
	
	CalcDataCRC		Type:#Boolean	Default:false				UI:CalcDataCRC
	DataCRC			Type:#Integer	Default:-1					UI:DataCRC
)
rollout rol "GTA V model" (
	Group "LOD distances" (
		Label	lLODGroupVal1	"High"	Align:#Right	Across:2
		Spinner	LODGroupVal1	Range:[0, 9999, 9998]	Align:#Center	FieldWidth:50
		Label	lLODGroupVal2	"Med"	Align:#Right	Across:2
		Spinner	LODGroupVal2	Range:[0, 9999, 9998]	Align:#Center	FieldWidth:50
		Label	lLODGroupVal3	"Low"	Align:#Right	Across:2
		Spinner	LODGroupVal3	Range:[0, 9999, 9998]	Align:#Center	FieldWidth:50
		Label	lLODGroupVal4	"VLow"	Align:#Right	Across:2
		Spinner	LODGroupVal4	Range:[0, 9999, 9998]	Align:#Center	FieldWidth:50
	)
	Group "Skeleton" (
		CheckBox	UseBones		"Include bones"			Align:#Left
		CheckBox	CalcDataCRC		"Recalculate DataCRC"	Align:#Left
		Spinner		DataCRC			Range:[-2147483647, 2147483647, -1]	Type:#Integer	Align:#Center	FieldWidth:(rol.Width - 30)	Enabled:false
		Button		SkelReset		"Revert bone transforms"
	)
	
	fn UpdateUI = (
		DataCRC.Enabled = (not CalcDataCRC.Checked)
	)
	fn _SkelReset_HWalk Obj = (
		/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
		/*<ERRHANDLERSTART>*/try (
		if
			(IsKindOf Obj EGIMS_V_Model_Bone) and
			Obj.IsInitialTMSet
		then
			Obj.Transform = (Obj.InitialTM * Obj.Parent.Transform)
		for Child in Obj.Children do
			_SkelReset_HWalk Child
		/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
		/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
	)
	on SkelReset Pressed do (
			local	DependentNodes = (Refs.DependentNodes this),
					ThisNode = DependentNodes[1]
			Free DependentNodes
		undo "Revert bone transforms" on (
			for Obj in ThisNode.Children do
				_SkelReset_HWalk Obj
		)
	)
	on CalcDataCRC Changed State do
		UpdateUI()
	on rol Open do
		UpdateUI()
)
