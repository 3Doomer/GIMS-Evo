/*#PC*DEFINE	CurrentGame	NR*/
/*<PROFILERSTART>*//*(LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.ConfigProps*/ ConfigPropsstr (
		BuildDate = "",
		CacheResetDate = "",
		RAWBuildDate = #(),
		Files = #(),
		Sizes = #(),
		Hashes = #(),
		Versions = #(),
		ChangeLog
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.strVDMap*/ VDMapstr (
		GIMSObjectLink = "GIMS.CurrentGame.Core.strVDMap",
		SourceValueTypeIDs = unsupplied,
		SourceValueCounts = unsupplied,
		SourceChannelNames = unsupplied,
		TargetTypeIDs = unsupplied,	--1: applied at read from file or cache
		TargetChannelNames = unsupplied,	--2: applied at create
		TargetChannelModifiers = unsupplied,	--3: applied at create
		TargetChannelPerValueMods = unsupplied,	--4: applied at create
		TargetChannelOrder = unsupplied	--5: applied at create
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.strRules*/ Rulesstr (
		GIMSObjectLink = "GIMS.CurrentGame.Core.strRules",
		ProMode = GIMS.IsDevBuild,
		PresetFiles = #(),
		PresetNames = #(),
		PresetCount = 0,
		ActivePresetID = 0,
		Changed = false,
		EngineVDMapping = #(
			#(	--engines
				"Frostbite 2",
				"Frostbite 3",
				"Frostbite 3.5",
				"YETI engine"
			), #(	--VD maps
				#(	--Frostbite 2
					(	--4
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1
							) \
							TargetChannelOrder:#(
								1,
								2,
								4,
								3
							)
					),
					(	--6
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#COLOR,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1,
								1
							)
					),
					(	--7
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#COLOR,
								#COLOR,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1,
								1,
								1
							)
					),
					(	--8
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#TEXCOORD,
								#TEXCOORD,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#COLOR
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								3,
								1,
								1,
								1,
								1,
								1
							) \
							TargetChannelOrder:#(
								1, --#POSITION,
								2, --#BLENDINDICES,
								7, --#TEXCOORD,
								4, --#TEXCOORD,
								5, --#NORMAL,
								6, --#TANGENT,
								3, --#TEXCOORD,
								8 --#COLOR
							)
					),
					(	--9
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#COLOR,
								#TEXCOORD,
								#TEXCOORD,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#COLOR
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								3,
								1,
								1,
								1,
								1,
								1
							) \
							TargetChannelOrder:#(
								1, --#POSITION,
								2, --#BLENDINDICES,
								3, --#COLOR,
								8, --#TEXCOORD,
								5, --#TEXCOORD,
								6, --#NORMAL,
								7, --#TANGENT,
								4, --#TEXCOORD,
								9 --#COLOR
							)
					)
				),
				#(	--Frostbite 3
					(	--1
						VDMapstr \
							TargetChannelNames:#(
								#POSITION
							) \
							SourceValueTypeIDs:#(
								1
							)
					),
					(	--2
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2
							)
					),
					(	--3
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#BLENDWEIGHT
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1
							)
					),
					(	--3
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#COLOR
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1
							)
					),
					(	--4
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1
							) \
							TargetChannelOrder:#(
								1,
								2,
								4,
								3
							)
					),
					(	--5
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1
							)
					),
					(	--6
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#COLOR,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#COLOR
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1
							)
					),
					(	--7
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								3,
								4,
								4,
								4,
								4,
								4,
								4
							) \
							TargetChannelOrder:#(
								1,
								4,
								5,
								6,
								7,
								2,
								3
							)
					),
					(	--7
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								3,
								4,
								4,
								4,
								4,
								4,
								2
							) \
							TargetChannelOrder:#(
								1,
								4,
								5,
								6,
								7,
								2,
								3
							)
					),
					(	--8
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#BLENDWEIGHT,
								#COLOR,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							TargetChannelOrder:#(
								1,	--#POSITION,
								2,	--#BLENDINDICES,
								3,	--#BLENDWEIGHT,
								6,	--#COLOR,
								7,	--#NORMAL,
								8,	--#TANGENT,
								5,	--#TEXCOORD,
								4	--#TEXCOORD
							)
					),
					(	--8
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1
							)
					),
					(	--9
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#COLOR,
								#TANGENT,
								#NORMAL,
								#BINORMAL,
								#TEXCOORD,
								#BLENDWEIGHT,
								#BLENDINDICES,
								#TEXCOORD	--actually, it might be another 2 weights(there was only 2)
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								2,
								1
							)
					),
					(	--10
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#COLOR,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4
							)
					),
					(	--11
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1
							)
					),
					(	--14
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								1
							) \
							TargetChannelOrder:#(
								1,
								11,
								3,
								4,
								5,
								6,
								7,
								8,
								9,
								10,
								2,
								12,
								13,
								14
							)
					)
				),
				#(	--Frostbite 3.5
					(	--4
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								2
							)
					),
					(	--4
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4
							)
					),
					(	--5
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#NORMAL,
								#TANGENT,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4
							)
					),
					(	--6
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#BLENDWEIGHT,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								4
							)
					),
					(	--6
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#BLENDWEIGHT,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								2
							)
					),
					(	--8
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								1,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								1
							)
					),
					(	--8
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#BLENDINDICES,
								#BLENDINDICES,
								#BLENDWEIGHT,
								#BLENDWEIGHT,
								#NORMAL,
								#TANGENT,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								2,
								2,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								2
							)
					),
					(	--9
						VDMapstr \
							TargetChannelNames:#(
								#POSITION,
								#TANGENT,
								#BLENDINDICES,
								#BLENDINDICES,
								#BLENDWEIGHT,
								#BLENDWEIGHT,
								#NORMAL,
								#BINORMAL,
								#TEXCOORD
							) \
							SourceValueTypeIDs:#(
								1,
								1,
								2,
								2,
								1,
								1,
								1,
								1,
								1
							) \
							SourceValueCounts:#(
								3,
								4,
								4,
								4,
								4,
								4,
								4,
								4,
								2
							)
					)
				),
				#(	--YETI engine
					(	--2
						VDMapstr \
							SourceChannelNames:#(
								#POSITION,
								#COLOR
							) \
							SourceValueCounts: #(
								4, --#POSITION,
								4 --#COLOR
							) \
							SourceValueTypeIDs: #(
								1, --#POSITION,
								2 --#COLOR
							) \
							TargetChannelNames:#(
								#POSITION,
								#COLOR
							) \
							TargetChannelModifiers:#(
								unsupplied, --#POSITION,
								#(255, #Divide) --#COLOR,
							)
					),
					(	--7
						VDMapstr \
							SourceChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#COLOR,
								#BLENDWEIGHT,
								#BLENDINDICES,
								#NORMAL,
								#TANGENT
							) \
							SourceValueTypeIDs: #(
								3, --#POSITION,
								3, --#TEXCOORD,
								2, --#COLOR,
								2, --#BLENDWEIGHT,
								2, --#BLENDINDICES,
								1, --#NORMAL,
								1 --#TANGENT
							) \
							SourceValueCounts: #(
								4, --#POSITION,
								2, --#TEXCOORD,
								4, --#COLOR,
								4, --#BLENDWEIGHT,
								4, --#BLENDINDICES,
								4, --#NORMAL,
								4 --#TANGENT
							) \
							TargetChannelNames:#(
								#POSITION,
								#TEXCOORD,
								#COLOR,
								#BLENDWEIGHT,
								#BLENDINDICES,
								#NORMAL,
								#TANGENT
							) \
							TargetTypeIDs: #(
								3, --#POSITION,
								2, --#TEXCOORD,
								2, --#COLOR,
								2, --#BLENDWEIGHT,
								2, --#BLENDINDICES,
								1, --#NORMAL,
								1 --#TANGENT
							) \
							TargetChannelPerValueMods:#(
								#XYZMultWDiv6553500, --#POSITION,
								unsupplied, --#TEXCOORD,
								unsupplied, --#COLOR,
								unsupplied, --#BLENDWEIGHT,
								unsupplied, --#BLENDINDICES,
								unsupplied, --#NORMAL,
								unsupplied --#TANGENT
							) \
							TargetChannelModifiers:#(
								unsupplied, --#POSITION,
								#(1024, #Divide), --#TEXCOORD,
								#(255, #Divide), --#COLOR,
								#(255, #Divide), --#BLENDWEIGHT,
								unsupplied, --#BLENDINDICES,
								unsupplied, --#NORMAL,
								unsupplied --#TANGENT
							)
					)
				)
			)
		),
		fn ActivatePreset ID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if ID == #Last then
					ID = PresetCount
				if ActivePresetID != ID then
					Changed = true
				ActivePresetID = ID
				PresetFiles[ActivePresetID]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AddPreset FilePath FileName = (
			Changed = true
			Append PresetFiles FilePath
			Append PresetNames FileName
			PresetCount += 1
			ActivePresetID = PresetCount
			ActivatePreset ActivePresetID
			ActivePresetID
		),
		fn RemovePreset = (
			if
				ActivePresetID != 1 and
				((QueryBox ("Are you really want to remove preset \"" + PresetNames[ActivePresetID] + "\"?") Title:"GIMS NR preset manager") == true)
			then (
				Changed = true
				DeleteItem PresetFiles ActivePresetID
				DeleteItem PresetNames ActivePresetID
				PresetCount -= 1
				ActivePresetID -= 1
				true
			) else
				false
		)
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.CoreOps*/ CoreOpsstr (
		fn FirstLaunchCleanup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn InitShortcuts = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GUIMgr = GIMS.Core.GUIMgr,
						ObjectMgr = GIMS.Core.ObjectMgr,
						GObjectMgr = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr,
						ArrayOps = GIMS.Core.ArrayOps,
						ValueOps = GIMS.Core.ValueOps
				GObjectMgr.ReadCached = GIMS.Core.CacheMgr.ReadCached
				GObjectMgr.UpdateProgress = GUIMgr.UpdateProgress
				GObjectMgr.AddResult = GIMS.Core.SystemMgr.AddResult
				GObjectMgr.TypeCast = ValueOps.TypeCast
				GObjectMgr.ConvertStruct = ValueOps.ConvertStruct
				GObjectMgr.CreateIfUnique = ObjectMgr.CreateIfUnique
				GObjectMgr.CalculateBounds = ObjectMgr.CalculateBounds
				GObjectMgr.ExtendBound = ObjectMgr.ExtendBound
				GObjectMgr.RemoveSmoothingGroups = ObjectMgr.RemoveSmoothingGroups
				GObjectMgr.GetPathString = ObjectMgr.GetPathString
				GObjectMgr.Split = ArrayOps.Split
				GObjectMgr.Modify = ArrayOps.Modify
				GObjectMgr.RotateA = ArrayOps.RotateA
				GObjectMgr.NormalizeA = ArrayOps.NormalizeA
				GObjectMgr.QuickSort = ArrayOps.QuickSort
				GObjectMgr.AppendMHL = ArrayOps.AppendMHL
				GObjectMgr.FetchMHL = ArrayOps.FetchMHL
				GObjectMgr.RebuildMHL = ArrayOps.RebuildMHL
				GObjectMgr.CreateMesh = ObjectMgr.CreateMesh
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				InitShortcuts()
				local	\
						GUIMgr = GIMS.Core.GUIMgr,
						UpdateProgress = GUIMgr.UpdateProgress
				GUIMgr.LoadInterface GIMS.CurrentGame
				GUIMgr.SetWindow GIMS.CurrentGame #Main
				GIMS.CurrentGame.Core.DB.Load()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core*/ Corestr (
		/*PARTS*/		strRules = Rulesstr,
						strVDMap = VDMapstr,
						ConfigProps = ConfigPropsstr(),
						CoreOps = CoreOpsstr(),
						DB,
						TypeLibrary,
						MAXFactory,
						GUI
	)
	GIMS.CurrentGame.Core = (Corestr())
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS)*//*<PROFILERENDED>*/
