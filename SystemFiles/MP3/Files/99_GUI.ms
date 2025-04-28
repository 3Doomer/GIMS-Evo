/*#PC*DEFINE	CurrentGame	MP3*/
(
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	(
		local	DialogsToDestroy = #(
					EGIMS_MP3_matlist,
					EGIMS_MP3_mateditor,
					EGIMS_MP3_BlendProps
				)
		for Dialog in DialogsToDestroy where Have Dialog do
			DestroyDialog Dialog
	)
	rollout EGIMS_MP3_BlendProps "Blend painter options" Width:250 (
		Spinner 	Radius			"Radius"		Type:#Float	Range:[0, 10000, EGIMS_MP3_matlist.Radius]	Width:100	Across:2
		Spinner		Strength		"Strength"	Type:#Float	Range:[0, 1, EGIMS_MP3_matlist.Strength]	Width:100
		Slider		TreeDepth		"Interaction speed"	Type:#Integer	Range:[2, 10, ThePainterInterface.TreeDepth]	Ticks:8	Width:235	Align:#Left
		Group "Viewport drawing" (
			CheckBox	DrawRing	"Ring"		Checked:ThePainterInterface.DrawRing	Across:2
			CheckBox	DrawNormal	"Normal"	Checked:ThePainterInterface.DrawNormal
			CheckBox	DrawTrace	"Trace"	Checked:ThePainterInterface.DrawTrace
		)
		on Radius Changed Val do (
			EGIMS_MP3_matlist.Radius = Val
			ThePainterInterface.MaxSize = Val
		)
		on Strength Changed Val do
			EGIMS_MP3_matlist.Strength = Val
		on TreeDepth Changed Val do
			ThePainterInterface.TreeDepth = Val
		on DrawRing Changed State do
			ThePainterInterface.DrawRing = State
		on DrawNormal Changed State do
			ThePainterInterface.DrawNormal = State
		on DrawTrace Changed State do
			ThePainterInterface.DrawTrace = State
	)
	rollout EGIMS_MP3_matlist "GIMS MP3 material editor" Width:350 Height:550 (
		local	TheObj, CpyMMtl, CpyMtl, CpyTexPath, MtlID, LastMtlID, PrevMtl,
				RC = #(),
				OnPreview = false,
				/*Painter options*/
				Radius = 2,
				Strength = 1,
				/*Material rollouts*/
				Padding = 5,
				ImageSize = [64, 64],
				AccentThickness = 3
				/**/
		Label ObjName "Unknown selection" Pos:[5,20] Align:#Left
		Button MMCopy "Copy" enabled:false across:5
		Button MMPaste "Paste" enabled:false
		Label lspc1 ""
		Button LibLoad "Import" enabled:false
		Button LibSave "Export" enabled:false
		SubRollout List Height:-1 Align:#Center
		CheckButton LockSh "Dock >" width:45 height:17 checked:true pos:[(GetDialogSize EGIMS_MP3_matlist).x - 45, 0] enabled:false
		Timer MtlAddTimer Interval:1 Active:false
		Timer MtlInitTimer Interval:1 Active:false

		fn UnifyMultimaterial Index:unsupplied = (
			local	TheMtlID
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				OldMtlID = (
					if Supplied Index then
						Index
					else
						MtlID
				)
				
				--create new mmtl
				local	TheObjMaterial = TheObj.Material
				TheObj.Material = ( \
					MultiMaterial \
						ShowInViewPort:true \
						Name:TheObjMaterial.Name \
						MaterialList:TheObjMaterial.MaterialList \
						MaterialIDList:TheObjMaterial.MaterialIDList \
						Names:TheObjMaterial.Names \
				)
				
				--wait for UI
				local	ProcessPostedMessages = GIMS.ProcessPostedMessages
				while (
					(No List.Rollouts[OldMtlID]) or
					MtlAddTimer.Active or
					MtlInitTimer.Active
				) do
					ProcessPostedMessages()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#MtlID, #LastMtlID, #OldMtlID), #(MtlID, LastMtlID, OldMtlID)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		fn OnMaterialChanged = (
			if (Callbacks.NotificationParam()) == TheObj then
				EGIMS_MP3_matlist.GetMaterialList()
		)
		fn EditMaterial DestroyEars:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if DestroyEars then (
					local	CurrentMtlID = MtlID
					DestroyDialog EGIMS_MP3_mateditor
					MtlID = CurrentMtlID
				)
				local	Result = true,
						TheObjMaterial = TheObj.Material,
						MaterialList = TheObjMaterial.MaterialList,
						CurrentMaterial = MaterialList[MtlID]
				if not (IsKindOf CurrentMaterial EGIMS_MP3_material) then (
					if (QueryBox "Unknown material type.\nConvert to Max Payne 3 material?" Title:"GIMS MP3 material editor") then (
						TheObjMaterial.MaterialList[MtlID] = (GIMS.MP3.Core.MAXFactory.MaterialOps.GetStandartized CurrentMaterial NeedMultiMtl:false)
						List.Rollouts[MtlID].Init MtlID
						EGIMS_MP3_matlist.UpdateThumbnail MtlID
						CurrentMaterial = MaterialList[MtlID]
					) else (
						Result = false
						if LastMtlID == MtlID then
							LastMtlID = 0
						EGIMS_MP3_matlist.SelectItem LastMtlID
					)
				)
				if Result then (
					List.Rollouts[MtlID].SetSelected true
					local WPos = (GetDialogPos EGIMS_MP3_matlist),
							Style = #(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
					CreateDialog EGIMS_MP3_mateditor Pos:[WPos.x + (GetDialogSize EGIMS_MP3_matlist).x + 20, WPos.y] Style:Style
					EGIMS_MP3_mateditor.TheObj = TheObj
					EGIMS_MP3_mateditor.TheMtl = CurrentMaterial
					EGIMS_MP3_mateditor.Init()
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SelectItem Index = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				DestroyDialog EGIMS_MP3_mateditor
				if Have TheObj then (
					local	TheObjMaterial = TheObj.Material
					if (IsKindOf TheObjMaterial MultiMaterial) then (
						local	MatCount = TheObjMaterial.MaterialList.Count,
						LastMtlID = MtlID
						MtlID = Index
						if
							LastMtlID != 0 and
							LastMtlID <= MatCount
						then
							List.Rollouts[LastMtlID].SetSelected false
						if MtlID > MatCount then (
							MtlID = MatCount
							LastMtlID = 0
							SelectItem MtlID
						) else (
							if MtlID != 0 then
								EditMaterial()
							else
								false
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateThumbnail Index Preview:false = (
			local	CurrentRenderer = Renderers.Current
			Renderers.Current = Renderers.Medit
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_SuspendMAX()
				Callbacks.RemoveScripts #SelectionSetChanged id:#EGIMS_MP3_matlist_GetMaterial
				Callbacks.RemoveScripts #NodePostMaterial id:#EGIMS_MP3_matlist_OnMaterialChanged
				local	LightStateFlagHolders = #(),
						LightStates = #(),
						SceneLightCount = 0
				LightStateFlagHolders.Count = (LightStates.Count = Lights.Count)
				for tLight in Lights do (
					local	IsLightOn = false,
							LightStateFlagHolder
					if not (IsKindOf tLight TargetObject) then (
						LightStateFlagHolder = (
							try
								tLight.Delegate
							catch
								tLight
						)
						IsLightOn = (
							try
								LightStateFlagHolder.On
							catch
								false
						)
					)
					if IsLightOn then (
						SceneLightCount += 1
						LightStateFlagHolders[SceneLightCount] = LightStateFlagHolder
						LightStates[SceneLightCount] = LightStateFlagHolder.On
						LightStateFlagHolder.on = false
					)
				)
				LightStateFlagHolders.Count = SceneLightCount
				LightStates.Count = SceneLightCount
				local	OldShownObjects = #(),
						OldSelection = (Selection as array),
						OldShownObjectCount = 0
				OldShownObjects.Count = Objects.Count
				for Obj in Objects where not Obj.IsHidden do (
					OldShownObjectCount += 1
					OldShownObjects[OldShownObjectCount] = Obj
				)
				OldShownObjects.Count = OldShownObjectCount
				ClearSelection()
				Hide Objects
				local	MaterialList = TheObj.Material.MaterialList,
						Rollouts = List.Rollouts,
						Indices = (
							if Index == #All then
								#{1..MaterialList.Count}
							else
								#{Index}
						),
						CamTarget = (TargetObject()),
						Cam = (TargetCamera Pos:[0.0, -65, 30.0] Target:CamTarget),
						CamDir = Cam.Dir,
						Sample = (GeoSphere Pos:[0.0, 0.0, 0.0] Radius:25 Segments:(if Preview then 10 else 5) BaseType:2 MapCoords:true RealWorldMapSize:false WireColor:White),
						BGPlane = (Plane Dir:CamDir Pos:(CamDir * (-25)) Width:80.02 Length:80.02 WidthSegs:1 LengthSegs:1 MapCoords:true RealWorldMapSize:false WireColor:White),
						RenderLights = #(
							(OmniLight Pos:[-100.0, -100.0, 300.0] Multiplier:1.0),
							(OmniLight Pos:[50.0, 0.0, -100.0] Multiplier:1.0)
						)
				if Preview then (
					for MatID in Indices do (
						local	CurrentMtl = MaterialList[MatID],
								HaveCurrentMtl = (Have CurrentMtl),
								ShowInViewport
						if HaveCurrentMtl then (
							ShowInViewport = CurrentMtl.ShowInViewport
							CurrentMtl.ShowInViewport = true
						)
						BGPlane.Material = CurrentMtl
						Sample.Material = CurrentMtl
						local	TheBMP = (Render Camera:Cam OutputWidth:512 OutputHeight:512 VFB:Preview Quiet:true)
						if HaveCurrentMtl then
							CurrentMtl.ShowInViewport = ShowInViewport
					)
				) else (
					for MatID in Indices do (
						local	MapSlot = Rollouts[MatID].MaterialBMP,
								CurrentMtl = MaterialList[MatID],
								HaveCurrentMtl = (Have CurrentMtl),
								ShowInViewport
						if HaveCurrentMtl then (
							ShowInViewport = CurrentMtl.ShowInViewport
							CurrentMtl.ShowInViewport = true
						)
						BGPlane.Material = CurrentMtl
						Sample.Material = CurrentMtl
						local	TheBMP = (Render Camera:Cam OutputWidth:MapSlot.Width OutputHeight:MapSlot.Height VFB:Preview Quiet:true)
						if HaveCurrentMtl then
							CurrentMtl.ShowInViewport = ShowInViewport
						MapSlot.BitMap = TheBMP
					)
				)
				Delete Cam
				Delete Sample
				Delete BGPlane
				Delete RenderLights
				UnHide OldShownObjects
				Select OldSelection
				for LightID = 1 to LightStateFlagHolders.count do
					LightStateFlagHolders[LightID].On = LightStates[LightID]
				Callbacks.AddScript #selectionSetChanged "EGIMS_MP3_matlist.GetMaterialList()" ID:#EGIMS_MP3_matlist_GetMaterial
				Callbacks.AddScript #NodePostMaterial "EGIMS_MP3_matlist.OnMaterialChanged()" ID:#EGIMS_MP3_matlist_OnMaterialChanged
				EGIMS_ResumeMAX()
			/*<ERRHANDLER>*/) catch (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			Renderers.Current = CurrentRenderer
			OK
		)
		fn DeleteMaterial Index = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TheObjMaterial = TheObj.Material,
						MaterialList = TheObjMaterial.MaterialList,
						MaterialIDList = TheObjMaterial.MaterialIDList,
						MapEnabled = TheObjMaterial.MapEnabled,
						Names = TheObjMaterial.Names,
						Rollouts = List.Rollouts
				for i = Index to (MaterialList.Count - 1) do (
					local	NextIndex = (i + 1)
					Swap MaterialList[i] MaterialList[NextIndex]
					Swap MaterialIDList[i] MaterialIDList[NextIndex]
					Swap MapEnabled[i] MapEnabled[NextIndex]
					Swap Names[i] Names[NextIndex]
					Rollouts[i].Init i
					UpdateThumbnail i
				)
				RemoveSubRollout List Rollouts[Rollouts.Count]
				MaterialList.Count -= 1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn InitMatRollout Index = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MaterialRolloutName = (GIMS.MP3.Core.GUI.MaterialRolloutName + (Index as String)),
						MaterialRollout = (Execute MaterialRolloutName)
				if Have MaterialRollout then
					MaterialRollout.Init Index
				else
					throw (Append "Can't find material rollout " MaterialRolloutName)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn AddMatRollout Index = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MaterialRolloutName = (GIMS.MP3.Core.GUI.MaterialRolloutName + (Index as String)),
						MaterialRollout = (Execute MaterialRolloutName)
				if Have MaterialRollout then (
					MaterialRollout.Open = false
					MaterialRollout.TheObj = undefined
					MaterialRollout.Title = "...loading..."
				) else (
					local	MaterialRolloutCode = (StringStream "")
					Format GIMS.MP3.Core.GUI.MaterialRolloutCode Index Index Index Index Index To:MaterialRolloutCode
					MaterialRollout = (Execute (MaterialRolloutCode as String))
					Free MaterialRolloutCode
				)
				if not MaterialRollout.isDisplayed then
					AddSubRollout List MaterialRollout
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn LoadList = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				MtlAddTimer.Ticks = 0
				MtlAddTimer.Active = true
				MtlInitTimer.Ticks = 0
				MtlInitTimer.Active = true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn ClearList = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Rollouts = List.Rollouts
				for i = Rollouts.Count to 1 by -1 do
					RemoveSubRollout List Rollouts[i]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateHeader = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Have TheObj then (
					local	MatCount = TheObj.Material.MaterialList.Count
					ObjName.Text = (
						case MatCount of (
							0: (
								GIMS.Core.ValueOps.FormatText \
									v1:"\"" \
									v2:TheObj.Name \
									v3:"\" - no materials"
							)
							1: (
								GIMS.Core.ValueOps.FormatText \
									v1:"\"" \
									v2:TheObj.Name \
									v3:"\" - 1 material"
							)
							default: (
								GIMS.Core.ValueOps.FormatText \
									v1:"\"" \
									v2:TheObj.Name \
									v3:"\" - " \
									v4:MatCount \
									v5:" materials"
							)
						)
					)
				) else
					ObjName.text = "Unknown selection"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn FixGUI = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				List.Width = ((GetDialogSize EGIMS_MP3_matlist).x - (Padding * 2))
				List.Pos.x = Padding
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn IsObjectAcceptable Obj = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				(
					(IsKindOf Obj Editable_Poly) or
					(IsKindOf Obj Editable_Mesh) or
					(IsKindOf Obj.BaseObject Editable_Poly) or
					(IsKindOf Obj.BaseObject Editable_Mesh) or
					(Have Obj.Modifiers[#Edit_Poly]) or
					(Have Obj.Modifiers[#Edit_Mesh])
				) and
				(TryAccess Obj #Mesh)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#MtlID, #LastMtlID), #(MtlID, LastMtlID)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetMaterialList = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				MtlAddTimer.Active = false
				MtlInitTimer.Active = false
				FixGUI()
				if EGIMS_MP3_BlendEditor.OnBlend then
					EGIMS_MP3_BlendEditor.BrakePaint()
				if EGIMS_MP3_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
				DestroyDialog EGIMS_MP3_mateditor
				local	Result = false
				if Selection.Count == 1 then
					Result = (IsObjectAcceptable $)
				ClearList()
				if Result then (
					MMCopy.Enabled = true
					MMPaste.Enabled = true
					LibSave.Enabled = true
					LibLoad.Enabled = true
					TheObj = $
					MtlID = 0
					LastMtlID = 0
					if (ClassOf TheObj.Material) != MultiMaterial then (
						TheObj.Material = (
							MultiMaterial \
							ShowInViewPort:true \
							Name:TheObj.Name \
							Material:#(TheObj.Material) \
							Names:#(
								if Have TheObj.Material then
									TheObj.Material.Name
								else
									"EMPTY"
							) \
						)
					)
					LoadList()
				) else (
					MMCopy.Enabled = false
					MMPaste.Enabled = false
					LibSave.Enabled = false
					LibLoad.Enabled = false
					TheObj = undefined
				)
				UpdateHeader()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on MtlInitTimer Tick do (
			try (
				local	Ticks = MtlInitTimer.Ticks
				if Ticks != 0 then (
					if not MtlAddTimer.Active then (
						if Ticks > TheObj.Material.MaterialList.Count then
							MtlInitTimer.Active = false
						else
							InitMatRollout Ticks
					) else
						MtlInitTimer.Ticks -= 1
				) else
					MtlInitTimer.Ticks -= 1
			) catch (
				MtlInitTimer.Active = false
				/*<ERRHANDLER>*/local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true/*<ERRHANDLEREND>*/
			)
			OK
		)
		on MtlAddTimer Tick do (
			try (
				local	Ticks = MtlAddTimer.Ticks
				if Ticks > TheObj.Material.MaterialList.Count then
					MtlAddTimer.Active = false
				else
					AddMatRollout Ticks
			) catch (
				MtlAddTimer.Active = false
				/*<ERRHANDLER>*/local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true/*<ERRHANDLEREND>*/
			)
			OK
		)
		on MMCopy pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if
					Have TheObj and
					not (IsDeleted TheObj)
				then
					CpyMMtl = TheObj.Material
				else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#MtlID, #LastMtlID), #(MtlID, LastMtlID)) NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on MMPaste pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if
					Have TheObj and
					not (IsDeleted TheObj)
				then (
					TheObj.Material = CpyMMtl
					GetMaterialList()
				) else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#MtlID, #LastMtlID), #(MtlID, LastMtlID)) NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LibSave pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					local	LibPath = (GetSaveFileName Caption:"Save GIMS MP3 material library" Types:"GIMS MP3 material library (*.GMP3EML)|*.GMP3EML")
					if Have LibPath then (
						GIMS.Core.CacheMgr.Write TheObj.Material LibPath SubresourcesPath:#ExecutePath
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LibLoad pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					local LibPath = (GetOpenFileName Caption:"Load GIMS MP3 material library" Types:"GIMS MP3 material library (*.GMP3EML)|*.GMP3EML")
					if Have LibPath then (
						global	EGIMS_ExecutePath = (GetFileNamePath LibPath)
						local	LoadedMtl = (FileIn LibPath)
						if (IsKindOf LoadedMtl MultiMaterial) then (
							for Mtl in LoadedMtl where (IsKindOf Mtl EGIMS_MP3_material) do
								Mtl.UpdateDelegateParams()
						)
						TheObj.Material = LoadedMtl
						
						GetMaterialList()
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LockSh changed state do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_MP3_matlist)
					SetDialogPos EGIMS_MP3_mateditor [(NewPos.x + (GetDialogSize EGIMS_MP3_matlist).x + 20), NewPos.y]
				)
				EGIMS_MP3_mateditor.LockSh.checked = state
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on EGIMS_MP3_matlist moved NewPos do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if LockSh.checked then
					SetDialogPos EGIMS_MP3_mateditor [(NewPos.x + (GetDialogSize EGIMS_MP3_matlist).x + 20), NewPos.y]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_matlist Open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				List.Height = ((GetDialogSize EGIMS_MP3_matlist).y - List.Pos.y - 5)
				Callbacks.AddScript #selectionSetChanged "EGIMS_MP3_matlist.GetMaterialList()" ID:#EGIMS_MP3_matlist_GetMaterial
				Callbacks.AddScript #NodePostMaterial "EGIMS_MP3_matlist.OnMaterialChanged()" ID:#EGIMS_MP3_matlist_OnMaterialChanged
				GetMaterialList()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_matlist Close do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				MtlAddTimer.Active = false
				MtlInitTimer.Active = false
				Callbacks.RemoveScripts #selectionSetChanged id:#EGIMS_MP3_matlist_GetMaterial
				Callbacks.RemoveScripts #NodePostMaterial id:#EGIMS_MP3_matlist_OnMaterialChanged
				DestroyDialog EGIMS_MP3_mateditor
				MtlID = 0
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rcmenu EGIMS_MP3_TexMapRC (
		MenuItem cpy "Copy" enabled:(Have EGIMS_MP3_matlist.RC[3])
		MenuItem pst "Paste" enabled:(Have EGIMS_MP3_matlist.CpyTexPath)
		MenuItem clr "Clear"
		MenuItem Preview "Preview" enabled:(Have EGIMS_MP3_matlist.RC[3])
		
		on cpy picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.CpyTexPath = EGIMS_MP3_matlist.RC[3].FileName
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on pst picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			local	CpyTexPath = EGIMS_MP3_matlist.CpyTexPath,
					TheBMP = (try (OpenBitmap CpyTexPath) catch undefined)
			if Have TheBMP then (
				local	TexMapData = EGIMS_MP3_matlist.RC[1],
						TheMtl = TexMapData[1],
						ParamName = TexMapData[2]
				TheMtl.SetParam ParamName #sp_sampler (BitmapTexture Bitmap:TheBMP)
				local	TexMapBtn = EGIMS_MP3_matlist.RC[2]
				TexMapBtn.tooltip = CpyTexPath
				TexMapBtn.caption = (FileNameFromPath CpyTexPath)
				if (TheMtl.IsDelegateLinkedParam ParamName) then
					EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
			) else
				MessageBox ("Can't load the texture from \"" + CpyTexPath + "\" file!") title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on clr picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TexMapData = EGIMS_MP3_matlist.RC[1],
						TheMtl = TexMapData[1],
						ParamName = TexMapData[2]
				TheMtl.SetParam ParamName #sp_sampler undefined
				local	TexMapBtn = EGIMS_MP3_matlist.RC[2]
				TexMapBtn.tooltip = (TexMapBtn.caption = "Empty")
				if (TheMtl.IsDelegateLinkedParam ParamName) then
					EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on Preview picked do (
			try
				Display EGIMS_MP3_matlist.RC[3]
			catch
				MessageBox "Can't load the texture" title:"GIMS MP3 texture map preview"
		)
		on EGIMS_MP3_TexMapRC Open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TexMapData = EGIMS_MP3_matlist.RC[1]
				clr.Enabled = (Have (TexMapData[1].GetParam TexMapData[2] #sp_sampler))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_MP3_BlendEditor "Blend editor" (
		local	TheObj, TheMtl, 
				ShaderName,
				OnBlend = false,
				IsPoly,
				AllowedVerts = #{},
				Faces = #{},	/*#{face ids}*/
				VertIDs = #(),	/*#(face * #(vert ids))*/
				VertPositions = #(),	/*#(face * #{vert positions})*/
				PaintMapVertIDs = #{},	/*#{painted map vert ids}*/
				PaintPowers = #(),	/*#{painted map vert powers}*/
				MapVertPaintData,
				FGetVertSelection,
				FGetFaceSelection,
				FGetVert,
				FGetVertsUsingFace,
				FGetFacesUsingVert,
				FGetVertSelection,
				FGetFaceMatID,
				FGetVertsUsingFace,
				FGetMapSupport,
				FSetMapSupport,
				FDefaultMapFaces,
				FGetMapFace,
				FGetMapVert,
				FSetMapVert,
				UndoStart, UndoAccept, GetHitPointData
		CheckButton PaintBtn "Paint" Width:100 Across:2
		Button beopt "Options" Width:100 Enabled:false
		RadioButtons PaintTexID "Layer" Labels:#("2nd", "3rd", "4th") Columns:4 Align:#Left Enabled:false Across:2
		RadioButtons PaintMode "Mode" Labels:#("Brush", "Rubber") Columns:2 Align:#Right Enabled:false
		Label lgbs1 height:10
		Button EraseLyr "Erase" Enabled:false Width:60 Across:2
		Button EraseAll "Erase" Enabled:false Width:60
		Button FillLyr "Fill" Enabled:false Width:60 Across:2
		Button FillAll "Fill" Enabled:false Width:60
		Label lgbs2 height:6
		GroupBox lgb "Current layer" Pos:[EraseLyr.Pos.x - 12.5, EraseLyr.Pos.y - 15] Width:85 Height:70
		GroupBox lgbf "All layers" Pos:[EraseAll.Pos.x - 12.5,EraseAll.Pos.y - 15] Width:85 Height:70
		
		fn BrakePaint = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				PaintBtn.Checked = false
				ThePainterInterface.EndPaintSession()
				DestroyDialog EGIMS_MP3_BlendProps
				Free AllowedVerts
				Free Faces
				Free VertIDs
				Free VertPositions
				Free PaintMapVertIDs
				Free PaintPowers
				PaintTexID.State = 1
				PaintTexID.Enabled = false
				PaintMode.Enabled = false
				EraseLyr.Enabled = false
				EraseAll.Enabled = false
				FillLyr.Enabled = false
				FillAll.Enabled = false
				beopt.Enabled = false
				EGIMS_MP3_BlendEditor.OnBlend = false
				if EGIMS_MP3_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SetMapPaintData BasePoint = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Free PaintMapVertIDs
				local	MapChannelID = MapVertPaintData.x,
						Radius = (EGIMS_MP3_matlist.Radius / 2),
						Strength = EGIMS_MP3_matlist.Strength,
						FaceIndex = 1
				for FaceID in Faces do (
					local	FaceVertIDs = VertIDs[FaceIndex],
							FaceVertPositions = VertPositions[FaceIndex],
							VertCount = FaceVertIDs.Count,
							TargeVertIndices = #{},
							Distances = #(),
							VertIndex = 1
					Distances.Count = VertCount
					for VertPos in FaceVertPositions where AllowedVerts[FaceVertIDs[VertIndex]] do (
						local	Dist = (Distance BasePoint VertPos)
						if (Dist < Radius) then (
							TargeVertIndices[VertIndex] = true
							Distances[VertIndex] = Dist
						)
						VertIndex += 1
					)
					if TargeVertIndices.Count != 0 then (
						local	MapVertIDs = (FGetMapFace TheObj MapChannelID FaceID)
						for VertIndex in TargeVertIndices do (
							local	MapVertID = MapVertIDs[VertIndex]
							PaintMapVertIDs[MapVertID] = true
							PaintPowers[MapVertID] = (((Radius - Distances[VertIndex]) / Radius) * Strength)
							VertIndex += 1
						)
					)
					FaceIndex += 1
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SelectLayer = (	--!	TODO codereview
			throw "TODO"
			case ShaderName of (
				#gta_terrain_va_2lyr:
					MapVertPaintData = [3, 2]
				#gta_terrain_va_3lyr: (
					if PaintTexID.State == 1 then
						MapVertPaintData = [4, 2]
					else
						MapVertPaintData = [5, 1]
				)
				#gta_terrain_va_4lyr: (
					case PaintTexID.State of (
						1:
							MapVertPaintData = [5, 2]
						2:
							MapVertPaintData = [6, 1]
						3:
							MapVertPaintData = [6, 2]
					)
				)
				Default:
					throw ("Unknown blend shader name " + ShaderName as String + " found!")
			)
		)
		on PaintTexID Changed State do (	--!	TODO codereview
			throw "TODO"
			local	MaxState = (
				case ShaderName of (
					#gta_terrain_va_2lyr:
						1
					#gta_terrain_va_3lyr:
						2
					#gta_terrain_va_4lyr:
						3
				)
			)
			if State > MaxState then
				PaintTexID.State = MaxState
			SelectLayer()
		)
		fn PaintStroke = (
			try (
				UndoStart() 
				local	BasePoint = [0, 0, 0]
				GetHitPointData [0, 0, 0] [0, 0, 0] &BasePoint [0, 0, 0] 0 0 0
				SetMapPaintData BasePoint
				local	MapChannelID = MapVertPaintData.x,
						MapVertComponentID = MapVertPaintData.y,
						State = PaintMode.State
				for MapVertID in PaintMapVertIDs do (
					local	TempMapVert = (FGetMapVert TheObj MapChannelID MapVertID),
							Power = (
								if MapVertComponentID == 2 then
									-TempMapVert[MapVertComponentID]
								else
									TempMapVert[MapVertComponentID]
							),
							PaintPower = PaintPowers[MapVertID]
					if State == 1 then
						Power += PaintPower
					else
						Power -= PaintPower
					if
						Power < 0 or
						Power > 1
					then (
						if Power < 0 then
							Power = 0
						else
							Power = 1
					)
					TempMapVert[MapVertComponentID] = (
						if MapVertComponentID == 2 then
							-Power
						else
							Power
					)
					FSetMapVert TheObj MapChannelID MapVertID TempMapVert
				)
				UndoAccept() 
				Update TheObj
				RedrawViews()
			) catch (
				ThePainterInterface.UndoCancel() 
				BrakePaint()
				/*<ERRHANDLER>*/local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS/*<ERRHANDLEREND>*/
				throw
			)
		)
		on beopt Pressed do (
			DestroyDialog EGIMS_MP3_BlendProps
			CreateDialog EGIMS_MP3_BlendProps Style:#(#style_titlebar, #style_border, #style_sysmenu)
		)
		fn FillChannel ID:unsupplied Factor:0 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FaceIndex = 1
				if Supplied ID then (
					for FaceID in Faces do (
						local	MapFace = (FGetMapFace TheObj ID FaceID),
								FaceVertIDs = VertIDs[FaceIndex]
						for VertID = 1 to (if IsPoly then MapFace.Count else 3) where AllowedVerts[FaceVertIDs[VertID]] do
							FSetMapVert TheObj ID MapFace[VertID] [Factor, Factor, Factor]
						FaceIndex += 1
					)
				) else (
					for FaceID in Faces do (
						local	MapFace = (FGetMapFace TheObj MapVertPaintData.x FaceID),
								FaceVertIDs = VertIDs[FaceIndex]
						for VertID = 1 to (if IsPoly then MapFace.Count else 3) where AllowedVerts[FaceVertIDs[VertID]] do (
							local	TempMapVert = (FGetMapVert TheObj MapVertPaintData.x MapFace[VertID])
							TempMapVert[MapVertPaintData.y] = Factor
							FSetMapVert TheObj MapVertPaintData.x MapFace[VertID] TempMapVert
						)
						FaceIndex += 1
					)
				)
				Update TheObj
				RedrawViews()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on FillLyr Pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				FillChannel Factor:1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EraseLyr Pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				FillChannel()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on FillAll Pressed do (	--!	TODO codereview
			throw "TODO"
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	StartMapID = (
					case ShaderName of (
						#gta_terrain_va_2lyr:
							3
						#gta_terrain_va_3lyr:
							4
						#gta_terrain_va_4lyr:
							5
					)
				)
				for i = StartMapID to 6 do
					FillChannel ID:i Factor:1
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EraseAll Pressed do (	--!	TODO codereview
			throw "TODO"
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	StartMapID = (
					case ShaderName of (
						#gta_terrain_va_2lyr:
							3
						#gta_terrain_va_3lyr:
							4
						#gta_terrain_va_4lyr:
							5
					)
				)
				for i = StartMapID to 6 do
					FillChannel ID:i
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PaintBtn Changed State do (	--!	TODO codereview
			throw "TODO"
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if State then (
					local	FaceSelectModes
					case (ClassOf TheObj) of (
						Editable_Mesh: (
							FGetVert = GetVert
							FGetVertSelection = GetVertSelection
							FGetFaceMatID = GetFaceMatID
							FGetVertsUsingFace = MeshOp.GetVertsUsingFace
							FGetFacesUsingVert = MeshOp.GetFacesUsingVert
							FGetMapSupport = MeshOp.GetMapSupport
							FSetMapSupport = MeshOp.SetMapSupport
							FDefaultMapFaces = MeshOp.DefaultMapFaces
							FGetMapFace = MeshOp.GetMapFace
							FGetMapVert = MeshOp.GetMapVert
							FSetMapVert = MeshOp.SetMapVert
							FGetVertSelection = GetVertSelection
							FGetFaceSelection = GetFaceSelection
							FaceSelectModes = #{3..5}
							IsPoly = false
						)
						Editable_Poly: (
							FGetVert = PolyOp.GetVert
							FGetVertSelection = PolyOp.GetVertSelection
							FGetFaceMatID = PolyOp.GetFaceMatID
							FGetVertsUsingFace = PolyOp.GetVertsUsingFace
							FGetFacesUsingVert = PolyOp.GetFacesUsingVert
							FGetMapSupport = PolyOp.GetMapSupport
							FSetMapSupport = PolyOp.SetMapSupport
							FDefaultMapFaces = PolyOp.DefaultMapFaces
							FGetMapFace = PolyOp.GetMapFace
							FGetMapVert = PolyOp.GetMapVert
							FSetMapVert = PolyOp.SetMapVert
							FGetVertSelection = PolyOp.GetVertSelection
							FGetFaceSelection = PolyOp.GetFaceSelection
							FaceSelectModes = #{4, 5}
							IsPoly = true
						)
					)
					UndoStart = ThePainterInterface.UndoStart
					UndoAccept = ThePainterInterface.UndoAccept
					GetHitPointData = ThePainterInterface.GetHitPointData
					if Have FaceSelectModes then (
						Free Faces
						Free VertIDs
						Free VertPositions
						Free PaintMapVertIDs
						Free PaintPowers
						ShaderName = (TheMtl.GetShaderName())
						AllowedVerts = (
							if (SubObjectLevel == 1) then
								(FGetVertSelection TheObj)
						)
						local	MaterialIDList = TheObj.Material.MaterialIDList,
								AllowedFaces = (	/*Get selected or all faces*/
									if Have AllowedVerts then
										FGetFacesUsingVert TheObj AllowedVerts
									else (
										if
											Have SubObjectLevel and
											SubObjectLevel != 0 and
											FaceSelectModes[SubObjectLevel]
										then
											(FGetFaceSelection TheObj)
										else
											#{1..TheObj.NumFaces}
									)
								),
								SelectedMtlID = MaterialIDList[EGIMS_MP3_matlist.MtlID],
								AppendIfUniq = GIMS.Core.ArrayOps.AppendIfUniq,
								tFace
						if No AllowedVerts then
							AllowedVerts = (FGetVertsUsingFace TheObj AllowedFaces)
						Free Faces
						Faces.Count = AllowedFaces.Count
						for FaceID in AllowedFaces where
							(FGetFaceMatID TheObj FaceID) == SelectedMtlID
						do
							Faces[FaceID] = true
						Free VertPositions
						VertPositions.Count = Faces.Count
						local	FaceIndex = 1
						for FaceID in Faces do (
							local	FaceVerts = ((FGetVertsUsingFace TheObj FaceID) as array)
							VertIDs[FaceIndex] = FaceVerts
							VertPositions[FaceIndex] = (
								local	Res = #()
								for i = FaceVerts to 1 by -1 do
									Res[i] = (FGetVert TheObj FaceVerts[i])
								Res
							)
							FaceIndex += 1
						)
						if EGIMS_MP3_matlist.OnPreview then
							GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
						EGIMS_MP3_BlendEditor.OnBlend = true
						local	StartMapID = (
							case ShaderName of (
								#gta_terrain_va_2lyr:
									3
								#gta_terrain_va_3lyr:
									4
								#gta_terrain_va_4lyr:
									5
							)
						)
						for i = StartMapID to 6 where not (FGetMapSupport TheObj i) do (
							FDefaultMapFaces TheObj i
							FillChannel ID:i
						)
						SelectLayer()
						GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
						ThePainterInterface.MaxSize = EGIMS_MP3_matlist.Radius
						ThePainterInterface.DrawRing = true
						ThePainterInterface.DrawNormal = true
						ThePainterInterface.DrawTrace = true
						ThePainterInterface.ScriptFunctions undefined PaintStroke undefined undefined undefined
						ThePainterInterface.InitializeNodes 0 TheObj
						ThePainterInterface.StartPaintSession()
						PaintTexID.Enabled = true
						PaintMode.Enabled = true
						EraseLyr.Enabled = true
						EraseAll.Enabled = true
						FillLyr.Enabled = true
						FillAll.Enabled = true
						beopt.Enabled = true
					) else (
						PaintTexID.State = 1
						PaintTexID.Enabled = false
						PaintMode.Enabled = false
						EraseLyr.Enabled = false
						EraseAll.Enabled = false
						FillLyr.Enabled = false
						FillAll.Enabled = false
						beopt.Enabled = false
						PaintBtn.State = false
						MessageBox "Can't edit blending - unknown object type" title:"GIMS for Max Payne 3 material editor"
					)
				) else
					BrakePaint()
				Update TheObj
				RedrawViews()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_BlendEditor Close do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if PaintBtn.State then
					BrakePaint()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_BlendEditor Open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				TheObj = EGIMS_MP3_matlist.TheObj
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_MP3_mateditor "Model" Width:350 Height:220 (
		local	TheObj, TheMtl, Shaders, SubRolParamNames = #(), SubRolParamRols = #(), MaxHintSize = 50, NRParamIDs = #(), SPSFullTip = ""
		Label lstrt
		Group "UV coordinates" (
			Label luvtip1 "These values won't be stored in the model"
			Label luvtip2 "Don't forget to:" Align:#Right Across:2
			Button ResetUV "Reset" Align:#Left Offset:[5, 0] Height:15
			Label offs "Offset" Align:#Center across:3
			Label tile "Tiling" Align:#Center	Offset:[15, 0]
			Label op "Opacity" Align:#Right	Offset:[-10, 0]
			Spinner U_Offset "U" Type:#Float Range:[-100000,100000,0] FieldWidth:35 Align:#Center Across:6
			Spinner V_Offset "V" Type:#Float Range:[-100000,100000,0] FieldWidth:35 Align:#Center
			Spinner U_Tiling "U" Type:#Float Range:[-100000,100000,1] FieldWidth:35 Align:#Center	Offset:[15, 0]
			Spinner V_Tiling "V" Type:#Float Range:[-100000,100000,1] FieldWidth:35 Align:#Center	Offset:[15, 0]
			Label el0 ""
			Spinner Opacity "" Type:#Float Range:[0,1,1] FieldWidth:35 Align:#Right	Offset:[-5, 0]
		)
		
		CheckBox mdl_AVF "Aligned vertex format" Align:#Left
		
		Label l0 "Shader" across:2	Align:#Left
		DropdownList mdl_shtype items:#() height:30 Width:240	Align:#Right
		Label l1 "Parameter set" across:2	Align:#Left
		DropdownList mdl_spslist items:#() height:30 Width:240	Align:#Right
		
		Label lst "VC" across:2	Align:#Left
		Button	SPSTip	""	Align:#Right	Width:300
		
		SubRollout editor Height:-1
		
		DropdownList cNRParamList Items:#() Height:30 Align:#Right	Width:250	Across:2
		Button	cAddNRParam	"Add parameter"	Enabled:false	Align:#Right
		
		CheckButton LockSh "< Dock" width:45 height:17 checked:true pos:[0,0]
		
		on U_Offset changed val do
			EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
		on V_Offset changed val do
			EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
		on U_Tiling changed val do
			EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
		on V_Tiling changed val do
			EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
		on Opacity changed val do
			EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
		on mdl_AVF changed val do
			TheMtl.AlignedVertexFormat = val
		
		fn DoTexmapRC SlotControl TexmapName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local Texmap = (TheMtl.GetParam TexmapName #sp_sampler),
						TheBMP = (try Texmap.Bitmap catch ())
				EGIMS_MP3_matlist.RC = #(#(TheMtl, TexmapName), SlotControl, TheBMP)
				PopUpMenu EGIMS_MP3_TexMapRC
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn _Init_AddSubRollout SPSParam EditorName EditorTitle UIHint = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ParamName = SPSParam.aName,
						SubRolName = ((EditorName as String) + ParamName),
						SubRol = (Execute SubRolName)
				if No SubRol then (
					local	SubRolCode = (StringStream ""),
							SubRolCodePattern = ( try (GetProperty GIMS.MP3.Core.GUI EditorName) catch ())
					if No SubRolCodePattern then
						throw "Can't find editor code for " EditorName
					local	ParamNameString = (ParamName as String)
					Format SubRolCodePattern ParamNameString ParamNameString ParamNameString ParamNameString ParamNameString To:SubRolCode
					SubRol = (Execute (SubRolCode as String))
					if No SubRol then
						throw "Can't find just compiled rollout: " ((EditorName as String) + ParamName)
					Free SubRolCode
				)
				if not SubRol.isDisplayed then
					AddSubRollout editor SubRol
				SubRol.Init EditorTitle UIHint TheMtl SPSParam
				SubRol
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetParamInfo SPSParam UIMin:0 UIMax:100 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ResourceName, UIName, UIHint,
						ResourceType
				for Anno in SPSParam.Annotations do (
					case Anno.aKey of (
						#ResourceName:
							ResourceName = Anno.aValue
						#UIHint:
							UIHint = Anno.aValue
						#UIName:
							UIName = Anno.aValue
						#UIMin:
							UIMin = Anno.aValue
						#UIMax:
							UIMax = Anno.aValue
						#ResourceType:
							ResourceType = Anno.aValue
					)
				)
				local	ParameterTitle = (
							if Have ResourceName then
								ResourceName
							else (
								if Have UIName then
									UIName
								else
									SPSParam.Description
							)
						)
				if Have ResourceType then (
					ParameterTitle += " ("
					Append ParameterTitle ResourceType
					Append ParameterTitle ")"
				)
				#(
					ParameterTitle,
					UIHint,
					UIMin,
					UIMax
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn InitArrayEditor SubRol ValueDimensions vValue DefaultValue UIMin UIMax = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MaxX = (ValueDimensions.x as Integer),
						MaxY = (ValueDimensions.y as Integer),
						HaveValue = true
				if No vValue then (
					vValue = DefaultValue
					HaveValue = (Supplied vValue)
				)
				local	SubRolControls = SubRol.Controls,
						ControlID = (MaxX + 1)
				for y = 1 to MaxY do (
					for x = 1 to MaxX do (
						local	Contr = SubRolControls[ControlID],
								val = (
									if HaveValue then
										vValue[y][x]
									else
										UIMax
								)
						Contr.Range = [UIMin, UIMax, 0]
						Contr.Value = val
						ControlID += 1
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn BuildSPSInfo SPS = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SPSFullTipSS = (StringStream ""),
						SPSTipSS = (StringStream ""),
						SPSToGIMSParamType = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.SPSToGIMSParamType,
						IsFirstVD = true
				for VD in SPS.VertexDeclarations do (
				
					--write header
					if IsFirstVD then (
						if VD.Skinned then (
							Format "Skinned:\n" To:SPSFullTipSS
							Format "+Skin(" To:SPSTipSS
						) else (
							Format "Not skinned:\n" To:SPSFullTipSS
							Format "-Skin(" To:SPSTipSS
						)
						IsFirstVD = false
					) else (
						if VD.Skinned then (
							Format "Skinned:\n" To:SPSFullTipSS
							Format " +Skin(" To:SPSTipSS
						) else (
							Format "Not skinned:\n" To:SPSFullTipSS
							Format " -Skin(" To:SPSTipSS
						)
					)
					
					--store components info
					local	UVCount = 0,
							HavePos = false,
							ColorTypes = #(),
							HaveNormal = false,
							HaveTangent = false,
							HaveSB = false,
							HaveSW = false
					for elem in VD.Elements do (
						case elem.Usage of (
							#D3DDECLUSAGE_POSITION:
								HavePos = true
							#D3DDECLUSAGE_TEXCOORD: (
								if (SPSToGIMSParamType elem.aType) == #P4 then
									UVCount += 2
								else
									UVCount += 1
							)
							#D3DDECLUSAGE_COLOR: (
								Append ColorTypes (
									case elem.aType of (
										#D3DDECLTYPE_FLOAT4:
											ColorType = 2
										#D3DDECLTYPE_UBYTE4N:
											ColorType = 2
										Default:
											ColorType = 1
									)
								)
							)
							#D3DDECLUSAGE_NORMAL:
								HaveNormal = true
							#D3DDECLUSAGE_TANGENT:
								HaveTangent = true
							#D3DDECLUSAGE_BLENDINDICES:
								HaveSB = true
							#D3DDECLUSAGE_BLENDWEIGHT:
								HaveSW = true
							Default:
								throw "Unknown vertex declaration element: " elem.Usage
						)
					)
					
					--write components info
					local	IsFirstElem = true
					if not HavePos then (
						Format "\tNo Position\n" To:SPSFullTipSS
						Format "NP " To:SPSTipSS
						IsFirstElem = false
					)
					if HaveNormal then (
						Format "\tNormals\n" To:SPSFullTipSS
						if IsFirstElem then (
							IsFirstElem = false
							Format "N" To:SPSTipSS
						) else
							Format " N" To:SPSTipSS
					) else
						Format "\tNo Normals\n" To:SPSFullTipSS
					if HaveTangent then (
						Format "\tTangents\n" To:SPSFullTipSS
						if IsFirstElem then (
							IsFirstElem = false
							Format "T" To:SPSTipSS
						) else
							Format " T" To:SPSTipSS
					) else
						Format "\tNo Tangents\n" To:SPSFullTipSS
					if ColorTypes.Count == 0 then (
						Format "\tNo Color\n" To:SPSFullTipSS
					) else (
						for i = 1 to ColorTypes.Count do (
							case ColorTypes[i] of (
								1: (
									if i == 2 then
										Format "\tRGB Illumination Color\n" To:SPSFullTipSS
									else
										Format "\tRGB Color\n" To:SPSFullTipSS
									if IsFirstElem then (
										IsFirstElem = false
										Format "RGB" To:SPSTipSS
									) else
										Format " RGB" To:SPSTipSS
								)
								2: (
									if i == 2 then
										Format "\tRGBA Illumination Color\n" To:SPSFullTipSS
									else
										Format "\tRGBA Color\n" To:SPSFullTipSS
									if IsFirstElem then (
										IsFirstElem = false
										Format "RGBA" To:SPSTipSS
									) else
										Format " RGBA" To:SPSTipSS
								)
								Default:
									throw "Unknown ColorType: " ColorTypes[i]
							)
						)
					)
					if UVCount == 0 then
						Format "\tNo Texture UV\n" To:SPSFullTipSS
					else (
						Format "\t% Texture UV\n" UVCount To:SPSFullTipSS
						if IsFirstElem then (
							IsFirstElem = false
							if UVCount == 1 then
								Format "UV" To:SPSTipSS
							else
								Format "UV-%" UVCount To:SPSTipSS
						) else (
							if UVCount == 1 then
								Format " UV" To:SPSTipSS
							else
								Format " UV-%" UVCount To:SPSTipSS
						)
					)
					if
						HaveSB and
						HaveSW
					then (
						Format "\tSkinning bones and weights\n" To:SPSFullTipSS
						if IsFirstElem then (
							IsFirstElem = false
							Format "S" To:SPSTipSS
						) else
							Format " S" To:SPSTipSS
					) else (
						if HaveSB then (
							Format "\tSkinning bones without weights\n" To:SPSFullTipSS
							if IsFirstElem then (
								IsFirstElem = false
								Format "SB" To:SPSTipSS
							) else
								Format " SB" To:SPSTipSS
						) else (	--not HaveSB
							if HaveSW then (
								Format "\tSkinning weights without bones\n" To:SPSFullTipSS
								if IsFirstElem then (
									IsFirstElem = false
									Format "SW" To:SPSTipSS
								) else
									Format " SW" To:SPSTipSS
							) else	--not (HaveSB or HaveSW)
								Format "\tNo skinning bones or weights\n" To:SPSFullTipSS
						)
					)
					Format ")" UVCount To:SPSTipSS
				)
				SPSTip.Text = (SPSTipSS as String)
				SPSFullTip = (SPSFullTipSS as String)
				Free SPSFullTipSS
				SPSTip.ToolTip = (Append "[Vertex components]\n\n" SPSFullTip)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#SPS), #(SPS)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn Init SPSData:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if EGIMS_MP3_mateditor.Open then (
					mdl_AVF.Checked = TheMtl.AlignedVertexFormat
					U_Offset.Controller = TheMtl.U_Offset.Controller
					V_Offset.Controller = TheMtl.V_Offset.Controller
					U_Tiling.Controller = TheMtl.U_Tiling.Controller
					V_Tiling.Controller = TheMtl.V_Tiling.Controller
					Opacity.Controller = TheMtl.Opacity.Controller
					
					cNRParamList.Visible = false
					cAddNRParam.Visible = false
					
					local	QuickSearch = GIMS.Core.ArrayOps.QuickSearch,
							TypeCast = GIMS.Core.ValueOps.TypeCast,
							SPSName = TheMtl.SPSName,
							SPSGroups = Shaders[3],
							SPSGroup, SPS, GID, SID
					if Supplied SPSData then (
						SPS = SPSData[1]
						GID = SPSData[2]
						SID = SPSData[3]
						SPSGroup = SPSGroups[GID]
					) else (
						local	Found = false
						for tGID = 1 to SPSGroups.Count while not Found do (
							local	tSPSGroup = SPSGroups[tGID],
									tSID = (QuickSearch tSPSGroup SPSName PropertyName:#aName)
							if tSID != 0 then (
								GID = tGID
								SID = tSID
								SPSGroup = tSPSGroup
								Found = true
							)
						)
						if No SPSGroup then
							throw "Can't find the SPS: " SPSName
						SPS = SPSGroup[SID]
					)
					
					local	SPSNameList = #()
					for i = SPSGroup.Count to 1 by -1 do
						SPSNameList[i] = SPSGroup[i].aName
					mdl_shtype.selection = GID
					mdl_spslist.items = SPSNameList
					mdl_spslist.selection = SID
					
					BuildSPSInfo SPS
					
					for Rol in editor.Rollouts do
						RemoveSubRollout editor Rol
					EditorHeight = 220
					MaxEditorHeight = EGIMS_MP3_matlist.Height
					EGIMS_MP3_mateditor.height = EditorHeight
					editor.Height = 500
					local	Padding = EGIMS_MP3_matlist.Padding
					editor.Pos.x = Padding
					editor.Width = ((GetDialogSize EGIMS_MP3_mateditor).x - (Padding * 2))
					
					local	CheckParamFn = TheMtl.CheckParam,
							ShaderParameters = SPS.ShaderParameters,
							SPSParamCount = ShaderParameters.Count,
							NRSPSParamCount = 0,
							NRParams = #()
					cAddNRParam.Enabled = false
					NRParams.Count = SPSParamCount
					NRParamIDs.Count = SPSParamCount
					for i = 1 to SPSParamCount do (
						local	SPSParam = ShaderParameters[i],
								SPSName = SPSParam.aName
						if
							not SPSParam.isRequired and
							not (CheckParamFn SPSName SPSParam.aType)
						then (
							NRSPSParamCount += 1
							local	ParamInfo = (GetParamInfo SPSParam),
									ParameterTitle = ParamInfo[1],
									UIHint = ParamInfo[2],
									Title = (SPSName as String)
							if
								Have ParameterTitle and
								(StriCmp Title ParameterTitle) != 0
							then (
								Title = (Title + ": ")
								Append Title ParameterTitle
							)
							if Have UIHint then (
								Title = (Title + " - ")
								Append Title UIHint
							)
							NRParams[NRSPSParamCount] = Title
							NRParamIDs[NRSPSParamCount] = i
						)
					)
					NRParams.Count = NRSPSParamCount
					NRParamIDs.Count = NRSPSParamCount
					cNRParamList.Items = NRParams
					if NRSPSParamCount != 0 then (
						cNRParamList.Selection = 1
						cAddNRParam.Enabled = true
					)
						
					local	ValueNames = TheMtl.TexValueNames,
							EditorName = #EGIMS_MP3_TexEditor_
					for i = 1 to ValueNames.Count do (
						local	ParamName = ValueNames[i],
								SPSParamID = (QuickSearch ShaderParameters ParamName PropertyName:#aName)
						if SPSParamID != 0 then (
							local	SPSParam = ShaderParameters[SPSParamID],
									ParamInfo = (GetParamInfo SPSParam),
									ParameterTitle = ParamInfo[1],
									UIHint = ParamInfo[2],
									SubRol = (_Init_AddSubRollout SPSParam EditorName ParameterTitle UIHint),
									TexValue = TheMtl.TexValues[i]
							GIMS.Core.MAXFactory.MaterialOps.UpdateMapButton SubRol SubRol.c_tex TexValue
							SubRol.c_texinc.Checked = TheMtl.TexInternalFlags[i]
						)
					)
					
					local	FloatValueNames = TheMtl.FloatValueNames
					for i = 1 to FloatValueNames.Count do (
						local	ParamName = FloatValueNames[i],
								SPSParamID = (QuickSearch ShaderParameters ParamName PropertyName:#aName)
						if SPSParamID != 0 then (
							SPSParam = ShaderParameters[SPSParamID]
							local	ParamInfo = (GetParamInfo SPSParam),
									ParameterTitle = ParamInfo[1],
									UIHint = ParamInfo[2],
									UIMin = ParamInfo[3],
									UIMax = ParamInfo[4],
									aType = SPSParam.aType,
									EditorName = (
										case aType of (
											#sp_float:
												#EGIMS_MP3_FloatEditor_
											#sp_float2:
												#EGIMS_MP3_Float2Editor_
											#sp_float3:
												#EGIMS_MP3_Float3Editor_
											#sp_float4:
												#EGIMS_MP3_Float4Editor_
										)
									),
									SubRol = (_Init_AddSubRollout SPSParam EditorName ParameterTitle UIHint),
									c_val = SubRol.c_val,
									DefaultValue = SPSParam.DefaultValue,
									vValue = (TheMtl.GetParam ParamName aType)
							if No DefaultValue then
								throw "No default value in SPS param " (SPSParam.aName + " of SPS " + SPSName)
							if No vValue then (
								vValue = (
									if Supplied DefaultValue then
										DefaultValue
									else
										(TypeCast UIMax #P4)
								)
							)
							c_val.Range = [UIMin, UIMax, 0]
							c_val.Value = vValue[1]
							SubRol.t_val.text = (c_val.value as String)
							case aType of (
								#sp_float2: (
									SubRol.c_val2.Range = [UIMin, UIMax, 0]
									SubRol.c_val2.Value = vValue[2]
									SubRol.t_val2.text = (SubRol.c_val2.value as String)
								)
								#sp_float3: (
									SubRol.c_val2.Range = [UIMin, UIMax, 0]
									SubRol.c_val3.Range = [UIMin, UIMax, 0]
									SubRol.c_val2.Value = vValue[2]
									SubRol.c_val3.Value = vValue[3]
									SubRol.t_val2.text = (SubRol.c_val2.value as String)
									SubRol.t_val3.text = (SubRol.c_val3.value as String)
								)
								#sp_float4: (
									SubRol.c_val2.Range = [UIMin, UIMax, 0]
									SubRol.c_val3.Range = [UIMin, UIMax, 0]
									SubRol.c_val4.Range = [UIMin, UIMax, 0]
									SubRol.c_val2.Value = vValue[2]
									SubRol.c_val3.Value = vValue[3]
									SubRol.c_val4.Value = vValue[4]
									SubRol.t_val2.text = (SubRol.c_val2.value as String)
									SubRol.t_val3.text = (SubRol.c_val3.value as String)
									SubRol.t_val4.text = (SubRol.c_val4.value as String)
								)
							)
						)
					)
					
					local	ArrayValueNames = #(
								TheMtl.Float2x3ParamNames,
								TheMtl.Matrix3x4ParamNames,
								TheMtl.Matrix4x4ParamNames,
								TheMtl.Float4x4ParamNames,
								TheMtl.Float4x5ParamNames
							),
							ArrayValueEditors = #(
								#EGIMS_MP3_Float2x3Editor_,
								#EGIMS_MP3_Float3x4Editor_,
								#EGIMS_MP3_Float4x4Editor_,
								#EGIMS_MP3_Float4x4Editor_,
								#EGIMS_MP3_Float4x5Editor_
							),
							ArrayValueDimensions = #(
								[2, 3],
								[3, 4],
								[4, 4],
								[4, 4],
								[4, 5]
							)
					for TypeID = 1 to ArrayValueNames.Count do (
						local	ValueNames = ArrayValueNames[TypeID],
								EditorName = ArrayValueEditors[TypeID],
								ValueDimensions = ArrayValueDimensions[TypeID]
						for i = 1 to ValueNames.Count do (
							local	ParamName = ValueNames[i],
									SPSParamID = (QuickSearch ShaderParameters ParamName PropertyName:#aName)
							if SPSParamID != 0 then (
								SPSParam = ShaderParameters[SPSParamID]
								local	ParamInfo = (GetParamInfo SPSParam UIMin:-100000 UIMax:100000),
										ParameterTitle = ParamInfo[1],
										UIHint = ParamInfo[2],
										UIMin = ParamInfo[3],
										UIMax = ParamInfo[4],
										aType = SPSParam.aType,
										SubRol = (_Init_AddSubRollout SPSParam EditorName ParameterTitle UIHint),
										DefaultValue = SPSParam.DefaultValue,
										vValue = (TheMtl.GetParam ParamName aType)
								if No DefaultValue then
									throw "No default value in SPS param " (SPSParam.aName + " of SPS " + SPSName)
								InitArrayEditor SubRol ValueDimensions vValue DefaultValue UIMin UIMax
							)
						)
					)
					
					for Rol in editor.Rollouts do (
						Rol.TheMtl = TheMtl
						local	RolHeight = rol.Height
						EditorHeight += ((if RolHeight < 60 then 60 else RolHeight) + 35)
					)
					if EditorHeight <= MaxEditorHeight then
						EditorHeight += 20
					else
						EditorHeight = MaxEditorHeight
					local	EditorControlHeight = (EditorHeight - editor.pos.y - Padding - 20 - Padding),
							EditorControlPosY = editor.Pos.y
					editor.Height = EditorControlHeight
					EGIMS_MP3_mateditor.height = EditorHeight
					
					local	NewPosY = (EditorControlPosY + EditorControlHeight + Padding)
					cNRParamList.Pos = [4, NewPosY]
					cAddNRParam.Pos = [258, NewPosY]
					cNRParamList.Visible = true
					cAddNRParam.Visible = true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on cAddNRParam Pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GID = mdl_shtype.Selection,
						SID = mdl_spslist.Selection,
						SPS = Shaders[3][GID][SID],
						SPSParam = SPS.ShaderParameters[NRParamIDs[cNRParamList.Selection]],
						aName = SPSParam.aName,
						aType = SPSParam.aType
				TheMtl.SetParam aName aType (
					if aType != #sp_sampler then
						SPSParam.DefaultValue
				)
				Init SPSData:#(SPS, GID, SID)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on mdl_shtype selected id do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SPSGroup = Shaders[3][id],
						SPSCount = SPSGroup.Count,
						SID = mdl_spslist.Selection
				if SID > SPSCount then
					SID = SPSCount
				local	SPS = SPSGroup[SID]
				TheMtl.SPSName = SPS.aName
				Init SPSData:#(SPS, id, SID)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on mdl_spslist selected id do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GID = mdl_shtype.Selection,
						SPS = Shaders[3][GID][id]
				TheMtl.SPSName = SPS.aName
				Init SPSData:#(SPS, GID, id)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on ResetUV Pressed do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				U_Offset.Value = 0
				V_Offset.Value = 0
				U_Tiling.Value = 1
				V_Tiling.Value = 1
				Opacity.Value = 1
				EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on EGIMS_MP3_mateditor open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.LockSh.enabled = true
				Shaders = GIMS.MP3.Core.DB.Shaders
				local	DefaultData = Shaders[4],
						DefaultGroup = (DefaultData.x as Integer)
				mdl_shtype.items = Shaders[2]
				mdl_shtype.selection = DefaultGroup
				local	SPSGroup = Shaders[3][DefaultGroup],
						SPSNameList = #()
				for i = SPSGroup.Count to 1 by -1 do
					SPSNameList[i] = SPSGroup[i].aName
				mdl_spslist.items = SPSNameList
				mdl_spslist.selection = (DefaultData.y as Integer)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_mateditor close do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.SelectItem 0
				EGIMS_MP3_matlist.LockSh.enabled = false
				if EGIMS_MP3_BlendEditor.OnBlend then
					EGIMS_MP3_BlendEditor.BrakePaint()
				if EGIMS_MP3_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LockSh changed state do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_MP3_mateditor)
					SetDialogPos EGIMS_MP3_matlist [(NewPos.x - (GetDialogSize EGIMS_MP3_matlist).x - 20), NewPos.y]
				)
				EGIMS_MP3_matlist.LockSh.checked = state
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on EGIMS_MP3_mateditor moved NewPos do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if LockSh.checked then
					SetDialogPos EGIMS_MP3_matlist [(NewPos.x - (GetDialogSize EGIMS_MP3_matlist).x - 20), NewPos.y]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rcmenu EGIMS_MP3_MaterialRC (
		local	TheObj, TheObjMaterial, MaterialList, MaterialIDList,
				MtlID, CpyMtl, CurrentMtl
		MenuItem CreateNew "Add new material"
		MenuItem ShowSubMtl "Display in viewports"
		MenuItem Unify "Make unique"
		MenuItem CopySet "Copy"
		submenu "Paste" (
			MenuItem PasteReference "Reference" Enabled:false
			MenuItem PasteDuplicate "Duplicate" Enabled:false
		)
		MenuItem DelSubMtl "Delete"
		submenu "Mesh" (
			MenuItem FaceSelect "Select faces with this material"
			MenuItem FaceApply "Apply to the selected faces" Enabled:false
		)
-- 		submenu "Preview" (
			MenuItem PreviewInVFB "Preview material"
--  			MenuItem PreviewInScene "Shader in scene"
-- 		)
		submenu "Storage" (
 			MenuItem StorageLoad "Import"
			MenuItem StorageSave "Export"
		)
		
		fn UpdateMatLinks = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				TheObjMaterial = TheObj.Material
				MaterialList = TheObjMaterial.MaterialList
				MaterialIDList = TheObjMaterial.MaterialIDList
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_MP3_MaterialRC Open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				TheObj = EGIMS_MP3_matlist.TheObj
				UpdateMatLinks()
				MtlID = EGIMS_MP3_matlist.MtlID
				CpyMtl = EGIMS_MP3_matlist.CpyMtl
				CurrentMtl = MaterialList[MtlID]
				ShowSubMtl.checked = (CurrentMtl.ShowInViewport)
				PasteReference.enabled = (Have CpyMtl)
				PasteDuplicate.enabled = (Have CpyMtl)
				FaceApply.enabled = (GIMS.Core.MaterialOps.CheckFaceSelection EGIMS_MP3_matlist)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on CreateNew picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MtlID = (GIMS.Core.ArrayOps.GetFirstUnusedIndex (MaterialIDList as array)),
						NewListID = (MaterialList.Count + 1)
				EGIMS_MP3_matlist.UnifyMultimaterial()
				UpdateMatLinks()
				MaterialList[NewListID] = (
					EGIMS_MP3_material \
						Name:(
							GIMS.Core.ValueOps.FormatText \
								v1:TheObj.Name \
								v2:" #" \
								v3:NewListID \
						) \
						ShowInViewport:true \
				)
				MaterialIDList[NewListID] = MtlID
				EGIMS_MP3_matlist.AddMatRollout NewListID
				EGIMS_MP3_matlist.InitMatRollout NewListID
				EGIMS_MP3_matlist.UpdateThumbnail NewListID
				EGIMS_MP3_matlist.UpdateHeader()
				EGIMS_MP3_matlist.SelectItem NewListID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on DelSubMtl picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.UnifyMultimaterial()
				UpdateMatLinks()
				if MaterialList.Count == 1 then (
					MaterialList[1] = (
						EGIMS_MP3_material \
							Name:(
								GIMS.Core.ValueOps.FormatText \
									v1:TheObj.Name \
									v2:" #1" \
							) \
							ShowInViewport:true \
					)
					MaterialIDList[1] = 1
					EGIMS_MP3_matlist.List.Rollouts[1].Init 1
					EGIMS_MP3_matlist.UpdateThumbnail 1
				) else (
					EGIMS_MP3_matlist.DeleteMaterial MtlID
					EGIMS_MP3_matlist.UpdateHeader()
				)
				EGIMS_MP3_matlist.SelectItem MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		fn GetObjClass Obj = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if (
					(IsKindOf Obj Editable_Poly) or
					(IsKindOf Obj.BaseObject Editable_Poly) or
					(Have Obj.Modifiers[#Edit_Poly])
				) then
					Editable_Poly
				else (
					if (
						(IsKindOf Obj Editable_Mesh) or
						(IsKindOf Obj.BaseObject Editable_Mesh) or
						(Have Obj.Modifiers[#Edit_Mesh])
					) then
						Editable_Mesh
					else
						undefined
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on FaceApply picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					if $ == TheObj then (
						local	FaceSelectModes, FSetFaceMatID, FGetFaceSelection,
								IsPoly = false
						case (GetObjClass TheObj) of (
							Editable_Mesh: (
								FSetFaceMatID = SetFaceMatID
								FGetFaceSelection = GetFaceSelection
								FaceSelectModes = #{3..5}
							)
							Editable_Poly: (
								FSetFaceMatID = PolyOp.SetFaceMatID
								FGetFaceSelection = PolyOp.GetFaceSelection
								FaceSelectModes = #{4, 5}
								IsPoly = true
							)
						)
						if Have FaceSelectModes then (
							if
								Have SubObjectLevel and
								SubObjectLevel != 0 and
								FaceSelectModes[SubObjectLevel]
							then (
								local Faces = (FGetFaceSelection TheObj)
								if Faces.Count != 0 then (
									local	CurrentMatID = MaterialIDList[MtlID],
											ObjectMgr = GIMS.Core.ObjectMgr,
											ModData = (ObjectMgr.StoreModData TheObj CollapseToMesh:true)
									CollapseStack TheObj
									if IsPoly then
										FSetFaceMatID TheObj Faces CurrentMatID
									else (
										for tFace in Faces do
											FSetFaceMatID TheObj tFace CurrentMatID
									)
									ObjectMgr.RestoreModData TheObj ModData
								) else
									MessageBox "Please select the faces first" title:"GIMS MP3 material editor"
								Update TheObj
							) else
								MessageBox "Please select the faces first" title:"GIMS MP3 material editor"
						) else
							MessageBox "Can't apply the material - object isn't an Editable Mesh/Poly" title:"GIMS MP3 material editor"
					) else
						MessageBox "Can't apply the material - another object's selected" title:"GIMS MP3 material editor"
				) else
					MessageBox "Can't apply the material - object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on FaceSelect picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					local	FGetFaceMatID, FSetFaceSelection, TargetSubObjectLevel, ModName
					case (GetObjClass TheObj) of (
						Editable_Mesh: (
							FGetFaceMatID = GetFaceMatID
							FSetFaceSelection = SetFaceSelection
							ModName = #Edit_Mesh
							TargetSubObjectLevel = 3
						)
						Editable_Poly: (
							FGetFaceMatID = PolyOp.GetFaceMatID
							FSetFaceSelection = PolyOp.SetFaceSelection
							ModName = #Edit_Poly
							TargetSubObjectLevel = 4
						)
					)
					if Have TargetSubObjectLevel then (
						Callbacks.RemoveScripts #selectionSetChanged id:#EGIMS_MP3_matlist_GetMaterial
						Select TheObj
						Callbacks.AddScript #selectionSetChanged "EGIMS_MP3_matlist.GetMaterialList()" ID:#EGIMS_MP3_matlist_GetMaterial
						max modify mode
						EGIMS_SelectModifier TheObj
						EnableSubObjSel true
						if NumSubObjectLevels < TargetSubObjectLevel then (
							local	ObjMod = TheObj.Modifiers[ModName]
							if Have ObjMod then
								EGIMS_SelectModifier ObjMod
						)
						SubObjectLevel = TargetSubObjectLevel
						local	Faces = #{},
								CurrentMatID = MaterialIDList[MtlID]
						for i = TheObj.NumFaces to 1 by -1 where (FGetFaceMatID TheObj i) == CurrentMatID do 
							Faces[i] = true
						if Faces.Count != 0 then (
							FSetFaceSelection TheObj Faces
							Free Faces
						) else
							MessageBox "Can't find faces with that material" title:"GIMS MP3 material editor"
					) else
						MessageBox "Can't select faces with that material - object isn't an Editable Mesh/Poly" title:"GIMS MP3 material editor"
				) else
					messagebox "Can't select faces with that material - object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true AddInfo:
				#(
					#(
						#Object,
						#BaseObject,
						#Modifiers
					), #(
						TheObj,
						TheObj.BaseObject,
						TheObj.Modifiers
					)
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on CopySet picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.CpyMtl = CurrentMtl
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PasteReference picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.UnifyMultimaterial()
				UpdateMatLinks()
				MaterialList[MtlID] = CpyMtl
				EGIMS_MP3_matlist.SelectItem MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PasteDuplicate picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.UnifyMultimaterial()
				UpdateMatLinks()
				MaterialList[MtlID] = (Copy CpyMtl)
				EGIMS_MP3_matlist.SelectItem MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on Unify picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.UnifyMultimaterial()
				UpdateMatLinks()
				MaterialList[MtlID] = (Copy CurrentMtl)
				EGIMS_MP3_matlist.SelectItem MtlID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
-- 		on PreviewInScene picked do (
-- 			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
-- 			/*<ERRHANDLERSTART>*/try (
-- 				GIMS.Core.MaterialOps.ReplaceShader EGIMS_MP3_matlist
-- 			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
-- 			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
-- 			OK
-- 		)
		on StorageSave picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					local	LibPath = (GetSaveFileName Caption:"Save GIMS MP3 material" Types:"GIMS MP3 material (*.EGMP3M)|*.EGMP3M")
					if Have LibPath then (
						GIMS.Core.CacheMgr.Write CurrentMtl LibPath SubresourcesPath:#ExecutePath
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on StorageLoad picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not (IsDeleted TheObj) then (
					local LibPath = (GetOpenFileName Caption:"Load GIMS MP3 material" Types:"GIMS MP3 material (*.EGMP3M)|*.EGMP3M")
					if Have LibPath then (
						global	EGIMS_ExecutePath = (GetFileNamePath LibPath)
						local	LoadedMtl = (FileIn LibPath)
						LoadedMtl.UpdateDelegateParams()
						MaterialList[MtlID] = LoadedMtl
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted" title:"GIMS MP3 material editor"
				EGIMS_MP3_matlist.UpdateThumbnail MtlID
				DestroyDialog EGIMS_MP3_mateditor
				EGIMS_MP3_matlist.MtlID = MtlID
				EGIMS_MP3_matlist.EditMaterial DestroyEars:true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PreviewInVFB picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID Preview:true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on ShowSubMtl picked do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				CurrentMtl.ShowInViewport = (not ShowSubMtl.checked)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI*/GUIstr (
	/*Viewport rendering*/
		SelectedAreaStart,
		SelectedAreaEnd,
		SelectingArea = false,
	/*Material editor*/
		MaterialRolloutName = "EGIMS_MP3_matlist_Item",
		MaterialRolloutCode = (
			"rollout EGIMS_MP3_matlist_Item% \"...loading...\" RolledUp:true (
				local	TheObj, Index, MatName,
						ImageSize = EGIMS_MP3_matlist.ImageSize,
						Padding = EGIMS_MP3_matlist.Padding,
						TricePadding = (Padding * 3),
						SpinnerWidth = 60,
						OptionsBtnHeight = 20,
						MiscX = (ImageSize.x + 5)
				ImgTag MaterialBMP Width:ImageSize.x Height:ImageSize.y Style:#BMP_Stretch Pos:[Padding, Padding] Transparent:Red
				EditText MaterialName Align:#Left Pos:[MiscX, Padding] Width:100 Text:\"...loading...\"
				Spinner ObjMtlID \"ID\" Align:#Left Type:#Integer Range:[1, 1000, 1] Pos:[MiscX + Padding, MaterialName.Pos.y + MaterialName.Height + Padding] Width:SpinnerWidth
				Button BtnOptions \"Options\" Align:#Left Pos:[MiscX + Padding, Padding + ImageSize.y - OptionsBtnHeight] Width:SpinnerWidth Height:OptionsBtnHeight
				HyperLink ActiveTip \"<EDITING>\" Align:#Left Color:Red Pos:[EGIMS_MP3_matlist_Item%.Width - Padding - 60, ObjMtlID.Pos.y] Enabled:false Visible:false
				fn UpdateHeader = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	TheObjMaterial = TheObj.Material,
								Mtl = TheObjMaterial.MaterialList[Index],
								Names = TheObjMaterial.Names,
								MMName = Names[Index],
								MatTitle
						if No MMName then
							MMName = \"\"
						MatName = (
							if No Mtl then
								MMName
							else (
								if MMName.Count != 0 then
									MMName
								else
									Names[Index] = Mtl.Name
							)
						)
						MatTitle = (
							GIMS.Core.ValueOps.FormatText \
								v1:\"\\\"\" \
								v2:MatName \
								v3:\"\\\"\"
						)
						if not (IsKindOf Mtl EGIMS_MP3_Material) then (
							Append MatTitle \": \"
							Append MatTitle ((ClassOf Mtl) as String)
						)
						EGIMS_MP3_matlist.List.Rollouts[Index].Title = (
							GIMS.Core.ValueOps.FormatText \
								v1:\"ID \" \
								v2:TheObjMaterial.MaterialIDList[Index] \
								v3:\": \" \
								v4:MatTitle
						)
						OK
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				fn SetSelected Flag = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						ActiveTip.Visible = Flag
						if Flag then
							EGIMS_MP3_matlist_Item%.Open = true
						OK
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				fn FixGUI = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	Height = (ImageSize.y + TricePadding),
									Rol = EGIMS_MP3_matlist.List.Rollouts[Index],
									Width = Rol.Width
						Rol.Height = Height
						MaterialName.Width = (Width - ImageSize.x - TricePadding)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				fn InitControls = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						ObjMtlID.Value = TheObj.Material.MaterialIDList[Index]
						MaterialName.Text = MatName
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				fn Init MatIndex EraseBitmap:true = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if EraseBitmap then
							MaterialBMP.Bitmap = undefined
						Index = MatIndex
						FixGUI()
						TheObj = EGIMS_MP3_matlist.TheObj
						UpdateHeader()
						InitControls()
						SetSelected false
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				on EGIMS_MP3_matlist_Item% RolledUp Flag do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if Flag then (
							if Have TheObj then (
								InitControls()
								EGIMS_MP3_matlist.UpdateThumbnail Index
							) else
								EGIMS_MP3_matlist_Item%.Open = false
						) else (
							if
								Have TheObj and
								Index == EGIMS_MP3_matlist.MtlID
							then
								EGIMS_MP3_matlist.SelectItem 0
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				fn SelectItem = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if not (IsDeleted TheObj) then
							EGIMS_MP3_matlist.SelectItem Index
						else (
							MessageBox \"Failed: object's deleted!\" title:\"GIMS MP3 material editor\"
							false
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				on MaterialBMP Click do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if Have TheObj then (
							if EGIMS_MP3_matlist.MtlID != Index then
								SelectItem()
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS MP3 material editor\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				fn OpenOptions = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if Have TheObj then (
							if not (IsDeleted TheObj) then (
								if (
									EGIMS_MP3_matlist.MtlID == Index or
									SelectItem()
								) then
									PopUpMenu EGIMS_MP3_MaterialRC
							) else
								MessageBox \"Failed: object's deleted!\" title:\"GIMS MP3 material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS MP3 material editor\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on MaterialBMP RightClick do
					OpenOptions()
				on BtnOptions Pressed do
					OpenOptions()
				on ObjMtlID Changed MID do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if Have TheObj then (
							if not (IsDeleted TheObj) then (
								local	MaterialIDList = TheObj.Material.MaterialIDList
								if MID != MaterialIDList[Index] then (
									local	UsedID = (FindItem MaterialIDList MID)
									if UsedID == 0 then (
										EGIMS_MP3_matlist.UnifyMultimaterial Index:Index
										TheObj.Material.MaterialIDList[Index] = MID
									) else (
										if (QueryBox \"This mesh material ID's already used.\\nSwap materials?\" Title:\"GIMS MP3 material editor\") then (
											EGIMS_MP3_matlist.UnifyMultimaterial Index:Index
											local	MaterialIDList = TheObj.Material.MaterialIDList
											Swap MaterialIDList[Index] MaterialIDList[UsedID]
											EGIMS_MP3_matlist.List.Rollouts[UsedID].Init UsedID EraseBitmap:false
										) else
											ObjMtlID.Value = MaterialIDList[Index]
									)
									UpdateHeader()
									Update TheObj.Mesh
								)
								RedrawViews()
							) else
								MessageBox \"Failed: object's deleted!\" title:\"GIMS V material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS V material editor\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on MaterialName Entered MtlName do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if Have TheObj then (
							if not (IsDeleted TheObj) then (
								MatName = MtlName
								local	TheObjMaterial = TheObj.Material,
										Mtl = TheObjMaterial.MaterialList[Index]
								if Have Mtl then
									Mtl.Name = MatName
								TheObjMaterial.Names[Index] = MatName
								UpdateHeader()
							) else
								MessageBox \"Failed: object's deleted!\" title:\"GIMS MP3 material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS MP3 material editor\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_TexEditor_ = (
			"rollout EGIMS_MP3_TexEditor_% \"...loading...\" RolledUp:true (	--%
				local Param, TheMtl, Hint
			
				button c_tex \"\" align:#Left toolTip:\"\" Width:220 Across:2
				CheckBox c_texinc \"Embed\" align:#Right	Offset:[0, 3]
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_TexEditor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_TexEditor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on HintBtn pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						MessageBox Hint Title:\"GIMS MP3 SPS parameter hint\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			
				on c_tex rightclick do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_mateditor.DoTexmapRC c_tex Param.aName
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_tex pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	ParamName = Param.aName,
									ParamType = Param.aType,
									OldMap = (TheMtl.GetParam ParamName ParamType),
									NewMap = (GIMS.Core.MAXFactory.MaterialOps.OpenMap undefined OldMap undefined ControlRollout:EGIMS_MP3_TexEditor_% MapControl:c_tex)
						if Have NewMap then (
							TheMtl.SetParam ParamName ParamType NewMap IsTexInternal:c_texinc.Checked
							if (TheMtl.IsDelegateLinkedParam ParamName) then
								EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_texinc changed State do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						TheMtl.SetParam Param.aName Param.aType unsupplied IsTexInternal:State
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_FloatEditor_ = (
			"rollout EGIMS_MP3_FloatEditor_% \"...loading...\" RolledUp:true (	--% %
				local Param, TheMtl, Hint
			
				slider c_val Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#left Width:260 Across:2
				edittext t_val text:\"\" width:45 align:#right	Offset:[-5, 10]
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_FloatEditor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_FloatEditor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on HintBtn pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						MessageBox Hint Title:\"GIMS MP3 SPS parameter hint\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				
				on c_val ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val.Value
						t_val.text = (val as String)
						local	ParamName = Param.aName
						TheMtl.SetParam ParamName Param.aType val
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val.text = (power = \"0.0\")
						try
							c_val.value = (power as Float)
						catch
							t_val.text = (c_val.value as String)
						local	ParamName = Param.aName
						TheMtl.SetParam ParamName Param.aType c_val.value
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_Float2Editor_ = (
			"rollout EGIMS_MP3_Float2Editor_% \"...loading...\" RolledUp:true (	--% %
				local Param, TheMtl, Hint
			
				Label	l_X	\"X\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_Y	\"Y\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val2 Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val2 text:\"\" width:45 align:#right	Offset:[-5, 10]
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float2Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float2Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on HintBtn pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						MessageBox Hint Title:\"GIMS MP3 SPS parameter hint\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				
				on c_val ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val.Value
						t_val.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val.text = (power = \"0.0\")
						try
							c_val.value = (power as Float)
						catch
							t_val.text = (c_val.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = c_val.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val2 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val2.Value
						t_val2.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = val
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val2 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val2.text = (power = \"0.0\")
						try
							c_val2.value = (power as Float)
						catch
							t_val2.text = (c_val2.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = c_val2.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_Float3Editor_ = (
			"rollout EGIMS_MP3_Float3Editor_% \"...loading...\" RolledUp:true (	--% %
				local Param, TheMtl, Hint
			
				Label	l_X	\"X\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_Y	\"Y\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val2 Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val2 text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_Z	\"Z\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val3 Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val3 text:\"\" width:45 align:#right	Offset:[-5, 10]
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float3Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float3Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
						if (MatchPattern iParam.aName Pattern:\"*color\") then (
							l_X.Text = \"R\"
							l_Y.Text = \"G\"
							l_Z.Text = \"B\"
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on HintBtn pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						MessageBox Hint Title:\"GIMS MP3 SPS parameter hint\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				
				on c_val ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val.Value
						t_val.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val.text = (power = \"0.0\")
						try
							c_val.value = (power as Float)
						catch
							t_val.text = (c_val.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = c_val.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val2 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val2.Value
						t_val2.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val2 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val2.text = (power = \"0.0\")
						try
							c_val2.value = (power as Float)
						catch
							t_val2.text = (c_val2.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = c_val2.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val3 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val3.Value
						t_val3.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[3] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val3 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val3.text = (power = \"0.0\")
						try
							c_val3.value = (power as Float)
						catch
							t_val3.text = (c_val3.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[3] = c_val3.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_Float4Editor_ = (
			"rollout EGIMS_MP3_Float4Editor_% \"...loading...\" RolledUp:true (	--% %
				local Param, TheMtl, Hint
			
				Label	l_X	\"X\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val Type:#Float Orient:#horizontal Range:[0,100,0] Ticks:10 Align:#Right Offset:[52, 0] Width:238
				edittext t_val text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_Y	\"Y\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val2 type:#Float orient:#horizontal range:[0,100,0] ticks:10 align:#Right Offset:[52, 0] Width:238
				edittext t_val2 text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_Z	\"Z\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val3 type:#Float orient:#horizontal range:[0,100,0] ticks:10 align:#Right Offset:[52, 0] Width:238
				edittext t_val3 text:\"\" width:45 align:#right	Offset:[-5, 10]
				Label	l_W	\"W\"	Across:3	Align:#left	Offset:[-5, 10]
				slider c_val4 type:#Float orient:#horizontal range:[0,100,0] ticks:10 align:#Right Offset:[52, 0] Width:238
				edittext t_val4 text:\"\" width:45 align:#right	Offset:[-5, 10]
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float4Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float4Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
						if (MatchPattern iParam.aName Pattern:\"*color\") then (
							l_X.Text = \"R\"
							l_Y.Text = \"G\"
							l_Z.Text = \"B\"
							l_W.Text = \"A\"
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on HintBtn pressed do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						MessageBox Hint Title:\"GIMS MP3 SPS parameter hint\"
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				
				on c_val ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val.Value
						t_val.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val.text = (power = \"0.0\")
						try
							c_val.value = (power as Float)
						catch
							t_val.text = (c_val.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[1] = c_val.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val2 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val2.Value
						t_val2.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val2 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val2.text = (power = \"0.0\")
						try
							c_val2.value = (power as Float)
						catch
							t_val2.text = (c_val2.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[2] = c_val2.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val3 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val3.Value
						t_val3.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[3] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val3 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val3.text = (power = \"0.0\")
						try
							c_val3.value = (power as Float)
						catch
							t_val3.text = (c_val3.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[3] = c_val3.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on c_val4 ButtonUp do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						local	val = c_val4.Value
						t_val4.text = (val as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[4] = val
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on t_val4 changed power do (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						if power.Count == 0 then
							t_val4.text = (power = \"0.0\")
						try
							c_val4.value = (power as Float)
						catch
							t_val4.text = (c_val4.value as String)
						local	ParamName = Param.aName,
								ParamType = Param.aType,
								OldValue = (TheMtl.GetParam ParamName ParamType)
						OldValue[4] = c_val4.value
						TheMtl.SetParam ParamName ParamType OldValue
						if (TheMtl.IsDelegateLinkedParam ParamName) then
							EGIMS_MP3_matlist.UpdateThumbnail EGIMS_MP3_matlist.MtlID
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		EGIMS_MP3_Float2x3Editor_ = (
			"rollout EGIMS_MP3_Float2x3Editor_% \"...loading...\" RolledUp:true (
				local Param, TheMtl, Hint
			
				Label	l_val1	\"X\"	Align:#Center	Across:2
				Label	l_val2	\"Y\"	Align:#Center
			
				Spinner	c_val11	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:2
				Spinner	c_val12	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val21	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:2
				Spinner	c_val22	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val31	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:2
				Spinner	c_val32	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
			
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float2x3Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float2x3Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on EGIMS_MP3_Float2x3Editor_% Close do (
					local	MaxX = 2,
								MaxY = 3,
								Result = #(),
								ArrDummy = [0, 0, 0],
								ControlID = (MaxX + 1),
								tControls = EGIMS_MP3_Float2x3Editor_%.Controls
					Result.Count = MaxY
					for y = 1 to MaxY do (
						local	SubArr = (
										if y == 1 then
											ArrDummy
										else
											(Copy ArrDummy)
									)
						for x = 1 to MaxX do (
							SubArr[x] = tControls[ControlID].Value
							ControlID += 1
						)
						Result[y] = SubArr
					)
					TheMtl.SetParam Param.aName Param.aType Result
				)
			)"
		),
		EGIMS_MP3_Float3x4Editor_ = (
			"rollout EGIMS_MP3_Float3x4Editor_% \"...loading...\" RolledUp:true (
				local Param, TheMtl, Hint
			
				Label	l_val1	\"X\"	Align:#Center	Across:3
				Label	l_val2	\"Y\"	Align:#Center
				Label	l_val3	\"Z\"	Align:#Center
			
				Spinner	c_val11	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:3
				Spinner	c_val12	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val13	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val21	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:3
				Spinner	c_val22	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val23	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val31	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:3
				Spinner	c_val32	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val33	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val41	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:3
				Spinner	c_val42	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val43	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
			
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float3x4Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float3x4Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on EGIMS_MP3_Float3x4Editor_% Close do (
					local	MaxX = 3,
								MaxY = 4,
								Result = #(),
								ArrDummy = [0, 0, 0],
								ControlID = (MaxX + 1),
								tControls = EGIMS_MP3_Float3x4Editor_%.Controls
					Result.Count = MaxY
					for y = 1 to MaxY do (
						local	SubArr = (
										if y == 1 then
											ArrDummy
										else
											(Copy ArrDummy)
									)
						for x = 1 to MaxX do (
							SubArr[x] = tControls[ControlID].Value
							ControlID += 1
						)
						Result[y] = SubArr
					)
					TheMtl.SetParam Param.aName Param.aType Result
				)
			)"
		),
		EGIMS_MP3_Float4x4Editor_ = (
			"rollout EGIMS_MP3_Float4x4Editor_% \"...loading...\" RolledUp:true (
				local Param, TheMtl, Hint
			
				Label	l_val1	\"X\"	Align:#Center	Across:4
				Label	l_val2	\"Y\"	Align:#Center
				Label	l_val3	\"Z\"	Align:#Center
				Label	l_val4	\"W\"	Align:#Center
			
				Spinner	c_val11	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val12	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val13	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val14	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val21	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val22	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val23	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val24	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val31	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val32	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val33	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val34	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val41	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val42	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val43	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val44	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false
				
				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float4x4Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float4x4Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on EGIMS_MP3_Float4x4Editor_% Close do (
					local	MaxX = 4,
								MaxY = 4,
								Result = #(),
								ArrDummy = [0, 0, 0, 0],
								ControlID = (MaxX + 1),
								tControls = EGIMS_MP3_Float4x4Editor_%.Controls
					Result.Count = MaxY
					for y = 1 to MaxY do (
						local	SubArr = (
										if y == 1 then
											ArrDummy
										else
											(Copy ArrDummy)
									)
						for x = 1 to MaxX do (
							SubArr[x] = tControls[ControlID].Value
							ControlID += 1
						)
						Result[y] = SubArr
					)
					TheMtl.SetParam Param.aName Param.aType Result
				)
			)"
		),
		EGIMS_MP3_Float4x5Editor_ = (
			"rollout EGIMS_MP3_Float4x5Editor_% \"...loading...\" RolledUp:true (
				local Param, TheMtl, Hint
			
				Label	l_val1	\"X\"	Align:#Center	Across:4
				Label	l_val2	\"Y\"	Align:#Center
				Label	l_val3	\"Z\"	Align:#Center
				Label	l_val4	\"W\"	Align:#Center
			
				Spinner	c_val11	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val12	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val13	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val14	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val21	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val22	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val23	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val24	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val31	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val32	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val33	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val34	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val41	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val42	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val43	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val44	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				Spinner	c_val51	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50	Across:4
				Spinner	c_val52	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val53	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
				Spinner	c_val54	Type:#Float	Range:[-100000, 100000, 0]	Align:#Center	FieldWidth:50
			
				button HintBtn \"?\" Height:17 Width:10 Pos:[3, 3]	Enabled:false Visible:false

				fn Init iTitle UIHint iTheMtl iParam = (
					/*<PROFILERSTART>*//*local PWS; LogProfiler #Start (local SS = (StringStream \"\"); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*/
					/*<ERRHANDLERSTART>*/try (
						EGIMS_MP3_Float4x5Editor_%.Title = iTitle
						Param = iParam
						TheMtl = iTheMtl
						if 
							Have UIHint and
							UIHint.Count != 0
						then (
							HintBtn.Pos.x = (EGIMS_MP3_Float4x5Editor_%.Width - 14)
							HintBtn.Visible = (HintBtn.Enabled = true)
							Hint = UIHint
							HintBtn.ToolTip = (\"Hint: \" + Hint)
						)
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				
				on EGIMS_MP3_Float4x5Editor_% Close do (
					local	MaxX = 4,
								MaxY = 5,
								Result = #(),
								ArrDummy = [0, 0, 0, 0],
								ControlID = (MaxX + 1),
								tControls = EGIMS_MP3_Float4x5Editor_%.Controls
					Result.Count = MaxY
					for y = 1 to MaxY do (
						local	SubArr = (
										if y == 1 then
											ArrDummy
										else
											(Copy ArrDummy)
									)
						for x = 1 to MaxX do (
							SubArr[x] = tControls[ControlID].Value
							ControlID += 1
						)
						Result[y] = SubArr
					)
					TheMtl.SetParam Param.aName Param.aType Result
				)
			)"
		),
	/*Internal ops*/
		fn Export_Write Sender Args InitLayout:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							AddResult = GIMS.Core.SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
							Objs = ExchangeData[2],
							ObjStrings = ExchangeData[3],
							ObjCount = Objs.Count,
							WriteProgressStartID = ExchangeData[4],
							Obj
					if InitLayout then
						GUIMgr.InitProgress ObjStrings Title:"Export"
					for ObjID = 1 to ObjCount do (
						UpdateProgress #Stage (ObjID + WriteProgressStartID)
						Objs[ObjID].Write()
					)
					GIMS.Core.ArrayOps.Dispose Objs
					local	CacheMgrWrite = GIMS.Core.CacheMgr.Write,
							GCachePath = GIMS.CurrentGame.CachePath,
							FormatText = GIMS.Core.ValueOps.FormatText
					CacheMgrWrite GIMS.CurrentGame.Core.DB.ObjectNames (GCachePath + "ObjectNames.Cache")
					CacheMgrWrite GIMS.CurrentGame.Core.DB.TextureNames (GCachePath + "TextureNames.Cache")
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_GetCNodeFaceCount CNode TotalFaceCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start "V.GUI.Export_GetObjMemoryInfos"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjClass = (ClassOf CNode.ParamSource),
						IsPoly = (ObjClass == Editable_Poly)
				if (
					IsPoly or
					(ObjClass == EGIMS_MP3_ModelMesh) or
					(ObjClass == Editable_Mesh)
				) then (
					local	Obj = CNode.Obj,
							FaceCount = (
								if IsPoly then (
									local	TriCount = 0,
											FGetFaceDeg = PolyOp.GetFaceDeg
									for i = 1 to Obj.NumFaces do (
										local fDegree = (FGetFaceDeg Obj i)
										TriCount += (
											if fDegree > 3 then
												(fDegree - 2)
											else
												1
										)
									)
									TriCount
								) else (
									try
										Obj.Mesh.NumFaces
									catch
										0
								)
							)
					TotalFaceCount += FaceCount
				) else (
					if (
						(ObjClass == EGIMS_MP3_ModelDict) or
						(ObjClass == EGIMS_MP3_Model) or
						(ObjClass == EGIMS_MP3_Model_Bone) or
						(ObjClass == EGIMS_MP3_Model_BoneMod)
					) then (
						for SubNode in CNode.Children do
							TotalFaceCount = (Export_GetCNodeFaceCount SubNode TotalFaceCount)
					)
				)
				TotalFaceCount
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							UpdateProgress = GUIMgr.UpdateProgress,
							SavePath = (GetSavePath Caption:"Select a location to export" InitialDir:GUIMgr.LastPath)
					if Have SavePath then (
						Append SavePath "\\"
						GUIMgr.LastPath = SavePath
						GUIMgr.InitProgress #(
							"Collect objects from scene"
						) Title:"Export"
						UpdateProgress #Stage 1
						local	Objs = (GIMS.Core.MAXFactory.SceneOps.GetObjsToExport()),
								HaveObjects = (Objs.Count != 0),
								AddResult = GIMS.Core.SystemMgr.AddResult
						if HaveObjects then (
							local	MaxMemUsage = 0.9,
									MemInfo = (SysInfo.GetSystemMemoryInfo()),
									GBDiv = (1024L * 1024L * 1024L),
									RAMFree = ((MemInfo[3] as Float) / GBDiv),
									RAMCanBeUsed = (RAMFree * MaxMemUsage),
									SwapFree = ((MemInfo[5] as Float) / GBDiv),
									MemFree = (RAMFree + SwapFree)
							for CNode in Objs do (
								local	CNodeFaceCount = (Export_GetCNodeFaceCount CNode 0),
										ProjMemoryFootprint = ((0.001 * CNodeFaceCount) / 28)
								if ProjMemoryFootprint > RAMCanBeUsed then (
									if ProjMemoryFootprint > MemFree then (
										local	SS = (StringStream "")
										Format "Model or dictionary \"%\" contains % faces, and it can take a lot of time and memory to export it.\n" CNode.Obj.Name CNodeFaceCount To:SS
										Format "Projected memory usage is around % GB, while you have only % GB of free memory(% GB RAM, % GB Swap).\n" ProjMemoryFootprint MemFree RAMFree SwapFree To:SS
										Format "You should consider splitting that model into multiple pieces.\n" To:SS
										AddResult #Error (SS as String)
										Free SS
									) else (
										local	SS = (StringStream "")
										Format "Model or dictionary \"%\" contains % faces, and it can take a lot of time and memory to export it.\n" CNode.Obj.Name CNodeFaceCount To:SS
										Format "Projected memory usage is around % GB, while you have % GB of free RAM and % GB of free Swap memory.\n" ProjMemoryFootprint RAMFree SwapFree To:SS
										Format "You can continue at your own risk if you have most of the swap memory on an SSD disk,\n" To:SS
										Format "but it will be better to split that model into multiple pieces." To:SS
										AddResult #Warning (SS as String)
										Free SS
									)
								)
								GIMS.Core.ArrayOps.Dispose MeshInfos
							)
							Free MemInfo
						) else
							GIMS.Core.SystemMgr.AddResult #Error "Nothing found to export."
						GIMS.Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_Select, 2), Objs, SavePath)
						GUIMgr.EndProgress true Continueable:HaveObjects
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_Select Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	ObjectMgr = GIMS.Core.ObjectMgr,
							GUIMgr = GIMS.Core.GUIMgr,
							FormatText = GIMS.Core.ValueOps.FormatText,
							ExchangeData = ObjectMgr.ExchangeData,
							GetPathString = GIMS.Core.ObjectMgr.GetPathString,
							Objs = ExchangeData[2],
							SavePath = ExchangeData[3]
					GUIMgr.SetWindow GIMS.Shared #Selection
					local	ListControl = (GUIMgr.FindControl #ObjectList),
							ObjStrings = (GIMS.Core.GUI.BuildCNodeTree ListControl Objs ObjTree)
					ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_StructsFromObjs, 2), Objs, ObjStrings, SavePath, GetPathString)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_StructsFromObjs Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							ObjectMgr = GIMS.Core.ObjectMgr,
							SystemMgr = GIMS.Core.SystemMgr,
							AddResult = SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
							Objs = ExchangeData[2],
							ObjStrings = ExchangeData[3]
					GIMS.Core.GUI.PurgeCNodes Objs CNodeStrings:ObjStrings
					local	SavePath = ExchangeData[4],
							ObjCount = Objs.Count,
							\
							HaveObjects = (ObjCount != 0)
					if HaveObjects then (
					
						--show export UI
						for i = 1 to ObjCount do
							ObjStrings[i] = (Append "\t> " ObjStrings[i])
						ObjStrings = (
							#("Collect from scene") +
							ObjStrings +
							#("Write to file") +
							ObjStrings
						)
						GUIMgr.InitProgress ObjStrings Title:"Export"
						
						--convert cnodes to structs and store failed
						MAX Create Mode
						local	StructFromScene = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.StructFromScene,
								UpdateProgress = GUIMgr.UpdateProgress,
								FailedObjIDs = #{},
								FailedObjectCount = 0
						FailedObjIDs.Count = ObjCount
						for i = 1 to ObjCount do (
							UpdateProgress #Stage (i + 1)
							local	ObjStruct = (StructFromScene Objs[i] DiskPath:SavePath)
							if Have ObjStruct then
								Objs[i] = ObjStruct
							else (
								FailedObjIDs[i] = true
								FailedObjectCount += 1
							)
						)
						
						--delete failed objects and their strings
						for i = ObjCount to 1 by -1 where FailedObjIDs[i] do (
							DeleteItem Objs i
							DeleteItem ObjStrings i
						)
						ObjCount -= FailedObjectCount
						
						--check final object count
						HaveObjects = (ObjCount != 0)
						if not HaveObjects then
							AddResult #Error "Can't export anything."
					) else
						AddResult #Error "Nothing selected to export."
					ObjectMgr.ExchangeData = #(
						#(GIMS.CurrentGame, 2, #Export_Write, 2),
						Objs,
						ObjStrings,
						(ObjCount + 2)
					)
					if (SystemMgr.HaveResults()) then
						GUIMgr.EndProgress true Continueable:HaveObjects
					else
						Export_Write Sender Args InitLayout:false
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import_Files Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjectMgr = GIMS.Core.ObjectMgr,
						SystemMgr = GIMS.Core.SystemMgr,
						AddResult = SystemMgr.AddResult,
						Files = ObjectMgr.ExchangeData[2],
						FileCount = Files.Count
				if FileCount != 0 then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast,
							FileStrings = #(),
							Stage1String = "\t> Read from file",
							Stage2String = "\t> Create in scene",
							NeedTextures = false
					FileStrings.Count = (FileCount * 3)
					for i = 1 to FileCount do (
						local	File = Files[i],
								FileType = (GetFileNameType File)
						FileType = (TypeCast (SubString FileType 2 FileType.Count) name)
						local	FileString = (
									( \
										case FileType of (
											#odr: (
												NeedTextures = true
												"Model: "
											)
											#odd: (
												NeedTextures = true
												"Model dictionary: "
											)
											#otd:
												"Texture dictionary: "
											Default:
												"Unknown: "	--throw "Unknown file type: " FileType
										)
									) +
									(GetFileNameFile File)
								),
								BaseIndex = ((i - 1) * 3)
						FileStrings[BaseIndex + 1] = FileString
						FileStrings[BaseIndex + 2] = Stage1String
						FileStrings[BaseIndex + 3] = Stage2String
					)
					local	GUIMgr = GIMS.Core.GUIMgr,
							\
							StructFromFile = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.StructFromFile,
							UpdateProgress = GUIMgr.UpdateProgress,
							TexPaths = #NoHandlerParam
					if NeedTextures then (
						TexPaths = (GetSavePath Caption:"Select external textures directory" InitialDir:(GetFileNamePath Files[1]))
						if Have TexPaths then (
							Append TexPaths "\\"
							TexPaths = (#(TexPaths) + (GetDirectories (TexPaths + "*")))
						)
					)
					MAX Create Mode
					GUIMgr.InitProgress FileStrings Title:"Import"
					local	IsSomethingImported = false
					for FileID = 1 to FileCount do (
						UpdateProgress #Stage (((FileID - 1) * 3) + 2)
						local	Obj = (StructFromFile Files[FileID] TexPaths)
						if Have Obj then (
							UpdateProgress #AddStage 1
							Obj.Create RootNode
							IsSomethingImported = true
							Obj = undefined
						)
					)
					if IsSomethingImported then (
						local	\
								CacheMgrWrite = GIMS.Core.CacheMgr.Write,
								GCachePath = GIMS.CurrentGame.CachePath
						CacheMgrWrite GIMS.CurrentGame.Core.DB.ObjectNames (GCachePath + "ObjectNames.Cache")
						CacheMgrWrite GIMS.CurrentGame.Core.DB.TextureNames (GCachePath + "TextureNames.Cache")
					) else
						AddResult #Error "Can't import anything."
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					GIMS.Core.ObjectMgr.ExchangeData = #(undefined, (GIMS.Core.GUI.SelectFiles "Select the resources to load" true "Max Payne 3 openFormats|*.odr;*.odd"))
					Import_Files Sender Args
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ChangeGamePath Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	Game = GIMS.CurrentGame
					if (QueryBox "Are you really want to change the game path?" Title:("GIMS for " + Game.Name)) then (
						GIMS.Core.GUIMgr.MainWindow.Close()
						GIMS.Core.SystemMgr.FileDelete (Game.BasePath + "Paths.txt")
						Game.Start Game
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowMatEditor Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					DestroyDialog EGIMS_MP3_matlist
					CreateDialog EGIMS_MP3_matlist Style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	GIMS.CurrentGame.Core.GUI = GUIstr()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
