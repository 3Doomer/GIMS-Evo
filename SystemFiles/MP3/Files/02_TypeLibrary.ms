/*#PC*DEFINE	CurrentGame	MP3*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.Bounds*/ strBounds (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.Bounds",
		AABB = (GIMS.Core.TypeLibrary.AABB()),
		Center,
		Centroid,
		CentroidPresent = false,
		CenterOfMass,
		CGPresent = false,
		Radius,
		WorldRadius,
		PushFlags = false,
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal,
						ValueOps = GIMS.Core.ValueOps,
						AsoFText = ValueOps.AsoFText,
						FormatText = ValueOps.FormatText,
						HaveCentroid = (Have Centroid)
				if
					HaveCentroid and
					((Length Centroid) > 0.0001)
				then (
					HaveCentroid = false
					CentroidPresent = false
				)
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
				if Have Center then
					WriteVal BufferID (AsoFText Center TabString:(TabString + "Center "))
				if Have AABB then (
					WriteVal BufferID (AsoFText AABB.bMin TabString:(TabString + "AABBMin "))
					WriteVal BufferID (AsoFText AABB.bMax TabString:(TabString + "AABBMax "))
				)
				if Have Radius then
					WriteVal BufferID (AsoFText Radius TabString:(TabString + "Radius "))
				if Have WorldRadius then
					WriteVal BufferID (AsoFText WorldRadius TabString:(TabString + "WorldRadius "))
				if HaveCentroid then
					WriteVal BufferID (AsoFText Centroid TabString:(TabString + "Centroid "))
				if CGPresent then
					WriteVal BufferID (AsoFText CenterOfMass TabString:(TabString + "CenterOfMass "))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

/* oF drawable */
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcMeshVertex*/ strMeshVertex (
		Position,
		Normal,
		TheColor,
		Tangent,
		SkinBones = unsupplied,
		SkinWeights = unsupplied,
		UVCoords = unsupplied,
		CollectionIndex = #NoCollectionIndex,
		HashValue,
		fn GetHash = (
			/*<PROFILERSTART>*//*LogProfiler #Start "MP3.MeshVertex.GetHash"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No HashValue then (
					local	ResultStream = (StringStream ""),
							FmtStr = "%,",
							FloatFmtStr = "0.6f"
					Format FmtStr (FormattedPrint Position Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint Normal Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint Tangent Format:FloatFmtStr) To:ResultStream
					Format FmtStr (FormattedPrint TheColor Format:FloatFmtStr) To:ResultStream
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
		AlignedVertexFormat = false,
		Idx = #(),
		Positions = #(),
		Normals = unsupplied,
		Colors = unsupplied,
		Tangents = unsupplied,
		SkinBones = unsupplied,
		SkinWeights = unsupplied,
		UVCoords = unsupplied,
		fn GetVertexDeclaration Skinned ShadingGroup = (
			local	SPSName
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				SPSName = ShadingGroup.Mtls[ShaderIndex].SPSName
				local	SPS = (GIMS.CurrentGame.Core.DB.GetShaderByName SPSName),
						VertexDeclarations = SPS.VertexDeclarations,
						NotAlignedVD,
						VertexDeclaration
				for VD in VertexDeclarations where
					VD.Skinned == Skinned and
					VD.Aligned == AlignedVertexFormat
				while No VertexDeclaration do
					VertexDeclaration = VD.Elements
				VertexDeclaration
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Skinned, #AlignedVertexFormat, #ShaderIndex, #SPSName), #(Skinned, AlignedVertexFormat, ShaderIndex, SPSName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID Skinned ShadingGroup = (
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
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				Skip BufferID 1 /* skip start */
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#ShaderIndex:
							ShaderIndex = ((TypeCast tLine[2] Integer) + 1)
						#AlignedVertexFormat:
							AlignedVertexFormat = (TypeCast tLine[2] BooleanClass)
						#Indices: (
							/*<PROFILERSTART>*//*LogProfiler #Start "Read indices"; local PWS = (*//*<PROFILERSTARTED>*/
							
							local	IdxCount = (TypeCast tLine[2] Integer),
									StartIdxIndex = 1
							Idx.Count = (IdxCount / 3)
							Skip BufferID 1 /* skip start */
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
								local	TempIdx = (oFTypeExec tLine #IntArray),
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
							local	VertexDeclaration = (GetVertexDeclaration Skinned ShadingGroup)
							if No VertexDeclaration then
								return false;
							local	VertexDeclarationCount = VertexDeclaration.Count,
									VDGIMSParamTypes = #(),
									VertCount = (TypeCast tLine[2] Integer),
									HaveUV = false,
									HaveColors = false,
									HaveNormals = false,
									HaveTangents = false,
									HaveBones = false,
									HaveWeights = false,
									UVCount = 0
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
											if Type == #P4 then
												2
											else
												1
										)
									)
									#D3DDECLUSAGE_COLOR:
										HaveColors = true
									#D3DDECLUSAGE_NORMAL:
										HaveNormals = true
									#D3DDECLUSAGE_TANGENT: (
										--HaveTangents = true
									)
									#D3DDECLUSAGE_BLENDINDICES:
										HaveBones = true
									#D3DDECLUSAGE_BLENDWEIGHT:
										HaveWeights = true
									Default:
										throw "Unknown vertex declaration element: " VD.Usage
								)
							)
							Positions.Count = VertCount
							Skip BufferID 1 /* skip start */
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
										if VDGIMSParamTypes[ParamID] == #P4 then (
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
								)
								if HaveWeights then (
									SkinWeights = #()
									SkinWeights.Count = VertCount
								)
							)
							
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
							/*<PROFILERSTART>*//*LogProfiler #Start "Read vertices"; local PWS = (*//*<PROFILERSTARTED>*/
							
							for VertID = 1 to VertCount do (
								local	VertLine = (ReadVal BufferID FilterStr:"/"),
										UVID = 1
								for ParamID = 1 to VertexDeclarationCount do (
									local	VD = VertexDeclaration[ParamID],
											Type = VDGIMSParamTypes[ParamID]
									case VD.Usage of (
										#D3DDECLUSAGE_POSITION:
											Positions[VertID] = (oFTypeExec VertLine[ParamID] Type)
										#D3DDECLUSAGE_TEXCOORD: (
											local	UVCoord = (oFTypeExec VertLine[ParamID] Type)
											if Type == #P4 then (
												UVCoord[2] *= -1
												UVCoord[4] *= -1
												UVCoords[UVID][VertID] = (TypeCast UVCoord #P2)
												UVCoords[UVID + 1][VertID] = [UVCoord.z, UVCoord.w]
												UVID += 2
											) else (
												UVCoord[2] *= -1
												UVCoords[UVID][VertID] = UVCoord
												UVID += 1
											)
										)
										#D3DDECLUSAGE_COLOR:
											Colors[VertID] = ((oFTypeExec VertLine[ParamID] Type) / 255)
										#D3DDECLUSAGE_NORMAL:
											Normals[VertID] = (oFTypeExec VertLine[ParamID] Type)
										#D3DDECLUSAGE_TANGENT: (
											--Tangents[VertID] = (oFTypeExec VertLine[ParamID] Type)
										)
										#D3DDECLUSAGE_BLENDINDICES:
											SkinBones[VertID] = (Modify (TypeCast (oFTypeExec VertLine[ParamID] Type) #Array) 1 #Add CopyArray:false)
										#D3DDECLUSAGE_BLENDWEIGHT:
											SkinWeights[VertID] = (TypeCast (oFTypeExec VertLine[ParamID] Type) #Array)
										Default:
											throw "Unknown vertex declaration element: " VD.Usage
									)
								)
							)
							Skip BufferID 1 /* skip end */
							
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
						default:
							throw ("Unknown strLODMeshPrim tag " + tLine[1])
					)
				)
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#Idx,
					#Positions,
					#Normals,
					#Colors,
					#Tangents,
					#SkinBones,
					#SkinWeights,
					#UVCoords
				), #(
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Tangents 		,
					SkinBones 		,
					SkinWeights 	,
					UVCoords 		
				)	
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString Skinned ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	VertexDeclaration = (GetVertexDeclaration Skinned ShadingGroup)
				if No VertexDeclaration then
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
						\
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						UVCount = UVCoords.Count,
						P2Dummy = "0 0",
						P3Dummy = "0 0 0",
						P4Dummy = "0 0 0 0"
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"ShaderIndex " \
						v3:(ShaderIndex - 1)
				)
				WriteVal BufferID (
					FormatText \
						v1:TabString \
						v2:"AlignedVertexFormat " \
						v3:AlignedVertexFormat
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
				local	ParamSeparator = " / "
				/*<PROFILERSTART>*//*LogProfiler #Start "Write+Vertices"; local PWS = (*//*<PROFILERSTARTED>*/
				
				--local	UsedBoneIndices = #{}	--<TODO>	remove, debug
				for VertID = 1 to VertCount do (
					WriteVal BufferID SubTabString
					local	IsFirstParam = true,
							UVID = 1
					for ParamID = 1 to VertexDeclaration.Count do (
						if IsFirstParam then
							IsFirstParam = false
						else
							WriteVal BufferID ParamSeparator AppendLast:true
						local	VD = VertexDeclaration[ParamID],
								Type = (SPSToGIMSParamType VD.aType)
						case VD.Usage of (
							#D3DDECLUSAGE_POSITION:
								WriteVal BufferID (AsoFText (TypeCast Positions[VertID] Type)) AppendLast:true
							#D3DDECLUSAGE_TEXCOORD: (
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
												throw "Unknown UV value type: " Type
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
										UVCoord = (TypeCast [UVCoord.x, -UVCoord.y] Type)
									WriteVal BufferID (AsoFText UVCoord) AppendLast:true
								)
							)
							#D3DDECLUSAGE_COLOR:
								WriteVal BufferID (AsoFText (TypeCast (Colors[VertID] * 255) Type) TypeHook:Integer) AppendLast:true
							#D3DDECLUSAGE_NORMAL:
								WriteVal BufferID (AsoFText (TypeCast Normals[VertID] Type)) AppendLast:true
							#D3DDECLUSAGE_TANGENT:
								WriteVal BufferID (AsoFText (TypeCast Tangents[VertID] Type)) AppendLast:true
							#D3DDECLUSAGE_BLENDINDICES: (
								/*<TODO>	remove, debug*
								for BoneIndex in SkinBones[VertID] do
									UsedBoneIndices[BoneIndex] = true
								/**/
								WriteVal BufferID (AsoFText (TypeCast (Modify SkinBones[VertID] -1 #Add CopyArray:true) Type) TypeHook:Integer) AppendLast:true
							)
							#D3DDECLUSAGE_BLENDWEIGHT:
								WriteVal BufferID (AsoFText (TypeCast SkinWeights[VertID] Type)) AppendLast:true
							Default:
								throw "Unknown vertex declaration element: " VD.Usage
						)
					)
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
					#Tangents,
					#SkinBones,
					#SkinWeights,
					#UVCoords
				), #(
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Tangents 		,
					SkinBones 		,
					SkinWeights 	,
					UVCoords 		
				)	
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Skinned BoneCount UsedBones MMtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UVCount = UVCoords.Count,
						VertCount = Positions.Count,
						TheMesh, SkinData
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				if AlignedVertexFormat then
					MMtl[ShaderIndex].AlignedVertexFormat = AlignedVertexFormat
				/*<PROFILERSTART>*//*LogProfiler #Start "Create mesh"; local PWS = (*//*<PROFILERSTARTED>*/
				
				TheMesh = (
					GIMS.Core.ObjectMgr.CreateMesh \
						Positions \
						Idx \
						MaterialIDs:ShaderIndex \
						VertColors:Colors \
						MapVerts:UVCoords \
						UVCount:UVCount
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
								if
									(BoneWeight > 0.0001) and
									BoneID <= BoneCount
								do (
									NewVertBoneCount += 1
									NewVertBoneIDs[NewVertBoneCount] = BoneID
									NewVertBoneWeights[NewVertBoneCount] = BoneWeight
									UsedBones[BoneID] = true
								)
							)
							NewVertBoneIDs.Count = NewVertBoneCount
							NewVertBoneWeights.Count = NewVertBoneCount
							NormalizeA NewVertBoneWeights
							BoneIDs[VertID] = NewVertBoneIDs
							BoneWeights[VertID] = NewVertBoneWeights
						)
						#(BoneIDs, BoneWeights)
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
					#Tangents,
					#SkinBones,
					#SkinWeights,
					#UVCoords
				), #(
					Idx,
					Positions,
					Normals	 		,
					Colors 			,
					Tangents 		,
					SkinBones 		,
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
		Version = [140, 21],
		BoneID = 1,
		Locked = false,
		Skinned = false,
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
						AddResult = GIMS.Core.SystemMgr.AddResult,
						grcLODMeshGeometry = GIMS.CurrentGame.Core.TypeLibrary.grcLODMeshGeometry,
						FullFilePath = (
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.ReadFile FullFilePath Mode:#StreamTxt),
						NotEOF = BufferMgr.NotEOF
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] Name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
								AddResult #Error  (
									FormatText \
										v1:"Wrong version resource \"" \
										v2:FullFilePath \
										v3:"\""
								)
								return false;
							)
							Skip BufferID 1 /* skip start */
						)
						#Locked:
							Locked = (TypeCast tLine[2] BooleanClass)
						#Skinned:
							Skinned = (TypeCast tLine[2] BooleanClass) 
						#Bounds: (
							Skip BufferID 1 /* skip start */
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	/* skips end */
								local	Tag = (TypeCast tLine[1] name)
								case Tag of (
									#AABB: (
										Skip BufferID 1 /* skip start */
										while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	/* skips end */
											local	Tag = (TypeCast tLine[1] name)
											case Tag of (
												#Min: ()	--skip
												#Max: ()	--skip
												default:
													throw ("Unknown strLODMesh.Bounds.AABB tag " + tLine[1])
											)
										)
									)
									default:
										throw ("Unknown strLODMesh.Bounds tag " + tLine[1])
								)
							)
						)
						#Geometries: (
							Skip BufferID 1 /* skip start */
							Geometries.Count = 10
							local	AddedGeometries = 0
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do (	/* skips end */
								local	Tag = (TypeCast tLine[1] name)
								case Tag of (
									#Geometry: (
										local	NewItem = (grcLODMeshGeometry())
										if (NewItem.Read BufferID Skinned ShadingGroup) then (
											AddedGeometries += 1
											Geometries[AddedGeometries] = NewItem
										) else (
											AddResult #Error  (
												FormatText \
													v1:"Can't find a proper vertex declaration for a mesh \"" \
													v2:FullFilePath \
													v3:"\" geometry " \
													v4:(
														local	ShaderIndex = NewItem.ShaderIndex
														if Have ShaderIndex then
															(ShaderIndex as String)
														else
															""
													) \
													v5:". This mesh can't be read and will be skipped." \
											)
										)
									)
									default:
										throw ("Unknown strLODMesh.Geometries tag " + tLine[1])
								)
							)
							Geometries.Count = AddedGeometries
						)
						default:
							throw ("Unknown strLODMesh tag " + tLine[1])
					)
				)
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						WriteVal = BufferMgr.WriteVal,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
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
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID BraceOpen
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"Locked " \
							v3:Locked
					)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"Skinned " \
							v3:Skinned
					)
					WriteVal BufferID (TabString + "Bounds")
					WriteVal BufferID TabBraceOpen
					for tAABB in Bounds do (
						WriteVal BufferID AABBHeader
						WriteVal BufferID SubTabBraceOpen
						WriteVal BufferID (AsoFText tAABB.bMin TabString:(SubTabString + "\tMin "))
						WriteVal BufferID (AsoFText tAABB.bMax TabString:(SubTabString + "\tMax "))
						WriteVal BufferID SubTabBraceClose
					)
					WriteVal BufferID TabBraceClose
					WriteVal BufferID (TabString + "Geometries")
					WriteVal BufferID TabBraceOpen
					/*<TODO>	remove, debug*
					local	UsedBoneIndices = #{}
					for Geom in Geometries do (
						for VertSkinBones in Geom.SkinBones do (
							for BoneIndex in VertSkinBones do
								UsedBoneIndices[BoneIndex] = true
						)
					)
					Format "Mesh % with % unique bones\n" ObjName UsedBoneIndices.NumberSet
					/**/
					for Geom in Geometries do (
						WriteVal BufferID GeomHeader
						WriteVal BufferID SubTabBraceOpen
						if not (Geom.Write BufferID DoubleSubTabString Skinned ShadingGroup) then (
							EGIMS_EHAbort ( \
								FormatText \
									v1:"Can't find a proper vertex declaration for a mesh \"" \
									v2:ObjDir \
									v3:"\" geometry " \
									v4:(
										local	ShaderIndex = NewItem.ShaderIndex
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
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create BoneNodes MMtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = false,
						GeometryCount = Geometries.Count
				if GeometryCount != 0 then (
					local	BoneCount = BoneNodes.Count,
							Meshes = #(),
							SkinBones = #(),
							SkinWeights = #(),
							Idx = unsupplied,
							Normals = unsupplied,
							NeedNormals = false,
							UsedBones = #{},
							IsFirstGeometry = true,
							Modify,
							InvalidNormalDummy,
							IdxOffset
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
						local	MeshData = (Geometries[GeometryID].Create Skinned BoneCount UsedBones MMtl),
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
						for BoneID = 1 to BoneCount do (
							AddBone SkinMod BoneNodes[BoneID] 0
							SetInnerRadius SkinMod BoneID 1 0
							SetOuterRadius SkinMod BoneID 1 0
							SetInnerRadius SkinMod BoneID 2 0
							SetOuterRadius SkinMod BoneID 2 0
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						local	UnNormalizeVertex = SkinOps.UnNormalizeVertex,
								GetVertexWeightCount = SkinOps.GetVertexWeightCount,
								GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
								ReplaceVertexWeights = SkinOps.ReplaceVertexWeights
						/*<PROFILERSTART>*//*LogProfiler #Start "Apply weights"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						for VertID = 1 to Result.NumVerts do (
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
							ReplaceVertexWeights SkinMod VertID VertBones VertWeights
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<PROFILERSTART>*//*LogProfiler #Start "Delete unused bones"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						local	SelectBone = SkinOps.SelectBone,
								RemoveBone = SkinOps.RemoveBone
						for BoneID = BoneCount to 1 by -1 where not UsedBones[BoneID] do (
							SelectBone SkinMod BoneID
							RemoveBone SkinMod
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					) else (
						Result.Transform = (
							if ParentNode == RootNode then
								(Matrix3 1)
							else
								ParentNode.Transform
						)
					)
					if NeedInteractiveUI then (
						Update Result
						MAX Create Mode
						Select OldSelection
						EGIMS_SuspendMAX()
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension), #(DiskPath, ObjName, Extension)))/*<ERRHANDLEREND>*/
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
			9999.0,
			9999.0,
			9999.0,
			9999.0
		),
		LODGrpTags = (for GrpName in LODGroupNames collect (GrpName as Name)),
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
					local	Tag = (TypeCast tLine[1] name),
							TagID = (FindItem LODGrpTags Tag)
					if TagID != 0 then (
						LODGroupValues[TagID] = (TypeCast tLine[2] Float)
						if (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] == "{" then (
							Skip BufferID 1	/* skip mesh list start */
							local	LODGroup = LODGroups[TagID],
									LODGroupSize = LODGroup.Count
							LODGroup.Count = (LODGroupSize + 10)
							while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips mesh list end */
								local	MeshFilePath = tLine[1],
										LODMesh = (
											grcLODMesh \
												BoneID:((TypeCast tLine[2] Integer) + 1) \
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
								throw ("Unknown strLODGroup tag " + tLine[1])
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
		fn Create BoneNodes ShadingGroup = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MMtl = (
							if Have ShadingGroup then (
								local	Mtls = ShadingGroup.Mtls,
										MtlNames = #(),
										MtlIDs = #()
								for i = Mtls.Count to 1 by -1 do (
									MtlNames[i] = Mtls[i].Name
									MtlIDs[i] = i
								)
								(MultiMaterial Name:ShadingGroup.ObjName Material:Mtls Names:MtlNames MaterialIDList:MtlIDs)
							)
						)
				for LODGrpID = 1 to LODGroups.Count do (
					for tMesh in LODGroups[LODGrpID] do (
						local	TempMesh = (tMesh.Create BoneNodes MMtl)
						if TempMesh != false then (
							TempMesh.Material = MMtl
							AddModifier TempMesh (EGIMS_MP3_ModelMesh Type:LODGrpID)
						)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcBone*/ strBone (
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
			#LOCK_ROT_XYZ,
			#LOCK_ROT_X,
			#LOCK_ROT_Y,
			#LOCK_ROT_Z,
			#LIMIT_ROT_X,
			#LIMIT_ROT_Y,
			#LIMIT_ROT_Z,
			#LOCK_TRANS_X,
			#LOCK_TRANS_Y,
			#LOCK_TRANS_Z,
			#LIMIT_TRANS_X,
			#LIMIT_TRANS_Y,
			#LIMIT_TRANS_Z,
			#LOCK_SCALE_X,
			#LOCK_SCALE_Y,
			#LOCK_SCALE_Z,
			#LIMIT_SCALE_X,
			#LIMIT_SCALE_Y,
			#LIMIT_SCALE_Z,
			#INVISIBLE
		),
		FlagStrings = #(
			"LOCK_ROT_XYZ",
			"LOCK_ROT_X",
			"LOCK_ROT_Y",
			"LOCK_ROT_Z",
			"LIMIT_ROT_X",
			"LIMIT_ROT_Y",
			"LIMIT_ROT_Z",
			"LOCK_TRANS_X",
			"LOCK_TRANS_Y",
			"LOCK_TRANS_Z",
			"LIMIT_TRANS_X",
			"LIMIT_TRANS_Y",
			"LIMIT_TRANS_Z",
			"LOCK_SCALE_X",
			"LOCK_SCALE_Y",
			"LOCK_SCALE_Z",
			"LIMIT_SCALE_X",
			"LIMIT_SCALE_Y",
			"LIMIT_SCALE_Z",
			"INVISIBLE"
		),
		Id = 0,
		MirrorBoneId = 0,
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
		
		Index = 1,	--collection process parameter
		
		fn GetChildrenCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local ChildrenCount = Children.Count
				for TempBone in Children do
					ChildrenCount += (TempBone.GetChildrenCount())
				ChildrenCount
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read ThisObj BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	tLine,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						TypeCast = GIMS.Core.ValueOps.TypeCast
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Bone: (
							ObjName = (tLine[2] as String)
							Id = (TypeCast tLine[3] Integer)
							Skip BufferID 1 /* skip start */
						)
						#Flags: (
							local	TempFlags = (oFTypeExec tLine #NameArray IDMask:#{2..tLine.Count}),
									FlagID
							for Flag in TempFlags do (
								FlagID = (FindItem AvailFlags Flag)
								if FlagID != 0 then
									Flags[FlagID] = true
								else (
									GIMS.Core.SystemMgr.AddResult #Error  (
										GIMS.Core.ValueOps.FormatText \
											v1:"Unknown flag \"" \
											v2:Flag \
											v3:"\" in object \"" \
											v4:ObjName \
											v5:"\" found"
									)
									return false;
								)
							)
						)
						#MirrorBoneId:
							MirrorBoneId = (TypeCast tLine[2] Integer)
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
								local	NewItem = grcBone()
								if not (NewItem.Read NewItem BufferID) then
									return false;
								Children[ChildID] = NewItem
							)
							Skip BufferID 1 /* skip end */
						)
						default:
							throw ("Unknown strBone tag " + tLine[1])
					)
				)
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID TabString = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
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
						v5:Id
				)
				WriteVal BufferID (TabString + "{")
				local	SubTabString = (TabString + "\t")
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"MirrorBoneId " \
						v3:MirrorBoneId
				)
				local	FlagsToWrite = #(),
						ObjFlagCount = Flags.Count,
						FlagCount = 0
				FlagsToWrite.Count = ObjFlagCount
				for ID = 1 to ObjFlagCount where Flags[ID] do (
					FlagCount += 1
					FlagsToWrite[FlagCount] = FlagStrings[ID]
				)
				FlagsToWrite.Count = FlagCount
				/*TODO remove, debug*
				Print #ObjName
				Print ObjName
				Print #Flags
				Print Flags
				Print #FlagsToWrite
				Print FlagsToWrite
				/**/
				WriteVal BufferID (AsoFText FlagsToWrite TabString:(SubTabString + "Flags "))
				WriteVal BufferID (AsoFText LocalOffset TabString:(SubTabString + "LocalOffset "))
				WriteVal BufferID (AsoFText RotationEuler TabString:(SubTabString + "RotationEuler ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText RotationQuaternion TabString:(SubTabString + "RotationQuaternion "))
				WriteVal BufferID (AsoFText TheScale TabString:(SubTabString + "Scale "))
				WriteVal BufferID (AsoFText WorldOffset TabString:(SubTabString + "WorldOffset "))
				WriteVal BufferID (AsoFText Orient TabString:(SubTabString + "Orient ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText Sorient TabString:(SubTabString + "Sorient ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText TransMin TabString:(SubTabString + "TransMin "))
				WriteVal BufferID (AsoFText TransMax TabString:(SubTabString + "TransMax "))
				WriteVal BufferID (AsoFText RotMin TabString:(SubTabString + "RotMin ") SubTypeHook:#DegToRad)
				WriteVal BufferID (AsoFText RotMax TabString:(SubTabString + "RotMax ") SubTypeHook:#DegToRad)
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
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_MP3_Model_Bone)
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				Result.WireColor = Yellow
				Result.ShowLinks = true
				Result.ShowLinksOnly = true
				Result.Scale = (ParentNode.Scale + TheScale)
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
		Version = [140, 21],
		AuthoredOrientation = false,
		NumBones = 0,
		TheBones = #(),
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
						grcBone = GIMS.CurrentGame.Core.TypeLibrary.grcBone,
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#StreamTxt
						),
						NotEOF = BufferMgr.NotEOF
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
						#NumBones: (/* skip */)
						#AuthoredOrientation:
							AuthoredOrientation = (TypeCast tLine[2] BooleanClass)
						#Bone: (
							Skip BufferID -1 /* return to start */
							local	NewItem = (grcBone())
							if not (NewItem.Read NewItem BufferID) then
								return false;
							Append TheBones NewItem
						)
						default:
							throw ("Unknown strSkeleton tag " + tLine[1])
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
						FormatText = ValueOps.FormatText,
						AsoFText = ValueOps.AsoFText,
						FilePath = (
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
						NumBones = TheBones.Count,
						TabString = "\t"
				if BufferID != false then (
					WriteVal BufferID (AsoFText Version TypeHook:Integer TabString:"Version ")
					WriteVal BufferID "{"
					for TempBone in TheBones do
						NumBones += (TempBone.GetChildrenCount())
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"NumBones " \
							v3:NumBones \
					)
					WriteVal BufferID (
						FormatText \
							v1:TabString \
							v2:"AuthoredOrientation " \
							v3:(Ternary AuthoredOrientation "True" "False") \
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
		fn Create ParentNode AncestorBoneNodes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local LastBoneIndex = 0
				for Item in TheBones do
					LastBoneIndex = (Item.Create Item ParentNode AncestorBoneNodes LastBoneIndex)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcLight*/ strLight (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcLight",
		Position = [0, 0, 0],
		Direction = [0, 0, -1],
		Origin = [0, 1, 0],
		TheColor = White,	/*<TODO> research game color format*/
		f28 = 1,
		f2C = 1,
		f30 = 1,
		TheDistance = 0,
		Range = 0,
		CoronaSize = 0,
		HotSpot = 0,
		TheFalloff = 0,
		Flags = #{},
		CoronaHash = -1103804803,
		LuminescenceHash = 0,
		TypeFlags = #{},
		Type = 1,
		CoronaPower = 1.0,
		f5C = 1.0,	/*<TODO> research - maybe it's DrawDistDiv4*/
		f60 = -1.0,	/*<TODO> research*/
		f64 = -1.0,	/*<TODO> research*/
		BoneID = 0,
		f6A_unknown = 0,	/*<TODO> research*/
		f6C = -1,	/*<TODO> research*/
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
				GIMS.Core.GUIMgr.UpdateProgress #None 0
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Position:
							Position = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#Direction:
							Direction = (-(oFTypeExec tLine #P3 IDMask:#{2..4}))
						#Origin:
							Origin = (oFTypeExec tLine #P3 IDMask:#{2..4})
						#Color: (
							local	Val = (TypeCast (Append tLine[2] "L") Integer),
									CopyBits = ValueOps.CopyBits
							TheColor = (
								Color \
								(CopyBits Val 0 #{25..32} #{1..8}) \
								(CopyBits Val 0 #{17..24} #{1..8}) \
								(CopyBits Val 0 #{9..16} #{1..8}) \
								(Bit.And Val 0xFF)
							)
						)
						#f28:
							f28 = (TypeCast tLine[2] Float)
						#f2C:
							f2C = (TypeCast tLine[2] Float)
						#f30:
							f30 = (TypeCast tLine[2] Float)
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
							Flags = (AsBitArray (TypeCast (Append tLine[2] "L") Integer))
						#CoronaHash:
							CoronaHash = (TypeCast (Append tLine[2] "L") Integer)
						#LuminescenceHash:
							LuminescenceHash = (TypeCast (Append tLine[2] "L") Integer)
						#TypeFlags:
							TypeFlags = (AsBitArray (TypeCast (Append tLine[2] "L") Integer) Range:#{1..8})
						#f58_padding: () /*SKIP*/
						#Type:
							Type = (TypeCast tLine[2] Integer)
						#f5C:
							f5C = (TypeCast tLine[2] Float)
						#f60:
							f60 = (TypeCast tLine[2] Float)
						#f64:
							f64 = (TypeCast tLine[2] Float)
						#BoneID:
							BoneID = (TypeCast tLine[2] Integer)
						#f6A_unknown:
							f6A_unknown = (TypeCast tLine[2] Integer)
						#f6C:
							f6C = (TypeCast tLine[2] Float)
						default:
							throw ("Unknown strLight tag " + tLine[1])
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
				WriteVal BufferID (AsoFText (-Direction) TabString:(SubTabString + "Direction "))
				WriteVal BufferID (AsoFText Origin TabString:(SubTabString + "Origin "))
				local	TheColorValue = (CopyBits TheColor.R 0L #{1..8} #{25..32})
				TheColorValue = (CopyBits TheColor.G TheColorValue #{1..8} #{17..24})
				TheColorValue = (CopyBits TheColor.B TheColorValue #{1..8} #{9..16})
				TheColorValue += (Bit.And TheColor.A 0xFF)
				WriteVal BufferID (AsoFText (FormattedPrint TheColorValue format:dwFmt) TabString: (SubTabString + "Color "))
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f28 " \
						v3:f28
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f2C " \
						v3:f2C
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f30 " \
						v3:f30
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"Distance " \
						v3:TheDistance
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"Range " \
						v3:Range
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"CoronaSize " \
						v3:CoronaSize
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"HotSpot " \
						v3:HotSpot
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"Falloff " \
						v3:TheFalloff
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"Flags " \
						v3:(FormattedPrint (BitArrayAsValue Flags Range:#{1..32}) Format:dwFmt)
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"CoronaHash " \
						v3:(FormattedPrint CoronaHash Format:dwFmt)
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"LuminescenceHash " \
						v3:(FormattedPrint LuminescenceHash Format:dwFmt)
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"TypeFlags " \
						v3:(BitArrayAsValue TypeFlags Range:#{1..8})
				)
				WriteVal BufferID (SubTabString + "f58_padding 0")
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"Type " \
						v3:Type
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f5C " \
						v3:f5C
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f60 " \
						v3:f60
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f64 " \
						v3:f64
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"BoneID " \
						v3:BoneID
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f6A_unknown " \
						v3:f6A_unknown
				)
				WriteVal BufferID (
					FormatText \
						v1:SubTabString \
						v2:"f6C " \
						v3:f6C
				)
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
					not (IsKindOf tBone EGIMS_MP3_Model) and
					tBone.ID == BoneID
				do
					ParentNode = tBone
				if No ParentNode then (
					if BoneID != 0 then (
						GIMS.Core.SystemMgr.AddResult #Error  (
							ValueOps.FormatText \
								v1:"Light link error in object \"" \
								v2:ObjName \
								v3:"\" - no bone with ID " \
								v4:BoneID
						)
					) else
						ParentNode = BoneNodes[1]
				)
				local	ParentTM = (
							if ParentNode == RootNode then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						TextureNames = GIMS.CurrentGame.Core.DB.TextureNames,
						FetchMHL = GIMS.Core.ArrayOps.FetchMHL,
						CoronaName = (FetchMHL TextureNames CoronaHash),
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique (if Have CoronaName then CoronaName else ("0x" + (FormattedPrint CoronaHash Format:"02X"))) ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_MP3_Model_Light)
				GIMS.Core.ValueOps.ConvertStruct Result undefined ParamSource:ThisObj DontCreate:true
				Result.Pos = (Position * ParentTM)
				Result.Dir = Direction
				Result.pLuminescenceHash = (FetchMHL TextureNames LuminescenceHash)
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
		Version = [140, 20],
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
							) Mode:#StreamTxt
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
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
							throw ("Unknown strLightAttributes tag " + tLine[1])
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
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
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
		Version = [11, 20],
		TexturePath = "",
		Type = 1,
		PixelFormat = 1,
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
						BufferID = (
							BufferMgr.ReadFile (
								ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#StreamTxt
						),
						NotEOF = BufferMgr.NotEOF
				if BufferID == false then
					return false;
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
						#FileName:
							TexturePath = (DiskPath + (tLine[2] as String))
						#Type: (
							Type = (FindItem TypeNames (TypeCast tLine[2] name))
							if Type == 0 then (
								GIMS.Core.SystemMgr.AddResult #Error  (
									FormatText \
										v1:"Unknown type \"" \
										v2:tLine[2] \
										v3:"\" in object \"" \
										v4:ObjName \
										v5:"\" found"
								)
								return false;
							)
						)
						#PixelFormat: (
							PixelFormat = (FindItem PixelFormatNames (TypeCast tLine[2] name))
							if PixelFormat == 0 then
								PixelFormat = 4
								--EGIMS_EHAbort ("Unknown PixelFormat \"" + tLine[2] as String + "\" in object \"" + ObjName + "\" found!")
						)
						#Levels: (/*skip*/)
						Default:
							throw ("Unknown strTexture tag " + tLine[1])
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
							FormatText \
								v1:DiskPath \
								v2:ObjName \
								v3:Extension
						),
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
						TexFileExt = (FileNameFromPath TexturePath),
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
					WriteVal BufferID ("\tFileName " + TexFileExt)
					WriteVal BufferID ("\tType " + TypeStrings[Type])
					WriteVal BufferID ("\tPixelFormat " + PixelFormatStrings[PixelFormat])
					WriteVal BufferID ("\tLevels " + ((ValueOps.TypeCast MipLevelCount Integer) as String))
					WriteVal BufferID "}"
					BufferMgr.WriteFile BufferID FilePath:FilePath
					BufferMgr.ClearBuffer BufferID
				) else
					EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary*/ strTextureDictionary (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcTextureDictionary",
		DiskPath,
		ObjName,
		Extension = ".otd",
		Version = [11, 20],
		Items = #(),
		fn Read TexPath ReportProgress:true = (
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
							) Mode:#StreamTxt
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
					local	Tag = (TypeCast tLine[1] name)
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
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
		fn Read BufferID TexPath = (
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
						tLine,
						MtlBufferSize = 50
				Mtls.Count = MtlBufferSize
				while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do ( /* skips end */
					local	SPSName = (GetFileNameFile tLine[1]),
							SPS = (GetShaderByName SPSName),
							Mtl = (EGIMS_MP3_material SPSName:SPSName ShowInViewport:true),
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
								throw ("Can't find a " + SPSName + " shader parameter: ") SPSParamName
							if (ReadVal BufferID FilterStr:"\t " NoSeek:true)[1] == "{" then (
								Skip BufferID 1 /* skip param start */
								while (tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}" do /* skips multiline param end */
									SPSParamDef += tLine
							)
							local	SPSParam = SPSShaderParameters[SPSParamID],
									SPSParamType = SPSParam.aType
							if SPSParamType == #sp_sampler then (
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
									)
									AppendMHL TextureNames TexFileName
									local	DefaultTexColor,
											SPSParamNameAsName = (TypeCast SPSParamName Name)
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
										MtlSetParam SPSParamName SPSParamType (LoadBitmapFile TexFilePath TexFileName BackColor:DefaultTexColor) IsTexInternal:IsIncluded
									else
										MtlSetParam SPSParamName SPSParamType (LoadBitmapFile (Ternary IsIncluded DiskPath TexPath) (Append TexFilePath TexFileName) BackColor:DefaultTexColor) IsTexInternal:IsIncluded
								)
							) else
								MtlSetParam SPSParamName SPSParamType (oFTypeExec SPSParamDef (SPSToGIMSParamType SPSParamType) IDMask:#{2..SPSParamDef.Count})
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
						AddResult = GIMS.Core.SystemMgr.AddResult,
						FormatText = ValueOps.FormatText,
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
								Mtl.Matrix4x4ParamNames,
								Mtl.Float2x3ParamNames,
								Mtl.Float4x4ParamNames,
								Mtl.Float4x5ParamNames
							),
							ParamTypeGroups = #(
								#sp_sampler,
								#sp_float,
								#sp_matrix3x4,
								#sp_matrix4x4,
								#sp_float2x3,
								#sp_float4x4,
								#sp_float4x5
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
															IsEmbedded = (GetParam ParamName ParamType GetIsTexInternal:true ParamID:ParamID)
													if IsEmbedded then (
														if (DoesFileExist FilePath) then (
															local	FileNameExt = (FileNameFromPath FilePath),
																	NewPath = (TexPath + FileNameExt),
																	OTX = (
																		grcTexture \
																			DiskPath:TexPath \
																			ObjName:FileName \
																			TexturePath:FilePath
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
												(TypeCast ParamValue GIMSParamType)
										)
								WriteVal BufferID (AsoFText ParamName TabString:SubTabString)
								if
									ParamType == #sp_matrix3x4 or
									ParamType == #sp_float4x4 or
									ParamType == #sp_matrix4x4 or
									ParamType == #sp_float2x3 or
									ParamType == #sp_float4x5
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
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcDrawable*/ strDrawable (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcDrawable",
		DiskPath,
		ObjName,
		Extension = ".odr",
		Version = [144, 20],
		ShadingGroup,
		TheSkeleton,
		LODGroup,
		LightAttributes,
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
		fn Read TexPath ReportProgress:true CachePath:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						Skip = BufferMgr.Skip,
						oFTypeExec = GIMS.Core.StringOps.oFTypeExec,
						\
						grcShadingGroup = GIMS.CurrentGame.Core.TypeLibrary.grcShadingGroup,
						grcSkeleton = GIMS.CurrentGame.Core.TypeLibrary.grcSkeleton,
						grcLODGroup = GIMS.CurrentGame.Core.TypeLibrary.grcLODGroup,
						grcLightAttributes = GIMS.CurrentGame.Core.TypeLibrary.grcLightAttributes,
						BufferID = (
							BufferMgr.ReadFile (
								GIMS.Core.ValueOps.FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#StreamTxt
						),
						tLine,
						IsVersionValid = false
				GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
				if BufferID == false then
					return false;
				if No TexPath then
					TexPath = DiskPath
				local	NotEOF = BufferMgr.NotEOF
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do (
					local	Tag = (TypeCast tLine[1] name)
					if ReportProgress then
						UpdateProgress #Progress (GetProgress BufferID)
					else
						UpdateProgress #None 0
					case Tag of (
						#Version: (
							if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
								(TypeCast tLine[2] name) != #NULL
							then (
								ShadingGroup = (grcShadingGroup DiskPath:DiskPath ObjName:ObjName)
								ShadingGroup.Read BufferID TexPath
							)
						)
						#Skeleton: (
							local	PathParam = tLine[2]
							if (TypeCast PathParam name) != #NULL then (
								TheSkeleton = (grcSkeleton DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
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
							if (TypeCast PathParam name) != #NULL then (
								LightAttributes = (grcLightAttributes DiskPath:(DiskPath + (GetFileNamePath PathParam)) ObjName:(GetFileNameFile PathParam) Extension:(GetFileNameType PathParam))
								if not (LightAttributes.Read()) then
									return false;
							)
						)
						Default: (
							if IsVersionValid then
								throw ("Unknown strDrawable tag " + tLine[1])
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
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #TexPath), #(DiskPath, ObjName, Extension, TexPath)))/*<ERRHANDLEREND>*/
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
						FormatText = ValueOps.FormatText,
						WriteVal = BufferMgr.WriteVal,
						ObjDir = (DiskPath + ObjName),
						FilePath = (ObjDir + Extension),
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
						SubDir = (ObjName + "\\"),
						SubPath = (DiskPath + SubDir),
						HaveMeshes = false,
						LODGroups = LODGroup.LODGroups,
						HaveShadingGroup = (Have ShadingGroup),
						HaveTheSkeleton = (Have TheSkeleton),
						HaveLightAttributes = (Have LightAttributes),
						TabString = "\t",
						BraceOpen = "{",
						BraceClose = "}",
						TabBraceOpen = (TabString + BraceOpen),
						TabBraceClose = (TabString + BraceClose)
				if BufferID != false then (
					GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
					for LODGroup in LODGroups while not HaveMeshes where LODGroup.Count != 0 do
						HaveMeshes = true
					if
						HaveTheSkeleton or
						HaveLightAttributes or
						HaveShadingGroup or
						HaveMeshes
					then
						MakeDir SubPath All:true
					WriteVal BufferID (ValueOps.AsoFText Version TypeHook:Integer TabString:"Version ")
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
					local	TheBones
					if HaveTheSkeleton then (
						local	TheSkeletonObjName = ObjName
						TheSkeleton.ObjName = TheSkeletonObjName
						TheBones = TheSkeleton.TheBones
						WriteVal BufferID (
							FormatText \
							v1:"\tSkeleton " \
							v2:SubDir \
							v3:TheSkeletonObjName \
							v4:TheSkeleton.Extension
						)
						TheSkeleton.DiskPath = SubPath
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
						local	LightAttributesObjName = ObjName
						LightAttributes.ObjName = LightAttributesObjName
						WriteVal BufferID (
							FormatText \
							v1:"\tLight " \
							v2:SubDir \
							v3:LightAttributesObjName \
							v4:LightAttributes.Extension
						)
						LightAttributes.DiskPath = SubPath
						LightAttributes.Write()
					) else
						WriteVal BufferID "\tLight null"
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
						Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_MP3_Model),
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
				if Have TheSkeleton then (
					BoneNodes.Count = TheSkeleton.NumBones
					TheSkeleton.Create Result BoneNodes
					Result.AuthoredOrientation = TheSkeleton.AuthoredOrientation
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
						UpdateProgress #None 0
				if Have LODGroup then
					LODGroup.Create BoneNodes ShadingGroup
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
		Version = [144, 20],
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
		fn Read TexPath ReportProgress:true CachePath:undefined = (
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
						GetProgress = BufferMgr.GetProgress,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						BufferID = (
							BufferMgr.ReadFile (
								FormatText \
									v1:DiskPath \
									v2:ObjName \
									v3:Extension
							) Mode:#StreamTxt
						),
						NewItem,
						NotEOF = BufferMgr.NotEOF
				GIMS.Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.ObjectNames ObjName
				if BufferID == false then
					return false;
				if No TexPath then
					TexPath = DiskPath
				local	IsVersionValid = false,
						ItemCount = 0
				Items.Count = 20
				while
					(NotEOF BufferID) and
					(tLine = (ReadVal BufferID FilterStr:"\t "))[1] != "}"
				do ( /* skips end */
					if tLine.Count > 0 then (
						local	Tag = (TypeCast tLine[1] name)
						case Tag of (
							#Version: (
								if (oFTypeExec tLine #P2 IDMask:#{2, 3}) != Version then (
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
									local	SubPath = tLine[1]
									NewItem = (grcDrawable DiskPath:(DiskPath + (GetFileNamePath SubPath)) ObjName:(GetFileNameFile SubPath))
									if not (NewItem.Read TexPath ReportProgress:false) then
										return false;
									ItemCount += 1
									Items[ItemCount] = NewItem
								) else (
									GIMS.Core.SystemMgr.AddResult #Error  (
										FormatText \
											v1:"Syntax error in DrawableDictionary resource \"" \
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
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName, #Extension, #TexPath), #(DiskPath, ObjName, Extension, TexPath)))/*<ERRHANDLEREND>*/
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
						BufferID = (BufferMgr.Create Mode:#StreamTxt FilePath:FilePath),
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
				local	Result = (GIMS.Core.ObjectMgr.CreateIfUnique ObjName ParentNode:ParentNode AllowSearch:false NodeType:EGIMS_MP3_ModelDict),
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
					if (TypeCast XMLNode.Name Name) == #Annotation then (
						aKey = (TypeCast (XMLNode.GetAttribute "key") Name)
						if No aKey then
							throw (Append "Can't find \"key\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name)
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
										(TypeCast XMLNode.Value Integer)
									#float:
										(TypeCast XMLNode.Value Float)
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
					if (TypeCast XMLNode.Name Name) == #Item then (
						aName = (XMLNode.GetAttribute "name")
						if No aName then
							throw (Append "Can't find \"name\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						Description = (TypeCast (XMLNode.GetAttribute "description") Name)
						if No Description then
							throw (Append "Can't find \"description\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name)
						if No aType then
							throw (Append "Can't find \"type\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						isRequired = (TypeCast (XMLNode.GetAttribute "isRequired") BooleanClass)
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
									(TypeCast (GIMS.Core.StringOps.oFTypeExec ParamValue ParamType) #P4)
								else
									(GIMS.Core.StringOps.oFTypeExec ParamValue ParamType)
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
										#sp_float: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#sp_float2: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#sp_float3: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#sp_float4: (
											IsArray = false
											[1, 1, 1, 1]
										)
										#sp_matrix3x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1]
											Res
										)
										#sp_matrix4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#sp_float2x3: (
											local	Res = #()
											for i = 3 to 1 by -1 do
												Res[i] = [1, 1]
											Res
										)
										#sp_float4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#sp_float4x5: (
											local	Res = #()
											for i = 5 to 1 by -1 do
												Res[i] = [1, 1, 1, 1]
											Res
										)
										#sp_sampler: (/*SKIP*/)
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
										#sp_sampler:
											"*NULL*"
										#sp_matrix3x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0]
											Res
										)
										#sp_matrix4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										#sp_float2x3: (
											local	Res = #()
											for i = 3 to 1 by -1 do
												Res[i] = [0, 0, 0]
											Res
										)
										#sp_float4x4: (
											local	Res = #()
											for i = 4 to 1 by -1 do
												Res[i] = [0, 0, 0, 0]
											Res
										)
										#sp_float4x5: (
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
					if (TypeCast XMLNode.Name Name) == #Element then (
						Usage = (TypeCast (XMLNode.GetAttribute "usage") Name)
						if No Usage then
							throw (Append "Can't find \"usage\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aType = (TypeCast (XMLNode.GetAttribute "type") Name)
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
		Skinned,
		Aligned,
		Elements = #(),
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name) == #Item then (
						Skinned = (TypeCast (XMLNode.GetAttribute "skinned") BooleanClass)
						if No Skinned then
							throw (Append "Can't find \"skinned\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						Aligned = (TypeCast (XMLNode.GetAttribute "aligned") BooleanClass)
						if No Aligned then
							throw (Append "Can't find \"aligned\" parameter at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						local	ElementsSubTree = (XMLNode.ReadSubTree())
						if No ElementsSubTree then
							throw (Append "Can't find shader vertex declaration elements subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						local	SPSVertexDeclarationElement = GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclarationElement,
								ElementCount = 0
						Elements.Count = 20
						while (ElementsSubTree.Read()) do (
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
		bucket = 0,
		fn Read XMLNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if XMLNode.HasAttributes then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					if (TypeCast XMLNode.Name Name) == #ShaderPreSet then (
					
						aName = (XMLNode.GetAttribute "name")
						if No aName then
							throw (Append "Can't find \"name\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aName = (GetFileNameFile aName)
						
						aShader = (XMLNode.GetAttribute "shader")
						if No aShader then
							throw (Append "Can't find \"shader\" property at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
						aShader = (TypeCast aShader Name)
						
						local	ShaderSubTree = (XMLNode.ReadSubTree())
						if No ShaderSubTree then
							throw (Append "Can't read shader subtree at " ([XMLNode.LineNumber, XMLNode.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "bucket") then
							throw (Append "Can't find \"bucket\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not (ShaderSubTree.Read()) then
							throw (Append "Can't read \"bucket\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not ShaderSubTree.HasValue then
							throw (Append "Can't find \"bucket\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						bucket = (TypeCast ShaderSubTree.Value Integer)
						if No bucket then
							throw (Append "Wrong \"bucket\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "supportSkinning") then
							throw (Append "Can't find \"supportSkinning\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not (ShaderSubTree.Read()) then
							throw (Append "Can't read \"supportSkinning\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						if not ShaderSubTree.HasValue then
							throw (Append "Can't find \"supportSkinning\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						SupportSkinning = (TypeCast ShaderSubTree.Value BooleanClass)
						if No SupportSkinning then
							throw (Append "Wrong \"supportSkinning\" parameter value at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
							
						if not (ShaderSubTree.ReadToFollowing "ShaderParameters") then
							throw (Append "Can't find \"ShaderParameters\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	ParamsSubTree = (ShaderSubTree.ReadSubTree())
						if No ParamsSubTree then
							throw (Append "Can't read shader items subtree at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	SPSParam = GIMS.CurrentGame.Core.TypeLibrary.SPSParam,
								AppendSorted = GIMS.Core.ArrayOps.AppendSorted
						while (ParamsSubTree.Read()) do (
							local	Item = (SPSParam())
							if (Item.Read ParamsSubTree) then
								AppendSorted ShaderParameters Item ValuePropertyName:#aName
						)
						
						if not (ShaderSubTree.ReadToFollowing "VertexDeclarations") then
							throw (Append "Can't find \"VertexDeclarations\" parameter at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	VertexDeclarationsSubTree = (ShaderSubTree.ReadSubTree())
						if No VertexDeclarationsSubTree then
							throw (Append "Can't read shader VertexDeclarations subtree at " ([ShaderSubTree.LineNumber, ShaderSubTree.LinePosition] as String))
						local	SPSVertexDeclaration = GIMS.CurrentGame.Core.TypeLibrary.SPSVertexDeclaration,
								VDCount = 0
						VertexDeclarations.Count = 10
						while (VertexDeclarationsSubTree.Read()) do (
							local	VertexDeclaration = (SPSVertexDeclaration())
							if (VertexDeclaration.Read VertexDeclarationsSubTree) then (
								VDCount += 1
								VertexDeclarations[VDCount] = VertexDeclaration
							)
						)
						VertexDeclarations.Count = VDCount
						if VDCount != 0 then (
							if SupportSkinning then (
								local	HaveSkinnedVD = false
								for VD in VertexDeclarations where VD.Skinned while not HaveSkinnedVD do
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
		/*common*/		Bounds = strBounds,
		/*oF models*/	grcMeshVertex = strMeshVertex,
						grcLODMeshGeometry = strLODMeshGeometry,
						grcLODMesh = strLODMesh,
						grcLODGroup = strLODGroup,
						grcBone = strBone,
						grcSkeleton = strSkeleton,
						grcLight = strLight,
						grcLightAttributes = strLightAttributes,
						grcTexture = strTexture,
						grcTextureDictionary = strTextureDictionary,
						grcShadingGroup = strShadingGroup,
						grcDrawable = strDrawable,
						grcDrawableDictionary = strDrawableDictionary,
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
