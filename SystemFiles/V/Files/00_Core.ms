/*#PC*DEFINE	CurrentGame	V*/
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
		SkinVertBoneCount = 4,
		SkinMaxBoneCount = 512,	--TODO get from OpenIV team
		SkinPerGeoMaxBoneCount = 254,
		SkeletonMaxBoneCount = 512,	--TODO get from OpenIV team
		ModelVertBufferSize = 65535,
		ColPolyBufferSize = 32767,
		ColVertBufferSize = 32767,
		GeometryCountLimit = 65535,
		ColMaterialBufferSize = 255,
		DefaultMaterialPropMapping = #(
			#CollisionData,
			#GeometryFlags,
			#SPSName,
			#FloatValueNames,
			#FloatValues,
			#TexValueNames,
			#TexValues,
			#TexInternalFlags,
			#TexParams,
			#Matrix3x4ParamNames,
			#Matrix3x4Params,
			#Matrix44ParamNames,
			#Matrix44Params,
			#Float2x3ParamNames,
			#Float2x3Params,
			#Float4x2ParamNames,
			#Float4x2Params,
			#Float4x4ParamNames,
			#Float4x4Params,
			#Float4x5ParamNames,
			#Float4x5Params
		),
		ColMaterialPropMapping = #(
			#CollisionData
		),
		ModelMaterialPropMapping = #(
			#GeometryFlags,
			#SPSName,
			#FloatValueNames,
			#FloatValues,
			#TexValueNames,
			#TexValues,
			#TexInternalFlags,
			#TexParams,
			#Matrix3x4ParamNames,
			#Matrix3x4Params,
			#Matrix44ParamNames,
			#Matrix44Params,
			#Float2x3ParamNames,
			#Float2x3Params,
			#Float4x2ParamNames,
			#Float4x2Params,
			#Float4x4ParamNames,
			#Float4x4Params,
			#Float4x5ParamNames,
			#Float4x5Params
		),
		ExportFilter = #(
			#( /*root objs/mods*/
				EGIMS_V_CollisionDict,
				EGIMS_V_Col_Composite,
				EGIMS_V_Col_Plane,
				EGIMS_V_Col_Box,
				EGIMS_V_Col_Disc,
				EGIMS_V_Col_Sphere,
				EGIMS_V_Col_Cylinder,
				EGIMS_V_Col_Capsule,
				EGIMS_V_ModelDict,
				EGIMS_V_Model,
				#EGIMS_V_Model_ModelMod,
				EGIMS_V_TexDict,
				#EGIMS_V_ModelMesh,
				#EGIMS_V_CollisionMesh
			), #( /*all allowed objs/mods*/
				EGIMS_V_CollisionDict,
				EGIMS_V_Col_Composite,
				EGIMS_V_Col_Plane,
				EGIMS_V_Col_Box,
				EGIMS_V_Col_Disc,
				EGIMS_V_Col_Sphere,
				EGIMS_V_Col_Cylinder,
				EGIMS_V_Col_Capsule,
				EGIMS_V_Col_PrimBox,
				EGIMS_V_Col_PrimSphere,
				EGIMS_V_Col_PrimCapsule,
				EGIMS_V_Col_PrimCylinder,
				EGIMS_V_ModelDict,
				EGIMS_V_Model,
				#EGIMS_V_Model_ModelMod,
				EGIMS_V_TexDict,
				EGIMS_V_Model_Bone,
				EGIMS_V_Model_Light,
				Editable_Mesh,
				Editable_Poly,
				#EGIMS_V_CollisionMesh,
				#EGIMS_V_ModelMesh,
				#EGIMS_V_Model_BoneMod,
				#EGIMS_V_Model_LightMod
			), #( /*children filters*/
				#(	--EGIMS_V_CollisionDict,
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh
				),
				#(	--EGIMS_V_Col_Composite,
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh
				),
				undefined,	--EGIMS_V_Col_Plane,
				undefined,	--EGIMS_V_Col_Box,
				undefined,	--EGIMS_V_Col_Disc,
				undefined,	--EGIMS_V_Col_Sphere,
				undefined,	--EGIMS_V_Col_Cylinder,
				undefined,	--EGIMS_V_Col_Capsule,
				undefined,	--EGIMS_V_Col_PrimBox,
				undefined,	--EGIMS_V_Col_PrimSphere,
				undefined,	--EGIMS_V_Col_PrimCapsule,
				undefined,	--EGIMS_V_Col_PrimCylinder
				#( /*EGIMS_V_ModelDict*/
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_V_Model_ModelMod,
					EGIMS_V_Model
				), #( /*EGIMS_V_Model*/
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Model_Bone,
					EGIMS_V_Model_Light,
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh,
					/**/
					#EGIMS_V_ModelMesh,
					#EGIMS_V_Model_BoneMod,
					#EGIMS_V_Model_LightMod
				), #( /*#EGIMS_V_Model_ModelMod*/
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Model_Bone,
					EGIMS_V_Model_Light,
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh,
					/**/
					#EGIMS_V_ModelMesh,
					#EGIMS_V_Model_BoneMod,
					#EGIMS_V_Model_LightMod
				),
				undefined, /*EGIMS_V_TexDict*/
				#( /*EGIMS_V_Model_Bone*/
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Model_Bone,
					EGIMS_V_Model_Light,
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh,
					/**/
					#EGIMS_V_ModelMesh,
					#EGIMS_V_Model_BoneMod,
					#EGIMS_V_Model_LightMod
				),
				undefined, /*EGIMS_V_Model_Light*/
				#(	/*Editable_Mesh*/
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh
					/**/
					/*TODO mesh-in-mesh*
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_V_ModelMesh
					/**/
				),
				#(	/*Editable_Poly*/
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh
					/**/
					/*TODO mesh-in-mesh*
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_V_ModelMesh
					/**/
				),
				#(	--#EGIMS_V_CollisionMesh,
					EGIMS_V_Col_PrimBox,
					EGIMS_V_Col_PrimSphere,
					EGIMS_V_Col_PrimCapsule,
					EGIMS_V_Col_PrimCylinder/*TODO mesh-in-mesh*			,
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_V_CollisionMesh
					/**/
				),
				#(	/*#EGIMS_V_ModelMesh*/
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh
					/**/
					/*TODO mesh-in-mesh*
					Editable_Mesh,
					Editable_Poly,
					#EGIMS_V_ModelMesh
					/**/
				),
				#(	/*#EGIMS_V_Model_BoneMod*/
					Editable_Mesh,
					Editable_Poly,
					EGIMS_V_Model_Bone,
					EGIMS_V_Model_Light,
					/*model+col*/
					EGIMS_V_Col_Composite,
					EGIMS_V_Col_Plane,
					EGIMS_V_Col_Box,
					EGIMS_V_Col_Disc,
					EGIMS_V_Col_Sphere,
					EGIMS_V_Col_Cylinder,
					EGIMS_V_Col_Capsule,
					#EGIMS_V_CollisionMesh,
					/**/
					#EGIMS_V_ModelMesh,
					#EGIMS_V_Model_BoneMod,
					#EGIMS_V_Model_LightMod
				),
				undefined	/*#EGIMS_V_Model_LightMod*/
			), #( /*root object collection  - chain indices*/
				4,	--EGIMS_V_CollisionDict,
				3,	--EGIMS_V_Col_Composite,
				1,	--EGIMS_V_Col_Plane,
				1,	--EGIMS_V_Col_Box,
				1,	--EGIMS_V_Col_Disc,
				1,	--EGIMS_V_Col_Sphere,
				1,	--EGIMS_V_Col_Cylinder,
				1,	--EGIMS_V_Col_Capsule,
				4,	--EGIMS_V_ModelDict
				2,	--EGIMS_V_Model
				2,	--#EGIMS_V_Model_ModelMod
				5,	--EGIMS_V_TexDict
				1,	--#EGIMS_V_ModelMesh
				2	--#EGIMS_V_CollisionMesh
			)
		)
	)
	if No GIMS.CurrentGame.Rules then
		GIMS.CurrentGame.Rules = (Rulesstr())
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GameMgr*/ GameMgrstr (	/*REMOVE DEBUG LINES*/
		/*GAME PATHS*/		GamePath = unsupplied,
		
		/*FILES*/			ShadersFilepath,
							BoneDataCRCsFile = "BoneDataCRCs.GCF", BoneDataCRCsFilepath,
							MaterialsFile = "materials.dat", MaterialsFilepath,
							MaterialFXFile = "materialfx.dat", MaterialFXFilepath,
									
		fn ReadGameConfig = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ShadersFilepath = (GIMS.CurrentGame.Core.OpenIVPath + "Games\\Five\\openFormats\\ShaderManager.xml")
				if not (DoesFileExist ShadersFilepath) then
					EGIMS_EHAbort "Can't find needed OpenIV files. Please update it."
				BoneDataCRCsFilepath = (GIMS.CurrentGame.FilesPath + BoneDataCRCsFile)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadGame = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (Supplied GamePath)
				if not Result then (
					local	FormatText = GIMS.Core.ValueOps.FormatText
					MessageBox (
						FormatText \
							v1:"You should select a folder with these game files to continue:\n\n" \
							v2:MaterialsFile \
							v3:"\nThat file's usually found in <GTA V dir>\\common.rpf\\data\\materials\\\n\n" \
							v4:MaterialFXFile \
							v5:"\nThat file's usually found in <GTA V dir>\\common.rpf\\data\\effects\\\n\n\n" \
							v6:"You can extract these files from the game using OpenIV"
					) Title:(
						FormatText \
							v1:"GIMS " \
							v2:GIMS.CurrentGame.Name \
							v3:" core initialization"
					)
					local	GUIMgr = GIMS.Core.GUIMgr,
							TempGamePath = (getSavePath initialDir:GUIMgr.LastPath Caption:"Select a folder with game files")
					if Have TempGamePath then (
						Append TempGamePath "\\"
						GUIMgr.LastPath = TempGamePath
						MaterialsFilepath = (TempGamePath + MaterialsFile)
						MaterialFXFilepath = (TempGamePath + MaterialFXFile)
						if
							DoesFileExist MaterialsFilepath and
							DoesFileExist MaterialFXFilepath
						then (
							GIMS.Core.SystemMgr.NETFileIO.WriteAllText (GIMS.CurrentGame.BasePath + "Paths.txt") TempGamePath
							GamePath = TempGamePath
							Result = true
						)
					)
					if not Result then
						MessageBox "Can't find the game files.\nLaunch's aborted." Title:("GIMS " + GIMS.CurrentGame.Name + " core initialization")
				)
				if Result then
					ReadGameConfig()
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.CoreOps*/ CoreOpsstr (
		fn FirstLaunchCleanup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SS = (StringStream "")
				Apropos "EGIMS_V_matlist_Item*" To:SS
				Apropos "EGIMS_V_TexEditor_*" To:SS
				Apropos "EGIMS_V_FloatEditor_*" To:SS
				Apropos "EGIMS_V_Float2Editor_*" To:SS
				Apropos "EGIMS_V_Float3Editor_*" To:SS
				Apropos "EGIMS_V_Float4Editor_*" To:SS
				Apropos "EGIMS_V_Float2x3Editor_*" To:SS
				Apropos "EGIMS_V_Float3x4Editor_*" To:SS
				Apropos "EGIMS_V_Float4x2Editor_*" To:SS
				Apropos "EGIMS_V_Float4x4Editor_*" To:SS
				Apropos "EGIMS_V_Float4x5Editor_*" To:SS
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
				/*SETUP TEST*
				Format "Have GIMS.Core:\t%\n" (Have GIMS.Core)
				Format "Have GIMS.CurrentGame:\t%\n" (Have GIMS.CurrentGame)
				Format "Have GIMS.CurrentGame.Core:\t%\n" (Have GIMS.CurrentGame.Core)
				Format "Have GIMS.CurrentGame.Core.MAXFactory:\t%\n" (Have GIMS.CurrentGame.Core.MAXFactory)
				/**/
				local	GUIMgr = GIMS.Core.GUIMgr,
						ObjectMgr = GIMS.Core.ObjectMgr,
						GObjectMgr = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr,
						GMaterialOps = GIMS.CurrentGame.Core.MAXFactory.MaterialOps,
						ArrayOps = GIMS.Core.ArrayOps,
						ValueOps = GIMS.Core.ValueOps,
						AppendMHL = ArrayOps.AppendMHL,
						TypeCast = ValueOps.TypeCast,
						ConvertStruct = ValueOps.ConvertStruct,
						AddResult = GIMS.Core.SystemMgr.AddResult,
						UpdateProgress = GUIMgr.UpdateProgress,
						SMaterialOps = GIMS.Core.MaterialOps,
						QuickSort = ArrayOps.QuickSort,
						QuickSearch = ArrayOps.QuickSearch,
						FormatText = ValueOps.FormatText,
						StringOps = GIMS.Core.StringOps,
						DB = GIMS.CurrentGame.Core.DB
				GObjectMgr.DumpMesh = ObjectMgr.DumpMesh
				GObjectMgr.AppendIfUniq = ArrayOps.AppendIfUniq
				GObjectMgr.UpdateProgress = UpdateProgress
				GObjectMgr.AddResult = AddResult
				GObjectMgr.ObjectNames = DB.ObjectNames
				GObjectMgr.TypeCast = TypeCast
				GObjectMgr.ConvertStruct = ConvertStruct
				GObjectMgr.CreateIfUnique = ObjectMgr.CreateIfUnique
				GObjectMgr.CalculateBounds = ObjectMgr.CalculateBounds
				GObjectMgr.CalculateVolumeAndCenterOfMass = ObjectMgr.CalculateVolumeAndCenterOfMass
				GObjectMgr.ExtendBound = ObjectMgr.ExtendBound
				GObjectMgr.RemoveSmoothingGroups = ObjectMgr.RemoveSmoothingGroups
				GObjectMgr.GetPathString = ObjectMgr.GetPathString
				GObjectMgr.Search = ArrayOps.Search
				GObjectMgr.Split = ArrayOps.Split
				GObjectMgr.Modify = ArrayOps.Modify
				GObjectMgr.RotateA = ArrayOps.RotateA
				GObjectMgr.NormalizeA = ArrayOps.NormalizeA
				GObjectMgr.QuickSort = QuickSort
				GObjectMgr.AppendMHL = AppendMHL
				GObjectMgr.AppendSorted = ArrayOps.AppendSorted
				GObjectMgr.FetchMHL = ArrayOps.FetchMHL
				GObjectMgr.StoreModData = ObjectMgr.StoreModData
				GObjectMgr.RestoreModData = ObjectMgr.RestoreModData
				GObjectMgr.RebuildMHL = ArrayOps.RebuildMHL
				GObjectMgr.CreateMesh = ObjectMgr.CreateMesh
				GObjectMgr.ReadCached = GIMS.Core.CacheMgr.ReadCached
				GObjectMgr.GetStandartized = GMaterialOps.GetStandartized
				GObjectMgr.ReplaceChars = StringOps.ReplaceChars
				GObjectMgr.Rules = GIMS.CurrentGame.Rules
				GObjectMgr.FormatText = FormatText
				GObjectMgr.FixMaterialID = ObjectMgr.FixMaterialID
				GObjectMgr.AsBitArray = ValueOps.AsBitArray
				GObjectMgr.GetShaderByName = DB.GetShaderByName
				GObjectMgr.GetFirstUnusedIndex = ArrayOps.GetFirstUnusedIndex
				GObjectMgr.QuickSearch = QuickSearch
				GObjectMgr.GetJenkinsHash = StringOps.GetJenkinsHash
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
				GMaterialOps.Compare = ValueOps.Compare
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
						SystemMgr = GIMS.Core.SystemMgr,
						GamePathFile = (GIMS.CurrentGame.BasePath + "Paths.txt"),
						GamePath = unsupplied
				if (DoesFileExist GamePathFile) then (
					GamePath = (SystemMgr.NETFileIO.ReadAllText GamePathFile)
					local	MaterialsFilepath = (GamePath + GameMgr.MaterialsFile),
							MaterialFXFilepath = (GamePath + GameMgr.MaterialFXFile)
					if
						not DoesFileExist MaterialsFilepath or
						not DoesFileExist MaterialFXFilepath
					then
						GamePath = unsupplied
					else (
						GameMgr.MaterialsFilepath = MaterialsFilepath
						GameMgr.MaterialFXFilepath = MaterialFXFilepath
					)
				)
				GameMgr.GamePath = GamePath
				GUIMgr.LoadInterface GIMS.CurrentGame
				if (GameMgr.LoadGame()) then (
					GUIMgr.SetWindow GIMS.CurrentGame #Main
					local	ProgressStages = #(
								"Load database",
								"\t> Pre-load",
								"\t> Shaders",
								"\t> MaterialFX",
								"\t> Materials",
								"\t> Bone DataCRCs",
								"\t> Resource names"
							)
					GUIMgr.InitProgress ProgressStages Title:"Loading"
					UpdateProgress #AddStage 1
					InitShortcuts()
					GIMS.CurrentGame.Core.DB.Load()
					if (SystemMgr.HaveResults ErrorsOnly:true) then (
						SystemMgr.AddResult #Error "The game core wasn't loaded. You should select a new game files path on the next step.\nIf that happens again, contact GIMS support."
						GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #ChangeGamePath, 2), #QueryYes)	--reset game path
					) else
						GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 1, #Main, 2))	--go to main window
					GUIMgr.EndProgress true Continueable:true CanGoBack:false
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core*/ Corestr (
		/*PARTS*/			ConfigProps = ConfigPropsstr(),
							GameMgr = GameMgrstr(),
							CoreOps = CoreOpsstr(),
							DB,
							TypeLibrary,
							MAXFactory,
							GUI,
		/*OpenIV*/			OpenIVPath,
							OpenIVCheckFile = "OpenIV.exe",
		/*INFO*/			DevInfoPropList = #(
								#OpenIVPath,
								#OpenIVCheckFile,
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
)
