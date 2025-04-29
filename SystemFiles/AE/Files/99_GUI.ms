/*#PC*DEFINE	CurrentGame	AE*/
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/--try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI*/GUIstr (
	/*Ops*/
		fn Import_Create Sender Args InitLayout:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	\
							GUIMgr = GIMS.Core.GUIMgr,
							UpdateProgress = GUIMgr.UpdateProgress,
							ObjectMgr = GIMS.Core.ObjectMgr,
							Objs = ObjectMgr.ExchangeData[2],
							ObjStrings = ObjectMgr.ExchangeData[3],
							ObjCount = Objs.Count,
							BaseID = (ObjCount + 2)
					if InitLayout then
						GUIMgr.InitProgress ObjStrings Title:"Import"
					MAX Create Mode
					for ObjID = 1 to ObjCount do (
						UpdateProgress #Stage (ObjID + BaseID)
						local	Obj = Objs[ObjID]
						Obj.Create Obj
					)
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import_Files Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	GUIMgr = GIMS.Core.GUIMgr,
						ObjectMgr = GIMS.Core.ObjectMgr,
						SystemMgr = GIMS.Core.SystemMgr,
						AddResult = SystemMgr.AddResult,
						Files = ObjectMgr.ExchangeData[2],
						FileCount = Files.Count,
						HaveObjects = (FileCount != 0),
						Objs = #()
				if HaveObjects then (
					local	ValueOps = GIMS.Core.ValueOps,
							TypeCast = ValueOps.TypeCast,
							FileStrings = #(),
							FileStringStart = "\t> ",
							FileStringMid = ": "
					FileStrings.Count = FileCount
					for i = 1 to FileCount do (
						local	File = Files[i],
								FileType = (GetFileNameType File)
						FileType = (TypeCast (SubString FileType 2 FileType.Count) name)
						local	TypeString = (
									case FileType of (
										#aem:
											"Model"
										#bin: (
											local	FileName = (GetFileNameFile File)
											case of (
												(MatchPattern FileName Pattern:"weapons*"):
													"Weapons"
												(MatchPattern FileName Pattern:"*collision*"):
													"Collisions"
												Default:
													throw ("Unknown BIN file" + FileName)
											)
										)
										Default:
											"Unknown"	--return undefined	--throw "Unknown file type"
									)
								),
								FileString = (Copy FileStringStart)
						Append FileString TypeString
						Append FileString FileStringMid
						Append FileString (GetFileNameFile File)
						FileStrings[i] = FileString
					)
					FileStrings = (
						#("Read from file") +
						FileStrings +
						#("Create in scene") +
						FileStrings
					)
					local	TexPath
					GUIMgr.InitProgress FileStrings Title:"Import"
					local	\
							StructFromFile = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.StructFromFile,
							UpdateProgress = GUIMgr.UpdateProgress,
							Iterator = 0
					Objs.Count = FileCount
					for FileID = 1 to FileCount do (
						UpdateProgress #Stage (FileID + 1)
						local	Obj = (StructFromFile Files[FileID])
						if Have Obj then (
							Iterator += 1
							Objs[Iterator] = Obj
						)
					)
					Objs.Count = Iterator
					HaveObjects = (Iterator != 0)
					if HaveObjects then
						ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Import_Create, 2), Objs, FileStrings)
					else
						AddResult #Error "Can't import anything."
				)
				if (SystemMgr.HaveResults()) then
					GUIMgr.EndProgress true Continueable:HaveObjects
				else (
					if HaveObjects then
						Import_Create Sender Args InitLayout:false
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					GIMS.Core.ObjectMgr.ExchangeData = #(undefined, (GIMS.Core.GUI.SelectFiles "Select the resources to load" true "Abyss Engine resource|*.aem;*collision*.bin;weapons*.bin"))
					Import_Files Sender Args
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							UpdateProgress = GUIMgr.UpdateProgress,
							SavePath = (GetSavePath Caption:"Select a location to export" InitialDir:GUIMgr.LastPath)
					if Have SavePath then (
						Append SavePath "\\"
						GUIMgr.LastPath = SavePath
						GUIMgr.InitProgress #(
							"Collect objects from scene"
						) Title:"Export"
						UpdateProgress #Stage 1
						local	Objs = (GIMS.Core.MAXFactory.SceneOps.GetObjsToExport()),
								HaveObjects = (Objs.Count != 0)
						if not HaveObjects then
							GIMS.Core.SystemMgr.AddResult #Error "Nothing found to export."
						GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_Select, 2), Objs, SavePath)
						GUIMgr.EndProgress true Continueable:HaveObjects
					)
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_Select Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	ObjectMgr = GIMS.Core.ObjectMgr,
							GUIMgr = GIMS.Core.GUIMgr,
							ExchangeData = ObjectMgr.ExchangeData,
							GetPathString = GIMS.Core.ObjectMgr.GetPathString,
							Objs = ExchangeData[2],
							SavePath = ExchangeData[3],
							ObjCount = Objs.Count
					GUIMgr.SetWindow GIMS.Shared #Selection
					local	ListControl = (GUIMgr.FindControl #ObjectList),
							ObjStrings = (GIMS.Core.GUI.BuildCNodeTree ListControl Objs ObjTree)
					ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_StructsFromObjs, 2), Objs, ObjStrings, SavePath)
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_Write Sender Args InitLayout:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							AddResult = GIMS.Core.SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
							Objs = ExchangeData[2],
							ObjStrings = ExchangeData[3],
							ObjCount = Objs.Count,
							BaseID = (ObjCount + 2),
							Obj
					if InitLayout then
						GUIMgr.InitProgress ObjStrings Title:"Export"
					for ObjID = 1 to ObjCount do (
						UpdateProgress #Stage (ObjID + BaseID)
						Objs[ObjID].Write()
					)
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_StructsFromObjs Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							ObjectMgr = GIMS.Core.ObjectMgr,
							SystemMgr = GIMS.Core.SystemMgr,
							AddResult = SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
							Objs = ExchangeData[2],
							ObjStrings = ExchangeData[3]
					GIMS.Core.GUI.PurgeCNodes Objs CNodeStrings:ObjStrings
					local	SavePath = ExchangeData[4],
							ObjCount = Objs.Count,
							\
							HaveObjects = (ObjCount != 0)
					if HaveObjects then (
					
						--show export UI
						for i = 1 to ObjCount do
							ObjStrings[i] = (Append "\t> " ObjStrings[i])
						ObjStrings = (
							#("Collect from scene") +
							ObjStrings +
							#("Write to file") +
							ObjStrings
						)
						GUIMgr.InitProgress ObjStrings Title:"Export"
						
						--convert cnodes to structs and store failed
						MAX Create Mode
						local	StructFromScene = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.StructFromScene,
								UpdateProgress = GUIMgr.UpdateProgress,
								FailedObjIDs = #{},
								FailedObjectCount = 0
						FailedObjIDs.Count = ObjCount
						for i = 1 to ObjCount do (
							UpdateProgress #Stage (i + 1)
							local	ObjStruct = (StructFromScene Objs[i] DiskPath:SavePath)
							if Have ObjStruct then
								Objs[i] = ObjStruct
							else (
								FailedObjIDs[i] = true
								FailedObjectCount += 1
							)
						)
						
						--delete failed objects and their strings
						for i = ObjCount to 1 by -1 where FailedObjIDs[i] do (
							DeleteItem Objs i
							DeleteItem ObjStrings i
						)
						ObjCount -= FailedObjectCount
						
						--check final object count
						HaveObjects = (ObjCount != 0)
						if not HaveObjects then
							AddResult #Error "Can't export anything."
					) else
						AddResult #Error "Nothing selected to export."
					ObjectMgr.ExchangeData = #(
						#(GIMS.CurrentGame, 2, #Export_Write, 2),
						Objs,
						ObjStrings,
						(ObjCount + 2)
					)
					if (SystemMgr.HaveResults()) then
						GUIMgr.EndProgress true Continueable:HaveObjects
					else
						Export_Write Sender Args InitLayout:false
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ChangeGamePath Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Game = GIMS.CurrentGame
					if (QueryBox "Are you really want to change the game path?" Title:("GIMS for " + Game.Name)) then (
						GIMS.Core.GUIMgr.MainWindow.Close()
						GIMS.Core.SystemMgr.FileDelete (Game.BasePath + "Paths.txt")
						Game.Start Game
					)
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ImportShip Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	ShipID = (Sender.SelectedIndex + 1)
				if ShipID != 0 then (
					local	\
							ShipModelMap = GIMS.CurrentGame.Core.DB.ShipModelMap,
							AddResult = GIMS.Core.SystemMgr.AddResult,
							Continueable = (
								if Have ShipModelMap[1][ShipID] then (
									local	TypeCast = GIMS.Core.ValueOps.TypeCast,
											GameMgr = GIMS.CurrentGame.Core.GameMgr,
											AEMFiles = GameMgr.AEMFiles,
											AEMFileNames = GameMgr.AEMFileNames,
											AEMFileCount = AEMFiles.Count,
											TabStart = "\t> ",
											ModelsToImport = #(),
											ModelCount = ShipModelMap.Count,
											ModelID = 0
									ModelsToImport.Count = (ModelCount - 1)
									for i = 2 to ModelCount do (
										local	Item = ShipModelMap[i][ShipID]
										if Have Item then (
											local	AEMID = (FindItem AEMFileNames (TypeCast Item Name))
											if AEMID > 0 then (
												ModelID += 1
												ModelsToImport[ModelID] = AEMFiles[AEMID]
											) else
												AddResult #Warning ("Ship model map contains model that wasn't found: " + Item)
										)
									)
									ModelsToImport.Count = ModelID
									if (ModelID != 0) then (
										GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Import_Files, 2), ModelsToImport)
										true
									) else (
										AddResult #Error "Can't import anything."
										false
									)
								) else (
									AddResult #Error "Can't import unknown ship."
									false
								)
							)
					GIMS.Core.GUIMgr.EndProgress true Continueable:Continueable
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowShips Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	GUIMgr = GIMS.Core.GUIMgr,
						ShipModelMapNames = GIMS.CurrentGame.Core.DB.ShipModelMap[1],
						ShipNames = #()
				for i = ShipModelMapNames.Count to 1 by -1 do (
					local	ShipName = ShipModelMapNames[i]
					ShipNames[i] = (
						if Have ShipName then
							ShipName
						else
							""
					)
				)
				GIMS.Core.GUI.SetLines (GUIMgr.FindControl #ShipList) ShipNames
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	GIMS.CurrentGame.Core.GUI = GUIstr()
/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
