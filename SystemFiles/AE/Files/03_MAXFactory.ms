/*#PC*DEFINE	CurrentGame	AE*/
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/--try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.ObjectMgr*/strObjectMgr (
		/*Shortcuts*/
		/*MAX*/
		IsFinite = Bit.IsFinite,
		DeleteFaces = MeshOp.DeleteFaces,
		BreakVerts = MeshOp.BreakVerts,
		GetIsoVerts = MeshOp.GetIsoVerts,
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
		PGetVert = PolyOp.GetVert,
		PGetFaceArea = PolyOp.GetFaceArea,
		PGetFaceDeg = PolyOp.GetFaceDeg,
		PDivideFace = PolyOp.DivideFace,
		PCollapseDeadStructs = PolyOp.CollapseDeadStructs,
		PWeldVertsByThreshold = PolyOp.WeldVertsByThreshold,
		/*GUI*/
		UpdateProgress, AddResult,
		/*Array*/
		Search, Split, Modify, RotateA, NormalizeA, QuickSearch, QuickSort, AppendMHL, FetchMHL, RebuildMHL,
		/*Misc*/
		TypeCast, ConvertStruct, CreateIfUnique, CalculateBounds, ExtendBound, RemoveSmoothingGroups, GetPathString, CreateMesh, FormatText, ReadCached, Rules, ModelTextureMap, ReplaceChars, DumpMesh, GetStandartized, StoreTransformData, StoreControllerData,
		/*Ops*/
		fn PrepareMeshForExport Obj = ( /*<TODO> keep source mesh unchanged*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	FGetFace = GetFace,
						FGetVert = GetVert,
						FDeleteFaces = DeleteFaces,
						FGetMapSupport = GetMapSupport,
						FDefaultMapFaces = DefaultMapFaces
				CollapseStack Obj
				/*delete NAN broken faces*/
				local	InvalidPolys = #{}
				for FaceID = 1 to Obj.NumFaces do (
					local	FaceVerts = (FGetFace Obj FaceID),
							Invalid = false
					for i = 1 to 3 while not Invalid do (
						local	TempVert = (FGetVert Obj FaceVerts[i])
						for j = 1 to 3 where not (IsFinite TempVert[j]) while not Invalid do
							Invalid = true
					)
					if Invalid then
						InvalidPolys[FaceID] = true
				)
				if InvalidPolys.count != 0 then
					FDeleteFaces Obj InvalidPolys
				/*remove the mesh garbage*/
				RemoveDegenerateFaces Obj
				RemoveIllegalFaces Obj
				RemoveIsolatedVerts Obj
				/*set face mat ids to 1*/
				for FaceID = 1 to Obj.NumFaces do
					SetFaceMatID Obj FaceID 1
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetCNodeProgressEntryCount CNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	Result = 0,
						Children = CNode.Children
				for CNodeChild in Children do (
					local	ChildClass = (ClassOf CNodeChild.ParamSource)
					Result += (
						case ChildClass of (
							EGIMS_AE_Model:
								(GetCNodeProgressEntryCount CNodeChild)
							EGIMS_AE_Collision:
								(GetCNodeProgressEntryCount CNodeChild)
							EGIMS_AE_CollisionNode:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							Editable_Mesh:
								3
							Editable_Poly:
								3
							Default:
								1
						)
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromScene \
			CNode \
			DiskPath:undefined \
			CoordsysTM:undefined \
			ParentParamSource:undefined \
			AllowProgress:true \
			ProgressData:undefined = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				at Time 0 (
					local	Obj = CNode.Obj,
							ParamSource = CNode.ParamSource,
							Children = CNode.Children,
							Result,
							ObjClass = (ClassOf ParamSource),
							SetOwnProgress = (No ProgressData)
					case ObjClass of (
						EGIMS_AE_Weapon: (
							if AllowProgress then (
								ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	Items = #()
							for Child in Children do (
								local	Item = (StructFromScene Child ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then
									Append Items Item
							)
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFile \
									DiskPath:DiskPath \
									ObjName:(ReplaceChars Obj.Name) \
									Nodes:Items
							)
						)
						EGIMS_AE_WeaponNode: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	Items = #(),
									InvObjTM = (Inverse Obj.Transform)
							for Child in Children do (
								local	Item = (StructFromScene Child CoordsysTM:InvObjTM ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then
									Append Items Item
							)
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileNode \
									ShipID:ParamSource.ShipID \
									Instances:Items
							)
						)
						EGIMS_AE_WeaponInstance: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileInstance \
									WeaponClass:ParamSource.WeaponClass \
									Pos:(Obj.Center * CoordsysTM) \
									Size:ParamSource.Size
							)
						)
						EGIMS_AE_Collision: (
							if AllowProgress then (
								ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	Items = #()
							for Child in Children do (
								local	Item = (StructFromScene Child ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then
									Append Items Item
							)
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFile \
									DiskPath:DiskPath \
									ObjName:(ReplaceChars Obj.Name) \
									Nodes:Items
							)
						)
						EGIMS_AE_CollisionNode: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	Items = #(),
									InvObjTM = (Inverse Obj.Transform)
							for Child in Children do (
								local	Item = (StructFromScene Child CoordsysTM:InvObjTM ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then
									Append Items Item
							)
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileNode \
									ID:ParamSource.ID \
									Instances:Items
							)
						)
						EGIMS_AE_Col_Sphere: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileInstance \
									Type:0 \
									Pos:(Obj.Center * CoordsysTM) \
									Size:ParamSource.Radius
							)
						)
						EGIMS_AE_Col_Box: (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileInstance \
									Type:1 \
									Pos:(Obj.Center * CoordsysTM) \
									Size:[ParamSource.Width, ParamSource.Depth, ParamSource.Height]
							)
						)
						EGIMS_AE_Model: (
							if AllowProgress then (
								ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	Items = #(),
									InvObjTM = (Inverse Obj.Transform)
							for Child in Children do (
								local	Item = (StructFromScene Child ParentParamSource:ParamSource CoordsysTM:InvObjTM ProgressData:ProgressData AllowProgress:AllowProgress)
								if Have Item then
									Append Items Item
							)
							local	ItemCount = Items.Count,
									ModelVersion = (ParamSource.ModelVersion + 1),
									Flags = ParamSource.Flags
							if
								ItemCount > 1 and
								ModelVersion == 2
							then (
								local	FirstMesh = Items[1],
										HaveUVs = Flags[1],
										HaveNormals = Flags[2],
										HaveColors = Flags[3],
										IdxOffset = FirstMesh.Verts.Count
								for i = 2 to ItemCount do (
									local	NewItem = Items[i],
											NewVerts = NewItem.Verts
									FirstMesh.Faces += (Modify NewItem.Faces IdxOffset #Add CopyArray:false)
									FirstMesh.Verts += NewVerts
									if HaveUVs then
										FirstMesh.UVs += NewItem.UVs
									if HaveNormals then
										FirstMesh.Normals += NewItem.Normals
									if HaveColors then
										FirstMesh.Colors += NewItem.Colors
									IdxOffset += NewVerts.Count
								)
								Items.Count = 1
							)
							Result = (
								GIMS.CurrentGame.Core.TypeLibrary.AEMFile \
									DiskPath:DiskPath \
									ObjName:(ReplaceChars Obj.Name) \
									ModelVersion:ModelVersion \
									Flags:Flags \
									Instances:Items
							)
						)
						Editable_Poly: (
							ConvertToMesh Obj
							Result = (
								StructFromScene \
								CNode \
								DiskPath:DiskPath \
								CoordsysTM:CoordsysTM \
								ParentParamSource:ParentParamSource \
								AllowProgress:AllowProgress \
								ProgressData:ProgressData
							)
						)
						Editable_Mesh: (
							PrepareMeshForExport Obj
							local	Mtl = (Obj.Material = (GetStandartized Obj.Material))[1]
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	RAWPositions = #(),
									RAWIdx = #(),
									RAWFaceGroups = #(),
									ModelFlags = ParentParamSource.Flags,
									HaveUVs = ModelFlags[1],
									HaveNormals = ModelFlags[2],
									HaveColors = ModelFlags[3],
									RAWNormals = (if HaveNormals then #()),
									RAWColors = (if HaveColors then #()),
									RAWUVData = (if HaveUVs then #()),
									RAWTransformKeyTimes = #(),
									TransformKeyValues = #(),
									MeshCoordsysTM
 							/*<TODO> StoreTransformData Obj RAWTransformKeyTimes TransformKeyValues CoordsysTM*/
							local	TransformKeyCount = TransformKeyValues.Count,
									LocalCoordsysTM
							if TransformKeyCount < 2 then (
								LocalCoordsysTM = CoordsysTM
								TransformKeyCount = 0
							) else
								LocalCoordsysTM = (Inverse Obj.Transform)
							if (
								DumpMesh \
									Obj \
									RAWPositions \
									RAWIdx \
									Normals:RAWNormals \
									Colors:RAWColors \
									UVCount:1 \
									UVData:RAWUVData \
									FaceGroups:RAWFaceGroups \
									CoordsysTM:LocalCoordsysTM
							) then (
								local	Idx = #(),
										Positions = #(),
										UVs = #(),
										Normals = #(),
										Colors = #(),
										Faces = RAWFaceGroups[2][1],
										NormalsFaces = RAWNormals[1],
										NormalsVectors = RAWNormals[2],
										RAWMapFaces, RAWMapVerts,
										ColorFaces, ColorVerts
								if HaveUVs then (
									RAWMapFaces = RAWUVData[1][1]
									RAWMapVerts = RAWUVData[2][1]
								)
								if HaveColors then (
									ColorFaces = RAWColors[1]
									ColorVerts = RAWColors[2]
								)
								local	FaceCount = Faces.Count,
										VertCount = (FaceCount * 3)
								Positions.Count = VertCount
								if HaveUVs then
									UVs.Count = VertCount
								if HaveNormals then
									Normals.Count = VertCount
								if HaveColors then
									Colors.Count = VertCount
								local	VertID = 0
								for i = FaceCount to 1 by -1 do (
									local	FaceID = Faces[i],
											FaceIdx = RAWIdx[FaceID],
											NormalsFace = NormalsFaces[FaceID],
											ColorFace = (if HaveColors then ColorFaces[FaceID])
									for SubVertID = 1 to 3 do (
										VertID += 1
										local	PhysVertID = FaceIdx[SubVertID],
												NormalsVertID = NormalsFace[SubVertID]
										Positions[VertID] = RAWPositions[PhysVertID]
										if HaveUVs then
											UVs[VertID] = (TypeCast RAWMapVerts[RAWMapFaces[FaceID][SubVertID]] #P2)
										if HaveNormals then
											Normals[VertID] = NormalsVectors[NormalsVertID]
										if HaveColors then
											Colors[VertID] = ColorVerts[ColorFace[SubVertID]]
									)
									Idx[i] = [VertID - 2, VertID - 1, VertID]
								)
								UpdateProgress #None undefined
								local	PivotPoint = [0, 0, 0],
										Bounds = (CalculateBounds Obj CoordsysTM:LocalCoordsysTM CheckChildrenRecursive:false),
										Centroid = Bounds[2],
										BoundingSphere = [Centroid.x, Centroid.y, Centroid.z, Bounds[3]]
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
								local	Animation = (GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimation()),
										BlockCount = (ParentParamSource.ModelVersion + 1)
								if BlockCount > 2 then (
									local	AnimOffset = (1.0 / Rules.AnimationFPS),
											AnimBlocks = Animation.Blocks,
											AEMMeshAnimBlock = GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimBlock,
											PosKeyTimes = #(),
											PosKeyValues = #(),
											RotationKeyTimes = #(),
											RotationKeyValues = #(),
											ScaleKeyTimes = #(),
											ScaleKeyValues = #()
									if
										TransformKeyCount == 1 and
										(IsIdentity TransformKeyCount[1])
									then
										TransformKeyCount = 0
									if TransformKeyCount != 0 then (
										local	TransformKeyTimes = (Modify RAWTransformKeyTimes AnimOffset #Add CopyArray:true)
										PosKeyTimes = TransformKeyTimes
										RotationKeyTimes = TransformKeyTimes
										ScaleKeyTimes = TransformKeyTimes
										for KeyID = TransformKeyCount to 1 by -1 do (
											local	KeyValue = TransformKeyValues[KeyID],
													KeyPos = KeyValue.Position,
													KeyRotation = (TypeCast KeyValue.Rotation EulerAngles),
													KeyScale = KeyValue.Scale
											PosKeyValues[KeyID] = [-KeyPos.x, KeyPos.z, KeyPos.y]
											RotationKeyValues[KeyID] = (TypeCast [-KeyRotation.x, -KeyRotation.y, KeyRotation.z] #DegToRad)
											ScaleKeyValues[KeyID] = [KeyScale.x, KeyScale.z, KeyScale.y]
										)
										InsertItem 0 PosKeyTimes 1
										InsertItem PosKeyValues[1] PosKeyValues 1
										InsertItem RotationKeyValues[1] RotationKeyValues 1
										InsertItem ScaleKeyValues[1] ScaleKeyValues 1
									)
									AnimBlocks.Count = BlockCount
									AnimBlocks[1] = (
										AEMMeshAnimBlock \
										Type:1 \
										KeyTimes:PosKeyTimes \
										KeyValues:PosKeyValues \
									)
									AnimBlocks[2] = (
										AEMMeshAnimBlock \
										Type:1 \
										KeyTimes:RotationKeyTimes \
										KeyValues:RotationKeyValues \
									)
									AnimBlocks[3] = (
										AEMMeshAnimBlock \
										Type:1 \
										KeyTimes:ScaleKeyTimes \
										KeyValues:ScaleKeyValues \
									)
									if BlockCount > 3 then (
										local	OpacityKeyTimes = #(),
												OpacityKeyValues = #(),
												RAWOpacityKeyTimes = #(),
												RAWOpacityKeyValues = #(),
												StartValue = Mtl.Opacity
 										/*<TODO> StoreControllerData Mtl.Opacity.Controller RAWOpacityKeyTimes RAWOpacityKeyValues*/
										local	KeyCount = RAWOpacityKeyValues.Count
										if
											KeyCount == 1 and
											(RAWOpacityKeyValues[1] - 1) < 0.0001
										then
											KeyCount = 0
										if KeyCount != 0 then (
											OpacityKeyTimes = (Modify RAWOpacityKeyTimes AnimOffset #Add CopyArray:true)
											OpacityKeyValues = RAWOpacityKeyValues
											for i = 1 to KeyCount do
												OpacityKeyValues[i] *= 100
											InsertItem 0 OpacityKeyTimes 1
											InsertItem OpacityKeyValues[1] OpacityKeyValues 1
										)
										AnimBlocks[4] = (
											AEMMeshAnimBlock \
											Type:(
												if KeyCount != 0 then
													2
												else
													-1
											) \
											KeyTimes:OpacityKeyTimes \
											KeyValues:OpacityKeyValues \
										)
										if BlockCount > 4 then (
											local	Controllers = #(
														Mtl.U_Offset.Controller,
														Mtl.V_Offset.Controller,
														Mtl.U_Tiling.Controller,
														Mtl.V_Tiling.Controller,
														unsupplied,
														unsupplied,
														unsupplied
													),
													StartValues = #(
														Mtl.U_Offset,
														Mtl.V_Offset,
														Mtl.U_Tiling,
														Mtl.V_Tiling,
														unsupplied,
														unsupplied,
														unsupplied
													),
													ControllerCount = Controllers.Count,
													UVTimes = #(),
													UVValues = #()
											for ControllerID = ControllerCount to 1 by -1 do (
												local	Controller = Controllers[ControllerID],
														UVKeyTimes = #(),
														UVKeyValues = #()
												if Supplied Controller then (
													local	StartValue = Controller.Value,
															RAWUVKeyTimes = #(),
															RAWUVKeyValues = #()
 													/*<TODO> StoreControllerData Controller RAWUVKeyTimes RAWUVKeyValues*/
													local	UVKeyCount = RAWUVKeyValues.Count
													if
														UVKeyCount == 1 and
														(RAWUVKeyValues[1] - StartValues[ControllerID]) < 0.0001
													then
														UVKeyCount = 0
													if UVKeyCount != 0 then (
														UVKeyTimes = (Modify RAWUVKeyTimes AnimOffset #Add CopyArray:true)
														UVKeyValues = RAWUVKeyValues
														for i = 1 to UVKeyCount do
															UVKeyValues[i] *= 100
														InsertItem 0 UVKeyTimes 1
														InsertItem UVKeyValues[1] UVKeyValues 1
													)
												)
												UVTimes[ControllerID] = UVKeyTimes
												UVValues[ControllerID] = UVKeyValues
											)
											AnimBlocks[5] = (
												AEMMeshAnimBlock \
												Type:0 \
												KeyTimes:UVTimes \
												KeyValues:UVValues \
											)
										)
									)
								)
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
								Result = (
									GIMS.CurrentGame.Core.TypeLibrary.AEMMesh \
										Faces:Idx \
										Verts:Positions \
										UVs:UVs \
										Normals:Normals \
										Colors:Colors \
										Animation:Animation \
										BoundingSphere:BoundingSphere \
										PivotPoint:PivotPoint
								)
							) else (
								if AllowProgress then (
									ProgressData.x += 3
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
							)
						)
						Default:
							throw ("Unknown object type: " + ObjClass as String)
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromFile File = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	 FileType = (GetFileNameType File),
				Type = (TypeCast (SubString FileType 2 FileType.Count) name),
				StrType = (
					case Type of (
						#aem:
							GIMS.CurrentGame.Core.TypeLibrary.AEMFile
						#bin: (
							local	FileName = (GetFileNameFile File)
							case of (
								(MatchPattern FileName Pattern:"weapons*"):
									GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFile
								(MatchPattern FileName Pattern:"*collision*"):
									GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFile
								Default:
									throw ("Unknown BIN file" + FileName)
							)
						)
						default:
							return undefined	--throw "Unknown resource type"
					)
				),
				Result = (ReadCached File StrType GCCPath:#ResourceCachePath Type:Type)
				if Have Result then (
					if (
						case StrType of (
							#aem:
								No Obj.Instances[1]
							Default:
								false
						)
					) then
						Result = undefined
				)
				Result
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetAEITexture File FullGCCPath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	ExitCode = 0,
						BMPPath = ((GetFileNamePath FullGCCPath) + (GetFileNameFile File) + ".png")
				HiddenDOSCommand \
					(
						FormatText \
							v1:GIMS.CurrentGame.Core.GameMgr.AEIEditorPath \
							v2:"AEIEditor.exe Export \"" \
							v3:File \
							v4:"\" \"" \
							v5:BMPPath \
							v6:"\" Silent=true"
					) \
					ExitCode:&ExitCode \
					DoNotWait:false
				if ExitCode != 0 then (
					throw #(
						"ErrorConsoleAttach",
						"ErrorAction",
						"ErrorArgCount",
						"ErrorParam",
						"ErrorSilent",
						"ErrorFormat",
						"ErrorMipMapped",
						"ErrorQuality",
						"ErrorWrongQuality",
						"ErrorTextureMap",
						"ErrorTextureMapID",
						"ErrorInvalidPath",
						"ErrorBatchMode"
					)[ExitCode]
				)
				if not DoesFileExist BMPPath then
					GIMS.Core.SystemMgr.AddResult #Error (Append "Can't find the texture: " BMPPath)
				(BitMapTexture FileName:BMPPath)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.MaterialOps*/strMaterialOps (
		/*SHORTCUTS*/	GetDiffuseWithOpacityAlpha, GetBumpWithSpecAlpha, ConvertStruct, UpdateProgress, FixMapFileNames, QuickSort, QuickSearch, RGBAlphaTextures,
		fn IsRGBAlphaTexture TextureName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				local	TextureID = (QuickSearch RGBAlphaTextures[1] TextureName)
				(
					TextureID > 0 or (
						local	Result = false
						for Wildcard in RGBAlphaTextures[2] where (MatchPattern TextureName Pattern:Wildcard) while not Result do
							Result = true
						Result
					)
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetStandartized Mtl NeedMultiMtl:true DoOwnProgress:false= (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/--try (
				case (ClassOf Mtl) of (
					MultiMaterial: (
						local	NewMtl = (Copy Mtl),
								MatCount = NewMtl.Count
						for MtlID = 1 to MatCount do (
							if DoOwnProgress then
								UpdateProgress #Progress [MtlID, 0, MatCount]
							else
								UpdateProgress #None undefined
							NewMtl[MtlID] = (GetStandartized NewMtl[MtlID] NeedMultiMtl:false)
						)
						QuickSort #(NewMtl.MaterialList, NewMtl.MaterialIDList) MHL:true
						NewMtl
					)
					EGIMS_AE_material: (
						FixMapFileNames Mtl
						if NeedMultiMtl then
							Mtl = (MultiMaterial Material:#(Mtl) Names:#(Mtl.Name))
						Mtl
					)
					Standard: (
						local	PropMapping = #(
									#(
										#Name,
										#ShowInViewport,
										#Opacity
									), #(
										#Name,
										#ShowInViewport,
										#Opacity
									)
								),
								NewMtl = (ConvertStruct Mtl EGIMS_AE_material PropMapping:PropMapping AllowOwnProps:false)
						NewMtl.DiffMap = (GetDiffuseWithOpacityAlpha Mtl UseOpacity:false)
						NewMtl.NormalSpecMap = (GetBumpWithSpecAlpha Mtl)
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					BitMap:
						GetStandartized (BitMapTexture BitMap:Mtl) DoOwnProgress:DoOwnProgress NeedMultiMtl:NeedMultiMtl
					BitMapTexture: (
						local	NewMtl = EGIMS_AE_material DiffMap:Mtl Name:(GetFileNameFile Mtl.FileName) ShowInViewport:true
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					Default: (
						local	NewMtl = (
									if No Mtl then
										EGIMS_AE_material ShowInViewport:true
									else (
										local	MatDelegate = (try Mtl.Delegate	catch())
										if
											Have MatDelegate and
											(IsKindOf MatDelegate Standard)
										then
											GetStandartized MatDelegate NeedMultiMtl:false
										else
											ConvertStruct Mtl EGIMS_AE_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false
									)
								)
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
				)
			/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory*/strMAXFactory (
		ObjectMgr = strObjectMgr(),
		MaterialOps = strMaterialOps()
	)
	GIMS.CurrentGame.Core.MAXFactory = strMAXFactory()
/*<ERRHANDLER>*//*) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)*//*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
