/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--(--try (
/* oF common */
struct strMeshVertex (
	Position,
	Normal,
	TheColor,
	Tangent,
	SkinBones = #(),
	SkinWeights = #(),
	UVCoords = #(),
	fn GetHash = (
		/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			local	ResultStream = (StringStream ""),
					FmtStr = "%,",
					FloatFmtStr = "0.7f"
			Format FmtStr (FormattedPrint Position Format:FloatFmtStr) To:ResultStream
			Format FmtStr (FormattedPrint Normal Format:FloatFmtStr) To:ResultStream
			Format FmtStr (FormattedPrint TheColor Format:FloatFmtStr) To:ResultStream
			Format FmtStr (FormattedPrint Tangent Format:FloatFmtStr) To:ResultStream
			for Val in SkinWeights do
				Format FmtStr (FormattedPrint Val Format:FloatFmtStr) To:ResultStream
			for Val in UVCoords do
				Append FmtStr (FormattedPrint Val Format:FloatFmtStr) To:ResultStream
			local	ResultString = (ResultStream as String)
			Free ResultStream
			(GIMS.Core.ValueOps.GetHash ResultString)
		/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
	)
)
struct strBounds (
	GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.Bounds",
	AABB = (GIMS.Core.TypeLibrary.AABB()),
	Center,
	Centroid,
	CentroidPresent = false,
	CenterOfMass,
	CGPresent = false,
	Radius,
	LCRadius,
	WorldRadius,
	PushFlags = false,
	fn Write BufferID TabString:"" = (
		/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			local	SCore = GIMS.Core,
					WriteVal = SCore.BufferMgr.WriteVal,
					ValueOps = SCore.ValueOps,
					AsoFText = ValueOps.AsoFText,
					FormatText = ValueOps.FormatText
			if Have Centroid then
				CentroidPresent = ((Length Centroid) != 0)
			if Have CenterOfMass then
				CGPresent = ((Length CenterOfMass) != 0)
			if PushFlags then (
				if CentroidPresent then
					WriteVal BufferID (TabString + "CentroidPresent 1")
				else
					WriteVal BufferID (TabString + "CentroidPresent 0")
				if CGPresent then
					WriteVal BufferID (TabString + "CGPresent 1")
				else
					WriteVal BufferID (TabString + "CGPresent 0")
			)
			if Have Radius then (
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Radius " \
						v3:(AsoFText Radius)
				)
			)
			if Have LCRadius then (
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"radius " \
						v3:(AsoFText LCRadius)
				)
			)
			if Have WorldRadius then (
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"WorldRadius " \
						v3:(AsoFText WorldRadius)
				)
			)
			if Have AABB then (
				WriteVal BufferID (AsoFText AABB.bMax TabString:(TabString + "AABBMax "))
				WriteVal BufferID (AsoFText AABB.bMin TabString:(TabString + "AABBMin "))
			)
			if CentroidPresent then
				WriteVal BufferID (AsoFText Centroid TabString:(TabString + "Centroid "))
			if CGPresent then
				WriteVal BufferID (AsoFText CenterOfMass TabString:(TabString + "CenterOfMass "))
			if Have Center then
				WriteVal BufferID (AsoFText Center TabString:(TabString + "center "))
		/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
	)
)
/* oF drawable */
	struct strLODMeshPrim (
		Tag = #MeshPrim,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshPrim",
		Idx = #(),
		Positions = #(),
		Normals = #(),
		Colors = #(),
		Tangents = #(),
		SkinBones = #(),
		SkinWeights = #(),
		UVCoords = #(
			#(),
			#(),
			#(),
			#(),
			#(),
			#()
		),
		fn Read BufferID Skinned oFVersion = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Tag, tLine, VertLine,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						Modify = SCore.ArrayOps.Modify,
						TypeCast = SCore.ValueOps.TypeCast
				Skip BufferID 2 /* skip header and start */
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Idx: (
							local	RAWIdx = #()
							Skip BufferID 1 /* skip start */
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /* skips end */
								RAWIdx += (oFTypeExec tLine #IntArray)
							Idx.Count = (RAWIdx.Count / 3)
							for IdxID = 0 to (Idx.Count - 1) do (
								Idx[IdxID + 1] = [ \
									RAWIdx[3 * IdxID + 1] + 1, \
									RAWIdx[3 * IdxID + 2] + 1, \
									RAWIdx[3 * IdxID + 3] + 1 \
								]
							)
						)
						#Verts: (
							Positions.Count = (TypeCast tLine[2] Integer)
							Skip BufferID 1 /* skip start */
							Normals.Count = Positions.Count
							Colors.Count = Positions.Count
							Tangents.Count = Positions.Count
							UVCoords[1].Count = Positions.Count
							UVCoords[2].Count = Positions.Count
							local	TangentType = (
								case oFVersion of (
								12:
									#P3
								13:
									#P4
								)
							)
							if Skinned then (
								SkinBones.Count = Positions.Count
								SkinWeights.Count = Positions.Count
								local	BoneID, TempSkinWeights, TempSkinBones
								for VertID = 1 to Positions.Count do (
									VertLine = (ReadVal BufferID FilterStr:"/")
									Positions[VertID] = (oFTypeExec VertLine[1] #P3)
									Normals[VertID] = (oFTypeExec VertLine[2] #P3)
									TempSkinWeights = (oFTypeExec VertLine[3] #FloatArray)
									TempSkinBones = (Modify (oFTypeExec VertLine[4] #IntArray) 1 #Add CopyArray:false)
									Colors[VertID] = ((oFTypeExec VertLine[5] #P4 IDMask:#(3, 2, 1, 4)) / 255)
									Tangents[VertID] = (oFTypeExec VertLine[6] TangentType)
									for UVID = 1 to 2 do
										UVCoords[UVID][VertID] = (oFTypeExec VertLine[UVID + 6] #P2)
									BoneID = 1
									while BoneID <= TempSkinWeights.count do (
										if TempSkinWeights[BoneID] == 0 then (
											DeleteItem TempSkinWeights BoneID
											DeleteItem TempSkinBones BoneID
										) else
											BoneID += 1
									)
									SkinWeights[VertID] = TempSkinWeights
									SkinBones[VertID] = TempSkinBones
								)
							) else (
								UVCoords[3].Count = Positions.Count
								UVCoords[4].Count = Positions.Count
								UVCoords[5].Count = Positions.Count
								UVCoords[6].Count = Positions.Count
								for VertID = 1 to Positions.Count do (
									VertLine = (ReadVal BufferID FilterStr:"/")
									Positions[VertID] = (oFTypeExec VertLine[1] #P3)
									Normals[VertID] = (oFTypeExec VertLine[2] #P3)
									Colors[VertID] = ((oFTypeExec VertLine[3] #P4 IDMask:#(3, 2, 1, 4)) / 255)
									Tangents[VertID] = (oFTypeExec VertLine[4] TangentType)
									for UVID = 1 to 6 do
										UVCoords[UVID][VertID] = (oFTypeExec VertLine[UVID + 4] #P2)
								)
							)
							Skip BufferID 1 /* skip end */
						)
						default:
							throw ("Unknown strLODMeshPrim tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID Index Skinned TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						Modify = SCore.ArrayOps.Modify,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Prim " \
						v3:(Index - 1)
				)
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tIdx " \
						v3:(Idx.Count * 3)
				)
				WriteVal BufferID (TabString + "\t{")
				WriteVal BufferID (AsoFText (Modify Idx -1 #Add CopyArray:false) SplitCount:5 TabString:(TabString + "\t\t") SplitString:" " SubSplitString:" " SubTypeHook:Integer)
				WriteVal BufferID (TabString + "\t}")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tVerts " \
						v3:Positions.Count
				)
				WriteVal BufferID (TabString + "\t{")
				local	VertCount = Positions.Count
				if Skinned then (
					for VertID = 1 to VertCount do (
						WriteVal BufferID (
							AsoFText #(
								(AsoFText Positions[VertID]),
								(AsoFText Normals[VertID]),
								(AsoFText SkinWeights[VertID]),
								(AsoFText (Modify SkinBones[VertID] -1 #Add) TypeHook:Integer),
								(AsoFText (Colors[VertID] * 255) TypeHook:Integer IDMask:#(3, 2, 1, 4)),
								(AsoFText Tangents[VertID]),
								(AsoFText UVCoords[1][VertID]),
								(AsoFText UVCoords[2][VertID])
							) SplitString:" / " TabString:(TabString + "\t\t")
						)
					)
				) else (
					for VertID = 1 to VertCount do (
						WriteVal BufferID (
							AsoFText #(
								(AsoFText Positions[VertID]),
								(AsoFText Normals[VertID]),
								(AsoFText (Colors[VertID] * 255) TypeHook:Integer IDMask:#(3, 2, 1, 4)),
								(AsoFText Tangents[VertID]),
								(AsoFText UVCoords[1][VertID]),
								(AsoFText UVCoords[2][VertID]),
								(AsoFText UVCoords[3][VertID]),
								(AsoFText UVCoords[4][VertID]),
								(AsoFText UVCoords[5][VertID]),
								(AsoFText UVCoords[6][VertID])
							) SplitString:" / " TabString:(TabString + "\t\t")
						)
					)
				)
				WriteVal BufferID (TabString + "\t}")
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strLODMeshMtl (
		Tag = #MeshMtl,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshMtl",
		MatID = 1,
		Prims = #(),
		fn Read BufferID Skinned oFVersion = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
					BufferMgr = SCore.BufferMgr,
					ReadVal = BufferMgr.ReadVal,
					Skip = BufferMgr.Skip,
					TypeCast = SCore.ValueOps.TypeCast,
					grcLODMeshPrim = GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshPrim,
					NewItem
				MatID = ((TypeCast (ReadVal BufferID FilterStr:"\t ")[2] Integer) + 1)
				Skip BufferID 1 /* skip start */
				while (ReadVal BufferID FilterStr:"\t ")[1] != "}" do ( /* skips end */
					Skip BufferID -1 /* return to start */
					NewItem = grcLODMeshPrim()
					NewItem.Read BufferID Skinned oFVersion
					Append Prims NewItem
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID Skinned TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID (
					SCore.ValueOps.FormatText \
						v1:TabString \
						v2:"Mtl " \
						v3:(MatID - 1)
				)
				WriteVal BufferID (TabString + "{")
				for PrimID = 1 to Prims.Count do
					Prims[PrimID].Write BufferID PrimID Skinned TabString:(TabString + "\t")
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strLODMesh (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh",
		Tag = #LODMesh,
		DiskPath,
		ObjName,
		Extension = ".mesh",
		SubDir,
		ResourceVersion = 11,
		oFVersion = 13,
		ValidoFVersions = #{12, 13},
		BoneID = 1,
		Skinned = false,
		Bounds = #(),
		Mtls = #(),
		Locked = false,
		fn Read CachePath:undefined = (	/*<TODO> CachePath*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						TypeCast = ValueOps.TypeCast,
						grcLODMeshMtl = GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshMtl,
						FullFilePath = (
							FormatText \
								v1:DiskPath \
								v2:SubDir \
								v3:ObjName \
								v4:Extension
						),
						BufferID = (BufferMgr.ReadFile FullFilePath),
						CurrentoFVersion,
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (TypeCast tLine[2] Integer) != ResourceVersion then
								SCore.SystemMgr.ThrowError (FormatText v1:"Wrong resource version in file \"" v2:FullFilePath v3:"\" !") #Abort
							CurrentoFVersion = (TypeCast tLine[3] Integer)
							if not ValidoFVersions[CurrentoFVersion] then
								SCore.SystemMgr.ThrowError (FormatText v1:"Wrong openFormats version in file \"" v2:FullFilePath v3:"\" ! Try to export it from the game resource using the newest OpenIV version.") #Abort
							Skip BufferID 1 /* skip start */
						)
						#Locked:
							Locked = true
						#Skinned:
							Skinned = ((TypeCast tLine[2] Integer) != 0)
						#Bounds:
							Skip BufferID (1 + (TypeCast tLine[2] Integer) + 1) /* skip start, bounds, end */
						#Mtl: (
							Skip BufferID -1 /* return to the start */
							local	NewItem = grcLODMeshMtl()
							NewItem.Read BufferID Skinned CurrentoFVersion
							Append Mtls NewItem
						)
						default:
						throw ("Unknown strLODMesh tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal
				WriteVal BufferID (
					FormatText \
						v1:" " \
						v2:SubDir \
						v3:ObjName \
						v4:Extension \
						v5:" " \
						v6:(BoneID - 1)
				) AppendLast:true
				BufferID = (BufferMgr.Create())
				WriteVal BufferID (
					FormatText \
						v1:"Version " \
						v2:ResourceVersion \
						v3:" " \
						v4:oFVersion \
				)
				WriteVal BufferID "{"
				local	ExtendBound = SCore.ObjectMgr.ExtendBound,
						AABB = SCore.TypeLibrary.AABB,
						MtlCount = Mtls.Count,
						Mtl
				Bounds = #()
				for i = MtlCount to 1 by -1 do
					Bounds[i] = (AABB())
				for MtlID = 1 to MtlCount do (
					Mtl = Mtls[MtlID]
					for Prim in Mtl.Prims do (
						for Pos in Prim.Positions do
							ExtendBound Bounds[MtlID] Pos
					)
				)
				if Locked then
					WriteVal BufferID "\tLocked"
				else (
					if Skinned then
						WriteVal BufferID "\tSkinned 1"
					else (
						WriteVal BufferID "\tSkinned 0"
						local	AlotOfMtls = (MtlCount > 1),
						BoundCount = (
							if AlotOfMtls then
								(Bounds.Count + 1)
							else
								Bounds.Count
						)
						WriteVal BufferID ("\tBounds " + BoundCount as String)
						WriteVal BufferID "\t{"
						if AlotOfMtls then (
							AABB = (AABB())
							for Bound in Bounds do
								ExtendBound AABB Bound
							local	AABBCentroid = (AABB.bMin + ((AABB.bMax - AABB.bMin) / 2))
							WriteVal BufferID (AsoFText [AABBCentroid.x, AABBCentroid.y, AABBCentroid.z, (Length (AABB.bMax - AABBCentroid))] TabString:"\t\t")
						)
						local	Centroid
						for Bound in Bounds do (
							Centroid = (Bound.bMin + ((Bound.bMax - Bound.bMin) / 2))
							WriteVal BufferID (AsoFText [Centroid.x, Centroid.y, Centroid.z, (Length (Bound.bMax - Centroid))] TabString:"\t\t")
						)
						WriteVal BufferID "\t}"
					)
					for Mtl in Mtls do
						Mtl.Write BufferID Skinned TabString:"\t"
				)
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:(
					FormatText \
						v1:DiskPath \
						v2:SubDir \
						v3:ObjName \
						v4:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strLodGroup (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLodGroup",
		DiskPath,
		ObjName,
		LODGroups = #(
			#(),
			#(),
			#(),
			#()
		),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag, MeshCount,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						grcLODMesh = GIMS.CurrentGame.Core.TypeLibrary.grcLODMesh,
						TypeCast = SCore.ValueOps.TypeCast,
						LODGrpTags = #(
							#High,
							#Med,
							#Low,
							#VLow
						),
						TagID, LODGroupInfo, LODGroup, MeshFile, MeshInfoID
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					TagID = (FindItem LODGrpTags Tag)
					if TagID != 0 then (
						LODGroupInfo = tLine[2]
						if (TypeCast LODGroupInfo name) != #none then (
							LODGroup = LODGroups[TagID]
							MeshCount = (TypeCast LODGroupInfo Integer)
							LODGroup.Count = MeshCount
							for MeshID = 1 to MeshCount do (
								MeshInfoID = (1 + MeshID * 2)
								MeshFile = tLine[MeshInfoID]
								local	LODMesh = (
											grcLODMesh \
												BoneID:((TypeCast tLine[MeshInfoID + 1] Integer) + 1) \
												DiskPath:DiskPath \
												SubDir:(GetFileNamePath MeshFile) \
												ObjName:(GetFileNameFile MeshFile) \
										)
								LODMesh.Read()
								LODGroup[MeshID] = LODMesh
							)
						)
					) else (
						case Tag of (
							#Center: () /*skip*/
							#AABBMin: () /*skip*/
							#AABBMax: () /*skip*/
							#Radius: () /*skip*/
							default:
								throw ("Unknown strLodGroup tag " + tLine[1])
						)
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TheBones TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						FormatText = SCore.ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						LODGrpStrings = #(
							"\thigh ",
							"\tmed ",
							"\tlow ",
							"\tvlow "
						),
						LODGrpCount = LODGroups.Count,
						LODGrp, LODGrpSize,
						ExtendBound = SCore.ObjectMgr.ExtendBound,
						Bounds = GIMS.CurrentGame.Core.TypeLibrary.Bounds(),
						AABB = Bounds.AABB,
						LODMeshBounds,
						BonesPresent = (Have TheBones)
				WriteVal BufferID (TabString + "lodgroup")
				WriteVal BufferID (TabString + "{")
				for LODGrpID = 1 to LODGrpCount do (
					LODGrp = LODGroups[LODGrpID]
					LODGrpSize = LODGrp.Count
					if LODGrpSize != 0 then (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:LODGrpStrings[LODGrpID] \
								v3:LODGrpSize
						)
						for LODMesh in LODGrp do (
							LODMesh.DiskPath = DiskPath
							LODMesh.SubDir = (ObjName + "\\")
							LODMesh.Write BufferID
							LODMeshBounds = LODMesh.Bounds
							for Bound in LODMeshBounds do (
								ExtendBound AABB Bound.bMin
								ExtendBound AABB Bound.bMax
							)
						)
						WriteVal BufferID " 9999.0" AppendLast:true
					) else (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:LODGrpStrings[LODGrpID] \
								v3:"none 9999.00000000"
						)
					)
				)
				local	AABBMax = AABB.bMax,
						AABBMin = AABB.bMin,
						Centroid = (AABBMin + ((AABBMax - AABBMin) / 2))
				Bounds.Center = Centroid
				Bounds.LCRadius = (Length (AABBMax - Centroid))
				Bounds.Write BufferID TabString:(TabString + "\t")
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strBone (
		Tag = #Bone,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcBone",
		ObjName,
		Flags = #(
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false
		),
		AvailFlags = #(
			#LockRotXYZ,
			#Invisible,
			#LockRotX,
			#LockRotY,
			#LockRotZ,
			#LimitRotX,
			#LimitRotY,
			#LimitRotZ,
			#LockTransX,
			#LockTransY,
			#LockTransZ,
			#LimitTransX,
			#LimitTransY,
			#LimitTransZ,
			#LockScaleX,
			#LockScaleY,
			#LockScaleZ,
			#LimitScaleX,
			#LimitScaleY,
			#LimitScaleZ
		),
		FlagStrings = #(
			"LockRotXYZ",
			"Invisible",
			"LockRotX",
			"LockRotY",
			"LockRotZ",
			"LimitRotX",
			"LimitRotY",
			"LimitRotZ",
			"LockTransX",
			"LockTransY",
			"LockTransZ",
			"LimitTransX",
			"LimitTransY",
			"LimitTransZ",
			"LockScaleX",
			"LockScaleY",
			"LockScaleZ",
			"LimitScaleX",
			"LimitScaleY",
			"LimitScaleZ"
		),
		Index = 1,
		Id = 0,
		WorldOffset,
		LocalOffset,
		RotationEuler,
		RotationQuaternion,
		TheScale,
		Orient,
		Sorient,
		TransMin = #(0, 0, 0),
		TransMax = #(1, 1, 1),
		RotMin = #(-180, -180, -180),
		RotMax = #(180, 180, 180),
		Children = #(),
		fn GetChildrenCount = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local ChildrenCount = Children.Count
				for TempBone in Children do
					ChildrenCount += (TempBone.GetChildrenCount())
				ChildrenCount
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						TypeCast = SCore.ValueOps.TypeCast,
						NewItem
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Bone: (
							ObjName = (tLine[2] as String)
							Skip BufferID 1 /* skip start */
						)
						#Flags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count}),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem AvailFlags Flag)
								if FlagID != 0 then
									Flags[FlagID] = true
								else
									SCore.SystemMgr.ThrowError ("Unknown flag \"" + Flag as String + "\" in object \"" + ObjName + "\" found!") #Abort
							)
						)
						#Index:
							Index = ((TypeCast tLine[2] Integer) + 1)
						#Id:
							Id = (TypeCast tLine[2] Integer)
						#Mirror: ()	--SKIP
						#LocalOffset:
							LocalOffset = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#RotationEuler:
							RotationEuler = (oFTypeExec tLine #RadEuler IDMask:#{2..4})
						#RotationQuaternion:
							RotationQuaternion = (oFTypeExec tLine #Quat IDMask:#{2..5})
						#Scale:
							TheScale = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#WorldOffset:
							WorldOffset = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#Orient:
							Orient = (oFTypeExec tLine #RadEuler IDMask:#{2..4})
						#Sorient:
							Sorient = (oFTypeExec tLine #RadEuler IDMask:#{2..4})
						#TransMin:
							TransMin = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#TransMax:
							TransMax = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#RotMin:
							RotMin = (oFTypeExec tLine #RadFloatArray IDMask:#{2..4})
						#RotMax:
							RotMax = (oFTypeExec tLine #RadFloatArray IDMask:#{2..4})
						#Children: (
							Skip BufferID 1 /* skip start */
							Children.Count = (TypeCast tLine[2] Integer)
							for ChildID = 1 to Children.Count do (
								NewItem = grcBone()
								NewItem.Read BufferID
								Children[ChildID] = NewItem
							)
							Skip BufferID 1 /* skip end */
						)
						default:
							throw ("Unknown strBone tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"bone " \
						v3:ObjName
				)
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID ( \
					AsoFText \
						(
							local	Res = #(),
									FlagCount = Flags.Count
							Res.Count = FlagCount
							for i = 1 to FlagCount do (
								if Flags[i] then
									Res[i] = FlagStrings[i]
								else
									FlagCount -= 1
							)
							Res.Count = FlagCount
							Res
						) \
						TabString:(TabString + "\tFlags ")
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tIndex " \
						v3:(Index - 1)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tId " \
						v3:Id
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tMirror " \
						v3:(Index - 1)
				)
				WriteVal BufferID (AsoFText LocalOffset TabString:(TabString + "\tLocalOffset "))
				WriteVal BufferID (AsoFText RotationEuler TabString:(TabString + "\tRotationEuler ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText RotationQuaternion TabString:(TabString + "\tRotationQuaternion "))
				WriteVal BufferID (AsoFText TheScale TabString:(TabString + "\tScale "))
				WriteVal BufferID (AsoFText WorldOffset TabString:(TabString + "\tWorldOffset "))
				WriteVal BufferID (AsoFText Orient TabString:(TabString + "\tOrient ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText Sorient TabString:(TabString + "\tSorient ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText TransMin TabString:(TabString + "\tTransMin "))
				WriteVal BufferID (AsoFText TransMax TabString:(TabString + "\tTransMax "))
				WriteVal BufferID (AsoFText RotMin TabString:(TabString + "\tRotMin ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText RotMax TabString:(TabString + "\tRotMax ") SubTypeHook:#DegToRad)
				if Children.Count != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"\tChildren " \
							v3:Children.Count
					)
					WriteVal BufferID (TabString + "\t{")
					for TempBone in Children do
						TempBone.Write BufferID TabString:(TabString + "\t\t")
					WriteVal BufferID (TabString + "\t}")
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strSkeleton (
		Tag = #Skeleton,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton",
		DiskPath,
		ObjName,
		Extension = ".skel",
		Version = [107, 11],
		TheBones = #(),
		Flags = #(
			false,
			false,
			false,
			false
		),
		AvailFlags = #(
			#UnknownFlag0,
			#HaveBoneMappings,
			#HaveBoneWorldOrient,
			#AuthoredOrientation
		),
		FlagStrings = #(
			"UnknownFlag0",
			"HaveBoneMappings",
			"HaveBoneWorldOrient",
			"AuthoredOrientation"
		),
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
						)
						#NumBones:
							#Skip
						#Flags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count}),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem AvailFlags Flag)
								if FlagID != 0 then
									Flags[FlagID] = true
								else
									SCore.SystemMgr.ThrowError ("Unknown flag \"" + Flag as String + "\" in object \"" + ObjName + "\" found!") #Abort
							)
						)
						#Bone: (
							Skip BufferID -1 /* return to start */
							local	NewItem = grcBone()
							NewItem.Read BufferID
							Append TheBones NewItem
						)
						default:
							throw ("Unknown strSkeleton tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						BufferID = BufferMgr.Create(),
						NumBones = TheBones.Count
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				for TempBone in TheBones do
					NumBones += (TempBone.GetChildrenCount())
				WriteVal BufferID ("NumBones " + NumBones as String)
				WriteVal BufferID ( \
					AsoFText \
						(
							local	Res = #(),
									FlagCount = Flags.Count
							Res.Count = FlagCount
							for i = 1 to FlagCount do (
								if Flags[i] then
									Res[i] = FlagStrings[i]
								else
									FlagCount -= 1
							)
							Res.Count = FlagCount
							Res
						) \
						TabString:"Flags "
				)
				for TheBone in TheBones do
					TheBone.Write BufferID
				BufferMgr.WriteFile BufferID FilePath:(
					ValueOps.FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strShadingGroup (
		Tag = #ShadingGroup,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup",
		DiskPath,
		ObjName,
		Shaders = #(),
		fn Read BufferID TexPath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ShaderID = 1,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						TypeCast = SCore.ValueOps.TypeCast,
						GetFromFormats = GIMS.CurrentGame.Core.MAXFactory.MaterialOps.GetFromFormats,
						tLine = (ReadVal BufferID FilterStr:"\t ")
				Shaders.Count = (TypeCast tLine[2] Integer)
				Skip BufferID 1 /* skip start */
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					Shaders[ShaderID] = (GetFromFormats tLine DiskPath TexPath)
					ShaderID += 1
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						FormatText = SCore.ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						AsFormatsText = GIMS.CurrentGame.Core.MAXFactory.MaterialOps.AsFormatsText
				WriteVal BufferID (TabString + "shadinggroup")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tShaders " \
						v3:Shaders.Count
				)
				WriteVal BufferID (TabString + "\t{")
				for TempShader in Shaders do (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"\t\t" \
							v3:(AsFormatsText TempShader DiskPath ObjName)
					)
				)
				WriteVal BufferID (TabString + "\t}")
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strLight (
		Tag = #Light,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLight",
		ObjName = "",
		Position = [0, 0, 0],
		Direction = [0, 0, -1],
		TheColor = White,
		_f28 = -1,
		_f2C = -1,
		_f30 = -1,
		TheDistance = 0,
		Range = 0,
		CoronaSize = 0,
		HotSpot = 0,
		TheFalloff = 0,
		Flags = 64,
		CoronaHash = -1103804803,
		LuminescenceHash = 0,
		TypeFlags = #(
			false,
			false,
			false,
			false
		),
		AvailFlags = #(
			#f0,
			#f1,
			#f2,
			#f3
		),
		FlagStrings = #(
			"f0",
			"f1",
			"f2",
			"f3"
		),
		Type = 1,
		Types = #(
			#Omni,
			#Spot
		),
		TypeStrings = #(
			"Omni",
			"Spot"
		),
		CoronaPower = 1.0,
		DrawDistDiv4 = -1.0,
		_f60 = -1.0,
		BoneID = 0,
		_f66 = 0,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeCast = SCore.ValueOps.TypeCast
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Position:
							Position = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#Direction:
							Direction = (-1 * (oFTypeExec tLine #P3 IDMask:#{2..4}))
						#Origin: () /*SKIP*/
						#Color:
							TheColor = (oFTypeExec tLine #Color IDMask:#{2..5})
						#_f28:
							_f28 = (TypeCast tLine[2] Float)
						#_f2C:
							_f2C = (TypeCast tLine[2] Float)
						#_f30:
							_f30 = (TypeCast tLine[2] Float)
						#Distance:
							TheDistance = (TypeCast tLine[2] Float)
						#Range:
							Range = (TypeCast tLine[2] Float)
						#CoronaSize:
							CoronaSize = (TypeCast tLine[2] Float)
						#HotSpot:
							HotSpot = (TypeCast tLine[2] Float)
						#Falloff:
							TheFalloff = (TypeCast tLine[2] Float)
						#Flags:
							Flags = (TypeCast (Append tLine[2] "L") Integer)
						#CoronaHash:
							CoronaHash = (TypeCast (Append tLine[2] "L") Integer)
						#LuminescenceHash:
							LuminescenceHash = (TypeCast (Append tLine[2] "L") Integer)
						#TypeFlags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count}),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem AvailFlags Flag)
								if FlagID != 0 then
									TypeFlags[FlagID] = true
								else
									SCore.SystemMgr.ThrowError ("Unknown flag \"" + Flag as String + "\" in object \"" + ObjName + "\" found!") #Abort
							)
						)
						#Type:
							Type = (FindItem Types (TypeCast tLine[2] name))
						#_f58:
							CoronaPower = (TypeCast tLine[2] Float)
						#_f5C: (
							DrawDistDiv4 = (TypeCast tLine[2] Float)
							if DrawDistDiv4 != -1 then
								DrawDistDiv4 *= 4
						)
						#_f60:
							_f60 = (TypeCast tLine[2] Float)
						#BoneID:
							BoneID = (TypeCast tLine[2] Integer)
						#_f66:
							_f66 = (TypeCast tLine[2] Integer)
						default:
							throw ("Unknown strLight tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"Attribute " \
						v3:ObjName
				)
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (AsoFText Position TabString:(TabString + "\tPosition "))
				local	Dir = (-1 * Direction)
				WriteVal BufferID (AsoFText Dir TabString:(TabString + "\tDirection "))
				WriteVal BufferID (AsoFText [Dir.x, Dir.z, Dir.y] TabString:(TabString + "\tOrigin "))
				WriteVal BufferID (AsoFText TheColor TabString: (TabString + "\tColor "))
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f28 " \
						v3:(AsoFText _f28)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f2C " \
						v3:(AsoFText _f2C)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f30 " \
						v3:(AsoFText _f30)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tDistance " \
						v3:(AsoFText TheDistance)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tRange " \
						v3:(AsoFText Range)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tCoronaSize " \
						v3:(AsoFText CoronaSize)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tHotSpot " \
						v3:(AsoFText HotSpot)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tFalloff " \
						v3:(AsoFText TheFalloff)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tFlags " \
						v3:(FormattedPrint Flags format:"u")
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tCoronaHash " \
						v3:(FormattedPrint CoronaHash format:"u")
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tLuminescenceHash " \
						v3:(FormattedPrint LuminescenceHash format:"u")
				)
				WriteVal BufferID ( \
					AsoFText \
						(
							local	Res = #(),
									FlagCount = TypeFlags.Count
							Res.Count = FlagCount
							for i = 1 to FlagCount do (
								if TypeFlags[i] then
									Res[i] = FlagStrings[i]
								else
									FlagCount -= 1
							)
							Res.Count = FlagCount
							Res
						) \
						TabString:(TabString + "\tTypeFlags ")
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tType " \
						v3:TypeStrings[Type]
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f58 " \
						v3:(AsoFText CoronaPower)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f5C " \
						v3:(
							AsoFText (
								if DrawDistDiv4 != -1 then
									(DrawDistDiv4 / 4)
								else
									-1.0
							)
						)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f60 " \
						v3:(AsoFText _f60)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tBoneID " \
						v3:BoneID
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\t_f66 " \
						v3:_f66
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strLightAttributes (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes",
		DiskPath,
		ObjName,
		Extension = ".light",
		Version = [1, 10],
		Items = #(),
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcLight = GIMS.CurrentGame.Core.TypeLibrary.grcLight,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
							Skip BufferID 1 /* skip start */
						)
						#Attribute: (
							Skip BufferID 1 /* skip start */
							local	NewItem = (grcLight ObjName:(tLine[2] as String))
							NewItem.Read BufferID /* skips end */
							Append Items NewItem
						)
						default:
							throw ("Unknown strLightAttributes tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						BufferID = BufferMgr.Create()
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Item in Items do
					Item.Write BufferID TabString:"\t"
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:(
					ValueOps.FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strDrawable (
		Tag = #Drawable,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDrawable",
		DiskPath,
		TexPath,
		ObjName,
		Extension = ".odr",
		Version = [110, 12],
		ShadingGroup,
		TheSkeleton,
		LodGroup,
		LightAttributes,
		fn CheckLocked = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Locked = false
				if Have LodGroup then (
					for LodGroup in LodGroup.LodGroups while not Locked where LodGroup.Count != 0 do (
						for LODMesh in LodGroup while not Locked where LODMesh.Locked do
							Locked = true
					)
				)
				Locked
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ParseTag BufferID tLine UpdateProgress:undefined GetProgress:undefined ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Tag = (GIMS.Core.ValueOps.TypeCast tLine[1] name),
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcShadingGroup = TypeLibrary.grcShadingGroup,
						grcSkeleton = TypeLibrary.grcSkeleton,
						grcLodGroup = TypeLibrary.grcLodGroup,
						grcLightAttributes = TypeLibrary.grcLightAttributes
				if ReportProgress then
					UpdateProgress #Progress (GetProgress BufferID)
				case Tag of (
					#Version: (
						if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
					)
					#ShadingGroup: (
						Skip BufferID 1 /* skip start */
						ShadingGroup = (grcShadingGroup DiskPath:DiskPath ObjName:ObjName)
						ShadingGroup.Read BufferID TexPath
						Skip BufferID 1 /* skip end */
					)
					#Skel: (
						Skip BufferID 1 /* skip start */
						local	PathParam = (ReadVal BufferID FilterStr:"\t ")[2]
						Skip BufferID 1 /* skip end */
						TheSkeleton = (grcSkeleton DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
						TheSkeleton.Read()
					)
					#LodGroup: (
						Skip BufferID 1 /* skip start */
						LodGroup = (grcLodGroup DiskPath:DiskPath)
						LodGroup.Read BufferID
					)
					#Light: (
						Skip BufferID 1 /* skip start */
						local	PathParam = (ReadVal BufferID FilterStr:"\t ")[2]
						Skip BufferID 1 /* skip end */
						LightAttributes = (grcLightAttributes DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
						LightAttributes.Read()
					)
					default:
						throw ("Unknown strDrawable tag " + tLine[1])
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				/*
				LightAttributes
				TheSkeleton
				LodGroup.LODGroups[0].LODMesh
				*/
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID:undefined ReportProgress:true CachePath:undefined = (	/*<TODO> CachePath*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						Separate = (No BufferID),
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						BufferID
				if No TexPath then
					TexPath = DiskPath
				if Separate then (
					BufferID = (
						BufferMgr.ReadFile (
								SCore.ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
					)
					local	NotEOF = BufferMgr.NotEOF
					while
						(NotEOF BufferID) and
						(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
					do
						ParseTag BufferID tLine UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
					BufferMgr.ClearBuffer BufferID
				) else (
					while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /* skips end */
						ParseTag BufferID tLine UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID:0 TabString:"" AdditionalTabString:"" Header:"gtaDrawable" DataDir:undefined ReportProgress:true ProgressData:[0, 0, 5] = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						BufferID
				if ReportProgress then
					UpdateProgress #Progress ProgressData
				local	SubDirName = (
							if Have DataDir then
								DataDir
							else
								ObjName
						),
						SubDir = (SubDirName + "\\"),
						SubDirPath = (DiskPath + SubDir),
						Separate = (BufferID == 0),
						HaveMeshes = false,
						LodGroups = LodGroup.LodGroups
				for LodGroup in LodGroups while not HaveMeshes where LodGroup.Count != 0 do
					HaveMeshes = true
				if
					Have TheSkeleton or
					Have LightAttributes or
					Have ShadingGroup or
					(
						Have LodGroup and
						HaveMeshes
					)
				then
					MakeDir SubDirPath All:true
				if Separate then (
					BufferID = BufferMgr.Create()
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				) else (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:Header \
							v3:" " \
							v4:ObjName
					)
					WriteVal BufferID (TabString + "{")
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Have ShadingGroup then (
					ShadingGroup.DiskPath = DiskPath
					ShadingGroup.ObjName = SubDirName
					ShadingGroup.Write BufferID TabString:(TabString + AdditionalTabString)
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				local	TheBones = (
					if Have TheSkeleton then (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:AdditionalTabString \
								v3:"skel"
						)
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:AdditionalTabString \
								v3:"{"
						)
						TheSkeleton.DiskPath = SubDirPath
						TheSkeleton.ObjName = ObjName
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:AdditionalTabString \
								v3:"\tskel " \
								v4:SubDir \
								v5:ObjName \
								v6:TheSkeleton.Extension
						)
						TheSkeleton.Write()
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:AdditionalTabString \
								v3:"}"
						)
						TheSkeleton.TheBones
					)
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Have LodGroup then (
					LodGroup.DiskPath = DiskPath
					LodGroup.ObjName = SubDirName
					LodGroup.Write BufferID TheBones TabString:(TabString + AdditionalTabString)
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Have LightAttributes then (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:AdditionalTabString \
							v3:"light"
					)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:AdditionalTabString \
							v3:"{"
					)
					LightAttributes.DiskPath = SubDirPath
					LightAttributes.ObjName = SubDirName
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:AdditionalTabString \
							v3:"\tlight " \
							v4:SubDir \
							v5:ObjName \
							v6:LightAttributes.Extension
					)
					LightAttributes.Write()
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:AdditionalTabString \
							v3:"}"
					)
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Separate then (
					BufferMgr.WriteFile BufferID FilePath:(
						FormatText \
							v1:DiskPath \
							v2:ObjName \
							v3:Extension
					)
					BufferMgr.ClearBuffer BufferID
				) else
					WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strDrawableDictionary (
		Tag = #DrawableDictionary,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDrawableDictionary",
		DiskPath,
		TexPath,
		ObjName,
		Extension = ".odd",
		Version = [110, 12],
		Items = #(),
		fn CheckLocked = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Locked = false
				for Item in Items while not Locked do
					Locked = (Item.CheckLocked())
				Locked
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				/*
				Items[0]
					LightAttributes
					TheSkeleton
					LodGroup.LODGroups[0].LODMesh
				*/
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read ReportProgress:true CachePath:undefined = (	/*<TODO> CachePath*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						StringOps = SCore.StringOps,
						oFTypeExec = StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						FormatText = ValueOps.FormatText,
						grcDrawable = GIMS.CurrentGame.Core.TypeLibrary.grcDrawable,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF
				if No TexPath then
					TexPath = DiskPath
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
							Skip BufferID 1 /* skip dict start */
						)
						#gtaDrawable: (
							Skip BufferID 1 /* skip start */
							NewItem = (grcDrawable DiskPath:DiskPath ObjName:tLine[2] TexPath:TexPath)
							NewItem.Read BufferID:BufferID ReportProgress:ReportProgress
							Append Items NewItem
						)
						default:
							throw ("Unknown strDrawableDictionary tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						BufferID = BufferMgr.Create(),
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						ProgressData = [0, 0, Items.Count * 5]
				if ReportProgress then
					UpdateProgress #Progress ProgressData
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Item in Items do (
					Item.DiskPath = DiskPath
					Item.Write \
						BufferID:BufferID \
						TabString:"\t" \
						AdditionalTabString:"\t" \
						DataDir:ObjName \
						ReportProgress:ReportProgress \
				)
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:(DiskPath + ObjName + Extension)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	/* oF fragments */
	struct strFragmentChildPart (
		Tag = #FragmentChildPart,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcFragmentChildPart",
		Version = [112, 2],
		DiskPath,
		TexPath,
		ObjName,
		Extension = ".child",
		Mass = 100,
		Drawable,
		BoundTransform,
		Bound,
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if No TexPath then
					TexPath = DiskPath
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcDrawable = TypeLibrary.grcDrawable,
						grcPhBound = TypeLibrary.grcPhBound,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:".child"
							)
						),
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
						)
						#Drawable: (
							Skip BufferID 1 /*skip start*/
							Drawable = (grcDrawable DiskPath:DiskPath ObjName:ObjName TexPath:TexPath)
							Drawable.Read BufferID:BufferID ReportProgress:false
						)
						#BoundTransform: (
							Skip BufferID 1 /*skip start*/
							BoundTransform = (
								Matrix3	(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3)
							)
							Skip BufferID 1 /*skip end*/
						)
						#Bound: (
							Skip BufferID 1 /*skip start*/
							if (TypeCast (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] name) != #Empty then (
								Bound = (grcPhBound DiskPath:DiskPath ObjName:ObjName)
								Bound.Read BufferID:BufferID ReportProgress:false
							) else
								Skip BufferID 2/*skip "empty" and end*/
						)
						default:
							throw ("Unknown strFragmentChildPart tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if No TexPath then
					TexPath = DiskPath
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						BufferID = BufferMgr.Create(),
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				MakeDir DiskPath All:true
				if Have Drawable then (
					Drawable.DiskPath = DiskPath
					Drawable.TexPath = TexPath
					Drawable.ObjName = ObjName
					Drawable.Write BufferID:BufferID Header:"drawable" AdditionalTabString:"\t" ReportProgress:false
				)
				if Have BoundTransform then (
					WriteVal BufferID "boundTransform"
					WriteVal BufferID "{"
					WriteVal BufferID (AsoFText BoundTransform TabString:"\t")
					WriteVal BufferID "}"
				)
				if Have Bound then
					Bound.Write BufferID:BufferID Header:"bound" ReportProgress:false
				else (
					WriteVal BufferID "bound"
					WriteVal BufferID "{"
					WriteVal BufferID "\tempty"
					WriteVal BufferID "}"
				)
				BufferMgr.WriteFile BufferID FilePath:(
					ValueOps.FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strFragmentChild (
		Tag = #FragmentChild,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcFragmentChild",
		DiskPath,
		TexPath,
		SubDir,
		PristinePart,
		DamagedPart,
		f50 = (Matrix3 1),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if No TexPath then
					TexPath = DiskPath
				local	tLine, Tag,
						Header, PristineMass, DamagedMass,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeCast = SCore.ValueOps.TypeCast,
						grcFragmentChildPart = GIMS.CurrentGame.Core.TypeLibrary.grcFragmentChildPart
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Child: (
							Header = tLine
							Skip BufferID 1 /*skip start*/
						)
						#PristineMass:
							PristineMass = (TypeCast tLine[2] Float)
						#DamagedMass:
							DamagedMass = (TypeCast tLine[2] Float)
						#f50: (
							Skip BufferID 1 /*skip start*/
							f50 = (
								Matrix3	(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3)
							)
							Skip BufferID 1 /*skip end*/
						)
						default:
							throw ("Unknown strFragmentChild tag " + tLine[1])
					)
				)
				local	PartInfo = Header[2]
				if (TypeCast PartInfo name) != #Null then (
					PristinePart = (grcFragmentChildPart Mass:PristineMass DiskPath:(DiskPath + (GetFileNamePath PartInfo)) ObjName:(GetFileNameFile PartInfo) TexPath:TexPath)
					PristinePart.Read()
				)
				PartInfo = Header[3]
				if (TypeCast PartInfo name) != #Null then (
					DamagedPart = (grcFragmentChildPart Mass:DamagedMass DiskPath:(DiskPath + (GetFileNamePath PartInfo)) ObjName:(GetFileNameFile PartInfo) TexPath:TexPath)
					DamagedPart.Read()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if No TexPath then
					TexPath = DiskPath
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						DefaultMass
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"child " \
						v3:(
							if Have PristinePart then (
								FormatText \
									v1:SubDir \
									v2:PristinePart.ObjName \
									v3:PristinePart.Extension
							) else
								"null"
						) \
						v4:" " \
						v5:(
							if Have DamagedPart then (
								FormatText \
									v1:SubDir \
									v2:DamagedPart.ObjName \
									v3:DamagedPart.Extension
							) else
								"null"
						)
				)
				WriteVal BufferID (TabString + "{")
				DefaultMass = (
					if Have PristinePart then
						PristinePart.Mass
					else (
						if Have DamagedPart then
							DamagedPart.Mass
						else
							0.0
					)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tpristineMass " \
						v3:(
							AsoFText (
								if Have PristinePart then
									PristinePart.Mass
								else
									DefaultMass
							)
						)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tdamagedMass " \
						v3:(
							AsoFText (
								if Have DamagedPart then
									DamagedPart.Mass
								else
									DefaultMass
							)
						)
				)
				WriteVal BufferID (TabString + "\tf50 [Temporarily|Unknown]")
				WriteVal BufferID (TabString + "\t{")
				WriteVal BufferID (AsoFText f50 TabString:(TabString + "\t\t"))
				WriteVal BufferID (TabString + "\t}")
				WriteVal BufferID (TabString + "}")
				local	PartsPath = (
							FormatText \
								v1:DiskPath \
								v2:"\\" \
								v3:SubDir \
								v4:"\\"
						)
				if Have PristinePart then (
					PristinePart.DiskPath = PartsPath
					PristinePart.TexPath = TexPath
					PristinePart.Write()
				)
				if Have DamagedPart then (
					DamagedPart.DiskPath = PartsPath
					DamagedPart.TexPath = TexPath
					DamagedPart.Write()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strFragmentGroup (
		Tag = #FragmentGroup,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcFragmentGroup",
		DiskPath,
		TexPath,
		SubDir,
		ObjName,
		strength = 100.0,
		forceTransmissionScaleUp = 0.25,
		forceTransmissionScaleDown = 0.25,
		jointStiffness = 0.0,
		minSoftAngle1 = -1.0,
		maxSoftAngle1 = 1.0,
		maxSoftAngle2 = 1.0,
		maxSoftAngle3 = 1.0,
		rotationSpeed = 0.0,
		rotationStrength = 0.0,
		restoringStrength = 0.0,
		restoringMaxTorque = 0.0,
		latchStrength = 0.0,
		disappearsWhenDead = false,
		minDamageForce = 100.0,
		damageHealth = 1000.0,
		Groups = #(),
		Children = #(),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				/*
				Drawable
				Fragment.Groups[0]
					Groups[0]
					Children[0]
				*/
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID UpdateProgress:undefined GetProgress:undefined ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcFragmentGroup = TypeLibrary.grcFragmentGroup,
						grcFragmentChild = TypeLibrary.grcFragmentChild,
						TypeCast = SCore.ValueOps.TypeCast,
						NewItem
				if No TexPath then
					TexPath = DiskPath
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#strength:
							strength = (TypeCast tLine[2] Float)
						#forceTransmissionScaleUp:
							forceTransmissionScaleUp = (TypeCast tLine[2] Float)
						#forceTransmissionScaleDown:
							forceTransmissionScaleDown = (TypeCast tLine[2] Float)
						#jointStiffness:
							jointStiffness = (TypeCast tLine[2] Float)
						#minSoftAngle1:
							minSoftAngle1 = (TypeCast tLine[2] Float)
						#maxSoftAngle1:
							maxSoftAngle1 = (TypeCast tLine[2] Float)
						#maxSoftAngle2:
							maxSoftAngle2 = (TypeCast tLine[2] Float)
						#maxSoftAngle3:
							maxSoftAngle3 = (TypeCast tLine[2] Float)
						#rotationSpeed:
							rotationSpeed = (TypeCast tLine[2] Float)
						#rotationStrength:
							rotationStrength = (TypeCast tLine[2] Float)
						#restoringStrength:
							restoringStrength = (TypeCast tLine[2] Float)
						#restoringMaxTorque:
							restoringMaxTorque = (TypeCast tLine[2] Float)
						#latchStrength:
							latchStrength = (TypeCast tLine[2] Float)
						#disappearsWhenDead:
							disappearsWhenDead = ((TypeCast tLine[2] Integer) != 0)
						#minDamageForce:
							minDamageForce = (TypeCast tLine[2] Float)
						#damageHealth:
							damageHealth = (TypeCast tLine[2] Float)
						#Group: (
							Skip BufferID 1 /*skip start*/
							NewItem = (grcFragmentGroup ObjName:tLine[2] SubDir:SubDir DiskPath:DiskPath TexPath:TexPath)
							NewItem.Read BufferID UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
							Append Groups NewItem
						)
						#Child: (
							Skip BufferID -1 /*return to header*/
							NewItem = (grcFragmentChild DiskPath:DiskPath TexPath:TexPath)
							NewItem.Read BufferID
							Append Children NewItem
						)
						#Flags:
							Flags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count})
						default:
							throw ("Unknown strFragmentGroup tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if No TexPath then
					TexPath = DiskPath
				local	Core = GIMS.Core,
						WriteVal = Core.BufferMgr.WriteVal,
						FormatText = Core.ValueOps.FormatText
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"strength " \
						v3:(AsoFText strength)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"forceTransmissionScaleUp " \
						v3:(AsoFText forceTransmissionScaleUp)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"forceTransmissionScaleDown " \
						v3:(AsoFText forceTransmissionScaleDown)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"jointStiffness " \
						v3:(AsoFText jointStiffness)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"minSoftAngle1 " \
						v3:(AsoFText minSoftAngle1)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"maxSoftAngle1 " \
						v3:(AsoFText maxSoftAngle1)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"maxSoftAngle2 " \
						v3:(AsoFText maxSoftAngle2)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"maxSoftAngle3 " \
						v3:(AsoFText maxSoftAngle3)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"rotationSpeed " \
						v3:(AsoFText rotationSpeed)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"rotationStrength " \
						v3:(AsoFText rotationStrength)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"restoringStrength " \
						v3:(AsoFText restoringStrength)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"restoringMaxTorque " \
						v3:(AsoFText restoringMaxTorque)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"latchStrength " \
						v3:(AsoFText latchStrength)
				)
				if disappearsWhenDead then
					WriteVal BufferID (TabString + "disappearsWhenDead 1")
				else
					WriteVal BufferID (TabString + "disappearsWhenDead 0")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"minDamageForce " \
						v3:(AsoFText minDamageForce)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"damageHealth " \
						v3:(AsoFText damageHealth)
				)
				for TempChild in Children do (
					TempChild.DiskPath = DiskPath
					TempChild.TexPath = TexPath
					TempChild.Write BufferID TabString:TabString
				)
				for TempGroup in Groups do (
					TempGroup.DiskPath = DiskPath
					TempGroup.TexPath = TexPath
					TempGroup.SubDir = SubDir
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"group " \
							v3:TempGroup.ObjName
					)
					WriteVal BufferID (TabString + "{")
					TempGroup.Write BufferID TabString:(TabString + "\t")
					WriteVal BufferID (TabString + "}")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strFragment (
		Tag = #Fragment,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcFragment",
		DiskPath,
		TexPath,
		SubDir,
		ObjName,
		UnbrokenCGOffset = [0, 0, 0],
		dampingLinearC = #(0.02, 0.02, 0.02),
		dampingLinearV = #(0.02, 0.02, 0.02),
		dampingLinearV2 = #(0.01, 0.01, 0.01),
		dampingAngularC = #(0.02, 0.02, 0.02),
		dampingAngularV = #(0.02, 0.02, 0.02),
		dampingAngularV2 = #(0.01, 0.01, 0.01),
		estimatedCacheSize = 15944,
		estimatedArticulatedCacheSize = 0,
		becomeRope = false,
		artAssetID = -1,
		attachBottomEnd = false,
		minMoveForce = 0,
		CenterOfMass = [0, 0, 0],
		gravityFactor = 1.0,
		buoyancyFactor = 80.0,
		Groups = #(),
		Flags = #(
			false,
			false,
			false,
			false
		),
		AvailFlags = #(
			#DISAPPEARS_WHEN_DEAD,
			#UNKNWON_FLAG,
			#CLONE_BOUND_PARTS_IN_CACHE,
			#FORCE_LOAD_COMMON_DRAWABLE
		),
		FlagStrings = #(
			"DISAPPEARS_WHEN_DEAD",
			"UNKNWON_FLAG",
			"CLONE_BOUND_PARTS_IN_CACHE",
			"FORCE_LOAD_COMMON_DRAWABLE"
		),
		fn Read BufferID UpdateProgress:undefined GetProgress:undefined ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						grcFragmentGroup = GIMS.CurrentGame.Core.TypeLibrary.grcFragmentGroup,
						TypeCast = SCore.ValueOps.TypeCast,
						NewItem
				if No TexPath then
					TexPath = DiskPath
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#UnbrokenCGOffset:
							unbrokenCGOffset = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#DampingLinearC:
							dampingLinearC = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#DampingLinearV:
							dampingLinearV = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#DampingLinearV2:
							dampingLinearV2 = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#DampingAngularC:
							dampingAngularC = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#DampingAngularV:
							dampingAngularV = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#DampingAngularV2:
							dampingAngularV2 = (oFTypeExec tLine #FloatArray IDMask:#{2..4})
						#EstimatedCacheSize:
							estimatedCacheSize = (TypeCast tLine[2] Integer)
						#EstimatedArticulatedCacheSize:
							estimatedArticulatedCacheSize = (TypeCast tLine[2] Integer)
						#BecomeRope:
							becomeRope = ((TypeCast tLine[2] Integer) != 0)
						#ArtAssetID:
							artAssetID = (TypeCast tLine[2] Integer)
						#AttachBottomEnd :
							AttachBottomEnd = ((TypeCast tLine[2] Integer) != 0)
						#MinMoveForce:
							minMoveForce = (TypeCast tLine[2] Float)
						#CenterOfMass:
							CenterOfMass = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#GravityFactor:
							gravityFactor = (TypeCast tLine[2] Float)
						#BuoyancyFactor:
							buoyancyFactor = (TypeCast tLine[2] Float)
						#Group: (
							Skip BufferID 1 /*skip start*/
							NewItem = (grcFragmentGroup ObjName:tLine[2] SubDir:SubDir DiskPath:DiskPath TexPath:TexPath)
							NewItem.Read BufferID UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
							Append Groups NewItem
						)
						#Flags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count}),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem AvailFlags Flag)
								if FlagID != 0 then
									Flags[FlagID] = true
								else
									SCore.SystemMgr.ThrowError ("Unknown flag \"" + Flag as String + "\" in object \"" + ObjName + "\" found!") #Abort
							)
						)
						default:
							throw ("Unknown strFragment tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" ReportProgress:true ProgressData:undefined = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText
				if No TexPath then
					TexPath = DiskPath
				WriteVal BufferID (AsoFText unbrokenCGOffset TabString:(TabString + "unbrokenCGOffset "))
				WriteVal BufferID (AsoFText dampingLinearC TabString:(TabString + "dampingLinearC "))
				WriteVal BufferID (AsoFText dampingLinearV TabString:(TabString + "dampingLinearV "))
				WriteVal BufferID (AsoFText dampingLinearV2 TabString:(TabString + "dampingLinearV2 "))
				WriteVal BufferID (AsoFText dampingAngularC TabString:(TabString + "dampingAngularC "))
				WriteVal BufferID (AsoFText dampingAngularV TabString:(TabString + "dampingAngularV "))
				WriteVal BufferID (AsoFText dampingAngularV2 TabString:(TabString + "dampingAngularV2 "))
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"estimatedCacheSize " \
						v3:estimatedCacheSize
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"estimatedArticulatedCacheSize " \
						v3:estimatedArticulatedCacheSize
				)
				if becomeRope then
					WriteVal BufferID (TabString + "becomeRope 1")
				else
					WriteVal BufferID (TabString + "becomeRope 0")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"artAssetID " \
						v3:artAssetID
				)
				if attachBottomEnd then
					WriteVal BufferID (TabString + "attachBottomEnd 1")
				else
					WriteVal BufferID (TabString + "attachBottomEnd 0")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"minMoveForce " \
						v3:minMoveForce
				)
				WriteVal BufferID (AsoFText CenterOfMass TabString:(TabString + "CenterOfMass "))
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"gravityFactor " \
						v3:(AsoFText gravityFactor)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"buoyancyFactor " \
						v3:(AsoFText buoyancyFactor)
				)
				for TempGroup in Groups do (
					if ReportProgress then (
						ProgressData.x += 1
						UpdateProgress #Progress ProgressData
					)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"group " \
							v3:TempGroup.ObjName
					)
					WriteVal BufferID (TabString + "{")
					TempGroup.DiskPath = DiskPath
					TempGroup.TexPath = TexPath
					TempGroup.Write BufferID TabString:(TabString + "\t")
					WriteVal BufferID (TabString + "}")
				)
				WriteVal BufferID (
					AsoFText \
						(
							local	Res = #(),
									FlagCount = Flags.Count
							Res.Count = FlagCount
							for i = 1 to FlagCount do (
								if Flags[i] then
									Res[i] = FlagStrings[i]
								else
									FlagCount -= 1
							)
							Res.Count = FlagCount
							Res
						) \
						TabString:(TabString + "flags ")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strFragType (
		Tag = #FragType,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcFragType",
		DiskPath,
		TexPath,
		ObjName,
		Extension = ".oft",
		Version = [112, 2],
		Fragment,
		Drawable,
		LightAttributes,
		f8 = #(),
		fn CheckGroupLocked Grp = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Locked = false,
						Groups = Grp.Groups,
						Children = Grp.Children
				if Children.Count != 0 then (
					for Child in Children while not Locked do (
						local	Parts = #(
									Child.PristinePart,
									Child.DamagedPart
								)
						for Part in Parts while not Locked where Have Part do (
							local	Drawable = Part.Drawable
							if Have Drawable then
								Locked = (Drawable.CheckLocked())
						)
					)
				)
				if
					not Locked and
					Groups.Count != 0
				then (
					for tGrp in Groups while not Locked do
						Locked = (CheckGroupLocked tGrp)
				)
				Locked
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CheckLocked = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Locked = false
				if Have Drawable then
					Locked = (Drawable.CheckLocked())
				if
					not Locked and
					Have Fragment
				then (
					for Grp in Fragment.Groups while not Locked do
						Locked = (CheckGroupLocked Grp)
				)
				Locked
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn PostCacheLoad CachePath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				/*
				Drawable
				Fragment.Groups[0]
					Groups[0]
					Children[0]
				*/
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read ReportProgress:true CachePath:undefined = (	/*<TODO> CachePath*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcFragment = TypeLibrary.grcFragment,
						grcDrawable = TypeLibrary.grcDrawable,
						grcLightAttributes = TypeLibrary.grcLightAttributes,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NotEOF = BufferMgr.NotEOF
				if No TexPath then
					TexPath = DiskPath
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /*skips end*/
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
						)
						#Fragments: (
							Skip BufferID 1 /*skip start*/
							Fragment = (grcFragment DiskPath:DiskPath SubDir:ObjName TexPath:TexPath)
							Fragment.Read BufferID UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
						)
						#Drawable: (
							Skip BufferID 1 /*skip start*/
							Drawable = (grcDrawable DiskPath:DiskPath ObjName:ObjName TexPath:TexPath)
							Drawable.Read BufferID:BufferID ReportProgress:ReportProgress
						)
						#f8: (
							Skip BufferID 1 /*skip start*/
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
								Skip BufferID 1 /*skip start*/
								Append f8 (
									Matrix3	(oFTypeExec (ReadVal BufferID) #P3) \
												(oFTypeExec (ReadVal BufferID) #P3) \
												(oFTypeExec (ReadVal BufferID) #P3) \
												(oFTypeExec (ReadVal BufferID) #P3)
								)
								Skip BufferID 1 /*skip end*/
								if ReportProgress then
									UpdateProgress #Progress (GetProgress BufferID)
							)
						)
						#Light: (
							Skip BufferID 1 /* skip start */
							local	PathParam = (ReadVal BufferID FilterStr:"\t ")[2]
							Skip BufferID 1 /* skip end */
							LightAttributes = (grcLightAttributes DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
							LightAttributes.Read()
						)
						default:
							throw ("Unknown strFragType tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SubDir = (ObjName + "\\"),
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						BufferID = BufferMgr.Create(),
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						ProgressData = [0, 0, 4 + Fragment.Groups.Count]
				if No TexPath then
					TexPath = DiskPath
				if ReportProgress then
					UpdateProgress #Progress ProgressData
				MakeDir (DiskPath + SubDir) All:true
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Have Fragment then (
					WriteVal BufferID "fragments"
					WriteVal BufferID "{"
					Fragment.DiskPath = DiskPath
					Fragment.TexPath = TexPath
					Fragment.SubDir = SubDir
					Fragment.Write BufferID TabString:"\t" ReportProgress:ReportProgress ProgressData:ProgressData
					WriteVal BufferID "}"
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Have Drawable then (
					Drawable.DiskPath = DiskPath
					Drawable.TexPath = TexPath
					Drawable.ObjName = ObjName
					Drawable.Extension = ".drawable"
					Drawable.Write BufferID:BufferID Header:"drawable" AdditionalTabString:"\t" ReportProgress:false
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if f8.Count != 0 then (
					WriteVal BufferID "f8 [Temporarily|Unknown]"
					WriteVal BufferID "{"
					for i = 1 to f8.Count do (
						WriteVal BufferID ("\t" + ((i - 1) as String))
						WriteVal BufferID "\t{"
						WriteVal BufferID (AsoFText f8[i] TabString:"\t\t")
						WriteVal BufferID "\t}"
					)
					WriteVal BufferID "}"
				)
				if Have LightAttributes then (
					LightAttributes.DiskPath = DiskPath
					LightAttributes.ObjName = ObjName
					WriteVal BufferID "light"
					WriteVal BufferID "{"
					WriteVal BufferID (
						FormatText \
							v1:"\tlight " \
							v2:SubDir \
							v3:ObjName \
							v4:LightAttributes.Extension
					)
					LightAttributes.Write()
					WriteVal BufferID "}"
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				BufferMgr.WriteFile BufferID FilePath:(
					FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	/*oF otd*/
	struct strTexture (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcTexture",
		TexPath,
		DiskPath,
		SubDir,
		ObjName,
		Type = "regular",
		MipMaps = 0,
		PixelFormat = "DXT5",
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						TypeCast = ValueOps.TypeCast
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Type:
							Type = tLine[2]
						#Name: (
							SubDir = (GetFileNamePath tLine[2])
							ObjName = (FileNameFromPath tLine[2])
							TexPath = (
								FormatText \
									v1:DiskPath \
									v2:SubDir \
									v3:"\\" \
									v4:ObjName
							)
						)
						#MipMaps:
							MipMaps = (TypeCast tLine[2] Integer)
						#PixelFormat:
							PixelFormat = tLine[2]
						default:
							throw ("Unknown strTexture tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						FormatText = SCore.ValueOps.FormatText
				WriteVal BufferID (TabString + "grcTexture")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tType " \
						v3:Type
				)
				ObjName = (FileNameFromPath TexPath)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tName " \
						v3:SubDir \
						v4:"\\" \
						v5:ObjName
				)
				if (DoesFileExist TexPath) then (
					MipMaps = 0
					local	TexBitMap = (try (OpenBitMap TexPath)	catch undefined)
					if Have TexBitMap then (
						local	Pixels,
								BitAnd = Bit.And,
								TW = TexBitMap.Width,
								TH = TexBitMap.Height
						if
							((BitAnd TW (TW - 1)) == 0) and
							((BitAnd TH (TH - 1)) == 0)
						then (
							if TW < TH then
								Pixels = TW
							else
								Pixels = TH
							while Pixels > 2 do (
								MipMaps += 1
								Pixels /= 2
							)
						)
						Close TexBitMap
					)
					SCore.SystemMgr.FileCopy TexPath (
						FormatText \
							v1:DiskPath \
							v2:SubDir \
							v3:"\\" \
							v4:ObjName
					)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tMipMaps " \
						v3:MipMaps
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tPixelFormat " \
						v3:PixelFormat
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strTextureDictionary (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary",
		Version = [8, 10],
		Textures = #(),
		DiskPath,
		ObjName,
		Extension = ".otd",
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						Skip = BufferMgr.Skip,
						ReadVal = BufferMgr.ReadVal,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						grcTexture = GIMS.CurrentGame.Core.TypeLibrary.grcTexture,
						tLine, Tag, NewItem,
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
							Skip BufferID 1 /*skip start*/
						)
						#grcTexture: (
							Skip BufferID 1 /*skip start*/
							NewItem = (grcTexture DiskPath:DiskPath)
							NewItem.Read BufferID /*skips end*/
							Append Textures NewItem
						)
						default:
							throw ("Unknown strTextureDictionary tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						BufferID = (BufferMgr.Create()),
						ObjDir = (DiskPath + ObjName)
				MakeDir ObjDir All:true
				WriteVal BufferID (SCore.ValueOps.AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Texture in Textures do (
					Texture.DiskPath = DiskPath
					Texture.SubDir = ObjName
					Texture.Write BufferID TabString:"\t"
				)
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:(ObjDir + Extension)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	/*oF bounds*/
	struct strCurvedEdge (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcCurvedEdge",
		unk_V = [-0.001, 0, 0],
		Dir,
		DeflatedRadius,
		Vertices = [0, 1],
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeCast = SCore.ValueOps.TypeCast
				Skip BufferID 1 /*skip header*/
				Skip BufferID 1 /*skip start*/
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#unk_V:
							unk_V = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#unk_V2:
							Dir = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#unk_F:
							DeflatedRadius = (TypeCast tLine[2] Float)
						#Vertices:
							Vertices = (oFTypeExec tLine #P2 IDMask:#{2, 3})
						default:
							throw ("Unknown strCurvedEdge tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText
				WriteVal BufferID (TabString + "edge")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (AsoFText unk_V TabString:(TabString + "\tunk_V "))
				WriteVal BufferID (AsoFText Dir TabString:(TabString + "\tunk_V2 "))
				WriteVal BufferID (
					ValueOps.FormatText \
						v1:TabString \
						v2:"\tunk_F " \
						v3:(AsoFText DeflatedRadius)
				)
				WriteVal BufferID (AsoFText Vertices TabString:(TabString + "\tVertices ") TypeHook:Integer)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strPhBound (
		Tag = #PhBound,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcPhBound",
		DiskPath,
		ObjName,
		Extension = ".obn",
		Version = [32, 11],
		Type,
		Bounds = GIMS.CurrentGame.Core.TypeLibrary.Bounds(),
		Margin,
		Extents,
		CapsuleData,
		Shrunk = #(),
		PolyMatIDs = #(),
		PolyVerts = #(),
		PolySiblings = #(),
		Vertices = #(),
		VertexScale,
		VertexOffset,
		CurvedEdges = #(),
		Materials = #(),
		Children = #(),
		ChildTransforms = #(),
		SimpleMaterial = false,
		fn ParseTag BufferID tLine UpdateProgress:undefined GetProgress:undefined ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	RAWData, MaterialData,
						SCore = GIMS.Core,
						GCore = GIMS.CurrentGame.Core,
						TypeLibrary = GCore.TypeLibrary,
						grcCurvedEdge = TypeLibrary.grcCurvedEdge,
						grcPhBound = TypeLibrary.grcPhBound,
						ColMaterials = GCore.DB.ColMaterials[3],
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeCast = SCore.ValueOps.TypeCast,
						Tag = (TypeCast tLine[1] name),
						NewItem
				if ReportProgress then
					UpdateProgress #Progress (GetProgress BufferID)
				case Tag of (
					#Version: (
						if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
					)
					#PhBound: (
						if Have tLine[2] then
							ObjName = tLine[2]
						Skip BufferID 1 /*skip start*/
					)
					#Centroid:
						Bounds.Centroid = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#Margin:
						Margin = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#CenterOfMass:
						Bounds.CenterOfMass = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#CentroidPresent: (
						Bounds.PushFlags = true
						Bounds.CentroidPresent = (tLine[2] != "0")
					)
					#CGPresent: (
						Bounds.PushFlags = true
						Bounds.CGPresent = (tLine[2] != "0")
					)
					#Type:
						Type = tLine[2]
					#Radius:
						Bounds.Radius = (TypeCast tLine[2] Float)
					#WorldRadius:
						Bounds.WorldRadius = (TypeCast tLine[2] Float)
					#Extents:
						Extents = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#Vertices: (
						Vertices.Count = (TypeCast tLine[2] Integer)
						Skip BufferID 1 /*skip start*/
						for i = 1 to Vertices.Count do
							Vertices[i] = (oFTypeExec (ReadVal BufferID) #P3)
						Skip BufferID 1 /*skip end*/
					)
					#Polygons: (
						local	PolyCount = (TypeCast tLine[2] Integer)
						if PolyCount != 0 then (
							PolyMatIDs.Count = PolyCount
							PolyVerts.Count = PolyCount
							PolySiblings.Count = PolyCount
							local	PolyID = 1
							Skip BufferID 1 /*skip start*/
							while (ReadVal BufferID FilterStr:"\t ")[1] != "}" do ( /*read polygons, skips their headers and end tokens*/
								local	PolyLine,
										IsTriFace = false
								Skip BufferID 1 /*skip polygon start token*/
								while (PolyLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*read polygon data, skips end token*/
									local	PolyTag = (TypeCast PolyLine[1] name)
									case PolyTag of (
										#Material:
											PolyMatIDs[PolyID] = ((TypeCast PolyLine[2] Integer) + 1)
										#Vertices: (
											local	Verts = (oFTypeExec PolyLine #P4 IDMask:#{2..5})
											IsTriFace = (Verts.w == 0)
											PolyVerts[PolyID] = (
												if IsTriFace then
													[Verts.x + 1, Verts.y + 1, Verts.z + 1]
												else
													[Verts.x + 1, Verts.y + 1, Verts.z + 1, Verts.w + 1]
											)
										)
										#Siblings: (
											if IsTriFace then (
												local	Siblings = (oFTypeExec PolyLine #P3 IDMask:#{2..4})
												PolySiblings[PolyID] = [Siblings.x + 1, Siblings.y + 1, Siblings.z + 1]
											) else (
												local	Siblings = (oFTypeExec PolyLine #P4 IDMask:#{2..5})
												PolySiblings[PolyID] = [Siblings.x + 1, Siblings.y + 1, Siblings.z + 1, Siblings.w + 1]
											)
										)
										default:
											throw ("Unknown Polygon tag " + PolyLine[1])
									)
								)
								PolyID += 1
							)
						)
					)
					#Materials: (
						Materials.Count = (TypeCast tLine[2] Integer)
						Skip BufferID 1 /*skip start*/
						local	UpdateMatrix = GIMS.Core.ValueOps.UpdateMatrix
						for i = 1 to Materials.Count do (
							local	Mtl = (EGIMS_IV_material ShowInViewport:true)
							Mtl.CollisionData = (UpdateMatrix Mtl.CollisionData 1 (oFTypeExec (ReadVal BufferID) #P3))
							local	MaterialData = (Mtl.FindDBIndex())
							Mtl.Name = ColMaterials[TypeCast MaterialData.x Integer][TypeCast MaterialData.y Integer]
							Materials[i] = Mtl
						)
						Skip BufferID 1 /*skip end*/
					)
					#Material: (
						SimpleMaterial = true
						local	Mtl = (EGIMS_IV_material ShowInViewport:true)
						Mtl.CollisionData = (GIMS.Core.ValueOps.UpdateMatrix Mtl.CollisionData 1 (oFTypeExec tLine #P3 IDMask:#{2..4}))
						local	MaterialData = (Mtl.FindDBIndex())
						Mtl.Name = ColMaterials[TypeCast MaterialData.x Integer][TypeCast MaterialData.y Integer]
						Materials[1] = Mtl
					)
					#Shrunk: (
						if (TypeCast tLine[2] name) != #Empty then (
							Shrunk.Count = (TypeCast tLine[2] Integer)
							Skip BufferID 1 /*skip start*/
							for i = 1 to Shrunk.Count do
								Shrunk[i] = (oFTypeExec (ReadVal BufferID) #P3)
							Skip BufferID 1 /*skip end*/
						) else
							Shrunk = #Empty
					)
					#CapsuleRadius: (
						local	Val = (TypeCast tLine[2] Float)
						if No CapsuleData then
							CapsuleData = [Val, 0]
						else
							CapsuleData.x = Val
					)
					#CapsuleHeight: (
						local	Val = (TypeCast tLine[2] Float)
						if No CapsuleData then
							CapsuleData = [0, Val]
						else
							CapsuleData.y = Val
					)
					#CurvedEdges: (
						CurvedEdges.Count = (TypeCast tLine[2] Integer)
						Skip BufferID 1 /*skip start*/
						for i = 1 to CurvedEdges.Count do (
							NewItem = grcCurvedEdge()
							NewItem.Read BufferID
							CurvedEdges[i] = NewItem
						)
						Skip BufferID 1 /*skip end*/
					)
					#AABBMax:
						Bounds.AABB.bMax = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#AABBMin:
						Bounds.AABB.bMin = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#VertexScale:
						VertexScale = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#VertexOffset:
						VertexOffset = (oFTypeExec tLine #P3 IDMask:#{2..4})
					#ChildTransforms: (
						ChildTransforms.Count = (TypeCast tLine[2] Integer)
						Skip BufferID 1 /*skip start*/
						for i = 1 to ChildTransforms.Count do (
							Skip BufferID 1 /*skip header*/
							Skip BufferID 1 /*skip start*/
							ChildTransforms[i] = (
								Matrix3	(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3) \
											(oFTypeExec (ReadVal BufferID) #P3)
							)
							Skip BufferID 1 /*skip end*/
						)
						Skip BufferID 1 /*skip end*/
					)
					#Children: (
						if (ReadVal BufferID FilterStr:"\t ")[1] == "{" then ( /*skips start*/
							while (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] != "}" do (
								NewItem = grcPhBound()
								NewItem.Read BufferID:BufferID
								Append Children NewItem
							)
							Skip BufferID 1 /*skip end*/
						) else
							Skip BufferID -1 /*return to the next tag*/
					)
					default:
						throw ("Unknown strPhBound tag " + tLine[1])
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID:undefined ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						Separate = (No BufferID),
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = SCore.GUIMgr.UpdateProgress
				if Separate then (
					local	BufferID = (
								BufferMgr.ReadFile (
									SCore.ValueOps.FormatText \
										v1:DiskPath \
										v2:ObjName \
										v3:Extension
								)
							),
							NotEOF = BufferMgr.NotEOF
					while
						(NotEOF BufferID) and
						(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
					do
						ParseTag BufferID tLine UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
					BufferMgr.ClearBuffer BufferID
				) else (
					while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do/*skips end*/
						ParseTag BufferID tLine UpdateProgress:UpdateProgress GetProgress:GetProgress ReportProgress:ReportProgress
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID:undefined Index:undefined TabString:"" AllowHeader:true Header:"phBound" ReportProgress:true ProgressData:undefined = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Separate = (No BufferID),
						AdditionalTab,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						TypeCast = ValueOps.TypeCast,
						UpdateProgress = SCore.GUIMgr.UpdateProgress
				if No ProgressData then (
					ProgressData = (
						if (TypeCast Type name) == #BoundComposite then
							[0, 0, 5 + Children.Count * 5]
						else
							[0, 0, 5]
					)
				)
				if ReportProgress then
					UpdateProgress #Progress ProgressData
				if Separate then (
					local	BufferID = BufferMgr.Create()
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				)
				if AllowHeader then (
					if Have Index then (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:Header \
								v3:" " \
								v4:(Index - 1)
						)
					) else (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:Header \
								v3:" " \
								v4:ObjName
						)
					)
					WriteVal BufferID (TabString + "{")
					AdditionalTab = "\t"
				) else
					AdditionalTab = ""
				local	FullTabString = (TabString + AdditionalTab)
				if Have Type then (
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:AdditionalTab \
							v3:"Type " \
							v4:Type
					)
				)
				Bounds.Write BufferID TabString:FullTabString
				if Have Margin then
					WriteVal BufferID (AsoFText Margin TabString:(FullTabString + "Margin "))
				if Have Extents then
					WriteVal BufferID (AsoFText Extents TabString:(FullTabString + "Extents "))
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Shrunk != #Empty then (
					if Shrunk.Count != 0 then (
						WriteVal BufferID (
							FormatText \
								v1:FullTabString \
								v2:"Shrunk " \
								v3:Shrunk.Count
						)
						WriteVal BufferID (FullTabString + "{")
						for Item in Shrunk do
							WriteVal BufferID (AsoFText Item TypeHook:Integer TabString:(FullTabString + "\t"))
						WriteVal BufferID (FullTabString + "}")
					)
				) else
					WriteVal BufferID (FullTabString + "Shrunk empty")
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				local	PolyCount = PolyMatIDs.Count
				if PolyCount != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"Polygons " \
							v3:PolyCount
					)
					WriteVal BufferID (FullTabString + "{")
					local	PolyTabString = (FullTabString + "\t")
					for ItemID = 1 to PolyCount do (
						WriteVal BufferID (
							FormatText \
								v1:PolyTabString \
								v2:"Polygon " \
								v3:(ItemID - 1)
						)
						WriteVal BufferID (PolyTabString + "{")
						WriteVal BufferID (
							FormatText \
								v1:PolyTabString \
								v2:"\tMaterial " \
								v3:(PolyMatIDs[ItemID] - 1)
						)
						local	Verts = PolyVerts[ItemID],
								Siblings = PolySiblings[ItemID]
						if
							(IsKindOf Verts Point3) or
							Verts.Count == 3
						then (
							WriteVal BufferID (AsoFText [Verts[1] - 1, Verts[2] - 1, Verts[3] - 1, 0] TabString:(PolyTabString + "\tVertices ") TypeHook:Integer)
							WriteVal BufferID (AsoFText [Siblings[1] - 1, Siblings[2] - 1, Siblings[3] - 1, -1] TabString:(PolyTabString + "\tSiblings ") TypeHook:Integer)
						) else (
							WriteVal BufferID (AsoFText [Verts[1] - 1, Verts[2] - 1, Verts[3] - 1, Verts[4] - 1] TabString:(PolyTabString + "\tVertices ") TypeHook:Integer)
							WriteVal BufferID (AsoFText [Siblings[1] - 1, Siblings[2] - 1, Siblings[3] - 1, Siblings[4] - 1] TabString:(PolyTabString + "\tSiblings ") TypeHook:Integer)
						)
						WriteVal BufferID (PolyTabString + "}")
					)
					WriteVal BufferID (FullTabString + "}")
				) else (
					if (TypeCast Type name) == #BoundCurvedGeometry then
						WriteVal BufferID (FullTabString + "Polygons 0")
				)
				if Have VertexScale then
					WriteVal BufferID (AsoFText VertexScale TabString:(FullTabString + "VertexScale "))
				if Have VertexOffset then
					WriteVal BufferID (AsoFText VertexOffset TabString:(FullTabString + "VertexOffset "))
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Vertices.Count != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"Vertices " \
							v3:Vertices.Count
					)
					WriteVal BufferID (FullTabString + "{")
					for Item in Vertices do
						WriteVal BufferID (AsoFText Item TypeHook:Integer TabString:(FullTabString + "\t"))
					WriteVal BufferID (FullTabString + "}")
				)
				if SimpleMaterial then
					WriteVal BufferID (AsoFText Materials[1].CollisionData[1] TabString:(FullTabString + "Material ") TypeHook:Integer)
				else (
					if Materials.Count != 0 then (
						WriteVal BufferID (
							FormatText \
								v1:FullTabString \
								v2:"Materials " \
								v3:Materials.Count
						)
						WriteVal BufferID (FullTabString + "{")
						for Item in Materials do
							WriteVal BufferID (AsoFText Item.CollisionData[1] TabString:(FullTabString + "\t") TypeHook:Integer)
						WriteVal BufferID (FullTabString + "}")
					)
				)
				if CurvedEdges.Count != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"CurvedEdges " \
							v3:CurvedEdges.Count
					)
					WriteVal BufferID (FullTabString + "{")
					for TheEdge in CurvedEdges do
						TheEdge.Write BufferID TabString:(FullTabString + "\t")
					WriteVal BufferID (FullTabString + "}")
				)
				if Have CapsuleData then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"CapsuleRadius " \
							v3:(AsoFText CapsuleData.x)
					)
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"CapsuleHeight " \
							v3:(AsoFText CapsuleData.y)
					)
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Children.Count != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"Children " \
							v3:Children.Count
					)
					WriteVal BufferID (FullTabString + "{")
					for ChildID = 1 to Children.Count do
						Children[ChildID].Write BufferID:BufferID Index:ChildID TabString:(FullTabString + "\t") ReportProgress:ReportProgress ProgressData:ProgressData
					WriteVal BufferID (FullTabString + "}")
				)
				if ChildTransforms.Count != 0 then (
					WriteVal BufferID (
						FormatText \
							v1:FullTabString \
							v2:"ChildTransforms " \
							v3:ChildTransforms.Count
					)
					WriteVal BufferID (FullTabString + "{")
					for ItemID = 1 to ChildTransforms.Count do (
						WriteVal BufferID (
							FormatText \
								v1:FullTabString \
								v2:"\tMatrix " \
								v3:(ItemID - 1)
						)
						WriteVal BufferID (FullTabString + "\t{")
						WriteVal BufferID (AsoFText ChildTransforms[ItemID] TabString:(FullTabString + "\t\t"))
						WriteVal BufferID (FullTabString + "\t}")
					)
					WriteVal BufferID (FullTabString + "}")
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if AllowHeader then
					WriteVal BufferID (TabString + "}")
				if Separate then (
					BufferMgr.WriteFile BufferID FilePath:(
						FormatText \
							v1:DiskPath \
							v2:ObjName \
							v3:Extension
					)
					BufferMgr.ClearBuffer BufferID
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strPhBoundDictionary (
		Tag = #PhBoundDictionary,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcPhBoundDictionary",
		DiskPath,
		ObjName,
		Extension = ".obd",
		Version = [32, 11],
		Items = #(),
		fn Read ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						grcPhBound = GIMS.CurrentGame.Core.TypeLibrary.grcPhBound,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
							Skip BufferID 1 /*skip dict start*/
						)
						#phBound: (
							Skip BufferID -1 /*return to the bound start*/
							NewItem = grcPhBound()
							NewItem.Read BufferID:BufferID ReportProgress:ReportProgress
							Append Items NewItem
						)
						default:
							throw ("Unknown strPhBoundDictionary tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						BufferID = BufferMgr.Create(),
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						EntryCount = (Items.Count * 5),
						ChildCount
				for Item in Items where (ChildCount = Item.Children.Count) != 0 do
					EntryCount += (ChildCount * 5)
				local	ProgressData = [0, 0, EntryCount]
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID "{"
				for Item in Items do
					Item.Write BufferID:BufferID TabString:"\t" ProgressData:ProgressData ReportProgress:ReportProgress
				WriteVal BufferID "}"
				BufferMgr.WriteFile BufferID FilePath:(
					ValueOps.FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	/*oF animations*/
	struct strAnimation_obj2 ( /*READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcAnimation_obj2",
		Structure,
		Type,
		channels = #()
	)
	struct strAnimation_obj4 ( /*READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcAnimation_obj4",
		BoneID,
		Action, /*0 pos, 1 rotation*/
		Type,
		crAnimation_obj2_Array = #()
	)
	struct strAnimation ( /*READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcAnimation",
		Name,
		Version = #(1, 1),
		Flags,
		Frames,
		_fA,
		Duration,
		_f10,
		_f28,
		MaterialID,
		crAnimation_obj4_Array = #()
	)
	struct strAnimationDictionary ( /*READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcAnimationDictionary",
		Version = #(1, 1),
		crAnimation_Array = #()
	)
	/*oF nav*/
	struct strNavTreeData (
		Tag = #NavTreeData,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavTreeData",
		PolyIndices = #(),
		Bounds = #(),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local tLine, Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						Modify = SCore.ArrayOps.Modify,
						TypeCast = SCore.ValueOps.TypeCast
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#PolyIndices: (
							if (TypeCast tLine[2] Integer) != 0 then (
								Skip BufferID 1 /*skip start*/
								while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /*skips end*/
									PolyIndices += (Modify (oFTypeExec tLine #IntArray) 1 #Add CopyArray:false)
							)
						)
						#Bounds: (
							Bounds.Count = (TypeCast tLine[2] Integer)
							if Bounds.Count != 0 then (
								Skip BufferID 1 /*skip start*/
								for i = 1 to Bounds.Count do (
									tLine = (ReadVal BufferID FilterStr:"\t ")
									Bounds[i] = (oFTypeExec tLine #P4)
								)
								Skip BufferID 1 /*skip end*/
							)
						)
						default:
							throw ("Unknown strNavTreeData tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						Modify = SCore.ArrayOps.Modify
				WriteVal BufferID (TabString + "SectorData")
				WriteVal BufferID (TabString + "{")
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tPolyIndices " \
						v3:PolyIndices.Count
				)
				if PolyIndices.Count != 0 then (
					WriteVal BufferID (TabString + "\t{")
					WriteVal BufferID (AsoFText (Modify PolyIndices -1 #Add CopyArray:false) SplitCount:15 TabString:(TabString + "\t\t"))
					WriteVal BufferID (TabString + "\t}")
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"\tBounds " \
						v3:Bounds.Count
				)
				if Bounds.Count != 0 then (
					WriteVal BufferID (TabString + "\t{")
					for TempItem in Bounds do
						WriteVal BufferID (AsoFText TempItem TypeHook:Integer TabString:(TabString + "\t\t"))
					WriteVal BufferID (TabString + "\t}")
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strNavTree (
		Tag = #NavTree,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavTree",
		Bounds = GIMS.CurrentGame.Core.TypeLibrary.Bounds(),
		SectorData,
		SubTrees = #(),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local tLine, Tag, Tag2,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						TypeCast = SCore.ValueOps.TypeCast,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcNavTreeData = TypeLibrary.grcNavTreeData,
						grcNavTree = TypeLibrary.grcNavTree,
						NewItem
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /*skips end*/
					Tag = (TypeCast tLine[1] name)
					Tag2 = (if No tLine[2] then #empty else (TypeCast tLine[2] name))
					case Tag of (
						#AABBMin:
							Bounds.AABB.bMin = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#AABBMax:
							Bounds.AABB.bMax = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#SectorData: (
							if Tag2 != #null then (
								Skip BufferID 1 /*skip start*/
								SectorData = grcNavTreeData()
								SectorData.Read BufferID /*skips end*/
							)
						)
						#SubTree0: (
							if Tag2 != #null then (
								Skip BufferID 1 /*skip start*/
								NewItem = grcNavTree()
								NewItem.Read BufferID /*skips end*/
								SubTrees[1] = NewItem
							)
						)
						#SubTree1: (
							if Tag2 != #null then (
								Skip BufferID 1 /*skip start*/
								NewItem = grcNavTree()
								NewItem.Read BufferID /*skips end*/
								SubTrees[2] = NewItem
							)
						)
						#SubTree2: (
							if Tag2 != #null then (
								Skip BufferID 1 /*skip start*/
								NewItem = grcNavTree()
								NewItem.Read BufferID /*skips end*/
								SubTrees[3] = NewItem
							)
						)
						#SubTree3: (
							if Tag2 != #null then (
								Skip BufferID 1 /*skip start*/
								NewItem = grcNavTree()
								NewItem.Read BufferID /*skips end*/
								SubTrees[4] = NewItem
							)
						)
						default:
							throw ("Unknown strNavTree tag " + tLine[1])
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" Header:"SectorTree" Index:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						WriteVal = SCore.BufferMgr.WriteVal,
						FormatText = SCore.ValueOps.FormatText
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:Header \
						v3:Index
				)
				WriteVal BufferID (TabString + "{")
				Bounds.Write BufferID TabString:(TabString + "\t")
				if No SectorData then
					WriteVal BufferID (TabString + "\tSectorData null")
				else
					SectorData.Write BufferID TabString:(TabString + "\t")
				for SubTreeID = 1 to 4 do (
					if No SubTrees[SubTreeID] then (
						WriteVal BufferID (
							FormatText \
								v1:TabString \
								v2:"\tSubTree" \
								v3:(SubTreeID - 1) \
								v4:" null"
						)
					) else
						SubTrees[SubTreeID].Write BufferID TabString:(TabString + "\t") Header:"SubTree" Index:((SubTreeID - 1) as String)
				)
				WriteVal BufferID (TabString + "}")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strNavPortal (
		Tag = #NavPortal,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavPortal",
		Points = #([0, 0, 0], [0, 0, 0]),
		PolyIDs = [1, 1],
		Sectors = [3600, 3600],
		WayDown = false, /*1/2*/
		tAngle = 0,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						tLine = (SCore.BufferMgr.ReadVal BufferID FilterStr:"\t ")
				tLine = (SCore.StringOps.oFTypeExec tLine #IntArray IDMask:#{1..tLine.Count})
				Points = #(
					[tLine[1], tLine[2], tLine[3]],
					[tLine[6], tLine[7], tLine[8]]
				)
				Sectors = [tLine[4], tLine[9]]
				PolyIDs = [tLine[5] + 1, tLine[10] + 1]
				WayDown = (tLine[11] == 2)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core
				SCore.BufferMgr.WriteVal BufferID (SCore.ValueOps.AsoFText #(Points[1].x, Points[1].y, Points[1].z, Sectors.x, PolyIDs.x - 1, Points[2].x, Points[2].y, Points[2].z, Sectors.y, PolyIDs.y - 1, (if WayDown then 2 else 1), tAngle) TabString:TabString TypeHook:Integer)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strNavPoly (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavPoly",
		VertexCount = 0,
		SurfaceFlags = 2, /*bits used [1..4, 6..8]*/
			/*1		edges/borders*/
			/*2		path crossing*/
			/*4		pavement*/
			/*8		sky not visible*/
			/*16	unknown*/
			/*32	polys near ladder*/
			/*64	downhill; autoset*/
			/*128	swim/water; autoset*/
		StartIndex = 1,
		PedGenFlags = 3, /*3 bits*/
			/*1		walking*/
			/*2		standing*/
			/*4		?near stairs(zone at start-end\left-right)? / ?walking accurately?*/
		f1C = 0, /*WORD*/
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						tLine = (SCore.BufferMgr.ReadVal BufferID FilterStr:"\t ")
				tLine = (SCore.StringOps.oFTypeExec tLine #IntArray IDMask:#{1..tLine.Count})
				StartIndex = (tLine[1] + 1)
				VertexCount = tLine[2]
				SurfaceFlags = tLine[3]
				PedGenFlags = tLine[4]
				f1C = tLine[5]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core
				SCore.BufferMgr.WriteVal BufferID (SCore.ValueOps.AsoFText #(StartIndex - 1, VertexCount, SurfaceFlags, PedGenFlags, f1C) TabString:TabString TypeHook:Integer)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strNavEdge (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavEdge",
		SectorIDs = [3600, 3600],
		PolyIDs = [1, 1],
		_f0_12 = 0, /*4 bits*/
		_f4_28 = 0,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						tLine = (SCore.BufferMgr.ReadVal BufferID FilterStr:"\t ")
				tLine = (SCore.StringOps.oFTypeExec tLine #IntArray IDMask:#{1..tLine.Count})
				SectorIDs = [tLine[1], tLine[4]]
				PolyIDs = [tLine[3] + 1, tLine[5] + 1]
				_f0_12 = tLine[2]
				_f4_28 = tLine[6]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString:"" = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core
				SCore.BufferMgr.WriteVal BufferID (SCore.ValueOps.AsoFText #(SectorIDs.x, _f0_12, PolyIDs.x - 1, SectorIDs.y, PolyIDs.y - 1, _f4_28) TabString:TabString TypeHook:Integer)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strNavMesh (
		Tag = #NavMesh,
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcNavMesh",
		DiskPath,
		ObjName,
		Extension = ".onv",
		Version = [1, 1],
		Sizes = [0, 0, 0],
		Flags = #( /*1/3/9/11*/
			true,
			false,
			false,
			false
		),
		Vertices = #(),
		Indices = #(),
		Edges = #(),
		Polys = #(),
		SectorTree = GIMS.CurrentGame.Core.TypeLibrary.grcNavTree(),
		Portals = #(),
		SectorID = 3600,
		Divider = 65536,
		fn Read ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Tag,
						SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = SCore.StringOps.oFTypeExec,
						ValueOps = SCore.ValueOps,
						TypeCast = ValueOps.TypeCast,
						Modify = SCore.ArrayOps.Modify,
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						grcNavEdge = TypeLibrary.grcNavEdge,
						grcNavPoly = TypeLibrary.grcNavPoly,
						grcNavPortal = TypeLibrary.grcNavPortal,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							)
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF
				while (NotEOF BufferID) do (
					local	tLine = (ReadVal BufferID FilterStr:"\t ")
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then
								SCore.SystemMgr.ThrowError ("Wrong version resource \"" + DiskPath + ObjName + Extension + "\" !") #Abort
						)
						#Sizes:
							Sizes = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#Flags: (
							local	Val = (TypeCast tLine[2] Integer)
							for i = 1 to Flags.Count do
								Flags[i] = (Bit.Get Val i)
						)
						#Vertices: (
							Vertices.Count = (TypeCast tLine[2] Integer)
							if Vertices.Count != 0 then (
								Skip BufferID 1 /*skip start*/
								for i = 1 to Vertices.Count do (
									tLine = (ReadVal BufferID FilterStr:"\t ")
									Vertices[i] = (oFTypeExec tLine #P3)
								)
								Skip BufferID 1 /*skip end*/
							)
						)
						#Indices: (
							if (TypeCast tLine[2] Integer) != 0 then (
								Skip BufferID 1 /*skip start*/
								while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /*skips end*/
									Indices += (Modify (oFTypeExec tLine #IntArray IDMask:#{1..tLine.Count}) 1 #Add CopyArray:false)
							)
						)
						#Edges: (
							Edges.Count = (TypeCast tLine[2] Integer)
							if Edges.Count != 0 then (
								Skip BufferID 1 /*skip start*/
								for i = 1 to Edges.Count do (
									NewItem = grcNavEdge()
									NewItem.Read BufferID
									Edges[i] = NewItem
								)
								Skip BufferID 1 /*skip end*/
							)
						)
						#Polys: (
							Polys.Count = (TypeCast tLine[2] Integer)
							if Polys.Count != 0 then (
								Skip BufferID 1 /*skip start*/
								for i = 1 to Polys.Count do (
									NewItem = grcNavPoly()
									NewItem.Read BufferID
									Polys[i] = NewItem
								)
								Skip BufferID 1 /*skip end*/
							)
						)
						#SectorTree: (
							Skip BufferID 1 /*skip start*/
							SectorTree.Read BufferID /*skips end*/
						)
						#Portals: (
							Portals.Count = (TypeCast tLine[2] Integer)
							if Portals.Count != 0 then (
								Skip BufferID 1 /*skip start*/
								for i = 1 to Portals.Count do (
									NewItem = grcNavPortal()
									NewItem.Read BufferID
									Portals[i] = NewItem
								)
								Skip BufferID 1 /*skip end*/
							)
						)
						#SectorID:
							SectorID = (TypeCast tLine[2] Integer)
						default:
							throw ("Unknown strNavMesh tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ReportProgress:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	SCore = GIMS.Core,
						BufferMgr = SCore.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						ValueOps = SCore.ValueOps,
						AsoFText = ValueOps.AsoFText,
						Modify = SCore.ArrayOps.Modify,
						UpdateProgress = SCore.GUIMgr.UpdateProgress,
						BufferID = BufferMgr.Create(),
						ProgressData = [0, 0, 7]
				if ReportProgress then
					UpdateProgress #Progress ProgressData
				WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
				WriteVal BufferID (AsoFText Sizes TabString:"Sizes ")
				tFlags = 0
				for i = 1 to Flags.Count do
					tFlags = (Bit.Set tFlags i Flags[i])
				WriteVal BufferID ("Flags " + tFlags as String)
				WriteVal BufferID ("Vertices " + Vertices.Count as String)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Vertices.Count != 0 then (
					WriteVal BufferID "{"
					for TempItem in Vertices do
						WriteVal BufferID (AsoFText TempItem TypeHook:Integer TabString:"\t")
					WriteVal BufferID "}"
				)
				WriteVal BufferID ("Indices " + Indices.Count as String)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Indices.Count != 0 then (
					WriteVal BufferID "{"
					WriteVal BufferID (AsoFText Indices SplitCount:15 TabString:"\t")
					WriteVal BufferID "}"
				)
				WriteVal BufferID ("Edges " + Edges.Count as String)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Edges.Count != 0 then (
					WriteVal BufferID "{"
					for TempItem in Edges do
						TempItem.Write BufferID TabString:"\t"
					WriteVal BufferID "}"
				)
				WriteVal BufferID ("Polys " + Polys.Count as String)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Polys.Count != 0 then (
					WriteVal BufferID "{"
					for TempItem in Polys do
						TempItem.Write BufferID TabString:"\t"
					WriteVal BufferID "}"
				)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				SectorTree.Write BufferID
				WriteVal BufferID ("Portals " + Portals.Count as String)
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
				if Portals.Count != 0 then (
					WriteVal BufferID "{"
					for TempItem in Portals do
						TempItem.Write BufferID TabString:"\t"
					WriteVal BufferID "}"
				)
				WriteVal BufferID ("SectorID " + SectorID as String)
				BufferMgr.WriteFile BufferID FilePath:(
					ValueOps.FormatText \
						v1:DiskPath \
						v2:ObjName \
						v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
				if ReportProgress then (
					ProgressData.x += 1
					UpdateProgress #Progress ProgressData
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	/*dat*/
	struct strDATNode ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.DATNode",
		Pos = [0, 0, 0],
		Type = 0,
		TheName = #NULL
	)
	struct strDATFile ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.DATFile",
		DoThisBitch
	)
	/*distantlights*/
	struct strDistantLink ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.DistantLink",
		Pos = [0, 0, 0],
		Flags = 65535,
		NodeID = 0,
		LinkCount = 0
	)
	struct strDistantLights ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.DistantLights",
		NodeCount = 0,
		LinkCount = 0,
		UnknownData_1 = (
			local	Res = #()
			for i = 64 to 1 by -1	do
				Res[i] = 0
			Res
		),
		UnknownData_2 = (DeepCopy UnknownData_1),
		UnknownData_3 = (DeepCopy UnknownData_1),
		Nodes = #(),
		Links = #()
	)
	/*NOD*/
	struct strNODNode ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.NODNode",
		Already = false,
		AreaID = 0,
		NodeID = 0,
		Interpolation = 0,
		LinkID = 0,
		Pos = [0, 0, 0],
		Width = 0,
		Type = 1,
		Flags_1 = 0,
		Flags_2 = 0,
		Flags_3 = 0,
		Flags_4 = 0,
		End = 0,
		GID = 0,
		fn Shrink = (
			(strNODNode Width:Width Type:Type Flags_1:Flags_1 Flags_2:Flags_2 Flags_3:Flags_3 Flags_4:Flags_4 Interpolation:Interpolation)
		)
	)
	struct strNODLink ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.NODLink",
		Already = false,
		InterAtStart = false,
		InterAtEnd = false,
		AreaID = 0,
		NodeID = 0,
		Density = 0,
		Len = 1,
		Flags = 0,
		StartNode = 0,
		EndNode = 0,
		GID =0 ,
		StartGID = 0,
		BackLen = 8,
		BackFlags = 0,
		BackDensity = 0,
		fn MakeBackLink StartGID GID = (
			local	NewLen = (GIMS.Core.ValueOps.CopyBits Len BackLen #{1..3} #{4..6})
			(strNODLink Density:BackDensity Len:NewLen Flags:BackFlags GID:GID StartGID:StartGID BackLen:BackLen BackFlags:BackFlags BackDensity:BackDensity)
		)
	)
	struct strNODArea ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.NODArea",
		CarNodeCount = 0,
		PedNodeCount = 0,
		Nodes = #(),
		Links = #()
	)
	struct strNODPaths ( /*<TODO>	READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.NODPaths"
	)
	/*mapping*/
	struct strIDEIPLVNod ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEIPLVNod",
		vPosition = [0, 0, 0],
		bUnk0 = true, /*bool _a14, [0..1], 2 items: #(0,1)*/
		bUnk1 = true, /*bool _a18, [0..1], 2 items: #(0,1)*/
		dUnk2 = 0, /*DWORD _a20, [0..70], 3 items: #(0,1,70)*/
		dUnk3 = 0, /*bool _a1C, [0..3], 4 items: #(0,1,2,3)*/
		dUnk4 = 0, /*DWORD _a24, [0..25], 24 items: #(0,1,2,3,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25)*/
		fAngle = 0, /*Float _a28, [-180.0..180.0], 485 items: #(-180.0,-179.9,-179.68,-179.0,-178.0..0,175.0,176.0,176.2,177.0,178.0,179.0,179.9,180.0)*/
		lUnk6 = 0, /*DWORD _a2C, [-2119733482..2142514224], 278 items: #(-2119733482,-2080114247,-2071417760..2131820829,2137460253,2142514224)*/
		bUnk7 = true, /*bool _a30 [0..255], 3 items: #(0,1,255)*/
		bUnk8 = true, /*bool _a34, [0..255], 3 items: #(0,1,255)*/
		bUnk9 = true, /*bool _a38 [0..255], 3 items: #(0,1,255)*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				vPosition.x = (TypeCast tLine[1] Float)
				vPosition.y = (TypeCast tLine[2] Float)
				vPosition.z = (TypeCast tLine[3] Float)
				bUnk0 = ((TypeCast tLine[4] Integer) != 0)
				bUnk1 = ((TypeCast tLine[5] Integer) != 0)
				dUnk2 = (TypeCast tLine[6] Integer)
				dUnk3 = (TypeCast tLine[7] Integer)
				dUnk4 = (TypeCast tLine[8] Integer)
				fAngle = (TypeCast tLine[9] Float)
				lUnk6 = (TypeCast (tLine[10] + "L") Integer)
				bUnk7 = ((TypeCast tLine[11] Integer) != 0)
				bUnk8 = ((TypeCast tLine[12] Integer) != 0)
				bUnk9 = ((TypeCast tLine[13] Integer) != 0)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEIPLlink ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEIPLlink",
		dStartID = 0,
		dEndID = 0,
		dUnk1 = 0, /*[0..4]*/
		dUnk2 = 0, /*[1..4]*/
		dUnk3 = 0, /*[0..2]*/
		dUnk4 = 0, /*[0..3]*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				dStartID = (TypeCast tLine[1] Integer)
				dEndID = (TypeCast tLine[2] Integer)
				dUnk1 = (TypeCast tLine[3] Integer)
				dUnk2 = (TypeCast tLine[4] Integer)
				dUnk3 = (TypeCast tLine[5] Integer)
				dUnk4 = (TypeCast tLine[6] Integer)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEIPL2dfx ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEIPL2dfx",
		sObjName = "",
		vPosition = [0, 0, 0],
		d2dfxType = 0,
		qRotation = (Quat 0 0 0 1),
		vDir = [0, 0, 1],
		Data,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				sObjName = tLine[1]
				vPosition.x = (TypeCast tLine[2] Float)
				vPosition.y = (TypeCast tLine[3] Float)
				vPosition.z = (TypeCast tLine[4] Float)
				d2dfxType = (TypeCast tLine[5] Integer)
				qRotation.x = (TypeCast tLine[6] Float)
				qRotation.y = (TypeCast tLine[7] Float)
				qRotation.z = (TypeCast tLine[8] Float)
				qRotation.w = (TypeCast tLine[9] Float)
				case d2dfxType of (
					0: () /*LightAttr - SKIP*/
					1: ( /* ParticleAttr*/
						if tLine.Count == 18 then (
							Data = #(
								EGIMS_IV_DFX_Particle,
								#(#sFXName, tLine[10]),
								#(#dColN, (TypeCast tLine[11] Integer)),
								#(#dFlags, (TypeCast (tLine[12] + "L") Integer)),
								#(#fScale, (TypeCast tLine[13] Float)),
								#(#dDrawDist, (TypeCast (tLine[14] + "L") Integer)),
								#(#CollPt, (TypeCast tLine[15] Integer)),
								#(#cColor, (Color (TypeCast tLine[16] Integer) (TypeCast tLine[17] Integer) (TypeCast tLine[18] Integer)))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX particle parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					2: ( /* ExplosionAttr*/
						if tLine.Count == 13 then (
							Data = #(
								EGIMS_IV_DFX_Explosion,
								#(#dFlags, (TypeCast (tLine[10] + "L") Integer)),
								#(#dType, (TypeCast tLine[11] Integer)),
								#(#dColN, (TypeCast tLine[12] Integer)),
								#(#dCollPt, (TypeCast tLine[13] Integer))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX explosion parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					10: ( /* EscalatorAttr*/
						if tLine.Count == 19 then (
							Data = #(
								EGIMS_IV_DFX_Escalator,
								#(#fUnkf1, (TypeCast tLine[10] Float)),
								#(#fUnkf2, (TypeCast tLine[11] Float)),
								#(#fUnkf3, (TypeCast tLine[12] Float)),
								#(#fUnkf4, (TypeCast tLine[13] Float)),
								#(#fUnkf5, (TypeCast tLine[14] Float)),
								#(#fUnkf6, (TypeCast tLine[15] Float)),
								#(#fUnkf7, (TypeCast tLine[16] Float)),
								#(#fUnkf8, (TypeCast tLine[17] Float)),
								#(#fUnkf9, (TypeCast tLine[18] Float)),
								#(#bFlag, ((TypeCast tLine[19] Integer) != 0))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX escalator parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					12: ( /* ProcObjAttr*/
						if tLine.Count == 20 then (
							Data = #(
								EGIMS_IV_DFX_ProcObject,
								#(#fUnk1, (TypeCast tLine[10] Float)),
								#(#fUnk2, (TypeCast tLine[11] Float)),
								#(#hObjName, (TypeCast (tLine[12] + "L") Integer)),
								#(#fUnk3, (TypeCast tLine[13] Float)),
								#(#dUnk4, (TypeCast tLine[14] Integer)),
								#(#dUnk5, (TypeCast tLine[15] Integer)),
								#(#dUnk6, (TypeCast tLine[16] Integer)),
								#(#dUnk7, (TypeCast tLine[17] Integer)),
								#(#fUnk8, (TypeCast tLine[18] Float)),
								#(#fUnk9, (TypeCast tLine[19] Float)),
								#(#dUnk10, (TypeCast tLine[20] Integer))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX procobj parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					13: ( /* ScriptAttr*/
						local	ParamCount = tLine.Count
						if
							ParamCount == 15 or
							ParamCount == 11
						then (
							local	HasTarget = ((TypeCast tLine[11] Integer) == 1)
							Data = (
								if HasTarget then #(
									EGIMS_IV_DFX_Script,
									#(#ScriptName, tLine[10]),
									#(#HasTarget, HasTarget),
									#(#fX, (TypeCast tLine[12] Float)),
									#(#fY, (TypeCast tLine[13] Float)),
									#(#fZ, (TypeCast tLine[14] Float)),
									#(#fAngle, (TypeCast tLine[15] Float))
								) else #(
									EGIMS_IV_DFX_Script,
									#(#ScriptName, tLine[10]),
									#(#HasTarget, HasTarget)
								)
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX script parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					14: ( /* LadderInfo*/
						if tLine.Count == 19 then (
							vPosition = [TypeCast tLine[10] Float, TypeCast tLine[11] Float, TypeCast tLine[12] Float]
							vDir = [TypeCast tLine[16] Float, TypeCast tLine[17] Float, TypeCast tLine[18] Float]
							Data = #(
								EGIMS_IV_DFX_Ladder,
								#(#fHeight, ((TypeCast tLine[15] Float) - vPosition.z)),
								#(#bFlag, ((TypeCast tLine[19] Integer) != 0))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX ladder parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					15: ( /* AudioAttr*/
						if tLine.Count == 10 then (
							Data = #(
								EGIMS_IV_DFX_Audio,
								#(#hAudioName, (TypeCast (tLine[10] + "L") Integer))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX audio parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					17: ( /* SpawnPoint*/
						if tLine.Count == 13 then (
							Data = #(
								EGIMS_IV_DFX_PedSpawn,
								#(#hScenario, (TypeCast (tLine[10] + "L") Integer)),
								#(#hPedType, (TypeCast (tLine[11] + "L") Integer)),
								#(#dUnk1, (TypeCast tLine[12] Integer)),
								#(#dUnk2, (TypeCast tLine[13] Integer))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX spawnpoint parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					18: ( /* LightShaftAttr*/
						if tLine.Count == 24 then (
							Data = #(
								EGIMS_IV_DFX_Lightshaft,
								#(
									#aVertices,
									(
										local	Res = #()
										for i = 4 to 1 by -1 do (
											Res[i] = [ \
												(TypeCast tLine[7 + i * 3] Float), \
												(TypeCast tLine[8 + i * 3] Float), \
												(TypeCast tLine[9 + i * 3] Float) \
											]
										)
										Res
									)
								),
								#(#dType, (TypeCast tLine[22] Integer)),
								#(#fUnk1, (TypeCast tLine[23] Float)),
								#(#fUnk2, (TypeCast tLine[24] Float))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX lightshaft parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					19: ( /* ScrollBar*/
						if
							tLine.Count > 14 and
							tLine.Count < 109
						then (
							local	PointCount = (TypeCast tLine[12] Integer),
									fThickness = (TypeCast tLine[10] Float)
							vPosition.z = ((TypeCast tLine[4] Float) - fThickness / 2)
							Data = #(
								EGIMS_IV_DFX_Scrollbar,
								#(
									#fThickness,
									fThickness
								),
								#(
									#aPoints,
									(
										local	Res = #()
										for i = PointCount to 1 by -1 do (
											Res[i] = [ \
												(TypeCast tLine[10 + i * 3] Float), \
												(TypeCast tLine[11 + i * 3] Float) \
											]
										)
										Res
									)
								),
								#(
									#dType,
									(TypeCast tLine[11] Integer)
								)
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX scrollbar parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					21: ( /* SwayableAttr*/
						if tLine.Count == 14 then (
							Data = #(
								EGIMS_IV_DFX_Swayable,
								#(#dUnk1, (TypeCast tLine[10] Integer)),
								#(#dUnk2, (TypeCast tLine[11] Integer)),
								#(#dUnk3, (TypeCast tLine[12] Integer)),
								#(#dUnk4, (TypeCast tLine[13] Integer)),
								#(#fUnk5, (TypeCast tLine[14] Float))
							)
						) else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX swayable parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					22: ( /* BouyancyAttr*/
						if tLine.Count == 9 then
							Data = #(EGIMS_IV_DFX_Bouyancy)
						else
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX bouyancy parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					23: ( /* WalkDontWalkAttr*/
						if tLine.Count != 9 then /*no params*/
							GIMS.Core.SystemMgr.AddResult #Error ("Wrong 2DFX walkdontwalk parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
					)
					default:
						GIMS.Core.SystemMgr.AddResult #Warning ("Unknown 2DFX type in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEobjs ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEobjs",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		LodName = "", /*char LodName[24]*/
		vSphere = [0, 0, 0, 0], /*Vector4 vSphere (0.f) , center+radius*/
		vMin = [0, 0, 0, 0], /*Vector4 vMin (0.f) , AABB min + draw distance*/
		vMax = [0, 0, 0], /*Vector3 vMax (0.f) , AABB max*/
		dwFlag1 = 0, /*DWORD dwFlag1 = 0*/
		dwFlag2 = 0, /*DWORD*/
		HasBounds = true,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				case tLine.Count of (
					16: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						dwFlag2 = (TypeCast (tLine[5] + "L") Integer)
						vMin.x = (TypeCast tLine[6] Float)
						vMin.y = (TypeCast tLine[7] Float)
						vMin.z = (TypeCast tLine[8] Float)
						vMax.x = (TypeCast tLine[9] Float)
						vMax.y = (TypeCast tLine[10] Float)
						vMax.z = (TypeCast tLine[11] Float)
						vSphere.x = (TypeCast tLine[12] Float)
						vSphere.y = (TypeCast tLine[13] Float)
						vSphere.z = (TypeCast tLine[14] Float)
						vSphere.w = (TypeCast tLine[15] Float)
						LodName = tLine[16]
					)
					15: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						vMin.x = (TypeCast tLine[6] Float)
						vMin.y = (TypeCast tLine[7] Float)
						vMin.z = (TypeCast tLine[8] Float)
						vMax.x = (TypeCast tLine[9] Float)
						vMax.y = (TypeCast tLine[10] Float)
						vMax.z = (TypeCast tLine[11] Float)
						vSphere.x = (TypeCast tLine[12] Float)
						vSphere.y = (TypeCast tLine[13] Float)
						vSphere.z = (TypeCast tLine[14] Float)
						vSphere.w = (TypeCast tLine[15] Float)
						LodName = tLine[16]
					)
					4: (
						HasBounds = false
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
					)
					Default:
						GIMS.Core.SystemMgr.AddResult #Warning ("Wrong OBJS parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEmloInst ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEmloInst",
		DoThisBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEmloPortal ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEmloPortal",
		DoThisBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEmloRoom ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEmloRoom",
		DoThisBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEmlo ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEmlo"/*,
		char Name[24];
		DWORD _v20;
		DWORD dwRoomCount = 0;
		DWORD dwPortalDataCount = 0;
		DWORD dwDataCount = 0;
		Float _v24 = 0.f;
		Float _v30 = 0.f;
		Float _v2C = 0.f;
		fn Read BufferID tLine = (
				if (8 != sscanf_s (pLine, "%s %d %d %d %d %f %f %f",
					Name, 24, &_v20, &dwRoomCount, &dwPortalDataCount, &dwDataCount, &_v24, &_v30, &_v2C)) {
						if (5 != sscanf_s (pLine, "%s %d %d %d %d", Name, 24, &_v20, &dwRoomCount, &dwPortalDataCount, &dwDataCount)) {
							trace ("ERROR: [ivConfigReader::parseIdeMlo] bad format '%s'\n", pLine);
							return NULL;
						}
						_v2C = _v24 = _v30 = -1.f;
				}
				ivMloModelInfo * pModel = ivModelInfoStore::allocateMloModel (Name);
				pModel->m_dwFirstMloDataIndex = pModel->_f64 = ivModelInfoStore::ms_mlo->dwUsed;
				pModel->setTxd ("generic");
				if (!dwPortalDataCount)
					dwRoomCount = 1;
				pModel->allocateMloData (dwRoomCount, dwPortalDataCount, dwDataCount, _v20);
				pModel->_f70->setData (_v2C, _v24, _v30);
				if (dwPortalDataCount) {
					pModel->m_dwFlags |= 8;
					pModel->setDrawDistance (20.f);
				}
				ivModelInfoStore::sortModelNameIndex ();
				return pModel;
									9: ( --mlo
										LastMLO = s_mlo[s_mlo.Count]
										dwState = 3
									)
									000000: ( --mlo data
										if tag == #mloend then
											dwState = 2
										else
											if tag == #mloroomstart then
												dwState = 4
											else (
												if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEmloInst()).Read tLine)) then
													Append LastMLO.Inst TempObj
											)
									)
									000000: ( --mlo => mloroomstart
										if tag == #mloportalstart then
											dwState = 6
										else (
											if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEmloRoom()).Read tLine)) then
												Append LastMLO.Rooms TempObj
											LastMLORoom = LastMLO.Rooms[LastMLO.Rooms.Count]
											dwState = 5
										)
									)
									000000: ( --mlo => mloroomstart data
										if tag == #roomend then
											dwState = 4
										else (
											if tLine.Count == 16 then (
												for TempID in tLine where TempID != "-1" do
													Append LastMLORoom.Inst s_mlo[s_mlo.Count].Inst[(GIMS.Core.ValueOps.TypeCast TempID Integer) + 1]
											) else
												GIMS.Core.SystemMgr.AddResult #Error ("Wrong MLO.Room.Inst parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
										)
									)
									000000: ( --mlo => mloroomstart => mloportalstart
										if tag == #mloend then
											dwState = 2
										else (
											if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEmloPortal()).Read tLine)) then
												Append LastMLO.Portals TempObj
										)
									)
		),
		fn Write BufferID = (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
		)
		*/
	)
	struct strIDEtobj ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEtobj",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		LodName = "", /*char LodName[24]*/
		vSphere = [0, 0, 0, 0], /*Vector4 vSphere (0.f) , center+radius*/
		vMin = [0, 0, 0, 0], /*Vector4 vMin (0.f) , AABB min + draw distance*/
		vMax = [0, 0, 0], /*Vector3 vMax (0.f) , AABB max*/
		dwFlag1 = 0, /*DWORD dwFlag1 = 0*/
		dwFlag2 = 0, /*DWORD*/
		dwNightFlag1 = 0, /*DWORD ?*/
		dwNightFlag2 = 0, /*DWORD ?*/
		dwTimeMask = 0, /*DWORD bitfield*/
		HasBounds = true,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				case tLine.Count of (
					18: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						dwFlag2 = (TypeCast (tLine[5] + "L") Integer)
						vMin.x = (TypeCast tLine[6] Float)
						vMin.y = (TypeCast tLine[7] Float)
						vMin.z = (TypeCast tLine[8] Float)
						vMax.x = (TypeCast tLine[9] Float)
						vMax.y = (TypeCast tLine[10] Float)
						vMax.z = (TypeCast tLine[11] Float)
						vSphere.x = (TypeCast tLine[12] Float)
						vSphere.y = (TypeCast tLine[13] Float)
						vSphere.z = (TypeCast tLine[14] Float)
						vSphere.w = (TypeCast tLine[15] Float)
						LodName = tLine[16]
						dwNightFlag1 = (TypeCast (tLine[17] + "L") Integer)
						dwNightFlag2 = (TypeCast (tLine[18] + "L") Integer)
					)
					17: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						dwFlag2 = (TypeCast (tLine[5] + "L") Integer)
						vMin.x = (TypeCast tLine[6] Float)
						vMin.y = (TypeCast tLine[7] Float)
						vMin.z = (TypeCast tLine[8] Float)
						vMax.x = (TypeCast tLine[9] Float)
						vMax.y = (TypeCast tLine[10] Float)
						vMax.z = (TypeCast tLine[11] Float)
						vSphere.x = (TypeCast tLine[12] Float)
						vSphere.y = (TypeCast tLine[13] Float)
						vSphere.z = (TypeCast tLine[14] Float)
						vSphere.w = (TypeCast tLine[15] Float)
						LodName = tLine[16]
						dwTimeMask = (TypeCast (tLine[17] + "L") Integer)
					)
					16: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						vMin.x = (TypeCast tLine[5] Float)
						vMin.y = (TypeCast tLine[6] Float)
						vMin.z = (TypeCast tLine[7] Float)
						vMax.x = (TypeCast tLine[8] Float)
						vMax.y = (TypeCast tLine[9] Float)
						vMax.z = (TypeCast tLine[10] Float)
						vSphere.x = (TypeCast tLine[11] Float)
						vSphere.y = (TypeCast tLine[12] Float)
						vSphere.z = (TypeCast tLine[13] Float)
						vSphere.w = (TypeCast tLine[14] Float)
						dwNightFlag1 = (TypeCast (tLine[15] + "L") Integer)
						dwNightFlag2 = (TypeCast (tLine[16] + "L") Integer)
					)
					7: (
						HasBounds = false
						ModelName = tLine[1]
						TxdName = tLine[2]
						vMin.w = (TypeCast tLine[3] Float)
						dwFlag1 = (TypeCast (tLine[4] + "L") Integer)
						dwFlag2 = (TypeCast (tLine[5] + "L") Integer)
						dwNightFlag1 = (TypeCast (tLine[6] + "L") Integer)
						dwNightFlag2 = (TypeCast (tLine[7] + "L") Integer)
					)
					Default:
						GIMS.Core.SystemMgr.AddResult #Error ("Wrong TOBJ parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEweap ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEweap",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		AnimName = "", /*char AnimName[24]*/
		dwFlags = 0,
		fDrawDistance = 0,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				if tLine.Count == 6 then (
					ModelName = tLine[1]
					TxdName = tLine[2]
					AnimName = tLine[3]
					dwFlags = (TypeCast tLine[4] Integer)
					fDrawDistance = (TypeCast tLine[5] Float)
				) else
					GIMS.Core.SystemMgr.AddResult #Error ("Wrong WEAP parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEhier ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEhier",
		idx = -1,	/*int; write 4 params without this, if -1*/
		modelName = "", /*char modelName[24]*/
		txdName = "", /*char txdName[24]*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				case tLine.Count of (
					5: (
						idx = (TypeCast tLine[1] Integer)
						modelName = tLine[2]
						txdName = tLine[3]
					)
					4: (
						modelName = tLine[1]
						txdName = tLine[2]
					)
					Default:
						GIMS.Core.SystemMgr.AddResult #Error ("Wrong HIER parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEanim ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEanim",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		AnimName = "", /*char AnimName[24]*/
		LodName = "", /*char LodName[24]*/
		vSphere = [0, 0, 0, 0], /*Vector4 vSphere (0.f) , center+radius*/
		vMin = [0, 0, 0, 0], /*Vector4 vMin (0.f) , AABB min + draw distance*/
		vMax = [0, 0, 0], /*Vector3 vMax (0.f) , AABB max*/
		dwFlag1 = 0, /*DWORD dwFlag1 = 0*/
		dwFlag2 = 0, /*DWORD dwFlag2 = 0*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				if tLine.Count == 17 then (
					ModelName = tLine[1]
					TxdName = tLine[2]
					AnimName = tLine[3]
					vMin.w = (TypeCast tLine[4] Float)
					dwFlag1 = (TypeCast (tLine[5] + "L") Integer)
					dwFlag2 = (TypeCast (tLine[6] + "L") Integer)
					vMin.x = (TypeCast tLine[7] Float)
					vMin.y = (TypeCast tLine[8] Float)
					vMin.z = (TypeCast tLine[9] Float)
					vMax.x = (TypeCast tLine[10] Float)
					vMax.y = (TypeCast tLine[11] Float)
					vMax.z = (TypeCast tLine[12] Float)
					vSphere.x = (TypeCast tLine[13] Float)
					vSphere.y = (TypeCast tLine[14] Float)
					vSphere.z = (TypeCast tLine[15] Float)
					vSphere.w = (TypeCast tLine[16] Float)
					LodName = tLine[17]
				) else
					GIMS.Core.SystemMgr.AddResult #Warning ("Wrong TANM parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEcars ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEcars",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		Type = "", /*char Type[8]*/
		HandlingId = "", /*char HandlingId[16]*/
		GameName = "", /*char GameName[32]*/
		AnimName = "", /*char AnimName[32]*/
		AnimName2 = "", /*char AnimName2[24]*/
		dwFrq = 100, /*DWORD dwFrq*/
		dwMaxNum = 999, /*DWORD dwMaxNum*/
		fWheelRadiusF = 0.2, /*Float fWheelRadiusF*/
		fWheelRadiusR = 0.2, /*Float fWheelRadiusR*/
		fDefDirtLevel = 0, /*Float fDefDirtLevel MAX = 1*/
		dwSwankness = 5, /*DWORD dwSwankness*/
		fLodMult = 1.0, /*Float fLodMult*/
		dwLodFlags = 0, /*DWORD dwLodFlags*/
		Opts = "-", /*char Opts[512]*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				case tLine.Count of (
					16: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						Type = tLine[3]
						HandlingId = tLine[4]
						GameName = tLine[5]
						AnimName = tLine[6]
						AnimName2 = tLine[7]
						dwFrq = (TypeCast tLine[8] Integer)
						dwMaxNum = (TypeCast tLine[9] Integer)
						fWheelRadiusF = (TypeCast tLine[10] Float)
						fWheelRadiusR = (TypeCast tLine[11] Float)
						fDefDirtLevel = (TypeCast tLine[12] Float)
						dwSwankness = (TypeCast tLine[13] Integer)
						fLodMult = (TypeCast tLine[14] Float)
						dwLodFlags = (TypeCast (tLine[15] + "L") Integer)
						Opts = tLine[16]
					)
					14: (
						ModelName = tLine[1]
						TxdName = tLine[2]
						Type = tLine[3]
						HandlingId = tLine[4]
						GameName = tLine[5]
						AnimName = tLine[6]
						AnimName2 = tLine[7]
						dwFrq = (TypeCast tLine[8] Integer)
						dwMaxNum = (TypeCast tLine[9] Integer)
						fWheelRadiusF = (TypeCast tLine[10] Float)
						fWheelRadiusR = (TypeCast tLine[11] Float)
						fDefDirtLevel = (TypeCast tLine[12] Float)
						dwSwankness = (TypeCast tLine[13] Integer)
						Opts = tLine[14]
					)
					default:
						GIMS.Core.SystemMgr.AddResult #Error ("Wrong CARS parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEpeds ( /*<TODO>	WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEpeds",
		ModelName = "",	/*char ModelName[24];*/
		PropsName = "",	/*char PropsName[24];*/
		Pedtype = "",	/*char Pedtype[24];*/
		AnimGroup = "",	/*char AnimGroup[24];*/
		GestureGroup = "",	/*char GestureGroup[24];*/
		GesturePhoneGroup = "",	/*char GesturePhoneGroup[24];*/
		FacialGroup = "",	/*char FacialGroup[24];*/
		VisemeGroup = "",	/*char VisemeGroup[24];*/
		dwFlags = 0,	/*DWORD dwFlags;*/
		AnimFile = "",	/*char AnimFile[24];*/
		BlendshapeFile = "",	/*char BlendshapeFile[24];*/
		dwRadio1 = 0,	/*DWORD dwRadio1;*/
		dwRadio2 = 0,	/*DWORD dwRadio2;*/
		Audiotype = "",	/*char Audiotype[20];*/
		FirstVoice = "",	/*char FirstVoice[60];*/
		LastVoice = "",	/*char LastVoice[60];*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				if tLine.Count == 16 then (
					ModelName = tLine[1]
					PropsName = tLine[2]
					Pedtype = tLine[3]
					AnimGroup = tLine[4]
					GestureGroup = tLine[5]
					GesturePhoneGroup = tLine[6]
					FacialGroup = tLine[7]
					VisemeGroup = tLine[8]
					dwFlags = (TypeCast tLine[9] Integer)
					AnimFile = tLine[10]
					BlendshapeFile = tLine[11]
					dwRadio1 = (TypeCast tLine[12] Integer)
					dwRadio2 = (TypeCast tLine[13] Integer)
					Audiotype = tLine[14]
					FirstVoice = tLine[15]
					LastVoice = tLine[16]
				) else
					GIMS.Core.SystemMgr.AddResult #Error ("Wrong PEDS parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"! Skipping...")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEtxdp ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEtxdp"/*,
		char Name1[32];
		char Name2[32];
		fn Read BufferID tLine = (
				if (2 != sscanf_s (pLine, "%s %s", Name1, 24, Name2, 24)) {
					trace ("ERROR: [ivConfigReader::parseIdeTxdp] bad format '%s'\n", pLine);
					return ;
				}
				DWORD dwTxd1Index = ivTxdStore::getIndexByNameAlways (Name1);
				DWORD dwTxd2Index = ivTxdStore::getIndexByNameAlways (Name2);
				ivTxdStore::setParent (dwTxd1Index, dwTxd2Index);
		),
		fn Write BufferID = (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
		)
		*/
	)
	struct strIDEamat ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEamat"/*,
		char Name[64];
		DWORD _v88;
		char Material[64];
		fn Read BufferID tLine = (
				sscanf_s (pLine, "%s %u %s", Name, 64, &_v88, Material, 64);
				DWORD dwMaterial;
				if (Material[0] >= '0' && Material[0] <= '9')
					sscanf_s (Material, "%u", &dwMaterial);
				else
					dwMaterial = sysHash (Material);
				ivModelInfoStore::sortModelNameIndex ();
				ivBaseModelInfo * pModel = ivModelInfoStore::getModelByName (Name, NULL);
				if (pModel) {
					ivAudioMaterial * pAmat = ivModelInfoStore::ms_amat->allocate ();
					pModel->addAudioMaterial (pAmat);
					pAmat->_f0 = _v88;
					pAmat->dwHash = dwMaterial;
				}
		),
		fn Write BufferID = (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
		)
		*/
	)
	struct strIDEtanm ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEtanm",
		ModelName = "", /*char ModelName[24]*/
		TxdName = "", /*char TxdName[24]*/
		AnimName = "", /*char AnimName[24]*/
		LodName = "", /*char LodName[24]*/
		vSphere = [0, 0, 0, 0], /*Vector4 vSphere (0.f) , center+radius*/
		vMin = [0, 0, 0, 0], /*Vector4 vMin (0.f),	AABB min + draw distance*/
		vMax = [0, 0, 0], /*Vector3 vMax (0.f), AABB max*/
		dwFlag1 = 0, /*DWORD dwFlag1 = 0*/
		dwFlag2 = 0, /*DWORD dwFlag2 = 0*/
		dwTimeMask = 0, /*DWORD bitfield*/
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast
				if tLine.Count == 18 then (
					ModelName = tLine[1]
					TxdName = tLine[2]
					AnimName = tLine[3]
					vMin.w = (TypeCast tLine[4] Float)
					dwFlag1 = (TypeCast (tLine[5] + "L") Integer)
					dwFlag2 = (TypeCast (tLine[6] + "L") Integer)
					vMin.x = (TypeCast tLine[7] Float)
					vMin.y = (TypeCast tLine[8] Float)
					vMin.z = (TypeCast tLine[9] Float)
					vMax.x = (TypeCast tLine[10] Float)
					vMax.y = (TypeCast tLine[11] Float)
					vMax.z = (TypeCast tLine[12] Float)
					vSphere.x = (TypeCast tLine[13] Float)
					vSphere.y = (TypeCast tLine[14] Float)
					vSphere.z = (TypeCast tLine[15] Float)
					vSphere.w = (TypeCast tLine[16] Float)
					LodName = tLine[17]
					dwTimeMask = (TypeCast (tLine[18] + "L") Integer)
				) else
					GIMS.Core.SystemMgr.AddResult #Warning ("Wrong TANM parameter count in line \"" + (GIMS.Core.ValueOps.AsoFText tLine SplitString:", ") + "\"")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIDEagrps ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEagrps"/*,
		char ModelName[24];
		char AgrpName[24];
		char dwAgrpData;
		fn Read BufferID tLine = (
				if (3 != sscanf_s (pLine, "%s %s %d", ModelName, 24, AgrpName, 24, &dwAgrpData)) {
					trace ("ERROR: [ivConfigReader::parseIdeAgrps] bad format '%s'\n", pLine);
					return ;
				}
				ivPedModelInfo * pModel = reinterpret_cast<ivPedModelInfo *>(ivModelInfoStore::getModelByName (ModelName, NULL));
				if (pModel)
					pModel->addAgrp (sysHash (AgrpName), dwAgrpData);
		),
		fn Write BufferID = (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
		)
		*/
	)
	struct strIDE ( /*<TODO>	CHECK*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.IDEFile",
		DiskPath,
		ObjName,
		Extension = ".ide",
		SectionNames = #(
			#2dfx,	/*1*/
			#agrps,	/*2*/
			#amat,	/*3*/
			#anim,	/*4*/
			#cars,	/*5*/
			#hier,	/*6*/
			#Link,	/*7*/
			#lodm,	/*8*/
			#mlo,		/*9*/
			#objs,	/*10*/
			#path,	/*11*/
			#peds,	/*12*/
			#tanm,	/*13*/
			#tobj,	/*14*/
			#tree,	/*15*/
			#txdp,	/*16*/
			#vnod,	/*17*/
			#weap	/*18*/
		),
		SectionData = #(
			#(),
			#(),
			#(),
			#(),
			#(),
			#(),
			#(),
			undefined,
			#(),
			#(),
			undefined,
			#(),
			#(),
			#(),
			undefined,
			#(),
			#(),
			#()
		),
		SectionOrder = #(
			10,
			14,
			15,
			11,
			4,
			13,
			3,
			2,
			6,
			12,
			18,
			17,
			9,
			1,
			8
		),
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Core = GIMS.Core,
						BufferMgr = Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						NotEOF = BufferMgr.NotEOF,
						ValueOps = Core.ValueOps,
						QuickSearch = Core.ArrayOps.QuickSearch,
						TypeCast = ValueOps.TypeCast,
						BufferID = (
							BufferMgr.ReadFile (
									ValueOps.FormatText \
										v1:DiskPath \
										v2:ObjName \
										v3:Extension
							)
						),
						TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,
						SectionStructs = #(
							TypeLibrary.IDEIPL2dfx,
							undefined, /*TypeLibrary.IDEagrps,*/
							undefined, /*TypeLibrary.IDEamat,*/
							undefined, /*TypeLibrary.IDEanim,*/
							undefined, /*TypeLibrary.IDEcars,*/
							undefined, /*TypeLibrary.IDEhier,*/
							undefined, /*TypeLibrary.IDEIPLlink,*/
							undefined,
							undefined, /*TypeLibrary.IDEmlo,*/
							undefined, /*TypeLibrary.IDEobjs,*/
							undefined,
							undefined, /*TypeLibrary.IDEpeds,*/
							undefined, /*TypeLibrary.IDEtanm,*/
							undefined, /*TypeLibrary.IDEtobj,*/
							undefined,
							undefined, /*TypeLibrary.IDEtxdp,*/
							undefined, /*TypeLibrary.IDEIPLVNod,*/
							undefined /*TypeLibrary.IDEweap*/
						),
						SectionID = 0
				while (NotEOF BufferID) do (
					local	tLine = (ReadVal BufferID FilterStr:", \t" ValidateGTAString:true)
					if tLine != #InvalidLine then (
						local	Tag = (TypeCast tLine[1] name)
						if Tag == #end then
							SectionID = 0
						else (
							if SectionID == 0 then
								SectionID = (QuickSearch SectionNames Tag)
							else (
								local	SectionStruct = SectionStructs[SectionID]
								if Have SectionStruct then (
									local	SectionInst = (SectionStruct())
									SectionInst.Read BufferID tLine
									Append SectionData[SectionID] SectionInst
								)
							)
						)
					)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Core = GIMS.Core,
						BufferMgr = Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						BufferID = (BufferMgr.Create Mode:#Bin)
				for SectionID in SectionOrder do (
					local	SectionItems = SectionData[SectionID]
					if
						Have SectionItems and
						SectionItems.Count != 0
					then (
						WriteVal BufferID (SectionNames[SectionID] as String)
						for Item in SectionItems do
							Item.Write BufferID
						WriteVal BufferID "end"
					)
				)
				BufferMgr.WriteFile BufferID FilePath:(
						Core.ValueOps.FormatText \
							v1:DiskPath \
							v2:ObjName \
							v3:Extension
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLinst ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLinst",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLzone ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLzone",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLmzon ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLmzon",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLcull ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLcull",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLoccl ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLoccl",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLgrge ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLgrge",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLenex ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLenex",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLpick ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLpick",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLcars ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLcars",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLtcyc ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLtcyc",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLmloplus ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLmloplus",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLlodm ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLlodm",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPLslow ( /*<TODO>	DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLslow",
		DoThisObjBitch,
		fn Read BufferID tLine = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				000000 = tLine[000000] as 000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID 000000 BinType:#000000
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strIPL ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.IPLFile",
		DiskPath,
		ObjName,
		Extension = ".ipl",
		s_inst = #(),
		s_zone = #(),
		s_mzon = #(),
		s_cull = #(),
		s_occl = #(),
		s_grge = #(),
		s_enex = #(),
		s_pick = #(),
		s_cars = #(),
		s_tcyc = #(),
		s_vnod = #(),
		s_link = #(),
		s_mloplus = #(),
		s_2dfx = #(),
		s_lodm = #(),
		s_slow = #(),
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName + Extension)),
						tag, /*section tag*/
						tagsArray = #(
							#inst,
							#mult,
							#zone,
							#mzon,
							#cull,
							#occl,
							#grge,
							#enex,
							#pick,
							#cars,
							#jump,
							#tcyc,
							#auzo,
							#vnod,
							#link,
							#mloplus,
							#2dfx,
							#lodm,
							#slow
						),
						dwState = 0, /* parser state*/
						dwStatesArray = #(
							2,
							3,
							4,
							5,
							6,
							7,
							8,
							9,
							10,
							11,
							12,
							13,
							14,
							15,
							16,
							18,
							19,
							20,
							21
						),
						TempObj,
						NotEOF = BufferMgr.NotEOF
				while (NotEOF BufferID) do (
					local	tLine = (BufferMgr.ReadVal BufferID FilterStr:", \t" CaseOp:#Lower ValidateGTAString:true)
					if tLine != #InvalidLine then (
						if tLine[1] == "mlo+" then
							tag = #mloplus
						else
							tag = (GIMS.Core.ValueOps.TypeCast tLine[1] name)
						if
							dwState != 0 and
							tag == #end
						then /*reset parser state*/
							dwState = 0
						else (
							case dwState of (
								0: (
									dwState = (FindItem tagsArray tag)
									if dwState != 0 then
										dwState = dwStatesArray[dwState]
								)
								2: ( /* 'inst'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLinst()).Read tLine)) then
										Append s_inst TempObj
								)
								4: ( /* 'zone'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLzone()).Read tLine)) then
										Append s_zone TempObj
								)
								5: ( /* 'mzon'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLmzon()).Read tLine)) then
										Append s_mzon TempObj
								)
								6: ( /* 'cull'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLcull()).Read tLine)) then
										Append s_cull TempObj
								)
								7: ( /* 'occl'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLoccl()).Read tLine)) then
										Append s_occl TempObj
								)
								8: ( /* 'grge'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLgrge()).Read tLine)) then
										Append s_grge TempObj
								)
								9: ( /* 'enex'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLenex()).Read tLine)) then
										Append s_enex TempObj
								)
								10: ( /* 'pick'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLpick()).Read tLine)) then
										Append s_pick TempObj
								)
								11: ( /* 'cars'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLcars()).Read tLine)) then
										Append s_cars TempObj
								)
								13: ( /* 'tcyc'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLtcyc()).Read tLine)) then
										Append s_tcyc TempObj
								)
								15: ( /* 'vnod'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEIPLVNod()).Read tLine)) then
										Append s_vnod TempObj
								)
								16: ( /* 'link'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEIPLlink()).Read tLine)) then
										Append s_link TempObj
								)
								18: ( /* 'mlo+'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLmloplus()).Read tLine)) then
										Append s_mloplus TempObj
								)
								19: ( /* '2dfx'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IDEIPL2dfx()).Read tLine)) then
										Append s_2dfx TempObj
								)
								20: ( /* 'lodm'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLlodm()).Read tLine)) then
										Append s_lodm TempObj
								)
								21: ( /* 'slow'*/
									if Have (TempObj = ((GIMS.CurrentGame.Core.TypeLibrary.IPLslow()).Read tLine)) then
										Append s_slow TempObj
								)
							)
						)
					)
				)
				GIMS.Core.BufferMgr.ClearBuffer BufferID
				Free tagsArray
				Free dwStatesArray
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	BufferID = (GIMS.Core.BufferMgr.Create)
				GIMS.Core.BufferMgr.WriteVal BufferID "inst"
				for tItem in s_inst do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "zone"
				for tItem in s_zone do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "mzon"
				for tItem in s_mzon do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "cull"
				for tItem in s_cull do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "occl"
				for tItem in s_occl do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "grge"
				for tItem in s_grge do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "enex"
				for tItem in s_enex do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "pick"
				for tItem in s_pick do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "cars"
				for tItem in s_cars do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "tcyc"
				for tItem in s_tcyc do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "vnod"
				for tItem in s_vnod do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "link"
				for tItem in s_link do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "mloplus"
				for tItem in s_mloplus do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "2dfx"
				for tItem in s_2dfx do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "lodm"
				for tItem in s_lodm do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteVal BufferID "slow"
				for tItem in s_slow do
					tItem.Write BufferID
				GIMS.Core.BufferMgr.WriteVal BufferID "end"
				GIMS.Core.BufferMgr.WriteFile BufferID FilePath:(DiskPath + ObjName + Extension)
				GIMS.Core.BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryInst ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLInst",
		vPosition = [0, 0, 0],
		qRotation = (Quat 0 0 0 1),
		dwHash = 0,
		dwFlags = 384,
		LODID = -1,
		DictID = 0,
		DrawDist = -1,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vPosition = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				qRotation = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#Quat)
				dwHash = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				dwFlags = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				LODID = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				DictID = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				DrawDist = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vPosition
				GIMS.Core.BufferMgr.WriteVal BufferID qRotation
				GIMS.Core.BufferMgr.WriteVal BufferID dwHash
				GIMS.Core.BufferMgr.WriteVal BufferID dwFlags
				GIMS.Core.BufferMgr.WriteVal BufferID LODID
				GIMS.Core.BufferMgr.WriteVal BufferID DictID
				GIMS.Core.BufferMgr.WriteVal BufferID DrawDist BinType:#Float
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryZone ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLZone",
		UnknownData,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryGrge ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLGrge",
		vPoint1 = [0, 0, 0],
		vPoint2 = [0, 0],
		vPoint3 = [0, 0, 0],
		dwDoorType = 1,
		dwGarageType = 1,
		GarageName = "",
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vPoint1 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				vPoint2 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P2)
				vPoint3 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				dwDoorType = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				dwGarageType = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				GarageName = (GIMS.Core.BufferMgr.ReadVal BufferID Size:8 MAXType:#String)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint1
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint2
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint3
				GIMS.Core.BufferMgr.WriteVal BufferID dwDoorType
				GIMS.Core.BufferMgr.WriteVal BufferID dwGarageType
				GIMS.Core.BufferMgr.WriteVal BufferID GarageName Size:8
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryCar ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLCar",
		vPosition = [0, 0, 0],
		vRotation = [0, 0, 4.0757],
		dwCarNameHash = 0,
		Color1 = -1,
		Color2 = -1,
		Color3 = -1,
		SpecColor = -1,
		dwFlags	= 1633,
		AlarmPerc = 0,
		_f34 = 0,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vPosition = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				vRotation = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				dwCarNameHash = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				Color1 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				Color2 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				Color3 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				SpecColor = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				dwFlags = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				AlarmPerc = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				_f34 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vPosition
				GIMS.Core.BufferMgr.WriteVal BufferID vRotation
				GIMS.Core.BufferMgr.WriteVal BufferID dwCarNameHash
				GIMS.Core.BufferMgr.WriteVal BufferID Color1
				GIMS.Core.BufferMgr.WriteVal BufferID Color2
				GIMS.Core.BufferMgr.WriteVal BufferID Color3
				GIMS.Core.BufferMgr.WriteVal BufferID SpecColor
				GIMS.Core.BufferMgr.WriteVal BufferID dwFlags
				GIMS.Core.BufferMgr.WriteVal BufferID AlarmPerc
				GIMS.Core.BufferMgr.WriteVal BufferID _f34
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryTcyc ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLTCyc",
		vBoxMin = [0, 0, 0],
		vBoxMax = [0, 0, 0],
		_f18 = 0,
		_f1C = 0,
		_f20 = 0,
		_f24 = 0,
		dwKey = 0,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vBoxMin = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				vBoxMax = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				_f18 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float)
				_f1C = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float)
				_f20 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				_f24 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				dwKey = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMin
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMax
				GIMS.Core.BufferMgr.WriteVal BufferID _f18 BinType:#Float
				GIMS.Core.BufferMgr.WriteVal BufferID _f1C BinType:#Float
				GIMS.Core.BufferMgr.WriteVal BufferID _f20
				GIMS.Core.BufferMgr.WriteVal BufferID _f24
				GIMS.Core.BufferMgr.WriteVal BufferID dwKey
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryVNod ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLVNod",
		UnknownData,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryLink ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLPLink",
		UnknownData,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryBlok ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLBlok",
		ID = 1,
		szLine = "",
		_f60 = 6,
		vPoint1 = [0, 0],
		vPoint2 = [0, 0],
		vPoint3 = [0, 0],
		vPoint4 = [0, 0],
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				ID = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				szLine = (GIMS.Core.BufferMgr.ReadVal BufferID Size:92 MAXType:#String)
				_f60 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				vPoint1 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P2)
				vPoint2 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P2)
				vPoint3 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P2)
				vPoint4 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P2)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID ID
				GIMS.Core.BufferMgr.WriteVal BufferID szLine Size:92
				GIMS.Core.BufferMgr.WriteVal BufferID _f60
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint1
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint2
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint3
				GIMS.Core.BufferMgr.WriteVal BufferID vPoint4
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryMlop ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLMloP",
		Modelname = "",
		IntDWFlags = 384,
		InstID = 0,
		_f20 = 0,
		vPosition = [0, 0, 0],
		qRotation = (Quat 0 0 0 1),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				Modelname = (GIMS.Core.BufferMgr.ReadVal BufferID Size:24 MAXType:#String)
				IntDWFlags = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				InstID = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				_f20 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				vPosition = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				qRotation = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#Quat)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID Modelname Size:24
				GIMS.Core.BufferMgr.WriteVal BufferID IntDWFlags
				GIMS.Core.BufferMgr.WriteVal BufferID InstID
				GIMS.Core.BufferMgr.WriteVal BufferID _f20
				GIMS.Core.BufferMgr.WriteVal BufferID vPosition
				GIMS.Core.BufferMgr.WriteVal BufferID qRotation
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinaryLodm ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLLodM",
		vBoxMin = [0, 0, 0],
		vBoxMax = [0, 0, 0],
		_f18 = 0,
		dwHashes = #(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		SuperlodNames = #("", "", "", "", "", "", "", "", "", ""),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vBoxMin = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				vBoxMax = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				_f18 = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int)
				dwHashes = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Int Size:10 MAXType:#Array)
				SuperlodNames = (GIMS.Core.BufferMgr.ReadVal BufferID ArrayMAXType:#String MAXType:#Array Size:10 ArrayItemSize:32)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMin
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMax
				GIMS.Core.BufferMgr.WriteVal BufferID _f18
				GIMS.Core.BufferMgr.WriteVal BufferID dwHashes
				GIMS.Core.BufferMgr.WriteVal BufferID SuperlodNames Size:32
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct IplBinarySlow ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLSlow",
		vBoxMin = [0, 0, 0],
		vBoxMax = [0, 0, 0],
		fn Read BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				vBoxMin = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
				vBoxMax = (GIMS.Core.BufferMgr.ReadVal BufferID BinType:#Float MAXType:#P3)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMin
				GIMS.Core.BufferMgr.WriteVal BufferID vBoxMax
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strWPL ( /*<TODO>	UPDATE_READ UPDATE_WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WPLFile",
		TypeLibrary = GIMS.CurrentGame.Core.TypeLibrary,	/*<TODO>	shouldn't serialize!*/
		SectionClasses = #(	/*<TODO>	shouldn't serialize!*/
			TypeLibrary.WPLInst,
			TypeLibrary.WPLZone,
			TypeLibrary.WPLGrge,
			TypeLibrary.WPLCar,
			TypeLibrary.WPLTCyc,
			TypeLibrary.WPLVNod,
			TypeLibrary.WPLPLink,
			TypeLibrary.WPLBlok,
			TypeLibrary.WPLMloP,
			TypeLibrary.WPLLodM,
			TypeLibrary.WPLSlow
		),
		SectionIDs = #(	/*<TODO>	shouldn't serialize!*/
			1,	/*Inst	1*/
			2,	/*Zone	2*/
			3,	/*Grge	3*/
			4,	/*Cars	4*/
			5,	/*Tcyc	5*/
			6,	/*VNod	6*/
			7,	/*PLink	7*/
			16,	/*Blok	16*/
			9,	/*Mlop	9*/
			10,	/*Lodm	10*/
			11	/*Slow	11*/
		),
		AllSectionIDs = (SectionIDs as BitArray),	/*<TODO>	shouldn't serialize!*/
		PresentSectionCount = AllSectionIDs.Count,	/*<TODO>	shouldn't serialize!*/
		SectionCount = SectionClasses.Count,	/*<TODO>	shouldn't serialize!*/
		DiskPath,
		ObjName,
		Sections = #(
			#(),	/*Inst	1*/
			#(),	/*Zone	2*/
			#(),	/*Grge	3*/
			#(),	/*Cars	4*/
			#(),	/*Tcyc	5*/
			#(),	/*VNod	6*/
			#(),	/*PLink	7*/
			#(),	/*Blok	16*/
			#(),	/*Mlop	9*/
			#(),	/*Lodm	10*/
			#()		/*Slow	11*/
		),
		fn Read = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName) Mode:#Bin),
						FileVersion = (ReadVal BufferID BinType:#Int),
						SectionSizes = (ReadVal BufferID BinType:#Int Size:PresentSectionCount MAXType:#Array),
						SectionIndex = 0
				for i = 1 to PresentSectionCount where AllSectionIDs[i] do (
					SectionIndex += 1
					local	SectionID = SectionIDs[SectionIndex],
							Section = Sections[SectionID]
							SectionSize = SectionSizes[SectionID]
					Section.Count = SectionSize
					for ObjID = 1 to SectionSize do
						Section[ObjID] = ((SectionClasses[SectionID]()).Read BufferID)
				)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						BufferID = (BufferMgr.Create Mode:#Bin FilePath:(DiskPath + ObjName)),
						SectionSizes = #(),
						SectionIndex = 0
				for i = 1 to PresentSectionCount do (
					SectionSizes[i] = (
						if AllSectionIDs[i] then (
							SectionIndex += 1
							Sections[SectionIDs[SectionIndex]].Count
						) else
							0
					)
				)
				WriteVal BufferID 3
				WriteVal BufferID SectionSizes
				for Section in Sections do (
					for tItem in Section do
						tItem.Write BufferID
				)
				BufferMgr.WriteFile BufferID FilePath:(DiskPath + ObjName)
				BufferMgr.ClearBuffer BufferID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strWaterPlane (	/*<TODO> STRUCT DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WaterPlane"
	)
	struct strWaterFile (	/*<TODO> STRUCT DEFAULT READ WRITE CHECK*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.WaterFile"
	)
	struct strMapZone (	/*<TODO>*/
		StructName = "GIMS.CurrentGame.Core.TypeLibrary.MapZone"
	)
	/*this*/
	struct strTypeLibrary (
		/*oF common*/		Bounds = strBounds,
		/*oF models*/			grcMeshVertex = strMeshVertex,
		/*oF models*/			grcLODMeshPrim = strLODMeshPrim,
								grcLODMeshMtl = strLODMeshMtl,
								grcLODMesh = strLODMesh,
								grcLodGroup = strLodGroup,
								grcBone = strBone,
								grcSkeleton = strSkeleton,
								grcShadingGroup = strShadingGroup,
								grcLight = strLight,
								grcLightAttributes = strLightAttributes,
								grcDrawable = strDrawable,
								grcDrawableDictionary = strDrawableDictionary,
		/*oF fragments*/		grcFragmentChildPart = strFragmentChildPart,
								grcFragmentChild = strFragmentChild,
								grcFragmentGroup = strFragmentGroup,
								grcFragment = strFragment,
								grcFragType = strFragType,
		/*oF texdict*/		grcTexture = strTexture,
								grcTextureDictionary = strTextureDictionary,
		/*oF anim*/			grcAnimation_obj2 = strAnimation_obj2,
								grcAnimation_obj4 = strAnimation_obj4,
								grcAnimation = strAnimation,
								grcAnimationDictionary = strAnimationDictionary,
		/*oF col*/				grcCurvedEdge = strCurvedEdge,
								grcPhBound = strPhBound,
								grcPhBoundDictionary = strPhBoundDictionary,
		/*oF navmesh*/		grcNavTreeData = strNavTreeData,
								grcNavTree = strNavTree,
								grcNavPortal = strNavPortal,
								grcNavPoly = strNavPoly,
								grcNavEdge = strNavEdge,
								grcNavMesh = strNavMesh,
		/*PATHS*/			DistantLink = strDistantLink,
								DistantLights = strDistantLights,
								DATNode = strDATNode,
								DATFile = strDATFile,
								NODNode = strNODNode,
								NODLink = strNODLink,
								NODArea = strNODArea,
								NODPaths = strNODPaths,
		/*MAPPING*/		IDEobjs = strIDEobjs,
								IDEmlo = strIDEmlo,
								IDEmloInst = strIDEmloInst,
								IDEmloPortal = strIDEmloPortal,
								IDEmloRoom = strIDEmloRoom,
								IDEtobj = strIDEtobj,
								IDEweap = strIDEweap,
								IDEhier = strIDEhier,
								IDEanim = strIDEanim,
								IDEcars = strIDEcars,
								IDEpeds = strIDEpeds,
								IDEIPL2dfx = strIDEIPL2dfx,
								IDEtxdp = strIDEtxdp,
								IDEIPLVNod = strIDEIPLVNod,
								IDEIPLlink = strIDEIPLlink,
								IDEamat = strIDEamat,
								IDEtanm = strIDEtanm,
								IDEagrps = strIDEagrps,
								IDEFile = strIDE,
								IPLinst = strIPLinst,
								IPLzone = strIPLzone,
								IPLmzon = strIPLmzon,
								IPLcull = strIPLcull,
								IPLoccl = strIPLoccl,
								IPLgrge = strIPLgrge,
								IPLenex = strIPLenex,
								IPLpick = strIPLpick,
								IPLcars = strIPLcars,
								IPLtcyc = strIPLtcyc,
								IPLmloplus = strIPLmloplus,
								IPLlodm = strIPLlodm,
								IPLslow = strIPLslow,
								IPLFile = strIPL,
								WPLInst = IplBinaryInst,
								WPLZone = IplBinaryZone,
								WPLGrge = IplBinaryGrge,
								WPLCar = IplBinaryCar,
								WPLTCyc = IplBinaryTcyc,
								WPLVNod = IplBinaryVNod,
								WPLPLink = IplBinaryLink,
								WPLBlok = IplBinaryBlok,
								WPLMloP = IplBinaryMlop,
								WPLLodM = IplBinaryLodm,
								WPLSlow = IplBinarySlow,
								WPLFile = strWPL,
								MapZone = strMapZone,
								WaterPlane = strWaterPlane,
								WaterFile = strWaterFile
	)
	GIMS.CurrentGame.Core.TypeLibrary = strTypeLibrary()
/*<ERRHANDLER>*//*) --catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
