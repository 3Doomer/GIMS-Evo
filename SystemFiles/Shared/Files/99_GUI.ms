/*#PC*DEFINE	CurrentGame	Shared*/
(
	/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
	/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI.GUI_Layout*/strGUI_Layout (
		Name,
		Pos,
		ItemText,
		EvtOnLoadCore,
		EvtOnLoadWindowOnly,
		EvtOnCloseCore,
		EvtOnLoad,
		EvtOnClose,
		HasBackButton,
		StoreInRolloutChain,
		BackColor,
		ForeColor,
		HeaderTextAlign,
		SubItems,
		Lang,
		CoreTag,
		Core,
		LastLayout,
		LastCore
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI.GUI_Item*/strGUI_Item (
		Name = #Null,
		Pos = [0, 0, 0],
		ItemSize = [9, 9],
		DefaultState = true,
		CheckState = true,
		ChangeIcon = false,
		Animated = false,
		Icon = #Null,
		IconSize = [7, 7],
		ImageAlign = 4,
		TextImageRelation = 1,
		ItemType = 1,
		ItemText = "",
		ItemContent = "",
		Font = 3,
		BackColor = 1,
		ForeColor = 2,
		ScrollOrient = 1,
		SelectionMode = 2,
		EventTypes = #(1, 1, 1, 1, 1, 1, 1, 1, 1),
		EventCores = #(2, 2, 2, 2, 2, 2, 2, 2, 2),
		EventNames = #(#Null, #Null, #Null, #Null, #Null, #Null, #Null, #Null, #Null),
		Clickable = true,
		Scrollable = false,
		TextAlign = 2,
		GroupID = 1,
		SubItems = #()
	)
	struct /*#PC*PATH	GIMS.Core.GUI.LeftButtonClickDummy.Button*/strLeftButtonClickDummyBtn (
		value__ = 1048576
	)
	struct /*#PC*PATH	GIMS.Core.GUI.LeftButtonClickDummy*/strLeftButtonClickDummy (
		Button = strLeftButtonClickDummyBtn()
	)
	
	struct /*#PC*PATH	GIMS.CurrentGame.Core.GUI*/strGUI (
	/*Props*/
		LeftButtonClickDummy = strLeftButtonClickDummy(),
		GUI_Layout = strGUI_Layout,
		GUI_Item = strGUI_Item,
		ReportLayout_CallerGame,
	/*Viewport rendering*/
		SelectedAreaStart,
		SelectedAreaEnd,
		SelectingArea = false,
	/*Internal Ops*/
		fn SetTextBoxText Contr Txt = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Txt = (Txt as String)
				local	Item = Contr.Tag.Value
				Item.ItemContent = Txt
				Contr.Text = (Item.ItemText + Txt)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetCheckableState Control State Item:unsupplied Preview:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not Supplied Item then
					Item = Control.Tag.Value
				local	tIcon = (
							case Item.ItemType of (
								6: ( /*"CheckBox"*/
									if Preview then
										#CheckMark
									else (
										if State then
											#Checked
										else
											#UnChecked
									)
								)
								7: ( /*"SwitchBox"*/
									if Preview then (
										if State then
											#SwitchMarkRight
										else
											#SwitchMarkLeft
									) else (
										if State then
											#SwitchLeft
										else
											#SwitchRight
									)
								)
								11: ( /*"RadioBox"*/
									if Preview then
										#RadioMark
									else (
										if State then
											#RadioOn
										else
											#RadioOff
									)
								)
								Default:
									throw ("Unknown checkable control type: " + Item.ItemType as String)
							)
						)
				if not Preview then (
					Item.Icon = tIcon
					Item.CheckState = State
				)	
				GIMS.Core.GUIMgr.ImageControl Control #Enable tIcon Size:Item.IconSize
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwitchCheckableState Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	Item = Sender.Tag.Value
					SetCheckableState Sender (not Item.CheckState) Item:Item
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetCheckableState Control = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Control.Tag.Value.CheckState
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwitchRadioState Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	Item = Sender.Tag.Value
					if not Item.CheckState then (
						SetCheckableState Sender true Item:Item
						local	GUIMgr = GIMS.Core.GUIMgr,
								TargetGroupID = Item.GroupID,
								Controls = GUIMgr.MainWindow.Controls,
								ControlsItem = Controls.Item,
								Result
						for ID = 1 to Controls.Count while No Result do (
							local	Control = ControlsItem[ID - 1],
									Item = Control.Tag.Value
							if
								Item.ItemType == 11 and	--RadioBox
								Item.GroupID == TargetGroupID
							then
								SetCheckableState Control false Item:Item
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetLines ListControl TextLines CharLimit:2000 Multiline:false KeepOneEmptyLine:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ListControl.BeginUpdate()
				ListControl.Items.Clear()
				for tLine in TextLines do (
					if (MatchPattern tLine Pattern:"*\n*") then (
						local	LineItems = (FilterString tLine "\n")
						if KeepOneEmptyLine then (
							for i = LineItems.Count to 2 by -1 where (
								((TrimLeft (TrimRight LineItems[i])).Count == 0) and
								((TrimLeft (TrimRight LineItems[i - 1])).Count == 0)
							) do
								DeleteItem LineItems i
						)
						if Multiline then (
							for i = 1 to LineItems.Count do (
								local	txt = LineItems[i]
								if txt.Count > CharLimit then
									txt = (Append (SubString txt 1 CharLimit) " <...>")
								LineItems[i] = (DotNETObject "System.String" txt)
							)
						) else (
							for i = 1 to LineItems.Count do (
								local	txt = LineItems[i]
								if txt.Count > CharLimit then
									txt = (Append (SubString txt 1 CharLimit) " <...>")
								if i == 1 then
									LineItems[i] = (DotNETObject "System.String" txt)
								else
									LineItems[i] = (DotNETObject "System.String" (Append "... " txt))
							)
						)
						ListControl.Items.AddRange LineItems
					) else (
						if tLine.Count > CharLimit then
							tLine = ((SubString tLine 1 CharLimit) + " <...>")
						ListControl.Items.Add (DotNETObject "System.String" tLine)
					)
				)
				ListControl.EndUpdate()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetControlProperties Controls PropertyName Data ControlIDs:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Supplied ControlIDs then (
					local	Iterator = 1
					for ControlID in ControlIDs do (
						SetProperty Controls[ControlID] PropertyName Data[Iterator]
						Iterator += 1
					)
				) else (
					for tControl in Controls do
						SetProperty tControl PropertyName Data
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetControlProperties Controls PropertyName ControlIDs:unsupplied AsBitArray:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (
							if AsBitArray then
								#{}
							else
								#()
						),
						IDMode = (Supplied ControlIDs),
						ResultCount
				if IDMode then (
					local	IDCount = ControlIDs.Count,
							FirstID
					for i = 1 to IDCount where ControlIDs[i] while No FirstID do
						FirstID = i
					ResultCount = (IDCount - FirstID)
				) else
					ResultCount = Controls.Count
				Result.Count = ResultCount
				if IDMode then (
					local	Iterator = 1
					if AsBitArray then (
						for i in ControlIDs do (
							Result[Iterator] = (GetProperty Controls[i] PropertyName)
							Iterator += 1
						)
					) else (
						for i = 1 to ResultCount do (
							Result[Iterator] = (
								if ControlIDs[i] then
									(GetProperty Controls[i] PropertyName)
							)
							Iterator += 1
						)
					)
				) else (
					for i = 1 to ResultCount do
						Result[i] = (GetProperty Controls[i] PropertyName)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SelectFiles Title Multiselect FileFilter = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Dialog = (DotNetObject "System.Windows.Forms.OpenFileDialog")
				GIMS.SetLifetimeController Dialog #MXS
				Dialog.Title = Title
				Dialog.Multiselect = Multiselect
				Dialog.Filter = FileFilter
				Dialog.InitialDirectory = GIMS.Core.GUIMgr.LastPath
				Dialog.ShowDialog()
				local	FileNames = Dialog.FileNames,
						FileCount = FileNames.Count
				if FileCount != 0 then (
					local	Filters = #(),
							FileItems = (FilterString FileFilter "|")
					for i = 2 to FileItems.Count by 2 do
						Filters += (FilterString FileItems[i] ";")
					for i = FileCount to 1 by -1 do (
						local	IsMatching = false,
								FileNameWithExt = (FileNameFromPath FileNames[i])
						for j = 1 to Filters.Count where (MatchPattern FileNameWithExt Pattern:Filters[j]) while not IsMatching do
							IsMatching = true
						if not IsMatching then (
							DeleteItem FileNames i
							FileCount -= 1
						)
					)
					if FileCount != 0 then
						GIMS.Core.GUIMgr.LastPath = (GetFileNamePath FileNames[1])
				)
				FileNames
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
	/*Ops*/
		fn ContinueFromSelection Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ExchangeData = GIMS.Core.ObjectMgr.ExchangeData
				if (IsKindOf ExchangeData array) then (
					local	ExchangeDataInfo = ExchangeData[1]
					if
						(IsKindOf ExchangeDataInfo array) and
						ExchangeDataInfo.Count == 4
					then
						GIMS.Core.GUIMgr.InvokeEvent ExchangeDataInfo[1] ExchangeDataInfo[2] ExchangeDataInfo[3] ExchangeDataInfo[4] Sender Args
				) else
					throw ("Wrong ExchangeData:" + (ExchangeData as String))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowErrors Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FindControl = GIMS.Core.GUIMgr.FindControl,
						List = (FindControl #ErrorList),
						TipControl = (FindControl #TipControl),
						CallerGame = undefined
				if GIMS.CurrentGame.IsUpdateDeclined then
					TipControl.Text = "Please update GIMS to avoid errors in future"
				SetLines List #(GIMS.Core.SystemMgr.ErrorStream as String)
				if (IsKindOf args Array) then (
					local	ArgNames = args[1]
					if (IsKindOf ArgNames Array) then (
						for i = 1 to ArgNames.Count where ArgNames[i] == #CallerGame while No CallerGame do
							CallerGame = args[2][i]
					)
				)
				ReportLayout_CallerGame = (
					if No CallerGame then
						GIMS.Shared
					else
						CallerGame
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetResults State tSwitch List SwitchItem GUIMgr Warnings Errors = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MainWindow = GUIMgr.MainWindow,
						MessageInfo = (
							if State then
								Errors
							else
								Warnings
						),
						FormatText = GIMS.Core.ValueOps.FormatText,
						Messages = MessageInfo[1],
						Counts = MessageInfo[3],
						AddInfos = MessageInfo[4],
						MessageCount = Messages.Count,
						MessageLines = #()
				MessageLines.Count = MessageCount
				for i = 1 to MessageCount do (
					local	Count = Counts[i],
							AddInfo = AddInfos[i][1],
							MessageLine = (
								if Count > 1 then (
									FormatText \
										v1:Count \
										v2:" times: " \
										v3:Messages[i]
								) else
									Messages[i]
							)
					if AddInfo.Count != 0 then (
						for AddInfoLine in AddInfo do
							Append MessageLine ("\n" + AddInfoLine)
					)
					MessageLines[i] = MessageLine
				)
				MainWindow.SuspendLayout()
				SetCheckableState tSwitch (not State) Item:SwitchItem
				SetLines List MessageLines
				MainWindow.SuspendLayout()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyResults Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	SystemMgr = GIMS.Core.SystemMgr,
							Warnings = SystemMgr.Warnings,
							Errors = SystemMgr.Errors,
							MsgWarnings = Warnings[1],
							MsgErrors = Errors[1],
							MsgCountWarnings = Warnings[3],
							MsgCountErrors = Errors[3],
							MsgAIWarnings = Warnings[4],
							MsgAIErrors = Errors[4],
							WarningCount = MsgWarnings.Count,
							ErrorCount = MsgErrors.Count,
							ss = (StringStream "")
					Format "[% errors]\n" ErrorCount To:ss
					for i = 1 to ErrorCount do (
						Format "% times:\t%\n" MsgCountErrors[i] MsgErrors[i] To:ss
						local	AddInfos = MsgAIErrors[i][1]
						if AddInfos.Count != 0 then (
							for Msg in AddInfos do
								Format "...\t%\n" Msg To:ss
						)
					)
					Format "[% warnings]\n" WarningCount To:ss
					for i = 1 to WarningCount do (
						Format "% times:\t%\n" MsgCountWarnings[i] MsgWarnings[i] To:ss
						local	AddInfos = MsgAIWarnings[i][1]
						if AddInfos.Count != 0 then (
							for Msg in AddInfos do
								Format "...\t%\n" Msg To:ss
						)
					)
					if (SetClipboardText (ss as String)) then
						MessageBox "The errors and warnings have copied to the clipboard." Title:"GIMS Evo messages"
					else
						MessageBox "Can't copy the errors and warnings to the clipboard.\nMay be, it's occupied by another application.\nPlease try again." Title:"GIMS Evo messages"
					Free ss
					OK
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyChangeLog Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	FindControl = GIMS.Core.GUIMgr.FindControl,
							DateList = (FindControl #DateList),
							ChangeItems = (FindControl #ChangeList).Items,
							ChangeItemsItem = ChangeItems.Item,
							ss = (StringStream "")
					Format "GIMS Evo % core release %\n" GIMS.CurrentGame.Name DateList.Items.Item[DateList.SelectedIndex] To:ss
					for i = 1 to ChangeItems.Count do
						Format "%\n" ChangeItemsItem[i - 1] To:ss
					if (SetClipboardText (ss as String)) then
						MessageBox "The changelog was copied to the clipboard." Title:"GIMS Evo changelog"
					else
						MessageBox "Can't copy the changelog to the clipboard.\nMay be, it's occupied by another application.\nPlease try again." Title:"GIMS Evo changelog"
					Free ss
					OK
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowResults Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SystemMgr = GIMS.Core.SystemMgr,
						GUIMgr = GIMS.Core.GUIMgr,
						FindControl = GUIMgr.FindControl,
						Warnings = SystemMgr.Warnings,
						WarningCount = Warnings[1].Count,
						Errors = SystemMgr.Errors,
						ErrorCount = Errors[1].Count,
						tSwitch = (FindControl #ResultSwitch),
						List = (FindControl #ResultList),
						WarnLabel = (FindControl #WarnLabel),
						ErrLabel = (FindControl #ErrLabel),
						State = (ErrorCount != 0)
				WarnLabel.Text = (Append (WarningCount as String) WarnLabel.Text)
				ErrLabel.Text = (Append (ErrorCount as String) ErrLabel.Text)
				SetResults State tSwitch List tSwitch.Tag.Value GUIMgr Warnings Errors
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwitchResults Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	SystemMgr = GIMS.Core.SystemMgr,
							GUIMgr = GIMS.Core.GUIMgr,
							FindControl = GUIMgr.FindControl,
							Warnings = SystemMgr.Warnings,
							Errors = SystemMgr.Errors,
							List = (FindControl #ResultList),
							Item = Sender.Tag.Value
					if
						(
							Item.CheckState and
							Errors[1].Count != 0
						) or (
							not Item.CheckState and
							Warnings[1].Count != 0
						)
					then
						SetResults Item.CheckState Sender List Item GUIMgr Warnings Errors
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ClearResults Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SystemMgr = GIMS.Core.SystemMgr,
						Warnings = SystemMgr.Warnings,
						Errors = SystemMgr.Errors
				Free Warnings[1]
				Free Warnings[2]
				Free Warnings[3]
				Free Warnings[4]
				SystemMgr.LastWarningID = 0
				Free Errors[1]
				Free Errors[2]
				Free Errors[3]
				Free Errors[4]
				SystemMgr.LastErrorID = 0
				GIMS.Core.BufferMgr.ClearBuffer 0
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReplaceChars Source ReplaceTags = (
			try (
				GIMS.Core.StringOps.ReplaceChars Source ReplaceTags:ReplaceTags
			) catch (
				local	TagsWhat = ReplaceTags[1],
						TagsWith = ReplaceTags[2],
						TagCount = TagsWhat.Count
				if TagCount != TagsWith.Count then
					throw
				for TagID = 1 to TagCount do
					Source = (SubstituteString Source TagsWhat[TagID] TagsWith[TagID])
				Source
			)
		),
		fn SimpleComparator v1 v2 = (
			if v1 == v2 then
				0
			else (
				if v1 > v2 then
					1
				else
					-1
			)
		),
		fn MakeErrorName ErrorText = (
			local	Result = "",
					CharsAdded = 0,
					InvalidChars = #("\r", "\n", "\t", " ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "{", "|", "}", "~"),	--<HINT> sorted aray
					skipChar = false
			for i = 1 to ErrorText.Count while CharsAdded < 64 do (
				local	chr = ErrorText[i],
						IsValidChar = (
							if Have BSearch then
								(No (BSearch chr InvalidChars SimpleComparator))
							else
								IsValidChar = ((FindItem InvalidChars chr) == 0)
						)
				if IsValidChar then (
					if skipChar then (
						Append Result (
							try
								(ToUpper chr)
							catch
								chr
						)
						skipChar = false
					) else
						Append Result chr
					CharsAdded += 1
				) else
					skipChar = true
			)
			Result
		),
		fn OVI_SendReport ErrorStream = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ValueOps = GIMS.Core.ValueOps,
						CurrentGameTag = ReportLayout_CallerGame.Tag,
						GConfigProps = ReportLayout_CallerGame.Core.ConfigProps,
						StringOps = GIMS.Core.StringOps,
						RequestStream = (StringStream ""),
						WinReg = try (DotNetClass "Microsoft.Win32.Registry") catch (),
						GameID = (StringOps.ToHighReg (CurrentGameTag as String)),
						tMAXVersion = (MaxVersion()),
						ApplicationVersion = (
							ValueOps.FormatText \
								v1:tMAXVersion[1] \
								v2:tMAXVersion[2] \
								v3:tMAXVersion[3]
						),
						WindowsVersion = (
							try
								(WinReg.GetValue "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" "CurrentBuild" "WindowsVersionError")
							catch
								"<WindowsVersionError>"
						),
						DataStream = (StringStream ""),
						HostName = SysInfo.ComputerName,
						DomainName = "<DomainGetError>"
				try (GIMS.SetLifetimeController WinReg #MXS) catch ()
				try (
					local	cIPGlobalProperties = (DotNetClass "System.Net.NetworkInformation.IPGlobalProperties"),
							IPGlobalProperties = (cIPGlobalProperties.GetIPGlobalProperties())
					try (GIMS.SetLifetimeController cIPGlobalProperties #MXS) catch ()
					try (GIMS.SetLifetimeController IPGlobalProperties #MXS) catch ()
					DomainName = IPGlobalProperties.DomainName
					HostName = IPGlobalProperties.HostName
				) catch ()
				Format "GIMS % core build %\n" GIMS.Shared.Name GIMS.Core.ConfigProps.BuildDate To:DataStream
				if ReportLayout_CallerGame != GIMS.Shared then
					Format "GIMS % core build %\n" ReportLayout_CallerGame.Name GConfigProps.BuildDate To:DataStream
				Format "3D MAX version: %\n" tMAXVersion To:DataStream
				Format "User info: %@%.%\n" SysInfo.UserName HostName DomainName To:DataStream
				Format "User contacts: %\n" GIMS.Core.GUIMgr.LastInput To:DataStream
				Format "\n%" (ErrorStream as String) To:DataStream
				Format "\n[SYSINFO]\n%\n" EGIMS_EHMemInfo To:DataStream
				EGIMS_EHDeleteMemInfo()
				local	SystemMgr = GIMS.Core.SystemMgr
				Format "\n[TELEMETRY CORE ERRORS]\n%\n" (EGIMS_TelemetryErrors as String) To:DataStream
				Format "\n[TELEMETRY THREAD ERRORS]\n%\n" (try (SystemMgr.GIMSTelemetryLib.GetErrors()) catch "<ERROR>") To:DataStream
				Format "\n[ERRORS]\n" To:DataStream
				try (
					local	MessageInfo = SystemMgr.Errors,
							Messages = MessageInfo[1],
							Counts = MessageInfo[3],
							AddInfos = MessageInfo[4]
					for i = 1 to Messages.Count do (
						local	Count = Counts[i]
						if Count > 1 then
							Format "\t% times: %" Count Messages[i] To:DataStream
						else
							Format "\t%" Messages[i] To:DataStream
						local	AddInfos = AddInfos[i][1]
						if AddInfos.Count != 0 then (
							for Msg in AddInfos do
								Format "...\t%\n" Msg To:DataStream
						)
					)
				) catch
					Format "\t<ERROR>: %" (GetCurrentException()) To:DataStream
				Format "\n\n[WARNINGS]\n" To:DataStream
				try (
					local	MessageInfo = SystemMgr.Warnings,
							Messages = MessageInfo[1],
							Counts = MessageInfo[3],
							AddInfos = MessageInfo[4]
					for i = 1 to Messages.Count do (
						local	Count = Counts[i]
						if Count > 1 then
							Format "\t% times: %" Count Messages[i] To:DataStream
						else
							Format "\t%" Messages[i] To:DataStream
						local	AddInfos = AddInfos[i][1]
						if AddInfos.Count != 0 then (
							for Msg in AddInfos do
								Format "...\t%\n" Msg To:DataStream
						)
					)
				) catch
					Format "\t<ERROR>: %\n" (GetCurrentException()) To:DataStream
				Format "\n[UPDATE LOG]\n" To:DataStream
				try
					Format "%" (GIMS.Core.CoreOps.UpdateStream as String) To:DataStream
				catch
					Format "\t<ERROR>: %\n" (GetCurrentException()) To:DataStream

				local	ErrorText = (
							try
								GIMS.Core.SystemMgr.LastError
							catch (
								Seek ErrorStream 0
								if (EOF ErrorStream) then
									"NONE"
								else (
									ReadLine ErrorStream
									ReplaceChars (ReadLine ErrorStream) #(
										#(
											"Runtime error",
											"dotNet runtime exception",
											"MXSNET"
										),
										#(
											"MXS",
											"NET",
											"NET"
										)
									)
								)
							)
						),
						ErrorType = (MakeErrorName ErrorText),
						RequestStream = (StringStream ""),
						DataStreamString = (DataStream as String),
						ErrorString,
						DataString = (
							try (
								GIMS.Core.SystemMgr.GIMSOpsLib.Base64Encode DataStreamString
							) catch (
								local	source = "using System;
											sealed class FailureLib {
												public static System.String Base64Encode(System.String plainText) {
													return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(plainText));
												}
											}",
										csharpProvider = (DOTNETObject "Microsoft.CSharp.CSharpCodeProvider"),
										compilerParams = (DOTNETObject "System.CodeDom.Compiler.CompilerParameters"),
										ReferencedAssemblies = compilerParams.ReferencedAssemblies
								ReferencedAssemblies.Add "System.dll"
								compilerParams.GenerateInMemory = true
								compilerParams.CompilerOptions = "/unsafe"
								local	compilerResults = (csharpProvider.CompileAssemblyFromSource compilerParams #(source)),
										Errors = CompilerResults.Errors
								if Errors.HasErrors then (
									local ErrStr = (StringStream ""),
											Items = Errors.Item
									for i = 0 to (Errors.Count - 1) do (
										local	Item = Items[i]
										Format "Line % column %: Error % - %\n" Item.Line Item.Column Item.ErrorNumber Item.ErrorText To:ErrStr
									)
									ErrorString = (ErrStr as String)
								) else (
									local	FailureAssembly = (compilerResults.CompiledAssembly)
									if No FailureAssembly then
										ErrorString = "Can't initialize FailureAssembly! Try to update your .NET runtime"
									else (
										local	NETFailureLib = (FailureAssembly.CreateInstance "FailureLib")
										if No NETFailureLib then
											ErrorString = "Can't initialize NETFailureLib! Try to update your .NET runtime"
										else
											NETFailureLib.Base64Encode DataStreamString
									)
								)
							)
						)
				if Have ErrorString then
					throw ErrorString
				--Format X To:RequestStream
				local	Result = ""	--(OVI_MakePOST (RequestStream as String))
								
				if (MatchPattern Result Pattern:"{*\"ReportId\":*\"*}") then (
					local	reportIDItems = (filterString Result "\""),
							reportID = (reportIDItems[4] as String)
					EGIMS_GAReportException ErrorText true StackStream:ErrorStream ReportID:reportID
					Result = OK
				) 
					EGIMS_GAReportException ErrorText true StackStream:ErrorStream
				
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); if not (MatchPattern CET Pattern:"*api.openiv.com*") then (EGIMS_EHError CET ESS) else OK)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn OnCloseReport Sender args TheStream:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if GIMS.CanExec then (
					local	ExternMode = (Supplied TheStream)
					GIMS.CanExec = false
					if not ExternMode then (
						try (
							if (
								(not GIMS.IsDevBuild) or (
									(try (not ReportLayout_CallerGame.IsUpdateDeclined) catch false) and
									(QueryBox "Send the report?" title:("GIMS Evo " + (try ReportLayout_CallerGame.Name catch "") + " error report"))
								)
							) then
								OVI_SendReport GIMS.Core.SystemMgr.ErrorStream
							ClearResults Sender args
						) catch
							ExternMode = true
					)
					if ExternMode then (
						local	ReportPath = (
									(
										try
											GIMS.Shared.BackupPath
										catch (
											try
												SysInfo.TempDir
											catch
												"Z:\\temp\\"
										)
									)
								),
								ReportFilePath = (ReportPath + "EGIMSReport.txt"),
								ErrorText = (((GetCurrentException()) as String) + "\n" + (try (GIMS.Core.SystemMgr.ErrorStream as String) catch "<ERROR>"))
						MakeDir ReportPath All:true
						GIMS.Core.SystemMgr.FileDelete ReportFilePath
						TheStream = (CreateFile ReportFilePath)
						if TheStream != undefined then (
							try
								Print ErrorText To:TheStream
							catch
								Format "%\n" ErrorText To:TheStream
							Stack ShowLocals:true FirstFrameOnly:true To:TheStream
							Flush TheStream
							Close TheStream
							ShellLaunch ReportFilePath ""
						)
						if (QueryBox ("Can't send the error report.\nPlease check the internet connection and try again, or seek for support.\n\nThe report file has to be saved there:\n\"" + ReportFilePath + "\"\n\nContact support?") title:("GIMS Evo " + (try GIMS.CurrentGame.Name catch "") + " error report")) then (
							try
								ShellLaunch ReportLayout_CallerGame.RussianSupport ""
							catch (
								try (ShellLaunch GIMS.CurrentGame.RussianSupport "") catch ()
							)
							try
								ShellLaunch ReportLayout_CallerGame.IntlSupport ""
							catch (
								try (ShellLaunch GIMS.CurrentGame.IntlSupport "") catch ()
							)
						)
					)
					if not ExternMode then
						GIMS.Core.BufferMgr.ClearBuffer 0
					GIMS.CanExec = true
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyReport Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	ss = (StringStream "")
					OnCloseReport Sender args TheStream:ss
					if (SetClipboardText (ss as String)) then
						MessageBox "The error report was copied to the clipboard." Title:"GIMS Evo changelog"
					else
						MessageBox "Can't copy the error report to the clipboard.\nMay be, it's occupied by another application.\nPlease try again." Title:"GIMS Evo changelog"
					Free ss
					OK
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Release Sender args = (	/*<TODO>*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					/*<TODO>*/
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import Sender args = (	/*<TODO>*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					/*<TODO>*/
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export Sender args = (	/*<TODO>*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					/*<TODO>*/
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _ConvMatsToStdInSelection_GetTargetMtl Mtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MtlDelegate = (TryGetProperty Mtl #Delegate)
				if
					(IsKindOf Mtl GTAIVunimat) or
					(IsKindOf Mtl GTA_IV_material) or
					(IsKindOf Mtl EGIMS_IV_material) or
					(IsKindOf Mtl EGIMS_AE_material) or
					(IsKindOf Mtl EGIMS_MP3_Material) or
					(IsKindOf Mtl EGIMS_V_Material) or
					(MtlDelegate != #GetPropertyFailed)
				then
					(Copy MtlDelegate)
				else
					undefined
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ConvMatsToStdInSelection Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					undo "Convert GIMS materials to Standard" on (
						for Obj in Selection do (
							local	ObjMtl = (TryGetProperty Obj #Material)
							if ObjMtl != #GetPropertyFailed then (
								if (IsKindOf ObjMtl MultiMaterial) then (
									for i = 1 to ObjMtl.Count do (
										local	TargetMtl = (_ConvMatsToStdInSelection_GetTargetMtl ObjMtl[i])
										if Have TargetMtl then
											ObjMtl[i] = TargetMtl
									)
								) else (
									local	TargetMtl = (_ConvMatsToStdInSelection_GetTargetMtl ObjMtl)
									if Have TargetMtl then
										Obj.Material = TargetMtl
								)
							)
						)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CloneSelection Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	CloneTick = (GIMS.Core.GUIMgr.FindControl #CloneTick),
							SelectNew = CloneTick.Tag.Value.CheckState
					undo "Clone selection" on (
						if SelectNew then (
							local	Objs = (Selection as array)
							ClearSelection()
							for Obj in Objs do (
								local	NewObj = (Copy Obj)
								NewObj.Name = Obj.Name
								SelectMore NewObj
							)
						) else (
							for Obj in Selection do
								(Copy Obj).Name = Obj.Name
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ArrangeSelection Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					undo "Arrange selection" on (
						local	OldSelection = (Selection as Array),
								Objs = (
									(
										if OldSelection.Count != 0 then
											OldSelection
										else
											Objects
									) as Array
								),
								CellCount = Objs.Count
						Objs.Pos.x = (Objs.Pos.y = 0)
						if CellCount != 0 then (
							local	GridSize = (Ceil (Sqrt CellCount)),
									ObjID = 0,
									SteppingX = 0,
									SteppingY = 0,
									SelectWithChildren = GIMS.Core.ObjectMgr.SelectWithChildren
							ClearSelection()
							for Obj in Objs do (
								SelectWithChildren Obj
								local	Diff = ($.Max - $.Min),
										DiffX = Diff.x,
										DiffY = Diff.y
								if DiffX > SteppingX then
									SteppingX = DiffX
								if DiffY > SteppingY then
									SteppingY = DiffY
							)
							for xCell = 1 to GridSize do (
								for yCell = 1 to GridSize do (
									ObjID = (xCell + ((yCell - 1) * GridSize))
									if ObjID <= CellCount then (
										local	Obj = Objs[ObjID]
										Obj.Pos.x = (xCell * SteppingX)
										Obj.Pos.y = (yCell * SteppingY)
									)
								)
							)
							Select OldSelection
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _EmbedMtlTextures m = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GUI._EmbedMtlTextures"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case (ClassOf m) of (
					EGIMS_V_Material: (
						local	af = m.TexInternalFlags
						for i = 1 to af.Count do
							af[i] = true
					)
					EGIMS_MP3_material: (
						local	af = m.TexInternalFlags
						for i = 1 to af.Count do
							af[i] = true
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		mapped fn _EmbedObjTextures o = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GUI._EmbedObjTextures"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	m = o.Material
				if (IsKindOf m MultiMaterial) then (
					for sm in m.MaterialList do
						_EmbedMtlTextures sm
				) else
					_EmbedMtlTextures m
				_EmbedObjTextures o.Children
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn EmbedTexturesInSelection Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					undo "Embed selection textures" on
						_EmbedObjTextures Selection
					Select Selection
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		mapped fn _SetGameMat o GetStandartized = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GUI._SetGameMat"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				o.Material = (GetStandartized o.Material DoSort:false)
				_SetGameMat o.Children GetStandartized
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ConvMatsToGameInSelection Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then (
					local	GetStandartized = GIMS.CurrentGame.Core.MAXFactory.MaterialOps.GetStandartized
					undo "Convert materials to game type" on
						_SetGameMat Selection GetStandartized
					Select Selection
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn DateListSelectionChanged Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.CanExec = false
				local	FileList = (GIMS.Core.GUIMgr.FindControl #FileList),
						SelectedIndices = Sender.SelectedIndices
				FileList.ClearSelected()
				for i = 1 to SelectedIndices.Count do
					FileList.SetSelected SelectedIndices.Item[i - 1] true
				GIMS.CanExec = true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FileListSelectionChanged Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.CanExec = false
				local	DateList = (GIMS.Core.GUIMgr.FindControl #DateList),
						SelectedIndices = Sender.SelectedIndices
				DateList.ClearSelected()
				for i = 1 to SelectedIndices.Count do
					DateList.SetSelected SelectedIndices.Item[i - 1] true
				GIMS.CanExec = true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _BuildCNodeTree_ProcessNode \
			Parent \
			CNode \
			FormatText \
			COCats \
			COClassNames \
			COClasses \
			COLocations = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjInfo = "<UNKNOWN>",
						ParamSourceClass = (ClassOf CNode.ParamSource),
						ClassID = (FindItem COClasses ParamSourceClass)
				if ClassID == 0 then
					ObjInfo = (ParamSourceClass as String)
				else (
					local	COLocation = COLocations[ClassID],
							CoreID = (COLocation[1] as Integer),
							CatID = (COLocation[2] as Integer),
							ClassID = (COLocation[3] as Integer)
					ObjInfo = (
						FormatText \
							v1:"[" \
							v2:COCats[CoreID][CatID] \
							v3:"] " \
							v4:COClassNames[CoreID][CatID][ClassID] \
					)
				)
				local	ObjString = (
							FormatText \
								v1:ObjInfo \
								v2:": " \
								v3:CNode.Obj.Name \
						),
						TreeNode = (Parent.Nodes.Add ObjString)
				TreeNode.Checked = true
				CNode.TreeNode = TreeNode
				for Child in CNode.Children do (
					_BuildCNodeTree_ProcessNode \
						TreeNode \
						Child \
						FormatText \
						COCats \
						COClassNames \
						COClasses \
						COLocations
				)
				ObjString
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn BuildCNodeTree TreeControl CNodes ObjTree = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FormatText = GIMS.Core.ValueOps.FormatText,
						CreatableObjects_Data = GIMS.Core.TypeLibrary.CreatableObjects_Data,
						COCats = CreatableObjects_Data[2],
						COClassNames = CreatableObjects_Data[3],
						COLocationInfos = CreatableObjects_Data[6],
						COClasses = COLocationInfos[1],
						COLocations = COLocationInfos[2],
						NodeCount = CNodes.Count,
						RootNodeStrings = #()
				RootNodeStrings.Count = NodeCount
				TreeControl.BeginUpdate()
				for i = 1 to NodeCount do (
					RootNodeStrings[i] = (
						_BuildCNodeTree_ProcessNode \
							TreeControl \
							CNodes[i] \
							FormatText \
							COCats \
							COClassNames \
							COClasses \
							COLocations
					)
				)
				TreeControl.EndUpdate()
				RootNodeStrings
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PurgeCNodes CNodes CNodeStrings:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Supplied CNodeStrings then (
					for i = CNodes.Count to 1 by -1 do (
						local	CNode = CNodes[i]
						if CNode.TreeNode.Checked then (
							local	Children = CNode.Children
							if Children.Count != 0 then
								PurgeCNodes Children
						) else (
							DeleteItem CNodes i
							DeleteItem CNodeStrings i
						)
					)
				) else (
					for i = CNodes.Count to 1 by -1 do (
						local	CNode = CNodes[i]
						if CNode.TreeNode.Checked then (
							local	Children = CNode.Children
							if Children.Count != 0 then
								PurgeCNodes Children
						) else
							DeleteItem CNodes i
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowCoreInfo Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GConfigProps = GIMS.CurrentGame.Core.ConfigProps,
						FindControl = GIMS.Core.GUIMgr.FindControl,
						VersionInfo = (FindControl #VersionInfo),
						CacheInfo = (FindControl #CacheInfo),
						FileList = (FindControl #FileList),
						DateList = (FindControl #DateList),
						FormatText = GIMS.Core.ValueOps.FormatText,
						gName = GIMS.CurrentGame.Name
				VersionInfo.Text = (FormatText v1:gName v2:" core from " v3:GConfigProps.BuildDate)
				CacheInfo.Text = (Append "Cache reset at " GConfigProps.CacheResetDate)
				SetLines FileList GConfigProps.Files
				SetLines DateList GConfigProps.Versions
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowChangesByDate Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				SetLines (GIMS.Core.GUIMgr.FindControl #ChangeList) (GetChangeLog())[Sender.SelectedIndex + 1]
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowChangeLog Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FindControl = GIMS.Core.GUIMgr.FindControl,
						CoreNameLabel = (FindControl #CoreName),
						ChangeList = (FindControl #ChangeList),
						DateList = (FindControl #DateList)
				CoreNameLabel.Text = (GIMS.CurrentGame.Name + " core")
				SetLines DateList (GIMS.CurrentGame.Core.ConfigProps.ChangeLog[2])
				DateList.SetSelected 0 true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn OpenTools Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GUIMgr = GIMS.Core.GUIMgr
				if Have (GUIMgr.FindLayout GIMS.CurrentGame #Tools ForceCheck:false) then
					GUIMgr.SetWindow GIMS.Shared #Tools
				else
					GUIMgr.SetWindow GIMS.Shared #SharedTools
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn OpenIntlSupport Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then
					ShellLaunch GIMS.CurrentGame.IntlSupport ""
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn OpenRUSupport Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if args.Button.value__ == 1048576 then
					ShellLaunch GIMS.CurrentGame.RussianSupport ""
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowGIMSEULA Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Info = (GIMS.Core.GUIMgr.FindControl #Info)
				SetLines Info #(EGIMS_GetEULA()) Multiline:true KeepOneEmptyLine:true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn DeleteCache Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.Core.CacheMgr.DeleteCache()
				GIMS.CurrentGame.Start GIMS.CurrentGame
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn DeclineEULA Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				DeleteFile EGIMS_EULAFilePath
				EGIMS_MainWindow.Close()
				CloseUtility uEvoGIMS
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RegenerateUUID Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_RegenerateUUID()
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowGIMSInfo Sender args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Info = (GIMS.Core.GUIMgr.FindControl #Info)
				GIMS.CurrentGame = GIMS.Shared
				Info.Text = "Developer: Mansurov Sergey a.K.a. 3Doomer
				
Contacts:
				
    E-mail: 3Doomer2@gmail.com
				
Donation:
				
	PayPal: 3Doomer2@gmail.com
	boosty.to/3Doomer
	patreon.com/GIMS
"
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowSettings Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GATick = (GIMS.Core.GUIMgr.FindControl #GATick)
				SetCheckableState GATick EGIMS_TelemetryEnabled
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SaveSettings Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Rules = GIMS.Shared.Rules,
						GATick = (GIMS.Core.GUIMgr.FindControl #GATick),
						GAState = (GetCheckableState GATick)
				Rules.GATelemetryEnabled = GAState
				GIMS.Core.CacheMgr.Write Rules (GIMS.Shared.CachePath + "Rules.GSF")
				if GAState then
					EGIMS_StartTelemetry()
				else
					EGIMS_StopTelemetry User:true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Goto_Cats_WithGame Game = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SystemMgr = GIMS.Core.SystemMgr,
						CoreID = (FindItem GIMS.Core.TypeLibrary.CreatableObjects_Data[1] (Game.Tag as name))
				if CoreID != 0 then (
					GIMS.Core.ObjectMgr.ExchangeData = #(
						Game,
						CoreID
					)
					GIMS.Core.GUIMgr.SetWindow GIMS.Shared #CO_Cats
				) else (
					SystemMgr.AddResult #Error "No creatable objects available"
					SystemMgr.CheckResult KeepLayout:true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Goto_Cats_Shared Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				CO_Goto_Cats_WithGame GIMS.Shared
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Goto_Cats Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.Core.GUI.CO_Goto_Cats_WithGame GIMS.CurrentGame
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Show_Cats Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
						ListControl = (GIMS.Core.GUIMgr.FindControl #CatList),
						CreatableObjects_Data = GIMS.Core.TypeLibrary.CreatableObjects_Data,
						TextLines = CreatableObjects_Data[2][ExchangeData[2]]
				ListControl.ItemHeight = 40
				SetLines ListControl TextLines
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Select_Category Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	CatID = (Sender.SelectedIndex + 1)
				if CatID != 0 then (
					local	ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
							CreatableObjects_Data = GIMS.Core.TypeLibrary.CreatableObjects_Data,
							CoreID = (FindItem CreatableObjects_Data[1] (ExchangeData[1].Tag as name))
					ExchangeData[3] = CreatableObjects_Data[3][CoreID][CatID]
					ExchangeData[4] = CreatableObjects_Data[4][CoreID][CatID]
					ExchangeData[5] = CoreID
					ExchangeData[6] = CatID
					GIMS.Core.GUIMgr.SetWindow GIMS.Shared #CO_Objs Title:CreatableObjects_Data[2][CoreID][CatID]
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CO_Show_Objects Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ListControl = (GIMS.Core.GUIMgr.FindControl #ObjectList),
						ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
						ObjNames = ExchangeData[3],
						ObjModFlags = ExchangeData[4],
						TextLines = #(),
						ObjCount = ObjNames.Count
				ListControl.ItemHeight = 40
				TextLines.Count = ObjCount
				for i = 1 to ObjCount do (
					TextLines[i] = (
						if ObjModFlags[i] then
							ObjNames[i] + " : Modifier"
						else
							ObjNames[i]
					)
				)
				SetLines ListControl TextLines
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ValidateFloat Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Item = Sender.Tag.Value,
						Txt = (TrimLeft (TrimRight Item.ItemContent)),
						EnteredValue = (Txt as Float),
						Result = (Have EnteredValue)
				if Result then (
					SetTextBoxText Sender (EnteredValue as String)
					Sender.ForeColor = GIMS.Core.GUIMgr.Colors[1][Item.ForeColor]
				) else
					Sender.ForeColor = GIMS.GUI.Colour.SDC.Red
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Sender), #(EGIMS_DumpObjectInfo Sender)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ValidateInt Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Item = Sender.Tag.Value,
						Txt = (TrimLeft (TrimRight Item.ItemContent)),
						EnteredValue = (Txt as Integer),
						Result = (Have EnteredValue)
				if Result then (
					SetTextBoxText Sender (EnteredValue as String)
					Sender.ForeColor = GIMS.Core.GUIMgr.Colors[1][Item.ForeColor]
				) else
					Sender.ForeColor = GIMS.GUI.Colour.SDC.Red
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Sender), #(EGIMS_DumpObjectInfo Sender)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ValidatePath Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Item = Sender.Tag.Value,
						Txt = (TrimLeft (TrimRight Item.ItemContent)),
						Result = (DoesFileExist Txt)
				if Result then (
					if not Txt.Count != 0 then
						SetTextBoxText Sender (PathConfig.NormalizePath Txt)
					Sender.ForeColor = GIMS.Core.GUIMgr.Colors[1][Item.ForeColor]
				) else
					Sender.ForeColor = GIMS.GUI.Colour.SDC.Red
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Sender), #(EGIMS_DumpObjectInfo Sender)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ValidateSequence Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Item = Sender.Tag.Value,
						RawTxt = (TrimLeft (TrimRight Item.ItemContent)),
						CharAsInt = Bit.CharAsInt,
						LegalChars = #{(CharAsInt "0")..(CharAsInt "9"), (CharAsInt ","), (CharAsInt "-")},
						Txt = ""
				for i = 1 to RawTxt.Count do (
					local	Chr = (RawTxt[i])
					if LegalChars[CharAsInt Chr] then
						Append Txt Chr
				)
				SetTextBoxText Sender Txt
				local	Result = (Txt.Count != 0)
				if Result then
					Sender.ForeColor = GIMS.Core.GUIMgr.Colors[1][Item.ForeColor]
				else
					Sender.ForeColor = GIMS.GUI.Colour.SDC.Red
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Sender), #(EGIMS_DumpObjectInfo Sender)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateObject Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjID = (Sender.SelectedIndex + 1)
				if ObjID != 0 then (
					if not (IsCreatingObject()) then (
						local	ExchangeData = GIMS.Core.ObjectMgr.ExchangeData,
								CoreID = ExchangeData[5],
								CatID = ExchangeData[6],
								ObjInfo = GIMS.Core.TypeLibrary.CreatableObjects_Data[5][CoreID][CatID][ObjID]
						if ExchangeData[4][ObjID] then (
							local	SystemMgr = GIMS.Core.SystemMgr
							if Selection.Count != 0 then (
								local	ModClass = ObjInfo[1]
								for Obj in Selection do
									AddModifier Obj (ModClass()) UI:false
							) else
								SystemMgr.AddResult #Error "You must select at least one object to apply the modifier"
							SystemMgr.CheckResult KeepLayout:true
						) else
							GIMS.Core.TypeLibrary.CallObjectCreator ObjInfo
					)
					Sender.SelectedIndex = -1
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _SelectArea_UpdateEndPoint TempPos = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				SelectedAreaEnd = TempPos
				RedrawViews()
			/*<ERRHANDLER>*/) catch (
				try (SelectingArea = false)	catch ()
				(local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SelectArea = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	VPType = (Viewport.GetType()),
						Result
				if
					VPType == #view_persp_user or
					VPType == #view_iso_user or
					VPType == #view_camera or
					VPType == #view_bottom or
					VPType == #view_top
				then (
					local	TempPos = (PickPoint())
					if (ClassOf TempPos) == Point3 then (
						SelectedAreaStart = SelectedAreaEnd = TempPos
						SelectingArea = true
						TempPos = (PickPoint MouseMoveCallback:_SelectArea_UpdateEndPoint)
						if (ClassOf TempPos) == Point3 then
							Result = [SelectedAreaStart.x, SelectedAreaStart.y, TempPos.x, TempPos.y]
						else
							Result = [SelectedAreaStart.x, SelectedAreaStart.y, SelectedAreaStart.x, SelectedAreaStart.y]
					)
					SelectingArea = false
				)
				Result
			/*<ERRHANDLER>*/) catch (
				SelectingArea = false
				try (
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
				) catch
					throw
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	GIMS.Core.GUI = strGUI()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
