/*#PC*DEFINE	CurrentGame	MP3*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.DB*/ strDB (
		ThisObj,
		/*SYSTEM*/	Shaders,
					ObjectNames, TextureNames,
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
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast version Integer) != 21 then
						EGIMS_EHAbort "Please update OpenIV to start GIMS for Max Payne 3."
					if NodeClass != "ShaderManagerMP3" then
						EGIMS_EHAbort "Please update OpenIV to start GIMS for Max Payne 3."
					local	ShaderManagerSubTree = (XMLNode.ReadSubTree())
					if No ShaderManagerSubTree then
						throw (Append "Can't read the ShaderManager subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
					if not (ShaderManagerSubTree.ReadToFollowing "Shaders") then
						throw (Append "Can't find \"Shaders\" parameter at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					local	ShadersSubTree = (ShaderManagerSubTree.ReadSubTree())
					if No ShadersSubTree then
						throw (Append "Can't read Shaders subtree at " ([ShaderManagerSubTree.LineNumber, ShaderManagerSubTree.LinePosition] as String))
					while (ShadersSubTree.Read()) do
						_GetShaders_ParseShader ShadersSubTree Shaders NETStream TypeCast
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
		fn GetTextureNames FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				TextureNames = #(#("NULL", "corona"), #())
				GIMS.Core.ArrayOps.RebuildMHL TextureNames
				TextureNames
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetObjectNames FilePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ObjectNames = #(#("NULL", "world"), #())
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
						"*micromovement*",
						"*rmptfx*",
						"*tracer*",
						"*fence*",
						"*grass*",
						"*cloth*",
						"*ped*",
						"*vehicle*",
						"*weapon*",
						"*glass*",
						"*parallax*",
						"*terrain*",
						"*trees*",
						"*decal*",
						"*emissive*",
						"*cutout*",
						"*normal*",
						"*reflect*",
						"*spec*",
						"*decal*",
						"*default*"
					), #( /*group names*/
						"Micromovement",
						"Particle FX",
						"Tracer",
						"Fence",
						"Grass",
						"Cloth",
						"Ped",
						"Vehicle",
						"Weapon",
						"Glass",
						"Parallax",
						"Terrain",
						"Trees",
						"Decal",
						"Emissive",
						"Cutout",
						"Normal bump",
						"Reflect",
						"Spec",
						"Decal",
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
				ObjectNames = #(#(), #())
				TextureNames = #(#(), #())
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Load = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ReadCached = GIMS.Core.CacheMgr.ReadCached,
						GameMgr = GIMS.CurrentGame.Core.GameMgr,
						MergeMHL = GIMS.Core.ArrayOps.MergeMHL
				UpdateProgress #Progress -1
				UpdateProgress #AddStage 1
				PreLoad()
				UpdateProgress #AddStage 1
				Shaders = (ReadCached GameMgr.ShadersFilepath ThisObj.GetShaders Type:"Shaders" IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				TextureNames = (ReadCached undefined ThisObj.GetTextureNames GCCFile:"TextureNames" Type:"Cache" DefaultData:TextureNames IgnoreBehavior:true)
				ObjectNames = (ReadCached undefined ThisObj.GetObjectNames GCCFile:"ObjectNames" Type:"Cache" DefaultData:ObjectNames IgnoreBehavior:true)
				Loaded = true
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
