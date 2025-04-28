/*#PC*DEFINE	CurrentGame	V*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.DB*/ strDB (
		ThisObj,
		
		Shaders, Materials, MaterialFXColors,
		ObjectNames, TextureNames,
		BoneDataCRCs,
		
		Loaded = false,
		
		fn _GetShaders_SPSComparator a b Descending = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Name1 = a.aName,
						Name2 = b.aName
				if Name1 == Name2 then
					0
				else (
					if (GIMS.Core.ValueOps.CheckOrder Name1 Name2 Descending) then
						-1
					else
						1
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _GetShaders_ParseShader XMLNode Shaders NETStream TypeCast = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SPS = (GIMS.CurrentGame.Core.TypeLibrary.SPS())
				if Supplied NETStream then
					GIMS.Core.GUIMgr.UpdateProgress #Progress #(NETStream.Position, 0, NETStream.Length)
				if (SPS.Read XMLNode) then (
					local	SPSName = SPS.aName,
							GroupNamePatterns = Shaders[1],
							GID
					for i = 1 to GroupNamePatterns.Count where (MatchPattern SPSName Pattern:GroupNamePatterns[i]) while No GID do
						GID = i
					if No GID then
						GID = Shaders[2].Count
					local	SPSList = Shaders[3][GID],
							ArrayOps = GIMS.Core.ArrayOps,
							SID = (ArrayOps.AppendSorted SPSList SPS Comparator:_GetShaders_SPSComparator GetID:true)
					if
						((TypeCast SPS.aShader Name) == #default) and
						((TypeCast SPSName Name) == #default)
					then
						Shaders[4] = [GID, SID]
					ArrayOps.AppendMHL Shaders[5] SPS Hash:SPSName
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _GetShaders_ParseShaderManager XMLNode Shaders NETStream:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	Version = (XMLNode.GetAttribute "version"),
							NodeClass = (XMLNode.GetAttribute "class")
					if No Version then
						throw (Append "Can't find \"version\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
					if No NodeClass then
						throw (Append "Can't find \"class\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
					local	TypeCast = GIMS.Core.ValueOps.TypeCast,
							nVersion = (TypeCast Version Integer),
							neededVersion = 31
					if nVersion < neededVersion then
						EGIMS_EHAbort "GIMS for GTA V version's newer than your OpenIV version. Please update OpenIV."
					else (
						if nVersion > neededVersion then
							EGIMS_EHAbort "OpenIV version's newer than your GIMS for GTA V version. Please update GIMS V or wait for new updates."
					)
					if NodeClass != "ShaderManagerFive" then
						EGIMS_EHAbort "OpenIV files corrupted. Please update OpenIV to start GIMS for GTA V."
						
					local	ShaderManagerSubTree = (XMLNode.ReadSubTree())
					if No ShaderManagerSubTree then
						throw (Append "Can't read the ShaderManager subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						
					if not (ShaderManagerSubTree.ReadToFollowing "Shaders") then
						throw (Append "Can't find \"Shaders\" parameter at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					local	ShadersSubTree = (ShaderManagerSubTree.ReadSubTree())
					if No ShadersSubTree then
						throw (Append "Can't read Shaders subtree at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					while (ShadersSubTree.Read()) do (						
						/*TODO remove, debug*	LogProfiler #PlainInfo "Shader @\t" AddParam:[ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition]	/**/
						_GetShaders_ParseShader ShadersSubTree Shaders NETStream TypeCast
					)
						
					if not (ShaderManagerSubTree.ReadToFollowing "VertexDeclarations") then
						throw (Append "Can't find \"VertexDeclarations\" parameter at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					local	VertexDeclarationsSubTree = (ShaderManagerSubTree.ReadSubTree())
					if No VertexDeclarationsSubTree then
						throw (Append "Can't read VertexDeclarations subtree at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					local	allVDs = #(),
							ArrayOps = GIMS.Core.ArrayOps,
							AppendSorted = GIMS.Core.ArrayOps.AppendSorted,
							SPSVertexDeclaration = GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclaration
					while (VertexDeclarationsSubTree.Read()) do (
						/*TODO remove, debug*	LogProfiler #PlainInfo "VD @\t" AddParam:[VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition]	/**/
						local	theVD = (SPSVertexDeclaration())
						if (theVD.Read VertexDeclarationsSubTree) then
							AppendSorted allVDs theVD ValuePropertyName:#aName
					)
					
					--replace SPS VD infos with actual VDs
					local	QuickSearch = ArrayOps.QuickSearch
					for SPS in Shaders[5][1] do (
						local	VDs = SPS.VertexDeclarations
						for i = 1 to VDs.Count do (
							local	VDInfo = VDs[i],
									vdName = VDInfo[1],
									vdSkinned = VDInfo[2]
							local	vdID = (QuickSearch allVDs vdName PropertyName:#aName)
							if vdID == 0 then
								throw ("Can't find " + SPS.aName + " shader vertex declaration: " + vdName)
							local	realVD = allVDs[vdID]
							if realVD.Skinned != vdSkinned then
								throw (SPS.aName + " shader vertex declaration " + vdName + " must be skinned, but it isn't")
							VDs[i] = realVD
						)
					)
					
					Free allVDs
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetShaders ShadersFilepath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.Core.SystemMgr.ReadXML ShadersFilepath "ShaderManager" ThisObj._GetShaders_ParseShaderManager Shaders NeedProgress:true
				local	GroupPatterns = Shaders[1],
						GroupNames = Shaders[2],
						SPSGroups = Shaders[3],
						GroupCount = SPSGroups.Count,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				for i = GroupCount to 1 by -1 where SPSGroups[i].Count == 0 do (
					DeleteItem GroupPatterns i
					DeleteItem GroupNames i
					DeleteItem SPSGroups i
					GroupCount -= 1
				)
				Shaders
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetMaterials FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local 	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						BufferID = (BufferMgr.ReadFile FilePath),
						NotEOF = BufferMgr.NotEOF,
						VersionLine = #InvalidLine,
						Result = true
				if BufferID != false then (
					while
						Result and
						(NotEOF BufferID) and
						(VersionLine == #InvalidLine)
					do
						VersionLine = (ReadVal BufferID ValidateGTAString:true)
					if VersionLine != #InvalidLine then (
						if (TrimLeft (TrimRight VersionLine)) == "12.00" then (
							local	ArrayOps = GIMS.Core.ArrayOps,
									AddResult = GIMS.Core.SystemMgr.AddResult,
									AppendIfUniq = ArrayOps.AppendIfUniq,
									FormatText = GIMS.Core.ValueOps.FormatText,
									FetchMHL = ArrayOps.FetchMHL,
									AppendMHL = ArrayOps.AppendMHL,
									MaterialNames = Materials[1],
									MatFXIDs = Materials[2],
									MatGroups = Materials[3],
									GroupedMats = Materials[4],
									GroupedIDs = Materials[5],
									GroupLocToIndexMHL = Materials[6],
									MaterialIndex = 1
							while (NotEOF BufferID) do (
								local tLine = (ReadVal BufferID FilterStr:" \t" ValidateGTAString:true)
								if tLine != #InvalidLine then (
									local	GroupID = (AppendIfUniq MatGroups tLine[2] GetID:true)
									if No GroupedMats[GroupID] then (
										GroupedMats[GroupID] = #()
										GroupedIDs[GroupID] = #()
									)
									local	MatName = tLine[1],
											MatGroup = GroupedMats[GroupID]
									Append MatGroup MatName
									Append GroupedIDs[GroupID] MaterialIndex
									Append MaterialNames MatName
									AppendMHL GroupLocToIndexMHL [GroupID, MatGroup.Count] Hash:MaterialIndex
									local	FXName = tLine[3]
											FXID = (FetchMHL MaterialFXColors tLine[3] ReturnHashOnFail:false)
									if Have FXID then
										Append MatFXIDs FXID
									else (
										AddResult #Error (
											FormatText \
												v1:"Can't find a material fx " \
												v2:FXName \
												v3:" for a material named " \
												v4:MatName
										)
										Append MatFXIDs 0
									)
									MaterialIndex += 1
								)
							)
						) else (
							GIMS.Core.SystemMgr.AddResult #Error (Append (FileNameFromPath FilePath) " file version is invalid")
							Result = false
						)
					) else (
						GIMS.Core.SystemMgr.AddResult #Error (Append (FileNameFromPath FilePath) " file syntax is invalid - can't find version line")
						Result = false
					)
					BufferMgr.ClearBuffer BufferID
				) else
					Result = false
				if Result then
					Materials
				else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetMaterialFXColors FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local 	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						BufferID = (BufferMgr.ReadFile FilePath),
						NotEOF = BufferMgr.NotEOF,
						VersionLine = #InvalidLine,
						Result = true
				if BufferID != false then (
					while
						(NotEOF BufferID) and
						(VersionLine == #InvalidLine)
					do
						VersionLine = (ReadVal BufferID ValidateGTAString:true)
					if VersionLine != #InvalidLine then (
						if (TrimLeft (TrimRight VersionLine)) == "6.00" then (
							local	BufSeek = BufferMgr.BufSeek,
									LineID = (BufferMgr.Search BufferID #MTLFX_TABLE_START CaseOp:#Name)
							if LineID != 0 then (
								BufSeek BufferID (LineID + 1)
								local	Reading = true,
										AppendMHL = GIMS.Core.ArrayOps.AppendMHL,
										oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
										TypeCast = GIMS.Core.ValueOps.TypeCast,
										AddResult = GIMS.Core.SystemMgr.AddResult
								while
									Reading and
									(NotEOF BufferID)
								do (
									local tLine = (ReadVal BufferID FilterStr:" \t" ValidateGTAString:true)
									if tLine != #InvalidLine then (
										local	ParamName = tLine[1]
										if (TypeCast ParamName Name) == #MTLFX_TABLE_END then
											Reading = false
										else
											AppendMHL MaterialFXColors (oFTypeExec tLine #Color IDMask:#{2..4}) Hash:ParamName
									)
								)
							) else (
								GIMS.Core.SystemMgr.AddResult #Error (Append (FileNameFromPath FilePath) " file syntax is invalid - can't find a MTLFX_TABLE_START tag")
								Result = false
							)
						) else (
							GIMS.Core.SystemMgr.AddResult #Error (Append (FileNameFromPath FilePath) " file version is invalid")
							Result = false
						)
					) else (
						GIMS.Core.SystemMgr.AddResult #Error (Append (FileNameFromPath FilePath) " file syntax is invalid - can't find version line")
						Result = false
					)
					BufferMgr.ClearBuffer BufferID
				) else
					Result = false
				if Result then
					MaterialFXColors
				else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),

		fn GetTextureNames FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				TextureNames = #(#("NULL"), #())
				GIMS.Core.ArrayOps.RebuildMHL TextureNames
				TextureNames
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetObjectNames FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ObjectNames = #(#("NULL"), #())
				GIMS.Core.ArrayOps.RebuildMHL ObjectNames
				ObjectNames
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Shaders = #(
					#( /*group name patterns*/
						"*clouds*",
						"*vehicle*",
						"*glass*",
						"*grass*",
						"*parallax*",
						"*cloth*",
						"*ped*",
						"*water*",
						"*terrain*",
						"*trees*",
						"*weapon*",
						"*decal*",
						"*emissive*",
						"*mirror*",
						"*cutout*",
						"*normal*",
						"*reflect*",
						"*spec*",
						"*default*"
					), #( /*group names*/
						"Clouds",
						"Vehicle",
						"Glass",
						"Grass",
						"Parallax",
						"Cloth",
						"Ped",
						"Water",
						"Terrain",
						"Trees",
						"Weapon",
						"Decal",
						"Emissive",
						"Mirror",
						"Cutout",
						"Normal bump",
						"Reflect",
						"Specular",
						"Default",
						"Other"
					),
					#(), /*group * shader*/
					[1, 1], /*default shader [GID, SID]*/
					#(#(), #())	/*MHL: SPS * SPSName*/
				)
				local	GroupCount = Shaders[2].Count,
						SPSGroups = Shaders[3]
				for i = GroupCount to 1 by -1 do
					SPSGroups[i] = #()
				Materials = #(
					#(),		--material names in normal order
					#(),		--colors
					#(),		--groups
					#(),		--grouped materials
					#(),		--grouped indices
					#(#(), #())	--[groupid, matid] to mat index MHL
				)
				MaterialFXColors = #(#(), #())
				ObjectNames = #(#(), #())
				TextureNames = #(#(), #())
				BoneDataCRCs = #(#(), #(), #())
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Load = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ReadCached = GIMS.Core.CacheMgr.ReadCached,
						GameMgr = GIMS.CurrentGame.Core.GameMgr
				UpdateProgress #Progress -1
				UpdateProgress #AddStage 1
				PreLoad()
				UpdateProgress #AddStage 1
				Shaders = (ReadCached GameMgr.ShadersFilepath ThisObj.GetShaders Type:"Shaders" IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				local	IsLoadedFromCache = false
				MaterialFXColors = (ReadCached GameMgr.MaterialFXFilepath ThisObj.GetMaterialFXColors Type:"MtlColors" DefaultData:MaterialFXColors IgnoreBehavior:true IsLoadedFromCache:(&IsLoadedFromCache))
				UpdateProgress #AddStage 1
				if Have MaterialFXColors then
					Materials = (ReadCached GameMgr.MaterialsFilepath ThisObj.GetMaterials Type:"Mtls" DefaultData:Materials IgnoreBehavior:true ForceInvalidateCache:(not IsLoadedFromCache))
				UpdateProgress #AddStage 1
				BoneDataCRCs = (ReadCached undefined undefined GCCFile:(GetFilenameFile GameMgr.BoneDataCRCsFilepath) GCCPath:#FilesPath DefaultData:BoneDataCRCs IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				TextureNames = (ReadCached undefined ThisObj.GetTextureNames GCCFile:"TextureNames" Type:"Cache" DefaultData:TextureNames IgnoreBehavior:true)
				ObjectNames = (ReadCached undefined ThisObj.GetObjectNames GCCFile:"ObjectNames" Type:"Cache" DefaultData:ObjectNames IgnoreBehavior:true)
				Loaded = true
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetShaderByName SPSName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (GIMS.Core.ArrayOps.FetchMHL Shaders[5] SPSName ReturnHashOnFail:false)
				if No Result then
					throw "Unknown SPS name: " SPSName
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	(
		local DB = strDB()
		DB.ThisObj = DB
		GIMS.CurrentGame.Core.DB = DB
		DB.PreLoad()
	)
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
