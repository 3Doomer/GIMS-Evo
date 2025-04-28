fn BoneFilter Obj = (
	(IsKindOf Obj EGIMS_V_Model_Bone) or
	(IsKindOf Obj.Modifiers["Bone"] EGIMS_V_Model_BoneMod)
)

parameters params rollout:BonesRol (
	IsInitialTMSet		Type:#Boolean		Default:false
	InitialTM			Type:#Matrix3		Default:(Matrix3 1)
	
	Flags				Type:#BoolTab		Default:false	TabSize:12		UI:(
																				LIMIT_ROTATION,
																				ROT_X,
																				ROT_Y,
																				ROT_Z,
																				LIMIT_TRANSLATION,
																				TRANS_X,
																				TRANS_Y,
																				TRANS_Z,
																				LIMIT_SCALE,
																				SCALE_X,
																				SCALE_Y,
																				SCALE_Z
																			)
	Index				Type:#Integer			Default:0		--collection process parameter
	ID					Type:#Integer			Default:0		UI:ID			Animatable:true
	MirrorBoneID		Type:#Integer			Default:0		UI:MirrorBoneID	Animatable:true
	TransMin			Type:#FloatTab			Default:0		TabSize:3	UI:(TransMinx, TransMiny, TransMinz)
	TransMax			Type:#FloatTab			Default:1		TabSize:3	UI:(TransMaxx, TransMaxy, TransMaxz)
	RotMin				Type:#FloatTab 			Default:-180	TabSize:3	--UI:(RotMinx, RotMiny, RotMinz)
	RotMax				Type:#FloatTab 			Default:180		TabSize:3	--UI:(RotMaxx, RotMaxy, RotMaxz)
	ScaleMin			Type:#FloatTab 			Default:1		TabSize:3	--UI:(ScaleMinx, ScaleMiny, ScaleMinz)
	ScaleMax			Type:#FloatTab 			Default:1		TabSize:3	--UI:(ScaleMaxx, ScaleMaxy, ScaleMaxz)
)

rollout BonesRol "GTA V model bone" (
	spinner 	ID 				"ID" 				Type:#Integer range:[0, 65535, 0]
	Label	lmbid	"Mirror bone ID:"	Align:#Center
	PickButton	MBPicker	"Pick"	Filter:BoneFilter	Width:60	Across:2	Message:"Pick a mirror bone to get its ID"	ToolTip:"Pick a mirror bone to get its ID"
	Spinner 	MirrorBoneID 	Type:#Integer range:[0, 65535, 0]
	--CheckBox	UseJoints		"Apply limits:"		Checked:false								Align:#Left
	Group "Rotation" (
		CheckBox	LIMIT_ROTATION	"Limit"	Align:#Center				--Enabled:false
		CheckBox	ROT_X			"X"	 	Align:#Center	Across:3	--Enabled:false
		CheckBox	ROT_Y			"Y"	 	Align:#Center				--Enabled:false
		CheckBox	ROT_Z			"Z"	 	Align:#Center				--Enabled:false
		--Label ll1 "Min XYZ"
		--spinner RotMinx Range:[-180, 180, -180]	Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		--spinner RotMiny Range:[-180, 180, -180]	Align:#Center	FieldWidth:35				--Enabled:false
		--spinner RotMinz Range:[-180, 180, -180]	Align:#Center	FieldWidth:35				--Enabled:false
		--Label ll2 "Max XYZ"
		--spinner RotMaxx Range:[-180, 180, 180] Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		--spinner RotMaxy Range:[-180, 180, 180] Align:#Center	FieldWidth:35				--Enabled:false
		--spinner RotMaxz Range:[-180, 180, 180] Align:#Center	FieldWidth:35				--Enabled:false
	)
	Group "Stretch" (
		CheckBox	LIMIT_SCALE	"Limit"	Align:#Center				--Enabled:false
		CheckBox	SCALE_X		"X"	 	Align:#Center	Across:3	--Enabled:false
		CheckBox	SCALE_Y		"Y"	 	Align:#Center				--Enabled:false
		CheckBox	SCALE_Z		"Z"		Align:#Center				--Enabled:false
		--Label ll3 "Min XYZ"
		--spinner ScaleMinx Range:[0, 1, 1] Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		--spinner ScaleMiny Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
		--spinner ScaleMinz Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
		--Label ll4 "Max XYZ"
		--spinner ScaleMaxx Range:[0, 1, 1] Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		--spinner ScaleMaxy Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
		--spinner ScaleMaxz Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
	)
	Group "Movement" (
		CheckBox	LIMIT_TRANSLATION	"Limit"	Align:#Center				--Enabled:false
		CheckBox	TRANS_X				"X"	 	Align:#Center	Across:3	--Enabled:false
		CheckBox	TRANS_Y				"Y"	 	Align:#Center				--Enabled:false
		CheckBox	TRANS_Z				"Z"	 	Align:#Center				--Enabled:false
		Label ll5 "Min XYZ"
		spinner TransMinx Range:[0, 1, 0] Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		spinner TransMiny Range:[0, 1, 0] Align:#Center	FieldWidth:35				--Enabled:false
		spinner TransMinz Range:[0, 1, 0] Align:#Center	FieldWidth:35				--Enabled:false
		Label ll6 "Max XYZ"
		spinner TransMaxx Range:[0, 1, 1] Align:#Center	FieldWidth:35	Across:3	--Enabled:false
		spinner TransMaxy Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
		spinner TransMaxz Range:[0, 1, 1] Align:#Center	FieldWidth:35				--Enabled:false
	)
	
	/*
	fn UpdateUI = (
		local	UseJointsChecked = UseJoints.Checked
		LIMIT_ROTATION.Enabled = UseJointsChecked
		ROT_X.Enabled = UseJointsChecked
		ROT_Y.Enabled = UseJointsChecked
		ROT_Z.Enabled = UseJointsChecked
		RotMinx.Enabled = UseJointsChecked
		RotMiny.Enabled = UseJointsChecked
		RotMinz.Enabled = UseJointsChecked
		RotMaxx.Enabled = UseJointsChecked
		RotMaxy.Enabled = UseJointsChecked
		RotMaxz.Enabled = UseJointsChecked
		LIMIT_SCALE.Enabled = UseJointsChecked
		SCALE_X.Enabled = UseJointsChecked
		SCALE_Y.Enabled = UseJointsChecked
		SCALE_Z.Enabled = UseJointsChecked
		ScaleMinx.Enabled = UseJointsChecked
		ScaleMiny.Enabled = UseJointsChecked
		ScaleMinz.Enabled = UseJointsChecked
		ScaleMaxx.Enabled = UseJointsChecked
		ScaleMaxy.Enabled = UseJointsChecked
		ScaleMaxz.Enabled = UseJointsChecked
		LIMIT_TRANSLATION.Enabled = UseJointsChecked
		TRANS_X.Enabled = UseJointsChecked
		TRANS_Y.Enabled = UseJointsChecked
		TRANS_Z.Enabled = UseJointsChecked
		TransMinx.Enabled = UseJointsChecked
		TransMiny.Enabled = UseJointsChecked
		TransMinz.Enabled = UseJointsChecked
		TransMaxx.Enabled = UseJointsChecked
		TransMaxy.Enabled = UseJointsChecked
		TransMaxz.Enabled = UseJointsChecked
	)
	on UseJoints Changed State do
		UpdateUI()
	on BonesRol Open do
		UpdateUI()
	*/
	on MBPicker Picked Obj do (
		this.MirrorBoneID.Controller = (
			if (IsKindOf Obj EGIMS_V_Model_Bone) then
				Obj.ID.Controller
			else
				Obj.Modifiers["Bone"].ID.Controller
		)
	)
)

on Create do (
	this.ID.Controller = (Linear_Float())
	this.MirrorBoneID.Controller = (Linear_Float())
)
