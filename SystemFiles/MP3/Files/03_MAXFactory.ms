/*#PC*DEFINE	CurrentGame	MP3*/
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
			Rules,
			/*GUI*/
			UpdateProgress, AddResult,
			/*Array*/
			PreallocatedInsertItem, Dispose, Split, Modify, RotateA, NormalizeA, QuickSearch, QuickSort, AppendSorted, AppendMHL, FetchMHL, RebuildMHL, AppendIfUniq, OrderComparator,
			/*Misc*/
			TypeCast, ConvertStruct, CreateIfUnique, CalculateBounds, ExtendBound, RemoveSmoothingGroups, GetStandartized, GetJenkinsHash, GetPathString, CreateMesh, StoreModData, RestoreModData, GetChildren,
			ReadCached, ReplaceChars, UnifyMaterials, CalculateVolumeAndCenterOfMass, GetSectorCoords, oFTypeExec, FormatText, DumpMesh, Compare, GetShaderByName,
			/*Buffers*/
			ClearBuffer, ReadFile, BufSearch, ReadVal,
		/*Ops*/
		fn GetMaterialLevelsAndSPSList MatList = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.GetMaterialLevelsAndSPSList"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BucketList = #(),
						SPSList = #()
				for i = MatList.Count to 1 by -1 do (
					local	SPS = (GetShaderByName MatList[i].SPSName)
					BucketList[i] = SPS.bucket
					SPSList[i] = SPS
				)
				#(BucketList, SPSList)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PrepareMeshForExport Obj Mtl MatLevelsAndSPSList = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.PrepareMeshForExport"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = true,
						ModData = (StoreModData Obj CollapseToMesh:true)	/*store modifiers*/
				ConvertToMesh Obj
				
				--delete NAN broken faces
				local	InvalidFaces = #{}
				for FaceID = Obj.NumFaces to 1 by -1 do (
					local	FaceVerts = (GetFace Obj FaceID),
							Invalid = false
					for i = 1 to 3 while not Invalid do (
						local	TempVert = (GetVert Obj FaceVerts[i])
						for j = 1 to 3 where not (IsFinite TempVert[j]) while not Invalid do
							Invalid = true
					)
					if Invalid then
						InvalidFaces[FaceID] = true
				)
				if InvalidFaces.count != 0 then
					DeleteFaces Obj InvalidFaces
				
				--make a new material
				local	SPSList = MatLevelsAndSPSList[2],
						MatCount = Mtl.MaterialList.Count
				if MatCount > 1 then
					QuickSort #(MatLevelsAndSPSList[1], SPSList, Mtl.MaterialIDList, Mtl.MaterialList, Mtl.Names) MHL:true MHLKeyItemID:1 Comparator:OrderComparator
				
				--check skinning
				if ModData[2].NumberSet != 0 then (
					local	MaterialList = Mtl.MaterialList,
							MtlNames = Mtl.Names
					for i = 1 to MatCount do (
						local	SPS = SPSList[i]
						if not SPS.SupportSkinning then (
							local	n1 = MaterialList[i].Name,
									n2 = MtlNames[i]
							if n1 != n2 then (
								AddResult #Error (
									FormatText \
										v1:"Skinned mesh material \"" \
										v2:n1 \
										v3:"\"(\"" \
										v4:n2 \
										v5:"\") uses not skinnable shader \"" \
										v6:SPS.aName \
										v7:"\", and will be skipped.\nScene mesh location: " \
										v8:(GetPathString Obj) \
								)
							) else (
								AddResult #Error (
									FormatText \
										v1:"Skinned mesh material \"" \
										v2:n1 \
										v3:"\" uses not skinnable shader \"" \
										v4:SPS.aName \
										v5:"\", and will be skipped.\nScene mesh location: " \
										v6:(GetPathString Obj) \
								)
							)
							Result = false
						)
					)
				)
								
				--remove the mesh garbage
				RemoveDegenerateFaces Obj
				RemoveIllegalFaces Obj
				RemoveIsolatedVerts Obj
				
				--restore modifiers
				RestoreModData Obj ModData
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetCNodeProgressEntryCount CNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.GetCNodeProgressEntryCount"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = 0,
						Children = CNode.Children
				for CNodeChild in Children do (
					local	ChildClass = (ClassOf CNodeChild.ParamSource)
					Result += (
						case ChildClass of (
							Editable_Mesh:
								4
							Editable_Poly:
								4
							EGIMS_MP3_ModelMesh:
								4
							EGIMS_MP3_Model_BoneMod:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_MP3_Model_Bone:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_MP3_Model:
								3 + (GetCNodeProgressEntryCount CNodeChild)
							Default:
								1
						)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _GetExcludedTextures_GetFromMtl Obj Mtl TexPaths PathString = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr._GetExcludedTextures_GetFromMtl"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	TexValues = Mtl.TexValues,
					TexValueNames = Mtl.TexValueNames,
					TexInternalFlags = Mtl.TexInternalFlags
			for i = 1 to TexInternalFlags.Count where not TexInternalFlags[i] do (
				local	Map = TexValues[i]
				if Have Map then (
					local	FileName = (
								try
									Map.FileName
								catch ()
							)
					if Have FileName then (
						if
							(DoesFileExist FileName) and
							not (MatchPattern FileName Pattern:SceneDirPattern)
						then
							AppendIfUniq TexPaths FileName Sorted:true Comparator:OrderComparator
						else (
							AddResult #Warning (
								FormatText \
									v1:"Missing a texture in slot \"" \
									v2:(TexValueNames[i] as String) \
									v3:"\" of material \"" \
									v4:Mtl.Name \
									v5:"\" in model \"" \
									v6:(
										if Have PathString then
											PathString
										else
											(PathString = (GetPathString Obj))
									) \
									v7:"\""
							)
						)
					)
				)
			)
			PathString
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetExcludedTextures Obj TexPaths:#() = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.GetExcludedTextures"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjClass = (ClassOf Obj)
				if
					ObjClass == Editable_Mesh or
					ObjClass == Editable_Poly
				then (
					local	ObjMaterial = Obj.Material,
							PathString
					if Have ObjMaterial then (
						for Mtl in (GetStandartized ObjMaterial DoSort:false) do
							PathString = (_GetExcludedTextures_GetFromMtl Obj Mtl TexPaths PathString)
					)
				)
				for Child in Obj.Children where not Child.IsFrozen do
					GetExcludedTextures Child TexPaths:TexPaths
				TexPaths
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SPSToGIMSParamType ParamType = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.SPSToGIMSParamType"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case ParamType of (
					#sp_sampler:
						#String
					#sp_float:
						#Float
					#sp_float2:
						#P2
					#sp_float3:
						#P3
					#sp_float4:
						#P4
					#sp_matrix3x4:
						#P3Array
					#sp_matrix4x4:
						#P4Array
					#sp_float2x3:
						#P2Array
					#sp_float4x4:
						#P4Array
					#sp_float4x5:
						#P4Array
					#D3DDECLTYPE_FLOAT2:
						#P2
					#D3DDECLTYPE_FLOAT3:
						#P3
					#D3DDECLTYPE_FLOAT4:
						#P4
					#D3DDECLTYPE_UBYTE4N:
						#P4
					Default:
						EGIMS_EHAbort ("Unknown SPS parameter type: " + (ParamType as String))
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CheckMirrorBoneIDs TheBones BoneIDs ModelName = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.SPSToGIMSParamType"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for tBone in TheBones do (
					local	MirrorBoneId = tBone.MirrorBoneId
					if not BoneIDs[MirrorBoneId + 1] then (
						tBone.MirrorBoneId = tBone.Id
						AddResult #Warning (
							FormatText \
								v1:"Can't find a mirror bone with ID " \
								v2:MirrorBoneId \
								v3:" for a bone \"" \
								v4:tBone.ObjName \
								v5:"\" of model \"" \
								v6:ModelName \
								v7:"\". Setting to default..."
						)
					)
					CheckMirrorBoneIDs tBone.Children BoneIDs ModelName
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromScene \
			CNode \
			ObjClass:unsupplied \
			DiskPath:undefined \
			Ancestor:undefined \
			AncestorNode:undefined \
			Parent:undefined \
			ParentParamSource:undefined \
			ParentResult:undefined \
			AdditionalParam:undefined \
			BoneIDs:undefined \
			Materials:unsupplied \
			AllowProgress:true \
			ProgressData:undefined = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.StructFromScene"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				at Time 0 (
					local	Obj = CNode.Obj,
							ParamSource = CNode.ParamSource,
							Children = CNode.Children,
							Result,
							SetOwnProgress = (No ProgressData)
					if not Supplied ObjClass then
						ObjClass = (ClassOf ParamSource)
					case ObjClass of (
						EGIMS_MP3_ModelDict: (
							if SetOwnProgress then (
								ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
								UpdateProgress #Progress ProgressData
							)
							local	Items = #(),
									ItemCount = 0
							Items.Count = Children.Count
							for Child in Children do (
								local	Item = (StructFromScene Child Parent:Obj ParentParamSource:ParamSource ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then (
									ItemCount += 1
									Items[ItemCount] = Item
								)
							)
							Items.Count = ItemCount
							if ItemCount == 0 then (
								AddResult #Error (
									FormatText \
										v1:"Model dictionary \"" \
										v2:(GetPathString Obj) \
										v3:"\" is empty. Skipping..."
								)
							) else (
								Result = (
									GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary \
									DiskPath:DiskPath \
									ObjName:(ReplaceChars Obj.Name) \
									Items:Items
								)
							)
						)
						EGIMS_MP3_Model: (
							if AllowProgress then (
								if SetOwnProgress then (
									ProgressData = [0, 0, 3 + (GetCNodeProgressEntryCount CNode)]
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
							) else
								UpdateProgress #None 0
							local	ObjName = (ReplaceChars Obj.Name)
							AdditionalParam = 0
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcDrawable \
								DiskPath:DiskPath \
								ObjName:ObjName \
								LODGroup:(GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup()) \
							)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
							local	BoneIDs = #{}
							Materials = #()
							for Child in Children do (
								local	ChildResult = (
									StructFromScene \
									Child \
									Ancestor:Result \
									AncestorNode:Obj \
									Parent:Obj \
									ParentParamSource:ParamSource \
									ParentResult:Result \
									AdditionalParam:AdditionalParam \
									ProgressData:ProgressData \
									BoneIDs:BoneIDs \
									Materials:Materials \
									AllowProgress:AllowProgress \
								)
								if (IsKindOf ChildResult Integer) then
									AdditionalParam = ChildResult
							)
							local	ShadingGroup = Result.ShadingGroup
							if Have ShadingGroup then
								ShadingGroup.Mtls = Materials
							local	TheSkeleton = Result.TheSkeleton,
									HaveSkeleton = (Have TheSkeleton),
									LodGroup = Result.LodGroup
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
							if HaveSkeleton then (
								TheSkeleton.AuthoredOrientation = ParamSource.AuthoredOrientation
								local	TheBones = TheSkeleton.TheBones,
										SkeletonMaxBoneCount = Rules.SkeletonMaxBoneCount,
										TheBonesCount = TheBones.Count
								CheckMirrorBoneIDs TheBones BoneIDs ObjName
								if TheBonesCount > SkeletonMaxBoneCount then (
									AddResult #Error (
										FormatText \
											v1:"Model \"" \
											v2:(GetPathString Obj) \
											v3:"\" has got " \
											v4:TheBonesCount \
											v5:" bones, when the maximum's " \
											v6:SkeletonMaxBoneCount \
											v7:" ! Skipping..."
									)
									Result = undefined
								)
							)
							LodGroup.LODGroupValues = ParamSource.LODGroupValues
							for LODGroup in LodGroup.LODGroups do (
								for LODMesh in LODGroup do (
									local	MeshBoneID = LODMesh.BoneID
									LODMesh.BoneID = (
										if No MeshBoneID then
											1
										else
											MeshBoneID.Index
									)
								)
							)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
						)
						EGIMS_MP3_Model_BoneMod: (
							StructFromScene \
								CNode \
								ObjClass:EGIMS_MP3_Model_Bone \
								DiskPath:DiskPath \
								Ancestor:Ancestor \
								AncestorNode:AncestorNode \
								Parent:Parent \
								ParentParamSource:ParentParamSource \
								ParentResult:ParentResult \
								AdditionalParam:AdditionalParam \
								BoneIDs:BoneIDs \
								Materials:Materials \
								AllowProgress:AllowProgress \
								ProgressData:ProgressData
						)
						EGIMS_MP3_Model_Bone: (
							if No Ancestor.TheSkeleton then
								Ancestor.TheSkeleton = (GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton())
							AdditionalParam += 1
							ParamSource.Index = AdditionalParam
							local	ObjName = (ReplaceChars Obj.Name),
									tBone = (ConvertStruct undefined GIMS.CurrentGame.Core.TypeLibrary.grcBone ParamSource:ParamSource)
							BoneIDs[tBone.Id + 1] = true
							tBone.ObjName = ObjName
							local	ParentPresent = (Have Parent),
									InvParentTM = (
										if ParentPresent then
											Inverse Parent.Transform
										else
											(Matrix3 1)
									),
									InvWorldTM = (
										if AdditionalParam == 0 then
											InvParentTM
										else
											Inverse AncestorNode.Transform
									)
							tBone.WorldOffset = (Obj.Pos * InvWorldTM)
							tBone.LocalOffset = (Obj.Pos * InvParentTM)
							local	Rot = ((Inverse (Obj.Rotation as Matrix3)) * InvParentTM).Rotation,
									RotEuler = (Rot as EulerAngles)
							tBone.RotationQuaternion = (Inverse Rot)
							tBone.RotationEuler = RotEuler
							tBone.Orient = RotEuler
							tBone.Sorient = [0, 0, 0]	--<TODO> research
							tBone.TheScale = (
								Obj.Scale - (
									if ParentPresent then
										Parent.Scale
									else
										[1, 1, 1]
								)
							)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
							for Child in Children do (
								local	ChildResult = (
									StructFromScene \
									Child \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Obj \
									ParentParamSource:ParamSource \
									ParentResult:tBone \
									AdditionalParam:AdditionalParam \
									BoneIDs:BoneIDs \
									Materials:Materials \
									ProgressData:ProgressData \
									AllowProgress:AllowProgress \
								)
								if (IsKindOf ChildResult Integer) then
									AdditionalParam = ChildResult
							)
							local	ParentBones = (
								if (IsKindOf ParentParamSource EGIMS_MP3_Model) then
									Ancestor.TheSkeleton.TheBones
								else
									ParentResult.Children
							)
							Append ParentBones tBone
							Result = AdditionalParam
						)
						EGIMS_MP3_Model_LightMod: (
							StructFromScene \
								CNode \
								ObjClass:EGIMS_MP3_Model_Light \
								DiskPath:DiskPath \
								Ancestor:Ancestor \
								AncestorNode:AncestorNode \
								Parent:Parent \
								ParentParamSource:ParentParamSource \
								ParentResult:ParentResult \
								AdditionalParam:AdditionalParam \
								AllowProgress:AllowProgress \
								ProgressData:ProgressData
						)
						EGIMS_MP3_Model_Light: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
							if No Ancestor.LightAttributes then
								Ancestor.LightAttributes = (GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes())
							local	LightAttributes = Ancestor.LightAttributes,
									InvParentTM = (
										if Have Parent then
												Inverse Parent.Transform
										else
												(Matrix3 1)
									),
									LightAttr = (ConvertStruct undefined GIMS.CurrentGame.Core.TypeLibrary.grcLight ParamSource:ParamSource)
							LightAttr.BoneID = (
								if
									(IsKindOf ParentParamSource EGIMS_MP3_Model_Bone) or
									(IsKindOf ParentParamSource EGIMS_MP3_Model_BoneMod)
								then
									ParentParamSource.ID
								else
									0
							)
							LightAttr.Position = (Obj.Pos * InvParentTM)
							LightAttr.Direction = ([0, 0, 1] * (Inverse (Obj.Rotation as Matrix3)))
							local	TexName = (ReplaceChars Obj.Name),
									LumTexName = (ReplaceChars ParamSource.pLuminescenceHash),
									TextureNames = GIMS.CurrentGame.Core.DB.TextureNames
							AppendMHL TextureNames TexName Comparator:OrderComparator
							AppendMHL TextureNames LumTexName Comparator:OrderComparator
							LightAttr.CoronaHash = (GetJenkinsHash TexName)
							LightAttr.LuminescenceHash = (GetJenkinsHash LumTexName)
							Append LightAttributes.Items LightAttr
						)
						Editable_Mesh: (
							StructFromScene \
								(GIMS.Core.TypeLibrary.CollectionNode Obj:Obj ParamSource:(EGIMS_MP3_ModelMesh())) \
								DiskPath:DiskPath \
								Ancestor:Ancestor \
								AncestorNode:AncestorNode \
								Parent:Parent \
								ParentParamSource:ParentParamSource \
								ParentResult:ParentResult \
								AdditionalParam:AdditionalParam \
								BoneIDs:BoneIDs \
								Materials:Materials \
								AllowProgress:AllowProgress \
								ProgressData:ProgressData
						)
						Editable_Poly: (
							StructFromScene \
								(GIMS.Core.TypeLibrary.CollectionNode Obj:Obj ParamSource:(EGIMS_MP3_ModelMesh())) \
								DiskPath:DiskPath \
								Ancestor:Ancestor \
								AncestorNode:AncestorNode \
								Parent:Parent \
								ParentParamSource:ParentParamSource \
								ParentResult:ParentResult \
								AdditionalParam:AdditionalParam \
								BoneIDs:BoneIDs \
								Materials:Materials \
								AllowProgress:AllowProgress \
								ProgressData:ProgressData
						)
						EGIMS_MP3_ModelMesh: (
							if AllowProgress then (
								if SetOwnProgress then (
									ProgressData = [0, 0, 1 + (GetCNodeProgressEntryCount CNode)]
									UpdateProgress #Progress ProgressData
								) else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None 0
							local	ObjName = (ReplaceChars Obj.Name),
									Mtl = (GetStandartized Obj.Material DoSort:false),
									MatLevelsAndSPSList = (GetMaterialLevelsAndSPSList Mtl.MaterialList)
							if (PrepareMeshForExport Obj Mtl MatLevelsAndSPSList) then (
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
								local	SkinMod = (
											try
												Obj.Skin
											catch ()
										),
										Skinned = (Have SkinMod)
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
								local	RAWSkinData = (
											if Skinned then
												#()
											else
												unsupplied
										),
										RAWUVCount = 0,
										SPSList = MatLevelsAndSPSList[2],
										FoundVDs = #(),
										FoundVDCount = 0,
										FoundVDsPresent = false,
										NeedNormals = false,
										NeedTangents = false,
										NeedColors = false,
										IsVDSearchFinished = false,
										SkinnedOriginal = Skinned
								FoundVDs.Count = SPSList.Count
								for i = 1 to 2 while not IsVDSearchFinished do (
									for SPS in SPSList do (
										for VertexDeclaration in SPS.VertexDeclarations where VertexDeclaration.Skinned == Skinned do (
											local	VDUVCount = 0
											for Elem in VertexDeclaration.Elements do (
												case Elem.Usage of (
													#D3DDECLUSAGE_NORMAL:
														NeedNormals = true
													#D3DDECLUSAGE_TANGENT:
														NeedTangents = true
													#D3DDECLUSAGE_COLOR:
														NeedColors = true
													#D3DDECLUSAGE_TEXCOORD: (
														VDUVCount += (
															if (SPSToGIMSParamType Elem.aType) == #P4 then
																2
															else
																1
														)
													)
												)
											)
											if VDUVCount > RAWUVCount then
												RAWUVCount = VDUVCount
											FoundVDCount += 1
											FoundVDs[FoundVDCount] = VertexDeclaration
											FoundVDsPresent = true
											IsVDSearchFinished = true
										)
									)
									if not FoundVDsPresent then (
										if Skinned then (
											AddResult #Error (
												FormatText \
												v1:"Some of shaders in object \"" \
												v2:(GetPathString Obj) \
												v3:"\" don't support mesh skinning. The skinning will be automatically turned off."
											)
											RAWSkinData = unsupplied
											Skinned = (not Skinned)
										) else (
											if SkinnedOriginal then (
												AddResult #Error (
													FormatText \
													v1:"Some of shaders in object \"" \
													v2:(GetPathString Obj) \
													v3:"\" don't support mesh skinning. It'll be skipped at export."
												)
											) else (
												AddResult #Error (
													FormatText \
													v1:"Some of shaders in object \"" \
													v2:(GetPathString Obj) \
													v3:"\" require mesh skinning. It'll be skipped at export."
												)
											)
											IsVDSearchFinished = true
											FoundVDsPresent = false
										)
									)
								)
								FoundVDs.Count = FoundVDCount
								if FoundVDsPresent then (
									if NeedTangents then (
										if RAWUVCount == 0 then
											RAWUVCount = 1
										NeedNormals = true
									)
									local	NeedUVs = (RAWUVCount != 0),
											RAWVerts = #(),
											RAWFaces = #(),
											RAWFaceGroups = #(undefined, undefined/*, #SG*/),
											RAWNormals = (if NeedNormals then #() else unsupplied),
											RAWUVData = (if NeedUVs then #() else unsupplied),
											RAWTangents = (if NeedTangents then #() else unsupplied),
											RAWColors = (if NeedColors then #() else unsupplied)
									/*<ERRHANDLERSTART>*/try (
										if (
											DumpMesh \
												Obj \
												RAWVerts \
												RAWFaces \
												Normals:RAWNormals \
												Tangents:RAWTangents \
												Colors:RAWColors \
												UVCount:RAWUVCount \
												UVData:RAWUVData \
												SkinData:RAWSkinData \
												FaceGroups:RAWFaceGroups \
												Materials:Materials \
												CoordsysTM: (
													if Skinned then
														(Inverse AncestorNode.Transform)
													else
														(Inverse Parent.Transform)
												)
										) then (
											
											/*TODO remove, debug*
											LogProfiler #PlainInfo "Geometry RAWSkinData:\t" AddParam:RAWSkinData
											/**/
					
											/*<ERRHANDLERSTART>*/try (
												--prepare
												if No Ancestor.LodGroup then
													Ancestor.LodGroup = (GIMS.CurrentGame.Core.TypeLibrary.grcLodGroup())
												if No Ancestor.ShadingGroup then
													Ancestor.ShadingGroup = (GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup())
												local	LodGroup = Ancestor.LodGroup,
														LODMesh = (
															GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh \
																BoneID:(
																	if
																		(IsKindOf ParentParamSource EGIMS_MP3_Model_Bone) or
																		(IsKindOf ParentParamSource EGIMS_MP3_Model_BoneMod)
																	then
																		ParentResult
																) \
																ObjName:ObjName \
														),
														GroupMtlIDs = RAWFaceGroups[1],
														FaceGroups = RAWFaceGroups[2],
														GroupCount = FaceGroups.Count,
														ModelVertBufferSize = Rules.ModelVertBufferSize,
														SkinPerGeoMaxBoneCount, RAWSkinBones, RAWSkinWeights, RAWSkinBoneCount,
														NeedBoneCountSplit = false,
														AlignedVertexFormats = #()
												--check VDs for AlignedVertexFormat compatibility
												/*<ERRHANDLERSTART>*/try (
													for GroupID = GroupCount to 1 by -1 do (
														local	Mtl = Materials[GroupMtlIDs[GroupID]],
																AlignedVertexFormat = Mtl.AlignedVertexFormat,
																FoundVD = false
														for VertexDeclaration in FoundVDs where VertexDeclaration.Aligned == AlignedVertexFormat while not FoundVD do
															FoundVD = true
														if FoundVD then
															AlignedVertexFormats[GroupID] = AlignedVertexFormat
														else (
															AddResult #Warning (
																FormatText \
																v1:"Shader \"" \
																v2:(Mtl.SPSName as String) \
																v3:"\" of object \"" \
																v4:(GetPathString Obj) \
																v5:"\" don't support selected \"Aligned vertex format\" flag:" \
																v6:AlignedVertexFormat \
																v7:". This flag'll be automatically switched."
															)
															AlignedVertexFormat = (not AlignedVertexFormat)
															AlignedVertexFormats[GroupID] = AlignedVertexFormat
															Mtl.AlignedVertexFormat = AlignedVertexFormat
														)
													)
												/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
												--split face groups to fit limits
												/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.StructFromScene+EGIMS_MP3_ModelMesh+SplitFaceGroups"; local PWS = (*//*<PROFILERSTARTED>*/
												/*<ERRHANDLERSTART>*/try (
													if Skinned then (
														RAWSkinBones = RAWSkinData[1]
														RAWSkinWeights = RAWSkinData[2]
														RAWSkinBoneCount = RAWSkinBones.Count
														SkinPerGeoMaxBoneCount = Rules.SkinPerGeoMaxBoneCount
														NeedBoneCountSplit = (RAWSkinBoneCount > SkinPerGeoMaxBoneCount)
													)
													local	GroupsToSplit = #{1..GroupCount}
													while GroupsToSplit.NumberSet != 0 do (
														for GroupID in GroupsToSplit do (
															UpdateProgress #None 0
															local	Faces = FaceGroups[GroupID],
																	NewFaces = #(),
																	NewGroupSize = 0,
																	UsedVertCount = 0,
																	MoveToNewGroup = false,
																	UsedBones
															if NeedBoneCountSplit then (
																UsedBones = #{}
																UsedBones.Count = RAWSkinBoneCount
															)
															NewFaces.Count = Faces.Count
															--process faces
															/*<ERRHANDLERSTART>*/try (
																for FaceID in Faces do (
																	if not MoveToNewGroup then (
																		UsedVertCount += 3
																		for SubVertID = 1 to 3 while not MoveToNewGroup do (
																			if NeedBoneCountSplit then (
																				local	SkinBones = RAWSkinBones[RAWFaces[FaceID][SubVertID]],
																						BA = (TypeCast SkinBones BitArray)
																				UsedBones += BA
																				Free BA
																				MoveToNewGroup = (UsedBones.NumberSet > SkinPerGeoMaxBoneCount)
																			)
																			if UsedVertCount >= ModelVertBufferSize then
																				MoveToNewGroup = true
																		)
																	)
																	if MoveToNewGroup then (
																		NewGroupSize += 1
																		NewFaces[NewGroupSize] = FaceID
																	)
																)
															/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
															--add a new group and fix current
															/*<ERRHANDLERSTART>*/try (
																GroupsToSplit[GroupID] = false
																if MoveToNewGroup then (
																	NewFaces.Count = NewGroupSize
																	Faces.Count = (Faces.Count - NewGroupSize)
																	Append FaceGroups NewFaces
																	Append GroupMtlIDs GroupMtlIDs[GroupID]
																	Append AlignedVertexFormats AlignedVertexFormats[GroupID]
																	GroupCount += 1
																	GroupsToSplit[GroupCount] = true
																)
															/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
														)
													)
												/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
												/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
												--collect data
												if AllowProgress then (
													ProgressData.x += 1
													UpdateProgress #Progress ProgressData
												) else
													UpdateProgress #None 0
												if GroupCount > Rules.GeometryCountLimit then (
													AddResult #Error (
														FormatText \
														v1:"Face group count " \
														v2:GroupCount \
														v3:" of mesh \"" \
														v4:(GetPathString Obj) \
														v5:"\" violates the limit " \
														v6:Rules.GeometryCountLimit \
														v7:"\nThat mesh will be skipped. You should consider reducing number of materials, or splitting that mesh into multiple."
													)
												) else (
													/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.StructFromScene+EGIMS_MP3_ModelMesh+CollectData"; local PWS = (*//*<PROFILERSTARTED>*/
													/*<ERRHANDLERSTART>*/try (
														local	grcMeshVertex = GIMS.CurrentGame.Core.TypeLibrary.grcMeshVertex,
																RAWMapFaceGroups = RAWUVData[1],
																RAWMapVertGroups = RAWUVData[2],
																NormalsFaces = (if NeedNormals then RAWNormals[1]),
																NormalsVectors = (if NeedNormals then RAWNormals[2]),
																TangentFaces = (if NeedTangents then RAWTangents[1]),
																TangentInfos = (if NeedTangents then RAWTangents[2]),
																ColorFaces = (if NeedColors then RAWColors[1]),
																ColorVerts = (if NeedColors then RAWColors[2]),
																AABB = GIMS.Core.TypeLibrary.AABB,
																Geometries = LODMesh.Geometries,
																grcLODMeshGeometry = GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshGeometry,
																NeedTotalAABB = (GroupCount > 1),
																TotalAABB = (if NeedTotalAABB then (GIMS.Core.TypeLibrary.AABB())),
																MatBounds = #(),
																HashFmtStr = "%,",
																HashValueSS = (StringStream ""),
																VertHashPropName = #HashValue,
																OldProgressData
														Geometries.Count = GroupCount
														MatBounds.Count = GroupCount
														LODMesh.Skinned = Skinned
														if AllowProgress then (
															OldProgressData = ProgressData
															ProgressData = [0, 0, GroupCount]
															UpdateProgress #Progress ProgressData
														)
														for GroupID = 1 to GroupCount do (
															if AllowProgress then (
																ProgressData.x += 1
																UpdateProgress #Progress ProgressData
															) else
																UpdateProgress #None 0
															
															--collect geometry data
															local	Faces = FaceGroups[GroupID],
																	Idx = #(),
																	Verts = #(),
																	GroupFaceCount = Faces.Count,
																	GroupVertBufferSize = (GroupFaceCount * 2),
																	IdxCount = 0,
																	VertCount = 0
															Idx.Count = GroupFaceCount
															Verts.Count = GroupVertBufferSize
															for FaceID in Faces do (
																local	Face = RAWFaces[FaceID],
																		NormalsFace = (if NeedNormals then NormalsFaces[FaceID]),
																		TangentFace = (if NeedTangents then TangentFaces[FaceID]),
																		ColorFace = (if NeedColors then ColorFaces[FaceID]),
																		FaceIndices = #()
																FaceIndices.Count = 3
																for SubVertID = 1 to 3 do (
																
																	--calculate vertex hash
																	local	PhysVertID = Face[SubVertID],
																			ColorVertID, MapVertIDs, NormalsVertID, TangentVertID
																	Format HashFmtStr PhysVertID To:HashValueSS
																	if NeedColors then (
																		ColorVertID = ColorFace[SubVertID]
																		Format HashFmtStr ColorVertID To:HashValueSS
																	)
																	if NeedUVs then (
																		MapVertIDs = #()
																		for ChID = RAWUVCount to 1 by -1 do (
																			local	MapVertID = RAWMapFaceGroups[ChID][FaceID][SubVertID]
																			MapVertIDs[ChID] = MapVertID
																			Format HashFmtStr MapVertID To:HashValueSS
																		)
																	)
																	if NeedNormals then (
																		NormalsVertID = NormalsFace[SubVertID]
																		Format HashFmtStr NormalVertID To:HashValueSS
																	)
																	if NeedTangents then (
																		TangentVertID = TangentFace[SubVertID]
																		Format HashFmtStr TangentVertID To:HashValueSS
																	)
																	local	HashValue = (HashValueSS as String)
																	Free HashValueSS
																
																	--find place for the vertex
																	local	VertID = (QuickSearch Verts HashValue EndID:VertCount PropertyName:VertHashPropName GetInsertionPoint:true Comparator:OrderComparator)
																	if VertID < 0 then (	--already present
																		VertID = -VertID	--fix place index
																		if VertID > VertCount then
																			VertCount = VertID
																		FaceIndices[SubVertID] = Verts[VertID]
																	) else (	--new vertex
																			
																		--collect vertex data
																		local	Pos = RAWVerts[PhysVertID],
																				Normal = (if NeedNormals then NormalsVectors[NormalsVertID]),
																				UVCoords = unsupplied,
																				VertColor, Tangent
																		if NeedColors then
																			VertColor = ColorVerts[ColorVertID]
																		if NeedUVs then (
																			UVCoords = #()
																			for ChID = RAWUVCount to 1 by -1 do
																				UVCoords[ChID] = (TypeCast RAWMapVertGroups[ChID][MapVertIDs[ChID]] Point3)
																		)
																		if NeedTangents then
																			Tangent = TangentInfos[TangentVertID]

																		--preallocate vertex buffer
																		VertCount += 1
																		if (VertCount > GroupVertBufferSize) then (
																			GroupVertBufferSize += GroupFaceCount
																			Verts.Count = GroupVertBufferSize
																		)
																		
																		--add vertex
																		local	TempVertex = (
																					if Skinned then (
																						grcMeshVertex \
																							Position:Pos \
																							Normal:Normal \
																							TheColor:VertColor \
																							Tangent:Tangent \
																							SkinBones:RAWSkinBones[PhysVertID] \
																							SkinWeights:RAWSkinWeights[PhysVertID] \
																							UVCoords:UVCoords \
																							HashValue:HashValue \
																					) else (
																						grcMeshVertex \
																							Position:Pos \
																							Normal:Normal \
																							TheColor:VertColor \
																							Tangent:Tangent \
																							UVCoords:UVCoords \
																							HashValue:HashValue \
																					)
																				)																		
																		PreallocatedInsertItem TempVertex Verts VertID VertCount
																		FaceIndices[SubVertID] = TempVertex
																	)
																)
																IdxCount += 1
																Idx[IdxCount] = FaceIndices
																
																--preallocate vertex buffer
																if VertCount > (GroupVertBufferSize - 3) then (
																	GroupVertBufferSize += GroupFaceCount
																	Verts.Count = GroupVertBufferSize
																)
															)
															
															--restore vert indices
															for i = 1 to VertCount do
																Verts[i].CollectionIndex = i
															for FaceIdx in Idx do (
																for i = 1 to 3 do
																	FaceIdx[i] = FaceIdx[i].CollectionIndex
															)
															
															--create geometry
															local	Positions = #(),
																	Normals = #(),
																	Colors = #(),
																	Tangents = #(),
																	MatBound = (AABB())
															if Skinned then (
																local	SkinBones = #(),
																		SkinWeights = #()
																if NeedUVs then (
																	local	UVCoords = #()
																	for i = RAWUVCount to 1 by -1 do
																		UVCoords[i] = #()
																	for VertID = VertCount to 1 by -1 do (
																		local	Vert = Verts[VertID],
																				VertPosition = Vert.Position
																		ExtendBound MatBound VertPosition
																		Positions[VertID] = VertPosition
																		Normals[VertID] = Vert.Normal
																		Colors[VertID] = Vert.TheColor
																		Tangents[VertID] = Vert.Tangent
																		SkinBones[VertID] = Vert.SkinBones
																		SkinWeights[VertID] = Vert.SkinWeights
																		local	VertUVCoords = Vert.UVCoords
																		for ChID = 1 to RAWUVCount do
																			UVCoords[ChID][VertID] = VertUVCoords[ChID]
																	)
																	
																	/*TODO remove, debug*
																	LogProfiler #PlainInfo "\tResult #(SkinBones, SkinWeights):\t" AddParam:#(SkinBones, SkinWeights)
																	/**/
											
																	Geometries[GroupID] = (
																		grcLODMeshGeometry \
																			ShaderIndex:GroupMtlIDs[GroupID] \
																			AlignedVertexFormat:AlignedVertexFormats[GroupID] \
																			Idx:Idx \
																			Positions:Positions \
																			Normals:Normals \
																			Colors:Colors \
																			Tangents:Tangents \
																			SkinBones:SkinBones \
																			SkinWeights:SkinWeights \
																			UVCoords:UVCoords \
																	)
																) else (
																	for VertID = VertCount to 1 by -1 do (
																		local	Vert = Verts[VertID],
																				VertPosition = Vert.Position
																		ExtendBound MatBound VertPosition
																		Positions[VertID] = VertPosition
																		Normals[VertID] = Vert.Normal
																		Colors[VertID] = Vert.TheColor
																		Tangents[VertID] = Vert.Tangent
																		SkinBones[VertID] = Vert.SkinBones
																		SkinWeights[VertID] = Vert.SkinWeights
																	)
																	
																	/*TODO remove, debug*
																	LogProfiler #PlainInfo "Geometry #(SkinBones, SkinWeights):\t" AddParam:#(SkinBones, SkinWeights)
																	/**/
											
																	Geometries[GroupID] = (
																		grcLODMeshGeometry \
																			ShaderIndex:GroupMtlIDs[GroupID] \
																			AlignedVertexFormat:AlignedVertexFormats[GroupID] \
																			Idx:Idx \
																			Positions:Positions \
																			Normals:Normals \
																			Colors:Colors \
																			Tangents:Tangents \
																			SkinBones:SkinBones \
																			SkinWeights:SkinWeights \
																	)
																)
															) else (	--not Skinned
																if NeedUVs then (
																	local	UVCoords = #()
																	for i = RAWUVCount to 1 by -1 do
																		UVCoords[i] = #()
																	for VertID = VertCount to 1 by -1 do (
																		local	Vert = Verts[VertID],
																				VertPosition = Vert.Position
																		ExtendBound MatBound VertPosition
																		Positions[VertID] = VertPosition
																		Normals[VertID] = Vert.Normal
																		Colors[VertID] = Vert.TheColor
																		Tangents[VertID] = Vert.Tangent
																		local	VertUVCoords = Vert.UVCoords
																		for ChID = 1 to RAWUVCount do
																			UVCoords[ChID][VertID] = VertUVCoords[ChID]
																	)
																	Geometries[GroupID] = (
																		grcLODMeshGeometry \
																			ShaderIndex:GroupMtlIDs[GroupID] \
																			AlignedVertexFormat:AlignedVertexFormats[GroupID] \
																			Idx:Idx \
																			Positions:Positions \
																			Normals:Normals \
																			Colors:Colors \
																			Tangents:Tangents \
																			UVCoords:UVCoords \
																	)
																) else (
																	for VertID = VertCount to 1 by -1 do (
																		local	Vert = Verts[VertID],
																				VertPosition = Vert.Position
																		ExtendBound MatBound VertPosition
																		Positions[VertID] = VertPosition
																		Normals[VertID] = Vert.Normal
																		Colors[VertID] = Vert.TheColor
																		Tangents[VertID] = Vert.Tangent
																	)
																	Geometries[GroupID] = (
																		grcLODMeshGeometry \
																			ShaderIndex:GroupMtlIDs[GroupID] \
																			AlignedVertexFormat:AlignedVertexFormats[GroupID] \
																			Idx:Idx \
																			Positions:Positions \
																			Normals:Normals \
																			Colors:Colors \
																			Tangents:Tangents \
																	)
																)
															)
															
															--collect bounds
															MatBounds[GroupID] = MatBound
															if NeedTotalAABB then
																ExtendBound TotalAABB MatBound
																
															--cleanup
															for i = 1 to VertCount do
																Verts[i].Dispose()
															Free Verts
														)
														if AllowProgress then
															ProgressData = OldProgressData
														
														--store bounds
														if NeedTotalAABB then
															InsertItem TotalAABB MatBounds 1
														for tAABB in MatBounds do (
															local	bMin = tAABB.bMin,
																	bMax = tAABB.bMax,
																	AABBSize = (bMax - bMin),
																	sX = AABBSize.x,
																	sY = AABBSize.y,
																	sZ = AABBSize.z,
																	rMin = (
																		(
																			if sX < sY then (
																				if sX < sZ then
																					sX
																				else
																					sZ
																			) else (
																				if sY < sZ then
																					sY
																				else
																					sZ
																			)
																		) / 2
																	),
																	rMax = ((Length AABBSize) / 2)
															bMin = (TypeCast tAABB.bMin Point4)
															bMax = (TypeCast tAABB.bMax Point4)
															bMin.w = rMax
															bMax.w = rMin
															tAABB.bMin = bMin
															tAABB.bMax = bMax
														)
														LODMesh.Bounds = MatBounds
														
														--store mesh
														Append LodGroup.LODGroups[ParamSource.Type] LODMesh
													/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
													/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
												)
												/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
													#(
														#RAWVerts,
														#RAWFaces,
														#RAWFaceGroups,
														#RAWNormals,
														#RAWUVData,
														#RAWTangents,
														#RAWColors
													), #(
														RAWVerts,
														RAWFaces,
														RAWFaceGroups,
														RAWNormals,
														RAWUVData,
														RAWTangents,
														RAWColors
													)
												))/*<ERRHANDLEREND>*/
										)
									/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
									
									--cleanup
									Dispose RAWVerts
									Dispose RAWFaces
									Dispose RAWFaceGroups
									if Skinned then
										Dispose RAWSkinData
									if NeedNormals then
										Dispose RAWNormals
									if NeedUVs then
										Dispose RAWUVData
									if NeedTangents then
										Dispose RAWTangents
									if NeedColors then
										Dispose RAWColors
								) else (
									if SkinnedOriginal then
										throw "Can't find a Vertex declaration for an object " (GetPathString Obj)
								)
								Free FoundVDs
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
							) else (
								if AllowProgress then (
									ProgressData.x += 4
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
							)
						)
						EGIMS_MP3_TexDict: (
							local	ObjList = ParamSource.ObjList
							if SetOwnProgress then (
								ProgressData = [0, 0, ObjList.Count]
								UpdateProgress #Progress ProgressData
							)
							local	Items = #(),
									ObjName = (ReplaceChars Obj.Name)
							for Child in ObjList where Have Child do (
								if (IsKindOf Child EGIMS_MP3_ModelDict) then (
									for SubChild in Child.Children where (IsKindOf SubChild EGIMS_MP3_Model) do
										Items += (GetExcludedTextures SubChild)
								) else
									Items += (GetExcludedTextures Child)
							)
							local	ItemCount = Items.Count
							if ItemCount == 0 then (
								AddResult #Error (
									FormatText \
										v1:"Texture dictionary \"" \
										v2:(GetPathString Obj) \
										v3:"\" is empty, and it'll be skipped automatically."
								)
							) else (
								local	grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture
								for i = 1 to ItemCount do (
									local	FilePath = Items[i]
									Items[i] = (
										grcTexture \
											ObjName:(GetFileNameFile FilePath) \
											TexturePath:FilePath \
											Type:00000001 \	--<TODO>	get from material properties
											PixelFormat:00000001	--<TODO>	get from material properties
									)
								)
								Result = (
									GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary \
									DiskPath:DiskPath \
									ObjName:ObjName \
									Items:Items
								)
							)
						)
						Default:
							throw ("Unknown object type: " + ObjClass as String)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ObjClass), #((if Have CNode.Obj then CNode.Obj.Name), (if Have CNode.ParamSource then (ClassOf CNode.ParamSource) else (if Have CNode.Obj then (ClassOf CNode.Obj))))))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromFile File TexPaths = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.ObjectMgr.StructFromFile"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FileType = (GetFileNameType File)
				FileType = (SubString FileType 2 FileType.Count)
				local	Type = (TypeCast FileType name),
						StrType = (
							case Type of (
								#odr:
									GIMS.CurrentGame.Core.TypeLibrary.grcDrawable
								#odd:
									GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary
								#otd:
									GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary
								default:
									return undefined	--throw "Unknown resource type"
							)
						),
						Result = (ReadCached File StrType GCCPath:#ResourceCachePath Type:FileType HandlerParam:TexPaths)
				if Have Result then (
					local	CheckLocked = (TryGetProperty Obj #CheckLocked)
					if CheckLocked != #GetPropertyFailed then (
						if (CheckLocked()) then (
							AddResult #Error (
								FormatText \
									v1:"File \"" \
									v2:File \
									v3:"\" is locked by its creator to prevent import. Skipping..."
							)
							Result = undefined
						)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.MaterialOps*/strMaterialOps (
		/*Shortcuts*/
			Compare, AddResult, FixMapFileNames, ConvertStruct, AsoFText, LoadBitmapFile, AppendMHL, QuickSort, QuickSearch, TypeCast, UpdateMatrix, UpdateProgress, FormatText, CopyBitmapAlpha, GetDiffuseWithOpacityAlpha,
		/*Ops*/
		fn GetStandartized Mtl NeedMultiMtl:true DoOwnProgress:false DoSort:true TargetMtl:unsupplied BaseIndex:0 = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MAXFactory.MaterialOps.GetStandartized"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case (ClassOf Mtl) of (
					MultiMaterial: (
						if not NeedMultiMtl then (
							if Supplied TargetMtl then (
								local	MaterialList = Mtl.MaterialList,
										MaterialIDList = Mtl.MaterialIDList,
										Names = Mtl.Names,
										MatCount = MaterialList.Count,
										TrgMaterialList = TargetMtl.MaterialList,
										TrgMaterialIDList = TargetMtl.MaterialIDList,
										TrgNames = TargetMtl.Names
								for MtlID = MatCount to 1 by -1 do (
									local	TargetIndex = (BaseIndex + MtlID)
									TrgMaterialList[TargetIndex] = (GetStandartized MaterialList[MtlID] NeedMultiMtl:false TargetMtl:TargetMtl BaseIndex:(TrgMaterialList.Count + BaseIndex))
									TrgMaterialIDList[TargetIndex] = MaterialIDList[MtlID]
									TrgNames[TargetIndex] = Names[MtlID]
								)
							)
							OK
						) else (
							local	NewMtl = (Copy Mtl),
									MaterialList = NewMtl.MaterialList,
									MaterialIDList = NewMtl.MaterialIDList,
									MatCount = MaterialList.Count
							for MtlID = 1 to MatCount do (
								if DoOwnProgress then
									UpdateProgress #Progress [MtlID, 0, MatCount]
								else
									UpdateProgress #None 0
								local	NewSubMtl = (GetStandartized MaterialList[MtlID] NeedMultiMtl:false TargetMtl:NewMtl BaseIndex:MaterialList.Count)
								MaterialList[MtlID] = (
									if NewSubMtl == OK then
										(EGIMS_MP3_material())
									else
										NewSubMtl
								)
							)
							if DoSort then
								QuickSort #(NewMtl.MaterialList, MaterialIDList) MHL:true
							NewMtl.ShowInViewport = true
							NewMtl
						)
					)
					EGIMS_MP3_material: (
						FixMapFileNames Mtl
						Mtl.EnsureHaveParams Mtl.SPSName GIMS.CurrentGame.Core.DB QuickSearch TypeCast
						if NeedMultiMtl then
							Mtl = (MultiMaterial Material:#(Mtl) Names:#(Mtl.Name) ShowInViewport:true)
						Mtl
					)
					Standard: (
						local	NewMtl = (ConvertStruct Mtl EGIMS_MP3_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false),
								IsGeneratedDiffuse = false,
								DiffMap = (GetDiffuseWithOpacityAlpha Mtl IsGeneratedDiffuse:(&IsGeneratedDiffuse)),
								NormalMap,
								SpecularLevelMap = (if Mtl.SpecularLevelMapEnable then Mtl.SpecularLevelMap),
								DisplacementMap = (if Mtl.DisplacementMapEnable then Mtl.DisplacementMap),
								SpecMask,
								HaveSpecMap = (Have SpecularLevelMap),
								HaveSpecMask = (
									HaveSpecMap and
									(IsKindOf SpecularLevelMap RGB_Tint)
								),
								ReflectionMap = (if Mtl.ReflectionMapEnable then Mtl.ReflectionMap),
								SelfIllumination = Mtl.SelfIllumination,
								IsGlowing = (SelfIllumination > 0.0001),
								HaveNM = (
									local	BumpMap = Mtl.BumpMap
									(
										Mtl.BumpMapEnable and
										(IsKindOf BumpMap Normal_Bump) and
										(IsKindOf (NormalMap = BumpMap.Normal_Map) BitMapTexture)
									)
								),
								HaveSM = (
									if HaveSpecMask then (
										local	Map1 = SpecularLevelMap.Map1,
												Red = SpecularLevelMap.Red,
												Green = SpecularLevelMap.Green,
												Blue = SpecularLevelMap.Blue,
												SpecMask = (
													TypeCast (
														(
															[
																Red.R + Red.G + Red.B, \
																Green.R + Green.G + Green.B, \
																Blue.R + Blue.G + Blue.B \
															] / 3
														) / 255
													) #P4
												)
										(IsKindOf (SpecularLevelMap = Map1) BitMapTexture)
									) else (
										HaveSpecMap and
										(IsKindOf SpecularLevelMap BitMapTexture)
									)
								),
								HaveRM = (
									Have ReflectionMap and
									(IsKindOf ReflectionMap BitMapTexture)
								),
								HaveDM = (
									Have DisplacementMap and
									(IsKindOf DisplacementMap BitMapTexture)
								)
						NewMtl.SPSName = (
							if IsGlowing then (
								if HaveSM then (
									if
										HaveNM or
										HaveRM
									then
										"normal_spec_reflect_emissive"
									else
										"emissive_spec"
								) else
									"emissive"
							) else (
								if HaveDM then (
									if HaveSM then
										"parallax_specmap"
									else
										"parallax"
								) else (
									if HaveNM then (
										if HaveSM then (
											if HaveRM then
												"normal_spec_reflect"
											else
												"normal_spec"
										) else (
											if HaveRM then
												"normal_reflect"
											else
												"normal"
										)
									) else (
										if HaveSM then (
											if HaveRM then
												"spec_reflect"
											else
												"spec"
										) else (
											if HaveRM then
												"reflect"
											else
												"default"
										)
									)
								)
							)
						)
						
						if HaveDM then (
							NormalMap = (CopyBitmapAlpha DisplacementMap NormalMap)
							HaveNM = true
						)

						local	SetParam = NewMtl.SetParam

						if (IsKindOf DiffMap BitMapTexture) then (
							SetParam "DiffuseSampler" #sp_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureGrassSampler" #sp_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureSampler_layer0" #sp_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureSampler" #sp_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
						)
														
						if HaveNM then (
							SetParam "BumpSampler" #sp_sampler NormalMap IsTexInternal:false
							SetParam "BumpSampler_layer0" #sp_sampler NormalMap IsTexInternal:false
							SetParam "NormalSampler" #sp_sampler NormalMap IsTexInternal:false
						)
						if HaveSM then
							SetParam "SpecSampler" #sp_sampler SpecularLevelMap IsTexInternal:false
						if HaveRM then
							SetParam "EnvironmentSampler" #sp_sampler ReflectionMap IsTexInternal:false
								
						local	MtlDiffColor = Mtl.Diffuse,
								DiffuseColor = (TypeCast ([MtlDiffColor.R, MtlDiffColor.G, MtlDiffColor.B] / 25.5) #P4),
								Bumpiness = (TypeCast (Mtl.BumpMapAmount / 10) #P4),
								SpecMapAmount = (TypeCast (Mtl.SpecularLevelMapAmount / 100) #P4),
								SpecFactor = (TypeCast (Mtl.Glossiness * 5.12) #P4),
								RefPower = (TypeCast Mtl.ReflectionMapAmount #P4),
								Emissiveness = (TypeCast (SelfIllumination * 2.55) #P4)
						if HaveSpecMask then (
							SetParam "specMapIntMask" #sp_float3 SpecMask IsTexInternal:false
							SetParam "normSpecMapIntMask" #sp_float3 SpecMask IsTexInternal:false
						)
						
						SetParam "diffuseCol" #sp_float3 DiffuseColor IsTexInternal:false
						SetParam "SubColor" #sp_float3 DiffuseColor IsTexInternal:false
						SetParam "matDiffuseColor" #sp_float3 DiffuseColor IsTexInternal:false
						SetParam "waterColor" #sp_float3 DiffuseColor IsTexInternal:false
						
						SetParam "bumpiness" #sp_float Bumpiness IsTexInternal:false
						
						SetParam "specularColorFactor" #sp_float SpecMapAmount IsTexInternal:false
						
						SetParam "specularFactor" #sp_float SpecFactor IsTexInternal:false
						SetParam "normSpecularFactor" #sp_float SpecFactor IsTexInternal:false
						SetParam "goldSpecularFactor" #sp_float SpecFactor IsTexInternal:false
						
						SetParam "reflectivePower" #sp_float RefPower IsTexInternal:false
						SetParam "normReflectivePower" #sp_float RefPower IsTexInternal:false
						SetParam "goldReflectivePower" #sp_float RefPower IsTexInternal:false
						
						if IsGlowing then
							SetParam "emissiveMultiplier" #sp_float Emissiveness IsTexInternal:false
						
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
					BitMap:
						(GetStandartized (BitMapTexture BitMap:Mtl) DoOwnProgress:DoOwnProgress)
					BitMapTexture: (
						local	NewMtl = (EGIMS_MP3_material Name:(GetFileNameFile Mtl.FileName) ShowInViewport:true),
								SetParam = NewMtl.SetParam
						SetParam "DiffuseSampler" #sp_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureGrassSampler" #sp_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureSampler_layer0" #sp_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureSampler" #sp_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
					)
					Default: (
						local	NewMtl = (
									if No Mtl then
										(EGIMS_MP3_material ShowInViewport:true)
									else (
										local	MatDelegate = (try Mtl.Delegate catch())
										if
											Have MatDelegate and
											(IsKindOf MatDelegate Standard)
										then
											(GetStandartized MatDelegate NeedMultiMtl:false)
										else
											(ConvertStruct Mtl EGIMS_MP3_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false)
									)
								)
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory*/strMAXFactory (
		ObjectMgr = strObjectMgr(),
		MaterialOps = strMaterialOps()
	)
	GIMS.CurrentGame.Core.MAXFactory = strMAXFactory()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
