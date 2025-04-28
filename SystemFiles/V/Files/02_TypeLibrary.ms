/*#PC*DEFINE	CurrentGame	V*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	
/*Bounds*/
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.Bounds*/strBounds (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.Bounds",
		AABB = (GIMS.Core.TypeLibrary.AABB()),
		Center = unsupplied,
		Centroid = unsupplied,
		CenterOfMass = unsupplied,
		Radius = unsupplied,
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText
				WriteVal BufferID (AsoFText AABB.bMin TabString:(TabString + "AABBMin "))
				WriteVal BufferID (AsoFText AABB.bMax TabString:(TabString + "AABBMax "))
				if Supplied Radius then
					WriteVal BufferID (ValueOps.FormatText v1:TabString v2:"Radius " v3:Radius)
				if Supplied Centroid then
					WriteVal BufferID (AsoFText Centroid TabString:(TabString + "Centroid "))
				if Supplied Center then
					WriteVal BufferID (AsoFText Center TabString:(TabString + "Center "))
				if Supplied CenterOfMass then
					WriteVal BufferID (AsoFText CenterOfMass TabString:(TabString + "CG "))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalculateCentroid = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	bMin = AABB.bMin
				Centroid = (bMin + ((AABB.bMax - bMin) / 2))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalculateWorldRadius = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	bMin = AABB.bMin,
						bMax = AABB.bMax,
						wMin = [bMin.x, bMin.y, 0],
						wMax = [bMax.x, bMax.y, 0]
				Radius = ((Distance wMin wMax) / 2)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalculateRadius = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Radius = ((Distance AABB.bMin AABB.bMax) / 2)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
/*phBound*/
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcPhBound*/ strPhBound (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcPhBound",
		DiskPath,
		ObjName,
		Extension = ".obn",
		Version = [43, 31],
		Type,
		KnownTypes = #(	--HINT: sorted MHL, don't fuck with this
			#(
				#BoundBox,
				#BoundBVH,
				#BoundCapsule,
				#BoundComposite,
				#BoundCylinder,
				#BoundDisc,
				#BoundGeometry,
				#BoundPlane,
				#BoundSphere
			), #(
				"BoundBox",
				"BoundBVH",
				"BoundCapsule",
				"BoundComposite",
				"BoundCylinder",
				"BoundDisc",
				"BoundGeometry",
				"BoundPlane",
				"BoundSphere"
			)
		),
		Bounds = GIMS.CurrentGame.Core.TypeLibrary.Bounds(),
		Margin = unsupplied,
		Shrunk = unsupplied,
		FaceMatIDs = #(),
		Faces = #(),
		Siblings = #(),
		Primitives = #(),
		Vertices = #(),
		VertexOffset,
		VertexOffset_UnkPart,
		Materials = #(),
		VertexColors = unsupplied,
		MaterialColors = unsupplied,
		CapsuleHalfHeight = unsupplied,
		ChildFlags = unsupplied,
		Children = #(),
		ChildTransforms = #(),
		KnownChildFlags = #(	--HINT: sorted, don't fuck with this
			#ANIMAL             ,
			#ANIMAL_RAGDOLL     ,
			#EXPLOSION          ,
			#Foliage            ,
			#FORKLIFT_FORKS     ,
			#Glass              ,
			#MAP_ANIMAL         ,
			#MAP_COVER          ,
			#MAP_DEEP_SURFACE   ,
			#MAP_DYNAMIC        ,
			#MAP_RIVER          ,
			#MAP_STAIRS         ,
			#MAP_VEHICLE        ,
			#MAP_WEAPON         ,
			#object             ,
			#OBJECT_ENV_CLOTH   ,
			#PED                ,
			#PICKUP             ,
			#PLANT              ,
			#PROJECTILE         ,
			#ragdoll            ,
			#Smoke              ,
			#TEST_AI            ,
			#TEST_CAMERA        ,
			#TEST_SCRIPT        ,
			#TEST_VEHICLE_WHEEL ,
			#TEST_WEAPON        ,
			#UNKNOWN            ,
			#UNSMASHED          ,
			#VEHICLE_BOX        ,
			#VEHICLE_BVH        ,
			#VEHICLE_NOT_BVH
		),
		KnownPolyFlags = #(	--HINT: sorted, don't fuck with this
			#FLAG_NO_CAM_COLLISION                ,
			#FLAG_NO_CAM_COLLISION_ALLOW_CLIPPING ,
			#FLAG_NO_DECAL                        ,
			#FLAG_NO_NAVMESH                      ,
			#FLAG_NO_NETWORK_SPAWN                ,
			#FLAG_NO_PTFX                         ,
			#FLAG_NO_RAGDOLL                      ,
			#FLAG_NOT_CLIMBABLE                   ,
			#FLAG_NOT_COVER                       ,
			#FLAG_SEE_THROUGH                     ,
			#FLAG_SHOOT_THROUGH                   ,
			#FLAG_SHOOT_THROUGH_FX                ,
			#FLAG_STAIRS                          ,
			#FLAG_TOO_STEEP_FOR_PLAYER            ,
			#FLAG_VEHICLE_WHEEL                   ,
			#FLAG_WALKABLE_PATH
		),
		fn GetCreateProgressStepCount ObjectMgr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Type == #BoundComposite then (
					local	Result = 0
					for ChildID = 1 to Children.Count do (
						local	Child = Children[ChildID]
						if Have Child then
							Result += (Child.GetCreateProgressStepCount ObjectMgr)
					)
					Result
				) else (
					if
						Type == #BoundBVH or
						Type == #BoundGeometry
					then
						(ObjectMgr.CreateMesh_ProgressStepCount + Primitives.Count)
					else
						1
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ParseTag BufferID tLine \
			BufferMgr \
			DiskPathWithObjName \
			Skip \
			ReadVal \
			TypeCast \
			oFTypeExec \
			GetProgress \
			UpdateProgress \
			ReportProgress \
			FormatText \
			NotEOF \
			grcPhBound \
			ValueOps \
			AppendMHL \
			FetchMHL \
			QuickSearch \
			ObjectNames \
			NoCaseOrderComparator \
			UpdateMatrix = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			
				/*TODO remove, debug*	LogProfiler #PlainInfo "tLine:\t" AddParam:tLine	/**/
											
				local	Tag = (TypeCast tLine[1] name BufferID:BufferID),
						Result = true
						
				--Format "@ %\tTag \"%\"\tLine \"%\"\n" (BufferMgr.TellPos BufferID) Tag tLine --TODO remove, debug

				case Tag of (
					#Version: (
						if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
							GIMS.Core.SystemMgr.AddResult #Error  (
								FormatText \
									v1:"Wrong version resource \"" \
									v2:DiskPathWithObjName \
									v3:Extension \
									v4:"\""
							)
							Result = false
						)
						Skip BufferID 1 /* skip start */
					)
					#PhBound: (
						if
							(tLine.Count < 2) or
							(TypeCast tLine[2] Name BufferID:BufferID) != #NULL
						then
							Skip BufferID 1 /*skip start*/
						else
							Result = false
					)
					#Type: (
						Type = (FetchMHL KnownTypes tLine[2] ReturnHashOnFail:false Comparator:NoCaseOrderComparator)
						if No Type then (
							GIMS.Core.SystemMgr.AddResult #Error  (
								FormatText \
									v1:"Unknown PhBound type \"" \
									v2:tLine[2] \
									v3:"\" in file \"" \
									v4:DiskPathWithObjName \
									v5:Extension \
									v6:"\" found at " \
									v7:(BufferMgr.GetErrorInfo BufferID) \
							)
							Result = false
						)
					)
					#Radius:
						Bounds.Radius = (TypeCast tLine[2] Float BufferID:BufferID)
					#AABBMax:
						Bounds.AABB.bMax = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
					#AABBMin:
						Bounds.AABB.bMin = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
					#Centroid:
						Bounds.Centroid = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
					#CG:
						Bounds.CenterOfMass = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
					#Margin:
						Margin = (TypeCast tLine[2] Float BufferID:BufferID)
					#CapsuleHalfHeight:
						CapsuleHalfHeight = (TypeCast tLine[2] Float BufferID:BufferID)
					#GeometryCenter: (
						VertexOffset = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						VertexOffset_UnkPart = (TypeCast tLine[5] Float BufferID:BufferID)
					)
					#ChildTransforms: (
						local	count = (TypeCast tLine[2] Integer BufferID:BufferID)
						ChildTransforms.Count = count
						Skip BufferID 1 /*skip start*/
						for i = 1 to count do (
							Skip BufferID 1 /*skip header*/
							Skip BufferID 1 /*skip start*/
							ChildTransforms[i] = (
								Matrix3	(oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID) \
											(oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID) \
											(oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID) \
											(oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID)
							)
							Skip BufferID 1 /*skip end*/
						)
						Skip BufferID 1 /*skip end*/
					)
					#ChildFlags: (
						local	strCount = tLine[2]
						if (TypeCast strCount Name BufferID:BufferID) != #null then (
							Skip BufferID 1 /*skip start*/
							local	count = (TypeCast strCount Integer BufferID:BufferID)
									ChildFlagsIndex = 0
							ChildFlags = #()
							ChildFlags.Count = count					
							while
								Result and
								(cfhLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
							do ( /*skips end*/
								local	Flags1 = #(),
										Flags2 = #()
								for i = KnownChildFlags.Count to 1 by -1 do (
									Flags1[i] = false
									Flags2[i] = false
								)
								local	cfhName = cfhLine[1],
										cfhTag = (TypeCast cfhName name BufferID:BufferID)
								case cfhTag of (
									#Item: (
										Skip BufferID 1 /*skip start*/
										while
											Result and
											(cfLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	cfTag = (TypeCast cfLine[1] name BufferID:BufferID)
											case cfTag of (
												#Flags1: (
													if (TypeCast cfLine[2] name BufferID:BufferID) != #FORMATS_EMPTY_FLAGS then (
														local	TempFlags = (oFTypeExec cfLine #NameArray IDMask:#{2..cfLine.Count} BufferID:BufferID),
																FlagID
														for Flag in TempFlags do (
															FlagID = (QuickSearch KnownChildFlags Flag)
															if FlagID != 0 then
																Flags1[FlagID] = true
															else (
																GIMS.Core.SystemMgr.AddResult #Error  (
																	GIMS.Core.ValueOps.FormatText \
																		v1:"Unknown ChildFlag \"" \
																		v2:Flag \
																		v3:"\" in object \"" \
																		v4:ObjName \
																		v5:"\" found at " \
																		v6:(BufferMgr.GetErrorInfo BufferID) \
																)
																Result = false;
															)
														)
													)
												)
												#Flags2: (
													if (TypeCast cfLine[2] name BufferID:BufferID) != #FORMATS_EMPTY_FLAGS then (
														local	TempFlags = (oFTypeExec cfLine #NameArray IDMask:#{2..cfLine.Count} BufferID:BufferID),
																FlagID
														for Flag in TempFlags do (
															FlagID = (QuickSearch KnownChildFlags Flag)
															if FlagID != 0 then
																Flags2[FlagID] = true
															else (
																GIMS.Core.SystemMgr.AddResult #Error  (
																	GIMS.Core.ValueOps.FormatText \
																		v1:"Unknown ChildFlag \"" \
																		v2:Flag \
																		v3:"\" in object \"" \
																		v4:ObjName \
																		v5:"\" found at " \
																		v6:(BufferMgr.GetErrorInfo BufferID) \
																)
																Result = false;
															)
														)
													)
												)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown ChildFlags.Item tag \"" \
															v2:cfLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
									)
									default: (
										GIMS.Core.SystemMgr.AddResult #Error  (
											FormatText \
												v1:"Unknown ChildFlags tag \"" \
												v2:cfhName \
												v3:"\" in file \"" \
												v4:DiskPathWithObjName \
												v5:Extension \
												v6:"\" found at " \
												v7:(BufferMgr.GetErrorInfo BufferID) \
										)
										Result = false
									)
								)
								ChildFlagsIndex += 1
								ChildFlags[ChildFlagsIndex] = #(Flags1, Flags2)
							)
							if not Result then
								Skip BufferID 1 /*skip end*/
							ChildFlags.Count = ChildFlagsIndex
						)
					)
					#Vertices: (
						local	count = (TypeCast tLine[2] Integer BufferID:BufferID)
						Vertices.Count = count
						Skip BufferID 1 /*skip start*/
						for i = 1 to count do
							Vertices[i] = (oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID)
						Skip BufferID 1 /*skip end*/
					)
					#Shrunk: (
						local	count = (TypeCast tLine[2] Integer BufferID:BufferID)
						Shrunk = #()
						Shrunk.Count = count
						Skip BufferID 1 /*skip start*/
						for i = 1 to count do
							Shrunk[i] = (oFTypeExec (ReadVal BufferID) #P3 BufferID:BufferID)
						Skip BufferID 1 /*skip end*/
					)
					#ComputePolyNeighbors: ()	--SKIP
					#Polygons: (
						local	PolyCount = (TypeCast tLine[2] Integer BufferID:BufferID),
								FaceIndex = 0,
								PrimitiveIndex = 0
						if PolyCount != 0 then (
							FaceMatIDs.Count = PolyCount
							Faces.Count = PolyCount
							Siblings.Count = PolyCount
							Primitives.Count = PolyCount
							Skip BufferID 1 /*skip start*/
							local	PolyHeaderLine, PolyLine
							while
								Result and
								(PolyHeaderLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
							do ( /*skips end*/
								local	PolyName = PolyHeaderLine[1],
										PolyHeaderTag = (TypeCast PolyName name BufferID:BufferID)
								case PolyHeaderTag of (
									#Tri: (
										Skip BufferID 1 /*skip start*/
										FaceIndex += 1
										while
											Result and
											(PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	PolyTag = (TypeCast PolyLine[1] name BufferID:BufferID)
											case PolyTag of (
												#Vertices: (
													local	VertIndices = (oFTypeExec PolyLine #P3 IDMask:#{2..4} BufferID:BufferID)
													Faces[FaceIndex] = [VertIndices.x + 1, VertIndices.y + 1, VertIndices.z + 1]
												)
												#MaterialIndex:
													FaceMatIDs[FaceIndex] = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Siblings: (
													local	FaceIndices = (oFTypeExec PolyLine #P3 IDMask:#{2..4} BufferID:BufferID)
													Siblings[FaceIndex] = [FaceIndices.x + 1, FaceIndices.y + 1, FaceIndices.z + 1]
												)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown Polygon.Tri tag \"" \
															v2:PolyLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
									)
									#Sphere: (
										Skip BufferID 1 /*skip start*/
										local	PrimitiveMaterialIndex = unsupplied,
												PrimitiveCenter = unsupplied,
												PrimitiveRadius = unsupplied,
												PrimName = (
													FormatText \
														v1:PolyName \
														v2:"_" \
														v3:PolyHeaderLine[2] \
												)
										while
											Result and
											(PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	PolyTag = (TypeCast PolyLine[1] name BufferID:BufferID)
											case PolyTag of (
												#MaterialIndex:
													PrimitiveMaterialIndex = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Center:
													PrimitiveCenter = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Radius:
													PrimitiveRadius = (TypeCast PolyLine[2] Float BufferID:BufferID)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown Polygon.Cylinder tag \"" \
															v2:PolyLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
										PrimitiveIndex += 1
										Primitives[PrimitiveIndex] = #(PolyHeaderTag, PrimName, PrimitiveMaterialIndex, PrimitiveCenter, PrimitiveRadius)
									)
									#Capsule: (
										Skip BufferID 1 /*skip start*/
										local	PrimitiveMaterialIndex = unsupplied,
												PrimitiveCenterTop = unsupplied,
												PrimitiveCenterBottom = unsupplied,
												PrimitiveRadius = unsupplied,
												PrimName = (
													FormatText \
														v1:PolyName \
														v2:"_" \
														v3:PolyHeaderLine[2] \
												)
										while
											Result and
											(PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	PolyTag = (TypeCast PolyLine[1] name BufferID:BufferID)
											case PolyTag of (
												#MaterialIndex:
													PrimitiveMaterialIndex = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#CenterTop:
													PrimitiveCenterTop = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#CenterBottom:
													PrimitiveCenterBottom = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Radius:
													PrimitiveRadius = (TypeCast PolyLine[2] Float BufferID:BufferID)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown Polygon.Capsule tag \"" \
															v2:PolyLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
										PrimitiveIndex += 1
										Primitives[PrimitiveIndex] = #(PolyHeaderTag, PrimName, PrimitiveMaterialIndex, PrimitiveCenterTop, PrimitiveCenterBottom, PrimitiveRadius)
									)
									#Box: (
										Skip BufferID 1 /*skip start*/
										local	PrimitiveMaterialIndex = unsupplied,
												PrimitiveVertIndices = unsupplied,
												PrimName = (
													FormatText \
														v1:PolyName \
														v2:"_" \
														v3:PolyHeaderLine[2] \
												)
										while
											Result and
											(PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	PolyTag = (TypeCast PolyLine[1] name BufferID:BufferID)
											case PolyTag of (
												#MaterialIndex:
													PrimitiveMaterialIndex = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Vertices: (
													PrimitiveVertIndices = #(
														((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1),
														((TypeCast PolyLine[3] Integer BufferID:BufferID) + 1),
														((TypeCast PolyLine[4] Integer BufferID:BufferID) + 1),
														((TypeCast PolyLine[5] Integer BufferID:BufferID) + 1)
													)
												)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown Polygon.Box tag \"" \
															v2:PolyLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
										PrimitiveIndex += 1
										Primitives[PrimitiveIndex] = #(PolyHeaderTag, PrimName, PrimitiveMaterialIndex, PrimitiveVertIndices)
									)
									#Cylinder: (
										Skip BufferID 1 /*skip start*/
										local	PrimitiveMaterialIndex = unsupplied,
												PrimitiveCenterTop = unsupplied,
												PrimitiveCenterBottom = unsupplied,
												PrimitiveRadius = unsupplied,
												PrimName = (
													FormatText \
														v1:PolyName \
														v2:"_" \
														v3:PolyHeaderLine[2] \
												)
										while
											Result and
											(PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
										do ( /*skips end*/
											local	PolyTag = (TypeCast PolyLine[1] name BufferID:BufferID)
											case PolyTag of (
												#MaterialIndex:
													PrimitiveMaterialIndex = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#CenterTop:
													PrimitiveCenterTop = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#CenterBottom:
													PrimitiveCenterBottom = ((TypeCast PolyLine[2] Integer BufferID:BufferID) + 1)
												#Radius:
													PrimitiveRadius = (TypeCast PolyLine[2] Float BufferID:BufferID)
												default: (
													GIMS.Core.SystemMgr.AddResult #Error  (
														FormatText \
															v1:"Unknown Polygon.Cylinder tag \"" \
															v2:PolyLine[1] \
															v3:"\" in file \"" \
															v4:DiskPathWithObjName \
															v5:Extension \
															v6:"\" found at " \
															v7:(BufferMgr.GetErrorInfo BufferID) \
													)
													Result = false
												)
											)
										)
										PrimitiveIndex += 1
										Primitives[PrimitiveIndex] = #(PolyHeaderTag, PrimName, PrimitiveMaterialIndex, PrimitiveCenterTop, PrimitiveCenterBottom, PrimitiveRadius)
									)
									default: (
										GIMS.Core.SystemMgr.AddResult #Error  (
											FormatText \
												v1:"Unknown Polygon tag \"" \
												v2:PolyHeaderLine[1] \
												v3:"\" in file \"" \
												v4:DiskPathWithObjName \
												v5:Extension \
												v6:"\" found at " \
												v7:(BufferMgr.GetErrorInfo BufferID) \
										)
										Result = false
									)
								)
							)
							FaceMatIDs.Count = FaceIndex
							Faces.Count = FaceIndex
							Primitives.Count = PrimitiveIndex
						)
					)
					#Materials: (
						local	count = (TypeCast tLine[2] Integer BufferID:BufferID)
						if (count != 0) then (
							Materials.Count = count
							Skip BufferID 1 /*skip start*/
							for i = 1 to count while Result do (
								Skip BufferID 1 /*skip material header*/
								Skip BufferID 1 /*skip material start*/
								local	Mat_Index = 0,
										ProcId = 0,
										RoomId = 0,
										PedDensity = 0,
										PolyFlags = 0,
										MaterialColorIndex = 0,
										MatLine
								while
									Result and
									(MatLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
								do ( /*skips material end*/
									local	MatTag = (TypeCast MatLine[1] name BufferID:BufferID)
									case MatTag of (
										#MaterialIndex:
											Mat_Index = ((TypeCast MatLine[2] Integer BufferID:BufferID) + 1)
										#ProcId:
											ProcId = (TypeCast MatLine[2] Integer BufferID:BufferID)
										#RoomId:
											RoomId = (TypeCast MatLine[2] Integer BufferID:BufferID)
										#PedDensity:
											PedDensity = (TypeCast MatLine[2] Integer BufferID:BufferID)
										#PolyFlags: (
											if (TypeCast MatLine[2] name BufferID:BufferID) != #FORMATS_EMPTY_FLAGS then (
												local	TempFlags = (oFTypeExec MatLine #NameArray IDMask:#{2..MatLine.Count} BufferID:BufferID),
														FlagID,
														BitSet = Bit.Set
												for Flag in TempFlags do (
													FlagID = (QuickSearch KnownPolyFlags Flag)
													if FlagID != 0 then
														PolyFlags = (BitSet PolyFlags FlagID true)
													else (
														GIMS.Core.SystemMgr.AddResult #Error  (
															GIMS.Core.ValueOps.FormatText \
																v1:"Unknown flag \"" \
																v2:Flag \
																v3:"\" in object \"" \
																v4:ObjName \
																v5:"\" found at " \
																v6:(BufferMgr.GetErrorInfo BufferID) \
														)
														Result = false;
													)
												)
											)
										)
										#MaterialColorIndex:
											MaterialColorIndex = (TypeCast MatLine[2] Integer BufferID:BufferID)
										default: (
											GIMS.Core.SystemMgr.AddResult #Error  (
												FormatText \
													v1:"Unknown Material tag \"" \
													v2:MatLine[1] \
													v3:"\" in file \"" \
													v4:DiskPathWithObjName \
													v5:Extension \
													v6:"\" found at " \
													v7:(BufferMgr.GetErrorInfo BufferID) \
											)
											Result = false
										)
									)
								)
								if not Result then
									Skip BufferID 1 /*skip end*/
								Materials[i] = #(Mat_Index, PolyFlags, MaterialColorIndex, ProcId, RoomId, PedDensity)
							)
							Skip BufferID 1 /*skip end*/
						)
					)
					#Material: (
						Skip BufferID 1 /*skip start*/
						local	Mat_Index = 0,
								ProcId = 0,
								RoomId = 0,
								PedDensity = 0,
								PolyFlags = 0,
								MaterialColorIndex = 0,
								MatLine
						while
							Result and
							(MatLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
						do ( /*skips end*/
							local	MatTag = (TypeCast MatLine[1] name BufferID:BufferID)
							case MatTag of (
								#MaterialIndex:
									Mat_Index = ((TypeCast MatLine[2] Integer BufferID:BufferID) + 1)
								#ProcId:
									ProcId = (TypeCast MatLine[2] Integer BufferID:BufferID)
								#RoomId:
									RoomId = (TypeCast MatLine[2] Integer BufferID:BufferID)
								#PedDensity:
									PedDensity = (TypeCast MatLine[2] Integer BufferID:BufferID)
								#PolyFlags: (
									if (TypeCast MatLine[2] name BufferID:BufferID) != #FORMATS_EMPTY_FLAGS then (
										local	TempFlags = (oFTypeExec MatLine #NameArray IDMask:#{2..MatLine.Count} BufferID:BufferID),
												FlagID,
												BitSet = Bit.Set
										for Flag in TempFlags do (
											FlagID = (QuickSearch KnownPolyFlags Flag)
											if FlagID != 0 then
												PolyFlags = (BitSet PolyFlags FlagID true)
											else (
												GIMS.Core.SystemMgr.AddResult #Error  (
													GIMS.Core.ValueOps.FormatText \
														v1:"Unknown flag \"" \
														v2:Flag \
														v3:"\" in object \"" \
														v4:ObjName \
														v5:"\" found at " \
														v6:(BufferMgr.GetErrorInfo BufferID) \
												)
												Result = false;
											)
										)
									)
								)
								#MaterialColorIndex:
									MaterialColorIndex = (TypeCast MatLine[2] Integer BufferID:BufferID)
								default: (
									GIMS.Core.SystemMgr.AddResult #Error  (
										FormatText \
											v1:"Unknown Material tag \"" \
											v2:MatLine[1] \
											v3:"\" in file \"" \
											v4:DiskPathWithObjName \
											v5:Extension \
											v6:"\" found at " \
											v7:(BufferMgr.GetErrorInfo BufferID) \
									)
									Result = false
								)
							)
						)
						if not Result then
							Skip BufferID 1 /*skip end*/
						Append Materials #(Mat_Index, PolyFlags, MaterialColorIndex, ProcId, RoomId, PedDensity)
					)
					#VertexColors: (
						local	param2 = tLine[2]
						if (TypeCast param2 Name BufferID:BufferID) != #null then (
							local	count = (TypeCast param2 Integer BufferID:BufferID)
							VertexColors = #()
							VertexColors.Count = count
							Skip BufferID 1 /*skip start*/
							for i = 1 to count do
								VertexColors[i] = ((oFTypeExec (ReadVal BufferID) #P4 BufferID:BufferID) / 255)
							Skip BufferID 1 /*skip end*/
						)
					)
					#MaterialColors: (
						local	param2 = tLine[2]
						if (TypeCast param2 Name BufferID:BufferID) != #null then (
							local	count = (TypeCast param2 Integer BufferID:BufferID)
							if (count != 0) then (
								MaterialColors = #()
								MaterialColors.Count = count
								Skip BufferID 1 /*skip start*/
								for i = 1 to count do
									MaterialColors[i] = (oFTypeExec (ReadVal BufferID) #Color BufferID:BufferID)
								Skip BufferID 1 /*skip end*/
							)
						)
					)
					#Children: (
						Skip BufferID 1 /*skip start*/
						Children.Count = (TypeCast tLine[2] Integer BufferID:BufferID)
						local	ChildIndex = 1,
								ChildDiskPathWithObjName = (
									FormatText \
										v1:DiskPathWithObjName \
										v2:"." \
										v3:ObjName
								),
								HaveOKChildren = false,
								ChildOK = true
						while
							ChildOK and
							(ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] != "}"
						do (
							local	NewItem = (grcPhBound DiskPath:ChildDiskPathWithObjName ObjName:(ChildIndex as String))
							if (
								NewItem.Read BufferID:BufferID \
									ReportProgress:ReportProgress \
									BufferMgr:BufferMgr \
									DiskPathWithObjName:ChildDiskPathWithObjName \
									Skip:Skip \
									ReadVal:ReadVal \
									TypeCast:TypeCast \
									oFTypeExec:oFTypeExec \
									GetProgress:GetProgress \
									UpdateProgress:UpdateProgress \
									FormatText:FormatText \
									NotEOF:NotEOF \
									grcPhBound:grcPhBound \
									ValueOps:ValueOps \
									AppendMHL:AppendMHL \
									FetchMHL:FetchMHL \
									QuickSearch:QuickSearch \
									ObjectNames:ObjectNames \
									NoCaseOrderComparator:NoCaseOrderComparator \
									UpdateMatrix:UpdateMatrix
							) then (
								HaveOKChildren = true
								Children[ChildIndex] = NewItem
							) else
								ChildOK = false
							ChildIndex += 1
						)
						if not HaveOKChildren then
							Result = false
						Skip BufferID 1 /*skip end*/
					)
					default: (
						GIMS.Core.SystemMgr.AddResult #Error  (
							FormatText \
								v1:"Unknown PhBound tag \"" \
								v2:tLine[1] \
								v3:"\" in file \"" \
								v4:DiskPathWithObjName \
								v5:Extension \
								v6:"\" found at " \
								v7:(BufferMgr.GetErrorInfo BufferID) \
						)
						Result = false
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BufferID, #tLine, #DiskPath, #ObjName, #Extension, #DiskPathWithObjName), #(BufferID, tLine, DiskPath, ObjName, Extension, DiskPathWithObjName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID:unsupplied \
			ReportProgress:true \
			BufferMgr:unsupplied \
			DiskPathWithObjName:unsupplied \
			Skip:unsupplied \
			ReadVal:unsupplied \
			TypeCast:unsupplied \
			oFTypeExec:unsupplied \
			GetProgress:unsupplied \
			UpdateProgress:unsupplied \
			FormatText:unsupplied \
			NotEOF:unsupplied \
			grcPhBound:unsupplied \
			ValueOps:unsupplied \
			AppendMHL:unsupplied \
			FetchMHL:unsupplied \
			QuickSearch:unsupplied \
			ObjectNames:unsupplied \
			NoCaseOrderComparator:unsupplied \
			UpdateMatrix:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Separate = false,
						Result = true
				if not Supplied ValueOps then (
					local	StringOps = GIMS.Core.StringOps,
							ArrayOps = GIMS.Core.ArrayOps
					ValueOps = GIMS.Core.ValueOps
					grcPhBound = GIMS.CurrentGame.Core.TypeLibrary.grcPhBound
					BufferMgr = GIMS.Core.BufferMgr
					TypeCast = ValueOps.TypeCast
					UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					FormatText = ValueOps.FormatText
					UpdateMatrix = ValueOps.UpdateMatrix
					Skip = BufferMgr.Skip
					ReadVal = BufferMgr.ReadVal
					oFTypeExec = StringOps.oFTypeExec
					GetProgress = BufferMgr.GetProgress
					NotEOF = BufferMgr.NotEOF
					AppendMHL = ArrayOps.AppendMHL
					FetchMHL = ArrayOps.FetchMHL
					QuickSearch = ArrayOps.QuickSearch
					NoCaseOrderComparator = StringOps.NoCaseOrderComparator
					ObjectNames = GIMS.CurrentGame.Core.DB.ObjectNames
				)
				if not Supplied DiskPathWithObjName then
					DiskPathWithObjName = (DiskPath + ObjName)
				if not Supplied BufferID then (
					BufferID = (BufferMgr.ReadFile (DiskPathWithObjName + Extension) Mode:#TxtLines)
					Separate = true
				)
				if BufferID == false then
					Result = false
				else (
					local	ObjHash = (
						try
							(ObjName + "L") as Integer64
						catch
							undefined
					)
					if Have ObjHash then
						ObjName = (FetchMHL ObjectNames ObjHash)
					else
						AppendMHL ObjectNames ObjName
					local	tLine
					while
						Result and
						(NotEOF BufferID) and
						(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
					do (	/*skips end*/
						if ReportProgress then
							UpdateProgress #Progress (GetProgress BufferID)
						else
							UpdateProgress #None 0
						Result = (
							ParseTag BufferID tLine \
								BufferMgr \
								DiskPathWithObjName \
								Skip \
								ReadVal \
								TypeCast \
								oFTypeExec \
								GetProgress \
								UpdateProgress \
								ReportProgress \
								FormatText \
								NotEOF \
								grcPhBound \
								ValueOps \
								AppendMHL \
								FetchMHL \
								QuickSearch \
								ObjectNames \
								NoCaseOrderComparator \
								UpdateMatrix
						)
					)
					if Separate then
						BufferMgr.ClearBuffer BufferID
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #DiskPathWithObjName, #Type), #(DiskPath, ObjName, Extension, DiskPathWithObjName, Type)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _WriteMaterial BufferID Mtl TabString WriteVal FormatText TypeCast Index:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Supplied Index then
					WriteVal BufferID (FormatText v1:TabString v2:"Material " v3:(Index - 1))
				else
					WriteVal BufferID (TabString + "Material")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (FormatText v1:TabString v2:"\tMaterialIndex " v3:(TypeCast (Mtl[1] - 1) Integer BufferID:BufferID))
				WriteVal BufferID (FormatText v1:TabString v2:"\tProcId " v3:(TypeCast Mtl[4] Integer BufferID:BufferID))
				WriteVal BufferID (FormatText v1:TabString v2:"\tRoomId " v3:(TypeCast Mtl[5] Integer BufferID:BufferID))
				WriteVal BufferID (FormatText v1:TabString v2:"\tPedDensity " v3:(TypeCast Mtl[6] Integer BufferID:BufferID))
				local	ToHighReg = GIMS.Core.StringOps.ToHighReg,
						PolyFlags = Mtl[2],
						BitGet = Bit.Get,
						FlagWritten = false
				WriteVal BufferID (TabString + "\tPolyFlags")
				for i = 1 to KnownPolyFlags.Count where (BitGet PolyFlags i) do (
					WriteVal BufferID (" " + (ToHighReg (KnownPolyFlags[i] as String))) AppendLast:true
					FlagWritten = true
				)
				if not FlagWritten then
					WriteVal BufferID " FORMATS_EMPTY_FLAGS" AppendLast:true
				WriteVal BufferID (FormatText v1:TabString v2:"\tMaterialColorIndex " v3:(TypeCast Mtl[3] Integer BufferID:BufferID))
				WriteVal BufferID (TabString + "}")
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Mtl), #(Mtl)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write \
			BufferID:unsupplied \
			BaseTabString:"" \
			NoCaseOrderComparator:unsupplied \
			ToHighReg:unsupplied \
			BufferMgr:unsupplied \
			WriteVal:unsupplied \
			ValueOps:unsupplied \
			FormatText:unsupplied \
			AsoFText:unsupplied \
			TypeCast:unsupplied \
			UpdateProgress:unsupplied \
			ArrayOps:unsupplied \
			Modify:unsupplied \
			ReportProgress:true \
			Progress:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No Type then
					throw "No type assigned to phBound " ObjName
				if not Supplied BufferMgr then (
					BufferMgr = GIMS.Core.BufferMgr
					WriteVal = BufferMgr.WriteVal
					ValueOps = GIMS.Core.ValueOps
					FormatText = ValueOps.FormatText
					AsoFText = ValueOps.AsoFText
					TypeCast = ValueOps.TypeCast
					UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					ArrayOps = GIMS.Core.ArrayOps
					Modify = ArrayOps.Modify
					local	StringOps = GIMS.Core.StringOps
					NoCaseOrderComparator = StringOps.NoCaseOrderComparator
					ToHighReg = StringOps.ToHighReg
				)
				local	IsComposite = (Type == #BoundComposite),
						FilePath
				if ReportProgress then (
					if not Supplied Progress then (
						Progress = (
							if IsComposite then
								[0, 0, 4 + Children.Count * 4]
							else
								[0, 0, 4]
						)
					)
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				local	IsSeparate = (not Supplied BufferID),
						TypeString = (ArrayOps.FetchMHL KnownTypes Type ReturnHashOnFail:false KeyValueItemIDs:[1, 2] Comparator:NoCaseOrderComparator)
				if No TypeString then
					EGIMS_EHAbort "Unknown phBound Type " Param1:Type BufferID:BufferID
				if IsSeparate then (
					FilePath = (
						FormatText \
							v1:DiskPath \
							v2:ObjName \
							v3:Extension
					)
					BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath)
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:(BaseTabString + "Version "))
				) else
					WriteVal BufferID (BaseTabString + "phBound")
				WriteVal BufferID (BaseTabString + "{")
				local	TabString = (BaseTabString + "\t"),
						SubTabString = (TabString + "\t"),
						SubSubTabString = (SubTabString + "\t"),
						ChildTransformsTabString = (TabString + "ChildTransforms "),
						ChildrenTabString = (TabString + "Children "),
						ChildFlagsTabString = (TabString + "ChildFlags "),
						ChildFlagsItemTabString = (SubTabString + "Item"),
						ChildFlags1TabString = (SubSubTabString + "Flags1"),
						ChildFlags2TabString = (SubSubTabString + "Flags2"),
						BlockStartTabString = (TabString + "{"),
						BlockEndTabString = (TabString + "}"),
						SubBlockStartTabString = (SubTabString + "{"),
						SubBlockEndTabString = (SubTabString + "}")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Type " \
						v3:TypeString
				)
				Bounds.Write BufferID TabString
				if Supplied Margin then
					WriteVal BufferID (FormatText v1:TabString v2:"Margin " v3:Margin)
				if Supplied CapsuleHalfHeight then
					WriteVal BufferID (FormatText v1:TabString v2:"CapsuleHalfHeight " v3:CapsuleHalfHeight)
				if Have VertexOffset then (
					WriteVal BufferID (
						FormatText \
							v1:(AsoFText VertexOffset TabString:(TabString + "GeometryCenter ")) \
							v2:" " \
							v3:(VertexOffset_UnkPart as String)
					)
				)
				local	MatCount = Materials.Count
				if MatCount != 0 then (
					if
						Type == #BoundBVH or
						Type == #BoundGeometry
					then (
						WriteVal BufferID (FormatText v1:TabString v2:"Materials " v3:MatCount)
						WriteVal BufferID (TabString + "{")
						for i = 1 to MatCount do
							_WriteMaterial BufferID Materials[i] SubTabString WriteVal FormatText TypeCast Index:i
						WriteVal BufferID (TabString + "}")
					) else
						_WriteMaterial BufferID Materials[1] TabString WriteVal FormatText TypeCast
				)
				if Supplied VertexColors then (
					WriteVal BufferID (FormatText v1:TabString v2:"VertexColors " v3:VertexColors.Count)
					WriteVal BufferID (TabString + "{")
					/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for Clr in VertexColors do
						WriteVal BufferID (AsoFText (Clr * 255) TypeHook:Integer TabString:SubTabString)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#VertexColors), #(VertexColors)))/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					WriteVal BufferID (TabString + "}")
				) else
					WriteVal BufferID (TabString + "VertexColors null")
				if Supplied MaterialColors then (
					WriteVal BufferID (FormatText v1:TabString v2:"MaterialColors " v3:MaterialColors.Count)
					WriteVal BufferID (TabString + "{")
					/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for Clr in MaterialColors do
						WriteVal BufferID (AsoFText Clr TypeHook:Integer TabString:SubTabString)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					WriteVal BufferID (TabString + "}")
				) else
					WriteVal BufferID (TabString + "MaterialColors null")
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				local	FaceCount = Faces.Count,
						PolyCount = (Primitives.Count + FaceCount)
				if PolyCount != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"Polygons " \
							v3:PolyCount
					)
					WriteVal BufferID (TabString + "{")
					local	PolyObjIndex = 0,
							TriTabString = (SubTabString + "Tri "),
							SphereTabString = (SubTabString + "Sphere "),
							BoxTabString = (SubTabString + "Box "),
							CapsuleTabString = (SubTabString + "Capsule "),
							CylinderTabString = (SubTabString + "Cylinder "),
							MaterialIndexTabString = (SubSubTabString + "MaterialIndex "),
							CenterTabString = (SubSubTabString + "Center "),
							RadiusTabString = (SubSubTabString + "Radius "),
							CenterTopTabString = (SubSubTabString + "CenterTop "),
							CenterBottomTabString = (SubSubTabString + "CenterBottom "),
							VerticesTabString = (SubSubTabString + "Vertices "),
							SiblingsTabString = (SubSubTabString + "Siblings "),
							P3Mod = [-1, -1, -1],
							SuppliedSiblings = (Supplied Siblings)
					/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for Prim in Primitives do (
						local	PrimTag = Prim[1]
						case PrimTag of (
							#Sphere: (
								WriteVal BufferID (SphereTabString + (PolyObjIndex as String))
								WriteVal BufferID SubBlockStartTabString
								WriteVal BufferID (MaterialIndexTabString + ((Prim[3] - 1) as String))
								WriteVal BufferID (CenterTabString + ((Prim[4] - 1) as String))
								WriteVal BufferID (RadiusTabString + (Prim[5] as String))
							)
							#Capsule: (
								WriteVal BufferID (CapsuleTabString + (PolyObjIndex as String))
								WriteVal BufferID SubBlockStartTabString
								WriteVal BufferID (MaterialIndexTabString + ((Prim[3] - 1) as String))
								WriteVal BufferID (CenterTopTabString + ((Prim[4] - 1) as String))
								WriteVal BufferID (CenterBottomTabString + ((Prim[5] - 1) as String))
								WriteVal BufferID (RadiusTabString + (Prim[6] as String))
							)
							#Box: (
								WriteVal BufferID (BoxTabString + (PolyObjIndex as String))
								WriteVal BufferID SubBlockStartTabString
								WriteVal BufferID (MaterialIndexTabString + ((Prim[3] - 1) as String))
								WriteVal BufferID (AsoFText (Modify Prim[4] -1 #Add) TabString:VerticesTabString)
							)
							#Cylinder: (
								WriteVal BufferID (CylinderTabString + (PolyObjIndex as String))
								WriteVal BufferID SubBlockStartTabString
								WriteVal BufferID (MaterialIndexTabString + ((Prim[3] - 1) as String))
								WriteVal BufferID (CenterTopTabString + ((Prim[4] - 1) as String))
								WriteVal BufferID (CenterBottomTabString + ((Prim[5] - 1) as String))
								WriteVal BufferID (RadiusTabString + (Prim[6] as String))
							)
							default:
								EGIMS_EHAbort "Unknown Polygon primitive tag " Param1:PrimTag BufferID:BufferID
						)
						WriteVal BufferID SubBlockEndTabString
						PolyObjIndex += 1
					)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					if SuppliedSiblings then (
						for i = 1 to FaceCount do (
							WriteVal BufferID (TriTabString + (PolyObjIndex as String))
							WriteVal BufferID SubBlockStartTabString
							WriteVal BufferID (AsoFText (Faces[i] + P3Mod) TypeHook:Integer TabString:VerticesTabString)
							WriteVal BufferID (AsoFText (Siblings[i] + P3Mod) TypeHook:Integer TabString:SiblingsTabString)
							WriteVal BufferID (MaterialIndexTabString + ((FaceMatIDs[i] - 1) as String))
							WriteVal BufferID SubBlockEndTabString
							PolyObjIndex += 1
						)
					) else (
						local	FakeSiblings = (SiblingsTabString + "-1 -1 -1")
						for i = 1 to FaceCount do (
							WriteVal BufferID (TriTabString + (PolyObjIndex as String))
							WriteVal BufferID SubBlockStartTabString
							WriteVal BufferID (AsoFText (Faces[i] + P3Mod) TypeHook:Integer TabString:VerticesTabString)
							WriteVal BufferID FakeSiblings
							WriteVal BufferID (MaterialIndexTabString + ((FaceMatIDs[i] - 1) as String))
							WriteVal BufferID SubBlockEndTabString
							PolyObjIndex += 1
						)
					)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					WriteVal BufferID (TabString + "}")
					if not SuppliedSiblings then
						WriteVal BufferID (TabString + "ComputePolyNeighbors True")
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				local	VerticesCount = Vertices.Count
				if VerticesCount != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"Vertices " \
							v3:VerticesCount
					)
					WriteVal BufferID (TabString + "{")
					/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for Vert in Vertices do
						WriteVal BufferID (AsoFText Vert TabString:SubTabString)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					WriteVal BufferID (TabString + "}")
				)
				if Supplied Shrunk then (
					local	ShrunkCount = Shrunk.Count
					if ShrunkCount != 0 then (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:"Shrunk " \
								v3:ShrunkCount
						)
						WriteVal BufferID (TabString + "{")
						/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for Vert in Shrunk do
							WriteVal BufferID (AsoFText Vert TabString:SubTabString)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						WriteVal BufferID (TabString + "}")
					)
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				if IsComposite then (
					
					local	ChildTransformsCount = ChildTransforms.Count
					if ChildTransformsCount != 0 then (
						WriteVal BufferID (AsoFText ChildTransformsCount TabString:ChildTransformsTabString)
						WriteVal BufferID (TabString + "{")
						/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for i = 1 to ChildTransformsCount do (
							WriteVal BufferID (
								FormatText \
									v1:SubTabString \
									v2:"Matrix " \
									v3:(i - 1)
							)
							WriteVal BufferID (SubTabString + "{")
							WriteVal BufferID (AsoFText ChildTransforms[i] TabString:SubSubTabString)
							WriteVal BufferID (SubTabString + "}")
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						WriteVal BufferID (TabString + "}")
					) else
						WriteVal BufferID (ChildTransformsTabString + "null")
					
					if Supplied ChildFlags then (
						local	ChildFlagsCount = ChildFlags.Count
						if ChildFlagsCount != 0 then (
							WriteVal BufferID (AsoFText ChildFlagsCount TabString:ChildFlagsTabString)
							WriteVal BufferID BlockStartTabString
							for ChildFlag in ChildFlags do (
								WriteVal BufferID ChildFlagsItemTabString
								WriteVal BufferID SubBlockStartTabString
								local	Flags1 = ChildFlag[1],
										Flags2 = ChildFlag[2],
										FlagWritten = false
								WriteVal BufferID ChildFlags1TabString
								for i = 1 to Flags1.Count where Flags1[i] do (
									WriteVal BufferID (" " + (ToHighReg (KnownChildFlags[i] as String))) AppendLast:true
									FlagWritten = true
								)
								if not FlagWritten then
									WriteVal BufferID " FORMATS_EMPTY_FLAGS" AppendLast:true
									
								FlagWritten = false
								WriteVal BufferID ChildFlags2TabString
								for i = 1 to Flags2.Count where Flags2[i] do (
									WriteVal BufferID (" " + (ToHighReg (KnownChildFlags[i] as String))) AppendLast:true
									FlagWritten = true
								)
								if not FlagWritten then
									WriteVal BufferID " FORMATS_EMPTY_FLAGS" AppendLast:true
								WriteVal BufferID SubBlockEndTabString
							)
							WriteVal BufferID BlockEndTabString
						)
					) else
						WriteVal BufferID (ChildFlagsTabString + "null")
						
					if ReportProgress then (
						Progress.x += 1
						UpdateProgress #Progress Progress
					) else
						UpdateProgress #None 0
					local	ChildrenCount = Children.Count
					if ChildrenCount != 0 then (
						WriteVal BufferID (AsoFText ChildrenCount TabString:ChildrenTabString)
						WriteVal BufferID (TabString + "{")
						/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for ChildID = 1 to ChildrenCount do (
							local Child = Children[ChildID]
							if Have Child then (
								Child.Write \
									BufferID:BufferID \
									BaseTabString:SubTabString \
									NoCaseOrderComparator:NoCaseOrderComparator \
									ToHighReg:ToHighReg \
									BufferMgr:BufferMgr \
									WriteVal:WriteVal \
									ValueOps:ValueOps \
									FormatText:FormatText \
									AsoFText:AsoFText \
									TypeCast:TypeCast \
									UpdateProgress:UpdateProgress \
									ArrayOps:ArrayOps \
									Modify:Modify \
									ReportProgress:ReportProgress \
									Progress:Progress
							) else
								WriteVal BufferID (SubTabString + "phBound null")
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/				
						WriteVal BufferID (TabString + "}")
					) else
						WriteVal BufferID (ChildrenTabString + "null")
				)
				WriteVal BufferID (BaseTabString + "}")
				if IsSeparate then (
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#DiskPath,
					#ObjName,
					#Type,
					#Margin,
					#Shrunk,
					#FaceMatIDs,
					#Faces,
					#Siblings,
					#Primitives,
					#Vertices,
					#VertexOffset,
					#VertexOffset_UnkPart,
					#Materials,
					#VertexColors,
					#MaterialColors,
					#CapsuleHalfHeight,
					#ChildFlags,
					#Children,
					#ChildTransforms
				), #(
					DiskPath,
					ObjName,
					Type,
					Margin,
					Shrunk,
					FaceMatIDs,
					Faces,
					Siblings,
					Primitives,
					Vertices,
					VertexOffset,
					VertexOffset_UnkPart,
					Materials,
					VertexColors,
					MaterialColors,
					CapsuleHalfHeight,
					ChildFlags,
					Children,
					ChildTransforms
				)
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _GetCylinderDimensions = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	AABB = Bounds.AABB,
						AABBMax = AABB.bMax,
						AABBMin = AABB.bMin,
						lx = (AABBMax.x - AABBMin.x),
						ly = (AABBMax.y - AABBMin.y),
						lz = (AABBMax.z - AABBMin.z),
						IsEq_lxly = (lx == ly),
						Radius, Height
				if
					IsEq_lxly or
					(lx == lz)
				then (
					Radius = (lx / 2)
					if
						(not IsEq_lxly) and
						(ly != lz)
					then
						Height = ly
					else
						Height = lz
				) else (
					Radius = (ly / 2)
					Height = lx
				)
				[Radius, Height]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _CalculateBoxVector Centroid v0 v2 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				(Normalize ((v0 + ((v2 - v0) / 2)) - Centroid))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _GetBoxPlacementFromDiagonals VertIndices = (
		--fn _GetBoxPlacementFromDiagonals VertIndices PrimName = (	--<TODO> remove, debug
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	v0 = Vertices[VertIndices[1]],
						v1 = Vertices[VertIndices[2]],
						v2 = Vertices[VertIndices[3]],
						v3 = Vertices[VertIndices[4]],
						
						BoxVector = (((v0 + v3) / 2) - ((v1 + v2) / 2)),
						tv0 = (v0 - BoxVector),
						tv1 = (v1 + BoxVector),
						tv3 = (v3 - BoxVector),
						
						Centroid = ((v2 + tv1) / 2),
						
						UpNormal = (_CalculateBoxVector Centroid v1 v0),
						FrontNormal = (_CalculateBoxVector Centroid v2 v1),
						RightNormal = (_CalculateBoxVector Centroid tv3 tv1),
						
						H = (Distance v2 tv0),
						W = (Distance tv0 v1),
						L = (Distance tv3 v3)
						
				if W > H then (
					Swap H W
					Swap UpNormal RightNormal
				)
				if L > W then (
					Swap L W
					Swap FrontNormal RightNormal
				)
				if W > H then (
					Swap H W
					Swap UpNormal RightNormal
				)
				local	BaseNormal = UpNormal,
						BaseRotateNormal = RightNormal,
						CheckingNormal = FrontNormal
				
				/*RESTORE VECTORS*		
				local	VecDiff_UF = (Dot UpNormal FrontNormal),
						VecDiff_UR = (Dot UpNormal RightNormal),
						VecDiff_FR = (Dot FrontNormal RightNormal),
						Compare = GIMS.Core.ValueOps.Compare,
						AreBaseVecs_UF = (Compare VecDiff_UF 0.0 MaxDiff:0.01),
						AreBaseVecs_UR = (Compare VecDiff_UR 0.0 MaxDiff:0.01),
						AreBaseVecs_FR = (Compare VecDiff_FR 0.0 MaxDiff:0.01)
				Format "%:\n\tUF UR FR	% % %	% % %\n" PrimName AreBaseVecs_UF AreBaseVecs_UR AreBaseVecs_FR VecDiff_UF VecDiff_UR VecDiff_FR	--<TODO> remove, debug
				for i = 1 to 2 while
					not AreBaseVecs_UF or
					not AreBaseVecs_UR or
					not AreBaseVecs_FR
				do (
					if
						(
							not AreBaseVecs_UF or
							not AreBaseVecs_UR
						) and
						AreBaseVecs_FR
					then (
						UpNormal = (Cross RightNormal FrontNormal)
						AreBaseVecs_UF = true
						AreBaseVecs_UR = true
					)
					if
						(
							not AreBaseVecs_UF or
							not AreBaseVecs_FR
						) and
						AreBaseVecs_UR
					then (
						FrontNormal = (Cross UpNormal RightNormal)
						AreBaseVecs_UF = true
						AreBaseVecs_FR = true
					)
					if
						(
							not AreBaseVecs_UR or
							not AreBaseVecs_FR
						) and
						AreBaseVecs_UF
					then (
						RightNormal = (Cross FrontNormal UpNormal)
						AreBaseVecs_UR = true
						AreBaseVecs_FR = true
					)
					Format "\tUF UR FR	% % %	% % %\n" AreBaseVecs_UF AreBaseVecs_UR AreBaseVecs_FR (Dot UpNormal FrontNormal) (Dot UpNormal RightNormal) (Dot FrontNormal RightNormal)	--<TODO> remove, debug
				)
				/**/
				
				local	NormalTrans = (MatrixFromNormal BaseNormal),
						ModAngle = (((EulerAngles 0 90 0) as Quat) * NormalTrans),
						RotatedUpNormal = (Normalize (BaseNormal * ModAngle)),
						AngleDiff = ACos(Dot RotatedUpNormal BaseRotateNormal),
						RotPlusTrans = ((RotateZMatrix AngleDiff) * NormalTrans),
						RotMinusTrans = ((RotateZMatrix (-AngleDiff)) * NormalTrans),
						RotPlusDistance = (Length (Cross CheckingNormal ([0, 1, 0] * RotPlusTrans))),
						RotMinusDistance = (Length (Cross CheckingNormal ([0, 1, 0] * RotMinusTrans))),
						ResultTrans = (
							if RotPlusDistance < RotMinusDistance then
								RotPlusTrans
							else
								RotMinusTrans
						)
				ResultTrans.Position = Centroid
				#(L, W, H, ResultTrans)
				--#(L, W, H, ResultTrans, Centroid, BaseNormal, BaseRotateNormal, CheckingNormal, v0, v1, v2 ,v3, tv0, tv1, tv3, UpNormal, FrontNormal, RightNormal, [UpVec[1], UpVec[2], UpVec[3]], [FrontVec[1], FrontVec[2], FrontVec[3]], [RightVec[1], RightVec[2], RightVec[3]])	--<TODO> remove, debug
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true Progress:unsupplied IsSeparate:true \
			UpdateProgress:unsupplied \
			ObjectMgr:unsupplied \
			NodeChildFlags:unsupplied \
			CreateIfUnique:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not Supplied ObjectMgr then (
					UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					ObjectMgr = GIMS.Core.ObjectMgr
					CreateIfUnique = ObjectMgr.CreateIfUnique
				)
				if
					ReportProgress and
					not Supplied Progress
				then
					Progress = [0, 0, GetCreateProgressStepCount ObjectMgr]
				local	ParentTM = (
							--if IsSeparate then (
								if ParentNode == RootNode then
									(Matrix3 1)
								else
									ParentNode.Transform
							--)
						),
						TargetPos = (
							if
								Have Bounds.Centroid and
								Type != #BoundComposite and
								Type != #BoundBVH and
								Type != #BoundGeometry
							then
								Bounds.Centroid
							else
								[0, 0, 0]
						)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				local	Result,
						ParamHolder = unsupplied
				/*TODO remove, debug*	LogProfiler #PlainInfo "Collision" AddParam:#(Type, ObjName)	/**/
				case Type of (
					#BoundComposite: (
						local	ChildrenCount = Children.Count,
								HaveChildFlags = (Supplied ChildFlags),
								ChildFlagCount = (if HaveChildFlags then ChildFlags.Count)
						Result = (CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_Col_Composite)
						Result.UseChildFlags = HaveChildFlags
						if ReportProgress then (
							Progress.x += 1
							UpdateProgress #Progress Progress
						) else
							UpdateProgress #None 0
							
						for ChildID = 1 to ChildrenCount where Have Children[ChildID] do (
							if ReportProgress then (
								Progress.x += 1
								UpdateProgress #Progress Progress
							) else
								UpdateProgress #None 0
							local	TempChildSource = Children[ChildID]
							if Have TempChildSource then (
								local	TempChild = (
											TempChildSource.Create \
												Result \
												ReportProgress:ReportProgress \
												Progress:Progress \
												IsSeparate:true \
												UpdateProgress:UpdateProgress \
												ObjectMgr:ObjectMgr \
												CreateIfUnique:CreateIfUnique \
												NodeChildFlags:(if HaveChildFlags then ChildFlags[ChildID] else unsupplied)
										)
								TempChild.Transform = (ChildTransforms[ChildID] * ParentTM)
								if TempChildSource.Type == #Plane then
									TempChild.Dir = (TempChildSource.CenterOfMass * ParentTM)
							)
						)
					)
					#BoundPlane: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Plane)
						local	CenterOfMass = Bounds.CenterOfMass
						if Supplied CenterOfMass then
							Result.Dir = CenterOfMass
					)
					#BoundBox: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Box)
						local	AABB = Bounds.AABB,
								bMin = AABB.bMin,
								bMax = AABB.bMax
						Result.SuspendMeshBuilding()
						Result.Width = (bMax.x - bMin.x)
						Result.Depth = (bMax.y - bMin.y)
						Result.Height = (bMax.z - bMin.z)
						Result.ResumeMeshBuilding()
					)
					#BoundSphere: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Sphere)
						Result.Radius = Bounds.Radius
					)
					#BoundCapsule: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Capsule)
						Result.CapsuleHalfHeight = CapsuleHalfHeight
						Result.SuspendMeshBuilding()
						Result.Radius = Margin
						Result.Height = ((Bounds.Radius - Margin) * 2)
						Result.ResumeMeshBuilding()
					)
					#BoundDisc: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Disc)
						local	CylinderDimensions = (_GetCylinderDimensions())
						Result.SuspendMeshBuilding()
						Result.Radius = CylinderDimensions.x
						Result.Height = CylinderDimensions.y	--or (Margin * 2)
						Result.ResumeMeshBuilding()
					)
					#BoundCylinder: (
						Result = (CreateIfUnique ObjName AllowSearch:false ParentNode:ParentNode NodeType:EGIMS_V_Col_Cylinder)
						local	CylinderDimensions = (_GetCylinderDimensions())
						Result.SuspendMeshBuilding()
						Result.Radius = CylinderDimensions.x
						Result.Height = CylinderDimensions.y
						Result.ResumeMeshBuilding()
					)
					default: (
						local	IsBVH = (Type == #BoundBVH)
						if
							IsBVH or
							(Type == #BoundGeometry)
						then (
							GIMS.Core.ArrayOps.Modify Vertices VertexOffset #Add CopyArray:false
							Result = (
								ObjectMgr.CreateMesh \
									Vertices \
									Faces \
									ObjName:ObjName \
									VertColors:VertexColors \
									MaterialIDs:FaceMatIDs \
									SG:#Remove \
									Parent:ParentNode \
									Progress:Progress
							)
							
							/*<TODO> remove this block, shrunk test import*
							
							if Supplied Shrunk then (
								GIMS.Core.ArrayOps.Modify Shrunk VertexOffset #Add CopyArray:false
								local	ShrinkVecs = unsupplied,
										ShrunkCount = Shrunk.Count,
										VertCount = Vertices.Count,
										Normals = #()
								for i = VertCount to 1 by -1 do
									Normals[i] = [0, 0, 0]
								
								--collect normals and face centers
								EGIMS_ResumeMAX()
								OldSelection = (Selection as Array)
								Select Result
								MAX Modify Mode
								local	NormalsMod = (Edit_Normals())
								AddModifier Result NormalsMod
								EGIMS_SelectModifier NormalsMod
								local	NMGetNormalID = NormalsMod.GetNormalID,
										NMGetNormal = NormalsMod.GetNormal,
										NMGetFaceDegree = NormalsMod.GetFaceDegree,
										ShrunkFaceOffsets = #()
								for FaceID = Faces.Count to 1 by -1 do (
									local	Face = Faces[FaceID],
											FaceDegree = (NMGetFaceDegree FaceID),
											NormalFaceCenter = [0, 0, 0],
											ShrunkFaceCenter = [0, 0, 0]
									for CornerID = FaceDegree to 1 by -1 do (
										local	NormID = (NMGetNormalID FaceID CornerID),
												VertID = Face[CornerID]
										NormalFaceCenter += Vertices[VertID]
										ShrunkFaceCenter += Shrunk[VertID]
										Normals[VertID] += (NMGetNormal NormID)
									)
									ShrunkFaceOffsets[FaceID] = (Distance (NormalFaceCenter / 3) (ShrunkFaceCenter / 3))
								)
								DeleteModifier Result NormalsMod
								Sort ShrunkFaceOffsets
								Format "Sorted shrunk face center offsets:\t[%..%]\t%\n" ShrunkFaceOffsets[1] ShrunkFaceOffsets[ShrunkFaceOffsets.Count] ShrunkFaceOffsets
								
								--create normal vectors and fix normal data
								local	tLine = (SplineShape Name:"VertNormals" Parent:Result WireColor:Blue),
										SplineCount = 0
								for i = 1 to VertCount do (
								
									--fix normal data
									local	Normal = (Normalize (Normals[i] / 3))
									Normals[i] = Normal
									
									--add line
									AddNewSpline tLine
									SplineCount += 1
									local	BasePoint = Vertices[i]
									AddKnot tLine SplineCount #Corner #Line BasePoint
									AddKnot tLine SplineCount #Corner #Line (BasePoint + (Normal * 0.02))
								)
								UpdateShape tLine
								
								--print minimum vertex distances
								local	MinDist = (Distance Result.Max Result.Min)
								for i = 1 to (VertCount - 1) do (
									for j = (i + 1) to VertCount do (
										local	Dist = (Distance Vertices[i] Vertices[j])
										if Dist < MinDist then
											MinDist = Dist
									)
								)
								Format "Minimum mesh intervertex distance is\t%\n" MinDist
								local	MinDist = (Distance Result.Max Result.Min)
								for i = 1 to (ShrunkCount - 1) do (
									for j = (i + 1) to ShrunkCount do (
										local	Dist = (Distance Shrunk[i] Shrunk[j])
										if Dist < MinDist then
											MinDist = Dist
									)
								)
								Format "Minimum shrunk intervertex distance is\t%\n" MinDist
										
								--print data
								if ShrunkCount == VertCount then (
									Format "Vertex\tShrunk\tShrinkVec\tNormal\tLenShrinkVec\tLenNormal\n"
									ShrinkVecs = #()
									ShrinkVecs.Count = ShrunkCount
									for i = 1 to ShrunkCount do (
										local	v = Vertices[i],
												s = Shrunk[i],
												n = Normals[i],
												sv = (v - s),
												lsv = (Length sv),
												ln = (Length n)
										ShrinkVecs[i] = sv
										Format "%\t%\t%\t%\t%\t%\n" \
											(FormattedPrint v Format:"0.4f") \
											(FormattedPrint s Format:"0.4f") \
											(FormattedPrint sv Format:"0.4f") \
											(FormattedPrint n Format:"0.4f") \
											(FormattedPrint lsv Format:"0.4f") \
											(FormattedPrint ln Format:"0.4f") \
									)
								) else
									Format "Shrunk count % != Vertex count %\n" ShrunkCount VertCount
								
								--create shrunk mesh
								Result.XRay = true
								local	ShrunkMesh = (
											ObjectMgr.CreateMesh \
												Shrunk \
												Faces \
												ObjName:"Shrunk" \
												VertColors:VertexColors \
												MaterialIDs:FaceMatIDs \
												VertTangents:ShrinkVecs \
												TangentLenMult:1 \
												SG:#Remove \
												Parent:Result
										)
								
							) else (
								if ReportProgress then (
									Progress.x += ObjectMgr.CreateMesh_ProgressStepCount
									UpdateProgress #Progress Progress
								) else
									UpdateProgress #None 0
							)
							
							/**/
							
							ParamHolder = (EGIMS_V_CollisionMesh Type:(Ternary IsBVH 1 2) VertexOffset_UnkPart:VertexOffset_UnkPart)
							AddModifier Result ParamHolder
							
							--create primitives
							local	TypeCast = GIMS.Core.ValueOps.TypeCast,
									CurrentProgress
							if ReportProgress then
								CurrentProgress = Progress.x
							for Prim in Primitives do (
								if ReportProgress then (
									local	ProgressX = (Progress.x += 1)
									if (ProgressX - CurrentProgress) >= 50 then (
										CurrentProgress = ProgressX
										UpdateProgress #Progress Progress
									)
								) else
									UpdateProgress #None 0
								local	PrimType = (TypeCast Prim[1] name BufferID:BufferID)
								/*TODO remove, debug*	LogProfiler #PlainInfo "\tPrimitive" AddParam:Prim	/**/
								case PrimType of (
									#Sphere: (
										local	PrimObj = (CreateIfUnique Prim[2] AllowSearch:false ParentNode:Result NodeType:EGIMS_V_Col_PrimSphere)
										PrimObj.Pos = Vertices[Prim[4]]
										PrimObj.SuspendMeshBuilding()
										PrimObj.MtlID = Prim[3]
										PrimObj.Radius = Prim[5]
										PrimObj.ResumeMeshBuilding()
									)
									#Capsule: (
										local	PrimObj = (CreateIfUnique Prim[2] AllowSearch:false ParentNode:Result NodeType:EGIMS_V_Col_PrimCapsule),
												TopVert = Vertices[Prim[4]],
												BottomVert = Vertices[Prim[5]],
												Dir = (BottomVert - TopVert)
										PrimObj.Pos = (BottomVert - (Dir / 2))
										PrimObj.Dir = Dir
										PrimObj.SuspendMeshBuilding()
										PrimObj.MtlID = Prim[3]
										PrimObj.Height = (Distance TopVert BottomVert)
										PrimObj.Radius = Prim[6]
										PrimObj.ResumeMeshBuilding()
									)
									#Box: (
										local	PrimObj = (CreateIfUnique Prim[2] AllowSearch:false ParentNode:Result NodeType:EGIMS_V_Col_PrimBox),
												BoxData = (_GetBoxPlacementFromDiagonals Prim[4])
												--BoxData = (_GetBoxPlacementFromDiagonals Prim[4] PrimObj.Name)	--<TODO> remove, debug
										PrimObj.Transform = BoxData[4]
										PrimObj.SuspendMeshBuilding()
										PrimObj.MtlID = Prim[3]
										PrimObj.Depth = BoxData[1]
										PrimObj.Width = BoxData[2]
										PrimObj.Height = BoxData[3]
										PrimObj.ResumeMeshBuilding()
										
										/*<TODO> remove, debug*
										GeoSphere Name:"v0"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:Vertices[Prim[4][1]]					WireColor:Red
										GeoSphere Name:"v1"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:Vertices[Prim[4][2]]					WireColor:Green
										GeoSphere Name:"v2"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:Vertices[Prim[4][3]]					WireColor:Blue
										GeoSphere Name:"v3"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:Vertices[Prim[4][4]]					WireColor:White
										/**/
										
										/*<TODO> remove, debug*
										GeoSphere Name:"Center"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[5]					WireColor:White
										GeoSphere Name:"Base" 				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[6] + BoxData[5])		WireColor:Blue
										GeoSphere Name:"BaseRotate"			Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[7] + BoxData[5])		WireColor:Green
										GeoSphere Name:"Checking"			Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[8] + BoxData[5])		WireColor:Red
										
										GeoSphere Name:"Up" 				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[16] + BoxData[5])	WireColor:Blue
										GeoSphere Name:"Front"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[17] + BoxData[5])	WireColor:Green
										GeoSphere Name:"Right"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[18] + BoxData[5])	WireColor:Red
										
										GeoSphere Name:"UpVec" 				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[19] + BoxData[5])	WireColor:Blue
										GeoSphere Name:"FrontVec"			Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[20] + BoxData[5])	WireColor:Green
										GeoSphere Name:"RightVec"			Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:(BoxData[21] + BoxData[5])	WireColor:Red
										
										/**/
										
										/*<TODO> remove, debug*
										GeoSphere Name:"v0"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[9]					WireColor:Yellow
										GeoSphere Name:"v1"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[10]					WireColor:Yellow
										GeoSphere Name:"v2"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[11]					WireColor:Yellow
										GeoSphere Name:"v3"					Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[12]					WireColor:Yellow
										GeoSphere Name:"tv0"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[13]					WireColor:Yellow
										GeoSphere Name:"tv1"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[14]					WireColor:Yellow
										GeoSphere Name:"tv3"				Radius:0.05 Parent:PrimObj	Segs:1 BaseType:1 Pos:BoxData[15]					WireColor:Yellow
										/**/
										
									)
									#Cylinder: (
										local	PrimObj = (CreateIfUnique Prim[2] AllowSearch:false ParentNode:Result NodeType:EGIMS_V_Col_PrimCylinder),
												TopVert = Vertices[Prim[4]],
												BottomVert = Vertices[Prim[5]],
												Dir = (TopVert - BottomVert)
										PrimObj.Pos = (BottomVert + (Dir / 2))
										PrimObj.Dir = Dir
										PrimObj.SuspendMeshBuilding()
										PrimObj.MtlID = Prim[3]
										PrimObj.Height = (Distance TopVert BottomVert)
										PrimObj.Radius = Prim[6]
										PrimObj.ResumeMeshBuilding()
									)
									default:
										EGIMS_EHAbort "Unknown Primitive type: " Param1:Prim[1] BufferID:BufferID
								)
							)
							
							--delete unused verts
							local	UnusedVerts = #{}
							for i = Vertices.Count to 1 by -1 do
								UnusedVerts[i] = true
							UnusedVerts.Count = Vertices.Count
							for Face in Faces do (
								for i = 1 to 3 do
									UnusedVerts[Face[i]] = false
							)
							if UnusedVerts.NumberSet != 0 then
								MeshOp.DeleteVerts Result UnusedVerts
							Free UnusedVerts
						) else
							EGIMS_EHAbort "Unknown phBound type: " Param1:Type BufferID:BufferID
					)
				)
				if Have Result then (
					--if IsSeparate then (
						Result.Name = ObjName
						Result.Pos = (TargetPos * ParentTM)
					--)
					
					--apply childflags
					/*
					Select Result
					MAX Modify Mode
					local	mod = modPanel.getCurrentObject()
					MAX Create Mode
					ClearSelection()
					*/
					if not Supplied ParamHolder then
						ParamHolder = Result
					if Supplied NodeChildFlags then (
						ParamHolder.Flags1 = NodeChildFlags[1]
						ParamHolder.Flags2 = NodeChildFlags[2]
					)
					--set material
					if Type != #BoundComposite then (
						local	MaterialCount = Materials.Count,
								MaterialList = #(),
								MaterialIDList = #(),
								MaterialNameList = #(),
								DBMaterialNames = GIMS.CurrentGame.Core.DB.Materials[1],
								UpdateMatrix = GIMS.Core.ValueOps.UpdateMatrix
						for i = MaterialCount to 1 by -1 do (
							local	MaterialData = Materials[i],
									MatIndex = MaterialData[1],
									MtlName = DBMaterialNames[MatIndex],
									Mtl = (EGIMS_V_Material Name:MtlName ShowInViewport:true),
									Opacity = 100,
									MaterialColorIndex = MaterialData[3],
									HaveColorFlag = 0
							if
								(Supplied MaterialColors) and
								(MaterialColorIndex != 0)
							then (
								local	Clr = MaterialColors[MaterialColorIndex]
								Mtl.CollisionData = (UpdateMatrix Mtl.CollisionData 1 (TypeCast Clr Point3 BufferID:BufferID))
								Opacity = Clr.a
								HaveColorFlag = 1
							)
							Mtl.CollisionData = (UpdateMatrix Mtl.CollisionData 2 [Opacity, MatIndex, HaveColorFlag])
							Mtl.CollisionData = (UpdateMatrix Mtl.CollisionData 3 [MaterialData[2], MaterialData[4], MaterialData[5]])
							MaterialList[i] = Mtl
							MaterialIDList[i] = i
							MaterialNameList[i] = MtlName
						)
						local	Mtl = (
									MultiMaterial \
										Name:ObjName \
										MaterialList:MaterialList \
										MaterialIDList:MaterialIDList \
										Names:MaterialNameList
								)
						Result.Material = Mtl
						Result.Children.Material = Mtl
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #Type), #(DiskPath, ObjName, Extension, Type)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcPhBoundDictionary*/ strPhBoundDictionary (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcPhBoundDictionary",
		DiskPath,
		ObjName,
		Extension = ".obd",
		Version = [43, 31],
		Items = #(),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#CachePath), #(CachePath)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read ReportProgress:true CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = true,
						tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						NotEOF = BufferMgr.NotEOF,
						StringOps = GIMS.Core.StringOps,
						oFTypeExec = StringOps.oFTypeExec,
						NoCaseOrderComparator = StringOps.NoCaseOrderComparator,
						ValueOps = GIMS.Core.ValueOps,
						UpdateMatrix = ValueOps.UpdateMatrix,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						\
						grcPhBound = GIMS.CurrentGame.Core.TypeLibrary.grcPhBound,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ArrayOps = GIMS.Core.ArrayOps,
						AppendMHL = ArrayOps.AppendMHL,
						FetchMHL = ArrayOps.FetchMHL,
						QuickSearch = ArrayOps.QuickSearch,
						ObjectNames = GIMS.CurrentGame.Core.DB.ObjectNames,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						)
				local	ObjHash = (
					try
						(ObjName + "L") as Integer64
					catch
						undefined
				)
				if Have ObjHash then
					ObjName = (FetchMHL ObjectNames ObjHash)
				else
					AppendMHL ObjectNames ObjName
				if BufferID == false then
					Result = false
				else (
					local	ItemCount = 0
					Items.Count = 20
					while
						Result and
						(NotEOF BufferID) and
						(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
					do ( /* skips end */
						local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
						case Tag of (
							#Version: (
								if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
									GIMS.Core.SystemMgr.AddResult #Error  (
										FormatText \
											v1:"Wrong version resource \"" \
											v2:DiskPath \
											v3:ObjName \
											v4:Extension \
											v5:"\""
									)
									Result = false
								)
								Skip BufferID 1 /* skip dict start */
							)
							Default: (
								local	SubPath = tLine[1],
										NewItem = (grcPhBound DiskPath:(DiskPath + (GetFileNamePath SubPath)) ObjName:(GetFileNameFile SubPath))
								if (
									NewItem.Read \
										ReportProgress:false \
										BufferMgr:BufferMgr \
										Skip:Skip \
										ReadVal:ReadVal \
										TypeCast:TypeCast \
										oFTypeExec:oFTypeExec \
										GetProgress:GetProgress \
										UpdateProgress:UpdateProgress \
										FormatText:FormatText \
										NotEOF:NotEOF \
										grcPhBound:grcPhBound \
										ValueOps:ValueOps \
										AppendMHL:AppendMHL \
										FetchMHL:FetchMHL \
										QuickSearch:QuickSearch \
										ObjectNames:ObjectNames \
										NoCaseOrderComparator:NoCaseOrderComparator \
										UpdateMatrix:UpdateMatrix
								) then (
									ItemCount += 1
									Items[ItemCount] = NewItem
								) else
									Result = false
							)
						)
						if ReportProgress then
							UpdateProgress #Progress (GetProgress BufferID)
						else
							UpdateProgress #None 0
					)
					Items.Count = ItemCount
					BufferMgr.ClearBuffer BufferID
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ArrayOps = GIMS.Core.ArrayOps,
						Modify = ArrayOps.Modify,
						BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						StringOps = GIMS.Core.StringOps,
						NoCaseOrderComparator = StringOps.NoCaseOrderComparator,
						ToHighReg = StringOps.ToHighReg,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t",
						SubDir = (ObjName + "\\"),
						SubPath = (DiskPath + SubDir),
						ItemHeader = (TabString + SubDir),
						EntryCount = (Items.Count * 4),
						ChildCount, Progress
				GIMS.Core.SystemMgr.CreateDir SubPath
				if ReportProgress then (
					for Item in Items where (TypeCast Item.Type Name BufferID:BufferID) == #BoundComposite do
						EntryCount += (Item.Children.Count * 4)
					Progress = [0, 0, EntryCount]
				)
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Item in Items do (
					WriteVal BufferID (
						FormatText \
							v1:ItemHeader \
							v2:Item.ObjName \
							v3:Item.Extension
					)
					Item.DiskPath = SubPath
					Item.Write \
						NoCaseOrderComparator:NoCaseOrderComparator \
						ToHighReg:ToHighReg \
						BufferMgr:BufferMgr \
						WriteVal:WriteVal \
						ValueOps:ValueOps \
						FormatText:FormatText \
						AsoFText:AsoFText \
						TypeCast:TypeCast \
						UpdateProgress:UpdateProgress \
						ArrayOps:ArrayOps \
						Modify:Modify \
						Progress:Progress \
						ReportProgress:ReportProgress
				)
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:FilePath
				BufferMgr.ClearBuffer BufferID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjectMgr = GIMS.Core.ObjectMgr,
						CreateIfUnique = ObjectMgr.CreateIfUnique,
						Result = (CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_CollisionDict),
						ItemCount = Items.Count,
						ParentTM = (
							if ParentNode == RootNode then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						ProgressStepCount = 0
				if ReportProgress then (
					for TheItem in Items do
						ProgressStepCount += (TheItem.GetCreateProgressStepCount ObjectMgr)
				)
				local	Progress = [0, 0, ProgressStepCount],
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				for i = 1 to ItemCount do (
					local	Item = Items[i]
					if Have Item then (
						Item.Create Result ReportProgress:ReportProgress Progress:Progress IsSeparate:false \
							UpdateProgress:UpdateProgress \
							ObjectMgr:ObjectMgr \
							CreateIfUnique:CreateIfUnique
					)
				)
				if
					Have Result and
					ParentNode != RootNode
				then
					Result.Transform = ParentNode.Transform
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
/* oF drawable */

	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcMeshVertex*/ strMeshVertex (
		Position,
		Normal,
		TheColor,
		TheColor2,
		Tangent,
		SkinBones = unsupplied,
		SkinWeights = unsupplied,
		UVCoords = unsupplied,
		CollectionIndex = #NoCollectionIndex,
		HashValue,
		fn GetHash = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.MeshVertex.GetHash"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No HashValue then (
					local	ResultStream = (StringStream ""),
							FmtStr = "%,",
							FloatFmtStr = "0.6f"
					Format FmtStr (FormattedPrint Position Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint Normal Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint Tangent Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint TheColor Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint TheColor2 Format:FloatFmtStr) To:ResultStream
					if Supplied UVCoords then (
						for Val in UVCoords do
							Format FmtStr (FormattedPrint Val Format:FloatFmtStr) To:ResultStream
					)
					if Supplied SkinWeights then (
						for Val in SkinWeights do
							Format FmtStr (FormattedPrint Val Format:FloatFmtStr) To:ResultStream
					)
					if Supplied SkinBones then (
						for Val in SkinBones do
							Format FmtStr (FormattedPrint Val Format:FloatFmtStr) To:ResultStream
					)
					local	HashString = (ResultStream as String)
					Free ResultStream
					HashValue = (GIMS.Core.ValueOps.GetHash HashString)
				)
				HashValue
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Dispose = (
			Free UVCoords
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshGeometry*/ strLODMeshGeometry (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshGeometry",
		ShaderIndex,
		Idx = #(),
		Positions = #(),
		Flags = #{},
		KnownFlags = #(
			#FLAG_VB_DYNAMIC,
			#FLAG_VB_READ_WRITE,
			#FLAG_COMPACT_BONE_MAPPING
		),
		Normals = unsupplied,
		Colors = unsupplied,
		Colors2 = unsupplied,
		Tangents = unsupplied,
		SkinBones = unsupplied,
		SkinWeights = unsupplied,
		VertClothSkins = unsupplied,
		UVCoords = unsupplied,
		fn GetVertexDeclaration Skinned ShadingGroup NeededLength:-1 PreferLonger:false &vdName:unsupplied = (
			local	SPSName
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				SPSName = ShadingGroup.Mtls[ShaderIndex].SPSName
				local	SPS = (GIMS.CurrentGame.Core.DB.GetShaderByName SPSName),
						VertexDeclarations = SPS.VertexDeclarations,
						VertexDeclaration = unsupplied
				/*TODO remove, debug*	LogProfiler #PlainInfo #(#(#Skinned, #NeededLength, #vdName, #SPS), #(Skinned, NeededLength, vdName, SPS))	/**/
				if 
					(NeededLength != -1) or
					PreferLonger
				then (
					if PreferLonger then (	--search the most informative VD
						local	MaxLenVD = unsupplied,
								MaxLen = -1
						for VD in VertexDeclarations where VD.Skinned == Skinned do (
							local	Elements = VD.Elements,
									ElementCount = Elements.Count
							if ElementCount > MaxLen then (
								MaxLen = ElementCount
								MaxLenVD = VD
							)
						)
						if MaxLen != -1 then (
							if Supplied vdName then
								vdName = MaxLenVD.aName
							VertexDeclaration = MaxLenVD.Elements
						)
					) else (	--search VD with predefined length
						if Supplied vdName then (
							for VD in VertexDeclarations where
								(VD.aName == vdName) and
								(VD.Skinned == Skinned)
							while not Supplied VertexDeclaration do (
								local	Elements = VD.Elements
								if Elements.Count == NeededLength then
									VertexDeclaration = Elements
							)
						) else (
							for VD in VertexDeclarations where (VD.Skinned == Skinned) while not Supplied VertexDeclaration do (
								local	Elements = VD.Elements
								if Elements.Count == NeededLength then
									VertexDeclaration = Elements
							)
						)
					)
				) else (	--simple search
					if Supplied vdName then (
						for VD in VertexDeclarations where
							(VD.aName == vdName) and
							(VD.Skinned == Skinned)
						while not Supplied VertexDeclaration do
							VertexDeclaration = VD.Elements
					) else (
						for VD in VertexDeclarations where VD.Skinned == Skinned while not Supplied VertexDeclaration do
							VertexDeclaration = VD.Elements
					)
				)
				VertexDeclaration
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Skinned, #ShaderIndex, #SPSName), #(Skinned, ShaderIndex, SPSName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID Skinned ShadingGroup = (
			local	VDUsage = unsupplied,
					VertLine
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No ShadingGroup then
					throw "Can't find ShadingGroup"
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						Modify = GIMS.Core.ArrayOps.Modify,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						\
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						vdName = unsupplied,
						Result = true
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				Skip BufferID 1 /* skip start */
				while 
					Result and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" 
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#ShaderIndex:
							ShaderIndex = ((TypeCast tLine[2] Integer BufferID:BufferID) + 1)
						#Flags: (
							if tLine[2] != "-" then (
								for i = 2 to tLine.Count do (
									local	ID = (FindItem KnownFlags (TypeCast tLine[i] name BufferID:BufferID))
									if ID == 0 then
										EGIMS_EHAbort ("Unknown UsageFlag \"" + tLine[i] as String + "\" in object \"" + ObjName + "\" found!") BufferID:BufferID
									Flags[ID] = true
								)
							)
						)
						#VertexDeclaration:
							vdName = (TypeCast tLine[2] Name BufferID:BufferID)
						#Indices: (
							/*<PROFILERSTART>*//*LogProfiler #Start "Read indices"; local PWS = (*//*<PROFILERSTARTED>*/
							
							local	IdxCount = (TypeCast tLine[2] Integer BufferID:BufferID),
									StartIdxIndex = 1
							Idx.Count = (IdxCount / 3)
							Skip BufferID 1 /* skip start */
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
								local	TempIdx = (oFTypeExec tLine #IntArray BufferID:BufferID),
										NewIdxCount = (TempIdx.Count / 3),
										NewIdxOffset = 1
								for IdxOffset = 0 to (NewIdxCount - 1) do (
									Idx[StartIdxIndex + IdxOffset] = [ \
										TempIdx[NewIdxOffset] + 1, \
										TempIdx[NewIdxOffset + 1] + 1, \
										TempIdx[NewIdxOffset + 2] + 1 \
									]
									NewIdxOffset += 3
								)
								StartIdxIndex += NewIdxCount
							)
							
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						#Vertices: (
							Skip BufferID 1 /* skip start */
							
							--calculate param count
							local	ParamSeparator = "/",
									FirstVertexLine = (ReadVal BufferID),
									NeededLength = 1
							for i = 1 to FirstVertexLine.Count where FirstVertexLine[i] == ParamSeparator do
								NeededLength += 1
							Skip BufferID -1 /* return back to the 1st vertex */
							
							--prepare info
							local	VertexDeclaration = (GetVertexDeclaration Skinned ShadingGroup NeededLength:NeededLength vdName:vdName)
							if Supplied VertexDeclaration then (
								local	VertexDeclarationCount = VertexDeclaration.Count,
										VDGIMSParamTypes = #(),
										VertCount = (TypeCast tLine[2] Integer BufferID:BufferID),
										HaveUV = false,
										HaveColors = false,
										HaveColors2 = false,
										HaveNormals = false,
										HaveTangents = false,
										HaveBones = false,
										HaveWeights = false,
										UVCount = 0
										
								--read
								/*<PROFILERSTART>*//*LogProfiler #Start "Init vertices"; local PWS = (*//*<PROFILERSTARTED>*/
								for ParamID = VertexDeclarationCount to 1 by -1 do (
									local	VD = VertexDeclaration[ParamID],
											Type = (SPSToGIMSParamType VD.aType)
									VDGIMSParamTypes[ParamID] = Type
									case VD.Usage of (
										#D3DDECLUSAGE_POSITION: ()
										#D3DDECLUSAGE_TEXCOORD: (
											HaveUV = true
											UVCount += (
												case Type of (
													#Float:
														1
													#P2:
														1
													#P3:
														2
													#P4:
														2
													default:
														throw "Unknown UV type: " Type BufferID:BufferID
												)
											)
										)
										#D3DDECLUSAGE_COLOR: (
											if HaveColors then (
												if not HaveColors2 then
													HaveColors2 = true
												else (
													UVCount += (
														case Type of (
															#Float:
																1
															#P2:
																1
															#P3:
																2
															#P4:
																2
															default:
																throw "Unknown Color type: " Type BufferID:BufferID
														)
													)
												)
											) else
												HaveColors = true
										)
										#D3DDECLUSAGE_NORMAL:
											HaveNormals = true
										#D3DDECLUSAGE_TANGENT:
											HaveTangents = true
										#D3DDECLUSAGE_BLENDINDICES:
											HaveBones = true
										#D3DDECLUSAGE_BLENDWEIGHT:
											HaveWeights = true
										Default:
											throw "Unknown vertex declaration element: " VD.Usage BufferID:BufferID
									)
								)
								Positions.Count = VertCount
								if HaveUV then (
									UVCoords = #()
									UVCoords.Count = UVCount
									local	UVID = 0,
											UVDummy = #()
									UVDummy.Count = VertCount
									for ParamID = 1 to VertexDeclarationCount do (
										if VertexDeclaration[ParamID].Usage == #D3DDECLUSAGE_TEXCOORD then (
											UVID += 1
											UVCoords[UVID] = (DeepCopy UVDummy)
											local	MAXParamType = VDGIMSParamTypes[ParamID]
											if
												(MAXParamType == #P3) or
												(MAXParamType == #P4)
											then (
												UVID += 1
												UVCoords[UVID] = (DeepCopy UVDummy)
											)
										)
									)
								)
								if HaveColors then (
									Colors = #()
									Colors.Count = VertCount
								)
								if HaveColors2 then (
									Colors2 = #()
									Colors2.Count = VertCount
								)
								if HaveNormals then (
									Normals = #()
									Normals.Count = VertCount
								)
								if HaveTangents then (
									Tangents = #()
									Tangents.Count = VertCount
								)
								if Skinned then (
									if HaveBones then (
										SkinBones = #()
										SkinBones.Count = VertCount
										VertClothSkins = #{}
										VertClothSkins.Count = VertCount
									)
									if HaveWeights then (
										SkinWeights = #()
										SkinWeights.Count = VertCount
									)
								)
								
								/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
								/*<PROFILERSTART>*//*LogProfiler #Start "Read vertices"; local PWS = (*//*<PROFILERSTARTED>*/
								
								for VertID = 1 to VertCount do (
									VertLine = (ReadVal BufferID FilterStr:ParamSeparator)
									local	UVID = 1,
											ColorID = 1
									for ParamID = 1 to VertexDeclarationCount do (
										local	VD = VertexDeclaration[ParamID],
												Type = VDGIMSParamTypes[ParamID]
										VDUsage = VD.Usage
										case VDUsage of (
											#D3DDECLUSAGE_POSITION:
												Positions[VertID] = (oFTypeExec VertLine[ParamID] Type BufferID:BufferID)
											#D3DDECLUSAGE_TEXCOORD: (
												local	UVCoord = (oFTypeExec VertLine[ParamID] Type BufferID:BufferID)
												case Type of (
													#Float: (
														UVCoords[UVID][VertID] = [UVCoord, 0]
														UVID += 1
													)
													#P2: (
														UVCoords[UVID][VertID] = [UVCoord[1], -UVCoord[2]]
														UVID += 1
													)
													#P3: (
														UVCoords[UVID][VertID] = [UVCoord[1], -UVCoord[2]]
														UVCoords[UVID + 1][VertID] = [UVCoord[3], 0]
														UVID += 2
													)
													#P4: (
														UVCoords[UVID][VertID] = [UVCoord[1], -UVCoord[2]]
														UVCoords[UVID + 1][VertID] = [UVCoord[3], -UVCoord[4]]
														UVID += 2
													)
													default:
														throw "Unknown UV type: " Type BufferID:BufferID
												)
											)
											#D3DDECLUSAGE_COLOR: (
												case ColorID of (
													1:
														Colors[VertID] = ((oFTypeExec VertLine[ParamID] Type BufferID:BufferID) / 255)
													2:
														Colors2[VertID] = ((oFTypeExec VertLine[ParamID] Type BufferID:BufferID) / 255)
													default: (
														local	UVCoord = (oFTypeExec VertLine[ParamID] Type BufferID:BufferID)
														case Type of (
															#Float: (
																UVCoords[UVID][VertID] = [UVCoord, 0]
																UVID += 1
															)
															#P2: (
																UVCoords[UVID][VertID] = UVCoord
																UVID += 1
															)
															#P3: (
																UVCoords[UVID][VertID] = [UVCoord[1], UVCoord[2]]
																UVCoords[UVID + 1][VertID] = [UVCoord[3], 0]
																UVID += 2
															)
															#P4: (
																UVCoords[UVID][VertID] = [UVCoord[1], UVCoord[2]]
																UVCoords[UVID + 1][VertID] = [UVCoord[3], UVCoord[4]]
																UVID += 2
															)
															default:
																throw "Unknown Color type: " Type BufferID:BufferID
														)
													)
												)
												ColorID += 1
											)
											#D3DDECLUSAGE_NORMAL:
												Normals[VertID] = (oFTypeExec VertLine[ParamID] Type BufferID:BufferID)
											#D3DDECLUSAGE_TANGENT:
												Tangents[VertID] = (oFTypeExec VertLine[ParamID] Type BufferID:BufferID)
											#D3DDECLUSAGE_BLENDINDICES: (
												local	BoneIDs = (Modify (TypeCast (oFTypeExec VertLine[ParamID] Type BufferID:BufferID) #Array BufferID:BufferID) 1 #Add CopyArray:false)
												SkinBones[VertID] = BoneIDs
												if BoneIDs[3] == 256 then
													VertClothSkins[VertID] = true
											)
											#D3DDECLUSAGE_BLENDWEIGHT:
												SkinWeights[VertID] = (TypeCast (oFTypeExec VertLine[ParamID] Type BufferID:BufferID) #Array BufferID:BufferID)
											Default:
												throw "Unknown vertex declaration element: " VD.Usage BufferID:BufferID
										)
									)
								)
								
								/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
							
							) else (
								GIMS.Core.SystemMgr.AddResult #Error  (
									ValueOps.FormatText \
										v1:"Can't find a vertex declaration with name \"" \
										v2:(vdName as String) \
										v3:"\" for material #" \
										v4:(
											if Have ShaderIndex then
												(ShaderIndex as String)
											else
												"<UNKNOWN>"
										) \
										v5:". Mesh can't be read and will be skipped." \
								)
								Result = false
							)
							Skip BufferID 1 /* skip end */
						)
						default:
							EGIMS_EHAbort "Unknown strLODMeshPrim tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#VDUsage,
					#VertLine,
					#Idx,
					#Positions,
					#Normals,
					#Colors,
					#Colors2,
					#Tangents,
					#SkinBones,
					#VertClothSkins,
					#SkinWeights,
					#UVCoords
				), #(
					VDUsage,
					VertLine,
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Colors2 		,
					Tangents 		,
					SkinBones 		,
					VertClothSkins	,
					SkinWeights 	,
					UVCoords 		
				)	
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString Skinned ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	vdName = #NONE,
						VertexDeclaration = (GetVertexDeclaration Skinned ShadingGroup PreferLonger:true vdName:(&vdName))
				if not Supplied VertexDeclaration then
					return false;
				local	Modify = GIMS.Core.ArrayOps.Modify,
						BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						SubTabString = (TabString + "\t"),
						BraceOpen = "{",
						BraceClose = "}",
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						SuppliedColors2 = (Supplied Colors2),
						NeedUVs = (Supplied UVCoords),
						UVCount = (if NeedUVs then UVCoords.Count else 0),
						P2Dummy = "0 0",
						P3Dummy = "0 0 0",
						P4Dummy = "0 0 0 0",
						ToHighReg = GIMS.Core.StringOps.ToHighReg
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"ShaderIndex " \
						v3:(ShaderIndex - 1)
				)
				if Flags.NumberSet == 0 then
					WriteVal BufferID (TabString + "Flags -")
				else (
					WriteVal BufferID (TabString + "Flags")
					for Flag in Flags do
						WriteVal BufferID (" " + (ToHighReg (KnownFlags[Flag] as String))) AppendLast:true
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"VertexDeclaration " \
						v3:(ToHighReg (vdName as String))
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Indices " \
						v3:(Idx.Count * 3)
				)
				WriteVal BufferID (TabString + BraceOpen)
				AsoFText (Modify Idx -1 #Add CopyArray:false) BufferID:BufferID SplitCount:5 TabString:SubTabString SplitString:" " SubSplitString:" " SubTypeHook:Integer
				WriteVal BufferID (TabString + BraceClose)
				local	VertCount = Positions.Count
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Vertices " \
						v3:VertCount
				)
				WriteVal BufferID (TabString + BraceOpen)
				local	EmptyParamSeparator = "",
						TheParamSeparator = " / "
				/*<PROFILERSTART>*//*LogProfiler #Start "Write+Vertices"; local PWS = (*//*<PROFILERSTARTED>*/
				
				--local	UsedBoneIndices = #{}	--<TODO>	remove, debug
				for VertID = 1 to VertCount do (
					WriteVal BufferID SubTabString
					local	IsFirstParam = true,
							UVID = 1,
							ColorID = 1,
							ParamID = 1,
							BoundParamID = (VertexDeclaration.Count + 1),
							ParamSeparator = EmptyParamSeparator
					do (
						local	VD = VertexDeclaration[ParamID],
								Type = (SPSToGIMSParamType VD.aType)
						case VD.Usage of (
							#D3DDECLUSAGE_POSITION:
								WriteVal BufferID (AsoFText (TypeCast Positions[VertID] Type BufferID:BufferID) TabString:ParamSeparator) AppendLast:true
							#D3DDECLUSAGE_TEXCOORD: (
								if not NeedUVs then
									throw "VertexDeclaration has UV, but there isn't any in the mesh"
								if UVID > UVCount then (
									WriteVal BufferID (
										case Type of (
											#P2:
												P2Dummy
											#P3:
												P3Dummy
											#P4:
												P4Dummy
											Default:
												throw "Unknown UV value type: " Type BufferID:BufferID
										)
									) AppendLast:true
								) else (
									local	UVCoord = UVCoords[UVID][VertID]
									UVID += 1
									if Type == #P4 then (
										local	NextUVCoord = UVCoords[UVID][VertID]
										UVID += 1
										UVCoord = [UVCoord.x, -UVCoord.y, NextUVCoord.x, -NextUVCoord.y]
									) else
										UVCoord = (TypeCast [UVCoord.x, -UVCoord.y] Type BufferID:BufferID)
									WriteVal BufferID (AsoFText UVCoord TabString:ParamSeparator) AppendLast:true
								)
							)
							#D3DDECLUSAGE_COLOR: (
								if
									(ColorID != 1) and
									SuppliedColors2
								then
									WriteVal BufferID (AsoFText (TypeCast (Colors2[VertID] * 255) Type BufferID:BufferID) TabString:ParamSeparator TypeHook:Integer) AppendLast:true
								else
									WriteVal BufferID (AsoFText (TypeCast (Colors[VertID] * 255) Type BufferID:BufferID) TabString:ParamSeparator TypeHook:Integer) AppendLast:true
								ColorID += 1
							)
							#D3DDECLUSAGE_NORMAL:
								WriteVal BufferID (AsoFText (TypeCast Normals[VertID] Type BufferID:BufferID) TabString:ParamSeparator) AppendLast:true
							#D3DDECLUSAGE_TANGENT:
								WriteVal BufferID (AsoFText (TypeCast Tangents[VertID] Type BufferID:BufferID) TabString:ParamSeparator) AppendLast:true
							#D3DDECLUSAGE_BLENDINDICES: (
								/*<TODO>	remove, debug*
								for BoneIndex in SkinBones[VertID] do
									UsedBoneIndices[BoneIndex] = true
								/**/
								WriteVal BufferID (AsoFText (TypeCast (Modify SkinBones[VertID] -1 #Add CopyArray:true) Type BufferID:BufferID) TabString:ParamSeparator TypeHook:Integer) AppendLast:true
							)
							#D3DDECLUSAGE_BLENDWEIGHT:
								WriteVal BufferID (AsoFText (TypeCast SkinWeights[VertID] Type BufferID:BufferID) TabString:ParamSeparator) AppendLast:true
							Default:
								throw "Unknown vertex declaration element: " VD.Usage BufferID:BufferID
						)
						ParamID += 1
						ParamSeparator = TheParamSeparator
					) while (ParamID < BoundParamID)
				)
				--Format "\t% unique bones\n"	UsedBoneIndices.NumberSet	--<TODO>	remove, debug
				
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				WriteVal BufferID (TabString + BraceClose)
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#Idx,
					#Positions,
					#Normals,
					#Colors,
					#Colors2,
					#Tangents,
					#SkinBones,
					#VertClothSkins,
					#SkinWeights,
					#UVCoords
				), #(
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Colors2 		,
					Tangents 		,
					SkinBones 		,
					VertClothSkins	,
					SkinWeights 	,
					UVCoords 		
				)	
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Skinned MMtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UVCount = (if Supplied UVCoords then UVCoords.Count else 0),
						VertCount = Positions.Count,
						TheMesh, SkinData
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				/*<PROFILERSTART>*//*LogProfiler #Start "Create mesh"; local PWS = (*//*<PROFILERSTARTED>*/
				
				TheMesh = (
					GIMS.Core.ObjectMgr.CreateMesh \
						Positions \
						Idx \
						MaterialIDs:ShaderIndex \
						VertColors:Colors \
						VertColors2:Colors2 \
						MapVerts:UVCoords \
						UVCount:UVCount \
						--VertTangents:Tangents	--TODO remove, tangents debug
				)
				
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				/*<PROFILERSTART>*//*LogProfiler #Start "Calculate SkinData"; local PWS = (*//*<PROFILERSTARTED>*/
				
				if
					Skinned and
					Supplied SkinBones and
					Supplied SkinWeights
				then (
					SkinData = (
						local	NormalizeA = GIMS.Core.ArrayOps.NormalizeA,
								BoneIDs = #(),
								BoneWeights = #()
						for VertID = VertCount to 1 by -1 do (
							local	VertBoneIDs = SkinBones[VertID],
									VertBoneWeights = SkinWeights[VertID],
									VertBoneCount = VertBoneIDs.Count,
									NewVertBoneIDs = #(),
									NewVertBoneWeights = #(),
									NewVertBoneCount = 0
							for i = 1 to VertBoneCount do (
								local	BoneID = VertBoneIDs[i],
										BoneWeight = VertBoneWeights[i]
								if (BoneWeight > 0.0001) do (
									NewVertBoneCount += 1
									NewVertBoneIDs[NewVertBoneCount] = BoneID
									NewVertBoneWeights[NewVertBoneCount] = BoneWeight
								)
							)
							NewVertBoneIDs.Count = NewVertBoneCount
							NewVertBoneWeights.Count = NewVertBoneCount
							NormalizeA NewVertBoneWeights
							BoneIDs[VertID] = NewVertBoneIDs
							BoneWeights[VertID] = NewVertBoneWeights
						)
						#(BoneIDs, BoneWeights, VertClothSkins)
					)
				)
				
				#(TheMesh, SkinData, Normals, Idx, VertCount)
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#Idx,
					#Positions,
					#Normals,
					#Colors,
					#Colors2,
					#Tangents,
					#SkinBones,
					#VertClothSkins,
					#SkinWeights,
					#UVCoords
				), #(
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Colors2 		,
					Tangents 		,
					SkinBones 		,
					VertClothSkins	,
					SkinWeights 	,
					UVCoords 		
				)	
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh*/ strLODMesh (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh",
		DiskPath,
		ObjName,
		Extension = ".mesh",
		Version = [165, 32],
		BoneID = 1,
		Locked = false,
		Skinned = false,
		BoneCount = 0,
		Mask,
		Bounds = #(),
		Geometries = #(),
		fn Read ShadingGroup CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						TypeCast = ValueOps.TypeCast,
						grcLODMeshGeometry = GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshGeometry,
						AABB = GIMS.Core.TypeLibrary.AABB,
						FullFilePath = (
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.ReadFile FullFilePath Mode:#TxtLines),
						NotEOF = BufferMgr.NotEOF,
						Result = true
				if BufferID == false then
					return false;
				while
					Result and
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] Name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:FullFilePath \
										v3:"\""
								)
								Result = false;
							)
							Skip BufferID 1 /* skip start */
						)
						#Locked:
							Locked = (TypeCast tLine[2] BooleanClass BufferID:BufferID)
						#Skinned:
							Skinned = (TypeCast tLine[2] BooleanClass BufferID:BufferID) 
						#BoneCount:
							BoneCount = (TypeCast tLine[2] Integer BufferID:BufferID) 
						#Mask:
							Mask = (TypeCast tLine[2] Integer BufferID:BufferID) 
						#Bounds: (
							Skip BufferID 1 /* skip start */
							local	BoundCount = 0
							Bounds.Count = 20
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	/* skips end */
								local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
								case Tag of (
									#AABB: (
										Skip BufferID 1 /* skip start */
										tAABB = (AABB())
										while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	/* skips end */
											local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
											case Tag of (
												#Min:
													tAABB.bMin = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
												#Max:
													tAABB.bMax = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
												default:
													EGIMS_EHAbort "Unknown strLODMesh.Bounds.AABB tag: " Param1:tLine[1] BufferID:BufferID
											)
										)
										BoundCount += 1
										Bounds[BoundCount] = tAABB
									)
									default:
										EGIMS_EHAbort "Unknown strLODMesh.Bounds tag: " Param1:tLine[1] BufferID:BufferID
								)
							)
							Bounds.Count = BoundCount
						)
						#Geometries: (
							Skip BufferID 1 /* skip start */
							Geometries.Count = 10
							local	AddedGeometries = 0
							while
								Result and
								(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
							do (	/* skips end */
								local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
								case Tag of (
									#Geometry: (
										local	Geom = (grcLODMeshGeometry())
										if (Geom.Read BufferID Skinned ShadingGroup) then (
											AddedGeometries += 1
											Geometries[AddedGeometries] = Geom
										) else
											Result = false
									)
									default:
										EGIMS_EHAbort "Unknown strLODMesh.Geometries tag: " Param1:tLine[1] BufferID:BufferID
								)
							)
							Geometries.Count = AddedGeometries
						)
						default:
							EGIMS_EHAbort "Unknown strLODMesh tag " Param1:tLine[1] BufferID:BufferID
					)
				)
				BufferMgr.ClearBuffer BufferID
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #Geometries), #(DiskPath, ObjName, Extension, Geometries)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						WriteVal = BufferMgr.WriteVal,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t",
						SubTabString = (TabString + "\t"),
						DoubleSubTabString = (SubTabString + "\t"),
						BraceOpen = "{",
						BraceClose = "}",
						SubTabBraceOpen = (SubTabString + "{"),
						SubTabBraceClose = (SubTabString + "}"),
						TabBraceOpen = (TabString + BraceOpen),
						TabBraceClose = (TabString + BraceClose),
						SubTabBraceOpen = (SubTabString + BraceOpen),
						SubTabBraceClose = (SubTabString + BraceClose),
						AABBHeader = (SubTabString + "Aabb"),
						GeomHeader = (SubTabString + "Geometry")
				if BufferID != false then (
				
					/*get bone count*
					local	UsedBoneIndices = #{}
					for Geom in Geometries do (
						local	SkinBones = Geom.SkinBones
						if Have SkinBones then (
							for VertSkinBones in SkinBones do (
								for BoneIndex in VertSkinBones do
									UsedBoneIndices[BoneIndex] = true
							)
						)
					)
					BoneCount = UsedBoneIndices.NumberSet
					--Format "Mesh % with % unique bones\n" ObjName BoneCount	--TODO remove, debug
					/**/
					
					--write
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID BraceOpen
					WriteVal BufferID (FormatText v1:TabString v2:"Locked " v3:Locked)
					WriteVal BufferID (FormatText v1:TabString v2:"Skinned " v3:Skinned)
					WriteVal BufferID (FormatText v1:TabString v2:"BoneCount " v3:BoneCount)
					WriteVal BufferID (FormatText v1:TabString v2:"Mask " v3:Mask)
					WriteVal BufferID (TabString + "Bounds")
					WriteVal BufferID TabBraceOpen
					for tAABB in Bounds do (
						WriteVal BufferID AABBHeader
						WriteVal BufferID SubTabBraceOpen
						WriteVal BufferID (AsoFText tAABB.bMin TabString:(DoubleSubTabString + "Min "))
						WriteVal BufferID (AsoFText tAABB.bMax TabString:(DoubleSubTabString + "Max "))
						WriteVal BufferID SubTabBraceClose
					)
					WriteVal BufferID TabBraceClose
					WriteVal BufferID (TabString + "Geometries")
					WriteVal BufferID TabBraceOpen
					for Geom in Geometries do (
						WriteVal BufferID GeomHeader
						WriteVal BufferID SubTabBraceOpen
						if not (Geom.Write BufferID DoubleSubTabString Skinned ShadingGroup) then (
							EGIMS_EHAbort ( \
								FormatText \
									v1:"Can't find a proper vertex declaration for a mesh \"" \
									v2:ObjDir \
									v3:"\" material " \
									v4:(
										local	ShaderIndex = Geom.ShaderIndex
										if Have ShaderIndex then
											(ShaderIndex as String)
										else
											""
									) \
									v5:".\nCheck if all of its materials can be skinned or not(depending on the selected shader)." \
							)
						)
						WriteVal BufferID SubTabBraceClose
					)
					WriteVal BufferID TabBraceClose
					WriteVal BufferID BraceClose
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #Bounds, #Geometries, #BoneID, #Skinned, #BoneCount, #Mask), #(DiskPath, ObjName, Extension, Bounds, Geometries, BoneID, Skinned, BoneCount, Mask)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes MMtl BoneIndexMap = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = false,
						GeometryCount = Geometries.Count
				if GeometryCount != 0 then (
					local	BoneCount = BoneNodes.Count,
							Meshes = #(),
							SkinBones = #(),
							VertClothSkins = #{},
							SkinWeights = #(),
							Idx = unsupplied,
							Normals = unsupplied,
							NeedNormals = false,
							UsedBones = #{},
							IsFirstGeometry = true,
							Modify,
							InvalidNormalDummy,
							IdxOffset,
							VertClothSkinsOffset = 0
					UsedBones.Count = BoneCount
					Meshes.Count = GeometryCount
					/*<PROFILERSTART>*//*LogProfiler #Start "Meshes creation"; local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for Geom in Geometries where Supplied Geom.Normals while not NeedNormals do
						NeedNormals = true
					if NeedNormals then (
						InvalidNormalDummy = [666, 666, 666]
						Modify = GIMS.Core.ArrayOps.Modify
					)
					for GeometryID = 1 to GeometryCount do (
					
						--create the mesh and get its data
						local	MeshData = (Geometries[GeometryID].Create Skinned MMtl),
								TheMesh = MeshData[1],
								SkinMeshData = MeshData[2],
								MeshNormals = MeshData[3],
								MeshIdx = MeshData[4],
								MeshVertCount = MeshData[5]
						Meshes[GeometryID] = TheMesh
						
						--accumulate data
						if IsFirstGeometry then (
							IsFirstGeometry = false
						
							--store normals data
							if NeedNormals then (
							
								--store data
								if Supplied MeshNormals then
									Normals = MeshNormals
								else (
									Normals = #()
									for i = MeshVertCount to 1 by -1 do
										Normals[i] = InvalidNormalDummy
								)
								Idx = MeshIdx

								--create offset
								IdxOffset = [MeshVertCount, MeshVertCount, MeshVertCount]
							)
							
							--store skin data
							if Have SkinMeshData then (
							
								--store data
								SkinBones = SkinMeshData[1]
								SkinWeights = SkinMeshData[2]
								
								--collect cloth skin vert IDs
								VertClothSkins.Count = MeshVertCount
								for VertClothSkin in SkinMeshData[3] do
									VertClothSkins[VertClothSkin] = true
									
								--create offset
								VertClothSkinsOffset = MeshVertCount
							)
						) else (
						
							--accumulate normals data
							if NeedNormals then (
							
								--extend old data
								local	NewIdx = (Idx + (Modify MeshIdx IdxOffset #Add CopyArray:false)),
										NewNormals
								if Supplied MeshNormals then
									NewNormals = (Normals + MeshNormals)
								else (
									local	NormalsDummy = #()
									for i = MeshVertCount to 1 by -1 do
										NormalsDummy[i] = InvalidNormalDummy
									NewNormals = (Normals + NormalsDummy)
									Free NormalsDummy
								)
								Free Idx
								Free Normals
								Idx = NewIdx
								Normals = NewNormals

								--add offset
								IdxOffset += [MeshVertCount, MeshVertCount, MeshVertCount]
							)
							
							--accumulate skin data
							if Have SkinMeshData then (
							
								--extend old data
								local	NewSkinBones = (SkinBones + SkinMeshData[1]),
										NewSkinWeights = (SkinWeights + SkinMeshData[2])
								Free SkinBones
								Free SkinWeights
								SkinBones = NewSkinBones
								SkinWeights = NewSkinWeights
								
								--collect cloth skin vert IDs
								VertClothSkins.Count += MeshVertCount
								for VertClothSkin in SkinMeshData[3] do
									VertClothSkins[VertClothSkin + VertClothSkinsOffset] = true
									
								--add offset
								VertClothSkinsOffset += MeshVertCount
							)
						)
					)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					local	ParentNode = BoneNodes[BoneID],
							NeedInteractiveUI = (
								NeedNormals or
								Skinned
							),
							OldSelection
					Result = Meshes[1]
					/*<PROFILERSTART>*//*LogProfiler #Start "Meshes attach"; local PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
					for MeshID = 2 to GeometryCount do
						Attach Result Meshes[MeshID]
					Result.Name = ObjName
					Result.Parent = ParentNode
					local	ParentTM = (
								if ParentNode == RootNode then
									(Matrix3 1)
								else
									ParentNode.Transform
							)
					if NeedInteractiveUI then (
						EGIMS_ResumeMAX()
						OldSelection = (Selection as Array)
						Select Result
						MAX Modify Mode
					)
					if NeedNormals then (
						GIMS.Core.ObjectMgr.SetMeshNormals \
							Result \
							Normals \
							InvalidNormalDummy:InvalidNormalDummy \
							Faces:Idx \
						CollapseStack Result
						Free Idx
						Free Normals
					)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#GeometryCount, #Meshes), #(GeometryCount, Meshes)))/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					if Skinned then (
						/*<PROFILERSTART>*//*LogProfiler #Start "Apply skinning"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						local	OldSelection = (Selection as array),
								SkinMod = (Skin WeightAllVertices:false)
						AddModifier Result SkinMod
						EGIMS_SelectModifier SkinMod
						local	AddBone = SkinOps.AddBone,
								SetInnerRadius = SkinOps.SetInnerRadius,
								SetOuterRadius = SkinOps.SetOuterRadius
						/*<PROFILERSTART>*//*LogProfiler #Start "Add bones"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for bid = 1 to BoneCount do (
							AddBone SkinMod BoneNodes[bid] 0
							SetInnerRadius SkinMod bid 1 0
							SetOuterRadius SkinMod bid 1 0
							SetInnerRadius SkinMod bid 2 0
							SetOuterRadius SkinMod bid 2 0
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						local	NumVerts = Result.NumVerts
						if Supplied BoneIndexMap then (

							--Print #ApplyWeights	--TODO remove, debug
						
							for VertID = 1 to NumVerts where not VertClothSkins[VertID] do (
								local	VertBones = SkinBones[VertID]
							
								--with printallelements true (Format "Replace\t%" VertBones)	--TODO remove, debug
							
								for i = 1 to VertBones.Count do (
									local	bid = VertBones[i]
									VertBones[i] = (BoneIndexMap[bid])
								)
							
								--with printallelements true (Format "\twith\t%\n" VertBones)	--TODO remove, debug
							
							)
						)
						local	UnNormalizeVertex = SkinOps.UnNormalizeVertex,
								GetVertexWeightCount = SkinOps.GetVertexWeightCount,
								GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
								ReplaceVertexWeights = SkinOps.ReplaceVertexWeights

						--Print #ApplyWeights	--TODO remove, debug

						/*<PROFILERSTART>*//*LogProfiler #Start "Apply weights"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for VertID = 1 to NumVerts do (
							if not VertClothSkins[VertID] then (	--TODO else apply cloth skinning
								UnNormalizeVertex SkinMod VertID false
								local	VertBones = SkinBones[VertID],
										VertWeights = SkinWeights[VertID],
										WeightCount = (GetVertexWeightCount SkinMod VertID)
								for WeightID = 1 to WeightCount do (
									local	BoneID = (GetVertexWeightBoneID SkinMod VertID WeightID)
									if (FindItem VertBones BoneID) == 0 then (
										Append VertBones BoneID
										Append VertWeights 0
									)
								)
								if VertBones.Count != 0 then (
									for BoneID in VertBones do
										UsedBones[BoneID] = true
									ReplaceVertexWeights SkinMod VertID VertBones VertWeights
								)
								
								--with printallelements true (Print (VertBones as String))	--TODO remove, debug
								
							)
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<PROFILERSTART>*//*LogProfiler #Start "Delete unused bones"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						local	SelectBone = SkinOps.SelectBone,
								RemoveBone = SkinOps.RemoveBone
						for bid = BoneCount to 1 by -1 where not UsedBones[bid] do (
							SelectBone SkinMod bid
							RemoveBone SkinMod
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					) else
						Result.Transform = ParentTM
					if NeedInteractiveUI then (
						Update Result
						MAX Create Mode
						Select OldSelection
						EGIMS_SuspendMAX()
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #BoneNodes, #BoneIndexMap, #Meshes, #Geometries), #(DiskPath, ObjName, Extension, BoneNodes, BoneIndexMap, Meshes, Geometries)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup*/ strLODGroup (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup",
		DiskPath,
		LODGroups = #(
			#(),
			#(),
			#(),
			#()
		),
		LODGroupNames = #(
			"High",
			"Med",
			"Low",
			"Vlow"
		),
		LODGroupValues = #(
			9998.0,
			9998.0,
			9998.0,
			9998.0
		),
		LODGrpTags = #(
			#High,
			#Med,
			#Low,
			#Vlow
		),
		fn Read BufferID ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						grcLODMesh = GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID),
							TagID = (FindItem LODGrpTags Tag)
					if TagID != 0 then (
						LODGroupValues[TagID] = (TypeCast tLine[2] Float BufferID:BufferID)
						if (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] == "{" then (
							Skip BufferID 1	/* skip mesh list start */
							local	LODGroup = LODGroups[TagID],
									LODGroupSize = LODGroup.Count
							LODGroup.Count = (LODGroupSize + 10)
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips mesh list end */
								local	MeshFilePath = tLine[1]
								for i = 2 to (tLine.Count - 1) do (
									Append MeshFilePath " "
									Append MeshFilePath tLine[i]
								)
								local	LODMesh = (
											grcLODMesh \
												BoneID:((TypeCast tLine[tLine.Count] Integer BufferID:BufferID) + 1) \
												DiskPath:(DiskPath + (GetFileNamePath MeshFilePath)) \
												ObjName:(GetFileNameFile MeshFilePath) \
												Extension:(GetFileNameType MeshFilePath) \
										)
								if not (LODMesh.Read ShadingGroup) then
									return false;
								LODGroupSize += 1
								LODGroup[LODGroupSize] = LODMesh
							)
							LODGroup.Count = LODGroupSize
						)
					) else (
						case Tag of (
							#Center: () /*skip*/
							#AABBMin: () /*skip*/
							#AABBMax: () /*skip*/
							#Radius: () /*skip*/
							default:
								EGIMS_EHAbort "Unknown strLODGroup tag: " Param1:tLine[1] BufferID:BufferID
						)
					)
				)
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID SubDir ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TabString = "\t\t",
						SubTabString = (TabString + "\t"),
						BufferMgr = GIMS.Core.BufferMgr,
						FormatText = GIMS.Core.ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						LODGrpCount = LODGroups.Count,
						ExtendBound = GIMS.Core.ObjectMgr.ExtendBound,
						Bounds = (GIMS.CurrentGame.Core.TypeLibrary.Bounds()),
						AABB = Bounds.AABB,
						NoModels = true
				for LODGrpID = 1 to LODGrpCount do (
					local	LODGrp = LODGroups[LODGrpID],
							LODGrpSize = LODGrp.Count
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:LODGroupNames[LODGrpID] \
							v3:" " \
							v4:LODGroupValues[LODGrpID]
					)
					if LODGrpSize != 0 then (
						WriteVal BufferID (TabString + "{")
						for LODMesh in LODGrp do (
							local	Bounds = LODMesh.Bounds
							if
								NoModels and
								Bounds.Count != 0
							then
								NoModels = false
							for Bound in Bounds do
								ExtendBound AABB Bound
							WriteVal BufferID (
								FormatText \
									v1:SubTabString \
									v2:SubDir \
									v3:LODMesh.ObjName \
									v4:LODMesh.Extension \
									v5:" " \
									v6:(LODMesh.BoneID - 1) \
							)
							LODMesh.DiskPath = DiskPath
							LODMesh.Write ShadingGroup
						)
						WriteVal BufferID (TabString + "}")
					)
				)
				if NoModels then (
					AABB.bMax = [0, 0, 0]
					AABB.bMin = [0, 0, 0]
					Bounds.Center = [0, 0, 0]
					Bounds.Radius = 0.0
				) else (
					local	AABBMax = AABB.bMax,
							AABBMin = AABB.bMin,
							Center = (AABBMin + ((AABBMax - AABBMin) / 2))
					Bounds.Center = Center
					Bounds.Radius = (Length (AABBMax - Center))
				)
				Bounds.Write BufferID TabString
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes ShadingGroup TheSkeleton HaveTheSkeleton TheSkeleton_FULL HaveTheSkeleton_FULL HaveActiveSkeleton = (
			local	Mtls, MMtl
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			
				--create material
				MMtl = (
					if Have ShadingGroup then (
						Mtls = ShadingGroup.Mtls
						local	MtlNames = #(),
								MtlIDs = #()
						for i = Mtls.Count to 1 by -1 do (
							MtlNames[i] = Mtls[i].Name
							MtlIDs[i] = i
						)
						(MultiMaterial Name:ShadingGroup.ObjName Material:Mtls Names:MtlNames MaterialIDList:MtlIDs)
					)
				)
				
				--get used bone count and set skinned meshes presence flag
				local	MaxBoneIndex = 0,
						HaveSkinned = false
				for LODGrp in LODGroups do (
					for tMesh in LODGrp do (
						local	MBoneID = tMesh.BoneID
						if MBoneID > MaxBoneIndex then
							MaxBoneIndex = MBoneID
						if tMesh.Skinned then (
							HaveSkinned = true
							for Geom in tMesh.Geometries do (
								local	SkinBones = Geom.SkinBones
								if Supplied SkinBones then (
									for BoneIndices in SkinBones where BoneIndices[3] != 256 do (
										for Index in BoneIndices where Index > MaxBoneIndex do
											MaxBoneIndex = Index
									)
								)
							)
						)
					)
				)
				
				--build BoneIndexMap
				local	BoneIndexMap = unsupplied,
						HaveBoneIndexMap = false
				if
					(
						HaveSkinned or
						MaxBoneIndex > 1
					) and
					HaveTheSkeleton and
					HaveTheSkeleton_FULL
				then (
					BoneIndexMap = #()
					BoneIndexMap.Count = MaxBoneIndex
					if (TheSkeleton.BuildBoneIndexMap BoneIndexMap TheSkeleton_FULL) then
						HaveBoneIndexMap = true
					else (
						Free BoneIndexMap
						BoneIndexMap = unsupplied
					)
				)
				
				--create fake bones
				if MaxBoneIndex > BoneNodes.Count then (
					if HaveBoneIndexMap then (
						GIMS.Core.SystemMgr.AddResult #Error (
							GIMS.Core.ValueOps.FormatText \
								v1:"Model with skeleton \"" \
								v2:TheSkeleton.DiskPath \
								v3:TheSkeleton.ObjName \
								v4:"\" hasn't got enough bones to properly create skinned meshes, despite the fact you've supplied FULL skeleton file \"" \
								v5:TheSkeleton_FULL.ObjName \
								v6:"\".\nFake bones will be created. Probably, supplied FULL skeleton doesn't match this model." \
						)
					)
					local	BonesParent = BoneNodes[1],
							BonesParentTM = BonesParent.Transform
					for i = MaxBoneIndex to 1 by -1 where No BoneNodes[i] do (
						local	tBone = (EGIMS_V_Model_Bone Name:("Fake Bone " + ((i as Integer) as String)) Parent:BonesParent Transform:BonesParentTM)
						tBone.WireColor = Yellow
						tBone.ShowLinks = true
						tBone.ShowLinksOnly = true
						BoneNodes[i] = tBone
					)
				)
					
				/*TODO remove, debug*
				if HaveBoneIndexMap then (
					Format "BoneIndexMap of %\n" (if HaveTheSkeleton then TheSkeleton.ObjName else TheSkeleton_FULL.ObjName)
					Format "\tSize %\n" BoneIndexMap.Count
					Format "\tFirst undefined at %\n" (FindItem BoneIndexMap undefined)
					with printallelements true (Format "\tData %\n" (BoneIndexMap as String))
				)
				/*TODO remove, debug END*/
				
				--create meshes
				for LODGrpID = 1 to LODGroups.Count do (
					for tMesh in LODGroups[LODGrpID] do (
						local	TempMesh = (tMesh.Create BoneNodes MMtl BoneIndexMap)
						if TempMesh != false then (
							for Geom in tMesh.Geometries do (
								local	Mtl = MMtl[Geom.ShaderIndex]
								if (not (IsKindOf Mtl EGIMS_V_material)) then
									throw ("Wrong type of material found at shader index " + (Geom.ShaderIndex as String) + ": ") (ClassOf Mtl)
								local	GeometryFlags = Mtl.GeometryFlags
								for FlagID in Geom.Flags do
									GeometryFlags[FlagID] = true
							)
							TempMesh.Material = MMtl
							AddModifier TempMesh (EGIMS_V_ModelMesh Type:LODGrpID Mask:tMesh.Mask)
						)
					)
				)
				Free BoneIndexMap
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Mtls, #MMtlCount), #(Mtls, MMtl.Count)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcBone*/ strBone (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcBone",
		ObjName,
		ID = #NoBoneID,
		MirrorBoneID = #NoMirrorBoneID,
		Flags = #{},
		KnownFlags = #(
			#LIMIT_ROTATION,
			#ROT_X,
			#ROT_Y,
			#ROT_Z,
			#LIMIT_TRANSLATION,
			#TRANS_X,
			#TRANS_Y,
			#TRANS_Z,
			#LIMIT_SCALE,
			#SCALE_X,
			#SCALE_Y,
			#SCALE_Z
		),
		RotationQuaternion,
		LocalOffset,
		TheScale,
		Children = #(),
		
		Index = #NoBoneIndex,
		
		fn GetRAWData RAWData FloatFmtStr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Format "%%%%" \
					ID \
					(FormattedPrint RotationQuaternion Format:FloatFmtStr) \
					(FormattedPrint LocalOffset Format:FloatFmtStr) \
					(FormattedPrint TheScale Format:FloatFmtStr) \
					To:RAWData
				for Child in Children do
					Child.GetRAWData RAWData FloatFmtStr
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetBoneIDs BoneIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				BoneIDs[Index] = ID
				for tBone in Children do
					tBone.GetBoneIDs BoneIDs
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read ThisObj BufferID LastBoneIndex = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				LastBoneIndex += 1
				Index = LastBoneIndex
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Bone: (
							ObjName = (tLine[2] as String)
							ID = (TypeCast tLine[3] Integer BufferID:BufferID)
							Skip BufferID 1 /* skip start */
						)
						#Flags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count} BufferID:BufferID),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem KnownFlags Flag)
								if FlagID != 0 then
									Flags[FlagID] = true
								else (
									GIMS.Core.SystemMgr.AddResult #Error  (
										GIMS.Core.ValueOps.FormatText \
											v1:"Unknown flag \"" \
											v2:Flag \
											v3:"\" in object \"" \
											v4:ObjName \
											v5:"\" found at " \
											v6:(BufferMgr.GetErrorInfo BufferID) \
									)
									return false;
								)
							)
						)
						#MirrorBoneId:
							MirrorBoneID = (TypeCast tLine[2] Integer BufferID:BufferID)
						#RotationQuaternion:
							RotationQuaternion = (oFTypeExec tLine #Quat IDMask:#{2..5} BufferID:BufferID)
						#LocalOffset:
							LocalOffset = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Scale:
							TheScale = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Children: (
							Skip BufferID 1 /* skip start */
							Children.Count = (TypeCast tLine[2] Integer BufferID:BufferID)
							for ChildID = 1 to Children.Count do (
								local	NewItem = grcBone()
								LastBoneIndex = (NewItem.Read NewItem BufferID LastBoneIndex)
								if LastBoneIndex == false then
									return false;
								Children[ChildID] = NewItem
							)
							Skip BufferID 1 /* skip end */
						)
						default:
							EGIMS_EHAbort "Unknown strBone tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				LastBoneIndex
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ToHighReg = GIMS.Core.StringOps.ToHighReg,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Bone " \
						v3:ObjName \
						v4:" " \
						v5:ID
				)
				WriteVal BufferID (TabString + "{")
				local	SubTabString = (TabString + "\t")
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"MirrorBoneId " \
						v3:MirrorBoneID
				)
				WriteVal BufferID (SubTabString + "Flags")
				for Flag in Flags do
					WriteVal BufferID (" " + (ToHighReg (KnownFlags[Flag] as String))) AppendLast:true
				WriteVal BufferID (AsoFText RotationQuaternion TabString:(SubTabString + "RotationQuaternion "))
				WriteVal BufferID (AsoFText LocalOffset TabString:(SubTabString + "LocalOffset "))
				WriteVal BufferID (AsoFText TheScale TabString:(SubTabString + "Scale "))
				local	ChildrenCount = Children.Count
				if ChildrenCount != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:SubTabString \
							v2:"Children " \
							v3:ChildrenCount
					)
					WriteVal BufferID (SubTabString + "{")
					local	ChildTabString = (SubTabString + "\t")
					for TempBone in Children do
						TempBone.Write BufferID ChildTabString
					WriteVal BufferID (SubTabString + "}")
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ThisObj ParentNode AncestorBoneNodes LastBoneIndex = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParentTM = (
							if ParentNode == RootNode then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						InvParentTM = (Inverse ParentTM),
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_Model_Bone)
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				Result.WireColor = Yellow
				Result.ShowLinks = true
				Result.ShowLinksOnly = true
				Result.Scale = (TheScale * ParentNode.Scale)
				Result.Rotation = (InvParentTM * (RotationQuaternion as Matrix3)).Rotation
				Result.Pos = (LocalOffset * ParentTM)
				Result.InitialTM = (Result.Transform * InvParentTM)
				Result.IsInitialTMSet = true
				GIMS.Core.ValueOps.ConvertStruct Result undefined ParamSource:ThisObj DontCreate:true
				LastBoneIndex += 1
				AncestorBoneNodes[LastBoneIndex] = Result
				for Item in Children do
					LastBoneIndex = (Item.Create Item Result AncestorBoneNodes LastBoneIndex)
				LastBoneIndex
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton*/ strSkeleton (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton",
		DiskPath,
		ObjName,
		Extension = ".skel",
		Version = [165, 30],
		DataCRC = -2,
		NumBones = 0,
		TheBones = #(),
		fn GetDataHash ValueOps:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	RAWData = (StringStream ""),
						FloatFmtStr = "0.6f"
				for tBone in TheBones do
					tBone.GetRAWData RAWData FloatFmtStr
				local	Hash
				
				/*STRING HASH*
				Hash = (RAWData as String)
				/**/
				
				/*JENKINS HASH*/
				if not Supplied ValueOps then
					Hash = (GIMS.Core.ValueOps.GetHash (RAWData as String))
				else
					Hash = (ValueOps.GetHash (RAWData as String))
				/**/
				
				Free RAWData
				Hash
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						\
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NotEOF = BufferMgr.NotEOF,
						LastBoneIndex = 0
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									ValueOps.FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#DataCRC:
							DataCRC = (TypeCast (tLine[2] + "L") Integer64 BufferID:BufferID)
						#NumBones:
							NumBones = (TypeCast tLine[2] Integer BufferID:BufferID)
						#Bone: (
							Skip BufferID -1 /* return to start */
							local	NewItem = (grcBone())
							LastBoneIndex = (NewItem.Read NewItem BufferID LastBoneIndex)
							if LastBoneIndex == false then
								return false;
							Append TheBones NewItem
						)
						default:
							EGIMS_EHAbort "Unknown strSkeleton tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				BufferMgr.ClearBuffer BufferID
				--if DataCRC >= 0 then	TODO append to BoneDataCRCs
				--	GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.BoneDataCRCs DataCRC Hash:(GetDataHash ValueOps:ValueOps)
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						FilePath = (
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t"
				if BufferID != false then (
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					if DataCRC == -1 then
						WriteVal BufferID (TabString + "DataCRC -1")
					else (
						if DataCRC == -2 then
							DataCRC = (GetDataHash ValueOps:ValueOps)
						WriteVal BufferID (FormatText v1:TabString v2:"DataCRC " v3:(FormattedPrint DataCRC Format:"u"))
					)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"NumBones " \
							v3:NumBones \
					)
					for TheBone in TheBones do
						TheBone.Write BufferID TabString
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetBoneIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BoneIDs = #()
				BoneIDs.Count = NumBones
				for tBone in TheBones do
					tBone.GetBoneIDs BoneIDs
				BoneIDs
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn BuildBoneIndexMap BoneIndexMap TheSkeleton_FULL = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = true,
						BoneIDs = (GetBoneIDs())
						FULLBoneIDs = (TheSkeleton_FULL.GetBoneIDs())
				for Index = 1 to NumBones while Result do (
					local	BoneID = BoneIDs[Index],
							FULLBoneIndex = (FindItem FULLBoneIDs BoneID)
					if FULLBoneIndex == 0 then (
						GIMS.Core.SystemMgr.AddResult #Error  (
							GIMS.Core.ValueOps.FormatText \
								v1:"Can't find a bone with ID " \
								v2:BoneID \
								v3:" in file \"" \
								v4:TheSkeleton_FULL.ObjName \
								v5:"\".\nMay be, you've supplied wrong skeleton file."
						)
						Result = false
					) else
						BoneIndexMap[Index] = FULLBoneIndex
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode AncestorBoneNodes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local 	LastBoneIndex = 0
				for tBone in TheBones do
					LastBoneIndex = (tBone.Create tBone ParentNode AncestorBoneNodes LastBoneIndex)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLight*/ strLight (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLight",
		Position = [0, 0, 0],
		TheColor = White,
		Flashiness = 0,
		Intensity = 1,
		Flags = #{},
		BoneTag = 0,
		GroupId = 0,
		LightType = 1,
		TimeFlags = #{},
		Falloff = 3.5,
		FalloffExponent = 32,
		CullingPlane = #(0, 0, 1, 10),
		ShadowBlur = 0,
		VolumeIntensity = 1,
		VolumeSizeScale = 1,
		VolumeOuterColor = White,
		LightHash = 0,	--0..255
		VolumeOuterIntensity = 1,
		CoronaSize = 1,
		VolumeOuterExponent = 1,
		LightFadeDistance = 0,
		ShadowFadeDistance = 0,
		SpecularFadeDistance = 0,
		VolumetricFadeDistance = 0,
		ShadowNearClip = 0.01,
		CoronaIntensity = 1,
		CoronaZBias = 0.1,
		Direction = [0, 0, -1],
		Tangent = [1, 0, 0],
		ConeInnerAngle = 0,
		ConeOuterAngle = 0,
		Extents = [1, 1, 1],
		ProjectedTextureHash = 0L,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						AsBitArray = ValueOps.AsBitArray
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Position:
							Position = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Color:
							TheColor = (oFTypeExec tLine #Color IDMask:#{2..4} BufferID:BufferID)
						#Flashiness:		--0,
							Flashiness = (TypeCast tLine[2] Integer BufferID:BufferID)
						#Intensity:		--1,
							Intensity = (TypeCast tLine[2] Float BufferID:BufferID)
						#Flags:		--0L,
							Flags = (AsBitArray (TypeCast (Append tLine[2] "L") Integer BufferID:BufferID))
						#BoneTag:		--0,
							BoneTag = (TypeCast tLine[2] Integer BufferID:BufferID)
						#LightType: (		--1,
							LightType = (TypeCast tLine[2] Integer BufferID:BufferID)
							if (
								LightType != 1 and
								LightType != 2 and
								LightType != 4
							) then
								throw "Unknown light type: " LightType
						)
						#GroupId:		--0,
							GroupId = (TypeCast tLine[2] Integer BufferID:BufferID)
						#TimeFlags:		--0L,
							TimeFlags = (AsBitArray (TypeCast (Append tLine[2] "L") Integer BufferID:BufferID))
						#Falloff:		--3.5,
							Falloff = (TypeCast tLine[2] Float BufferID:BufferID)
						#FalloffExponent:		--32,
							FalloffExponent = (TypeCast tLine[2] Float BufferID:BufferID)
						#CullingPlane:		--[0, 0, 1, 3.5],
							CullingPlane = (oFTypeExec tLine #FloatArray IDMask:#{2..5} BufferID:BufferID)
						#ShadowBlur:		--0,
							ShadowBlur = (TypeCast tLine[2] Integer BufferID:BufferID)
						#VolumeIntensity:		--1,
							VolumeIntensity = (TypeCast tLine[2] Float BufferID:BufferID)
						#VolumeSizeScale:		--1,
							VolumeSizeScale = (TypeCast tLine[2] Float BufferID:BufferID)
						#VolumeOuterColor:		--White,
							VolumeOuterColor = (oFTypeExec tLine #Color IDMask:#{2..4} BufferID:BufferID)
						#LightHash:		--0,
							LightHash = (TypeCast tLine[2] Integer BufferID:BufferID)
						#VolumeOuterIntensity:		--1,
							VolumeOuterIntensity = (TypeCast tLine[2] Float BufferID:BufferID)
						#CoronaSize:		--1,
							CoronaSize = (TypeCast tLine[2] Float BufferID:BufferID)
						#VolumeOuterExponent:		--1,
							VolumeOuterExponent = (TypeCast tLine[2] Float BufferID:BufferID)
						#LightFadeDistance:		--0,
							LightFadeDistance = (TypeCast tLine[2] Integer BufferID:BufferID)
						#ShadowFadeDistance:		--0,
							ShadowFadeDistance = (TypeCast tLine[2] Integer BufferID:BufferID)
						#SpecularFadeDistance:		--0,
							SpecularFadeDistance = (TypeCast tLine[2] Integer BufferID:BufferID)
						#VolumetricFadeDistance:		--0,
							VolumetricFadeDistance = (TypeCast tLine[2] Integer BufferID:BufferID)
						#ShadowNearClip:		--0.01,
							ShadowNearClip = (TypeCast tLine[2] Float BufferID:BufferID)
						#CoronaIntensity:		--1,
							CoronaIntensity = (TypeCast tLine[2] Float BufferID:BufferID)
						#CoronaZBias:		--0.1,
							CoronaZBias = (TypeCast tLine[2] Float BufferID:BufferID)
						#Direction:		--[0, 0, -1],
							Direction = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Tangent:		--[1, 0, 0],
							Tangent = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#ConeInnerAngle:		--0,
							ConeInnerAngle = (TypeCast tLine[2] Float BufferID:BufferID)
						#ConeOuterAngle:		--0,
							ConeOuterAngle = (TypeCast tLine[2] Float BufferID:BufferID)
						#Extents:		--[1, 1, 1],
							Extents = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#ProjectedTextureHash:
							ProjectedTextureHash = (TypeCast (Append tLine[2] "L") Integer BufferID:BufferID)
						default:
							EGIMS_EHAbort "Unknown strLight tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						CopyBits = ValueOps.CopyBits,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						BitArrayAsValue = GIMS.Core.ArrayOps.BitArrayAsValue,
						SubTabString = (TabString + "\t"),
						dwFmt = "u"
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				WriteVal BufferID (TabString + "Attribute")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (AsoFText Position TabString:(SubTabString + "Position "))
				WriteVal BufferID (AsoFText TheColor TabString:(SubTabString + "Color ") WithAlpha:false)
				WriteVal BufferID (FormatText v1:SubTabString v2:"Flashiness " v3:Flashiness)
				WriteVal BufferID (FormatText v1:SubTabString v2:"Intensity " v3:Intensity)
				WriteVal BufferID (FormatText v1:SubTabString v2:"Flags " v3:(FormattedPrint (BitArrayAsValue Flags Range:#{1..32}) Format:dwFmt))
				WriteVal BufferID (FormatText v1:SubTabString v2:"BoneTag " v3:BoneTag)
				WriteVal BufferID (FormatText v1:SubTabString v2:"LightType " v3:LightType)
				WriteVal BufferID (FormatText v1:SubTabString v2:"GroupId " v3:GroupId)
				WriteVal BufferID (FormatText v1:SubTabString v2:"TimeFlags " v3:(FormattedPrint (BitArrayAsValue TimeFlags Range:#{1..32}) Format:dwFmt))
				WriteVal BufferID (FormatText v1:SubTabString v2:"Falloff " v3:Falloff)
				WriteVal BufferID (FormatText v1:SubTabString v2:"FalloffExponent " v3:FalloffExponent)
				WriteVal BufferID (AsoFText CullingPlane TabString:(SubTabString + "CullingPlane "))
				WriteVal BufferID (FormatText v1:SubTabString v2:"ShadowBlur " v3:ShadowBlur)
				WriteVal BufferID (FormatText v1:SubTabString v2:"VolumeIntensity " v3:VolumeIntensity)
				WriteVal BufferID (FormatText v1:SubTabString v2:"VolumeSizeScale " v3:VolumeSizeScale)
				WriteVal BufferID (AsoFText VolumeOuterColor TabString:(SubTabString + "VolumeOuterColor ") WithAlpha:false)
				WriteVal BufferID (FormatText v1:SubTabString v2:"LightHash " v3:LightHash)
				WriteVal BufferID (FormatText v1:SubTabString v2:"VolumeOuterIntensity " v3:VolumeOuterIntensity)
				WriteVal BufferID (FormatText v1:SubTabString v2:"CoronaSize " v3:CoronaSize)
				WriteVal BufferID (FormatText v1:SubTabString v2:"VolumeOuterExponent " v3:VolumeOuterExponent)
				WriteVal BufferID (FormatText v1:SubTabString v2:"LightFadeDistance " v3:LightFadeDistance)
				WriteVal BufferID (FormatText v1:SubTabString v2:"ShadowFadeDistance " v3:ShadowFadeDistance)
				WriteVal BufferID (FormatText v1:SubTabString v2:"SpecularFadeDistance " v3:SpecularFadeDistance)
				WriteVal BufferID (FormatText v1:SubTabString v2:"VolumetricFadeDistance " v3:VolumetricFadeDistance)
				WriteVal BufferID (FormatText v1:SubTabString v2:"ShadowNearClip " v3:ShadowNearClip)
				WriteVal BufferID (FormatText v1:SubTabString v2:"CoronaIntensity " v3:CoronaIntensity)
				WriteVal BufferID (FormatText v1:SubTabString v2:"CoronaZBias " v3:CoronaZBias)
				WriteVal BufferID (AsoFText Direction TabString:(SubTabString + "Direction "))
				WriteVal BufferID (AsoFText Tangent TabString:(SubTabString + "Tangent "))
				WriteVal BufferID (FormatText v1:SubTabString v2:"ConeInnerAngle " v3:ConeInnerAngle)
				WriteVal BufferID (FormatText v1:SubTabString v2:"ConeOuterAngle " v3:ConeOuterAngle)
				WriteVal BufferID (AsoFText Extents TabString:(SubTabString + "Extents "))
				WriteVal BufferID (FormatText v1:SubTabString v2:"ProjectedTextureHash " v3:(FormattedPrint ProjectedTextureHash format:dwFmt))
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ThisObj BoneNodes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParentNode = undefined
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				for tBone in BoneNodes while No ParentNode where
					not (IsKindOf tBone EGIMS_V_Model) and
					not (IsKindOf tBone.Modifiers[#Model] EGIMS_V_Model_ModelMod) and
					tBone.ID == BoneTag
				do
					ParentNode = tBone
				if No ParentNode then (
					/*if BoneTag != 0 then (
						GIMS.Core.SystemMgr.AddResult #Error  (
							ValueOps.FormatText \
								v1:"Light link error in object \"" \
								v2:ObjName \
								v3:"\" - no bone with tag " \
								v4:BoneTag
						)
					) else*/
						ParentNode = BoneNodes[1]
				)
				local	ParentTM = (
							if ParentNode == RootNode then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						ParentRotation = ParentTM.Rotation,
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique (LightHash as String) ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_Model_Light),
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						Pos = (Position * ParentTM),
						Dir = ((Normalize (-Direction)) * ParentRotation),
						DirMtx = (MatrixFromNormal Dir),
						CPVec = ((Normalize [CullingPlane[1], CullingPlane[2], CullingPlane[3]]) * ParentRotation),
						CPMtx = ((MatrixFromNormal CPVec) * (Inverse DirMtx)),
						CPAngles = (TypeCast (CPMtx.Rotation as EulerAngles) #Array)
				ValueOps.ConvertStruct Result undefined ParamSource:ThisObj DontCreate:true
				Result.Pos = Pos
				Result.Dir = Dir
				Result.TheExtents = Extents[1]
				Result.TheDistance = LightFadeDistance
				Result.ProjectedTextureName = (GIMS.Core.ArrayOps.FetchMHL GIMS.CurrentGame.Core.DB.TextureNames ProjectedTextureHash)
				Result.Type = (
					case LightType of (
						1:
							1
						2:
							2
						4:
							3
						default:
							throw "Unknown light type: " LightType
					)
				)
				Result.CustomCullingPlane = true
				Result.CPDistance = CullingPlane[4]
				/*
				local	ResultCPAngles = Result.CPAngles
				for i = 1 to ResultCPAngles.Count do
					ResultCPAngles[i] = (CPAngles[i] + 180)
				*/
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes*/ strLightAttributes (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes",
		DiskPath,
		ObjName,
		Extension = ".light",
		Version = [165, 30],
		Items = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcLight = GIMS.CurrentGame.Core.TypeLibrary.grcLight,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NotEOF = BufferMgr.NotEOF,
						ItemCount = 0
				Items.Count = 10
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#Attribute: (
							Skip BufferID 1 /* skip start */
							local	NewItem = (grcLight())
							NewItem.Read BufferID /* skips end */
							ItemCount += 1
							Items[ItemCount] = NewItem
						)
						default:
							EGIMS_EHAbort "Unknown strLightAttributes tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				Items.Count = ItemCount
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FilePath = (
							ValueOps.FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t"
				if BufferID != false then (
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					for Item in Items do
						Item.Write BufferID TabString
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for Item in Items do
					Item.Create Item BoneNodes
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcTexture*/ strTexture (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcTexture",
		DiskPath,
		ObjName,
		Extension = ".otx",
		Version = [13, 30],
		TexturePath = "",
		TypeID = 1,
		PixelFormatID = 1,
		UsageID = 1,
		UsageFlags = #{},
		ExtraFlags = 0,
		
		TypeStrings = #(
			"Regular",
			"Cube",
			"Volume"
		),
		TypeNames = #(
			#Regular,
			#Cube,
			#Volume
		),
		PixelFormatStrings = #(
			"DXT5",
			"DXT3",
			"DXT1",
			"A8R8G8B8"
		),
		PixelFormatNames = #(
			#DXT5,
			#DXT3,
			#DXT1,
			#A8R8G8B8
		),
		KnownUsages = #(
			#UNKNOWN,
			#DEFAULT,
			#TERRAIN,
			#CLOUDDENSITY,
			#CLOUDNORMAL,
			#CABLE,
			#FENCE,
			#ENVEFF,
			#SCRIPT,
			#WATERFLOW,
			#WATERFOAM,
			#WATERFOG,
			#WATEROCEAN,
			#WATER,
			#FOAMOPACITY,
			#FOAM,
			#DIFFUSEMIPSHARPEN,
			#DIFFUSEDETAIL,
			#DIFFUSEDARK,
			#DIFFUSEALPHAOPAQUE,
			#DIFFUSE,
			#DETAIL,
			#NORMAL,
			#SPECULAR,
			#EMISSIVE,
			#TINTPALETTE,
			#SKIPPROCESSING,
			#DONOTOPTIMIZE,
			#TEST,
			#COUNT
		),
		KnownUsageFlags = #(
			#NOT_HALF,
			#HD_SPLIT,
			#FLAG_FULL,
			#MAPS_HALF
		),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						GetProgress = BufferMgr.GetProgress,
						FormatText = ValueOps.FormatText,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NotEOF = BufferMgr.NotEOF
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#Image:
							TexturePath = (DiskPath + (tLine[2] as String))
						#Type: (
							TypeID = (FindItem TypeNames (TypeCast tLine[2] name BufferID:BufferID))
							if TypeID == 0 then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Unknown type \"" \
										v2:tLine[2] \
										v3:"\" in object \"" \
										v4:ObjName \
										v5:"\" found at " \
										v6:(BufferMgr.GetErrorInfo BufferID) \
								)
								return false;
							)
						)
						#PixelFormat: (
							PixelFormatID = (FindItem PixelFormatNames (TypeCast tLine[2] name BufferID:BufferID))
							if PixelFormatID == 0 then
								PixelFormatID = 4
								--EGIMS_EHAbort ("Unknown PixelFormat \"" + tLine[2] as String + "\" in object \"" + ObjName + "\" found!") BufferID:BufferID
						)
						#Usage: (
							UsageID = (FindItem KnownUsages (TypeCast tLine[2] name BufferID:BufferID))
							if UsageID == 0 then
								EGIMS_EHAbort ("Unknown Usage \"" + tLine[2] as String + "\" in object \"" + ObjName + "\" found!") BufferID:BufferID
						)
						#UsageFlags: (
							if tLine[2] != "-" then (
								for i = 2 to tLine.Count do (
									local	ID = (FindItem KnownUsageFlags (TypeCast tLine[i] name BufferID:BufferID))
									if ID == 0 then
										EGIMS_EHAbort ("Unknown UsageFlag \"" + tLine[i] as String + "\" in object \"" + ObjName + "\" found!") BufferID:BufferID
									UsageFlags[ID] = true
								)
							)
						)
						#ExtraFlags:
							ExtraFlags = (TypeCast tLine[2] Integer BufferID:BufferID)
						#Levels: (/*skip*/)
						Default:
							EGIMS_EHAbort "Unknown strTexture tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						FilePath = (
							ValueOps.FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TexFileExt = (FileNameFromPath TexturePath),
						ToHighReg = GIMS.Core.StringOps.ToHighReg,
						TypeCast = ValueOps.TypeCast,
						MipLevelCount = 0
				if BufferID != false then (
					if (DoesFileExist TexturePath) then (
						local	TexBitMap = (try (OpenBitMap TexturePath) catch undefined)
						if Have TexBitMap then (
							local	Pixels,
									BitAnd = Bit.And,
									TW = TexBitMap.Width,
									TH = TexBitMap.Height
							Close TexBitMap
							if
								((BitAnd TW (TW - 1)) == 0) and
								((BitAnd TH (TH - 1)) == 0)
							then (
								if TW < TH then
									Pixels = TW
								else
									Pixels = TH
								while Pixels > 2 do (
									MipLevelCount += 1
									Pixels /= 2
								)
							)
						)
						GIMS.Core.SystemMgr.FileCopy TexturePath (DiskPath + TexFileExt)
					) else (
						GIMS.Core.SystemMgr.AddResult #Error  (
							FormatText \
								v1:"Can't find a texture file:\n\"" \
								v2:TexturePath \
								v3:"\"\nPlease copy it by yourself! Otherwise, the resource won't work."
						)
					)
					WriteVal BufferID (ValueOps.AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					WriteVal BufferID ("\tImage " + TexFileExt)
					WriteVal BufferID ("\tType " + TypeStrings[TypeID])
					WriteVal BufferID ("\tPixelFormat " + PixelFormatStrings[PixelFormatID])
					WriteVal BufferID ("\tLevels " + ((TypeCast MipLevelCount Integer BufferID:BufferID) as String))
					WriteVal BufferID ("\tUsage " + (ToHighReg (KnownUsages[UsageID] as String)))
					if UsageFlags.NumberSet == 0 then
						WriteVal BufferID "\tUsageFlags -"
					else (
						WriteVal BufferID "\tUsageFlags "
						for UsageFlag in UsageFlags do
							WriteVal BufferID (" " + (ToHighReg (KnownUsageFlags[UsageFlag] as String))) AppendLast:true
					)
					WriteVal BufferID ("\tExtraFlags " + ((TypeCast ExtraFlags Integer) as String))
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
			#(
				#TypeID,
				#PixelFormatID,
				#UsageID
			), #(
				TypeID,
				PixelFormatID,
				UsageID
			)
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary*/ strTextureDictionary (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary",
		DiskPath,
		ObjName,
		Extension = ".otd",
		Version = [13, 30],
		Items = #(),
		fn Read ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						StringOps = GIMS.Core.StringOps,
						oFTypeExec = StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						\
						grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF,
						\
						TextureNames = GIMS.CurrentGame.Core.DB.TextureNames,
						AppendMHL = GIMS.Core.ArrayOps.AppendMHL,
						IsVersionValid = false
				AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
				if BufferID == false then
					return false;
				local	ItemCount = 0
				Items.Count = 20
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					else
						UpdateProgress #None 0
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip dict start */
							IsVersionValid = true
						)
						Default: (
							if IsVersionValid then (
								local	SubPath = tLine[1],
										TexFileName = (GetFileNameFile SubPath)
								AppendMHL TextureNames TexFileName
								NewItem = (grcTexture DiskPath:(DiskPath + (GetFileNamePath SubPath)) ObjName:TexFileName)
								if not (NewItem.Read()) then
									return false;
								ItemCount += 1
								Items[ItemCount] = NewItem
							) else (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Syntax error in TextureDictionary resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
						)
					)
				)
				Items.Count = ItemCount
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						SubDir = (ObjName + "\\"),
						SubPath = (DiskPath + SubDir),
						ItemHeader = ("\t" + SubDir),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						CurrentProgress = [0, 0, Items.Count],
						\
						TextureNames = GIMS.CurrentGame.Core.DB.TextureNames,
						AppendMHL = GIMS.Core.ArrayOps.AppendMHL
				if BufferID != false then (
					AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
					MakeDir ObjDir All:true
					WriteVal BufferID (ValueOps.AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					for Item in Items do (
						CurrentProgress.x += 1
						UpdateProgress #Progress CurrentProgress
						local	ItemObjName = Item.ObjName
						AppendMHL TextureNames ItemObjName
						WriteVal BufferID (
							FormatText \
								v1:ItemHeader \
								v2:ItemObjName \
								v3:Item.Extension
						)
						Item.DiskPath = SubPath
						Item.Write()
					)
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup*/ strShadingGroup (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup",
		DiskPath,
		ObjName,
		Mtls = #(),
		fn Read BufferID TexPaths = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MtlCount = 0,
						\
						grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture,
						ArrayOps = GIMS.Core.ArrayOps,
						AppendMHL = ArrayOps.AppendMHL,
						QuickSearch = ArrayOps.QuickSearch,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						LoadBitmapFile = GIMS.Core.MaterialOps.LoadBitmapFile,
						GetShaderByName = GIMS.CurrentGame.Core.DB.GetShaderByName,
						TextureNames = GIMS.CurrentGame.Core.DB.TextureNames,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						BitArrayAsValue = ArrayOps.BitArrayAsValue,
						tLine,
						MtlBufferSize = 50
				Mtls.Count = MtlBufferSize
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	SPSName = (GetFileNameFile tLine[1]),
							SPS = (GetShaderByName SPSName),
							Mtl = (EGIMS_V_material SPSName:SPSName ShowInViewport:true),
							MtlName = SPSName,
							SPSShaderParameters = SPS.ShaderParameters,
							MtlSetParam = Mtl.SetParam
					if (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] == "{" then (
						Skip BufferID 1 /* skip shader start */
						while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips shader end */
							local	SPSParamDef = tLine,
									SPSParamName = SPSParamDef[1],
									SPSParamID = (QuickSearch SPSShaderParameters SPSParamName PropertyName:#aName)
							if SPSParamID == 0 then
								EGIMS_EHAbort ("Can't find a " + SPSName + " shader parameter: ") Param1:SPSParamName
							if (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] == "{" then (
								Skip BufferID 1 /* skip param start */
								while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /* skips multiline param end */
									SPSParamDef += tLine
							)
							local	SPSParam = SPSShaderParameters[SPSParamID],
									SPSParamType = SPSParam.aType,
									TheTexParams = unsupplied
							if SPSParamType == #svt_sampler then (
								local	ParamValue = SPSParamDef[2]
								if ParamValue != "*NULL*" then (
									local	TexFilePath = (GetFileNamePath ParamValue),
											TexFileName = (GetFileNameFile ParamValue),
											TexFileType = (GetFileNameType ParamValue),
											IsIncluded = (
												(TexFileType.Count != 0) and
												(DoesFileExist (DiskPath + ParamValue))
											)
									if IsIncluded then (
										local	OTX = (
													grcTexture \
													DiskPath:(DiskPath + TexFilePath) \
													ObjName:TexFileName \
													Extension:TexFileType \
												)
										OTX.Read()
										local	OTXTexturePath = OTX.TexturePath
										TexFilePath = (GetFileNamePath OTXTexturePath)
										TexFileName = (GetFileNameFile OTXTexturePath)
										TheTexParams = (
											Matrix3 \
											[OTX.TypeID, OTX.PixelFormatID, OTX.UsageID] \
											[(BitArrayAsValue OTX.UsageFlags), OTX.ExtraFlags, -1] \
											[-1, -1, -1] \
											[-1, -1, -1] \
										)
									)
									AppendMHL TextureNames TexFileName
									local	DefaultTexColor,
											SPSParamNameAsName = (TypeCast SPSParamName Name BufferID:BufferID)
									if
										SPSParamNameAsName == #DiffuseSampler or
										SPSParamNameAsName == #TextureGrassSampler or
										SPSParamNameAsName == #texturesampler_layer0 or
										SPSParamNameAsName == #texturesampler
									then (
										MtlName = TexFileName
										DefaultTexColor = Red
									) else
										DefaultTexColor = White
									if IsIncluded then
										MtlSetParam SPSParamName SPSParamType (LoadBitmapFile TexFilePath TexFileName BackColor:DefaultTexColor) IsTexInternal:IsIncluded TheTexParams:TheTexParams
									else
										MtlSetParam SPSParamName SPSParamType (LoadBitmapFile (Ternary IsIncluded DiskPath TexPaths) (Append TexFilePath TexFileName) BackColor:DefaultTexColor) IsTexInternal:IsIncluded TheTexParams:TheTexParams
								)
							) else
								MtlSetParam SPSParamName SPSParamType (oFTypeExec SPSParamDef (SPSToGIMSParamType SPSParamType) IDMask:#{2..SPSParamDef.Count} BufferID:BufferID) TheTexParams:TheTexParams
						)
					)
					Mtl.Name = MtlName
					MtlCount += 1
					if MtlCount > MtlBufferSize then (
						MtlBufferSize += 50
						Mtls.Count = MtlBufferSize
					)
					Mtls[MtlCount] = Mtl
				)
				Mtls.Count = MtlCount
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID SubDir TexPath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						AddResult = GIMS.Core.SystemMgr.AddResult,
						AsBitArray = ValueOps.AsBitArray,
						\
						GetShaderByName = GIMS.CurrentGame.Core.DB.GetShaderByName,
						grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture,
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						QuickSearch = GIMS.Core.ArrayOps.QuickSearch,
						TabString = "\t\t",
						SubTabString = (TabString + "\t"),
						DoubleSubTabString = (SubTabString + "\t"),
						BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal
				for MtlID = 1 to Mtls.Count do (
					local	Mtl = Mtls[MtlID],
							GetParam = Mtl.GetParam,
							SPSName = Mtl.SPSName,
							SPS = (GetShaderByName SPSName)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:SPSName \
							v3:".sps" \
					)
					local	ParamNameGroups = #(
								Mtl.TexValueNames,
								Mtl.FloatValueNames,
								Mtl.Matrix3x4ParamNames,
								Mtl.Matrix44ParamNames,
								Mtl.Float2x3ParamNames,
								Mtl.Float4x2ParamNames,
								Mtl.Float4x4ParamNames,
								Mtl.Float4x5ParamNames
							),
							ParamTypeGroups = #(
								#svt_sampler,
								#svt_float,
								#svt_matrix3x4,
								#svt_matrix44,
								#svt_float2x3,
								#svt_float4x2,
								#svt_float4x4,
								#svt_float4x5
							),
							TexInternalFlags = Mtl.TexInternalFlags,
							ShaderParameters = SPS.ShaderParameters,
							HaveParams = false
					for Grp in ParamNameGroups where Grp.Count != 0 while not HaveParams do
						HaveParams = true
					if HaveParams then
						WriteVal BufferID (TabString + "{")
					for GID = 1 to ParamNameGroups.Count do (
						local	ParamNames = ParamNameGroups[GID],
								ParamType = ParamTypeGroups[GID]
						for PID = 1 to ParamNames.Count do (
							local	ParamName = ParamNames[PID],
									SPSParamID = (QuickSearch ShaderParameters ParamName PropertyName:#aName)
							if SPSParamID != 0 then (
								local	SPSParam = ShaderParameters[SPSParamID]
								local	ParamValueData = (GetParam ParamName ParamType GetParamIDToo:true),
										ParamValue = ParamValueData[1],
										ParamID = ParamValueData[2],
										GIMSParamType = (SPSToGIMSParamType SPSParam.aType),
										ValueToWrite = (
											if GID == 1 then (
												if Have ParamValue then (
													local	FilePath = ParamValue.FileName,
															FileName = (GetFileNameFile FilePath),
															IncAndParams = (GetParam ParamName ParamType GetIsTexInternal:true ParamID:ParamID GetTexParams:true)
													if IncAndParams[1] then (
														if (DoesFileExist FilePath) then (
															local	FileNameExt = (FileNameFromPath FilePath),
																	NewPath = (TexPath + FileNameExt),
																	TexParams = IncAndParams[2],
																	OTX = (
																		grcTexture \
																			DiskPath:TexPath \
																			ObjName:FileName \
																			TexturePath:FilePath \
																			TypeID:TexParams[1][1] \
																			PixelFormatID:TexParams[1][2] \
																			UsageID:TexParams[1][3] \
																			UsageFlags:(AsBitArray TexParams[2][1]) \
																			ExtraFlags:TexParams[2][2] \
																	)
															OTX.Write()
															(
																FormatText \
																	v1:SubDir \
																	v2:FileName \
																	v3:OTX.Extension
															)
														) else (
															AddResult #Warning  (
																FormatText \
																	v1:"Can't find an embedded texture file:\n\"" \
																	v2:FilePath \
																	v3:"\"\nIt will be stored as external."
															)
															FileName
														)
													) else
														FileName
												) else 
													"*NULL*"
											) else
												(TypeCast ParamValue GIMSParamType BufferID:BufferID)
										)
								WriteVal BufferID (AsoFText ParamName TabString:SubTabString)
								if
									ParamType == #svt_matrix3x4 or
									ParamType == #svt_float4x2 or
									ParamType == #svt_float4x4 or
									ParamType == #svt_matrix44 or
									ParamType == #svt_float2x3 or
									ParamType == #svt_float4x5
								then (
									WriteVal BufferID (SubTabString + "{")
									for Val in ValueToWrite do
										WriteVal BufferID (AsoFText Val TabString:DoubleSubTabString)
									WriteVal BufferID (SubTabString + "}")
								) else
									WriteVal BufferID (AsoFText ValueToWrite TabString:" ") AppendLast:true
							)
						)
					)
					if HaveParams then
						WriteVal BufferID (TabString + "}")
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #SubDir, #TexPath), #(DiskPath, ObjName, SubDir, TexPath)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcJointLimit*/ strJointLimit (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcJointLimit",
		BoneID,
		LimitMin,
		LimitMax,
		fn Read BufferID LineItems Header = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						Skip = BufferMgr.Skip,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				local	Tag = (TypeCast LineItems[1] Name BufferID:BufferID)
				if Tag == Header then (
					BoneID = (TypeCast LineItems[2] Integer BufferID:BufferID)
					Skip BufferID 1	--skip start
					while (LineItems = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	--skips end
						local	Subtag = (TypeCast LineItems[1] Name BufferID:BufferID)
						case Subtag of (
							#LimitMin:
								LimitMin = (oFTypeExec LineItems #P3 IDMask:#{2..4} BufferID:BufferID)
							#LimitMax:
								LimitMax = (oFTypeExec LineItems #P3 IDMask:#{2..4} BufferID:BufferID)
							default:
								EGIMS_EHAbort "Unknown strJointLimit subtag " Param1:LineItems[1] BufferID:BufferID
						)
					)
				) else
					EGIMS_EHAbort "Unknown strJointLimit tag " Param1:LineItems[1] BufferID:BufferID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString Header = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						AsoFText = GIMS.Core.ValueOps.AsoFText,
						SubTabString = (TabString + "\t")
				WriteVal BufferID (Header + (BoneID as String))
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (AsoFText LimitMin TabString:(SubTabString + "LimitMin "))
				WriteVal BufferID (AsoFText LimitMax TabString:(SubTabString + "LimitMax "))
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyP3ToAP P3 Arr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for i = 1 to 3 do
					Arr[i] = P3[i]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes Type = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case Type of (
					1: (
						for tBone in BoneNodes where tBone.ID == BoneID do (
							CopyP3ToAP LimitMin tBone.RotMin
							CopyP3ToAP LimitMax tBone.RotMax
							--tBone.UseJoints = true
						)
					)
					2: (
						for tBone in BoneNodes where tBone.ID == BoneID do (
							CopyP3ToAP LimitMin tBone.TransMin
							CopyP3ToAP LimitMax tBone.TransMax
							--tBone.UseJoints = true
						)
					)
					3: (
						for tBone in BoneNodes where tBone.ID == BoneID do (
							CopyP3ToAP LimitMin tBone.ScaleMin
							CopyP3ToAP LimitMax tBone.ScaleMax
							--tBone.UseJoints = true
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcJoints*/ strJoints (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcJoints",
		DiskPath,
		ObjName,
		Extension = ".joints",
		Version = [165, 30],
		RotationLimits = #(),
		TranslationLimits = #(),
		ScaleLimits = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcJointLimit = GIMS.CurrentGame.Core.TypeLibrary.grcJointLimit,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NotEOF = BufferMgr.NotEOF
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#RotationLimits: (
							local	Param2 = tLine[2]
							if (TypeCast Param2 Name BufferID:BufferID) != #NULL then (
								RotationLimits.Count = (TypeCast Param2 Integer BufferID:BufferID)
								local	LimitCount = 0,
										LineItems
								Skip BufferID 1	/* skip start */
								while (LineItems = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	--skips end
									local	NewItem = (grcJointLimit())
									NewItem.Read BufferID LineItems #RotationLimit	/* skips end */
									LimitCount += 1
									RotationLimits[LimitCount] = NewItem
								)
								RotationLimits.Count = LimitCount
							)
						)
						#TranslationLimits: (
							local	Param2 = tLine[2]
							if (TypeCast Param2 Name BufferID:BufferID) != #NULL then (
								TranslationLimits.Count = (TypeCast Param2 Integer BufferID:BufferID)
								local	LimitCount = 0,
										LineItems
								Skip BufferID 1	/* skip start */
								while (LineItems = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	--skips end
									local	NewItem = (grcJointLimit())
									NewItem.Read BufferID LineItems #TranslationLimit	/* skips end */
									LimitCount += 1
									TranslationLimits[LimitCount] = NewItem
								)
								TranslationLimits.Count = LimitCount
							)
						)
						#ScaleLimits: (
							local	Param2 = tLine[2]
							if (TypeCast Param2 Name BufferID:BufferID) != #NULL then (
								ScaleLimits.Count = (TypeCast Param2 Integer BufferID:BufferID)
								local	LimitCount = 0,
										LineItems
								Skip BufferID 1	/* skip start */
								while (LineItems = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	--skips end
									local	NewItem = (grcJointLimit())
									NewItem.Read BufferID LineItems #ScaleLimit	/* skips end */
									LimitCount += 1
									ScaleLimits[LimitCount] = NewItem
								)
								ScaleLimits.Count = LimitCount
							)
						)
						default:
							EGIMS_EHAbort "Unknown strLightAttributes tag " Param1:tLine[1] BufferID:BufferID
					)
				)
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						FilePath = (
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t",
						TabOpenString = "\t{",
						TabCloseString = "\t}",
						DoubleTabString = (TabString + TabString),
						RotationLimitsHeader = (DoubleTabString + "RotationLimit "),
						TranslationLimitsHeader = (DoubleTabString + "TranslationLimit "),
						ScaleLimitsHeader = (DoubleTabString + "ScaleLimit ")
				if BufferID != false then (
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					local	RotationLimitsCount = RotationLimits.Count,
							TranslationLimitsCount = TranslationLimits.Count,
							ScaleLimitsCount = ScaleLimits.Count
					if RotationLimitsCount != 0 then (
						WriteVal BufferID (FormatText v1:TabString v2:"RotationLimits " v3:RotationLimitsCount)
						WriteVal BufferID TabOpenString
						for Limit in RotationLimits do
							Limit.Write BufferID DoubleTabString RotationLimitsHeader
						WriteVal BufferID TabCloseString
					) else
						WriteVal BufferID (TabString + "RotationLimits null")
					if TranslationLimitsCount != 0 then (
						WriteVal BufferID (FormatText v1:TabString v2:"TranslationLimits " v3:TranslationLimitsCount)
						WriteVal BufferID TabOpenString
						for Limit in TranslationLimits do
							Limit.Write BufferID DoubleTabString TranslationLimitsHeader
						WriteVal BufferID TabCloseString
					) else
						WriteVal BufferID (TabString + "TranslationLimits null")
					if ScaleLimitsCount != 0 then (
						WriteVal BufferID (FormatText v1:TabString v2:"ScaleLimits " v3:ScaleLimitsCount)
						WriteVal BufferID TabOpenString
						for Limit in ScaleLimits do
							Limit.Write BufferID DoubleTabString ScaleLimitsHeader
						WriteVal BufferID TabCloseString
					) else
						WriteVal BufferID (TabString + "ScaleLimits null")
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for Limit in RotationLimits do
					Limit.Create BoneNodes 1
				for Limit in TranslationLimits do
					Limit.Create BoneNodes 2
				for Limit in ScaleLimits do
					Limit.Create BoneNodes 3
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcDrawable*/ strDrawable (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDrawable",
		DiskPath,
		ObjName,
		Extension = ".odr",
		Version = [165, 32],
		ShadingGroup,
		TheSkeleton,
		TheSkeleton_FULL = unsupplied,
		LODGroup,
		LightAttributes,
		Bound,
		Joints,
		fn CheckLocked = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Locked = false
				if Have LODGroup then (
					for LODGroup in LODGroup.LODGroups while not Locked where LODGroup.Count != 0 do (
						for LODMesh in LODGroup while not Locked where LODMesh.Locked do
							Locked = true
					)
				)
				Locked
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*
				LightAttributes
				TheSkeleton
				if Have LODGroup then
					LODGroup.LODGroups[0].LODMesh
				*/
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#CachePath), #(CachePath)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read TexPaths ReportProgress:true CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						Skip = BufferMgr.Skip,
						StringOps = GIMS.Core.StringOps,
						oFTypeExec = StringOps.oFTypeExec,
						NoCaseOrderComparator = StringOps.NoCaseOrderComparator,
						\
						grcShadingGroup = GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup,
						grcSkeleton = GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton,
						grcJoints = GIMS.CurrentGame.Core.TypeLibrary.grcJoints,
						grcLODGroup = GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup,
						grcLightAttributes = GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes,
						grcPhBound = GIMS.CurrentGame.Core.TypeLibrary.grcPhBound,
						FormatText = ValueOps.FormatText,
						ArrayOps = GIMS.Core.ArrayOps,
						ObjectNames = GIMS.CurrentGame.Core.DB.ObjectNames,
						NotEOF = BufferMgr.NotEOF,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						tLine,
						IsVersionValid = false
				ArrayOps.AppendMHL ObjectNames ObjName
				if BufferID == false then
					return false;
				if No TexPaths then
					TexPaths = DiskPath
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					else
						UpdateProgress #None 0
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
							IsVersionValid = true
						)
						#Shaders: (
							Skip BufferID 1 /* skip start */
							if
								tLine.Count == 1 or
								(TypeCast tLine[2] name BufferID:BufferID) != #NULL
							then (
								ShadingGroup = (grcShadingGroup DiskPath:DiskPath ObjName:ObjName)
								ShadingGroup.Read BufferID TexPaths
							)
						)
						#Skeleton: (
							local	PathParam = tLine[2]
							for i = 3 to tLine.Count do (
								Append PathParam " "
								Append PathParam tLine[i]
							)
							if (TypeCast PathParam name BufferID:BufferID) != #NULL then (
								local	SkelDiskPath = (DiskPath + (GetFileNamePath PathParam)),
										SkelObjName = (GetFileNameFile PathParam)
								TheSkeleton = (grcSkeleton DiskPath:SkelDiskPath ObjName:SkelObjName Extension:(GetFileNameType PathParam))
								if not (TheSkeleton.Read()) then
									return false;
							)
						)
						#LODGroup: (
							Skip BufferID 1 /* skip start */
							LODGroup = (grcLODGroup DiskPath:DiskPath)
							if not (LODGroup.Read BufferID ShadingGroup) then
								return false;
						)
						#Light: (
							local	PathParam = tLine[2]
							for i = 3 to tLine.Count do (
								Append PathParam " "
								Append PathParam tLine[i]
							)
							if (TypeCast PathParam name BufferID:BufferID) != #NULL then (
								LightAttributes = (grcLightAttributes DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
								if not (LightAttributes.Read()) then
									return false;
							)
						)
						#Bound: (
							local	PathParam = tLine[2]
							for i = 3 to tLine.Count do (
								Append PathParam " "
								Append PathParam tLine[i]
							)
							if (TypeCast PathParam name BufferID:BufferID) != #NULL then (
								Bound = (grcPhBound DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
								if not (
									Bound.Read \
										ReportProgress:false \
										BufferMgr:BufferMgr \
										Skip:Skip \
										ReadVal:ReadVal \
										TypeCast:TypeCast \
										oFTypeExec:oFTypeExec \
										GetProgress:GetProgress \
										UpdateProgress:UpdateProgress \
										FormatText:FormatText \
										NotEOF:NotEOF \
										grcPhBound:grcPhBound \
										ValueOps:ValueOps \
										AppendMHL:ArrayOps.AppendMHL \
										FetchMHL:ArrayOps.FetchMHL \
										QuickSearch:ArrayOps.QuickSearch \
										ObjectNames:ObjectNames \
										NoCaseOrderComparator:NoCaseOrderComparator \
										UpdateMatrix:ValueOps.UpdateMatrix
								) then
									return false;
							)
						)
						#Joints: (
							local	PathParam = tLine[2]
							for i = 3 to tLine.Count do (
								Append PathParam " "
								Append PathParam tLine[i]
							)
							if (TypeCast PathParam name BufferID:BufferID) != #NULL then (
								Joints = (grcJoints DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
								if not (Joints.Read()) then
									return false;
							)
						)
						Default: (
							if IsVersionValid then
								EGIMS_EHAbort "Unknown strDrawable tag: " Param1:tLine[1] BufferID:BufferID
							else (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Syntax error in Drawable resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
						)
					)
				)
				BufferMgr.ClearBuffer BufferID
				local	Result = true
				if not Supplied TheSkeleton_FULL then (
					local	SkelObjName_FULL = (ObjName + " FULL"),
							SkelExtension = ".skel",
							SkelPath_FULL = (
								FormatText \
									v1:DiskPath \
									v2:SkelObjName_FULL \
									v3:SkelExtension
							)
					if (DoesFileExist SkelPath_FULL) then (
						TheSkeleton_FULL = (grcSkeleton DiskPath:DiskPath ObjName:SkelObjName_FULL Extension:SkelExtension)
						if not (TheSkeleton_FULL.Read()) then
							Result = false
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #TexPaths), #(DiskPath, ObjName, Extension, TexPaths)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write Progress:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No LODGroup then
					throw "No LODGroup"
				if not Supplied Progress then
					Progress = [0, 0, 4]
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						StringOps = GIMS.Core.StringOps,
						NoCaseOrderComparator = StringOps.NoCaseOrderComparator,
						ToHighReg = StringOps.ToHighReg,
						ArrayOps = GIMS.Core.ArrayOps,
						FormatText = ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						SubDir = (ObjName + "\\"),
						SubPath = (DiskPath + SubDir),
						HaveMeshes = false,
						LODGroups = LODGroup.LODGroups,
						HaveShadingGroup = (Have ShadingGroup),
						HaveTheSkeleton = (Have TheSkeleton),
						HaveJoints = (Have Joints),
						HaveBound = (Have Bound),
						HaveLightAttributes = (Have LightAttributes),
						TabString = "\t",
						BraceOpen = "{",
						BraceClose = "}",
						TabBraceOpen = (TabString + BraceOpen),
						TabBraceClose = (TabString + BraceClose)
				if BufferID != false then (
					ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
					for LODGroup in LODGroups while not HaveMeshes where LODGroup.Count != 0 do
						HaveMeshes = true
					if
						HaveTheSkeleton or
						HaveJoints or
						HaveBound or
						HaveLightAttributes or
						HaveShadingGroup or
						HaveMeshes
					then
						MakeDir SubPath All:true
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID BraceOpen
					if HaveShadingGroup then (
						WriteVal BufferID "\tShaders"
						WriteVal BufferID TabBraceOpen
						ShadingGroup.Write BufferID SubDir SubPath
						WriteVal BufferID TabBraceClose
					) else
						WriteVal BufferID "\tShaders null"
					Progress.x += 1
					UpdateProgress #Progress Progress
					if HaveTheSkeleton then (
						TheSkeleton.ObjName = ObjName
						TheSkeleton.DiskPath = SubPath
						WriteVal BufferID (
							FormatText \
							v1:"\tSkeleton " \
							v2:SubDir \
							v3:ObjName \
							v4:TheSkeleton.Extension
						)
						TheSkeleton.Write()
					) else
						WriteVal BufferID "\tSkeleton null"
					Progress.x += 1
					UpdateProgress #Progress Progress
					WriteVal BufferID "\tLodGroup"
					WriteVal BufferID TabBraceOpen
					LODGroup.DiskPath = SubPath
					LODGroup.Write BufferID SubDir ShadingGroup
					Progress.x += 1
					UpdateProgress #Progress Progress
					WriteVal BufferID TabBraceClose
					if HaveLightAttributes then (
						LightAttributes.ObjName = ObjName
						LightAttributes.DiskPath = SubPath
						WriteVal BufferID (
							FormatText \
							v1:"\tLight " \
							v2:SubDir \
							v3:ObjName \
							v4:LightAttributes.Extension
						)
						LightAttributes.Write()
					) else
						WriteVal BufferID "\tLight null"
					if HaveBound then (
						local	BoundExtension = ".bound"
						Bound.ObjName = ObjName
						Bound.Extension = BoundExtension
						Bound.DiskPath = SubPath
						WriteVal BufferID (
							FormatText \
							v1:"\tBound " \
							v2:SubDir \
							v3:ObjName \
							v4:BoundExtension
						)
						Bound.Write \
							NoCaseOrderComparator:NoCaseOrderComparator \
							ToHighReg:ToHighReg \
							BufferMgr:BufferMgr \
							WriteVal:WriteVal \
							ValueOps:ValueOps \
							FormatText:FormatText \
							AsoFText:AsoFText \
							TypeCast:TypeCast \
							UpdateProgress:UpdateProgress \
							ArrayOps:ArrayOps \
							Modify:ArrayOps.Modify \
							ReportProgress:false
					) else
						WriteVal BufferID "\tBound null"
					if HaveJoints then (
						Joints.ObjName = ObjName
						Joints.DiskPath = SubPath
						WriteVal BufferID (
							FormatText \
							v1:"\tJoints " \
							v2:SubDir \
							v3:ObjName \
							v4:Joints.Extension
						)
						Joints.Write()
					) else
						WriteVal BufferID "\tJoints null"
					WriteVal BufferID BraceClose
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true Progress:unsupplied IsSeparate:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if
					ReportProgress and
					not Supplied Progress
				then
					Progress = [0, 0, 4]
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_Model),
						ParentTM = (
							if IsSeparate then (
								if ParentNode == RootNode then
									(Matrix3 1)
								else
									ParentNode.Transform
							)
						),
						BoneNodes = #(Result)
				if Have LODGroup then
					Result.LODGroupValues = LODGroup.LODGroupValues
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
						UpdateProgress #None 0
				local	HaveTheSkeleton = (Have TheSkeleton),
						HaveTheSkeleton_FULL = (Supplied TheSkeleton_FULL),
						ActiveSkeleton = (
							if HaveTheSkeleton_FULL then
								TheSkeleton_FULL
							else
								TheSkeleton
						),
						HaveActiveSkeleton = (Have ActiveSkeleton)
				if HaveTheSkeleton then
					Result.DataCRC = TheSkeleton.DataCRC
				else
					Result.UseBones = false
				if HaveActiveSkeleton then (
					BoneNodes.Count = ActiveSkeleton.NumBones
					ActiveSkeleton.Create Result BoneNodes
					if Have Joints then
						Joints.Create BoneNodes
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
						UpdateProgress #None 0
				if Have LODGroup then
					LODGroup.Create BoneNodes ShadingGroup TheSkeleton HaveTheSkeleton TheSkeleton_FULL HaveTheSkeleton_FULL HaveActiveSkeleton
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
						UpdateProgress #None 0
				if Have LightAttributes then
					LightAttributes.Create BoneNodes
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				if Have Bound then
					Bound.Create BoneNodes[1]
				if
					IsSeparate and
					Have Result
				then
					Result.Transform = ParentTM
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary*/ strDrawableDictionary (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary",
		DiskPath,
		ObjName,
		Extension = ".odd",
		Version = [165, 32],
		Items = #(),

		fn CheckLocked = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Locked = false
				for Item in Items while not Locked do
					Locked = (Item.CheckLocked())
				Locked
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*
				Items[0]
					LightAttributes
					TheSkeleton
					LODGroup.LODGroups[0].LODMesh
				*/
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#CachePath), #(CachePath)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read TexPaths ReportProgress:true CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						StringOps = GIMS.Core.StringOps,
						oFTypeExec = StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						\
						grcDrawable = GIMS.CurrentGame.Core.TypeLibrary.grcDrawable,
						grcSkeleton = GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF
				GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
				if BufferID == false then
					return false;
				if No TexPaths then
					TexPaths = DiskPath
				local	IsVersionValid = false,
						SkelObjName_FULL = (ObjName + " FULL"),
						SkelExtension = ".skel",
						SkelPath_FULL = (
							FormatText \
								v1:DiskPath \
								v2:SkelObjName_FULL \
								v3:SkelExtension
						),
						TheSkeleton_FULL = unsupplied
				if (DoesFileExist SkelPath_FULL) then (
					local	TheSkeleton_FULL = (grcSkeleton DiskPath:DiskPath ObjName:SkelObjName_FULL Extension:SkelExtension)
					if not (TheSkeleton_FULL.Read()) then
						return false;
				)
				local	tRAWLine,
						ItemCount = 0
				Items.Count = 20
				while
					(NotEOF BufferID) and
					(TrimLeft (tRAWLine = (ReadVal BufferID)))[1] != "}"
				do (	--skips end
					local	tLine = (FilterString tRAWLine "\t ")
					if tLine.Count > 0 then (
						local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
						case Tag of (
							#Version: (
								if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
									GIMS.Core.SystemMgr.AddResult #Error  (
										FormatText \
											v1:"Wrong version resource \"" \
											v2:DiskPath \
											v3:ObjName \
											v4:Extension \
											v5:"\""
									)
									return false;
								)
								Skip BufferID 1 /* skip dict start */
								IsVersionValid = true
							)
							Default: (
								if IsVersionValid then (
									local	SubPath = (FilterString tRAWLine "\t")[1]
									NewItem = (grcDrawable DiskPath:(DiskPath + (GetFileNamePath SubPath)) ObjName:(GetFileNameFile SubPath) TheSkeleton_FULL:TheSkeleton_FULL)
									if not (NewItem.Read TexPaths ReportProgress:false) then
										return false;
									ItemCount += 1
									Items[ItemCount] = NewItem
								) else (
									GIMS.Core.SystemMgr.AddResult #Error  (
										FormatText \
											v1:"Syntax error in Drawable resource \"" \
											v2:DiskPath \
											v3:ObjName \
											v4:Extension \
											v5:"\""
									)
									return false;
								)
							)
						)
						if ReportProgress then
							UpdateProgress #Progress (GetProgress BufferID)
						else
							UpdateProgress #None 0
					)
				)
				Items.Count = ItemCount
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #TexPaths), #(DiskPath, ObjName, Extension, TexPaths)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = GIMS.Core.ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						SubDir = (ObjName + "\\"),
						SubPath = (DiskPath + SubDir),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ItemHeader = ("\t" + SubDir),
						Progress = [0, 0, Items.Count * 4]
				GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
				MakeDir ObjDir All:true
				WriteVal BufferID (ValueOps.AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Item in Items do (
					WriteVal BufferID (
						FormatText \
							v1:ItemHeader \
							v2:Item.ObjName \
							v3:Item.Extension
					)
					Item.DiskPath = SubPath
					Item.Write Progress:Progress
				)
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:FilePath
				BufferMgr.ClearBuffer BufferID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_ModelDict),
						ItemCount = Items.Count,
						Progress = [0, 0, ItemCount * 4]
				for i = 1 to ItemCount do
					Items[i].Create Result ReportProgress:ReportProgress Progress:Progress IsSeparate:false
				if
					Have Result and
					ParentNode != RootNode
				then
					Result.Transform = ParentNode.Transform
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
/*paths*/

	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcDistantLightGroup*/ strDistantLightGroup (	--TODO remove debug blocks; create
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDistantLightGroup",
		Centroid,
		Radius,
		PointOffset,
		PointCount,
		Flags,
		DisplayProperties,
		DistanceOffset,
		RandomSeed,
		
		/*TODO remove, debug*/
		CollectionIndex,
		/**/
					
		fn Read BufferID ReadVal = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Centroid = (ReadVal BufferID MAXType:#P3 BinType:#Short)
				Radius = (ReadVal BufferID BinType:#Short)
				PointOffset = (ReadVal BufferID BinType:#Short)
				PointCount = (ReadVal BufferID BinType:#Short)
				Flags = (ReadVal BufferID BinType:#UShort)
				DisplayProperties = (ReadVal BufferID BinType:#UShort)
				DistanceOffset = (ReadVal BufferID BinType:#Float)
				RandomSeed = (ReadVal BufferID BinType:#Int)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID WriteVal = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				WriteVal BufferID Centroid BinType:#Short
				WriteVal BufferID Radius BinType:#Short
				WriteVal BufferID PointOffset BinType:#Short
				WriteVal BufferID PointCount BinType:#Short
				WriteVal BufferID Flags BinType:#UShort
				WriteVal BufferID DisplayProperties BinType:#UShort
				WriteVal BufferID DistanceOffset BinType:#Float
				WriteVal BufferID RandomSeed BinType:#Int
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode Points/*TODO remove, debug*/ UsedPoints/**/ = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (				
				local	spath = (SplineShape Parent:ParentNode WireColor:Blue Name:(CollectionIndex as String)/*TODO remove, debug*/ VertexTicks:true/**/)	--TODO remake to some other object name
				AddNewSpline spath
				for i = 1 to PointCount do (
					AddKnot spath 1 #Corner #Line Points[PointOffset + i]
					/*TODO remove, debug*/
					if UsedPoints[PointOffset + i] then
						Format "Point % reused" (PointOffset + i)
					else
						UsedPoints[PointOffset + i] = true
					/**/
				)
				UpdateShape spath
				spath.Pivot = Centroid
				spath
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcDistantLights*/ strDistantLights (	--TODO remove debug blocks; create
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDistantLights",
		DiskPath,
		ObjName,
		Extension = ".dat",
		Points,
		Groups,
		FirstGroups,
		CoastalGroupNums,
		InlandGroupNums,

		fn Read ReportProgress:true CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						grcDistantLightGroup = GIMS.CurrentGame.Core.TypeLibrary.grcDistantLightGroup,
						BufferID = (
							BufferMgr.ReadFile (
								GIMS.Core.ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#NETBinStream BigEndian:true
						),
						SectorCount = 1024
				if BufferID == false then
					return false;
				local	m_numPoints = (ReadVal BufferID BinType:#Int),
						m_numGroups = (ReadVal BufferID BinType:#Int)
				FirstGroups = (ReadVal BufferID MAXType:#Array Size:SectorCount BinType:#Int)
				CoastalGroupNums = (ReadVal BufferID MAXType:#Array Size:SectorCount BinType:#Int)
				InlandGroupNums = (ReadVal BufferID MAXType:#Array Size:SectorCount BinType:#Int)
				Points = (ReadVal BufferID MAXType:#Array Size:m_numPoints ArrayItemMAXType:#P3 BinType:#Short)
				Groups = #()
				Groups.Count = m_numGroups
				for i = 1 to m_numGroups do (
					--TODO uncomment, working code	local	grp = (grcDistantLightGroup())
					/*TODO remove, debug*/
					local	grp = (grcDistantLightGroup CollectionIndex:i)
					/**/
					grp.Read BufferID ReadVal
					Groups[i] = grp
				)
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						FilePath = (
							GIMS.Core.ValueOps.FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create FilePath:FilePath Mode:#NETBinStream BigEndian:true)
				if BufferID != false then (
					WriteVal BufferID Points.Count BinType:#Int
					WriteVal BufferID Groups.Count BinType:#Int
					WriteVal BufferID FirstGroups BinType:#Int
					WriteVal BufferID CoastalGroupNums BinType:#Int
					WriteVal BufferID InlandGroupNums BinType:#Int
					WriteVal BufferID Points BinType:#Short
					for grp in Groups do
						grp.Write BufferID WriteVal
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true = (	--TODO test and make properly
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			
				/*TODO remove, debug*/
				local	UsedPoints = #{}
				UsedPoints.Count = Points.Count
				/**/
				
				local	UpdateProgress,
						ProgressData,
						Result = (Dummy Name:"DistantLights")	--TODO create GIMS object
				if ReportProgress then (
					UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					ProgressData = [0, 0, Groups.Count]
				)
				for grp in Groups do (
					if ReportProgress then (
						ProgressData.x += 1
						UpdateProgress #Progress ProgressData
					)
					grp.Create Result Points/*TODO remove, debug*/ UsedPoints/**/
				)
			
				/*TODO remove, debug*/
				local	d = (Dummy Name:"DEBUG" Parent:Result),
						SS = (StringStream ""),
						sid = 1
				for sy = 0 to 31 do (
					local	blockY = (((sy + 0.5) * 512.0) - 8192.0)
					for sx = 0 to 31 do (
						local	blockX = (((sx + 0.5) * 512.0) - 8192.0)
						Format "F %\r\nC %\r\nI %" FirstGroups[sid] CoastalGroupNums[sid] InlandGroupNums[sid] To:SS
						(Text Pos:[blockX, blockY + 110, 1000] Text:(SS as String) Size:150 WireColor:Black ShowFrozenInGray:false Parent:d).IsFrozen = true
						Free SS
						sid += 1
					)
				)
				(Plane Pos:[0, 0, -1000] length:16384 width:16384 lengthsegs:32 widthsegs:32 WireColor:Black ShowFrozenInGray:false Parent:d).IsFrozen = true
				/**/
				
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordingItem*/ strVehicleRecordingItem (	--TODO	test-read	test-create	test-write
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordingItem",
		KeyTime = 0,
		Position = [0, 0, 0],
		Right = [1, 0, 0],
		Top = [0, 1, 0],
		Velocity = #(0, 0, 0),
		SteeringAngle = 0,
		GasPedalPower = 0,
		BreakPedalPower = 0,
		UseHandBrake = false,
		
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Time:	--46692
							KeyTime = ((TypeCast tLine[2] Float BufferID:BufferID) / frameRate)
						#Position:	--724.52000000 -4341.40100000 385.90720000
							Position = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Velocity:	--56.59231000 -32.89773000 9.45585600
							Velocity = (oFTypeExec tLine #FloatArray IDMask:#{2..4} BufferID:BufferID)
						#Right:	---0.49606300 -0.85826770 0.00000000
							Right = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#Top:	--0.85039370 -0.48818900 0.17322830
							Top = (oFTypeExec tLine #P3 IDMask:#{2..4} BufferID:BufferID)
						#SteeringAngle:	--0.00000000
							SteeringAngle = (-(RadToDeg (TypeCast tLine[2] Float BufferID:BufferID)))
						#GasPedalPower:	--1.00000000
							GasPedalPower = (TypeCast tLine[2] Float BufferID:BufferID)
						#BreakPedalPower:	--0.00000000
							BreakPedalPower = (TypeCast tLine[2] Float BufferID:BufferID)
						#UseHandBrake:	--false
							UseHandBrake = (TypeCast tLine[2] BooleanClass BufferID:BufferID)
						default:
							EGIMS_EHAbort "Unknown strVehicleRecordingItem tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						CopyBits = ValueOps.CopyBits,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						SubTabString = (TabString + "\t"),
						FloatFmtStr = "0.6f"
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				WriteVal BufferID (TabString + "Item")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (FormatText v1:SubTabString v2:"Time " v3:((KeyTime * frameRate) as Integer))
				WriteVal BufferID (AsoFText Position 	TabString:(SubTabString + "Position "))	
				WriteVal BufferID (AsoFText Velocity 	TabString:(SubTabString + "Velocity "))	
				WriteVal BufferID (AsoFText Right 		TabString:(SubTabString + "Right "))	
				WriteVal BufferID (AsoFText Top 		TabString:(SubTabString + "Top "))	
				WriteVal BufferID (FormatText v1:SubTabString v2:"SteeringAngle " 	v3:(FormattedPrint (DegToRad (-SteeringAngle)) Format:FloatFmtStr))	
				WriteVal BufferID (FormatText v1:SubTabString v2:"GasPedalPower " 	v3:(FormattedPrint GasPedalPower Format:FloatFmtStr))	
				WriteVal BufferID (FormatText v1:SubTabString v2:"BreakPedalPower "	v3:(FormattedPrint BreakPedalPower Format:FloatFmtStr))	
				WriteVal BufferID (FormatText v1:SubTabString v2:"UseHandBrake "	v3:(FormattedPrint UseHandBrake Format:FloatFmtStr))	
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ThisObj AnimNode /*TODO remove, debug*mtxMode/**/ = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	vR = (Normalize Right),
						vT = (Normalize Top),
						vF = (Normalize (Cross vR vT)),
						rotMtx = (Matrix3 vR vT vF [0,0,0]),
						rot = (rotMtx.Rotation as EulerAngles)
				
				/*TODO remove, debug*
				case mtxMode of (
					1:	rotMtx = (Matrix3 vR vF vT [0,0,0])
					2:	rotMtx = (Matrix3 vR vT vF [0,0,0])
					3:	rotMtx = (Matrix3 vF vR vT [0,0,0])
					4:	rotMtx = (Matrix3 vF vT vR [0,0,0])
					5:	rotMtx = (Matrix3 vT vF vR [0,0,0])
					6:	rotMtx = (Matrix3 vT vR vF [0,0,0])
						
					7:	rotMtx = (Matrix3 -vR vF vT [0,0,0])
					8:	rotMtx = (Matrix3 -vR vT vF [0,0,0])
					9:	rotMtx = (Matrix3 -vF vR vT [0,0,0])
					10:	rotMtx = (Matrix3 -vF vT vR [0,0,0])
					11:	rotMtx = (Matrix3 -vT vF vR [0,0,0])
					12:	rotMtx = (Matrix3 -vT vR vF [0,0,0])

					13:	rotMtx = (Matrix3 vR -vF vT [0,0,0])
					14:	rotMtx = (Matrix3 vR -vT vF [0,0,0])
					15:	rotMtx = (Matrix3 vF -vR vT [0,0,0])
					16:	rotMtx = (Matrix3 vF -vT vR [0,0,0])
					17:	rotMtx = (Matrix3 vT -vF vR [0,0,0])
					18:	rotMtx = (Matrix3 vT -vR vF [0,0,0])

					19:	rotMtx = (Matrix3 vR vF -vT [0,0,0])
					20:	rotMtx = (Matrix3 vR vT -vF [0,0,0])
					21:	rotMtx = (Matrix3 vF vR -vT [0,0,0])
					22:	rotMtx = (Matrix3 vF vT -vR [0,0,0])
					23:	rotMtx = (Matrix3 vT vF -vR [0,0,0])
					24:	rotMtx = (Matrix3 vT vR -vF [0,0,0])
					
					default:
						throw "Unknown mtxMode"
				)
				/**/
						
				at Time KeyTime (
					GIMS.Core.ValueOps.ConvertStruct AnimNode undefined ParamSource:ThisObj DontCreate:true
					--AnimNode.Rotation = (Quat rotMtx.Rotation.x rotMtx.Rotation.y (-rotMtx.Rotation.z) rotMtx.Rotation.w)
					AnimNode.Rotation = (EulerAngles (rot.x) (rot.y) (-rot.z))
					AnimNode.Pos = Position
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordings*/ strVehicleRecordings (	--TODO	test-read	test-create	test-write
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordings",
		DiskPath,
		ObjName,
		Extension = ".ovr",
		Version = [1, 30],
		Items = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						ValueOps = GIMS.Core.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcVehicleRecordingItem = GIMS.CurrentGame.Core.TypeLibrary.grcVehicleRecordingItem,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#TxtLines
						),
						NotEOF = BufferMgr.NotEOF,
						ItemCount = 0
				Items.Count = 1000
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name BufferID:BufferID)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3} BufferID:BufferID) != Version then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:Extension \
										v5:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#Item: (
							Skip BufferID 1 /* skip start */
							local	NewItem = (grcVehicleRecordingItem())
							NewItem.Read BufferID /* skips end */
							ItemCount += 1
							Items[ItemCount] = NewItem
						)
						default:
							EGIMS_EHAbort "Unknown strVehicleRecordings tag: " Param1:tLine[1] BufferID:BufferID
					)
				)
				Items.Count = ItemCount
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FilePath = (
							ValueOps.FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#TxtLines FilePath:FilePath),
						TabString = "\t"
				if BufferID != false then (
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					for Item in Items do
						Item.Write BufferID TabString
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (				
				local	ObjectMgr = GIMS.Core.ObjectMgr
				
				local	MaxTime = -999999999
				for Item in Items do (
					local	t = Item.KeyTime;
					if t > MaxTime then
						MaxTime = t;
				)
				if MaxTime > 0 then
					ObjectMgr.ExtendAnimationRange 0 MaxTime
					
				/*TODO remove, debug*
				local	mtxModeCount = 24,
						mtxLayerMargin = 10,
						mtxLayerStep = 5,
						mtxLayerCapacity = 8
				for mtxMode = 1 to mtxModeCount do (
				/**/
				
				local	Result = (ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_V_VehicleRecording),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				Result.Pos.Controller = (Linear_Position())
				Result.Rotation.Controller = (Linear_Rotation())
				Result.SuspendMeshBuilding()
				with animate on (
					if ReportProgress then (
						local	Progress = [0, 0, Items.Count]
						for Item in Items do (
							Item.Create Item Result /*TODO remove, debug*mtxMode/**/
							Progress.x += 1
							UpdateProgress #Progress Progress
						)
					) else (
						for Item in Items do (
							UpdateProgress #None 0
							Item.Create Item Result /*TODO remove, debug*mtxMode/**/
						)
					)
				)
				Result.ResumeMeshBuilding()
				
				if
					Have Result and
					ParentNode != RootNode
				then
					Result.Transform = ParentNode.Transform
					
				/*TODO remove, debug*
					Result.Name += ("_mtx" + (mtxMode as String))
					local	layerSizeMult = (mtxMode / mtxLayerCapacity),
							layerOffset = (mtxLayerMargin + (mtxLayerStep * layerSizeMult)),
							layerAngleStep = (360.0 / (mtxLayerCapacity * (layerSizeMult + 1))),
							mtxAngle = (
								(
									EulerAngles \
										0 \
										0 \
										(layerAngleStep * (mtxMode - (mtxLayerCapacity * layerSizeMult)))
								) as Quat
							)
					Result.Pos += (layerOffset * ([0, 1, 0] * mtxAngle))
				)
				/**/
				
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

/*shaders*/

	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.SPSParamAnnotation*/ strSPSParamAnnotation (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.SPSParamAnnotation",
		aKey,
		aType,
		aValue,
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name BufferID:BufferID) == #Annotation then (
						aKey = (TypeCast (XMLNode.GetAttribute "key") Name BufferID:BufferID)
						if No aKey then
							throw (Append "Can't find \"key\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name BufferID:BufferID)
						if No aType then
							throw (Append "Can't find \"type\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						if not (XMLNode.Read()) then
							throw (Append "Can't read annotation value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						aValue = (
							if XMLNode.HasValue then (
								case aType of (
									#string:
										XMLNode.Value
									#int:
										(TypeCast XMLNode.Value Integer BufferID:BufferID)
									#float:
										(TypeCast XMLNode.Value Float BufferID:BufferID)
									Default:
										throw ("Unknown shader parameter annotation type " + (aType as String) + " found at " + ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
								)
							) else
								unsupplied
						)
						true
					) else
						false
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.SPSParam*/ strSPSParam (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.SPSParam",
		aName,
		Description,
		aType,
		isRequired,
		DefaultValue,
		Annotations = #(),
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name BufferID:BufferID) == #Item then (
						aName = (XMLNode.GetAttribute "name")
						if No aName then
							throw (Append "Can't find \"name\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						Description = (TypeCast (XMLNode.GetAttribute "description") Name BufferID:BufferID)
						if No Description then
							throw (Append "Can't find \"description\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name BufferID:BufferID)
						if No aType then
							throw (Append "Can't find \"type\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						isRequired = (TypeCast (XMLNode.GetAttribute "isRequired") BooleanClass BufferID:BufferID)
						if No isRequired then
							throw (Append "Can't read \"isRequired\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						local	ParamValue = (XMLNode.GetAttribute "value"),
								ParamType = (GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType aType),
								IsBaseParamType = (
									ParamType == #Float or
									ParamType == #P2 or
									ParamType == #P3
								)
						DefaultValue = (
							if Have ParamValue then (
								if IsBaseParamType then
									(TypeCast (GIMS.Core.StringOps.oFTypeExec ParamValue ParamType BufferID:BufferID) #P4 BufferID:BufferID)
								else
									(GIMS.Core.StringOps.oFTypeExec ParamValue ParamType BufferID:BufferID)
							) else
								unsupplied
						)
						local	AnnotationsSubTree = (XMLNode.ReadSubTree()),
								SPSParamAnnotation = GIMS.CurrentGame.Core.TypeLibrary.SPSParamAnnotation
						if Have AnnotationsSubTree then (
							local	AnnotationCount = 0
							Annotations.Count = 20
							while (AnnotationsSubTree.Read()) do (
								local	Annotation = (SPSParamAnnotation())
								if (Annotation.Read AnnotationsSubTree) then (
									AnnotationCount += 1
									Annotations[AnnotationCount] = Annotation
								)
							)
							Annotations.Count = AnnotationCount
							local	Modify = GIMS.Core.ArrayOps.Modify
							for Annotation in Annotations where
								Annotation.aKey == #UIMin and
								Supplied Annotation.aValue
							while not Supplied DefaultValue do (
								local	IsArray = true
								DefaultValue = (
									case aType of (
										#svt_float: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#svt_float2: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#svt_float3: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#svt_float4: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#svt_matrix3x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1]
											Res
										)
										#svt_matrix44: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#svt_float2x3: (
											local	Res = #()
											for i = 3 to 1 by -1 do
												Res[i] = [1, 1]
											Res
										)
										#svt_float4x2: (
											local	Res = #()
											for i = 2 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#svt_float4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#svt_float4x5: (
											local	Res = #()
											for i = 5 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#svt_sampler: (/*SKIP*/)
										Default:
											throw "Unknown SPS param type: " aType
									)
								)
								if IsArray then
									GIMS.Core.ArrayOps.Modify DefaultValue Annotation.aValue #Multiply
								else
									DefaultValue *= Annotation.aValue
							)
						)
						if not Supplied DefaultValue then (
							DefaultValue = (
								if
									IsBaseParamType or
									ParamType == #P4
								then
									[0, 0, 0, 0]
								else (
									case aType of (
										#svt_sampler:
											"*NULL*"
										#svt_matrix3x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0]
											Res
										)
										#svt_matrix44: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										#svt_float2x3: (
											local	Res = #()
											for i = 3 to 1 by -1 do
												Res[i] = [0, 0, 0]
											Res
										)
										#svt_float4x2: (
											local	Res = #()
											for i = 2 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										#svt_float4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										#svt_float4x5: (
											local	Res = #()
											for i = 5 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										default:
											throw "Unknown param type: " ParamType
									)
								)
							)
						)
						true
					) else
						false
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclarationElement*/ strSPSVertexDeclarationElement (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclarationElement",
		Usage,
		aType,
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name BufferID:BufferID) == #Element then (
						Usage = (TypeCast (XMLNode.GetAttribute "usage") Name BufferID:BufferID)
						if No Usage then
							throw (Append "Can't find \"usage\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name BufferID:BufferID)
						if No aType then
							throw (Append "Can't find \"type\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						true
					) else
						false
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclaration*/ strSPSVertexDeclaration (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclaration",
		aName,
		Skinned,
		Elements = #(),
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name BufferID:BufferID) == #Declaration then (
					
						local	vdName = (XMLNode.GetAttribute "name")
						if No vdName then
							throw (Append "Can't find VD \"name\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aName = (TypeCast vdName Name BufferID:BufferID)
					
						Skinned = (TypeCast (XMLNode.GetAttribute "skinned") BooleanClass BufferID:BufferID)
						if No Skinned then
							throw (Append "Can't find VD \"skinned\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						
						if not (XMLNode.ReadToFollowing "Count") then
							throw (Append "Can't find VD \"Count\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						if not (XMLNode.Read()) then
							throw (Append "Can't read VD \"Count\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						if not XMLNode.HasValue then
							throw (Append "Can't find VD \"Count\" parameter value at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						local	vdCount = XMLNode.Value
						if No vdCount then
							throw (Append "Wrong VD \"Count\" parameter value at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						vdCount = (TypeCast vdCount Integer BufferID:BufferID)
						
						if not (XMLNode.ReadToFollowing "D3D9VertexElements") then
							throw (Append "Can't find VD \"D3D9VertexElements\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						local	ElementsSubTree = (XMLNode.ReadSubTree())
						if No ElementsSubTree then
							throw (Append "Can't find VD elements subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						
						local	SPSVertexDeclarationElement = GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclarationElement,
								ElementCount = 0
						Elements.Count = vdCount
						while (ElementsSubTree.Read()) do (
							/*TODO remove, debug*	LogProfiler #PlainInfo "\tElement @\t" AddParam:[ElementsSubTree.LineNumber, ElementsSubTree.LinePosition]	/**/
							local	Element = (SPSVertexDeclarationElement())
							if (Element.Read ElementsSubTree) then (
								ElementCount += 1
								Elements[ElementCount] = Element
							)
						)
						Elements.Count = ElementCount
						true
					) else
						false
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.SPS*/ strSPS (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.SPS",
		aName,
		aShader,
		SupportSkinning,
		ShaderParameters = #(),
		VertexDeclarations = #(),
		Bucket = 0,
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name BufferID:BufferID) == #ShaderPreSet then (
					
						aName = (XMLNode.GetAttribute "name")
						if No aName then
							throw (Append "Can't find \"name\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aName = (GetFileNameFile aName)
						
						aShader = (XMLNode.GetAttribute "shader")
						if No aShader then
							throw (Append "Can't find \"shader\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aShader = (TypeCast aShader Name BufferID:BufferID)
						
						local	ShaderSubTree = (XMLNode.ReadSubTree())
						if No ShaderSubTree then
							throw (Append "Can't read shader subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "Bucket") then
							throw (Append "Can't find \"Bucket\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not (ShaderSubTree.Read()) then
							throw (Append "Can't read \"Bucket\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not ShaderSubTree.HasValue then
							throw (Append "Can't find \"Bucket\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						Bucket = (TypeCast ShaderSubTree.Value Integer BufferID:BufferID)
						if No Bucket then
							throw (Append "Wrong \"Bucket\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "SupportSkinning") then
							throw (Append "Can't find \"SupportSkinning\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not (ShaderSubTree.Read()) then
							throw (Append "Can't read \"SupportSkinning\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not ShaderSubTree.HasValue then
							throw (Append "Can't find \"SupportSkinning\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						SupportSkinning = (TypeCast ShaderSubTree.Value BooleanClass BufferID:BufferID)
						if No SupportSkinning then
							throw (Append "Wrong \"SupportSkinning\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "ShaderParameters") then
							throw (Append "Can't find \"ShaderParameters\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	ParamsSubTree = (ShaderSubTree.ReadSubTree())
						if No ParamsSubTree then
							throw (Append "Can't read shader items subtree at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	SPSParam = GIMS.CurrentGame.Core.TypeLibrary.SPSParam,
								AppendSorted = GIMS.Core.ArrayOps.AppendSorted
						while (ParamsSubTree.Read()) do (
							/*TODO remove, debug*	LogProfiler #PlainInfo "\tParam @\t" AddParam:[ParamsSubTree.LineNumber, ParamsSubTree.LinePosition]	/**/
							local	Item = (SPSParam())
							if (Item.Read ParamsSubTree) then
								AppendSorted ShaderParameters Item ValuePropertyName:#aName
						)
						
						if not (ShaderSubTree.ReadToFollowing "VertexDeclarations") then
							throw (Append "Can't find \"VertexDeclarations\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	VertexDeclarationsSubTree = (ShaderSubTree.ReadSubTree())
						if No VertexDeclarationsSubTree then
							throw (Append "Can't read shader VertexDeclarations subtree at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
							
						local	VDCount = 0
						VertexDeclarations.Count = 10
						while (VertexDeclarationsSubTree.Read()) do (
							/*TODO remove, debug*	LogProfiler #PlainInfo "\tVDInfo @\t" AddParam:[VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition]	/**/
						
							if
								XMLNode.HasAttributes and
								(TypeCast VertexDeclarationsSubTree.Name Name BufferID:BufferID) == #Name
							then (
								local	vdSkinned = (TypeCast (VertexDeclarationsSubTree.GetAttribute "skinned") BooleanClass BufferID:BufferID)
								if No vdSkinned then
									throw (Append "Can't find \"skinned\" parameter at " ([VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition] as String))
								
								if not VertexDeclarationsSubTree.Read() then
									throw (Append "Can't read VD \"Name\" parameter value at " ([VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition] as String))
								if not VertexDeclarationsSubTree.HasValue then
									throw (Append "Can't find VD \"Name\" parameter value at " ([VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition] as String))
								local	vdName = VertexDeclarationsSubTree.Value
								if No vdName then
									throw (Append "Wrong VD \"Name\" parameter value at " ([VertexDeclarationsSubTree.LineNumber, VertexDeclarationsSubTree.LinePosition] as String))
								
								VDCount += 1
								VertexDeclarations[VDCount] = #((TypeCast vdName Name BufferID:BufferID), vdSkinned)
							)
						)
						VertexDeclarations.Count = VDCount
						
						if VDCount != 0 then (
							if SupportSkinning then (
								local	HaveSkinnedVD = false
								for VD in VertexDeclarations where VD[2] while not HaveSkinnedVD do
									HaveSkinnedVD = true
								SupportSkinning = HaveSkinnedVD
							)
							true
						) else
							false
							
					) else
						false
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

/*this*/

	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary*/ strTypeLibrary (
		/*Bounds*/		Bounds = strBounds,
		/*phBound*/		grcPhBoundDictionary = strPhBoundDictionary,
						grcPhBound = strPhBound,
		/*oF models*/	grcMeshVertex = strMeshVertex,
						grcLODMeshGeometry = strLODMeshGeometry,
						grcLODMesh = strLODMesh,
						grcLODGroup = strLODGroup,
						grcBone = strBone,
						grcSkeleton = strSkeleton,
						grcJointLimit = strJointLimit,
						grcJoints = strJoints,
						grcLight = strLight,
						grcLightAttributes = strLightAttributes,
						grcTexture = strTexture,
						grcTextureDictionary = strTextureDictionary,
						grcShadingGroup = strShadingGroup,
						grcDrawable = strDrawable,
						grcDrawableDictionary = strDrawableDictionary,
		/*paths*/		grcDistantLights = strDistantLights,
						grcDistantLightGroup = strDistantLightGroup,
						grcVehicleRecordings = strVehicleRecordings,
						grcVehicleRecordingItem = strVehicleRecordingItem,
		/*shaders*/		SPSParamAnnotation = strSPSParamAnnotation,
						SPSParam = strSPSParam,
						SPSVertexDeclarationElement = strSPSVertexDeclarationElement,
						SPSVertexDeclaration = strSPSVertexDeclaration,
						SPS = strSPS
	)
	GIMS.CurrentGame.Core.TypeLibrary = strTypeLibrary()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
