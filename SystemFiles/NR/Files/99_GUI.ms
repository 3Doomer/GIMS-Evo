/*#PC*DEFINE	CurrentGame	NR*/
/*<PROFILERSTART>*//*(LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI*/GUIstr (
		LoadedPresets = #(),
		LoadedPresetDates = #(),
		AllowPresetChange = true,
		
		BonesContextMenu = undefined,
		BonesContextMenu_Item0 = undefined,
		BonesContextMenu_Item1 = undefined,
		BonesContextMenu_Item2 = undefined,
		BonesContextMenu_Item3 = undefined,
		BonesContextMenu_Item4 = undefined,
		
		fn SetBonesModeControlText Contr Item BonesMode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ReuseTip = (
							case (Bit.And BonesMode 3) of (
								0:
									"none"
								1:
									"at zero"
								2:
									"calc pos"
								Default:
									throw "Unknown BonesMode: " BonesMode
							)
						),
						BitGet = Bit.Get
				if (BitGet BonesMode 3) then
					Append ReuseTip ",reuse"
				if (BitGet BonesMode 4) then
					Append ReuseTip ",split"
				Contr.Text = (Item.ItemText + ReuseTip)
			OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadPreset FilePath FileName Preset Rules PresetID = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GUIMgr = GIMS.Core.GUIMgr,
						ImageControl = GUIMgr.ImageControl,
						SetCheckableState = GIMS.Core.GUI.SetCheckableState,
						SetTextBoxText = GIMS.Core.GUI.SetTextBoxText,
						Controls = (GUIMgr.GetNewestLayoutControls()),
						ControlItems = Controls.Item,
						ErrorMessage
				if No Preset then (
					for i = 1 to 2 while No Preset do (
						try (
							Preset = (
								GIMS.Core.CacheMgr.ReadCached \
									undefined \
									undefined \
									GCCPath:(GetFileNamePath FilePath) \
									GCCFile:FileName \
									Type:(GetFileNameType FilePath) \
									IgnoreBehavior:true \
									DefaultData:GIMS.CurrentGame.Core.TypeLibrary.UIPreset
							)
						) catch (
							if i == 2 then
								ErrorMessage = ("Can't create a failsafe preset at path " + (FilePath as String))
							FilePath = (GIMS.CurrentGame.CachePath + (FileNameFromPath FilePath))
							Rules.PresetFiles[PresetID] = FilePath
						)
					)
					if Have ErrorMessage then
						throw ErrorMessage
				)
				local	ImportMode = Preset.ImportMode
				for ID = 1 to Controls.Count do (
					Contr = ControlItems[ID - 1]
					local	Item = Contr.Tag.Value
					case Item.Name of (
						#BonesMode: (
							local	BonesMode = Preset.BonesMode
							Item.ItemContent = (BonesMode as String)
							SetBonesModeControlText Contr Item BonesMode
						)
						#FlipFaces:
							SetCheckableState Contr Preset.FlipFaces Item:Item
						#MirrorX:
							SetCheckableState Contr Preset.MirrorX Item:Item
						#MirrorY:
							SetCheckableState Contr Preset.MirrorY Item:Item
						#MirrorZ:
							SetCheckableState Contr Preset.MirrorZ Item:Item
						#FlipU:
							SetCheckableState Contr Preset.FlipU Item:Item
						#FlipV:
							SetCheckableState Contr Preset.FlipV Item:Item
						#FormatList: (
							try
								Contr.SelectedIndex = Preset.FormatIndex
							catch
								Contr.SelectedIndex = 0
						)
						#PosX:
							SetTextBoxText Contr Preset.PositionX
						#PosY:
							SetTextBoxText Contr Preset.PositionY
						#PosZ:
							SetTextBoxText Contr Preset.PositionZ
						#RotX:
							SetTextBoxText Contr Preset.RotationX
						#RotY:
							SetTextBoxText Contr Preset.RotationY
						#RotZ:
							SetTextBoxText Contr Preset.RotationZ
						#Scale:
							SetTextBoxText Contr Preset.Scale
						#OffsetU:
							SetTextBoxText Contr Preset.OffsetU
						#OffsetV:
							SetTextBoxText Contr Preset.OffsetV
						#ScaleU:
							SetTextBoxText Contr Preset.ScaleU
						#ScaleV:
							SetTextBoxText Contr Preset.ScaleV
						#Diffuse:
							SetTextBoxText Contr Preset.Diffuse
						#Bump:
							SetTextBoxText Contr Preset.Bump
						#Specular:
							SetTextBoxText Contr Preset.Specular
						#PathField:
							SetTextBoxText Contr Preset.Path
						#ModeSwitch:
							SetCheckableState Contr ImportMode Item:Item
						#IDField: (
							SetTextBoxText Contr Preset.IDs
							ImageControl Contr (if ImportMode then #Disable else #Enable) #Null
						)
					)
				)
				#(Preset, (GetFileModDate FilePath))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn TryParseControlValue Contr ValType = (
			local	Res = (
						Contr.Tag.Value.ItemContent
					)
			if Supplied ValType then
				(Res as ValType)
			else
				Res
		),
		fn SavePreset FilePath FileName Preset:unsupplied = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Controls = (GIMS.Core.GUIMgr.GetNewestLayoutControls()),
						ControlItems = Controls.Item
				if not Supplied Preset then
					Preset = (GIMS.CurrentGame.Core.TypeLibrary.UIPreset())
				for ID = 1 to Controls.Count do (
					Contr = ControlItems[ID - 1]
					local	Item = Contr.Tag.Value
					case Item.Name of (
						#BonesMode: (
							Preset.BonesMode = (
								try
									(GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
								catch
									13
							)
						)
						#FlipFaces:
							Preset.FlipFaces = Item.CheckState
						#MirrorX:
							Preset.MirrorX = Item.CheckState
						#MirrorY:
							Preset.MirrorY = Item.CheckState
						#MirrorZ:
							Preset.MirrorZ = Item.CheckState
						#FlipU:
							Preset.FlipU = Item.CheckState
						#FlipV:
							Preset.FlipV = Item.CheckState
						#FormatList:
							Preset.FormatIndex = Contr.SelectedIndex
						#PosX:
							Preset.PositionX = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#PosY:
							Preset.PositionY = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#PosZ:
							Preset.PositionZ = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#RotX:
							Preset.RotationX = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#RotY:
							Preset.RotationY = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#RotZ:
							Preset.RotationZ = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#Scale:
							Preset.Scale = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#OffsetU:
							Preset.OffsetU = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#OffsetV:
							Preset.OffsetV = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#ScaleU:
							Preset.ScaleU = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#ScaleV:
							Preset.ScaleV = (GIMS.NR.Core.GUI.TryParseControlValue Contr Float)
						#Diffuse:
							Preset.Diffuse = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
						#Bump:
							Preset.Bump = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
						#Specular:
							Preset.Specular = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
						#PathField:
							Preset.Path = (GIMS.NR.Core.GUI.TryParseControlValue Contr String)
						#ModeSwitch:
							Preset.ImportMode = Item.CheckState
						#IDField:
							Preset.IDs = (GIMS.NR.Core.GUI.TryParseControlValue Contr String)
					)
				)
				GIMS.Core.CacheMgr.Write Preset FilePath
				Preset
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SelectPreset Sender Args FilePath:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if AllowPresetChange then (
					local	Rules = GIMS.CurrentGame.Rules,
							SelectedPresetID = (Sender.SelectedIndex - 2),
							NextPresetID
					case SelectedPresetID of (
						(-2): (	--Load
							if not Supplied FilePath then (
								FilePath = (
									GetOpenFileName \
										Caption:"Select a preset to load" \
										Types:"GIMS Evo NR preset files|*.Preset" \
										HistoryCategory:"EGIMS_NR_PresetPaths"
								)
							)
							if Have FilePath then (
								local	FileName = (GetFileNameFile FilePath),
										PresetFiles = Rules.PresetFiles,
										FoundID
								for i = 1 to PresetFiles.Count where (StriCmp FilePath PresetFiles[i]) == 0 while No FoundID do
									FoundID = i
								if No FoundID then (
									NextPresetID = (Rules.AddPreset FilePath FileName)
									Sender.Items.Add (DotNETObject "System.String" FileName)
								) else
									NextPresetID = FoundID
							) else (
								NextPresetID = Rules.ActivePresetID
								AllowPresetChange = false
							)
						)
						(-1): (	--Save
							if not Supplied FilePath then (
								FilePath = (
									GetSaveFileName \
										Caption:"Select the preset save path" \
										Types:"GIMS Evo NR preset files|*.Preset" \
										HistoryCategory:"EGIMS_NR_PresetPaths"
								)
							)
							if Have FilePath then (
								local	FileName = (GetFileNameFile FilePath),
										PresetFiles = Rules.PresetFiles,
										PathsResolveEquivalent = PathConfig.PathsResolveEquivalent,
										FoundID
								for i = 1 to PresetFiles.Count where (PathsResolveEquivalent FilePath PresetFiles[i]) while No FoundID do
									FoundID = i
								if No FoundID then (
									NextPresetID = (Rules.AddPreset FilePath FileName)
									Sender.Items.Add (DotNETObject "System.String" FileName)
								) else (
									NextPresetID = FoundID
									Rules.ActivatePreset NextPresetID
								)
								LoadedPresets[NextPresetID] = (SavePreset FilePath FileName)
								LoadedPresetDates[NextPresetID] = (GetFileModDate FilePath)
							) else
								NextPresetID = Rules.ActivePresetID
							AllowPresetChange = false
						)
						0: (	--SPACER
							NextPresetID = Rules.ActivePresetID
							AllowPresetChange = false
						)
						Default: (
							local	FilePath = (Rules.ActivatePreset SelectedPresetID),
									LoadedPreset = LoadedPresets[SelectedPresetID],
									IsFileMissing = (not (DoesFileExist FilePath)),
									FileModDate = (if not IsFileMissing then (GetFileModDate FilePath)),
									IsNewPreset = (
										No LoadedPreset or
										IsFileMissing or
										FileModDate != LoadedPresetDates[SelectedPresetID]
									)
							if IsNewPreset then (
								local	LoadedPresetData = (LoadPreset FilePath Rules.PresetNames[SelectedPresetID] undefined Rules SelectedPresetID)
								LoadedPreset = LoadedPresetData[1]
								if IsFileMissing then
									FileModDate = LoadedPresetData[2]
								LoadedPresets[SelectedPresetID] = LoadedPreset
								LoadedPresetDates[SelectedPresetID] = FileModDate
							) else
								LoadPreset FilePath Rules.PresetNames[SelectedPresetID] LoadedPreset Rules SelectedPresetID
						)
					)
					if Have NextPresetID then (
						try
							Sender.SelectedIndex = (NextPresetID + 2)
						catch
							Sender.SelectedIndex = 3
						SelectPreset Sender Args
					)
				) else
					AllowPresetChange = true
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RemovePreset Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ButtonID = args.Button.value__,
						PresetList = (GIMS.Core.GUIMgr.FindControl #PresetList),
						Rules = GIMS.CurrentGame.Rules
				if
					ButtonID == 1048576 and
					(Rules.RemovePreset())
				then (
					local	SelectedIndex = PresetList.SelectedIndex
					PresetList.Items.RemoveAt SelectedIndex
					PresetList.SelectedIndex = (SelectedIndex - 1)
					SelectPreset PresetList Args
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RestoreState Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FindControl = GIMS.Core.GUIMgr.FindControl,
						PresetList = (FindControl #PresetList),
						FormatList = (FindControl #FormatList),
						CachePath = GIMS.CurrentGame.CachePath,
						RulesPath = (CachePath + "Rules.GSF"),
						DefaultPresetName = "Default",
						DefaultPresetPath = (
							GIMS.Core.ValueOps.FormatText \
								v1:CachePath \
								v2:DefaultPresetName \
								v3:".GSF"
						),
						NoDefaultPresetFile = (not (DoesFileExist DefaultPresetPath)),
						HaveRulesFile = (DoesFileExist RulesPath),
						Rules = (GIMS.CurrentGame.Core.strRules())
				Rules.AddPreset DefaultPresetPath DefaultPresetName
				try (
					Rules = (
						GIMS.Core.CacheMgr.ReadCached \
							undefined \
							undefined \
							GCCFile:"Rules" \
							Type:"GSF" \
							IgnoreBehavior:true \
							DefaultData:Rules
					)
				) catch ()
				local	SetLines = GIMS.Core.GUI.SetLines
				SetLines FormatList (#("Other") + Rules.EngineVDMapping[1])
				FormatList.SelectedIndex = 0
				if NoDefaultPresetFile then (
					LoadedPresets[1] = (SavePreset DefaultPresetPath DefaultPresetName)
					LoadedPresetDates[1] = (GetFileModDate DefaultPresetPath)
				)
				GIMS.CurrentGame.Rules = Rules
				SetLines PresetList (#("Load...", "Save...", "- - - - - - - - -") + Rules.PresetNames)
				try
					PresetList.SelectedIndex = (Rules.ActivePresetID + 2)
				catch
					PresetList.SelectedIndex = 3
				SelectPreset PresetList Args
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StoreState Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	NR = GIMS.NR,
						Rules = NR.Rules,
						ActivePresetID = Rules.ActivePresetID
				if ActivePresetID == 1 then (
					AllowPresetChange = false
					local	PresetList = (GIMS.Core.GUIMgr.FindControl #PresetList)
					PresetList.SelectedIndex = ActivePresetID
					AllowPresetChange = true
					SelectPreset PresetList Args FilePath:((GetFileNamePath Rules.PresetFiles[ActivePresetID]) + "Modified.GSF")
				) else (
					local	FilePath = Rules.PresetFiles[ActivePresetID]
					SavePreset FilePath Rules.PresetNames[ActivePresetID] Preset:LoadedPresets[ActivePresetID]
					LoadedPresetDates[ActivePresetID] = (GetFileModDate FilePath)
				)
				if Rules.Changed then (
					Rules.Changed = false
					GIMS.Core.CacheMgr.Write Rules (NR.CachePath + "Rules.GSF")
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwitchMode Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							IDField = (GUIMgr.FindControl #IDField)
					GUIMgr.SwitchCheckableState Sender Args
					GUIMgr.ImageControl IDField (if Sender.Tag.Value.CheckState then #Disable else #Enable) #Null
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SelectPath Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	FindControl = GIMS.Core.GUIMgr.FindControl,
							ModeSwitch = (FindControl #ModeSwitch),
							PathField = (FindControl #PathField),
							IsSingleFileMode = ModeSwitch.Tag.Value.CheckState,
							NewPath
					if IsSingleFileMode then (
						NewPath = (
							GetOpenFileName \
								Caption:"Select a rip file" \
								Types:"Ninja Ripper rip files|*.rip" \
								HistoryCategory:"EGIMS_NR_RipFilePaths"
						)
					) else
						NewPath = (GetSavePath Caption:"Select the path with rip files")
					if Have NewPath then (
						if not IsSingleFileMode then
							Append NewPath "\\"
						GIMS.Core.GUI.SetTextBoxText PathField NewPath
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBoneMode_0 Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Contr = (GIMS.Core.GUIMgr.FindControl #BonesMode)
				local	Item = Contr.Tag.Value
				Item.ItemContent = "0"
				GIMS.NR.Core.GUI.SetBonesModeControlText Contr Item 0
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBoneMode_1 Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Contr = (GIMS.Core.GUIMgr.FindControl #BonesMode)
				local	BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
				BonesMode = (Bit.Or (Bit.And BonesMode 12) 1)
				local	Item = Contr.Tag.Value
				Item.ItemContent = (BonesMode as String)
				GIMS.NR.Core.GUI.SetBonesModeControlText Contr Item BonesMode
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBoneMode_2 Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Contr = (GIMS.Core.GUIMgr.FindControl #BonesMode)
				local	BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
				BonesMode = (Bit.Or (Bit.And BonesMode 12) 2)
				local	Item = Contr.Tag.Value
				Item.ItemContent = (BonesMode as String)
				GIMS.NR.Core.GUI.SetBonesModeControlText Contr Item BonesMode
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBoneMode_Reuse Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Contr = (GIMS.Core.GUIMgr.FindControl #BonesMode)
				local	BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
				BonesMode = (Bit.Set BonesMode 3 (not (Bit.Get BonesMode 3)))
				local	Item = Contr.Tag.Value
				Item.ItemContent = (BonesMode as String)
				GIMS.NR.Core.GUI.SetBonesModeControlText Contr Item BonesMode
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBoneMode_Split Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Contr = (GIMS.Core.GUIMgr.FindControl #BonesMode)
				local	BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
				BonesMode = (Bit.Set BonesMode 4 (not (Bit.Get BonesMode 4)))
				local	Item = Contr.Tag.Value
				Item.ItemContent = (BonesMode as String)
				GIMS.NR.Core.GUI.SetBonesModeControlText Contr Item BonesMode
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn BonesMode Contr Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Args.Button.value__ == 1048576 then (
					if No BonesContextMenu then (
					
						--create the menu and its items
						local	cms = (DotNETObject "System.Windows.Forms.ContextMenuStrip"),
								tsi0 = (DotNETObject "System.Windows.Forms.ToolStripButton" "Don't create"),
								tsi1 = (DotNETObject "System.Windows.Forms.ToolStripButton" "Create at zero"),
								tsi2 = (DotNETObject "System.Windows.Forms.ToolStripButton" "Create at calculated position"),
								tsis = (DotNETObject "System.Windows.Forms.ToolStripSeparator"),
								tsi3 = (DotNETObject "System.Windows.Forms.ToolStripMenuItem" "Reuse scene bones"),
								tsi4 = (DotNETObject "System.Windows.Forms.ToolStripMenuItem" "Split the mesh by skinning when possible"),
								SetLifetimeController = GIMS.SetLifetimeController
						SetLifetimeController cms #MXS
						SetLifetimeController tsi0 #MXS
						SetLifetimeController tsi1 #MXS
						SetLifetimeController tsi2 #MXS
						SetLifetimeController tsis #MXS
						SetLifetimeController tsi3 #MXS
						SetLifetimeController tsi4 #MXS
												
						--add the menu items
						cms.Items.Add tsi0
						cms.Items.Add tsi1
						cms.Items.Add tsi2
						cms.Items.Add tsis
						cms.Items.Add tsi3
						cms.Items.Add tsi4
						
						--assign item events
						local	AddEventHandler = DotNET.AddEventHandler
						AddEventHandler tsi0 "Click" SetBoneMode_0
						AddEventHandler tsi1 "Click" SetBoneMode_1
						AddEventHandler tsi2 "Click" SetBoneMode_2
						AddEventHandler tsi3 "Click" SetBoneMode_Reuse
						AddEventHandler tsi4 "Click" SetBoneMode_Split
						
						--remember the controls
						BonesContextMenu_Item0 = tsi0
						BonesContextMenu_Item1 = tsi1
						BonesContextMenu_Item2 = tsi2
						BonesContextMenu_Item3 = tsi3
						BonesContextMenu_Item4 = tsi4
						BonesContextMenu = cms
					)
					
					--highlight the current BonesMode state
					local	BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer),
							BitGet = Bit.Get
					BonesContextMenu_Item0.Checked = false
					BonesContextMenu_Item0.Enabled = true
					BonesContextMenu_Item1.Checked = false
					BonesContextMenu_Item1.Enabled = true
					BonesContextMenu_Item2.Checked = false
					BonesContextMenu_Item2.Enabled = true
					BonesContextMenu_Item3.Checked = false
					BonesContextMenu_Item3.Enabled = true
					BonesContextMenu_Item4.Checked = false
					BonesContextMenu_Item4.Enabled = true
					case (Bit.And BonesMode 3) of (
						0: (
							BonesContextMenu_Item0.Checked = true
							BonesContextMenu_Item3.Checked = false
							BonesContextMenu_Item3.Enabled = false
							BonesContextMenu_Item4.Checked = false
							BonesContextMenu_Item4.Enabled = false
						)
						1:
							BonesContextMenu_Item1.Checked = true
						2:
							BonesContextMenu_Item2.Checked = true
						Default:
							throw "Unknown BonesMode: " BonesMode
					)
					if (BitGet BonesMode 3) then
						BonesContextMenu_Item3.Checked = true
					if (BitGet BonesMode 4) then
						BonesContextMenu_Item4.Checked = true
							
					--show the menu
					--local	MousePos = Mouse.ScreenPos
					--BonesContextMenu.Show MousePos.x MousePos.y
					local	ControlLocation = (GIMS.Core.GUIMgr.MainWindow.PointToScreen Contr.Location)
					BonesContextMenu.Show ControlLocation.x (ControlLocation.y + Contr.Height + 2)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import_Files Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjectMgr = GIMS.Core.ObjectMgr,
						SystemMgr = GIMS.Core.SystemMgr,
						AddResult = SystemMgr.AddResult,
						ProcessParams = ObjectMgr.ExchangeData[3],
						VDMaps = ProcessParams[1],
						Files = ObjectMgr.ExchangeData[2],
						FileCount = Files.Count
				if FileCount != 0 then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast,
							FileStrings = #(),
							Stage1String = "\t> Read from file",
							Stage2String = "\t> Create in scene"
					FileStrings.Count = (FileCount * 3)
					for i = 1 to FileCount do (
						local	File = Files[i],
								FileType = (GetFileNameType File)
						FileType = (TypeCast (SubString FileType 2 FileType.Count) name)
						local	FileString = (
									( \
										case FileType of (
											#rip:
												"Rip: "
											Default:
												"Unknown: "	--throw "Unknown file type in " File
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
							TextureIDs = ProcessParams[2],
							FlipFaces = ProcessParams[3],
							MeshTransform = ProcessParams[4],
							BonesMode = ProcessParams[5],
							UOffset = ProcessParams[6],
							VOffset = ProcessParams[7],
							UScale = ProcessParams[8],
							VScale = ProcessParams[9],
							ProMode = ProcessParams[10],
							BoneNodes = unsupplied,
							UsedBones = unsupplied,
							MaterialsMHL = #(#(), #()),
							AppendMHL = GIMS.Core.ArrayOps.AppendMHL,
							IsSomethingImported = false
					MAX Create Mode
					GUIMgr.InitProgress FileStrings Title:"Import"
					for TheMaterial in SceneMaterials where (IsKindOf TheMaterial Standard) do (
						local	DiffMap = TheMaterial.DiffuseMap,
								BumpMap = TheMaterial.BumpMap,
								SpecMap = TheMaterial.SpecularLevelMap,
								HaveDiff = (Have DiffMap),
								HaveBump = (Have BumpMap),
								HaveSpec = (Have SpecMap),
								IsDiffValid = false,
								IsBumpValid = false,
								IsSpecValid = false,
								MaterialHash = ""
						if HaveDiff then (
							if (IsKindOf DiffMap BitmapTexture) then (
								Append MaterialHash (FileNameFromPath DiffMap.FileName)
								IsDiffValid = true
							)
						)
						if HaveBump then (
							if (IsKindOf BumpMap Normal_Bump) then (
								BumpMap = BumpMap.Normal_Map
								if (IsKindOf BumpMap BitmapTexture) then (
									Append MaterialHash (FileNameFromPath BumpMap.FileName)
									IsBumpValid = true
								)
							)
							if not IsBumpValid then
								Append MaterialHash "_"
							IsBumpValid = true
						)
						if HaveSpec then (
							if (IsKindOf SpecMap RGB_Tint) then (
								SpecMap = SpecMap.Map1
								if (IsKindOf SpecMap BitmapTexture) then (
									Append MaterialHash (FileNameFromPath SpecMap.FileName)
									IsSpecValid = true
								)
							)
							if not IsSpecValid then
								Append MaterialHash "_"
							IsSpecValid = true
						)
						if
							IsDiffValid and
							IsBumpValid and
							IsSpecValid
						then
							AppendMHL MaterialsMHL TheMaterial Sorted:true Hash:(GIMS.Core.ValueOps.GetHash MaterialHash)
					)
					local	BitGet = Bit.Get,
							IsReuseBones = (BitGet BonesMode 3),
							CanSplitSkinning = (BitGet BonesMode 4),
							IsGuessBonePosMode = false,
							BonePositions = unsupplied,
							BonePosWeights = unsupplied
					case (Bit.And BonesMode 3) of (
						0: ()
						1: ()
						2: (
							IsGuessBonePosMode = true
							BonePositions = #()
							BonePosWeights = #()
						)
						Default:
							throw "Unknown BonesMode: " BonesMode
					)
					local	SceneBones = #{},
							HaveBonesMode = (BonesMode != 0)
					if HaveBonesMode then (
						BoneNodes = #()
						UsedBones = #{}
						local	DefaultBoneCount = 150,
								BoxSize = [0.01, 0.01, 0.01],
								WireColor = Yellow					
						UsedBones.Count = DefaultBoneCount
						if IsReuseBones then (
							--find bones in scene
							BoneNodes.Count = DefaultBoneCount
							SceneBones.Count = Objects.Count
							for Obj in Objects where
								(IsKindOf Obj Dummy) and
								Obj.Parent == undefined
							do (
								local	ObjName = Obj.Name
								if (MatchPattern ObjName Pattern:"bone_*") then (
									local	NameItems = (FilterString ObjName "_")
									if NameItems.Count == 2 then (
										local	ID = (NameItems[2] as Integer)
										if Have ID then (
											BoneNodes[ID] = Obj
											SceneBones[ID] = true
										)
									)
								)
							)		
							--pre-create bones
							for i = DefaultBoneCount to 1 by -1 where not SceneBones[i] do (
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
						)
					)
					if HaveBonesMode then (
						if IsReuseBones then (
							--create meshes reusing scene bones
							for FileID = 1 to FileCount do (
								UpdateProgress #Stage (((FileID - 1) * 3) + 2)
								local	Obj = (StructFromFile Files[FileID] VDMaps)
								if Have Obj then (
									UpdateProgress #AddStage 1
									Obj.Create \
										RootNode \
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
										ProMode
									IsSomethingImported = true
								)
							)
							--remove unused bones and set guessed bone positions
							if IsGuessBonePosMode then (
								local	SkinMods = #(),
										SkinModCount = 0
								SkinMods.Count = Objects.Count
								for Obj in Objects do (
									for SkinMod in Obj.Modifiers where (IsKindOf SkinMod Skin) do (
										SkinModCount += 1
										SkinMods[SkinModCount] = SkinMod
										EGIMS_SelectModifier SkinMod
										SkinMod.Always_Deform = false
									)
								)
								SkinMods.Count = SkinModCount
								for i = 1 to BoneNodes.Count do (
									if UsedBones[i] then (
										local	BoneNode = BoneNodes[i],
												Children = BoneNode.Children,
												ChildrenCount = Children.Count,
												ChildrenTransforms = #()
										for j = ChildrenCount to 1 by -1 do
											ChildrenTransforms[j] = Children[j].Transform
										BoneNode.Pos = (BonePositions[i] * MeshTransform)
										for j = ChildrenCount to 1 by -1 do
											Children[j].Transform = ChildrenTransforms[j]
									) else (
										if
											not SceneBones[i] and
											Have BoneNodes[i]
										then
											Delete BoneNodes[i]
									)
								)
								for SkinMod in SkinMods do (
									EGIMS_SelectModifier SkinMod
									SkinMod.Always_Deform = true
								)
							) else (
								for i = 1 to BoneNodes.Count where
									not UsedBones[i] and
									not SceneBones[i] and
									Have BoneNodes[i]
								do
									Delete BoneNodes[i]
							)
						) else (
							--create meshes with new bones set for every one
							for FileID = 1 to FileCount do (
								UpdateProgress #Stage (((FileID - 1) * 3) + 2)
								local	Obj = (StructFromFile Files[FileID] VDMaps)
								if Have Obj then (
									UpdateProgress #AddStage 1
									--pre-create bones
									if IsGuessBonePosMode then (
										BonePositions.Count = DefaultBoneCount
										BonePosWeights.Count = DefaultBoneCount
									)
									BoneNodes.Count = DefaultBoneCount
									UsedBones.Count = DefaultBoneCount
									for i = DefaultBoneCount to 1 by -1 do (
										UsedBones[i] = false
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
									Obj.Create \
										RootNode \
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
										ProMode
									--remove unused bones and set guessed bone positions
									if IsGuessBonePosMode then (
										MAX Modify Mode
										local	SkinMods = #(),
												SkinModCount = 0
										SkinMods.Count = Objects.Count
										for Obj in Objects do (
											for SkinMod in Obj.Modifiers where (IsKindOf SkinMod Skin) do (
												SkinModCount += 1
												SkinMods[SkinModCount] = SkinMod
												EGIMS_SelectModifier SkinMod
												SkinMod.Always_Deform = false
											)
										)
										SkinMods.Count = SkinModCount
										for i = 1 to BoneNodes.Count do (
											if UsedBones[i] then (
												local	BoneNode = BoneNodes[i],
														Children = BoneNode.Children,
														ChildrenCount = Children.Count,
														ChildrenTransforms = #()
												for j = ChildrenCount to 1 by -1 do
													ChildrenTransforms[j] = Children[j].Transform
												BoneNode.Pos = (BonePositions[i] * MeshTransform)
												for j = ChildrenCount to 1 by -1 do
													Children[j].Transform = ChildrenTransforms[j]
											) else (
												if Have BoneNodes[i] then
													Delete BoneNodes[i]
											)
											BonePositions[i] = undefined
										)
										for SkinMod in SkinMods do (
											EGIMS_SelectModifier SkinMod
											SkinMod.Always_Deform = true
										)
										MAX Create Mode
									) else (
										for i = 1 to BoneNodes.Count where
											not UsedBones[i] and
											Have BoneNodes[i]
										do
											Delete BoneNodes[i]
									)
									IsSomethingImported = true
								)
							)
						)
					) else (
						--create meshes without any bones
						for FileID = 1 to FileCount do (
							UpdateProgress #Stage (((FileID - 1) * 3) + 2)
							local	Obj = (StructFromFile Files[FileID] VDMaps)
							if Have Obj then (
								UpdateProgress #AddStage 1
								Obj.Create \
									RootNode \
									VDMaps \
									TextureIDs \
									FlipFaces \
									false \
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
									ProMode
								IsSomethingImported = true
							)
						)
					)
					if not IsSomethingImported then
						AddResult #Error "Can't import anything."
					GUIMgr.EndProgress true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import Sender Args = (
			local	Contr
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GUIMgr = GIMS.Core.GUIMgr,
							Controls = (GUIMgr.GetNewestLayoutControls()),
							ControlCount = Controls.Count,
							ControlItems = Controls.Item,
							InvalidFields = #(),
							InvalidFieldCount = 0,
							IsSingleFileMode = true,
							ThePath, IDMask,
							ValueOps = GIMS.Core.ValueOps,
							TypeCast = ValueOps.TypeCast,
							Controls = (GUIMgr.GetNewestLayoutControls()),
							ControlItems = Controls.Item,
							VDMaps = unsupplied,
							TextureIDs = #(
								#NoDiffuse,	--Diffuse
								#NoBump,	--Bump
								#NoSpecular	--Specular
							),
							UOffset = 0,
							VOffset = 0,
							UScale = 1,
							VScale = 1,
							FlipFaces = false,
							MeshPosX = 0,
							MeshPosY = 0,
							MeshPosZ = 0,
							MeshRotX = 0,
							MeshRotY = 0,
							MeshRotZ = 0,
							MeshScaleX = 1,
							MeshScaleY = 1,
							MeshScaleZ = 1,
							BonesMode = 0,
							Rules = GIMS.CurrentGame.Rules,
							ProMode = Rules.ProMode
					InvalidFields.Count = ControlCount
					for ID = 1 to ControlCount do (
						Contr = ControlItems[ID - 1]
						local	Item = Contr.Tag.Value,
								ItemName = Item.Name
						case ItemName of (
							#ModeSwitch:
								IsSingleFileMode = Item.CheckState
							#PathField:
								ThePath = (GIMS.NR.Core.GUI.TryParseControlValue Contr String)
							#IDField:
								IDMask = (GIMS.NR.Core.GUI.TryParseControlValue Contr String)
							#BonesMode:
								BonesMode = (GIMS.NR.Core.GUI.TryParseControlValue Contr Integer)
							#FlipFaces:
								FlipFaces = Item.CheckState
							#MirrorX: (
								if Item.CheckState then
									MeshScaleX *= -1
							)
							#MirrorY: (
								if Item.CheckState then
									MeshScaleY *= -1
							)
							#MirrorZ: (
								if Item.CheckState then
									MeshScaleZ *= -1
							)
							#FlipU: (
								if Item.CheckState then
									UScale *= -1
							)
							#FlipV: (
								if Item.CheckState then
									VScale *= -1
							)
							#FormatList: (
								local	FormatID = Contr.SelectedIndex
								if FormatID != 0 then
									VDMaps = Rules.EngineVDMapping[2][FormatID]
							)
							#PosX:
								MeshPosX = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#PosY:
								MeshPosY = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#PosZ:
								MeshPosZ = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#RotX:
								MeshRotX = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#RotY:
								MeshRotY = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#RotZ:
								MeshRotZ = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#Scale: (
								local	ScaleVal = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
								MeshScaleX *= ScaleVal
								MeshScaleY *= ScaleVal
								MeshScaleZ *= ScaleVal
							)
							#OffsetU:
								UOffset = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#OffsetV:
								VOffset = (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#ScaleU:
								UScale *= (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#ScaleV:
								VScale *= (TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Float)
							#Diffuse:
								TextureIDs[1] = ((TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Integer) + 1)
							#Bump:
								TextureIDs[2] = ((TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Integer) + 1)
							#Specular:
								TextureIDs[3] = ((TypeCast (GIMS.NR.Core.GUI.TryParseControlValue Contr unsupplied) Integer) + 1)
						)
						local	HandlerName = Item.EventNames[9]
						if
							HandlerName != #Null and
							((GetProperty GIMS.Core.GUI HandlerName) Contr undefined) == false
						then (
							InvalidFieldCount += 1
							InvalidFields[InvalidFieldCount] = Item.ItemText
						)
					)
					if InvalidFieldCount == 0 then (
						local	MeshTransform = (Matrix3 1)
						MeshTransform.Rotation = (EulerAngles MeshRotX MeshRotY MeshRotZ)
						MeshTransform.Pos = [MeshPosX, MeshPosY, MeshPosZ]
						PreScale MeshTransform [MeshScaleX, MeshScaleY, MeshScaleZ]
						local	Result = true,
								ProcessParams = #(
									VDMaps,
									TextureIDs,
									FlipFaces,
									MeshTransform,
									BonesMode,
									(UOffset - (Floor UOffset)),
									(VOffset - (Floor VOffset)),
									UScale,
									VScale,
									ProMode
								)
						if IsSingleFileMode then (
							if
								(DoesFileExist ThePath) and
								(StriCmp (GetFileNameType ThePath) ".rip") == 0 and
								(GetFileNameFile ThePath).Count != 0
							then
								GIMS.Core.ObjectMgr.ExchangeData = #(undefined, #(ThePath), ProcessParams)
							else
								Result = false
						) else (
							local	Sequences = (FilterString IDMask ","),
									SeqPattern = "*-*",
									SeqSeparator = "\t -",
									FileIDs = #{},
									AddNullID = false
							for Sequence in Sequences do (
								if (MatchPattern Sequence Pattern:SeqPattern) then (
									local	SeqRange = (FilterString Sequence SeqSeparator),
											SeqRangeCount = SeqRange.Count
									if SeqRangeCount == 1 then (
										for ID = (TypeCast SeqRange[1] Integer) to 1 by -1 do
											FileIDs[ID] = true
									) else (
										for i = 1 to (SeqRangeCount - 1) do (
											local	StartID = (TypeCast SeqRange[i] Integer),
													EndID = (TypeCast SeqRange[i + 1] Integer),
													LoopStep = (Ternary (StartID < EndID) -1 1)
											for ID = EndID to StartID by LoopStep do (
												if ID == 0 then (
													AddNullID = true
													ID += 1
												)
												FileIDs[ID] = true
											)
										)
									)
								) else (
									local	ID = (TypeCast Sequence Integer)
									if ID == 0 then (
										AddNullID = true
										ID += 1
									)
									FileIDs[ID] = true
								)
							)
							local	FilePaths = #(),
									FormatText = ValueOps.FormatText,
									FilePtr = 0,
								TheDir = (Copy ThePath)
							if Have IsDirectoryWriteable then (
								local	LastSymbol
								while
									(LastSymbol = TheDir[TheDir.Count]) == "\\" or
									LastSymbol == "/"
								do
									TheDir = (SubString TheDir 1 (TheDir.Count - 1))
								if (IsDirectoryWriteable TheDir) then
									Append TheDir "\\"
								else
									TheDir = (GetFileNamePath TheDir)
							) else
								Append TheDir "\\"
							local	FileName = "Mesh_",
									IDFormat = "0.4d",
									FileExt = ".rip"
							FilePaths.Count = FileIDs.NumberSet
							if AddNullID then (
								local	FilePath = (TheDir + "Mesh_0000.rip")
								if (DoesFileExist FilePath) then (
									FilePtr += 1
									FilePaths[FilePtr] = FilePath
								)
							)
							for FileID in (FileIDs as Array) do (
								local	FilePath = (
											FormatText \
												v1:TheDir \
												v2:FileName \
												v3:(FormattedPrint FileID Format:IDFormat) \
												v4:FileExt
										)
								if (DoesFileExist FilePath) then (
									FilePtr += 1
									FilePaths[FilePtr] = FilePath
								)
							)
							FilePaths.Count = FilePtr
							if FilePtr != 0 then
								GIMS.Core.ObjectMgr.ExchangeData = #(undefined, FilePaths, ProcessParams)
							else
								Result = false
						)
						if Result then
							Import_Files Sender Args
						else (
							GIMS.Core.SystemMgr.AddResult #Error "Can't find the files to import.\nPlease check the path, and/or file IDs."
							GUIMgr.EndProgress true
						)
					) else (
						local	ss = (StringStream "")
						Print "Please check these input fields:" To:ss
						for i = 1 to InvalidFieldCount do (
							local	str = InvalidFields[i]
							Format "\n%" (SubString str 1 (str.Count - 2)) To:ss
						)
						GIMS.Core.SystemMgr.AddResult #Error (ss as String)
						Free ss
						GUIMgr.EndProgress true
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	GIMS.CurrentGame.Core.GUI = GUIstr()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS)*//*<PROFILERENDED>*/
