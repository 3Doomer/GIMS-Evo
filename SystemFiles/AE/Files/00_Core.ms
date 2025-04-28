/*#PC*DEFINE	CurrentGame	AE*/
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
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
	struct /*#PC*PATH	GIMS.CurrentGame.Rules*/ Rulesstr (
		AnimationFPS = ((100 as Double) / 3),
		DefaultMaterialPropMapping = #(
			#DiffMap,
			#NormalSpecMap
		),
		ExportFilter = #(
			#( /*root objs/mods*/
				EGIMS_AE_Model,
				EGIMS_AE_Collision,
				EGIMS_AE_Weapon
			), #( /*all possible objs/mods*/
				EGIMS_AE_Model,
				EGIMS_AE_Collision,
				EGIMS_AE_CollisionNode,
				EGIMS_AE_Col_Box,
				EGIMS_AE_Col_Sphere,
				EGIMS_AE_Weapon,
				EGIMS_AE_WeaponNode,
				EGIMS_AE_WeaponInstance,
				Editable_Mesh,
				Editable_Poly
			), #( /*children filters*/
				#( /*EGIMS_AE_Model*/
					Editable_Mesh,
					Editable_Poly
				), #( /*EGIMS_AE_Collision*/
					EGIMS_AE_CollisionNode
				), #( /*EGIMS_AE_CollisionNode*/
					EGIMS_AE_Col_Box,
					EGIMS_AE_Col_Sphere
				),
				undefined, /*EGIMS_AE_Col_Box*/
				undefined, /*EGIMS_AE_Col_Sphere*/
				#( /*EGIMS_AE_Weapon*/
					EGIMS_AE_WeaponNode
				), #( /*EGIMS_AE_WeaponNode*/
					EGIMS_AE_WeaponInstance
				),
				undefined, /*EGIMS_AE_WeaponInstance*/
				undefined, /*Editable_Mesh*/
				undefined /*Editable_Poly*/
			), #( /*root object collection  - chain indices*/
				1,	/*EGIMS_AE_Model*/
				1,	/*EGIMS_AE_Collision*/
				1	/*EGIMS_AE_Weapon*/
			)
		)
	)
	if No GIMS.CurrentGame.Rules then
		GIMS.CurrentGame.Rules = (Rulesstr())
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GameMgr*/ GameMgrstr (	/*REMOVE DEBUG LINES*/
		/*SYSTEM*/			AEIEditorPath,
								ModelTextureMapFile,
								ShipModelMapFile,
								StationModelMapFile,
								RGBAlphaTexturesFile,
		/*GAME PATHS*/	GamePath,
								APKPath,
		/*FILES*/			AEMFiles = #(),
								AEMFileNames = #(),
								AEIFiles = #(),
								AEIFileNames = #(),
								BINCollisionFiles = #(),
		fn CacheResources = (	/*REMOVE DEBUG LINES*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				UpdateProgress #AddStage 1
				local	TimeStart, /*DEBUG LINE*/
						TimeEnd, /*DEBUG LINE*/
						ReadCached = Core.CacheMgr.ReadCached,
						ResourceCachePath = GIMS.CurrentGame.ResourceCachePath,
						Files, FileCount,
						AEMType = "AEM",
						BINCollisionType = "BINCOL"
				/*AEM*/
				TimeStart = (GetTimeStamp()) /*DEBUG LINE*/
				Files = AEMFiles
				FileCount = Files.Count
				for FileID = 1 to FileCount do (
					ReadCached Files[FileID] GIMS.CurrentGame.Core.TypeLibrary.AEMFile GCCPath:ResourceCachePath Type:AEMType
					UpdateProgress #Progress [0, FileCount, FileID]
				)
				TimeEnd = (GetTimeStamp()) /*DEBUG LINE*/
				/*Format "GIMS Evo % has loaded AEM files in % seconds\n" CurrentGame.Name (0.001 * (TimeEnd - TimeStart)) /*DEBUG LINE*/
				/**/
				/*BINCollision*/
				TimeStart = (GetTimeStamp()) /*DEBUG LINE*/
				Files = BINCollisionFiles
				FileCount = Files.Count
				for FileID = 1 to FileCount do (
					ReadCached Files[FileID] GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFile GCCPath:ResourceCachePath Type:BINCollisionType
					UpdateProgress #Progress [0, FileCount, FileID]
				)
				TimeEnd = (GetTimeStamp()) /*DEBUG LINE*/
				/*Format "GIMS Evo % has loaded BINCollision files in % seconds\n" CurrentGame.Name (0.001 * (TimeEnd - TimeStart)) /*DEBUG LINE*/
				/**/
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadGameConfig = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				AEMFiles = #()
				AEIFiles = #()
				BINCollisionFiles = #()
				local	Dirs = (GIMS.Core.SystemMgr.GetFoldersRecursive #(GamePath, (APKPath + "assets\\data\\")))
				for Dir in Dirs do (
					local	TempAEMFiles = (GetFiles (Dir + "*.aem")),
							TempAEIFiles = (GetFiles (Dir + "*.aei")),
							TempBINCollisionFiles = (GetFiles (Dir + "*collision*.bin"))
					if TempAEMFiles.Count != 0 then
						AEMFiles += TempAEMFiles
					if TempAEIFiles.Count != 0 then
						AEIFiles += TempAEIFiles
					if TempBINCollisionFiles.Count != 0 then
						BINCollisionFiles += TempBINCollisionFiles
				)
				AEMFileNames = #()
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				for i = AEMFiles.Count to 1 by -1 do
					AEMFileNames[i] = (TypeCast (GetFileNameFile AEMFiles[i]) Name)
				for i = AEIFiles.Count to 1 by -1 do
					AEIFileNames[i] = (TypeCast (GetFileNameFile AEIFiles[i]) Name)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadGame = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	HaveGamePath = (Have GamePath),
						HaveAPKPath = (Have APKPath),
						HaveAEIEditorPath = (Have AEIEditorPath),
						Result = (
							HaveGamePath and
							HaveAEIEditorPath
						),
						GUIMgr = GIMS.Core.GUIMgr,
						WriteAllLines = GIMS.Core.SystemMgr.NETFileIO.WriteAllLines,
						BasePath = GIMS.CurrentGame.BasePath
				if not Result then (
					local	TempAPKPath = (
								if HaveAPKPath then
									APKPath
								else
									(GetSavePath initialDir:GUIMgr.LastPath caption:"Select unpacked APK file \"assets\" folder location(with \"data\" folder inside), or cancel")
							),
							TempGamePath = (
								if HaveGamePath then
									GamePath
								else
									(GetSavePath initialDir:GUIMgr.LastPath caption:"Select unpacked cache location(with \"data\" folder inside)")
							),
							TempAEIEditorPath = (
								if HaveAEIEditorPath then
									AEIEditorPath
								else
									(GetSavePath initialDir:GUIMgr.LastPath caption:"Select AEI Editor folder")
							)
					if No TempAPKPath then
						TempAPKPath = ""
					if
						Have TempGamePath and
						Have TempAEIEditorPath
					then (
						if not HaveGamePath then
							Append TempGamePath "\\"
						if not HaveAPKPath then
							Append TempAPKPath "\\"
						if not HaveAEIEditorPath then
							Append TempAEIEditorPath "\\"
						GUIMgr.LastPath = TempGamePath
						if
							Have (GetDirectories (TempGamePath + "data"))[1] and
							DoesFileExist (TempAEIEditorPath + "AEIEditor.exe")
						then (
							WriteAllLines (BasePath + "Paths.txt") #(TempGamePath, TempAPKPath, TempAEIEditorPath)
							GamePath = TempGamePath
							APKPath = TempAPKPath
							AEIEditorPath = TempAEIEditorPath
							Result = true
						)
					)
					if not Result then (
						local	ErrTxt = "Can't find some paths:\n"
						if No TempGamePath then
							Append ErrTxt "\n- unpacked cache location(with \"data\" folder)"
						if No AEIEditorPath then
							Append ErrTxt "\n- AEI Editor path"
						Append ErrTxt "\n\nLaunch's aborted."
						MessageBox ErrTxt Title:("GIMS " + GIMS.CurrentGame.Name + " core initialization")
					)
				)
				if Result then (
					local	FilesToCreate = #(
								ModelTextureMapFile,
								ShipModelMapFile,
								StationModelMapFile,
								RGBAlphaTexturesFile
							),
							FileContentsToCreate = #(
								#(
									"//Model textures match list",
									"//",
									"//Format: use <Tab> before texture names",
									"//",
									"//model_name",
									"//\ttexture 1",
									"//\ttexture 2",
									"//\ttexture ..",
									"//"
								), #(
									"//Ship models",
									"//Separate parameters using <Tab>",
									"//",
									"//Format:",
									"//",
									"//ID\tName\tBase\tEngine\tEngineGlow\tLights\tEmissive\tLOD_1\tLOD_2\tExplosion",
									"//"
								), #(
									"//Station models",
									"//Separate parameters using <Tab>",
									"//",
									"//Format:",
									"//",
									"//ID\tName\tModels...",
									"//"
								), #(
									"//Textures with RGB transparency",
									"//",
									"//Format: AEI file names in <FULL> section, and wildcard patterns in <WILDCARD>",
									"//",
									"",
									"<FULL>",
									"",
									"",
									"<WILDCARD>",
									""
								)
							)
					for i = 1 to FilesToCreate.Count do (
						local	FilePath = FilesToCreate[i]
						if not (DoesFileExist FilePath) then
							WriteAllLines FilePath FileContentsToCreate[i]
					)
					ReadGameConfig()
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
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
						ValueOps = GIMS.Core.ValueOps,
						QuickSort = ArrayOps.QuickSort,
						QuickSearch = ArrayOps.QuickSearch,
						GMaterialOps = GIMS.CurrentGame.Core.MAXFactory.MaterialOps,
						SMaterialOps = GIMS.Core.MaterialOps,
						StringOps = GIMS.Core.StringOps,
						UpdateProgress = GUIMgr.UpdateProgress,
						ConvertStruct = ValueOps.ConvertStruct
				GObjectMgr.UpdateProgress = UpdateProgress
				GObjectMgr.AddResult = GIMS.Core.SystemMgr.AddResult
				GObjectMgr.TypeCast = ValueOps.TypeCast
				GObjectMgr.ConvertStruct = ConvertStruct
				GObjectMgr.CreateIfUnique = ObjectMgr.CreateIfUnique
				GObjectMgr.ReplaceChars = StringOps.ReplaceChars
				GObjectMgr.CalculateBounds = ObjectMgr.CalculateBounds
				GObjectMgr.ExtendBound = ObjectMgr.ExtendBound
				GObjectMgr.RemoveSmoothingGroups = ObjectMgr.RemoveSmoothingGroups
				GObjectMgr.GetPathString = ObjectMgr.GetPathString
				GObjectMgr.Search = ArrayOps.Search
				GObjectMgr.Split = ArrayOps.Split
				GObjectMgr.Modify = ArrayOps.Modify
				GObjectMgr.RotateA = ArrayOps.RotateA
				GObjectMgr.NormalizeA = ArrayOps.NormalizeA
				GObjectMgr.QuickSort = QuickSort
				GObjectMgr.AppendMHL = ArrayOps.AppendMHL
				GObjectMgr.FetchMHL = ArrayOps.FetchMHL
				GObjectMgr.RebuildMHL = ArrayOps.RebuildMHL
				GObjectMgr.CreateMesh = ObjectMgr.CreateMesh
				GObjectMgr.FormatText = ValueOps.FormatText
				GObjectMgr.ReadCached = GIMS.Core.CacheMgr.ReadCached
				GObjectMgr.Rules = GIMS.CurrentGame.Rules
				GObjectMgr.ModelTextureMap = GIMS.CurrentGame.Core.DB.ModelTextureMap
				GObjectMgr.DumpMesh = ObjectMgr.DumpMesh
				GObjectMgr.GetStandartized = GMaterialOps.GetStandartized
				GObjectMgr.StoreTransformData = ObjectMgr.StoreTransformData
				GObjectMgr.StoreControllerData = ObjectMgr.StoreControllerData
				GMaterialOps.GetDiffuseWithOpacityAlpha = SMaterialOps.GetDiffuseWithOpacityAlpha
				GMaterialOps.GetBumpWithSpecAlpha = SMaterialOps.GetBumpWithSpecAlpha
				GMaterialOps.UpdateProgress = UpdateProgress
				GMaterialOps.FixMapFileNames = SMaterialOps.FixMapFileNames
				GMaterialOps.ConvertStruct = ConvertStruct
				GMaterialOps.QuickSort = QuickSort
				GMaterialOps.QuickSearch = QuickSearch
				GMaterialOps.RGBAlphaTextures = GIMS.CurrentGame.Core.DB.RGBAlphaTextures
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	\
						GUIMgr = GIMS.Core.GUIMgr,
						UpdateProgress = GUIMgr.UpdateProgress,
						GameMgr = GIMS.CurrentGame.Core.GameMgr,
						PathsFile = (GIMS.CurrentGame.BasePath + "Paths.txt"),
						GamePath, APKPath, AEIEditorPath
				if (DoesFileExist PathsFile) then (
					local	PathLines = (GIMS.Core.SystemMgr.NETFileIO.ReadAllLines PathsFile)
					GamePath = PathLines[1]
					APKPath = PathLines[2]
					AEIEditorPath = PathLines[3]
					if No (GetDirectories (GamePath + "data"))[1] then
						GamePath = undefined
					if No (GetDirectories (APKPath + "assets"))[1] then
						APKPath = ""
					if not DoesFileExist (AEIEditorPath + "AEIEditor.exe") then
						AEIEditorPath = undefined
				)
				GameMgr.GamePath = GamePath
				GameMgr.APKPath = APKPath
				GameMgr.AEIEditorPath = AEIEditorPath
				GameMgr.ModelTextureMapFile = (GIMS.CurrentGame.FilesPath + "ModelTextureMap.txt")
				GameMgr.ShipModelMapFile = (GIMS.CurrentGame.FilesPath + "ShipModelMap.txt")
				GameMgr.StationModelMapFile = (GIMS.CurrentGame.FilesPath + "StationModelMap.txt")
				GameMgr.RGBAlphaTexturesFile = (GIMS.CurrentGame.FilesPath + "RGBAlphaTextures.txt")
				GUIMgr.LoadInterface GIMS.CurrentGame
				if GameMgr.LoadGame() then (
					GUIMgr.SetWindow GIMS.CurrentGame #Main
					local	ProgressStages = #(
								"Load database",
								"\t> Pre-load",
								"\t> Model textures",
								"\t> Ship models",
								"\t> Station models",
								"\t> RGB opacity textures"
							),
							AutoCache = (GIMS.Core.CacheMgr.BehaviorID == 1)
					if AutoCache then (
						ProgressStages += #(
							"Cache content",
							"\t> Models",
							"\t> Binary files"
						)
					) 
					GUIMgr.InitProgress ProgressStages Title:"Loading"
					UpdateProgress #AddStage 1
					GIMS.CurrentGame.Core.DB.Load()
					InitShortcuts()
					if AutoCache then
						GameMgr.CacheResources()
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core*/ Corestr (
		/*DATA*/	ConfigProps = ConfigPropsstr(),
					GameMgr = GameMgrstr(),
					CoreOps = CoreOpsstr(),
		/*PARTS*/	DB,
					TypeLibrary,
					MAXFactory,
					GUI,
		/*INFO*/	DevInfoPropList = #(
						#ConfigProps,
						#CoreOps,
						#DB,
						#GUI,
						#TypeLibrary,
						#MAXFactory
					)
	)
	GIMS.CurrentGame.Core = (Corestr())
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
