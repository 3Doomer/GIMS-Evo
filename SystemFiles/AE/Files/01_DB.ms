/*#PC*DEFINE	CurrentGame	AE*/
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.DB*/ strDB (
		ThisObj,
		
		ModelTextureMap,
		ShipModelMap,
		StationModelMap,
		RGBAlphaTextures,
		WeaponClasses,
			
		Loaded = false,
		fn PreLoad = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ModelTextureMap = #(
					#(),	/*Model names*/
					#(),	/*Texture names*/
					#()	/*NormalSpec texture names*/
				)
				ShipModelMap = #(
					#(),	/*Names*/
					#(),	/*Base models*/
					#(),	/*Engine models*/
					#(),	/*EngineGlow models*/
					#(),	/*Lights models*/
					#(),	/*Emissive models*/
					#(),	/*LOD_1 models*/
					#(),	/*LOD_2 models*/
					#()	/*Explosion models*/
				)
				StationModelMap = #(
					#(),	/*Names*/
					#()	/*Models*/
				)
				RGBAlphaTextures = #(
					#(),	/*FULL names*/
					#()	/*WILDCARD names*/
				)
				WeaponClasses = #(
					"Main weapon",
					"Heavy weapon",
					"Turret",
					"Equipment",
					"Goods"
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadModelTextureMap ModelTextureMapFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						ArrayOps = GIMS.Core.ArrayOps,
						AppendIfUniq = ArrayOps.AppendIfUniq,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						ValidateGTAString = GIMS.Core.StringOps.ValidateGTAString,
						BufferID = (BufferMgr.ReadFile ModelTextureMapFile),
						NotEOF = BufferMgr.NotEOF,
						Models = ModelTextureMap[1],
						Textures = ModelTextureMap[2],
						NSTextures = ModelTextureMap[3],
						NormalMapPattern = "*normal*",
						CurrentModelNames = #(),
						CurrentTextureNames = #(),
						ParsingTextureNames,
						CanRead = true,
						Parsing = true
				while Parsing do (
					ParsingTextureNames = false
					if CanRead then (
						local	RAWLine = (ReadVal BufferID),
								tLine = (TrimLeft (TrimRight RAWLine)),
								IsLineValid = (ValidateGTAString tLine)
						if IsLineValid then (
							ParsingTextureNames = (IsSpace RAWLine[1])
							if ParsingTextureNames then (
								if CurrentModelNames.Count != 0 then
									Append CurrentTextureNames (TypeCast tLine Name)
							)
						)
					) else
						Parsing = false
					if not ParsingTextureNames then (
						if
							CurrentModelNames.Count != 0 and
							CurrentTextureNames.Count != 0
						then (
							for CurrentModelName in CurrentModelNames do (
								local	AppendResult = (AppendIfUniq Models (TypeCast CurrentModelName Name) GetFlagWithID:true Sorted:false),
										Added = AppendResult[1],
										ItemID = AppendResult[2],
										CurrentModelTextures, CurrentModelNSTextures
								if Added then (
									CurrentModelTextures = (Textures[ItemID] = #())
									CurrentModelNSTextures = (NSTextures[ItemID] = #())
								) else (
									CurrentModelTextures = Textures[ItemID]
									CurrentModelNSTextures = NSTextures[ItemID]							
								)
								for TexName in CurrentTextureNames do (
									local	TargetArray = (
												if (MatchPattern TexName Pattern:NormalMapPattern) then
													CurrentModelNSTextures
												else
													CurrentModelTextures
											),
											NameID = (FindItem TargetArray TexName)
									if NameID == 0 then
										InsertItem TexName TargetArray 1
									else (
										if NameID != 1 then
											Swap TargetArray[NameID] TargetArray[1]
									)
								)
							)
							Free CurrentTextureNames
							Free CurrentModelNames
						)
						if IsLineValid then
							Append CurrentModelNames (TypeCast tLine Name)
					)
					CanRead = (NotEOF BufferID)
				)
				BufferMgr.ClearBuffer BufferID
				ArrayOps.QuickSort ModelTextureMap MHL:true MHLKeyItemID:1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadShipModelMap ShipModelMapFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ExcludeMark = "-",
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						NotEOF = BufferMgr.NotEOF,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						ValidateGTAString = GIMS.Core.StringOps.ValidateGTAString,
						BufferID = (BufferMgr.ReadFile ShipModelMapFile),
						LineCount = BufferMgr.Sizes[BufferID],
						MaxID = 0,
						ShipModelMapSize = ShipModelMap.Count
				for i = 1 to ShipModelMapSize do
					ShipModelMap[i].Count = LineCount
				while (NotEOF BufferID) do (
					local	tLine = (TrimRight (TrimLeft (ReadVal BufferID)))
					if (ValidateGTAString tLine) then (
						local	LineParams = (FilterString tLine "\t")
						if LineParams.Count > 2 then (
							local	ID = ((TypeCast LineParams[1] Integer) + 1)
							ShipModelMap[1][ID] = LineParams[2]
							for i = 3 to LineParams.Count do (
								local	Item = LineParams[i]
								if Item != ExcludeMark then
									ShipModelMap[i - 1][ID] = (TypeCast Item Name)
							)
							if ID > MaxID then
								MaxID = ID
						)
					)
				)
				for i = 1 to ShipModelMapSize do
					ShipModelMap[i].Count = MaxID
				BufferMgr.ClearBuffer BufferID
				ShipModelMap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadStationModelMap StationModelMapFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ExcludeMark = "-",
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						NotEOF = BufferMgr.NotEOF,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						ValidateGTAString = GIMS.Core.StringOps.ValidateGTAString,
						BufferID = (BufferMgr.ReadFile StationModelMapFile),
						LineCount = BufferMgr.Sizes[BufferID],
						MaxID = 0,
						StationModelMapSize = StationModelMap.Count
				for i = 1 to StationModelMapSize do
					StationModelMap[i].Count = LineCount
				while (NotEOF BufferID) do (
					local	tLine = (TrimRight (TrimLeft (ReadVal BufferID)))
					if (ValidateGTAString tLine) then (
						local	LineParams = (FilterString tLine "\t"),
								ParamCount = LineParams.Count
						if ParamCount > 1 then (
							local	ID = ((TypeCast LineParams[1] Integer) + 1),
									Models = #(),
									ModelID = 0
							StationModelMap[1][ID] = LineParams[2]
							Models.Count = (ParamCount - 1)
							for i = 3 to ParamCount do (
								local	Item = LineParams[i]
								if Item != ExcludeMark then (
									ModelID += 1
									Models[ModelID] = (TypeCast Item Name)
								)
							)
							Models.Count = ModelID
							StationModelMap[2][ID] = Models
							if ID > MaxID then
								MaxID = ID
						)
					)
				)
				for i = 1 to StationModelMapSize do
					StationModelMap[i].Count = MaxID
				BufferMgr.ClearBuffer BufferID
				StationModelMap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadRGBAlphaTextures RGBAlphaTexturesFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						NotEOF = BufferMgr.NotEOF,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						QuickSort = GIMS.Core.ArrayOps.QuickSort,
						ValidateGTAString = GIMS.Core.StringOps.ValidateGTAString,
						BufferID = (BufferMgr.ReadFile RGBAlphaTexturesFile),
						LineCount = BufferMgr.Sizes[BufferID],
						SectionCount = RGBAlphaTextures.Count,
						SectionNames = #(
							(TypeCast "<FULL>" Name),
							(TypeCast "<WILDCARD>" Name)
						),
						SectionSizes = #(),
						CurrentSectionID
				for SectionID = SectionCount to 1 by -1 do (
					RGBAlphaTextures[SectionID].Count = LineCount
					SectionSizes[SectionID] = 0
				)
				while (NotEOF BufferID) do (
					local	tLine = (TrimRight (TrimLeft (ReadVal BufferID)))
					if (ValidateGTAString tLine) then (
						local	ParamName = (TypeCast tLine Name)
						case ParamName of (
							(SectionNames[1]):
								CurrentSectionID = 1
							(SectionNames[2]):
								CurrentSectionID = 2
							Default: (
								if Have CurrentSectionID then (
									local	NewItemID = (SectionSizes[CurrentSectionID] += 1)
									RGBAlphaTextures[CurrentSectionID][NewItemID] = (
										if CurrentSectionID == 1 then
											ParamName
										else
											tLine
									)
								)
							)
						)
					)
				)
				for SectionID = 1 to SectionCount do
					RGBAlphaTextures[SectionID].Count = SectionSizes[SectionID]
				QuickSort RGBAlphaTextures[1]
				RGBAlphaTextures
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
				ModelTextureMap = (ReadCached GameMgr.ModelTextureMapFile ThisObj.LoadModelTextureMap Type:"ModelTextureMap" IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				ShipModelMap = (ReadCached GameMgr.ShipModelMapFile ThisObj.LoadShipModelMap Type:"ShipModelMap" IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				StationModelMap = (ReadCached GameMgr.StationModelMapFile ThisObj.LoadStationModelMap Type:"StationModelMap" IgnoreBehavior:true)
				UpdateProgress #AddStage 1
				RGBAlphaTextures = (ReadCached GameMgr.RGBAlphaTexturesFile ThisObj.LoadRGBAlphaTextures Type:"RGBAlphaTextures" IgnoreBehavior:true)
				Loaded = true
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
