/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
	
	struct ConfigPropsstr (
		BuildDate = "",
		CacheResetDate = "",
		RAWBuildDate = #(),
		Files = #(),
		Sizes = #(),
		Versions = #(),
		ChangeLog
	)
	struct Rulesstr (
		ModelVertBufferSize = 65535,
		ColVertBufferSize = 32767,
		ColMaterialBufferSize = 255,
		ColPolyPlanarCoef = 0.01,
		ColPolyMaxArea = 1000,
		NODHeightBounds = [-512, 511.9],
		SkinVertBoneCount = 4,
		SkinPerGeoMaxBoneCount = 48,
		SkeletonMaxBoneCount = 255,
		DefaultMaterialPropMapping = #(
			#NavData,
			#CollisionData,
			#ShaderData,
			#MapsLocationData,
			#ColorData,
			#ColorData2,
			#PowerData,
			#ClipData,
			#DiffuseMap_1,
			#DiffuseMap_2,
			#NormalMap,
			#SpecMap,
			#RefMap,
			#DirtMap,
			#BlendLayerMap_1,
			#BlendLayerMap_2,
			#BlendLayerMap_3,
			#BlendLayerMap_4,
			#BlendLayerMap_4
		),
		ExportFilter = #(
			#( /*root objs/mods*/
				EGIMS_IV_CollisionDict,
				EGIMS_IV_ColComposite,
				EGIMS_IV_Car_Wheel,
				GIMS_IV_Col_Box,
				GIMS_IV_Col_Sphere,
				GIMS_IV_Col_Capsule,
				EGIMS_IV_ModelDict,
				EGIMS_IV_Model,
				#EGIMS_IV_CollisionMesh
				/*#EGIMS_IV_FragType
				#EGIMS_IV_NavMesh
				#EGIMS_IV_NavMesh_Portal*/
			), #( /*objs/mods*/
				EGIMS_IV_CollisionDict,
				EGIMS_IV_ColComposite,
				EGIMS_IV_Car_Wheel,
				GIMS_IV_Col_Box,
				GIMS_IV_Col_Sphere,
				GIMS_IV_Col_Capsule,
				#EGIMS_IV_CollisionMesh,
				EGIMS_IV_ModelDict,
				EGIMS_IV_Model,
				EGIMS_IV_Model_Bone,
				EGIMS_IV_Model_Light,
				#EGIMS_IV_ModelMesh,
				#EGIMS_IV_FragType,
				#EGIMS_IV_FragType_Group,
				#EGIMS_IV_FragType_Child,
				#EGIMS_IV_NavMesh_Portal,
				#EGIMS_IV_NavMesh,
				GeoSphere
			), #( /*children filters*/
				#( /*IV_CollisionDict*/
					EGIMS_IV_ColComposite,
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule,
					#EGIMS_IV_CollisionMesh
				), #( /*IV_ColComposite*/
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule,
					#EGIMS_IV_CollisionMesh
				),
				undefined, /*IV_Car_Wheel*/
				undefined, /*IV_Col_Box*/
				undefined, /*IV_Col_Sphere*/
				undefined, /*IV_Col_Capsule*/
				undefined, /*IV_CollisionMesh*/
				#( /*IV_ModelDict*/
					EGIMS_IV_Model
				), #( /*IV_Model*/
					EGIMS_IV_Model_Bone,
					EGIMS_IV_Model_Light,
					#EGIMS_IV_ModelMesh
					/*MODEL+COL*
					EGIMS_IV_ColComposite,
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule,
					#EGIMS_IV_CollisionMesh,
					/**/
				), #( /*IV_Model_Bone*/
					EGIMS_IV_Model_Bone,
					EGIMS_IV_Model_Light,
					#EGIMS_IV_ModelMesh,
					#EGIMS_IV_FragType_Child
				),
				undefined, /*IV_Model_Light*/
				#( /*IV_ModelMesh*/
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule,
					#EGIMS_IV_CollisionMesh
				), #( /*IV_FragType (mod)*/
					EGIMS_IV_Model_Bone, /*forever*/
					#EGIMS_IV_FragType_Group
				), #( /*IV_FragType_Group*/
					EGIMS_IV_Model_Bone,
					EGIMS_IV_Model_Light,
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule,
					#EGIMS_IV_CollisionMesh,
					#EGIMS_IV_ModelMesh,
					#EGIMS_IV_FragType_Child,
					#EGIMS_IV_FragType_Group
				), #( /*IV_FragType_Child*/
					EGIMS_IV_CollisionMesh,
					EGIMS_IV_Car_Wheel,
					GIMS_IV_Col_Box,
					GIMS_IV_Col_Sphere,
					GIMS_IV_Col_Capsule
				),
				undefined, /*IV_NavMesh_Portal*/
				#( /*IV_NavMesh*/
					EGIMS_IV_NavMesh_Obstacle
				),
				undefined /*GeoSphere*/
			)
		)
	)
	if No GIMS.CurrentGame.Rules then
		GIMS.CurrentGame.Rules = (Rulesstr())
	
	struct GameMgrstr (	/*REMOVE DEBUG LINES*/
		/*SYSTEM*/				EFLC = false,
									EncryptionKeyHash = 0x03BADE2A,
		/*GAME PATHS*/		EXEFile, GamePath, EPGamePath,
		/*CONFIG FILES*/		DatFiles = #(),
		/*FILES*/				WaterFile, ScrollbarsFile, CarColsFile, PedGrpFile, ScenariosFile, ShadersFile, EntityFXFile, MaterialsFile, ProcMaterialsFile, TCycModFiles,
		/*MAP FILES*/			IMGFiles = #(#(), #()),
									IDEFiles = #(#(), #()),
									IPLFiles = #(#(), #()),
									WPLFiles = #(#(), #()),
									ThisObj,
		fn CacheResources = (	/*REMOVE DEBUG LINES*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				UpdateProgress #AddStage 1
				local	TimeStart, /*DEBUG LINE*/
						TimeEnd, /*DEBUG LINE*/
						ReadCached = Core.CacheMgr.ReadCached,
						TypeLibrary = GCore.TypeLibrary,
						DoGC = Core.SystemMgr.DoGC,
						Files, FileCount,
						WPLType = "WPL",
						IPLType = "IPL",
						IDEType = "IDE"
				/*WPL*/
				TimeStart = (GetTimeStamp()) /*DEBUG LINE*/
				Files = WPLFiles
				FileCount = Files.Count
				for FileID = 1 to FileCount do (
					ReadCached Files[FileID] TypeLibrary.WPLFile GCCPath:#ResourceCachePath Type:WPLType
					UpdateProgress #Progress [0, FileCount, FileID]
				)
				TimeEnd = (GetTimeStamp()) /*DEBUG LINE*/
				/*Format "GIMS Evo % has loaded WPL files in % seconds\n" CurrentGame.Name (0.001 * (TimeEnd - TimeStart)) /*DEBUG LINE*/
				DoGC()
				/**/
				/*IPL*/
				TimeStart = (GetTimeStamp()) /*DEBUG LINE*/
				UpdateProgress #AddStage 1
				Files = IPLFiles
				FileCount = Files.Count
				for FileID = 1 to FileCount do (
					ReadCached Files[FileID] TypeLibrary.IPLFile GCCPath:#ResourceCachePath Type:IPLType
					UpdateProgress #Progress [0, FileCount, FileID]
				)
				TimeEnd = (GetTimeStamp()) /*DEBUG LINE*/
				/*Format "GIMS Evo % has loaded IPL files in % seconds\n" CurrentGame.Name (0.001 * (TimeEnd - TimeStart)) /*DEBUG LINE*/
				DoGC()
				/**/
				/*IDE*/
				TimeStart = (GetTimeStamp()) /*DEBUG LINE*/
				UpdateProgress #AddStage 1
				Files = IDEFiles
				FileCount = Files.Count
				for FileID = 1 to FileCount do (
					ReadCached Files[FileID] TypeLibrary.IDEFile GCCPath:#ResourceCachePath Type:IDEType
					UpdateProgress #Progress [0, FileCount, FileID]
				)
				TimeEnd = (GetTimeStamp()) /*DEBUG LINE*/
				/*Format "GIMS Evo % has loaded IDE files in % seconds\n" CurrentGame.Name (0.001 * (TimeEnd - TimeStart)) /*DEBUG LINE*/
				DoGC()
				/**/
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadIMGList IMGListFile Content = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result = #(#(), #())
				if (DoesFileExist IMGListFile) then (
					local	SCore = GIMS.Core,
							AppendMHL = SCore.ArrayOps.AppendMHL,
							ValueOps = SCore.ValueOps,
							FormatText = ValueOps.FormatText,
							TypeCast = ValueOps.TypeCast,
							BufferMgr = SCore.BufferMgr,
							ReadVal = BufferMgr.ReadVal,
							NotEOF = BufferMgr.NotEOF,
							IMGExt = ".img",
							tLine, TargetDir
					BufferID = (BufferMgr.ReadFile IMGListFile)
					if Content then (
						while (NotEOF BufferID) do (
							local tLine = (ReadVal BufferID FilterStr:": \t" ValidateGTAString:true)
							if tLine != #InvalidLine then (
								AppendMHL Result (
									FormatText \
										v1:EPGamePath \
										v2:tLine[1] \
										v3:IMGExt
								)
							)
						)
					) else (
						while (NotEOF BufferID) do (
							local tLine = (ReadVal BufferID FilterStr:": \t" ValidateGTAString:true)
							if tLine != #InvalidLine then (
								if (TypeCast tLine[1] name) == #commonimg then
									TargetDir = (GamePath + "common")
								else
									TargetDir = (GamePath + "pc")
								AppendMHL Result (
									FormatText \
										v1:TargetDir \
										v2:tLine[2] \
										v3:IMGExt
								)
							)
						)
					)
					BufferMgr.ClearBuffer BufferID
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadDatFile DatFile tGamePath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local IMGFilesTemp = #(#(), #()),
						IDEFilesTemp = #(#(), #()),
						IPLFilesTemp = #(#(), #()),
						WPLFilesTemp = #(#(), #()),
						DelayedIMG = #(#(), #()),
						DelayedIDE = #(#(), #()),
						DelayedIPL = #(#(), #()),
						DelayedWPL = #(#(), #()),
						IMGToRemove = #(#(), #()),
						IDEToRemove = #(#(), #()),
						IPLToRemove = #(#(), #()),
						WPLToRemove = #(#(), #()),
						TempIMGListFile,
						TempPedGrpFile,
						TempCarColsFile,
						TempScrollbarsFile,
						TempWaterFile
				if (DoesFileExist DatFile) then (
					local	SCore = GIMS.Core,
							ArrayOps = SCore.ArrayOps,
							AppendMHL = ArrayOps.AppendMHL,
							ValueOps = SCore.ValueOps,
							FormatText = ValueOps.FormatText,
							TypeCast = ValueOps.TypeCast,
							BufferMgr = SCore.BufferMgr,
							NotEOF = BufferMgr.NotEOF,
							ReadFile = BufferMgr.ReadFile,
							ReadVal = BufferMgr.ReadVal,
							WPLExt = ".wpl",
							IMGExt = ".img",
							CommonDir = "common",
							PlatformDir = "pc",
							StdCommonDir = (GamePath + CommonDir),
							StdPlatformDir = (GamePath + PlatformDir),
							BufferID = (ReadFile DatFile),
							tLine,
							tag,
							tag2,
							FilePath, FileNameType, FileType,
							WPLFile,
							Reading = true
					CommonDir = (tGamePath + CommonDir)
					PlatformDir = (tGamePath + PlatformDir)
					while
						Reading and
						(NotEOF BufferID)
					do (
						local tLine = (ReadVal BufferID FilterStr:": \t" ValidateGTAString:true)
						if tLine != #InvalidLine then (
							tag = (TypeCast tLine[1] name)
							if tag != #end then (
								if Have tLine[2] then (
									if tLine.Count > 2 then (
										if (TypeCast tLine[2] name) == #common then
											FilePath = (CommonDir + tLine[3])
										else
											FilePath = (PlatformDir + tLine[3])
									) else
										FilePath = (tGamePath + tLine[2])
									case tag of (
										#imglist: (
											if (DoesFileExist FilePath) then
												TempIMGListFile = FilePath
										)
										#pedgrp: (
											if (DoesFileExist FilePath) then
												TempPedGrpFile = FilePath
										)
										#carcols: (
											if (DoesFileExist FilePath) then
												TempCarColsFile = FilePath
										)
										#scrollbar: (
											if (DoesFileExist FilePath) then
												TempScrollbarsFile = FilePath
										)
										#water: (
											if (DoesFileExist FilePath) then
												TempWaterFile = FilePath
										)
										#img: (
											if (DoesFileExist FilePath) then
												AppendMHL IMGFilesTemp FilePath
										)
										#ide: (
											if (DoesFileExist FilePath) then
												AppendMHL IDEFilesTemp FilePath
										)
										#ipl: (
											WPLFile = (
												FormatText \
													v1:(GetFileNamePath FilePath) \
													v2:(GetFileNameFile FilePath) \
													v3:WPLExt
											)
											if (DoesFileExist WPLFile) then
												AppendMHL WPLFilesTemp WPLFile
											else (
												if (DoesFileExist FilePath) then
													AppendMHL IPLFilesTemp FilePath
											)
										)
										#delayed_img: (
											if (DoesFileExist FilePath) then
												AppendMHL DelayedIMG FilePath
										)
										#delayed_ide: (
											if (DoesFileExist FilePath) then
												AppendMHL DelayedIDE FilePath
										)
										#delayed_ipl: (
											local	TempWPLPath = tLine[2]
											WPLFile = (
												FormatText \
													v1:(GetFileNamePath TempWPLPath) \
													v2:(GetFileNameFile TempWPLPath) \
													v3:WPLExt
											)
											if (DoesFileExist WPLFile) then
												AppendMHL DelayedEPWPL WPLFile
											else (
												if (DoesFileExist FilePath) then
													AppendMHL DelayedIPL FilePath
											)
										)
										#disable_file: (
												tag2 = (TypeCast tLine[2] name)
												case tag2 of (
													#commonimg: (
														AppendMHL IMGToRemove (
															FormatText \
																v1:StdCommonDir \
																v2:tLine[3] \
																v3:IMGExt
														)
													)
													#platformimg: (
														AppendMHL IMGToRemove (
															FormatText \
																v1:StdPlatformDir \
																v2:tLine[3] \
																v3:IMGExt
														)
													)
													#common:
														FilePath = StdCommonDir
													#platform:
														FilePath = StdPlatformDir
												)
												if
													tag2 == #common or
													tag2 == #platform
												then (
													FileNameType = tLine[3]
													FileType = (TypeCast (SubString FileNameType (FileNameType.Count - 2) 3) name)
													case FileType of (
														#IDE:
															AppendMHL IDEToRemove (FilePath + FileNameType)
														#IPL: (
															WPLFile = (
																FormatText \
																	v1:FilePath \
																	v2:(GetFileNameFile FileNameType) \
																	v3:WPLExt
															)
															if (DoesFileExist WPLFile) then
																AppendMHL WPLToRemove WPLFile
															else
																AppendMHL IPLToRemove (FilePath + FileNameType)
														)
														#ZON:
															AppendMHL IPLToRemove (FilePath + FileNameType)
													)
												)
										)
										#exit:
											Reading = false
									)
								)
							) else
								Reading = false
						)
					)
					BufferMgr.ClearBuffer BufferID
				)
				#(
					IMGFilesTemp,
					IDEFilesTemp,
					IPLFilesTemp,
					WPLFilesTemp,
					DelayedIMG,
					DelayedIDE,
					DelayedIPL,
					DelayedWPL,
					IMGToRemove,
					IDEToRemove,
					IPLToRemove,
					WPLToRemove,
					TempIMGListFile,
					TempPedGrpFile,
					TempCarColsFile,
					TempScrollbarsFile,
					TempWaterFile
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadGameConfig = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local CommonDir = "common",
						PlatformDir = "pc",
						CommonDataPath = (CommonDir + "\\data\\"),
						PlatformDataPath = (PlatformDir + "\\data\\"),
						CommonGameDataPath = (GamePath + CommonDataPath)
				DatFiles = #(
					(CommonGameDataPath + "default.dat"),
					(CommonGameDataPath + "gta.dat")
				)
				if EFLC then
					Append DatFiles (EPGamePath + "content.dat")
				ShadersFile = (GIMS.CurrentGame.Core.OpenIVPath + "Games\\IV\\openFormats\\ShaderManager.xml")
				if not (DoesFileExist ShadersFile) then
					throw "Can't find needed OpenIV files. Please update it."
				ScrollbarsFile = (CommonGameDataPath + "scrollbars.dat")
				CarColsFile = (CommonGameDataPath + "carcols.dat")
				WaterFile = (CommonGameDataPath + "water.dat")
				PedGrpFile = (CommonGameDataPath + "pedgrp.dat")
				ScenariosFile = (CommonGameDataPath + "scenarios.dat")
				EntityFXFile = (CommonGameDataPath + "effects\\entityfx.dat")
				MaterialsFile = (CommonGameDataPath + "materials\\materials.dat")
				ProcMaterialsFile = (CommonGameDataPath + "materials\\procedural.dat")
				TCycModFiles = (
					GetFiles (
						GIMS.Core.ValueOps.FormatText \
							v1:GamePath \
							v2:PlatformDataPath \
							v3:"timecyclemodifiers*.dat"
					)
				)
				local	Core = GIMS.Core,
						ArrayOps = Core.ArrayOps,
						Remove = ArrayOps.Remove,
						AppendMHL = ArrayOps.AppendMHL,
						MergeMHL = ArrayOps.MergeMHL,
						RemoveMHL = ArrayOps.RemoveMHL,
						ReadCached = Core.CacheMgr.ReadCached,
						DatFileCount = DatFiles.Count,
						IMGListFile,
						EPIMGListFile,
						TempPedGrpFile,
						TempCarColsFile,
						TempScrollbarsFile,
						TempWaterFile,
						DataToRemoveLists = #(
								#(#(), #()), /*IVIMGToRemove*/
								#(#(), #()), /*IVIDEToRemove*/
								#(#(), #()), /*IVIPLToRemove*/
								#(#(), #()) /*IVWPLToRemove*/
						),
						TargetDataLists = #(
							#(
								#(#(), #()), /*IVIMG*/
								#(#(), #()), /*IVIDE*/
								#(#(), #()), /*IVIPL*/
								#(#(), #()), /*IVWPL*/
								#(#(), #()), /*DelayedIVIMG*/
								#(#(), #()), /*DelayedIVIDE*/
								#(#(), #()), /*DelayedIVIPL*/
								#(#(), #()) /*DelayedIVWPL*/
							), #(
								#(#(), #()), /*EPIMG*/
								#(#(), #()), /*EPIDE*/
								#(#(), #()), /*EPIPL*/
								#(#(), #()), /*EPWPL*/
								#(#(), #()), /*DelayedEPIMG*/
								#(#(), #()), /*DelayedEPIDE*/
								#(#(), #()), /*DelayedEPIPL*/
								#(#(), #()) /*DelayedEPWPL*/
							)
						)
				for DatFileID = 1 to DatFileCount do (
					local	IsEPDatFile = (DatFileID == 3),
							DatFileData = (
								ReadCached \
								DatFiles[DatFileID] \
								ThisObj.ReadDatFile \
								Type:"DATCfg" \
								HandlerParam:(
									if IsEPDatFile then
										EPGamePath
									else
										GamePath
								) \
								IgnoreBehavior:true
							),
							TargetList = (
								if IsEPDatFile then
									TargetDataLists[2]
								else
									TargetDataLists[1]
							)
					for ListID = 1 to 8 do
						MergeMHL TargetList[ListID] DatFileData[ListID]
					for ListID = 1 to 4 do
						MergeMHL DataToRemoveLists[ListID] DatFileData[8 + ListID]
					local	TempIMGListFile = DatFileData[13]
					if Have TempIMGListFile then (
						if IsEPDatFile then
							EPIMGListFile = TempIMGListFile
						else
							IMGListFile = TempIMGListFile
					)
					TempPedGrpFile = DatFileData[14]
					TempCarColsFile = DatFileData[15]
					TempScrollbarsFile = DatFileData[16]
					TempWaterFile = DatFileData[17]
				)
				if Have TempPedGrpFile then
					PedGrpFile = TempPedGrpFile
				if Have TempCarColsFile then
					CarColsFile = TempCarColsFile
				if Have TempScrollbarsFile then
					ScrollbarsFile = TempScrollbarsFile
				if Have TempWaterFile then
					WaterFile = TempWaterFile
				local	BaseIVIMG = (
							if Have IMGListFile then
								(ReadCached IMGListFile ThisObj.ReadIMGList Type:"IMGList" HandlerParam:false IgnoreBehavior:true)
							else
								#(#(), #())
						),
						BaseEPIMG = (
							if Have EPIMGListFile then
								(ReadCached EPIMGListFile ThisObj.ReadIMGList Type:"IMGList" HandlerParam:true IgnoreBehavior:true)
							else
								#(#(), #())
						)
				local	IVDataLists = TargetDataLists[1],
						EPDataLists = TargetDataLists[2],
						SourceLists = #(
							IVDataLists[1], /*IVIMG,*/
							BaseIVIMG,
							IVDataLists[5], /*DelayedIVIMG,*/
							EPDataLists[1], /*EPIMG,*/
							BaseEPIMG,
							EPDataLists[5], /*DelayedEPIMG,*/
							
							IVDataLists[2], /*IVIDE,*/
							IVDataLists[6], /*DelayedIVIDE,*/
							EPDataLists[2], /*EPIDE,*/
							EPDataLists[6], /*DelayedEPIDE,*/
							
							IVDataLists[3], /*IVIPL,*/
							IVDataLists[7], /*DelayedIVIPL,*/
							EPDataLists[3], /*EPIPL,*/
							EPDataLists[7], /*DelayedEPIPL,*/
							
							IVDataLists[4], /*IVWPL,*/
							IVDataLists[8], /*DelayedIVWPL,*/
							EPDataLists[4], /*EPWPL,*/
							EPDataLists[8] /*DelayedEPWPL*/
						),
						TargetLists = #(
							IMGFiles,
							IMGFiles,
							IMGFiles,
							IMGFiles,
							IMGFiles,
							IMGFiles,
							
							IDEFiles,
							IDEFiles,
							IDEFiles,
							IDEFiles,
							
							IPLFiles,
							IPLFiles,
							IPLFiles,
							IPLFiles,
							
							WPLFiles,
							WPLFiles,
							WPLFiles,
							WPLFiles
						),
						GamePaths = #(
							GamePath,
							GamePath,
							GamePath,
							EPGamePath,
							EPGamePath,
							EPGamePath,
							
							GamePath,
							GamePath,
							EPGamePath,
							EPGamePath,
							
							GamePath,
							GamePath,
							EPGamePath,
							EPGamePath,
							
							GamePath,
							GamePath,
							EPGamePath,
							EPGamePath
						),
						ListCount = TargetLists.Count,
						SourceList
				for ListID = 1 to ListCount do
					MergeMHL TargetLists[ListID] SourceLists[ListID]
				SourceLists = #(
					DataToRemoveLists[1], /*IVIMGToRemove,*/
					DataToRemoveLists[2], /*IVIDEToRemove,*/
					DataToRemoveLists[3], /*IVIPLToRemove,*/
					DataToRemoveLists[4] /*IVWPLToRemove,*/
				)
				TargetLists = #(
					IMGFiles,
					IDEFiles,
					IPLFiles,
					WPLFiles
				)
				local	HashesToDelete
				ListCount = TargetLists.Count
				for ListID = 1 to ListCount do (
					HashesToDelete = SourceLists[ListID][2]
					for Item in HashesToDelete do
						RemoveMHL TargetLists[ListID] Item
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadGame = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result = (Have GamePath),
						Core = GIMS.Core,
						GUIMgr = Core.GUIMgr
				if not Result then (
					local	TempGamePath = (getSavePath initialDir:GUIMgr.LastPath caption:"Select GTA IV/EFLC folder")
					if Have TempGamePath then (
						Append TempGamePath "\\"
						GUIMgr.LastPath = TempGamePath
						if
							DoesFileExist (TempGamePath + "gtaiv.exe") or
							DoesFileExist (TempGamePath + "eflc.exe")
						then (
							GIMS.Core.SystemMgr.NETFileIO.WriteAllText (GIMS.CurrentGame.BasePath + "Paths.txt") TempGamePath
							GamePath = TempGamePath
							Result = true
						)
					)
					if not Result then
						MessageBox "Can't find the game!\nLaunch's aborted." Title:("GIMS " + GIMS.CurrentGame.Name + " core initialization")
				)
				if Result then (
					if DoesFileExist (GamePath + "eflc.exe") then (
						EXEFile = "eflc.exe"
						Result = false
						GUIMgr.SetWindow GIMS.CurrentGame #EPSelect
					) else (
						EXEFile = "gtaiv.exe"
						ReadGameConfig()
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadEFLC EPDir = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EFLC = true
				EPGamePath = (GamePath + EPDir)
				ReadGameConfig()
				GIMS.CurrentGame.Core.CoreOps.PostLoad()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct CoreOpsstr (
		fn FirstLaunchCleanup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	SS = (StringStream "")
				Apropos "EGIMS_IV_matlist_Item*" To:SS
				Apropos "EGIMS_IV_TexEditor_*" To:SS
				Apropos "EGIMS_IV_FloatEditor_*" To:SS
				Apropos "EGIMS_IV_Float2Editor_*" To:SS
				Apropos "EGIMS_IV_Float3Editor_*" To:SS
				Apropos "EGIMS_IV_Float4Editor_*" To:SS
				Apropos "EGIMS_IV_Float2x3Editor_*" To:SS
				Apropos "EGIMS_IV_Float3x4Editor_*" To:SS
				Apropos "EGIMS_IV_Float4x2Editor_*" To:SS
				Apropos "EGIMS_IV_Float4x4Editor_*" To:SS
				Apropos "EGIMS_IV_Float4x5Editor_*" To:SS
				Seek SS 0
				local	DeleteCode = " = undefined"
				while not (EOF SS) do
					Execute ((FilterString (ReadLine SS) " ")[1] + DeleteCode)
				GIMS.Core.SystemMgr.DoGC()
				OK
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreLoad = (
			local	GCore = GIMS.CurrentGame.Core,
					OpenIVCheckFile = GCore.OpenIVCheckFile,
					OVISubPath = "New Technology Studio\\Apps\\OpenIV\\",
					TestPath = (GIMS.LocalApplicationPath + OVISubPath)
			if not (DoesFileExist (TestPath + OpenIVCheckFile)) then
				TestPath = (GIMS.RoamingApplicationPath + OVISubPath)
			if not (DoesFileExist (TestPath + OpenIVCheckFile)) then
				TestPath = (GIMS.CommonApplicationPath + OVISubPath)
			local	Result = (DoesFileExist (TestPath + OpenIVCheckFile))
			if Result then
				GCore.OpenIVPath = TestPath
			else
				throw "Can't find OpenIV!\nPlease, install it from OpenIV.com\n"
			OK
		),
		fn InitShortcuts = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Core = GIMS.Core,
						GUIMgr = Core.GUIMgr,
						ObjectMgr = Core.ObjectMgr,
						BufferMgr = Core.BufferMgr,
						CurrentGame = GIMS.CurrentGame,
						GCore = CurrentGame.Core,
						DB = GCore.DB,
						SMAXFactory = Core.MAXFactory,
						GMAXFactory = GCore.MAXFactory,
						GObjectMgr = GMAXFactory.ObjectMgr,
						GMaterialOps = GMAXFactory.MaterialOps,
						ArrayOps = Core.ArrayOps,
						ValueOps = Core.ValueOps,
						STypeLibrary = Core.TypeLibrary,
						ConvertStruct = ValueOps.ConvertStruct,
						AppendMHL = ArrayOps.AppendMHL,
						QuickSort = ArrayOps.QuickSort,
						TypeCast = ValueOps.TypeCast,
						SMaterialOps = Core.MaterialOps,
						StringOps = Core.StringOps,
						AddResult = Core.SystemMgr.AddResult,
						Shaders = DB.Shaders,
						UpdateProgress = GUIMgr.UpdateProgress,
						FormatText = ValueOps.FormatText,
						Compare = ValueOps.Compare
				GObjectMgr.STypeLibrary = STypeLibrary
				GObjectMgr.UpdateProgress = UpdateProgress
				GObjectMgr.SCore = Core
				GObjectMgr.GetStandartized = GMAXFactory.MaterialOps.GetStandartized
				GObjectMgr.AddResult = AddResult
				GObjectMgr.GCore = GCore
				GObjectMgr.GTypeLibrary = GCore.TypeLibrary
				GObjectMgr.Rules = CurrentGame.Rules
				GObjectMgr.ObjectNames = DB.ObjectNames
				GObjectMgr.TypeCast = TypeCast
				GObjectMgr.ConvertStruct = ConvertStruct
				GObjectMgr.CreateIfUnique = ObjectMgr.CreateIfUnique
				GObjectMgr.CalculateBounds = ObjectMgr.CalculateBounds
				GObjectMgr.ExtendBound = ObjectMgr.ExtendBound
				GObjectMgr.RemoveSmoothingGroups = ObjectMgr.RemoveSmoothingGroups
				GObjectMgr.GetPathString = ObjectMgr.GetPathString
				GObjectMgr.Split = ArrayOps.Split
				GObjectMgr.Modify = ArrayOps.Modify
				GObjectMgr.RotateA = ArrayOps.RotateA
				GObjectMgr.NormalizeA = ArrayOps.NormalizeA
				GObjectMgr.QuickSort = QuickSort
				GObjectMgr.AppendMHL = AppendMHL
				GObjectMgr.FetchMHL = ArrayOps.FetchMHL
				GObjectMgr.RebuildMHL = ArrayOps.RebuildMHL
				GObjectMgr.CreateMesh = ObjectMgr.CreateMesh
				GObjectMgr.StoreModData = ObjectMgr.StoreModData
				GObjectMgr.RestoreModData = ObjectMgr.RestoreModData
				GObjectMgr.GetChildren = ObjectMgr.GetChildren
				GObjectMgr.ReadCached = Core.CacheMgr.ReadCached
				GObjectMgr.ReplaceChars = StringOps.ReplaceChars
				GObjectMgr.Shaders = Shaders
				GObjectMgr.DumpMesh = ObjectMgr.DumpMesh
				GObjectMgr.CalculateVolumeAndCenterOfMass = ObjectMgr.CalculateVolumeAndCenterOfMass
				GObjectMgr.GetSectorCoords = SMAXFactory.SceneOps.GetSectorCoords
				GObjectMgr.ClearBuffer = BufferMgr.ClearBuffer
				GObjectMgr.ReadFile = BufferMgr.ReadFile
				GObjectMgr.GetPath = BufferMgr.GetPath
				GObjectMgr.BufSearch = BufferMgr.Search
				GObjectMgr.ReadVal = BufferMgr.ReadVal
				GObjectMgr.oFTypeExec = StringOps.oFTypeExec
				GObjectMgr.FormatText = FormatText
				GObjectMgr.Compare = Compare
				GMaterialOps.AddResult = AddResult
				GMaterialOps.FixMapFileNames = SMaterialOps.FixMapFileNames
				GMaterialOps.LoadBitmapFile = SMaterialOps.LoadBitmapFile
				GMaterialOps.ConvertStruct = ConvertStruct
				GMaterialOps.AsoFText = ValueOps.AsoFText
				GMaterialOps.AppendMHL = AppendMHL
				GMaterialOps.TypeCast = TypeCast
				GMaterialOps.TextureNames = DB.TextureNames
				GMaterialOps.UpdateMatrix = ValueOps.UpdateMatrix
				GMaterialOps.Shaders = Shaders
				GMaterialOps.UpdateProgress = UpdateProgress
				GMaterialOps.FormatText = FormatText
				GMaterialOps.QuickSort = QuickSort
				GMaterialOps.GetDiffuseWithOpacityAlpha = SMaterialOps.GetDiffuseWithOpacityAlpha
				GMaterialOps.GetBumpWithSpecAlpha = SMaterialOps.GetBumpWithSpecAlpha
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostLoad = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Core = GIMS.Core,
						GCore = GIMS.CurrentGame.Core,
						GUIMgr = Core.GUIMgr,
						CurrentGame = GIMS.CurrentGame,
						UpdateProgress = GUIMgr.UpdateProgress,
						GameMgr = GCore.GameMgr,
						GamePathFile = (CurrentGame.BasePath + "Paths.txt"),
						GamePath
				if (DoesFileExist GamePathFile) then (
					GamePath = (Core.SystemMgr.NETFileIO.ReadAllText GamePathFile)
					if
						not DoesFileExist (GamePath + "gtaiv.exe") and
						not DoesFileExist (GamePath + "eflc.exe")
					then
						GamePath = undefined
				)
				GameMgr.GamePath = GamePath
				GUIMgr.LoadInterface CurrentGame
				if
					GameMgr.EFLC or
					GameMgr.LoadGame()
				then (
					GUIMgr.SetWindow CurrentGame #Main
					local	ProgressStages = #(
								"Load database",
								"\t> Pre-load",
								"\t> Materials",
								"\t> Procedural materials",
								"\t> Entity FX",
								"\t> Timecycle modifiers",
								"\t> Scrollbars",
								"\t> Scenarios",
								"\t> Ped groups",
								"\t> Car colours",
								"\t> Shaders",
								"\t> GXT names",
								"\t> Script names",
								"\t> Audio names",
								"\t> Resource names"
							),
							AutoCache = (Core.CacheMgr.BehaviorID == 1)
					if AutoCache then (
						ProgressStages += #(
							"Cache content",
							"\t> WPL",
							"\t> IPL",
							"\t> IDE"
						)
					) 
					GUIMgr.InitProgress ProgressStages Title:"Loading"
					UpdateProgress #AddStage 1
					GCore.DB.Load()
					InitShortcuts()
					if AutoCache then
						GameMgr.CacheResources()
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct Corestr (
		/*DATA*/	ConfigProps = ConfigPropsstr(),
					GameMgr = GameMgrstr(),
					CoreOps = CoreOpsstr(),
		/*PARTS*/	DB,
					TypeLibrary,
					MAXFactory,
					GUI,
		/*OpenIV*/	OpenIVPath,
					OpenIVCheckFile = "OpenIV.exe",
		/*INFO*/	DevInfoPropList = #(
						#OpenIVPath,
						#OpenIVCheckFile,
						#ConfigProps,
						#CoreOps,
						#DB,
						#GameMgr,
						#GUI,
						#TypeLibrary,
						#MAXFactory
					)
	)
	(
		local	Core = (Corestr()),
				GameMgr = Core.GameMgr
		
		GameMgr.ThisObj = GameMgr
		
		GIMS.CurrentGame.Core = Core
	)
/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
try (GIMS.Core.SystemMgr.DoGC())	catch ()
