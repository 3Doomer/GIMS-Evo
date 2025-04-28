/*#PC*DEFINE	CurrentGame	MP3*/
(
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
		ModelVertBufferSize = 65535,
		SkinVertBoneCount = 4,
		SkinPerGeoMaxBoneCount = 40,
		SkeletonMaxBoneCount = 255,
		GeometryCountLimit = 65535,
		DefaultMaterialPropMapping = #(
			#SPSName,
			#FloatValueNames,
			#FloatValues,
			#TexValueNames,
			#TexValues,
			#TexInternalFlags,
			#Matrix3x4ParamNames,
			#Matrix3x4Params,
			#Matrix4x4ParamNames,
			#Matrix4x4Params,
			#Float2x3ParamNames,
			#Float2x3Params,
			#Float4x4ParamNames,
			#Float4x4Params,
			#Float4x5ParamNames,
			#Float4x5Params,
			#AlignedVertexFormat
		),
		ExportFilter = #(
			#( /*root objs/mods*/
				EGIMS_MP3_ModelDict,
				EGIMS_MP3_Model,
				EGIMS_MP3_TexDict
			), #( /*all allowed objs/mods*/
				EGIMS_MP3_ModelDict,
				EGIMS_MP3_Model,
				EGIMS_MP3_TexDict,
				EGIMS_MP3_Model_Bone,
				EGIMS_MP3_Model_Light,
				Editable_Mesh,
				Editable_Poly,
				#EGIMS_MP3_ModelMesh,
				#EGIMS_MP3_Model_BoneMod,
				#EGIMS_MP3_Model_LightMod
			), #( /*allowed objs/mods - children filters*/
				#( /*EGIMS_MP3_ModelDict*/
					EGIMS_MP3_Model
				), #( /*EGIMS_MP3_Model*/
					EGIMS_MP3_Model_Bone,
					EGIMS_MP3_Model_Light,
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_MP3_ModelMesh,
					#EGIMS_MP3_Model_BoneMod,
					#EGIMS_MP3_Model_LightMod
				),
				undefined, /*EGIMS_MP3_TexDict*/
				#( /*EGIMS_MP3_Model_Bone*/
					EGIMS_MP3_Model_Bone,
					EGIMS_MP3_Model_Light,
					#EGIMS_MP3_ModelMesh,
					#EGIMS_MP3_Model_BoneMod,
					#EGIMS_MP3_Model_LightMod
				),
				undefined, /*EGIMS_MP3_Model_Light*/
				undefined,	--Editable_Mesh
				undefined,	--Editable_Poly
				undefined, /*#EGIMS_MP3_ModelMesh*/
				#(	/*#EGIMS_MP3_Model_BoneMod*/
					EGIMS_MP3_Model_Bone,
					EGIMS_MP3_Model_Light,
					#EGIMS_MP3_ModelMesh,
					#EGIMS_MP3_Model_BoneMod,
					#EGIMS_MP3_Model_LightMod
				),
				undefined	/*#EGIMS_MP3_Model_LightMod*/
			), #( /*root object collection  - chain indices*/
				1,	/*EGIMS_MP3_ModelDict*/
				1,	/*EGIMS_MP3_Model*/
				2	/*EGIMS_MP3_TexDict*/
			)
		)
	)
	if No GIMS.CurrentGame.Rules then
		GIMS.CurrentGame.Rules = (Rulesstr())
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GameMgr*/ GameMgrstr (
		/*FILES*/	ShadersFilepath,
		fn ReadGameConfig = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ShadersFilepath = (GIMS.CurrentGame.Core.OpenIVPath + "Games\\Payne\\openFormats\\ShaderManager.xml")
				if not (DoesFileExist ShadersFilepath) then
					EGIMS_EHAbort "Can't find needed OpenIV files. Please update it."
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadGame = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ReadGameConfig()
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.CoreOps*/ CoreOpsstr (
		fn FirstLaunchCleanup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SS = (StringStream "")
				Apropos "EGIMS_MP3_matlist_Item*" To:SS
				Apropos "EGIMS_MP3_TexEditor_*" To:SS
				Apropos "EGIMS_MP3_FloatEditor_*" To:SS
				Apropos "EGIMS_MP3_Float2Editor_*" To:SS
				Apropos "EGIMS_MP3_Float3Editor_*" To:SS
				Apropos "EGIMS_MP3_Float4Editor_*" To:SS
				Apropos "EGIMS_MP3_Float2x3Editor_*" To:SS
				Apropos "EGIMS_MP3_Float3x4Editor_*" To:SS
				Apropos "EGIMS_MP3_Float4x4Editor_*" To:SS
				Apropos "EGIMS_MP3_Float4x5Editor_*" To:SS
				Seek SS 0
				local	DeleteCode = " = undefined"
				while not (EOF SS) do
					Execute ((FilterString (ReadLine SS) " ")[1] + DeleteCode)
				GIMS.Core.SystemMgr.DoGC()
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	\
						OpenIVCheckFile = GIMS.CurrentGame.Core.OpenIVCheckFile,
						OVISubPath = "New Technology Studio\\Apps\\OpenIV\\",
						TestPath = (GIMS.LocalApplicationPath + OVISubPath)
				if not (DoesFileExist (TestPath + OpenIVCheckFile)) then
					TestPath = (GIMS.RoamingApplicationPath + OVISubPath)
				if not (DoesFileExist (TestPath + OpenIVCheckFile)) then
					TestPath = (GIMS.CommonApplicationPath + OVISubPath)
				local	Result = (DoesFileExist (TestPath + OpenIVCheckFile))
				if Result then
					GIMS.CurrentGame.Core.OpenIVPath = TestPath
				else
					EGIMS_EHAbort "Can't find OpenIV. Please, install it from OpenIV.com\n"
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn InitShortcuts = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GUIMgr = GIMS.Core.GUIMgr,
						ObjectMgr = GIMS.Core.ObjectMgr,
						BufferMgr = GIMS.Core.BufferMgr,
						GObjectMgr =  GIMS.CurrentGame.Core.MAXFactory.ObjectMgr,
						GMaterialOps =  GIMS.CurrentGame.Core.MAXFactory.MaterialOps,
						ArrayOps = GIMS.Core.ArrayOps,
						ValueOps = GIMS.Core.ValueOps,
						ConvertStruct = ValueOps.ConvertStruct,
						AppendMHL = ArrayOps.AppendMHL,
						QuickSort = ArrayOps.QuickSort,
						QuickSearch = ArrayOps.QuickSearch,
						TypeCast = ValueOps.TypeCast,
						SMaterialOps = GIMS.Core.MaterialOps,
						StringOps = GIMS.Core.StringOps,
						AddResult = GIMS.Core.SystemMgr.AddResult,
						UpdateProgress = GUIMgr.UpdateProgress,
						FormatText = ValueOps.FormatText,
						Compare = ValueOps.Compare
				GObjectMgr.UpdateProgress = UpdateProgress
				GObjectMgr.GetStandartized =  GIMS.CurrentGame.Core.MAXFactory.MaterialOps.GetStandartized
				GObjectMgr.AddResult = AddResult
				GObjectMgr.Rules = GIMS.CurrentGame.Rules
				GObjectMgr.TypeCast = TypeCast
				GObjectMgr.ConvertStruct = ConvertStruct
				GObjectMgr.CreateIfUnique = ObjectMgr.CreateIfUnique
				GObjectMgr.CalculateBounds = ObjectMgr.CalculateBounds
				GObjectMgr.ExtendBound = ObjectMgr.ExtendBound
				GObjectMgr.RemoveSmoothingGroups = ObjectMgr.RemoveSmoothingGroups
				GObjectMgr.GetPathString = ObjectMgr.GetPathString
				GObjectMgr.GetJenkinsHash = StringOps.GetJenkinsHash
				GObjectMgr.Split = ArrayOps.Split
				GObjectMgr.Modify = ArrayOps.Modify
				GObjectMgr.RotateA = ArrayOps.RotateA
				GObjectMgr.NormalizeA = ArrayOps.NormalizeA
				GObjectMgr.QuickSort = QuickSort
				GObjectMgr.AppendMHL = AppendMHL
				GObjectMgr.AppendSorted = ArrayOps.AppendSorted
				GObjectMgr.FetchMHL = ArrayOps.FetchMHL
				GObjectMgr.RebuildMHL = ArrayOps.RebuildMHL
				GObjectMgr.CreateMesh = ObjectMgr.CreateMesh
				GObjectMgr.StoreModData = ObjectMgr.StoreModData
				GObjectMgr.RestoreModData = ObjectMgr.RestoreModData
				GObjectMgr.GetChildren = ObjectMgr.GetChildren
				GObjectMgr.ReadCached = GIMS.Core.CacheMgr.ReadCached
				GObjectMgr.ReplaceChars = StringOps.ReplaceChars
				GObjectMgr.DumpMesh = ObjectMgr.DumpMesh
				GObjectMgr.CalculateVolumeAndCenterOfMass = ObjectMgr.CalculateVolumeAndCenterOfMass
				GObjectMgr.GetSectorCoords = GIMS.Core.MAXFactory.SceneOps.GetSectorCoords
				GObjectMgr.ClearBuffer = BufferMgr.ClearBuffer
				GObjectMgr.ReadFile = BufferMgr.ReadFile
				GObjectMgr.BufSearch = BufferMgr.Search
				GObjectMgr.ReadVal = BufferMgr.ReadVal
				GObjectMgr.oFTypeExec = StringOps.oFTypeExec
				GObjectMgr.FormatText = FormatText
				GObjectMgr.Compare = Compare
				GObjectMgr.GetShaderByName = GIMS.CurrentGame.Core.DB.GetShaderByName
				GObjectMgr.AppendIfUniq = ArrayOps.AppendIfUniq
				GObjectMgr.QuickSearch = QuickSearch
				GObjectMgr.Dispose = ArrayOps.Dispose
				GObjectMgr.PreallocatedInsertItem = ArrayOps.PreallocatedInsertItem
				GObjectMgr.OrderComparator = ValueOps.OrderComparator
				GMaterialOps.QuickSearch = QuickSearch
				GMaterialOps.AddResult = AddResult
				GMaterialOps.FixMapFileNames = SMaterialOps.FixMapFileNames
				GMaterialOps.LoadBitmapFile = SMaterialOps.LoadBitmapFile
				GMaterialOps.ConvertStruct = ConvertStruct
				GMaterialOps.AsoFText = ValueOps.AsoFText
				GMaterialOps.AppendMHL = AppendMHL
				GMaterialOps.TypeCast = TypeCast
				GMaterialOps.UpdateMatrix = ValueOps.UpdateMatrix
				GMaterialOps.UpdateProgress = UpdateProgress
				GMaterialOps.FormatText = FormatText
				GMaterialOps.QuickSort = QuickSort
				GMaterialOps.GetDiffuseWithOpacityAlpha = SMaterialOps.GetDiffuseWithOpacityAlpha
				GMaterialOps.CopyBitmapAlpha = SMaterialOps.CopyBitmapAlpha
				GMaterialOps.Compare = Compare
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	\
						GUIMgr = GIMS.Core.GUIMgr,
						UpdateProgress = GUIMgr.UpdateProgress,
						GameMgr = GIMS.CurrentGame.Core.GameMgr
				GUIMgr.LoadInterface GIMS.CurrentGame
				if (GameMgr.LoadGame()) then (
					GUIMgr.SetWindow GIMS.CurrentGame #Main
					local	ProgressStages = #(
								"Load database",
								"\t> Pre-load",
								"\t> Shaders",
								"\t> Resource names"
							),
							AutoCache = (GIMS.Core.CacheMgr.BehaviorID == 1)
					if AutoCache then (
						ProgressStages += #(
							"Cache content"
						)
					) 
					GUIMgr.InitProgress ProgressStages Title:"Loading"
					UpdateProgress #AddStage 1
					InitShortcuts()
					GIMS.CurrentGame.Core.DB.Load()
					if AutoCache then
						GameMgr.CacheResources()
					GUIMgr.EndProgress true
				)
				OK
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
	GIMS.CurrentGame.Core = (Corestr())
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
