/*#PC*DEFINE	CurrentGame	V*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.ObjectMgr*/strObjectMgr (
		/*Shortcuts*/
			/*MAX*/
			IsFinite = Bit.IsFinite,
			DeleteFaces = MeshOp.DeleteFaces,
			RemoveIsolatedVerts = MeshOps.RemoveIsolatedVerts,
			RemoveDegenerateFaces = MeshOp.RemoveDegenerateFaces,
			RemoveIllegalFaces = MeshOp.RemoveIllegalFaces,
			WeldVertsByThreshold = MeshOp.WeldVertsByThreshold,
			DetachFaces = MeshOp.DetachFaces,
			/*Data*/
			SceneDirPattern = ((GetDir #Scene) + "*"),
			/*DB*/
			ObjectNames, GetShaderByName,
			/*Core*/
			Rules,
			/*GUI*/
			UpdateProgress, AddResult,
			/*Array*/
			PreallocatedInsertItem, Dispose, GetFirstUnusedIndex, Search, Split, Modify, RotateA, NormalizeA, QuickSearch, QuickSort, AppendSorted, AppendMHL, FetchMHL, RebuildMHL, OrderComparator,
			/*Misc*/
			GetJenkinsHash, AsBitArray, FixMaterialID, FormatText, CalculateVolumeAndCenterOfMass, AppendIfUniq, DumpMesh, StoreModData, RestoreModData, ReadCached, TypeCast, ConvertStruct, CreateIfUnique, CalculateBounds, ExtendBound, RemoveSmoothingGroups, GetPathString, CreateMesh, GetStandartized, ReplaceChars,
		/*Ops*/
		fn _CheckBones_UnifyIDs TheBones BoneIDs UsedBones RemappedBoneIDs ModelName UnifyDefaultID = (
			local	BoneID, NewID
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr._CheckBones_UnifyIDs"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for tBone in TheBones do (
					BoneID = (tBone.Id + 1)
					if UsedBones[BoneID] then (
						if
							UnifyDefaultID or
							(BoneID != 1)
						then (
							NewID = (GetFirstUnusedIndex BoneIDs)
							tBone.Id = (NewID - 1)
							BoneIDs[NewID] = true
							RemappedBoneIDs[NewID] = true
							AddResult #Warning (
								FormatText \
									v1:"Bone \"" \
									v2:tBone.ObjName \
									v3:"\" ID " \
									v4:(BoneID - 1) \
									v5:" was already used by other bone, and it will be changed to " \
									v6:(NewID - 1) \
									v7:".\nReferring Mirror bone IDs will be reset to default. Model name: \"" \
									v8:ModelName \
									v9:"\"" \
							)
							BoneID = NewID
						)
					)
					UsedBones[BoneID] = true
					_CheckBones_UnifyIDs tBone.Children BoneIDs UsedBones RemappedBoneIDs ModelName UnifyDefaultID
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BoneIDs, #ModelName, #UsedBones, #NewID, #BoneID), #(BoneIDs, ModelName, UsedBones, NewID, BoneID)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _CheckBones_CheckMirrorIDs TheBones BoneIDs RemappedBoneIDs ModelName = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr._CheckBones_CheckMirrorIDs"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for tBone in TheBones do (
					local	MirrorBoneId = (tBone.MirrorBoneId + 1),
							BoneID = (tBone.Id + 1),
							IsRemapped = RemappedBoneIDs[MirrorBoneId]
					if
						(BoneID != MirrorBoneId) and (
							IsRemapped or
							(not BoneIDs[MirrorBoneId])
						)
					then (
						tBone.MirrorBoneId = tBone.Id
						if not IsRemapped then (
							AddResult #Warning (
								FormatText \
									v1:"Can't find a mirror bone with ID " \
									v2:(MirrorBoneId - 1) \
									v3:" for a bone \"" \
									v4:tBone.ObjName \
									v5:"\" of model \"" \
									v6:ModelName \
									v7:"\". Setting to default..."
							)
						)
					)
					_CheckBones_CheckMirrorIDs tBone.Children BoneIDs RemappedBoneIDs ModelName
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BoneIDs, #ModelName), #(BoneIDs, ModelName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CheckBones TheBones BoneIDs ModelName UnifyDefaultID = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.CheckBones"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UsedBones = #{},
						RemappedBoneIDs = #{}
				UsedBones.Count = BoneIDs.NumberSet
				RemappedBoneIDs.Count = BoneIDs.NumberSet
				_CheckBones_UnifyIDs TheBones BoneIDs UsedBones RemappedBoneIDs ModelName UnifyDefaultID
				_CheckBones_CheckMirrorIDs TheBones BoneIDs RemappedBoneIDs ModelName
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BoneIDs, #ModelName), #(BoneIDs, ModelName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetMaterialLevelsAndSPSList MatList = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.GetMaterialLevelsAndSPSList"; local PWS = (*//*<PROFILERSTARTED>*/
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
		fn SPSToGIMSParamType ParamType = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.SPSToGIMSParamType"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case ParamType of (
					#svt_sampler:
						#String
					#svt_float:
						#Float
					#svt_float2:
						#P2
					#svt_float3:
						#P3
					#svt_float4:
						#P4
					#svt_matrix3x4:
						#P3Array
					#svt_matrix44:
						#P4Array
					#svt_float2x3:
						#P2Array
					#svt_float4x2:
						#P4Array
					#svt_float4x4:
						#P4Array
					#svt_float4x5:
						#P4Array
					#D3DDECLTYPE_FLOAT1:
						#Float
					#D3DDECLTYPE_FLOAT16_2:
						#P2
					#D3DDECLTYPE_FLOAT2:
						#P2
					#D3DDECLTYPE_FLOAT3:
						#P3
					#D3DDECLTYPE_FLOAT16_4:
						#P4
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
		fn _GetExcludedTextures_GetFromMtl Obj Mtl TexInfos PathString = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr._GetExcludedTextures_GetFromMtl"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	TexValues = Mtl.TexValues,
					TexParams = Mtl.TexParams,
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
							AppendMHL TexInfos TexParams[i] Hash:FileName Comparator:OrderComparator
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
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Mtl, #PathString), #(Mtl, PathString)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetExcludedTextures Obj TexInfos:#(#(), #()) = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.GetExcludedTextures"; local PWS = (*//*<PROFILERSTARTED>*/
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
							PathString = (_GetExcludedTextures_GetFromMtl Obj Mtl TexInfos PathString)
					)
				)
				for Child in Obj.Children where not Child.IsFrozen do
					GetExcludedTextures Child TexInfos:TexInfos
				TexInfos
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #TexInfos), #(Obj, TexInfos)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PrepareMeshForExport Mode Obj Mtl MatLevelsAndSPSList = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				--prepare and store modifiers
				local	Result = true,
						ModData = (StoreModData Obj CollapseToMesh:true)
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
					
				--mode - specific actions
				case Mode of (
					#Col: (
					
						--prepare col mesh
						--WeldVertsByThreshold Obj #All 0.0001
						--RemoveSmoothingGroups Obj
						
						--remove the mesh garbage
						RemoveDegenerateFaces Obj
						RemoveIllegalFaces Obj
						RemoveIsolatedVerts Obj
					)
					#Model: (
					
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
					)
					default:
						throw "Unknown Mode: " Mode
				)
				
				--restore modifiers
				RestoreModData Obj ModData
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetCNodeProgressEntryCount CNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.GetCNodeProgressEntryCount"; local PWS = (*//*<PROFILERSTARTED>*/
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
							EGIMS_V_CollisionMesh:
								4
							EGIMS_V_CollisionDict:
								(GetCNodeProgressEntryCount CNodeChild)
							EGIMS_V_Col_Composite:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_V_ModelMesh:
								4
							EGIMS_V_Model_BoneMod:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_V_Model_Bone:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_V_Model:
								3 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_V_Model_ModelMod:
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
		fn MakeColMatsWritableAndGetColors Materials MaterialCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.MakeColMatsWritableAndGetColors"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	HaveColorFlag = false,
						MaterialColors = unsupplied
				for Mtl in Materials while not HaveColorFlag do
					HaveColorFlag = (Mtl.CollisionData[2][3] != 0)	
				if HaveColorFlag then (
					MaterialColors = #()
					for i = MaterialCount to 1 by -1 do (
						local	Mtl = Materials[i],
								CollisionData = Mtl.CollisionData,
								CollisionData2 = CollisionData[2],
								CollisionData3 = CollisionData[3],
								Clr = (TypeCast Mtl.CollisionData[1] Color)
						Clr.a = CollisionData2[1]
						MaterialColors[i] = Clr
						Materials[i] = #(
							CollisionData2[2],	--Mat_Index,
							CollisionData3[1],	--Flags,
							i,	--MaterialColorIndex,
							CollisionData3[2],	--ProcId,
							CollisionData3[3],	--RoomId
							CollisionData[4][1]
						)
					)
				) else (
					for i = MaterialCount to 1 by -1 do (
						local	Mtl = Materials[i],
								CollisionData = Mtl.CollisionData,
								CollisionData3 = CollisionData[3]
						Materials[i] = #(
							CollisionData[2][2],	--Mat_Index,
							CollisionData3[1],	--PolyFlags,
							0,	--MaterialColorIndex,
							CollisionData3[2],	--ProcId,
							CollisionData3[3],	--RoomId
							CollisionData[4][1]
						)
					)
				)
				MaterialColors
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Materials, #MaterialCount), #(Materials, MaterialCount)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn MergeVert Verts Pos VertexColors SuppliedVertexColors = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.MergeVert"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*actual merging, but very slow because Search_Compare_MaxDiff forces loop search*
				local	AddData = (AppendIfUniq Verts Pos GetID:true Search_Compare_MaxDiff:0.01 GetFlagWithID:true Comparator:OrderComparator)
				if
					SuppliedVertexColors and
					AddData[1]
				then
					Append VertexColors [1, 1, 1, 1]
				AddData[2]
				/**/
				/*just append*/
				Append Verts Pos
				if SuppliedVertexColors then
					Append VertexColors [1, 1, 1, 1]
				Verts.Count
				/**/
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetSimpleObjMaterial Obj ParamSource = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.GetSimpleObjMaterial"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjMtl = Obj.Material
				(
					if (IsKindOf ObjMtl MultiMaterial) then (
						local	MatCount = ObjMtl.Count,
								MtlID = ParamSource.MtlID,
								MatIDBA = ((ObjMtl.MaterialIDList as Array) as BitArray)
						if not MatIDBA[MtlID] then
							MtlID = (FixMaterialID MtlID MatIDBA.Count)
						(GetStandartized ObjMtl.MaterialList[MtlID] NeedMultiMtl:false)
					) else
						(GetStandartized ObjMtl NeedMultiMtl:false)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalcBoneIndices CNode BoneIDs BoneCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.CalcBoneIndices"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParamSource = CNode.ParamSource,
						Children = CNode.Children,
						ObjClass = (ClassOf ParamSource)
				if 
					(ObjClass == EGIMS_V_Model_BoneMod) or
					(ObjClass == EGIMS_V_Model_Bone)
				then (
					BoneCount += 1
					BoneIDs[ParamSource.ID + 1] = true
					ParamSource.Index = BoneCount
				)
				for Child in Children do
					BoneCount = (CalcBoneIndices Child BoneIDs BoneCount)
				BoneCount
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StoreDrawableCollision ParentParamSource ModelResult ColResult = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.CalcBoneIndices"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if (
					(IsKindOf ParentParamSource EGIMS_V_Model) or
					(IsKindOf ParentParamSource EGIMS_V_Model_ModelMod) or
					(IsKindOf ParentParamSource EGIMS_V_Model_Bone) or
					(IsKindOf ParentParamSource EGIMS_V_Model_BoneMod) or
					(IsKindOf ParentParamSource EGIMS_V_ModelMesh)
				) then (
					ModelResult.Bound = ColResult
					/*
					local	Bound = ModelResult.Bound
					if No Bound then
						ModelResult.Bound = #(ColResult)
					else
						Append Bound ColResult
					*/
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromScene \
			CNode \
			ObjClass:unsupplied \
			DiskPath:undefined \
			Ancestor:undefined \
			AncestorNode:undefined \
			CoordsysTM:undefined \
			Parent:undefined \
			ParentParamSource:undefined \
			ParentResult:undefined \
			AllowProgress:true \
			Materials:unsupplied \
			RestrictedTypes:undefined \
			AllowedTypes:undefined \
			ProgressData:undefined = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				at Time 0 (
					local	Obj = CNode.Obj,
							ParamSource = CNode.ParamSource,
							Children = CNode.Children,
							Result,
							SetOwnProgress = (No ProgressData),
							Allowed = true
					if not Supplied ObjClass then
						ObjClass = (ClassOf ParamSource)
					if Have AllowedTypes then
						Allowed = ((FindItem AllowedTypes ObjClass) != 0)
					if
						(Have RestrictedTypes) and
						Allowed
					then
						Allowed = ((FindItem RestrictedTypes ObjClass) == 0)
					if Allowed then (
					case ObjClass of (
					
						--generic
					
						Editable_Mesh: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+Editable_Mesh"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							local	ParentParamSourceClass = (ClassOf ParentParamSource),
									ParamSourceClass = (
										case ParentParamSourceClass of (
											EGIMS_V_CollisionDict:
												EGIMS_V_CollisionMesh
											EGIMS_V_Col_Composite:
												EGIMS_V_CollisionMesh
											EGIMS_V_ModelDict:
												EGIMS_V_ModelMesh
											EGIMS_V_Model:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_ModelMod:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_Bone:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_BoneMod:
												EGIMS_V_ModelMesh
											/*TODO mesh-in-mesh
											EGIMS_V_ModelMesh:
												EGIMS_V_ModelMesh
											EGIMS_V_CollisionMesh:
												EGIMS_V_CollisionMesh
											*/
											default:
												throw "Unknown editable mesh parent type: " ParentParamSourceClass
										)
									)
							ParamSource = (ParamSourceClass())
							CNode.ParamSource = ParamSource
							Result = (
								StructFromScene \
									(GIMS.Core.TypeLibrary.CollectionNode Obj:Obj ParamSource:ParamSource Children:Children) \
									ObjClass:ParamSourceClass \
									DiskPath:DiskPath \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Parent \
									ParentParamSource:ParentParamSource \
									ParentResult:ParentResult \
									AllowProgress:AllowProgress \
									ProgressData:ProgressData \
									Materials:Materials \
									RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
							)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						Editable_Poly: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+Editable_Poly"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							local	ParentParamSourceClass = (ClassOf ParentParamSource),
									ParamSourceClass = (
										case ParentParamSourceClass of (
											EGIMS_V_CollisionDict:
												EGIMS_V_CollisionMesh
											EGIMS_V_Col_Composite:
												EGIMS_V_CollisionMesh
											EGIMS_V_ModelDict:
												EGIMS_V_ModelMesh
											EGIMS_V_Model:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_ModelMod:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_Bone:
												EGIMS_V_ModelMesh
											EGIMS_V_Model_BoneMod:
												EGIMS_V_ModelMesh
											/*TODO mesh-in-mesh
											EGIMS_V_ModelMesh:
												EGIMS_V_ModelMesh
											EGIMS_V_CollisionMesh:
												EGIMS_V_CollisionMesh
											*/
											default:
												throw "Unknown editable poly parent type: " ParentParamSourceClass
										)
									)
							ParamSource = (ParamSourceClass())
							CNode.ParamSource = ParamSource
							Result = (
								StructFromScene \
									(GIMS.Core.TypeLibrary.CollectionNode Obj:Obj ParamSource:ParamSource Children:Children) \
									ObjClass:ParamSourceClass \
									DiskPath:DiskPath \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Parent \
									ParentParamSource:ParentParamSource \
									ParentResult:ParentResult \
									AllowProgress:AllowProgress \
									ProgressData:ProgressData \
									RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
									Materials:Materials
							)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
					
						--collisions
					
						EGIMS_V_CollisionDict: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_CollisionDict"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then (
									ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None 0
							local	Items = #(),
									ItemCount = 0,
									ObjName = (ReplaceChars Obj.Name),
									Item
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Items.Count = Children.Count
							for Child in Children do (
								Item = (
									StructFromScene \
										Child \
										DiskPath:DiskPath \
										Parent:Obj \
										AncestorNode:Obj \
										ParentParamSource:ParamSource \
										ProgressData:ProgressData \
										RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
										AllowProgress:AllowProgress
								)
								if Have Item then (
									ItemCount += 1
									Items[ItemCount] = Item
								)
							)
							Items.Count = ItemCount
							if ItemCount == 0 then (
								AddResult #Error (
									FormatText \
										v1:"Collision dictionary \"" \
										v2:(GetPathString Obj) \
										v3:"\" is empty. Skipping..."
								)
							) else (
								Result = (
									GIMS.CurrentGame.Core.TypeLibrary.grcPhBoundDictionary \
									DiskPath:DiskPath \
									ObjName:ObjName \
									Items:Items
								)
							)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Composite: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Composite"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then (
									ProgressData = [0, 0, 1 + (GetCNodeProgressEntryCount CNode)]
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
							) else
								UpdateProgress #None 0
							local	ObjName = (ReplaceChars Obj.Name),
									ChildCount = Children.Count
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:#BoundComposite
							)
							local	Bounds = Result.Bounds,
									AABB = Bounds.AABB,
									CG = [0, 0, 0],
									Items = #(),
									ItemCount = 0,
									HaveChildFlags = (ParamSource.UseChildFlags),
									ChildTransforms = #(),
									ChildFlags = unsupplied,
									InvTrans = (Inverse Obj.Transform)
							if ChildCount > 0 then (
								Items.Count = ChildCount
								ChildTransforms.Count = ChildCount
								if HaveChildFlags then (
									ChildFlags = #()
									ChildFlags.Count = ChildCount
								)
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
								for Child in Children do (
									local	Item = (
												StructFromScene \
													Child \
													DiskPath:DiskPath \
													Ancestor:Result \
													AncestorNode:Obj \
													Parent:Obj \
													ParentParamSource:ParamSource \
													ProgressData:ProgressData \
													AllowProgress:AllowProgress \
													RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
													ParentResult:Result
											)
									if Have Item then (
										ItemCount += 1
										local	ItemBounds = Item.Bounds,
												ItemAABB = ItemBounds.AABB,
												ItemParamSource = Child.ParamSource,
												TempTrans = (Child.Obj.Transform * InvTrans)
										ExtendBound AABB (ItemAABB.bMin * TempTrans)
										ExtendBound AABB (ItemAABB.bMax * TempTrans)
										CG += (ItemBounds.CenterOfMass * TempTrans)
										local	ItemParamSourceType = (TryGetProperty ItemParamSource #Type)
										if ItemParamSourceType == 1 then
											ChildTransforms[ItemCount] = (Matrix3 1)
										else
											ChildTransforms[ItemCount] = TempTrans
										if HaveChildFlags then (
											ChildFlags[ItemCount] = #(
												ItemParamSource.Flags1,
												ItemParamSource.Flags2
											)
										)
										Items[ItemCount] = Item
									)
								)
								Items.Count = ItemCount
								ChildTransforms.Count = ItemCount
								if HaveChildFlags then
									ChildFlags.Count = ItemCount
							)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None 0
							if ItemCount == 0 then (
								AABB.bMin = CG
								AABB.bMax = CG
								Bounds.CenterOfMass = CG
							) else
								Bounds.CenterOfMass = (CG / ItemCount)
							Bounds.CalculateCentroid()
							Bounds.CalculateRadius()
							Result.Children = Items
							Result.ChildTransforms = ChildTransforms
							Result.ChildFlags = ChildFlags
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Plane: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Plane"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:#BoundPlane \
							)
							local	Bounds = Result.Bounds,
									AABB = Bounds.AABB,
									CoordsysTM = (
										if Have AncestorNode then
											(Inverse AncestorNode.Transform)
										else
											(Matrix3 1)
									)
							AABB.bMin = [0, 0, 0]
							AABB.bMax = [0, 0, 0]
							Bounds.CenterOfMass = Obj.Dir
							Bounds.Centroid = (Obj.Pos * CoordsysTM)
							Bounds.Radius = 0.0
							Result.Margin = 0.04
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Disc: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Disc"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundDisc" \
							)
							local	Radius = ParamSource.Radius,
									HalfHeight = (ParamSource.Height / 2),
									Bounds = Result.Bounds,
									AABB = Bounds.AABB
							AABB.bMin = [HalfHeight, Radius, Radius]
							AABB.bMax = [-HalfHeight, -Radius, -Radius]
							Bounds.Radius = Radius
							Bounds.Centroid = [0, 0, 0]
							Bounds.CenterOfMass = [0, 0, 0]
							Result.Margin = HalfHeight
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Cylinder: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Cylinder"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundCylinder" \
							)
							local	Radius = ParamSource.Radius,
									HalfHeight = (ParamSource.Height / 2),
									Bounds = Result.Bounds,
									AABB = Bounds.AABB
							AABB.bMin = [Radius, HalfHeight, Radius]
							AABB.bMax = [-Radius, -HalfHeight, -Radius]
							Bounds.CalculateWorldRadius()
							Bounds.Centroid = [0, 0, 0]
							Bounds.CenterOfMass = [0, 0, 0]
							Result.Margin = 0.04
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Box: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Box"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundBox" \
							)
							local	HalfWidth = (ParamSource.Width / 2),
									HalfDepth = (ParamSource.Depth / 2),
									HalfHeight = (ParamSource.Height / 2),
									Bounds = Result.Bounds
							if (IsKindOf ParentParamSource EGIMS_V_Col_Composite) then (
								local	AABB = Bounds.AABB
								AABB.bMin = [HalfWidth, HalfDepth, HalfHeight]
								AABB.bMax = [-HalfWidth, -HalfDepth, -HalfHeight]
								Bounds.CalculateRadius()
								Bounds.Centroid = [0, 0, 0]
								Bounds.CenterOfMass = [0, 0, 0]
							) else (
								local	CoordsysTM = (
											if Have AncestorNode then
												(Inverse AncestorNode.Transform)
											else
												(Matrix3 1)
										),
										ObjBounds = (CalculateBounds Obj CoordsysTM:CoordsysTM),
										Centroid = ObjBounds[2]
								Bounds.AABB = ObjBounds[1]
								Bounds.Centroid = Centroid
								Bounds.CenterOfMass = Centroid
								Bounds.Radius = ObjBounds[3]
							)
							if
								HalfWidth < 0.1 or
								HalfDepth < 0.1 or
								HalfHeight < 0.1
							then (
								if HalfWidth < HalfDepth then (
									if HalfWidth < HalfHeight then
										Result.Margin = (HalfWidth / 4)
									else
										Result.Margin = (HalfHeight / 4)
								) else (
									if HalfDepth < HalfHeight then
										Result.Margin = (HalfDepth / 4)
									else
										Result.Margin = (HalfHeight / 4)
								)
							) else
								Result.Margin = 0.04
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Sphere: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Sphere"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundSphere" \
							)
							local	Bounds = Result.Bounds,
									Radius = ParamSource.Radius
							Bounds.AABB.bMax = [Radius, Radius, Radius]
							Bounds.AABB.bMin = [-Radius, -Radius, -Radius]
							Bounds.Radius = Radius
							Bounds.Centroid = [0, 0, 0]
							Bounds.CenterOfMass = [0, 0, 0]
							Result.Margin = Radius
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_Capsule: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_Capsule"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundCapsule" \
							)
							local	Radius = ParamSource.Radius,
									HalfHeight = (ParamSource.Height / 2),
									Bounds = Result.Bounds,
									AABB = Bounds.AABB
							AABB.bMin = [Radius, HalfHeight, Radius]
							AABB.bMax = [-Radius, -HalfHeight, -Radius]
							Bounds.Radius = (HalfHeight + Radius)
							Bounds.Centroid = [0, 0, 0]
							Bounds.CenterOfMass = [0, 0, 0]
							Result.Margin = Radius
							Result.CapsuleHalfHeight = 0.0
							Materials = #(GetSimpleObjMaterial Obj ParamSource)
							Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials 1)
							Result.Materials = Materials
							StoreDrawableCollision ParentParamSource Ancestor Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_PrimBox: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_PrimBox"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	ObjCoordsysTM = (Obj.Transform * CoordsysTM),
									ObjMeshVerts = Obj.Mesh.Verts,
									VertPositions = #(
										(ObjMeshVerts[2].Pos * ObjCoordsysTM),	--2 or 6
										(ObjMeshVerts[8].Pos * ObjCoordsysTM),	--8 or 4
										(ObjMeshVerts[5].Pos * ObjCoordsysTM),	--5 or 1
										(ObjMeshVerts[3].Pos * ObjCoordsysTM)	--3 or 7
									)
							Result = #(#Box, undefined, (GetSimpleObjMaterial Obj ParamSource), VertPositions)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_PrimSphere: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_PrimSphere"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							Result = #(#Sphere, undefined, (GetSimpleObjMaterial Obj ParamSource), (Obj.Pos * CoordsysTM), ParamSource.Radius)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_PrimCapsule: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_PrimCapsule"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	HalfHeight = (ParamSource.Height / 2),
									ObjCoordsysTM = (Obj.Transform * CoordsysTM),
									TopPos = ([0, 0, HalfHeight] * ObjCoordsysTM),
									BottomPos = ([0, 0, -HalfHeight] * ObjCoordsysTM)
							Result = #(#Capsule, undefined, (GetSimpleObjMaterial Obj ParamSource), TopPos, BottomPos, ParamSource.Radius)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Col_PrimCylinder: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Col_PrimCylinder"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then
									UpdateProgress #Progress [1, 0, 1]
								else (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
							) else
								UpdateProgress #None undefined
							local	HalfHeight = (ParamSource.Height / 2),
									ObjCoordsysTM = (Obj.Transform * CoordsysTM),
									TopPos = ([0, 0, HalfHeight] * ObjCoordsysTM),
									BottomPos = ([0, 0, -HalfHeight] * ObjCoordsysTM)
							Result = #(#Cylinder, undefined, (GetSimpleObjMaterial Obj ParamSource), TopPos, BottomPos, ParamSource.Radius)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_CollisionMesh: (
							local	ObjMtl
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_CollisionMesh"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
							if AllowProgress then (
								if SetOwnProgress then (
									ProgressData = [0, 0, 4]
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
							) else
								UpdateProgress #None undefined
							local	ObjName = (ReplaceChars Obj.Name)
							AppendMHL ObjectNames ObjName Comparator:OrderComparator
							ObjMtl = (GetStandartized Obj.Material)
							Obj.Material = ObjMtl
							if (PrepareMeshForExport #Col Obj ObjMtl unsupplied) then (
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
								local	IsBVH = (ParamSource.Type == 1),
										CoordsysTM = (
											if Have AncestorNode then (
												if IsBVH then
													AncestorNode.Transform
												else
													Obj.Transform
											) else
												(Matrix3 1)
										),
										InvCoordsysTM = (Inverse CoordsysTM),
										VertexOffset = (Obj.Center * InvCoordsysTM),
										Verts = #(),
										Faces = #(),
										FGetMapSupport = (
											if (IsKindOf Obj Editable_Poly) then
												PolyOp.GetMapSupport
											else
												MeshOp.GetMapSupport
										),
										SuppliedVertexColors = true,
										ObjMesh = Obj.Mesh,
										VertexColors = (
											if
												(FGetMapSupport ObjMesh 0) or
												(FGetMapSupport ObjMesh -2)
											then
												#()
											else (
												SuppliedVertexColors = false
												unsupplied
											)
										),
										Siblings = (if ParamSource.CollectMAXSiblings then #() else unsupplied),
										FaceMatIDs = #(),
										InvOffsetCoordsysTM = (Inverse ((TransMatrix VertexOffset) * CoordsysTM)),
										ColMaterialPropMapping = Rules.ColMaterialPropMapping,
										MatPropMapping = #(ColMaterialPropMapping, ColMaterialPropMapping)
								Materials = #()
								if (
									DumpMesh \
										Obj \
										Verts \
										Faces \
										Colors:VertexColors \
										Siblings:Siblings \
										FaceMatIDs:FaceMatIDs \
										Materials:Materials \
										CoordsysTM:InvOffsetCoordsysTM \
										MatPropMapping:ColMaterialPropMapping
								) then (
									/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
									/*<ERRHANDLERSTART>*/try (
									local	FacesCount = Faces.Count,
											VertCount = Verts.Count
									if SuppliedVertexColors then (
										local	VCVerts = VertexColors[2]
										if FacesCount == 0 then
											VertexColors = VCVerts
										else (
											local	VCFaces = VertexColors[1]
											VertexColors = #()
											VertexColors.Count = VertCount
											for i = 1 to FacesCount do (
												local	VCFace = VCFaces[i],
														PhysFace = Faces[i]
												for j = 3 to 1 by -1 do
													VertexColors[PhysFace[j]] = VCVerts[VCFace[j]]
											)
											for i = 1 to VertCount where No VertexColors[i] do
												VertexColors[i] = VCVerts[i]
										)
									)
									if AllowProgress then (
										ProgressData.x += 1
										UpdateProgress #Progress ProgressData
									) else
										UpdateProgress #None undefined
									local	Prims = #(),
											ChildrenCount = Children.Count,
											CMCount = (
												if FacesCount != 0 then
													(ChildrenCount + 1)
												else (
													if ChildrenCount != 0 then
														ChildrenCount
													else
														1
												)
											),
											BoundCM = [0, 0, 0],
											ObjBounds = (CalculateBounds Obj CoordsysTM:InvCoordsysTM),
											AABB = ObjBounds[1]
									for ChildID = ChildrenCount to 1 by -1 do (
										local	Child = Children[ChildID],
												Prim = (
													StructFromScene \
														Child \
														DiskPath:DiskPath \
														Ancestor:Ancestor \
														AncestorNode:AncestorNode \
														CoordsysTM:InvOffsetCoordsysTM \
														ParentParamSource:ParamSource \
														ProgressData:ProgressData \
														RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
														AllowProgress:AllowProgress
												)
										Prim[3] = (AppendIfUniq Materials Prim[3] GetID:true PropMapping:MatPropMapping Comparator:OrderComparator)
										local	PrimName = Prim[1]
										case PrimName of (
											#Sphere:
												Prim[4] = (MergeVert Verts Prim[4] VertexColors SuppliedVertexColors)
											#Capsule: (
												Prim[4] = (MergeVert Verts Prim[4] VertexColors SuppliedVertexColors)
												Prim[5] = (MergeVert Verts Prim[5] VertexColors SuppliedVertexColors)
											)
											#Box: (															
												local	PrimVerts = Prim[4]
												PrimVerts[1] = (MergeVert Verts PrimVerts[1] VertexColors SuppliedVertexColors)
												PrimVerts[2] = (MergeVert Verts PrimVerts[2] VertexColors SuppliedVertexColors)
												PrimVerts[3] = (MergeVert Verts PrimVerts[3] VertexColors SuppliedVertexColors)
												PrimVerts[4] = (MergeVert Verts PrimVerts[4] VertexColors SuppliedVertexColors)
											)
											#Cylinder: (
												Prim[4] = (MergeVert Verts Prim[4] VertexColors SuppliedVertexColors)
												Prim[5] = (MergeVert Verts Prim[5] VertexColors SuppliedVertexColors)
											)
											default:
												throw "Unknown Primitive type " PrimName
										)
										local	ChildObj = Child.Obj
										ExtendBound AABB (ChildObj.Min * InvCoordsysTM)
										ExtendBound AABB (ChildObj.Max * InvCoordsysTM)
										BoundCM += ((CalculateVolumeAndCenterOfMass ChildObj CoordsysTM:InvCoordsysTM CMOnly:true) / CMCount)
										Prims[ChildID] = Prim
									)
									if AllowProgress then (
										ProgressData.x += 1
										UpdateProgress #Progress ProgressData
									) else
										UpdateProgress #None undefined
									VertCount = Verts.Count
									if VertCount == 0 then (
										AddResult #Error (
											FormatText \
												v1:"The collision mesh \"" \
												v2:(GetPathString Obj) \
												v3:"\" hasn't got a mesh. Skipping..."
										)
									) else (
										local	VertCountLimit = Rules.ColVertBufferSize
										if VertCount > VertCountLimit then (
											AddResult #Error (
												FormatText \
													v1:"Maximum vertex count of " \
													v2:VertCountLimit \
													v3:" exceeded in the collision object \"" \
													v4:(GetPathString Obj) \
													v5:"\".\nThat mesh will be skipped. You should split it to multiple pieces before export."
											)
										) else (
											local	PolyCountLimit = Rules.ColPolyBufferSize
											if Faces.Count > PolyCountLimit then (
												AddResult #Error (
													FormatText \
														v1:"Maximum face count of " \
														v2:PolyCountLimit \
														v3:" exceeded in the collision object \"" \
														v4:(GetPathString Obj) \
														v5:"\".\nThat mesh will be skipped. You should split it to multiple pieces before export."
												)
											) else (
												local	ColMaterialBufferSize = Rules.ColMaterialBufferSize,
														MaterialCount = Materials.Count
												if MaterialCount > ColMaterialBufferSize then (
													AddResult #Error (
														FormatText \
															v1:"Maximum material count of " \
															v2:ColMaterialBufferSize \
															v3:" exceeded in the collision object \"" \
															v4:(GetPathString Obj) \
															v5:"\".\nThat mesh will be skipped. You should split it to into multiple pieces by materials before export."
													)
												) else (
													Result = (
														GIMS.CurrentGame.Core.TypeLibrary.grcPhBound \
														DiskPath:DiskPath \
														ObjName:ObjName \
														Type:(
															if IsBVH then
																#BoundBVH
															else
																#BoundGeometry
														) \
														Margin:(
															if IsBVH then
																0.005
															else
																0.04
														) \
														Vertices:Verts \
														Faces:Faces \
														FaceMatIDs:FaceMatIDs \
														Siblings:Siblings \
														Shrunk:(
															if IsBVH then
																unsupplied
															else
																Verts	--TODO	generate Shrunk
														) \
														VertexColors:(
															if SuppliedVertexColors then
																VertexColors
															else
																unsupplied
														) \
														Primitives:Prims \
														VertexOffset_UnkPart:ParamSource.VertexOffset_UnkPart \
														VertexOffset:VertexOffset \
													)
													local	Bounds = Result.Bounds
													Bounds.AABB = AABB
													Bounds.CalculateCentroid()
													Bounds.CalculateRadius()
													Bounds.CenterOfMass = (BoundCM + ((CalculateVolumeAndCenterOfMass Obj CoordsysTM:InvCoordsysTM CMOnly:true) / CMCount))
													Result.MaterialColors = (MakeColMatsWritableAndGetColors Materials MaterialCount)
													Result.Materials = Materials
													
													/*TODO mesh-in-mesh*
													for Child in Children do (
														StructFromScene \
															Child \
															DiskPath:DiskPath \
															Ancestor:Ancestor \
															AncestorNode:AncestorNode \
															CoordsysTM:CoordsysTM \
															Parent:Parent \
															ParentParamSource:ParentParamSource \
															ParentResult:ParentResult \
															AllowProgress:AllowProgress \
															Materials:Materials \
															RestrictedTypes:RestrictedTypes \
															AllowedTypes:AllowedTypes \
															ProgressData:ProgressData \
													)
													/**/
													
													StoreDrawableCollision ParentParamSource Ancestor Result
												)
											)
										)
									)
									if AllowProgress then (
										ProgressData.x += 1
										UpdateProgress #Progress ProgressData
									) else
										UpdateProgress #None undefined
									/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
									/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
								) else (
									if AllowProgress then (
										ProgressData.x += 3
										UpdateProgress #Progress ProgressData
									)
								)
							) else (
								if AllowProgress then (
									ProgressData.x += 4
									UpdateProgress #Progress ProgressData
								)
							)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass, #ObjMtl), #(Obj, ParamSource, SetOwnProgress, ObjClass, (if Have ObjMtl then (try ObjMtl.MaterialList catch (ClassOf ObjMtl)) else undefined))))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
					
						--models
						
						EGIMS_V_ModelDict: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_ModelDict"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								if AllowProgress then (
									if SetOwnProgress then (
										ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
										UpdateProgress #Progress ProgressData
									)
								) else
									UpdateProgress #None undefined
								local	Items = #(),
										ItemCount = 0,
										ObjName = (ReplaceChars Obj.Name),
										Item
								Items.Count = Children.Count
								for Child in Children do (
									Item = (
										StructFromScene \
											Child \
											DiskPath:DiskPath \
											Parent:Obj \
											ParentParamSource:ParamSource \
											ProgressData:ProgressData \
											RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
											AllowProgress:AllowProgress
									)
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
										ObjName:ObjName \
										Items:Items
									)
								)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Model_ModelMod: (
							Result = (
								StructFromScene \
									CNode \
									ObjClass:EGIMS_V_Model \
									DiskPath:DiskPath \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Parent \
									ParentParamSource:ParentParamSource \
									ParentResult:ParentResult \
									Materials:Materials \
									RestrictedTypes:RestrictedTypes \
									AllowedTypes:AllowedTypes \
									AllowProgress:AllowProgress \
									ProgressData:ProgressData
							)
						)
						EGIMS_V_Model: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Model"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								if AllowProgress then (
									if SetOwnProgress then (
										ProgressData = [0, 0, 3 + (GetCNodeProgressEntryCount CNode)]
										UpdateProgress #Progress ProgressData
									) else
										UpdateProgress #None 0
								) else
									UpdateProgress #None 0
								local	ObjName = (ReplaceChars Obj.Name)
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
										
								--precalculate bone indices before meshes collection(used in DumpMesh fn skinning) and get bone count
								local	BoneCount = 0,
										BoneIDs = #{}
								BoneIDs.Count = 100
								for Child in Children do
									BoneCount = (CalcBoneIndices Child BoneIDs BoneCount)
								BoneIDs.Count = BoneIDs.NumberSet

								--collect children
								local	SubDiskPath = (
											FormatText \
												v1:DiskPath \
												v2:ObjName \
												v3:"\\" \
										)
								Materials = #()
								for Child in Children do (
									StructFromScene \
										Child \
										DiskPath:SubDiskPath \
										Ancestor:Result \
										ParentResult:Result \
										AncestorNode:Obj \
										Parent:Obj \
										ParentParamSource:ParamSource \
										ProgressData:ProgressData \
										Materials:Materials \
										AllowProgress:AllowProgress \
										AllowedTypes:AllowedTypes \
										RestrictedTypes:RestrictedTypes \
								)
								
								--store values
								local	LightAttributes = Result.LightAttributes,
										HaveLightAttributes = (Have LightAttributes)
								local	ShadingGroup = Result.ShadingGroup
								if Have ShadingGroup then
									ShadingGroup.Mtls = Materials
								local	TheSkeleton = Result.TheSkeleton,
										TheBones = #NoTheBones,
										BoneIndexMod = 0,
										RootBone = undefined,
										HaveSkeleton = false
								if Have TheSkeleton then (
									TheBones = TheSkeleton.TheBones
									CheckBones TheBones BoneIDs ObjName HaveLightAttributes
									if TheBones.Count > 1 then (
										AddResult #Warning (
											FormatText \
												v1:"Model \"" \
												v2:(GetPathString Obj) \
												v3:"\" has got more than one root bone.\nAll of them will be grouped into a new one with default parameters and unique ID.\nIf you want to tweak these parameters, consider creating the root bone by yourself, and attaching your model bones to it."
										)
										RootBone = (
											GIMS.CurrentGame.Core.TypeLibrary.grcBone \
												ObjName:"FakeRoot" \
												ID:((GetFirstUnusedIndex BoneIDs) - 1) \
												MirrorBoneID:0 \
												RotationQuaternion:((EulerAngles 0 0 0) as Quat) \
												LocalOffset:[0, 0, 0] \
												TheScale:[1, 1, 1] \
												Children:TheBones \
												Index:0 \
										)
										TheSkeleton.TheBones = (TheBones = #(RootBone))
										BoneIndexMod = 1
										BoneCount += BoneIndexMod
									)
									if ParamSource.UseBones then
										HaveSkeleton = true
									else
										Result.TheSkeleton = undefined
								) else
									Result.TheSkeleton = undefined
								local	LodGroup = Result.LodGroup
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
								if HaveSkeleton then (
									local	SkeletonMaxBoneCount = Rules.SkeletonMaxBoneCount
									if BoneCount > SkeletonMaxBoneCount then (
										AddResult #Error (
											FormatText \
												v1:"Model \"" \
												v2:(GetPathString Obj) \
												v3:"\" has got " \
												v4:BoneCount \
												v5:" bones, when the maximum's " \
												v6:SkeletonMaxBoneCount \
												v7:". Skipping..."
										)
										Result = undefined
									) else (
										TheSkeleton.NumBones = BoneCount
										TheSkeleton.DataCRC = (
											if ParamSource.CalcDataCRC then
												-2
											else
												ParamSource.DataCRC
										)
									)
								)
								
								if Have Result then (
								
									--set light bone IDs from bones in there
									if HaveLightAttributes then (
										if Have RootBone then (
											for tLight in LightAttributes.Items do (
												local	BoneTag = tLight.BoneTag
												tLight.BoneTag = (
													if BoneTag == -1 then
														RootBone.ID
													else
														BoneTag.ID
												)
											)
										) else (
											for tLight in LightAttributes.Items do (
												local	BoneTag = tLight.BoneTag
												tLight.BoneTag = (
													if BoneTag == -1 then
														0
													else
														BoneTag.ID
												)
											)
										)
									)
									
									--set joint bone IDs from bones in there
									local	Joints = Result.Joints
									if Have Joints then (
										for tJoint in Joints.RotationLimits do
											tJoint.BoneID = tJoint.BoneID.ID
										for tJoint in Joints.TranslationLimits do
											tJoint.BoneID = tJoint.BoneID.ID
										for tJoint in Joints.ScaleLimits do
											tJoint.BoneID = tJoint.BoneID.ID
									)

									--set mesh bone IDs from bones in there
									LodGroup.LODGroupValues = ParamSource.LODGroupValues
									if BoneIndexMod == 0 then (
										for LODGroup in LodGroup.LODGroups do (
											for LODMesh in LODGroup do (
												local	MeshBoneID = LODMesh.BoneID
												if LODMesh.Skinned then
													LODMesh.BoneCount = BoneCount
												LODMesh.BoneID = (
													if No MeshBoneID then
														1
													else
														MeshBoneID.Index
												)
											)
										)
									) else (
										for LODGroup in LodGroup.LODGroups do (
											for LODMesh in LODGroup do (
												local	MeshBoneID = LODMesh.BoneID
												LODMesh.BoneID = (
													if No MeshBoneID then
														1
													else
														(MeshBoneID.Index + BoneIndexMod)
												)
												if LODMesh.Skinned then (
													LODMesh.BoneCount = BoneCount
													for Geom in LODMesh.Geometries do (
														local	SkinBones = Geom.SkinBones
														if Supplied SkinBones then (
															for VertBoneIDs in SkinBones do (
																for i = 1 to VertBoneIDs.Count do
																	VertBoneIDs[i] += BoneIndexMod
															)
														)
													)
												)
											)
										)
									)
									
									/*process bounds*
									local	Bound = Result.Bound
									if Have Bound then (
										local	BoundCount = Bound.Count
										if BoundCount > 1 then (	--TODO create composite
											!	TODO add result
										) else
											Result.Bound = Bound[1]
									)
									/**/
									
								)
								
								--finish
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Model_BoneMod: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Model_BoneMod"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								StructFromScene \
									CNode \
									ObjClass:EGIMS_V_Model_Bone \
									DiskPath:DiskPath \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Parent \
									ParentParamSource:ParentParamSource \
									ParentResult:ParentResult \
									Materials:Materials \
									RestrictedTypes:RestrictedTypes \
									AllowedTypes:AllowedTypes \
									AllowProgress:AllowProgress \
									ProgressData:ProgressData
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Model_Bone: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Model_Bone"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								if AllowProgress then (
									if SetOwnProgress then (
										ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
										UpdateProgress #Progress ProgressData
									)
								) else
									UpdateProgress #None 0
								if No Ancestor.TheSkeleton then
									Ancestor.TheSkeleton = (GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton())
								local	ObjName = (ReplaceChars Obj.Name)
								Result = (ConvertStruct undefined GIMS.CurrentGame.Core.TypeLibrary.grcBone ParamSource:ParamSource)
								Result.ObjName = ObjName
								local	ParentPresent = (Have Parent),
										InvParentTM = (
											if ParentPresent then
												Inverse Parent.Transform
											else
												(Matrix3 1)
										)
								Result.LocalOffset = (Obj.Pos * InvParentTM)
								local	Rot = ((Inverse (Obj.Rotation as Matrix3)) * InvParentTM).Rotation
								Result.RotationQuaternion = (Inverse Rot)
								Result.TheScale = (
									if ParentPresent then
										Parent.Scale / Obj.Scale
									else
										Obj.Scale
								)
								--if ParamSource.UseJoints then (
									local	Flags = ParamSource.Flags,
											--LimitRot = Flags[1],
											LimitTrans = Flags[5]--,
											--LimitScale = Flags[9]
									if
										--LimitRot or
										LimitTrans --or
										--LimitScale
									then (
										local	Joints = Ancestor.Joints,
												grcJointLimit = GIMS.CurrentGame.Core.TypeLibrary.grcJointLimit
										if No Joints then
											Ancestor.Joints = Joints = (GIMS.CurrentGame.Core.TypeLibrary.grcJoints())
										/*if LimitRot then (
											Append Joints.RotationLimits (
												grcJointLimit \
													BoneID:Result \
													LimitMin:ParamSource.RotMin \
													LimitMax:ParamSource.RotMax
											)
										)*/
										if LimitTrans then (
											Append Joints.TranslationLimits (
												grcJointLimit \
													BoneID:Result \
													LimitMin:ParamSource.TransMin \
													LimitMax:ParamSource.TransMax
											)
										)
										/*if LimitScale then (
											Append Joints.ScaleLimits (
												grcJointLimit \
													BoneID:Result \
													LimitMin:ParamSource.ScaleMin \
													LimitMax:ParamSource.ScaleMax
											)
										)*/
									)
								--)
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None 0
								for Child in Children do (
									StructFromScene \
										Child \
										DiskPath:DiskPath \
										Ancestor:Ancestor \
										AncestorNode:AncestorNode \
										Parent:Obj \
										ParentParamSource:ParamSource \
										ParentResult:Result \
										Materials:Materials \
										RestrictedTypes:RestrictedTypes \
										AllowedTypes:AllowedTypes \
										ProgressData:ProgressData \
										AllowProgress:AllowProgress \
								)
								local	ParentBones = (
									if
										(IsKindOf ParentParamSource EGIMS_V_Model) or
										(IsKindOf ParentParamSource EGIMS_V_Model_ModelMod)
									then
										Ancestor.TheSkeleton.TheBones
									else
										ParentResult.Children
								)
								Append ParentBones Result
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Model_LightMod: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Model_LightMod"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								StructFromScene \
									CNode \
									ObjClass:EGIMS_V_Model_Light \
									DiskPath:DiskPath \
									Ancestor:Ancestor \
									AncestorNode:AncestorNode \
									Parent:Parent \
									ParentParamSource:ParentParamSource \
									ParentResult:ParentResult \
									RestrictedTypes:RestrictedTypes AllowedTypes:AllowedTypes \
									AllowProgress:AllowProgress \
									ProgressData:ProgressData
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_Model_Light: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_Model_Light"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
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
								if No Ancestor.LightAttributes then
									Ancestor.LightAttributes = (GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes())
								local	LightAttributes = Ancestor.LightAttributes,
										InvParentTM = (
											if Have Parent then
													Inverse Parent.Transform
											else
													(Matrix3 1)
										),
										LightAttr = (ConvertStruct undefined GIMS.CurrentGame.Core.TypeLibrary.grcLight ParamSource:ParamSource),
										Dir = ((-Obj.Dir) * InvParentTM.Rotation),
										CP
								if ParamSource.CustomCullingPlane then (
									local	Angles = ParamSource.CPAngles,
											CPVec = ((-Dir) * ((EulerAngles Angles[1] Angles[2] Angles[3]) as Quat))
									CP = (TypeCast CPVec #Array)
									CP[4] = ParamSource.CPDistance
								) else (
									CP = (TypeCast (-Dir) #Array)
									CP[4] = ParamSource.Falloff
								)
								LightAttr.LightType = (
									case ParamSource.Type of (
										1:
											1
										2:
											2
										3:
											4
										default:
											throw "Unknown light type: " ParamSource.Type
									)
								)
								LightAttr.CullingPlane = CP
								LightAttr.Tangent = (Dir * ((EulerAngles 90 0 0) as Quat))	--TODO get from ParamSource
								local	TheExtents = ParamSource.TheExtents
								LightAttr.Extents = [TheExtents, TheExtents, TheExtents]
								LightAttr.LightFadeDistance = ParamSource.TheDistance
								LightAttr.BoneTag = (
									if
										(IsKindOf ParentParamSource EGIMS_V_Model_Bone) or
										(IsKindOf ParentParamSource EGIMS_V_Model_BoneMod)
									then
										ParentResult
									else
										-1
								)
								LightAttr.Position = (Obj.Pos * InvParentTM)
								LightAttr.Direction = Dir
								local	ProjectedTextureName = (ReplaceChars ParamSource.ProjectedTextureName Comparator:OrderComparator)
								AppendMHL GIMS.CurrentGame.Core.DB.TextureNames ProjectedTextureName Comparator:OrderComparator
								LightAttr.ProjectedTextureHash = (GetJenkinsHash ProjectedTextureName)
								Append LightAttributes.Items LightAttr
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_ModelMesh: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_ModelMesh"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
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
									
								--prepare collection data
								local	ObjName = (ReplaceChars Obj.Name),
										Mtl = (GetStandartized Obj.Material DoSort:false),
										MatLevelsAndSPSList = (GetMaterialLevelsAndSPSList Mtl.MaterialList)
							
								--create fake parent model
								local	IsOphan = false
								if No Ancestor then (
									IsOphan = true
									Result = (
										GIMS.CurrentGame.Core.TypeLibrary.grcDrawable \
											DiskPath:DiskPath \
											ObjName:ObjName \
											LODGroup:(GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup()) \
									)
									Ancestor = Result
									AncestorNode = Obj
									ParentResult = Ancestor
									Materials = #()
								)
									
								--collect data
								if (PrepareMeshForExport #Model Obj Mtl MatLevelsAndSPSList) then (
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
											--FoundVDs = #(),
											--FoundVDCount = 0,
											FoundVDsPresent = false,
											NeedNormals = false,
											NeedTangents = false,
											NeedColors = false,
											NeedColors2 = false,
											IsVDSearchFinished = false,
											SkinnedOriginal = Skinned
									--FoundVDs.Count = SPSList.Count
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
														#D3DDECLUSAGE_COLOR: (
															if NeedColors then (
																if not NeedColors2 then
																	NeedColors2 = true
																else (
																	VDUVCount += (
																		case (SPSToGIMSParamType Elem.aType) of (
																			#Float:
																				1
																			#P2:
																				1
																			#P3:
																				2
																			#P4:
																				2
																			default:
																				throw "Unknown Color type: " Type
																		)
																	)
																)
															) else
																NeedColors = true
														)
														#D3DDECLUSAGE_TEXCOORD: (
															VDUVCount += (
																case (SPSToGIMSParamType Elem.aType) of (
																	#Float:
																		1
																	#P2:
																		1
																	#P3:
																		2
																	#P4:
																		2
																	default:
																		throw "Unknown Color type: " Type
																)
															)
														)
													)
												)
												if VDUVCount > RAWUVCount then
													RAWUVCount = VDUVCount
												--FoundVDCount += 1
												--FoundVDs[FoundVDCount] = VertexDeclaration
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
													v3:"\" don't support mesh skinning.\nThe skinning will be automatically turned off."
												)
												RAWSkinData = unsupplied
												Skinned = (not Skinned)
											) else (
												AddResult #Error (
													FormatText \
													v1:"Some of shaders in object \"" \
													v2:(GetPathString Obj) \
													v3:"\" require mesh skinning, which isn't there.\nObject'll be skipped at export."
												)
												IsVDSearchFinished = true
												FoundVDsPresent = false
											)
										)
									)
									--FoundVDs.Count = FoundVDCount
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
												RAWColors = (if NeedColors then #() else unsupplied),
												RAWColors2 = (if NeedColors2 then #() else unsupplied)
										/*<ERRHANDLERSTART>*/try (
											local	CTM = (
														if Skinned then (
															if Have AncestorNode then
																(Inverse AncestorNode.Transform)
															else
																(Matrix3 1)
														) else (
															if Have Parent then
																(Inverse Parent.Transform)
															else
																(Matrix3 1)
														)
													)
											if (
												DumpMesh \
													Obj \
													RAWVerts \
													RAWFaces \
													Normals:RAWNormals \
													Tangents:RAWTangents \
													Colors:RAWColors \
													Colors2:RAWColors2 \
													UVCount:RAWUVCount \
													UVData:RAWUVData \
													SkinData:RAWSkinData \
													FaceGroups:RAWFaceGroups \
													Materials:Materials \
													MatPropMapping:Rules.ModelMaterialPropMapping \
													CoordsysTM:CTM \
											) then (
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
																			(IsKindOf ParentParamSource EGIMS_V_Model_Bone) or
																			(IsKindOf ParentParamSource EGIMS_V_Model_BoneMod)
																		then
																			ParentResult
																	) \
																	ObjName:ObjName \
																	Mask:ParamSource.Mask \
															),
															GroupMtlIDs = RAWFaceGroups[1],
															FaceGroups = RAWFaceGroups[2],
															GroupCount = FaceGroups.Count,
															ModelVertBufferSize = Rules.ModelVertBufferSize,
															SkinPerGeoMaxBoneCount, RAWSkinBones, RAWSkinWeights, RAWSkinBoneCount

													--split face groups to fit limits
													/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_ModelMesh+SplitFaceGroups"; local PWS = (*//*<PROFILERSTARTED>*/
													/*<ERRHANDLERSTART>*/try (
														if Skinned then (
															RAWSkinBones = RAWSkinData[1]
															RAWSkinWeights = RAWSkinData[2]
															RAWSkinBoneCount = RAWSkinBones.Count
															SkinPerGeoMaxBoneCount = Rules.SkinPerGeoMaxBoneCount
														)
														local	GroupsToSplit = #{1..GroupCount}
														while GroupsToSplit.NumberSet != 0 do (
															for GroupID in GroupsToSplit do (
																UpdateProgress #None 0
																local	Faces = FaceGroups[GroupID],
																		NewFaces = #(),
																		NewGroupSize = 0,
																		UsedVertCount = 0,
																		MoveToNewGroup = false
																NewFaces.Count = Faces.Count
																
																--process faces
																/*<ERRHANDLERSTART>*/try (
																	for FaceID in Faces do (
																		if not MoveToNewGroup then (
																			UsedVertCount += 3
																			if UsedVertCount >= ModelVertBufferSize then
																				MoveToNewGroup = true
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
																		GroupCount += 1
																		GroupsToSplit[GroupCount] = true
																	)
																/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
															)
														)
													/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
													/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
													
													--collect mesh data
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
															v7:"\nThat mesh will be skipped. You should consider reducing number of materials or splitting that mesh into multiple."
														)
													) else (
														/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_ModelMesh+CollectMeshData"; local PWS = (*//*<PROFILERSTARTED>*/
														/*<ERRHANDLERSTART>*/try (
															local	grcMeshVertex = GIMS.CurrentGame.Core.TypeLibrary.grcMeshVertex,
																	RAWMapFaceGroups = (if NeedUVs then RAWUVData[1] 		else unsupplied),
																	RAWMapVertGroups = (if NeedUVs then RAWUVData[2] 		else unsupplied),
																	NormalsFaces 	= (if NeedNormals then RAWNormals[1] 	else #NoNormalsFaces 	),
																	NormalsVectors 	= (if NeedNormals then RAWNormals[2] 	else #NoNormalsVectors 	),
																	TangentFaces 	= (if NeedTangents then RAWTangents[1] 	else #NoTangentFaces 	),
																	TangentInfos 	= (if NeedTangents then RAWTangents[2] 	else #NoTangentInfos 	),
																	ColorFaces 		= (if NeedColors then RAWColors[1] 		else #NoColorFaces 		),
																	ColorVerts 		= (if NeedColors then RAWColors[2] 		else #NoColorVerts 		),
																	ColorFaces2 	= (if NeedColors2 then RAWColors2[1] 	else #NoColorFaces2 	),
																	ColorVerts2 	= (if NeedColors2 then RAWColors2[2] 	else #NoColorVerts2 	),
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
																			NormalsFace = (if NeedNormals then NormalsFaces[FaceID]		else #NoNormalsFace ),
																			TangentFace = (if NeedTangents then TangentFaces[FaceID]	else #NoTangentFace ),
																			ColorFace 	= (if NeedColors then ColorFaces[FaceID]		else #NoColorFace 	),
																			ColorFace2 	= (if NeedColors2 then ColorFaces2[FaceID]		else #NoColorFace2 	),
																			FaceIndices = #()
																	FaceIndices.Count = 3
																	for SubVertID = 1 to 3 do (
																	
																		--calculate vertex hash
																		--TODO prepare vertex strings instead of indices
																		
																		local	PhysVertID = Face[SubVertID],
																				MapVertIDs = #NoMapVertIDs,
																				ColorVertID, Color2VertID, NormalsVertID, TangentVertID
																		Format HashFmtStr (PhysVertID as Integer) To:HashValueSS
																		if NeedColors then (
																			ColorVertID = ColorFace[SubVertID]
																			Format HashFmtStr (ColorVertID as Integer) To:HashValueSS
																		)
																		if NeedColors2 then (
																			Color2VertID = ColorFace2[SubVertID]
																			Format HashFmtStr (Color2VertID as Integer) To:HashValueSS
																		)
																		if NeedUVs then (
																			MapVertIDs = #()
																			for ChID = RAWUVCount to 1 by -1 do (
																				local	MapVertID = RAWMapFaceGroups[ChID][FaceID][SubVertID]
																				MapVertIDs[ChID] = MapVertID
																				Format HashFmtStr (MapVertID as Integer) To:HashValueSS
																			)
																		)
																		if NeedNormals then (
																			NormalsVertID = NormalsFace[SubVertID]
																			Format HashFmtStr (NormalsVertID as Integer) To:HashValueSS
																		)
																		if NeedTangents then (
																			TangentVertID = TangentFace[SubVertID]
																			Format HashFmtStr (TangentVertID as Integer) To:HashValueSS
																		)
																		local	HashValue = (HashValueSS as String)
																		Free HashValueSS
																	
																		--find place for the vertex
																		--TODO collect prepared vertex strings
																		
																		local	VertID = (QuickSearch Verts HashValue EndID:VertCount PropertyName:VertHashPropName GetInsertionPoint:true Comparator:OrderComparator)
																		--Format "%\t\t\t%\n" HashValue VertID 	--TO--DO remove, debug
																		if VertID < 0 then (	--already present
																			VertID = -VertID	--fix place index
																			if VertID > VertCount then
																				VertCount = VertID
																			FaceIndices[SubVertID] = Verts[VertID]
																		) else (	--add new vertex
																				
																			--collect vertex data
																			local	UVCoords = unsupplied,
																					VertColor, VertColor2, Normal, Tangent
																			if NeedColors then
																				VertColor = ColorVerts[ColorVertID]
																			if NeedColors2 then
																				VertColor2 = ColorVerts2[Color2VertID]
																			if NeedUVs then (
																				UVCoords = #()
																				for ChID = RAWUVCount to 1 by -1 do
																					UVCoords[ChID] = (TypeCast RAWMapVertGroups[ChID][MapVertIDs[ChID]] Point3)
																			)
																			if NeedNormals then
																				Normal = NormalsVectors[NormalsVertID]
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
																								Position:RAWVerts[PhysVertID] \
																								Normal:Normal \
																								TheColor:VertColor \
																								TheColor2:VertColor2 \
																								Tangent:Tangent \
																								SkinBones:RAWSkinBones[PhysVertID] \
																								SkinWeights:RAWSkinWeights[PhysVertID] \
																								UVCoords:UVCoords \
																								HashValue:HashValue \
																						) else (
																							grcMeshVertex \
																								Position:RAWVerts[PhysVertID] \
																								Normal:Normal \
																								TheColor:VertColor \
																								TheColor2:VertColor2 \
																								Tangent:Tangent \
																								UVCoords:UVCoords \
																								HashValue:HashValue \
																						)
																					)
																			FaceIndices[SubVertID] = TempVertex
																			PreallocatedInsertItem TempVertex Verts VertID VertCount
																		)
																	)
																	IdxCount += 1
																	Idx[IdxCount] = FaceIndices
																)
																
																/*TODO remove, debug*
																local	HaveVertFlags = #{}
																for i = GroupVertBufferSize to 1 by -1 where (Have Verts[i]) do
																	HaveVertFlags[i] = true
																LogProfiler #PlainInfo "VertCount, GroupVertBufferSize, Verts array size, Actual vertices:\t" AddParam:#(VertCount, GroupVertBufferSize, Verts.Count, HaveVertFlags)
																Free HaveVertFlags
																/**/
																
																--restore vert indices
																for i = 1 to VertCount do
																	Verts[i].CollectionIndex = i
																for FaceIdx in Idx do (
																	for i = 1 to 3 do
																		FaceIdx[i] = FaceIdx[i].CollectionIndex
																)
																
																--create geometry
																--TODO put prepared vertex strings instead of components

																
																local	Positions = #(),
																		Normals = #(),
																		Colors = #(),
																		Colors2 = #(),
																		Tangents = #(),
																		MatBound = (AABB()),
																		MatID = GroupMtlIDs[GroupID],
																		MtlGeometryFlags = Materials[MatID].GeometryFlags,
																		GeometryFlags = #{}
																for mgf = MtlGeometryFlags.Count to 1 by -1 where MtlGeometryFlags[mgf] do
																	GeometryFlags[mgf] = true
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
																			if NeedNormals then
																				Normals[VertID] = Vert.Normal
																			if NeedColors then
																				Colors[VertID] = Vert.TheColor
																			if NeedColors2 then
																				Colors2[VertID] = Vert.TheColor2
																			if NeedTangents then
																				Tangents[VertID] = Vert.Tangent
																			SkinBones[VertID] = Vert.SkinBones
																			SkinWeights[VertID] = Vert.SkinWeights
																			local	VertUVCoords = Vert.UVCoords
																			for ChID = 1 to RAWUVCount do
																				UVCoords[ChID][VertID] = VertUVCoords[ChID]
																		)
																		Geometries[GroupID] = (
																			grcLODMeshGeometry \
																				Flags:GeometryFlags \
																				ShaderIndex:MatID \
																				Idx:Idx \
																				Positions:Positions \
																				Normals:Normals \
																				Colors:Colors \
																				Colors2:Colors2 \
																				Tangents:Tangents \
																				SkinBones:SkinBones \
																				SkinWeights:SkinWeights \
																				UVCoords:UVCoords \
																		)
																	) else (	--not NeedUVs
																		for VertID = VertCount to 1 by -1 do (
																			local	Vert = Verts[VertID],
																					VertPosition = Vert.Position
																			ExtendBound MatBound VertPosition
																			Positions[VertID] = VertPosition
																			if NeedNormals then
																				Normals[VertID] = Vert.Normal
																			if NeedColors then
																				Colors[VertID] = Vert.TheColor
																			if NeedColors2 then
																				Colors2[VertID] = Vert.TheColor2
																			if NeedTangents then
																				Tangents[VertID] = Vert.Tangent
																			SkinBones[VertID] = Vert.SkinBones
																			SkinWeights[VertID] = Vert.SkinWeights
																		)
																		Geometries[GroupID] = (
																			grcLODMeshGeometry \
																				Flags:GeometryFlags \
																				ShaderIndex:MatID \
																				Idx:Idx \
																				Positions:Positions \
																				Normals:Normals \
																				Colors:Colors \
																				Colors2:Colors2 \
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
																			if NeedNormals then
																				Normals[VertID] = Vert.Normal
																			if NeedColors then
																				Colors[VertID] = Vert.TheColor
																			if NeedColors2 then
																				Colors2[VertID] = Vert.TheColor2
																			if NeedTangents then
																				Tangents[VertID] = Vert.Tangent
																			local	VertUVCoords = Vert.UVCoords
																			for ChID = 1 to RAWUVCount do
																				UVCoords[ChID][VertID] = VertUVCoords[ChID]
																		)
																		Geometries[GroupID] = (
																			grcLODMeshGeometry \
																				Flags:GeometryFlags \
																				ShaderIndex:MatID \
																				Idx:Idx \
																				Positions:Positions \
																				Normals:Normals \
																				Colors:Colors \
																				Colors2:Colors2 \
																				Tangents:Tangents \
																				UVCoords:UVCoords \
																		)
																	) else (	--not NeedUVs
																		for VertID = VertCount to 1 by -1 do (
																			local	Vert = Verts[VertID],
																					VertPosition = Vert.Position
																			ExtendBound MatBound VertPosition
																			Positions[VertID] = VertPosition
																			if NeedNormals then
																				Normals[VertID] = Vert.Normal
																			if NeedColors then
																				Colors[VertID] = Vert.TheColor
																			if NeedColors2 then
																				Colors2[VertID] = Vert.TheColor2
																			if NeedTangents then
																				Tangents[VertID] = Vert.Tangent
																		)
																		Geometries[GroupID] = (
																			grcLODMeshGeometry \
																				Flags:GeometryFlags \
																				ShaderIndex:MatID \
																				Idx:Idx \
																				Positions:Positions \
																				Normals:Normals \
																				Colors:Colors \
																				Colors2:Colors2 \
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
															/*calculate small and big radiuses*
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
															/**/
															LODMesh.Bounds = MatBounds
															
															--store mesh
															Append LodGroup.LODGroups[ParamSource.Type] LODMesh
														/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#FaceGroups), #(FaceGroups)))/*<ERRHANDLEREND>*/
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
														#RAWColors,
														#RAWColors2
													), #(
														RAWVerts,
														RAWFaces,
														RAWFaceGroups,
														RAWNormals,
														RAWUVData,
														RAWTangents,
														RAWColors,
														RAWColors2
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
										if NeedColors2 then
											Dispose RAWColors2
									)
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
								
								/*collect child meshes and collisions*/
								for Child in Children do (
									StructFromScene \
										Child \
										DiskPath:DiskPath \
										Ancestor:Ancestor \
										AncestorNode:AncestorNode \
										CoordsysTM:CoordsysTM \
										Parent:Obj \
										ParentParamSource:ParamSource \
										ParentResult:ParentResult \
										AllowProgress:AllowProgress \
										Materials:Materials \
										RestrictedTypes:RestrictedTypes \
										AllowedTypes:AllowedTypes \
										ProgressData:ProgressData \
								)
								/**/
								
								--complete fake parent model
								if IsOphan then (
								
									--store values
									local	ShadingGroup = Result.ShadingGroup
									if Have ShadingGroup then
										ShadingGroup.Mtls = Materials
									Result.TheSkeleton = undefined
									
									--set mesh bone IDs
									local	LodGroup = Result.LodGroup
									for LODGroup in LodGroup.LODGroups do (
										for LODMesh in LODGroup do
											LODMesh.BoneID = 1
									)
								
									/*process bounds*
									local	Bound = Result.Bound
									if Have Bound then (
										local	BoundCount = Bound.Count
										if BoundCount > 1 then (	--TODO create composite
											!	TODO add result
										) else
											Result.Bound = Bound[1]
									)
									/**/
								)
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						EGIMS_V_TexDict: (
							/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.ObjectMgr.StructFromScene+EGIMS_V_TexDict"; local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								local	ObjList = ParamSource.ObjList
								if AllowProgress then (
									if SetOwnProgress then (
										ProgressData = [0, 0, ObjList.Count]
										UpdateProgress #Progress ProgressData
									)
								) else
									UpdateProgress #None undefined
								local	TexInfos = #(#(), #()),
										ObjName = (ReplaceChars Obj.Name)
								for Child in ObjList where Have Child do (
									if (IsKindOf Child EGIMS_V_ModelDict) then (
										for SubChild in Child.Children where
											(IsKindOf SubChild EGIMS_V_Model) or
											(IsKindOf SubChild.Modifiers[#Model] EGIMS_V_Model_ModelMod)
										do
											GetExcludedTextures SubChild TexInfos:TexInfos
									) else
										GetExcludedTextures Child TexInfos:TexInfos
								)
								local	ItemCount = TexInfos[1].Count
								if ItemCount == 0 then (
									AddResult #Error (
										FormatText \
											v1:"Texture dictionary \"" \
											v2:(GetPathString Obj) \
											v3:"\" is empty, and it'll be skipped automatically."
									)
								) else (
									local	grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture,
											ArrOTX = #()
									for i = ItemCount to 1 by -1 do (
										local	FilePath = TexInfos[2][i],
												TexParams = TexInfos[1][i]
										ArrOTX[i] = (
											grcTexture \
												ObjName:(GetFileNameFile FilePath) \
												TexturePath:FilePath \
												TypeID:TexParams[1][1] \
												PixelFormatID:TexParams[1][2] \
												UsageID:TexParams[1][3] \
												UsageFlags:(AsBitArray TexParams[2][1]) \
												ExtraFlags:TexParams[2][2] \
										)
									)
									Result = (
										GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary \
										DiskPath:DiskPath \
										ObjName:ObjName \
										Items:ArrOTX
									)
								)
								Free TexInfos[1]
								Free TexInfos[2]
								Free TexInfos
							/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj, #ParamSource, #SetOwnProgress, #ObjClass), #(Obj, ParamSource, SetOwnProgress, ObjClass)))/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						
						Default:
							throw ("Unknown object type: " + ObjClass as String)
					)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#Obj,
					#ObjClass
				), #(
					(
					if Have CNode.Obj then
						CNode.Obj.Name
					),
					(
						if Have CNode.ParamSource then
							(ClassOf CNode.ParamSource)
						else (
						if Have CNode.Obj then
							(ClassOf CNode.Obj)
						)
					)
				)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromFile File TexPaths = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FileType = (GetFileNameType File)
				FileType = (SubString FileType 2 FileType.Count)
				local	Type = (TypeCast FileType name),
						NeedTextures = false,
						StrType = (
							case Type of (
								#ovr:
									GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordings
								#obn:
									GIMS.CurrentGame.Core.TypeLibrary.grcPhBound
								#obd:
									GIMS.CurrentGame.Core.TypeLibrary.grcPhBoundDictionary
								#odr: (
									NeedTextures = true
									GIMS.CurrentGame.Core.TypeLibrary.grcDrawable
								)
								#odd: (
									NeedTextures = true
									GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary
								)
								#otd:
									GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary
								default: (
									if (MatchPattern (FileNameFromPath File) Pattern:"*distantlights_hd.dat") then
										GIMS.CurrentGame.Core.TypeLibrary.grcDistantLights
									else
										return undefined	--throw "Unknown resource type: " Type
								)
							)
						),
						HandlerParam = (
							if NeedTextures then
								TexPaths
							else
								#NoHandlerParam
						),
						Result = (ReadCached File StrType GCCPath:#ResourceCachePath Type:FileType HandlerParam:HandlerParam)
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
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#File, #TexPaths), #(File, TexPaths)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.MaterialOps*/strMaterialOps (
		/*Shortcuts*/
			Compare, AddResult, FixMapFileNames, ConvertStruct, AsoFText, LoadBitmapFile, AppendMHL, QuickSort, QuickSearch, TypeCast, UpdateMatrix, UpdateProgress, FormatText, CopyBitmapAlpha, GetDiffuseWithOpacityAlpha,
		/*Ops*/
		fn GetStandartized Mtl NeedMultiMtl:true DoOwnProgress:false DoSort:true TargetMtl:unsupplied BaseIndex:0 = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MAXFactory.MaterialOps.GetStandartized"; local PWS = (*//*<PROFILERSTARTED>*/
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
								TargetMtl
							) else
								(GetStandartized Mtl.MaterialList[1] NeedMultiMtl:false)
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
										(EGIMS_V_material())
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
					GTAIVunimat: (
						local	NewMtl = (ConvertStruct Mtl EGIMS_V_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false),
								DiffMap = Mtl.diffName,
								DiffMapEmbed = (Mtl.copytex_d == 2),
								NormalMap = Mtl.normName,
								NormalMapEmbed = (Mtl.copytex_b == 2),
								SpecularLevelMap = Mtl.specName,
								SpecularLevelMapEmbed = (Mtl.copytex_s == 2),
								ReflectionMap = Mtl.envName,
								ReflectionMapEmbed = (Mtl.copytex_e == 2),
								SetParam = NewMtl.SetParam
						NewMtl.SPSName = "default"
						if (IsKindOf DiffMap BitMapTexture) then (
							SetParam "DiffuseSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureGrassSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureSampler_layer0" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
						)
						if (IsKindOf NormalMap BitMapTexture) then (
							SetParam "BumpSampler" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
							SetParam "BumpSampler_layer0" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
							SetParam "NormalSampler" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
						)
						if (IsKindOf SpecularLevelMap BitMapTexture) then
							SetParam "SpecSampler" #svt_sampler SpecularLevelMap IsTexInternal:SpecularLevelMapEmbed
						if (IsKindOf ReflectionMap BitMapTexture) then
							SetParam "EnvironmentSampler" #svt_sampler ReflectionMap IsTexInternal:ReflectionMapEmbed
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
					GTA_IV_material: (
						local	NewMtl = (ConvertStruct Mtl EGIMS_V_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false),
								DiffMap = Mtl.DiffuseMap_1,
								DiffMapEmbed = (Mtl.MapsLocationData[1][1] == 2),
								NormalMap = Mtl.NormalMap,
								NormalMapEmbed = (Mtl.MapsLocationData[1][3] == 2),
								SpecularLevelMap = Mtl.SpecMap,
								SpecularLevelMapEmbed = (Mtl.MapsLocationData[2][1] == 2),
								ReflectionMap = Mtl.RefMap,
								ReflectionMapEmbed = (Mtl.MapsLocationData[2][2] == 2),
								SetParam = NewMtl.SetParam
						NewMtl.SPSName = "default"
						if (IsKindOf DiffMap BitMapTexture) then (
							SetParam "DiffuseSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureGrassSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureSampler_layer0" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
							SetParam "TextureSampler" #svt_sampler DiffMap IsTexInternal:DiffMapEmbed
						)
						if (IsKindOf NormalMap BitMapTexture) then (
							SetParam "BumpSampler" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
							SetParam "BumpSampler_layer0" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
							SetParam "NormalSampler" #svt_sampler NormalMap IsTexInternal:NormalMapEmbed
						)
						if (IsKindOf SpecularLevelMap BitMapTexture) then
							SetParam "SpecSampler" #svt_sampler SpecularLevelMap IsTexInternal:SpecularLevelMapEmbed
						if (IsKindOf ReflectionMap BitMapTexture) then
							SetParam "EnvironmentSampler" #svt_sampler ReflectionMap IsTexInternal:ReflectionMapEmbed
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
					EGIMS_MP3_material: (
						local	ParamMap = #(
									#("TextureSampler", 		#sp_sampler,		"TextureSampler", 			#svt_sampler),
									#("TextureSampler_layer0", 	#sp_sampler,		"TextureSampler_layer0",	#svt_sampler),
									#("TextureGrassSampler",	#sp_sampler,		"TextureGrassSampler",		#svt_sampler),
									#("DiffuseSampler",			#sp_sampler,		"DiffuseSampler",			#svt_sampler),
									
									#("NormalSampler", 			#sp_sampler,		"NormalSampler",			#svt_sampler),
									#("BumpSampler_layer0",		#sp_sampler,		"BumpSampler_layer0",		#svt_sampler),
									#("BumpSampler", 			#sp_sampler,		"BumpSampler",				#svt_sampler),
									
									#("SpecSampler", 			#sp_sampler,		"SpecSampler",				#svt_sampler),
									#("EnvironmentSampler", 	#sp_sampler,		"EnvironmentSampler",		#svt_sampler)
								),
								NewMtl = (ConvertStruct Mtl EGIMS_V_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false),
								GetParam = Mtl.GetParam,
								SetParam = NewMtl.SetParam
						NewMtl.SPSName = "default"
						for pData in ParamMap do (
							local	SParamName = pData[1],
									SParamType = pData[2],
									ParamValueData = (GetParam SParamName SParamType GetParamIDToo:true),
									ParamValue = ParamValueData[1]
							if Have ParamValue then (
								local	ParamID = ParamValueData[2],
										IsTexInternal = (GetParam SParamName SParamType GetIsTexInternal:true ParamID:ParamID)
								SetParam pData[3] pData[4] ParamValue IsTexInternal:IsTexInternal
							)
						)
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
					EGIMS_V_material: (
						FixMapFileNames Mtl
						Mtl.EnsureHaveParams Mtl.SPSName GIMS.CurrentGame.Core.DB QuickSearch TypeCast
						if NeedMultiMtl then
							Mtl = (MultiMaterial Material:#(Mtl) Names:#(Mtl.Name) ShowInViewport:true)
						Mtl
					)
					Standard: (
						local	NewMtl = (ConvertStruct Mtl EGIMS_V_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false),
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
							if IsGlowing then
								"emissive"
							else (
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
							SetParam "DiffuseSampler" #svt_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureGrassSampler" #svt_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureSampler_layer0" #svt_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
							SetParam "TextureSampler" #svt_sampler DiffMap IsTexInternal:IsGeneratedDiffuse
						)
														
						if HaveNM then (
							SetParam "BumpSampler" #svt_sampler NormalMap IsTexInternal:false
							SetParam "BumpSampler_layer0" #svt_sampler NormalMap IsTexInternal:false
							SetParam "NormalSampler" #svt_sampler NormalMap IsTexInternal:false
						)
						if HaveSM then
							SetParam "SpecSampler" #svt_sampler SpecularLevelMap IsTexInternal:false
						if HaveRM then
							SetParam "EnvironmentSampler" #svt_sampler ReflectionMap IsTexInternal:false
								
						local	MtlDiffColor = Mtl.Diffuse,
								DiffuseColor = (TypeCast ([MtlDiffColor.R, MtlDiffColor.G, MtlDiffColor.B] / 25.5) #P4),
								Bumpiness = (TypeCast (Mtl.BumpMapAmount / 10) #P4),
								SpecMapAmount = (TypeCast (Mtl.SpecularLevelMapAmount / 100) #P4),
								SpecFactor = (TypeCast (Mtl.Glossiness * 5.12) #P4),
								RefPower = (TypeCast Mtl.ReflectionMapAmount #P4),
								Emissiveness = (TypeCast (SelfIllumination * 2.55) #P4)
						if HaveSpecMask then
							SetParam "specMapIntMask" #svt_float3 (TypeCast SpecMask #P3) IsTexInternal:false
						
						SetParam "diffuseCol" #svt_float3 (TypeCast DiffuseColor #P3) IsTexInternal:false
						SetParam "SubColor" #svt_float3 (TypeCast DiffuseColor #P3) IsTexInternal:false
						SetParam "matDiffuseColor" #svt_float3 (TypeCast DiffuseColor #P3) IsTexInternal:false
						
						SetParam "bumpiness" #svt_float (TypeCast Bumpiness #Float) IsTexInternal:false
						
						Local	FloatSpecMapAmount = (TypeCast SpecMapAmount #Float)
						SetParam "specMapIntMask" #svt_float3 [FloatSpecMapAmount, FloatSpecMapAmount, FloatSpecMapAmount] IsTexInternal:false
						
						SetParam "specularIntensityMult" #svt_float (TypeCast SpecFactor #Float) IsTexInternal:false
						
						SetParam "reflectivePower" #svt_float (TypeCast RefPower #Float) IsTexInternal:false
						
						if IsGlowing then
							SetParam "emissiveMultiplier" #svt_float (TypeCast Emissiveness #Float) IsTexInternal:false
						
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
						NewMtl
					)
					BitMap:
						(GetStandartized (BitMapTexture BitMap:Mtl) DoOwnProgress:DoOwnProgress)
					BitMapTexture: (
						local	NewMtl = (EGIMS_V_material Name:(GetFileNameFile Mtl.FileName) ShowInViewport:true),
								SetParam = NewMtl.SetParam
						SetParam "DiffuseSampler" #svt_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureGrassSampler" #svt_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureSampler_layer0" #svt_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						SetParam "TextureSampler" #svt_sampler Mtl IsTexInternal:IsGeneratedDiffuse
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name) ShowInViewport:true)
					)
					Default: (
						local	NewMtl = (
									if No Mtl then
										(EGIMS_V_material ShowInViewport:true)
									else (
										local	MatDelegate = (try Mtl.Delegate catch())
										if
											Have MatDelegate and
											(IsKindOf MatDelegate Standard)
										then
											(GetStandartized MatDelegate NeedMultiMtl:false)
										else
											(ConvertStruct Mtl EGIMS_V_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false)
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
		/*Material info*/
			DelegateLinkedParams = #(	--HINT: it is mapped to DelegateLinkTypes
				#bumpiness                                             ,
				#bumpsampler                                           ,
				#BumpSampler2                                          ,
				/*TODO maybe for blend preview
				#BumpSampler_layer0                                    ,
				#BumpSampler_layer1                                    ,
				#BumpSampler_layer2                                    ,
				#BumpSampler_layer3                                    ,
				*/
				#diffuseCol                                            ,
				#DiffuseSampler                                        ,
				#emissivemultiplier                                    ,
				#environmentsampler                                    ,
				#fillColor                                             ,
				/*TODO maybe for blend preview
				#heightMapSamplerLayer0                                ,
				#heightMapSamplerLayer1                                ,
				#heightMapSamplerLayer2                                ,
				#heightMapSamplerLayer3                                ,
				*/
				#heightSampler                                         ,
				#highDetailSampler                                     ,
				#matDiffuseColor                                       ,
				#matDiffuseColor2                                      ,
				#NormalSampler                                         ,
				#plantColor                                            ,
				#PlateBgBumpSampler                                    ,
				#PlateBgSampler                                        ,
				#reflectivepower                                       ,
				#shader_cableDiffuse                                   ,
				#shader_cableEmissive                                  ,
				#specmapintmask                                        ,
				#specsampler                                           ,
				#specularFalloffMult                                           ,
				#SpecularIntensity                                     ,
				#specularIntensityMult                                 ,
				#TextureGrassSampler                                   ,
				#textureSamp                                           /*TODO maybe for blend preview	,
				#texturesampler_layer0                                 ,
				#TextureSampler_layer1                                 ,
				#TextureSampler_layer2                                 ,
				#TextureSampler_layer3                                 
				*/
			),
			DelegateLinkMults = #(	--HINT: it is mapped to DelegateLinkTypes
				10,			--#bumpiness                                             ,
				unsupplied,			--#bumpsampler                                           ,
				unsupplied,			--#BumpSampler2                                          ,
				/*TODO maybe for blend preview
				unsupplied,			--#BumpSampler_layer0                                    ,
				unsupplied,			--#BumpSampler_layer1                                    ,
				unsupplied,			--#BumpSampler_layer2                                    ,
				unsupplied,			--#BumpSampler_layer3                                    ,
				*/
				255,			--#diffuseCol                                            ,
				unsupplied,			--#DiffuseSampler                                        ,
				1.0/2.55,			--#emissivemultiplier                                    ,
				unsupplied,			--#environmentsampler                                    ,
				255,			--#fillColor                                             ,
				/*TODO maybe for blend preview
				unsupplied,			--#heightMapSamplerLayer0                                ,
				unsupplied,			--#heightMapSamplerLayer1                                ,
				unsupplied,			--#heightMapSamplerLayer2                                ,
				unsupplied,			--#heightMapSamplerLayer3                                ,
				*/
				unsupplied,			--#heightSampler                                         ,
				unsupplied,			--#highDetailSampler                                     ,
				25.5,			--#matDiffuseColor                                       ,
				25.5,			--#matDiffuseColor2                                      ,
				unsupplied,			--#NormalSampler                                         ,
				255,			--#plantColor                                            ,
				unsupplied,			--#PlateBgBumpSampler                                    ,
				unsupplied,			--#PlateBgSampler                                        ,
				unsupplied,			--#reflectivepower                                       ,
				unsupplied,			--#shader_cableDiffuse                                   ,
				unsupplied,			--#shader_cableEmissive                                  ,
				255,			--#specmapintmask                                        ,
				unsupplied,			--#specsampler                                           ,
				1.0/5.12,			--#specularFalloffMult                                     ,
				2,			--#SpecularIntensity                                     ,
				100,			--#specularIntensityMult                                 ,
				unsupplied,			--#TextureGrassSampler                                   ,
				unsupplied			/*TODO maybe for blend preview	,			--#textureSamp                                           ,
				unsupplied,			--#texturesampler_layer0                                 ,
				unsupplied,			--#TextureSampler_layer1                                 ,
				unsupplied,			--#TextureSampler_layer2                                 ,
				unsupplied,			--#TextureSampler_layer3                                 
				*/
			),
			DelegateLinkTypes = #(	--HINT: it is mapped to DelegateLinkedParams
				#BumpMult                                             ,
				#BumpSampler                                           ,
				#BumpSampler                                          ,
				/*TODO maybe for blend preview
				#BumpSampler_L0                                    ,
				#BumpSampler_L1                                    ,
				#BumpSampler_L2                                    ,
				#BumpSampler_L3                                    ,
				*/
				#DiffuseColor                                            ,
				#DiffuseSampler                                        ,
				#EmissiveMult                                    ,
				#ReflSampler                                    ,
				#DiffuseColor                                             ,
				/*TODO maybe for blend preview
				#HeightSampler_L0                                ,
				#HeightSampler_L1                                ,
				#HeightSampler_L2                                ,
				#HeightSampler_L3                                ,
				*/
				#HeightSampler                                         ,
				#DiffuseSampler                                     ,
				#DiffuseColor                                       ,
				#SpecColor                                      ,
				#BumpSampler                                         ,
				#DiffuseColor                                            ,
				#BumpSampler                                    ,
				#DiffuseSampler                                        ,
				#ReflMult                                       ,
				#DiffuseColor                                   ,
				#EmissiveMult                                  ,
				#SpecMapIntMask                                        ,
				#SpecSampler                                           ,
				#SpecFalloffMult                                           ,
				#SpecIntensity                                     ,
				#SpecMult                                 ,
				#DiffuseSampler                                   ,
				#DiffuseSampler                                           /*TODO maybe for blend preview	,
				#DiffuseSampler_L0                                 ,
				#DiffuseSampler_L1                                 ,
				#DiffuseSampler_L2                                 ,
				#DiffuseSampler_L3                                 
				*/
			),
		/*Ops*/
		ObjectMgr = strObjectMgr(),
		MaterialOps = strMaterialOps()
	)
	
	local	MAXFactory = (strMAXFactory()),
			DelegateLinkedParamsCount = MAXFactory.DelegateLinkedParams.Count,
			DelegateLinkMultsCount = MAXFactory.DelegateLinkMults.Count,
			DelegateLinkTypesCount = MAXFactory.DelegateLinkTypes.Count
	if
		(DelegateLinkedParamsCount != DelegateLinkMultsCount) or
		(DelegateLinkedParamsCount != DelegateLinkTypesCount)
	then
		throw "MAXFactory DelegateLinkedParams*DelegateLinkMults*DelegateLinkTypes map isn't balanced: " [DelegateLinkedParamsCount, DelegateLinkMultsCount, DelegateLinkTypesCount]

	GIMS.CurrentGame.Core.MAXFactory = MAXFactory
	
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
