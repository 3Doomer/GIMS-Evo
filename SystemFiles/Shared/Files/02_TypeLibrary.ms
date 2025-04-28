/*#PC*DEFINE	CurrentGame	Shared*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	/*Globalization*/
	global		EGIMS_GUI_Item,
				EGIMS_GUI_Layout,
				EGIMS_Dummy,
				GTAIVunimat,
				GTA_IV_material,
				EGIMS_IV_material,
				EGIMS_AE_material,
				EGIMS_AE_Model,
				EGIMS_AE_Collision,
				EGIMS_AE_CollisionNode,
				EGIMS_AE_Col_Box,
				EGIMS_AE_Col_Sphere,
				EGIMS_AE_Weapon,
				EGIMS_AE_WeaponNode,
				EGIMS_AE_WeaponInstance,
				EGIMS_MP3_Material,
				EGIMS_MP3_ModelDict,
				EGIMS_MP3_Model,
				EGIMS_MP3_Model_Bone,
				EGIMS_MP3_Model_BoneMod,
				EGIMS_MP3_Model_Light,
				EGIMS_MP3_Model_LightMod,
				EGIMS_MP3_ModelMesh,
				EGIMS_MP3_TexDict,
				EGIMS_V_Material,
				EGIMS_V_CollisionDict,
				EGIMS_V_Col_Composite,
				EGIMS_V_Col_Plane,
				EGIMS_V_Col_Box,
				EGIMS_V_Col_Disc,
				EGIMS_V_Col_Sphere,
				EGIMS_V_Col_Cylinder,
				EGIMS_V_Col_Capsule,
				EGIMS_V_CollisionMesh,
				EGIMS_V_Col_PrimBox,
				EGIMS_V_Col_PrimSphere,
				EGIMS_V_Col_PrimCapsule,
				EGIMS_V_Col_PrimCylinder,
				EGIMS_V_ModelDict,
				EGIMS_V_Model,
				EGIMS_V_Model_ModelMod,
				EGIMS_V_Model_Bone,
				EGIMS_V_Model_BoneMod,
				EGIMS_V_Model_Light,
				EGIMS_V_Model_LightMod,
				EGIMS_V_ModelMesh,
				EGIMS_V_TexDict,
				EGIMS_V_VehicleRecording--,
				--EGIMS_V_MapHelper
	/*Dev*/
	plugin /*#PC*PATH	GIMS.Core.GUI.GUI_Item*/ 	SimpleObject 	EGIMS_GUI_Item				Category:"Dev_GUI" 				Name:"Item" 									ClassID:#(1732535932, 1671230926)		Invisible:true	(
		local	GUIMgr = GIMS.Core.GUIMgr,
				Align = GUIMgr.Align,
				MiddleCenter = GIMS.GUI.Align.MiddleCenter,
				ControlTypes = GUIMgr.ControlTypes,
				Fonts = GUIMgr.Fonts,
				Colors = GUIMgr.Colors,
				TextImageRelations = GUIMgr.TextImageRelations,
				Events = GUIMgr.Events[4],
				ActTypes = GUIMgr.ActTypes,
				Transparent = GIMS.GUI.Colour.Transparent
		fn PickerFilter Obj = (
			(IsKindOf Obj EGIMS_GUI_Item)
		)
		fn IsNotHighlightable State = (
			(
				State == 3 or
				State == 13 or
				State == 4 or
				State == 5
			)
		)
		fn IsCheckable State = (
			(
				State == 6 or
				State == 7 or
				State == 11
			)
		)
		fn IsListBox State = (
			(
				State == 13 or
				State == 4 or
				State == 5
			)
		)
		parameters	PGeneral		Rollout:GeneralRol	(
			GIMSObjectLink	Type:#String														Default:"GIMS.Core.GUI.GUI_Item"
			ItemSize	 			Type:#IntTab		UI:(GUIItemSizeX, GUIItemSizeY)	Default:9	TabSize:2
			ItemType	 		Type:#Integer		UI:GUIItemType							Default:1
			DefaultState		Type:#Boolean	UI:GUIDefaultState						Default:true
			CheckState			Type:#Boolean	UI:GUICheckState						Default:true
			SelectionMode		Type:#Integer		UI:GUISelectionMode					Default:2
			GroupID				Type:#Integer		UI:GUIGroupID								Default:1
			on ItemType set State do (
				local	Flag = (IsListBox State)
				this.GeneralRol.GUISelectionMode.Enabled = Flag
				this.GeneralRol.GUIGroupID.Enabled = (State == 11)
				Flag = (IsNotHighlightable State)
				this.AppearRol.GUIClickable.Enabled = (not Flag)
				if Flag then (
					if
						Flag and
						this.Clickable
					then
						this.Clickable = false
				)
				if (IsCheckable State) then
					ChangeIcon = true
			)
		)
		parameters	PAppear		Rollout:AppearRol		(
			BackColor	 		Type:#Integer		UI:GUIBackColor				Default:1
			Clickable				Type:#Boolean	UI:GUIClickable					Default:true
		)
		parameters	PText		Rollout:TextRol		(
			ItemText	Type:#String		UI:GUIItemText	Default:""
			ItemContent	Type:#String		UI:GUIItemContent	Default:""
			Font	 		Type:#Integer		UI:GUIFont			Default:3
			ForeColor	Type:#Integer		UI:GUIForeColor	Default:2
			TextAlign	Type:#Integer		UI:GUITextAlign	Default:2
		)
		parameters	PIcon			Rollout:IconRol		(
			ChangeIcon			Type:#Boolean	UI:GUIChangeIcon						Default:false
			Icon	 					Type:#String		UI:GUIIcon									Default:"Null"
			Animated				Type:#Boolean	UI:GUIAnimated							Default:false
			IconSize	 				Type:#IntTab		UI:(GUIIconSizeX, GUIIconSizeY)	Default:7	TabSize:2
			ImageAlign	 			Type:#Integer		UI:GUIImageAlign							Default:4
			TextImageRelation	Type:#Integer		UI:GUITextImageRelation				Default:1
			on Animated set State do (
				this.IconRol.GUIIconSizeX.Enabled = (not State)
				this.IconRol.GUIIconSizeY.Enabled = (not State)
			)
		)
		parameters	PEvents		Rollout:EventsRol		(
			EventTypes	 	Type:#IntTab		UI:(
				EventType1,
				EventType2,
				EventType3,
				EventType4,
				EventType5,
				EventType6,
				EventType7,
				EventType8,
				EventType9
			)	Default:1		TabSize:GIMS.Core.GUIMgr.Events[4].Count
			EventCores	 		Type:#IntTab		UI:(
				EventCore1,
				EventCore2,
				EventCore3,
				EventCore4,
				EventCore5,
				EventCore6,
				EventCore7,
				EventCore8,
				EventCore9
			)	Default:2		TabSize:GIMS.Core.GUIMgr.Events[4].Count
			EventNames	 	Type:#StringTab	UI:(
				EventName1,
				EventName2,
				EventName3,
				EventName4,
				EventName5,
				EventName6,
				EventName7,
				EventName8,
				EventName9
			)	Default:"Null"	TabSize:GIMS.Core.GUIMgr.Events[4].Count
		)
		parameters	PChildren	Rollout:ChildrenRol	(
			Scrollable			Type:#Boolean	UI:GUIScrollable		Default:false
			ScrollOrient			Type:#Integer		UI:GUIScrollOrient	Default:1
			SubItems			Type:#NodeTab	TabSize:20	TabSizeVariable:true	UI: (
				Child1,
				Child2,
				Child3,
				Child4,
				Child5,
				Child6,
				Child7,
				Child8,
				Child9,
				Child10,
				Child11,
				Child12,
				Child13,
				Child14,
				Child15,
				Child16,
				Child17,
				Child18,
				Child19,
				Child20
			)
			on Scrollable set State do
				this.ChildrenRol.GUIScrollOrient.Enabled = State
		)
		rollout	GeneralRol	"General"								(
			Label l0 "Size"
			Spinner			GUIItemSizeX			"X"					Type:#Integer		Range:[2, 300, 9]	Align:#Left		Width:60	Across:2
			Spinner			GUIItemSizeY			"Y"					Type:#Integer		Range:[2, 300, 9]	Align:#Right	Width:60
			RadioButtons	GUIItemType	 		"Type"				Labels:ControlTypes[2]	Align:#Left
			CheckBox		GUIDefaultState		"Enabled"
			CheckBox		GUICheckState		"Checked"
			RadioButtons	GUISelectionMode	"Selection mode"	Labels:#("None", "One", "Multi")			Columns:3	Align:#Left	Enabled:false
			Spinner			GUIGroupID				"Group ID"			Type:#Integer		Range:[1, 10, 1]		Align:#Left	Width:60	Enabled:false
			on GeneralRol Open do (
				GUISelectionMode.Enabled = (IsListBox ItemType)
				GUICheckState.Enabled = (IsCheckable ItemType)
				GUIGroupID.Enabled = (ItemType == 11)
			)
		)
		rollout	AppearRol	"Appearance"		RolledUp:true	(
			CheckBox		GUIClickable				"Clickable"	Enabled:true
			RadioButtons	GUIBackColor	 		"Color"						Labels:Colors[2]	Columns:2	Align:#Left
			on AppearRol Open do (
				local	Flag = (IsNotHighlightable ItemType)
				GUIClickable.Enabled = (not Flag)
				if
					Flag and
					Clickable
				then
					Clickable = false
			)
		)
		rollout	TextRol		"Text"			RolledUp:true	(
			Label lt1 "Label:"
			EditText		GUIItemText
			Label lt2 "EditText:"
			EditText		GUIItemContent
			RadioButtons	GUIFont	 			"Font"						Labels:Fonts[2]							Align:#Left
			RadioButtons	GUITextAlign	 		"Alignment"					Labels:Align[2]				Align:#Left
			RadioButtons	GUIForeColor	 		"Color"						Labels:Colors[2]			Columns:2	Align:#Left
		)
		rollout	IconRol		"Icon"				RolledUp:true	(
			Label l1 "Size"
			Spinner			GUIIconSizeX	"X"	Type:#Integer		Range:[2, 300, 7]	Align:#Left		Width:60	Across:2
			Spinner			GUIIconSizeY	"Y"	Type:#Integer		Range:[2, 300, 7]	Align:#Right	Width:60
			EditText		GUIIcon	 		"Name"
			CheckBox		GUIAnimated	"Animated"
			CheckBox		GUIChangeIcon	"Changeable eventually"
			RadioButtons	GUIImageAlign	 			"Alignment"	Labels:Align[2]					Align:#Left
			RadioButtons	GUITextImageRelation	"Alignment"	Labels:TextImageRelations[2]	Align:#Left
			on IconRol Open do (
				GUIIconSizeX.Enabled = (not GUIAnimated.Checked)
				GUIIconSizeY.Enabled = (not GUIAnimated.Checked)
				GUIIcon.Enabled = (GUIAnimated.Enabled = (GUIChangeIcon.Enabled = (not (IsCheckable State))))
			)
		)
		rollout	EventsRol	"Events"				RolledUp:true	(
			DotNETControl	lName1	"System.Windows.Forms.Label"	Text:Events[1]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType1			"Type"		Across:2
			Label			lDef1				"Core"
			RadioButtons	EventType1				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore1					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName1	"Name"	Align:#Right
			Label			lsp
			DotNETControl	lName2	"System.Windows.Forms.Label"	Text:Events[2]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType2			"Type"		Across:2
			Label			lDef2				"Core"
			RadioButtons	EventType2				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore2					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName2	"Name"	Align:#Right
			Label			lsp3
			DotNETControl	lName3	"System.Windows.Forms.Label"	Text:Events[3]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType3			"Type"		Across:2
			Label			lDef3				"Core"
			RadioButtons	EventType3				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore3					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName3	"Name"	Align:#Right
			Label			lsp4
			DotNETControl	lName4	"System.Windows.Forms.Label"	Text:Events[4]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType4			"Type"		Across:2
			Label			lDef4				"Core"
			RadioButtons	EventType4				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore4					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName4	"Name"	Align:#Right
			Label			lsp5
			DotNETControl	lName5	"System.Windows.Forms.Label"	Text:Events[5]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType5			"Type"		Across:2
			Label			lDef5				"Core"
			RadioButtons	EventType5				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore5					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName5	"Name"	Align:#Right
			Label			lsp6
			DotNETControl	lName6	"System.Windows.Forms.Label"	Text:Events[6]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType6			"Type"		Across:2
			Label			lDef6				"Core"
			RadioButtons	EventType6				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore6					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName6	"Name"	Align:#Right
			Label			lsp7
			DotNETControl	lName7	"System.Windows.Forms.Label"	Text:Events[7]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType7			"Type"		Across:2
			Label			lDef7				"Core"
			RadioButtons	EventType7				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore7					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName7	"Name"	Align:#Right
			Label			lsp8
			DotNETControl	lName8	"System.Windows.Forms.Label"	Text:Events[8]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType8			"Type"		Across:2
			Label			lDef8				"Core"
			RadioButtons	EventType8				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore8					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName8	"Name"	Align:#Right
			Label			lsp9
			DotNETControl	lName9	"System.Windows.Forms.Label"	Text:Events[9]	TextAlign:MiddleCenter	BackColor:Transparent
			Label			lType9			"Type"		Across:2
			Label			lDef9				"Core"
			RadioButtons	EventType9				Align:#Center	Labels:ActTypes	Across:2
			RadioButtons	EventCore9					Align:#Center	Labels:#("Shared", "Game")
			EditText		EventName9	"Name"	Align:#Right
			on EventsRol Open do (
				local	Labels = #(
							lName1,
							lName2,
							lName3,
							lName4,
							lName5,
							lName6,
							lName7,
							lName8,
							lName9
						),
						Font = GIMS.GUI.Font.Body.SemiBold
				for Item in Labels do
					Item.Font = Font
			)
		)
		rollout	ChildrenRol	"Child controls"	RolledUp:true	(
			PickButton	Child1	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child2	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child3	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child4	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child5	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child6	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child7	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child8	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child9	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child10	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child11	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child12	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child13	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child14	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child15	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child16	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child17	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child18	Width:60	Filter:PickerFilter	AutoDisplay:true
			PickButton	Child19	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
			PickButton	Child20	Width:60	Filter:PickerFilter	AutoDisplay:true
			CheckBox		GUIScrollable			"Can scroll"
			RadioButtons	GUIScrollOrient			"Scrolling orientation"	Labels:#("Vertical", "Horizontal")	Columns:2	Align:#Left	Enabled:false
			on ChildrenRol Open do
				GUIScrollOrient.Enabled = GUIScrollable.Checked
			on Child1 RightClick do
				Child1.Object = undefined
			on Child2 RightClick do
				Child2.Object = undefined
			on Child3 RightClick do
				Child3.Object = undefined
			on Child4 RightClick do
				Child4.Object = undefined
			on Child5 RightClick do
				Child5.Object = undefined
			on Child6 RightClick do
				Child6.Object = undefined
			on Child7 RightClick do
				Child7.Object = undefined
			on Child8 RightClick do
				Child8.Object = undefined
			on Child9 RightClick do
				Child9.Object = undefined
			on Child10 RightClick do
				Child10.Object = undefined
		)
		on buildMesh do
			SetMesh mesh verts:#([0, 0, 0], [0, -10 * ItemSize[2], 0], [10 * ItemSize[1], -10 * ItemSize[2], 0], [10 * ItemSize[1], 0, 0]) faces:#([1, 2, 3], [3, 4, 1])
		on PostLoad do
			GIMSObjectLink = "GIMS.Core.GUI.GUI_Item"
	)
	plugin /*#PC*PATH	GIMS.Core.GUI.GUI_Layout*/ 	SimpleObject 	EGIMS_GUI_Layout			Category:"Dev_GUI" 				Name:"Layout" 								ClassID:#(1487662001, 992301879)		Invisible:true	(
		local	GUIMgr = GIMS.Core.GUIMgr,
				Align = GUIMgr.Align,
				MainWindowSize = GUIMgr.MainWindowSize,
				Modify = GIMS.Core.ArrayOps.Modify,
				Faces = #(
					[1, 2, 3],
					[3, 4, 1]
				),
				BaseVerts = #(
					[0, 0, 0],
					[0, -10 * MainWindowSize.y, 0],
					[10 * MainWindowSize.x, -10 * MainWindowSize.y, 0],
					[10 * MainWindowSize.x, 0, 0]
				),
				BackVerts = #(
					[20, -40, 10],
					[20, -130, 10],
					[110, -130, 10],
					[110, -40, 10]
				),
				HeaderVerts = #(
					[20, 0, 10],
					[20, -170, 10],
					[10 * MainWindowSize.x, -170, 10],
					[10 * MainWindowSize.x, 0, 10]
				),
				BackHeaderVerts = #(
					[110, 0, 10],
					[110, -170, 10],
					[10 * MainWindowSize.x, -170, 10],
					[10 * MainWindowSize.x, 0, 10]
				),
				GenVerts = (BaseVerts + HeaderVerts),
				GenFaces = (Faces + (Modify Faces [3, 3, 3] #Add)),
				MiddleCenter = GIMS.GUI.Align.MiddleCenter,
				Colors = GUIMgr.Colors,
				Transparent = GIMS.GUI.Colour.Transparent
		fn PickerFilter Obj = (
			(IsKindOf Obj EGIMS_GUI_Item)
		)
		fn Updatemesh = (
			if this.HasBackButton then (
				if this.ItemText.Count != 0 then (
					GenVerts = (BaseVerts + BackVerts + BackHeaderVerts)
					GenFaces = (Faces + (Modify Faces ([1, 1, 1] * BaseVerts.Count) #Add) + (Modify Faces ([1, 1, 1] * (BaseVerts.Count + BackVerts.Count)) #Add))
				) else (
					GenVerts = (BaseVerts + BackVerts)
					GenFaces = (Faces + (Modify Faces ([1, 1, 1] * BaseVerts.Count) #Add))
				)
			) else (
				if this.ItemText.Count != 0 then (
					GenVerts = (BaseVerts + HeaderVerts)
					GenFaces = (Faces + (Modify Faces ([1, 1, 1] * BaseVerts.Count) #Add))
				) else (
					GenVerts = BaseVerts
					GenFaces = Faces
				)
			)
		)
		parameters params rollout:params (
			GIMSObjectLink	 	Type:#String		Default:"GIMS.Core.GUI.GUI_Layout"
			Lang	 					Type:#String		UI:Lang							Default:"English"
			CoreTag	 				Type:#String		UI:CoreTag						Default:"Shared"
			ItemText	 			Type:#String		UI:ItemText					Default:"Sample"
			EvtOnLoadCore		Type:#Integer		UI:EvtOnLoadCore			Default:2
			EvtOnLoadWindowOnly	Type:#Boolean		UI:EvtOnLoadWindowOnly		Default:false
			EvtOnCloseCore		Type:#Integer		UI:EvtOnCloseCore			Default:2
			HeaderTextAlign		Type:#Integer		UI:HeaderTextAlign			Default:2
			EvtOnLoad	 			Type:#String		UI:EvtOnLoad					Default:"Null"
			EvtOnClose	 			Type:#String		UI:EvtOnClose					Default:"Null"
			HasBackButton		Type:#Boolean	UI:HasBackButton			Default:false
			StoreInRolloutChain	Type:#Boolean	UI:StoreInRolloutChain		Default:true
			BackColor	 			Type:#Integer		UI:BackColor					Default:1
			ForeColor	 			Type:#Integer		UI:ForeColor					Default:2
			SubItems				Type:#NodeTab	TabSize:10	TabSizeVariable:true	UI: (
				Child1,
				Child2,
				Child3,
				Child4,
				Child5,
				Child6,
				Child7,
				Child8,
				Child9,
				Child10
			)
			on ItemText set txt do
				Updatemesh()
			on HasBackButton set state do
				Updatemesh()
		)
		rollout params "GIMS GUI Layout" (
			EditText		Lang	"Language"
			EditText		CoreTag					"Core tag"		Align:#Center
			RadioButtons	BackColor	 			"Back color"	Labels:Colors[2]	Align:#Left	Columns:2
			RadioButtons	ForeColor	 			"Fore color"		Labels:Colors[2]	Align:#Left	Columns:2
			CheckBox		HasBackButton		"Back button"
			CheckBox		StoreInRolloutChain	"Store in rollout chain"
			Group "Header" (
				EditText		ItemText
				RadioButtons	HeaderTextAlign	"Align"			Labels:Align[2]	Align:#Left
			)
			Group "Events" (
				DotNETControl	lName1	"System.Windows.Forms.Label"	Text:"Load"	TextAlign:MiddleCenter	BackColor:Transparent
				Label			lType1				"Type"			Across:2
				Label			lDef1					"Function"
				RadioButtons	EvtOnLoadCore	Align:#Center	Across:2	Labels:#("Shared", "Game")
				EditText		EvtOnLoad			Align:#Right
				CheckBox		EvtOnLoadWindowOnly	"When new window only"	Align:#Center
				Label			lsp2
				DotNETControl	lName2	"System.Windows.Forms.Label"	Text:"Close"	TextAlign:MiddleCenter	BackColor:Transparent
				Label			lType2				"Type"			Across:2
				Label			lDef2					"Function"
				RadioButtons	EvtOnCloseCore	Align:#Center	Across:2	Labels:#("Shared", "Game")
				EditText		EvtOnClose			Align:#Right
			)
			Group "Child controls" (
				PickButton	Child1	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
				PickButton	Child2	Width:60	Filter:PickerFilter	AutoDisplay:true
				PickButton	Child3	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
				PickButton	Child4	Width:60	Filter:PickerFilter	AutoDisplay:true
				PickButton	Child5	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
				PickButton	Child6	Width:60	Filter:PickerFilter	AutoDisplay:true
				PickButton	Child7	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
				PickButton	Child8	Width:60	Filter:PickerFilter	AutoDisplay:true
				PickButton	Child9	Width:60	Filter:PickerFilter	AutoDisplay:true	Across:2
				PickButton	Child10	Width:60	Filter:PickerFilter	AutoDisplay:true
			)
			on params Open do (
				local	Font = GIMS.GUI.Font.Body.SemiBold
				lName1.Font = Font
				lName2.Font = Font
			)
			on Child1 RightClick do
				Child1.Object = undefined
			on Child2 RightClick do
				Child2.Object = undefined
			on Child3 RightClick do
				Child3.Object = undefined
			on Child4 RightClick do
				Child4.Object = undefined
			on Child5 RightClick do
				Child5.Object = undefined
			on Child6 RightClick do
				Child6.Object = undefined
			on Child7 RightClick do
				Child7.Object = undefined
			on Child8 RightClick do
				Child8.Object = undefined
			on Child9 RightClick do
				Child9.Object = undefined
			on Child10 RightClick do
				Child10.Object = undefined
		)
		on buildMesh do
			SetMesh mesh Verts:GenVerts Faces:GenFaces
		on PostLoad do
			GIMSObjectLink = "GIMS.Core.GUI.GUI_Layout"
	)
	plugin 	Helper 			EGIMS_Dummy 				Category:"Shared_Helpers" 		Name:"Dummy" 								ClassID:#(1236739888, 1959657655)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			Tip	Type:#String	Default:""	UI:Tip
		)
		rollout rol "Dummy helper" (
			label TipLabel "Tip:"
			edittext Tip
		)
	)
	/*Dev END*/
		
	/*IV*/
	
	plugin	Material		GTAIVunimat					Category:"IV_Materials"			Name:"Very old GIMS GTA IV material"	ClassID:#(384348970, 206093280)			Invisible:true	Extends:Standard	ReplaceUI:true	(	
		parameters mdl (
				shtype			type:#Integer		default:1
				shid				type:#Integer		default:1
				diffName2		type:#texturemap
				dirtName		type:#texturemap
				copytex_d2		type:#Integer		default:1
				copytex_dirt	type:#Integer		default:1
				diffcolor			type:#color		default:(color 255 255 255)
				diffName			type:#texturemap
				normName		type:#texturemap
				specName		type:#texturemap
				envName		type:#texturemap
				blendname1	type:#texturemap
				blendname2	type:#texturemap
				blendname3	type:#texturemap
				blendname4	type:#texturemap
				bumppower		type:#Float		default:1
				refpower		type:#Float		default:1
				specpower		type:#Float		default:1
				speccolpower	type:#Float		default:1
				lightpower		type:#Float		default:0
				tbumppower	type:#String	default:"1"
				trefpower		type:#String	default:"1"
				tspecpower		type:#String	default:"1"
				tspeccolpower	type:#String	default:"1"
				tlightpower		type:#String	default:"0"
				thickness		type:#Float		default:0.5
				zshift				type:#Float		default:1
				parallaxscale	type:#Float		default:0.05
				specmask		type:#color	default:(color 255 255 255)
				dirtmask			type:#color	default:(color 255 255 255)
				skincolor			type:#color	default:(color 255 255 255)
				copytex_d			type:#Integer		default:1
				copytex_b			type:#Integer		default:1
				copytex_s			type:#Integer		default:1
				copytex_e			type:#Integer		default:1
				copytex_1			type:#Integer		default:1
				copytex_2			type:#Integer		default:1
				copytex_3			type:#Integer		default:1
				copytex_4			type:#Integer		default:1
				isnew					type:#boolean		default:false
		)
		parameters col (
				m_matgrp	type:#Integer	default:1
				m_matlst	type:#Integer	default:1
				m_unk1		type:#Integer	default:1
				m_unk2		type:#Integer	default:0
				m_unk3		type:#Integer	default:0
		)
		rollout TheMaterial "Old GTA IV material" (
			label l0 "this material's OBSOLETE and UNSUPPORTED. Please, use"
			label l1 "GIMS IV -> Tools -> Material editor"
		)
	)
	plugin	Material		GTA_IV_material				Category:"IV_Materials"			Name:"Old GIMS GTA IV material"		ClassID:#(1525736629, 1087565209)		Invisible:true	Extends:Standard	ReplaceUI:true	(
		fn SetBitmapData = (
			if Have gims_flt then (
				if this.DiffuseMap_1 != undefined then (
					this.DiffuseMap_1.Coords.U_Offset = this.ClipData.x
					this.DiffuseMap_1.Coords.V_Offset = this.ClipData.y
					this.DiffuseMap_1.Coords.U_Tiling = this.ClipData.z
					this.DiffuseMap_1.Coords.V_Tiling = this.ClipData.w
				)
				if this.DiffuseMap_2 != undefined then (
					this.DiffuseMap_2.Coords.U_Offset = this.ClipData.x
					this.DiffuseMap_2.Coords.V_Offset = this.ClipData.y
					this.DiffuseMap_2.Coords.U_Tiling = this.ClipData.z
					this.DiffuseMap_2.Coords.V_Tiling = this.ClipData.w
				)
				if this.NormalMap != undefined then (
					this.NormalMap.Coords.U_Offset = this.ClipData.x
					this.NormalMap.Coords.V_Offset = this.ClipData.y
					this.NormalMap.Coords.U_Tiling = this.ClipData.z
					this.NormalMap.Coords.V_Tiling = this.ClipData.w
				)
				if this.SpecMap != undefined then (
					this.SpecMap.Coords.U_Offset = this.ClipData.x
					this.SpecMap.Coords.V_Offset = this.ClipData.y
					this.SpecMap.Coords.U_Tiling = this.ClipData.z
					this.SpecMap.Coords.V_Tiling = this.ClipData.w
				)
				if this.RefMap != undefined then (
					this.RefMap.Coords.U_Offset = this.ClipData.x
					this.RefMap.Coords.V_Offset = this.ClipData.y
					this.RefMap.Coords.U_Tiling = this.ClipData.z
					this.RefMap.Coords.V_Tiling = this.ClipData.w
				)
				if this.DirtMap != undefined then (
					this.DirtMap.Coords.U_Offset = this.ClipData.x
					this.DirtMap.Coords.V_Offset = this.ClipData.y
					this.DirtMap.Coords.U_Tiling = this.ClipData.z
					this.DirtMap.Coords.V_Tiling = this.ClipData.w
				)
				if this.BlendLayerMap_1 != undefined then (
					this.BlendLayerMap_1.Coords.U_Offset = this.ClipData.x
					this.BlendLayerMap_1.Coords.V_Offset = this.ClipData.y
					this.BlendLayerMap_1.Coords.U_Tiling = this.ClipData.z
					this.BlendLayerMap_1.Coords.V_Tiling = this.ClipData.w
				)
				if this.BlendLayerMap_2 != undefined then (
					this.BlendLayerMap_2.Coords.U_Offset = this.ClipData.x
					this.BlendLayerMap_2.Coords.V_Offset = this.ClipData.y
					this.BlendLayerMap_2.Coords.U_Tiling = this.ClipData.z
					this.BlendLayerMap_2.Coords.V_Tiling = this.ClipData.w
				)
				if this.BlendLayerMap_3 != undefined then (
					this.BlendLayerMap_3.Coords.U_Offset = this.ClipData.x
					this.BlendLayerMap_3.Coords.V_Offset = this.ClipData.y
					this.BlendLayerMap_3.Coords.U_Tiling = this.ClipData.z
					this.BlendLayerMap_3.Coords.V_Tiling = this.ClipData.w
				)
				if this.BlendLayerMap_4 != undefined then (
					this.BlendLayerMap_4.Coords.U_Offset = this.ClipData.x
					this.BlendLayerMap_4.Coords.V_Offset = this.ClipData.y
					this.BlendLayerMap_4.Coords.U_Tiling = this.ClipData.z
					this.BlendLayerMap_4.Coords.V_Tiling = this.ClipData.w
				)
			)
		)
		parameters Params (
			DimmerSetPart1		type:#matrix3			default:(matrix3 [0, 0, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			DimmerSetPart2		type:#matrix3			default:(matrix3 [0, 0, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			DimmerSetPart3		type:#matrix3			default:(matrix3 [0, 0, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			DimmerSetPart4		type:#matrix3			default:(matrix3 [0, 0, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			DimmerSetPart5		type:#matrix3			default:(matrix3 [0, 0, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			CollisionData			type:#matrix3			default:(matrix3 [1, 1, 1] [0, -1, -1] [-1, -1, -1] [-1, -1, -1])
			ShaderData				type:#matrix3			default:(matrix3 [1, 1, 1] [1, 1, 1] [1, 1, -1] [-1, -1, -1])
			MapsLocationData	type:#matrix3			default:(matrix3 [1, 1, 1] [1, 1, 1] [1, 1, 1] [1, -1, -1])
			ColorData				type:#matrix3			default:(matrix3 [255, 255, 255] [255, 255, 255] [255, 255, 255] [255, 255, 255])
			PowerData				type:#matrix3			default:(matrix3 [1, 1, 100] [1, 0, 0.5] [1, 0.05, -1] [-1, -1, -1])
			ClipData					type:#Point4			default:[0, 0, 1, 1]	animatable:true
			DiffuseMap_1			type:#texturemap
			DiffuseMap_2			type:#texturemap
			NormalMap				type:#texturemap
			SpecMap				type:#texturemap
			RefMap					type:#texturemap
			DirtMap					type:#texturemap
			BlendLayerMap_1		type:#texturemap
			BlendLayerMap_2		type:#texturemap
			BlendLayerMap_3		type:#texturemap
			BlendLayerMap_4		type:#texturemap
			IsNewMaterial			type:#boolean			default:false
			/*CollisionData
				m_matgrp	type:#Integer	default:1	
				m_matlst	type:#Integer	default:1	
				m_unk1		type:#Integer	default:1	
			
				m_unk2		type:#Integer	default:0
			*/
			/*ShaderData
				shtype			type:#Integer			default:1	
				shid				type:#Integer			default:1	
				specularfactored
				
				specularcolorfactored
				reflectivepowered
				specular2factored
				
				specular2colorintensityed
				diffuse2specmod
			*/
			/*MapsLocationData
				copytex_d			type:#Integer		default:1				
				copytex_d2		type:#Integer			default:1	
				copytex_b			type:#Integer		default:1				
				
				copytex_s			type:#Integer		default:1				
				copytex_e			type:#Integer		default:1				
				copytex_dirt	type:#Integer			default:1	
				
				copytex_1			type:#Integer		default:1				
				copytex_2			type:#Integer		default:1				
				copytex_3			type:#Integer		default:1				
				
				copytex_4			type:#Integer		default:1				
			*/
			/*ColorData
				diffcolor			type:#color			default:(color 255 255 255)	
				
				specmask		type:#color	default:(color 255 255 255)	
				
				dirtmask			type:#color	default:(color 255 255 255)	
				
				skincolor			type:#color	default:(color 255 255 255)	
			*/
			/*PowerData
				bumppower		type:#Float				default:1	
				refpower		type:#Float				default:1	
				specpower		type:#Float				default:100	
				
				speccolpower	type:#Float				default:1	
				lightpower		type:#Float				default:0	
				thickness		type:#Float				default:0.5	
				
				zshift				type:#Float				default:1	
				parallaxscale	type:#Float				default:0.05	
			*/
			/*Other params
				dirtName		type:#texturemap					
				diffName			type:#texturemap				
				diffName2		type:#texturemap					
				normName		type:#texturemap					
				specName		type:#texturemap					
				envName		type:#texturemap					
				blendname1	type:#texturemap					
				blendname2	type:#texturemap					
				blendname3	type:#texturemap					
				blendname4	type:#texturemap					
				isnew		type:#boolean		default:false
			*/
			on ClipData set tmp do
				SetBitmapData()
			on CollisionData set tmp do (
				if Have gims_flt then (
					if CollisionData[1].y > gims_matgrp[3][tmp[1].x].Count then
						CollisionData = (matrix3 [tmp[1].x, 1, tmp[1].z] tmp[2] tmp[3] tmp[4])
					if
						this.ShowInViewport and
						(
							BlendLayerMap_1 != undefined or
							DiffuseMap_1 != undefined
						)
					then
						delegate.diffuse = (Color ColorData[1].x ColorData[1].y ColorData[1].z)
					else
						delegate.diffuse = gims_matgrp[2][CollisionData[1].x]
				)
			)
			on ShaderData set tmp do (
				if Have gims_flt then (
					if ShaderData[1].y > gims_mdlshaders[2][tmp[1].x].Count then
						ShaderData = (matrix3 [tmp[1].x, 1, tmp[1].z] tmp[2] tmp[3] tmp[4])
				)
			)
			on ColorData set tmp do (
				if Have gims_flt then (
					if
						this.ShowInViewport and
						(
							BlendLayerMap_1 != undefined or
							DiffuseMap_1 != undefined
						)
					then
						delegate.diffuse = (Color ColorData[1].x ColorData[1].y ColorData[1].z)
					else
						delegate.diffuse = gims_matgrp[2][CollisionData[1].x]
				)
			)
			on PowerData set tmp do (
				if Have gims_flt then (
					delegate.bumpmapamount = ((tmp[1].x)*100)
					delegate.reflectionmapamount = ((tmp[1].y)*100)
					delegate.specularLevelMapamount = (tmp[1].z)
					delegate.selfillumination = tmp[2].y
				)
			)
			on DiffuseMap_1 set texmap do (
				if Have gims_flt then (
					if 
						texmap != undefined or
						BlendLayerMap_1 == undefined
					then (
						delegate.opacitymap = undefined
						delegate.diffuseMap = texmap
						if texmap != undefined then (
							BlendLayerMap_1 = undefined
							texmap.coords.realWorldScale = false
							texmap.coords.U_Tiling = 1
							texmap.coords.V_Tiling = 1
							if
								(DoesFileExist texmap.filename) and
								texmap.bitmap.hasAlpha
							then (
								delegate.opacitymap = (copy texmap)
								delegate.opacitymap.monooutput = 2
							)
						)
					)
					if
						this.ShowInViewport and
						(
							BlendLayerMap_1 != undefined or
							DiffuseMap_1 != undefined
						)
					then
						delegate.diffuse = (Color ColorData[1].x ColorData[1].y ColorData[1].z)
					else
						delegate.diffuse = gims_matgrp[2][CollisionData[1].x]
					SetBitmapData()
				)
			)
			on DiffuseMap_2 set texmap do
				SetBitmapData()
			on NormalMap set texmap do (
				if Have gims_flt then (
					if texmap != undefined then
						delegate.bumpMap = (Normal_Bump normal_map:texmap)
					else
						delegate.bumpMap = undefined
					SetBitmapData()
				)
			)
			on SpecMap set texmap do (
				if Have gims_flt then (
					delegate.specularLevelMap = texmap
					SetBitmapData()
				)
			)
			on RefMap set texmap do (
				if Have gims_flt then (
					delegate.reflectionMap = texmap
					SetBitmapData()
				)
			)
			on DirtMap set texmap do
				SetBitmapData()
			on BlendLayerMap_1 set texmap do (
				if Have gims_flt then (
					if
						texmap != undefined or
						DiffuseMap_1 == undefined
					then (
						DiffuseMap_1 = undefined
						delegate.opacitymap = undefined
						delegate.diffuseMap = texmap
						if texmap != undefined then (
							texmap.coords.realWorldScale = false
							texmap.coords.U_Tiling = 1
							texmap.coords.V_Tiling = 1
							if
								(DoesFileExist texmap.filename) and
								texmap.bitmap.hasAlpha
							then (
								delegate.opacitymap = (copy texmap)
								delegate.opacitymap.monooutput = 2
							)
						)
					)
					if
						this.ShowInViewport and
						(
							BlendLayerMap_1 != undefined or
							DiffuseMap_1 != undefined
						)
					then
						delegate.diffuse = (Color ColorData[1].x ColorData[1].y ColorData[1].z)
					else
						delegate.diffuse = gims_matgrp[2][CollisionData[1].x]
					SetBitmapData()
				)
			)
			on BlendLayerMap_2 set texmap do
				SetBitmapData()
			on BlendLayerMap_3 set texmap do
				SetBitmapData()
			on BlendLayerMap_4 set texmap do
				SetBitmapData()
		)
		rollout TheMaterial "GTA IV material" (
			label l0 "this material's only editable through GIMS IV material editor in"
			label l1 "GIMS IV -> Tools -> Material editor"
		)
		fn LoadBitmapFile TheBitmap FileName = (
			if Have gims_flt then (
				local FilePath = (gimsbakpath + "TexturesForGIML\\" + (FileNameFromPath FileName))
				if not (DoesFileExist FilePath) then
					GIMS.Core.SystemMgr.FileCopy TheBitmap.Bitmap.FileName FilePath
			)
		)
		fn PrintMtl IncludeTextures:false = (
			if Have gims_flt then (
				/*<ERRHANDLERSTART>*/try (
					local Res
					if IncludeTextures then (
						local DiffuseMap_1 = "",
								DiffuseMap_2 = "",
								NormalMap = "",
								SpecMap = "",
								RefMap = "",
								DirtMap = "",
								BlendLayerMap_1 = "",
								BlendLayerMap_2 = "",
								BlendLayerMap_3 = "",
								BlendLayerMap_4 = ""
						if this.DiffuseMap_1 != undefined then (
							try
								DiffuseMap_1 = (filenameFromPath (RecastTexturePath this.DiffuseMap_1))
							catch
								DiffuseMap_1 = "DiffuseMap_1.png"
							try (
								LoadBitmapFile this.DiffuseMap_1 DiffuseMap_1
								DiffuseMap_1 = (" DiffuseMap_1:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + DiffuseMap_1 + "\")))	catch undefined)")
							) catch
								DiffuseMap_1 = ""
						)
						if this.DiffuseMap_2 != undefined then (
							try
								DiffuseMap_2 = (filenameFromPath (RecastTexturePath this.DiffuseMap_2))
							catch
								DiffuseMap_2 = "DiffuseMap_2.png"
							try (
								LoadBitmapFile this.DiffuseMap_2 DiffuseMap_2
								DiffuseMap_2 = (" DiffuseMap_2:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + DiffuseMap_2 + "\")))	catch undefined)")
							) catch
								DiffuseMap_2 = ""
						)
						if this.NormalMap != undefined then (
							try
								NormalMap = (filenameFromPath (RecastTexturePath this.NormalMap))
							catch
								NormalMap = "NormalMap.png"
							try (
								LoadBitmapFile this.NormalMap NormalMap
								NormalMap = (" NormalMap:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + NormalMap + "\")))	catch undefined)")
							) catch
								NormalMap = ""
						)
						if this.SpecMap != undefined then (
							try
								SpecMap = (filenameFromPath (RecastTexturePath this.SpecMap))
							catch
								SpecMap = "SpecMap.png"
							try (
								LoadBitmapFile this.SpecMap SpecMap
								SpecMap = (" SpecMap:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + SpecMap + "\")))	catch undefined)")
							) catch
								SpecMap = ""
						)
						if this.RefMap != undefined then (
							try
								RefMap = (filenameFromPath (RecastTexturePath this.RefMap))
							catch
								RefMap = "RefMap.png"
							try (
								LoadBitmapFile this.RefMap RefMap
								RefMap = (" RefMap:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + RefMap + "\")))	catch undefined)")
							) catch
								RefMap = ""
						)
						if this.DirtMap != undefined then (
							try
								DirtMap = (filenameFromPath (RecastTexturePath this.DirtMap))
							catch
								DirtMap = "DirtMap.png"
							try (
								LoadBitmapFile this.DirtMap DirtMap
								DirtMap = (" DirtMap:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + DirtMap + "\")))	catch undefined)")
							) catch
								DirtMap = ""
						)
						if this.BlendLayerMap_1 != undefined then (
							try
								BlendLayerMap_1 = (filenameFromPath (RecastTexturePath this.BlendLayerMap_1))
							catch
								BlendLayerMap_1 = "BlendLayerMap_1.png"
							try (
								LoadBitmapFile this.BlendLayerMap_1 BlendLayerMap_1
								BlendLayerMap_1 = (" BlendLayerMap_1:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + BlendLayerMap_1 + "\")))	catch undefined)")
							) catch
								BlendLayerMap_1 = ""
						)
						if this.BlendLayerMap_2 != undefined then (
							try
								BlendLayerMap_2 = (filenameFromPath (RecastTexturePath this.BlendLayerMap_2))
							catch
								BlendLayerMap_2 = "BlendLayerMap_2.png"
							try (
								LoadBitmapFile this.BlendLayerMap_2 BlendLayerMap_2
								BlendLayerMap_2 = (" BlendLayerMap_2:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + BlendLayerMap_2 + "\")))	catch undefined)")
							) catch
								BlendLayerMap_2 = ""
						)
						if this.BlendLayerMap_3 != undefined then (
							try
								BlendLayerMap_3 = (filenameFromPath (RecastTexturePath this.BlendLayerMap_3))
							catch
								BlendLayerMap_3 = "BlendLayerMap_3.png"
							try (
								LoadBitmapFile this.BlendLayerMap_3 BlendLayerMap_3
								BlendLayerMap_3 = (" BlendLayerMap_3:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + BlendLayerMap_3 + "\")))	catch undefined)")
							) catch
								BlendLayerMap_3 = ""
						)
						if this.BlendLayerMap_4 != undefined then (
							try
								BlendLayerMap_4 = (filenameFromPath (RecastTexturePath this.BlendLayerMap_4))
							catch
								BlendLayerMap_4 = "BlendLayerMap_4.png"
							try (
								LoadBitmapFile this.BlendLayerMap_4 BlendLayerMap_4
								BlendLayerMap_4 = (" BlendLayerMap_4:(try (BitmapTexture Bitmap:(OpenBitmap (GIMLdir + \"" + BlendLayerMap_4 + "\")))	catch undefined)")
							) catch
								BlendLayerMap_4 = ""
						)
						Res = (
							"(GTA_IV_material ShowInViewPort:True" +
							(" CollisionData:" + this.CollisionData as String) +
							(" ShaderData:" + this.ShaderData as String) +
							(" MapsLocationData:" + this.MapsLocationData as String) +
							(" ColorData:" + this.ColorData as String) +
							(" PowerData:" + this.PowerData as String) +
							(" ClipData:" + this.ClipData as String) +
							DiffuseMap_1 +
							DiffuseMap_2 +
							NormalMap +
							SpecMap +
							RefMap +
							DirtMap +
							BlendLayerMap_1 +
							BlendLayerMap_2 +
							BlendLayerMap_3 +
							BlendLayerMap_4 +
							")"
						)
					) else (
						Res = (
							"(GTA_IV_material ShowInViewPort:True" +
							(" CollisionData:" + this.CollisionData as String) +
							(" ShaderData:" + this.ShaderData as String) +
							(" MapsLocationData:" + this.MapsLocationData as String) +
							(" ColorData:" + this.ColorData as String) +
							(" PowerData:" + this.PowerData as String) +
							(" ClipData:" + this.ClipData as String) +
							(
								try
									" DiffuseMap_1:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.DiffuseMap_1) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" DiffuseMap_2:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.DiffuseMap_2) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" NormalMap:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.NormalMap) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" SpecMap:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.SpecMap) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" RefMap:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.RefMap) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" DirtMap:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.DirtMap) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" BlendLayerMap_1:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.BlendLayerMap_1) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" BlendLayerMap_2:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.BlendLayerMap_2) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" BlendLayerMap_3:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.BlendLayerMap_3) + "\"))	catch undefined)"
								catch
									""
							) +
							(
								try
									" BlendLayerMap_4:(try (BitmapTexture Bitmap:(OpenBitmap \"" + (RecastTexturePath this.BlendLayerMap_4) + "\"))	catch undefined))"
								catch
									")"
							)
						)
					)
					Res
				/*<ERRHANDLER>*/) catch (
					append err_text ("CORE->GTA_IV_material::PrintMtl error:"+(getcurrentexception()) as String)
					throw
				)/*<ERRHANDLEREND>*/
			)
		)
		fn AsFormatsText Mode = (
			if Have gims_flt then (
				/*<ERRHANDLERSTART>*/try (
					case Mode of (
						#Bounds:
							(gims_matgrp[3][this.CollisionData[1].x][this.CollisionData[1].y] + " " + ((this.CollisionData[1].z as Integer) - 1) as String + " " + (this.CollisionData[2].x as Integer) as String)
						#Shader:
							undefined
					)
				/*<ERRHANDLER>*/) catch (
					append err_text ("CORE->GTA_IV_material::AsFormatsText error:"+(getcurrentexception()) as String)
					throw
				)/*<ERRHANDLEREND>*/
			)
		)
	)
	plugin	Material		EGIMS_IV_material			Category:"IV_Materials"			Name:"GTA IV material"						ClassID:#(1617192218, 70056743)			Invisible:true	Extends:Standard	ReplaceUI:true	(
		parameters Params (
			NavData					type:#point3			default:[4, 1, 0]
			CollisionData			type:#matrix3			default:(Matrix3 [0, 0, 0] [-1, -1, -1] [-1, -1, -1] [-1, -1, -1])
			ShaderData				type:#matrix3			default:(Matrix3 [1, 1, 1] [1, 1, 1] [1, 1, -1] [-1, -1, -1])
			MapsLocationData	type:#matrix3			default:(Matrix3 [1, 1, 1] [1, 1, 1] [1, 1, 1] [1, 1, -1])
			ColorData				type:#matrix3			default:(Matrix3 [255, 255, 255] [255, 255, 255] [255, 255, 255] [255, 255, 255])
			ColorData2				type:#matrix3			default:(Matrix3 [0, 255, 0] [0, 0, 0] [0, 0, 0] [0, 0, 0])
			PowerData				type:#matrix3			default:(Matrix3 [1, 1, 100] [1, 0, 0.5] [1, 0.04, 1] [-1, -1, -1])
			UOffs						type:#Float				default:0	Animated:true
			VOffs						type:#Float				default:0	Animated:true
			UTile						type:#Float				default:1	Animated:true
			VTile						type:#Float				default:1	Animated:true
			DiffuseMap_1			type:#texturemap
			DiffuseMap_2			type:#texturemap
			NormalMap				type:#texturemap
			SpecMap				type:#texturemap
			RefMap					type:#texturemap
			DirtMap					type:#texturemap
			BlendLayerMap_1		type:#texturemap
			BlendLayerMap_2		type:#texturemap
			BlendLayerMap_3		type:#texturemap
			BlendLayerMap_4		type:#texturemap
			GrassMap				type:#texturemap
		)
		rollout TheMaterial "GTA IV material" (
			label l0 "this material's deprecated"
		)
	)
	
	/*IV end*/
	
	/*AE*/
		
	plugin	Material		EGIMS_AE_material			Category:"AE_Materials"			Name:"GIMS AE material"						ClassID:#(1950911105, 262830903)						Extends:Standard	ReplaceUI:true	(
		parameters Params Rollout:MainRollout (
			DiffMap				Type:#TextureMap
			NormalSpecMap	Type:#TextureMap
			U_Offset			Type:#Float			Default:0 	UI:cU_Offset	Animatable:true
			V_Offset			Type:#Float			Default:0 	UI:cV_Offset	Animatable:true
			U_Tiling				Type:#Float			Default:1 	UI:cU_Tiling	Animatable:true
			V_Tiling				Type:#Float			Default:1 	UI:cV_Tiling	Animatable:true
			Opacity				Type:#Float			Default:1	UI:cOpacity	Animatable:true
			RGBAlpha			Type:#Boolean		Default:false	UI:cRGBAlpha

			on DiffMap set Val do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if
						Have MAXFactory and
						(IsProperty GIMS #AE)
					then (
						local	Maps = (MAXFactory.MaterialOps.HandleMapChanged this Val AllowOpacityMapController:true)
						Delegate.DiffuseMap = Maps[1]
						Delegate.OpacityMap = Maps[2]
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			on NormalSpecMap set Val do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if
						Have MAXFactory and
						(IsProperty GIMS #AE)
					then (
						local	Maps = (MAXFactory.MaterialOps.HandleMapChanged this Val AllowOpacityMapController:false)
						Delegate.BumpMap = (Normal_Bump Normal_Map:Maps[1])
						Delegate.BumpMapAmount = 100
						Delegate.SpecularLevelMap = Maps[2]
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			on RGBAlpha set Val do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if
						Have MAXFactory and
						(IsProperty GIMS #AE)
					then (
						local	FileName = (
									if Have DiffMap then (
										try
											DiffMap.FileName
										catch
											undefined
									)
								)
						if Have FileName then (
							Delegate.OpacityMap = (
								local	TheAlphaMap = (Copy DiffMap)
								MAXFactory.MaterialOps.SetMapControllers this TheAlphaMap AllowOpacity:true
								if not Val then (
									if DiffMap.Bitmap.HasAlpha then
										TheAlphaMap.MonoOutput = 2
									else
										TheAlphaMap = undefined
								)
								TheAlphaMap
							)
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
		)
		rollout MainRollout "Abyss Engine material" (
			Spinner	cOpacity			"Opacity"				Align:#Left		Type:#Float	Range:[0, 1, 1]
			Label	l0						"Textures"				Align:#Center
			Label	l1						"Diffuse"					Align:#Left		Across:2
			Button	cDiffMap				"Empty"					Align:#Right	Width:145	ToolTip:"Empty"
			Label	l2						"Normal"					Align:#Left		Across:2
			Button	cNormalSpecMap	"Empty"					Align:#Right	Width:145	ToolTip:"Empty"
			CheckBox cRGBAlpha		"Alpha from color"		Align:#Right	Checked:false
			Group "UV coordinates" (
				Button	ResetUV		"Reset"	Align:#Center	Height:15
				Label	offs			"Offset"	Across:2
				Label	tile			"Tiling"
				Spinner	cU_Offset	"U"		Align:#Right 	Type:#Float	Range:[-1000, 1000, 0]	Width:50	Across:4
				Spinner	cV_Offset	"V"		Align:#Left 	Type:#Float	Range:[-1000, 1000, 0]	Width:50
				Spinner	cU_Tiling	"U" 		Align:#Right	Type:#Float	Range:[-1000, 1000, 1]	Width:50
				Spinner	cV_Tiling	"V" 		Align:#Left		Type:#Float	Range:[-1000, 1000, 1]	Width:50
			)
						
			on ResetUV pressed do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.MAXFactory.MaterialOps.ResetUV this
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			
			on cDiffMap rightclick do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.MAXFactory.MaterialOps.AlterProperty this #DiffMap undefined ControlRollout:MainRollout MapControl:cDiffMap IsMap:true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			on cNormalSpecMap rightclick do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.MAXFactory.MaterialOps.AlterProperty this #NormalSpecMap undefined ControlRollout:MainRollout MapControl:cDiffMap IsMap:true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			
			on cDiffMap pressed do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.MAXFactory.MaterialOps.OpenMap this DiffMap #DiffMap ControlRollout:MainRollout MapControl:cDiffMap
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			on cNormalSpecMap pressed do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.MAXFactory.MaterialOps.OpenMap this NormalSpecMap #NormalSpecMap ControlRollout:MainRollout MapControl:cNormalSpecMap
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
			
			on MainRollout Open do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if Have MAXFactory then (
						local	Maps = #(
									DiffMap,
									NormalSpecMap
								),
								MapControls = #(
									cDiffMap,
									cNormalSpecMap
								)
						MAXFactory.MaterialOps.UpdateMapButtons MainRollout MapControls Maps
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			)
		)
		on Create do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MAXFactory = GIMS.Core.MAXFactory
				if Have MAXFactory then
					MAXFactory.MaterialOps.InitUV this
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	plugin 	Helper 			EGIMS_AE_Model				Category:"AE_Models" 			Name:"Model" 								ClassID:#(1296876784, 1608362777)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			ModelVersion	Type:#Integer		Default:4 	UI:cModelVersion
			Flags				Type:#BoolTab	TabSize:3	Default:true UI:(UVs, Normals, Colors)
		)
		rollout rol "AE model" (
			RadioButtons	cModelVersion	"Model detail, Animation"			Align:#Left	Labels:#("Low, None", "Low, PRS", "High, PRS+Opacity", "High, PRS+Opacity+UV")	Columns:1
			Group "Data" (
				CheckBox 	UVs 				"UVs"				Align:#Left	Across:2
				CheckBox 	Normals 			"Normals"		Align:#Left
				CheckBox 	Colors 			"Colors"			Align:#Left
			)
		)
	)
	plugin 	Helper 			EGIMS_AE_Collision			Category:"AE_Collisions" 		Name:"Dictionary" 							ClassID:#(656145028, 89170423)			Invisible:true	Extends:Dummy		ReplaceUI:true	(
		rollout rol "AE collision dictionary" (
			Label	Tip	"No properties to assign"
		)
	)
	plugin 	Helper 			EGIMS_AE_CollisionNode		Category:"AE_Collisions" 		Name:"Object" 								ClassID:#(2135088573, 755655015)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			ID	Type:#Integer UI:cID	Default:0
		)
		rollout rol "AE object collision" (
			Spinner	cID	"ID"	Type:#Integer	Range:[0, 9999, 0]	Align:#Left
		)
	)
	plugin 	SimpleObject	EGIMS_AE_Col_Box 			Category:"AE_Collisions" 		Name:"Box" 									ClassID:#(2056925246, 182864860)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	BoxCentricMesh = GIMS.Core.DB.BoxCentricMesh
			if _Faces.Count == 0 then
				_Faces = BoxCentricMesh[2]
			_Verts = (GIMS.Core.ArrayOps.Modify BoxCentricMesh[1] [Width, Depth, Height] #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			Width Type:#worldUnits UI:Width default:2
			Depth Type:#worldUnits UI:Depth default:2
			Height Type:#worldUnits UI:Height default:2
			
			on Width set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Depth set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "AE collision box" (
			spinner Width "Width" Type:#worldunits range:[2,10000,2]
			spinner Depth "Length" Type:#worldunits range:[2,10000,2]
			spinner Height "Height" Type:#worldunits range:[2,10000,2]
		)
	)
	plugin 	SimpleObject 	EGIMS_AE_Col_Sphere 		Category:"AE_Collisions" 		Name:"Sphere" 								ClassID:#(1665001227, 1554906201) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	SphereMesh = GIMS.Core.DB.SphereMesh
			if _Faces.Count == 0 then
				_Faces = SphereMesh[2]
			_Verts = (GIMS.Core.ArrayOps.Modify SphereMesh[1] (Radius * 2) #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			Radius Type:#worldUnits UI:Radius default:1
			
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout rol "AE collision sphere" (
			spinner Radius "Radius" Type:#worldunits range:[0, 10000, 1]
		)
	)
		
	plugin 	Helper 			EGIMS_AE_Weapon				Category:"AE_Weapons" 			Name:"Dictionary" 							ClassID:#(1602612770, 261194825)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		rollout rol "AE ship equipment dictionary" (
			Label	Tip	"No properties to assign"
		)
	)
	plugin 	Helper 			EGIMS_AE_WeaponNode			Category:"AE_Weapons" 			Name:"Ship" 								ClassID:#(696995121, 2139932412)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			ShipID	Type:#Integer	Default:1
			
			on ShipID Set val do
				this.rol.cShipID.Selection = val
		)
		rollout rol "AE ship equipment slots" (
			DropdownList cShipID "Ship"
			
			on cShipID Selected val do
				this.ShipID = val
			on rol Open do (
				local	GIMSAE = (TryGetProperty GIMS #AE)
				if GIMSAE != #GetPropertyFailed then (
					local	Items = #(),
							ShipNames = GIMSAE.Core.DB.ShipModelMap[1]
					for i = ShipNames.Count to 1 by -1 do (
						local	ShipName = ShipNames[i]
						Items[i] = (
							if Have ShipName then
								ShipName
							else
								""
						)
					)
					cShipID.Items = Items
					cShipID.Selection = 1
					cShipID.Selection = ShipID
				)
			)
		)
	)
	plugin 	Helper 			EGIMS_AE_WeaponInstance		Category:"AE_Weapons" 			Name:"Equipment" 							ClassID:#(573902332, 370725879)			Invisible:true	Extends:Dummy		ReplaceUI:true	(
		fn UpdateState = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	trol = this.rol,
					WeaponClass = this.WeaponClass
			trol.cWeaponClass.Selection = WeaponClass
			if WeaponClass == 4 then (
				trol.cSizeX.Enabled = true
				trol.cSizeY.Enabled = true
				trol.cSizeZ.Enabled = true
				local	tSize = this.Size
				delegate.BoxSize = [tSize[1], tSize[2], tSize[3]]
			) else (
				trol.cSizeX.Enabled = false
				trol.cSizeY.Enabled = false
				trol.cSizeZ.Enabled = false
				delegate.BoxSize = [50, 50, 50]
			)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			WeaponClass	Type:#Integer								Default:1
			Size				Type:#WorldUnitsTab	TabSize:3	Default:50	UI:(cSizeX, cSizeY, cSizeZ)
			
			on WeaponClass Set val do
				UpdateState()
			on Size Set val do
				delegate.BoxSize = [Size[1], Size[2], Size[3]]
		)
		rollout rol "AE ship equipment" (
			DropdownList cWeaponClass "Class"
			Group "Size" (
				Label	lX	"X"	Align:#Center Across:3
				Label	lY	"Y"	Align:#Center
				Label	lZ	"Z"	Align:#Center
				Spinner cSizeX "" Type:#worldunits range:[0, 10000, 50]	Align:#Center	FieldWidth:35	Enabled:false Across:3
				Spinner cSizeY "" Type:#worldunits range:[0, 10000, 50]	Align:#Center	FieldWidth:35	Enabled:false
				Spinner cSizeZ "" Type:#worldunits range:[0, 10000, 50]	Align:#Center	FieldWidth:35	Enabled:false
			)
			
			on cWeaponClass Selected val do
				this.WeaponClass = val
			on rol Open do (
				local	GIMSAE = (TryGetProperty GIMS #AE)
				if GIMSAE != #GetPropertyFailed then (
					cWeaponClass.Items = GIMSAE.Core.DB.WeaponClasses
					cWeaponClass.Selection = 1
					UpdateState()
				)
			)
		)
	)
	
	/*AE END*/
	
	/*MP3*/
		
	plugin	Material		EGIMS_MP3_material			Category:"MP3_Materials"		Name:"GIMS MP3 material"					ClassID:#(2137099625, 1876971228)		Invisible:true	Extends:Standard	ReplaceUI:true	(
		local	DelegateLinkedParams = #(
					#bumpiness,
					#bumpsampler,
					#BumpSampler_layer0,
					#diffuseCol,
					#DiffuseSampler,
					#emissivemultiplier,
					#environmentsampler,
					#matDiffuseColor,
					#NormalSampler,
					#normReflectivePower,
					#normSpecMapIntMask,
					#normSpecularFactor,
					#ParallaxScaleBias,
					#reflectivepower,
					#specmapintmask,
					#specsampler,
					#specularcolorfactor,
					#specularfactor,
					#subcolor,
					#TextureGrassSampler,
					#texturesampler,
					#texturesampler_layer0,
					#waterColor
				)
		fn IsDelegateLinkedParam aName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No BSearch then (
					((GIMS.Core.ArrayOps.QuickSearch DelegateLinkedParams (GIMS.Core.ValueOps.TypeCast aName Name)) != 0)
				) else
					(Have (BSearch aName DelegateLinkedParams StriCmp))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateDelegate aName aType vValue = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				aName = (GIMS.Core.ValueOps.TypeCast aName Name)
				if aType == #sp_sampler then (
					if (
						aName == #DiffuseSampler or
						aName == #TextureGrassSampler or
						aName == #texturesampler_layer0 or
						aName == #texturesampler
					) then (
						local	Maps = (GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged this vValue AllowOpacityMapController:true),
								TheAlphaMap = Maps[2]
						Delegate.DiffuseMap = Maps[1]
						Delegate.OpacityMap = TheAlphaMap
					) else (
						if (
							aName == #bumpsampler or
							aName == #BumpSampler_layer0 or
							aName == #NormalSampler
						) then (
							local	Maps = (GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged this vValue AllowOpacityMapController:false),
									TheAlphaMap = Maps[2]
							Delegate.BumpMap = (Normal_Bump Normal_Map:Maps[1])
							Delegate.BumpMapAmount = 100
							if (MatchPattern This.SPSName Pattern:"*parallax*") then
								Delegate.DisplacementMap = TheAlphaMap
							else (
								Delegate.SpecularLevelMap = (
									if Have TheAlphaMap then
										(RGB_Tint Map1:TheAlphaMap Red:White Green:White Blue:White)
								)
							)
						) else (
							if aName == #specsampler then (
								local	Maps = (GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged this vValue AllowOpacityMapController:false)
								Delegate.SpecularLevelMap = (RGB_Tint Map1:Maps[1] Red:White Green:White Blue:White)
							) else (
								if aName == #environmentsampler then (
									local	Maps = (GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged this vValue AllowOpacityMapController:false)
									Delegate.ReflectionMap = Maps[1]
								)
							)
						)
					)
				) else (
					local	IsSpecMapIntMask = (
								aName == #specmapintmask or
								aName == #normSpecMapIntMask
							),
							IsSpecularFactor = (
								aName == #specularfactor or
								aName == #normSpecularFactor
							),
							IsReflectivePower = (
								aName == #reflectivepower or
								aName == #normReflectivePower
							),
							IsDiffuseColor = (
								aName == #diffuseCol or
								aName == #subcolor or
								aName == #matDiffuseColor or
								aName == #waterColor
							)
					case of (
						IsReflectivePower:
							Delegate.ReflectionMapAmount = vValue.x
						IsSpecularFactor:
							Delegate.Glossiness = (vValue.x / 5.12)
						IsDiffuseColor:
							Delegate.Diffuse = (Color (vValue.x * 25.5) (vValue.y * 25.5) (vValue.z * 25.5))
						IsSpecMapIntMask: (
							local	SpecularLevelMap = Delegate.SpecularLevelMap
							if Have SpecularLevelMap then (
								local	vX = (vValue.x * 255),
										vY = (vValue.y * 255),
										vZ = (vValue.z * 255)
								SpecularLevelMap.Red.R = vX
								SpecularLevelMap.Red.G = vX
								SpecularLevelMap.Red.B = vX
								SpecularLevelMap.Green.R = vY
								SpecularLevelMap.Green.G = vY
								SpecularLevelMap.Green.B = vY
								SpecularLevelMap.Blue.R = vZ
								SpecularLevelMap.Blue.G = vZ
								SpecularLevelMap.Blue.B = vZ
							)
						)
						(aName == #ParallaxScaleBias):
							Delegate.DisplacementMapAmount = (vValue.x * 100)
						(aName == #bumpiness):
							Delegate.BumpMapAmount = (vValue.x * 10)
						(aName == #emissivemultiplier):
							Delegate.SelfIllumination = (vValue.x / 2.55)
						(aName == #specularcolorfactor):
							Delegate.SpecularLevelMapAmount = (vValue.x * 100)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType, #vValue), #(aName, aType, vValue)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateDelegateParams = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParamNameGroups = #(
							this.FloatValueNames,
							this.TexValueNames,
							this.Matrix3x4ParamNames,
							this.Matrix4x4ParamNames,
							this.Float2x3ParamNames,
							this.Float4x4ParamNames,
							this.Float4x5ParamNames
						),
						ParamValueGroups = #(
							this.FloatValues,
							this.TexValues,
							this.Matrix3x4Params,
							this.Matrix4x4Params,
							this.Float2x3Params,
							this.Float4x4Params,
							this.Float4x5Params
						),
						ParamGroupTypes = #(
							#sp_float,
							#sp_sampler,
							#sp_matrix3x4,
							#sp_matrix4x4,
							#sp_float2x3,
							#sp_float4x4,
							#sp_float4x5
						)
				for i = 1 to ParamNameGroups.Count do (
					local	ParamNames = ParamNameGroups[i],
							ParamValues = ParamValueGroups[i],
							ParamGroupType = ParamGroupTypes[i]
					for j = 1 to ParamNames.Count do
						UpdateDelegate ParamNames[j] ParamGroupType ParamValues[j]
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SetParam aName aType vValue IsTexInternal:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #sp_float or
							aType == #sp_float2 or
							aType == #sp_float3 or
							aType == #sp_float4
						),
						SuppliedValue = (Supplied vValue)
				if IsBaseType then (
					vValue = (GIMS.Core.ValueOps.TypeCast vValue #P4)
					local	tFloatValues = this.FloatValues,
							LocationData = (GIMS.Core.ArrayOps.AppendMHL #(tFloatValues, this.FloatValueNames) vValue Sorted:true Hash:aName GetFlagWithID:true)
					if not LocationData[1] then
						tFloatValues[LocationData[2]] = vValue
				) else (
					local	HandleArrayParam = true,
							NamesArray, ValuesArray, ValueCount, ValueType
					case aType of (
						#sp_sampler: (
							HandleArrayParam = false
							if SuppliedValue then (
								local	tTexValues = this.TexValues,
										tTexValueNames = this.TexValueNames,
										tTexInternalFlags = this.TexInternalFlags,
										LocationData = (GIMS.Core.ArrayOps.AppendMHL #(tTexValues, tTexValueNames) vValue Sorted:true Hash:aName GetFlagWithID:true),
										Added = LocationData[1],
										ParamID = LocationData[2]
								if Added then (
									if tTexInternalFlags.Count < ParamID then
										tTexInternalFlags[ParamID] = IsTexInternal
									else
										InsertItem IsTexInternal tTexInternalFlags ParamID
								) else (
									tTexValues[ParamID] = vValue
									tTexInternalFlags[ParamID] = IsTexInternal
								)
							) else (
								local	ParamID = (GIMS.Core.ArrayOps.QuickSearch this.TexValueNames aName)
								if ParamID != 0 then
									this.TexInternalFlags[ParamID] = IsTexInternal
								else
									throw "Can't apply texture embed flag - parameter isn't present: " aName
							)
						)
						#sp_matrix3x4: (
							NamesArray = this.Matrix3x4ParamNames
							ValuesArray = this.Matrix3x4Params
							ValueCount = 4
						)
						#sp_matrix4x4: (
							NamesArray = this.Matrix4x4ParamNames
							ValuesArray = this.Matrix4x4Params
							ValueCount = 4
						)
						#sp_float2x3: (
							NamesArray = this.Float2x3ParamNames
							ValuesArray = this.Float2x3Params
							ValueCount = 3
							ValueType = #P3
						)
						#sp_float4x4: (
							NamesArray = this.Float4x4ParamNames
							ValuesArray = this.Float4x4Params
							ValueCount = 4
						)
						#sp_float4x5: (
							NamesArray = this.Float4x5ParamNames
							ValuesArray = this.Float4x5Params
							ValueCount = 5
						)
						Default:
							throw "Unknown SPS param type: " aType
					)
					if HandleArrayParam then (
						local	LocationData = (GIMS.Core.ArrayOps.AppendIfUniq NamesArray aName Sorted:true GetFlagWithID:true),
								Added = LocationData[1],
								ParamID = LocationData[2],
								StartIndex = ((ParamID - 1) * ValueCount)
						if Have ValueType then (
							local	TypeCast = GIMS.Core.ValueOps.TypeCast
							for i = 1 to ValueCount do
								vValue[i] = (TypeCast vValue[i] ValueType)
						)
						if
							Added and
							(ValuesArray.Count / ValueCount) > ParamID
						then (
							for i = 1 to ValueCount do
								InsertItem vValue[i] ValuesArray [StartIndex + i]
						) else (
							for i = ValueCount to 1 by -1 do
								ValuesArray[StartIndex + i] = vValue[i]
						)
					)
				)
				if SuppliedValue then
					UpdateDelegate aName aType vValue
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType, #vValue), #(aName, aType, vValue)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn CheckParam aName aType = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #sp_float or
							aType == #sp_float2 or
							aType == #sp_float3 or
							aType == #sp_float4
						),
						Names = (
							if IsBaseType then
								this.FloatValueNames
							else (
								case aType of (
									#sp_sampler:
										this.TexValueNames
									#sp_matrix3x4:
										this.Matrix3x4ParamNames
									#sp_matrix4x4:
										this.Matrix4x4ParamNames
									#sp_float2x3:
										this.Float2x3ParamNames
									#sp_float4x4:
										this.Float4x4ParamNames
									#sp_float4x5:
										this.Float4x5ParamNames
									Default:
										throw "Unknown SPS param type: " aType
								)
							)
						)
				((GIMS.Core.ArrayOps.QuickSearch Names aName) != 0)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetParam aName aType GetIsTexInternal:false GetParamIDToo:false ParamID:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #sp_float or
							aType == #sp_float2 or
							aType == #sp_float3 or
							aType == #sp_float4
						),
						Result
				if IsBaseType then (
					if not Supplied ParamID then
						ParamID = (GIMS.Core.ArrayOps.QuickSearch this.FloatValueNames aName)
					if ParamID != 0 then
						Result = this.FloatValues[ParamID]
				) else (
					if aType == #sp_sampler then (
						if not Supplied ParamID then
							ParamID = (GIMS.Core.ArrayOps.QuickSearch this.TexValueNames aName)
						if ParamID != 0 then (
							Result = (
								if GetIsTexInternal then
									this.TexInternalFlags[ParamID]
								else
									this.TexValues[ParamID]
							)
						)
					) else (
						local	ParamNames, ParamValues, ValueCount
						case aType of (
							#sp_matrix3x4: (
								ParamNames = this.Matrix3x4ParamNames
								ParamValues = this.Matrix3x4Params
								ValueCount = 4
							)
							#sp_matrix4x4: (
								ParamNames = this.Matrix4x4ParamNames
								ParamValues = this.Matrix4x4Params
								ValueCount = 4
							)
							#sp_float2x3: (
								ParamNames = this.Float2x3ParamNames
								ParamValues = this.Float2x3Params
								ValueCount = 3
							)
							#sp_float4x4: (
								ParamNames = this.Float4x4ParamNames
								ParamValues = this.Float4x4Params
								ValueCount = 4
							)
							#sp_float4x5: (
								ParamNames = this.Float4x5ParamNames
								ParamValues = this.Float4x5Params
								ValueCount = 5
							)
							Default:
								throw "Unknown SPS param type: " aType
						)
						if not Supplied ParamID then
							ParamID = (GIMS.Core.ArrayOps.QuickSearch ParamNames aName)
						if ParamID != 0 then (
							local	StartIndex = ((ParamID - 1) * ValueCount)
							Result = #()
							for i = ValueCount to 1 by -1 do
								Result[i] = ParamValues[StartIndex + i]
						)
					)
				)
				if GetParamIDToo then
					#(Result, ParamID)
				else
					Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn EnsureHaveParams tSPSName DB QuickSearch TypeCast = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DBShaders = DB.Shaders
				if Have DBShaders then (
					local	SPSGroups = DBShaders[3],
								SPS,
								Found = false
					for SPSGroup in SPSGroups while not Found do (
						local	SID = (QuickSearch SPSGroup tSPSName PropertyName:#aName)
						if SID != 0 then (
							SPS = SPSGroup[SID]
							Found = true
						)
					)
					if No SPS then
						throw "Can't find the SPS: " tSPSName
					local	IsEmissive = false
					for SPSParam in SPS.ShaderParameters do (
						local	aName = SPSParam.aName,
								aType = SPSParam.aType
						if not IsEmissive then
							IsEmissive = ((TypeCast aName Name) == #emissivemultiplier)
						if
							SPSParam.isRequired and
							not (CheckParam aName aType)
						then (
							SetParam aName aType (
								if aType != #sp_sampler then
									SPSParam.DefaultValue
							)
						)
					)
					if IsEmissive then
						Delegate.SelfIllumination = 0
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		
		parameters Params Rollout:MainRollout (
			SPSName					Type:#String			Default:"default"
			
			FloatValueNames			Type:#StringTab			TabSizeVariable:true
			FloatValues				Type:#Point4Tab			TabSizeVariable:true
			
			TexValueNames			Type:#StringTab			TabSizeVariable:true
			TexValues				Type:#TextureMapTab		TabSizeVariable:true
			TexInternalFlags		Type:#BoolTab			TabSizeVariable:true
			
			Matrix3x4ParamNames		Type:#StringTab			TabSizeVariable:true
			Matrix3x4Params			Type:#Point3Tab			TabSizeVariable:true
			
			Matrix4x4ParamNames		Type:#StringTab			TabSizeVariable:true
			Matrix4x4Params			Type:#Point4Tab			TabSizeVariable:true
		
			Float2x3ParamNames		Type:#StringTab			TabSizeVariable:true
			Float2x3Params			Type:#Point3Tab			TabSizeVariable:true
			
			Float4x4ParamNames		Type:#StringTab			TabSizeVariable:true
			Float4x4Params			Type:#Point4Tab			TabSizeVariable:true
			
			Float4x5ParamNames		Type:#StringTab			TabSizeVariable:true
			Float4x5Params			Type:#Point4Tab			TabSizeVariable:true

			AlignedVertexFormat	Type:#Boolean	Default:false
			
			U_Offset	Type:#Float	Default:0	Animatable:true
			V_Offset	Type:#Float	Default:0	Animatable:true
			U_Tiling	Type:#Float	Default:1	Animatable:true
			V_Tiling	Type:#Float	Default:1	Animatable:true
			Opacity		Type:#Float	Default:1	Animatable:true
			
			on SPSName set tSPSName do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if
						Have MAXFactory and
						(IsProperty GIMS #MP3)
					then (
						local	DB = (GIMS.Core.CoreOps.TryGetGameDB #MP3)
						if Supplied DB then
							EnsureHaveParams tSPSName DB GIMS.Core.ArrayOps.QuickSearch GIMS.Core.ValueOps.TypeCast
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
		)
		rollout MainRollout "Max Payne 3 material" (
			label l0 "This material's only editable through"	Align:#Left
			label l1 "GIMS Evo MP3 material editor"	Align:#Right
		)
		on Create do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MAXFactory = GIMS.Core.MAXFactory
				if Have MAXFactory then
					MAXFactory.MaterialOps.InitUV this
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	/*models*/
	plugin	Helper 			EGIMS_MP3_ModelDict			Category:"MP3_Models" 			Name:"Dictionary" 							ClassID:#(2005742990, 132796408)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		rollout rol "Max Payne 3 model dictionary" (
			Button		SkelReset		"Revert bone transforms"
			
			fn _SkelReset_HWalk Obj = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if
					(IsKindOf Obj EGIMS_MP3_Model_Bone) and
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
		)
	)
	plugin 	Helper 			EGIMS_MP3_Model				Category:"MP3_Models" 			Name:"Model" 								ClassID:#(1152073805, 1577419771)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			AuthoredOrientation	Type:#Boolean	Default:false					UI:AuthoredOrientation
			LODGroupValues		Type:#FloatTab	Default:9999		TabSize:4	UI:(LODGroupVal1, LODGroupVal2, LODGroupVal3, LODGroupVal4)
		)
		rollout rol "Max Payne 3 model" (
			CheckBox	AuthoredOrientation	"Authored orientation"	Align:#Left
			Group "LOD distances" (
				Label	lLODGroupVal1	"High"	Align:#Right	Across:2
				Spinner	LODGroupVal1	Range:[0, 9999, 9999]	Align:#Center	FieldWidth:50
				Label	lLODGroupVal2	"Med"	Align:#Right	Across:2
				Spinner	LODGroupVal2	Range:[0, 9999, 9999]	Align:#Center	FieldWidth:50
				Label	lLODGroupVal3	"Low"	Align:#Right	Across:2
				Spinner	LODGroupVal3	Range:[0, 9999, 9999]	Align:#Center	FieldWidth:50
				Label	lLODGroupVal4	"VLow"	Align:#Right	Across:2
				Spinner	LODGroupVal4	Range:[0, 9999, 9999]	Align:#Center	FieldWidth:50
			)
			Button		SkelReset		"Revert bone transforms"
			
			fn _SkelReset_HWalk Obj = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if
					(IsKindOf Obj EGIMS_MP3_Model_Bone) and
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
		)
	)
	plugin 	Helper 			EGIMS_MP3_Model_Bone 		Category:"MP3_Models" 			Name:"Bone" 								ClassID:#(71010095, 856569913)			Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			IsInitialTMSet		Type:#Boolean		Default:false
			InitialTM			Type:#Matrix3		Default:(Matrix3 1)
	
			Flags				Type:#BoolTab		Default:false	TabSize:20	UI:(
																									LOCK_ROT_XYZ,
																									LOCK_ROT_X,
																									LOCK_ROT_Y,
																									LOCK_ROT_Z,
																									LIMIT_ROT_X,
																									LIMIT_ROT_Y,
																									LIMIT_ROT_Z,
																									LOCK_TRANS_X,
																									LOCK_TRANS_Y,
																									LOCK_TRANS_Z,
																									LIMIT_TRANS_X,
																									LIMIT_TRANS_Y,
																									LIMIT_TRANS_Z,
																									LOCK_SCALE_X,
																									LOCK_SCALE_Y,
																									LOCK_SCALE_Z,
																									LIMIT_SCALE_X,
																									LIMIT_SCALE_Y,
																									LIMIT_SCALE_Z,
																									INVISIBLE
																								)
			Index				Type:#Integer			Default:0	--collection process parameter
			Id					Type:#Integer			Default:0						UI:Id
			MirrorBoneId	Type:#Integer			Default:0						UI:MirrorBoneId
			TransMin		Type:#FloatTab		Default:0		TabSize:3	UI:(TransMinx, TransMiny, TransMinz)
			TransMax		Type:#FloatTab		Default:1		TabSize:3	UI:(TransMaxx, TransMaxy, TransMaxz)
			RotMin			Type:#FloatTab 		Default:-180	TabSize:3	UI:(RotMinx, RotMiny, RotMinz)
			RotMax			Type:#FloatTab 		Default:180		TabSize:3	UI:(RotMaxx, RotMaxy, RotMaxz)
		)
		rollout rol "Max Payne 3 model bone" (
			spinner Id "ID" type:#Integer range:[0, 65535, 0]
			spinner MirrorBoneId "Mirror bone ID" type:#Integer range:[0, 65535, 0]
			CheckBox	INVISIBLE	"Invisible"	 Align:#Center
			Group "Rotation" (
				CheckBox	LOCK_ROT_XYZ	"Lock all" Align:#Center
				Label l3 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_ROT_X	"X"	 Align:#Center
				CheckBox	LOCK_ROT_Y	"Y"	 Align:#Center
				CheckBox	LOCK_ROT_Z	"Z"	 Align:#Center
				Label l4 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_ROT_X	"X"	 Align:#Center
				CheckBox	LIMIT_ROT_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_ROT_Z	"Z"	 Align:#Center
				Label ll1 "Min XYZ"
				spinner RotMinx Range:[-180, 180, -180]	Align:#Center	FieldWidth:35	Across:3
				spinner RotMiny Range:[-180, 180, -180]	Align:#Center	FieldWidth:35
				spinner RotMinz Range:[-180, 180, -180]	Align:#Center	FieldWidth:35
				Label ll2 "Max XYZ"
				spinner RotMaxx Range:[-180, 180, 180] Align:#Center	FieldWidth:35	Across:3
				spinner RotMaxy Range:[-180, 180, 180] Align:#Center	FieldWidth:35
				spinner RotMaxz Range:[-180, 180, 180] Align:#Center	FieldWidth:35
			)
			Group "Stretch" (
				Label l5 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_SCALE_X	"X"	 Align:#Center
				CheckBox	LOCK_SCALE_Y	"Y"	 Align:#Center
				CheckBox	LOCK_SCALE_Z	"Z"	 Align:#Center
				Label l6 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_SCALE_X	"X"	 Align:#Center
				CheckBox	LIMIT_SCALE_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_SCALE_Z	"Z"	 Align:#Center
			)
			Group "Movement" (
				Label l1 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_TRANS_X	"X"	 Align:#Center
				CheckBox	LOCK_TRANS_Y	"Y"	 Align:#Center
				CheckBox	LOCK_TRANS_Z	"Z"	 Align:#Center
				Label l2 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_TRANS_X	"X"	 Align:#Center
				CheckBox	LIMIT_TRANS_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_TRANS_Z	"Z"	 Align:#Center
				Label ll3 "Min XYZ"
				spinner TransMinx Range:[0, 1, 0] Align:#Center	FieldWidth:35	Across:3
				spinner TransMiny Range:[0, 1, 0] Align:#Center	FieldWidth:35
				spinner TransMinz Range:[0, 1, 0] Align:#Center	FieldWidth:35
				Label ll4 "Max XYZ"
				spinner TransMaxx Range:[0, 1, 1] Align:#Center	FieldWidth:35	Across:3
				spinner TransMaxy Range:[0, 1, 1] Align:#Center	FieldWidth:35
				spinner TransMaxz Range:[0, 1, 1] Align:#Center	FieldWidth:35
			)
		)
	)
	plugin 	SimpleMod 		EGIMS_MP3_Model_BoneMod 	Category:"MP3_Models" 			Name:"Bone" 								ClassID:#(249587354, 385267440)			Invisible:true	(
		parameters params rollout:rol (
			Flags				Type:#BoolTab		Default:false	TabSize:20	UI:(
																									LOCK_ROT_XYZ,
																									LOCK_ROT_X,
																									LOCK_ROT_Y,
																									LOCK_ROT_Z,
																									LIMIT_ROT_X,
																									LIMIT_ROT_Y,
																									LIMIT_ROT_Z,
																									LOCK_TRANS_X,
																									LOCK_TRANS_Y,
																									LOCK_TRANS_Z,
																									LIMIT_TRANS_X,
																									LIMIT_TRANS_Y,
																									LIMIT_TRANS_Z,
																									LOCK_SCALE_X,
																									LOCK_SCALE_Y,
																									LOCK_SCALE_Z,
																									LIMIT_SCALE_X,
																									LIMIT_SCALE_Y,
																									LIMIT_SCALE_Z,
																									INVISIBLE
																								)
			Index				Type:#Integer			Default:0	--collection process parameter
			Id					Type:#Integer			Default:0						UI:Id
			MirrorBoneId	Type:#Integer			Default:0						UI:MirrorBoneId
			TransMin		Type:#FloatTab		Default:0		TabSize:3	UI:(TransMinx, TransMiny, TransMinz)
			TransMax		Type:#FloatTab		Default:1		TabSize:3	UI:(TransMaxx, TransMaxy, TransMaxz)
			RotMin			Type:#FloatTab 		Default:-180	TabSize:3	UI:(RotMinx, RotMiny, RotMinz)
			RotMax			Type:#FloatTab 		Default:180		TabSize:3	UI:(RotMaxx, RotMaxy, RotMaxz)
		)
		rollout rol "Max Payne 3 model bone" (
			spinner Id "ID" type:#Integer range:[0, 65535, 0]
			spinner MirrorBoneId "Mirror bone ID" type:#Integer range:[0, 65535, 0]
			CheckBox	INVISIBLE	"Invisible"	 Align:#Center
			Group "Free rotation" (
				CheckBox	LOCK_ROT_XYZ	"Lock all" Align:#Center
				Label l3 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_ROT_X	"X"	 Align:#Center
				CheckBox	LOCK_ROT_Y	"Y"	 Align:#Center
				CheckBox	LOCK_ROT_Z	"Z"	 Align:#Center
				Label l4 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_ROT_X	"X"	 Align:#Center
				CheckBox	LIMIT_ROT_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_ROT_Z	"Z"	 Align:#Center
				Label ll1 "Min XYZ"
				spinner RotMinx Range:[-180, 180, -180]	Align:#Center	FieldWidth:35	Across:3
				spinner RotMiny Range:[-180, 180, -180]	Align:#Center	FieldWidth:35
				spinner RotMinz Range:[-180, 180, -180]	Align:#Center	FieldWidth:35
				Label ll2 "Max XYZ"
				spinner RotMaxx Range:[-180, 180, 180] Align:#Center	FieldWidth:35	Across:3
				spinner RotMaxy Range:[-180, 180, 180] Align:#Center	FieldWidth:35
				spinner RotMaxz Range:[-180, 180, 180] Align:#Center	FieldWidth:35
			)
			Group "Stretch" (
				Label l5 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_SCALE_X	"X"	 Align:#Center
				CheckBox	LOCK_SCALE_Y	"Y"	 Align:#Center
				CheckBox	LOCK_SCALE_Z	"Z"	 Align:#Center
				Label l6 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_SCALE_X	"X"	 Align:#Center
				CheckBox	LIMIT_SCALE_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_SCALE_Z	"Z"	 Align:#Center
			)
			Group "Movement" (
				Label l1 "Lock"	Across:4 Align:#Left
				CheckBox	LOCK_TRANS_X	"X"	 Align:#Center
				CheckBox	LOCK_TRANS_Y	"Y"	 Align:#Center
				CheckBox	LOCK_TRANS_Z	"Z"	 Align:#Center
				Label l2 "Limit"	Across:4 Align:#Left
				CheckBox	LIMIT_TRANS_X	"X"	 Align:#Center
				CheckBox	LIMIT_TRANS_Y	"Y"	 Align:#Center
				CheckBox	LIMIT_TRANS_Z	"Z"	 Align:#Center
				Label ll3 "Min XYZ"
				spinner TransMinx Range:[0, 1, 0] Align:#Center	FieldWidth:35	Across:3
				spinner TransMiny Range:[0, 1, 0] Align:#Center	FieldWidth:35
				spinner TransMinz Range:[0, 1, 0] Align:#Center	FieldWidth:35
				Label ll4 "Max XYZ"
				spinner TransMaxx Range:[0, 1, 1] Align:#Center	FieldWidth:35	Across:3
				spinner TransMaxy Range:[0, 1, 1] Align:#Center	FieldWidth:35
				spinner TransMaxz Range:[0, 1, 1] Align:#Center	FieldWidth:35
			)
		)
	)
	plugin 	Light 			EGIMS_MP3_Model_Light		Category:"MP3_Models" 			Name:"Light"								ClassID:#(1847700210, 135366740)		Invisible:true	Extends:OmniLight	ReplaceUI:true	(
		parameters params rollout:rol (
			Type						Type:#Integer		Default:1			UI:Type
			TheColor				Type:#Color		Default:White		UI:TheColor
			f28						Type:#Float		Default:1			UI:f28
			f2C						Type:#Float		Default:1			UI:f2C
			f30						Type:#Float		Default:1			UI:f30
			TheDistance			Type:#Float		Default:0			UI:TheDistance
			Range					Type:#Float		Default:0			UI:Range
			CoronaSize				Type:#Float		Default:0			UI:CoronaSize
			HotSpot					Type:#Float		Default:0			UI:GUIHotSpot
			TheFalloff				Type:#Float		Default:0			UI:GUITheFalloff
			TypeFlags				Type:#BoolTab	TabSize:8			Default:false				UI:(
																															mcflag_f1,
																															mcflag_f2,
																															mcflag_f3,
																															mcflag_f4,
																															mcflag_f5,
																															mcflag_f6,
																															mcflag_f7,
																															mcflag_f8
																														)
			CoronaPower			Type:#Float		Default:1			UI:CoronaPower
			f5C						Type:#Float		Default:1			UI:f5C
			f60						Type:#Float		Default:-1			UI:f60
			f64						Type:#Float		Default:-1			UI:f64
			f6A_unknown			Type:#Integer		Default:0			UI:f6A_unknown
			f6C						Type:#Float		Default:-1			UI:f6C
			pLuminescenceHash	Type:#String		Default:""			UI:pLuminescenceHash
			Flags						Type:#BoolTab	TabSize:32			Default:false				UI:(
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
			on Type set val do (
				delegate.Type = #(#Omni, #FreeSpot)[val]
				if val == 2 then (
					this.rol.GUIHotSpot.Enabled = true
					this.rol.GUITheFalloff.Enabled = true
					delegate.HotSpot = HotSpot
					delegate.Falloff = TheFalloff
				) else (
					this.rol.GUIHotSpot.Enabled = false
					this.rol.GUITheFalloff.Enabled = false
				)
			)
			on TheColor set val do
				delegate.Color = val
			on TheDistance set val do
				delegate.FarAttenEnd = (val / 2)
			on Range set val do
				delegate.Multiplier = (val / 10)
			on TheFalloff set val do (
				if Type == 2 then
					delegate.Falloff = val
			)
			on HotSpot set val do (
				if Type == 2 then
					delegate.HotSpot = val
			)
		)
		rollout rol "Max Payne 3 model light" (
			label lnametip1 "Object name's"	Align:#Left
			label lnametip2 "a corona texture name"	Align:#Right
			Label	TypeTip	"Type:"	Across:2
			RadioButtons Type Labels:#("Dot", "Spot") Columns:2
			ColorPicker TheColor "Color" Align:#Right
			Label	pttip	"Projector texture name"
			edittext pLuminescenceHash
			spinner CoronaSize "Corona size" type:#Float range:[0, 10000, 1]
			spinner CoronaPower "Corona power" type:#Float range:[0, 1000, 10]
			Group "Light" (
				spinner TheDistance "Distance" type:#Float range:[0, 6000, 0]
				spinner Range "Range" type:#Float range:[0, 6000, 0]
				spinner GUIHotSpot "Hot spot" type:#Float range:[0, 6000, 1]	Enabled:false
				spinner GUITheFalloff "Falloff" type:#Float range:[0, 6000, 1]	Enabled:false
			)
			Group "Unknown" (
				spinner f28 "f28" type:#Float range:[-100000000,100000000,1]
				spinner f2C "f2c" type:#Float range:[-100000000,100000000,1]
				spinner f30 "f30" type:#Float range:[-100000000,100000000,1]
				spinner f5C "f5C" type:#Float range:[-100000000,100000000,1]
				spinner f60 "f60" type:#Float range:[-100000000,100000000,-1]
				spinner f64 "f64" type:#Float range:[-100000000,100000000,-1]
				spinner f6A_unknown "f6A_unknown" type:#Integer range:[-100000000,100000000,0]
				spinner f6C "f6C" type:#Float range:[-100000000,100000000,-1]
			)
			group "Flags"
			(
				checkbox mcflag_1 "Random flashing"
				checkbox mcflag_2 "Random flashing"
				checkbox mcflag_3 "Hazard flashing"
				checkbox mcflag_4 "Slow hazard flashing"
				checkbox mcflag_5 "Very slow hazard flashing"
				checkbox mcflag_6 "Light at day"
				checkbox mcflag_7 "Light at night" checked:true
				checkbox mcflag_8 "Weak light"
				checkbox mcflag_9 "Very fast hazard flashing"
				checkbox mcflag_10 "Fast hazard flashing"
				checkbox mcflag_11 "Very slow fade in/out"
				checkbox mcflag_12 "Very slow fade in/out"
				checkbox mcflag_13 "Slow fade in/out"
				checkbox mcflag_14 "Hazard flashing"
				checkbox mcflag_15 "Tiny flickering"
				checkbox mcflag_16 "Dynamic shadow"
				checkbox mcflag_17 "Weather - modified color"
				checkbox mcflag_18 "unk 18"	Across:2
				checkbox mcflag_19 "unk 19"
				checkbox mcflag_20 "Show rays"
				checkbox mcflag_21 "No corona reflection"
				checkbox mcflag_22 "unk 22"	Across:2
				checkbox mcflag_23 "unk 23"
				checkbox mcflag_24 "unk 24"	Across:2
				checkbox mcflag_25 "unk 25"
				checkbox mcflag_26 "unk 26"	Across:2
				checkbox mcflag_27 "unk 27"
				checkbox mcflag_28 "unk 28"	Across:2
				checkbox mcflag_29 "unk 29"
				checkbox mcflag_30 "unk 30"	Across:2
				checkbox mcflag_31 "unk 31"
				checkbox mcflag_32 "unk 32"
			)
			group "Type flags"
			(
				checkbox mcflag_f1 "5sec on - 3sec flicker"
				checkbox mcflag_f2 "5sec on - 3sec flicker"
				checkbox mcflag_f3 "on/off by 1sec"
				checkbox mcflag_f4 "off"
				checkbox mcflag_f5 "unk 5"
				checkbox mcflag_f6 "unk 6"
				checkbox mcflag_f7 "unk 7"
				checkbox mcflag_f8 "unk 8"
			)
			on rol open do (
				if Type == 2 then (
					GUIHotSpot.Enabled = true
					GUITheFalloff.Enabled = true
				) else (
					GUIHotSpot.Enabled = false
					GUITheFalloff.Enabled = false
				)
			)
		)
		on Create do (
			delegate.UseFarAtten = true
			delegate.ShowFarAtten = true
			delegate.FarAttenStart = 0
		)
	)
	plugin 	SimpleMod 		EGIMS_MP3_Model_LightMod	Category:"MP3_Models" 			Name:"Light"								ClassID:#(1636225929, 1920411455)		Invisible:true	(
		parameters params rollout:rol (
			ParentObj				Type:#maxObject
			Type						Type:#Integer		Default:1			UI:Type
			TheColor				Type:#Color		Default:White		UI:TheColor
			f28						Type:#Float		Default:1			UI:f28
			f2C						Type:#Float		Default:1			UI:f2C
			f30						Type:#Float		Default:1			UI:f30
			TheDistance			Type:#Float		Default:0			UI:TheDistance
			Range					Type:#Float		Default:0			UI:Range
			CoronaSize				Type:#Float		Default:0			UI:CoronaSize
			HotSpot					Type:#Float		Default:0			UI:GUIHotSpot
			TheFalloff				Type:#Float		Default:0			UI:GUITheFalloff
			TypeFlags				Type:#BoolTab	TabSize:8			Default:false				UI:(
																															mcflag_f1,
																															mcflag_f2,
																															mcflag_f3,
																															mcflag_f4,
																															mcflag_f5,
																															mcflag_f6,
																															mcflag_f7,
																															mcflag_f8
																														)
			CoronaPower			Type:#Float		Default:1			UI:CoronaPower
			f5C						Type:#Float		Default:1			UI:f5C
			f60						Type:#Float		Default:-1			UI:f60
			f64						Type:#Float		Default:-1			UI:f64
			f6A_unknown			Type:#Integer		Default:0			UI:f6A_unknown
			f6C						Type:#Float		Default:-1			UI:f6C
			pLuminescenceHash	Type:#String		Default:""			UI:pLuminescenceHash
			Flags						Type:#BoolTab	TabSize:32			Default:false				UI:(
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
			on Type set val do (
				if Have ParentObj then (
					ParentObj.Type = #(#Omni, #FreeSpot)[val]
					if val == 2 then (
						this.rol.GUIHotSpot.Enabled = true
						this.rol.GUITheFalloff.Enabled = true
						ParentObj.HotSpot = HotSpot
						ParentObj.Falloff = TheFalloff
					) else (
						this.rol.GUIHotSpot.Enabled = false
						this.rol.GUITheFalloff.Enabled = false
					)
				)
			)
			on TheColor set val do (
				if Have ParentObj then
					ParentObj.Color = val
			)
			on TheDistance set val do (
				if Have ParentObj then
					ParentObj.FarAttenEnd = (val / 2)
			)
			on Range set val do (
				if Have ParentObj then
					ParentObj.Multiplier = (val / 10)
			)
			on TheFalloff set val do (
				if
					Have ParentObj and
					Type == 2
				then
					ParentObj.Falloff = val
			)
			on HotSpot set val do (
				if
					Have ParentObj and
					Type == 2
				then
					ParentObj.HotSpot = val
			)
		)
		rollout rol "Max Payne 3 model light" (
			label lnametip1 "Object name's"	Align:#Left
			label lnametip2 "a corona texture name"	Align:#Right
			Label	TypeTip	"Type:"	Across:2
			RadioButtons Type Labels:#("Dot", "Spot") Columns:2
			ColorPicker TheColor "Color" Align:#Right
			Label	pttip	"Projector texture name"
			edittext pLuminescenceHash
			spinner CoronaSize "Corona size" type:#Float range:[0, 10000, 1]
			spinner CoronaPower "Corona power" type:#Float range:[0, 1000, 10]
			Group "Light" (
				spinner TheDistance "Distance" type:#Float range:[0, 6000, 0]
				spinner Range "Range" type:#Float range:[0, 6000, 0]
				spinner GUIHotSpot "Hot spot" type:#Float range:[0, 6000, 1]	Enabled:false
				spinner GUITheFalloff "Falloff" type:#Float range:[0, 6000, 1]	Enabled:false
			)
			Group "Unknown" (
				spinner f28 "f28" type:#Float range:[-100000000,100000000,1]
				spinner f2C "f2c" type:#Float range:[-100000000,100000000,1]
				spinner f30 "f30" type:#Float range:[-100000000,100000000,1]
				spinner f5C "f5C" type:#Float range:[-100000000,100000000,1]
				spinner f60 "f60" type:#Float range:[-100000000,100000000,-1]
				spinner f64 "f64" type:#Float range:[-100000000,100000000,-1]
				spinner f6A_unknown "f6A_unknown" type:#Integer range:[-100000000,100000000,0]
				spinner f6C "f6C" type:#Float range:[-100000000,100000000,-1]
			)
			group "Flags"
			(
				checkbox mcflag_1 "Random flashing"
				checkbox mcflag_2 "Random flashing"
				checkbox mcflag_3 "Hazard flashing"
				checkbox mcflag_4 "Slow hazard flashing"
				checkbox mcflag_5 "Very slow hazard flashing"
				checkbox mcflag_6 "Light at day"
				checkbox mcflag_7 "Light at night" checked:true
				checkbox mcflag_8 "Weak light"
				checkbox mcflag_9 "Very fast hazard flashing"
				checkbox mcflag_10 "Fast hazard flashing"
				checkbox mcflag_11 "Very slow fade in/out"
				checkbox mcflag_12 "Very slow fade in/out"
				checkbox mcflag_13 "Slow fade in/out"
				checkbox mcflag_14 "Hazard flashing"
				checkbox mcflag_15 "Tiny flickering"
				checkbox mcflag_16 "Dynamic shadow"
				checkbox mcflag_17 "Weather - modified color"
				checkbox mcflag_18 "unk 18"	Across:2
				checkbox mcflag_19 "unk 19"
				checkbox mcflag_20 "Show rays"
				checkbox mcflag_21 "No corona reflection"
				checkbox mcflag_22 "unk 22"	Across:2
				checkbox mcflag_23 "unk 23"
				checkbox mcflag_24 "unk 24"	Across:2
				checkbox mcflag_25 "unk 25"
				checkbox mcflag_26 "unk 26"	Across:2
				checkbox mcflag_27 "unk 27"
				checkbox mcflag_28 "unk 28"	Across:2
				checkbox mcflag_29 "unk 29"
				checkbox mcflag_30 "unk 30"	Across:2
				checkbox mcflag_31 "unk 31"
				checkbox mcflag_32 "unk 32"
			)
			group "Type flags"
			(
				checkbox mcflag_f1 "5sec on - 3sec flicker"
				checkbox mcflag_f2 "5sec on - 3sec flicker"
				checkbox mcflag_f3 "on/off by 1sec"
				checkbox mcflag_f4 "off"
				checkbox mcflag_f5 "unk 5"
				checkbox mcflag_f6 "unk 6"
				checkbox mcflag_f7 "unk 7"
				checkbox mcflag_f8 "unk 8"
			)
			fn Init = (
				if Type == 2 then (
					GUIHotSpot.Enabled = true
					GUITheFalloff.Enabled = true
				) else (
					GUIHotSpot.Enabled = false
					GUITheFalloff.Enabled = false
				)
			)
			on rol open do (
				if Have ParentObj then
					Init()
			)
		)
		fn Init Obj = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			ParentObj = Obj
			ParentObj.UseFarAtten = true
			ParentObj.ShowFarAtten = true
			ParentObj.FarAttenStart = 0
			TheColor = ParentObj.Color
			TheDistance = (ParentObj.FarAttenEnd * 2)
			Range = (ParentObj.Multiplier * 10)
			local	IsSpot = true
			case ParentObj.Type of (
				#FreeSpot:
					Type = 2
				#TargetSpot:
					Type = 2
				Default: (
					IsSpot = false
					Type = 1
				)
			)
			if IsSpot then (
				TheFalloff = ParentObj.Falloff
				HotSpot = ParentObj.HotSpot
			)
			this.rol.Init()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	plugin 	SimpleMod 		EGIMS_MP3_ModelMesh			Category:"MP3_Models"			Name:"Game mesh"							ClassID:#(1101661505, 1129624471)		Invisible:true	(
		parameters Params rollout:Rol (
			Type						Type:#Integer	Default:1		UI:Type
		)
		rollout Rol "Max Payne 3 model mesh" (
			RadioButtons Type "Level of detail" Labels:#("High", "Medium", "Low", "Very low") Columns:2
		)
	)
	
	/*textures*/
	plugin	Helper 			EGIMS_MP3_TexDict			Category:"MP3_Graphics" 		Name:"Texture Dictionary" 					ClassID:#(1605294882, 1040646913)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			ObjList	Type:#NodeTab	TabSizeVariable:true
		)
		rollout rol "Max Payne 3 texture dictionary" (
			MultiListBox	cObjList	"Models"				Height:20	Align:#Center
			Button			bnAdd	"Add"					Width:65	Align:#Left							Across:2
			Button			bnDel		"Remove"			Width:65	Align:#Right	Enabled:false
			Button			bnSel		"Select in scene"	Width:135	Align:#Center	Enabled:false
			
			fn UpdateObjList = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				local	ObjListCount = ObjList.Count,
						Items = #(),
						ItemCount = 0
				Items.Count = ObjListCount
				for i = 1 to ObjListCount do (
					local	Obj = ObjList[i]
					if
						Have Obj and
						not (IsDeleted Obj)
					then (
						ItemCount += 1
						Items[ItemCount] = Obj.Name
					)
				)
				Items.Count = ItemCount
				cObjList.Items = Items
				cObjList.Selection = 0
				bnSel.Enabled = false
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cObjList SelectionEnd do (
				local	Enabled = (cObjList.Selection.NumberSet != 0)
				bnDel.Enabled = Enabled
				bnSel.Enabled = Enabled
			)
			on bnDel Pressed do (
				local	cObjListSelection = cObjList.Selection
				for i = cObjListSelection.Count to 1 by -1 where cObjListSelection[i] do
					DeleteItem ObjList i
				UpdateObjList()
			)
			fn FilterFn Obj = (
				(
					(FindItem ObjList Obj) == 0 and (
						(IsKindOf Obj EGIMS_MP3_ModelDict) or (
							(IsKindOf Obj EGIMS_MP3_Model) and
							not (IsKindOf Obj.Parent EGIMS_MP3_ModelDict)
						)
					)
				)
			)
			on bnAdd Pressed do (
				undo "Select texture dictionary items" on (
					local	Objs = (SelectByName Title:"Select models to use in texture dictionary" Filter:FilterFn ShowHidden:false Single:False)
					if Have Objs then (
						for Obj in Objs do
							Append ObjList Obj
					)
					UpdateObjList()
				)
			)
			on bnSel Pressed do (
				ClearSelection()
				for i in cObjList.Selection do
					SelectMore ObjList[i]
			)
			on rol Open do
				UpdateObjList()
		)
	)
	
	/*MP3 END*/
	
	/*V*/
		
	plugin	Material		EGIMS_V_material			Category:"V_Materials"			Name:"GIMS V material"	ClassID:#(1928993219, 1015109671)		Invisible:false	Extends:Standard	ReplaceUI:true	(
		local	DelegateLinkedParams, DelegateLinkMults, DelegateLinkTypes
		fn UpdateDelegateLinks = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MAXFactory = (GIMS.Core.CoreOps.TryGetGameMAXFactory #V)
				if Supplied MAXFactory then (
					DelegateLinkedParams = MAXFactory.DelegateLinkedParams
					DelegateLinkMults = MAXFactory.DelegateLinkMults
					DelegateLinkTypes = MAXFactory.DelegateLinkTypes
					true
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetDelegateLinkID aName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				try (
					(GIMS.Core.ArrayOps.QuickSearch DelegateLinkedParams (GIMS.Core.ValueOps.TypeCast aName Name))
				) catch
					(FindItem DelegateLinkedParams ((aName as String) as Name))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn IsDelegateLinkedParam aName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No BSearch then
					((GetDelegateLinkID aName) != 0)
				else
					(Have (BSearch aName DelegateLinkedParams StriCmp))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateDelegate aName aType vValue HandleMapChanged:unsupplied TypeCast:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if (UpdateDelegateLinks()) then (
					if not Supplied HandleMapChanged then (
						HandleMapChanged = GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged
						TypeCast = GIMS.Core.ValueOps.TypeCast
					)
					local	LinkID = (GetDelegateLinkID (TypeCast aName Name))
					if LinkID != 0 then (
						local	ValMult = DelegateLinkMults[LinkID],
								Val = (
									if Supplied ValMult then
										vValue * ValMult
									else
										vValue
								)
						case DelegateLinkTypes[LinkID] of (
							#DiffuseSampler	    : (
								if aType == #svt_sampler then (
									local	Maps = (HandleMapChanged this vValue AllowOpacityMapController:true),
											TheAlphaMap = Maps[2]
									Delegate.DiffuseMap = Maps[1]
									Delegate.OpacityMap = TheAlphaMap
								)
							)	
							
							/*TODO maybe for blend preview
							#DiffuseSampler_L0	: (
								if aType == #svt_sampler then (
								)
							)
							#DiffuseSampler_L1	: (
								if aType == #svt_sampler then (
								)
							)
							#DiffuseSampler_L2	: (
								if aType == #svt_sampler then (
								)
							)
							#DiffuseSampler_L3	: (
								if aType == #svt_sampler then (
								)
							)
							*/
							
							#bumpsampler	    : (
								if aType == #svt_sampler then (
									local	Maps = (HandleMapChanged this vValue AllowOpacityMapController:false),
											TheAlphaMap = Maps[2]
									Delegate.BumpMap = (Normal_Bump Normal_Map:Maps[1])
									Delegate.BumpMapAmount = 100
									if (MatchPattern This.SPSName Pattern:"*parallax*") then
										Delegate.DisplacementMap = TheAlphaMap
									else (
										Delegate.SpecularLevelMap = (
											if Have TheAlphaMap then
												(RGB_Tint Map1:TheAlphaMap Red:White Green:White Blue:White)
										)
									)
								)
							)
							
							/*TODO maybe for blend preview
							#BumpSampler_L0	    : (
								if aType == #svt_sampler then (
								)
							)
							#BumpSampler_L1	    : (
								if aType == #svt_sampler then (
								)
							)
							#BumpSampler_L2	    : (
								if aType == #svt_sampler then (
								)
							)
							#BumpSampler_L3	    : (
								if aType == #svt_sampler then (
								)
							)
							*/
							
							#specsampler	    : (
								if aType == #svt_sampler then (
									local	Maps = (HandleMapChanged this vValue AllowOpacityMapController:false)
									Delegate.SpecularLevelMap = (RGB_Tint Map1:Maps[1] Red:White Green:White Blue:White)
								)
							)
							
							#ReflSampler	        : (
								if aType == #svt_sampler then (
									local	Maps = (HandleMapChanged this vValue AllowOpacityMapController:false)
									Delegate.ReflectionMap = Maps[1]
								)
							)
							
							/*TODO maybe for blend preview
							#heightSampler	    : (
								if aType == #svt_sampler then (
								)
							)
							#HeightSampler_L0	: (
								if aType == #svt_sampler then (
								)
							)
							#HeightSampler_L1	: (
								if aType == #svt_sampler then (
								)
							)
							#HeightSampler_L2	: (
								if aType == #svt_sampler then (
								)
							)
							#HeightSampler_L3	: (
								if aType == #svt_sampler then (
								)
							)
							*/
							
							#specmapintmask	    : (
								if aType != #svt_sampler then (
									local	SpecularLevelMap = Delegate.SpecularLevelMap
									if Have SpecularLevelMap then (
										local	vX = Val.x,
												vY = Val.y,
												vZ = Val.z
										SpecularLevelMap.Red.R = vX
										SpecularLevelMap.Red.G = vX
										SpecularLevelMap.Red.B = vX
										SpecularLevelMap.Green.R = vY
										SpecularLevelMap.Green.G = vY
										SpecularLevelMap.Green.B = vY
										SpecularLevelMap.Blue.R = vZ
										SpecularLevelMap.Blue.G = vZ
										SpecularLevelMap.Blue.B = vZ
									)
								)
							)
							
							#BumpMult	        : (
								if aType != #svt_sampler then (
									Delegate.BumpMapAmount = Val.x
									Delegate.DisplacementMapAmount = Val.x
								)
							)
							#SpecMult	        : (
								if aType != #svt_sampler then (
									local	v = Val.x
									Delegate.SpecularLevel = v
									Delegate.SpecularLevelMapAmount = v
								)
							)
							#SpecFalloffMult	    : (
								if aType != #svt_sampler then (
									Delegate.Glossiness = Val.x
								)
							)
							#SpecIntensity	    : (
								if aType != #svt_sampler then (
									Delegate.SpecularLevel = Val.x
								)
							)
							#ReflMult	        : (
								if aType != #svt_sampler then (
									Delegate.ReflectionMapAmount = Val.x
								)
							)
							#EmissiveMult	    : (
								if aType != #svt_sampler then (
									Delegate.SelfIllumination = Val.x
								)
							)
							
							#diffuseColor	    : (
								if aType != #svt_sampler then (
									Delegate.Diffuse = (Color Val.x Val.y Val.z)
								)
							)
							#SpecColor	        : (
								if aType != #svt_sampler then (
									Delegate.Specular = (Color Val.x Val.y Val.z)
								)
							)
						)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType, #vValue), #(aName, aType, vValue)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateDelegateParams = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if (UpdateDelegateLinks()) then (
					local	HandleMapChanged = GIMS.Core.MAXFactory.MaterialOps.HandleMapChanged,
							TypeCast = GIMS.Core.ValueOps.TypeCast,
							ParamNameGroups = #(
								this.FloatValueNames,
								this.TexValueNames,
								this.Matrix3x4ParamNames,
								this.Matrix44ParamNames,
								this.Float2x3ParamNames,
								this.Float4x2ParamNames,
								this.Float4x4ParamNames,
								this.Float4x5ParamNames
							),
							ParamValueGroups = #(
								this.FloatValues,
								this.TexValues,
								this.Matrix3x4Params,
								this.Matrix44Params,
								this.Float2x3Params,
								this.Float4x2Params,
								this.Float4x4Params,
								this.Float4x5Params
							),
							ParamGroupTypes = #(
								#svt_float,
								#svt_sampler,
								#svt_matrix3x4,
								#svt_matrix44,
								#svt_float2x3,
								#svt_float4x2,
								#svt_float4x4,
								#svt_float4x5
							)
					for i = 1 to ParamNameGroups.Count do (
						local	ParamNames = ParamNameGroups[i],
								ParamValues = ParamValueGroups[i],
								ParamGroupType = ParamGroupTypes[i]
						for j = 1 to ParamNames.Count do
							UpdateDelegate ParamNames[j] ParamGroupType ParamValues[j] HandleMapChanged:HandleMapChanged TypeCast:TypeCast
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SetParam aName aType vValue IsTexInternal:false TheTexParams:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #svt_float or
							aType == #svt_float2 or
							aType == #svt_float3 or
							aType == #svt_float4
						),
						SuppliedValue = (Supplied vValue)
				if IsBaseType then (
					vValue = (GIMS.Core.ValueOps.TypeCast vValue #P4)
					local	tFloatValues = this.FloatValues,
							LocationData = (GIMS.Core.ArrayOps.AppendMHL #(tFloatValues, this.FloatValueNames) vValue Sorted:true Hash:aName GetFlagWithID:true)
					if not LocationData[1] then
						tFloatValues[LocationData[2]] = vValue
				) else (
					local	HandleArrayParam = true,
							NamesArray, ValuesArray, ValueCount, ValueType
					case aType of (
						#svt_sampler: (
							HandleArrayParam = false
							if SuppliedValue then (
								local	tTexValues = this.TexValues,
										tTexValueNames = this.TexValueNames,
										tTexInternalFlags = this.TexInternalFlags,
										tTexParams = this.TexParams,
										LocationData = (GIMS.Core.ArrayOps.AppendMHL #(tTexValues, tTexValueNames) vValue Sorted:true Hash:aName GetFlagWithID:true),
										Added = LocationData[1],
										ParamID = LocationData[2]
								if Added then (
									if tTexInternalFlags.Count < ParamID then (
										tTexInternalFlags[ParamID] = IsTexInternal
										if Supplied TheTexParams then
											tTexParams[ParamID] = TheTexParams
										else
											tTexParams[ParamID] = (Matrix3 [1, 1, 1] [0, 0, -1] [-1, -1, -1] [-1, -1, -1])
									) else (
										InsertItem IsTexInternal tTexInternalFlags ParamID
										if Supplied TheTexParams then
											InsertItem TheTexParams tTexParams ParamID
										else
											InsertItem (Matrix3 [1, 1, 1] [0, 0, -1] [-1, -1, -1] [-1, -1, -1]) tTexParams ParamID
									)
								) else (
									tTexValues[ParamID] = vValue
									if Supplied IsTexInternal then
										tTexInternalFlags[ParamID] = IsTexInternal
									if Supplied TheTexParams then
										this.TexParams[ParamID] = TheTexParams
								)
							) else (
								local	ParamID = (GIMS.Core.ArrayOps.QuickSearch this.TexValueNames aName)
								if ParamID != 0 then (
									if Supplied IsTexInternal then
										this.TexInternalFlags[ParamID] = IsTexInternal
									if Supplied TheTexParams then
										this.TexParams[ParamID] = TheTexParams
								) else
									throw "Can't apply texture embed flag - parameter isn't present: " aName
							)
						)
						#svt_matrix3x4: (
							NamesArray = this.Matrix3x4ParamNames
							ValuesArray = this.Matrix3x4Params
							ValueCount = 4
						)
						#svt_matrix44: (
							NamesArray = this.Matrix44ParamNames
							ValuesArray = this.Matrix44Params
							ValueCount = 4
						)
						#svt_float2x3: (
							NamesArray = this.Float2x3ParamNames
							ValuesArray = this.Float2x3Params
							ValueCount = 3
							ValueType = #P3
						)
						#svt_float4x2: (
							NamesArray = this.Float4x2ParamNames
							ValuesArray = this.Float4x2Params
							ValueCount = 2
						)
						#svt_float4x4: (
							NamesArray = this.Float4x4ParamNames
							ValuesArray = this.Float4x4Params
							ValueCount = 4
						)
						#svt_float4x5: (
							NamesArray = this.Float4x5ParamNames
							ValuesArray = this.Float4x5Params
							ValueCount = 5
						)
						Default:
							throw "Unknown SPS param type: " aType
					)
					if HandleArrayParam then (
						local	LocationData = (GIMS.Core.ArrayOps.AppendIfUniq NamesArray aName Sorted:true GetFlagWithID:true),
								Added = LocationData[1],
								ParamID = LocationData[2],
								StartIndex = ((ParamID - 1) * ValueCount)
						if Have ValueType then (
							local	TypeCast = GIMS.Core.ValueOps.TypeCast
							for i = 1 to ValueCount do
								vValue[i] = (TypeCast vValue[i] ValueType)
						)
						if
							Added and
							(ValuesArray.Count / ValueCount) > ParamID
						then (
							for i = 1 to ValueCount do
								InsertItem vValue[i] ValuesArray [StartIndex + i]
						) else (
							for i = ValueCount to 1 by -1 do
								ValuesArray[StartIndex + i] = vValue[i]
						)
					)
				)
				if SuppliedValue then
					UpdateDelegate aName aType vValue
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType, #vValue), #(aName, aType, vValue)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn CheckParam aName aType = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #svt_float or
							aType == #svt_float2 or
							aType == #svt_float3 or
							aType == #svt_float4
						),
						Names = (
							if IsBaseType then
								this.FloatValueNames
							else (
								case aType of (
									#svt_sampler:
										this.TexValueNames
									#svt_matrix3x4:
										this.Matrix3x4ParamNames
									#svt_matrix44:
										this.Matrix44ParamNames
									#svt_float2x3:
										this.Float2x3ParamNames
									#svt_float4x2:
										this.Float4x2ParamNames
									#svt_float4x4:
										this.Float4x4ParamNames
									#svt_float4x5:
										this.Float4x5ParamNames
									Default:
										throw "Unknown SPS param type: " aType
								)
							)
						)
				((GIMS.Core.ArrayOps.QuickSearch Names aName) != 0)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetParam aName aType GetIsTexInternal:false GetTexParams:false GetParamIDToo:false ParamID:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsBaseType = (
							aType == #svt_float or
							aType == #svt_float2 or
							aType == #svt_float3 or
							aType == #svt_float4
						),
						Result
				if IsBaseType then (
					if not Supplied ParamID then
						ParamID = (GIMS.Core.ArrayOps.QuickSearch this.FloatValueNames aName)
					if ParamID != 0 then
						Result = this.FloatValues[ParamID]
				) else (
					if aType == #svt_sampler then (
						if not Supplied ParamID then
							ParamID = (GIMS.Core.ArrayOps.QuickSearch this.TexValueNames aName)
						if ParamID != 0 then (
							Result = (
								if GetIsTexInternal then
									this.TexInternalFlags[ParamID]
								else
									this.TexValues[ParamID]
							)
						)
					) else (
						local	ParamNames, ParamValues, ValueCount
						case aType of (
							#svt_matrix3x4: (
								ParamNames = this.Matrix3x4ParamNames
								ParamValues = this.Matrix3x4Params
								ValueCount = 4
							)
							#svt_matrix44: (
								ParamNames = this.Matrix44ParamNames
								ParamValues = this.Matrix44Params
								ValueCount = 4
							)
							#svt_float2x3: (
								ParamNames = this.Float2x3ParamNames
								ParamValues = this.Float2x3Params
								ValueCount = 3
							)
							#svt_float4x2: (
								ParamNames = this.Float4x2ParamNames
								ParamValues = this.Float4x2Params
								ValueCount = 2
							)
							#svt_float4x4: (
								ParamNames = this.Float4x4ParamNames
								ParamValues = this.Float4x4Params
								ValueCount = 4
							)
							#svt_float4x5: (
								ParamNames = this.Float4x5ParamNames
								ParamValues = this.Float4x5Params
								ValueCount = 5
							)
							Default:
								throw "Unknown SPS param type: " aType
						)
						if not Supplied ParamID then
							ParamID = (GIMS.Core.ArrayOps.QuickSearch ParamNames aName)
						if ParamID != 0 then (
							local	StartIndex = ((ParamID - 1) * ValueCount)
							Result = #()
							for i = ValueCount to 1 by -1 do
								Result[i] = ParamValues[StartIndex + i]
						)
					)
				)
				if GetTexParams then (
					if GetParamIDToo then
						#(Result, ParamID, this.TexParams[ParamID])
					else
						#(Result, this.TexParams[ParamID])
				) else (
					if GetParamIDToo then
						#(Result, ParamID)
					else
						Result
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn EnsureHaveParams tSPSName DB QuickSearch TypeCast = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DBShaders = DB.Shaders
				if Have DBShaders then (
					local	SPSGroups = DBShaders[3],
							SPS,
							Found = false
					for SPSGroup in SPSGroups while not Found do (
						local	SID = (QuickSearch SPSGroup tSPSName PropertyName:#aName)
						if SID != 0 then (
							SPS = SPSGroup[SID]
							Found = true
						)
					)
					if No SPS then
						throw "Can't find the SPS: " tSPSName
					local	IsEmissive = false
					for SPSParam in SPS.ShaderParameters do (
						local	aName = SPSParam.aName,
								aType = SPSParam.aType
						if not IsEmissive then
							IsEmissive = ((TypeCast aName Name) == #emissivemultiplier)
						if
							SPSParam.isRequired and
							not (CheckParam aName aType)
						then (
							SetParam aName aType (
								if aType != #svt_sampler then
									SPSParam.DefaultValue
							)
						)
					)
					if IsEmissive then
						Delegate.SelfIllumination = 0
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#aName, #aType), #(aName, aType)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		
		fn UpdateControls = (	--TODO remove after moving the collision material editor to GIMS
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	CollisionData = This.CollisionData,
						Part1 = CollisionData[1],
						Part2 = CollisionData[2],
						Part3 = CollisionData[3],
						
						TheColor = (Color Part1.x Part1.y Part1.z)
				this.MainRollout.cCollisionColor.Color = TheColor
			
				local	TheOpacity = Part2.x
				this.MainRollout.cCollisionOpacity.Value = TheOpacity		
				
				local	Success = false,
						DB = (GIMS.Core.CoreOps.TryGetGameDB #V)
				if Supplied DB then (
					local	DBMaterials = DB.Materials,
							MatIndex = Part2.y
					if MatIndex > DBMaterials[1].Count then
						MatIndex = 1
					local	LocationData = (GIMS.Core.ArrayOps.FetchMHL DBMaterials[6] MatIndex ReturnHashOnFail:false)
					if No LocationData then (
						LocationData = [1, 1]
						MatIndex = DBMaterials[5][1][1]
					)
					local	GID = LocationData.x
					this.MainRollout.cMatGroup.Items = DBMaterials[3]
					this.MainRollout.cMatGroup.Selection = GID
					this.MainRollout.cMtl.Items = DBMaterials[4][GID]
					this.MainRollout.cMtl.Selection = LocationData.y
					Success = true
				)
				
				this.MainRollout.cUseColor.Checked = (Part2.z != 0)
				
				this.MainRollout.cProcId.Value = Part3.y
				this.MainRollout.cRoomId.Value = Part3.z
				this.MainRollout.cPedDensity.Value = CollisionData[4].x
				
				local	PolyFlags = Part3.x,
						Controls = this.MainRollout.Controls,
						ControlIDs = #{(FindItem Controls this.MainRollout.cPF01)..(FindItem Controls this.MainRollout.cPF16)},
						BitIndex = 1,
						BitGet = Bit.Get
				for cID in ControlIDs do (
					Controls[cID].Checked = (BitGet PolyFlags BitIndex)
					BitIndex += 1
				)				
				Success
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		
		parameters Params Rollout:MainRollout (
			CollisionData			Type:#Matrix3			Default:(Matrix3 [127.5, 127.5, 127.5] [100, 1, 0] [0, 0, 0] [0, 0, 1])
			
			SPSName					Type:#String			Default:"default"
			
			FloatValueNames			Type:#StringTab			TabSizeVariable:true
			FloatValues				Type:#Point4Tab			TabSizeVariable:true
			
			TexValueNames			Type:#StringTab			TabSizeVariable:true
			TexValues				Type:#TextureMapTab		TabSizeVariable:true
			TexInternalFlags		Type:#BoolTab			TabSizeVariable:true
			TexParams				Type:#Matrix3Tab		TabSizeVariable:true
			
			Matrix3x4ParamNames		Type:#StringTab			TabSizeVariable:true
			Matrix3x4Params			Type:#Point3Tab			TabSizeVariable:true
			
			Matrix44ParamNames		Type:#StringTab			TabSizeVariable:true
			Matrix44Params			Type:#Point4Tab			TabSizeVariable:true
		
			Float2x3ParamNames		Type:#StringTab			TabSizeVariable:true
			Float2x3Params			Type:#Point3Tab			TabSizeVariable:true
			
			Float4x2ParamNames		Type:#StringTab			TabSizeVariable:true
			Float4x2Params			Type:#Point4Tab			TabSizeVariable:true
			
			Float4x4ParamNames		Type:#StringTab			TabSizeVariable:true
			Float4x4Params			Type:#Point4Tab			TabSizeVariable:true
			
			Float4x5ParamNames		Type:#StringTab			TabSizeVariable:true
			Float4x5Params			Type:#Point4Tab			TabSizeVariable:true

			GeometryFlags	Type:#BoolTab	Default:false	TabSize:3
																
			U_Offset	Type:#Float	Default:0	Animatable:true
			V_Offset	Type:#Float	Default:0	Animatable:true
			U_Tiling	Type:#Float	Default:1	Animatable:true
			V_Tiling	Type:#Float	Default:1	Animatable:true
			Opacity		Type:#Float	Default:1	Animatable:true

			/*Format:
				CollisionData:	ColorP3 [Opacity, Index, HaveColorFlag] [PolyFlags, ProcId, RoomId] [PedDensity, UNUSED, VERSION]
			*/
			
			on CollisionData set vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	NoDiffuse = true,	--TODO remake because param can present, but not used in SPS
							NameArrays = #(
								FloatValueNames,
								Matrix3x4ParamNames,
								Matrix44ParamNames,
								Float2x3ParamNames,
								Float4x2ParamNames,
								Float4x4ParamNames,
								Float4x5ParamNames
							)
					for Names in NameArrays while NoDiffuse do (
						for tName in Names while NoDiffuse do (
							local	aName = (tName as Name)
							if
								(aName == #diffuseCol) or
								(aName == #subcolor) or
								(aName == #matDiffuseColor) or
								(aName == #waterColor)
							then
								NoDiffuse = true
						)
					)
					if NoDiffuse then (
						local	Part1 = vValue[1],
								Part2 = vValue[2]
						if Part2.z == 0 then (
							local	DB = (GIMS.Core.CoreOps.TryGetGameDB #V)
							if Supplied DB then (
								local	DBMaterials = DB.Materials
								if Have DBMaterials then (
									local	MatColors = DBMaterials[2],
											MatIndex = Part2.y
									if MatIndex <= MatColors.Count then
										Delegate.Diffuse = MatColors[MatIndex]
								)
							)
							Delegate.Opacity = 100
						) else (
							Delegate.Diffuse = (Color Part1.x Part1.y Part1.z)
							Delegate.Opacity = Part2.x
						)
					)
					UpdateControls()
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#vValue), #(vValue)) NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on SPSName set tSPSName do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	MAXFactory = GIMS.Core.MAXFactory
					if
						Have MAXFactory and
						(IsProperty GIMS #V)
					then (
						local	DB = (GIMS.Core.CoreOps.TryGetGameDB #V)
						if Supplied DB then
							EnsureHaveParams tSPSName DB GIMS.Core.ArrayOps.QuickSearch GIMS.Core.ValueOps.TypeCast
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
		)

		--TODO move the collision material editor to GIMS
		rollout MainRollout "GTA V Collision material" (
			Label			cLMatGroup			"Group"			Align:#Center	Across:2
			Label			cLMtl				"Material"		Align:#Center
			DropDownList	cMatGroup			""				Align:#Center	Across:2
			DropDownList	cMtl				""				Align:#Center
			CheckBox		cUseColor			"Use color"		Align:#Right	Checked:false	Across:2
			ColorPicker		cCollisionColor		"Color"			Align:#Right
			Spinner			cCollisionOpacity	"Opacity"		Align:#Right	FieldWidth:50	Range:[0, 100, 100]		Type:#Float
			Spinner			cPedDensity			"Ped density"	Align:#Right	FieldWidth:50	Range:[0, 7, 0]		Type:#Integer
			Spinner			cRoomId				"Room ID"		Align:#Right	FieldWidth:50	Range:[0, 31, 0]	Type:#Integer	Across:2
			Spinner			cProcId				"Procedural ID"	Align:#Right	FieldWidth:50	Range:[0, 255, 0]	Type:#Integer
			Group "Flags" (
				CheckBox	cPF01	"No cam collision"               	Align:#Left	Checked:false	Across:2
				CheckBox	cPF02	"No cam collision, allow clipping"	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF03	"No decal"                       	Align:#Left	Checked:false	Across:2
				CheckBox	cPF04	"No navmesh"                     	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF05	"No network spawn"               	Align:#Left	Checked:false	Across:2
				CheckBox	cPF06	"No ptfx"                        	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF07	"No ragdoll"                     	Align:#Left	Checked:false	Across:2
				CheckBox	cPF08	"Not climbable"                  	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF09	"Not cover"                      	Align:#Left	Checked:false	Across:2
				CheckBox	cPF10	"See through"                    	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF11	"Shoot through"                  	Align:#Left	Checked:false	Across:2
				CheckBox	cPF12	"Shoot through fx"               	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF13	"Stairs"                         	Align:#Left	Checked:false	Across:2
				CheckBox	cPF14	"Too steep for player"           	Align:#Left	Checked:false				Offset:[-10, 0]
				CheckBox	cPF15	"Vehicle wheel"                  	Align:#Left	Checked:false	Across:2
				CheckBox	cPF16	"Walkable path"						Align:#Left	Checked:false				Offset:[-10, 0]
			)

			label lsp0 "Shader parameters're editable through"	Align:#Left
			label lsp1 "GIMS Evo V material editor"	Align:#Right
			
			fn SetMatIndex = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	DB = (GIMS.Core.CoreOps.TryGetGameDB #V)
					if Supplied DB then (
						local	Part = CollisionData[2]
						Part.y = DB.Materials[5][cMatGroup.Selection][cMtl.Selection]
						CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 2 Part)
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cMatGroup selected vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					cMtl.Selection = 1
					SetMatIndex()
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cMtl selected vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					SetMatIndex()
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cCollisionColor changed vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 1 [vValue.r, vValue.g, vValue.b])
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cCollisionOpacity changed vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Part = CollisionData[2]
					Part.x = vValue
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 2 Part)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cUseColor changed vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Part = CollisionData[2]
					Part.z = (Ternary vValue 1 0)
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 2 Part)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			fn SetFlags = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	PolyFlags = 0,
							Controls = this.MainRollout.Controls,
							ControlIDs = #{(FindItem Controls cPF01)..(FindItem Controls cPF16)},
							BitIndex = 1,
							BitSet = Bit.Set
					for cID in ControlIDs do (
						if Controls[cID].Checked then
							PolyFlags = (BitSet PolyFlags BitIndex true)
						BitIndex += 1
					)		
					local	Part = CollisionData[3]
					Part.x = PolyFlags
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 3 Part)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cPF01 changed state do SetFlags()
			on cPF02 changed state do SetFlags()
			on cPF03 changed state do SetFlags()
			on cPF04 changed state do SetFlags()
			on cPF05 changed state do SetFlags()
			on cPF06 changed state do SetFlags()
			on cPF07 changed state do SetFlags()
			on cPF08 changed state do SetFlags()
			on cPF09 changed state do SetFlags()
			on cPF10 changed state do SetFlags()
			on cPF11 changed state do SetFlags()
			on cPF12 changed state do SetFlags()
			on cPF13 changed state do SetFlags()
			on cPF14 changed state do SetFlags()
			on cPF15 changed state do SetFlags()
			on cPF16 changed state do SetFlags()
			on cProcId changed vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Part = CollisionData[3]
					Part.y = vValue
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 3 Part)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cRoomId changed vValue do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Part = CollisionData[3]
					Part.z = vValue
					CollisionData = (GIMS.Core.ValueOps.UpdateMatrix CollisionData 3 Part)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on MainRollout Open do (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if not (UpdateControls()) then
						MessageBox "You should install GIMS Evo V core to properly view or edit this material" Title:"GIMS Evo material warning"
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
		)
		
		on Update do (
			if CollisionData[4][3] < 0.5 then (
				CollisionData[3] = [0, 0, 0]
				CollisionData[4][3] = 1
			)
			local	TexValueCount = TexValues.Count
			if TexParams.Count != TexValueCount then (
				for i = TexValueCount to 1 by -1 do
					TexParams[i] = (Matrix3 [1, 1, 1] [0, 0, -1] [-1, -1, -1] [-1, -1, -1])
			)
		)
		on Create do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MAXFactory = GIMS.Core.MAXFactory
				if Have MAXFactory then
					MAXFactory.MaterialOps.InitUV this
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

	/*collisions*/
	plugin 	Helper 			EGIMS_V_CollisionDict	 	Category:"V_Collisions" 		Name:"Dictionary" 		ClassID:#(1951679095, -1450803854)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		rollout rol "GTA V collision dictionary" (
			Label	Tip	"No properties to assign"
		)
	)
	plugin 	Helper 			EGIMS_V_Col_Composite 		Category:"V_Collisions" 		Name:"Composite" 		ClassID:#(1574213680, 1997960851)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters chFlags rollout:params (
			UseChildFlags	Type:#Boolean	Default:true		UI:cUseChildFlags
		)
		rollout params "GTA V composite collision" (
			CheckBox	cUseChildFlags	"Use children flags"	Align:#Left	Checked:true
		)
		include "I_V_ChildFlagsUI.ms"
		on Create do (
			if Have AdditionalCreateHandler then
				AdditionalCreateHandler()
		)
	)
	plugin 	SimpleMod 		EGIMS_V_CollisionMesh		Category:"V_Collisions" 		Name:"Mesh"				ClassID:#(921371151, 1871725530)		Invisible:true	(
		parameters Params rollout:Rol (
			Type					Type:#Integer		Default:1		UI:Type
			VertexOffset_UnkPart	Type:#WorldUnits	Default:0		UI:VertexOffset_UnkPart
			CollectMAXSiblings		Type:#Boolean		Default:false	UI:CollectMAXSiblings					
		)
		rollout Rol "GTA V collision mesh" (
			RadioButtons	Type "Type" Labels:#("BVH", "Geometry") Columns:2
			Spinner 		VertexOffset_UnkPart "Unk VertOffset part" Type:#WorldUnits Range:[-9999, 9999, 0]	Align:#Left FieldWidth:40
			CheckBox		CollectMAXSiblings	"Collect MAX siblings"	Align:#Left
		)
		include "I_V_ChildFlagsUI.ms"
		on Create do (
			if Have AdditionalCreateHandler then
				AdditionalCreateHandler()
		)
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Plane 			Category:"V_Collisions" 		Name:"Plane" 			ClassID:#(2008192725, 1441569628)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	HalfWidth = (this.Width / 2),
					HalfLength = (this.Length / 2)
			if _Faces.Count == 0 then
				_Faces = #([2, 1, 3], [3, 4, 2])
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = #([-HalfWidth, HalfLength, 0], [HalfWidth, HalfLength, 0], [-HalfWidth, -HalfLength, 0], [HalfWidth, -HalfLength, 0])
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			MtlID	Type:#Integer		UI:MtlID	default:1
			Width 	Type:#worldUnits	UI:Width 	default:1
			Length 	Type:#worldUnits	UI:Length 	default:1
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Width set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Length set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "GTA V collision plane" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Width "Width" Type:#worldunits range:[0,10000,1] FieldWidth:50
			spinner Length "Length" Type:#worldunits range:[0,10000,1] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Disc			Category:"V_Collisions"			Name:"Disc" 			ClassID:#(1652583542, 406348285)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	CylinderMesh = GIMS.Core.DB.CylinderMesh,
					Diameter = (this.Radius * 2)
			if _Faces.Count == 0 then
				_Faces = CylinderMesh[2]
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify CylinderMesh[1] #([Diameter, Diameter, this.Height], (Quat 0 -0.707107 0 0.707107)) #(#Multiply, #Multiply))
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			MtlID	Type:#Integer		UI:MtlID	default:1
			Radius	Type:#worldUnits	UI:Radius	default:0.5
			Height 	Type:#worldUnits	UI:Height	default:0.2
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "GTA V collision disc" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0,100,0.2] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0,100,0.5] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Box 			Category:"V_Collisions" 		Name:"Box" 				ClassID:#(200596908, -1429683129)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	BoxCentricMesh = GIMS.Core.DB.BoxCentricMesh
			if _Faces.Count == 0 then
				_Faces = BoxCentricMesh[2]
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify BoxCentricMesh[1] [this.Width, this.Depth, this.Height] #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			MtlID	Type:#Integer		UI:MtlID	default:1
			Width	Type:#worldUnits	UI:Width	default:1
			Depth	Type:#worldUnits	UI:Depth	default:1
			Height	Type:#worldUnits	UI:Height	default:1
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Width set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Depth set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "GTA V collision box" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Width "Width" Type:#worldunits range:[0,10000,1] FieldWidth:50
			spinner Depth "Length" Type:#worldunits range:[0,10000,1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0,10000,1] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Sphere 			Category:"V_Collisions" 		Name:"Sphere" 			ClassID:#(1221911841, 96644880) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	SphereMesh = GIMS.Core.DB.SphereMesh
			if _Faces.Count == 0 then
				_Faces = SphereMesh[2]
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify SphereMesh[1] (this.Radius * 2) #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			MtlID	Type:#Integer		UI:MtlID	default:1
			Radius	Type:#worldUnits	UI:Radius	default:1
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout rol "GTA V collision sphere" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0, 10000, 1] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Capsule 		Category:"V_Collisions" 		Name:"Capsule" 			ClassID:#(858407250, 148563441) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	ArrayOps = GIMS.Core.ArrayOps,
					Modify = ArrayOps.Modify,
					JoinArraysIntoResult = ArrayOps.JoinArraysIntoResult,
					SphereMesh = GIMS.Core.DB.SphereMesh,
					CylinderMesh = GIMS.Core.DB.CylinderMesh,
					SphereMeshVerts = SphereMesh[1],
					Diameter = (this.Radius * 2),
					HalfHeight = (this.Height / 2)
			if _Faces.Count == 0 then (
				local	SphereMeshFaces = SphereMesh[2],
						SphereMeshVertCount = SphereMeshVerts.Count,
						DoubleSphereMeshVertCount = (SphereMeshVertCount * 2),
						Faces2 = (Modify SphereMeshFaces [SphereMeshVertCount, SphereMeshVertCount, SphereMeshVertCount] #Add),
						Faces3 = (Modify CylinderMesh[2] [DoubleSphereMeshVertCount, DoubleSphereMeshVertCount, DoubleSphereMeshVertCount] #Add)
				JoinArraysIntoResult #(SphereMeshFaces, Faces2, Faces3) (&_Faces)
				Free Faces3
				Free Faces2
			)
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			local	ScaledVerts = (Modify SphereMeshVerts Diameter #Multiply),
					Verts1 = (Modify ScaledVerts [0, HalfHeight, 0] #Add),
					Verts2 = (Modify ScaledVerts [0, -HalfHeight, 0] #Add)
			Free ScaledVerts
			local	Verts3 = (Modify CylinderMesh[1] #([Diameter, Diameter, this.Height], (Quat -0.707107 0 0 0.707107)) #(#Multiply, #Multiply))
			JoinArraysIntoResult #(Verts1, Verts2, Verts3) (&_Verts)
			Free Verts1
			Free Verts2
			Free Verts3
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			MtlID				Type:#Integer	UI:MtlID				default:1
			Radius				Type:#worldUnits UI:Radius				default:1
			Height				Type:#worldUnits UI:Height				default:2
			CapsuleHalfHeight	Type:#worldUnits UI:CapsuleHalfHeight	default:0
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout rol "GTA V collision capsule" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0, 10000, 1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0, 10000, 2] FieldWidth:50
			spinner CapsuleHalfHeight "CapsuleHalfHeight" Type:#worldunits range:[0, 10000, 0] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_Cylinder		Category:"V_Collisions"			Name:"Cylinder" 		ClassID:#(1939362787, 1521396838)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	CylinderMesh = GIMS.Core.DB.CylinderMesh,
					Diameter = (this.Radius * 2)
			if _Faces.Count == 0 then
				_Faces = CylinderMesh[2]
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify CylinderMesh[1] #([Diameter, Diameter, this.Height], ((EulerAngles 90 0 0) as Quat)) #(#Multiply, #Multiply))
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			MtlID	Type:#Integer		UI:MtlID	default:1
			Radius	Type:#worldUnits	UI:Radius	default:0.5
			Height 	Type:#worldUnits	UI:Height	default:0.2
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "GTA V collision cylinder" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0,100,0.2] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0,100,0.5] FieldWidth:50
		)
		include "I_V_ChildFlagsUI.ms"
	)
	plugin 	SimpleObject 	EGIMS_V_Col_PrimBox 		Category:"V_PrimCollisions"		Name:"Box" 				ClassID:#(52281751, 642373764)			Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	BoxCentricMesh = GIMS.Core.DB.BoxCentricMesh
			if _Faces.Count == 0 then
				_Faces = BoxCentricMesh[2]
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify BoxCentricMesh[1] [this.Width, this.Depth, this.Height] #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:MainRol (
			MtlID			Type:#Integer		UI:MtlID	default:1
			Width			Type:#worldUnits	UI:Width	default:1
			Depth			Type:#worldUnits	UI:Depth	default:1
			Height			Type:#worldUnits	UI:Height	default:1
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Width set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Depth set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout MainRol "GTA V primitive col box" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Width "Width" Type:#worldunits range:[0,10000,1] FieldWidth:50
			spinner Depth "Length" Type:#worldunits range:[0,10000,1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0,10000,1] FieldWidth:50
		)
	)
	plugin 	SimpleObject 	EGIMS_V_Col_PrimSphere 		Category:"V_PrimCollisions" 	Name:"Sphere" 			ClassID:#(1610404602, 769120363) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	SphereMesh = GIMS.Core.DB.SphereMesh,
					MtlID = this.MtlID
			if _Faces.Count == 0 then
				_Faces = SphereMesh[2]
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify SphereMesh[1] (this.Radius * 2) #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			MtlID	Type:#Integer 		UI:MtlID	default:1
			Radius	Type:#worldUnits	UI:Radius	default:1
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout rol "GTA V primitive col sphere" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0, 10000, 1] FieldWidth:50
		)
	)
	plugin 	SimpleObject 	EGIMS_V_Col_PrimCapsule 	Category:"V_PrimCollisions" 	Name:"Capsule" 			ClassID:#(321642857, 773461178) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	ArrayOps = GIMS.Core.ArrayOps,
					Modify = ArrayOps.Modify,
					JoinArraysIntoResult = ArrayOps.JoinArraysIntoResult,
					SphereMesh = GIMS.Core.DB.SphereMesh,
					CylinderMesh = GIMS.Core.DB.CylinderMesh,
					SphereMeshVerts = SphereMesh[1],
					Diameter = (this.Radius * 2),
					HalfHeight = (this.Height / 2)
			if _Faces.Count == 0 then (
				local	SphereMeshFaces = SphereMesh[2],
						SphereMeshVertCount = SphereMeshVerts.Count,
						DoubleSphereMeshVertCount = (SphereMeshVertCount * 2),
						Faces2 = (Modify SphereMeshFaces [SphereMeshVertCount, SphereMeshVertCount, SphereMeshVertCount] #Add),
						Faces3 = (Modify CylinderMesh[2] [DoubleSphereMeshVertCount, DoubleSphereMeshVertCount, DoubleSphereMeshVertCount] #Add)
				JoinArraysIntoResult #(SphereMeshFaces, Faces2, Faces3) (&_Faces)
				Free Faces3
				Free Faces2
			)
			local	MtlID = this.MtlID
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			local	ScaledVerts = (Modify SphereMeshVerts Diameter #Multiply),
					Verts1 = (Modify ScaledVerts [0, 0, HalfHeight] #Add),
					Verts2 = (Modify ScaledVerts [0, 0, -HalfHeight] #Add)
			Free ScaledVerts
			local	Verts3 = (Modify CylinderMesh[1] [Diameter, Diameter, this.Height] #Multiply)
			JoinArraysIntoResult #(Verts1, Verts2, Verts3) (&_Verts)
			Free Verts1
			Free Verts2
			Free Verts3
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			MtlID				Type:#Integer 	UI:MtlID 				default:1
			Radius				Type:#worldUnits UI:Radius				default:1
			Height				Type:#worldUnits UI:Height				default:2
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout rol "GTA V primitive col capsule" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0, 10000, 1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0, 10000, 2] FieldWidth:50
		)
	)
	plugin 	SimpleObject 	EGIMS_V_Col_PrimCylinder	Category:"V_PrimCollisions"		Name:"Cylinder" 		ClassID:#(656703252, 2054693377)		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	CylinderMesh = GIMS.Core.DB.CylinderMesh,
					Diameter = (this.Radius * 2),
					MtlID = this.MtlID
			if _Faces.Count == 0 then
				_Faces = CylinderMesh[2]
			for i = _Faces.Count to 1 by -1 do
				_MtlIDs[i] = MtlID
			_Verts = (GIMS.Core.ArrayOps.Modify CylinderMesh[1] [Diameter, Diameter, this.Height] #Multiply)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:params (
			MtlID	Type:#Integer 		UI:MtlID	default:1
			Radius	Type:#worldUnits	UI:Radius	default:0.5
			Height 	Type:#worldUnits	UI:Height	default:0.2
			
			on MtlID set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Radius set Val do
				_NeedUpdate = true	--_RebuildMesh()
			on Height set Val do
				_NeedUpdate = true	--_RebuildMesh()
		)
		rollout params "GTA V primitive col cylinder" (
			spinner MtlID "Material ID" Type:#Integer range:[1,100,1] FieldWidth:50
			spinner Height "Height" Type:#worldunits range:[0,100,0.2] FieldWidth:50
			spinner Radius "Radius" Type:#worldunits range:[0,100,0.5] FieldWidth:50
		)
	)

	plugin 	SimpleObject 	EGIMS_V_VehicleRecording 	Category:"V_Paths" 		Name:"Vehicle recording" 	ClassID:#(1507408395, 1738459703) 		Invisible:true	(
		include "I_PluginMesh.ms"
		fn RebuildMesh &_Verts &_Faces &_MtlIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	ArrayOps = GIMS.Core.ArrayOps,
					Modify = ArrayOps.Modify,
					JoinArraysIntoResult = ArrayOps.JoinArraysIntoResult,
					
					CarWithWheelsMesh = GIMS.Core.DB.CarWithWheelsMesh,
					
					MeshBase = CarWithWheelsMesh[1],
					MeshLF = CarWithWheelsMesh[2],
					MeshRF = CarWithWheelsMesh[3],
										
					VertsBase = MeshBase[2],
					VertsLF = MeshLF[2],
					VertsRF = MeshRF[2],
										
					VertsStage1Count = VertsBase.Count,
					Faces2 = (Modify MeshLF[3] [VertsStage1Count, VertsStage1Count, VertsStage1Count] #Add),
					
					VertsStage2Count = VertsStage1Count + VertsLF.Count,
					Faces3 = (Modify MeshRF[3] [VertsStage2Count, VertsStage2Count, VertsStage2Count] #Add)
			JoinArraysIntoResult #(MeshBase[3], Faces2, Faces3) (&_Faces)
			Free Faces2
			Free Faces3
			
			local	angle = this.SteeringAngle,
					OriginLF = MeshLF[1],
					OriginRF = MeshRF[1],
					
					Rot = ((EulerAngles 0 0 -angle) as Quat),
					
					Verts2 = (Modify VertsLF #(Rot, OriginLF) #(#Multiply, #Add)),
					Verts3 = (Modify VertsRF #(Rot, OriginRF) #(#Multiply, #Add))
			JoinArraysIntoResult #(VertsBase, Verts2, Verts3) (&_Verts)
			Free Verts2
			Free Verts3
						
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		parameters params rollout:rol (
			Velocity			Type:#FloatTab	Default:0			Animatable:true		TabSize:3	UI:(uiVelocityX, uiVelocityY, uiVelocityZ)
			SteeringAngle		Type:#Float		Default:0			Animatable:true		UI:uiSteeringAngle
			GasPedalPower		Type:#Float		Default:0			Animatable:true		UI:uiGasPedalPower
			BreakPedalPower		Type:#Float		Default:0			Animatable:true		UI:uiBreakPedalPower
			UseHandBrake		Type:#Boolean	Default:false		Animatable:true		UI:uiUseHandBrake
		)
		rollout rol "GTA V vehicle recording" (
			Label		lblVel				"Velocity(m/s)"		Align:#Center
			spinner 	uiVelocityX 		"X" 				Align:#Left		Type:#Float range:[-9999,9999,0]
			spinner 	uiVelocityY 		"Y" 				Align:#Left		Type:#Float range:[-9999,9999,0]
			spinner 	uiVelocityZ 		"Z" 				Align:#Left		Type:#Float range:[-9999,9999,0]
			spinner 	uiSteeringAngle 	"Steering" 			Align:#Left		Type:#Float range:[-180,180,0]
			spinner 	uiGasPedalPower 	"Gas pedal" 		Align:#Left		Type:#Float range:[-1,1,0]
			spinner 	uiBreakPedalPower 	"Break pedal" 		Align:#Left		Type:#Float range:[0,1,0]
			checkbox 	uiUseHandBrake 		"HandBrake"			Align:#Left	
		)
		
		fn AdditionalCreateHandler = (
			this._AlwaysRedraw = true
			this.Velocity			.Controller = (Linear_Float())
			this.SteeringAngle		.Controller = (Linear_Float())
			this.GasPedalPower		.Controller = (Linear_Float())
			this.BreakPedalPower	.Controller = (Linear_Float())
			this.UseHandBrake		.Controller = (Linear_Float())
		)
	)

	/*
	plugin 	SimpleObject 	EGIMS_V_MapHelper			Category:"V_Helpers"			Name:"Map" 				ClassID:#(857604459, 1491837148)		Invisible:true	(
		rollout params "GTA V map helper" (
			Label	Tip	"No properties to assign"
		)
		on buildMesh do (
			local	VMapHelperMesh = GIMS.Core.DB.VMapHelperMesh
			SetMesh Mesh Vertices:VMapHelperMesh[1] Faces:VMapHelperMesh[2]
			local	VCols = VMapHelperMesh[3],
					FSetMapVert = MeshOp.SetMapVert
			MeshOp.DefaultMapFaces Mesh 0
			for VertID = 1 to VertColCount do
				FSetMapVert Mesh 0 VertID VCols[VertID]
			this.ShowVertexColors = true
			this.VertexColorType = 0
		)
	)
	*/
	
	/*models*/
	plugin	Helper 			EGIMS_V_ModelDict			Category:"V_Models" 			Name:"Dictionary"			ClassID:#(753633694, -1039092802)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		rollout rol "GTA V model dictionary" (
			Button		SkelReset		"Revert bone transforms"
			
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
		)
	)
	plugin 	Helper 			EGIMS_V_Model				Category:"V_Models" 			Name:"Model" 				ClassID:#(335677675, 326373399)			Invisible:true	Extends:Dummy		ReplaceUI:true	(
		include "I_V_oFModel.ms"
	)
	plugin 	SimpleMod 		EGIMS_V_Model_ModelMod 		Category:"V_Imposters" 			Name:"Model" 				ClassID:#(1007338255, 2091317628)		Invisible:true	(
		include "I_V_oFModel.ms"
	)
	plugin 	Helper 			EGIMS_V_Model_Bone 			Category:"V_Models" 			Name:"Bone" 				ClassID:#(1583710484, -1251435080)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		include "I_V_oFBone.ms"
	)
	plugin 	SimpleMod 		EGIMS_V_Model_BoneMod 		Category:"V_Imposters" 			Name:"Bone" 				ClassID:#(428178281, -2095695919)		Invisible:true	(
		include "I_V_oFBone.ms"
	)
	plugin 	Light 			EGIMS_V_Model_Light			Category:"V_Models" 			Name:"Light"				ClassID:#(1229726970, -2017340078)		Invisible:true	Extends:OmniLight	ReplaceUI:true	(
		include "I_V_oFLight.ms"
		on Create do
			Init delegate
	)
	plugin 	SimpleMod 		EGIMS_V_Model_LightMod		Category:"V_Imposters" 			Name:"Light"				ClassID:#(1940220823, 1425288171)		Invisible:true	(
		include "I_V_oFLight.ms"
		on Create do
			IsCreating = true
	)
	plugin 	SimpleMod 		EGIMS_V_ModelMesh			Category:"V_Models"				Name:"Game mesh"			ClassID:#(1009825488, 387669260)		Invisible:true	(
		parameters Params rollout:Rol (
			Type	Type:#Integer	Default:1		UI:Type
			Mask	Type:#Integer	Default:255		UI:Mask
		)
		rollout Rol "GTA V model mesh" (
			RadioButtons	Type						"Level of detail"		Columns:2		Labels:#("High", "Medium", "Low", "Very low")
			Spinner			Mask						"Mask"					Type:#Integer	Range:[0, 255, 255]
		)
	)
	
	/*textures*/
	plugin	Helper 			EGIMS_V_TexDict				Category:"V_Graphics" 			Name:"Texture Dictionary"	ClassID:#(619416821, -1098014747)		Invisible:true	Extends:Dummy		ReplaceUI:true	(
		parameters params rollout:rol (
			ObjList	Type:#NodeTab	TabSizeVariable:true
		)
		rollout rol "GTA V texture dictionary" (
			MultiListBox	cObjList	"Models"			Height:20	Align:#Center
			Button			bnAdd		"Add"				Width:65	Align:#Left						Across:2
			Button			bnDel		"Remove"			Width:65	Align:#Right	Enabled:false
			Button			bnSel		"Select in scene"	Width:135	Align:#Center	Enabled:false
			
			fn UpdateObjList = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				local	ObjListCount = ObjList.Count,
						Items = #(),
						ItemCount = 0
				Items.Count = ObjListCount
				for i = 1 to ObjListCount do (
					local	Obj = ObjList[i]
					if
						Have Obj and
						not (IsDeleted Obj)
					then (
						ItemCount += 1
						Items[ItemCount] = Obj.Name
					)
				)
				Items.Count = ItemCount
				cObjList.Items = Items
				cObjList.Selection = 0
				bnSel.Enabled = false
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
			on cObjList SelectionEnd do (
				local	Enabled = (cObjList.Selection.NumberSet != 0)
				bnDel.Enabled = Enabled
				bnSel.Enabled = Enabled
			)
			on bnDel Pressed do (
				local	cObjListSelection = cObjList.Selection
				for i = cObjListSelection.Count to 1 by -1 where cObjListSelection[i] do
					DeleteItem ObjList i
				UpdateObjList()
			)
			fn FilterFn Obj = (
				(
					(FindItem ObjList Obj) == 0 and (
						(IsKindOf Obj EGIMS_V_ModelDict) or (
							(
								(IsKindOf Obj EGIMS_V_Model) or
								(IsKindOf Obj.Modifiers[#Model] EGIMS_V_Model_ModelMod)
							) and
							not (IsKindOf Obj.Parent EGIMS_V_ModelDict)
						)
					)
				)
			)
			on bnAdd Pressed do (
				undo "Select texture dictionary items" on (
					local	Objs = (SelectByName Title:"Select models to use in texture dictionary" Filter:FilterFn ShowHidden:false Single:False)
					if Have Objs then (
						for Obj in Objs do
							Append ObjList Obj
					)
					UpdateObjList()
				)
			)
			on bnSel Pressed do (
				ClearSelection()
				for i in cObjList.Selection do
					SelectMore ObjList[i]
			)
			on rol Open do
				UpdateObjList()
		)
	)
	
	/*V END*/
	
	/*COMMON*/
	
	tool	CreatorTool_Generic					Prompt:"Press and drag LMB to place an object, RMB to cancel" (
		local	Obj
		on mousePoint ClickID do (
			if ClickID == 1 then
				Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass IsSelected:true)
			else
				#stop
		)
		on mouseMove ClickID do (
			if ClickID == 2 then
				Obj.Pos = WorldPoint
			else
				#stop
		)
	)
	tool 	CreatorTool_Bone					Prompt:"Press and drag LMB to place an object, RMB to cancel" (
		local	Obj
		on mousePoint ClickID do (
			if ClickID == 1 then (
				Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass IsSelected:true)
				Obj.WireColor = Yellow
				Obj.ShowLinks = true
				Obj.ShowLinksOnly = true
			) else
				#stop
		)
		on mouseMove ClickID do (
			if ClickID == 2 then
				Obj.Pos = WorldPoint
			else
				#stop
		)
	)
	tool 	CreatorTool_EGIMS_GUI_Item			Prompt:"Press LMB to place and drag to set control size, RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:([(gridPoint.x / 10) as Integer, (gridPoint.y / 10) as Integer, 0] * 10) IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2: (
					if worldDist.x > 0 then
						Obj.ItemSize[1] = ((worldDist.x / 10) as Integer)
					if worldDist.y < 0 then
						Obj.ItemSize[2] = ((-worldDist.y / 10) as Integer)
				)
				3:
					#stop
			)
		)
	)
	tool 	CreatorTool_EGIMS_GUI_Layout		Prompt:"Press and drag LMB to place a layout, RMB to cancel" (
		local	Obj
		on mousePoint click do (
			if click == 1 then
				Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:gridPoint IsSelected:true)
			else
				#stop
		)
		on mouseMove click do (
			if click == 2 then
				Obj.Pos = ([(gridPoint.x / 10) as Integer, (gridPoint.y / 10) as Integer, 0] * 10)
			else
				#stop
		)
	)
	tool 	CreatorTool_EGIMS_IV_Car_Wheel		Prompt:"Press LMB to place and drag to set deflated wheel size, inflated size, and width; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				4:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2:
					Obj.InfRadius = (Length worldDist)
				3:
					Obj.DefRadius = (InfRadius - (Length worldDist))
				4:
					Obj.Width = (abs (worldDist.x*2))
			)
		)
	)
	tool 	CreatorTool_CenteredBox				Prompt:"Press LMB to place and drag to set box length with width, then Height; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2: (
					Obj.Width = (abs worldDist.x*2)
					Obj.Depth = (abs worldDist.y*2)
				)
				3:
					Obj.Height = (abs worldDist.z*2)
			)
		)
	)
	tool 	CreatorTool_Capsule					Prompt:"Press LMB to place and drag to set capsule radius, then Height; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2:
					Obj.Radius = (Length worldDist)
				3:
					Obj.Height = ((Length worldDist)*2)
			)
		)
	)
	tool 	CreatorTool_Box 					Prompt:"Press LMB to place and drag to set box length with width, then height; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2: (
					Obj.Width = (Abs worldDist.x)
					Obj.Len = (Abs worldDist.y)
				)
				3:
					Obj.Height = (Abs worldDist.z)
			)
		)
	)
	tool 	CreatorTool_Cylinder 				Prompt:"Press LMB to place and drag to set cylinder radius, then Height; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2:
					Obj.Radius = (Length worldDist)
				3:
					Obj.Height = ((Length worldDist)*2)
			)
		)
	)
	tool 	CreatorTool_Plane 					Prompt:"Press LMB to place and drag to set plane length and width; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				2:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2: (
					Obj.Width = ((Abs worldDist.x) * 2)
					Obj.Length = ((Abs worldDist.y) * 2)
				)
			)
		)
	)
	tool 	CreatorTool_Sphere 					Prompt:"Press LMB to place and drag to set sphere radius, RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2:
					Obj.Radius = (Length worldDist)
				3:
					#stop
			)
		)
	)
	tool 	CreatorTool_Light 					Prompt:"Press LMB to place and drag to set light distance, RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				4:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2:
					Obj.Pos = WorldPoint
				3:
					Obj.TheDistance = ((Length worldDist) * 2)
				4:
					#stop
			)
		)
	)
	tool 	CreatorTool_EGIMS_AE_WeaponInstance	Prompt:"Press LMB to place and drag to set weapon length with width, then height; RMB to cancel" (
		local	Obj
		on mousePoint click do (
			case click of (
				1:
					Obj = (GIMS.Core.TypeLibrary.CreatorTool_ObjClass Pos:WorldPoint IsSelected:true)
				3:
					#stop
			)
		)
		on mouseMove click do (
			case click of (
				2: (
					local	ObjSize = Obj.Size
					ObjSize[1] = (abs worldDist.x*2)
					ObjSize[2] = (abs worldDist.y*2)
				)
				3:
					Obj.Size[3] = (abs worldDist.z*2)
			)
		)
	)

	struct /*#PC*PATH	GIMS.Core.TypeLibrary.CollectionNode*/strCollectionNode (
		TreeNode,
		Obj,
		ParamSource,
		Children = #()
	)
	
	struct /*#PC*PATH	GIMS.Core.TypeLibrary.AABB*/strAABB (
		GIMSObjectLink = "GIMS.Core.TypeLibrary.AABB",
		bMin = [99999999, 99999999, 99999999],
		bMax = [-99999999, -99999999, -99999999]
	)
	
	/*COMMON END*/
	
	struct /*#PC*PATH	GIMS.Core.TypeLibrary*/strTypeLibrary (
		/*Common*/
		DefaultNode = EGIMS_Dummy,
		CollectionNode = strCollectionNode,
		AABB = strAABB,
		CreatableObjects_Data = #(
			#(	/*core tags*/
			), #(	/*core * category name*/
			), #(	/*core * category * object name*/
			), #(	/*core * category * object IsModifier flag*/
			), #(	/*core * category * object*/
			), #(	/*object * [CoreID, CatID, ObjID]*/
				#(), #()
			)
		),
		CreatorTool_ObjClass = unsupplied,
		fn CallObjectCreator ObjInfo = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				CreatorTool_ObjClass = ObjInfo[1]
				ClearSelection()
				if
					(StartTool ObjInfo[2]) == #Abort and
					Selection.Count != 0
				then
					Delete Selection
				OK
			/*<ERRHANDLER>*/) catch (
				CreatorTool_ObjClass = unsupplied
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Load = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for PlugData in #(
					#(EGIMS_GUI_Item,				CreatorTool_EGIMS_GUI_Item),
					#(EGIMS_GUI_Layout,				CreatorTool_EGIMS_GUI_Layout),
					#(EGIMS_Dummy,					CreatorTool_Generic),
					#(EGIMS_AE_Model,				CreatorTool_Generic),
					#(EGIMS_AE_Collision,			CreatorTool_Generic),
					#(EGIMS_AE_CollisionNode,		CreatorTool_Generic),
					#(EGIMS_AE_Col_Box,				CreatorTool_CenteredBox),
					#(EGIMS_AE_Col_Sphere,			CreatorTool_Sphere),
					#(EGIMS_AE_Weapon,				CreatorTool_Generic),
					#(EGIMS_AE_WeaponNode,			CreatorTool_Generic),
					#(EGIMS_AE_WeaponInstance,		CreatorTool_EGIMS_AE_WeaponInstance),
					#(EGIMS_MP3_ModelDict,			CreatorTool_Generic),
					#(EGIMS_MP3_Model,				CreatorTool_Generic),
					#(EGIMS_MP3_Model_Bone,			CreatorTool_Bone),
					#(EGIMS_MP3_Model_BoneMod,		CreatorTool_Generic),
					#(EGIMS_MP3_Model_Light,		CreatorTool_Light),
					#(EGIMS_MP3_Model_LightMod,		CreatorTool_Generic),
					#(EGIMS_MP3_ModelMesh,			CreatorTool_Generic),
					#(EGIMS_MP3_TexDict,			CreatorTool_Generic),
					#(EGIMS_V_CollisionDict,		CreatorTool_Generic),
					#(EGIMS_V_Col_Composite,		CreatorTool_Generic),
					#(EGIMS_V_Col_Plane,			CreatorTool_Plane),
					#(EGIMS_V_Col_Box,				CreatorTool_CenteredBox),
					#(EGIMS_V_Col_Disc,				CreatorTool_Cylinder),
					#(EGIMS_V_Col_Sphere,			CreatorTool_Sphere),
					#(EGIMS_V_Col_Cylinder,			CreatorTool_Cylinder),
					#(EGIMS_V_Col_Capsule,			CreatorTool_Capsule),
					#(EGIMS_V_VehicleRecording,		CreatorTool_Generic),
					#(EGIMS_V_CollisionMesh,		CreatorTool_Generic),
					#(EGIMS_V_Col_PrimBox,			CreatorTool_CenteredBox),
					#(EGIMS_V_Col_PrimSphere,		CreatorTool_Sphere),
					#(EGIMS_V_Col_PrimCapsule,		CreatorTool_Capsule),
					#(EGIMS_V_Col_PrimCylinder,		CreatorTool_Cylinder),
					#(EGIMS_V_ModelDict,			CreatorTool_Generic),
					#(EGIMS_V_Model,				CreatorTool_Generic),
					#(EGIMS_V_Model_ModelMod,		CreatorTool_Generic),
					#(EGIMS_V_Model_Bone,			CreatorTool_Bone),
					#(EGIMS_V_Model_BoneMod,		CreatorTool_Generic),
					#(EGIMS_V_Model_Light,			CreatorTool_Light),
					#(EGIMS_V_Model_LightMod,		CreatorTool_Generic),
					#(EGIMS_V_ModelMesh,			CreatorTool_Generic),
					#(EGIMS_V_TexDict,				CreatorTool_Generic)--,
					--#(EGIMS_V_MapHelper,			CreatorTool_Generic)
				) do (
					local	Plug = PlugData[1]
					if Have Plug then (
						local	Category = (Plug.Category as String)
						if Category[1] != "_" then (
							local	Cores = GIMS.Cores,
									CategoryData = (FilterString Category "_"),
									PluginCoreTag = (CategoryData[1] as Name),
									CoreFound = false
							for Core in Cores where (Core.Tag as Name) == PluginCoreTag while not CoreFound do
								CoreFound = true
							if CoreFound then (
								local	AppendIfUniq = GIMS.Core.ArrayOps.AppendIfUniq,
										CoreTags = CreatableObjects_Data[1],
										Core_Cats = CreatableObjects_Data[2],
										Core_Cat_ObjNames = CreatableObjects_Data[3],
										Core_Cat_ModFlags = CreatableObjects_Data[4],
										Core_Cat_Objects = CreatableObjects_Data[5],
										ObjCatMap = CreatableObjects_Data[6],
										CoreFlagAndID = (AppendIfUniq CoreTags PluginCoreTag GetFlagWithID:true)
								if CoreFlagAndID[1] then (
									Append Core_Cats #()
									Append Core_Cat_ObjNames #()
									Append Core_Cat_ModFlags #()
									Append Core_Cat_Objects #()
								)
								local	CoreID = CoreFlagAndID[2],
										Cats = Core_Cats[CoreID],
										Cat_ObjNames = Core_Cat_ObjNames[CoreID],
										Cat_ModFlags = Core_Cat_ModFlags[CoreID],
										Cat_Objects = Core_Cat_Objects[CoreID],
										PluginCategory = (CategoryData[2] as Name),
										CatFlagAndID = (AppendIfUniq Cats PluginCategory GetFlagWithID:true)
								if CatFlagAndID[1] then (
									Append Cat_ObjNames #()
									Append Cat_ModFlags #{}
									Append Cat_Objects #()
								)
								local	CatID = CatFlagAndID[2],
										ObjNames = Cat_ObjNames[CatID],
										ModFlags = Cat_ModFlags[CatID],
										Objs = Cat_Objects[CatID]
								Append ObjNames Plug.Name
								if (IsKindOf Plug Modifier) then
									ModFlags[ObjNames.Count] = true
								Append Objs #(Plug, PlugData[2])
								Append ObjCatMap[1] Plug
								Append ObjCatMap[2] [CoreID, CatID, Objs.Count]
							)
						)
					)
				)
				local	CatNames = #(
							#Helpers,
							#Collisions,
							#PrimCollisions,
							#Models,
							#Fragments,
							#NavMeshes,
							#Paths,
							#Weapons,
							#Graphics,
							#Imposters
						),
						CatNameStrings = #(
							"Helpers",
							"Collisions",
							"Primitive collisions",
							"Models",
							"Fragments",
							"Navigation meshes",
							"Paths",
							"Weapons",
							"Graphics",
							"Imposters"
						)
				for CoreCats in CreatableObjects_Data[2] do (
					for CatID = 1 to CoreCats.Count do (
						local	CatNameID = (FindItem CatNames CoreCats[CatID])
						if CatNameID == 0 then
							throw ("Unknown plugin category found: " + (CoreCats[CatID] as String))
						CoreCats[CatID] = CatNameStrings[CatNameID]
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	(
		local	TL = (strTypeLibrary())
		TL.Load()
		GIMS.Core.TypeLibrary = TL
	)
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
