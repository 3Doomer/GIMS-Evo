/*#PC*DEFINE	CurrentGame	Shared*/
global	EGIMS_SetModRules,
		EGIMS_SetLocks,
		EGIMS_VPRedrawCallback
(

/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.SceneOps*/strSceneOps (
		/*SHORTCUTS*/
			TypeLibrary, FormatText, GetPathString, AddResult, UpdateProgress, TypeCast,
		/*OPS*/
		fn CheckPointInFrustrum PointPos = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	thePos = (pointPos * (Viewport.GetTM())),
						vpsize = (GetViewSize()),
						vpsizex = vpsize.x,
						vpsizey = vpsize.y,
						thePosz = thePos.z,
						screen_origin = (MapScreenToView [0,0] thePosz),
						end_screen = (MapScreenToView vpsize thePosz),
						world_size = (screen_origin - end_screen),
						x_aspect = (vpsizex / (Abs world_size.x)),
						y_aspect = (vpsizey / (Abs world_size.y)),
						screen_coordx = (x_aspect * (thePos.x - screen_origin.x)),
						screen_coordy = (-(y_aspect * (thePos.y - screen_origin.y)))
				(
					(screen_coordx > 0) and
					(screen_coordx < vpsizex) and
					(screen_coordy > 0) and
					(screen_coordy < vpsizey)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetSectorCoords Pos SectorSize WorldSize:3000 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				[ \
					(Floor ((Pos.x + WorldSize) / SectorSize)), \
					(Floor ((Pos.y + WorldSize) / SectorSize)) \
				]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetObjTypeInfo ExportFilter Obj TypeFilter = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParamSource = Obj,
						Mods = Obj.Modifiers,
						FilterID = 0,
						ExportFilterObjects = ExportFilter[2],
						ParamSourceClass = (ClassOf ParamSource),
						TypeID
				--if Mods.Count == 0 then (
					TypeID = (FindItem TypeFilter ParamSourceClass)
					if TypeID != 0 then
						FilterID = (FindItem ExportFilterObjects ParamSourceClass)
				--) else (
					local	TypeFilterCount = TypeFilter.Count,
							ModFilterID = 0
					for TempFilterID = 1 to TypeFilterCount while ModFilterID == 0 do (
						local	TempFilter = TypeFilter[TempFilterID]
						if (IsKindOf TempFilter Name) then (
							local	TempMod
							for tMod in Mods where ((TypeCast ((ClassOf tMod) as String) Name) == TempFilter) while No TempMod do
								TempMod = tMod
							if Have TempMod then (
								ParamSource = TempMod
								ModFilterID = (FindItem ExportFilterObjects TempFilter)
								TypeID = TempFilterID
							)
						)
					)
					if ModFilterID != 0 then
						FilterID = ModFilterID
				--)
				if FilterID != 0 then
					#(FilterID, ParamSource, TypeID)
				else
					#(undefined, ParamSourceClass, TypeID)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetObjsByFilter ExportFilter TypeFilter ChildArray = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Objs = #(),
						ChildrenExportFilter = ExportFilter[3],
						CollectionNode = TypeLibrary.CollectionNode
				for Obj in ChildArray where not Obj.IsFrozen do (
					UpdateProgress #None undefined
					local	ObjTypeInfo = (GetObjTypeInfo ExportFilter Obj TypeFilter),
							ObjFilterID = ObjTypeInfo[1]
					if Have ObjFilterID then (
						local	NewObj = (CollectionNode Obj:Obj ParamSource:ObjTypeInfo[2]),
								FilterData = ChildrenExportFilter[ObjFilterID]
						if Have FilterData then
							NewObj.Children = (GetObjsByFilter ExportFilter FilterData Obj.Children)
						Append Objs NewObj
					) else (
						if Have Obj.Parent then (
							AddResult #Warning (
								FormatText \
									v1:"Object \"" \
									v2: (GetPathString Obj) \
									v3:"\" with type " \
									v4:ObjTypeInfo[2] \
									v5:" isn't allowed in current hierarchy, and won't be exported.\nMay be, you've forgot to add or remove some modifiers?"
							)
						)
					)
				)
				Objs
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetObjsToExport = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Objs = #(),
						ExportFilter = GIMS.CurrentGame.Rules.ExportFilter,
						TypeFilter = ExportFilter[1],
						ChildrenExportFilter = ExportFilter[3],
						ChainIndices = ExportFilter[4],
						ChainSize = ChainIndices[1],
						CollectionNode = TypeLibrary.CollectionNode,
						RootObjs = RootNode.Children
				for i = ChainIndices.Count to 2 by -1 do (
					local	ChainIndex = ChainIndices[i]
					if ChainIndex > ChainSize then
						ChainSize = ChainIndex
				)
				for ChainIndex = 1 to ChainSize do (
					for Obj in RootObjs where not Obj.IsFrozen do (
						UpdateProgress #None undefined
						local	ObjTypeInfo = (GetObjTypeInfo ExportFilter Obj TypeFilter),
								ObjFilterID = ObjTypeInfo[1]
						if
							Have ObjFilterID and
							ChainIndices[ObjTypeInfo[3]] == ChainIndex
						then (
							local	NewObj = (CollectionNode Obj:Obj ParamSource:ObjTypeInfo[2]),
									FilterData = ChildrenExportFilter[ObjFilterID]
							if Have FilterData then
								NewObj.Children = (GetObjsByFilter ExportFilter FilterData Obj.Children)
							Append Objs NewObj
						)
					)
				)
				Objs
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory.MaterialOps*/strMaterialOps (
		fn UpdateMapButton ControlRollout MapControl Map = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if
					ControlRollout.Open or
					ControlRollout.isDisplayed
				then (
					local	FileName = (
								if Have Map then (
									try
										Map.FileName
									catch
										"*ERROR*"
								)
							)
					if Have FileName then (
						MapControl.Caption = (FileNameFromPath FileName)
						MapControl.Tooltip = FileName
					) else
						MapControl.Caption = (MapControl.Tooltip = "Empty")
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn UpdateMapButtons ControlRollout MapControls Maps = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MapCount = Maps.Count
				if MapControls.Count != MapCount then
					throw "Control and map counts aren't equal"
				if ControlRollout.Open then (
					for MapID = 1 to MapCount do
						UpdateMapButton ControlRollout MapControls[MapID] Maps[MapID]
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AlterProperty Mtl PropertyName Val ControlRollout:unsupplied MapControl:unsupplied IsMap:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				SetProperty Mtl PropertyName Val
				if
					Supplied ControlRollout and
					Supplied MapControl and
					IsMap
				then
					UpdateMapButton ControlRollout MapControl Val
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn OpenMap Mtl Map PropertyName ControlRollout:unsupplied MapControl:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local FileName = (
							if Have Map then (
								try
									Map.FileName
								catch
									"Empty"
							)
						),
						TheBMP = (SelectBitMap FileName:FileName Caption:"Select the texture file"),
						NewMap
				if Have TheBMP then (
					NewMap = (
						try
							(BitmapTexture Bitmap:TheBMP)
						catch
							undefined
					)
					if Have PropertyName then (
						AlterProperty Mtl PropertyName NewMap ControlRollout:ControlRollout MapControl:MapControl IsMap:true
					) else
						UpdateMapButton ControlRollout MapControl NewMap
				)
				NewMap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetMapControllers Mtl Map AllowOpacity:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Map.ClipU.Controller = Mtl.U_Offset.Controller
				Map.ClipV.Controller = Mtl.V_Offset.Controller
				Map.ClipW.Controller = Mtl.U_Tiling.Controller
				Map.ClipH.Controller = Mtl.V_Tiling.Controller
				Map.Coords.U_Offset.Controller = Mtl.U_Offset.Controller
				Map.Coords.V_Offset.Controller = Mtl.V_Offset.Controller
				Map.Coords.U_Tiling.Controller = Mtl.U_Tiling.Controller
				Map.Coords.V_Tiling.Controller = Mtl.V_Tiling.Controller
				if AllowOpacity then
					Map.Output.Output_Amount.Controller = Mtl.Opacity.Controller
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn UpdateThumbnail MatList Mtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MtlID = MatList.MtlID
				if
					Have MtlID and
					MtlID != 0
				then (
					local	TheObj = MatList.TheObj
					if
						Have TheObj
					then (
						local	Mtl = TheObj.Material
						if Mtl.MaterialList[MtlID] == Mtl then
							MatList.UpdateThumbnail MtlID
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn HandleMapChanged Mtl Map AllowOpacityMapController:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FileName = (if Have Map then (try Map.FileName catch ())),
						ResultMap, ResultAlphaMap
				if Have FileName then (
					Map.Coords.RealWorldScale = false
					Map.PreMultAlpha = false
					Map.AlphaSource = 2
					SetMapControllers Mtl Map
					if
						(DoesFileExist FileName) and (
							try
								Map.Bitmap.HasAlpha
							catch
								false
						)
					then (
						local	ResultAlphaMap = (Copy Map)
						ResultAlphaMap.AlphaSource = 0
						ResultAlphaMap.MonoOutput = 1
						ResultAlphaMap.RGBOutput = 1
						SetMapControllers Mtl ResultAlphaMap AllowOpacity:AllowOpacityMapController
					)
					ResultMap = Map
				)
				#(ResultMap, ResultAlphaMap)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ResetUV Mtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				AlterProperty Mtl #U_Offset 0
				AlterProperty Mtl #V_Offset 0
				AlterProperty Mtl #U_Tiling 1
				AlterProperty Mtl #V_Tiling 1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		),
		fn InitUV Mtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Mtl.Opacity.Controller = (Mtl.Delegate.Opacity.Controller = (Linear_Float()))
				Mtl.U_Offset.Controller = (Linear_Float())
				Mtl.V_Offset.Controller = (Linear_Float())
				Mtl.U_Tiling.Controller = (Linear_Float())
				Mtl.V_Tiling.Controller = (Linear_Float())
				AlterProperty Mtl #U_Offset 0
				AlterProperty Mtl #V_Offset 0
				AlterProperty Mtl #U_Tiling 1
				AlterProperty Mtl #V_Tiling 1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		),
		fn GetStandartized Mtl NeedMultiMtl:true DoOwnProgress:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						QuickSort = GIMS.Core.ArrayOps.QuickSort
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
					Standard: (
						NewMtl = (GIMS.Core.ValueOps.ConvertStruct Mtl Standard PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:true)
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					Default: (
						local	NewMtl = (
									if No Mtl then
										Standard ShowInViewport:true
									else (
										local	MatDelegate = (try Mtl.Delegate	catch())
										if
											Have MatDelegate and
											(IsKindOf MatDelegate Standard)
										then
											GetStandartized MatDelegate NeedMultiMtl:false
										else
											GIMS.Core.ValueOps.ConvertStruct Mtl Standard PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false
									)
								)
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.MAXFactory*/strMAXFactory (
		SceneOps = (strSceneOps()),
		MaterialOps = (strMaterialOps())
	)
	GIMS.CurrentGame.Core.MAXFactory = strMAXFactory()
	UnRegisterRedrawViewsCallback EGIMS_VPRedrawCallback
	fn EGIMS_VPRedrawCallback = (
		/*<ERRHANDLERSTART>*/try (
			local	Result = (Have GIMS)
			if Result then (
				Result = (
					Have GIMS.Shared and
					GIMS.Shared.Loaded
				)
			)
			if Result then (
				local	GUI = GIMS.Core.GUI
				if Have GUI then (
					local	SelectedAreaStart = GUI.SelectedAreaStart,
							SelectedAreaEnd = GUI.SelectedAreaEnd
					if
						GUI.SelectingArea and
						Have SelectedAreaStart and
						Have SelectedAreaEnd
					then (
						local	X1 = SelectedAreaStart.x,
								Y1 = SelectedAreaStart.y,
								X2 = SelectedAreaEnd.x,
								Y2 = SelectedAreaEnd.y
						GW.SetColor #Line Green
						GW.Polyline #([X1, Y1, 0], [X2, Y1, 0], [X2, Y2, 0], [X1, Y2, 0]) true
						GW.EnlargeUpdateRect #Whole
						GW.UpdateScreen()
					)
				) else
					UnRegisterRedrawViewsCallback EGIMS_VPRedrawCallback
			) else
				UnRegisterRedrawViewsCallback EGIMS_VPRedrawCallback
		/*<ERRHANDLER>*/) catch (
			UnRegisterRedrawViewsCallback EGIMS_VPRedrawCallback
			try (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
			) catch
				throw
		)/*<ERRHANDLEREND>*/
		OK
	)
	RegisterRedrawViewsCallback EGIMS_VPRedrawCallback
	Callbacks.RemoveScripts #SceneNodeAdded ID:#EGIMS_SetLocks
	fn EGIMS_SetLocks = (
		/*SetTransformLockFlags Obj #{}*/
		/*	1	POS_X		2	POS_Y		3	POS_Z*/
		/*	4	ROT_X		5	ROT_Y		6	ROT_Z*/
		/*	7	SCALE_X		8	SCALE_Y		9	SCALE_Z*/
		/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
		/*<ERRHANDLERSTART>*/try (
			local	Obj = (Callbacks.NotificationParam()),
					ObjClass = (ClassOf Obj.BaseObject),
					Flags = (
						case ObjClass of (
							EGIMS_GUI_Item: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								4, /*ROT_X*/
								5, /*ROT_Y*/
								6, /*ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_GUI_Layout: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								4, /*ROT_X*/
								5, /*ROT_Y*/
								6, /*ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_Dummy: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_AE_Model: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_AE_Collision: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_AE_CollisionNode: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_AE_Col_Box: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_AE_Col_Sphere: #{
								/*1	, POS_X*/
								/*2, POS_Y*/
								/*3, POS_Z*/
								/*4, ROT_X*/
								/*5, ROT_Y*/
								/*6, ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
							EGIMS_V_MapHelper: #{
								1, /*POS_X*/
								2, /*POS_Y*/
								3, /*POS_Z*/
								4, /*ROT_X*/
								5, /*ROT_Y*/
								6, /*ROT_Z*/
								7, /*SCALE_X*/
								8, /*SCALE_Y*/
								9}/*SCALE_Z*/
						)
					)
			if Have Flags then (
				SetTransformLockFlags Obj Flags
				Free Flags
			)
		/*<ERRHANDLER>*/) catch (
			Callbacks.RemoveScripts #SceneNodeAdded ID:#EGIMS_SetLocks
			try (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
			) catch
				throw
		)/*<ERRHANDLEREND>*/
		/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		OK
	)
	Callbacks.AddScript #SceneNodeAdded "EGIMS_SetLocks()" ID:#EGIMS_SetLocks
	Callbacks.RemoveScripts #postModifierAdded ID:#EGIMS_SetModRules
	fn EGIMS_SetModRules = (
		/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
		/*<ERRHANDLERSTART>*/try (
			local	Params = (Callbacks.NotificationParam()),
					tObj = Params[1],
					tMod = Params[2]
			if Have tObj then (
				local	ObjClass = (ClassOf tObj.BaseObject),
						ModClass = (ClassOf tMod),
						Failed = false,
						ObjectMgr, AddResult, CheckResult, GetPathString, ExchangeData,
						CanCallMetro = (
							try (
								SystemMgr = GIMS.Core.SystemMgr
								ObjectMgr = GIMS.Core.ObjectMgr
								AddResult = SystemMgr.AddResult
								CheckResult = SystemMgr.CheckResult
								GetPathString = ObjectMgr.GetPathString
								ExchangeData = ObjectMgr.ExchangeData
								true
							) catch
								false
						)
				case ModClass of (
					EGIMS_V_CollisionMesh: (
						if
							ObjClass != Editable_Mesh and
							ObjClass != Editable_Poly and
							not (TryAccess tObj #Edit_Mesh) and
							not (TryAccess tObj #Edit_Poly)
						then (
							local	ErrTxt = "Collision Mesh modifier can be applied only to an Editable Mesh/Poly, got:\n\t"
							Append ErrTxt (ObjClass as String)
							Append ErrTxt " : "
							if CanCallMetro then
								Append ErrTxt (GetPathString tObj Shorten:true)
							else
								Append ErrTxt (tObj as String)
							if CanCallMetro then
								AddResult #Error ErrTxt
							else
								MessageBox ErrTxt Title:"GIMS V modifier"
							Failed = true
						)
					)
					EGIMS_MP3_ModelMesh: (
						if
							ObjClass == EGIMS_MP3_ModelMesh or (
								ObjClass != Editable_Mesh and
								ObjClass != Editable_Poly and
								not (TryAccess tObj #Edit_Mesh) and
								not (TryAccess tObj #Edit_Poly)
							)
						then (
							local	ErrTxt = "Model Mesh modifier can be applied only to an Editable Mesh/Poly, got:\n\t"
							Append ErrTxt (ObjClass as String)
							Append ErrTxt " : "
							if CanCallMetro then
								Append ErrTxt (GetPathString tObj Shorten:true)
							else
								Append ErrTxt (tObj as String)
							if CanCallMetro then
								AddResult #Error ErrTxt
							else
								MessageBox ErrTxt Title:"GIMS MP3 modifier"
							Failed = true
						)
					)
					EGIMS_MP3_Model_BoneMod: (
						if ObjClass == EGIMS_MP3_Model_Bone then (
							if CanCallMetro then
								AddResult #Error "Model Bone modifier can't be applied to a Model Bone."
							else
								MessageBox "Model Bone modifier can't be applied to a Model Bone." Title:"GIMS MP3 modifier"
							Failed = true
						)
					)
					EGIMS_MP3_Model_LightMod: (
						if
							ObjClass == EGIMS_MP3_Model_Light or (
								ObjClass != targetSpot and
								ObjClass != freeSpot and
								ObjClass != Omnilight
							)
						then (
							local	ErrTxt = "Model Light modifier can be applied only to an Omni\Spot light, got:\n\t"
							Append ErrTxt (ObjClass as String)
							Append ErrTxt " : "
							if CanCallMetro then
								Append ErrTxt (GetPathString tObj Shorten:true)
							else
								Append ErrTxt (tObj as String)
							if CanCallMetro then
								AddResult #Error ErrTxt
							else
								MessageBox ErrTxt Title:"GIMS MP3 modifier"
							Failed = true
						) else
							tMod.Init tObj.BaseObject
					)
					EGIMS_V_ModelMesh: (
						if
							ObjClass == EGIMS_V_ModelMesh or (
								ObjClass != Editable_Mesh and
								ObjClass != Editable_Poly and
								not (TryAccess tObj #Edit_Mesh) and
								not (TryAccess tObj #Edit_Poly)
							)
						then (
							local	ErrTxt = "Model Mesh modifier can be applied only to an Editable Mesh/Poly, got:\n\t"
							Append ErrTxt (ObjClass as String)
							Append ErrTxt " : "
							if CanCallMetro then
								Append ErrTxt (GetPathString tObj Shorten:true)
							else
								Append ErrTxt (tObj as String)
							if CanCallMetro then
								AddResult #Error ErrTxt
							else
								MessageBox ErrTxt Title:"GIMS V modifier"
							Failed = true
						)
					)
					EGIMS_V_Model_BoneMod: (
						if ObjClass == EGIMS_V_Model_Bone then (
							if CanCallMetro then
								AddResult #Error "Model Bone imposter can't be applied to a Model Bone."
							else
								MessageBox "Model Bone imposter can't be applied to a Model Bone." Title:"GIMS V modifier"
							Failed = true
						)
					)
					EGIMS_V_Model_ModelMod: (
						if ObjClass == EGIMS_V_Model then (
							if CanCallMetro then
								AddResult #Error "Model imposter can't be applied to a Model node."
							else
								MessageBox "Model Bone imposter can't be applied to a Model node." Title:"GIMS V modifier"
							Failed = true
						)
					)
					EGIMS_V_Model_LightMod: (
						if
							ObjClass == EGIMS_V_Model_Light or (
								ObjClass != TargetDirectionallight and
								ObjClass != Directionallight and
								ObjClass != targetSpot and
								ObjClass != freeSpot and
								ObjClass != Omnilight
							)
						then (
							local	ErrTxt = "Model Light imposter can be applied only to an Omni\Spot\Directional light, got:\n\t"
							Append ErrTxt (ObjClass as String)
							Append ErrTxt " : "
							if CanCallMetro then
								Append ErrTxt (GetPathString tObj Shorten:true)
							else
								Append ErrTxt (tObj as String)
							if CanCallMetro then
								AddResult #Error ErrTxt
							else
								MessageBox ErrTxt Title:"GIMS V modifier"
							Failed = true
						) else
							tMod.Init tObj.BaseObject
					)
				)
				if
					Have ExchangeData and
					(IsKindOf ExchangeData Array) and
					ExchangeData[5] == true
				then
					CheckResult KeepLayout:true
				if Failed then
					DeleteModifier tObj tMod
			)
		/*<ERRHANDLER>*/) catch (
			Callbacks.RemoveScripts #postModifierAdded ID:#EGIMS_SetModRules
			try (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
			) catch
				throw
		)/*<ERRHANDLEREND>*/
		/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		OK
	)
	Callbacks.AddScript #postModifierAdded "EGIMS_SetModRules()" ID:#EGIMS_SetModRules
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
