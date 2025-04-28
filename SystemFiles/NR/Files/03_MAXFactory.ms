/*#PC*DEFINE	CurrentGame	NR*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.ObjectMgr*/strObjectMgr (
		/*Shortcuts*/
			/*MAX*/
			IsFinite = Bit.IsFinite,
			BitAnd = Bit.And,
			DeleteFaces = MeshOp.DeleteFaces,
			BreakVerts = MeshOp.BreakVerts,
			GetIsoVerts = MeshOp.GetIsoVerts,
			WeldVertsByThreshold = MeshOp.WeldVertsByThreshold,
			RemoveIsolatedVerts = MeshOps.RemoveIsolatedVerts,
			RemoveDegenerateFaces = MeshOp.RemoveDegenerateFaces,
			RemoveIllegalFaces = MeshOp.RemoveIllegalFaces,
			GetMapSupport = MeshOp.GetMapSupport,
			DefaultMapFaces = MeshOp.DefaultMapFaces,
			GetMapFace = MeshOp.GetMapFace,
			GetMapVert = MeshOp.GetMapVert,
			GetFacesUsingVert = MeshOp.GetFacesUsingVert,
			MDetachFaces = MeshOp.DetachFaces,
			PDetachFaces = PolyOp.DetachFaces,
			PAttach = PolyOp.Attach,
			PGetFaceMatID = PolyOp.GetFaceMatID,
			PGetFaceVerts = PolyOp.GetFaceVerts,
			PGetFaceEdges = PolyOp.GetFaceEdges,
			PGetFacesUsingEdge = PolyOp.GetFacesUsingEdge,
			PGetFaceNormal = PolyOp.GetFaceNormal,
			PGetFaceCenter = PolyOp.GetFaceCenter,
			PDeleteFaces = PolyOp.DeleteFaces,
			PGetVert = PolyOp.GetVert,
			PGetFaceArea = PolyOp.GetFaceArea,
			PGetFaceDeg = PolyOp.GetFaceDeg,
			PTessellateByFace = PolyOp.TessellateByFace,
			PCreateEdge = PolyOp.CreateEdge,
			PWeldVertsByThreshold = PolyOp.WeldVertsByThreshold,
			PGetMapSupport = PolyOp.GetMapSupport,
			PDefaultMapFaces = PolyOp.DefaultMapFaces,
			GetVertexWeightCount = SkinOps.GetVertexWeightCount,
			GetVertexWeight = SkinOps.GetVertexWeight,
			GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
			AddBone = SkinOps.AddBone,
			SetInnerRadius = SkinOps.SetInnerRadius,
			SetOuterRadius = SkinOps.SetOuterRadius,
			UnNormalizeVertex = SkinOps.UnNormalizeVertex,
			ReplaceVertexWeights = SkinOps.ReplaceVertexWeights,
			GetBoneName = (
				try
					SkinOps.GetBoneNameByListID
				catch
					SkinOps.GetBoneName
			),
			DependencyLoopTest = Refs.DependencyLoopTest,
			/*Data*/
			SceneDirPattern = ((GetDir #Scene) + "*"),
			/*GUI*/
			UpdateProgress, AddResult,
			/*Array*/
			Split, Modify, RotateA, NormalizeA, QuickSearch, QuickSort, AppendMHL, FetchMHL, RebuildMHL, AppendIfUniq,
			/*Misc*/
			TypeCast, ConvertStruct, CreateIfUnique, CalculateBounds, ExtendBound, RemoveSmoothingGroups, GetStandartized, GetPathString, CreateMesh, StoreModData, RestoreModData, GetChildren, ReadCached, ReplaceChars, UnifyMaterials, CalculateVolumeAndCenterOfMass, GetSectorCoords, oFTypeExec, FormatText, DumpMesh, Compare, GetShaderByName,
			/*Buffers*/
			ClearBuffer, ReadFile, BufSearch, ReadVal, GetFile,
		/*Ops*/
		fn StructFromFile File VDMaps = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.StructFromFile"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FileType = (GetFileNameType File),
						FileType = (SubString FileType 2 FileType.Count),
						StrType = (
							case (TypeCast FileType name) of (
								#rip:
									GIMS.CurrentGame.Core.TypeLibrary.grcRipFile
								default:
									return undefined	--throw "Unknown resource type"
							)
						),
						Result = (ReadCached File StrType HandlerParam:VDMaps GCCPath:#ResourceCachePath Type:FileType)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory*/strMAXFactory (
		ObjectMgr = strObjectMgr()
	)
	GIMS.CurrentGame.Core.MAXFactory = strMAXFactory()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
