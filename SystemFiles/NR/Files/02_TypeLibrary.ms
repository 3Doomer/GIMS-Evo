/*#PC*DEFINE	CurrentGame	NR*/
/*<PROFILERSTART>*//*(LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	
	/*Common*/
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.UIPreset*/ strUIPreset (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.UIPreset",
		BonesMode = 13,
		FlipFaces = false,
		MirrorX = false,
		MirrorY = false,
		MirrorZ = false,
		FlipU = false,
		FlipV = true,
		ImportMode = true,
		FormatIndex = 0,
		PositionX = "0.0",
		PositionY = "0.0",
		PositionZ = "0.0",
		RotationX = "90.0",
		RotationY = "0.0",
		RotationZ = "0.0",
		Scale = "1.0",
		OffsetU = "0.0",
		OffsetV = "0.0",
		ScaleU = "1.0",
		ScaleV = "1.0",
		Diffuse = "0",
		Bump = "2",
		Specular = "1",
		Path = "",
		IDs = "0-99999"
	)
	
	/*RIP*/
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcRipVDElem*/ strRipVDElem (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcRipVDElem",
		ElemName,
		ID,
		Offset,
		Size,
		ValueCount,
		ValueTypes = #(),
		ValueTypeIDs = #(),
		fn SetValueTypes VDTypeMap TargetTypeIDs = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Supplied TargetTypeIDs then (
					if (IsKindOf TargetTypeIDs Array) then
						ValueTypeIDs = TargetTypeIDs
					else (
						for i = ValueCount to 1 by -1 do
							ValueTypeIDs[i] = TargetTypeIDs
					)
				)
				for i = ValueCount to 1 by -1 do
					ValueTypes[i] = VDTypeMap[ValueTypeIDs[i]]
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal
				ElemName = (GIMS.Core.ValueOps.TypeCast (ReadVal BufferID MAXType:#NTString) Name)
				ID = (ReadVal BufferID BinType:#UInt)
				Offset = (ReadVal BufferID BinType:#UInt)
				Size = (ReadVal BufferID BinType:#UInt)
				ValueCount = (ReadVal BufferID BinType:#UInt)
				ValueTypeIDs = (ReadVal BufferID MAXType:#Array BinType:#UInt Size:ValueCount)
				GIMS.Core.ArrayOps.Modify ValueTypeIDs 1 #Add CopyArray:false
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.grcRipFile*/ strRipFile (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.grcRipFile",
		DiskPath,
		ObjName,
		Version = 4,
		FaceCount,
		VertCount,
		VertSize,
		TexCount,
		ShaderCount,
		VDElemCount,
		VDElements = #(),
		Textures = #(),
		Shaders = #(),
		Faces = #(),
		Channels = #(),
		fn GetVDMap VDMaps &FoundVDMap ElemNames:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*<VERBOSE_START>*//*
				Format "VD map "
				*//*<VERBOSE_END>*/
				--search VD map
				local	VDMap = unsupplied
				if Supplied VDMaps then (
					--search using source element names
					local	Compare = GIMS.Core.ValueOps.Compare,
							ValueTypeIDs = #(),
							ValueCounts = #(),
							SuppliedElemNames = (Supplied ElemNames)
					if SuppliedElemNames then (
						for i = VDElemCount to 1 by -1 do (
							local	VDElem = VDElements[i]
							ValueTypeIDs[i] = VDElem.ValueTypeIDs[1]
							ValueCounts[i] = VDElem.ValueCount
						)
					) else (
						ElemNames = #()
						for i = VDElemCount to 1 by -1 do (
							local	VDElem = VDElements[i]
							ValueTypeIDs[i] = VDElem.ValueTypeIDs[1]
							ValueCounts[i] = VDElem.ValueCount
							ElemNames[i] = VDElem.ElemName
						)
					)
					local	TargetChannelNamesuppliedFlags = #{},
							VDMapCount = VDMaps.Count
					TargetChannelNamesuppliedFlags.Count = VDMapCount
					for i = 1 to VDMapCount while not FoundVDMap do (
						local	tVDMap = VDMaps[i],
								VDMapChannelCount = tVDMap.TargetChannelNames.Count
						if VDMapChannelCount == VDElemCount then (
							local	SourceChannelNames = tVDMap.SourceChannelNames,
									SourceValueTypeIDs = tVDMap.SourceValueTypeIDs,
									TargetTypeIDs = tVDMap.TargetTypeIDs,
									SourceValueCounts = tVDMap.SourceValueCounts,
									SuppliedSourceChannelNames = (Supplied SourceChannelNames),
									SuppliedSourceValueTypeIDs = (Supplied SourceValueTypeIDs),
									SuppliedSourceValueCounts = (Supplied SourceValueCounts)
							TargetChannelNamesuppliedFlags[i] = SuppliedSourceChannelNames
							/*<VERBOSE_START>*//*
							Format "VDMap:\n"
							Format "\tCompare channel names:\n"
							Format "\t\t%\n" ElemNames
							Format "\t\t%\n" SourceChannelNames
							Format "\tCompare type IDs:\n"
							Format "\t\t%\n" ValueTypeIDs
							if
								SuppliedElemNames or
								(not Supplied TargetTypeIDs)
							then
								Format "\t\t%\n" SourceValueTypeIDs
							else
								Format "\t\t%\n" TargetTypeIDs
							Format "\tCompare value counts:\n"
							Format "\t\t%\n" ValueCounts
							Format "\t\t%\n" SourceValueCounts
							*//*<VERBOSE_END>*/
							if
								SuppliedSourceChannelNames or
								SuppliedSourceValueTypeIDs or
								SuppliedSourceValueCounts
							then (
								if
									(
										not SuppliedSourceChannelNames or
										(Compare ElemNames SourceChannelNames)
									) and (
										not SuppliedSourceValueTypeIDs or (
											if
												SuppliedElemNames or
												(not Supplied TargetTypeIDs)
											then
												(Compare ValueTypeIDs SourceValueTypeIDs)
											else
												(Compare ValueTypeIDs TargetTypeIDs)
										)
									) and (
										not SuppliedSourceValueCounts or
										(Compare ValueCounts SourceValueCounts)
									)
								then (
									VDMap = tVDMap
									FoundVDMap = true
									/*<VERBOSE_START>*//*
									if SuppliedSourceChannelNames then (
										if SuppliedSourceValueTypeIDs then
											Format "found using elem names and value type ids"
										else
											Format "found using elem names"
									) else
										Format "found using value type ids"
									*//*<VERBOSE_END>*/
								)
							)							
						)
					)
				)
				/*<VERBOSE_START>*//*
				Format ": %\n" VDMap
				*//*<VERBOSE_END>*/
				VDMap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read VDMaps ReportProgress:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*<VERBOSE_START>*//*Format "\nRIP read\t%\tVDMaps: %\n\n" ObjName VDMaps*//*<VERBOSE_END>*/
				local	ValueOps = GIMS.Core.ValueOps,
						SystemMgr = GIMS.Core.SystemMgr,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						FullFilePath = (DiskPath + ObjName),
						BufferID = (BufferMgr.ReadFile FullFilePath Mode:#StreamBin),
						Result = true
				if BufferID != false then (
					BufferMgr.CheckEOF = true
					local	MagicValue = (ReadVal BufferID BinType:#UInt)
					if MagicValue != 0xDEADC0DEL then (
						SystemMgr.AddResult #Error (
							ValueOps.FormatText \
								v1:"Wrong magic value " \
								v2:(Bit.IntAsHex MagicValue) \
								v3:" in file " \
								v4:FullFilePath
						)
						Result = false
					)
					if Result then (
						local	ResVersion = (ReadVal BufferID BinType:#UInt)
						if ResVersion != Version then (
							SystemMgr.AddResult #Error (
								ValueOps.FormatText \
									v1:"Unknown version " \
									v2:ResVersion \
									v3:" resource in file " \
									v4:FullFilePath
							)
							Result = false
						)
						if Result then (
							local	GetProgress = BufferMgr.GetProgress,
									UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
									grcRipVDElem = GIMS.CurrentGame.Core.TypeLibrary.grcRipVDElem
							if ReportProgress then
								UpdateProgress #Progress (GetProgress BufferID)
							FaceCount = (ReadVal BufferID BinType:#UInt)
							VertCount = (ReadVal BufferID BinType:#UInt)
							VertSize = (ReadVal BufferID BinType:#UInt)
							TexCount = (ReadVal BufferID BinType:#UInt)
							ShaderCount = (ReadVal BufferID BinType:#UInt)
							--read VD
							VDElemCount = (ReadVal BufferID BinType:#UInt)
							VDElements.Count = VDElemCount
							local	ElemNames = #()
							ElemNames.Count = VDElemCount
							for i = 1 to VDElemCount do (
								if ReportProgress then
									UpdateProgress #Progress (GetProgress BufferID)
								local	NewVDElem = (grcRipVDElem())
								NewVDElem.Read BufferID
								ElemNames[i] = NewVDElem.ElemName
								VDElements[i] = NewVDElem
							)
							--get VD map
							local	FoundVDMap = false
							VDMap = (GetVDMap VDMaps &FoundVDMap ElemNames:ElemNames)
							--set VD value types
							local	VDTypeMap = #(#Float, #UInt, #Short, #Byte, #Short, #Int),
									TargetTypeIDs = (
										if Supplied VDMap then
											VDMap.TargetTypeIDs
										else
											unsupplied
									)
							if Supplied TargetTypeIDs then (
								for i = 1 to VDElemCount do
									VDElements[i].SetValueTypes VDTypeMap TargetTypeIDs[i]
							) else (
								for i = 1 to VDElemCount do
									VDElements[i].SetValueTypes VDTypeMap unsupplied
							)
							--read data
							Textures = (ReadVal BufferID MAXType:#Array ArrayItemMAXType:#NTString Size:TexCount)
							Shaders = (ReadVal BufferID MAXType:#Array ArrayItemMAXType:#NTString Size:ShaderCount)
							if ReportProgress then
								UpdateProgress #Progress (GetProgress BufferID)
							local	ArrayOps = GIMS.Core.ArrayOps
							Faces = (ArrayOps.Modify (ReadVal BufferID MAXType:#Array ArrayItemMAXType:#P3 BinType:#UInt Size:FaceCount)[1, 1, 1] #Add CopyArray:false)
							local	Skip = BufferMgr.Skip,
									TypeCast = ValueOps.TypeCast,
									ChannelTemplate = #()
							ChannelTemplate.Count = VertCount
							for i = VDElemCount to 1 by -1 do
								Channels[i] = (DeepCopy ChannelTemplate)
							Free ChannelTemplate
							for VertID = 1 to VertCount do (
								for ElemID = 1 to VDElemCount do (
									local	VDElem = VDElements[ElemID],
											ValueTypes = VDElem.ValueTypes,
											ValueTypeIDs = VDElem.ValueTypeIDs,
											ValueCount = VDElem.ValueCount,
											TheValue = #()
									TheValue.Count = (Ternary (ValueCount < 4) 4 ValueCount)
									for i = 1 to ValueCount do (
										TheValue[i] = (TypeCast (ReadVal BufferID BinType:ValueTypes[i]) Float)
										if ValueTypeIDs[i] == 3 then
											Skip BufferID 2
									)
									for i = 4 to (ValueCount + 1) by -1 do
										TheValue[i] = 0.0
									Channels[ElemID][VertID] = TheValue
								)
								if ReportProgress then
									UpdateProgress #Progress (GetProgress BufferID)
							)
						)
					)
					BufferMgr.ClearBuffer BufferID
					BufferMgr.CheckEOF = false
					Result
				) else
					false
			/*<ERRHANDLER>*/) catch (
				GIMS.Core.BufferMgr.CheckEOF = false
				local	CET = (GetCurrentException())
				if (MatchPattern (CET as String) Pattern:"*End of file reached*") then (
					GIMS.Core.SystemMgr.AddResult #Error (
						GIMS.Core.ValueOps.FormatText \
							v1:"The file's corrupted: " \
							v2:DiskPath \
							v3:ObjName
					)
					false
				) else (
					local	ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#DiskPath, #ObjName), #(DiskPath, ObjName))
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _Create_ModUV \
			src \
			trg \
			UOffset \
			UScale \
			VOffset \
			VScale \
			ApplyUOffset \
			ApplyUScale \
			IsUScaleNegative \
			ApplyVOffset \
			IsVScaleNegative \
			ApplyVScale = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if ApplyUOffset then (
					if ApplyUScale then (
						if IsUScaleNegative then
							trg[1] = (((src[1] + UOffset) * UScale) + 1)
						else
							trg[1] = ((src[1] + UOffset) * UScale)
					) else
						trg[1] = (src[1] + UOffset)
				) else (
					if ApplyUScale then (
						if IsUScaleNegative then
							trg[1] = (((src[1] + UOffset) * UScale) + 1)
						else
							trg[1] = ((src[1] + UOffset) * UScale)
					)
				)
				if ApplyVOffset then (
					if ApplyVScale then (
						if IsVScaleNegative then
							trg[2] = (((src[2] + VOffset) * VScale) + 1)
						else
							trg[2] = ((src[2] + VOffset) * VScale)
					) else
						trg[2] = (src[2] + VOffset)
				) else (
					if ApplyVScale then (
						if IsVScaleNegative then
							trg[2] = (((src[2] + VOffset) * VScale) + 1)
						else
							trg[2] = ((src[2] + VOffset) * VScale)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create \
			ParentNode \
			VDMaps \
			TextureIDs \
			FlipFaces \
			CanSplitSkinning \
			MeshTransform \
			UOffset \
			VOffset \
			UScale \
			VScale \
			BoneNodes \
			UsedBones \
			MaterialsMHL \
			BonePositions \
			BonePosWeights \
			ProMode \
			ReportProgress:true = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*<VERBOSE_START>*//*Format "\nRIP create\t%\tVDMaps: %\n\n" ObjName VDMaps*//*<VERBOSE_END>*/
				local	Result = true,
						ValueOps = GIMS.Core.ValueOps,
						FormatText = ValueOps.FormatText,
						AddResult = GIMS.Core.SystemMgr.AddResult,
						ObjectMgr = GIMS.Core.ObjectMgr,
						SuppliedBonePositions = (Supplied BonePositions),
						CreateMesh_ProgressStepCount, UpdateProgress, ProgressStepCount, Progress
				if ReportProgress then (
					UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					CreateMesh_ProgressStepCount = ObjectMgr.CreateMesh_ProgressStepCount
					ProgressStepCount = (9 + (CreateMesh_ProgressStepCount))
					Progress = [0, 0, ProgressStepCount]
				)
				if VertCount > 0 then (
					--get VD map
					local	FoundVDMap = false,
							VDMap = (GetVDMap VDMaps &FoundVDMap),
							TargetChannelNames = unsupplied,
							TargetChannelModifiers = unsupplied,
							TargetChannelOrder = unsupplied,
							TargetChannelPerValueMods = unsupplied,
							VDNotFound = (
								Supplied VDMaps and
								not FoundVDMap
							),
							VDDatas,
							OriginalVDElements
					--collect ProMode VD info
					if ProMode then (
						OriginalVDElements = (DeepCopy VDElements)
						VDDatas = #()
						local	VertCountSplit = 5,
								VertCountPart = ((VertCount as Float) / VertCountSplit)
						for i = VDElemCount to 1 by -1 do (
							local	VDData = #(),
									Channel = Channels[i]
							VDData[VertCountSplit] =  Channel[VertCount]
							VDData[1] = Channel[1]
							for j = (VertCountSplit - 1) to 2 by -1 do
								VDData[j] = Channel[VertCountPart * j]
							VDDatas[i] = VDData
						)
					)
					if ReportProgress then (
						Progress.x += 1
						UpdateProgress #Progress Progress
					)
					--apply name mapping
					if Supplied VDMap then (
						TargetChannelModifiers = VDMap.TargetChannelModifiers
						TargetChannelPerValueMods = VDMap.TargetChannelPerValueMods
						local	VDTargetChannelOrder = VDMap.TargetChannelOrder
						TargetChannelOrder = (
							if Supplied VDTargetChannelOrder then
								(DeepCopy VDTargetChannelOrder)
							else
								unsupplied
						)
						TargetChannelNames = (DeepCopy VDMap.TargetChannelNames)
					)
					
					/*<VERBOSE_START>*//*
					with PrintAllElements true (
						Print "Read data"
						for i = 1 to VDElements.Count do
							Format "\tChannel ID %\tname %\tvalues %\n" i VDElements[i].ElemName Channels[i]
					)
					*//*<VERBOSE_END>*/
					
					if not Supplied TargetChannelNames then (
						TargetChannelNames = #()
						local	PositionsFound = false
						for i = VDElemCount to 1 by -1 do (
							local	ChannelName = VDElements[i].ElemName
							TargetChannelNames[i] = ChannelName
							if ChannelName == #POSITION then
								PositionsFound = true
						)
						if not PositionsFound then (
							for i = 1 to VDElemCount where VDElements[i].ValueCount > 2 while not PositionsFound do (
								/*
								AddResult #Error  (
									FormatText \
										v1:"The mesh file hasn't got vertex positions. GIMS will try to find them... File: \"" \
										v2:DiskPath \
										v3:ObjName \
										v4:"\""
								)
								*/
								TargetChannelNames[i] = #POSITION
								PositionsFound = true
							)
						)
					)
					
					/*<VERBOSE_START>*//*
					with PrintAllElements true (
						Print "Applied name mapping"
						for i = 1 to TargetChannelNames.Count do
							Format "\tChannel ID %\tname %\tvalues %\n" i TargetChannelNames[i] Channels[i]
					)
					*//*<VERBOSE_END>*/
					
					if Result then (
						local	DiffTextureID = TextureIDs[1],
								BumpTextureID = TextureIDs[2],
								SpecTextureID = TextureIDs[3],
								HaveBump = (BumpTextureID > 0),
								HaveSpec = (SpecTextureID > 0),
								DiffFileName = (
									if DiffTextureID > 0 then
										Textures[DiffTextureID]
									else
										"setka.png"
								),
								BumpFileName = (
									if HaveBump then
										Textures[BumpTextureID]
								),
								SpecFileName = (
									if HaveSpec then
										Textures[SpecTextureID]
								),
								ArrayOps = GIMS.Core.ArrayOps,
								Modify = ArrayOps.Modify,
								MaterialHash = (
									ValueOps.GetHash (
										FormatText \
											v1:DiffFileName \
											v2:(Ternary HaveBump BumpFileName "_") \
											v3:(Ternary HaveSpec SpecFileName "_")
									)
								),
								TheMaterial = (ArrayOps.FetchMHL MaterialsMHL MaterialHash ReturnHashOnFail:false),
								LoadBitmapFile = GIMS.Core.MaterialOps.LoadBitmapFile
						if No TheMaterial then (
							TheMaterial = (
								Standard \
									Name:ObjName \
									ShowInViewport:true \
									BumpMapAmount:100 \
									SpecularLevelMapAmount:100 \
									DiffuseMap:(
										if Have DiffFileName then
											(LoadBitmapFile DiskPath (GetFileNameFile DiffFileName) DefaultExt:".dds")
									) \
									BumpMap:(
										if Have BumpFileName then
											(Normal_Bump Normal_Map:(LoadBitmapFile DiskPath (GetFileNameFile BumpFileName) DefaultExt:".dds"))
									) \
									SpecularLevelMap:(
										if Have SpecFileName then
											(RGB_Tint Map1:(LoadBitmapFile DiskPath (GetFileNameFile SpecFileName) DefaultExt:".dds") Red:White Green:White Blue:White)
									)
							)
							ArrayOps.AppendMHL MaterialsMHL TheMaterial Sorted:true Hash:MaterialHash
						)
						if ReportProgress then (
							Progress.x += 1
							UpdateProgress #Progress Progress
						)
						--modify channel values
						if Supplied TargetChannelModifiers then (
							for i = 1 to TargetChannelModifiers.Count do (
								local	ChannelModifier = TargetChannelModifiers[i]
								if Supplied ChannelModifier then
									Modify Channels[i] ChannelModifier[1] ChannelModifier[2] CopyArray:false
							)
						)
						--apply channel per-value modifiers
						local	TypeCast = ValueOps.TypeCast
						if Supplied TargetChannelPerValueMods then (
							for i = 1 to TargetChannelPerValueMods.Count do (
								local	ChannelPerValueMod = TargetChannelPerValueMods[i]
								if Supplied ChannelPerValueMod then (
									local	Channel = Channels[i]
									case ChannelPerValueMod of (
										#XYZMultWDiv6553500: (
											if Have Channel[1][4] then (
												for j = 1 to VertCount do (
													local	Val = Channel[j]
													Channel[j] = ((TypeCast Val #P3) * Val[4] / 6553500)
												)
												VDElements[i].ValueCount = 3
											)
										)
										Default:
											throw "Unknown per-value channel modifier: " ChannelPerValueMod
									)
								)
							)
						)
					
						/*<VERBOSE_START>*//*
						with PrintAllElements true (
							Print "Modified values"
							for i = 1 to TargetChannelNames.Count do
								Format "\tChannel ID %\tname %\tvalues %\n" i TargetChannelNames[i] Channels[i]
						)
						*//*<VERBOSE_END>*/
					
						/*<VERBOSE_START>*//*
						with PrintAllElements true
							Format "Applied channel order %\n" TargetChannelOrder
						*//*<VERBOSE_END>*/
					
						--apply channel order
						if Supplied TargetChannelOrder then
							ArrayOps.QuickSort #(Channels, TargetChannelOrder, TargetChannelNames) MHL:true
					
						/*<VERBOSE_START>*//*
						with PrintAllElements true (
							for i = 1 to TargetChannelNames.Count do
								Format "\tChannel ID %\tname %\tvalues %\n" i TargetChannelNames[i] Channels[i]
						)
						*//*<VERBOSE_END>*/
					
						if ReportProgress then (
							Progress.x += 1
							UpdateProgress #Progress Progress
						)
						--find UV channels
						local	UVChannelFlags = #(),
								UVCount = 0
						for i = VDElemCount to 1 by -1 do
							UVChannelFlags[i] = false
						local	ColorCount = 0,
								ApplyUOffset = (not (FloatCompare UOffset 0 0.0001)),
								ApplyVOffset = (not (FloatCompare VOffset 0 0.0001)),
								ApplyUScale = (not (FloatCompare UScale 1 0.0001)),
								ApplyVScale = (not (FloatCompare VScale 1 0.0001)),
								IsUScaleNegative, IsVScaleNegative,
								UVModificationNeeded = (
									ApplyUOffset or
									ApplyUScale or
									ApplyVOffset or
									ApplyVScale
								),
								AllChannelIDs = #(),
								AllTargetChannelNames = #(),
								AllChannelSwapHints = #()
						if UVModificationNeeded then (
							IsUScaleNegative = (UScale < 0)
							IsVScaleNegative = (VScale < 0)
						)
						for i = 1 to VDElemCount do (
							local	ElemName = TargetChannelNames[i],
									IsForcedUV = false
							if ProMode then (
								Append AllChannelIDs i
								Append AllTargetChannelNames ElemName
								Append AllChannelSwapHints false
							)
							if ElemName == #COLOR then (
								ColorCount += 1
								if ColorCount != 1 then (
									TargetChannelNames[i] = (
										if ColorCount == 2 then
											#COLOR2
										else (
											IsForcedUV = true
											#TEXCOORD
										)
									)
								)
							)
							if
								IsForcedUV or
								ElemName == #TEXCOORD or
								(MatchPattern ElemName Pattern:"TEXCOORD*")
							then (
								local	Channel = Channels[i]
								UVChannelFlags[i] = true
								UVCount += 1
								if UVModificationNeeded then (
									for j = 1 to VertCount do (
										local	val = Channel[j]
										_Create_ModUV \
											val \
											val \
											UOffset \
											UScale \
											VOffset \
											VScale \
											ApplyUOffset \
											ApplyUScale \
											IsUScaleNegative \
											ApplyVOffset \
											IsVScaleNegative \
											ApplyVScale
									)
								)
							)
						)
						--store all channels in UV
						local	RealUVCount = UVCount,
								RealVDElemCount = VDElemCount,
								ProModeUVChannelFlags
						if ProMode then (
							local	EndID = (RealVDElemCount + 1),
									OldChannelID = RealVDElemCount
							VDElemCount += RealVDElemCount
							UVCount += RealVDElemCount
							ProModeUVChannelFlags = #{}
							for i = VDElemCount to EndID by -1 do (
								local	ChannelName = TargetChannelNames[OldChannelID]
								AllChannelIDs[i] = OldChannelID
								AllTargetChannelNames[i] = ChannelName
								AllChannelSwapHints[i] = false
								TargetChannelNames[i] = #TEXCOORD
								VDElements[i] = VDElements[OldChannelID]
								Channels[i] = (DeepCopy Channels[OldChannelID])
								UVChannelFlags[i] = true
								if
									ChannelName == #TEXCOORD or
									(MatchPattern ChannelName Pattern:"TEXCOORD*")
								then
									ProModeUVChannelFlags[i] = true
								OldChannelID -= 1
							)
						)
						if ReportProgress then (
							Progress.x += 1
							UpdateProgress #Progress Progress
						)
						--make channel values needed for Create fn types, and separate Point4 UV channels .ZW data to new channels
						local	PositionChannels = #(),
								PositionChannelCount = 0
						PositionChannels.Count = VDElemCount
						for i = VDElemCount to 1 by -1 do (
							if UVChannelFlags[i] then (
								local	Channel = Channels[i],
										VDElement = VDElements[i]
								if (VDElement.ValueCount > 3) then (
									local	NewChannelID = (i + 1),
											NewChannel = (DeepCopy Channel)
										if
											UVModificationNeeded and (
												not ProMode or
												ProModeUVChannelFlags[i]
											)
										then (
											for j = VertCount to 1 by -1 do (
												local	oldVal = Channel[j],
														val = NewChannel[j]
												_Create_ModUV \
													oldVal \
													val \
													UOffset \
													UScale \
													VOffset \
													VScale \
													ApplyUOffset \
													ApplyUScale \
													IsUScaleNegative \
													ApplyVOffset \
													IsVScaleNegative \
													ApplyVScale
												val[3] = 0
												val[4] = 0
											)
										) else (
											for j = VertCount to 1 by -1 do (
												local	oldVal = Channel[j],
														val = NewChannel[j]
												val[1] = oldVal[3]
												val[2] = oldVal[4]
												val[3] = 0
												val[4] = 0
											)
										)
									InsertItem TargetChannelNames[i] TargetChannelNames NewChannelID
									InsertItem VDElement VDElements NewChannelID
									InsertItem NewChannel Channels NewChannelID
									InsertItem true UVChannelFlags NewChannelID
									if ProMode then (
										InsertItem AllChannelIDs[i] AllChannelIDs NewChannelID
										InsertItem AllTargetChannelNames[i] AllTargetChannelNames NewChannelID
										InsertItem true AllChannelSwapHints NewChannelID
									)
									VDElemCount += 1
									UVCount += 1
								)
							) else (
								local	ChannelName = TargetChannelNames[i]
								if ChannelName == #POSITION then (
									local	Channel = Channels[i]
									if not (IsKindOf Channel[1] Point3) then
										TypeCast Channel #P3Array CopyArray:false
									PositionChannelCount += 1
									PositionChannels[PositionChannelCount] = Channel
								) else (
									if
										ChannelName != #BLENDINDICES and
										ChannelName != #BLENDWEIGHT
									then
										TypeCast Channels[i] #P4Array CopyArray:false
								)
							)
						)
						PositionChannels.Count = PositionChannelCount
					
						/*<VERBOSE_START>*//*
						with PrintAllElements true (
							Print "Normalized data"
							for i = 1 to TargetChannelNames.Count do
								Format "\tChannel ID %\tname %\tvalues %\n" i TargetChannelNames[i] Channels[i]
						)
						*//*<VERBOSE_END>*/
					
						if ReportProgress then (
							Progress.x += 1
							UpdateProgress #Progress Progress
						)
						--get channels data
						local	VertNormals = unsupplied,
								VertColors = unsupplied,
								VertColors2 = unsupplied,
								MapVerts = unsupplied,
								HaveIndices = false,
								HaveWeights = false,
								SkinBones = unsupplied,
								SuppliedSkinBones = false,
								SkinWeights = unsupplied,
								SuppliedSkinWeights = false,
								AllowBones = (Supplied BoneNodes),
								WeightValueType = unsupplied,
								HaveUV = true
						if UVCount != 0 then (
							MapVerts = #()
							MapVerts.Count = UVCount
						) else
							HaveUV = false
						UVCount = 0
						for i = 1 to VDElemCount do (
							if
								HaveUV and
								UVChannelFlags[i]
							then (
								UVCount += 1
								MapVerts[UVCount] = Channels[i]
							) else (
								case TargetChannelNames[i] of (
									#NORMAL: (
										if not Supplied VertNormals then
											VertNormals = Channels[i]
									)
									#COLOR: (
										if not Supplied VertColors then
											VertColors = Channels[i]
									)
									#COLOR2: (
										if not Supplied VertColors2 then
											VertColors2 = Channels[i]
									)
									#BLENDWEIGHT: (
										if AllowBones then (
											local	ValueType = VDElements[i].ValueTypes[1]
											if not Supplied WeightValueType then
												WeightValueType = ValueType
											else (
												if ValueType != WeightValueType then
													throw ("Can't merge " + (ValueType as String) + " weights with " + (WeightValueType as String))
											)
											if not Supplied SkinWeights then (
												SkinWeights = Channels[i]
												SuppliedSkinWeights = true
											) else (
												local	Channel = Channels[i]
												for vI = 1 to VertCount do
													SkinWeights[vI] += Channel[vI]
											)
											HaveWeights = true
										)
									)
									#BLENDINDICES: (
										if AllowBones then (
											if not SuppliedSkinBones then (
												SkinBones = Channels[i]
												SuppliedSkinBones = true
											) else (
												local	Channel = Channels[i]
												for vI = 1 to VertCount do
													SkinBones[vI] += Channel[vI]
											)
											HaveIndices = true
										)
									)
								)
							)
						)
						
						/*<VERBOSE_START>*//*
						with PrintAllElements true (
							Print "Skinning data"
							if
								SuppliedSkinBones and
								SuppliedSkinWeights
							then (
								for i = 1 to VertCount do
									Format "\t%\t%\n" SkinBones[i] SkinWeights[i]
							) else
								Format "\tSkinBones:\t%\n\tSkinWeights:\t%\n" i SkinBones SkinWeights
						)
						*//*<VERBOSE_END>*/

						if PositionChannelCount != 0 then (
							if ReportProgress then (
								if PositionChannelCount > 1 then
									Progress.z += (CreateMesh_ProgressStepCount * (PositionChannelCount - 1))
								Progress.x += 1
								UpdateProgress #Progress Progress
							)
							--calculate used bones count, increasing bone IDs to be 1-based
							local	BoneCount = 0,
									SplitSkinning = false,
									SplittedBoneIDVerts = #(),
									SplittedBoneIDs = #{},
									OldBoneCount = 0,
									SplittedBoneDataSize = 0
							if HaveIndices then (
								OldBoneCount = BoneNodes.Count
								SplittedBoneDataSize = OldBoneCount
								SplittedBoneIDVerts.Count = SplittedBoneDataSize
								SplittedBoneIDs.Count = SplittedBoneDataSize
								SplitSkinning = CanSplitSkinning
								for i = 1 to VertCount while Result do (
									local	VertBoneIDs = SkinBones[i],
											SplitBoneID = unsupplied
									for j = 1 to VertBoneIDs.Count while Result do (
										local	BoneID = (VertBoneIDs[j] += 1)
										if
											BoneID < 0 or
											BoneID > 1024
										then (
											AddResult #Error (
												FormatText \
													v1:"Skinning skipped - mesh skin data's invalid. File: \"" \
													v2:DiskPath \
													v3:ObjName \
													v4:"\""
											)
											Result = false
											SplitSkinning = false
											SkinBones = unsupplied
											SuppliedSkinBones = false
										) else (
											if BoneID > BoneCount then
												BoneCount = BoneID
											if SplitSkinning then (
												if not Supplied SplitBoneID then
													SplitBoneID = BoneID
												else (
													if BoneID != SplitBoneID then
														SplitSkinning = false
												)
											)
										)
									)
									if Result then (
										if OldBoneCount < BoneCount then (
											local	BoxSize = [0.01, 0.01, 0.01],
													WireColor = Yellow
											if SuppliedBonePositions then
												BonePosWeights.Count = BoneCount
											for i = BoneCount to (OldBoneCount + 1) by -1 do (
												BoneNodes[i] = (
													Dummy \
														Name:(Append "bone_" (i as String)) \
														Transform:MeshTransform \
														BoxSize:BoxSize \
														WireColor:WireColor \
														ShowLinks:true \
														ShowLinksOnly:true
												)
											)
											OldBoneCount = BoneCount
										)
										if SplitSkinning then (
											if Supplied SplitBoneID then (
												if OldBoneCount > SplittedBoneDataSize then (
													SplittedBoneIDVerts.Count = OldBoneCount
													SplittedBoneIDs.Count = OldBoneCount
													SplittedBoneDataSize = OldBoneCount
												)
												local	BoneIDVerts = SplittedBoneIDVerts[SplitBoneID]
												if BoneIDVerts == undefined then (
													local	ba = #{}
													ba.Count = VertCount
													ba[i] = true
													SplittedBoneIDVerts[SplitBoneID] = ba
												) else
													BoneIDVerts[i] = true
												SplittedBoneIDs[SplitBoneID] = true
											) else
												SplitSkinning = false
										)
									)
								)
								if Result then (
									if
										WeightValueType != #Float and
										SuppliedSkinWeights
									then (
										local	MaxWeight = 0
										for VertWeights in SkinWeights do (
											for VertWeight in VertWeights where VertWeight > MaxWeight do
												MaxWeight = VertWeight
										)
										local	WeightMod = (
													if MaxWeight < 256 then
														255
													else (
														if MaxWeight < 65536 then
															65535
														else (
															if MaxWeight < 4294967295L then
																4294967295L
															else
																throw "Unknown vertex weights divider, max: " MaxWeight
														)
													)
												)
										if MaxWeight != 0 then (
											/*<VERBOSE_START>*//*
											Format "Divide skin weights by %, because max weight = %\n" WeightMod MaxWeight
											*//*<VERBOSE_END>*/
											Modify SkinWeights WeightMod #Divide CopyArray:false
											/*<VERBOSE_START>*//*
											with PrintAllElements true (
												Print "Skinning data after division"
												for i = 1 to VertCount do
													Format "\t%\t%\n" SkinBones[i] SkinWeights[i]
											)
											*//*<VERBOSE_END>*/
										)
										/*<VERBOSE_START>*//*
										else
											Format "All skin weights're 0\n"
										*//*<VERBOSE_END>*/
									)
								) else
									BoneNodes = unsupplied
							)
							if ReportProgress then (
								Progress.x += 1
								UpdateProgress #Progress Progress
							)
							--create mesh
							local	MeshUsedBones = #{},
									CreatedMeshes
							MeshUsedBones.Count = BoneCount
							if SplitSkinning then (
								local	MeshID = 0,
										SplittedBoneCount = SplittedBoneIDs.NumberSet,
										DeleteVerts = MeshOp.DeleteVerts,
										InverseMeshTransform = (Inverse MeshTransform)
								CreatedMeshes = #()
								CreatedMeshes.Count = SplittedBoneCount
								if ReportProgress then (
									Progress.z += (CreateMesh_ProgressStepCount * (SplittedBoneCount - 1))
									UpdateProgress #Progress Progress
								)
								--split mesh
								if SuppliedBonePositions then (
									for BoneID in SplittedBoneIDs do (
										local	BoneFaces = #(),
												BoneFaceID = 0,
												BoneVerts = SplittedBoneIDVerts[BoneID]
										BoneFaces.Count = FaceCount
										for FaceID = 1 to FaceCount do (
											local	VertsHit = 0,
													Face = Faces[FaceID]
											for i = 1 to 3 while VertsHit < 3 do (
												local	VertID = (Face[i])
												if BoneVerts[Face[i]] then
													VertsHit += 1
											)
											if VertsHit == 3 then (
												BoneFaceID += 1
												BoneFaces[BoneFaceID] = Face
											)
										)
										if BoneFaceID != 0 then (
											BoneFaces.Count = BoneFaceID
											local	PosChannelIndex = 0,
													BaseMeshName = ((GetFileNameFile ObjName) + "_")
											for Positions in PositionChannels do (
												local	TheBone = BoneNodes[BoneID],
														BaseName = (
															if PosChannelIndex == 0 then
																BaseMeshName
															else (
																FormatText \
																	v1:BaseMeshName \
																	v2:PosChannelIndex \
																	v3:"_"
															)
														),
														TheMesh = (
															ObjectMgr.CreateMesh \
																Positions \
																BoneFaces \
																ObjName:(BaseName + TheBone.Name) \
																MeshTransform:MeshTransform \
																VertNormals:VertNormals \
																VertColors:VertColors \
																VertColors2:VertColors2 \
																MapVerts:MapVerts \
																UVCount:UVCount \
																Progress:Progress
														)
												DeleteVerts TheMesh (#{1..VertCount} - BoneVerts)
												local	MeshCenter = TheMesh.Center
												TheMesh.Pivot = MeshCenter
												TheMesh.Parent = TheBone
												MeshID += 1
												CreatedMeshes[MeshID] = TheMesh
												MeshUsedBones[BoneID] = true
												BonePositions[BoneID] = (MeshCenter * InverseMeshTransform)
												PosChannelIndex += 1
											)
										)
									)
								) else (
									for BoneID in SplittedBoneIDs do (
										local	BoneFaces = #(),
												BoneFaceID = 0,
												BoneVerts = SplittedBoneIDVerts[BoneID]
										BoneFaces.Count = FaceCount
										for FaceID = 1 to FaceCount do (
											local	VertsHit = 0,
													Face = Faces[FaceID]
											for i = 1 to 3 while VertsHit < 3 do (
												local	VertID = (Face[i])
												if BoneVerts[Face[i]] then
													VertsHit += 1
											)
											if VertsHit == 3 then (
												BoneFaceID += 1
												BoneFaces[BoneFaceID] = Face
											)
										)
										if BoneFaceID != 0 then (
											BoneFaces.Count = BoneFaceID
											local	PosChannelIndex = 0,
													BaseMeshName = ((GetFileNameFile ObjName) + "_")
											for Positions in PositionChannels do (
												local	TheBone = BoneNodes[BoneID],
														BaseName = (
															if PosChannelIndex == 0 then
																BaseMeshName
															else (
																FormatText \
																	v1:BaseMeshName \
																	v2:PosChannelIndex \
																	v3:"_"
															)
														),
														TheMesh = (
															ObjectMgr.CreateMesh \
																Positions \
																BoneFaces \
																ObjName:(BaseName + TheBone.Name) \
																MeshTransform:MeshTransform \
																VertNormals:VertNormals \
																VertColors:VertColors \
																VertColors2:VertColors2 \
																MapVerts:MapVerts \
																UVCount:UVCount \
																Progress:Progress
														)
												DeleteVerts TheMesh (#{1..VertCount} - BoneVerts)
												local	MeshCenter = TheMesh.Center
												TheMesh.Pivot = MeshCenter
												TheMesh.Parent = TheBone
												MeshID += 1
												CreatedMeshes[MeshID] = TheMesh
												MeshUsedBones[BoneID] = true
												PosChannelIndex += 1
											)
										)
									)
								)
							) else (
								CreatedMeshes = #()
								CreatedMeshes.Count = PositionChannelCount
								local	PosChannelIndex = 0,
										FileName = (GetFileNameFile ObjName)
								for Positions in PositionChannels do (
									CreatedMeshes[PosChannelIndex + 1] = (
										ObjectMgr.CreateMesh \
											Positions \
											Faces \
											ObjName:(
												if PosChannelIndex == 0 then
													FileName
												else (
													FormatText \
														v1:FileName \
														v2:"_" \
														v3:PosChannelIndex
												)
											) \
											MeshTransform:MeshTransform \
											VertNormals:VertNormals \
											VertColors:VertColors \
											VertColors2:VertColors2 \
											MapVerts:MapVerts \
											UVCount:UVCount \
											SkinBones:SkinBones \
											SkinWeights:SkinWeights \
											BoneNodes:BoneNodes \
											BoneCount:BoneCount \
											UsedBones:MeshUsedBones \
											Progress:Progress
									)
									--update bone positions
									if
										SuppliedSkinBones and
										SuppliedBonePositions and
										SuppliedSkinWeights
									then (
										for i = 1 to VertCount do (
											local	VertBoneIDs = SkinBones[i],
													VertWeights = SkinWeights[i],
													VertPos = Positions[i]
											for WeightIndex = 1 to VertWeights.Count do (
												local	BoneID = VertBoneIDs[WeightIndex],
														BonePos = BonePositions[BoneID],
														Weight = VertWeights[WeightIndex]
												if Have BonePos then (
													local	CurrentBonePosWeight = BonePosWeights[BoneID]
													if
														Have CurrentBonePosWeight and
														Have Weight
													then (
														local	HalfDir = ((VertPos - BonePos) / 2)
														BonePositions[BoneID] += (HalfDir - (CurrentBonePosWeight * HalfDir) + (Weight * HalfDir))
														BonePosWeights[BoneID] = 1
													)
												) else (
													BonePositions[BoneID] = VertPos
													BonePosWeights[BoneID] = Weight
												)
											)
										)
									)
									PosChannelIndex += 1
								)
							)
							if ReportProgress then (
								Progress.x += 1
								UpdateProgress #Progress Progress
							)
							--update total UsedBones bitarray
							if Supplied UsedBones then (
								for i in MeshUsedBones do
									UsedBones[i] = true
							)
							--assign meshes material
							CreatedMeshes.Material = TheMaterial
							--modify meshes
							for TheMesh in CreatedMeshes do (
								--flip normals
								if FlipFaces then
									MeshOp.FlipNormals TheMesh #All
								--store UV channels info
								if ProMode then (
									SetUserProp TheMesh "UV channels info" "after name mapping and applying order"
									local	UVID = 1
									for i = 1 to VDElemCount where UVChannelFlags[i] do (
										SetUserProp TheMesh \
											("UVChannel" + (UVID as String)) ( \
												FormatText \
													v1:"Channel #" \
													v2:AllChannelIDs[i] \
													v3:": " \
													v4:AllTargetChannelNames[i] \
													v5:(Ternary AllChannelSwapHints[i] " (.XYZW = previous channel .ZW00)" #DontFormatText)
											)
										UVID += 1
									)
								)
							)
							if ReportProgress then (
								Progress.x += 1
								UpdateProgress #Progress Progress
							)
						) else (
							AddResult #Error  (
								FormatText \
									v1:"Can't create a mesh without positions. File: \"" \
									v2:DiskPath \
									v3:ObjName \
									v4:"\""
							)
							Result = false
						)
					)
					if
						ProMode and (
							not Result or 
							VDNotFound
						)
					then (
						local	ss = (StringStream ""),
								MessageMode = (Ternary Result #Warning #Error)
						if VDNotFound then (
							if Result then
								Format "File's imported, but appropriate vertex declaration can't be found in the game engine settings.\n...File path: %%\n...File vertex declaration:\n" DiskPath ObjName To:ss
							else
								Format "...Can't find appropriate vertex declaration in the game engine settings. File vertex declaration:\n" To:ss
						) else
							Format "...File vertex declaration:\n" To:ss
						for i = 1 to RealVDElemCount do (
							local	Elem = OriginalVDElements[i]
							Format \
								"...\tID: %, Name: %, Size: %, Value types: % (Type IDs: %)\n" \
								Elem.ID \
								(Elem.ElemName as String) \
								Elem.Size \
								Elem.ValueTypes \
								Elem.ValueTypeIDs \
								To:ss
							Format "...\tData examples:\n" To:ss
							local	ElemValueCount = Elem.ValueCount
							for VDData in VDDatas[i] do (
								Format "...\t\t" To:ss
								for j = 1 to ElemValueCount do
									Format "% " VDData[j] To:ss
								Format "\n" To:ss
							)
						)
						AddResult MessageMode (ss as String)
						Free ss
					)
				) else (
					AddResult #Error  (
						FormatText \
							v1:"Can't create a mesh without vertices. File: \"" \
							v2:DiskPath \
							v3:ObjName \
							v4:"\""
					)
					Result = false						
				)
				if ReportProgress then
					UpdateProgress #Progress -1
				if
					Have Result and
					ParentNode != RootNode
				then (
					Result.Parent = ParentNode
					Result.Transform = ParentNode.Transform
				)
				Result
			/*<ERRHANDLER>*/) catch (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS \
					AddInfo:#(
					#(
						#DiskPath, 
						#ObjName, 
						#VDMaps,
						#ParentNode,
						#TextureIDs,
						#FlipFaces,
						#CanSplitSkinning,
						#MeshTransform,
						#UOffset,
						#VOffset,
						#UScale,
						#VScale,
						#BoneNodes,
						#UsedBones,
						#MaterialsMHL,
						#BonePositions,
						#BonePosWeights,
						#ProMode
					),
					#(
						DiskPath, 
						ObjName, 
						VDMaps,
						ParentNode,
						TextureIDs,
						FlipFaces,
						CanSplitSkinning,
						MeshTransform,
						UOffset,
						VOffset,
						UScale,
						VScale,
						(
							if (IsKindOf BoneNodes Array) then
								("Array size " + (BoneNodes.Count as String))
							else
								BoneNodes
						),
						UsedBones,
						MaterialsMHL,
						BonePositions,
						BonePosWeights,
						ProMode
					)
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)

	/*this*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary*/ strTypeLibrary (
		/*Common*/	UIPreset = strUIPreset,
		/*RIP*/		grcRipVDElem = strRipVDElem,
					grcRipFile = strRipFile
	)
	GIMS.CurrentGame.Core.TypeLibrary = strTypeLibrary()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS)*//*<PROFILERENDED>*/
