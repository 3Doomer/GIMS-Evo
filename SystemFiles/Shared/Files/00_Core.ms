/*#PC*DEFINE	CurrentGame	Shared*/

(
	local	CoreVersion = 13,
			IsGIMSOlder = true,
			AreVersionsDifferrent = true
	try (
		local	GIMSVersion = GIMS.Version
		AreVersionsDifferrent = (GIMSVersion != CoreVersion)
		IsGIMSOlder = (GIMSVersion < CoreVersion)
	) catch ()
	if AreVersionsDifferrent then (
		if IsGIMSOlder then
			throw "Please download web or manual installed version archive\nand update \"<3D MAX root>\\Scripts\\Startup\\\" folder contents with it.<GIMSVERSIONOLD>"
		else
			throw "<GIMSVERSIONUNKNOWN>"
	)
)

try
	GIMS.Core.GUIMgr.MainWindow.Close()
catch (
	try (EGIMS_MainWindow.Close()) catch ()
)

(
	local	MemInfo = (SysInfo.GetSystemMemoryInfo()),
			FreeRAM = MemInfo[3]
	if FreeRAM < (2L * 1024L * 1024L * 1024L) then	--if amount of free RAM is less than 2 GB
		FreeRAM += MemInfo[5]	--add free swap memory
	local	TargetHeapSize = (FreeRAM / 2L),	--reserve half of free memory
			TargetHeapSizeMin = (32L * 1024L * 1024L)	--32 MB heap minimum
	while (
		(HeapSize < TargetHeapSize) and
		(TargetHeapSize >= TargetHeapSizeMin) and (
			try (
				HeapSize = TargetHeapSize
				false
			) catch
				true
		)
	) do
		TargetHeapSize /= 2L
)

_CompileError = undefined

global		/*Syntax Sugar*/
				Have, No, Supplied, Ternary,
				TryAccess, TryGetProperty,
				FloatCompare,
				EGIMS_DumpObjectInfo,
				EGIMS_SelectModifier,
				/*Multithreading*/
				EGIMS_ThreadMgr,
				/*Misc*/
				EGIMS_GetCoreVersion,
				EGIMS_DNDateTime = (DotNETClass "System.DateTime"),
				GetTimeStamp,
				EGIMS_DNTicksPerMillisecond = (DotNETClass "System.TimeSpan").TicksPerMillisecond,
				/*EULA*/
				EGIMS_GetEULA,
				EGIMS_EULAFilePath = (GIMS.GIMSPath + "EULA"),
				/*Telemetry*/
				EGIMS_UUIDFilePath = (GIMS.GIMSPath + "UUID"),
				EGIMS_UUID,
				EGIMS_RegenerateUUID,
				EGIMS_StopTelemetry,
				EGIMS_StartTelemetry,
				EGIMS_TelemetryEnabled = true,
				EGIMS_TelemetryLib, 
				EGIMS_TelemetryErrors = (StringStream ""),
				EGIMS_GAReportException,
				EGIMS_GAReportTiming,
				EGIMS_GAReportPageView,
				EGIMS_GAReportScreenView,
				EGIMS_GAReportEvent,	
				/*Exception handling*/
				EGIMS_EHStoreMemInfo, EGIMS_EHDeleteMemInfo, EGIMS_EHMemInfo = unsupplied,
				EGIMS_EHReport, EGIMS_EHError, EGIMS_EHAbort,
				EGIMS_EHStackLocals = false,
				EGIMS_EHFFO = false,
				/*MAX hacks*/
				EGIMS_SuspendMAX, EGIMS_ResumeMAX,
				/*ChangeLog*/
				LoadChangeLog, GetChangeLog,
				/*GUI*/
				EGIMS_EULARollout,
				EGIMS_UpdateRollout,
				EGIMS_ReportRollout,
				EGIMS_TextBoxRollout,
				EGIMS_LangSelectRollout,
				EGIMS_MainWindow,
				EGIMS_MP3_matlist,
				EGIMS_MP3_mateditor,
				EGIMS_MP3_BlendProps,
				EGIMS_MP3_TexMapRC,
				EGIMS_MP3_MaterialRC,
				EGIMS_MP3_BlendEditor,
				EGIMS_V_matlist,
				EGIMS_V_mateditor,
				EGIMS_V_BlendProps,
				EGIMS_V_TexMapRC,
				EGIMS_V_MaterialRC,
				EGIMS_V_BlendEditor
			
fn GetTimeStamp = (
	EGIMS_DNDateTime.UTCNow.Ticks
)

	--PROFILER
	
	global	EGIMS_ProfilerStackInfos = #(),
			EGIMS_ProfilerStartTimes = #(),
			EGIMS_ProfilerLocations = #(),
			EGIMS_ProfilerCallLevel = 0
	for i = 100 to 1 by -1 do (
		EGIMS_ProfilerStackInfos[i] = 0
		EGIMS_ProfilerStartTimes[i] = 0
		EGIMS_ProfilerLocations[i] = 0
	)
	
	--ProfilerEntry PROFILER START
	
	global	strProfilerEntry, LogProfiler, ProfilerEntry, EGIMS_DumpProfiler, EGIMS_ResetProfiler
	
	struct strProfilerEntry (
		Parent = #NONE,
		Location = "",
		Ticks = 1,
		Duration = 0,
		Calls = #(),
		InfoCallOffsets = #(),
		
		CallArraySize = 0,
		CallCount = 0,
		
		CallLevel = 0,
		
		fn StartCall CallLocation = (
			ProfilerEntry = (strProfilerEntry Location:CallLocation Parent:ProfilerEntry CallLevel:(CallLevel + 1))
			CallCount += 1
			if CallCount > CallArraySize then (
				CallArraySize += 50
				Calls.Count = CallArraySize
			)
			Calls[CallCount] = ProfilerEntry
			OK
		),
		fn EndCall CallDuration = (
			Duration += CallDuration
			if Parent != #NONE then
				ProfilerEntry = Parent
			OK
		),
		fn AddInfo CallOffset CallLocation = (
			Append Calls CallLocation
			InfoCallOffsets[Calls.Count] = CallOffset
			OK
		),
		
		fn Dump FS:unsupplied Full:false AllowFull:true = (
			local	IsNewFS = (FS == unsupplied),
					FS = (
						if IsNewFS then (
							if
								AllowFull and
								not Full
							then
								Dump Full:true
							try (
								local	FileName = (if Full then "EGIMSProfiler_FULL_" else "EGIMSProfiler_OPTI_"),
										LogFilePath = (GIMS.GIMSPath + FileName + ((GetTimeStamp()) as String) + ".py")
								while (DoesFileExist LogFilePath) do (
									Sleep 0.1
									LogFilePath = (GIMS.GIMSPath + FileName + ((GetTimeStamp()) as String) + ".py")
								)
								(CreateFile LogFilePath)
							) catch
								undefined
						) else
							FS
					)
			if FS != undefined then (
				try (
					local	TabString = ""
					for i = 1 to CallLevel do
						Append TabString "\t"
					if Full then (
						local	FnEndPlace = (FindString Location ";")
						if FnEndPlace != undefined then
							Format "%% % {\n" TabString (SubString Location 1 (FnEndPlace - 1)) (SubString Location (FnEndPlace + 2) -1) To:FS
						else
							Format "%% {\n" TabString Location To:FS
						--dump child calls
						for a = 1 to CallCount do (
							local	Call = Calls[a]
							case (ClassOf Call) of (
								String:
									Format "%\tat % ms:\t%\n" TabString InfoCallOffsets[a] Call To:FS
								Array: (
									local	Names = Call[1],
											Values = Call[2]
									Format "%\tInfo {\n" TabStringTo:FS
									with PrintAllElements true (
										for i = 1 to Names.Count do
											Format "%\t\t%\t=\t%\n" TabString Names[i] Values[i] To:FS
									)
									Format "%\t} // at % ms\n" TabString InfoCallOffsets[a] To:FS
								)									
								default:
									Call.Dump FS:FS Full:Full
							)
						)
						if Ticks != 1 then
							Format "%} % times in % ms\n" TabString Ticks Duration To:FS
						else
							Format "%} in % ms\n" TabString Duration To:FS
					) else (
						local	FnEndPlace = (FindString Location ";")
						if FnEndPlace != undefined then
							Format "%% % {\n" TabString (SubString Location 1 (FnEndPlace - 1)) (SubString Location (FnEndPlace + 2) -1) To:FS
						else
							Format "%% {\n" TabString Location To:FS
						local	DumpAllowedIndices = #{}
						for i = CallCount to 1 by -1 do
							DumpAllowedIndices[i] = true
						for a = 1 to CallCount where DumpAllowedIndices[a] do (
							local	Call = Calls[a]
							case (ClassOf Call) of (
								String:
									Format "%\tat % ms:\t%\n" TabString InfoCallOffsets[a] Call To:FS
								Array: (
									local	Names = Call[1],
											Values = Call[2]
									Format "%\tInfo {\n" TabStringTo:FS
									with PrintAllElements true (
										for i = 1 to Names.Count do
											Format "%\t\t%\t=\t%\n" TabString Names[i] Values[i] To:FS
									)
									Format "%\t} // at % ms\n" TabString InfoCallOffsets[a] To:FS
								)									
								default: (
									--store current call data
									DumpAllowedIndices[a] = false
									local	CurrentCallLocation = Call.Location
									
									--summarize call ticks and durations with same location calls
									for b = 1 to CallCount where DumpAllowedIndices[b] do (
										if (StriCmp Calls[b].Location CurrentCallLocation) == 0 then (
											DumpAllowedIndices[b] = false
											--add
											Call.Duration += Calls[b].Duration
											Call.Ticks += Calls[b].Ticks
											Call.Calls += Calls[b].Calls
											--reset
											Calls[b].Duration = 0
											Calls[b].Ticks = 0
											Calls[b].Calls.Count = 0
										)
									)
									
									--dump call children
									Call.Dump FS:FS
								)
							)
						)
						if Ticks != 1 then
							Format "%} % times in % ms\n" TabString Ticks Duration To:FS
						else
							Format "%} in % ms\n" TabString Duration To:FS
					)
				) catch
					MessageBox (GetCurrentException()) Title:"Profiler dump"
				if IsNewFS then
					Close FS
			)
			OK
		)
	)

	fn EGIMS_DumpProfiler AllowFull:true = (
		ProfilerEntry.Dump AllowFull:AllowFull
		#Ready
	)

	fn EGIMS_ResetProfiler = (
		ProfilerEntry = (strProfilerEntry())
		#Ready
	)
	
	EGIMS_ResetProfiler()
	
	fn RTLogProfiler Mode LocSS = (
		local	CallTime = (GetTimeStamp())
		case Mode of (
			#Start: (
				EGIMS_ProfilerCallLevel += 1
				local	Location = (_LogProfiler_GetLocation LocSS)
				ProfilerEntry.StartCall Location
			)
			#End: (
				local	Duration = ((CallTime - EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel]) / 10000)
				EGIMS_ProfilerCallLevel -= 1
				ProfilerEntry.EndCall Duration
			)
			#Info:
				ProfilerEntry.AddInfo ((CallTime - EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel]) / 10000) Location
			default:
				throw "Unknown Mode: " Mode
		)
		OK
	)
	
	--ProfilerEntry PROFILER END

	--REALTIME PROFILER START
		
	global	EGIMS_ProfilerGetTabString,
			EGIMS_ProfilerTabStrings = #(),
			EGIMS_ProfilerStream
	if EGIMS_ProfilerStream != undefined then (
		Close EGIMS_ProfilerStream
		EGIMS_ProfilerStream = undefined
	)

	fn _LogProfiler_GetLocation LocSS = (
		if (IsKindOf LocSS StringStream) then (
			local	Searching = true,
					LineFound = false,
					Location = "<UNKNOWN>"
			Seek LocSS 0
			while (
				Searching and
				not (EOF LocSS)
			) do (
				local	tLine = (ReadLine LocSS)
				if LineFound then (
					Location = (SubString tLine 7 -1)
					Searching = false
				) else
					LineFound = (tLine == "**	[stack level: 0]")
			)
			Free LocSS
			Location
		) else
			(LocSS as String)
	)
	fn EGIMS_ProfilerGetTabString = (
		if EGIMS_ProfilerCallLevel < 1 then
			""
		else (
			local	TabString = EGIMS_ProfilerTabStrings[EGIMS_ProfilerCallLevel]
			if TabString == undefined then (
				local	StringCount = EGIMS_ProfilerTabStrings.Count
				TabString = (
					if StringCount == 0 then
						""
					else
						(Copy EGIMS_ProfilerTabStrings[StringCount])
				)
				for i = (StringCount + 1) to EGIMS_ProfilerCallLevel do
					Append TabString "\t"
				EGIMS_ProfilerTabStrings[EGIMS_ProfilerCallLevel] = TabString
			)
			TabString
		)
	)
	fn _LogProfiler_GetStream = (
		local	FilePath = (GIMS.GIMSPath + "EGIMSProfiler_RT.py")
		if EGIMS_ProfilerStream == undefined then (
			try (
				if (DoesFileExist FilePath) then
					EGIMS_ProfilerStream = (OpenFile FilePath Mode:"at")
				else
					EGIMS_ProfilerStream = (CreateFile FilePath)
				if EGIMS_ProfilerStream == undefined then
					throw "Can't open profiler stream in " FilePath
				EGIMS_ProfilerStream
			) catch
				throw
		) else
			EGIMS_ProfilerStream
	)
	fn LogProfiler Mode LocSS AddParam:unsupplied = (
		--try (
		with PrintAllElements true (
		local	CallTime = (GetTimeStamp()),
				MemBusy = (HeapSize - HeapFree),
				FS = (_LogProfiler_GetStream())
		case Mode of (
			#Start: (
				local	TabString = (EGIMS_ProfilerGetTabString())
				local	Location = (_LogProfiler_GetLocation LocSS)
				Format "%% {\n" TabString Location To:FS
				EGIMS_ProfilerCallLevel += 1
				EGIMS_ProfilerLocations[EGIMS_ProfilerCallLevel] = Location
				EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel] = (GetTimeStamp())
				EGIMS_ProfilerStackInfos[EGIMS_ProfilerCallLevel] = MemBusy
			)
			#End: (
				EGIMS_ProfilerCallLevel -= 1
				if EGIMS_ProfilerCallLevel < 0 then
					EGIMS_ProfilerCallLevel = 0
				local	Duration = ((CallTime - EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel + 1]) / 10000),
						MemoryFootprint = (0.0009765625 * (EGIMS_ProfilerStackInfos[EGIMS_ProfilerCallLevel + 1] - MemBusy))
				Format "%} //% ms, % KB memory footprint\n" (EGIMS_ProfilerGetTabString()) Duration MemoryFootprint To:FS
			)
			#UnwindStack: (
				EGIMS_ProfilerCallLevel -= 3
				if EGIMS_ProfilerCallLevel < 0 then (
					EGIMS_ProfilerCallLevel = 0
					Format "%}}} //stack unwound to top-level\n" (EGIMS_ProfilerGetTabString()) To:FS
				) else
					Format "%}}} //stack unwound to %\n" (EGIMS_ProfilerGetTabString()) EGIMS_ProfilerLocations[EGIMS_ProfilerCallLevel + 1] To:FS
			)
			#Info: (
				local	MemoryFootprint = (0.0009765625 * (EGIMS_ProfilerStackInfos[EGIMS_ProfilerCallLevel + 1] - MemBusy)),
						TabString = (EGIMS_ProfilerGetTabString()),
						TimeOffset = ((CallTime - EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel]) / 10000)
				case (ClassOf LocSS) of (
					Array: (
						local	Names = LocSS[1],
								Values = LocSS[2]
						Format "%Info at % ms, % KB memory footprint {\n" TabString TimeOffset MemoryFootprint To:FS
						with PrintAllElements true (
							for i = 1 to Names.Count do
								Format "%\t%:\t%\n" TabString Names[i] Values[i] To:FS
						)
						Format "%}\n" TabString To:FS
					)
					String:
						Format "%at % ms, % KB memory footprint:\t%\n" TabString TimeOffset MemoryFootprint LocSS To:FS
				)
			)
			#PlainInfo: (
				local	TimeOffset = 0
				if EGIMS_ProfilerCallLevel == 0 then (
					EGIMS_ProfilerCallLevel += 1
					EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel] = CallTime
				) else (
					local	StartTime = (
								if EGIMS_ProfilerCallLevel == 1 then
									EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel]
								else
									EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel - 1]
							)
					if StartTime == undefined then
						EGIMS_ProfilerStartTimes[EGIMS_ProfilerCallLevel] = (StartTime = CallTime)
					TimeOffset = ((CallTime - StartTime) / 10000)
				)
				local	TabString = (EGIMS_ProfilerGetTabString())
				case (ClassOf LocSS) of (
					Array: (
						local	Names = LocSS[1],
								Values = LocSS[2]
						if AddParam != unsupplied then
							Format "%PlainInfo\t%\t{ //at % ms\n" TabString AddParam TimeOffset To:FS
						else
							Format "%PlainInfo { //at % ms\n" TabString TimeOffset To:FS
						with PrintAllElements true (
							for i = 1 to Names.Count do
								Format "%%:\t%\n" Names[i] TabString Values[i] To:FS
						)
						Format "%} //at % ms\n" TabString TimeOffset To:FS
					)
					String: (
						if AddParam != unsupplied then
							Format "%%\t%\tat % ms\n" TabString LocSS AddParam TimeOffset To:FS
						else
							Format "%%\tat % ms\n" TabString LocSS TimeOffset To:FS
					)
				)
			)
			default:
				throw "Unknown Mode: " Mode
		)
		Free LocSS
		if EGIMS_ProfilerCallLevel == 0 then (
			Close EGIMS_ProfilerStream
			EGIMS_ProfilerStream = undefined
		)
		)
		OK
		--) catch
		--	break()
	)
	
	--REALTIME PROFILER END
		
(

	/*	Syntax Sugar	*/
	
	fn Have	Obj = (
		Obj != undefined
	)
	fn No	Obj = (
		not (Have Obj)
	)
	fn Supplied	Obj = (
		Obj != unsupplied
	)
	fn TryGetProperty Obj Property Failsafe:#GetPropertyFailed = (
		try
			(GetProperty Obj Property)
		catch
			Failsafe
	)
	fn TryAccess Obj Property = (
		(
			(IsProperty Obj Property) or 
			((TryGetProperty Obj Property Failsafe:#GetPropertyFailed) != #GetPropertyFailed)
		)
	)
	fn Ternary Cond vThen vElse = (
		if (ClassOf Cond) != BooleanClass then
			throw "Ternary operation can't happen with that: " Cond
		if Cond then
			vThen
		else
			vElse
	)
	fn FloatCompare v1 v2 MaxDiff = (
		(v1 == v2) or (
			(v1 > (v2 - MaxDiff)) and
			(v1 < (v2 + MaxDiff))
		)
	)
	fn EGIMS_DumpObjectInfo Obj = (
		local	SS = (StringStream "")
		try
			ShowProperties Obj To:SS
		catch
			Format "<%>" (GetCurrentException()) To:SS
		local	Res = (SS as string)
		Free SS
		Res
	)
	fn EGIMS_SelectModifier tMod Retry:true = (
		EGIMS_ResumeMAX()
		MAX Modify Mode
		ModPanel.SetCurrentObject tMod UI:true
		local	isSelected = ((ModPanel.GetCurrentObject()) == tMod)
		if (
			(not isSelected) and
			Retry
		) then
			EGIMS_SelectModifier tMod Retry:false
		else (
			if not isSelected then
				throw "Can't select the modifier!"
		)
		OK
	)
	
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (

	/*Misc*/
	
	fn EGIMS_GetEULA = (
"End User License Agreement
\r\n
\r\nGIMS Evo
\r\n
\r\nThank you for choosing GIMS Evo (hereinafter named as \"Software\").
\rThis is a license agreement between you (hereinafter named as \"User\")
\r  and the GIMS Evo developer Sergey Mansurov a.K.a 3Doomer (hereinafter named as \"Developer\").
\rBy accepting this agreement or using the Software, the User agrees to all of listed terms.
\rIf the User do not accept or fulfil these terms, the User may not use the Software.
\r\n
\r\n1. LICENSE RIGHTS
\r\n
\r\n1.1. Under this agreement the Developer grants the User the right to install
\r  and run unlimited number of copies of the Software for free if the User comply
\r  with all the terms of this agreement. Sublicensing is not allowed.
\r1.2. The agreement is valid while the User comply with all of its terms.
\r1.3. The Developer grants the User no rights to own the Software.
\r\n
\rTerms and conditions not specified in this agreement shall be governed in accordance
\r  with the current law of the Russian Federation.
\r\n
\r\n2. RIGHTS AND RESTRICTIONS OF THE USER
\r\n
\r\n2.1. The User has the rights to use and distribute the Software.
\r2.2. The User is not allowed to distribute the Software or any of its components
\r  for commercial purposes.
\r2.3. The User is not allowed to decrypt, reverse-engineer, or modify the Software
\r  or any of its components; 
\r2.4. The User is not allowed to change or delete any legal notices from the Software.
\r\n
\r\n3. RIGHTS AND RESTRICTIONS OF THE DEVELOPER
\r\n
\r\n3.1. The Developer has the right to change the terms of this agreement or publish
\r  new versions of it. By using the Software containing the updated version
\r  of the agreement, the User agrees with any changes made to the agreement.
\r3.2. The Developer has the right to track and collect the information on how
\r  the Software works and how the User interact with the Software.
\r3.3. If an error occurs in the Software, the error data including information
\r  about the User's actions may be automatically transferred to the Developer's server.
\r3.4. The Developer guarantees that any information obtained by automatic methods
\r  will not be used by the Developer in any order, except for improving the Software.
\r3.5. The Developer has the right to modify or delete the Software
\r  or any of its components at any time, without any prior notice to the User.
\r\n
\r\n4. TERMINATION OF THE LICENSE AGREEMENT
\r\n
\r\n4.1. This license agreement is valid until one of the parties terminates it.
\r4.2. The User may terminate the agreement at any time by uninstalling the Software.
\r4.3. The Developer may terminate the agreement if the User violates the terms of this agreement.
\r4.4. The invalidity of one or more provisions of this agreement, due to
\r  the priority of the User's domestic law, does not lead to the invalidity
\r  of the agreement as a whole. If one or more provisions of this agreement
\r  is recognized to be invalid, the parties agree to fulfill the undertaken
\r  obligations closest to the implied.
\r\n
\r\n5. LIMITATION OF LIABILITY
\r\n
\r\n5.1. The Developer has no liability for any actions of the User.
\r5.2. The Developer has no liability for any legal or game developers/owners
\r  actions in relation to the User.
\r5.3. The Developer is not obliged to provide the User with any proofs
\r  on violation of the agreement by the User.
\r5.4. The software is provided with ABSOLUTELY NO warranty of ANY kind.
\r  The User accepts all risks and consequences, whether direct or indirect,
\r  when using the Software.
\r\n
\r\n© 2017-2025 Sergey Mansurov a.K.a. 3Doomer
\r\n3Doomer2@gmail.com
"
	)
	fn EGIMS_CheckEULA = (
		local	EULAVersion = "EULAv1",
				FileEULA = (
					if (DoesFileExist EGIMS_EULAFilePath) then (
						try
							(FileIn EGIMS_EULAFilePath)
						catch
							undefined
					) else
						undefined
				),
				Result = true
		if
			(No FileEULA) or
			(FileEULA != EULAVersion)
		then (
			DeleteFile EGIMS_EULAFilePath
			CreateDialog EGIMS_EULARollout
			local	ProcessPostedMessages = GIMS.ProcessPostedMessages
			while (EGIMS_EULARollout.IsDisplayed) do
				ProcessPostedMessages()
			Result = EGIMS_EULARollout.Decision
			if Result then (
				local	fs = (CreateFile EGIMS_EULAFilePath)
				if No fs then
					throw "Can't create the EULA file"
				Format "\"%\"" EULAVersion To:fs
				Close fs
			)
		)
		Result
	)
		
	fn EGIMS_GetCoreVersion Game:unsupplied = (
		try (
			if Supplied Game then
				((Game.Tag as String) + "-" + Game.Core.ConfigProps.BuildDate)
			else
				GIMS.Core.ConfigProps.BuildDate
		) catch
			"<VERSION_ERROR>"
	)
	
	/*Telemetry*/
	fn EGIMS_GAReportException	exceptionText isFatal				Game:undefined	StackStream:undefined ReportID:-1	= (
		if EGIMS_TelemetryEnabled then (
			local	appTag = "<TAG_ERROR>"
			try (
				try (
					if No Game then
						Game = GIMS.CurrentGame
					appTag = Game.Tag
				) catch ()
				EGIMS_TelemetryLib.GAReportException	appTag (EGIMS_GetCoreVersion()) (EGIMS_GetCoreVersion Game:Game) exceptionText isFatal (StackStream as String)
				OK
			) catch
				Format "ReportException % % Game %:\t %\n" exceptionText isFatal appTag (GetCurrentException()) To:EGIMS_TelemetryErrors
		) else
			#NO_TELEMETRY
	)
	fn EGIMS_GAReportTiming		category action label timing 		Game:undefined	= (
		if EGIMS_TelemetryEnabled then (
			local	appTag = "<TAG_ERROR>"
			try (
				try (
					if No Game then
						Game = GIMS.CurrentGame
					appTag = Game.Tag
				) catch ()
				EGIMS_TelemetryLib.GAReportTiming		appTag (EGIMS_GetCoreVersion()) (EGIMS_GetCoreVersion Game:Game)  category action label timing
				OK
			) catch
				Format "ReportTiming % % % % Game %:\t %\n" category action label timing appTag (GetCurrentException()) To:EGIMS_TelemetryErrors
		) else
			#NO_TELEMETRY
	)
	fn EGIMS_GAReportPageView	parent page title 					Game:undefined	= (
		if EGIMS_TelemetryEnabled then (
			local	appTag = "<TAG_ERROR>"
			try (
				try (
					if No Game then
						Game = GIMS.CurrentGame
					appTag = Game.Tag
				) catch ()
				if parent == #CurrentGameTag then
					parent = appTag
				EGIMS_TelemetryLib.GAReportPageView	appTag (EGIMS_GetCoreVersion()) (EGIMS_GetCoreVersion Game:Game)  parent (page as String) title
				OK
			) catch
				Format "ReportPageView % % % Game %:\t %\n" parent page title appTag (GetCurrentException()) To:EGIMS_TelemetryErrors
		) else
			#NO_TELEMETRY
	)
	fn EGIMS_GAReportScreenView	parent page title 					Game:undefined	= (
		if EGIMS_TelemetryEnabled then (
			local	appTag = "<TAG_ERROR>"
			try (
				try (
					if No Game then
						Game = GIMS.CurrentGame
					appTag = Game.Tag
				) catch ()
				if parent == #CurrentGameTag then
					parent = appTag
				EGIMS_TelemetryLib.GAReportScreenView	appTag (EGIMS_GetCoreVersion()) (EGIMS_GetCoreVersion Game:Game)  parent (page as String) title
				OK
			) catch
				Format "ReportScreenView % % % Game %:\t %\n" parent page title appTag (GetCurrentException()) To:EGIMS_TelemetryErrors
		) else
			#NO_TELEMETRY
	)
	fn EGIMS_GAReportEvent		category action label eventValue 	Game:undefined	= (
		if EGIMS_TelemetryEnabled then (
			local	appTag = "<TAG_ERROR>"
			try (
				try (
					if No Game then
						Game = GIMS.CurrentGame
					appTag = Game.Tag
				) catch ()
				EGIMS_TelemetryLib.GAReportEvent		appTag (EGIMS_GetCoreVersion()) (EGIMS_GetCoreVersion Game:Game)  category action label eventValue
				OK
			) catch
				Format "ReportEvent % % % % Game %:\t %\n" category action label eventValue appTag (GetCurrentException()) To:EGIMS_TelemetryErrors
		) else
			#NO_TELEMETRY
	)
	fn EGIMS_StopTelemetry User:true = (
		Callbacks.RemoveScripts #PreSystemShutdown ID:#EGIMS_StopTelemetry
		try (
			if User then
				EGIMS_GAReportEvent		"Telemetry" "Stop" "Vegetable user found" 0
			EGIMS_TelemetryEnabled = false
			EGIMS_TelemetryLib.Stop (EGIMS_GetCoreVersion())
			OK
		) catch
			#STOPPING_FAILD
	)
	EGIMS_StopTelemetry User:false
	fn EGIMS_StartTelemetry = (
		--if not GIMS.IsDevBuild then (
			EGIMS_StopTelemetry User:false
			Callbacks.AddScript #PreSystemShutdown "EGIMS_StopTelemetry User:false" ID:#EGIMS_StopTelemetry
			local	TheMaxVersion = (MaxVersion()),
					GUIMgr = GIMS.Core.GUIMgr,
					ws = (GUIMgr.ScaleGUICoord GUIMgr.MainWindowSize)
			EGIMS_TelemetryLib.Start \
				EGIMS_UUID \
				(EGIMS_GetCoreVersion()) \
				("3DsMAX-" + (TheMaxVersion[1] as String) + "." + (TheMaxVersion[2] as String) + "." + (TheMaxVersion[3] as String)) \
				(GUIMgr.ScreenSize as String) \
				(((ws[1] as Integer) as String) + "x" + ((ws[2] as Integer) as String))
			EGIMS_TelemetryEnabled = true
		--)
		OK
	)
	
	/*Exception handling*/
	
	fn EGIMS_EHStoreMemInfo = (
		if not Supplied EGIMS_EHMemInfo then (
			local	SS = (StringStream ""),
					MemInfo = (SysInfo.GetSystemMemoryInfo()),
					MBDiv = (1024.0 * 1024.0)
			Format "RAM: % MB\nRAM free: % MB\nSwap memory: % MB\nSwap memory free: % MB\nHeapSize: % MB\nHeapFree: % MB" \
				((MemInfo[2] as Float) / MBDiv) \
				((MemInfo[3] as Float) / MBDiv) \
				((MemInfo[4] as Float) / MBDiv) \
				((MemInfo[5] as Float) / MBDiv) \
				((HeapSize as Float) / MBDiv) \
				((HeapFree as Float) / MBDiv) \
				To:SS
			EGIMS_EHMemInfo = (SS as String)
			Free SS
		)
		OK
	)
	fn EGIMS_EHDeleteMemInfo = (
		if Supplied EGIMS_EHMemInfo then (
			Free EGIMS_EHMemInfo
			EGIMS_EHMemInfo = unsupplied
		)
		OK
	)
	fn EGIMS_EHReport ErrorText StackStream AddInfo:unsupplied Returnable:false NoMetro:false = (
		try
			GIMS.Core.SystemMgr.ExceptionHandler ErrorText #Report StackStream:StackStream AddInfo:AddInfo Returnable:Returnable NoMetro:NoMetro
		catch (
			EGIMS_GAReportException (ErrorText as String) true StackStream:StackStream
			throw()
		)
	)
	fn EGIMS_EHError ErrorText StackStream AddInfo:unsupplied = (
		GIMS.Core.SystemMgr.ExceptionHandler ErrorText #Throw StackStream:StackStream AddInfo:AddInfo
	)
	fn EGIMS_EHAbort AbortText Param1:unsupplied BufferID:unsupplied = (
		AbortText = (AbortText as String)
		if Supplied BufferID then
			AbortText = (Append (GIMS.Core.BufferMgr.GetErrorInfo BufferID) AbortText)
		EGIMS_GAReportException AbortText false
		if Supplied Param1 then
			GIMS.Core.SystemMgr.ExceptionHandler (AbortText + (Param1 as String)) #Abort
		else
			GIMS.Core.SystemMgr.ExceptionHandler AbortText #Abort
	)
	
	/*MAX hacks*/
	
	fn EGIMS_SuspendMAX = (
		max Create mode
		SuspendEditing()
		set undo off
		set animate off
		set redraw off
		Autosave.Enable = false
	)
	fn EGIMS_ResumeMAX = (
		max Create mode
		Autosave.Enable = true
		set redraw on
		set undo on
		ResumeEditing()
		ResumeEditing()
		ResumeEditing()
	)
	
	/*Cleanup*/
	try (UnRegisterRedrawViewsCallback EGIMS_VPRedrawCallback) catch ()
	Callbacks.RemoveScripts #SceneNodeAdded ID:#EGIMS_SetLocks
	Callbacks.RemoveScripts #PostModifierAdded ID:#EGIMS_SetModRules
	Callbacks.RemoveScripts #SelectionSetChanged ID:#EGIMS_MP3_matlist_GetMaterial
	Callbacks.RemoveScripts #NodePostMaterial ID:#EGIMS_MP3_matlist_OnMaterialChanged
	Callbacks.RemoveScripts #SelectionSetChanged ID:#EGIMS_V_matlist_GetMaterial
	Callbacks.RemoveScripts #NodePostMaterial ID:#EGIMS_V_matlist_OnMaterialChanged
	(
		local	DialogsToDestroy = #(
					EGIMS_EULARollout,
					EGIMS_UpdateRollout,
					EGIMS_ReportRollout,
					EGIMS_TextBoxRollout,
					EGIMS_LangSelectRollout,
					EGIMS_MP3_matlist,
					EGIMS_MP3_mateditor,
					EGIMS_MP3_BlendProps,
					EGIMS_V_matlist,
					EGIMS_V_mateditor,
					EGIMS_V_BlendProps
				)
		for Dialog in DialogsToDestroy where Have Dialog do
			DestroyDialog Dialog
	)
	
	/*ChangeLog*/
	fn LoadChangeLog FilePath:unsupplied = (
		/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
		/*<ERRHANDLERSTART>*/try (
			(
				FileIn (
					if (Supplied FilePath) then
						(FilePath + "ChangeLog.GCF")
					else
						(GIMS.CurrentGame.FilesPath + "ChangeLog.GCF")
				)
			)
		/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
	)
	fn GetChangeLog ChangeLog:unsupplied = (
		/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
		/*<ERRHANDLERSTART>*/try (
			if not Supplied ChangeLog then
				ChangeLog = GIMS.CurrentGame.Core.ConfigProps.ChangeLog
			local	Lang = GIMS.Languages[GIMS.LangID],
					LangID = (FindItem ChangeLog[1] Lang)
			if LangID == 0 then
				throw ("Can't find " + GIMS.CurrentGame.Name + " core " + Lang as String + " language package!")
			ChangeLog[3][LangID]
		/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
	)
			
	/*GUI PROTOTYPES*/
	rollout EGIMS_MP3_matlist "PROTOTYPE" (
		local	TheObj, CpyMtl, CpyTexPath, MtlID, LastMtlID, PrevMtl,
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
		fn GetMaterialList = (
			DestroyDialog EGIMS_MP3_matlist
		)
	)
	rollout EGIMS_MP3_mateditor "PROTOTYPE" (
		fn DoTexmapRC = (
			DestroyDialog EGIMS_MP3_mateditor
		)
	)
	rollout EGIMS_V_matlist "PROTOTYPE" (
		local	TheObj, CpyMtl, CpyTexPath, MtlID, LastMtlID, PrevMtl,
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
		fn GetMaterialList = (
			DestroyDialog EGIMS_V_matlist
		)
	)
	rollout EGIMS_V_mateditor "PROTOTYPE" (
		fn DoTexmapRC = (
			DestroyDialog EGIMS_V_mateditor
		)
	)

	/*DEFAULT GUI*/
	rollout EGIMS_UpdateRollout "GIMS Evo update" Width:500 Height:340 (
		local	Decision
		Label	cCoreTip	""	Align:#Center
		ListBox	cChangeLog	"ChangeLog:"	ReadOnly:true	Align:#Center Height:20
		Label	cSizeTip	""	Align:#Left	Across:2	Offset:[0, 5]
		Button	cUpdate	"Update"	Align:#Right	Width:80
		fn Init GameTag DownloadSizeText ChangeLogPath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				cCoreTip.Text = (Append (Append "New version of GIMS " GameTag) " core's available.")
				cSizeTip.Text = (Append "Prepare to download " DownloadSizeText)
				local	ChangeLog = (LoadChangeLog FilePath:ChangeLogPath)
				cChangeLog.Items = (GetChangeLog ChangeLog:ChangeLog)[1]
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on cUpdate Pressed do (
			Decision = true
			DestroyDialog EGIMS_UpdateRollout
		)
		on EGIMS_UpdateRollout Open do (
			GIMS.CanExec = false
			Decision = false
		)
		on EGIMS_UpdateRollout Close do
			GIMS.CanExec = true
	)
	rollout EGIMS_EULARollout "GIMS Evo EULA" Width:600 Height:500 (
		local		Decision
		DotNETControl cChangeLog "System.Windows.Forms.TextBox"	Text:(EGIMS_GetEULA())	Align:#Center Height:460	ReadOnly:true
		Button		cAccept		"Accept"	Align:#Center	Width:80	Across:2
		Button		cDecline	"Decline"	Align:#Center	Width:80
		on cAccept Pressed do (
			Decision = true
			DestroyDialog EGIMS_EULARollout
		)
		on cDecline Pressed do (
			Decision = false
			DestroyDialog EGIMS_EULARollout
		)
		on EGIMS_EULARollout Open do (
			GIMS.CanExec = false
			Decision = false
			cChangeLog.multiline = true
			cChangeLog.wordwrap = true
			cChangeLog.scrollbars = (DotNETClass "System.Windows.Forms.ScrollBars").Vertical
		)
		on EGIMS_EULARollout Close do
			GIMS.CanExec = true
	)
	rollout EGIMS_ReportRollout "GIMS Evo error report" Width:500 (
		Label	l0	"GIMS Evo has encountered an error"	Align:#Center
		EditText	GUInfo	"Please, leave your contacts here:" LabelOnTop:true	Align:#Center
		EditText	ErrorInfo	"Error information:"	ReadOnly:true	LabelOnTop:true	Align:#Center Height:500
		Label	BSend	"This error report'll be sent automatically."	Align:#Center
		
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
		)
		fn SimpleComparator v1 v2 = (
			if v1 == v2 then
				0
			else (
				if v1 > v2 then
					1
				else
					-1
			)
		)
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
		)
		fn OVI_SendReport ErrorStream = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ValueOps = GIMS.Core.ValueOps,
						CurrentGame = GIMS.CurrentGame
				if No CurrentGame then
					CurrentGame = GIMS.Shared
				local	CurrentGameTag = CurrentGame.Tag,
						GConfigProps = CurrentGame.Core.ConfigProps,
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
				if CurrentGame != GIMS.Shared then
					Format "GIMS % core build %\n" CurrentGame.Name GConfigProps.BuildDate To:DataStream
				Format "3D MAX version: %\n" tMAXVersion To:DataStream
				Format "User info: %@%.%\n" SysInfo.UserName HostName DomainName To:DataStream
				Format "User contacts: %\n" GUInfo.Text To:DataStream
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
						try (
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
						) catch
							Format "\t<ERROR1>: %" (GetCurrentException()) To:DataStream
					)
				) catch
					Format "\t<ERROR2>: %" (GetCurrentException()) To:DataStream
				Format "\n\n[WARNINGS]\n" To:DataStream
				try (
					local	MessageInfo = SystemMgr.Warnings,
							Messages = MessageInfo[1],
							Counts = MessageInfo[3],
							AddInfos = MessageInfo[4]
					for i = 1 to Messages.Count do (
						try (
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
						) catch
							Format "\t<ERROR3>: %\n" (GetCurrentException()) To:DataStream
					)
				) catch
					Format "\t<ERROR4>: %\n" (GetCurrentException()) To:DataStream
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
											public class FailureLib {
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
				) else
					EGIMS_GAReportException ErrorText true StackStream:ErrorStream
								
				Result
			/*<ERRHANDLER>*/) catch ("OVI_SendReport error: " + (GetCurrentException()))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		fn SendReport = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ErrorStream = (StringStream ErrorInfo.Text)
						Result = OK
				if (
					not GIMS.IsDevBuild or
					(QueryBox "Send the report?" title:("GIMS Evo " + (try GIMS.CurrentGame.Name catch "") + " error report"))
				) then
					Result = (OVI_SendReport ErrorStream)
				Free ErrorStream
				if (
					(Result != OK) and
					(not (MatchPattern Result Pattern:"*api.openiv.com*"))
				) then
					throw Result
			/*<ERRHANDLER>*/) catch (
				local	ReportPath = (
							(
								try
									GIMS.CurrentGame.BackupPath
								catch (
									try
										SysInfo.TempDir
									catch
										"Z:\\temp\\"
								)
							)
						),
						ReportFilePath = (ReportPath + "EGIMSReport.txt"),
						ErrorText = (((GetCurrentException()) as String) + "\n" + ErrorInfo.Text)
				MakeDir ReportPath All:true
				GIMS.Core.SystemMgr.FileDelete ReportFilePath
				local	fs = (CreateFile ReportFilePath)
				if fs != undefined then (
					try
						Print ErrorText To:fs
					catch
						Format "%\n" ErrorText To:fs
					Stack ShowLocals:true FirstFrameOnly:true To:fs
					Flush fs
					Close fs
					ShellLaunch ReportFilePath ""
				)
				if (QueryBox ("Can't send the error report.\nPlease check the internet connection and try again, or seek for support.\n\nThe report file has to be saved there:\n\"" + ReportFilePath + "\"\n\nContact support?") title:("GIMS Evo " + (try GIMS.CurrentGame.Name catch "") + " error report")) then (
					try (ShellLaunch GIMS.CurrentGame.RussianSupport "") catch ()
					try (ShellLaunch GIMS.CurrentGame.IntlSupport "") catch ()
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on GUInfo entered txt do
			try (GIMS.Core.GUIMgr.LastInput = txt) catch ()
		on EGIMS_ReportRollout Close do (
			try (
				local	DoSendReport = (
							try
								(not GIMS.CurrentGame.IsUpdateDeclined)
							catch
								true
						)
				if DoSendReport then
					SendReport()
			) catch ()
			try (Free GIMS.Core.SystemMgr.Warnings[1]) catch ()
			try (Free GIMS.Core.SystemMgr.Warnings[2]) catch ()
			try (Free GIMS.Core.SystemMgr.Warnings[3]) catch ()
			try (Free GIMS.Core.SystemMgr.Warnings[4]) catch ()
			try (Free GIMS.Core.SystemMgr.Errors[1]) catch ()
			try (Free GIMS.Core.SystemMgr.Errors[2]) catch ()
			try (Free GIMS.Core.SystemMgr.Errors[3]) catch ()
			try (Free GIMS.Core.SystemMgr.Errors[4]) catch ()
			try (GIMS.Core.BufferMgr.ClearBuffer 0) catch ()
		)
		on EGIMS_ReportRollout Open do (
			try
				GIMS.Core.GUIMgr.MainWindow.Close()
			catch (
				try (EGIMS_MainWindow.Close()) catch ()
			)
			try (GUInfo.Text = (GIMS.Core.GUIMgr.LastInput as String)) catch ()
			ErrorInfo.Text = (
				try
					(GIMS.Core.SystemMgr.ErrorStream as String)
				catch
					(GetClipboardText())
			)
			try (
				if GIMS.CurrentGame.IsUpdateDeclined then
					BSend.Text = "Please update GIMS to avoid errors in future"
			) catch ()
		)
	)
	rollout EGIMS_LangSelectRollout "GIMS language" Width:200 Height:31 (
		DropDownList	Lang	Pos:[4, 5]	Width:191
		
		on Lang Selected ID do
			GIMS.LangID = ID
		on EGIMS_LangSelectRollout Open do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	LangItems = #(),
						GIMSLanguages = GIMS.Languages
				for i = GIMSLanguages.Count to 1 by -1 do
					LangItems[i] = (GIMSLanguages[i] as String)
				Lang.Items = LangItems
				Lang.Selection = GIMS.LangID
			/*<ERRHANDLER>*/) catch (
				try (
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true
				) catch
					throw
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	rollout EGIMS_TextBoxRollout "" (
		local	Contr = #NoControl
		DotNETControl	Txt	"System.Windows.Forms.TextBox"	Pos:[0, 0]
		fn Init tContr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Txt.AutoSize = false
				Txt.Width = EGIMS_TextBoxRollout.Width
				Txt.Height = EGIMS_TextBoxRollout.Height
				Contr = tContr
				Txt.MultiLine = false
				Txt.BackColor = Contr.BackColor
				Txt.ForeColor = Contr.ForeColor
				Txt.Font = Contr.Font
				Txt.Text = Contr.Tag.Value.ItemContent
				Txt.Focus()
			/*<ERRHANDLER>*/) catch (
				DestroyDialog EGIMS_TextBoxRollout
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS)
				EGIMS_EHError CET ESS AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr))
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
		on Txt LostFocus do (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TheText = Txt.Text,
						GUIMgr = GIMS.Core.GUIMgr,
						Item = Contr.Tag.Value
				GUIMgr.LastInput = TheText
				Item.ItemContent = TheText
				Contr.Text = (Item.ItemText + TheText)
				local	HandlerName = Item.EventNames[9]
				if HandlerName != #Null then
					(GetProperty GIMS.Core.GUI HandlerName) Contr undefined
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true AddInfo:#(#(#Contr), #(EGIMS_DumpObjectInfo Contr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			DestroyDialog EGIMS_TextBoxRollout
		)
	)
		
	/*UUID*/
	fn EGIMS_RegenerateUUID = (
		local	ReenableTelemetry = EGIMS_TelemetryEnabled
		EGIMS_StopTelemetry User:false
		EGIMS_UUID = ((GetTimeStamp()) as String)
		DeleteFile EGIMS_UUIDFilePath
		local	fs = (CreateFile EGIMS_UUIDFilePath)
		if Have fs then (
			Format "\"%\"" EGIMS_UUID To:fs
			Close fs
		)
		local	WinReg = (
					try
						(DotNetClass "Microsoft.Win32.Registry")
					catch
						undefined
				)
		if Have WinReg then (
			try (GIMS.SetLifetimeController WinReg #MXS) catch ()
			try
				(WinReg.SetValue "HKEY_CURRENT_USER\\SOFTWARE\\GIMS" "UUID" EGIMS_UUID)
			catch ()
		)
		if ReenableTelemetry then
			EGIMS_StartTelemetry()
		OK
	)
	if No EGIMS_UUID then (
		local	WinReg = (
					try
						(DotNetClass "Microsoft.Win32.Registry")
					catch
						undefined
				)
		if Have WinReg then (
			try (GIMS.SetLifetimeController WinReg #MXS) catch ()
			EGIMS_UUID = (
				try
					(WinReg.GetValue "HKEY_CURRENT_USER\\SOFTWARE\\GIMS" "UUID" undefined)
				catch
					undefined
			)
		)
		if No EGIMS_UUID then (
			local	FileUUID = (
						if (DoesFileExist EGIMS_UUIDFilePath) then (
							try
								(FileIn EGIMS_UUIDFilePath)
							catch
								undefined
						) else
							undefined
					)
			if Have FileUUID then (
				EGIMS_UUID = FileUUID
				try
					(WinReg.SetValue "HKEY_CURRENT_USER\\SOFTWARE\\GIMS" "UUID" EGIMS_UUID)
				catch ()
			) else
				EGIMS_RegenerateUUID()
		)
	)
	
	/*Parts*/
	struct /*#PC*PATH	GIMS.Core.Rules*/ Rulesstr (
		GIMSObjectLink = "GIMS.Core.strRules",
		DefaultMaterialPropMapping = #(#Diffuse, #DiffuseMap),
		GATelemetryEnabled = true
	)
	if No GIMS.CurrentGame.Rules then
		GIMS.CurrentGame.Rules = (Rulesstr())

	struct ConfigPropsstr (
		BuildDate = "",
		CacheResetDate = "",
		RAWBuildDate = #(),
		Files = #(),
		Sizes = #(),
		Hashes = #(),
		Versions = #(),
		ChangeLog
	)
	
	struct /*#PC*PATH	GIMS.Core.BufferMgr*/ BufferMgrstr (
		/*Props*/
			Paths = #(),
			Buffers = #(),
			Readers = #(),
			Modes = #(),
			Sizes = #(),
			Capacities = #(),
			BigEndians = #{},
			LastPositions = #(),
			NANCounts = #(),
			NANOffsets = #(),
			CheckEOF = false,
			PreallocateAmount = 100,
		/*Cache*/
			NETSeekOrigin = (DotNETClass "System.IO.SeekOrigin"),
		/*Ops*/
			fn GetPath BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Paths[BufferID]
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetMode BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Modes[BufferID]
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ClearBuffer BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	AddResult = GIMS.Core.SystemMgr.AddResult,
							FormatText = GIMS.Core.ValueOps.FormatText
					if BufferID == 0 then (
						for BufferID = 1 to NANCounts.Count do (
							local	NANCount = NANCounts[BufferID],
									Offsets = NANOffsets[BufferID]
							if NANCount > 0 then (
								Offsets.Count = NANCount
								AddResult #Error (
									FormatText \
										v1:"Floating point value read returned Not-A-Number value " \
										v2:NANCount \
										v3:" times. Data may be corrupted.\nFile: " \
										v4:(GetPath BufferID) \
										v5:"\nOffsets: " \
										v6:(with PrintAllElements true (Offsets as String))
								)
							)
						)
						local	Dispose = GIMS.Core.ArrayOps.Dispose
						Dispose Buffers
						Dispose Paths
						Dispose Readers
						Dispose Modes
						Dispose Sizes
						Dispose Capacities
						Dispose BigEndians
						Dispose LastPositions
						Dispose NANCounts
						Dispose NANOffsets
						GIMS.Core.SystemMgr.DoGC()
					) else (
						local	NANCount = NANCounts[BufferID],
								Offsets = NANOffsets[BufferID]
						if NANCount > 0 then (
							Offsets.Count = NANCount
							AddResult #Error (
								FormatText \
									v1:"Floating point value read returned Not-A-Number value " \
									v2:NANCount \
									v3:" times. Data may be corrupted.\nFile: " \
									v4:(GetPath BufferID) \
									v5:"\nOffsets: " \
									v6:(with PrintAllElements true (Offsets as String))
							)
						)
						case Modes[BufferID] of (
							#StreamTxt: (
								Close Buffers[BufferID]
								Free Buffers[BufferID]
							)
							#StreamBin: (
								FClose Buffers[BufferID]
								Free Buffers[BufferID]
							)
							#NETBinStream:
								Buffers[BufferID].Close()
							default:
								GIMS.Core.ArrayOps.Dispose Buffers[BufferID]
						)
						if BufferID == Buffers.Count then (
							DeleteItem Buffers BufferID
							DeleteItem Paths BufferID
							DeleteItem Readers BufferID
							DeleteItem Modes BufferID
							DeleteItem Sizes BufferID
							DeleteItem Capacities BufferID
							DeleteItem BigEndians BufferID
							DeleteItem LastPositions BufferID
							DeleteItem NANCounts BufferID
							DeleteItem NANOffsets BufferID
						) else (
							Buffers[BufferID] = -1
							Paths[BufferID] = -1
							Readers[BufferID] = -1
							Modes[BufferID] = -1
							Sizes[BufferID] = -1
							Capacities[BufferID] = -1
							BigEndians[BufferID] = false
							LastPositions[BufferID] = -1
							NANCounts[BufferID] = -1
							NANOffsets[BufferID] = undefined
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CreateNewBuffer Mode:#TxtLines ForcedID:0 BufferData:undefined FilePath:#NoPath BigEndian:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local NewID
					if ForcedID != 0 then
						NewID = ForcedID
					else (
						NewID = (FindItem Readers -1)
						if NewID == 0 then
							NewID = (Readers.Count + 1)
					)
					Buffers[NewID] = BufferData
					Modes[NewID] = Mode
					Paths[NewID] = FilePath
					Readers[NewID] = 1L
					Sizes[NewID] = 0
					Capacities[NewID] = 0
					BigEndians[NewID] = BigEndian
					LastPositions[NewID] = 0
					NANCounts[NewID] = 0
					local	OffsetsDummy = #()
					OffsetsDummy.Count = 100
					NANOffsets[NewID] = OffsetsDummy
					NewID
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn Create Mode:#TxtLines ForcedID:0 AppendMode:false FilePath:#NoPath BufferData:undefined NETBufferSize:1024 BigEndian:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local NewID = (CreateNewBuffer Mode:Mode ForcedID:ForcedID FilePath:FilePath BufferData:BufferData BigEndian:BigEndian)
					if FilePath != #NoPath then
						GIMS.Core.SystemMgr.CreateDir (GetFileNamePath FilePath)
					case Mode of (
						#StreamTxt: (
							if FilePath == #NoPath then
								throw "Can't create stream buffer without FilePath"
							if AppendMode then
								Buffers[NewID] = (OpenFile FilePath Mode:"at")
							else
								Buffers[NewID] = (CreateFile FilePath)
						)
						#StreamBin: (
							if FilePath == #NoPath then
								throw "Can't create stream buffer without FilePath"
							if AppendMode then
								Buffers[NewID] = (FOpen FilePath "ab")
							else
								Buffers[NewID] = (FOpen FilePath "wb")
						)
						#NETBinStream: (
							if FilePath == #NoPath then
								throw "Can't create NET stream buffer without FilePath"
							local	s = (GIMS.Core.SystemMgr.GIMSOpsLib.GetStreamWriter FilePath AppendMode NETBufferSize BigEndian)
							try (GIMS.SetLifetimeController s #MXS) catch ()
							Buffers[NewID] = s
						)
						default: (
							if AppendMode then (
								if FilePath == #NoPath then
									throw "Can't create append stream buffer without FilePath"
								ReadFile FilePath Mode:Mode ForcedID:NewID
							) else (
								if Mode == #RawTxt then
									Buffers[NewID] = ""
								else
									Buffers[NewID] = #()
							)
						)
					)
					NewID
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn DeCrypt FilePath = (
				local	FS
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if (GetFileSize FilePath) > 3 then (
						FS = (FOpen FilePath "rb")
						if No FS then
							EGIMS_EHAbort ("Can't open file \"" + (FilePath as String) + "\" for reading! Please move it to another directory or fix security settings.")
						local	Magic = (ReadLong FS #Unsigned)
						FClose FS
						if Magic == 1095124051 then /*SDFA*/
							EGIMS_EHAbort ("File \"" + (FilePath as String) + "\" is encrypted.")
					)
				/*<ERRHANDLER>*/) catch (
					try (FClose FS)	catch ()
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
				)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ReadFile FilePath Mode:#TxtLines ForcedID:0 BigEndian:false NETBufferSize:1024 = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if (DoesFileExist FilePath) then (
						try (
							--DeCrypt FilePath
							local	NewID = (CreateNewBuffer Mode:Mode ForcedID:ForcedID FilePath:FilePath),
									Buf = (
										case Mode of (
											#Bin:
												(GIMS.Core.SystemMgr.NETFileIO.ReadAllBytes FilePath)
											#TxtLines:
												(GIMS.Core.SystemMgr.NETFileIO.ReadAllLines FilePath)
											#RawTxt:
												(GIMS.Core.SystemMgr.NETFileIO.ReadAllText FilePath)
											#StreamTxt:
												(OpenFile FilePath)
											#StreamBin:
												(FOpen FilePath "rb")
											#NETBinStream: (
												local	s = (GIMS.Core.SystemMgr.GIMSOpsLib.GetStreamReader FilePath NETBufferSize BigEndian)
												try (GIMS.SetLifetimeController s #MXS) catch ()
												s
											)
											default:
												throw "Unknown mode: " Mode
										)
									),
									BufferSize = (
										case Mode of (
											#StreamTxt: (
												Seek Buf #EOF
												local	r = (FilePos Buf)
												Seek Buf 0
												r
											)
											#StreamBin: (
												FSeek Buf 0 #seek_end
												local	r = (FTell Buf)
												FSeek Buf 0 #seek_set
												r
											)
											#NETBinStream:
												Buf.BaseStream.Length
											default:
												(Buf.Count as Integer64)
										)
									)
							Sizes[NewID] = BufferSize
							Capacities[NewID] = BufferSize
							BigEndians[NewID] = BigEndian
							Buffers[NewID] = Buf
							NewID
						) catch (
							if (MatchPattern (GetCurrentException()) Pattern:"*dotNet runtime exception: Could not find a part of the path*") then (
								GIMS.Core.SystemMgr.AddResult #Error (Append "Can't read the file - path's invalid: " FilePath)
								false
							) else
								throw
						)
					) else (
						GIMS.Core.SystemMgr.AddResult #Error (Append "Can't read the file - path's invalid: " FilePath)
						false
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn WriteFile BufferID FilePath:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if No FilePath then
						FilePath = Paths[BufferID]
					local	SystemMgr = GIMS.Core.SystemMgr
					SystemMgr.CreateDir (GetFileNamePath FilePath)
					try (
						SystemMgr.CreateDir (GetFileNamePath FilePath) All:true
						case Modes[BufferID] of (
							#Bin: (
								local	Buffer = Buffers[BufferID],
										NewCapacity = (Readers[BufferID] - 1)
								Buffer.Count = NewCapacity
								Capacities[BufferID] = NewCapacity
								SystemMgr.NETFileIO.WriteAllBytes FilePath Buffer
							)
							#TxtLines: (
								local	Buffer = Buffers[BufferID],
										NewCapacity = (Readers[BufferID] - 1)
								Buffer.Count = NewCapacity
								Capacities[BufferID] = NewCapacity
								SystemMgr.NETFileIO.WriteAllLines FilePath Buffer
							)
							#RawTxt:
								SystemMgr.NETFileIO.WriteAllText FilePath Buffers[BufferID]
							#StreamTxt: (
								Format "\n" To:Buffers[BufferID]
								Close Buffers[BufferID]
								Free Buffers[BufferID]
							)
							#StreamBin: (
								FClose Buffers[BufferID]
								Free Buffers[BufferID]
							)
							#NETBinStream:
								Buffers[BufferID].Close()
							default:
								throw "Unknown mode: " Modes[BufferID]
						)
					) catch (
						if (MatchPattern (GetCurrentException()) Pattern:"*dotNet runtime exception: Could not find a part of the path*") then (
							SystemMgr.AddResult #Error (Append "Can't write the file - path's invalid: " FilePath)
							false
						) else
							throw
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn TellPos BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.TellPos"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					case Modes[BufferID] of (
						#StreamTxt:
							(FilePos Buffers[BufferID])
						#StreamBin:
							(FTell Buffers[BufferID])
						#NETBinStream:
							Buffers[BufferID].BaseStream.Position
						default:
							Readers[BufferID]
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetErrorInfo BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					case (GetMode BufferID) of (
						#TxtLines:
							Append (Append "Buffer line " ((TellPos BufferID) as String)) ": "
						#Bin:
							Append (Append "Buffer pos " ((TellPos BufferID) as String)) ": "
						#RawTxt:
							Append (Append "Buffer pos " ((TellPos BufferID) as String)) ": "
						#StreamTxt:
							Append (Append "Buffer pos " ((TellPos BufferID) as String)) ": "
						#StreamBin:
							Append (Append "Buffer pos " ((TellPos BufferID) as String)) ": "
						#NETBinStream:
							Append (Append "Buffer pos " ((TellPos BufferID) as String)) ": "
						default:
							throw "Unknown mode: " (GetMode BufferID)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn StoreLastPosition BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.StoreLastPosition"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				
					/*TO DO remove, debug*
					LogProfiler #PlainInfo "Stored new last position [From, To]:\t" AddParam:[LastPositions[BufferID], (TellPos BufferID)]
					/**/
									
					LastPositions[BufferID] = (TellPos BufferID)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn BufSeek BufferID SeekPos Base:#Start = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.BufSeek"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	NewPos = (
								case Base of (
									#Start:
										Readers[BufferID] = SeekPos
									#Current:
										Readers[BufferID] += SeekPos
									#End:
										Readers[BufferID] = (Sizes[BufferID] - SeekPos)
									Default:
										throw "Unknown base"
								)
							)
					case Modes[BufferID] of (
						#StreamBin: (
							FSeek Buffers[BufferID] SeekPos (
								case Base of (
									#Start:
										#Seek_Set
									#Current:
										#Seek_Cur
									#End:
										#Seek_End
									Default:
										throw "Unknown base"
								)
							)
						)
						#NETBinStream: (
							Buffers[BufferID].BaseStream.Seek SeekPos (
								case Base of (
									#Start:
										NETSeekOrigin.Begin
									#Current:
										NETSeekOrigin.Current
									#End:
										NETSeekOrigin.End
									Default:
										throw "Unknown base"
								)
							)
						)
						#StreamTxt: (
							local	Buf = Buffers[BufferID]
							Seek Buf NewPos
							ReadChar Buf
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn Skip BufferID SkipCount = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.Skip"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					case Modes[BufferID] of (
						#StreamTxt: (
						
							/*TO DO remove, debug*
							LogProfiler #PlainInfo "Skip [From, Count, LastPos]:\t" AddParam:[TellPos BufferID, SkipCount, LastPositions[BufferID]]
							/**/
											
							if SkipCount < 0 then (
								if SkipCount < -1 then
									throw "Can't skip back in StreamTxt buffer more than once at a time"
								BufSeek BufferID LastPositions[BufferID]
							) else (
								StoreLastPosition BufferID
								local	Buf = Buffers[BufferID]
								for i = 1 to SkipCount do
									ReadLine Buf
							)
						)
						#StreamBin:
							FSeek Buffers[BufferID] SkipCount #Seek_Cur
						#NETBinStream:
							Buffers[BufferID].BaseStream.Seek SkipCount NETSeekOrigin.Current
					)
					Readers[BufferID] += SkipCount
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn BufReplace BufferID ReplaceWith AtPosition:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if Have AtPosition then (
						if (IsKindOf ReplaceWith array) then (
							for i = 1 to ReplaceWith.Count do
								Buffers[BufferID][AtPosition + i - 1] = ReplaceWith[i]
						) else
							Buffers[BufferID][AtPosition] = ReplaceWith
					) else (
						if (IsKindOf ReplaceWith array) then (
							for i = 1 to ReplaceWith.Count do
								Buffers[BufferID][Readers[BufferID] + i - 1] = ReplaceWith[i]
						) else
							Buffers[BufferID][Readers[BufferID]] = ReplaceWith
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetProgress BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.GetProgress"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					[(TellPos BufferID), 0, Sizes[BufferID]]
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn NotEOF BufferID = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.NotEOF"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					case Modes[BufferID] of (
						#StreamTxt:
							(not (EOF Buffers[BufferID]))	--((TellPos BufferID) < Sizes[BufferID])
						#StreamBin:
							((TellPos BufferID) < Sizes[BufferID])
						Default:
							((TellPos BufferID) <= Sizes[BufferID])
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BufferID), #(BufferID)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ReadVal BufferID \
				FilterStr:undefined \
				CaseOp:undefined \
				NoSeek:false \
				BinType:undefined \
				Size:1 \
				MAXType:undefined \
				ArrayItemMAXType:undefined \
				ArrayItemSize:1 \
				ValidateGTAString:false \
				CanSwitchEndian:true \
				&ResultSize:unsupplied \
				ValidateFiltered:false = \
			(
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.ReadVal"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						CheckEOF and
						not (NotEOF BufferID)
					then
						throw "End of file reached"
					local	Res,
							SkipCount = 1,
							CheckForNAN = false
					case Modes[BufferID] of (
						#Bin: (
							case MAXType of (
								#P2: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = [X, Y]
									NoSeek = true
								)
								#P3: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Z = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = [X, Y, Z]
									NoSeek = true
								)
								#P4: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Z = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											W = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = [X, Y, Z, W]
									NoSeek = true
								)
								#Quat: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Z = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											W = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = (Quat X Y Z W)
									NoSeek = true
								)
								#Euler: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											Z = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = (EulerAngles X Y Z)
									NoSeek = true
								)
								#Color: (
									local	R = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											G = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											B = (ReadVal BufferID NoSeek:NoSeek BinType:BinType),
											A = (ReadVal BufferID NoSeek:NoSeek BinType:BinType)
									Res = (Color R G B A)
									NoSeek = true
								)
								#Matrix3: (
									local	X = (ReadVal BufferID NoSeek:NoSeek BinType:BinType MAXType:#P3),
											Y = (ReadVal BufferID NoSeek:NoSeek BinType:BinType MAXType:#P3),
											Z = (ReadVal BufferID NoSeek:NoSeek BinType:BinType MAXType:#P3)
									Res = (Matrix3 X Y Z [0, 0, 0])
									NoSeek = true
								)
								#Array: (
									if NoSeek then
										throw "Can't turn off seeking while reading an array"
									Res = #()
									Res.Count = Size
									for i = 1 to Size do
										Res[i] = (ReadVal BufferID BinType:BinType MAXType:ArrayItemMAXType Size:ArrayItemSize)
									NoSeek = true
								)
								#String: (
									if NoSeek then
										throw "Can't turn off seeking while reading a String"
									Res = ""
									local	IntAsChar = Bit.IntAsChar,
											Parsing = true
									for i = 1 to Size do (
										if Parsing then (
											local	TempChar = (ReadVal BufferID NoSeek:NoSeek BinType:#UByte)
											if TempChar == 0 then
												Parsing = false
											else
												Res += (IntAsChar TempChar)
										) else
											Skip BufferID 1
									)
									NoSeek = true
								)
								#NTString: (
									if NoSeek then
										throw "Can't turn off seeking while reading a NTString"
									Res = ""
									local	IntAsChar = Bit.IntAsChar,
											Parsing = true
									while Parsing do (
										local	TempChar = (ReadVal BufferID NoSeek:NoSeek BinType:#UByte)
										if TempChar == 0 then
											Parsing = false
										else
											Res += (IntAsChar TempChar)
									)
									NoSeek = true
								)
								default: (
									local	IsBigEndian = BigEndians[BufferID]
									case BinType of (
										#Byte:
											Res = (GIMS.Core.SystemMgr.GIMSOpsLib.UInt8ToSigned Buffers[BufferID][Readers[BufferID]])
										#UByte: (
											Res = Buffers[BufferID][Readers[BufferID]]
											if Res < 0 then
												try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int8ToUnsigned Res)) catch ()
										)
										#Short: (
											SkipCount = 2
											Res = (GIMS.Core.SystemMgr.GIMSOpsLib.ToInt16 Buffers[BufferID] (Readers[BufferID] - 1))
										)
										#UShort: (
											SkipCount = 2
											local	Buf = Buffers[BufferID],
													Pos = Readers[BufferID],
													BitShift = Bit.Shift
											Res = 0
											for i = (SkipCount - 1) to 0 by -1 do
												Res += (BitShift Buf[Pos + i] (8 * i))
											if Res < 0 then
												try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int16ToUnsigned Res)) catch ()
										)
										#Int: (
											SkipCount = 4
											--Res = (GIMS.Core.SystemMgr.GIMSOpsLib.ToInt32 Buffers[BufferID] (Readers[BufferID] - 1))
											local	Buf = Buffers[BufferID],
													Pos = Readers[BufferID],
													BitShift = Bit.Shift
											Res = 0L
											for i = (SkipCount - 1) to 0 by -1 do
												Res += (BitShift Buf[Pos + i] (8 * i))
										)
										#UInt: (
											SkipCount = 4
											/**	--2.7 sec
											local	SystemMgr = GIMS.Core.SystemMgr
											Res = (SystemMgr.GIMSOpsLib.Int32ToUnsigned (SystemMgr.GIMSOpsLib.ToInt32 Buffers[BufferID] (Readers[BufferID] - 1)))
											/**/	--1.525 sec
											local	Buf = Buffers[BufferID],
													Pos = Readers[BufferID],
													BitShift = Bit.Shift
											Res = 0L
											for i = (SkipCount - 1) to 0 by -1 do
												Res += (BitShift Buf[Pos + i] (8 * i))
											if Res < 0 then
												try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Res)) catch ()
											/**/
										)
										#Quad: (
											SkipCount = 8
											/**/	--1.934 sec
											Res = (GIMS.Core.SystemMgr.GIMSOpsLib.ToInt64 Buffers[BufferID] (Readers[BufferID] - 1))
											/**	--3.332 sec
											local	Part1 = (ReadVal BufferID NoSeek:false BinType:#UInt),
													Part2 = (ReadVal BufferID NoSeek:false BinType:#UInt)
											Res = ((Bit.Shift (GIMS.Core.ValueOps.TypeCast Part2 Integer64) 32) + Part1)
											if NoSeek then
												Skip BufferID -SkipCount
											/**/
										)
										#UQuad: (
											SkipCount = 8
											/**/	--2.708 sec
											local	SystemMgr = GIMS.Core.SystemMgr
											Res = (SystemMgr.GIMSOpsLib.Int64ToUnsigned (SystemMgr.GIMSOpsLib.ToInt64 Buffers[BufferID] (Readers[BufferID] - 1)))
											/**	--3.388 sec
											local	Part1 = (ReadVal BufferID NoSeek:false BinType:#UInt),
													Part2 = (ReadVal BufferID NoSeek:false BinType:#UInt)
											Res = ((Bit.Shift (GIMS.Core.ValueOps.TypeCast Part2 Integer64) 32) + Part1)
											if NoSeek then
												Skip BufferID -SkipCount
											/**/
										)
										#HalfFloat: (
											SkipCount = 2
											CheckForNAN = true
											local	SystemMgr = GIMS.Core.SystemMgr,
													/**	--2.946 sec
													Base = (SystemMgr.GIMSOpsLib.Int16ToUnsigned (SystemMgr.GIMSOpsLib.ToInt16 Buffers[BufferID] (Readers[BufferID] - 1)))
													/**/	--0.912 sec
													Base = (ReadVal BufferID NoSeek:NoSeek BinType:#UShort)
											NoSeek = true
													/**/
											if IsBigEndian then
												Base = (GIMS.Core.ValueOps.SwitchEndian Base 2)
											CanSwitchEndian = false
											local	BitShift = Bit.Shift,
													BitAnd = Bit.And,
													BitOr = Bit.Or,
													Sign = (Bit.Get Base 0x10),
													Exponent = ((BitShift (BitAnd Base 0x7C00) -10) - 0x10),
													Fraction = (BitAnd Base 0x03FF),
													ExponentF = (Exponent + 0x7F),
													FractionShifted = (BitShift Fraction 13),
													ExponentFShifted = (BitShift ExponentF 23),
													FractionOrExponentF = (BitOr FractionShifted ExponentFShifted),
													IntFloat = (
														if Sign then
															(BitOr FractionOrExponentF 0x80000000L)	--0x80000000L = (BitShift 1 31)
														else
															FractionOrExponentF
													)
											Res = ((Bit.IntAsFloat IntFloat) * 2)
										)
										#Float: (
											SkipCount = 4
											CheckForNAN = true
											/**	--1.95 sec
											local	Base = (GIMS.Core.SystemMgr.GIMSOpsLib.ToSingle Buffers[BufferID] (Readers[BufferID] - 1))
											/**/	--0.815 sec
											local	Base = (ReadVal BufferID NoSeek:NoSeek BinType:#UInt)
											if IsBigEndian then
												Base = (GIMS.Core.ValueOps.SwitchEndian Base 4)
											CanSwitchEndian = false
											Res = (Bit.IntAsFloat Base)
											NoSeek = true
											/**/
										)
										#Double: (
											SkipCount = 8
											CheckForNAN = true
											/**/	--1.98 sec
											Res = (GIMS.Core.SystemMgr.GIMSOpsLib.ToDouble Buffers[BufferID] (Readers[BufferID] - 1))
											/**	--2.185 sec
											Res = (Bit.Int64AsDouble (ReadVal BufferID NoSeek:NoSeek BinType:#Quad))
											/**/
										)
										default:
											throw "Unknown type"
									)
									if
										CanSwitchEndian and
										SkipCount > 1 and
										IsBigEndian
									then
										Res = (GIMS.Core.ValueOps.SwitchEndian Res SkipCount)
								)
							)
							if not NoSeek then
								Skip BufferID SkipCount
						)
						#TxtLines: (
							Res = Buffers[BufferID][Readers[BufferID]]
							if Have Res then (
								local	StringOps = GIMS.Core.StringOps
								if
									ValidateGTAString and
									not (StringOps.ValidateGTAString Res)
								then
									Res = #InvalidLine
								else (
									case CaseOp of (
										#Lower:
											Res = (StringOps.ToLowReg Res)
										#Higher:
											Res = (StringOps.ToHighReg Res)
										#Name:
											Res = (GIMS.Core.ValueOps.TypeCast Res name)
									)
									if Have FilterStr then (
										Res = (FilterString Res FilterStr)
										if
											ValidateFiltered and
											not (StringOps.ValidateGTAString Res[1])
										then
											Res = #InvalidLine
									)
								)
							)
							if not NoSeek then
								Skip BufferID SkipCount
						)
						#RawTxt: (
							SkipCount = Size
							if Size == 1 then
								Res = Buffers[BufferID][Readers[BufferID]]
							else (
								local	Buf = Buffers[BufferID]
								if (Readers[BufferID] + Size) <= (Buf.Count + 1) then
									Res = (SubString Buf Readers[BufferID] Size)
							)
							if Have Res then (
								local	StringOps = GIMS.Core.StringOps
								if
									ValidateGTAString and
									not (StringOps.ValidateGTAString Res)
								then
									Res = #InvalidLine
								else (
									case CaseOp of (
										#Lower:
											Res = (StringOps.ToLowReg Res)
										#Higher:
											Res = (StringOps.ToHighReg Res)
										#Name:
											Res = (GIMS.Core.ValueOps.TypeCast Res name)
									)
									if Have FilterStr then (
										Res = (FilterString Res FilterStr)
										if
											ValidateFiltered and
											not (StringOps.ValidateGTAString Res[1])
										then
											Res = #InvalidLine
									)
								)
							)
							if not NoSeek then
								Skip BufferID SkipCount
						)
						#StreamTxt: (
						
							/*TO DO remove, debug*
							LogProfiler #PlainInfo "ReadVal [Seek, From, LastPos]:\t" AddParam:[Ternary NoSeek 0 1, TellPos BufferID, LastPositions[BufferID]]
							/**/

							StoreLastPosition BufferID
							local	StringOps = GIMS.Core.StringOps
							Res = (ReadLine Buffers[BufferID])
						
							/*TO DO remove, debug*
							LogProfiler #PlainInfo "\tReadVal result:\t" AddParam:Res
							/**/
							
							if
								ValidateGTAString and
								not (StringOps.ValidateGTAString Res)
							then
								Res = #InvalidLine
							else (
								case CaseOp of (
									#Lower:
										Res = (StringOps.ToLowReg Res)
									#Higher:
										Res = (StringOps.ToHighReg Res)
									#Name:
										Res = (GIMS.Core.ValueOps.TypeCast Res name)
								)
								if Have FilterStr then (
									Res = (FilterString Res FilterStr)
									if
										ValidateFiltered and
										not (StringOps.ValidateGTAString Res[1])
									then
										Res = #InvalidLine
								)
							)
							if NoSeek then
								Skip BufferID (-SkipCount)
							else
								Readers[BufferID] += SkipCount
											
						)
						#StreamBin: (
							local	OffsetChanged = false
							SkipCount = 0
							AddSize = 0
							case MAXType of (
								#P2: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y]
									OffsetChanged = true
								)
								#P3: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y, Z]
									OffsetChanged = true
								)
								#P4: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											W = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y, Z, W]
									OffsetChanged = true
								)
								#Quat: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											W = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (Quat X Y Z W)
									OffsetChanged = true
								)
								#Euler: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (EulerAngles X Y Z)
									OffsetChanged = true
								)
								#Color: (
									local	R = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											G = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											B = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											A = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (Color R G B A)
									OffsetChanged = true
								)
								#Matrix3: (
									local	X = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize))
									Res = (Matrix3 X Y Z [0, 0, 0])
									OffsetChanged = true
								)
								#Array: (
									Res = #()
									Res.Count = Size
									for i = 1 to Size do
										Res[i] = (ReadVal BufferID BinType:BinType MAXType:ArrayItemMAXType Size:ArrayItemSize ResultSize:(&AddSize))
									OffsetChanged = true
								)
								#String: (
									Res = ""
									local	IntAsChar = Bit.IntAsChar,
											Parsing = true
									for i = 1 to Size do (
										if Parsing then (
											local	TempChar = (ReadVal BufferID BinType:#UByte ResultSize:(&AddSize))
											if TempChar == 0 then
												Parsing = false
											else
												Res += (IntAsChar TempChar)
										) else
											Skip BufferID 1
									)
									OffsetChanged = true
								)
								#NTString: (
									Res = (ReadVal BufferID BinType:#String ResultSize:(&AddSize))
									OffsetChanged = true
								)
								default: (
									if
										CanSwitchEndian and
										BigEndians[BufferID]
									then (
										case BinType of (
											#UByte: (
												SkipCount = 1
												Res = (ReadByte Buffers[BufferID] #Unsigned)
											)
											#Byte: (
												SkipCount = 1
												Res = (ReadByte Buffers[BufferID] #Signed)
											)	
											#UShort: (
												SkipCount = 2
												Res = (ReadShort Buffers[BufferID] #Unsigned)
											)
											#Short: (
												SkipCount = 2
												Res = (ReadShort Buffers[BufferID] #Signed)
											)
											#UInt: (
												SkipCount = 4
												Res = (ReadLong Buffers[BufferID] #Unsigned)
												if Res < 0 then
													try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Res)) catch ()
											)
											#Int: (
												SkipCount = 4
												Res = (ReadLong Buffers[BufferID] #Signed)
											)
											#UQuad: (
												SkipCount = 8
												if No ReadLongLong then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (ReadLong Buffer #Signed),
															Part2 = (ReadLong Buffer #Signed)
													Part1 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part1)
													Part2 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part2)
													Res = (Part1 + (Bit.Shift Part2 32))
												) else
													Res = (ReadLongLong Buffers[BufferID] #Unsigned)
												if Res < 0 then
													try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int64ToUnsigned Res)) catch ()
											)
											#Quad: (
												SkipCount = 8
												if No ReadLongLong then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (ReadLong Buffer #Signed),
															Part2 = (ReadLong Buffer #Signed)
													Part1 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part1)
													Part2 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part2)
													Res = (Part1 + (Bit.Shift Part2 32))
												) else
													Res = (ReadLongLong Buffers[BufferID] #Signed)
											)
											#HalfFloat: (
												SkipCount = 2
												CheckForNAN = true
												local	Base = (ReadShort Buffers[BufferID] #Unsigned)
												Base = (GIMS.Core.ValueOps.SwitchEndian Base 2)
												local	BitShift = Bit.Shift,
														BitAnd = Bit.And,
														BitOr = Bit.Or,
														Sign = (Bit.Get Base 0x10),
														Exponent = ((BitShift (BitAnd Base 0x7C00) -10) - 0x10),
														Fraction = (BitAnd Base 0x03FF),
														ExponentF = (Exponent + 0x7F),
														FractionShifted = (BitShift Fraction 13),
														ExponentFShifted = (BitShift ExponentF 23),
														FractionOrExponentF = (BitOr FractionShifted ExponentFShifted),
														IntFloat = (
															if Sign then
																(BitOr FractionOrExponentF 0x80000000L)	--0x80000000L = (BitShift 1 31)
															else
																FractionOrExponentF
														)
												Res = ((Bit.IntAsFloat IntFloat) * 2)
											)
											#Float: (
												CheckForNAN = true
												SkipCount = 4
												local	Val = (ReadLong Buffers[BufferID] #Unsigned),
														BEVal = (GIMS.Core.ValueOps.SwitchEndian Val 4)
												Res = (Bit.IntAsFloat BEVal)
											)
											#Double: (
												CheckForNAN = true
												SkipCount = 8
												if No ReadDouble then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (TypeCast (ReadLong Buffer #Unsigned) Integer64),
															Part2 = (TypeCast (ReadLong Buffer #Unsigned) Integer64)
													Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int64BitsToDouble (Part1 + (Bit.Shift Part2 32)))
												) else
													Res = (ReadDouble Buffers[BufferID])
											)
											#String: (
												Res = (ReadString Buffers[BufferID])
												SkipCount = (Res.Count + 1)
											)
											default:
												throw "Unknown type"
										)
									) else (
										case BinType of (
											#UByte: (
												SkipCount = 1
												Res = (ReadByte Buffers[BufferID] #Unsigned)
											)
											#Byte: (
												SkipCount = 1
												Res = (ReadByte Buffers[BufferID] #Signed)
											)	
											#UShort: (
												SkipCount = 2
												Res = (ReadShort Buffers[BufferID] #Unsigned)
											)
											#Short: (
												SkipCount = 2
												Res = (ReadShort Buffers[BufferID] #Signed)
											)
											#UInt: (
												SkipCount = 4
												Res = (ReadLong Buffers[BufferID] #Unsigned)
												if Res < 0 then
													try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Res)) catch ()
											)
											#Int: (
												SkipCount = 4
												Res = (ReadLong Buffers[BufferID] #Signed)
											)
											#UQuad: (
												SkipCount = 8
												if No ReadLongLong then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (ReadLong Buffer #Signed),
															Part2 = (ReadLong Buffer #Signed)
													Part1 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part1)
													Part2 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part2)
													Res = (Part1 + (Bit.Shift Part2 32))
												) else
													Res = (ReadLongLong Buffers[BufferID] #Unsigned)
												if Res < 0 then
													try (Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int64ToUnsigned Res)) catch ()
											)
											#Quad: (
												SkipCount = 8
												if No ReadLongLong then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (ReadLong Buffer #Signed),
															Part2 = (ReadLong Buffer #Signed)
													Part1 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part1)
													Part2 = (GIMS.Core.SystemMgr.GIMSOpsLib.Int32ToUnsigned Part2)
													Res = (Part1 + (Bit.Shift Part2 32))
												) else
													Res = (ReadLongLong Buffers[BufferID] #Signed)
											)
											#HalfFloat: (
												SkipCount = 2
												CheckForNAN = true
												local	Base = (ReadShort Buffers[BufferID] #Unsigned),
														BitShift = Bit.Shift,
														BitAnd = Bit.And,
														BitOr = Bit.Or,
														Sign = (Bit.Get Base 0x10),
														Exponent = ((BitShift (BitAnd Base 0x7C00) -10) - 0x10),
														Fraction = (BitAnd Base 0x03FF),
														ExponentF = (Exponent + 0x7F),
														FractionShifted = (BitShift Fraction 13),
														ExponentFShifted = (BitShift ExponentF 23),
														FractionOrExponentF = (BitOr FractionShifted ExponentFShifted),
														IntFloat = (
															if Sign then
																(BitOr FractionOrExponentF 0x80000000L)	--0x80000000L = (BitShift 1 31)
															else
																FractionOrExponentF
														)
												Res = ((Bit.IntAsFloat IntFloat) * 2)
											)
											#Float: (
												CheckForNAN = true
												SkipCount = 4
												Res = (ReadFloat Buffers[BufferID])
											)
											#Double: (
												CheckForNAN = true
												SkipCount = 8
												if No ReadDouble then (
													local	TypeCast = GIMS.Core.ValueOps.TypeCast,
															Buffer = Buffers[BufferID],
															Part1 = (TypeCast (ReadLong Buffer #Unsigned) Integer64),
															Part2 = (TypeCast (ReadLong Buffer #Unsigned) Integer64)
													Res = (GIMS.Core.SystemMgr.GIMSOpsLib.Int64BitsToDouble (Part1 + (Bit.Shift Part2 32)))
												) else
													Res = (ReadDouble Buffers[BufferID])
											)
											#String: (
												Res = (ReadString Buffers[BufferID])
												SkipCount = (Res.Count + 1)
											)
											default:
												throw "Unknown type"
										)
									)
								)
							)
							SkipCount += AddSize
							if OffsetChanged then (
								if NoSeek then
									Skip BufferID (-SkipCount)
							) else (
								if NoSeek then
									Skip BufferID (-SkipCount)
								else
									Readers[BufferID] += SkipCount
							)
						)
						#NETBinStream: (
							local	OffsetChanged = false
							SkipCount = 0
							AddSize = 0
							case MAXType of (
								#P2: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y]
									OffsetChanged = true
								)
								#P3: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y, Z]
									OffsetChanged = true
								)
								#P4: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											W = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = [X, Y, Z, W]
									OffsetChanged = true
								)
								#Quat: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											W = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (Quat X Y Z W)
									OffsetChanged = true
								)
								#Euler: (
									local	X = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (EulerAngles X Y Z)
									OffsetChanged = true
								)
								#Color: (
									local	R = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											G = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											B = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize)),
											A = (ReadVal BufferID BinType:BinType ResultSize:(&AddSize))
									Res = (Color R G B A)
									OffsetChanged = true
								)
								#Matrix3: (
									local	X = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize)),
											Y = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize)),
											Z = (ReadVal BufferID BinType:BinType MAXType:#P3 ResultSize:(&AddSize))
									Res = (Matrix3 X Y Z [0, 0, 0])
									OffsetChanged = true
								)
								#Array: (
									Res = #()
									Res.Count = Size
									for i = 1 to Size do
										Res[i] = (ReadVal BufferID BinType:BinType MAXType:ArrayItemMAXType Size:ArrayItemSize ResultSize:(&AddSize))
									OffsetChanged = true
								)
								#String: (
									Res = ""
									local	IntAsChar = Bit.IntAsChar,
											Parsing = true
									for i = 1 to Size do (
										if Parsing then (
											local	TempChar = (ReadVal BufferID BinType:#UByte ResultSize:(&AddSize))
											if TempChar == 0 then
												Parsing = false
											else
												Res += (IntAsChar TempChar)
										) else
											Skip BufferID 1
									)
									OffsetChanged = true
								)
								#NTString: (
									Res = (ReadVal BufferID BinType:#String ResultSize:(&AddSize))
									OffsetChanged = true
								)
								default: (
									case BinType of (
										#UByte: (
											SkipCount = 1
											Res = (Buffers[BufferID].ReadByte())
										)
										#Byte: (
											SkipCount = 1
											Res = (Buffers[BufferID].ReadSByte())
										)	
										#UShort: (
											SkipCount = 2
											Res = (Buffers[BufferID].ReadUInt16())
										)
										#Short: (
											SkipCount = 2
											Res = (Buffers[BufferID].ReadInt16())
										)
										#UInt: (
											SkipCount = 4
											Res = (Buffers[BufferID].ReadUInt32())
										)
										#Int: (
											SkipCount = 4
											Res = (Buffers[BufferID].ReadInt32())
										)
										#UQuad: (
											SkipCount = 8
											Res = (Buffers[BufferID].ReadUInt64())
										)
										#Quad: (
											SkipCount = 8
											Res = (Buffers[BufferID].ReadInt64())
										)
										#HalfFloat: (
											CheckForNAN = true
											SkipCount = 2
											throw "HalfFloat reading isn't implemented in #NETBinStream mode"
										)
										#Float: (
											CheckForNAN = true
											SkipCount = 4
											Res = (Buffers[BufferID].ReadSingle())
										)
										#Double: (
											CheckForNAN = true
											SkipCount = 8
											Res = (Buffers[BufferID].ReadDouble())
										)
										#String: (
											Res = (Buffers[BufferID].ReadNTString())
											SkipCount = (Res.Count + 1)
										)
										default:
											throw "Unknown type"
									)
								)
							)
							SkipCount += AddSize
							if OffsetChanged then (
								if NoSeek then
									Skip BufferID (-SkipCount)
							) else (
								if NoSeek then
									Skip BufferID (-SkipCount)
								else
									Readers[BufferID] += SkipCount
							)
						)
						default:
							throw "Unknown mode: " Modes[BufferID]
					)
					if Supplied ResultSize then
						ResultSize += SkipCount
					if
						CheckForNAN and
						not (Bit.IsFinite Res)
					then (
						local	NANCount = (NANCounts[BufferID] += 1),
								Offsets = NANOffsets[BufferID]
						if NANCount > Offsets.Count then
							Offsets.Count  = (Offsets.Count + 100)
						Offsets[NANCount] = (TellPos BufferID)
						Res = 0.0
					)
					Res
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Modes, #BufferID), #(Modes, BufferID)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn PreallocateBufferSpace BufferID Count = (
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.WriteVal"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Capacity = Capacities[BufferID],
							AddSize = (
								if Count > PreallocateAmount then
									(PreallocateAmount * ((Count / PreallocateAmount) + 1))
								else
									PreallocateAmount
							)
					if (Sizes[BufferID] + Count) >= Capacity then (
						local	NewSize = (Capacity + AddSize)
						Buffers[BufferID].Count = NewSize
						Capacities[BufferID] = NewSize
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn WriteVal \
				BufferID \
				ValToPush \
				BinType:unsupplied \
				Size:1 \
				AppendLast:false \
				AllowPrealloc:true = \
			(
				/*<PROFILERSTART>*//*LogProfiler #Start "BufferMgr.WriteVal"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	BufferPos = Readers[BufferID]
					case Modes[BufferID] of (
						#Bin: (
							case (ClassOf ValToPush) of (
								Point2: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
								)
								Point3: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Point4: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								Quat: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								EulerAngles: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Array: (
									if not Supplied BinType then
										BinType = #Float
									for TempValue in ValToPush do
										WriteVal BufferID TempValue BinType:BinType Size:Size
								)
								String: (
									local	CharCount = ValToPush.Count,
											CharAsInt = Bit.CharAsInt
									if Size == -1 then (	/*NULL-terminated*/
										PreallocateBufferSpace BufferID (CharCount + 1)
										for CharID = 1 to CharCount do
											WriteVal BufferID (CharAsInt ValToPush[CharID]) BinType:#UByte AllowPrealloc:false
										Buffers[BufferID][Sizes[BufferID] += 1] = 0
									) else (
										PreallocateBufferSpace BufferID Size
										for CharID = 1 to Size do (
											if CharID > CharCount then
												Buffers[BufferID][Sizes[BufferID] += 1] = 0
											else
												WriteVal BufferID (CharAsInt ValToPush[CharID]) BinType:#UByte AllowPrealloc:false
										)
									)
								)
								default: (
									local	BitAnd = Bit.And,
											BitShift = Bit.Shift
									case BinType of (
										#UByte: (
											if AllowPrealloc then
												PreallocateBufferSpace BufferID 1
											Buffers[BufferID][Sizes[BufferID] += 1] = (BitAnd ValToPush 0xFF)
										)
										#UShort: (
											if AllowPrealloc then
												PreallocateBufferSpace BufferID 2
											ValToPush = (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush 2
												else
													ValToPush
											)
											local	BufferPos = Sizes[BufferID],
													BufferOffset = (BufferPos + 2)
											Buffers[BufferID][BufferPos + 1] = (BitAnd ValToPush 0xFF)
											Buffers[BufferID][BufferOffset] = (BitShift (BitAnd ValToPush 0xFF00) -8)
											Sizes[BufferID] = BufferOffset
										)
										#UInt: (
											if AllowPrealloc then
												PreallocateBufferSpace BufferID 4
											ValToPush = (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush 4
												else
													ValToPush
											)
											local	BufferPos = Sizes[BufferID],
													BufferOffset = (BufferPos + 4)
											Buffers[BufferID][BufferPos + 1] = (BitAnd ValToPush 0xFF)
											Buffers[BufferID][BufferPos + 2] = (BitShift (BitAnd ValToPush 0xFF00) -8)
											Buffers[BufferID][BufferPos + 3] = (BitShift (BitAnd ValToPush 0xFF0000) -16)
											Buffers[BufferID][BufferOffset] = ((BitShift (BitAnd ValToPush 0xFF000000L) -24) as Integer)
											Sizes[BufferID] = BufferOffset
										)
										#UQuad: (
											if AllowPrealloc then
												PreallocateBufferSpace BufferID 8
											ValToPush = (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush 8
												else
													ValToPush
											)
											local	BufferPos = Sizes[BufferID],
													BufferOffset = (BufferPos + 8)
											Buffers[BufferID][BufferPos + 1] = (BitAnd ValToPush 0xFF)
											Buffers[BufferID][BufferPos + 2] = (BitShift (BitAnd ValToPush 0xFF00) -8)
											Buffers[BufferID][BufferPos + 3] = (BitShift (BitAnd ValToPush 0xFF0000) -16)
											Buffers[BufferID][BufferPos + 4] = ((BitShift (BitAnd ValToPush 0xFF000000L) -24) as Integer)
											Buffers[BufferID][BufferPos + 5] = ((BitShift (BitAnd ValToPush 0xFF00000000L) -32) as Integer)
											Buffers[BufferID][BufferPos + 6] = ((BitShift (BitAnd ValToPush 0xFF0000000000L) -40) as Integer)
											Buffers[BufferID][BufferPos + 7] = ((BitShift (BitAnd ValToPush 0xFF000000000000L) -48) as Integer)
											Buffers[BufferID][BufferOffset] = ((BitShift (BitAnd ValToPush 0xFF00000000000000L) -56) as Integer)
											Sizes[BufferID] = BufferOffset
										)
										#Byte:
											WriteVal BufferID ValToPush BinType:#UByte
										#Short:
											WriteVal BufferID ValToPush BinType:#UShort
										#Int:
											WriteVal BufferID ValToPush BinType:#UInt
										#Quad:
											WriteVal BufferID ValToPush BinType:#UQuad
										#Float:
											WriteVal BufferID (Bit.FloatAsInt ValToPush) BinType:#UInt
										#Double:
											WriteVal BufferID (Bit.DoubleAsInt64 ValToPush) BinType:#UQuad
										Unsupplied:
											throw "No BinType supplied"
										default:
											throw "Unknown BinType"
									)
								)
							)
						)
						#TxtLines: (
							if (IsKindOf ValToPush array) then (
								if
									AllowPrealloc and
									not AppendLast
								then
									PreallocateBufferSpace BufferID ValToPush.Count
								Size = 0
								for TempItem in ValToPush do
									WriteVal BufferID TempItem AppendLast:AppendLast AllowPrealloc:false
							) else (
								if AppendLast then
									Buffers[BufferID][(TellPos BufferID) - 1] += (ValToPush as String)
								else (
									if AllowPrealloc then
										PreallocateBufferSpace BufferID 1
									Buffers[BufferID][Sizes[BufferID] += 1] = (ValToPush as String)
								)
							)
						)
						#RawTxt: (
							if (IsKindOf ValToPush array) then (
								Size = 0
								for TempItem in ValToPush do
									WriteVal BufferID TempItem AppendLast:AppendLast
							) else (
								local	Str = (ValToPush as String)
								Size = Str.Count
								Append Buffers[BufferID] Str
							)
						)
						#StreamTxt: (
							if (IsKindOf ValToPush array) then (
								Size = 0
								for TempItem in ValToPush do
									WriteVal BufferID TempItem AppendLast:AppendLast
							) else (
								local	Str = (ValToPush as String)
								Size = Str.Count
								if
									(BufferPos == 1L) or
									AppendLast
								then
									Format "%" Str To:Buffers[BufferID]
								else
									Format "\n%" Str To:Buffers[BufferID]
							)
						)
						#StreamBin: (
							case (ClassOf ValToPush) of (
								Point2: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
								)
								Point3: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Point4: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								Quat: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								EulerAngles: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Array: (
									if not Supplied BinType then
										BinType = #Float
									for TempValue in ValToPush do
										WriteVal BufferID TempValue BinType:BinType Size:Size
								)
								String: (
									if Size == -1 then (	/*NULL-terminated*/
										WriteString Buffers[BufferID] ValToPush
									) else (
										local	CharAsInt = Bit.CharAsInt,
												ValSize = ValToPush.Count
										for CharID = 1 to Size do (
											if CharID > ValSize then
												WriteVal BufferID 0 BinType:#UByte
											else
												WriteVal BufferID (CharAsInt ValToPush[CharID]) BinType:#UByte
										)
									)
								)
								default: (
									Size = 1
									case BinType of (
										#UByte:
											WriteByte Buffers[BufferID] ValToPush #Unsigned
										#UShort: (
											Size = 2
											WriteShort Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Unsigned
										)
										#UInt: (
											Size = 4
											WriteLong Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Unsigned
										)
										#UQuad: (
											Size = 8
											WriteLongLong Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Unsigned
										)
										#Byte:
											WriteByte Buffers[BufferID] ValToPush #Signed
										#Short: (
											Size = 2
											WriteShort Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Signed
										)
										#Int: (
											Size = 4
											WriteLong Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Signed
										)
										#Quad: (
											Size = 8
											WriteLongLong Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											) #Signed
										)
										#Float: (
											Size = 4
											WriteFloat Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											)
										)
										#Double: (
											Size = 8
											WriteDouble Buffers[BufferID] (
												if BigEndians[BufferID] then
													GIMS.Core.ValueOps.SwitchEndian ValToPush Size
												else
													ValToPush
											)
										)
										Unsupplied:
											throw "No BinType supplied"
										default:
											throw "Unknown BinType: " BinType
									)
								)
							)
						)
						#NETBinStream: (
							case (ClassOf ValToPush) of (
								Point2: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
								)
								Point3: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Point4: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								Quat: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
									WriteVal BufferID ValToPush.w BinType:BinType
								)
								EulerAngles: (
									if not Supplied BinType then
										BinType = #Float
									WriteVal BufferID ValToPush.x BinType:BinType
									WriteVal BufferID ValToPush.y BinType:BinType
									WriteVal BufferID ValToPush.z BinType:BinType
								)
								Array: (
									if not Supplied BinType then
										BinType = #Float
									for TempValue in ValToPush do
										WriteVal BufferID TempValue BinType:BinType Size:Size
								)
								String:
									Size = (Buffers[BufferID].WriteString ValToPush Size)
								default: (
									Size = 1
									case BinType of (
										#UByte:
											Size = (Buffers[BufferID].WriteByte ValToPush)
										#UShort:
											Size = (Buffers[BufferID].WriteUInt16 ValToPush)
										#UInt:
											Size = (Buffers[BufferID].WriteUInt32 ValToPush)
										#UQuad:
											Size = (Buffers[BufferID].WriteUInt64 ValToPush)
										#Byte:
											Size = (Buffers[BufferID].WriteSByte ValToPush)
										#Short:
											Size = (Buffers[BufferID].WriteInt16 ValToPush)
										#Int:
											Size = (Buffers[BufferID].WriteInt32 ValToPush)
										#Quad:
											Size = (Buffers[BufferID].WriteInt64 ValToPush)
										#Float:
											Size = (Buffers[BufferID].WriteSingle ValToPush)
										#Double:
											Size = (Buffers[BufferID].WriteDouble ValToPush)
										Unsupplied:
											throw "No BinType supplied"
										default:
											throw "Unknown BinType: " BinType
									)
								)
							)
						)
						default:
							throw "Unknown mode: " Modes[BufferID]
					)
					if
						not AppendLast and
						Size != 0
					then
						Readers[BufferID] = (BufferPos + Size)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn Search BufferID ValToFind CaseOp:undefined FromCurrent:true ToWhere:unsupplied NoSeek:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local Res = 0,
							FromWhere = (
								if FromCurrent then
									(TellPos BufferID)
								else
									1
							)
					case Modes[BufferID] of (
						#Bin:
							Res = (GIMS.Core.ArrayOps.Search Buffers[BufferID] ValToFind CaseOp:CaseOp FromWhere:FromWhere ToWhere:ToWhere)
						#TxtLines:
							Res = (GIMS.Core.ArrayOps.Search Buffers[BufferID] ValToFind CaseOp:CaseOp FromWhere:FromWhere ToWhere:ToWhere)
						#RawTxt: (
							if
								CaseOp == #Pattern and
								ValToFind[1] == "*"
							then
								throw "Can't match the whole file"
							Res = (GIMS.Core.StringOps.Search Buffers[BufferID] ValToFind CaseOp:CaseOp FromWhere:FromWhere ToWhere:ToWhere)
						)
						default:
							throw "Unknown mode: " Modes[BufferID]
					)
					if
						Res != 0 and
						not NoSeek
					then
						BufSeek BufferID Res
					Res
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
	)
	struct /*#PC*PATH	GIMS.Core.ObjectMgr*/ ObjectMgrstr (
		/*Props*/
		ExchangeData,
		/*Baking*/
		ElementNames = #(
			#AlphaMap,
			#AmbientOcclusion,
			#CompleteMap,
			#DiffuseMap,
			#HeightMap,
			#LightingMap,
			#NormalsMap,
			#ShadowsMap,
			#SpecularMap
		),
		Postfixes = #(
			"AlphaMap",	/*#AlphaMap*/
			"AmbientOcclusion",	/*#AmbientOcclusion,*/
			"CompleteMap",	/*#CompleteMap*/
			"DiffuseMap",	/*#DiffuseMap*/
			"HeightMap",	/*#HeightMap*/
			"LightingMap",	/*#LightingMap*/
			"NormalsMap",	/*#NormalsMap*/
			"ShadowsMap",	/*#ShadowsMap*/
			"SpecularMap"	/*#SpecularMap*/
		),
		BakeElements = #(
			AlphaMap,	/*#AlphaMap*/
			Ambient_Occlusion,	/*#AmbientOcclusion,*/
			CompleteMap,	/*#CompleteMap*/
			DiffuseMap,	/*#DiffuseMap*/
			HeightMap,	/*#HeightMap*/
			LightingMap,	/*#LightingMap*/
			NormalsMap,	/*#NormalsMap*/
			ShadowsMap,	/*#ShadowsMap*/
			SpecularMap	/*#SpecularMap*/
		),
		ShadowsOns = #(
			00000000000000,	/*#AlphaMap*/
			00000000000000,	/*#AmbientOcclusion,*/
			00000000000000,	/*#CompleteMap*/
			false,	/*#DiffuseMap*/
			00000000000000,	/*#HeightMap*/
			true,	/*#LightingMap*/
			00000000000000,	/*#NormalsMap*/
			00000000000000,	/*#ShadowsMap*/
			00000000000000	/*#SpecularMap*/
		),
		LightingOns = #(
			00000000000000,	/*#AlphaMap*/
			00000000000000,	/*#AmbientOcclusion,*/
			00000000000000,	/*#CompleteMap*/
			false,	/*#DiffuseMap*/
			00000000000000,	/*#HeightMap*/
			true,	/*#LightingMap*/
			00000000000000,	/*#NormalsMap*/
			00000000000000,	/*#ShadowsMap*/
			00000000000000	/*#SpecularMap*/
		),
		DirectOns = #(
			00000000000000,	/*#AlphaMap*/
			00000000000000,	/*#AmbientOcclusion,*/
			00000000000000,	/*#CompleteMap*/
			false,	/*#DiffuseMap*/
			00000000000000,	/*#HeightMap*/
			true,	/*#LightingMap*/
			00000000000000,	/*#NormalsMap*/
			00000000000000,	/*#ShadowsMap*/
			00000000000000	/*#SpecularMap*/
		),
		IndirectOns = #(
			00000000000000,	/*#AlphaMap*/
			00000000000000,	/*#AmbientOcclusion,*/
			00000000000000,	/*#CompleteMap*/
			false,	/*#DiffuseMap*/
			00000000000000,	/*#HeightMap*/
			true,	/*#LightingMap*/
			00000000000000,	/*#NormalsMap*/
			00000000000000,	/*#ShadowsMap*/
			00000000000000	/*#SpecularMap*/
		),
		/*Ops*/
		fn StoreTransformData Obj Times Values CoordsysTM = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	PosControllerKeys = Obj.Position.Controller.Keys,
						RotationControllerKeys = Obj.Rotation.Controller.Keys,
						ScaleControllerKeys = Obj.Scale.Controller.Keys,
						AppendIfUniq = GIMS.Core.ArrayOps.AppendIfUniq
				for Key in PosControllerKeys do
					AppendIfUniq Times Key.Time Sorted:true
				for Key in RotationControllerKeys do
					AppendIfUniq Times Key.Time Sorted:true
				for Key in ScaleControllerKeys do
					AppendIfUniq Times Key.Time Sorted:true
				for i = 1 to Times.Count do (
					at Time Times[i]
						Values[i] = (Obj.Transform * CoordsysTM)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StoreControllerData Controller Times Values = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Keys = Controller.Keys,
						KeyCount = Keys.Count
				Times.Count = (Values.Count = KeyCount)
				for i = 1 to KeyCount do (
					local	KeyTime = Keys[i].Time
					Times[i] = KeyTime
					Values[i] = (at Time KeyTime Controller.Value)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SelectWithChildren Obj = (
			/*<PROFILERSTART>*//*LogProfiler #Start "SelectWithChildren"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Obj != RootNode then
					SelectMore Obj
				for Child in Obj.Children do
					SelectWithChildren Child
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ExtendAnimationRange MinTime MaxTime = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if MinTime > MaxTime then
					throw "Minimum time has to be less or equal to maximum time"
				MAX Create Mode
				local	OldSelection = (Selection as array)
				Select Objects
				local	CurMinTime = (at Time AnimationRange.Start Trackbar.GetNextKeyTime())
				if No CurMinTime then
					AnimationRange = (Interval MinTime MaxTime)
				else (
					local	CurMaxTime = (at Time AnimationRange.End Trackbar.GetPreviousKeyTime())
					if MinTime < CurMinTime then
						CurMinTime = MinTime
					if MaxTime > CurMaxTime then
						CurMaxTime = MaxTime
					AnimationRange = (Interval CurMinTime CurMaxTime)
				)
				ClearSelection()
				Select OldSelection
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetAncestor Obj HTree:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GetAncestor"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Have Obj then (
					if Have HTree then
						InsertItem Obj HTree 1
					while Have Obj.Parent do
						Obj = (GetAncestor Obj.Parent HTree:HTree)
				)
				Obj
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ConfirmLoadEnvelopes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local HWND = (DialogMonitorOps.GetWindowHandle())
				if HWND != 0 then (
					local	WTitle = (UIAccessor.GetWindowText HWND)
					if WTitle == "Load Envelopes" then
						UIAccessor.PressButtonByName HWND "OK"
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			true
		),
		fn LoadEnvelopes ModSkin envFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				DialogMonitorOps.Enabled = true
				DialogMonitorOps.RegisterNotification ConfirmLoadEnvelopes ID:#PressSkinOK
				SkinOps.LoadEnvelope ModSkin envFile
				DialogMonitorOps.UnRegisterNotification ID:#PressSkinOK
				DialogMonitorOps.Enabled = false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ConfirmSaveUVWData = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local HWND = (DialogMonitorOps.GetWindowHandle())
				if HWND != 0 then (
					local	WTitle = (UIAccessor.GetWindowText HWND)
					if (MatchPattern WTitle Pattern:"*Save UVW") then (
						local	SystemMgr = GIMS.Core.SystemMgr
						SystemMgr.FileDelete ExchangeData
						local	GetWindow = SystemMgr.GIMSOpsLib.GetWindow,
								TypeCast = GIMS.Core.ValueOps.TypeCast,
								GetWindowClassName = UIAccessor.GetWindowClassName,
								Ptr = (GetWindow (DotNETObject "System.IntPtr" HWND) 5)
						while Ptr != 0 do (
							if (TypeCast (GetWindowClassName Ptr) Name) == #ComboBoxEx32 then (
								UIAccessor.SetWindowText Ptr ExchangeData
								Ptr = 0
							) else
								Ptr = (GetWindow (DotNETObject "System.IntPtr" Ptr) 2)
						)
						UIAccessor.SendMessageID HWND #IDOK
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			true
		),
		fn SaveUVWData Obj ModUVW FileName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	NeedToSelect = ((ModPanel.GetCurrentObject()) != ModUVW),
						OldSelection
				if NeedToSelect then (
					EGIMS_ResumeMAX()
					OldSelection = (Selection as array)
					Select Obj
					MAX Modify Mode
					EGIMS_SelectModifier ModUVW
				)
				ExchangeData = FileName
				DialogMonitorOps.Enabled = true
				DialogMonitorOps.RegisterNotification ConfirmSaveUVWData ID:#DoSaveUVW
				ModUVW.Save()
				DialogMonitorOps.UnRegisterNotification ID:#DoSaveUVW
				DialogMonitorOps.Enabled = false
				if NeedToSelect then (
					MAX Create Mode
					Select OldSelection
					EGIMS_SuspendMAX()
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ConfirmLoadUVWData = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local HWND = (DialogMonitorOps.GetWindowHandle())
				if HWND != 0 then (
					local	WTitle = (UIAccessor.GetWindowText HWND)
					if (MatchPattern WTitle Pattern:"*Load UVW") then (
						local	GetWindow = GIMS.Core.SystemMgr.GIMSOpsLib.GetWindow,
								TypeCast = GIMS.Core.ValueOps.TypeCast,
								GetWindowClassName = UIAccessor.GetWindowClassName,
								Ptr = (GetWindow (DotNETObject "System.IntPtr" HWND) 5)
						while Ptr != 0 do (
							if (TypeCast (GetWindowClassName Ptr) Name) == #ComboBoxEx32 then (
								UIAccessor.SetWindowText Ptr ExchangeData
								Ptr = 0
							) else
								Ptr = (GetWindow (DotNETObject "System.IntPtr" Ptr) 2)
						)
						UIAccessor.SendMessageID HWND #IDOK
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			true
		),
		fn LoadUVWData Obj ModUVW FileName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	NeedToSelect = ((ModPanel.GetCurrentObject()) != ModUVW),
						OldSelection
				if NeedToSelect then (
					EGIMS_ResumeMAX()
					OldSelection = (Selection as array)
					Select Obj
					MAX Modify Mode
					EGIMS_SelectModifier ModUVW
				)
				ExchangeData = FileName
				DialogMonitorOps.Enabled = true
				DialogMonitorOps.RegisterNotification ConfirmLoadUVWData ID:#DoLoadUVW
				ModUVW.Load()
				DialogMonitorOps.UnRegisterNotification ID:#DoLoadUVW
				DialogMonitorOps.Enabled = false
				if NeedToSelect then (
					MAX Create Mode
					Select OldSelection
					EGIMS_SuspendMAX()
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn StoreModData Obj SaveEnvelope:true CollapseToMesh:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Mods = #(),
						SkinModIDs = #{},
						LastSkinModID = 0,
						Modifiers = Obj.Modifiers,
						ModCount = Modifiers.Count
				if SaveEnvelope then (
					if CollapseToMesh then (
						Mods.Count = ModCount
						SkinModIDs.Count = ModCount
						local	MeshFound = false,
								ModsAdded = 0
						for i = 1 to ModCount while not MeshFound do (
							local	ObjMod = Modifiers[i],
									ModClass = (ClassOf ObjMod)
							case ModClass of (
								Edit_Poly:
									MeshFound = true
								Edit_Mesh:
									MeshFound = true
								Default: (
									if ModClass == Skin then (
										SkinModIDs[i] = true
										LastSkinModID = i
									)
									ModsAdded += 1
									Mods[ModsAdded] = ObjMod
								)
							)
						)
						SkinModIDs.Count = LastSkinModID
						if ModsAdded != ModCount then
							Mods.Count = ModsAdded
					) else (
						for i = ModCount to 1 by -1 do
							Mods[i] = Modifiers[i]
						for i = ModCount to 1 by -1 where (IsKindOf Mods[i] Skin) do
							SkinModIDs[i] = true
					)
					if LastSkinModID != 0 then (
						EGIMS_ResumeMAX()
						local	OldSelection,
								NeedToSelect = ($ != Obj)
						if NeedToSelect then (
							OldSelection = (Selection as array)
							Select Obj
						)
						MAX Modify Mode
						local	SkinOpsSaveEnvelope = SkinOps.SaveEnvelope,
								FormatText = GIMS.Core.ValueOps.FormatText,
								EnvPath = GIMS.CurrentGame.ResourceCachePath
						for SkinModID in SkinModIDs do (
							local	SkinMod = Mods[SkinModID]
							EGIMS_SelectModifier SkinMod
							SkinOpsSaveEnvelope SkinMod (
								FormatText \
									v1:EnvPath \
									v2:SkinModID \
									v3:".env"
							)
						)
						MAX Create Mode
						if NeedToSelect then
							Select OldSelection
						EGIMS_SuspendMAX()
					)
				) else (	--not SaveEnvelope
					if CollapseToMesh then (
						Mods.Count = ModCount
						local	MeshFound = false,
								ModsAdded = 0
						for i = 1 to ModCount while not MeshFound do (
							local	ObjMod = Modifiers[i],
									ModClass = (ClassOf ObjMod)
							case ModClass of (
								Edit_Poly:
									MeshFound = true
								Edit_Mesh:
									MeshFound = true
								Default: (
									ModsAdded += 1
									Mods[ModsAdded] = ObjMod
								)
							)
						)
						if ModsAdded != ModCount then
							Mods.Count = ModsAdded
					) else (
						for i = ModCount to 1 by -1 do
							Mods[i] = Modifiers[i]
					)
				)
				#(Mods, SkinModIDs)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#SaveEnvelope, #CollapseToMesh), #(SaveEnvelope, CollapseToMesh)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RestoreModData Obj ModData = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Mods = ModData[1],
						ModCount = Mods.Count
				if ModCount != 0 then (
					local	SkinModIDs = ModData[2],
							Ancestor = (GetAncestor Obj),
							AncestorTM = Ancestor.Transform,
							ModifyAncestorTM = (not (IsIdentity AncestorTM))
					if ModifyAncestorTM then
						Ancestor.Transform = (Matrix3 1)
					for i = Mods.Count to 1 by -1 do
						AddModifier Obj Mods[i] UI:false
					if SkinModIDs.NumberSet != 0 then (
						EGIMS_ResumeMAX()
						local	OldSelection,
								NeedToSelect = ($ != Obj)
						if NeedToSelect then (
							OldSelection = (Selection as array)
							Select Obj
						)
						MAX Modify Mode
						local	FormatText = GIMS.Core.ValueOps.FormatText,
								EnvPath = GIMS.CurrentGame.ResourceCachePath,
								FileDelete = GIMS.Core.SystemMgr.FileDelete
						for SkinModID in SkinModIDs do (
							local	EnvFilePath = (
										FormatText \
											v1:EnvPath \
											v2:SkinModID \
											v3:".env"
									),
									SkinMod = Mods[SkinModID]
							EGIMS_SelectModifier SkinMod
							SkinMod.Always_Deform = false
							LoadEnvelopes SkinMod EnvFilePath
							SkinMod.Always_Deform = true
							FileDelete EnvFilePath
						)
						MAX Create Mode
						if NeedToSelect then
							Select OldSelection
						EGIMS_SuspendMAX()
					)
					if ModifyAncestorTM then
						Ancestor.Transform = AncestorTM
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#ModData), #(ModData)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn BakeTextures Obj BakePath OutputSize Elements:#(#CompleteMap) = (
			/*TEST ZONE
				Obj = $
				BakePath = "Z:\\test\\"
				makedir BakePath
				OutputSize = [256, 256]
				Elements = #(#DiffuseMap)
			
			/**/
			local	CurrentRenderer = Renderers.Current
			Renderers.Current = Renderers.Medit
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	NeedToSelect = ((ModPanel.GetCurrentObject()) != Obj),
						OldSelection
				if NeedToSelect then (
					EGIMS_ResumeMAX()
					OldSelection = (Selection as array)
					Select Obj
					MAX Modify Mode
				)
				local	ModData = (StoreModData Obj),
						FlattenAngleThreshold = 180.0,
						FlattenSpacing = 0.001,
						BakeChannel = 10,
						INodeBakeProperties = Obj.INodeBakeProperties,
						ObjName = Obj.Name,
						FileNamePath = (BakePath + ObjName),
						FlattenUnwrapModName = "Auto flatten UVW",
						FlattenUnwrapMod = (Unwrap_UVW Name:FlattenUnwrapModName)
				FlattenUnwrapMod.SetAlwaysEdit false
				FlattenUnwrapMod.SetMapChannel BakeChannel
				FlattenUnwrapMod.SetFlattenAngle FlattenAngleThreshold
				FlattenUnwrapMod.SetFlattenSpacing FlattenSpacing
				FlattenUnwrapMod.SetFlattenNormalize true
				FlattenUnwrapMod.SetFlattenRotate true
				FlattenUnwrapMod.SetFlattenFillHoles true
				FlattenUnwrapMod.SetApplyToWholeObject true
				AddModifier Obj FlattenUnwrapMod UI:false
				FlattenUnwrapMod.FlattenMapByMatID FlattenAngleThreshold FlattenSpacing true BakeChannel true true
				INodeBakeProperties.RemoveAllBakeElements()
				local	QuickSearch = GIMS.Core.ArrayOps.QuickSearch,
						FormatText = GIMS.Core.ValueOps.FormatText
				for ElementName in Elements do (
					local	ElementID = (QuickSearch ElementNames ElementName),
							Postfix = (
								FormatText \
									v1:FileNamePath \
									v2:"_" \
									v3:Postfixes[ElementID] \
									v4:".png"
							),
							tBakeElement = ( \
								BakeElements[ElementID] \
								Enabled:true \
								FilterOn:true \
								FileName:ObjName \
								FileType:Postfix \
								OutputSzX:OutputSize.x \
								OutputSzY:OutputSize.y \
								ShadowsOn:ShadowsOns[ElementID] \
								LightingOn:LightingOns[ElementID] \
								DirectOn:DirectOns[ElementID] \
								IndirectOn:IndirectOns[ElementID] \
							)
					INodeBakeProperties.AddBakeElement tBakeElement
				)
				INodeBakeProperties.BakeEnabled = true
				INodeBakeProperties.BakeChannel = BakeChannel
				INodeBakeProperties.NDilations = 1	/*expand the texturea bit(???)*/
				Render RenderType:#BakeSelected VFB:false ProgressBar:true OutputWidth:OutputSize.x OutputHeight:OutputSize.y Quiet:true
				SaveUVWData Obj FlattenUnwrapMod (FileNamePath + ".uvw")
				DeleteModifier Obj FlattenUnwrapMod
				RestoreModData Obj ModData
				if NeedToSelect then (
					MAX Create Mode
					Select OldSelection
					EGIMS_SuspendMAX()
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			Renderers.Current = CurrentRenderer
			OK
		),
		fn GetChildren ParentNode Types WithSelf:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GetChildren"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (
							if WithSelf then
								#(ParentNode)
							else
								#()
						)
				for Item in ParentNode.Children where (FindItem Types (ClassOf Item.BaseObject)) != 0 do
					Result += (GetChildren Item Types WithSelf:true)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RemoveSmoothingGroups Obj = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ObjClass = (ClassOf Obj.BaseObject)
				case ObjClass of (
					Editable_Poly: (
						Obj.AutoSmoothThreshold = 0
						PolyOp.SetFaceSelection Obj #All
						PolyOp.AutoSmooth Obj
						PolyOp.SetFaceSelection Obj #{}
					)
					Editable_Mesh:
						Meshop.AutoSmooth Obj #All 0
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetMeshNormals \
			Result \
			VertNormals \
			Faces:unsupplied \
			CoordsysTM:unsupplied \
			FaceCount:unsupplied \
			VertPosCount:unsupplied \
			UpdateProgress:unsupplied \
			InvalidNormalDummy:[666, 666, 666] = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.SetMeshNormals"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
					local	HaveCoordsysTM = (Supplied CoordsysTM),
							SuppliedFaces = (Supplied Faces)
					if not Supplied UpdateProgress then
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
						
					--get unsupplied info
					if not Supplied FaceCount then (
						FaceCount = (
							if SuppliedFaces then
								Faces.Count
							else
								Result.NumFaces
						)
					)
					if not Supplied VertPosCount then
						VertPosCount = Result.NumVerts
					
					--check vertex count
					if VertNormals.Count != VertPosCount then
						throw "Mesh vertex count isn't equal to the normals count"
					if VertPosCount != 0 then (
							
						--set smoothing group of all faces to 1 to get one normal per vertex
						for i = 1 to FaceCount do
							SetFaceSmoothGroup Result i 1
							
						--fix normals array type
						if (not (IsKindOf VertNormals[1] Point3)) then (
							for i = 1 to VertPosCount do (
								local	n = VertNormals[i]
								VertNormals[i] = [n[1], n[2], n[3]]
							)
						)
						UpdateProgress #None 0
						
						--apply phys normals
						for i = 1 to VertPosCount do
							SetNormal Result i VertNormals[i]
						UpdateProgress #None 0
						
						--get faces
						if not SuppliedFaces then (
							Faces = #()
							for i = FaceCount to 1 by -1 do
								Faces[i] = (GetFace Result i)
						)
						UpdateProgress #None 0
						
						--apply normals
						local	NormalsMod = (Edit_Normals())
						AddModifier Result NormalsMod
						EGIMS_SelectModifier NormalsMod
						local	AllVerts = #{1..VertPosCount}
						NormalsMod.MakeExplicit Selection:AllVerts
						Free AllVerts
						local	NMGetNormalID = NormalsMod.GetNormalID,
								NMSetNormal = NormalsMod.SetNormal
						if HaveCoordsysTM then (
							for FaceID = 1 to FaceCount do (
								local	Face = Faces[FaceID]
								for CornerID = 1 to 3 do
									NMSetNormal (NMGetNormalID FaceID CornerID) VertNormals[Face[CornerID]]
							)
						) else (	--not HaveCoordsysTM
							for FaceID = 1 to FaceCount do (
								local	Face = Faces[FaceID]
								for CornerID = 1 to 3 do
									NMSetNormal (NMGetNormalID FaceID CornerID) VertNormals[Face[CornerID]]
							)
						)
						
						/*TO DO remove, normals debug*
						local	tLine = (SplineShape Name:"Normals" Parent:Result WireColor:Blue),
								SplineCount = 0,
								Verts = #()
						for i = VertPosCount to 1 by -1 do
							Verts[i] = (GetVert Result i)
						for FaceID = 1 to FaceCount do (
							local	Face = Faces[FaceID]
							for CornerID = 1 to 3 do (
								local	VertID = Face[CornerID]
								AddNewSpline tLine
								SplineCount += 1
								local	BasePoint = Verts[VertID]
								AddKnot tLine SplineCount #Corner #Line BasePoint
								AddKnot tLine SplineCount #Corner #Line (BasePoint + (VertNormals[VertID] / 50))
							)
						)
						UpdateShape tLine
						Free Verts
						/**/
						
					)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
			#(
				#Result,
				#VertNormals,
				#CoordsysTM,
				#FaceCount,
				#Faces,
				#VertPosCount,
				#InvalidNormalDummy
			), #(
				Result,
				VertNormals,
				CoordsysTM,
				FaceCount,
				Faces,
				VertPosCount,
				InvalidNormalDummy
			)
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		CreateMesh_ProgressStepCount = 7,
		fn CreateMesh \
			VertPositions \
			Faces \
			Polys:unsupplied \
			PolyMatIDs:1 \
			SGIDs:1 \
			MaterialIDs:1 \
			VertNormals:unsupplied \
			InvalidNormalDummy:[666, 666, 666] \
			VertTangents:unsupplied \
			TangentLenMult:0.02 \
			VertColors:unsupplied \
			VertColors2:unsupplied \
			MapFaces:unsupplied \
			MapVerts:unsupplied \
			MapVertMults:unsupplied \
			UVCount:0 \
			ObjName:"Object" \
			MeshTransform:unsupplied \
			Parent:RootNode \
			NormalsCoordsysTM:unsupplied \
			Mtl:unsupplied \
			SkinBones:unsupplied \
			SkinWeights:unsupplied \
			BoneNodes:unsupplied \
			BoneCount:unsupplied \
			UsedBones:unsupplied \
			ResultAsPoly:false \
			SG:#Set \
			WireColor:(Random Black White) \
			Progress:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.CreateMesh"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GATimeStart = (GetTimeStamp()),
						ValueOps = GIMS.Core.ValueOps,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ArrayOps = GIMS.Core.ArrayOps,
						Modify = ArrayOps.Modify,
						FaceCount = Faces.Count,
						VertPosCount = VertPositions.Count,
						ReportProgress = (Supplied Progress)
				--create mesh
				local	Result
				if (IsKindOf MaterialIDs Array) then (
					Result = (
						Mesh \
							Name:ObjName \
							Material:Mtl \
							Vertices:VertPositions \
							Faces:Faces \
							MaterialIDs:MaterialIDs \
							WireColor:WireColor
					)
				) else (
					Result = (
						Mesh \
							Name:ObjName \
							Material:Mtl \
							Vertices:VertPositions \
							Faces:Faces \
							WireColor:WireColor
					)
					for i = 1 to FaceCount do
						SetFaceMatID Result i MaterialIDs
				)
				local	DoPolys = (Supplied Polys),
						OpProvider = (
							if DoPolys then
								PolyOp
							else
								MeshOp
						)
				if Parent != RootNode then
					Result.Parent = Parent
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--add polys
				/*<ERRHANDLERSTART>*/try (
				if DoPolys then (
					ConvertToPoly Result
					local	PolyOpCreatePolygon = PolyOp.CreatePolygon,
							PolyOpCreateVert = PolyOp.CreateVert,
							PolyOpSetFaceMatID = PolyOp.SetFaceMatID,
							PolyOpDeleteVerts = PolyOp.DeleteVerts,
							PolyCount = Polys.Count,
							PolyMatIDsIsArray = (IsKindOf PolyMatIDs Array),
							ApplyMtlIDs = (
								PolyMatIDsIsArray or
								PolyMatIDs != 1
							)
					for ID = 1 to PolyCount do (
						local	Indices = Polys[ID],
								NewPolyID = (PolyOpCreatePolygon Result Indices),
								NewVertIDs
						if No NewPolyID then (
							local	CreationOK = true
							NewVertIDs = #()
							for VID = 1 to Indices.Count while CreationOK do (
								local	NewVertID = (PolyOpCreateVert Result VertPositions[Indices[VID]])
								if Have NewVertID then
									Append NewVertIDs NewVertID
								else
									CreationOK = false
							)
							if CreationOK then
								NewPolyID = (PolyOpCreatePolygon Result NewVertIDs)
						)
						if Have NewPolyID then (
							if ApplyMtlIDs then (
								PolyOpSetFaceMatID Result NewPolyID (
									if PolyMatIDsIsArray then
										PolyMatIDs[ID]
									else
										PolyMatIDs
								)
							)
						) else (
							PolyOpDeleteVerts Result NewVertIDs
							GIMS.Core.SystemMgr.AddResult #Error (
								ValueOps.FormatText \
									v1:"Failed to create poly with vertex indices " \
									v2:(ValueOps.AsoFText Indices SplitString:"-") \
									v3:" in object " \
									v4:(GetPathString Obj) \
									v5:". This polygon won't be created." \
							)
						)
					)
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--add map data
				local	FSetMapVert = OpProvider.SetMapVert,
						FSetMapFace = OpProvider.SetMapFace,
						FDefaultMapFaces = OpProvider.DefaultMapFaces,
						--FSetMapSupport = OpProvider.SetMapSupport,
						FSetNumMaps = OpProvider.SetNumMaps,
						SuppliedMapVerts = (Supplied MapVerts)
				if
					SuppliedMapVerts and
					UVCount == 0
				then
					UVCount = MapVerts.Count
				local	UVChannels = (
							local	Res = #()
							for i = UVCount to 1 by -1 do
								Res[i] = i
							Res
						),
						VertColorsPresent = (Supplied VertColors),
						VertColors2Present = (Supplied VertColors2),
						ChannelIDs
				if
					VertColorsPresent or
					VertColors2Present
				then (
					if
						VertColorsPresent and
						VertColors2Present
					then
						ChannelIDs = (#(-2, -1, 0) + UVChannels)
					else (
						if VertColorsPresent then
							ChannelIDs = (#(-2, 0) + UVChannels)
						else	--(not VertColorsPresent) = VertColors2Present
							ChannelIDs = (#(-1, 0) + UVChannels)
					)
				) else
					ChannelIDs = UVChannels
				/*<ERRHANDLERSTART>*/try (
				local	SuppliedMapVertMults = (Supplied MapVertMults)
				for ChannelID in ChannelIDs do
					FDefaultMapFaces Result ChannelID
				if SuppliedMapVerts then (
					for ChannelID in UVChannels do (
						local	MapVertCount = MapVerts[ChannelID].Count,
								ChannelMapVerts = MapVerts[ChannelID]
						if SuppliedMapVertMults then
							ChannelMapVerts = (Modify ChannelMapVerts MapVertMults[ChannelID] #Multiply CopyArray:true)
						if (try (ChannelMapVerts[1][3]; true) catch false) then (
							for VertID = 1 to MapVertCount do (
								local	TempVal = ChannelMapVerts[VertID]
								FSetMapVert Result ChannelID VertID [TempVal[1], TempVal[2], TempVal[3]]
							)
						) else ( 
							for VertID = 1 to MapVertCount do (
								local	TempVal = ChannelMapVerts[VertID]
								FSetMapVert Result ChannelID VertID [TempVal[1], TempVal[2], 0]
							)
						)
						if SuppliedMapVertMults then
							Free ChannelMapVerts
					)
					UpdateProgress #None 0
				)
				if Supplied MapFaces then (
					for ChannelID in UVChannels do (
						local	MapFaceCount = MapFaces[ChannelID].Count,
								ChannelMapFaces = MapFaces[ChannelID]
						for VertID = 1 to MapFaceCount do
							FSetMapFace Result ChannelID VertID ChannelMapFaces[VertID]
					)
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				--add colors with alphas
				/*<ERRHANDLERSTART>*/try (
				if
					VertColorsPresent and
					VertColors2Present
				then (
					local	VertColCount = VertColors.Count,
							VertCol2Count = VertColors2.Count
					if VertColCount != VertPosCount then
						throw "Vertex color count must be equal to vertex count"
					if VertCol2Count != VertPosCount then
						throw "Vertex color2 count must be equal to vertex count"
					for VertID = 1 to VertColCount do (
						local	Color1 = VertColors[VertID],
								Color2 = VertColors2[VertID]
						FSetMapVert Result 0 VertID [Color1[1], Color1[2], Color1[3]]
						FSetMapVert Result -1 VertID [Color2[1], Color2[2], Color2[3]]
						FSetMapVert Result -2 VertID [Color1[4], Color2[4], 0]
					)
				) else (	--not (VertColorsPresent and VertColors2Present)
					if VertColorsPresent then (
						local	VertColCount = VertColors.Count
						if VertColCount != VertPosCount then
							throw "Vertex color count must be equal to vertex count"
						for VertID = 1 to VertColCount do (
							local	Color1 = VertColors[VertID]
							FSetMapVert Result 0 VertID [Color1[1], Color1[2], Color1[3]]
							FSetMapVert Result -2 VertID [Color1[4], 0, 0]
						)
					)
					if VertColors2Present then (
						local	VertCol2Count = VertColors2.Count
						if VertCol2Count != VertPosCount then
							throw "Vertex color2 count must be equal to vertex count"
						for VertID = 1 to VertCol2Count do (
							local	Color2 = VertColors2[VertID]
							FSetMapVert Result -1 VertID [Color2[1], Color2[2], Color2[3]]
							FSetMapVert Result -2 VertID [0, Color2[4], 0]
						)
					)
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--add tangents
				/*<ERRHANDLERSTART>*/try (
				if Supplied VertTangents then (
					local	tLine = (SplineShape Name:"VertTangents" Parent:Result WireColor:Green),
							SplineCount = 0
					for VertID = 1 to VertPosCount do (
						AddNewSpline tLine
						SplineCount += 1
						local	BasePoint = VertPositions[VertID]
						AddKnot tLine SplineCount #Corner #Line BasePoint
						AddKnot tLine SplineCount #Corner #Line (BasePoint + (VertTangents[VertID] * TangentLenMult))
					)
					UpdateShape tLine
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				local	FSetFaceSmoothGroup = (
							if DoPolys then
								PolyOp.SetFaceSmoothGroup
							else
								SetFaceSmoothGroup
						),
						OldSelection,
						ApplyNormals = (Supplied VertNormals),
						ApplySkinning = (
							Supplied SkinBones and
							Supplied SkinWeights and
							Supplied BoneNodes
						),
						NeedInteractiveUI = (
							ApplyNormals or
							ApplySkinning
						)
				if NeedInteractiveUI then (
					EGIMS_ResumeMAX()
					OldSelection = (Selection as Array)
					Select Result
					MAX Modify Mode
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--add SG
				/*<ERRHANDLERSTART>*/try (
				case SG of (
					#Set: (
						if Have SGIDs then (
							if (IsKindOf SGIDs Array) then (
								for FaceID = 1 to Result.NumFaces do
									FSetFaceSmoothGroup Result FaceID SGIDs[FaceID]
							) else (
								for FaceID = 1 to Result.NumFaces do
									FSetFaceSmoothGroup Result FaceID SGIDs
							)
						)
					)
					#Remove:
						RemoveSmoothingGroups Result
					Default:
						throw "Unknown SG mode: " SG
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--add normals
				if ApplyNormals then (
					SetMeshNormals \
						Result \
						VertNormals \
						Faces:(if DoPolys then unsupplied else Faces) \
						CoordsysTM:NormalsCoordsysTM \
						InvalidNormalDummy:InvalidNormalDummy \
						FaceCount:FaceCount \
						VertPosCount:VertPosCount
--					if DoPolys then
--						ConvertToPoly Result
--					else
						CollapseStack Result
				)
				if Supplied MeshTransform then (
					Result.Transform = MeshTransform
					CollapseStack Result
				)
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--skin
				/*<ERRHANDLERSTART>*/try (
				if ApplySkinning then (
					/*<PROFILERSTART>*//*LogProfiler #Start "Apply skinning"; local PWS = (*//*<PROFILERSTARTED>*/
					
						if not Supplied BoneCount then
							BoneCount = BoneNodes.Count
						local	NormalizeA = ArrayOps.NormalizeA,
								BoneIDs = #(),
								BoneWeights = #()
						/*<PROFILERSTART>*//*LogProfiler #Start "Normalize skin data and get bone usage"; local PWS = (*//*<PROFILERSTARTED>*/
						
							if not Supplied UsedBones then (
								UsedBones = #{}
								UsedBones.Count = BoneCount
							)
							for VertID = VertPosCount to 1 by -1 do (
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
						
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						local	SkinMod = (Skin WeightAllVertices:false)
						AddModifier Result SkinMod
						EGIMS_SelectModifier SkinMod
						local	LastBoneID = -1
						/*<PROFILERSTART>*//*LogProfiler #Start "Add bones"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
							local	AddBone = SkinOps.AddBone,
									SetInnerRadius = SkinOps.SetInnerRadius,
									SetOuterRadius = SkinOps.SetOuterRadius
							for BoneID = 1 to BoneCount do (
								LastBoneID = BoneID
								AddBone SkinMod BoneNodes[BoneID] 0
								SetInnerRadius SkinMod BoneID 1 0
								SetOuterRadius SkinMod BoneID 1 0
								SetInnerRadius SkinMod BoneID 2 0
								SetOuterRadius SkinMod BoneID 2 0
							)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BoneNodes, #BoneID, #BoneNodeByID), #(BoneNodes, LastBoneID, if LastBoneID > 0 then BoneNodes[LastBoneID] else #OutOfBounds)))/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						Update Result
						local	UnNormalizeVertex = SkinOps.UnNormalizeVertex,
								GetVertexWeightCount = SkinOps.GetVertexWeightCount,
								GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
								ReplaceVertexWeights = SkinOps.ReplaceVertexWeights
						/*<PROFILERSTART>*//*LogProfiler #Start "Apply weights"; local PWS = (*//*<PROFILERSTARTED>*/
						
							for VertID = 1 to Result.NumVerts do (
								UnNormalizeVertex SkinMod VertID false
								local	VertBones = BoneIDs[VertID],
										VertWeights = BoneWeights[VertID],
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
						
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<PROFILERSTART>*//*LogProfiler #Start "Delete unused bones from skin mod"; local PWS = (*//*<PROFILERSTARTED>*/
						
							local	SelectBone = SkinOps.SelectBone,
									RemoveBone = SkinOps.RemoveBone
							for BoneID = BoneCount to 1 by -1 where not UsedBones[BoneID] do (
								SelectBone SkinMod BoneID
								RemoveBone SkinMod
							)
						
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#BoneNodes), #(BoneNodes)))/*<ERRHANDLEREND>*/
				if ReportProgress then (
					Progress.x += 1
					UpdateProgress #Progress Progress
				) else
					UpdateProgress #None 0
				--finish
				if NeedInteractiveUI then (
					Update Result
					MAX Create Mode
					Select OldSelection
					EGIMS_SuspendMAX()
				)				
				EGIMS_GAReportTiming "ObjectMgr" "CreateMesh" "Function" (((GetTimeStamp()) - GATimeStart) / EGIMS_DNTicksPerMillisecond)						
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RemapIDs IDs MapsFrom MapsTo MapsFromSorted:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if MapsFromSorted then (
					local	QuickSearch = GIMS.Core.ArrayOps.QuickSearch,
							MapsFromBA = (MapsFrom as BitArray)
					for i = 1 to IDs.Count do (
						local	SourceID = IDs[i]
						if MapsFromBA[SourceID] then
							IDs[i] = MapsTo[QuickSearch MapsFrom SourceID]
					)
					Free MapsFromBA
				) else 
					throw "Unsorted remap tables aren't supported yet"
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ExtendBound AABB AABBOrPos = (
			/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.ExtendBound"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	AABBMin = AABB.bMin,
						AABBMax = AABB.bMax
				if (IsKindOf AABBOrPos Point3) then (
					if AABBOrPos.x < AABBMin.x then
						AABB.bMin.x = AABBOrPos.x
					if AABBOrPos.y < AABBMin.y then
						AABB.bMin.y = AABBOrPos.y
					if AABBOrPos.z < AABBMin.z then
						AABB.bMin.z = AABBOrPos.z
					if AABBOrPos.x > AABBMax.x then
						AABB.bMax.x = AABBOrPos.x
					if AABBOrPos.y > AABBMax.y then
						AABB.bMax.y = AABBOrPos.y
					if AABBOrPos.z > AABBMax.z then
						AABB.bMax.z = AABBOrPos.z
				) else (
					local	AABBOrPosMin = AABBOrPos.bMin,
							AABBOrPosMax = AABBOrPos.bMax
					if AABBOrPosMin.x < AABBMin.x then
						AABB.bMin.x = AABBOrPosMin.x
					if AABBOrPosMin.y < AABBMin.y then
						AABB.bMin.y = AABBOrPosMin.y
					if AABBOrPosMin.z < AABBMin.z then
						AABB.bMin.z = AABBOrPosMin.z
					if AABBOrPosMax.x > AABBMax.x then
						AABB.bMax.x = AABBOrPosMax.x
					if AABBOrPosMax.y > AABBMax.y then
						AABB.bMax.y = AABBOrPosMax.y
					if AABBOrPosMax.z > AABBMax.z then
						AABB.bMax.z = AABBOrPosMax.z
				)
				AABB
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FixMaterialID InvalidID LastMatID = (
			/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.FixMaterialID"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IDMod = (Mod InvalidID LastMatID)
				(
					if IDMod == 0 then
						LastMatID
					else
						(IDMod as Integer)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn DumpMesh \
			SrcObj \
			Verts \
			Faces \
			Siblings:unsupplied \
			FaceGroups:unsupplied \
			Normals:unsupplied \
			PhysNormals:unsupplied \
			Tangents:unsupplied \
			Colors:unsupplied \
			Colors2:unsupplied \
			FaceMatIDs:unsupplied \
			Materials:unsupplied \
			MatPropMapping:GIMS.CurrentGame.Rules.DefaultMaterialPropMapping \
			UVCount:0 \
			UVData:unsupplied \
			SkinData:unsupplied \
			NormalsCoordsysTM:unsupplied \
			CoordsysTM:unsupplied = \
		(
			/*DATA FORMATS*
			Verts[VertCount]
			Faces[FaceCount]
			FaceGroups = Map:#(
				#(FaceMatIDs),
				#(FaceGroups),
				#SG	--set only if need to split by SG
			)
			Siblings[FaceCount] = #(
				FaceIDs
			)
			FaceMatIDs[FaceCount]
			Normals = #(
				NormalFaces[VertCount],
				NormalVectors[VertCount]
			)
			PhysNormals = #(VertNormals[VertCount])
			Tangents = #(
				TangentFaces[VertCount],
				TangentInfos[VertCount]
			)
			Colors = #(
				ColorFaces[FaceCount],
				ColorVerts = <ColorFaces mapped verts>
			)
			Colors2 = #(
				Color2Faces[FaceCount],
				Color2Verts = <Color2Faces mapped verts>
			)
			UVData = #(
				UVFaces[UVCount]
				UVVerts[UVCount]
			)
			SkinData = Map:#(
				Bones[VertCount],
				Weights[VertCount]
			)
			/**/
			/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh"; local PWS = (*//*<PROFILERSTARTED>*/
			local	Obj = (Copy SrcObj)
			/*<ERRHANDLERSTART>*/try (
				/*<TO DO remove, debug>*LogProfiler #PlainInfo "DumpMesh"/*<>*/
				local	GATimeStart = (GetTimeStamp()),
						Result = true,
						IsFinite = Bit.IsFinite,
						IsEPoly = (IsKindOf Obj.BaseObject Editable_Poly),
						FGetFaceSmoothGroup, FGetVert, FGetFace, FGetFaceMatID, OpProvider,
						NumVerts,
						NumFaces = Obj.NumFaces,
						HaveTangents = (Supplied Tangents),
						HaveColors = (Supplied Colors),
						HaveColors2 = (Supplied Colors2),
						HaveNormals = (Supplied Normals),
						HavePhysNormals = (Supplied PhysNormals),
						HaveSiblings = (Supplied Siblings),
						NeedMapData = (
							HaveColors or
							HaveColors2 or
							HaveTangents or (
								UVCount != 0 and
								Supplied UVData
							)
						),
						HaveFaceMatIDs = (Supplied FaceMatIDs),
						HaveMaterials = (Supplied Materials),
						HaveFaceGroups = (Supplied FaceGroups),
						NeedMatData = (
							HaveFaceMatIDs or
							HaveMaterials or
							HaveFaceGroups
						),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						ArrayOps = GIMS.Core.ArrayOps,
						ValueOps = GIMS.Core.ValueOps,
						RotateA = ArrayOps.RotateA,
						QuickSort = ArrayOps.QuickSort,
						FormatText = ValueOps.FormatText,
						PreallocatedMHLInsertItem = ArrayOps.PreallocatedMHLInsertItem,
						QuickSearch = ArrayOps.QuickSearch,
						AddResult = GIMS.Core.SystemMgr.AddResult,
						GetPathString = GIMS.Core.ObjectMgr.GetPathString,
						RotatedFaceIDs = #{},
						InvObjTM = (Inverse Obj.Transform),
						HaveNormalsCoordsysTM = (Supplied NormalsCoordsysTM),
						HaveFaceDegrees = HaveSiblings,
						FaceSGs,
						FaceDegrees,
						SplitSG = false
				if HaveFaceGroups then (
					FaceSGs = #()
					SplitSG = (FaceGroups[3] == #SG)
				)
				if not Supplied CoordsysTM then
					CoordsysTM = InvObjTM
				if IsEPoly then (
					OpProvider = PolyOp
					FGetVert = OpProvider.GetVert
					FGetFace = OpProvider.GetFaceVerts
					FGetFaceMatID = OpProvider.GetFaceMatID
					FGetFaceSmoothGroup = OpProvider.GetFaceSmoothGroup 
					if HaveFaceDegrees then
						FaceDegrees = #()
				) else (
					OpProvider = MeshOp
					FGetVert = GetVert
					FGetFace = GetFace
					FGetFaceMatID = GetFaceMatID
					FGetFaceSmoothGroup = GetFaceSmoothGroup 
				)

				/*detach zero SG faces*/
				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+DetachZeroSG"/*<>*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+FaceSGs"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (	
				if IsEPoly then (
					local	FDetachFaces = OpProvider.DetachFaces
					if SplitSG then (
						for i = NumFaces to 1 by -1 do (
							local	FaceSG = (FGetFaceSmoothGroup Obj i)
							FaceSGs[i] = FaceSG
							if FaceSG == 0 then
								FDetachFaces Obj i Delete:true AsMesh:false
						)
					) else (
						for i = NumFaces to 1 by -1 where (FGetFaceSmoothGroup Obj i) == 0 do
							FDetachFaces Obj i Delete:true AsMesh:false
					)
				) else (
					local	ZeroSGFaces = #{}
					if SplitSG then (
						for i = NumFaces to 1 by -1 do (
							local	FaceSG = (FGetFaceSmoothGroup Obj i)
							FaceSGs[i] = FaceSG
							if FaceSG == 0 then
								ZeroSGFaces[i] = true
						)
					) else (
						for i = NumFaces to 1 by -1 where (FGetFaceSmoothGroup Obj i) == 0 do
							ZeroSGFaces[i] = true
					)
					if ZeroSGFaces.NumberSet != 0 then (
						OpProvider.ExplodeFaces Obj ZeroSGFaces 0
						Free ZeroSGFaces
					)
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/

				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Verts"/*<>*/				
				/*get verts*/
				/*<ERRHANDLERSTART>*/try (
				NumVerts = Obj.NumVerts
				for i = NumVerts to 1 by -1 do
					Verts[i] = ((FGetVert Obj i) * CoordsysTM)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				
				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Faces"/*<>*/
				/*get faces*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+Faces"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if No Faces then
					Faces = #()
				if IsEPoly then (
					if HaveFaceDegrees then (
						local	FGetFaceDeg = PolyOp.GetFaceDeg
						for PolyID = NumFaces to 1 by -1 do (
							local	FaceVerts = (FGetFace Obj PolyID)
							Faces[PolyID] = FaceVerts
							if FaceVerts[4] == 1 then
								RotatedFaceIDs[PolyID] = true
							FaceDegrees[PolyID] = (FGetFaceDeg Obj PolyID)
						)
					) else (
						for PolyID = NumFaces to 1 by -1 do (
							local	FaceVerts = (FGetFace Obj PolyID)
							Faces[PolyID] = FaceVerts
							if FaceVerts[4] == 1 then
								RotatedFaceIDs[PolyID] = true
						)
					)
				) else (	--not IsEPoly
					for i = NumFaces to 1 by -1 do
						Faces[i] = (FGetFace Obj i)
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/

				/*get physical normals*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+PhysNormals"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if HavePhysNormals then (
					local	GGetFacesUsingVert = OpProvider.GetFacesUsingVert,
							FGetFaceNormal = OpProvider.GetFaceNormal
					for v = 1 to NumVerts do (
						local	VertFaces = (GGetFacesUsingVert Obj v),
								Normal = [0, 0, 0]
						for f in VertFaces do
							Normal += (FGetFaceNormal Obj f)
						PhysNormals[v] = (Normal / VertFaces.NumberSet)
						Free VertFaces
					)
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				
				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Siblings"/*<>*/
				/*get poly siblings*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+Siblings"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if HaveSiblings then (
					if IsEPoly then (
						local	FGetEdgesUsingFace = PolyOp.GetEdgesUsingFace,
								FGetFacesUsingEdge = PolyOp.GetFacesUsingEdge
						for PolyID = NumFaces to 1 by -1 do (
							local	PolyEdges = (FGetEdgesUsingFace Obj PolyID),
									PolySiblings = (
										case FaceDegrees[PolyID] of (
											3:
												[0, 0, 0]
											4:
												[0, 0, 0, 0]
											Default:
												#()
										)
									),
									EdgeIterator = 1
							for EdgeID in PolyEdges do (
								local	EdgePolyIDs = (FGetFacesUsingEdge Obj EdgeID)
								EdgePolyIDs[PolyID] = false
								PolySiblings[EdgeIterator] = (
									if EdgePolyIDs.NumberSet != 0 then (
										local	SiblingPolyID
										for sPolyID in EdgePolyIDs while No SiblingPolyID do
											SiblingPolyID = sPolyID
										SiblingPolyID
									) else
										0
								)
								EdgeIterator += 1
							)
							Siblings[PolyID] = PolySiblings
						)
						for FaceID in RotatedFaceIDs do (
							RotateA Faces[FaceID]
							RotateA Siblings[FaceID]
						)
					) else (
						local	FGetEdgesUsingFace = MeshOp.GetEdgesUsingFace,
								FGetFacesUsingEdge = MeshOp.GetFacesUsingEdge,
								FGetEdgesReverseEdge = MeshOp.GetEdgesReverseEdge
						for FaceID = NumFaces to 1 by -1 do (
							local	FaceSiblings = [0, 0, 0],
									FaceEdges = (FGetEdgesUsingFace Obj FaceID),
									EdgeIterator = 1
							for EdgeID in FaceEdges do (
								local	EdgeIDs = (FGetEdgesReverseEdge Obj EdgeID)
								EdgeIDs[EdgeID] = true
								local	EdgeFaceIDs = (FGetFacesUsingEdge Obj EdgeIDs)
								EdgeFaceIDs[FaceID] = false
								FaceSiblings[EdgeIterator] = (
									if EdgeFaceIDs.NumberSet != 0 then
										(EdgeFaceIDs as array)[1]
									else
										0
								)
								EdgeIterator += 1
							)
							Siblings[FaceID] = FaceSiblings
						)
					)
				) else (
					if IsEPoly then (
						for FaceID in RotatedFaceIDs do
							RotateA Faces[FaceID]
					)
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/

				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Material info"/*<>*/
				
				/*get material info*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MaterialInfo"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if NeedMatData then (
					local	ObjMaterial = (GIMS.CurrentGame.Core.MAXFactory.MaterialOps.GetStandartized Obj.Material),
							MaterialIDList = ObjMaterial.MaterialIDList
					if not HaveFaceMatIDs then
						FaceMatIDs = #()
					/*store ids*/
					for i = NumFaces to 1 by -1 do
						FaceMatIDs[i] = (FGetFaceMatID Obj i)
					/*remap wrong matids*/
					local	ArrMaterialIDList = (MaterialIDList as Array),
							MatIDBA = (ArrMaterialIDList as BitArray),
							FaceMatIDsBA = (FaceMatIDs as BitArray),
							InvalidIDsBA = (FaceMatIDsBA - MatIDBA)
					Free ArrMaterialIDList
					Free FaceMatIDsBA
					if InvalidIDsBA.Count != 0 then (
						local	InvalidIDs = (InvalidIDsBA as Array),
								FixedIDs = #(),
								LastMatID = MatIDBA.Count
						for i = InvalidIDs.Count to 1 by -1 do
							FixedIDs[i] = (FixMaterialID InvalidIDs[i] LastMatID)
						RemapIDs FaceMatIDs InvalidIDs FixedIDs
						Free InvalidIDs
						Free InvalidIDsBA
					)
					Free MatIDBA
					/*get materials and remap FaceMatIDs if needed*/
					if HaveMaterials then (
						local	UsedFaceMatIDs = (FaceMatIDs as BitArray),
								InvalidIDs = #(),
								FixedIDs = #(),
								InvalidIDCount = 0,
								MaterialList = ObjMaterial.MaterialList,
								MaterialListCount = MaterialList.Count,
								AppendIfUniq = ArrayOps.AppendIfUniq
						InvalidIDs.Count = MaterialListCount
						FixedIDs.Count = MaterialListCount
						MatPropMapping = #(MatPropMapping, MatPropMapping)
						for i = 1 to MaterialListCount do (
							local	SourceMtlID = MaterialIDList[i]
							if UsedFaceMatIDs[SourceMtlID] then (
								local	Mtl = MaterialList[i],
										TargetMtlID = (AppendIfUniq Materials Mtl GetID:true PropMapping:MatPropMapping)
								if SourceMtlID != TargetMtlID then (
									InvalidIDCount += 1
									InvalidIDs[InvalidIDCount] = SourceMtlID
									FixedIDs[InvalidIDCount] = TargetMtlID
								)
							)
						)
						Free UsedFaceMatIDs
						InvalidIDs.Count = InvalidIDCount
						FixedIDs.Count = InvalidIDCount
						if InvalidIDCount != 0 then (
							RemapIDs FaceMatIDs InvalidIDs FixedIDs
							Free InvalidIDs
							Free FixedIDs
						)
					)
					/**/
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/

				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Face groups"/*<>*/
				
				/*get face smooth groups*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+FaceGroups"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if HaveFaceGroups then (
					/*<ERRHANDLERSTART>*/try (
					local	GroupMatIDs = #(),
							MatGroupedFaces = #(),
							MatGroupSizes = #(),
							MatGroupCount = 0,
							UsedFaceMatIDs = (FaceMatIDs as BitArray),
							MatIDCount = UsedFaceMatIDs.Count
							
					/*<TO DO remove, debug>*
					LogProfiler #PlainInfo "DumpMesh" AddParam:Obj 
					LogProfiler #PlainInfo "\tUsedFaceMatIDs" AddParam:UsedFaceMatIDs 
					LogProfiler #PlainInfo "\tMatIDCount" AddParam:MatIDCount 
					/*<>*/
					
					Free UsedFaceMatIDs
					GroupMatIDs.Count = MatIDCount
					MatGroupedFaces.Count = MatIDCount
					MatGroupSizes.Count = MatIDCount
					if SplitSG then (

						/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t*Smoothed"/*<>*/
						
						/*<ERRHANDLERSTART>*/try (
						local	GroupSGIDs = #()
						GroupSGIDs.Count = MatIDCount
						for FaceID = 1 to NumFaces do (
							local	FaceMatID = FaceMatIDs[FaceID],
									FaceSG = FaceSGs[FaceID],
									GroupID
							for ID = 1 to MatGroupCount where
								GroupMatIDs[ID] == FaceMatID and
								GroupSGIDs[ID] == FaceSG
							while No GroupID do
								GroupID = ID
									
							/*<TO DO remove, debug>*
							LogProfiler #PlainInfo "\tFACE" AddParam:FaceID 
							LogProfiler #PlainInfo "\t\tFaceMatID" AddParam:FaceMatID 
							LogProfiler #PlainInfo "\t\tFaceSG" AddParam:FaceSG 
							LogProfiler #PlainInfo "\t\tGroupID" AddParam:GroupID 
							/*<>*/
							
							if No GroupID then (
								MatGroupCount += 1
										
								/*<TO DO remove, debug>*LogProfiler #PlainInfo "\tNEW GROUP" AddParam:MatGroupCount /*<>*/
					
								GroupMatIDs[MatGroupCount] = FaceMatID
								GroupSGIDs[MatGroupCount] = FaceSG
								MatGroupSizes[MatGroupCount] = 1
								local	GroupFaces = #(FaceID)
								GroupFaces.Count = NumFaces
								MatGroupedFaces[MatGroupCount] = GroupFaces
							) else (
								MatGroupSizes[GroupID] += 1
								local	GroupSize = MatGroupSizes[GroupID]
										
								/*<TO DO remove, debug>*
								LogProfiler #PlainInfo "\tOLD GROUP" AddParam:MatGroupCount 
								LogProfiler #PlainInfo "\t\tGroupSize" AddParam:GroupSize 
								/*<>*/
								
								MatGroupedFaces[GroupID][GroupSize] = FaceID
							)
						)
						Free GroupSGIDs
						Free FaceSGs
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					) else (

						/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t*Not smoothed"/*<>*/
				
						/*<ERRHANDLERSTART>*/try (
						for FaceID = 1 to NumFaces do (
							local	FaceMatID = FaceMatIDs[FaceID],
									GroupID = (FindItem GroupMatIDs FaceMatID)
									
							/*<TO DO remove, debug>*
							LogProfiler #PlainInfo "\tFACE" AddParam:FaceID 
							LogProfiler #PlainInfo "\t\tFaceMatID" AddParam:FaceMatID 
							LogProfiler #PlainInfo "\t\tFaceSG" AddParam:FaceSG 
							LogProfiler #PlainInfo "\t\tGroupID" AddParam:GroupID 
							/*<>*/
							
							if (GroupID == 0) then (
								MatGroupCount += 1
										
								/*<TO DO remove, debug>*LogProfiler #PlainInfo "\tNEW GROUP" AddParam:MatGroupCount /*<>*/
					
								GroupMatIDs[MatGroupCount] = FaceMatID
								MatGroupSizes[MatGroupCount] = 1
								local	GroupFaces = #(FaceID)
								GroupFaces.Count = NumFaces
								MatGroupedFaces[MatGroupCount] = GroupFaces
							) else (
								MatGroupSizes[GroupID] += 1
								local	GroupSize = MatGroupSizes[GroupID]
										
								/*<TO DO remove, debug>*
								LogProfiler #PlainInfo "\tOLD GROUP" AddParam:MatGroupCount 
								LogProfiler #PlainInfo "\t\tGroupSize" AddParam:GroupSize 
								/*<>*/
					
								MatGroupedFaces[GroupID][GroupSize] = FaceID
							)
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
					)

					/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+Cleanup and storage"/*<>*/
				
					--remove unused items
					GroupMatIDs.Count = MatGroupCount
					MatGroupedFaces.Count = MatGroupCount
					for i = 1 to MatGroupCount do (
						MatGroupedFaces[i].Count = MatGroupSizes[i]
							
						/*<TO DO remove, debug>*
						LogProfiler #PlainInfo "\t\tMatGroupSize" AddParam:MatGroupSizes[i] 
						LogProfiler #PlainInfo "\t\tMatGroupedFaces" AddParam:MatGroupedFaces[i] 
						/*<>*/
		
					)
					Free MatGroupSizes
						
					--store results
					FaceGroups[1] = GroupMatIDs
					FaceGroups[2] = MatGroupedFaces
					FaceGroups.Count = 2
					QuickSort FaceGroups MHL:true MHLKeyItemID:1
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				
				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Normals"/*<>*/
				
				local	HaveSkinData = (Supplied SkinData),
						NeedNormals = (
							HaveNormals or
							HaveTangents
						),
						NeedInteractiveUI = (
							NeedNormals or
							HaveSkinData
						),
						OldSelection,
						NormalFaces, NormalVectors
						
				/*get normals*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+Normals"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if NeedInteractiveUI then (
					EGIMS_ResumeMAX()
					OldSelection = (Selection as Array)
					Select Obj
					MAX Modify Mode
				)
				if NeedNormals then (
					
					--add modifier
					local	NormalsMod = (Edit_Normals())
					AddModifier Obj NormalsMod
					EGIMS_SelectModifier NormalsMod
					local	NumNormalsVerts = (NormalsMod.GetNumNormals()),
							FNMGetNumFaces = NormalsMod.GetNumFaces,
							NumNormalsFaces = (FNMGetNumFaces())
					if NumNormalsFaces != NumFaces then (
						AddResult #Warning (
							FormatText \
								v1:"Number of physical faces " \
								v2:NumFaces \
								v3:" isn't equal to number of Normal faces " \
								v4:NumNormalsFaces \
								v5:" in mesh " \
								v6:(GetPathString Obj) \
								v7:".\nGIMS will try to fix that, but the results can be wrong." \
						)
						NormalsMod.RebuildNormals()
						NumNormalsFaces = (FNMGetNumFaces())
						if NumNormalsFaces != NumFaces then (
							NormalsMod.RecomputeNormals()
							NumNormalsFaces = (FNMGetNumFaces())
							if NumNormalsFaces != NumFaces then
								throw (Append (Append "Number of physical faces " (NumFaces as String)) " isn't equal to number of Normal faces ") NumNormalsFaces
						)
					)
				
					--prepare result array
					NormalFaces = #()
					NormalVectors = #()
					NormalFaces.Count = NumNormalsFaces
					NormalVectors.Count = NumNormalsVerts
					
					--get normals data
					local	NMGetNormalID = NormalsMod.GetNormalID,
							NMGetNormal = NormalsMod.GetNormal,
							NMGetFaceDegree = NormalsMod.GetFaceDegree
					if HaveNormalsCoordsysTM then (
						if IsEPoly then (
							for FaceID = 1 to NumFaces do (
								local	Face = Faces[FaceID],
										FaceDegree = (NMGetFaceDegree FaceID), 
										NormalFace = #()
								for CornerID = FaceDegree to 1 by -1 do (
									local	NormID = (NMGetNormalID FaceID CornerID)
									NormalFace[CornerID] = NormID
									NormalVectors[NormID] = ((NMGetNormal NormID) * NormalsCoordsysTM)
								)
								NormalFaces[FaceID] = NormalFace
							)
						) else (	--not IsEPoly
							for FaceID = 1 to NumFaces do (
								local	Face = Faces[FaceID],
										FaceDegree = (NMGetFaceDegree FaceID), 
										NormalFace = #()
								for CornerID = FaceDegree to 1 by -1 do (
									local	NormID = (NMGetNormalID FaceID CornerID)
									NormalFace[CornerID] = NormID
									NormalVectors[NormID] = ((NMGetNormal NormID) * NormalsCoordsysTM)
								)
								NormalFaces[FaceID] = NormalFace
							)
						)
					) else (	--not HaveNormalsCoordsysTM
						if IsEPoly then (
							for FaceID = 1 to NumFaces do (
								local	Face = Faces[FaceID],
										FaceDegree = (NMGetFaceDegree FaceID), 
										NormalFace = #()
								for CornerID = FaceDegree to 1 by -1 do (
									local	NormID = (NMGetNormalID FaceID CornerID)
									NormalFace[CornerID] = NormID
									NormalVectors[NormID] = (NMGetNormal NormID)
								)
								NormalFaces[FaceID] = NormalFace
							)
						) else (	--not IsEPoly
							for FaceID = 1 to NumFaces do (
								local	Face = Faces[FaceID],
										FaceDegree = (NMGetFaceDegree FaceID), 
										NormalFace = #()
								for CornerID = FaceDegree to 1 by -1 do (
									local	NormID = (NMGetNormalID FaceID CornerID)
									NormalFace[CornerID] = NormID
									NormalVectors[NormID] = (NMGetNormal NormID)
								)
								NormalFaces[FaceID] = NormalFace
							)
						)
					)
					DeleteModifier Obj NormalsMod
					
					--store results
					if HaveNormals then (
						Normals[2] = NormalVectors
						Normals[1] = NormalFaces
					)					
				)	--NeedNormals
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				if HaveFaceDegrees then
					Free FaceDegrees

				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Skinning"/*<>*/
				
				/*get skin data*/
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+SkinData"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if HaveSkinData then (
					/*<ERRHANDLERSTART>*/try (
					local	DependencyLoopTest = Refs.DependencyLoopTest,
							SkinMod = (
								try
									Obj.Skin
								catch ()
							)
					if No SkinMod then
						throw "No Skin Modifier Found"

					/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+Bones"/*<>*/
				
					EGIMS_SelectModifier SkinMod
					local	AllSkinBoneCount = 0,
							AllSkinBones = #()
					AllSkinBones.Count = Objects.Count
					for gObj in Objects where (DependencyLoopTest SkinMod gObj) do (
						AllSkinBoneCount += 1
						AllSkinBones[AllSkinBoneCount] = gObj
					)
					AllSkinBones.Count = AllSkinBoneCount
					ArrayOps.NEWQuickSort AllSkinBones PropertyName:#Name
					local	GetVertexWeightCount = SkinOps.GetVertexWeightCount,
							GetVertexWeight = SkinOps.GetVertexWeight,
							GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
							GetBoneName = (
								try
									SkinOps.GetBoneNameByListID
								catch
									SkinOps.GetBoneName
							),
							SkinVertBoneIDs = #(),
							SkinVertWeights = #(),
							Rules = GIMS.CurrentGame.Rules,
							SkinMaxBoneCount = (TryGetProperty Rules #SkinMaxBoneCount),
							HaveSkinMaxBoneCount = (SkinMaxBoneCount != #GetPropertyFailed),
							SkinVertBoneCount = (TryGetProperty Rules #SkinVertBoneCount),
							HaveSkinVertBoneCount = (SkinVertBoneCount != #GetPropertyFailed),
							NeedUsedBoneIndices = (HaveSkinMaxBoneCount or HaveSkinVertBoneCount),
							DefaultBoneIndex = unsupplied,
 							UsedBoneIndices
					UpdateProgress #None 0

					/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+Weights"/*<>*/
				
					--create skinning data
					
					for VertID = obj.NumVerts to 1 by -1 do (
						local	WeightCount = (GetVertexWeightCount SkinMod VertID),
								SkinBones = #(),
								SkinWeights = #()
						SkinBones.Count = WeightCount
						SkinWeights.Count = WeightCount
						SkinVertBoneIDs[VertID] = SkinBones
						SkinVertWeights[VertID] = SkinWeights
					)
					
					--collect skinning data
					
					if NeedUsedBoneIndices then (

						/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+NeedUsedBoneIndices"/*<>*/
				
						/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+SkinData+NeedUsedBoneIndices"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						UsedBoneIndices = #{}
						UsedBoneIndices.Count = AllSkinBoneCount
						--Print #AllSkinBones	--<TO DO> remove, debug
						--Print AllSkinBones	--<TO DO> remove, debug
						for VertID = NumVerts to 1 by -1 do (
							local	SkinBones = SkinVertBoneIDs[VertID],
									SkinWeights = SkinVertWeights[VertID],
									WeightCount = SkinWeights.Count,
									StoredWeightCount = 0
							for WeightID = 1 to WeightCount do (
								local	Weight = (GetVertexWeight SkinMod VertID WeightID),
										IsWeightValid = (Weight > 0.0001)
								if IsWeightValid then (
									local	BoneID = (GetVertexWeightBoneID SkinMod VertID WeightID),
											BoneName = (GetBoneName SkinMod BoneID 0)
									if No BoneName then
										throw "Can't find the bone name in skin referenced bone ID: " BoneID
									local	FoundID = (QuickSearch AllSkinBones BoneName PropertyName:#Name)
									--Format "Searched for \"%\", found %\n" BoneName FoundID	--<TO DO> remove, debug
									if FoundID == 0 then
										throw "Can't find the bone in skin referenced bones: " BoneName
									local	tBone = AllSkinBones[FoundID],
											BoneIndex = (TryGetProperty tBone #Index Failsafe:1)
									if StoredWeightCount < SkinVertBoneCount then
										UsedBoneIndices[BoneIndex] = true
									if not Supplied DefaultBoneIndex then
										DefaultBoneIndex = BoneIndex
									StoredWeightCount += 1
									SkinBones[StoredWeightCount] = BoneIndex
									SkinWeights[StoredWeightCount] = Weight
								)
							)
							SkinBones.Count = StoredWeightCount
							SkinWeights.Count = StoredWeightCount
						)
						--Format "% UsedBoneIndices:\t%\n" UsedBoneIndices.NumberSet UsedBoneIndices	--<TO DO> remove, debug
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					) else (	--not NeedUsedBoneIndices

						/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+not NeedUsedBoneIndices"/*<>*/
				
						/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+SkinData+NotNeedUsedBoneIndices"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						--Print #AllSkinBones	--<TO DO> remove, debug
						--Print AllSkinBones	--<TO DO> remove, debug
						for VertID = NumVerts to 1 by -1 do (
							local	SkinBones = SkinVertBoneIDs[VertID],
									SkinWeights = SkinVertWeights[VertID],
									WeightCount = SkinWeights.Count,
									StoredWeightCount = 0
							for WeightID = 1 to WeightCount do (
								local	Weight = (GetVertexWeight SkinMod VertID WeightID),
										IsWeightValid = (Weight > 0.0001)
								if IsWeightValid then (
									local	BoneID = (GetVertexWeightBoneID SkinMod VertID WeightID),
											BoneName = (GetBoneName SkinMod BoneID 0)
									if No BoneName then
										throw "Can't find the bone name in skin referenced bone ID: " BoneID
									local	FoundID = (QuickSearch AllSkinBones BoneName PropertyName:#Name)
									--Format "Searched for \"%\", found %\n" BoneName FoundID	--<TO DO> remove, debug
									if FoundID == 0 then
										throw "Can't find the bone in skin referenced bones: " BoneName
									local	tBone = AllSkinBones[FoundID],
											BoneIndex = (TryGetProperty tBone #Index Failsafe:1)
									if not Supplied DefaultBoneIndex then
										DefaultBoneIndex = BoneIndex
									StoredWeightCount += 1
									SkinBones[StoredWeightCount] = BoneIndex
									SkinWeights[StoredWeightCount] = Weight
								)
							)
							SkinBones.Count = StoredWeightCount
							SkinWeights.Count = StoredWeightCount
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					)
							
					/*<TO DO remove, debug>*
					LogProfiler #PlainInfo "\t\t\tSkinVertBoneIDs" AddParam:SkinVertBoneIDs 
					LogProfiler #PlainInfo "\t\t\tSkinVertWeights" AddParam:SkinVertWeights 
					/*<>*/
					
					--fix vertex bone counts
					
					if HaveSkinVertBoneCount then (

						/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t+HaveSkinVertBoneCount"/*<>*/
				
						/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+SkinData+HaveSkinVertBoneCount"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
						if not Supplied DefaultBoneIndex then
							DefaultBoneIndex = 1
						local	NormalizeA = ArrayOps.NormalizeA
						for VertID = 1 to NumVerts do (
							local	SkinBones = SkinVertBoneIDs[VertID],
									BoneCount = SkinBones.Count
							if BoneCount != SkinVertBoneCount then (
								local	SkinWeights = SkinVertWeights[VertID]
								if BoneCount > SkinVertBoneCount then (
									local	TempMHL = #(SkinBones, SkinWeights)
									QuickSort TempMHL MHL:true Descending:true
									Free TempMHL
									SkinBones.Count = SkinVertBoneCount
									SkinWeights.Count = SkinVertBoneCount
									NormalizeA SkinWeights
								) else (
									local	FixBoneIndex = unsupplied,
											NoFixBoneIndex = true,
											StartIndex = (BoneCount + 1),
											EndIndex = unsupplied
									if BoneCount < SkinVertBoneCount then (
										if BoneCount == 0 then (
											EndIndex = SkinVertBoneCount
											StartIndex = 2
											for UsedBoneIndex in UsedBoneIndices where UsedBoneIndex != DefaultBoneIndex while NoFixBoneIndex do (
												FixBoneIndex = UsedBoneIndex
												NoFixBoneIndex = false
											)
											SkinBones[1] = DefaultBoneIndex
											SkinWeights[1] = 1
										) else (	--BoneCount != 0
											EndIndex = SkinVertBoneCount
											local	SkinBonesBA = (SkinBones as BitArray)
											for UsedBoneIndex in UsedBoneIndices where not SkinBonesBA[UsedBoneIndex] while NoFixBoneIndex do (
												FixBoneIndex = UsedBoneIndex
												NoFixBoneIndex = false
											)
											Free SkinBonesBA
										)
									)
									if NoFixBoneIndex then
										FixBoneIndex = DefaultBoneIndex
									for i = EndIndex to StartIndex by -1 do (
										SkinBones[i] = FixBoneIndex
										SkinWeights[i] = 0
									)
								)
							)
						)
						/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					)
					
					--check bone count limit
					
					if HaveSkinMaxBoneCount then (
						local	SkinBoneCount = UsedBoneIndices.NumberSet
						if SkinBoneCount > SkinMaxBoneCount then (
							AddResult #Error (
								FormatText \
									v1:"Skinned mesh " \
									v2:(GetPathString Obj) \
									v3:" has got too many skinned bones: " \
									v4:SkinBoneCount \
									v5:", when the maximum's " \
									v6:SkinMaxBoneCount \
									v7:".\nThis mesh will be skipped."
							)
							Result = false
						)
					)
							
					/*<TO DO remove, debug>*
					LogProfiler #PlainInfo "\t\t\tSkinVertBoneIDs" AddParam:SkinVertBoneIDs 
					LogProfiler #PlainInfo "\t\t\tSkinVertWeights" AddParam:SkinVertWeights 
					/*<>*/
										
					--cleanup
					
					Free AllSkinBones
					if NeedUsedBoneIndices then
						Free UsedBoneIndices
						
					--store skin data
					
					SkinData[1] = SkinVertBoneIDs
					SkinData[2] = SkinVertWeights
							
					/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t\t\tSkinData" AddParam:SkinData/*<>*/
					
					/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				)
				UpdateProgress #None 0
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				if NeedInteractiveUI then (
					MAX Create Mode
					Select OldSelection
				)

				/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+Vertex color and map channels"/*<>*/
				
				/*get vert colors with alphas and map channels data*/
				local	MapsToCollect = #(),
						MapVertCounts = #()
				/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
				if
					Result and
					NeedMapData
				then (
					local	FGetMapVert = OpProvider.GetMapVert,
							FGetMapFace = OpProvider.GetMapFace,
							FSetMapVert = OpProvider.SetMapVert,
							FGetNumMapVerts = OpProvider.GetNumMapVerts,
							FGetNumMapFaces = OpProvider.GetNumMapFaces,
							FGetMapSupport = OpProvider.GetMapSupport,
							FGetNumMaps = OpProvider.GetNumMaps
					if
						UVCount == 0 and
						HaveTangents
					then
						UVCount = 1
					local	AlphaVertMapID = (UVCount + 1),
							ColorVertMapID = (UVCount + 2),
							Color2VertMapID = (UVCount + 3)
					if HaveColors then (
						MapsToCollect[AlphaVertMapID] = -2
						MapsToCollect[ColorVertMapID] = 0
					)
					if HaveColors2 then (
						MapsToCollect[AlphaVertMapID] = -2
						MapsToCollect[Color2VertMapID] = -1
					)
					for i = UVCount to 1 by -1 do
						MapsToCollect[i] = i

					/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+InitMaps"; local PWS = (*//*<PROFILERSTARTED>*/

					/*activate maps and get vert counts*/
					local	MapChannelPresence = #{},
							MapChannelCount = MapsToCollect.Count,
							FBuildMapFaces = OpProvider.BuildMapFaces
					if IsEPoly then (
						local	FSetNumMapFaces = OpProvider.SetNumMapFaces
						for i = MapChannelCount to 1 by -1 do (
							local	MapID = MapsToCollect[i],
									HaveChannel = (FGetMapSupport Obj MapID)
							MapChannelPresence[i] = HaveChannel
							local	MapVertCount = NumVerts
							if HaveChannel then (
								FBuildMapFaces Obj MapID Keep:true
								local	MapFaceCount = (FGetNumMapFaces Obj MapID)
								if MapFaceCount != NumFaces then (
									AddResult #Error (
										FormatText \
											v1:"Mesh " \
											v2:(GetPathString Obj) \
											v3:" Map Channel " \
											v4:MapID \
											v5:" face count of " \
											v6:MapFaceCount \
											v7:" isn't equal to the physical face count of " \
											v8:NumFaces \
											v9:".\nThis will be fixed automatically, but can cause some incorrect results."
									)
									FSetNumMapFaces Obj MapID NumFaces Keep:true
									MapFaceCount = (FGetNumMapFaces Obj MapID)
									if MapFaceCount != NumFaces then (
										AddResult #Error (
											FormatText \
												v1:"Can't fix mesh " \
												v2:(GetPathString Obj) \
												v3:" Map Channel " \
												v4:MapID \
												v5:" face count.\nThis mesh will be skipped." \
										)
										Result = false
									)
								)
								MapVertCount = (FGetNumMapVerts Obj MapID)
							)
							/*TO DO remove, debug*
							Format "Map % Presence % VertCount %\n" i HaveChannel MapVertCount
							/**/
							MapVertCounts[i] = MapVertCount
						)
					) else (	--not IsEPoly
						for i = MapChannelCount to 1 by -1 do (
							local	MapID = MapsToCollect[i],
									HaveChannel = (FGetMapSupport Obj MapID)
							MapChannelPresence[i] = HaveChannel
							local	MapVertCount = NumVerts
							if HaveChannel then (
								FBuildMapFaces Obj MapID Keep:true
								local	MapFaceCount = (FGetNumMapFaces Obj MapID)
								if MapFaceCount != NumFaces then (
									AddResult #Error (
										FormatText \
											v1:"Mesh " \
											v2:(GetPathString Obj) \
											v3:" Map Channel " \
											v4:MapID \
											v5:" face count of " \
											v6:MapFaceCount \
											v7:" isn't equal to the physical face count of " \
											v8:NumFaces \
											v9:".\nThis will be fixed automatically, but can cause some incorrect results."
									)
									MapFaceCount = (FGetNumMapFaces Obj MapID)
									if MapFaceCount != NumFaces then (
										AddResult #Error (
											FormatText \
												v1:"Can't fix mesh " \
												v2:(GetPathString Obj) \
												v3:" Map Channel " \
												v4:MapID \
												v5:" face count.\nThis mesh will be skipped." \
										)
										Result = false
									)
								)
								MapVertCount = (FGetNumMapVerts Obj MapID)
							)
							/*TO DO remove, debug*
							Format "Map % Presence % VertCount %\n" i HaveChannel MapVertCount
							/**/
							MapVertCounts[i] = MapVertCount
						)
					)
					UpdateProgress #None 0

					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+Collect"; local PWS = (*//*<PROFILERSTARTED>*/
			
					if Result then (
						local	HaveAlphaChannel = MapChannelPresence[AlphaVertMapID],
								HaveColorChannel = MapChannelPresence[ColorVertMapID],
								HaveColor2Channel = MapChannelPresence[Color2VertMapID],
								AlphaChannelID = MapsToCollect[AlphaVertMapID],
								ColorChannelID = MapsToCollect[ColorVertMapID],
								Color2ChannelID = MapsToCollect[Color2VertMapID],
								AlphaVertsCount = MapVertCounts[AlphaVertMapID],
								ColorVertsCount = MapVertCounts[ColorVertMapID],
								Color2VertsCount = MapVertCounts[Color2VertMapID]
										
						/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+Collect+Colors"; local PWS = (*//*<PROFILERSTARTED>*/

						/*get color with alpha*/
						if HaveColors then (
							/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+HaveColors"/*<>*/
							local	ColorFaces = #(),
									ColorVerts = #(),
									CPVCount = (
										if ColorVertsCount >= AlphaVertsCount then
											ColorVertsCount
										else
											AlphaVertsCount
									)
							if NumVerts >= CPVCount then
								CPVCount = NumVerts
							for i = CPVCount to 1 by -1 do
								ColorVerts[i] = [1, 1, 1, 1]
							if
								HaveColorChannel and
								HaveAlphaChannel
							then (
								for FaceID = NumFaces to 1 by -1 do (
									local	ColorMapFace = (FGetMapFace Obj ColorChannelID FaceID),
											AlphaMapFace = (FGetMapFace Obj AlphaChannelID FaceID)
									for SubVertID = 1 to 3 do (
										local	MapVertID = ColorMapFace[SubVertID],
												VertColor = (FGetMapVert Obj ColorChannelID MapVertID),
												ColorVert = ColorVerts[MapVertID],
												VColor,
												AlphaMapVertID = AlphaMapFace[SubVertID],
												VAlpha = (FGetMapVert Obj AlphaChannelID AlphaMapVertID)[1]
										if ColorVert == undefined then
											throw ("No Color vert " + (MapVertID as String) + " / " + (CPVCount as String))
										for i = 1 to 3 where (IsFinite (VColor = VertColor[i])) do
											ColorVert[i] = VColor
										if IsFinite VAlpha then
											ColorVert[4] = VAlpha
									)
									ColorFaces[FaceID] = ColorMapFace
								)
							) else (
								if HaveColorChannel then (
									for FaceID = NumFaces to 1 by -1 do (
										local	ColorMapFace = (FGetMapFace Obj ColorChannelID FaceID)
										for SubVertID = 1 to 3 do (
											local	MapVertID = ColorMapFace[SubVertID],
													VertColor = (FGetMapVert Obj ColorChannelID MapVertID),
													ColorVert = ColorVerts[MapVertID],
													VColor
											if ColorVert == undefined then
												throw ("No Color vert " + (MapVertID as String) + " / " + (CPVCount as String))
											for i = 1 to 3 where (IsFinite (VColor = VertColor[i])) do
												ColorVert[i] = VColor
										)
										ColorFaces[FaceID] = ColorMapFace
									)
								) else (
									if HaveAlphaChannel then (
										for FaceID = NumFaces to 1 by -1 do (
											local	AlphaMapFace = (FGetMapFace Obj AlphaChannelID FaceID)
											for SubVertID = 1 to 3 do (
												local	MapVertID = AlphaMapFace[SubVertID],
														VAlpha = (FGetMapVert Obj AlphaChannelID MapVertID)[1],
														ColorVert = ColorVerts[MapVertID]
												if ColorVert == undefined then
													throw ("No Color alpha vert " + (MapVertID as String) + " / " + (CPVCount as String))
												if IsFinite VAlpha then
													ColorVert[4] = VAlpha
											)
											ColorFaces[FaceID] = AlphaMapFace
										)
									) else
										ColorFaces = Faces
								)
							)
							Colors[1] = ColorFaces
							Colors[2] = ColorVerts
						)
						
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+Collect+Colors2"; local PWS = (*//*<PROFILERSTARTED>*/

						/*get color2*/
						if HaveColors2 then (
							/*<TO DO remove, debug>*LogProfiler #PlainInfo "\t+HaveColors2"/*<>*/
							local	ColorFaces = #(),
									ColorVerts = #(),
									CPVCount = (
										if Color2VertsCount >= AlphaVertsCount then
											Color2VertsCount
										else
											AlphaVertsCount
									)
							if NumVerts >= CPVCount then
								CPVCount = NumVerts
							for i = CPVCount to 1 by -1 do
								ColorVerts[i] = [1, 1, 1, 1]
							if
								HaveColor2Channel and
								HaveAlphaChannel
							then (
								for FaceID = NumFaces to 1 by -1 do (
									local	Color2MapFace = (FGetMapFace Obj Color2ChannelID FaceID),
											AlphaMapFace = (FGetMapFace Obj AlphaChannelID FaceID)
									for SubVertID = 1 to 3 do (
										local	MapVertID = Color2MapFace[SubVertID],
												VertColor2 = (FGetMapVert Obj Color2ChannelID MapVertID),
												Color2Vert = ColorVerts[MapVertID],
												VColor2,
												AlphaMapVertID = AlphaMapFace[SubVertID],
												VAlpha = (FGetMapVert Obj AlphaChannelID AlphaMapVertID)[2]
										if Color2Vert == undefined then
											throw ("No Color2 vert " + (MapVertID as String) + " / " + (CPVCount as String))
										for i = 1 to 3 where (IsFinite (VColor2 = VertColor2[i])) do
											Color2Vert[i] = VColor2
										if IsFinite VAlpha then
											Color2Vert[4] = VAlpha
									)
									ColorFaces[FaceID] = Color2MapFace
								)
							) else (
								if HaveColor2Channel then (
									for FaceID = NumFaces to 1 by -1 do (
										local	Color2MapFace = (FGetMapFace Obj Color2ChannelID FaceID)
										for SubVertID = 1 to 3 do (
											local	MapVertID = Color2MapFace[SubVertID],
													VertColor2 = (FGetMapVert Obj Color2ChannelID MapVertID),
													Color2Vert = ColorVerts[MapVertID],
													VColor2
											if Color2Vert == undefined then
												throw ("No Color2 vert " + (MapVertID as String) + " / " + (CPVCount as String))
											for i = 1 to 3 where (IsFinite (VColor2 = VertColor2[i])) do
												Color2Vert[i] = VColor2
										)
										ColorFaces[FaceID] = Color2MapFace
									)
								) else (
									if HaveAlphaChannel then (
										for FaceID = NumFaces to 1 by -1 do (
											local	AlphaMapFace = (FGetMapFace Obj AlphaChannelID FaceID)
											for SubVertID = 1 to 3 do (
												local	MapVertID = AlphaMapFace[SubVertID],
														VAlpha = (FGetMapVert Obj AlphaChannelID MapVertID)[2],
														Color2Vert = ColorVerts[MapVertID]
												if Color2Vert == undefined then
													throw ("No Color2 alpha vert " + (MapVertID as String) + " / " + (CPVCount as String))
												if IsFinite VAlpha then
													Color2Vert[4] = VAlpha
											)
											ColorFaces[FaceID] = AlphaMapFace
										)
									) else
										ColorFaces = Faces
								)
							)
							Colors2[1] = ColorFaces
							Colors2[2] = ColorVerts
						)
						
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/

						/*get map channels data*/
						local	HaveUVData = (Supplied UVData),
								MapFaceGroups, MapVertGroups
						if
							HaveUVData or
							HaveTangents
						then (
						
							/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+Collect+UV"; local PWS = (*//*<PROFILERSTARTED>*/
							
							MapFaceGroups = #()
							MapVertGroups = #()
							for MapID = UVCount to 1 by -1 do (
								local	MapVertGroup = #(),
										MapFaceGroup,
										MapVertCount = MapVertCounts[MapID]
								if MapChannelPresence[MapID] then (
									for VertID = MapVertCount to 1 by -1 do (
										local	MapVert = (FGetMapVert Obj MapID VertID)
										for i = 1 to 3 do (
											if not (IsFinite MapVert[i]) then
												MapVert[i] = 0
										)
										MapVertGroup[VertID] = MapVert
									)
									MapFaceGroup = #()
									for FaceID = NumFaces to 1 by -1 do
										MapFaceGroup[FaceID] = (FGetMapFace Obj MapID FaceID)
								) else (
									for VertID = MapVertCount to 1 by -1 do
										MapVertGroup[VertID] = [1, 1, 1, 1]
									MapFaceGroup = Faces
								)
								MapFaceGroups[MapID] = MapFaceGroup
								MapVertGroups[MapID] = MapVertGroup
							)
							if HaveUVData then (
								UVData[1] = MapFaceGroups
								UVData[2] = MapVertGroups
							)
							
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
							/*<PROFILERSTART>*//*LogProfiler #Start "ObjectMgr.DumpMesh+MapData+Collect+Tangents"; local PWS = (*//*<PROFILERSTARTED>*/

							/*get tangents*/
							if HaveTangents then (
								if IsEPoly then
									throw "Can't collect tangents from an Editable Poly" 
								local	MapFaces = MapFaceGroups[1],
										MapVerts = MapVertGroups[1],
										NumTangents = MapVerts.Count,
										tan1 = #(),
										tan2 = #(),
										TangentFaces = MapFaces,
										TangentInfos = #()
								TangentInfos.Count = NumTangents
								
								--prepare data
								for i = NumTangents to 1 by -1 do (
									tan1[i] = [0, 0, 0]
									tan2[i] = [0, 0, 0]
								)
								
								--build UV vectors
								for i = 1 to NumFaces do (
									local	Face = Faces[i],
											MapFace = MapFaces[i],
									
											i1 = Face[1],
											i2 = Face[2],
											i3 = Face[3],
											
											ti1 = MapFace[1],
											ti2 = MapFace[2],
											ti3 = MapFace[3],
									
											v1 = Verts[i1],
											v2 = Verts[i2],
											v3 = Verts[i3],
											
											w1 = MapVerts[ti1],
											w2 = MapVerts[ti2],
											w3 = MapVerts[ti3],
									
											x1 = v2.x - v1.x,
											x2 = v3.x - v1.x,
											y1 = v2.y - v1.y,
											y2 = v3.y - v1.y,
											z1 = v2.z - v1.z,
											z2 = v3.z - v1.z,
											
											s1 = w2.x - w1.x,
											s2 = w3.x - w1.x,
											t1 = w2.y - w1.y,
											t2 = w3.y - w1.y,
									
											r = 1.0 / (s1 * t2 - s2 * t1),
											sdir = [(t2 * x1 - t1 * x2) * r, (t2 * y1 - t1 * y2) * r, (t2 * z1 - t1 * z2) * r],
											tdir = [(s1 * x2 - s2 * x1) * r, (s1 * y2 - s2 * y1) * r, (s1 * z2 - s2 * z1) * r]
									
									tan1[ti1] += sdir
									tan1[ti2] += sdir
									tan1[ti3] += sdir
									
									tan2[ti1] += tdir
									tan2[ti2] += tdir
									tan2[ti3] += tdir
								)
								
								--build tangents
								if HaveNormalsCoordsysTM then (
									for i = 1 to NumFaces do (
										local	MapFace = MapFaces[i],
												NormalFace = NormalFaces[i]
										for vi = 1 to 3 do (
											local	ti = (MapFace[vi] as Integer),
													TangentInfo = TangentInfos[ti]
											if No TangentInfo then (
												local	ni = NormalFace[vi],
														n1 = NormalVectors[ni],
														t1 = tan1[ti],
														Tangent = ((Normalize (t1 - (n1 * (Dot n1 t1)))) * NormalsCoordsysTM),
														TangentW = (
															if (Dot (Cross n1 t1) tan2[ti]) < 0 then
																-1
															else
																1
														)
												TangentInfos[ti] = [Tangent.x, Tangent.y, Tangent.z, TangentW]
											)
										)
									)
								) else (
									for i = 1 to NumFaces do (
										local	MapFace = MapFaces[i],
												NormalFace = NormalFaces[i]
										for vi = 1 to 3 do (
											local	ti = (MapFace[vi] as Integer),
													TangentInfo = TangentInfos[ti]
											if No TangentInfo then (
												local	ni = NormalFace[vi],
														n1 = NormalVectors[ni],
														t1 = tan1[ti],
														Tangent = (Normalize (t1 - (n1 * (Dot n1 t1)))),
														TangentW = (
															if (Dot (Cross n1 t1) tan2[ti]) < 0 then
																-1
															else
																1
														)
												TangentInfos[ti] = [Tangent.x, Tangent.y, Tangent.z, TangentW]
											)
										)
									)
								)
								
								--store tangents
								Tangents[2] = TangentInfos
								Tangents[1] = TangentFaces
								
								--cleanup
								Free tan1
								Free tan2
							)
							
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
							
						)
					)
					UpdateProgress #None 0
					
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					
				)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
					#(
						#MapsToCollect,
						#MapVertCounts
					), #(
						MapsToCollect,
						MapVertCounts
					)
				))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				if not NeedNormals then (
					Free NormalFaces
					Free NormalVectors
				)
				Delete Obj
				EGIMS_GAReportTiming "ObjectMgr" "DumpMesh" "Function" (((GetTimeStamp()) - GATimeStart) / EGIMS_DNTicksPerMillisecond)
				Result
			/*<ERRHANDLER>*/) catch (
				try (Delete Obj) catch ()
				local	CET = (GetCurrentException()),
						ESS
				if not (MatchPattern CET Pattern:"*<THROW>*") then (
					ESS = (StringStream "")
					Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS
				)
				EGIMS_EHError CET ESS AddInfo:#(
					#(
						#SrcObj,
						#Verts,
						#Faces,
						#Siblings,
						#FaceGroups,
						#Normals,
						#Tangents,
						#Colors,
						#Colors2,
						#FaceMatIDs,
						#Materials,
						#MatPropMapping,
						#UVCount,
						#UVData,
						#SkinData,
						#NormalsCoordsysTM,
						#CoordsysTM
					), #(
						SrcObj,
						Verts,
						Faces,
						Siblings,
						FaceGroups,
						Normals,
						Tangents,
						Colors,
						Colors2,
						FaceMatIDs,
						Materials,
						MatPropMapping,
						UVCount,
						UVData,
						SkinData,
						NormalsCoordsysTM,
						CoordsysTM
					)
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateIfUnique ObjName ParentNode:RootNode NodeType:unsupplied FindOnly:false AllowSearch:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result
				if not Supplied NodeType then
					NodeType = GIMS.Core.TypeLibrary.DefaultNode
				if AllowSearch then (
					for TempChild in ParentNode.Children while No Result where
						(ClassOf TempChild.BaseObject) == NodeType and
						(StriCmp TempChild.Name ObjName) == 0
					do
						Result = TempChild
				)
				if
					not FindOnly and
					No Result
				then (
					in ParentNode
						Result = (NodeType Name:ObjName)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetPathString Obj Shorten:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start "GetPathString"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Obj == RootNode then
					"*SCENE ROOT*"
				else (
					local	tSS = (StringStream ""),
							HTree = #()
					GetAncestor Obj HTree:HTree
					local	HTreeSize = HTree.Count
					if
						Shorten and
						HTreeSize > 3
					then (
						Format "%/%/../%" HTree[1].Name HTree[2].Name HTree[HTreeSize].Name To:tSS
					) else (
						Format "%" HTree[1].Name To:tSS
						for i = 2 to HTreeSize do
							Format "/%" HTree[i].Name To:tSS
					)
					Free HTree
					local	Result = (tSS as String)
					Free tSS
					Result
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalculateBounds Obj CoordsysTM:unsupplied MatID:0 CheckChildrenOnly:false CheckChildrenRecursive:true GetAABBOnly:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local AABB
				if CheckChildrenOnly then (
					AABB = (GIMS.Core.TypeLibrary.AABB())
					for Child in Obj.Children do
						ExtendBound AABB (CalculateBounds Child CoordsysTM:CoordsysTM MatID:MatID CheckChildren:CheckChildrenRecursive GetAABBOnly:true)
				) else (
					if (SuperClassOf Obj) == StructDef then
						Obj = Obj.Obj
					if not Supplied CoordsysTM then
						CoordsysTM = (Matrix3 1)
					if MatID == 0 then (
						AABB = (NodeGetBoundingBox Obj (Inverse CoordsysTM))
						AABB = (GIMS.Core.TypeLibrary.AABB bMin:AABB[1] bMax:AABB[2])
					) else (
						AABB = (GIMS.Core.TypeLibrary.AABB())
						local	ObjMesh = Obj.Mesh,
								FaceVerts
						for FaceID = 1 to ObjMesh.NumFaces where (GetFaceMatID ObjMesh FaceID) == MatID do (
							FaceVerts = (GetFace ObjMesh FaceID)
							for VertID = 1 to 3 do
								ExtendBound AABB ((GetVert ObjMesh FaceVerts[VertID]) * CoordsysTM)
						)
					)
				)
				if GetAABBOnly then
					AABB
				else (
					local	AABBMin = AABB.bMin,
							AABBMax = AABB.bMax,
							Centroid = (AABBMin + ((AABBMax - AABBMin) / 2)),
							Radius = ((Distance AABBMin AABBMax) / 2),
							wMin = [AABBMin.x, AABBMin.y, 0],
							wMax = [AABBMax.x, AABBMax.y, 0],
							WorldRadius = ((Distance wMin wMax) / 2)
					#(AABB, Centroid, Radius, WorldRadius)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CalculateVolumeAndCenterOfMass Obj CoordsysTM:unsupplied CMOnly:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Volume = 0.0,
						CenterOfMass = [0.0, 0.0, 0.0],
						TheMesh = (SnapshotAsMesh Obj),
						NumFaces = TheMesh.NumFaces
				if not Supplied CoordsysTM then
					CoordsysTM = (Matrix3 1)
				if NumFaces != 0 then (
					for i = 1 to NumFaces do (
						local	Face = (GetFace TheMesh i),
								vert2 = ((GetVert TheMesh Face.z) * CoordsysTM),
								vert1 = ((GetVert TheMesh Face.y) * CoordsysTM),
								vert0 = ((GetVert TheMesh Face.x) * CoordsysTM),
								dV = (Dot (Cross (vert1 - vert0) (vert2 - vert0)) vert0)
						Volume += dV
						CenterOfMass += (vert0 + vert1 + vert2) * dV
					)
					Volume /= 6
					CenterOfMass /= 24
					CenterOfMass /= Volume
					if not (Bit.IsFinite CenterOfMass.x) then
						CenterOfMass = (Obj.Center * CoordsysTM)
				)
				Delete TheMesh
				if CMOnly then
					CenterOfMass
				else
					#(Volume, CenterOfMass)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Obj), #(Obj)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.Core.ArrayMap*/ ArrayMapstr (	/*<TODO>	test	Merge_OrderedDescending*/
		Sorted = true,
		OrderedDescending = false,
		_DefaultComparator = unsupplied,
		CurrentComparator = _DefaultComparator,
		Size = 0,
		ChannelCount = 1,
		Keys = #(),
		Order = #(),
		Channels = #(
			#()
		),
		
		_SH_ArrayOps = GIMS.Core.ArrayOps,
		_SH_ValueOps = GIMS.Core.ValueOps,
		_SH_RotateA = _SH_ArrayOps.RotateA,
		_SH_QuickSearch = _SH_ArrayOps.QuickSearch,
		_SH_QuickSort = _SH_ArrayOps.QuickSort,
		_SH_GetHash = _SH_ValueOps.GetHash,
		
		fn _AdditionalSwapHandler i j = (
			Swap Order[i] Order[j]
			for ChannelID = 1 to ChannelCount do (
				local	Data = Channels[ChannelID]
				Swap Data[i] Data[j]
			)
		),
		fn _GetItem ID ChannelID = (
			if ChannelID == 0 then (
				local	Result = #()
				for ChannelID = ChannelCount to 1 by -1 do
					Result[ChannelID] = Channels[ChannelID][ID]
				Result
			) else
				Channels[ChannelID][ID]
		),
		fn _RemoveData ID = (
			if ID != 0 then (
				Size -= 1
				DeleteItem Keys ID
				DeleteItem Order ID
				for Data in Channels do
					DeleteItem Data ID
				true
			) else
				false
		),
		fn _AddData Key Data MultiChannel = (
			Size += 1
			Append Keys Key
			Append Order Size
			if MultiChannel then (
				for i = 1 to ChannelCount do
					Append Channels[i] Data[i]
			) else
				Append Channels[1] Data
			OK
		),
		fn _InsertData ID Key Data MultiChannel = (
			if ID > 0 then (
				Size += 1
				InsertItem Key Keys ID
				InsertItem Size Order ID
				if MultiChannel then (
					for i = 1 to ChannelCount do
						InsertItem Data[i] Channels[i] ID
				) else
					InsertItem Data Channels[1] ID
			)
			OK
		),
		
		fn SetComparator NewComparator = (
			CurrentComparator = NewComparator
			OK
		),
		fn GetChannel ChannelID = (
			if ChannelID == 0 then
				Channels
			else
				Channels[ChannelID]
		),
		fn SetChannelCount Val = (
			if Val == 0 then
				throw "Can't set the channel count to 0"
			if Val != ChannelCount then (
				Channels.Count = Val
				if Val > ChannelCount then (
					for i = (ChannelCount + 1) to Val do (
						local	TempChannel = #()
						TempChannel.Count = Size
						Channels[i] = TempChannel
					)
				)
				ChannelCount = Val
			)
			OK
		),
		
		fn _SelectComparator Val = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			case (ClassOf (SuperClassOf Val)) of (
				Node:
					NodeOrderComparator
				Default:	--i.e. Value
					OrderComparator
			)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn _EnsureComparatorSupplied IsDefault Val = (
			local	IsNewDefault = false
			if IsDefault then (
				if not Supplied _DefaultComparator then (
					_DefaultComparator = (_SelectComparator Val)
					IsNewDefault = true
				)
			)
			if not Supplied CurrentComparator then (
				if IsNewDefault then
					CurrentComparator = _DefaultComparator
				else
					CurrentComparator = (_SelectComparator Val)
			)
			OK
		),
		
		fn Sort = (
			_EnsureComparatorSupplied false Keys[1]
			_SH_QuickSort Keys AdditionalSwapHandler:_AdditionalSwapHandler Comparator:CurrentComparator Descending:OrderedDescending
			Sorted = true
			OK
		),
		fn UnSort = (
			Swap Keys Order
			_EnsureComparatorSupplied true Keys[1]
			_SH_QuickSort Keys AdditionalSwapHandler:_AdditionalSwapHandler Comparator:_DefaultComparator Descending:OrderedDescending
			Swap Keys Order
			Sorted = false
			OK
		),
		
		fn FindByKey Key = (
			_EnsureComparatorSupplied false Keys[1]
			if Sorted then
				_SH_QuickSearch Keys Key Comparator:CurrentComparator Descending:OrderedDescending
			else (
				if CurrentComparator == _DefaultComparator then
					FindItem Keys Key
				else (
					local	Result
					for i = 1 to Size where (CurrentComparator Keys[i] Key OrderedDescending) == 0 while No Result do
						Result = i
					Result
				)
			)
		),
		fn FindByOrder Index = (
			if Sorted then
				FindItem Order Index
			else (
				_EnsureComparatorSupplied false Order[1]
				_SH_QuickSearch Order Index Comparator:CurrentComparator Descending:OrderedDescending
			)
		),
		fn GetByKey Key ChannelID:0 = (
			local	ID = (FindByKey Key)
			if ID != 0 then
				_GetItem ID ChannelID
		),
		fn GetByOrder Index ChannelID:0 = (
			local	ID = (FindByOrder Index)
			if ID != 0 then
				_GetItem ID ChannelID
		),
		
		fn RemoveByKey Key = (
			local	ID = (FindByKey Key)
			_RemoveData ID
		),
		fn RemoveByOrder Index = (
			local	ID = (FindByOrder Index)
			_RemoveData ID
		),
		fn Add Val Key:unsupplied HashablePropertyName:unsupplied HashableItemID:unsupplied MultiChannel:false = (
			if
				MultiChannel and
				Val.Count != ChannelCount
			then
				throw "Can't add data with another channel count"
			if not Supplied Key then (
				local	HashableItem = (
							if MultiChannel then (
								if not Supplied HashableItemID then
									throw "Can't add multi - channel data without a key or hashable item id"
								else
									Val[HashableItemID]
							) else
								Val
						)
				Key = (_SH_GetHash HashableItem HashablePropertyName:HashablePropertyName)
			)
			if Sorted then (
				_EnsureComparatorSupplied false Keys[1]
				_InsertData (_SH_QuickSearch Keys Key Comparator:CurrentComparator Descending:OrderedDescending GetInsertionPoint:true) Key Val MultiChannel
			) else
				_AddData Key Val MultiChannel
			OK
		),
		fn Merge AM = (	/*<TODO>	OrderedDescending_case*/
			if AM.ChannelCount != ChannelCount then
				throw "Can't merge an ArrayMap with another channel count"
			if AM.OrderedDescending != OrderedDescending then
				throw "Can't merge an ArrayMap with another order"
			if AM.CurrentComparator != CurrentComparator then
				throw "Can't merge an ArrayMap with another comparator"
			if AM.Sorted != Sorted then
				throw "Can't merge sorted and unsorted ArrayMaps"
			_EnsureComparatorSupplied false Keys[1]
			local	AMKeys = AM.Keys,
					AMChannels = AM.Channels,
					AMKeyCount = AMKeys.Count,
					StartPos = (_SH_QuickSearch Keys AMKeys[1] Comparator:CurrentComparator Descending:OrderedDescending GetInsertionPoint:true),
					EndPos = (_SH_QuickSearch Keys AMKeys[AMKeyCount] Comparator:CurrentComparator Descending:OrderedDescending GetInsertionPoint:true),
					StartCollided = (StartPos < 0),
					EndCollided = (EndPos < 0)
			if StartCollided then
				StartPos *= -1
			if EndCollided then
				EndPos *= -1
			local	InsertToStart = (
						not StartCollided and
						EndPos == 1
					),
					InsertToEnd = (
						not EndCollided and
						StartPos > Size
					),
					CollisionDetected = (
						StartCollided or
						EndCollided or (
							not InsertToStart and
							not InsertToEnd
						)
					),
					RotateAmount = (
						if CollisionDetected then
							(Size - StartPos)
						else (
							if InsertToStart then
								AMKeyCount
							else
								0
						)
					)
			Join Keys AMKeys
			Join Order AM.Order
			for i = 1 to ChannelCount do
				Join Channels[i] AMChannels[i]
			if RotateAmount != 0 then (
				_SH_RotateA Keys Amount:RotateAmount
				_SH_RotateA Order Amount:RotateAmount
				for i = 1 to ChannelCount do
					_SH_RotateA Channels[i] Amount:RotateAmount
			)
			if CollisionDetected then (
				local	CollisionBlockStart = (StartPos + AMKeyCount),
						CollisionBlockEnd = (EndPos + AMKeyCount),
						DeleteCount = 0
				for KeyID = AMKeyCount to 1 by -1 do (
					local	CollidedID = (_SH_QuickSearch Keys AMKeys[KeyID] StartID:CollisionBlockStart EndID:CollisionBlockEnd Comparator:CurrentComparator Descending:OrderedDescending)
					if (_RemoveData CollidedID) then (
						CollisionBlockEnd -= 1
						DeleteCount += 1
					)
				)
				AMKeyCount -= DeleteCount
			)
			Size += AMKeyCount
			OK
		),
		
		fn Print = (
			Format "\nArrayMap\n"
			Format "\tSorted: %\n" Sorted
			Format "\tOrderedDescending: %\n" OrderedDescending
			Format "\tSize: %\n" Size
			Format "\tChannelCount: %\n" ChannelCount
			Format "\tKeys: %\n" Keys
			Format "\tOrder: %\n" Order
			Format "\tChannels:\n"
			for i = 1 to ChannelCount do
				Format "\t\t%\n" Channels[i]
		)
	)
	struct /*#PC*PATH	GIMS.Core.ArrayOps*/ ArrayOpsstr (
	
		/*START Quick magic for ArrayMap*/
		
		fn JoinArraysIntoResult Arrays &Result = (
			/*<PROFILERSTART>*//*LogProfiler #Start "ArrayOps.JoinArraysIntoResult"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
			
				local	TotalCount = 0
				for arr in Arrays do
					TotalCount += arr.Count
				Result.Count = TotalCount
				
				local	IndexMod = 0
				for arr in Arrays do (
					local	arrCount = arr.Count
					if arrCount != 0 then (
						for i = 1 to arrCount do
							Result[i + IndexMod] = arr[i]
						IndexMod += arrCount
					)
				)
				
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn _NEWDoQuickSort Keys AdditionalSwapHandler StartID EndID Comparator Descending PropertyName = (
			/*<ERRHANDLERSTART>*/try (
				local	tPivot = Keys[(EndID - StartID) / 2 + StartID],
						i = StartID,
						j = EndID
				if Supplied AdditionalSwapHandler then (
					if Supplied PropertyName then (
						while i <= j do (
							while 
								i <= EndID and
								(Comparator (GetProperty Keys[i] PropertyName) (GetProperty tPivot PropertyName) Descending) == -1
							do
								i += 1
							while 
								j >= StartID and
								(Comparator (GetProperty tPivot PropertyName) (GetProperty Keys[j] PropertyName) Descending) == -1
							do
								j -= 1
							if i <= j then (
								if i != j then (
									Swap Keys[i] Keys[j]
									AdditionalSwapHandler i j
								)
								i += 1
								j -= 1
							)
						)
					) else (
						while i <= j do (
							while 
								i <= EndID and
								(Comparator Keys[i] tPivot Descending) < 0							do
								i += 1
							while 
								j >= StartID and
								(Comparator tPivot Keys[j] Descending) < 0
							do
								j -= 1
							if i <= j then (
								if i != j then (
									Swap Keys[i] Keys[j]
									AdditionalSwapHandler i j
								)
								i += 1
								j -= 1
							)
						)
					)
				) else (
					if Supplied PropertyName then (
						while i <= j do (
							while 
								i <= EndID and
								(Comparator (GetProperty Keys[i] PropertyName) (GetProperty tPivot PropertyName) Descending) == -1
							do
								i += 1
							while 
								j >= StartID and
								(Comparator (GetProperty tPivot PropertyName) (GetProperty Keys[j] PropertyName) Descending) == -1
							do
								j -= 1
							if i <= j then (
								if i != j then
									Swap Keys[i] Keys[j]
								i += 1
								j -= 1
							)
						)
					) else (
						while i <= j do (
							while 
								i <= EndID and
								(Comparator Keys[i] tPivot Descending) < 0
							do
								i += 1
							while 
								j >= StartID and
								(Comparator tPivot Keys[j] Descending) < 0
							do
								j -= 1
							if i <= j then (
								if i != j then
									Swap Keys[i] Keys[j]
								i += 1
								j -= 1
							)
						)
					)
				)
				if j > StartID then
					_NEWDoQuickSort Keys AdditionalSwapHandler StartID j Comparator Descending PropertyName
				if i < EndID then
					_NEWDoQuickSort Keys AdditionalSwapHandler i EndID Comparator Descending PropertyName
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		),
		fn NEWQuickSort Keys StartID:1 EndID:unsupplied AdditionalSwapHandler:unsupplied PropertyName:unsupplied Comparator:unsupplied Descending:false DoCopy:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No Comparator then
					throw "Undefined Comparator supplied"
				else (
					if not Supplied Comparator then
						Comparator = GIMS.Core.ValueOps.OrderComparator
				)
				local	Arr = (
							if DoCopy then
								(DeepCopy Keys)
							else
								Keys
						)
				if not Supplied EndID then
					EndID = Arr.Count
				_NEWDoQuickSort Arr AdditionalSwapHandler StartID EndID Comparator Descending PropertyName
				Arr
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn QuickSearch Arr Val StartID:1 EndID:unsupplied Comparator:unsupplied PropertyName:unsupplied Descending:false GetInsertionPoint:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No Comparator then
					throw "Undefined Comparator supplied"
				else (
					if not Supplied Comparator then
						Comparator = GIMS.Core.ValueOps.OrderComparator
				)
				if not Supplied EndID then
					EndID = Arr.Count
				local	MidID = 0,
						LastComparedRes = 0,
						Result = 0
				if EndID != 0 then (
					if Supplied PropertyName then (
						while
							Result == 0 and
							StartID <= EndID
						do (
							MidID = (StartID + ((EndID - StartID) / 2))
							LastComparedRes = (Comparator Val (GetProperty Arr[MidID] PropertyName) Descending)
							case of (
								(LastComparedRes == 0):
									Result = MidID
								(LastComparedRes < 0):
									EndID = (MidID - 1)
								default:
									StartID = (MidID + 1)
							)
						)
					) else (
						while
							Result == 0 and
							StartID <= EndID
						do (
							MidID = (StartID + ((EndID - StartID) / 2))
							LastComparedRes = (Comparator Val Arr[MidID] Descending)
							case of (
								(LastComparedRes == 0):
									Result = MidID
								(LastComparedRes < 0):
									EndID = (MidID - 1)
								default:
									StartID = (MidID + 1)
							)
						)
					)
					if GetInsertionPoint then (
						case of (
							(LastComparedRes == 0):
								-MidID
							(LastComparedRes < 0):
								MidID
							default:
								MidID + 1
						)
					) else
						Result
				) else (
					if GetInsertionPoint then
						1
					else
						0
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Arr, #Val, #StartID, #EndID, #Comparator, #PropertyName, #Descending, #GetInsertionPoint), #(Arr, Val, StartID, EndID, Comparator, PropertyName, Descending, GetInsertionPoint)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		/*END Quick magic for ArrayMap*/
		
		fn _DoQuickSort Arr Keys Low High MHLItemIDs Comparator Descending = (	/*<TODO> !	delete*/
			/*<ERRHANDLERSTART>*/try (
				local	tPivot = Keys[(High - Low) / 2 + Low],
						i = Low,
						j = High
				while i <= j do (
					while 
						i <= High and
						(Comparator Keys[i] tPivot Descending) < 0
					do
						i += 1
					while 
						j >= Low and
						(Comparator tPivot Keys[j] Descending) < 0
					do
						j -= 1
					if i <= j then (
						if i != j then (
							Swap Keys[i] Keys[j]
							for ItemID in MHLItemIDs do (
								local	ItemGroup = Arr[ItemID]
								Swap ItemGroup[i] ItemGroup[j]
							)
						)
						i += 1
						j -= 1
					)
				)
				if j > Low then
					_DoQuickSort Arr Keys Low j MHLItemIDs Comparator Descending
				if i < High then
					_DoQuickSort Arr Keys i High MHLItemIDs Comparator Descending
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		),
		fn QuickSort Arr Low:1 High:undefined DoCopy:false Descending:false MHL:false Comparator:unsupplied MHLKeyItemID:2 = (	/*<TODO> !	delete*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MHLItemIDs = #{},
						ArrCount = Arr.Count,
						MHLElemCount
				if MHL then (
					MHLElemCount = Arr[1].Count
					for i = 2 to ArrCount where Arr[i].Count != MHLElemCount do
						throw "MHL element counts aren't equal"
					MHLItemIDs = #{1..ArrCount}
					MHLItemIDs[MHLKeyItemID] = false
				)
				if (
					if MHL then
						MHLElemCount != 0
					else
						ArrCount != 0
				) then (
					local	Result = (
								if DoCopy then
									(DeepCopy Arr)
								else
									Arr
							),
							Keys = (
								if MHL then
									Result[MHLKeyItemID]
								else
									Result
							)
					if No High then (
						High = (
							if MHL then
								MHLElemCount
							else
								ArrCount
						)
					)
					if Low > High then
						throw "Start ID's more than the End ID"
					if Have Comparator then (
						if not Supplied Comparator then
							Comparator = GIMS.Core.ValueOps.OrderComparator
					) else
						throw "Undefined Comparator supplied"
					_DoQuickSort Result Keys Low High MHLItemIDs Comparator Descending
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn _Modify_ModifyItems Arr ArraySize Factor Mode HavePropertyName PropertyName = (	/*<TODO> !	rename*/
			/*<PROFILERSTART>*//*LogProfiler #Start "_Modify_ModifyItems"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case Mode of (
					#Add: (
						if HavePropertyName then (
							for i = 1 to ArraySize do (
								local	Item = Arr[i]
								SetProperty Item PropertyName ((GetProperty Item PropertyName) + Factor)
							)
						) else (
							if (IsKindOf Arr[1] Array) then (
								for i = 1 to ArraySize do (
									local	Val = Arr[i]
									_Modify_ModifyItems Val Val.Count Factor Mode HavePropertyName PropertyName
								)
							) else (
								for i = 1 to ArraySize do
									Arr[i] += Factor
							)
						)
					)
					#Multiply: (
						if HavePropertyName then (
							for i = 1 to ArraySize do (
								local	Item = Arr[i]
								SetProperty Item PropertyName ((GetProperty Item PropertyName) * Factor)
							)
						) else (
							if (IsKindOf Arr[1] Array) then (
								for i = 1 to ArraySize do (
									local	Val = Arr[i]
									_Modify_ModifyItems Val Val.Count Factor Mode HavePropertyName PropertyName
								)
							) else (
								for i = 1 to ArraySize do
									Arr[i] *= Factor
							)
						)
					)
					#Divide: (
						if HavePropertyName then (
							for i = 1 to ArraySize do (
								local	Item = Arr[i]
								SetProperty Item PropertyName ((GetProperty Item PropertyName) / Factor)
							)
						) else (
							if (IsKindOf Arr[1] Array) then (
								for i = 1 to ArraySize do (
									local	Val = Arr[i]
									_Modify_ModifyItems Val Val.Count Factor Mode HavePropertyName PropertyName
								)
							) else (
								for i = 1 to ArraySize do
									Arr[i] /= Factor
							)
						)
					)
					Default:
						throw "Unknown mode: " Mode
				)
				Arr
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Modify Arr Factor Mode PropertyName:unsupplied CopyArray:true = (	/*<TODO> !	rename*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local 	Res,
						TypeCast = GIMS.Core.ValueOps.TypeCast,
						HavePropertyName = (Supplied PropertyName)
				if CopyArray then
					Res = (DeepCopy (TypeCast Arr Array))
				else
					Res = (TypeCast Arr Array)
				local	ArraySize = Res.Count
				if (IsKindOf Mode Array) then (
					local	ModeCount = Mode.Count
					if Factor.Count != ModeCount then
						throw "Factor and Mode arrays aren't mapped"
					for i = 1 to ModeCount do
						_Modify_ModifyItems Res ArraySize Factor[i] Mode[i] HavePropertyName PropertyName
				) else
					_Modify_ModifyItems Res ArraySize Factor Mode HavePropertyName PropertyName
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn Search Arr Val \
			CaseOp:undefined \
			FromWhere:1 \
			ToWhere:unsupplied \
			IgnoredID:undefined \
			ForceCompare:false \
			PropMapping:unsupplied \
			Sorted:false \
			Compare_MaxDiff:unsupplied \
			Comparator:unsupplied = \
		(	/*<TODO> !	remake when ArrayMap ready*/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DoLoopSearch = (
							ForceCompare or
							Have IgnoredID or
							Supplied PropMapping or
							Have CaseOp or
							Supplied Compare_MaxDiff
						),
						NotSuppliedToWhere = (not Supplied ToWhere),
						Res = 0
				if not DoLoopSearch then (
					if Sorted then
						Res = (QuickSearch Arr Val StartID:FromWhere EndID:ToWhere Comparator:Comparator)
					else (
						if
							FromWhere == 1 and
							NotSuppliedToWhere
						then
							Res = (FindItem Arr Val)
						else
							DoLoopSearch = true
					)
				)
				if DoLoopSearch then (
					local	Compare = GIMS.Core.ValueOps.Compare
					if NotSuppliedToWhere then
						ToWhere = Arr.Count
					for i = FromWhere to ToWhere while Res == 0 where
						i != IgnoredID and
						(Compare Arr[i] Val CaseOp:CaseOp PropMapping:PropMapping MaxDiff:Compare_MaxDiff)
					do
						Res = i
				)
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreallocatedInsertItem Val Arr PlaceID ItemCount = (	/*<TODO> 	rename**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for i = ItemCount to PlaceID by -1 do
					Arr[i + 1] = Arr[i]
				Arr[PlaceID] = Val
				PlaceID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PreallocatedMHLInsertItem ValKey Val Keys Values PlaceID ItemCount = (	/*<TODO> 	rename**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for i = ItemCount to PlaceID by -1 do (
					local	NextIndex = (i + 1)
					Keys[NextIndex] = Keys[i]
					Values[NextIndex] = Values[i]
				)
				Keys[PlaceID] = ValKey
				Values[PlaceID] = Val
				PlaceID
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AppendSorted \
			Arr Val \
			MHLItem:unsupplied \
			ValuePropertyName:unsupplied \
			Descending:false \
			OnlyIfUnique:false \
			GetID:true \
			GetFlagWithID:false \
			EndID:unsupplied \
			IsPreallocated:false \
			Comparator:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	HaveEndID = (Supplied EndID),
						MHL = (MHLItem != unsupplied),
						Numbers = (
							if MHL then
								Arr[2]
							else
								Arr
						),
						ArraySize = Numbers.Count,
						ItemCount = (if HaveEndID then EndID else ArraySize),
						SortValue = (
							if Supplied ValuePropertyName then
								(GetProperty Val ValuePropertyName)
							else
								Val
						),
						PlaceID = (QuickSearch Numbers SortValue EndID:ItemCount Descending:Descending PropertyName:ValuePropertyName GetInsertionPoint:true Comparator:Comparator),
						Added = true
				if PlaceID < 0 then (
					PlaceID = -PlaceID
					if OnlyIfUnique then
						Added = false
				)
				if Added then (
					if MHL then (
						local	ValueArr = Arr[1]
						if (
							(ItemCount < PlaceID) and
							(IsKindOf Numbers ArrayParameter) and
							(IsKindOf ValueArr ArrayParameter)
						) then (
							Numbers[PlaceID] = Val
							ValueArr[PlaceID] = MHLItem
						) else (
							if
								IsPreallocated and
								(ItemCount < ArraySize)
							then
								PreallocatedMHLInsertItem Val MHLItem Numbers ValueArr PlaceID ItemCount
							else (
								InsertItem Val Numbers PlaceID
								InsertItem MHLItem ValueArr PlaceID
							)
						)
					) else (
						if (
							(ItemCount < PlaceID) and
							(IsKindOf Numbers ArrayParameter)
						) then
							Numbers[PlaceID] = Val
						else (
							if
								IsPreallocated and
								(ItemCount < ArraySize)
							then
								PreallocatedInsertItem Val Numbers PlaceID ItemCount
							else
								InsertItem Val Numbers PlaceID
						)
					)
				)
				if
					GetID or
					GetFlagWithID
				then (
					if GetFlagWithID then
						#(Added, PlaceID)
					else
						PlaceID
				) else
					Added
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			/*TEST*
			(
				local	Tests = #(
							#(false, #(), 1, #(1)),
								
							#(false, #(1), 0, #(0, 1)),
							#(false, #(1), 1, #(1, 1)),
							#(false, #(1), 2, #(1, 2)),
								
							#(false, #(1, 3), 0, #(0, 1, 3)),
							#(false, #(1, 3), 1, #(1, 1, 3)),
							#(false, #(1, 3), 2, #(1, 2, 3)),
							#(false, #(1, 3), 3, #(1, 3, 3)),
							#(false, #(1, 3), 4, #(1, 3, 4)),
								
							#(false, #(1, 3, 5), 0, #(0, 1, 3, 5)),
							#(false, #(1, 3, 5), 1, #(1, 1, 3, 5)),
							#(false, #(1, 3, 5), 2, #(1, 2, 3, 5)),
							#(false, #(1, 3, 5), 3, #(1, 3, 3, 5)),
							#(false, #(1, 3, 5), 4, #(1, 3, 4, 5)),
							#(false, #(1, 3, 5), 5, #(1, 3, 5, 5)),
							#(false, #(1, 3, 5), 6, #(1, 3, 5, 6)),
								
							#(true, #(3, 1), 0, #(3, 1, 0)),
							#(true, #(3, 1), 1, #(3, 1, 1)),
							#(true, #(3, 1), 2, #(3, 2, 1)),
							#(true, #(3, 1), 3, #(3, 3, 1)),
							#(true, #(3, 1), 4, #(4, 3, 1)),
								
							#(true, #(5, 3, 1), 0, #(5, 3, 1, 0)),
							#(true, #(5, 3, 1), 1, #(5, 3, 1, 1)),
							#(true, #(5, 3, 1), 2, #(5, 3, 2, 1)),
							#(true, #(5, 3, 1), 3, #(5, 3, 3, 1)),
							#(true, #(5, 3, 1), 4, #(5, 4, 3, 1)),
							#(true, #(5, 3, 1), 5, #(5, 5, 3, 1)),
							#(true, #(5, 3, 1), 6, #(6, 5, 3, 1)),

							#(false, #(), "1", #("1")),
								
							#(false, #("1"), "0", #("0", "1")),
							#(false, #("1"), "1", #("1", "1")),
							#(false, #("1"), "2", #("1", "2")),
								
							#(false, #("1", "3"), "0", #("0", "1", "3")),
							#(false, #("1", "3"), "1", #("1", "1", "3")),
							#(false, #("1", "3"), "2", #("1", "2", "3")),
							#(false, #("1", "3"), "3", #("1", "3", "3")),
							#(false, #("1", "3"), "4", #("1", "3", "4")),
								
							#(false, #("1", "3", "5"), "0", #("0", "1", "3", "5")),
							#(false, #("1", "3", "5"), "1", #("1", "1", "3", "5")),
							#(false, #("1", "3", "5"), "2", #("1", "2", "3", "5")),
							#(false, #("1", "3", "5"), "3", #("1", "3", "3", "5")),
							#(false, #("1", "3", "5"), "4", #("1", "3", "4", "5")),
							#(false, #("1", "3", "5"), "5", #("1", "3", "5", "5")),
							#(false, #("1", "3", "5"), "6", #("1", "3", "5", "6")),
								
							#(true, #("3", "1"), "0", #("3", "1", "0")),
							#(true, #("3", "1"), "1", #("3", "1", "1")),
							#(true, #("3", "1"), "2", #("3", "2", "1")),
							#(true, #("3", "1"), "3", #("3", "3", "1")),
							#(true, #("3", "1"), "4", #("4", "3", "1")),
								
							#(true, #("5", "3", "1"), "0", #("5", "3", "1", "0")),
							#(true, #("5", "3", "1"), "1", #("5", "3", "1", "1")),
							#(true, #("5", "3", "1"), "2", #("5", "3", "2", "1")),
							#(true, #("5", "3", "1"), "3", #("5", "3", "3", "1")),
							#(true, #("5", "3", "1"), "4", #("5", "4", "3", "1")),
							#(true, #("5", "3", "1"), "5", #("5", "5", "3", "1")),
							#(true, #("5", "3", "1"), "6", #("6", "5", "3", "1"))
						)
				for Test in Tests do (
					local	Descending = Test[1],
							Arr = Test[2],
							Val = Test[3],
							Target = Test[4],
							Result = (GIMS.Core.ArrayOps.AppendSorted Arr Val Descending:Descending)
					if (Arr as String) != (Target as String) then
						Format "Test failed with % append of % into %: expected %, got %\n" (if Descending then "descending" else "normal") Val Arr Target Arr
				)
				#Finished
			)
			/**/
		),

		fn AppendIfUniq Arr Val \
			GetID:false GetFlagWithID:false \
			Sorted:false Descending:false ValuePropertyName:unsupplied Comparator:unsupplied \
			MHLItem:unsupplied \
			PropMapping:unsupplied \
			Search_ForceCompare:false Search_Compare_MaxDiff:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ItemID = #EItemID,
						Added = false
				if
					Sorted and
					(not Supplied PropMapping) and
					(not Search_ForceCompare) and
					(not Supplied Search_Compare_MaxDiff)
				then (
					local	AddData = (AppendSorted Arr Val MHLItem:MHLItem ValuePropertyName:ValuePropertyName Descending:Descending OnlyIfUnique:true GetFlagWithID:true Comparator:Comparator)
					Added = AddData[1]
					ItemID = AddData[2]
				) else (
					local	MHL = (MHLItem != unsupplied),
							Numbers = (
								if MHL then
									Arr[2]
								else
									Arr
							)
					ItemID = (Search Numbers Val Sorted:Sorted PropMapping:PropMapping ForceCompare:Search_ForceCompare Compare_MaxDiff:Search_Compare_MaxDiff)
					if ItemID == 0 then (
						Append Numbers Val
						if MHL then
							Append Arr[1] MHLItem
						ItemID = Numbers.Count
						Added = true
					)
				)
				if
					GetID or
					GetFlagWithID
				then (
					if GetFlagWithID then
						#(Added, ItemID)
					else
						ItemID
				) else
					Added
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn Remove Arr Val Sorted:false GetID:false = (	/*<TODO> 	rename**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local Res = (Search Arr Val Sorted:Sorted)
				if Res != 0 then
					DeleteItem Arr Res
				if GetID then
					Res
				else
					(Res != 0)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Dispose Arr = (	/*<TODO> 	rename**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if (IsKindOf Arr Array) then (
					for i = 1 to Arr.Count do (
						local	Item = Arr[i]
						if
							IsKindOf Item String or
							IsKindOf Item Array
						then
							Free Arr[i]
					)
					Free Arr
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn BitArrayAsValue BA Range:undefined BitShift:0 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Res = 0,
						BitSet = Bit.Set,
						ArraySize
				if BitShift == 0 then (
					if No Range then (
						for i in BA do
							Res = (BitSet Res i true)
					) else (
						for i in Range where BA[i] do
							Res = (BitSet Res i true)
					)
				) else (
					if No Range then (
						for i in BA do
							Res = (BitSet Res (i + BitShift) true)
					) else (
						for i in Range where BA[i] do
							Res = (BitSet Res (i + BitShift) true)
					)
				)
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn NormalizeA Arr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	sum = 0
				for Val in Arr do
					sum += Val
				if
					(sum != 0) and
					(sum != 1) and (
						(sum > 1.0001) or
						(sum < 0.9999)
					)
				then (
					local	Mult = (1.0 / sum)
					for i = 1 to Arr.Count do
						Arr[i] *= Mult
				) else
					Arr
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Arr), #(Arr)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn InvertA Arr StartID:1 EndID:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No EndID then (
					EndID = (
						case (ClassOf Arr) of (
							Array:
								Arr.Count
							Point3:
								3
							Point4:
								4
							Default:
								throw "Unknown type"
						)
					)
				)
				while StartID < EndID do (
					Swap Arr[StartID] Arr[EndID]
					StartID += 1
					EndID -= 1
				)
				Arr
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RotateA Arr Amount:1 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Amount = -Amount
				local	ArrCount = (
							case (ClassOf Arr) of (
								Array:
									Arr.Count
								Point3:
									3
								Point4:
									4
								Default:
									throw "Unknown type"
							)
						)
				while Amount < 0 do
					Amount += ArrCount
				while Amount > ArrCount do
					Amount -= ArrCount
				if
					Amount != ArrCount and
					Amount != 0
				then (
					InvertA Arr EndID:Amount
					InvertA Arr StartID:(Amount + 1)
					InvertA Arr EndID:ArrCount
				)
				Arr
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn AppendMHL TheMHL Val Sorted:true Hash:unsupplied GetID:false GetFlagWithID:false Comparator:unsupplied = (	/*<TODO> 	delete when ArrayMap ready**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/try (
				if not Supplied Hash then (
					Hash = (
						if (IsKindOf Val Array) then
							Val[2]
						else
							GIMS.Core.ValueOps.GetHash Val
					)
				)
				(AppendIfUniq TheMHL Hash Sorted:Sorted GetID:GetID GetFlagWithID:GetFlagWithID MHLItem:Val Comparator:Comparator)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FetchMHL TheMHL Hash Sorted:true Comparator:unsupplied ReturnHashOnFail:true FailHashTypeHook:#HexString &FoundID:unsupplied KeyValueItemIDs:[2, 1] = (	/*<TODO> 	delete when ArrayMap ready**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local Res = (Search TheMHL[KeyValueItemIDs.x] Hash Sorted:Sorted Comparator:Comparator)
				if Supplied FoundID then
					FoundID = Res
				if Res != 0 then
					TheMHL[KeyValueItemIDs.y][Res]
				else (
					if ReturnHashOnFail then
						(GIMS.Core.ValueOps.TypeCast Hash FailHashTypeHook)
					else
						undefined
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
				#(
					#TheMHL,
					#Hash,
					#Sorted,
					#Comparator,
					#ReturnHashOnFail,
					#FailHashTypeHook,
					#FoundID,
					#KeyValueItemIDs
				), #(
					TheMHL,
					Hash,
					Sorted,
					Comparator,
					ReturnHashOnFail,
					FailHashTypeHook,
					FoundID,
					KeyValueItemIDs
				)
			))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn MergeMHL MHLTo MHLWhat Sorted:true = (	/*<TODO> 	delete when ArrayMap ready**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if MHLWhat[1].Count != 0 then (
					local	OldHashes = MHLTo[2],
							NewHashes = MHLWhat[2],
							OldHashCount = OldHashes.Count
					if
						not Sorted or
						OldHashCount == 0 or
						NewHashes[1] >= OldHashes[OldHashCount]
					then (
						Join MHLTo[1] MHLWhat[1]
						Join MHLTo[2] NewHashes
					) else (
						local	New1 = (MHLWhat[1] + MHLTo[1]),
								New2 = (NewHashes + OldHashes)
						Free MHLTo[1]
						Free MHLTo[2]
						MHLTo[1] = New1
						MHLTo[2] = New2
					)
				)
				MHLTo
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RemoveMHL TheMHL Val Sorted:true = (	/*<TODO> 	delete when ArrayMap ready**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local Res = (Remove TheMHL[2] Val Sorted:Sorted GetID:true)
				if Res != 0 then (
					DeleteItem TheMHL[1] Res
					true
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RebuildMHL TheMHL PostSort:true HashablePropertyName:unsupplied Comparator:unsupplied = (	/*<TODO> 	delete when ArrayMap ready**/
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	GetHash = GIMS.Core.ValueOps.GetHash,
						Items = TheMHL[1],
						Hashes = TheMHL[2],
						ItemCount = Items.Count
				for i = 1 to ItemCount do
					Hashes[i] = (GetHash Items[i] HashablePropertyName:HashablePropertyName)
				if PostSort then
					QuickSort TheMHL MHL:true Comparator:Comparator
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn Split Arr Count = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ArrSize = Arr.Count
						Result
				if
					ArrSize != Count and
					(ArrSize / Count) != 0
				then (
					local	ChunkCount = (Arr.Count / Count),
							StartID, EndID,
							Result = #(),
							LastChunkID,
							HaveLastChunk = false
					if (Mod ArrSize Count) != 0 then (
						HaveLastChunk = true
						LastChunkID = (ChunkCount + 1)
					) else
						LastChunkID = ChunkCount
					Result.Count = LastChunkID
					for ChunkID = ChunkCount to 1 by -1 do (
						local	Values = #()
						StartID = (((ChunkID - 1) * Count) + 1)
						EndID = (StartID + Count - 1)
						for ValID = EndID to StartID by -1 do
							Values[ValID] = Arr[ValID]
						Result[ChunkID] = Values
					)
					if HaveLastChunk then (
						StartID = (EndID + 1)
						local	SubResult = #()
						for i = ArrSize to StartID by -1 do
							SubResult[i] = Arr[i]
						Result[LastChunkID] = SubResult
					)
				)
				if No Result then
					#(Arr)
				else
					Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetFirstUnusedIndex Arr = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsNotBA = false,
						BA
				if not (IsKindOf Arr BitArray) then (
					IsNotBA = true
					BA = (Arr as BitArray)
				) else
					BA = Arr
				local	ID = 1,
						Result
				while No Result do (
					if not BA[ID] then
						Result = ID
					ID += 1
				)
				if IsNotBA then
					Free BA
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.Core.StringOps*/ StringOpsstr (
		fn GetLastFolderName ThePath = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Items = (FilterString ThePath "/\\"),
						Result = Items[Items.Count]
				Free Items
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ToLowReg Str = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				(ToLower Str)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ToHighReg Str = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				(toUpper Str)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ValidateGTAString Str = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				/*SELF - TEST
				(
					not (ValidateGTAString undefined) and
					not (ValidateGTAString "") and
					not (ValidateGTAString "#test") and
					not (ValidateGTAString ";test") and
					not (ValidateGTAString "//test") and
					not (ValidateGTAString "    ") and
					not (ValidateGTAString "\t\t\t\t") and
					not (ValidateGTAString " \t") and
					not (ValidateGTAString "\t ") and
					(ValidateGTAString "test") and
					(ValidateGTAString "  test") and
					(ValidateGTAString "\t\ttest") and
					(ValidateGTAString "/test")
				)
				*/
				if No Str then
					false
				else (
					local	S1 = (TrimRight Str),
							TestStr = (TrimLeft S1),
							Result = (
								if TestStr.Count == 0 then
									false
								else (
									local	FirstChar = TestStr[1]
									if
										FirstChar == "#" or
										FirstChar == ";" or (
											FirstChar == "/" and
											TestStr[2] == FirstChar
										)
									then
										false
									else
										true
								)
							)
					Free S1
					Free TestStr
					Result
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetJenkinsHash TheString IgnoreCase:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start "StringOps.GetJenkinsHash"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				GIMS.Core.SystemMgr.GIMSOpsLib.GetJenkinsHash TheString IgnoreCase
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Search StrWhere StrWhat CaseOp:undefined FromWhere:1 ToWhere:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not Supplied ToWhere then
					ToWhere = StrWhere.Count
				GIMS.Core.SystemMgr.GIMSOpsLib.FindSubString StrWhere StrWhat FromWhere (ToWhere - FromWhere) (CaseOp != #Lower and CaseOp != #Upper)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReplaceChars Source ReplaceTags:#(#(" ", "\t", "."), #("_", "-", "_")) = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TagsWhat = ReplaceTags[1],
						TagsWith = ReplaceTags[2],
						TagCount = TagsWhat.Count
				if TagCount != TagsWith.Count then
					throw "Tag counts aren't equal"
				if TagCount != 0 then (
					Source = (SubstituteString Source TagsWhat[1] TagsWith[1])
					for i = 2 to TagCount do (
						local	NewS = (SubstituteString Source TagsWhat[i] TagsWith[i])
						Free Source
						Source = NewS
					)
				)
				Source
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn oFTypeExec TheValue Type IDMask:unsupplied FilterStr:" \t" BufferID:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start "oFTypeExec"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast,
						IsNewIDMask = true,
						IsNewValue = false
				if (IsKindOf TheValue String) then (
					IsNewValue = true
					TheValue = (FilterString TheValue FilterStr)
				)
				if Supplied IDMask then (
					if (IsKindOf IDMask Array) then
						IsNewIDMask = false
					else
						IDMask = (TypeCast IDMask Array)
				) else (
					local	BA = #{1..TheValue.Count}
					IDMask = (BA as Array)
					Free BA
				)
				local	Result = #oFTypeExecFailed,
						TheValueCount = TheValue.Count,
						InvalidValueID = (TheValueCount + 1),
						IDMaskCount = IDMask.Count
				if IDMaskCount < 1 then
					IDMask[1] = InvalidValueID
				case Type of (
					#String:
						Result = TheValue[IDMask[1]]
					#Float:
						Result = TypeCast TheValue[IDMask[1]] Float BufferID:BufferID
					#Double:
						Result = TypeCast TheValue[IDMask[1]] Float BufferID:BufferID
					#P2: (
						if IDMaskCount < 2 then
							IDMask[2] = InvalidValueID
						Result = [ \
							TypeCast TheValue[IDMask[1]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[2]] Float BufferID:BufferID \
						]
					)
					#P3: (
						if IDMaskCount < 3 then (
							IDMask[3] = InvalidValueID
							if IDMaskCount < 2 then
								IDMask[2] = InvalidValueID
						)
						Result = [ \
							TypeCast TheValue[IDMask[1]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[2]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[3]] Float BufferID:BufferID \
						]
					)
					#P4: (
						if IDMaskCount < 4 then (
							IDMask[4] = InvalidValueID
							if IDMaskCount < 3 then (
								IDMask[3] = InvalidValueID
								if IDMaskCount < 2 then
									IDMask[2] = InvalidValueID
							)
						)
						Result = [ \
							TypeCast TheValue[IDMask[1]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[2]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[3]] Float BufferID:BufferID, \
							TypeCast TheValue[IDMask[4]] Float BufferID:BufferID \
						]
					)
					#Euler: (
						if IDMaskCount < 3 then (
							IDMask[3] = InvalidValueID
							if IDMaskCount < 2 then
								IDMask[2] = InvalidValueID
						)
						Result = (
							EulerAngles \
								(TypeCast TheValue[IDMask[1]] Float BufferID:BufferID) \
								(TypeCast TheValue[IDMask[2]] Float BufferID:BufferID) \
								(TypeCast TheValue[IDMask[3]] Float BufferID:BufferID) \
						)
					)
					#RadEuler: (
						if IDMaskCount < 3 then (
							IDMask[3] = InvalidValueID
							if IDMaskCount < 2 then
								IDMask[2] = InvalidValueID
						)
						Result = (
							EulerAngles \
								(TypeCast (TypeCast TheValue[IDMask[1]] Float BufferID:BufferID) #RadToDeg) \
								(TypeCast (TypeCast TheValue[IDMask[2]] Float BufferID:BufferID) #RadToDeg) \
								(TypeCast (TypeCast TheValue[IDMask[3]] Float BufferID:BufferID) #RadToDeg) \
						)
					)
					#Quat: (
						if IDMaskCount < 4 then (
							IDMask[4] = InvalidValueID
							if IDMaskCount < 3 then (
								IDMask[3] = InvalidValueID
								if IDMaskCount < 2 then
									IDMask[2] = InvalidValueID
							)
						)
						Result = (
							Quat \
								(TypeCast TheValue[IDMask[1]] Float BufferID:BufferID) \
								(TypeCast TheValue[IDMask[2]] Float BufferID:BufferID) \
								(TypeCast TheValue[IDMask[3]] Float BufferID:BufferID) \
								(TypeCast TheValue[IDMask[4]] Float BufferID:BufferID) \
						)
					)
					#Color: (
						if IDMaskCount < 3 then (
							IDMask[3] = InvalidValueID
							if IDMaskCount < 2 then
								IDMask[2] = InvalidValueID
						)
						Result = (
							if IDMask.Count == 3 then (
								Color \
									(TypeCast TheValue[IDMask[1]] Integer BufferID:BufferID) \
									(TypeCast TheValue[IDMask[2]] Integer BufferID:BufferID) \
									(TypeCast TheValue[IDMask[3]] Integer BufferID:BufferID) \
							) else (
								Color \
									(TypeCast TheValue[IDMask[1]] Integer BufferID:BufferID) \
									(TypeCast TheValue[IDMask[2]] Integer BufferID:BufferID) \
									(TypeCast TheValue[IDMask[3]] Integer BufferID:BufferID) \
									(TypeCast TheValue[IDMask[4]] Integer BufferID:BufferID) \
							)
						)
					)
					#Matrix: (
						if IDMaskCount < 4 then (
							IDMask[4] = InvalidValueID
							if IDMaskCount < 3 then (
								IDMask[3] = InvalidValueID
								if IDMaskCount < 2 then
									IDMask[2] = InvalidValueID
							)
						)
						Result = (
							Matrix3 \
								(oFTypeExec TheValue[IDMask[1]] #P3) \
								(oFTypeExec TheValue[IDMask[2]] #P3) \
								(oFTypeExec TheValue[IDMask[3]] #P3) \
								(oFTypeExec TheValue[IDMask[4]] #P3) \
						)
					)
					#IntArray: (
						local	FirstID = IDMask[1]
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMask.Count to 1 by -1 do
								Result[i] = (TypeCast TheValue[IDMask[i]] Integer BufferID:BufferID)
						)
					)
					#FloatArray: (
						local	FirstID = IDMask[1]
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMask.Count to 1 by -1 do
								Result[i] = (TypeCast TheValue[IDMask[i]] Float BufferID:BufferID)
						)
					)
					#NameArray: (
						local	FirstID = IDMask[1]
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMask.Count to 1 by -1 do
								Result[i] = (TypeCast TheValue[IDMask[i]] Name BufferID:BufferID)
						)
					)
					#StringArray: (
						local	FirstID = IDMask[1]
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMask.Count to 1 by -1 do
								Result[i] = (TheValue[IDMask[i]] as String)
						)
					)
					#RadFloatArray: (
						local	FirstID = IDMask[1]
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMask.Count to 1 by -1 do
								Result[i] = (TypeCast (TypeCast TheValue[IDMask[i]] Float BufferID:BufferID) #RadToDeg)
						)
					)
					#P2Array: (
						local	FirstID = IDMask[1],
								ResID = (IDMaskCount / 2)
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMaskCount to 1 by -2 do (
								Result[ResID] = [ \
									TypeCast TheValue[IDMask[i - 1]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i]] Float BufferID:BufferID \
								]
								ResID -= 1
							)
						)
					)
					#P3Array: (
						local	FirstID = IDMask[1],
								ResID = (IDMaskCount / 3)
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMaskCount to 1 by -3 do (
								Result[ResID] = [ \
									TypeCast TheValue[IDMask[i - 2]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i - 1]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i]] Float BufferID:BufferID \
								]
								ResID -= 1
							)
						)
					)
					#P4Array: (
						local	FirstID = IDMask[1],
								ResID = (IDMaskCount / 4)
						Result = #()
						if Have TheValue[FirstID] then (
							for i = IDMaskCount to 1 by -4 do (
								Result[ResID] = [ \
									TypeCast TheValue[IDMask[i - 3]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i - 2]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i - 1]] Float BufferID:BufferID, \
									TypeCast TheValue[IDMask[i]] Float BufferID:BufferID \
								]
								ResID -= 1
							)
						)
					)
					default:
						throw "Unknown type"
				)
				if IsNewIDMask then
					Free IDMask
				if IsNewValue then
					Free TheValue
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#TheValue, #Type, #IDMask), #(TheValue, Type, IDMask)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn NoCaseOrderComparator a b Descending = (
			/*<ERRHANDLERSTART>*/try (
				if Descending then
					-(StriCmp a b)
				else
					(StriCmp a b)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		)
	)
	struct /*#PC*PATH	GIMS.Core.ValueOps*/ ValueOpsstr (
		fn GetHash Val HashablePropertyName:unsupplied UseJenkins:true IgnoreCase:true = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case (ClassOf Val) of (
					String: (
						if UseJenkins then
							GIMS.Core.StringOps.GetJenkinsHash Val IgnoreCase:IgnoreCase
						else
							GetHashValue Val 0
					)
					Name: (
						if UseJenkins then
							GIMS.Core.StringOps.GetJenkinsHash (Val as String)
						else
							GetHashValue Val 0
					)
					Default: (
						if Supplied HashablePropertyName then
							GetHash (GetProperty Val HashablePropertyName) UseJenkins:UseJenkins
						else (
							local	ValGetHash = (TryGetProperty Val #GetHash)
							if ValGetHash != #GetPropertyFailed then
								ValGetHash()
							else
								GetHashValue Val 0
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FormatText \
			v1:#DontFormatText \
			v2:#DontFormatText \
			v3:#DontFormatText \
			v4:#DontFormatText \
			v5:#DontFormatText \
			v6:#DontFormatText \
			v7:#DontFormatText \
			v8:#DontFormatText \
			v9:#DontFormatText \
			v10:#DontFormatText \
			v11:#DontFormatText \
			v12:#DontFormatText \
			v13:#DontFormatText \
			v14:#DontFormatText \
			v15:#DontFormatText = \
		(
			/*<ERRHANDLERSTART>*/try (
				local	SS = (StringStream ""),
						Pattern ="%"
				if #DontFormatText != v1 then (
					Format Pattern v1 To:SS
					if #DontFormatText != v2 then (
						Format Pattern v2 To:SS
						if #DontFormatText != v3 then (
							Format Pattern v3 To:SS
							if #DontFormatText != v4 then (
								Format Pattern v4 To:SS
								if #DontFormatText != v5 then (
									Format Pattern v5 To:SS
									if #DontFormatText != v6 then (
										Format Pattern v6 To:SS
										if #DontFormatText != v7 then (
											Format Pattern v7 To:SS
											if #DontFormatText != v8 then (
												Format Pattern v8 To:SS
												if #DontFormatText != v9 then (
													Format Pattern v9 To:SS
													if #DontFormatText != v10 then (
														Format Pattern v10 To:SS
														if #DontFormatText != v11 then (
															Format Pattern v11 To:SS
															if #DontFormatText != v12 then (
																Format Pattern v12 To:SS
																if #DontFormatText != v13 then (
																	Format Pattern v13 To:SS
																	if #DontFormatText != v14 then (
																		Format Pattern v14 To:SS
																		if #DontFormatText != v15 then
																			Format Pattern v15 To:SS
																	)
																)
															)
														)
													)
												)
											)
										)
									)
								)
							)
						)
					)
				)
				local	Res = (SS as String)
				Free SS
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		),
		fn ConvertStruct Obj Type PropMapping:undefined AllowOwnProps:true AddMod:false ParamSource:undefined DontCreate:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if No ParamSource then (
					if Have Obj then
						ParamSource = Obj
					else
						throw "Can't resolve the param source - no object or param holder."
				)
				local	Result = (
							if DontCreate then (
								if Have Obj then
									Obj
								else
									throw "Can't assign the resulting object - DontCreate flag's set, but no object's specified."
							) else
								Type()
						),
						TagNamesFrom = #(),
						TagNamesTo = #()
				if AllowOwnProps then (
					local	ArrayOps = GIMS.Core.ArrayOps,
							SourceTagNames = (GetPropNames ParamSource),
							TargetTagNames = (ArrayOps.QuickSort (GetPropNames Result) DoCopy:true),
							QuickSearch = ArrayOps.QuickSearch,
							TagNameCount = SourceTagNames.Count,
							TagMapSize = 0
					TagNamesFrom.Count = TagNameCount
					TagNamesTo.Count = TagNameCount
					for TagName in SourceTagNames where (QuickSearch TargetTagNames TagName) != 0 do (
						TagMapSize += 1
						TagNamesFrom[TagMapSize] = TagName
						TagNamesTo[TagMapSize] = TagName
					)
					TagNamesFrom.Count = TagMapSize
					TagNamesTo.Count = TagMapSize
				)
				if Have PropMapping then (
					local	NewTagNamesFrom = (TagNamesFrom + PropMapping[1]),
							NewTagNamesTo = (TagNamesTo + PropMapping[2])
					Free TagNamesFrom
					Free TagNamesTo
					TagNamesFrom = NewTagNamesFrom
					TagNamesTo = NewTagNamesTo
				)
				local	SourceTagNameCount = TagNamesFrom.Count
				if SourceTagNameCount != TagNamesTo.Count then
					throw "Tag counts aren't equal"
				for TagID = 1 to SourceTagNameCount do (
					local	SourceProperty = (GetProperty ParamSource TagNamesFrom[TagID]),
							SourcePropertyType = (ClassOf SourceProperty)
					if SourcePropertyType != MAXScriptFunction then (
						local	ResultTagName = TagNamesTo[TagID],
								ResultProperty = (GetProperty Result ResultTagName)
						if (IsKindOf ResultProperty ArrayParameter) then (
							if (
								SourcePropertyType == Array or
								SourcePropertyType == ArrayParameter or
								SourcePropertyType == BitArray
							) then (
								local	SourcePropertyCount = SourceProperty.Count,
										ResultPropertyCount = ResultProperty.Count,
										ItemCount = (
											if SourcePropertyCount < ResultPropertyCount then
												SourcePropertyCount
											else
												ResultPropertyCount
										)
								for i = ItemCount to 1 by -1 do
									ResultProperty[i] = SourceProperty[i]
							) else
								throw "Can't fill an ArrayParameter value using non-storage type data source"
						) else (
							if (
								(SourcePropertyType == ArrayParameter) and
								(IsKindOf SourceProperty[1] BooleanClass) and
								(IsKindOf ResultProperty BitArray)
							) then (
								for i = SourceProperty.Count to 1 by -1 where SourceProperty[i] do
									ResultProperty[i] = true
							) else
								SetProperty Result ResultTagName SourceProperty
						)
					)
				)
				if Have Obj then (
					if AddMod then (
						AddModifier Obj Result UI:false
						Obj
					) else
						Result
				) else
					Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AsHex Val OutputMode ByteCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Res,
						TempRes = (FormattedPrint Val Format:"02X"),
						BitHexAsInt = Bit.HexAsInt
				case OutputMode of (
					#Array: (
						Res = #()
						for i = ByteCount to 1 by -1 do
							Res[i] = (BitHexAsInt (SubString TempRes (i*2 - 1) 2))
					)
					#String:
						Res = (SubString TempRes (TempRes.Count - (ByteCount*2 - 1)) (ByteCount*2))
					default:
						throw "Unknown OutputMode"
				)
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Round Val = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IntValue = (Val as Integer)
				(
					if (Val - IntValue) < 0.5 then
						IntValue
					else (
						IntValue + (
							if IntValue > 0 then
								1
							else
								-1
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn TypeCast Val Type CopyArray:true ReportCastFail:true BufferID:undefined = (
			/*<ERRHANDLERSTART>*/try (
				if (IsKindOf Type Name) then (
					case Type of (
						#HexString: (
							local	IntVal = (
										try
											Val as Integer64
										catch
											undefined
									)
							if Have IntVal then (
								local	str = (Append "0x" (Bit.IntAsHex IntVal)),
										Result = (SubString str 1 (str.Count - 1))
								Free str
								Result
							) else
								(Val as String)
						)
						#DegToRad: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								EulerAngles: (
									Val.x = (DegToRad Val.x)
									Val.y = (DegToRad Val.y)
									Val.z = (DegToRad Val.z)
									Val
								)
								Point3: (
									Val.x = (DegToRad Val.x)
									Val.y = (DegToRad Val.y)
									Val.z = (DegToRad Val.z)
									Val
								)
								Default:
									(DegToRad Val)
							)
						)
						#RadToDeg: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								EulerAngles: (
									Val.x = (RadToDeg Val.x)
									Val.y = (RadToDeg Val.y)
									Val.z = (RadToDeg Val.z)
									Val
								)
								Point3: (
									Val.x = (RadToDeg Val.x)
									Val.y = (RadToDeg Val.y)
									Val.z = (RadToDeg Val.z)
									Val
								)
								Default:
									(RadToDeg Val)
							)
						)
						#P2: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									[Val, 0]
								Float:
									[Val, 0]
								Double:
									[Val, 0]
								Point2:
									Val
								Point3:
									[Val.x, Val.y]
								Point4:
									[Val.x, Val.y]
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									[0, 0]
								)
							)
						)
						#P3: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									[Val, 0, 0]
								Float:
									[Val, 0, 0]
								Double:
									[Val, 0, 0]
								EulerAngles:
									[Val.x, Val.y, Val.z]
								Point2:
									[Val.x, Val.y, 0]
								Point3:
									Val
								Point4:
									[Val.x, Val.y, Val.z]
								Color:
									[Val.r, Val.g, Val.b]
								Array:
									[Val[1], Val[2], Val[3]]
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									[0, 0, 0]
								)
							)
						)
						#Color: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									(Color Val Val Val)
								Float:
									(Color Val Val Val)
								Double:
									(Color Val Val Val)
								EulerAngles:
									(Color Val.x Val.y Val.z)
								Point2:
									(Color Val.x Val.y 0)
								Point3:
									(Color Val.x Val.y Val.z)
								Point4:
									(Color Val.x Val.y Val.z Val.w)
								Color:
									Val
								Array:
									(Color Val[1] Val[2] Val[3])
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									(Color 0 0 0)
								)
							)
						)
						#P4: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									[Val, 0, 0, 0]
								Float:
									[Val, 0, 0, 0]
								Double:
									[Val, 0, 0, 0]
								Point2:
									[Val.x, Val.y, 0, 0]
								Point3:
									[Val.x, Val.y, Val.z, 0]
								Point4:
									Val
								Color:
									[Val.r, Val.g, Val.b, Val.a]
								Array:
									[Val[1], Val[2], Val[3], Val[4]]
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									[0, 0, 0, 0]
								)
							)
						)
						#String:
							(TypeCast Val String)
						#Float: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									(Val as Float)
								Float:
									Val
								Double:
									(Val as Float)
								EulerAngles:
									Val.x
								Point2:
									Val.x
								Point3:
									Val.x
								Point4:
									Val.x
								Color:
									Val.r
								Array:
									Val[1]
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									0
								)
							)
						)
						#Double: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Integer:
									(Val as Float)
								Float:
									(Val as Double)
								Double:
									Val
								EulerAngles:
									Val.x
								Point2:
									Val.x
								Point3:
									Val.x
								Point4:
									Val.x
								Color:
									Val.r
								Array:
									Val[1]
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									0
								)
							)
						)
						#P2Array: (
							if
								not (IsKindOf Val Array) and
								not (IsKindOf Val ArrayParameter)
							then
								throw ("Value " + (Val as String) + " isn't an array: " + ((ClassOf Val) as String))
							local	Result = (
										if CopyArray then
											#()
										else
											Val
									)
							for i = Val.Count to 1 by -1 do
								Result[i] = (TypeCast Val[i] #P2)
							Result
						)
						#P3Array: (
							if
								not (IsKindOf Val Array) and
								not (IsKindOf Val ArrayParameter)
							then
								throw ("Value " + (Val as String) + " isn't an array: " + ((ClassOf Val) as String))
							local	Result = (
										if CopyArray then
											#()
										else
											Val
									)
							for i = Val.Count to 1 by -1 do
								Result[i] = (TypeCast Val[i] #P3)
							Result
						)
						#P4Array: (
							if
								not (IsKindOf Val Array) and
								not (IsKindOf Val ArrayParameter)
							then
								throw ("Value " + (Val as String) + " isn't an array: " + ((ClassOf Val) as String))
							local	Result = (
										if CopyArray then
											#()
										else
											Val
									)
							for i = Val.Count to 1 by -1 do
								Result[i] = (TypeCast Val[i] #P4)
							Result
						)
						#ColorArray: (
							if
								not (IsKindOf Val Array) and
								not (IsKindOf Val ArrayParameter)
							then
								throw ("Value " + (Val as String) + " isn't an array: " + ((ClassOf Val) as String))
							local	Result = (
										if CopyArray then
											#()
										else
											Val
									)
							for i = Val.Count to 1 by -1 do
								Result[i] = (TypeCast Val[i] #Color)
							Result
						)
						#Euler: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Point3:
									(EulerAngles Val.x Val.y Val.z)
								Array:
									(EulerAngles Val[1] Val[2] Val[3])
								Default: (
									if ReportCastFail then
										GIMS.Core.SystemMgr.AddResult #Error (local	tSS = (StringStream "");	Format "% cast from % failed at \"%\".Data corrupted." Type ValClass Val To:tSS;	(tSS as String)) BufferID:BufferID
									(EulerAngles 0 0 0)
								)
							)
						)
						#Array: (
							local	ValClass = (ClassOf Val)
							case ValClass of (
								Point2:
									#(Val.x, Val.y)
								Point3:
									#(Val.x, Val.y, Val.z)
								EulerAngles:
									#(Val.x, Val.y, Val.z)
								Point4:
									#(Val.x, Val.y, Val.z, Val.w)
								Quat:
									#(Val.x, Val.y, Val.z, Val.w)
								Color:
									#(Val.r, Val.g, Val.b, Val.a)
								Array:
									Val
								Default:
									#(Val)
							)
						)
						Default:
							throw ("Can't make " + (Type as String) + " with " + ((ClassOf Val) as String) + " " + (Val as String))
					)
				) else (
					if (ClassOf Val) != Type then (
						local	Result = (
									try
										Val as Type
									catch
										undefined
								)
						if No Result then (
							local	ErrTxt = (
										FormatText \
											v1:Type \
											v2:" cast from " \
											v3:(ClassOf Val) \
											v4:" failed at \"" \
											v5:Val \
											v6:"\". Data corrupted." \
									)
							if ReportCastFail then (
								GIMS.Core.SystemMgr.AddResult #Error ErrTxt BufferID:BufferID
								Result = (
									case Type of (
										String:
											"<TypeCastFail>"
										Name:
											("<TypeCastFail>" as Name)
										Array:
											#()
										BitArray:
											#{}
										Float:
											0.0
										Integer:
											0
										Integer64:
											0
										IntegerPtr:
											0
										Point2:
											[0, 0]
										Point3:
											[0, 0, 0]
										Point4:
											[0, 0, 0, 0]
										Color:
											(Color 0 0 0)
										Matrix3:
											(Matrix3 0)
										EulerAngles:
											(EulerAngles 0 0 0)
										Quat:
											(Quat 0 0 0 0)
										Default:
											undefined
									)
								)
							) else
								throw ErrTxt
						)
						Result
					) else
						Val
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Val, #Type), #(Val, Type)))/*<ERRHANDLEREND>*/
		),
		fn GetPropertyByID Val ID IsColor:false = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if IsColor then (
					case ID of (
						1:
							Val.r
						2:
							Val.g
						3:
							Val.b
						4:
							Val.a
					)
				) else (
					case ID of (
						1:
							Val.x
						2:
							Val.y
						3:
							Val.z
						4:
							Val.w
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AsoFText \
			Val \
			WithAlpha:true \
			TabString:"" \
			SplitString:" " \
			SubSplitString:" " \
			SplitCount:0 \
			TypeHook:undefined \
			SubTypeHook:undefined \
			BufferID:unsupplied \
			IDMask:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "AsoFText"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ValClass = (ClassOf Val),
						SuppliedIDMask = (Supplied IDMask),
						Result = #AsoFTextFailed
				case ValClass of (
					ArrayParameter: (
						local	Arr = (Val as Array)
						Result = (AsoFText Arr WithAlpha:WithAlpha TabString:TabString SplitString:SplitString SubSplitString:SubSplitString SplitCount:SplitCount TypeHook:TypeHook SubTypeHook:SubTypeHook IDMask:IDMask)
						Free Arr
					)
					Array: (
						local	ArraySize = Val.Count,
								PrintFormat = "%%"
						if SuppliedIDMask then (
							local	IsNewIDMask = false
							if not (IsKindOf IDMask BitArray) then (
								IsNewIDMask = true
								IDMask = (TypeCast IDMask BitArray)
							)
							local	IDMaskSize = IDMask.NumberSet
							Result = (
								if IDMaskSize != 0 then (
									if Supplied BufferID then (
										local	WriteVal = GIMS.Core.BufferMgr.WriteVal
										local	tSS = (StringStream ""),
												IsFirstValue = true
										if SplitCount == 0 then (
											if Have TypeHook then (
												for VID in IDMask do (
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												)
											) else (
												for VID in IDMask do (
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												)
											)
											WriteVal BufferID (tSS as String)
											Free tSS
										) else (
											local	ValuesInLine = 0
											if Have TypeHook then (
												for VID in IDMask do (
													if ValuesInLine == SplitCount then (
														WriteVal BufferID (tSS as String)
														Free tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											) else (
												for VID in IDMask do (
													if ValuesInLine == SplitCount then (
														WriteVal BufferID (tSS as String)
														Free tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											)
											if ValuesInLine != 0 then
												WriteVal BufferID (tSS as String)
											Free tSS
										)
										OK
									) else (	--not Supplied BufferID
										local	tSS = (StringStream ""),
												IsFirstValue = true
										if SplitCount == 0 then (
											if Have TypeHook then (
												for VID in IDMask do (
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												)
											) else (
												for VID in IDMask do (
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												)
											)
											local	Res = (tSS as String)
											Free tSS
											Res
										) else (	--SplitCount != 0
											local	Res = #(),
													LineCount = (
														if (Mod IDMaskSize SplitCount) == 0 then
															(IDMaskSize / SplitCount)
														else
															((IDMaskSize / SplitCount) + 1)
													),
													ValuesInLine = 0,
													LineID = 1
											Res.Count = LineCount
											if Have TypeHook then (
												for VID in IDMask do (
													if ValuesInLine == SplitCount then (
														Res[LineID] = (tSS as String)
														Free tSS
														LineID += 1
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											) else (
												for VID in IDMask do (
													if ValuesInLine == SplitCount then (
														Res[LineID] = (tSS as String)
														Free tSS
														LineID += 1
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											)
											Res[LineID] = (tSS as String)
											Free tSS
											Res
										)
									)
								) else
									TabString
							)
							if IsNewIDMask then
								Free IDMask
						) else (	--not SuppliedIDMask
							if Supplied BufferID then (
								local	WriteVal = GIMS.Core.BufferMgr.WriteVal
								Result = (
									if ArraySize != 0 then (
										local	tSS = (StringStream "")
										if SplitCount == 0 then (
											if Have TypeHook then (
												Format PrintFormat TabString (AsoFText (TypeCast Val[1] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												for VID = 2 to ArraySize do
													Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
											) else (
												Format PrintFormat TabString (AsoFText Val[1] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												for VID = 2 to ArraySize do
													Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
											)
											WriteVal BufferID (tSS as String)
											Free tSS
										) else (	--SplitCount != 0
											
											/*WriteVal multiline*/
											local	ValuesInLine = 0,
													IsFirstValue = true,
													NewlineString = "\n"
											if Have TypeHook then (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														Format NewlineString to:tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											) else (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														Format NewlineString to:tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											)
											WriteVal BufferID (tSS as String)
											/**/
											
											/*WriteVal per line*
											local	ValuesInLine = 0,
													IsFirstValue = true
											if Have TypeHook then (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														WriteVal BufferID (tSS as String)
														Free tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											) else (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														WriteVal BufferID (tSS as String)
														Free tSS
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											)
											if ValuesInLine != 0 then
												WriteVal BufferID (tSS as String)
											/**/
											
											Free tSS
										)
									) else
										TabString
								)
								OK
							) else (	--not Supplied BufferID
								Result = (
									if ArraySize != 0 then (
										local	tSS = (StringStream ""),
												IsFirstValue = true
										if SplitCount == 0 then (
											if Have TypeHook then (
												Format PrintFormat TabString (AsoFText (TypeCast Val[1] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												for VID = 2 to ArraySize do
													Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
											) else (
												Format PrintFormat TabString (AsoFText Val[1] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
												for VID = 2 to ArraySize do
													Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
											)
											local	Res = (tSS as String)
											Free tSS
											Res
										) else (	--SplitCount != 0
											local	Res = #(),
													LineCount = (
														if (Mod ArraySize SplitCount) == 0 then
															(ArraySize / SplitCount)
														else
															((ArraySize / SplitCount) + 1)
													),
													ValuesInLine = 0,
													LineID = 1
											Res.Count = LineCount
											if Have TypeHook then (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														Res[LineID] = (tSS as String)
														Free tSS
														LineID += 1
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText (TypeCast Val[VID] TypeHook) SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											) else (
												for VID = 1 to ArraySize do (
													if ValuesInLine == SplitCount then (
														Res[LineID] = (tSS as String)
														Free tSS
														LineID += 1
														IsFirstValue = true
														ValuesInLine = 0
													)
													if IsFirstValue then (
														Format PrintFormat TabString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
														IsFirstValue = false
													) else
														Format PrintFormat SplitString (AsoFText Val[VID] SplitString:SubSplitString TypeHook:SubTypeHook) To:tSS
													ValuesInLine += 1
												)
											)
											Res[LineID] = (tSS as String)
											Free tSS
											Res
										)
									) else
										TabString
								)
							)
						)
					)
					Default: (
						local	IsNewIDMask = false
						if SuppliedIDMask then (
							if not (IsKindOf IDMask Array) then (
								IsNewIDMask = true
								IDMask = (TypeCast IDMask array)
							)
						)
						case ValClass of (
							Point2: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TS1,
										TS2
								if not SuppliedIDMask then (
									TS1 = (AsoFText Val[1] TypeHook:TypeHook)
									TS2 = (AsoFText Val[2] TypeHook:TypeHook)
								) else (
									TS1 = (AsoFText Val[IDMask[1]] TypeHook:TypeHook)
									TS2 = (AsoFText Val[IDMask[2]] TypeHook:TypeHook)
								)
								Result = (
									FormatText \
										v1:TabString \
										v2:TS1 \
										v3:SplitString \
										v4:TS2 \
								)
								Free TS1
								Free TS2
							)
							Point3: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TS1,
										TS2,
										TS3

								if not SuppliedIDMask then (
									if SubTypeHook == #DegToRad then (
										TS1 = (AsoFText (DegToRad Val[1]) TypeHook:TypeHook)
										TS2 = (AsoFText (DegToRad Val[2]) TypeHook:TypeHook)
										TS3 = (AsoFText (DegToRad Val[3]) TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText Val[1] TypeHook:TypeHook)
										TS2 = (AsoFText Val[2] TypeHook:TypeHook)
										TS3 = (AsoFText Val[3] TypeHook:TypeHook)
									)
								) else (
									if SubTypeHook == #DegToRad then (
										TS1 = (AsoFText (DegToRad Val[IDMask[1]]) TypeHook:TypeHook)
										TS2 = (AsoFText (DegToRad Val[IDMask[2]]) TypeHook:TypeHook)
										TS3 = (AsoFText (DegToRad Val[IDMask[3]]) TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText Val[IDMask[1]] TypeHook:TypeHook)
										TS2 = (AsoFText Val[IDMask[2]] TypeHook:TypeHook)
										TS3 = (AsoFText Val[IDMask[3]] TypeHook:TypeHook)
									)
								)
								Result = (
									FormatText \
										v1:TabString \
										v2:TS1 \
										v3:SplitString \
										v4:TS2 \
										v5:SplitString \
										v6:TS3 \
								)
								Free TS1
								Free TS2
								Free TS3
							)
							Point4: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TS1,
										TS2,
										TS3,
										TS4
								if not SuppliedIDMask then (
									TS1 = (AsoFText Val[1] TypeHook:TypeHook)
									TS2 = (AsoFText Val[2] TypeHook:TypeHook)
									TS3 = (AsoFText Val[3] TypeHook:TypeHook)
									TS4 = (AsoFText Val[4] TypeHook:TypeHook)
								) else (
									TS1 = (AsoFText Val[IDMask[1]] TypeHook:TypeHook)
									TS2 = (AsoFText Val[IDMask[2]] TypeHook:TypeHook)
									TS3 = (AsoFText Val[IDMask[3]] TypeHook:TypeHook)
									TS4 = (AsoFText Val[IDMask[4]] TypeHook:TypeHook)
								)
								Result = (
									FormatText \
										v1:TabString \
										v2:TS1 \
										v3:SplitString \
										v4:TS2 \
										v5:SplitString \
										v6:TS3 \
										v7:SplitString \
										v8:TS4 \
								)
								Free TS1
								Free TS2
								Free TS3
								Free TS4
							)
							EulerAngles: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TS1,
										TS2,
										TS3
								if not SuppliedIDMask then (
									if SubTypeHook == #DegToRad then (
										TS1 = (AsoFText (DegToRad Val.x) TypeHook:TypeHook)
										TS2 = (AsoFText (DegToRad Val.y) TypeHook:TypeHook)
										TS3 = (AsoFText (DegToRad Val.z) TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText Val.x TypeHook:TypeHook)
										TS2 = (AsoFText Val.y TypeHook:TypeHook)
										TS3 = (AsoFText Val.z TypeHook:TypeHook)
									)
								) else (
									if SubTypeHook == #DegToRad then (
										TS1 = (AsoFText (DegToRad (GetPropertyByID Val IDMask[1])) TypeHook:TypeHook)
										TS2 = (AsoFText (DegToRad (GetPropertyByID Val IDMask[2])) TypeHook:TypeHook)
										TS3 = (AsoFText (DegToRad (GetPropertyByID Val IDMask[3])) TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText (GetPropertyByID Val IDMask[1]) TypeHook:TypeHook)
										TS2 = (AsoFText (GetPropertyByID Val IDMask[2]) TypeHook:TypeHook)
										TS3 = (AsoFText (GetPropertyByID Val IDMask[3]) TypeHook:TypeHook)
									)
								)
								Result = (
									FormatText \
										v1:TabString \
										v2:TS1 \
										v3:SplitString \
										v4:TS2 \
										v5:SplitString \
										v6:TS3 \
								)
								Free TS1
								Free TS2
								Free TS3
							)
							Quat: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TS1,
										TS2,
										TS3,
										TS4
								if not SuppliedIDMask then (
									TS1 = (AsoFText Val.x TypeHook:TypeHook)
									TS2 = (AsoFText Val.y TypeHook:TypeHook)
									TS3 = (AsoFText Val.z TypeHook:TypeHook)
									TS4 = (AsoFText Val.w TypeHook:TypeHook)
								) else (
									TS1 = (AsoFText (GetPropertyByID Val IDMask[1]) TypeHook:TypeHook)
									TS2 = (AsoFText (GetPropertyByID Val IDMask[2]) TypeHook:TypeHook)
									TS3 = (AsoFText (GetPropertyByID Val IDMask[3]) TypeHook:TypeHook)
									TS4 = (AsoFText (GetPropertyByID Val IDMask[4]) TypeHook:TypeHook)
								)
								Result = (
									FormatText \
										v1:TabString \
										v2:TS1 \
										v3:SplitString \
										v4:TS2 \
										v5:SplitString \
										v6:TS3 \
										v7:SplitString \
										v8:TS4 \
								)
								Free TS1
								Free TS2
								Free TS3
								Free TS4
							)
							Matrix3: (
								local	TS1,
										TS2,
										TS3,
										TS4
								if not SuppliedIDMask then (
									TS1 = (AsoFText Val[1] TypeHook:TypeHook)
									TS2 = (AsoFText Val[2] TypeHook:TypeHook)
									TS3 = (AsoFText Val[3] TypeHook:TypeHook)
									TS4 = (AsoFText Val[4] TypeHook:TypeHook)
								) else (
									TS1 = (AsoFText Val[IDMask[1]] TypeHook:TypeHook)
									TS2 = (AsoFText Val[IDMask[2]] TypeHook:TypeHook)
									TS3 = (AsoFText Val[IDMask[3]] TypeHook:TypeHook)
									TS4 = (AsoFText Val[IDMask[4]] TypeHook:TypeHook)
								)
								if Supplied BufferID then (
									local	WriteVal = GIMS.Core.BufferMgr.WriteVal
									WriteVal BufferID (TabString + TS1)
									WriteVal BufferID (TabString + TS2)
									WriteVal BufferID (TabString + TS3)
									WriteVal BufferID (TabString + TS4)
									Result = #Matrix3Pushed
								) else (
									Result = #(
										(TabString + TS1),
										(TabString + TS2),
										(TabString + TS3),
										(TabString + TS4)
									)
								)
								Free TS1
								Free TS2
								Free TS3
								Free TS4
							)
							Color: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								if No TypeHook then
									TypeHook = Integer
								if WithAlpha then (
									local	TS1,
											TS2,
											TS3,
											TS4
									if not SuppliedIDMask then (
										TS1 = (AsoFText Val.r TypeHook:TypeHook)
										TS2 = (AsoFText Val.g TypeHook:TypeHook)
										TS3 = (AsoFText Val.b TypeHook:TypeHook)
										TS4 = (AsoFText Val.a TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText (GetPropertyByID Val IDMask[1] IsColor:true) TypeHook:TypeHook)
										TS2 = (AsoFText (GetPropertyByID Val IDMask[2] IsColor:true) TypeHook:TypeHook)
										TS3 = (AsoFText (GetPropertyByID Val IDMask[3] IsColor:true) TypeHook:TypeHook)
										TS4 = (AsoFText (GetPropertyByID Val IDMask[4] IsColor:true) TypeHook:TypeHook)
									)
									Result = (
										FormatText \
											v1:TabString \
											v2:TS1 \
											v3:SplitString \
											v4:TS2 \
											v5:SplitString \
											v6:TS3 \
											v7:SplitString \
											v8:TS4 \
									)
									Free TS1
									Free TS2
									Free TS3
									Free TS4
								) else (	--not WithAlpha
									local	TS1,
											TS2,
											TS3
									if not SuppliedIDMask then (
										TS1 = (AsoFText Val.r TypeHook:TypeHook)
										TS2 = (AsoFText Val.g TypeHook:TypeHook)
										TS3 = (AsoFText Val.b TypeHook:TypeHook)
									) else (
										TS1 = (AsoFText (GetPropertyByID Val IDMask[1] IsColor:true) TypeHook:TypeHook)
										TS2 = (AsoFText (GetPropertyByID Val IDMask[2] IsColor:true) TypeHook:TypeHook)
										TS3 = (AsoFText (GetPropertyByID Val IDMask[3] IsColor:true) TypeHook:TypeHook)
									)
									Result = (
										FormatText \
											v1:TabString \
											v2:TS1 \
											v3:SplitString \
											v4:TS2 \
											v5:SplitString \
											v6:TS3 \
									)
									Free TS1
									Free TS2
									Free TS3
								)
							)
							Integer: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast Val TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							Integer64: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast Val TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							IntegerPtr: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast Val TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							Float: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then (
												if
													TypeHook == ValClass or
													TypeHook == Double or
													TypeHook == #RadToDeg or
													TypeHook == #DegToRad
												then
													(FormattedPrint (TypeCast Val TypeHook) Format:"0.7f")
												else
													((TypeCast Val TypeHook) as String)
											) else
												(FormattedPrint Val Format:"0.7f")
										)
								Result = (TabString + TempString)
								Free TempString
							)
							Double: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then (
												if
													TypeHook == ValClass or
													TypeHook == Float or
													TypeHook == #RadToDeg or
													TypeHook == #DegToRad
												then
													(FormattedPrint (TypeCast Val TypeHook) Format:"0.7f")
												else (
													local	Res = ((TypeCast Val TypeHook) as String)
													(SubString Res 1 (Res.Count - 2))
												)
											) else
												(FormattedPrint Val Format:"0.7f")
										)
								Result = (TabString + TempString)
								Free TempString
							)
							String: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast Val TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							Name: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast (Val as String) TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							UndefinedClass: (
								if Supplied BufferID then
									throw "Can't write that value type to the buffer: " ValClass
								local	TempString = (
											if Have TypeHook then
												((TypeCast Val TypeHook) as String)
											else
												(Val as String)
										)
								Result = (TabString + TempString)
								Free TempString
							)
							default:
								throw ("Unknown value type " + ValClass as String + "!")
						)
						if IsNewIDMask then
							Free IDMask
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#Val, #WithAlpha, #TabString, #SplitString, #SubSplitString, #SplitCount, #TypeHook, #SubTypeHook, #IDMask, #BufferID), #(Val, WithAlpha, TabString, SplitString, SubSplitString, SplitCount, TypeHook, SubTypeHook, IDMask, BufferID)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Compare ValOne ValTwo CaseOp:undefined PropMapping:unsupplied MaxDiff:unsupplied = (
			/*<ERRHANDLERSTART>*/try (
				if not Supplied MaxDiff then
					MaxDiff = 0.0001
				if ValOne != ValTwo then (
					if
						Have CaseOp or
						(ClassOf ValOne) == (ClassOf ValTwo)
					then (
						local	Result = #NoCompareResult
						case (ClassOf ValOne) of (
							Array: (
								Result = (ValOne.Count == ValTwo.Count)
								if Result then (
									for i = 1 to ValOne.Count while Result where not (Compare ValOne[i] ValTwo[i] CaseOp:CaseOp PropMapping:PropMapping MaxDiff:MaxDiff) do
										Result = false
								)
							)
							ArrayParameter: (
								Result = (ValOne.Count == ValTwo.Count)
								if Result then (
									for i = 1 to ValOne.Count while Result where not (Compare ValOne[i] ValTwo[i] CaseOp:CaseOp PropMapping:PropMapping MaxDiff:MaxDiff) do
										Result = false
								)
							)
							BitmapTexture:
								Result = (Compare ValOne.FileName ValTwo.FileName)
							EulerAngles: (
								Result = (
									(Compare ValOne.x ValTwo.x MaxDiff:MaxDiff) and
									(Compare ValOne.y ValTwo.y MaxDiff:MaxDiff) and
									(Compare ValOne.z ValTwo.z MaxDiff:MaxDiff)
								)
							)
							Quat: (
								Result = (
									(Compare ValOne.x ValTwo.x MaxDiff:MaxDiff) and
									(Compare ValOne.y ValTwo.y MaxDiff:MaxDiff) and
									(Compare ValOne.z ValTwo.z MaxDiff:MaxDiff) and
									(Compare ValOne.w ValTwo.w MaxDiff:MaxDiff)
								)
							)
							Matrix3: (
								Result = (
									(Compare ValOne.Rotation ValTwo.Rotation MaxDiff:MaxDiff) and
									(Distance ValOne.Pos ValTwo.Pos) < MaxDiff and
									(Distance ValOne.Scale ValTwo.Scale) < MaxDiff
								)
							)
							Integer:
								Result = (ValOne == ValTwo)
							Integer64:
								Result = (ValOne == ValTwo)
							IntegerPtr:
								Result = (ValOne == ValTwo)
							Float:
								Result = (FloatCompare ValOne ValTwo MaxDiff)
							Double:
								Result = (FloatCompare ValOne ValTwo MaxDiff)
							Point2:
								Result = ((Distance ValOne ValTwo) < MaxDiff)
							Point3:
								Result = ((Distance ValOne ValTwo) < MaxDiff)
							Point4:
								Result = ((Distance ValOne ValTwo) < MaxDiff)
							String: (
								Result = (
									case CaseOp of (
										#Name:
											((TypeCast (TrimRight (TrimLeft ValOne)) Name) == (TypeCast ValTwo Name))
										#Pattern:
											(MatchPattern ValOne Pattern:ValTwo)
										#CaseSensitive:
											(ValOne == ValTwo)
										Default:
											((StriCmp ValOne ValTwo) == 0)
									)
								)
							)
							Name: (
								Result = (
									case CaseOp of (
										#Pattern:
											(MatchPattern ValOne Pattern:ValTwo)
										Default:
											(ValOne == ValTwo)
									)
								)
							)
							default: (
								local	ValType = (SuperClassOf ValOne)
								if
									ValType == StructDef or
									ValType == GeometryClass or
									ValType == Material
								then (
									Result = true
									local	SuppliedPropMapping = (Supplied PropMapping),
											Tags1, Tags2
									if SuppliedPropMapping then (
										Tags1 = PropMapping[1]
										Tags2 = PropMapping[2]
									) else (
										Tags1 = (GetPropNames ValOne)
										Tags2 = (GetPropNames ValTwo)
									)
									for TagID = 1 to Tags1.Count while Result do (
										local	TempTag = Tags1[TagID]
										if TempTag != #GIMSObjectLink then (
											local	Val1 = (GetProperty ValOne TempTag)
											if not (IsKindOf Val1 MAXScriptFunction) then (
												local	FoundTagID = (FindItem Tags2 TempTag)
												if
													FoundTagID != 0 and
													not (Compare Val1 (GetProperty ValTwo Tags2[FoundTagID]) CaseOp:CaseOp MaxDiff:MaxDiff)
												then
													Result = false
											)
										)
									)
									if not SuppliedPropMapping then (
										Free Tags1
										Free Tags2
									)
								) else (
									local	h1 = (GetHashValue ValOne 0)
									if No h1 then
										Result = (ValOne == ValTwo)
									else
										Result = (h1 == (GetHashValue ValTwo 0))
								)
							)
						)
						Result
					) else
						false
				) else
					true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#ValOne, #ValTwo, #CaseOp, #PropMapping, #MaxDiff), #(ValOne, ValTwo, CaseOp, PropMapping, MaxDiff)))/*<ERRHANDLEREND>*/
		),
		fn CheckOrder a b Descending = (
			/*<ERRHANDLERSTART>*/try (
				if Descending then
					(a > b)
				else
					(a < b)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		),
		fn OrderComparator a b Descending = (	/*TODO>	use in new Quicksort**/
			/*<ERRHANDLERSTART>*/try (
				if a == b then
					0
				else (
					if (CheckOrder a b Descending) then
						-1
					else
						1
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
		),
		fn AsText Val \
			BufferID:undefined \
			AppendLast:false \
			Prefix:"" \
			Postfix:"" \
			ArrayItemsPerLine:20 \
			ArraySeparators:#("#(", ",", ")") \
			ValClass:unsupplied \
			IsStructDef:unsupplied \
			IsMaterial:unsupplied \
			IsNode:unsupplied \
			SubresourcesPath:unsupplied \
			Executable:false \
			TargetStringStream:unsupplied = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start "AsText"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not Supplied ValClass then
					ValClass = (ClassOf Val)
				local	ValSuperClass = (SuperClassOf Val)
				if not Supplied IsStructDef then
					IsStructDef = (ValSuperClass == StructDef)
				if not Supplied IsMaterial then
					IsMaterial = (ValSuperClass == Material)
				if not Supplied IsNode then
					IsNode = (ClassOf ValSuperClass == Node)
				case ValClass of (
					ArrayParameter:
						AsText Val ArrayItemsPerLine:ArrayItemsPerLine BufferID:BufferID AppendLast:AppendLast Prefix:Prefix Postfix:Postfix ArraySeparators:ArraySeparators ValClass:Array SubresourcesPath:SubresourcesPath Executable:Executable TargetStringStream:TargetStringStream
					Array: (
						if Have BufferID then (
							local	WriteVal = GIMS.Core.BufferMgr.WriteVal,
									ValCount = Val.Count,
									SourceAppendLast = AppendLast
							WriteVal BufferID (Prefix + ArraySeparators[1]) AppendLast:AppendLast
							if ValCount <= ArrayItemsPerLine then
								AppendLast = true
							local	ArraySeparators2 = ArraySeparators[2],
									ItemsInLine = 0,
									IsLineFull = (not AppendLast)
							for ItemID = 1 to (ValCount - 1) do (
								local	ArrVal = Val[ItemID],
										ArrValClass = (ClassOf ArrVal),
										ArrValSuperClass = (SuperClassOf ArrVal),
										ArrValIsStructDef = (ArrValSuperClass == StructDef),
										ArrValIsMaterial = (ArrValSuperClass == Material),
										ArrValIsNode = (ClassOf ArrValSuperClass == Node),
										DoAppendLast = (
											if IsLineFull then
												AppendLast
											else (
												if
													ArrValClass == ArrayParameter or
													ArrValClass == Array
												then
													false
												else (
													not ArrValIsStructDef and
													not ArrValIsMaterial and
													not ArrValIsNode
												)
											)
										)
								AsText ArrVal \
									ValClass:ArrValClass \
									IsStructDef:ArrValIsStructDef \
									IsMaterial:ArrValIsMaterial \
									IsNode:ArrValIsNode \
									ArrayItemsPerLine:ArrayItemsPerLine \
									BufferID:BufferID \
									AppendLast:DoAppendLast \
									Postfix:ArraySeparators2 \
									SubresourcesPath:SubresourcesPath \
									Executable:Executable \
									TargetStringStream:TargetStringStream
								if not AppendLast then (
									ItemsInLine += 1
									if ItemsInLine == ArrayItemsPerLine then (
										ItemsInLine = 0
										IsLineFull = true
									) else
										IsLineFull = false
								)
							)
							if ValCount != 0 then (
								local	ArrVal = Val[ValCount],
										ArrValClass = (ClassOf ArrVal),
										ArrValSuperClass = (SuperClassOf ArrVal),
										ArrValIsStructDef = (ArrValSuperClass == StructDef),
										ArrValIsMaterial = (ArrValSuperClass == Material),
										ArrValIsNode = (ClassOf ArrValSuperClass == Node),
										DoAppendLast = (
											if IsLineFull then
												AppendLast
											else (
												if
													ArrValClass == ArrayParameter or
													ArrValClass == Array
												then
													false
												else (
													not ArrValIsStructDef and
													not ArrValIsMaterial and
													not ArrValIsNode
												)
											)
										)
								AsText ArrVal \
									ValClass:ArrValClass \
									IsStructDef:ArrValIsStructDef \
									IsMaterial:ArrValIsMaterial \
									IsNode:ArrValIsNode \
									ArrayItemsPerLine:ArrayItemsPerLine \
									BufferID:BufferID \
									AppendLast:DoAppendLast \
									SubresourcesPath:SubresourcesPath \
									Executable:Executable \
									TargetStringStream:TargetStringStream
							)
							WriteVal BufferID (ArraySeparators[3] + Postfix) AppendLast:AppendLast
						) else (
							local	tSS = (StringStream "")
							Format "%%" Prefix ArraySeparators[1] To:tSS
							local	ValCount = Val.Count,
									ArraySeparators2 = ArraySeparators[2],
									PercentChar = "%"
							for ItemID = 1 to (ValCount - 1) do (
								Format PercentChar (
									AsText Val[ItemID] \
										ArrayItemsPerLine:ArrayItemsPerLine \
										Postfix:ArraySeparators2 \
										SubresourcesPath:SubresourcesPath \
										Executable:Executable \
										TargetStringStream:TargetStringStream
								) To:tSS
							)
							if ValCount != 0 then (
								Format PercentChar (
									AsText Val[ValCount] \
										ArrayItemsPerLine:ArrayItemsPerLine \
										SubresourcesPath:SubresourcesPath \
										Executable:Executable \
										TargetStringStream:TargetStringStream
								) To:tSS
							)
							Format "%%" ArraySeparators[3] Postfix To:tSS
							local	Result = (tSS as String)
							Free tSS
							Result
						)
					)
					String: (
						local	QuoteChar = "\"",
								Res = (
									FormatText \
										v1:Prefix \
										v2:QuoteChar \
										v3:(GIMS.Core.StringOps.ReplaceChars Val ReplaceTags:#(#("\\", "\""), #("\\\\", "\\\"")) MultiChar:true) \
										v4:QuoteChar \
										v5:Postfix
								)
						if Have BufferID then
							GIMS.Core.BufferMgr.WriteVal BufferID Res AppendLast:AppendLast
						else
							Res
					)
					Name: (
						local	ValStr = (Val as String),
								Res = (Append "#" ValStr)
						Free ValStr
						if Executable then (
							try
								Execute Res
							catch (
								Res = (
									FormatText \
										v1:"(\"" \
										v2:Val \
										v3:"\" as Name)" \
								)
							)
						)
						Res = (
							FormatText \
								v1:Prefix \
								v2:Res \
								v3:Postfix
						)
						if Have BufferID then
							GIMS.Core.BufferMgr.WriteVal BufferID Res AppendLast:AppendLast
						else
							Res
					)
					BitmapTexture: (
						if No BufferID then
							throw "Can't convert a texture to text without a BufferID"
						if (GIMS.Core.MaterialOps.FixMapFileName Val) then (
							local	ValFileName = Val.FileName,
									FileNameType = (FileNameFromPath ValFileName),
									BufferMgr = GIMS.Core.BufferMgr,
									ResourcePath = (BufferMgr.GetPath BufferID),
									ResourceDir = ((FileNameFromPath ResourcePath) + ".Data\\"),
									ResourceFilesPath = ((GetFileNamePath ResourcePath) + ResourceDir),
									PathDef = (
										if not Supplied SubresourcesPath then
											"(if Have EGIMS_ExecutePath then EGIMS_ExecutePath else (throw \"Undefined EGIMS_ExecutePath\"))"
										else (
											if (IsKindOf SubresourcesPath Name) then (
												FormatText \
													v1:"(" \
													v2: (
														case SubresourcesPath of (
															#FilesPath:
																"GIMS.CurrentGame.FilesPath"
															#CachePath:
																"GIMS.CurrentGame.CachePath"
															#ResourceCachePath:
																"GIMS.CurrentGame.ResourceCachePath"
															#ExecutePath:
																"(if Have EGIMS_ExecutePath then EGIMS_ExecutePath else (throw \"Undefined EGIMS_ExecutePath\"))"
															default:
																throw "Unknown SubresourcesPath: " SubresourcesPath
														)
													) \
													v3:" + " \
													v4:(AsText ResourceDir ArrayItemsPerLine:ArrayItemsPerLine Executable:Executable TargetStringStream:TargetStringStream) \
													v5:")"
											) else
												(AsText (GetFileNamePath ValFileName) ArrayItemsPerLine:ArrayItemsPerLine Executable:Executable TargetStringStream:TargetStringStream)
										)
									),
									Res = (
										FormatText \
											v1:Prefix \
											v2:"(GIMS.Core.MaterialOps.LoadBitmapFile " \
											v3:PathDef \
											v4:" \"" \
											v5:FileNameType \
											v6:"\" NoSearch:true)" \
											v7:Postfix
									)
							if (DoesFileExist ValFileName) then (
								MakeDir ResourceFilesPath All:true
								GIMS.Core.SystemMgr.FileCopy ValFileName (ResourceFilesPath + FileNameType)
							)
							if Have BufferID then
								BufferMgr.WriteVal BufferID Res AppendLast:AppendLast
							else
								Res
						) else
							"undefined"
					)
					Default: (
						if
							IsStructDef or
							IsMaterial or
							IsNode
						then (
							if Have BufferID then (
								local	AllTagNames = (GetPropNames Val),
										GIMSObjectLinkTagID = (FindItem AllTagNames #GIMSObjectLink),
										GIMSObjectLink = (
											if GIMSObjectLinkTagID != 0 then
												((GetProperty Val AllTagNames[GIMSObjectLinkTagID]) as String)
											else (
												local	strDef = ((ClassOf Val) as String)
												if (MatchPattern strDef Pattern:"#Struct:*(*)") then
													SubString strDef 9 ((FindString strDef "(") - 9)
												else (
													if IsStructDef then
														throw "Can't resolve structure name: " strDef
													else
														strDef
												)
											)
										),
										Tags = #(),
										TagValues = #(),
										TagID = 0
								Tags.Count = AllTagNames.Count
								TagValues.Count = AllTagNames.Count
								for Tag in AllTagNames do (
									local	TagValue = (GetProperty Val Tag)
									if
										(Tag != #GIMSObjectLink) and
										(not (IsKindOf TagValue MAXScriptFunction))
									then (
										TagID += 1
										Tags[TagID] = Tag
										TagValues[TagID] = TagValue
									)
								)
								Tags.Count = TagID
								TagValues.Count = TagID
								local	HaveTags = (TagID != 0),
										WriteVal = GIMS.Core.BufferMgr.WriteVal,
										ParamPostfix = (
											if HaveTags then (
												if AppendLast then
													" "
												else
													" \\"
											) else
												(Append "())" Postfix)
										)
								WriteVal BufferID (Prefix + "(") AppendLast:AppendLast
								AsText GIMSObjectLink ArrayItemsPerLine:ArrayItemsPerLine ValClass:#NoQuoteString BufferID:BufferID AppendLast:AppendLast Executable:Executable Postfix:ParamPostfix
								if HaveTags then (
									case of (
										IsNode: (
											WriteVal BufferID (
												FormatText \
													v1:"Name:" \
													v2:(AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) \
													v3:ParamPostfix
											) AppendLast:AppendLast
											WriteVal BufferID (
												FormatText \
													v1:"Pos:" \
													v2:Val.Pos \
													v3:ParamPostfix
											) AppendLast:AppendLast
										)
										IsMaterial: (
											WriteVal BufferID (
												FormatText \
													v1:"Name:" \
													v2:(AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) \
													v3:ParamPostfix
											) AppendLast:AppendLast
											WriteVal BufferID (
												FormatText \
													v1:"ShowInViewPort:" \
													v2:Val.ShowInViewPort \
													v3:ParamPostfix
											) AppendLast:AppendLast
										)
									)
									local	DoubleDotChar = ":"
									for TagID = 1 to Tags.Count do
										AsText TagValues[TagID] ArrayItemsPerLine:ArrayItemsPerLine BufferID:BufferID AppendLast:AppendLast Prefix:((Tags[TagID] as String) + DoubleDotChar) Postfix:ParamPostfix SubresourcesPath:SubresourcesPath Executable:Executable
									WriteVal BufferID (")" + Postfix) AppendLast:AppendLast
								)
							) else (
								local	MakeNewSS = false
								if not Supplied TargetStringStream then (
									TargetStringStream = (StringStream "")
									MakeNewSS = true
								)
								local	AllTagNames = (GetPropNames Val),
										GIMSObjectLinkTagID = (FindItem AllTagNames #GIMSObjectLink),
										GIMSObjectLink = (
											if GIMSObjectLinkTagID != 0 then
												((GetProperty Val AllTagNames[GIMSObjectLinkTagID]) as String)
											else (
												local	strDef = ((ClassOf Val) as String)
												if (MatchPattern strDef Pattern:"#Struct:*(*)") then
													SubString strDef 9 ((FindString strDef "(") - 9)
												else (
													if IsStructDef then
														throw "Can't resolve structure name: " strDef
													else
														strDef
												)
											)
										),
										Tags = #(),
										TagValues = #(),
										TagID = 0
								Tags.Count = AllTagNames.Count
								TagValues.Count = AllTagNames.Count
								for Tag in AllTagNames do (
									local	TagValue = (GetProperty Val Tag)
									if
										(Tag != #GIMSObjectLink) and
										(not (IsKindOf TagValue MAXScriptFunction))
									then (
										TagID += 1
										Tags[TagID] = Tag
										TagValues[TagID] = TagValue
									)
								)
								Free AllTagNames
								Tags.Count = TagID
								TagValues.Count = TagID
								local	HaveTags = (TagID != 0),
										ParamPostfix = (
											if HaveTags then (
												if AppendLast then
													" "
												else
													" \\"
											) else
												(Append "())" Postfix)
										)
								if AppendLast then
									Format "%(" Prefix To:TargetStringStream
								else
									Format "\n%(" Prefix To:TargetStringStream
								AsText GIMSObjectLink ArrayItemsPerLine:ArrayItemsPerLine ValClass:#NoQuoteString BufferID:BufferID AppendLast:AppendLast Executable:Executable Postfix:ParamPostfix TargetStringStream:TargetStringStream
								if HaveTags then (
									case of (
										IsNode: (
											if AppendLast then
												Format "Name:% Pos:% " (AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) Val.Pos To:TargetStringStream
											else
												Format "Name:% \\\nPos:% \\\n" (AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) Val.Pos To:TargetStringStream
										)
										IsMaterial: (
											if AppendLast then
												Format "Name:% ShowInViewPort:% " (AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) Val.ShowInViewPort To:TargetStringStream
											else
												Format "Name:% \\\nShowInViewPort:% \\\n" (AsText Val.Name ArrayItemsPerLine:ArrayItemsPerLine SubresourcesPath:SubresourcesPath Executable:Executable) Val.ShowInViewPort To:TargetStringStream
										)
									)
									local	DoubleDotChar = ":"
									for TagID = 1 to Tags.Count do
										AsText TagValues[TagID] ArrayItemsPerLine:ArrayItemsPerLine BufferID:BufferID AppendLast:AppendLast Prefix:((Tags[TagID] as String) + DoubleDotChar) Postfix:ParamPostfix SubresourcesPath:SubresourcesPath Executable:Executable TargetStringStream:TargetStringStream
									if AppendLast then
										Format ")%" Postfix To:TargetStringStream
									else
										Format "\n)%" Postfix To:TargetStringStream
								)
								if MakeNewSS then (
									local	Result = (TargetStringStream as String)
									Free TargetStringStream
									Result
								) else
									TargetStringStream
							)
						) else (
							if ValClass == Float then
								Val = (FormattedPrint Val Format:"0.7f")
							local	Res = (
										FormatText \
											v1:Prefix \
											v2:(if not Supplied Val then "unsupplied" else Val) \
											v3:Postfix
									)
							if Have BufferID then
								GIMS.Core.BufferMgr.WriteVal BufferID Res AppendLast:AppendLast
							else
								Res
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AsBitArray Val Range:undefined BitShift:0 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Res = #{},
						BitGet = Bit.Get,
						NoRange = (No Range)
				if NoRange then
					Range = #{1..32}
				Res.Count = Range.Count
				for i in Range where (BitGet Val i) do
					Res[i + BitShift] = true
				if NoRange then
					Free Range
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyBits FromVal ToVal FromRange ToRange = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Res = (Copy ToVal),
						IsNewFromRange = false,
						IsNewToRange = false,
						BitGet = Bit.Get,
						BitSet = Bit.Set
				if not (IsKindOf FromRange Array) then (
					IsNewFromRange = true
					FromRange = (TypeCast FromRange Array)
				)
				if not (IsKindOf ToRange Array) then (
					IsNewToRange = true
					ToRange = (TypeCast ToRange Array)
				)
				if FromRange.Count != ToRange.Count then
					throw "Counts aren't equal"
				for i = 1 to FromRange.Count do
					Res = (BitSet Res ToRange[i] (BitGet FromVal FromRange[i]))
				if IsNewFromRange then
					Free FromRange
				if IsNewToRange then
					Free ToRange
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetBits ToVal Range Bits = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Res = (Copy ToVal),
						IsNewRange = false,
						IsNewBits = false,
						BitSet = Bit.Set
				if not (IsKindOf FromRange Array) then (
					IsNewRange = true
					Range = (TypeCast Range Array)
				)
				if not (IsKindOf ToRange Array) then (
					IsNewBits = true
					Bits = (TypeCast Bits Array)
				)
				if Range.Count != Bits.Count then
					throw "Counts aren't equal"
				for i = 1 to Range.Count do
					Res = (BitSet Res Range[i] Bits[i])
				if IsNewRange then
					Free Range
				if IsNewBits then
					Free Bits
				Res
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwapBytes Val Bytes = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BitSwapBytes = Bit.SwapBytes
				for i = 1 to Bytes.Count - 1 by 2 do
					Val = (BitSwapBytes Val Bytes[i] Bytes[i + 1])
				Val
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Round Val Limit:2 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Limit > 0 then
					Val *= (Pow 10 Limit)
				Val = ((Val + 0.5) as Integer)
				if limit > 0 then
					Val /= (Pow 10 Limit)
				Val
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn UpdateMatrix Mtx Coords Data = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	UpdatePointer = (IsKindOf Mtx ValueRef),
						UpdateCoord = (IsKindOf Coords Point2),
						TargetMtx = (
							if UpdatePointer then
								(*Mtx)
							else
								Mtx
						),
						ElementID = (
							if UpdateCoord then
								Coords.x
							else
								Coords
						),
						Element
				if UpdateCoord then (
					Element = TargetMtx[ElementID]
					Element[Coords.y] = Data
				) else
					Element = Data
				TargetMtx[ElementID] = Element
				if UpdatePointer then
					*Mtx = TargetMtx
				TargetMtx
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SwitchEndian Val ByteCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BitSwapBytes = Bit.SwapBytes
				case ByteCount of (
					2:
						(BitSwapBytes Val 1 2)
					4:
						(BitSwapBytes (BitSwapBytes Val 1 4) 2 3)
					8:
						(BitSwapBytes (BitSwapBytes (BitSwapBytes (BitSwapBytes Val 1 8) 2 7) 3 6) 4 5)
					Default:
						throw ("Unknown byte count: " + ByteCount as String)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.Core.ConfigOps*/ ConfigOpsstr (
		fn GetTime Parameter = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ResultIsString = true,
						Result
				case Parameter of (
					#Build: (
						Result = (GetUniversalTime())
						Result = #(Result[4], Result[2], Result[1], Result[5], Result[6])
						ResultIsString = false
					)
					#CacheResetDate: (
						Result = (FilterString GIMS.CurrentGame.Core.ConfigProps.CacheResetDate " ")
						Result = (FilterString Result[1] ".") + (FilterString Result[2] ":")
					)
					default: (
						local	FileDate = (((GIMS.Core.SystemMgr.NETFileIO.GetLastWriteTime Parameter).ToUniversalTime()).ToString "d.M.yyyy.H.m")
						Result = (FilterString FileDate ".")
					)
				)
				if ResultIsString then (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast
					for i = Result.Count to 1 by -1 do
						Result[i] = (TypeCast Result[i] Integer)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn TimeToString RAWBuildDate = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DotChar = "."
				(
					GIMS.Core.ValueOps.FormatText \
						v1:RAWBuildDate[1] \
						v2:DotChar \
						v3:RAWBuildDate[2] \
						v4:DotChar \
						v5:RAWBuildDate[3] \
						v6:" " \
						v7:RAWBuildDate[4] \
						v8:":" \
						v9:RAWBuildDate[5] \
						v10:" UTC"
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn IsDatetimeNewerThan DT1 DT2 = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				
				if not (IsKindOf DT1 Array) then
					DT1 = (GetTime DT1)
				if not (IsKindOf DT2 Array) then
					DT2 = (GetTime DT2)
									
				local	Result
				--DT format: #(day, month, year, hr, min)
				for i = 3 to 1 by -1 while No Result do (
					local	d1 = DT1[i],
							d2 = DT2[i]
					if (d1 != d2) then
						Result = (d1 > d2)
				)
				if No Result then (
					for i = 4 to 5 while No Result do (
						local	d1 = DT1[i],
								d2 = DT2[i]
						if (d1 != d2) then
							Result = (d1 > d2)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadTime SourceFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				#(
					ReadByte SourceFile #unsigned,
					ReadByte SourceFile #unsigned,
					ReadShort SourceFile #unsigned,
					ReadByte SourceFile #unsigned,
					ReadByte SourceFile #unsigned
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadConfigFile SourceFile = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SourceFile = (FOpen SourceFile "rb"),
						RAWBuildDate = (ReadTime SourceFile),
						BuildDate = (TimeToString RAWBuildDate),
						CacheResetDate = (TimeToString (ReadTime SourceFile)),
						Files = #(),
						Sizes = #(),
						Hashes = #(),
						Versions = #(),
						EntryCount = (ReadByte SourceFile #unsigned)
				Files.Count = EntryCount
				Sizes.Count = EntryCount
				Hashes.Count = EntryCount
				Versions.Count = EntryCount
				for i = 1 to EntryCount do (
					Files[i] = (ReadString SourceFile)
					Sizes[i] = (ReadLong SourceFile)
					Versions[i] = (TimeToString (ReadTime SourceFile))
				)
				local	CurPos = (FTell SourceFile)
				FSeek SourceFile 0 #seek_end
				local	EndPos = (FTell SourceFile)
				if CurPos < EndPos then (
					FSeek SourceFile CurPos #seek_set
					for i = 1 to EntryCount do
						Hashes[i] = (ReadString SourceFile)
				)
				FClose SourceFile
				#(BuildDate, CacheResetDate, Files, Versions, Sizes, RAWBuildDate, Hashes)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn WriteTime TargetFile FileTime = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				WriteByte TargetFile FileTime[1] #unsigned
				WriteByte TargetFile FileTime[2] #unsigned
				WriteShort TargetFile FileTime[3] #unsigned
				WriteByte TargetFile FileTime[4] #unsigned
				WriteByte TargetFile FileTime[5] #unsigned
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn WriteConfigFile UseEncryptedExtension = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local 	TypeCast = GIMS.Core.ValueOps.TypeCast,
						ConfigProps = GIMS.CurrentGame.Core.ConfigProps,
						FilesPath = GIMS.CurrentGame.FilesPath,
						AllFiles = (GetFiles (FilesPath + "*")),
						AllFileCount = AllFiles.Count,
						Files = #(),
						FileCount = 0
				Files.Count = AllFileCount
				for i = 1 to AllFileCount do (
					local	tFile = AllFiles[i],
							FileType = (GetFileNameType tFile)
					if
						FileType != ".cfg" and
						(TypeCast (GetFileNameFile tFile) name) != #Paths and (
							if UseEncryptedExtension then
								FileType != ".ms"
							else
								true
						)
					then (
						FileCount += 1
						Files[FileCount] = tFile
					)
				)
				Files.Count = FileCount
				local	TargetFile = (fopen (GIMS.CurrentGame.FilesPath + GIMS.ConfigFile) "wb")
				WriteTime TargetFile ConfigProps.RAWBuildDate
				WriteTime TargetFile ConfigProps.CacheResetDate
				WriteByte TargetFile Files.Count #unsigned
				for tFile in Files do (
					local	FileType = (GetFileNameType tFile)
					if (
						if UseEncryptedExtension then
							FileType != ".ms"
						else
							true
					) then (
						WriteString TargetFile (FileNameFromPath tFile)
						WriteLong TargetFile (TypeCast (GetFileSize tFile) Integer) #unsigned
						WriteTime TargetFile (GetTime tFile)
					)
				)
				local	GetMD5Hash = GIMS.Core.SystemMgr.GIMSOpsLib.GetMD5Hash
				for tFile in Files do
					WriteString TargetFile (GetMD5Hash tFile)
				fclose TargetFile
				free Files
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.Core.Animator*/ Animatorstr(	/*<TODO> _MultiframeMode*/
		/*Base*/
			NETTimer,
			FrameID,
		/*Start values*/
			_MultiframeMode,
			_Controls,
			_SpeedLimit,
			_Acceleration,
		/*Runtime values*/
			CurrentSpeedX,
			CurrentDistanceX,
			DistanceMultX,
			TargetDistanceX,
			CurrentSpeedY,
			CurrentDistanceY,
			DistanceMultY,
			TargetDistanceY,
			IsBusy = false,
		/*Ops*/
			fn End = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.GUIMgr.Animator.IsBusy = false
					local	AnimTimer = GIMS.Core.GUIMgr.Animator.NETTimer
					if Have AnimTimer then (
						AnimTimer.Stop()
						DotNET.RemoveAllEventHandlers AnimTimer
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn _MakePositionStep Animator Controls dX dY DistanceMultX DistanceMultY = (
				/*<ERRHANDLERSTART>*/try (
					if
						dX != 0 or
						dY != 0
					then (
						Animator.CurrentDistanceX += dX
						Animator.CurrentDistanceY += dY
						local	dXReal = (dX * DistanceMultX),
								dYReal = (dY * DistanceMultY)
						for Contr in Controls do (
							Contr.Location.x += dXReal
							Contr.Location.y += dYReal
						)
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			),
			fn _CalculateStepAndSetSpeed CurrentDistance TargetDistance Acceleration SpeedLimit &CurrentSpeed = (
				/*<ERRHANDLERSTART>*/try (
					/*accelerate*/
					local	NewSpeed = (CurrentSpeed + Acceleration)
					/*limit the speed*/
					if NewSpeed > SpeedLimit then
						NewSpeed = SpeedLimit
					/*calculate the boundary-safe step size*/
					if (CurrentDistance + NewSpeed) < TargetDistance then
						(CurrentSpeed = NewSpeed)
					else
						(TargetDistance - CurrentDistance)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			),
			fn Tick AnimTimer Args = (	/*<TODO> _MultiframeMode*/
				local	CET = unsupplied
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	GUIMgr = AnimTimer.Tag.Value,
							Animator = GUIMgr.Animator
					try (
						if Animator._MultiframeMode then (
							throw #TODO	/*<TODO>*/
							/*<TODO> use FrameID*/
							/*<TODO> null CurrentSpeedX and CurrentSpeedY after every frame if Acceleration != 0*/
						) else (
							local	CurrentDistanceX = Animator.CurrentDistanceX,
									TargetDistanceX = Animator.TargetDistanceX,
									CurrentDistanceY = Animator.CurrentDistanceY,
									TargetDistanceY = Animator.TargetDistanceY,
									XReady = (CurrentDistanceX >= TargetDistanceX),
									YReady = (CurrentDistanceY >= TargetDistanceY)
							if
								XReady and
								YReady
							then
								Animator.End()
							else (
								Animator._MakePositionStep \
									Animator \
									Animator._Controls \
									(
										if XReady then
											0
										else (
											Animator._CalculateStepAndSetSpeed \
												CurrentDistanceX \
												TargetDistanceX \
												Animator._Acceleration \
												Animator._SpeedLimit \
												&Animator.CurrentSpeedX
										)
									) \
									(
										if YReady then
											0
										else (
											Animator._CalculateStepAndSetSpeed \
												CurrentDistanceY \
												TargetDistanceY \
												Animator._Acceleration \
												Animator._SpeedLimit \
												&Animator.CurrentSpeedY
										)
									) \
									Animator.DistanceMultX \
									Animator.DistanceMultY
							)
						)
					) catch (
						CET = (GetCurrentException())
						try (
							Animator.End()
							Animator._MakePositionStep Animator Animator._Controls \
								(Animator.TargetDistanceX - Animator.CurrentDistanceX) \
								(Animator.TargetDistanceY - Animator.CurrentDistanceY) \
								Animator.DistanceMultX \
								Animator.DistanceMultY
						) catch (
							Append CET "\n>Animation: "
							Append CET (GetCurrentException())
						)
						--throw CET
					)
					if Supplied CET then
						throw CET
				/*<ERRHANDLER>*/) catch (
					try(GIMS.Core.GUIMgr.Animator.IsBusy = false) catch ()
					AnimTimer.Stop()
					local	ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
				)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn Start \
				Controls \
				DistanceX:0 \
				DistanceY:0 \
				Acceleration:5 \
				SpeedLimit:50 \
				MultiframeMode:false \
				WaitForEnd:true = \
			(
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if Acceleration < 0 then
						throw "Can't apply negative acceleration"
					local	ControlCount = Controls.Count
					if MultiframeMode then (
						if not (IsKindOf DistanceX Array) then
							throw "DistanceX isn't an array"
						if not (IsKindOf DistanceY Array) then
							throw "DistanceY isn't an array"
						if DistanceX.Count != ControlCount then
							throw "X distance count isn't equal to the control count"
						if DistanceY.Count != ControlCount then
							throw "Y distance count isn't equal to the control count"
						CurrentDistanceX = #()
						DistanceMultX = #()
						TargetDistanceX = #()
						CurrentDistanceY = #()
						DistanceMultY = #()
						TargetDistanceY = #()
						for i = ControlCount to 1 by -1 do (
							local	FrameDistanceX = DistanceX[i]
							CurrentDistanceX[i] = 0
							DistanceMultX[i] = (
								if FrameDistanceX < 0 then
									(-1)
								else
									1
							)
							TargetDistanceX[i] = (Abs FrameDistanceX)
							local	FrameDistanceY = DistanceY[i]
							CurrentDistanceY[i] = 0
							DistanceMultY[i] = (
								if FrameDistanceY < 0 then
									(-1)
								else
									1
							)
							TargetDistanceY[i] = (Abs FrameDistanceY)
						)
					) else (
						CurrentDistanceX = 0
						DistanceMultX = (
							if DistanceX < 0 then
								(-1)
							else
								1
						)
						TargetDistanceX = (Abs DistanceX)
						CurrentDistanceY = 0
						DistanceMultY = (
							if DistanceY < 0 then
								(-1)
							else
								1
						)
						TargetDistanceY = (Abs DistanceY)
					)
					_MultiframeMode = MultiframeMode
					_Controls = Controls
					_Acceleration = Acceleration
					_SpeedLimit = SpeedLimit
					FrameID = 1
					CurrentSpeedX = (
						CurrentSpeedY = (
							if Acceleration == 0 then
								SpeedLimit
							else
								0
						)
					)
					local	GUIMgr = GIMS.Core.GUIMgr
					NETTimer.Tag = (DotNETMXSValue GUIMgr)
					DotNET.AddEventHandler NETTimer "Tick" Tick
					IsBusy = true
					NETTimer.Start()
					if WaitForEnd then (
						local	UpdateMainWindow = GUIMgr.UpdateMainWindow
						while IsBusy do (
							try
								UpdateMainWindow()
							catch
								End()
						)
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
	)
	struct /*#PC*PATH	GIMS.Core.GUIMgr*/ GUIMgrstr (	/*<TODO>	scroll*/
		/*Memory management*/
			TargetHeapSize = HeapSize,
			HeapSizeGrowthStep = (1024L * 1024L * 1024L),	--1 GB
			HeapSizeGrowthMin = (1024L * 1024L),	--1 MB
		/*Parts*/
			Animator = (Animatorstr()),
		/*Props*/
			ProgressStartTime = 0,
			WindowCreateTime = 0,
			WindowControls = #(),
			DPMM = 3,
			MAXHWnd,
			ScreenResolution,
			ScreenSize = unsupplied,
			MainWindowSize = [120, 160],
			MainWindow,
			CurrentLayout,
			CurrentLayoutTitle,
			Images = #(#(), #()),
			GUIAlign,
			Align,
			TextImageRelations,
			Colors,
			Fonts,
			ControlTypes,
			ActTypes,
			Events,
		/*Disk path props*/
			LastInput = "",
			LastPath = "",
		/*Progress props*/
			IsInProgress = false,
			BarProgress, ListProgress,
			Stages = #(),
			StageID = 1,
			Progress = [-1, 0, 0],
			ProgressUpdateInterval = 200,
		/*Progress runtime values*/
			ProgressRuntime_UpdateTime = 0,
			ProgressRuntime_Progress = -1,
			ProgressRuntime_Stage = 0,
			ProgressRuntime_UpdateBar = true,
			ProgressRuntime_UpdateStage = true,
		/*PROTOTYPES*/
			fn SetWindow TargetGame Layout = (),
			fn InitMainWindow = (),
			fn InvokeEvent Game Type OriginalEvt EvtCore Sender Args = (),
		/*DPI magic*/
			ScaleMult = 1,
			fn ScaleGUICoord Val = (
				/*<ERRHANDLERSTART>*/try (
					((DPMM * Val) * ScaleMult)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			),
		/*DotNET windows*/
			fn DisposeControl Contr = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Controls = Contr.Controls,
							ControlItems = Controls.Item
					for ID = Controls.Count to 1 by -1 do
						DisposeControl ControlItems[ID - 1]
					try (
						local	Tag = Contr.Tag
						if
							Have Tag and
							Tag.Value.ItemType == 12	--ComboBox
						then
							GIMS.Core.SystemMgr.NETGC.ReRegisterForFinalize Contr
					) catch (
						if GIMS.IsDevBuild then
							Format "Can't ReRegisterForFinalize control % %: %\n" Contr Contr.Name (GetCurrentException())
					)
					try (Contr.Dispose()) catch ()
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn ReInitMainWindow = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					EGIMS_GAReportScreenView "GIMS" "Utility" "Standby"						
					local	GUIMgr = GIMS.Core.GUIMgr,
							MainWindow = GUIMgr.MainWindow
					GUIMgr.Animator.End()
					Free GUIMgr.WindowControls
					if
						(Have MainWindow) and
						(not MainWindow.IsDisposed)
					then (
						local	cCurrentLayout = GUIMgr.CurrentLayout
						if Have cCurrentLayout then (
							local	CurrentGame = GIMS.CurrentGame,
									EvtGame = cCurrentLayout.Core
							GIMS.CurrentGame = EvtGame
							GUIMgr.InvokeEvent EvtGame 2 cCurrentLayout.EvtOnClose cCurrentLayout.EvtOnCloseCore cCurrentLayout undefined
							GIMS.CurrentGame = CurrentGame
							cCurrentLayout.LastLayout = undefined
							GUIMgr.CurrentLayout = undefined
						)
						GUIMgr.DisposeControl MainWindow
					)
					GUIMgr.InitMainWindow()
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn UpdateMainWindow = (
				GIMS.ProcessPostedMessages()
			),
			fn InitMainWindow = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local GUIMgr = GIMS.Core.GUIMgr,
							WindowSize = (GUIMgr.ScaleGUICoord MainWindowSize),
							SetLifetimeController = GIMS.SetLifetimeController
					MainWindow = (DotNETObject "System.Windows.Forms.Form")
					MainWindow.BackColor = GIMS.GUI.Colour.CBlack
					MainWindow.ForeColor = GIMS.GUI.Colour.CWhite
					MainWindow.Font = GIMS.GUI.Font.Tip.Regular
					MainWindow.Text = "Game Indefinite Modding Suite Evo"
					MainWindow.Clientsize = (DotNETObject "System.Drawing.Size" WindowSize.x WindowSize.y)
					SetLifetimeController MainWindow.Clientsize #MXS
					MainWindow.FormBorderStyle = MainWindow.FormBorderStyle.FixedDialog
					MainWindow.HelpButton = false
					MainWindow.MaximizeBox = false
					MainWindow.MinimizeBox = true
					MainWindow.StartPosition = MainWindow.StartPosition.Manual
					MainWindow.Location = (DotNETObject "System.Drawing.Point" 20 ((ScreenResolution.y - WindowSize.y - 40) / 2))
					SetLifetimeController MainWindow.Location #MXS
					DotNET.AddEventHandler MainWindow "Closed" ReInitMainWindow
					GUIMgr.MainWindow = (EGIMS_MainWindow = MainWindow)
					SetLifetimeController GUIMgr.MainWindow #MXS
					GUIMgr.WindowCreateTime = (GetTimeStamp())
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
		/*Control image magic*/
			fn GetImage Action tIcon Animated Size:#(7, 7) = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Size = (GIMS.Core.GUIMgr.ScaleGUICoord [Size[1], Size[2]])
					local	ValueOps = GIMS.Core.ValueOps,
							Tag = (
								ValueOps.TypeCast (
									ValueOps.FormatText \
										v1:tIcon \
										v2:Action \
										v3:Size
								) name
							),
							BitmapID = (FindItem Images[1] Tag),
							Result,
							SetLifetimeController = GIMS.SetLifetimeController
					if BitmapID == 0 then (
						local	FilePath = (
									ValueOps.FormatText \
										v1:GIMS.Shared.FilesPath \
										v2:(tIcon as String) \
										v3:(
											if Animated then
												".gif"
											else
												".png"
										)
								),
								ImgClass = (DotNETClass "System.Drawing.Image")
						SetLifetimeController ImgClass #MXS
						if not (DoesFileExist FilePath) then
							throw ("Can't find the image " + FilePath + "!")
						Result = (ImgClass.FromFile FilePath)
						if not Animated then (
							local	NewResult = (DotNETObject "System.Drawing.Bitmap" Result Size.x Size.y)
							try (Result.Dispose()) catch ()
							Result = NewResult
						)
						SetLifetimeController Result #MXS
						Append Images[1] Tag
						Append Images[2] Result
						Result
					) else
						Images[2][BitmapID]
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ImageControl Control Action tIcon Size:#(7, 7) = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Enabled = (Action != #Disable)
					Control.Enabled = Enabled
					local	Obj = Control.Tag.Value,
							ItemType = Obj.ItemType
					if ItemType == 3 then (
						Control.BackColor = (
							if Enabled then
								Colors[1][Obj.BackColor]
							else
								GIMS.GUI.Colour.CGray
						)
					) else (
						if
							ItemType != 4 and
							ItemType != 5
						then (
							if (IsProperty Control #Image) then (
								Control.Image = (
									if tIcon != #Null then
										GetImage Action tIcon Obj.Animated Size:Size
									else
										undefined
								)
							)
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
		/*Event execution*/
			fn InvokeEvent Game Type OriginalEvt EvtCore Sender Args = (
				/*<PROFILERSTART>*//*LogProfiler #Start "InvokeEvent"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						GIMS.CanExec and
						not (Animator.IsBusy)
					then (
						local	Evt = (GIMS.Core.ValueOps.TypeCast OriginalEvt name),
								TargetGame = (
									if EvtCore == 1 then
										GIMS.Shared
									else
										Game
								)
						if Evt != #Null then (
							if Type == 1 then
								SetWindow TargetGame Evt
							else (
								local	Handler = (
											if (IsKindOf Evt Name) then
												(try (GetProperty TargetGame.Core.GUI Evt) catch ())
											else
												Evt
										)
								if No Handler then
									throw ("Can't find an event handler " + OriginalEvt as String + " in " + TargetGame.Name as String + " core!")
								else
									Handler Sender args
							)
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetNewestLayoutControls = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					/*WITH PANEL*/
					local	PanelControls = MainWindow.Controls
					PanelControls.Item[PanelControls.Count - 1].Controls
					/**/
					/*WITHOUT PANEL
					MainWindow.Controls
					/**/
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn FindControl ControlName = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					/*WITH PANEL*/
					local	PanelControls = MainWindow.Controls,
							PanelControlItems = PanelControls.Item,
							Result
					for PanelID = PanelControls.Count to 1 by -1 while No Result do (
						local	Controls = PanelControlItems[PanelID - 1].Controls,
								ControlsItem = Controls.Item
						for ID = 1 to Controls.Count while No Result do (
							local	TempControl = ControlsItem[ID - 1],
									TagValue = TempControl.Tag.Value
							if Have TagValue then (
								if
									TagValue.Name == ControlName and
									not TempControl.IsDisposed
								then
									Result = TempControl
							)
						)
					)
					/**/
					/*WITHOUT PANEL*
					local	Controls = MainWindow.Controls,
							ControlsItem = Controls.Item,
							Result
					for ID = 1 to Controls.Count while No Result do (
						local	TempControl = ControlsItem[ID - 1],
								TagValue = TempControl.Tag.Value
						if
							Have TagValue and
							TempControl.Tag.Value.Name == ControlName and
							not TempControl.IsDisposed
						then
							Result = TempControl
					)
					/**/
					if No Result then
						throw ("Can't find the item " + ControlName as String + " in layout " + CurrentLayout.Name as String + " of langpack " + GIMS.Languages[GIMS.LangID] as String + ", using core " + GIMS.CurrentGame.Name as String + "!")
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
		/*Common event handlers*/
			fn MouseEnter Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value,
								ItemType = Item.ItemType
						if
							Item.Clickable and
							ItemType != 2 and
							ItemType != 6 and
							ItemType != 7 and
							ItemType != 11
						then
							Sender.BackColor = GIMS.GUI.Colour.Accent
						GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[1] Item.EventNames[1] Item.EventCores[1] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseMove Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value
						GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[2] Item.EventNames[2] Item.EventCores[2] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseLeave Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value,
								GUIMgr = GIMS.Core.GUIMgr,
								ItemType = Item.ItemType
						GUIMgr.MainWindow.ActiveControl = undefined
						if
							Item.Clickable and
							ItemType != 2 and
							ItemType != 6 and
							ItemType != 7 and
							ItemType != 11
						then
							Sender.BackColor = GUIMgr.Colors[1][Item.BackColor]
						GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[3] Item.EventNames[3] Item.EventCores[3] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseDown Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value,
								GUIMgr = GIMS.Core.GUIMgr
						if
							args.Button.value__ == 1048576 and
							Item.Clickable
						then (
							if not Item.ChangeIcon then
								GUIMgr.ImageControl Sender #Enable Item.Icon Size:(Item.IconSize - 1)
							Sender.Location.x += 1
							Sender.Width -= 2
							Sender.Location.y += 1
							Sender.Height -= 2
						)
						GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[4] Item.EventNames[4] Item.EventCores[4] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseUp Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value,
								GUIMgr = GIMS.Core.GUIMgr
						if
							args.Button.value__ == 1048576 and
							Item.Clickable
						then (
							local	ScaleGUICoord = GIMS.Core.GUIMgr.ScaleGUICoord,
									NewSize = (ScaleGUICoord Item.ItemSize),
									NewPos = (ScaleGUICoord Item.Pos)
							if not Item.ChangeIcon then
								GUIMgr.ImageControl Sender #Enable Item.Icon Size:Item.IconSize
							Sender.Location.x = NewPos.x
							Sender.Location.y = NewPos.y
							Sender.Width = NewSize.x
							Sender.Height = NewSize.y
						)
						GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[5] Item.EventNames[5] Item.EventCores[5] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseClick Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value,
								ItemType = Item.ItemType
						if
							args.Button.value__ == 1048576 and
							Item.Clickable and
							ItemType != 2 and
							ItemType != 6 and
							ItemType != 7 and
							ItemType != 11
						then
							Sender.BackColor = GIMS.GUI.Colour.Accent
						GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[6] Item.EventNames[6] Item.EventCores[6] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn MouseWheel Sender args = (	--<TODO>	scroll subitems
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value
						--todo...
						GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[7] Item.EventNames[7] Item.EventCores[7] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn EnterText Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						Sender.ForeColor = GIMS.Core.GUIMgr.Colors[1][Sender.Tag.Value.ForeColor]
						local	Parent = Sender.Parent,
						ControlPos = (Parent.PointToScreen Sender.Location)
						GIMS.SetLifetimeController ControlPos #MXS
						CreateDialog EGIMS_TextBoxRollout Pos:[ControlPos.x, ControlPos.y] Width:Sender.Width Height:Sender.Height Style:#()
						EGIMS_TextBoxRollout.Init Sender
						local	PopupDialogs = UIAccessor.GetPopupDialogs(),
								TypeCast = GIMS.Core.ValueOps.TypeCast,
								DialogName = (TypeCast "EGIMS_TextBoxRollout" name),
								GetWindowText = UIAccessor.GetWindowText,
								Searching = true
						for HWND in PopupDialogs while Searching do (
							local	WName = (GetWindowText HWND)
							if
								(Have WName) and
								((TypeCast WName Name) == DialogName)
							then (
								GIMS.Core.SystemMgr.GIMSOpsLib.SetWindowPos HWND -1 0 0 0 0 3
								Searching = false
							)
						)
					--)
				/*<ERRHANDLER>*/) catch (
					DestroyDialog EGIMS_TextBoxRollout
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
				)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn TextEntered Sender Args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Item = Sender.Tag.Value
					GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[9] Item.EventNames[9] Item.EventCores[9] Sender args
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn SelectedIndexChanged Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						local	Item = Sender.Tag.Value
						GIMS.Core.GUIMgr.InvokeEvent GIMS.CurrentGame Item.EventTypes[8] Item.EventNames[8] Item.EventCores[8] Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn PreviewStartCheckableState Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Item = Sender.Tag.Value
					GIMS.Core.GUI.SetCheckableState Sender Item.CheckState Item:Item Preview:true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn PreviewEndCheckableState Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Item = Sender.Tag.Value
					GIMS.Core.GUI.SetCheckableState Sender Item.CheckState Item:Item
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn SwitchCheckableState Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						GIMS.Core.GUI.SwitchCheckableState Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn SwitchRadioState Sender args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if Sender.Enabled then (
						GIMS.Core.GUI.SwitchRadioState Sender args
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
		/*Layout builder*/
			fn SetItemEvents NewControl Item = (
				/*<PROFILERSTART>*//*LogProfiler #Start "SetItemEvents"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
						local	IsComboBox = (Item.ItemType == 12)
						for ID = 1 to Events[1].Count where
							Events[3][ID] or
							Item.EventNames[ID] != #Null
						do (
							if
								IsComboBox and
								ID == 8
							then
								DotNET.AddEventHandler NewControl "SelectionChangeCommitted" Events[1][ID]
							else (
								local	EventName = Events[2][ID]
								if Have EventName then
									DotNET.AddEventHandler NewControl EventName Events[1][ID]
							)
						)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn SetItem ParentControl Item StartPos = (
				local	NewControl
				/*<PROFILERSTART>*//*LogProfiler #Start "SetItem"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	RAWItemPos = (StartPos + Item.Pos),
							ItemPos, ItemSize,
							ItemType = Item.ItemType,
							ControlType = ControlTypes[1][ItemType],
							SystemMgr = GIMS.Core.SystemMgr,
							ScaleGUICoord = GIMS.Core.GUIMgr.ScaleGUICoord
					/*<PROFILERSTART>*//*LogProfiler #Start "SetItem+NewControl"; local PWS = (*//*<PROFILERSTARTED>*/
					NewControl = (
						if (MatchPattern ControlType Pattern:"*.*") then
							DotNETObject ControlType
						else
							SystemMgr.GIMSNETAssembly.CreateInstance ControlType
					)
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					/*<PROFILERSTART>*//*LogProfiler #Start "SetItem+Init"; local PWS = (*//*<PROFILERSTARTED>*/
					NewControl.Name = Item.Name
					ItemPos = (ScaleGUICoord RAWItemPos)
					NewControl.Location = (DotNETObject "System.Drawing.Point" ItemPos.x ItemPos.y)
					ItemSize = (ScaleGUICoord Item.ItemSize)
					local	ItemSizeY = ItemSize.y
					try
						NewControl.BackColor = Colors[1][Item.BackColor]
					catch
						NewControl.BackColor = ParentControl.BackColor
					NewControl.ForeColor = Colors[1][Item.ForeColor]
					NewControl.Font = Fonts[1][Item.Font]
					NewControl.Text = Item.ItemText
					if (IsProperty NewControl #ImageAlign) then
						NewControl.ImageAlign = Align[1][Item.ImageAlign]
					if (IsProperty NewControl #TextImageRelation) then
						NewControl.TextImageRelation = TextImageRelations[1][Item.TextImageRelation]
					if (IsProperty NewControl #BorderStyle) then
						NewControl.BorderStyle = NewControl.BorderStyle.None
					if
						ItemType != 12 and
						(IsProperty NewControl #FlatStyle)
					then
						NewControl.FlatStyle = NewControl.FlatStyle.Flat
					if
						ItemType != 3 and
						(IsProperty NewControl #TextAlign) 
					then
						NewControl.TextAlign = Align[1][Item.TextAlign]
					NewControl.Tag = (DotNETMXSValue Item)
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					/*<PROFILERSTART>*//*LogProfiler #Start "SetItem+Tune"; local PWS = (*//*<PROFILERSTARTED>*/
					case ItemType of (
						3: ( /*"TextBox"*/
							local	Txt = NewControl.Text,
									SeparatorPos = (FindString Txt ":"),
									Description = (TrimLeft (TrimRight (SubString Txt 1 (SeparatorPos - 1)))),
									ValueText = (TrimLeft (TrimRight (SubString Txt (SeparatorPos + 1) -1)))
							Append Description ": "
							Item.ItemContent = ValueText
							NewControl.Text = (Description + ValueText)
							try (NewControl.AutoEllipsis = true) catch ()
							DotNET.AddEventHandler NewControl "MouseClick" EnterText
							DotNET.AddEventHandler NewControl "TextChanged" TextEntered
						)
						6: ( /*"CheckBox"*/
							Item.Icon = (
								if Item.CheckState then
									#Checked
								else
									#UnChecked
							)
							DotNET.AddEventHandler NewControl "MouseDown" PreviewStartCheckableState
							DotNET.AddEventHandler NewControl "MouseUp" PreviewEndCheckableState
							DotNET.AddEventHandler NewControl "MouseLeave" PreviewEndCheckableState
							if Item.EventNames[6] == #Null then
								DotNET.AddEventHandler NewControl "MouseClick" SwitchCheckableState
						)
						7: ( /*"SwitchBox"*/
							Item.Icon = (
								if Item.CheckState then
									#SwitchLeft
								else
									#SwitchRight
							)
							DotNET.AddEventHandler NewControl "MouseDown" PreviewStartCheckableState
							DotNET.AddEventHandler NewControl "MouseUp" PreviewEndCheckableState
							DotNET.AddEventHandler NewControl "MouseLeave" PreviewEndCheckableState
							if Item.EventNames[6] == #Null then
								DotNET.AddEventHandler NewControl "MouseClick" SwitchCheckableState
						)
						8: ( /*"ProgressBar"*/
						)
						9: ( /*"ListView"*/
							NewControl.Alignment = NewControl.Alignment.Left
						)
						10: ( /*"CheckedListBox"*/
							NewControl.CheckOnClick = true
							NewControl.ThreeDCheckBoxes = false
						)
						11: ( /*"RadioBox"*/
							Item.Icon = (
								if Item.CheckState then
									#RadioOn
								else
									#RadioOff
							)
							DotNET.AddEventHandler NewControl "MouseEnter" PreviewStartCheckableState
							DotNET.AddEventHandler NewControl "MouseLeave" PreviewEndCheckableState
							if Item.EventNames[6] == #Null then
								DotNET.AddEventHandler NewControl "MouseClick" SwitchRadioState
						)
						12: ( /*"ComboBox"*/
							NewControl.DropDownStyle = NewControl.DropDownStyle.DropDownList
							local	NETGC = SystemMgr.NETGC
							NETGC.SuppressFinalize NewControl
							NETGC.KeepAlive NewControl
						)
						14: (	/*"TreeView"*/
							NewControl.CheckBoxes = false
						)
						15: (	/*"CheckedTreeView"*/
							NewControl.CheckBoxes = true
						)
						default: (
							local	IsButton = (ItemType == 2),
									IsButtonListBox = (ItemType == 13)	/*"ButtonListBox"*/
							if
								IsButtonListBox or
								ItemType == 4 or /*"ListBox"*/
								ItemType == 5 /*"CounterListBox"*/
							then (
								local	SelectionMode = NewControl.SelectionMode,
										SelectionModes = #(
											SelectionMode.None,
											SelectionMode.One,
											SelectionMode.MultiSimple
										)
								NewControl.SelectionMode = SelectionModes[Item.SelectionMode]
								if IsButtonListBox then
									NewControl.ItemColor = GIMS.GUI.Colour.Accent
							) else (
								if IsButton then ( /*"Button"*/
									local	FlatAppearance = NewControl.FlatAppearance,
											GUIColour = GIMS.GUI.Colour
									FlatAppearance.BorderSize = 0
									FlatAppearance.CheckedBackColor = GUIColour.Accent
									FlatAppearance.MouseDownBackColor = GUIColour.Accent
									FlatAppearance.MouseOverBackColor = GUIColour.Accent
								)
							)
						)
					)
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					local	Enabled = Item.DefaultState,
							Action = (
								if Enabled then
									#Enable
								else
									#Disable
							)
					/*<PROFILERSTART>*//*LogProfiler #Start "SetItem+Finalize"; local PWS = (*//*<PROFILERSTARTED>*/
					ImageControl NewControl Action Item.Icon Size:Item.IconSize
					NewControl.AutoSize = false
					NewControl.Width = ItemSize.x
					NewControl.Height = ItemSizeY
					SetItemEvents NewControl Item
					NewControl.Parent = ParentControl
					NewControl.BringToFront()
					GIMS.SetLifetimeController NewControl #DotNET
					Append WindowControls NewControl
					/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
					for SubItem in Item.SubItems where Have SubItem do
						SetItem ParentControl SubItem StartPos
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#NewControl), #(EGIMS_DumpObjectInfo NewControl)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn SetLayout AnimDirection Title:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
						local	StartPos = (
									case AnimDirection of (
										#Left:
											[MainWindowSize.x, 0]
										#Right:
											[-MainWindowSize.x, 0]
										default:
											[0, 0]
									)
								),
								HasBackButton = CurrentLayout.HasBackButton,
								BackColor = CurrentLayout.BackColor,
								ForeColor = CurrentLayout.ForeColor,
								SubItems = CurrentLayout.SubItems,
								HeaderPosX, SubItem
						for ItemID = SubItems.Count to 1 by -1 where
							Have (SubItem = SubItems[ItemID]) and (
								SubItem.Name == #NavBack or
								SubItem.Name == #Header
							)
						do
							DeleteItem SubItems ItemID
						if No Title then
							Title = CurrentLayout.ItemText
						local	GUI_Item = GIMS.Core.GUI.GUI_Item
						if HasBackButton then (
							InsertItem (GUI_Item \
								Name:#NavBack \
								BackColor:BackColor \
								ForeColor:ForeColor \
								Pos:[2, 4] \
								ItemSize:[9, 9] \
								IconSize:[7, 7] \
								Icon:#Back \
								EventCores:#(2, 2, 2, 2, 2, 1, 2, 2) \
								EventNames:#(#Null, #Null, #Null, #Null, #Null, #LastLayout, #Null, #Null) \
							) SubItems 1
							HeaderPosX = 11
						) else
							HeaderPosX = 2
						if Title.Count != 0 then (
							InsertItem (GUI_Item \
								Name:#Header \
								BackColor:BackColor \
								ForeColor:ForeColor \
								Pos:[HeaderPosX, 0] \
								ItemSize:[(MainWindowSize.x - HeaderPosX), 17] \
								ItemText:Title \
								TextAlign:CurrentLayout.HeaderTextAlign \
								Font:1 \
								Clickable:false \
							) SubItems 1
						)
						/*WITH PANEL*/
						local	ThePanel = (DotNETObject "System.Windows.Forms.Panel"),
								PanelPos = (ScaleGUICoord StartPos)
						ThePanel.Name = "ThePanel"
						ThePanel.Location = (DotNETObject "System.Drawing.Point" PanelPos.x PanelPos.y)
						local	PanelSize = (ScaleGUICoord MainWindowSize)
						ThePanel.AutoSize = false
						ThePanel.Width = PanelSize.x
						ThePanel.Height = PanelSize.y
						ThePanel.BorderStyle = ThePanel.BorderStyle.None
						ThePanel.BackColor = MainWindow.BackColor
						ThePanel.Parent = MainWindow
						GIMS.SetLifetimeController ThePanel #DotNET
						Append WindowControls ThePanel
						local	PanelItemStartPos = [0, 0]
						for Item in SubItems where Have Item do
							SetItem ThePanel Item PanelItemStartPos
						/**/
						/*WITHOUT PANEL
						for Item in SubItems where Have Item do
							SetItem MainWindow Item StartPos
						/**/
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn FindLayout Game LayoutName ForceCheck:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	TypeCast = GIMS.Core.ValueOps.TypeCast,
							WindowLayouts = Game.WindowLayouts,
							Result
					for TempLayout in WindowLayouts while No Result where TempLayout.Name == LayoutName do
						Result = TempLayout
					if
						ForceCheck and
						No Result
					then
						throw ("Can't find the layout " + LayoutName as String + " in langpack " + GIMS.Languages[GIMS.LangID] as String + " of core " + Game.Name as String + "!")
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn StringAsGUIName Str = (
				/*<ERRHANDLERSTART>*/try (
					if Str.Count == 0 then
						#Null
					else
						(GIMS.Core.ValueOps.TypeCast Str name)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			),
			fn FixItem Item AncestorPos = (
				/*<PROFILERSTART>*//*LogProfiler #Start "FixItem"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Item.Name = (StringAsGUIName Item.Name)
					Item.Icon = (StringAsGUIName Item.Icon)
					for ID = 1 to Item.EventNames.Count do
						Item.EventNames[ID] = (StringAsGUIName Item.EventNames[ID])
					Item.Pos *= [0.1, -0.1, 0.1]
					Item.Pos -= AncestorPos
					Item.ItemSize = [Item.ItemSize[1], Item.ItemSize[2]]
					Item.IconSize = [Item.IconSize[1], Item.IconSize[2]]
					for SubItem in Item.SubItems where Have SubItem do
						FixItem SubItem AncestorPos
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetLastLayoutAndCore Layout FromThat:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						FromThat and
						Layout.StoreInRolloutChain
					then 
						#(Layout, Layout.Core)
					else (
						local	LastLayout = Layout.LastLayout,
								LastCore = Layout.LastCore
						while
							Have LastLayout and
							not LastLayout.StoreInRolloutChain
						do (
								LastLayout = LastLayout.LastLayout
								LastCore = (
									if Have LastLayout then
										LastLayout.LastCore
									else
										undefined
								)
						)
						#(LastLayout, LastCore)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn SetWindow TargetGame Layout AnimDirection:undefined Title:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					IsInProgress = false
					if No TargetGame then
						throw "TargetGame undefined"
					if No Layout then
						throw "Layout undefined"
					local	NoMainWindow = (
								No MainWindow or
								MainWindow.IsDisposed
							)
					if NoMainWindow then
						InitMainWindow()
					if
						No MainWindow or
						MainWindow.IsDisposed
					then
						throw "Can't find the main window"
					if not MainWindow.Visible then
						MainWindow.Show MAXHWnd
					MainWindow.WindowState = MainWindow.WindowState.Normal
					local	GoBack = (Layout == #LastLayout),
							Controls = MainWindow.Controls,
							OldControls = #(),
							NewCore,
							NewLayout,
							FindNewLayout = true
					for i = Controls.Count to 1 by -1 do
						OldControls[i] = Controls.Item[i - 1]
					if No AnimDirection then (
						AnimDirection = (
							if GoBack then
								#Right
							else
								#Left
						)
					)
					local	CurrentGame = GIMS.CurrentGame
					if Have CurrentLayout then (
						local	EvtGame = CurrentLayout.Core
						GIMS.CurrentGame = EvtGame
						InvokeEvent EvtGame 2 CurrentLayout.EvtOnClose CurrentLayout.EvtOnCloseCore CurrentLayout undefined
						GIMS.CurrentGame = CurrentGame
						if GoBack then (
							local	LastData = (GetLastLayoutAndCore CurrentLayout),
									LastCore = LastData[2]
							NewLayout = LastData[1]
							NewCore = (
								if Have LastCore then
									LastCore
								else
									GIMS.Shared
							)
							FindNewLayout = false
						) else
							NewLayout = Layout
					) else (
						if GoBack then
							MainWindow.Close()
					)
					if FindNewLayout then (
						NewCore = TargetGame
						NewLayout = (FindLayout NewCore Layout)
						if Have CurrentLayout then (
							LastData = (GetLastLayoutAndCore CurrentLayout FromThat:true)
							NewLayout.LastLayout = LastData[1]
							NewLayout.LastCore = LastData[2]
						)
					)
						
					if Have NewLayout then (							
						CurrentLayout = NewLayout
						CurrentLayoutTitle = (if Have Title then Title else CurrentLayout.ItemText)
						EGIMS_GAReportScreenView #CurrentGameTag CurrentLayout.Name CurrentLayoutTitle
						MainWindow.SuspendLayout()
						Free WindowControls
						SetLayout AnimDirection Title:Title
						MainWindow.ResumeLayout()
						InvokeEvent NewCore 2 NewLayout.EvtOnLoad NewLayout.EvtOnLoadCore NewLayout #(#(#CallerGame), #(CurrentGame))
						local	TargetDistance = (ScaleGUICoord MainWindowSize).x,
								AllControls = #()
						for i = Controls.Count to 1 by -1 do
							AllControls[i] = Controls.Item[i - 1]
						Animator.Start \
							AllControls \
							DistanceX:(
								if GoBack then
									TargetDistance
								else
									(-TargetDistance)
							)
						if OldControls.Count != 0 then (
							MainWindow.SuspendLayout()
							for Contr in OldControls do
								DisposeControl Contr
							MainWindow.ResumeLayout()
						)
					) else (
						CurrentLayout = undefined
						MainWindow.Close()
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn LoadInterface Game = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	LangPack = (GIMS.Languages[GIMS.LangID] as String),
							GIPPath = (
								GIMS.Core.ValueOps.FormatText \
									v1:Game.FilesPath \
									v2:LangPack \
									v3:".GIP"
							),
							GameWindowLayouts = Game.WindowLayouts,
							HaveLoadedLayouts = (GameWindowLayouts.Count != 0),
							Result = (
								if HaveLoadedLayouts then
									GameWindowLayouts
								else (
									if (DoesFileExist GIPPath) then
										(FileIn GIPPath)
								)
							)
					if Have Result then (
						if not HaveLoadedLayouts then
							Game.WindowLayouts = Result
					) else
						throw ("Can't find " + LangPack + " interface package for " + Game.Name as String + " core!")
					if not HaveLoadedLayouts then (
						local	TypeCast = GIMS.Core.ValueOps.TypeCast,
								Cores = GIMS.Cores,
								CoreTagNames = #()
						for i = Cores.Count to 1 by -1 do
							CoreTagNames[i] = (TypeCast Cores[i].Tag Name)
						for Layout in Result do (
							local	CoreID = (FindItem CoreTagNames (TypeCast Layout.CoreTag Name))
							if CoreID == 0 then
								throw ("Can't find a core with tag " + Layout.CoreTag)
							Layout.Core = Cores[CoreID]
							Layout.Name = (StringAsGUIName Layout.Name)
							Layout.EvtOnLoad = (StringAsGUIName Layout.EvtOnLoad)
							Layout.EvtOnClose = (StringAsGUIName Layout.EvtOnClose)
							Layout.Pos *= [0.1, -0.1, 0.1]
							for SubItem in Layout.SubItems where Have SubItem do
								FixItem SubItem Layout.Pos
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				OK
			),
			fn SetLastLayout = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						Have CurrentLayout and
						Have CurrentLayout.LastLayout
					then
						SetWindow CurrentLayout.LastCore #LastLayout
					else (
						CurrentLayout = undefined
						MainWindow.Close()
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
		/*Progress*/
			fn EndProgress CheckResult Continueable:false CanGoBack:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					EGIMS_GAReportTiming "GUI" "Progress" CurrentLayoutTitle (((GetTimeStamp()) - ProgressStartTime) / EGIMS_DNTicksPerMillisecond)
					SysInfo.ProcessAffinity = (Bit.Set SysInfo.ProcessAffinity 1 true)
					GIMS.CanExec = true
					IsInProgress = false
					if not CanGoBack then
						CurrentLayout = undefined
					if CheckResult then
						GIMS.Core.SystemMgr.CheckResult Continueable:Continueable
					else
						GIMS.Core.GUIMgr.SetLastLayout()
					GIMS.Core.SystemMgr.DoGC()
					EGIMS_ResumeMAX()
					RedrawViews()
					ProgressEnd()
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn UpdateProgress Mode Val = (
				/*<PROFILERSTART>*//*LogProfiler #Start "UpdateProgress"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						not GIMS.CanExec and
						ProgressStartTime < WindowCreateTime
					then (
						ProgressStartTime = WindowCreateTime
						IsInProgress = false
						EGIMS_EHAbort "Operation's cancelled."
					) else (
						
						--control heap growth
						if
							(HeapSize != TargetHeapSize) and
							(HeapSizeGrowthStep > HeapSizeGrowthMin)
						then (
							TargetHeapSize = (HeapSize + HeapSizeGrowthStep)
							/*<TO DO remove, debug>*
							LogProfiler #PlainInfo "Increasing HeapSize from\t" AddParam:HeapSize
							LogProfiler #PlainInfo "\tto\t" AddParam:TargetHeapSize
							/*<>*/
							while (
								(HeapSize < TargetHeapSize) and
								(HeapSizeGrowthStep >= HeapSizeGrowthMin) and (
									try (
										HeapSize += HeapSizeGrowthStep
										false
									) catch
										true
								)
							) do
								HeapSizeGrowthStep /= 2L
							TargetHeapSize = HeapSize
							/*<TO DO remove, debug>*
							LogProfiler #PlainInfo "\tresult\t" AddParam:HeapSize
							LogProfiler #PlainInfo "\tstep\t" AddParam:HeapSizeGrowthStep
							/*<>*/
						)
						
						--update progress
						if IsInProgress then (
							case Mode of (
								#None: ()	--just pump the messages to prevent hanging
								#Progress: (
									ProgressRuntime_Progress = Val
									ProgressRuntime_UpdateBar = true
								)
								#Stage: (
									ProgressRuntime_Stage = Val
									ProgressRuntime_UpdateStage = true
									ProgressRuntime_Progress = -1
									ProgressRuntime_UpdateBar = true
								)
								#AddStage: (
									ProgressRuntime_Stage += Val
									ProgressRuntime_UpdateStage = true
									ProgressRuntime_Progress = -1
									ProgressRuntime_UpdateBar = true
								)
								Default:
									throw "Unknown mode: " Mode
							)
							local	CurrentTime = (GetTimeStamp())
							if (
								(CurrentTime - ProgressRuntime_UpdateTime) > ProgressUpdateInterval or
								ProgressRuntime_UpdateStage or
								CurrentTime < ProgressRuntime_UpdateTime
							) then (
								ProgressRuntime_UpdateTime = CurrentTime
								if ProgressRuntime_UpdateStage then (
									ProgressRuntime_UpdateStage = false
									local	StageCount = ListProgress.Items.Count
									if ProgressRuntime_Stage <= StageCount then (
										ListProgress.SelectedIndex = (ProgressRuntime_Stage - 1)
										ProgressUpdate (((100d0 / StageCount) * ProgressRuntime_Stage) as Integer)
									) --else
										--throw "Progress stage went out of bounds"
										
									--free memory if needed
									local	MaxMemUsage = 0.9,
											MemInfo = (SysInfo.GetSystemMemoryInfo()),
											RAMSize = MemInfo[2],
											RAMUsed = (RAMSize - MemInfo[3])
									if RAMUsed > (MaxMemUsage * RAMSize) then
										GIMS.Core.SystemMgr.DoGC()
									Free MemInfo
								)
								if ProgressRuntime_UpdateBar then (
									ProgressRuntime_UpdateBar = false
									local	Style = BarProgress.Style
									if ProgressRuntime_Progress == -1 then (
										local	Marquee = Style.Marquee
										if Style != Marquee then
											BarProgress.Style = Marquee
									) else (
										local	Current = ProgressRuntime_Progress[1],
												Maximum = ProgressRuntime_Progress[3]
										if Current > Maximum then (
											local	Marquee = Style.Marquee
											if Style != Marquee then
												BarProgress.Style = Marquee
										) else (
											BarProgress.Minimum = (ProgressRuntime_Progress[2] as Integer)
											BarProgress.Maximum = (Maximum as Integer)
											BarProgress.Value = (Current as Integer)
											local	Continuous = Style.Continuous
											if Style != Continuous then
												BarProgress.Style = Continuous
										)
									)
								)
								
								--pump messages to prevent hanging
								UpdateMainWindow()
							)
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn InitProgress Stages Title:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					
					--	prepare MAX
					ProgressStartTime = (GetTimeStamp())
					ProgressStart "GIMS Evo is working..."
					EGIMS_SuspendMAX()
					
					--	prepare system
					local	ProcessAffinity = SysInfo.ProcessAffinity
					if ProcessAffinity > 3 then
						SysInfo.ProcessAffinity = (Bit.Set ProcessAffinity 1 false)
						
					--	prepare UI
					SetWindow GIMS.Shared #Progress Title:Title
					BarProgress = (FindControl #ProgressBar)
					ListProgress = (FindControl #TaskList)
					GIMS.Core.GUI.SetLines ListProgress Stages
					
					--	reset runtime values
					ProgressRuntime_UpdateTime = 0
					ProgressRuntime_Stage = 0
					ProgressRuntime_Value = -1
					ProgressRuntime_UpdateBar = true
					ProgressRuntime_UpdateStage = true
					
					--	start
					UpdateProgress #None 0
					GIMS.CanExec = false
					IsInProgress = true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
		/*Init*/
			fn Init = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Events = #(
						#( /*event handlers*/
							MouseEnter,
							MouseMove,
							MouseLeave,
							MouseDown,
							MouseUp,
							MouseClick,
							MouseWheel,
							SelectedIndexChanged,
							TextEntered
						), #( /*dotnetevent names*/
							"MouseEnter",
							"MouseMove",
							"MouseLeave",
							"MouseDown",
							"MouseUp",
							"MouseClick",
							"MouseWheel",
							"SelectedIndexChanged",
							undefined
						), #(	/*add automatically*/
							true,
							false,
							true,
							true,
							true,
							true,
							false,
							false,
							false
						), #(	/*names*/
							"Mouse Enter",
							"Mouse Move",
							"Mouse Leave",
							"Mouse Down",
							"Mouse Up",
							"Mouse Click",
							"Mouse Wheel",
							"List selection",
							"Text entered"
						)
					)
					GUIAlign = GIMS.GUI.Align
					Align = #(
						#(
							GUIAlign.BottomCenter,
							GUIAlign.BottomLeft,
							GUIAlign.BottomRight,
							GUIAlign.MiddleCenter,
							GUIAlign.MiddleLeft,
							GUIAlign.MiddleRight,
							GUIAlign.TopCenter,
							GUIAlign.TopLeft,
							GUIAlign.TopRight
						), #(
							"Bottom Center",
							"Bottom Left",
							"Bottom Right",
							"Middle Center",
							"Middle Left",
							"Middle Right",
							"Top Center",
							"Top Left",
							"Top Right"
						)
					)
					local	Colour = GIMS.GUI.Colour
					Colors = #(
						#(
							Colour.CBlack,
							Colour.CWhite,
							Colour.CGray,
							Colour.Theme,
							Colour.Accent,
							Colour.Warning,
							Colour.CBlack,
							Colour.Info
						), #(
							"Black",
							"White",
							"Gray",
							"Theme",
							"Accent",
							"Warning",
							"Transparent",
							"Info"
						)
					)
					local	Font = GIMS.GUI.Font,
							SubHeader = Font.SubHeader,
							Body = Font.Body,
							TextImageRelation = (DotNETClass "System.Windows.Forms.TextImageRelation"),
							Tip = Font.Tip
					Fonts = #(
						#(
							Font.Header,
							SubHeader.Light,
							SubHeader.Regular,
							Body.Regular,
							Body.SemiBold,
							Tip.Regular,
							Tip.SemiBold
						), #(
							"Header",
							"SubHeader Light",
							"SubHeader Regular",
							"Body Regular",
							"Body SemiBold",
							"Tip Regular",
							"Tip SemiBold"
						)
					)
					TextImageRelations = #(
						#(
							TextImageRelation.Overlay,
							TextImageRelation.ImageBeforeText,
							TextImageRelation.TextBeforeImage,
							TextImageRelation.ImageAboveText,
							TextImageRelation.TextAboveImage
						), #(
							"Overlay",
							"ImageBeforeText",
							"TextBeforeImage",
							"ImageAboveText",
							"TextAboveImage"
						)
					)
					ControlTypes = #(
						#(
							"System.Windows.Forms.Label",
							"System.Windows.Forms.Button",
							"System.Windows.Forms.Label",
							"GIMSListBox",
							"GIMSCounterListBox",
							"System.Windows.Forms.Label",
							"System.Windows.Forms.Label",
							"System.Windows.Forms.ProgressBar",
							"System.Windows.Forms.ListView",
							"GIMSCheckedListBox",
							"System.Windows.Forms.Label",
							"System.Windows.Forms.ComboBox",
							"GIMSButtonListBox",
							"System.Windows.Forms.TreeView",
							"System.Windows.Forms.TreeView"
						), #(
							"Label",
							"Button",
							"TextBox",
							"ListBox",
							"ListBox with counter",
							"CheckBox",
							"SwitchBox",
							"ProgressBar",
							"ListView",
							"Checked ListBox",
							"RadioBox",
							"ComboBox",
							"Button ListBox",
							"TreeView",
							"Checked TreeView"
						)
					)
					ActTypes = #(
						"Set layout",
						"Function"
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
		/**/
	)
	struct /*#PC*PATH	GIMS.Core.SystemMgr*/ SystemMgrstr (
		/*Props*/
			NETFileIO,
			GIMSNETAssembly,
			GIMSOpsLib,
			GIMSTelemetryLib,
			NETGC,
			NETXMLReaderClass,
			NETXMLSettings,
			NETBitConverter,
			Errors = #(#(), #(), #(), #()),
			LastErrorID = 0,
			Warnings = #(#(), #(), #(), #()),
			LastWarningID = 0,
			ErrorStream = (StringStream ""),
			ErrorStreamSize = 0,
			LastError = "",
			AddInfoLevel = 0,
			--IsGCFriendly = ((MAXVersion())[1] > 11000),	--only on 2010  or later because GC deletes UI event handlers and causes unknown system exception after trying to dispose ComboBox
		/*PROTOTYPES*/
			fn ExceptionHandler ExceptionText Action = (),
		/*Ops*/
			fn FileDelete FilePath ForceCheck:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start "FileDelete"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if (DoesFileExist FilePath) then (
						local	Result = false
						for i = 1 to 3 while not Result do (
							Result = (
								(DeleteFile FilePath) and
								(not (DoesFileExist FilePath))
							)
						)
						if not Result then (
							MessageBox ("Can't delete the file\n" + FilePath + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
							if
								ForceCheck and
								(DoesFileExist FilePath)
							then
								EGIMS_EHAbort ("Can't delete the file \"" + FilePath + "\"")
						)
						Result
					) else
						true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#FilePath), #(FilePath)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn FileRename SourcePath TargetPath ForceCheck:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start "FileRename"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						ForceCheck and
						not (DoesFileExist SourcePath)
					then
						EGIMS_EHAbort ("The file \"" + SourcePath + "\" doesn't exist")
					local	Result = (
								(DoesFileExist TargetPath) and
								((GetFileSize SourcePath) == (GetFileSize TargetPath)) and
								((GetFileModDate SourcePath) == (GetFileModDate TargetPath))
							)
					if not Result then (
						if (FileDelete TargetPath ForceCheck:ForceCheck) then (
							local	FileDir = (GetFileNamePath TargetPath)
							for i = 1 to 3 while not Result do
								Result = (MakeDir FileDir All:true)
							if not Result then (
								MessageBox ("Can't create the directory\n" + FileDir + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
								if
									ForceCheck and
									not (DoesFileExist FileDir)
								then
									EGIMS_EHAbort ("Can't create the directory \"" + FileDir + "\"")
							)
							if Result then (
								Result = false
								for i = 1 to 3 while not Result do
									Result = (RenameFile SourcePath TargetPath)
								if not Result then (
									MessageBox ("Can't rename or move the file\n" + SourcePath + "\nto\n" + TargetPath + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
									if
										ForceCheck and
										not (DoesFileExist TargetPath)
									then
										EGIMS_EHAbort ("Can't rename or move the file \"" + SourcePath + "\" to \"" + TargetPath + "\"")
								)
							)
						)
					)
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#SourcePath, #TargetPath), #(SourcePath, TargetPath)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn FileCopy SourcePath TargetPath ForceCheck:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start "FileCopy"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						ForceCheck and
						not (DoesFileExist SourcePath)
					then
						EGIMS_EHAbort ("The file \"" + SourcePath + "\" doesn't exist")
					local	Result = (
								(DoesFileExist TargetPath) and
								((GetFileSize SourcePath) == (GetFileSize TargetPath)) and
								((GetFileModDate SourcePath) == (GetFileModDate TargetPath))
							)
					if not Result then (
						if (FileDelete TargetPath ForceCheck:ForceCheck) then (
							local	FileDir = (GetFileNamePath TargetPath)
							for i = 1 to 3 while not Result do
								Result = (MakeDir FileDir All:true)
							if not Result then (
								MessageBox ("Can't create the directory\n" + FileDir + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
								if
									ForceCheck and
									not (DoesFileExist FileDir)
								then
									EGIMS_EHAbort ("Can't create the directory \"" + FileDir + "\"")
							)
							if Result then (
								Result = false
								for i = 1 to 3 while not Result do
									Result = (CopyFile SourcePath TargetPath)
								if not Result then (
									MessageBox ("Can't copy the file\n" + SourcePath + "\nto\n" + TargetPath + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
									if
										ForceCheck and
										not (DoesFileExist TargetPath)
									then
										EGIMS_EHAbort ("Can't copy the file \"" + SourcePath + "\" to \"" + TargetPath + "\"")
								)
							)
						)
					)
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#SourcePath, #TargetPath), #(SourcePath, TargetPath)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CreateDir FileDir ForceCheck:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start "FileCopy"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if not (DoesFileExist FileDir) then (
						local	Result = false
						for i = 1 to 3 while not Result do
							Result = (MakeDir FileDir All:true)
						if not Result then (
							MessageBox ("Can't create the directory\n" + FileDir + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
							if
								ForceCheck and
								not (DoesFileExist FileDir)
							then
								EGIMS_EHAbort ("Can't create the directory \"" + FileDir + "\"")
						)
						Result
					) else
						true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#SourcePath, #TargetPath), #(SourcePath, TargetPath)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CreateXMLReader XMLPath &NETStream:unsupplied = (
				local	XMLReader, IOFile, FileStream, StreamReader
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					locaL	SetLifetimeController = GIMS.SetLifetimeController
					if Supplied NETStream then (
						IOFile = (DotNetClass "System.IO.File")
						SetLifetimeController IOFile #MXS
						FileStream = (IOFile.OpenRead XMLPath)
						SetLifetimeController FileStream #MXS
						StreamReader = (DotNetObject "System.IO.StreamReader" FileStream)
						SetLifetimeController StreamReader #MXS
						NETStream = StreamReader.BaseStream
						XMLReader = (NETXMLReaderClass.Create StreamReader NETXMLSettings)
					) else
						XMLReader = (NETXMLReaderClass.Create XMLPath NETXMLSettings)
					SetLifetimeController XMLReader #MXS
					XMLReader
				/*<ERRHANDLER>*/) catch (
					try (XMLReader.Dispose()) catch ()
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
						#(
							#IOFile,
							#FileStream,
							#StreamReader
						), #(
							IOFile,
							FileStream,
							StreamReader
						)
					)
				)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ReadXML XMLPath SectionName NodeHandler HandlerParam NeedProgress:false = (
				local	XMLReader
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	NETStream = (if not NeedProgress then unsupplied)
					XMLReader = (CreateXMLReader XMLPath NETStream:(&NETStream))
					if not (XMLReader.ReadToFollowing SectionName) then
						throw ("Can't find section " + SectionName + " at " + ([XMLReader.LineNumber, XMLReader.LinePosition] as String))
					NodeHandler XMLReader HandlerParam NETStream:NETStream
					try (XMLReader.Dispose()) catch ()
					OK
				/*<ERRHANDLER>*/) catch (
					try (XMLReader.Dispose())	catch ()
					local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
				)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn AddResult Mode MessageTxt AppendLast:false BufferID:undefined = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Added = false,
							ValueOps = GIMS.Core.ValueOps,
							AppendMHL = GIMS.Core.ArrayOps.AppendMHL,
							HaveAddInfo = false,
							AddInfo
					if Have BufferID then (
						local	BufferMgr = GIMS.Core.BufferMgr
						AddInfo = (
							ValueOps.FormatText \
								v1:"Occured in file \"" \
								v2:(BufferMgr.GetPath BufferID) \
								v3:"\" at " \
								v4:(BufferMgr.GetErrorInfo BufferID)
						)
						HaveAddInfo = true
					)
					case Mode of (
						#Warning: (
							if
								AppendLast and
								LastWarningID != 0
							then
								Append Warnings[1][LastWarningID] (Append "\n" MessageTxt)
							else (
								local	Result = (AppendMHL Warnings MessageTxt Sorted:false GetFlagWithID:true)
								Added = Result[1]
								LastWarningID = Result[2]
								if Added then (
									InsertItem 1 Warnings[3] LastWarningID
									if HaveAddInfo then
										InsertItem #(#(AddInfo), #(ValueOps.GetHash AddInfo)) Warnings[4] LastWarningID
									else
										InsertItem #(#(), #()) Warnings[4] LastWarningID
								) else (
									Warnings[3][LastWarningID] += 1
									if HaveAddInfo then
										AppendMHL Warnings[4][LastWarningID] AddInfo
								)
							)
						)
						#Error: (
							if
								AppendLast and
								LastErrorID != 0
							then
								Append Errors[1][LastErrorID] (Append "\n" MessageTxt)
							else (
								local	Result = (AppendMHL Errors MessageTxt Sorted:false GetFlagWithID:true)
								Added = Result[1]
								LastErrorID = Result[2]
								if Added then (
									InsertItem 1 Errors[3] LastErrorID
									if HaveAddInfo then
										InsertItem #(#(AddInfo), #(ValueOps.GetHash AddInfo)) Errors[4] LastErrorID
									else
										InsertItem #(#(), #()) Errors[4] LastErrorID
								) else (
									Errors[3][LastErrorID] += 1
									if HaveAddInfo then
										AppendMHL Errors[4][LastErrorID] AddInfo
								)
							)
						)
						Default:
							throw (Append "Unknown result type: " (Mode as String))
					)
					/*<VERBOSE_START>*//*
					if
						Added and
						GIMS.IsDevBuild
					then (
						local	Location = "UNKNOWN",
								SS = (StringStream ""),
								LevelPattern = "*level: 3*"
						Stack ShowLocals:false FirstFrameOnly:false To:SS
						Seek SS 0
						local	Searching = true,
								LineFound = false
						while (
							Searching and
							not (EOF SS)
						) do (
							local	tLine = (ReadLine SS)
							if LineFound then (
								Location = (SubString tLine 4 -1)
								Searching = false
							) else
								LineFound = (MatchPattern tLine Pattern:LevelPattern)
						)
						Free SS
						AddResult Mode (Append "> " Location) AppendLast:true
					)
					*//*<VERBOSE_END>*/
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetFoldersRecursive Folders = (
				/*<PROFILERSTART>*//*LogProfiler #Start "GetFoldersRecursive"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if not (IsKindOf Folders Array) then
						Folders = #(Folders)
					for Dir in Folders do
						Folders += (GetFoldersRecursive (GetDirectories (Dir + "*")))
					Folders
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn DoGC LightMode:true DoTwoRounds:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start "DoGC"; local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					--if IsGCFriendly then (
						local	HaveNETGC = (Have NETGC),
								NETGCCollect
						if HaveNETGC then (
							local	NETGCCollect = NETGC.Collect
							GC Light:LightMode Quiet:true
							NETGCCollect()
							if DoTwoRounds then (
								GC Light:LightMode Quiet:true
								NETGCCollect()
							)
						) else (
							GC Light:LightMode Quiet:true
							if DoTwoRounds then
								GC Light:LightMode Quiet:true
						)
					--)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn HaveResults ErrorsOnly:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if ErrorsOnly then
						(Errors[1].count != 0)
					else (
						(Warnings[1].count != 0) or
						(Errors[1].count != 0)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CheckResult Continueable:false KeepLayout:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if (HaveResults()) then
						GIMS.Core.GUIMgr.SetWindow GIMS.Shared (if Continueable then #ContinueableResults else #Results)
					else (
						local	Core = GIMS.Core
						if Continueable then (
							local	GUI = Core.GUI
							GUI.ContinueFromSelection undefined GUI.LeftButtonClickDummy
						) else (
							if not KeepLayout then
								Core.GUIMgr.SetLastLayout()
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn _ExceptionHandler_PrintValue Val CharLimit:unsupplied Target:Listener Fmt:unsupplied EscapeString:true = (
				with PrintAllElements true (
					EscapeString = (
						EscapeString and
						(IsKindOf Val String)
					)
					if
						(IsKindOf Val Array) or
						(IsKindOf Val ArrayParameter)
					then (
						local	SS = (StringStream "")
						local	ValCount = Val.Count
						if ValCount == 0 then
							Format "[%] #()" ValCount To:SS
						else (
							Format "[%] #(\n" ValCount Val To:SS
							if Supplied CharLimit then (
								for i = 1 to ValCount do (
									local	Elem = (with PrintAllElements true (Val[i] as String))
									if Elem.Count > CharLimit then
										Format "\t%,\n" (SubString Elem 1 CharLimit) To:SS
									else
										Format "\t%,\n" Elem To:SS
								)
							) else (
								for Elem in Val do with PrintAllElements true
									Format "\t%,\n" Elem To:SS
							)
							Format ")" ValCount Val To:SS
						)
						Val = (SS as String)
						Free SS
					) else
						Val = (Val as String)
					if EscapeString then (
						if Supplied Fmt then (
							if
								Supplied CharLimit and
								Val.Count > CharLimit
							then
								with PrintAllElements true(Format (Fmt + " \"%\" <...>\n") (SubString Val 1 CharLimit) To:Target)
							else
								with PrintAllElements true(Format (Fmt + " \"%\"\n") Val To:Target)
						) else (
							if
								Supplied CharLimit and
								Val.Count > CharLimit
							then
								with PrintAllElements true(Format " \"%\" <...>\n" (SubString Val 1 CharLimit) To:Target)
							else
								with PrintAllElements true(Format " \"%\"\n" Val To:Target)
						)
					) else (
						if Supplied Fmt then (
							if
								Supplied CharLimit and
								Val.Count > CharLimit
							then
								with PrintAllElements true(Format (Fmt + " % <...>\n") (SubString Val 1 CharLimit) To:Target)
							else
								with PrintAllElements true(Format (Fmt + " %\n") Val To:Target)
						) else (
							if
								Supplied CharLimit and
								Val.Count > CharLimit
							then
								with PrintAllElements true(Format " % <...>\n" (SubString Val 1 CharLimit) To:Target)
							else
								with PrintAllElements true(Format " %\n" Val To:Target)
						)
					)
				)
				OK
			),
			fn _ExceptionHandler_PrintAddInfo AddInfo TargetStream CharLimit:unsupplied = (
				if Supplied AddInfo then (
					Format "[AddInfo level %]\n" AddInfoLevel To:TargetStream
					try (
						if (IsKindOf AddInfo Array) then (
							local	Params = AddInfo[1],
									Values = AddInfo[2]
							if
								(IsKindOf Params Array) and
								(IsKindOf Values Array)
							then (
								local	PrintedValues = #(),
										PrintedValueIndices = #()
								for i = 1 to Params.Count do (
									local	Val = Values[i],
											PrintedIndex = (FindItem PrintedValues Val)
									if PrintedIndex != 0 then
										Format "%: see <%>\n" Params[i] Params[PrintedValueIndices[PrintedIndex]] To:TargetStream
									else (
										Append PrintedValues Val
										Append PrintedValueIndices i
										local	ValSuperClass = (SuperClassOf Val)
										Format "%:" Params[i] To:TargetStream
										if
											(ValSuperClass == StructDef) or
											(ValSuperClass == Material) or
											(ClassOf ValSuperClass == Node)
										then (
											Format "\n" To:TargetStream
											try (
												local	AllTagNames = (GetPropNames Val)
												for Tag in AllTagNames do (
													local	TagValue = (GetProperty Val Tag)
													if not (IsKindOf TagValue MAXScriptFunction) then (
														Format "\t%:\t" Tag To:TargetStream
														_ExceptionHandler_PrintValue TagValue Target:TargetStream CharLimit:CharLimit
													)
												)
											) catch
												_ExceptionHandler_PrintValue Val Target:TargetStream CharLimit:CharLimit
										) else
											_ExceptionHandler_PrintValue Val Target:TargetStream CharLimit:CharLimit
									)
								)
							) else
								_ExceptionHandler_PrintValue AddInfo Target:TargetStream CharLimit:CharLimit
						) else
							_ExceptionHandler_PrintValue AddInfo Target:TargetStream CharLimit:CharLimit
					) catch
						Format "<ERROR in _ExceptionHandler_PrintAddInfo>: %\n#AddInfo: %\n" (GetCurrentException()) AddInfo To:TargetStream
				)
				OK
			),
			fn ExceptionHandler ExceptionText Action StackStream:undefined Returnable:false NoMetro:false AddInfo:unsupplied = (
				EGIMS_ResumeMAX()
				try
					EGIMS_EHStoreMemInfo()
				catch ()
			
				/*TO DO remove, debug*
				LogProfiler #PlainInfo "ExceptionHandler 1:\t" AddParam:#(Action, ExceptionText, AddInfo)
				/**/
				
				/*<PROFILERSTART>*//*
					LogProfiler #Start "ExceptionHandler"
					local	ProfilerInfo = (
								local	i1 = #(#ExceptionText, #Action),
										i2 = #(ExceptionText, Action)
								if Supplied AddInfo then (
									AddInfo[1] += i1
									AddInfo[2] += i2
									AddInfo
								) else
									#(i1, i2)
							)
					LogProfiler #Info ProfilerInfo
					local	PWS = (
				*//*<PROFILERSTARTED>*/
				EGIMS_ResumeMAX()
				GIMS.CanExec = true
				ExceptionText = (ExceptionText as String)
				local	IsFirstAbort = (Action == #Abort)
				if (
					IsFirstAbort or
					(MatchPattern ExceptionText Pattern:"*<ABORT>")
				) then (
					if Action == #Report then
						CheckResult()
					else (
						local	CurEx
						try (
							if IsFirstAbort then (
							
								--remove throw parts
								local	ErrorStart = "-- Runtime error: ",
										StartIndex = (FindString ExceptionText ErrorStart)
								while (StartIndex != undefined) do (
									ExceptionText = (SubString ExceptionText (StartIndex + ErrorStart.Count) -1)
									StartIndex = (FindString ExceptionText ErrorStart)
								)
								if ExceptionText.Count > 300 then
									ExceptionText = (Append (SubString ExceptionText 1 300) " <...>")
									
								LastError = ExceptionText
								AddResult #Error ExceptionText
							)
						) catch
							CurEx = (GetCurrentException())
						if Have CurEx then
							throw "Error in abort handler: " CurEx
						
						/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
						throw "<ABORT>"
					)
				) else (
					local	IsFirstThrow = (not (MatchPattern ExceptionText Pattern:"*<THROW>*")),
							CurEx
						
					/*TO DO remove, debug*
					LogProfiler #PlainInfo "ExceptionHandler 2:\t" AddParam:#(IsFirstThrow, ExceptionText, AddInfo)
					/**/
				
					try (
						local	IsDevBuild = (try GIMS.IsDevBuild catch false)
						--remove throw parts
						local	ErrorStart = "-- Runtime error: ",
								StartIndex = (FindString ExceptionText ErrorStart)
						while (StartIndex != undefined) do (
							ExceptionText = (SubString ExceptionText (StartIndex + ErrorStart.Count) -1)
							StartIndex = (FindString ExceptionText ErrorStart)
						)
						if ExceptionText.Count > 300 then
							ExceptionText = (Append (SubString ExceptionText 1 300) " <...>")
							
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 3:\t" AddParam:#(ExceptionText, AddInfo)
						/**/
					
						if IsFirstThrow then (
							AddInfoLevel = 0
							LastError = (ExceptionText as String)
							local	OldErrorStream = (
										if (ErrorStreamSize < 2) then (
											ErrorStreamSize += 1
											(ErrorStream as String)
										)
									)
							Free ErrorStream
							Format "[ERROR]\n%\n" LastError To:ErrorStream
							Format "[STACK]\n" To:ErrorStream
							if No StackStream then (
								StackStream = (StringStream "")
								Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:false To:StackStream
							)
								
							/*TO DO remove, debug*
							LogProfiler #PlainInfo "ExceptionHandler 4:\t" AddParam:#(ExceptionText, AddInfo)
							/**/
					
							local	CETPattern = "--\t\t\tCET: *",
									ESSPattern = "--\t\t\tESS: *",
									Reading = true
							Seek StackStream 0
							while
								Reading and
								not (EOF StackStream)
							do (
								local	tLine = (ReadLine StackStream)
								if
									not (MatchPattern tLine Pattern:CETPattern) and
									not (MatchPattern tLine Pattern:ESSPattern)
								then (
									if tLine == "--\t\tExternals:" then
										Reading = false
									else (
										local	LineStart = (SubString tLine 1 2)
										if
											(LineStart == "--") or
											(LineStart == "**")
										then
											_ExceptionHandler_PrintValue tLine Target:ErrorStream EscapeString:false
									)
								)
							)
							Free StackStream
							if Have OldErrorStream then
								Format "\n[OldErrorStream]\n\n%" OldErrorStream To:ErrorStream
						)
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 5:\t" AddParam:#(ExceptionText, AddInfo)
						/**/
					
						_ExceptionHandler_PrintAddInfo AddInfo ErrorStream CharLimit:(if IsDevBuild then unsupplied else 300)
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 6:\t" AddParam:#(ExceptionText, AddInfo)
						/**/
					
						local	esPath = ((GIMS.Shared.BackupPath as String) + "ErrorStream.txt")
						if IsFirstThrow then (
							try
								GIMS.Core.GUIMgr.MainWindow.Close()
							catch (
								try (EGIMS_MainWindow.Close()) catch ()
							)
							local	strErrorStream = (ErrorStream as String)
							SetClipboardText strErrorStream
							local	fsErrorStream
							try (
								DeleteFile esPath
								fsErrorStream = (CreateFile esPath)
								if Have fsErrorStream then
									Print strErrorStream To:fsErrorStream
							) catch ()
							if Have fsErrorStream then
								Close fsErrorStream
							--if IsDevBuild then (
								try (
									esPath = ((GIMS.Shared.BackupPath as String) + "ErrorStream.FULL.txt")
									DeleteFile esPath
									fsErrorStream = (CreateFile esPath)
									if Have fsErrorStream then
										Stack ShowLocals:true FirstFrameOnly:false To:fsErrorStream
								) catch ()
								if Have fsErrorStream then
									Close fsErrorStream
							--)
						) else (
							local	fsErrorStream
							try (
								fsErrorStream = (OpenFile esPath Mode:"at")
								if Have fsErrorStream then
									_ExceptionHandler_PrintAddInfo AddInfo fsErrorStream CharLimit:(if IsDevBuild then 10000 else 300)
							) catch ()
							if Have fsErrorStream then
								Close fsErrorStream
						)
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 7:\t" AddParam:#(ExceptionText, AddInfo)
						/**/
					
						AddInfoLevel += 1
						if Action == #Report then (
							if (MatchPattern LastError Pattern:"*OutOfMemory*") then (
								/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
								throw "Your system has ran out of memory, retry last operation after restarting 3D MAX or resetting the scene."
							)
							if (MatchPattern LastError Pattern:"*Memory alloc*") then (
								/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
								throw "Your system has ran out of memory, retry last operation after restarting 3D MAX or resetting the scene."
							)
							if (MatchPattern LastError Pattern:"*not enough space on the disk*") then (
								/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
								throw "Not enough space on the disk, operation aborted."
							)
							if IsDevBuild then
								MessageBox ("An error has occured.\nThe information's copied to the clipboard, and saved here:\n\t" + esPath)
							DestroyDialog EGIMS_ReportRollout
							if NoMetro then
								CreateDialog EGIMS_ReportRollout
							else (
									
							/*TO DO remove, debug*
							LogProfiler #PlainInfo "ExceptionHandler 8:\t" AddParam:#(ExceptionText, AddInfo)
							/**/
					
								local	GUIMgr = GIMS.Core.GUIMgr
								GUIMgr.ReInitMainWindow()
								GUIMgr.SetWindow GIMS.Shared (if Returnable then #ReturnableReport else #Report)
							)
							ErrorStreamSize = 0
						)
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 9:\t" AddParam:#(ExceptionText, AddInfo)
						/**/
					
					) catch
						CurEx = (GetCurrentException())
							
					/*TO DO remove, debug*
					LogProfiler #PlainInfo "ExceptionHandler 10:\t" AddParam:#(ExceptionText, AddInfo)
					/**/
					
					if Have CurEx then (
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 11:\t" AddParam:#(CurEx, AddInfo)
						/**/
						
						Format "Error in exception handler: %\n" CurEx To:ErrorStream
						local	fsErrorStream
						try (
							fsErrorStream = (OpenFile esPath Mode:"at")
							if Have fsErrorStream then
								Format "Error in exception handler: %\n" fsErrorStream To:ErrorStream
						) catch ()
						if Have fsErrorStream then
							Close fsErrorStream
						try (
							CreateDialog EGIMS_ReportRollout
							ErrorStreamSize = 0
						) catch
							MessageBox ("An error has occured.\nThe information's in the clipboard, and here:\n\t" + esPath)
						/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
					)
					if Action != #Report then (						
								
						/*TO DO remove, debug*
						LogProfiler #PlainInfo "ExceptionHandler 12:\t" AddParam:#(CurEx, AddInfo)
						/**/
						
						/*<PROFILEREND>*//*LogProfiler #UnwindStack 0*//*<PROFILERENDED>*/
						if IsFirstThrow then
							throw "<THROW>: " ExceptionText
						else
							throw ExceptionText
					)
				)
				OK
				
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetFileMD5 tFile = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if (DoesFileExist tFile) then
						(GIMS.Core.ValueOps.TypeCast (GIMSOpsLib.GetMD5Hash tFile) name)
					else
						EGIMS_EHAbort ("Can't find file \"" + tFile + "\"")
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn IncludeFiles = (
				local	ErrorText = ""
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	ValueOps = GIMS.Core.ValueOps,
							TypeCast = ValueOps.TypeCast,
							Files = GIMS.CurrentGame.Core.ConfigProps.Files,
							FilesPath = GIMS.CurrentGame.FilesPath,
							CoreFileName = (TypeCast GIMS.CoreFile name),
							FormatText = ValueOps.FormatText,
							ProcessPostedMessages = GIMS.ProcessPostedMessages,
							IsDevBuild = GIMS.IsDevBuild,
							ExtDev = GIMS.ScriptExtDev,
							ExtEnc = GIMS.ScriptExtEnc,
							FileExt = (if IsDevBuild then ExtDev else ExtEnc)
					Format "Including files\n" To:GIMS.Core.CoreOps.UpdateStream
					for i = 1 to Files.count do (
						ProcessPostedMessages()
						local	File = Files[i],
								FileName = (GetFileNameFile File),
								FileType = (GetFileNameType File)
						if
							(TypeCast FileName Name) != CoreFileName and
							(
								(FileType == ExtDev) or
								(FileType == ExtEnc)
							) and
							(not (MatchPattern FileName Pattern:"I_*"))
						then (
							local	FilePath = (FilesPath + FileName + FileExt)
							if
								(not IsDevBuild) or
								(not (DoesFileExist FilePath))
							then
								FilePath = (FilesPath + FileName + ExtEnc)
								
							/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
							/*<ERRHANDLERSTART>*/try (
								FileIn FilePath
							/*<ERRHANDLER>*/) catch (
								local	CET = (GIMS.CurrentGame.Name + " " + FileName + ": " + GetCurrentException())
								local	ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
							)/*<ERRHANDLEREND>*/
							/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CheckFiles = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	FilesPath = GIMS.CurrentGame.FilesPath,
							ConfigProps = GIMS.CurrentGame.Core.ConfigProps,
							Files = ConfigProps.Files,
							Sizes = ConfigProps.Sizes,
							FileCount = Files.Count,
							GetMD5Hash = GIMSOpsLib.GetMD5Hash,
							Result = (StringStream "")
					if IsProperty ConfigProps #Hashes then (
						local	Hashes = ConfigProps.Hashes
						for i = 2 to FileCount do (
							local	tFile = (FilesPath + Files[i])
							if not (DoesFileExist tFile) then
								Format "File % doesn't exist.\n" tFile To:Result
							else (
								if
									not GIMS.IsDevBuild and (
										(GetFileSize tFile) != Sizes[i] or (
											Have Hashes[i] and
											(GetMD5Hash tFile) != Hashes[i]
										)
									)
								then
									Format "File % is corrupted.\n" tFile To:Result
							)	
						)
					) else (
						for i = 2 to FileCount do (
							local	tFile = (FilesPath + Files[i])
							if not (DoesFileExist tFile) then
								Format "File % doesn't exist.\n" tFile To:Result
							if
								not GIMS.IsDevBuild and
								(GetFileSize tFile) != Sizes[i]
							then
								Format "File % is corrupted.\n" tFile To:Result
						)
					)
					Result = (Result as String)
					if Result.Count != 0 then
						Result
					else
						true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
	)
	struct /*#PC*PATH	GIMS.Core.CoreOps*/ CoreOpsstr (
		UpdateStream = (StringStream ""),
			fn FirstLaunchCleanup = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn TryGetGameDB GameTag TryLoading:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Game = (TryGetProperty GIMS GameTag Failsafe:unsupplied)
					if Supplied Game then (
						local	DB = unsupplied
						if
							Have Game and
							Game.Loaded
						then (
							local	Core = Game.Core
							if Have Core then
								DB = Core.DB
						)
						if
							Supplied DB and
							DB.Loaded
						then
							DB
						else (
							/*
							try (
								if TryLoading then (
									Game.Start Game NoEH:true
									TryGetGameDB GameTag TryLoading:false
								) else
									unsupplied
							) catch
							*/
								unsupplied
						)
					) else
						unsupplied
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn TryGetGameMAXFactory GameTag = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Game = (TryGetProperty GIMS GameTag Failsafe:unsupplied)
					if Supplied Game then (
						local	MAXFactory = unsupplied
						if
							Have Game and
							Game.Loaded
						then (
							local	Core = Game.Core
							if Have Core then
								MAXFactory = Core.MAXFactory
						)
						if Supplied MAXFactory then
							MAXFactory
						else (
							/*
							try (
								Game.Start Game
								Game.Core.MAXFactory
							) catch
							*/
								unsupplied
						)
					) else
						unsupplied
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn InitGUI = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	GUIMgr = GIMS.Core.GUIMgr
					GUIMgr.InitMainWindow()
					GUIMgr.LoadInterface GIMS.CurrentGame
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CompileDOTNetAssembly \
				sourceString \
				referencedAssemblyNames:#() \
				compilerOptions: "/unsafe /optimize" \
			= (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	csharpProvider = (DOTNETObject "Microsoft.CSharp.CSharpCodeProvider"),
							compilerParams = (DOTNETObject "System.CodeDom.Compiler.CompilerParameters"),
							referencedAssemblies = compilerParams.ReferencedAssemblies,
							SetLifetimeController = GIMS.SetLifetimeController
					SetLifetimeController csharpProvider #MXS
					SetLifetimeController compilerParams #MXS
					
					for ran in referencedAssemblyNames do
						referencedAssemblies.Add ran
					compilerParams.GenerateInMemory = true
					compilerParams.GenerateExecutable = false
					compilerParams.IncludeDebugInformation = false
					compilerParams.CompilerOptions = compilerOptions
					
					local	compilerResults = (csharpProvider.CompileAssemblyFromSource compilerParams #(sourceString))
					
					local	errors = compilerResults.Errors
					if errors.HasErrors then (
						local errStr = (StringStream ""),
								items = errors.Item
						for i = 0 to (errors.Count - 1) do (
							local	Item = items[i]
							Format "Line % column %: Error % - %\n" Item.Line Item.Column Item.ErrorNumber Item.ErrorText To:errStr
						)
						throw (errStr as String)
					)
					
					local	assembly = (compilerResults.CompiledAssembly)
					SetLifetimeController assembly #MXS
					assembly
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn InitDOTNet Setup:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	SystemMgr = GIMS.Core.SystemMgr,
							GUIMgr = GIMS.Core.GUIMgr,
							NETFileIO = (DotNETClass "System.IO.File"),
							NETGC = (DotNETClass "System.GC"),
							NETBitConverter = (DotNETClass "System.BitConverter"),
							SetLifetimeController = GIMS.SetLifetimeController
					if No NETFileIO then
						throw "Can't initialize NETFileIO! Try to update your .NET runtime"
					if No NETGC then
						throw "Can't initialize NETGC! Try to update your .NET runtime"
					SetLifetimeController NETFileIO #MXS
					SetLifetimeController NETGC #MXS
					SetLifetimeController NETBitConverter #MXS
					SystemMgr.NETFileIO = NETFileIO
					SystemMgr.NETGC = NETGC
					SystemMgr.NETBitConverter = NETBitConverter
					
					local	GIMSNETAssemblySource = ("
							using System;
							using System.IO;
							using System.Net;
							using System.Text;
							using System.Text.RegularExpressions;
							using System.Drawing;
							using System.Security.Cryptography;
							using System.Runtime.InteropServices;
							using System.Windows.Forms;
							using System.ComponentModel;
							using System.Globalization;
							using System.Threading;
							using System.Collections.Generic;
							using Microsoft.Win32;

							public class GIMSTelemetry {
								private static string UUID = null,
														CultureName = null,
														UserAgent = null,
														ScreenSize = null,
														ViewSize = null;

								private static string lineStart = @\"\\s*[\\*\\-]{2}\\s*\";
								private static string callPattern = @\"\\s+(?:([^\\;]*)\\;?)\\s*(?:(filename)\\:\\s*([^\\;]*)\\;?\\s*)(?:(position)\\:\\s*([^\\;]*)\\;?\\s*)?(?:(line)\\:\\s*([^\\;]*)\\;?\\s*)?\";
								private static Regex rgx_ThreadID = new Regex(lineStart + @\".*threadID\\:(.*)\", RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);
								private static Regex rgx_StackLevel = new Regex(lineStart + @\"\\[stack\\slevel\\: (.*)\\]\", RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);
								private static Regex rgx_CalledFrom = new Regex(lineStart + @\"called\\sfrom\" + callPattern, RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);
								private static Regex rgx_CalledIn = new Regex(lineStart + @\"called\\sin\" + callPattern, RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);
								private static Regex rgx_OccuredIn = new Regex(lineStart + @\"occured\\sin\" + callPattern, RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);
								private static Regex rgx_In = new Regex(lineStart + @\"in\" + callPattern, RegexOptions.Compiled | RegexOptions.IgnoreCase /*| RegexOptions.CultureInvariant*/);

								private enum GAEventType {
									Exception,
									Timing,
									PageView,
									ScreenView,
									Event
								}

								private class TelemetryFrame {
									public GAEventType eventType;
									public long eventTime;
									public string appTag;
									public string baseAppVersion;
									public string appVersion;
									public string p1;
									public string p2;
									public string p3;
									public int ip1;
									public string stackText;

									public TelemetryFrame(
										GAEventType ineventType,
										long ineventTime,
										string inappTag,
										string inbaseAppVersion,
										string inappVersion,
										string inp1,
										string inp2,
										string inp3,
										int inip1,
										string instackText
									) {
										eventType = ineventType;
										eventTime = ineventTime;
										appTag = inappTag;
										baseAppVersion = inbaseAppVersion;
										appVersion = inappVersion;
										p1 = inp1;
										p2 = inp2;
										p3 = inp3;
										ip1 = inip1;
										stackText = instackText;
									}
								}

								private static string LimitString(string txt, int limit) {
									if (txt.Length <= limit)
										return txt;
									return String.Format(\"{0} <...>\", txt.Substring(0, limit - 6));
															}

								private static string GASend(TelemetryFrame data) {
									StringBuilder payload = new StringBuilder(512);
									string eventName = null;
									switch (data.eventType) {
										case GAEventType.Exception: {
											eventName = \"exception\";
																		payload.AppendFormat(\"&exd={0}\", LimitString(Uri.EscapeDataString(data.p1), 150));
																		payload.AppendFormat(\"&exf={0}\", data.ip1);
																	}
										break;
										case GAEventType.Timing: {
											eventName = \"timing\";
																		payload.AppendFormat(\"&utc={0}\", LimitString(Uri.EscapeDataString(data.p1), 150));
																		payload.AppendFormat(\"&utv={0}\", LimitString(Uri.EscapeDataString(data.p2), 500));
																		payload.AppendFormat(\"&utt={0}\", data.ip1);
																		payload.AppendFormat(\"&utl={0}\", LimitString(Uri.EscapeDataString(data.p3), 500));
																	}
										break;
										case GAEventType.PageView: {
											eventName = \"pageview\";
																		if (data.p2.StartsWith(\"/\"))
																			payload.AppendFormat(\"&dl={0}\", LimitString(Uri.EscapeDataString(data.p1 + data.p2), 2048));
																		else
																			payload.AppendFormat(\"&dl={0}\", LimitString(Uri.EscapeDataString(String.Format(\"{0}/{1}\", data.p1, data.p2)), 2048));
																		payload.AppendFormat(\"&dt={0}\", LimitString(Uri.EscapeDataString(data.p3), 1500));
																	}
										break;
										case GAEventType.ScreenView: {
											eventName = \"screenview\";
																		string title;
											if (data.p2.StartsWith(\"/\"))

												payload.AppendFormat(\"&dl={0}\", LimitString(Uri.EscapeDataString(data.p1 + data.p2), 2048));
																		else

												payload.AppendFormat(\"&dl={0}\", LimitString(Uri.EscapeDataString(String.Format(\"{0}/{1}\", data.p1, data.p2)), 2048));

											payload.AppendFormat(\"&cd={0}\", LimitString(Uri.EscapeDataString(String.Format(\"{0} {1} ({2})\", data.p1, data.p3, data.p2)), 2048));
																	}
										break;
										case GAEventType.Event: {
											eventName = \"event\";
																		payload.AppendFormat(\"&ec={0}\", LimitString(Uri.EscapeDataString(data.p1), 150));
																		payload.AppendFormat(\"&ea={0}\", LimitString(Uri.EscapeDataString(data.p2), 500));
																		payload.AppendFormat(\"&el={0}\", LimitString(Uri.EscapeDataString(data.p3), 500));
																		if (data.ip1 < 0)
												return (String.Format(\"Параметр ev должен быть положительным: {0}\", data.ip1));

											payload.AppendFormat(\"&ev={0}\", data.ip1);
																	}
										break;
										default:
										throw new Exception(String.Format(\"Неизвестное значение eventType: {0}\", data.eventType));
																}
									int delta = DateTime.UtcNow.Subtract(new DateTime(data.eventTime)).Milliseconds;
									payload.AppendFormat(
																		\"&an=GIMS&ul={0}&aid={1}&av={2}&ua={3}&sr={4}&vp={5}\",

											CultureName,
											LimitString(Uri.EscapeDataString(data.appTag), 150),
											LimitString(Uri.EscapeDataString(String.Format(\"{0} @ {1}\", data.appVersion, data.baseAppVersion)), 100),

											UserAgent,
											ScreenSize,
											ViewSize
									);
									if (!String.IsNullOrEmpty(data.stackText)) {
										StringBuilder ss = new StringBuilder(data.stackText.Length);
										ss.Append(\"&ds=\");
										using (StringReader sr = new StringReader(data.stackText)) {
											while (true) {
												string tLine = sr.ReadLine();
												if (tLine == null)
													break;
												tLine = tLine.Trim();

												Match mTID = rgx_ThreadID.Match(tLine);
												if (mTID.Success) {
													ss.AppendFormat(\"|TID:{0}\", mTID.Groups[1].Value);
													continue;
												}
												Match mSL = rgx_StackLevel.Match(tLine);
												if (mSL.Success) {
													ss.AppendFormat(\"|SL {0}\", mSL.Groups[1].Value);
													continue;
												}

												Match match = null;
												Match m1 = rgx_CalledFrom.Match(tLine);
												if (m1.Success)
													match = m1;
												else {
													Match m2 = rgx_CalledIn.Match(tLine);
													if (m2.Success)
														match = m2;
													else {
														Match m3 = rgx_OccuredIn.Match(tLine);
														if (m3.Success)
															match = m3;
														else {
															Match m4 = rgx_In.Match(tLine);
															if (m4.Success)
																match = m4;
														}
													}
												}
												if (match != null) {
													bool parsed = false;
													if (!String.IsNullOrEmpty(match.Groups[2].Value.Trim())) {
														ss.AppendFormat(\";{0}\", match.Groups[1].Value);
														string filepath = match.Groups[3].Value;
														int start = 0;
														int count = 3;
														for (int i = filepath.Length - 1; i > 0; i--) {
															if (
																(filepath[i] == Path.AltDirectorySeparatorChar) ||
																(filepath[i] == Path.DirectorySeparatorChar)
															) {
																count--;
																if (count == 0) {
																	start = (i + 1);
																	break;
																}
															}
														}
														ss.AppendFormat(\";F {0}\", filepath.Substring(start));
														parsed = true;
													}
													if (!String.IsNullOrEmpty(match.Groups[4].Value.Trim())) {
														ss.AppendFormat(\";P {0}\", match.Groups[5].Value);
														parsed = true;
													}
													if (!String.IsNullOrEmpty(match.Groups[6].Value.Trim())) {
														ss.AppendFormat(\";L {0}\", match.Groups[7].Value);
														parsed = true;
													}
													if (!parsed)
														ss.AppendFormat(\";{0}\", match.Groups[1].Value);
													continue;
												}
											}
										}
										payload.Append(Uri.EscapeDataString(ss.ToString()));
									}
									HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(
										String.Format(
																		\"https://www.google-analytics.com/collect?v=1&tid=UA-72729920-1&cid={0}&t={1}&qt={2}&aiid={3}{4}\",
																		UUID,
											eventName,
											(delta > 0) ? delta : 0,
											UUID,
											payload
										)
									);
									request.Method = \"POST\";
									request.ProtocolVersion = HttpVersion.Version11;
									request.Timeout = 10000;
									request.ContentLength = 0;
									try {
										using (WebResponse response = request.GetResponse()) {
											return null;
										}
									} catch (WebException we) {
										return String.Format(\"{0};{1};{2}\", we.Status, we.Response, we.Message);
																}
								}

								private static Thread TelemetryThread = null;
								private static bool TelemetryEnabled = true;
								private static Mutex TelemetryMutex = new Mutex();
								private static Queue<TelemetryFrame> TelemetryQueue = new Queue<TelemetryFrame>();
								private static Mutex InfoMutex = new Mutex();
								private static List<string> TelemetryErrors = new List<string>(10);

								public static void Start(string inUUID, string baseAppVersion, string userAgent, string screenSize, string viewSize) {
									Stop(baseAppVersion);
									UUID = Uri.EscapeDataString(inUUID);
									CultureName = LimitString(Uri.EscapeDataString(CultureInfo.CurrentCulture.Name), 20);
									ScreenSize = LimitString(screenSize, 20);
									ViewSize = LimitString(viewSize, 20);
									UserAgent = String.Format(\"{0}@Win-{1}\", Uri.EscapeDataString(userAgent), Uri.EscapeDataString((string)Registry.GetValue(\"HKEY_LOCAL_MACHINE\\\\SOFTWARE\\\\Microsoft\\\\Windows NT\\\\CurrentVersion\", \"CurrentBuild\", \"WindowsVersionError\")));

									TelemetryThread = new Thread(new ThreadStart(ProcessTelemetry));
									TelemetryThread.Start();
									TelemetryEnabled = true;
									GAReportEvent(\"3DsMax\", userAgent, baseAppVersion, \"Telemetry\", \"Start\", userAgent, 0);
								}
								public static void Stop(string baseAppVersion) {
									if (TelemetryThread != null) {
										TelemetryEnabled = false;
										while (TelemetryThread.IsAlive)
											Thread.Sleep(10);
										TelemetryThread = null;
									}
								}

								private static void ProcessTelemetry() {
									try {
										while (true) {
											TelemetryMutex.WaitOne();
											TelemetryFrame data = null;
											if (TelemetryQueue.Count != 0)
												data = TelemetryQueue.Dequeue();
											TelemetryMutex.ReleaseMutex();
											if (data != null) {
												string error = GASend(data);
												if (!String.IsNullOrEmpty(error)) {
													InfoMutex.WaitOne();
													TelemetryErrors.Add(error);
													InfoMutex.ReleaseMutex();
												}
											} else {
												if (!TelemetryEnabled)
													break;
												Thread.Sleep(100);
											}
										}
									} catch (ThreadAbortException) {
									}
								}

								public static string[] GetErrors() {
									InfoMutex.WaitOne();
									string[] result = TelemetryErrors.ToArray();
									InfoMutex.ReleaseMutex();
									return result;
								}

								public static void GAReportException(string appTag, string baseAppVersion, string appVersion, string exceptionText, bool isFatal, string stackText) {
									if (!TelemetryEnabled)
										return;
									TelemetryMutex.WaitOne();
									TelemetryQueue.Enqueue(new TelemetryFrame(GAEventType.Exception, DateTime.UtcNow.Ticks, appTag, baseAppVersion, appVersion, exceptionText, null, null, (isFatal ? 1 : 0), stackText));

									TelemetryMutex.ReleaseMutex();
								}
								public static void GAReportTiming(string appTag, string baseAppVersion, string appVersion, string category, string action, string label, int timing) {
									if (!TelemetryEnabled)
										return;
									TelemetryMutex.WaitOne();
									TelemetryQueue.Enqueue(new TelemetryFrame(GAEventType.Timing, DateTime.UtcNow.Ticks, appTag, baseAppVersion, appVersion, category, action, label, timing, null));
									TelemetryMutex.ReleaseMutex();
								}
								public static void GAReportPageView(string appTag, string baseAppVersion, string appVersion, string parent, string page, string title) {
									if (!TelemetryEnabled)
										return;
									TelemetryMutex.WaitOne();
									TelemetryQueue.Enqueue(new TelemetryFrame(GAEventType.PageView, DateTime.UtcNow.Ticks, appTag, baseAppVersion, appVersion, parent, page, title, 0, null));
									TelemetryMutex.ReleaseMutex();
								}
								public static void GAReportScreenView(string appTag, string baseAppVersion, string appVersion, string parent, string page, string title) {
									if (!TelemetryEnabled)
										return;
									TelemetryMutex.WaitOne();
									TelemetryQueue.Enqueue(new TelemetryFrame(GAEventType.ScreenView, DateTime.UtcNow.Ticks, appTag, baseAppVersion, appVersion, parent, page, title, 0, null));
									TelemetryMutex.ReleaseMutex();
								}
								public static void GAReportEvent(string appTag, string baseAppVersion, string appVersion, string category, string action, string label, int eventValue) {
									if (!TelemetryEnabled)
										return;
									TelemetryMutex.WaitOne();
									TelemetryQueue.Enqueue(new TelemetryFrame(GAEventType.Event, DateTime.UtcNow.Ticks, appTag, baseAppVersion, appVersion, category, action, label, eventValue, null));
									TelemetryMutex.ReleaseMutex();
								}

							}

							public class GIMSOps {
								private static System.Security.Cryptography.MD5CryptoServiceProvider MD5Hasher = new System.Security.Cryptography.MD5CryptoServiceProvider();
								
								[DllImport(\"User32.dll\")]
								public static extern IntPtr GetWindow(IntPtr hWnd, int uCmd);
								[DllImport(\"User32.dll\")]
								public static extern IntPtr GetDlgItem(IntPtr hDlg, int nIDDlgItem);
								[DllImport(\"User32.dll\")]
								public static extern IntPtr GetNextDlgGroupItem(IntPtr hDlg, IntPtr hCtl, Boolean bPrevious);
								[DllImport(\"User32.dll\")]
								public static extern bool SetWindowPos(Int64 hWnd, int hWndArg, int Left, int Top, int Width, int Height, int hWndFlags);
								[DllImport(\"gdi32.dll\")]
								static extern int GetDeviceCaps(IntPtr hdc, int nIndex);
								public enum DeviceCap {
									HORZSIZE = 4,
									VERTSIZE = 6
								}  
								public void GetGraphicsInfo(ref int w, ref int h) {
									using (Graphics g = Graphics.FromHwnd(IntPtr.Zero)) {
										IntPtr desktop = g.GetHdc();
										w = GetDeviceCaps(desktop, (int)DeviceCap.HORZSIZE);
										h = GetDeviceCaps(desktop, (int)DeviceCap.VERTSIZE);
									}
								}			
								private static FileStream GetFileStream(String pathName) {
									return (new FileStream(pathName, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
								}
								public static int GetJenkinsHash(string str, bool ignoreCase) {
									if (
										(String.IsNullOrEmpty(str)) ||
										(String.Compare(str, \"NULL\", true, CultureInfo.InvariantCulture) == 0)
									)
										return 0;
									string s = (ignoreCase ? str.ToLower() : str);
									uint hash = 0;
									for (int i = 0; i < s.Length; i++) {
										hash += s[i];
										hash += hash << 10;
										hash ^= hash >> 6;
									}
									hash += hash << 3;
									hash ^= hash >> 11;
									hash += hash << 15;
									return (int)hash;
								}
								public static String GetMD5Hash(String pathName) {
									using (System.IO.FileStream oFileStream = GetFileStream(pathName)) {
										byte[] bytes = MD5Hasher.ComputeHash(oFileStream);
										StringBuilder s = new StringBuilder(bytes.Length * 2);
										for (int i = 0; i < bytes.Length; i++)
											s.Append(bytes[i].ToString(\"X2\"));
										return s.ToString();
									}
								}
								public class Win32HandleWrapper : IWin32Window {
									private IntPtr mHandle;
									public Win32HandleWrapper(IntPtr aHandle) {
										this.mHandle = aHandle;
									}
									public IntPtr Handle {
										get {
											return this.mHandle;
										}
									}
								}
								public static Win32HandleWrapper WrapWin32Handle(IntPtr Handle) {
									return (new Win32HandleWrapper(Handle));
								}
								public int FindSubString(String FindWhere, String FindWhat, int FromWhere, int CharCount, bool IgnoreCase) {
									StringComparison ComparsionMethod;
									if (IgnoreCase)
										ComparsionMethod = StringComparison.OrdinalIgnoreCase;
									else
										ComparsionMethod = StringComparison.Ordinal;
									return (FindWhere.IndexOf(FindWhat, (FromWhere - 1), CharCount, ComparsionMethod) + 1);
								}
								public int[] DoRegExp(String tText, String tPattern, bool IgnoreCase, int FromWhere) {
									RegexOptions Options;
									if (IgnoreCase)
										Options = RegexOptions.IgnoreCase;
									else
										Options = RegexOptions.None;
									Regex tRegEx = new Regex(@tPattern, Options);
									MatchCollection tMatches = tRegEx.Matches(tText, FromWhere);
									int MatchCount = tMatches.Count;
									int[] Result = new int[MatchCount];
									for (int i = 0; i < MatchCount; i++)
										Result[i] = (tMatches[i].Index + 1);
									return Result;
								}
								public byte Int8ToUnsigned(int val) {
									return (byte)val;
								}
								public uint Int16ToUnsigned(int val) {
									return (uint)(val & 0xFFFF);
								}
								public ulong Int32ToUnsigned(int val) {
									return (ulong)(val & 0xFFFFFFFF);
								}
								public long Int64FromInt32s(int v1, int v2) {
									return (long)(((long)v1) + (((long)v2) << 32));
								}
								public long UInt64FromInt32s(int v1, int v2) {
									return (long)(((long)v1) + (((long)v2) << 32));
								}
								public long Int64ToUnsigned(long val) {
									return val;
								}
								public short ToInt16(int[] buffer, int offset) {
									byte[] buf = {
										(byte)buffer[offset + 0],
										(byte)buffer[offset + 1]
									};
									return BitConverter.ToInt16(buf, 0);
								}
								public int ToInt32(int[] buffer, int offset) {
									byte[] buf = {
										(byte)buffer[offset + 0],
										(byte)buffer[offset + 1],
										(byte)buffer[offset + 2],
										(byte)buffer[offset + 3]
									};
									return BitConverter.ToInt32(buf, 0);
								}
								public long ToInt64(int[] buffer, int offset) {
									byte[] buf = {
										(byte)buffer[offset + 0],
										(byte)buffer[offset + 1],
										(byte)buffer[offset + 2],
										(byte)buffer[offset + 3],
										(byte)buffer[offset + 4],
										(byte)buffer[offset + 5],
										(byte)buffer[offset + 6],
										(byte)buffer[offset + 7]
									};
									return BitConverter.ToInt64(buf, 0);
								}
								public float ToSingle(int[] buffer, int offset) {
									byte[] buf = {
										(byte)buffer[offset + 0],
										(byte)buffer[offset + 1],
										(byte)buffer[offset + 2],
										(byte)buffer[offset + 3]
									};
									return BitConverter.ToSingle(buf, 0);
								}
								public double ToDouble(int[] buffer, int offset) {
									byte[] buf = {
										(byte)buffer[offset + 0],
										(byte)buffer[offset + 1],
										(byte)buffer[offset + 2],
										(byte)buffer[offset + 3],
										(byte)buffer[offset + 4],
										(byte)buffer[offset + 5],
										(byte)buffer[offset + 6],
										(byte)buffer[offset + 7]
									};
									return BitConverter.ToDouble(buf, 0);
								}
								/*
								public short ToInt16(byte[] buffer, int offset) {
									return BitConverter.ToInt16(buffer, offset);
								}
								public int ToInt32(byte[] buffer, int offset) {
									return BitConverter.ToInt32(buffer, offset);
								}
								public long ToInt64(byte[] buffer, int offset) {
									return BitConverter.ToInt64(buffer, offset);
								}
								public float ToSingle(byte[] buffer, int offset) {
									return BitConverter.ToSingle(buffer, offset);
								}
								public double ToDouble(byte[] buffer, int offset) {
									return BitConverter.ToDouble(buffer, offset);
								}
								*/
								public double Int64BitsToDouble(long val) {
									return BitConverter.Int64BitsToDouble(val);
								}
								public sbyte UInt8ToSigned(byte val) {
									return (sbyte)val;
								}
								public sbyte UInt8ToSigned(int val) {
									return (sbyte)val;
								}
								public short UInt16ToSigned(ushort val) {
									return (short)val;
								}
								public int UInt32ToSigned(uint val) {
									return (int)val;
								}
								public long UInt64ToSigned(ulong val) {
									return (long)val;
								}
								public static UInt64[] UInt64StrToDWORDs(string str) {
									UInt64 val = 0;
									NumberStyles ns = NumberStyles.Any;
									if (str.StartsWith(\"0x\")) {
										ns = NumberStyles.AllowHexSpecifier;
										str = str.Substring(2);
									}
									if (!UInt64.TryParse(str, ns, CultureInfo.CurrentCulture, out val))
										throw new Exception(String.Format(\"Не удалось распознать UInt64 в \\\"{0}\\\"\", str));
									return new UInt64[] {
										((val >> 32) & 0xFFFFFFFF),
										(val & 0xFFFFFFFF)
									};
								}
								public static string Base64Encode(string plainText) {
									return System.Convert.ToBase64String(Encoding.UTF8.GetBytes(plainText));//, Base64FormattingOptions.InsertLineBreaks);
								}

								public static GIMSBinaryReader GetStreamReader(string path, int bufferSize, bool isBigEndian) {
									BufferedStream s = new BufferedStream(File.OpenRead(path), bufferSize);
									return new GIMSBinaryReader(s, isBigEndian);
								}
								public static GIMSBinaryWriter GetStreamWriter(string path, bool appendMode, int bufferSize, bool isBigEndian) {
									BufferedStream s = new BufferedStream(File.Open(path, FileMode.Create, FileAccess.Read, FileShare.Read), bufferSize);
									return new GIMSBinaryWriter(s, isBigEndian);
								}

							}
							
							public class GIMSBinaryReader : BinaryReader {
								private bool IsBigEndian = false;

								public GIMSBinaryReader(Stream input, bool isBigEndian)
									: base(input, ASCIIEncoding.ASCII)
								{
									IsBigEndian = isBigEndian;
								}

								private byte[] Reverse(byte[] b) {
									Array.Reverse(b);
									return b;
								}

								override public UInt16 ReadUInt16() {
									if (IsBigEndian)
										return BitConverter.ToUInt16(Reverse(ReadBytes(sizeof(UInt16))), 0);
									else
										return ReadUInt16();
								}

								override public Int16 ReadInt16() {
									if (IsBigEndian)
										return BitConverter.ToInt16(Reverse(ReadBytes(sizeof(Int16))), 0);
									else
										return ReadInt16();
								}

								override public UInt32 ReadUInt32() {
									if (IsBigEndian)
										return BitConverter.ToUInt32(Reverse(ReadBytes(sizeof(UInt32))), 0);
									else
										return ReadUInt32();
								}

								override public Int32 ReadInt32() {
									if (IsBigEndian)
										return BitConverter.ToInt32(Reverse(ReadBytes(sizeof(Int32))), 0);
									else
										return ReadInt32();
								}

								override public Single ReadSingle() {
									if (IsBigEndian)
										return BitConverter.ToSingle(Reverse(ReadBytes(sizeof(Single))), 0);
									else
										return ReadSingle();
								}

								override public Double ReadDouble() {
									if (IsBigEndian)
										return BitConverter.ToDouble(Reverse(ReadBytes(sizeof(Double))), 0);
									else
										return ReadDouble();
								}

								public string ReadLString(int charCount) {
									StringBuilder sb = new StringBuilder(charCount);
									for (int i = 0; i < charCount; i++) {
										char ch = base.ReadChar();
										if (ch == '\0') {
											base.BaseStream.Seek(charCount - 1, SeekOrigin.Current);
											break;
										}
										sb.Append(ch);
									}
									return sb.ToString();
								}

								public string ReadNTString() {
									StringBuilder sb = new StringBuilder(64);
									while (BaseStream.Position < BaseStream.Length) {
										char ch = base.ReadChar();
										if (ch == '\0')
											break;
										sb.Append(ch);
									}
									return sb.ToString();
								}
							}

							public class GIMSBinaryWriter : BinaryWriter {
								private bool IsBigEndian = false;

								public GIMSBinaryWriter(Stream output, bool isBigEndian)
									: base(output, ASCIIEncoding.ASCII)
								{
									IsBigEndian = isBigEndian;
								}

								private byte[] Reverse(byte[] b) {
									Array.Reverse(b);
									return b;
								}

								public int WriteByte(byte value) {
									base.Write(value);
									return sizeof(byte);
								}

								public int WriteSByte(sbyte value) {
									base.Write(value);
									return sizeof(sbyte);
								}

								public int WriteUInt16(UInt16 val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(UInt16);
								}

								public int WriteInt16(Int16 val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(Int16);
								}

								public int WriteUInt32(UInt32 val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(UInt32);
								}

								public int WriteInt32(Int32 val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(Int32);
								}

								public int WriteSingle(Single val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(Single);
								}

								public int WriteDouble(Double val) {
									if (IsBigEndian)
										base.Write(Reverse(BitConverter.GetBytes(val)));
									else
										base.Write(val);
									return sizeof(Double);
								}

								public int WriteString(string val, int size) {
									int charCount = ((size == -1) ? val.Length : size);
									for (int i = 0; i < charCount; i++)
										base.Write(val[i]);
									return charCount;
								}

								public int WriteNTString(string val) {
									for (int i = 0; i < val.Length; i++)
										base.Write(val[i]);
									base.Write('\0');
									return (val.Length + 1);
								}
							}

							public class GIMSCheckedListBox : CheckedListBox {
								public GIMSCheckedListBox() {
									SetStyle(
										ControlStyles.OptimizedDoubleBuffer,
										true
									);
									HorizontalScrollbar = true;
								}
							}
							
							public class GIMSListBox : ListBox {
								public override int ItemHeight {
									get {
										return base.ItemHeight;
									}

									set {
										base.ItemHeight = value;
										DrawMode = DrawMode.OwnerDrawFixed;
									}
								}
								protected override void OnDrawItem(DrawItemEventArgs e) {
									e.DrawBackground();
									e.DrawFocusRectangle();
									TextRenderer.DrawText(e.Graphics, Items[e.Index].ToString(), e.Font, e.Bounds, e.ForeColor, Color.Transparent, TextFormatFlags.Left | TextFormatFlags.LeftAndRightPadding | TextFormatFlags.VerticalCenter);
								}
								public GIMSListBox() {
									SetStyle(
										ControlStyles.OptimizedDoubleBuffer,
										true
									);
									HorizontalScrollbar = true;
								}
							}
							
							public class GIMSButtonListBox : ListBox {
								private Brush _ItemBrush = null;
								private Padding _Padding = new Padding(5);
								public Padding ItemPadding {
									get {
										return _Padding;
									}
									set {
										_Padding = value;
										Invalidate();
									}
								}
								public Color ItemColor {
									set {
										if (_ItemBrush != null)
											_ItemBrush.Dispose();
										if (value == Color.Transparent)
											return;
										_ItemBrush = new SolidBrush(value);
										Invalidate();
									}
								}
								public override int ItemHeight {
									get {
										return base.ItemHeight;
									}

									set {
										base.ItemHeight = value;
										DrawMode = DrawMode.OwnerDrawFixed;
									}
								}
								protected override void OnDrawItem(DrawItemEventArgs e) {
									e.DrawBackground();
									Rectangle rect = e.Bounds;
									if (_ItemBrush != null) {
										rect = new Rectangle(
											rect.X + _Padding.Left,
											rect.Y + _Padding.Top,
											rect.Width - _Padding.Horizontal,
											rect.Height - _Padding.Vertical
										);
										e.Graphics.FillRectangle(_ItemBrush, rect);
										e.Graphics.DrawRectangle(Pens.Black, rect);
									}
									e.DrawFocusRectangle();
									TextRenderer.DrawText(e.Graphics, Items[e.Index].ToString(), e.Font, rect, e.ForeColor, Color.Transparent, TextFormatFlags.HorizontalCenter | TextFormatFlags.LeftAndRightPadding | TextFormatFlags.VerticalCenter);
								}
								public GIMSButtonListBox() {
									SetStyle(
										ControlStyles.OptimizedDoubleBuffer,
										true
									);
									HorizontalScrollbar = true;
								}
							}

							public class GIMSCounterListBox : ListBox {
								public GIMSCounterListBox() {
									SetStyle(
										ControlStyles.OptimizedDoubleBuffer |
										ControlStyles.UserPaint |
										ControlStyles.AllPaintingInWmPaint,
										true
									);
									HorizontalScrollbar = true;
								}
								public Font CounterFont {
									get {
										return new Font(\"Segoe UI\", 70);
									}
									set {}
								}
								public Color CounterColor {
									get {
										return Color.Gray;
									}
									set {}
								}
								public Color AccentColor {
									get {
										return Color.FromArgb(175, Color.DodgerBlue);
									}
									set {}
								}
								public override int ItemHeight {
									get {
										return base.ItemHeight;
									}

									set {
										base.ItemHeight = value;
										DrawMode = DrawMode.OwnerDrawFixed;
									}
								}
								protected override void OnDrawItem(DrawItemEventArgs e) {
									e.DrawBackground();
									if (e.Index >= 0) {
										String ItemText = Items[e.Index].ToString();
										Graphics gr = e.Graphics;
										int TextLen = (int)gr.MeasureString(ItemText, e.Font).Width;
										if (HorizontalExtent < TextLen)
											HorizontalExtent = TextLen;
										TextRenderer.DrawText(gr, ItemText, e.Font, e.Bounds, e.ForeColor, Color.Transparent, TextFormatFlags.Left | TextFormatFlags.LeftAndRightPadding | TextFormatFlags.VerticalCenter);
									}
								}
								private void PaintBackground(Graphics gr, Region iRegion) {
									gr.FillRegion(new SolidBrush(BackColor), iRegion);
									String ItemCount = Items.Count.ToString();
									SizeF size = gr.MeasureString(ItemCount, CounterFont);
									Point pos = new Point((int)(Width - size.Width) - 10, (int)(Height - size.Height) - 10);
									gr.DrawString(ItemCount, CounterFont, new SolidBrush(CounterColor), pos);
								}
								protected override void OnPaint(PaintEventArgs e) {
									Graphics gr = e.Graphics;
									Rectangle rect = e.ClipRectangle;
									Region iRegion = new Region(rect);
									PaintBackground(gr, iRegion);
									if (Items.Count > 0) {
										for (int i = 0; i < Items.Count; ++i) {
											Rectangle irect = GetItemRectangle(i);
											if (rect.IntersectsWith(irect)) {
												if (
													(SelectionMode == SelectionMode.One && SelectedIndex == i) ||
													(SelectionMode == SelectionMode.MultiSimple && SelectedIndices.Contains(i)) ||
													(SelectionMode == SelectionMode.MultiExtended && SelectedIndices.Contains(i))
												)
													OnDrawItem(new DrawItemEventArgs(gr, Font, irect, i, DrawItemState.Selected, ForeColor, Color.Transparent));
												else
													OnDrawItem(new DrawItemEventArgs(gr, Font, irect, i, DrawItemState.Default, ForeColor, Color.Transparent));
												iRegion.Complement(irect);
											}
										}
									}
								}
							}
							
							"),
							referencedAssemblyNames = #(
								"System.dll",
								"System.Windows.Forms.dll",
								"System.Drawing.dll"
							),
							GIMSNETAssembly = (CompileDOTNetAssembly GIMSNETAssemblySource referencedAssemblyNames:referencedAssemblyNames)
					if No GIMSNETAssembly then
						throw "Can't initialize GIMSNETAssembly! Try to update your .NET runtime"
					SystemMgr.GIMSNETAssembly = GIMSNETAssembly
					
					local	GIMSOpsLib = (GIMSNETAssembly.CreateInstance "GIMSOps")
					if No GIMSOpsLib then
						throw "Can't initialize GIMSOpsLib! Try to update your .NET runtime"
					SetLifetimeController GIMSOpsLib #MXS
					SystemMgr.GIMSOpsLib = GIMSOpsLib
										
					local	XMLReaderClassName = "System.Xml.XmlReader"
					if No (DotNET.GetType XMLReaderClassName) then (
						local	XMLAssembly = (DotNET.LoadAssembly "System.Xml")
						SetLifetimeController XMLAssembly #MXS
					)
					local	NETXMLSettings = (DotNETObject "System.Xml.XmlReaderSettings")
					SetLifetimeController NETXMLSettings #MXS
					NETXMLSettings.IgnoreWhitespace = true
					SystemMgr.NETXMLSettings = NETXMLSettings
					local	NETXMLReaderClass = (DotNETClass XMLReaderClassName)
					SetLifetimeController NETXMLReaderClass #MXS
					SystemMgr.NETXMLReaderClass = NETXMLReaderClass
					
					local	NETTimer = (DotNETObject "System.Windows.Forms.Timer")
					if No NETTimer then
						throw "Can't initialize NETTimer! Try to update your .NET runtime"
					SetLifetimeController NETTimer #MXS
					NETTimer.Interval = 10
					GUIMgr.Animator.NETTimer = NETTimer
					
					local	MAXHWnd = (GIMSOpsLib.WrapWin32Handle (DotNETObject "System.IntPtr" (Windows.GetMAXHWND())))
					if No MAXHWnd then
						throw "Can't initialize MAXHWnd! Try to update your .NET runtime"
					SetLifetimeController MAXHWnd #MXS
					GUIMgr.MAXHWnd = MAXHWnd
					
					local	SystemInformation = (DotNETClass "System.Windows.Forms.SystemInformation")
					SetLifetimeController SystemInformation #MXS
					local	ScreenWidth = 0,
							ScreenHeight = 0
					GIMSOpsLib.GetGraphicsInfo &ScreenWidth &ScreenHeight
					if ScreenHeight > ScreenWidth then
						Swap ScreenWidth ScreenHeight
					local	ScreenSize = [ScreenWidth, ScreenHeight],
							PrimaryMonitorSize = SystemInformation.PrimaryMonitorSize,
							ScreenResolution = [PrimaryMonitorSize.Width, PrimaryMonitorSize.Height],
							DPMM = (ScreenResolution / ScreenSize),
							MinDPMM = 3.2,
							ScaleMult = 1,
							MainWindowSize = GUIMgr.MainWindowSize
					if
						DPMM.x < MinDPMM or
						DPMM.y < MinDPMM
					then
						ScaleMult = (MinDPMM / DPMM.x)
					GUIMgr.ScreenSize = ScreenSize
					GUIMgr.ScreenResolution = ScreenResolution
					GUIMgr.DPMM = DPMM
					GUIMgr.ScaleMult = (
						if (ScreenSize.y - MainWindowSize.y) < 30 then (
							(ScaleMult * 0.7)
						) else
							ScaleMult
					)
					
					local	GIMSTelemetryLib = (GIMSNETAssembly.CreateInstance "GIMSTelemetry")
					if No GIMSTelemetryLib then
						throw "Can't initialize GIMSTelemetryLib! Try to update your .NET runtime"
					SetLifetimeController GIMSTelemetryLib #MXS	
					SystemMgr.GIMSTelemetryLib = GIMSTelemetryLib
					EGIMS_TelemetryLib = GIMSTelemetryLib

					OK					
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn CheckConnection args = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					try (
						local	arr = GIMS.WorkerArg	--args.Argument
						if not (Internet.CheckConnection URL:arr[2] Force:true) then
							arr[1].CancelAsync()
						GIMS.IsWorkerBusy = false
					) catch (
						GIMS.IsWorkerBusy = false
						MessageBox ("Internet connection check error:\n" + (GetCurrentException()))
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn Download Servers URLList Location ShowGUI = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					
					--))))	TODO use Servers with URLList
					
					if URLList.Count != 0 then (
						local	Result = true,
								Timeout = (if Quiet then 5000 else 30000)
						if (GIMS.DoWaitAsync CheckConnection URLList[1] Timeout:Timeout) then (
							local	hash = (GetTimeStamp()),
									DownloadUrlToDisk = DragAndDrop.DownloadUrlToDisk
							for DownFile in URLList while Result do (
								local	TargetFile = (Location + (FileNameFromPath DownFile)),
										IsDownloaded = (DownloadUrlToDisk (DownFile + "?is=" + (hash as String)) TargetFile 0)
								if
									(not IsDownloaded) or
									(not (DoesFileExist TargetFile))
								then
									Result = false 
							)
						) else
							Result = false
						--if not Result then (
						--	for DownFile in URLList do
						--		DeleteFile (Location + (FileNameFromPath DownFile))
						--)
						Result
					) else
						true
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn GetUpdateState CurrentGame Quiet ForceUpdate:false ForceAgree:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Format "GetUpdateState (CurrentGame:% Quiet:% ForceUpdate:% ForceAgree:%) {\n" CurrentGame.Name Quiet ForceUpdate ForceAgree To:UpdateStream
					local	DownloadPath = CurrentGame.DownloadPath,
							ValueOps = GIMS.Core.ValueOps,
							FormatText = ValueOps.FormatText,
							ServerURLs = CurrentGame.ServerURLs,
							Tag = CurrentGame.Tag,
							--Download = GIMS.Download,
							Result = (
								if (
										Download ServerURLs #(
											FormatText \
												v1:"GIMS/" \
												v2:Tag \
												v3:"/Files/" \
												v4:GIMS.ConfigFile
										) DownloadPath (not Quiet)
								) then (
									Format "Downloaded config file\n" To:UpdateStream
									if (
											Download ServerURLs #(
												FormatText \
													v1:"GIMS/" \
													v2:Tag \
													v3:"/Files/ChangeLog.GCF"
											) DownloadPath (not Quiet)
									) then (
										Format "Downloaded ChangeLog file\n" To:UpdateStream
										local	Result = #NoUpdate, /*#Unavailable #NoUpdate #Agree #Discard*/
												ConfigProps = CurrentGame.Core.ConfigProps,
												TypeCast = ValueOps.TypeCast,
												FilesPath = CurrentGame.FilesPath,
												PresentVersions = ConfigProps.Versions,
												PresentFiles = ConfigProps.Files,
												PresentFileTags,
												ConfData = (GIMS.Core.ConfigOps.ReadConfigFile (DownloadPath + GIMS.ConfigFile)),
												NewBuildDate = ConfData[1],
												NewFiles = ConfData[3],
												NewFileTags,
												NewVersions = ConfData[4],
												NewSizes = ConfData[5],
												ToDownload = #(),
												DLMask,
												DLSize = 0,
												NewFileTag, FileID, NewFileID,
												CurrentFiles,
												ConfigFileTag
										if
											ForceUpdate or
											ConfigProps.BuildDate != NewBuildDate
										then (
											Format "Forced or new date found\n" To:UpdateStream
											PresentFileTags = #()
											NewFileTags = #()
											DLMask = #()
											for i = PresentFiles.count to 1 by -1 do
												PresentFileTags[i] = (TypeCast PresentFiles[i] name)
											for i = NewFiles.count to 1 by -1 do
												NewFileTags[i] = (TypeCast NewFiles[i] name)
											for i = NewFiles.count to 1 by -1 do
												DLMask[i] = true
											CurrentFiles = (GetFiles (FilesPath + "*"))
											ConfigFileTag = (TypeCast GIMS.ConfigFile name)
											for File in CurrentFiles do ( /*select files to update*/
												NewFileTag = (TypeCast (FileNameFromPath File) name)
												if NewFileTag != ConfigFileTag then (
													NewFileID = (FindItem NewFileTags NewFileTag)
													if NewFileID != 0 then (
														FileID = (FindItem PresentFileTags NewFileTag) 
														if FileID != 0 then (
															if (DoesFileExist (FilesPath + PresentFiles[FileID])) then (
																if PresentVersions[FileID] == NewVersions[NewFileID] then
																	DLMask[NewFileID] = false
															)
														)
													)
												)
											)
											local	FilesSubPath = "/Files/"
											for i = 1 to DLMask.Count where DLMask[i] do ( /*collect files to download and set DLSize*/
												Append ToDownload (
													FormatText \
														v1:Tag \
														v2:FilesSubPath \
														v3:NewFiles[i]
												)
												DLSize += NewSizes[i] 
											)
											if
												ForceUpdate or
												DLSize != 0
											then ( /*if have smth to update*/
												Format "Found files to update\n" To:UpdateStream
												DLSize = (DLSize as String)
												if DLSize.count > 3 then (
													DLSize = (
														if DLSize.count > 6 then (
															FormatText \
																v1:(SubString DLSize 1 (DLSize.count - 6)) \
																v2:"." \
																v3:(SubString DLSize (DLSize.count - 5) 3) \
																v4:" Mb"
														) else
															(Append (SubString DLSize 1 (DLSize.count - 3)) " Kb")
													)
												) else
													Append DLSize " bytes"
												if
													ForceUpdate or
													ForceAgree or (
														CreateDialog EGIMS_UpdateRollout
														EGIMS_UpdateRollout.Init CurrentGame.Name DLSize DownloadPath
														local	ProcessPostedMessages = GIMS.ProcessPostedMessages
														while (EGIMS_UpdateRollout.IsDisplayed) do
															ProcessPostedMessages()
														EGIMS_UpdateRollout.Decision
													)
												then (
													Result = #Agree
													try
														GUIMgr.MainWindow.Close()
													catch (
														try (EGIMS_MainWindow.Close()) catch ()
													)
												) else
													Result = #Discard
											)
										)
										#(
											Result,
											ConfigProps,
											FilesPath,
											ConfData[6],
											NewBuildDate,
											ConfData[2],
											NewFiles,
											NewVersions,
											NewSizes,
											ToDownload,
											CurrentFiles,
											DownloadPath
										)
									) else
										#(#Unavailable)
								) else
									#(#Unavailable)
							)
					Format "} Result decision: %\n" Result[1] To:UpdateStream
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn DoUpdate CurrentGame UpdateState UpdateMissing Quiet Setup = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Format "DoUpdate (CurrentGame:% UpdateMissing:% Quiet:% Setup:%) {\n" CurrentGame.Name UpdateMissing Quiet Setup To:UpdateStream
					EGIMS_GAReportEvent		"Core" "Update" (if Setup then "Setup" else "Update") (if UpdateMissing then 1 else 0) Game:CurrentGame
					local	ToDownload = UpdateState[10],
							DownloadPath = UpdateState[12],
							--Download = GIMS.Download,
							Result = (
								if (Download CurrentGame.ServerURLs ToDownload DownloadPath true) then ( /*download needed files*/
									Format "Download success\n" To:UpdateStream
									local	BackupPath = CurrentGame.BackupPath,
											ConfigProps = UpdateState[2],
											FilesPath = UpdateState[3],
											--NewRAWBuildDate = UpdateState[4],
											--NewBuildDate = UpdateState[5],
											NewCacheResetDate = UpdateState[6],
											NewFiles = UpdateState[7],
											--NewVersions = UpdateState[8],
											--NewSizes = UpdateState[9],
											CurrentFiles = UpdateState[11],
											ValueOps = GIMS.Core.ValueOps,
											TypeCast = ValueOps.TypeCast
									 /*Reset cache*/
									if ConfigProps.CacheResetDate != NewCacheResetDate then (
										GIMS.Core.CacheMgr.DeleteCache()
										ConfigProps.CacheResetDate = NewCacheResetDate
									)
									/*create empty backup folder*/
									local	BackupFolder = (FilterString ConfigProps.BuildDate ":")
									BackupFolder = (
										ValueOps.FormatText \
											v1:BackupPath \
											v2: BackupFolder[1] \
											v3:"." \
											v4:BackupFolder[2] \
											v5:"/"
									)
									MakeDir BackupFolder All:true
									local	BackupFiles = (GetFiles (BackupFolder + "*"))
									local	FileCopy = GIMS.Core.SystemMgr.FileCopy,
											FileDelete = GIMS.Core.SystemMgr.FileDelete
									for File in BackupFiles do
										FileDelete File
									/*make backup*/
									for File in CurrentFiles do
										FileCopy File (BackupFolder + (FileNameFromPath File))
									/*copy new files*/
									NewFiles = (GetFiles (DownloadPath + "*"))
									local	SubResult = true
									for File in NewFiles while SubResult do (
										local	TargetFile = (FilesPath + (FileNameFromPath file))
										SubResult = (FileCopy File TargetFile)
										if not SubResult then
											Format "Copy failed: %\n" TargetFile To:UpdateStream
									)
									if SubResult then (
										Format "Copy success\n" To:UpdateStream
										if not Quiet then (
											if Setup then
												MessageBox "Complete" Title:("GIMS " + CurrentGame.Name + " core setup")
											else
												MessageBox "Complete" Title:("GIMS " + CurrentGame.Name + " core update")
										)
										CurrentGame.Rules = undefined
										CurrentGame.Core = undefined
										SubResult = (CurrentGame.Start CurrentGame)
									) else
										Format "Copy failed\n" To:UpdateStream
									SubResult
								) else (
									Format "Download failed\n" To:UpdateStream
									false
								)
							)
					Format "} Result: %\n" Result To:UpdateStream
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn UpdateCore Quiet Setup:false UpdateMissing:false &IsGameUpdateDeclined:unsupplied ForceUpdate:false = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Format "UpdateCore (CurrentGame:% Quiet:% Setup:% UpdateMissing:%) {\n" GIMS.CurrentGame.Name Quiet Setup UpdateMissing To:UpdateStream
					local	Result = (
								if not GIMS.IsDevBuild then (
									if not ForceUpdate then (
										ForceUpdate = (
											Setup or
											UpdateMissing
										)
									)
									local	SubResult = true,
											CurrentGame = GIMS.CurrentGame,
											IsGameShared = (CurrentGame == GIMS.Shared),
											UpdateState = (GetUpdateState GIMS.Shared Quiet ForceUpdate:(IsGameShared and ForceUpdate) ForceAgree:((not IsGameShared) and Setup)), /*check shared update*/
											UpdateDecision = UpdateState[1],
											ForceAgree = false,
											IsUpdateDeclined = (UpdateDecision == #Discard)
									GIMS.Shared.IsUpdateDeclined = IsUpdateDeclined
									Format "Shared update decision:%\n" UpdateDecision To:UpdateStream
									if UpdateDecision != #Unavailable then ( /*shared connection ok*/
										if not IsUpdateDeclined then ( /*shared update not cancelled*/
											if UpdateDecision != #NoUpdate then ( /*shared update present*/
												SubResult = (
													if (DoUpdate GIMS.Shared UpdateState UpdateMissing (Quiet or (not IsGameShared)) (IsGameShared and Setup)) then ( /*update and start shared*/
														GIMS.CurrentGame = CurrentGame
														ForceAgree = true
														EGIMS_GAReportEvent (EGIMS_GetCoreVersion Game:GIMS.Shared) "Update" GIMS.Shared.Name 0
														#Updated
													) else
														false
												)
												Format "Shared update result: %\n" SubResult To:UpdateStream
											)
											if
												CurrentGame != GIMS.Shared and
												SubResult != false
											then ( /*shared update succeeded or not present, and current core is game*/
												local	UpdateState = (GetUpdateState CurrentGame Quiet ForceUpdate:ForceUpdate ForceAgree:ForceAgree), /*check game update*/
														UpdateDecision = UpdateState[1]
												IsUpdateDeclined = (UpdateDecision == #Discard)
												CurrentGame.IsUpdateDeclined = IsUpdateDeclined
												if Supplied IsGameUpdateDeclined then
													IsGameUpdateDeclined = IsUpdateDeclined
												Format "Game update decision:%\n" UpdateDecision To:UpdateStream
												SubResult = (
													if UpdateDecision == #Agree then (	/*game update not cancelled*/
														local	UpdateResult = (DoUpdate CurrentGame UpdateState UpdateMissing Quiet Setup)	/*update game*/
														if UpdateResult == true then (
															EGIMS_GAReportEvent (EGIMS_GetCoreVersion Game:CurrentGame) "Update" CurrentGame.Name 0
															#Updated
														) else
															UpdateResult
													) else
														(not ForceUpdate)	/*no game connection/update, or cancelled: return true if not forced*/
												)
												Format "Game update result: %\n" SubResult To:UpdateStream
											)
										) else
											SubResult = (not ForceUpdate) /*shared update cancelled: return true if not forced*/
									) else
										SubResult = (not ForceUpdate) /*no shared connection: return true if not forced*/
									if SubResult == false then (
										if (QueryBox (CurrentGame.Name + " core update's failed.\nPlease, check the internet connection and try again later, or contact the support.\n\nICQ: 466645558\nSkype: treedoomer\n3Doomer2@gmail.com\n\nContact support?") Title:("GIMS " + CurrentGame.Name + " update")) then (
											ShellLaunch CurrentGame.RussianSupport ""
											ShellLaunch CurrentGame.IntlSupport ""
										)
									)
									local	FilesToDelete = (
												(GetFiles (GIMS.Shared.DownloadPath + "*")) +
												(GetFiles (CurrentGame.DownloadPath + "*"))
											),
											FileDelete = GIMS.Core.SystemMgr.FileDelete
									for File in FilesToDelete do
										FileDelete File
									SubResult
								) else
									true
							)
					Format "} Result: %\n" Result To:UpdateStream
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn FindLangPacks = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	Languages = (GetFiles (GIMS.Shared.FilesPath + "*.GIP")),
							LangCount = Languages.Count
					if LangCount == 0 then
						throw ("Can't find any " + GIMS.Shared.Name + " core language packages!")
					else (
						for i = 1 to LangCount do
							Languages[i] = ((GetFileNameFile Languages[i]) as name)
					)
					GIMS.Languages = Languages
					local	LangID = (FindItem Languages #English)
					if LangID == 0 then
						throw ("Can't find " + GIMS.Shared.Name + " core English language package!")
					GIMS.LangID = LangID
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn PreLoad = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					GIMS.Core.GUIMgr.Init()
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn LoadRules = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	CachePath = GIMS.Shared.CachePath,
							RulesPath = (CachePath + "Rules.GSF")
					if (DoesFileExist RulesPath) then (
						local	Rules = GIMS.Shared.Rules
						try (
							Rules = (
								GIMS.Core.CacheMgr.ReadCached \
									undefined \
									undefined \
									GCCPath:CachePath \
									GCCFile:"Rules" \
									Type:"GSF" \
									IgnoreBehavior:true \
									DefaultData:Rules
							)
						) catch ()
						GIMS.Shared.Rules = Rules
						local	GAState = Rules.GATelemetryEnabled
						if GAState then (
							EGIMS_StartTelemetry()
							EGIMS_GAReportScreenView "GIMS" "Utility" "Standby"
						) else
							EGIMS_StopTelemetry()
					) else (
						EGIMS_StartTelemetry()
						EGIMS_GAReportScreenView "GIMS" "Utility" "Standby"
					)
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn LoadGame IsFirstLaunch Setup:false = (
				local	Result = false
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					Format "LoadGame (IsFirstLaunch:% Setup:% CurrentGame:%) {\n" IsFirstLaunch Setup GIMS.CurrentGame.Name To:UpdateStream
					local	SystemMgr = GIMS.Core.SystemMgr,
							FilesPath = GIMS.CurrentGame.FilesPath,
							ConfigProps = GIMS.CurrentGame.Core.ConfigProps,
							ConfigFilePath = (FilesPath + GIMS.ConfigFile)
					if (DoesFileExist ConfigFilePath) then (
						Format "Config found\n" To:UpdateStream
						local 	ConfData = (GIMS.Core.ConfigOps.ReadConfigFile ConfigFilePath),
								BuildDate = ConfData[1]
						ConfigProps.BuildDate = BuildDate
						ConfigProps.CacheResetDate = ConfData[2]
						ConfigProps.Files = ConfData[3]
						ConfigProps.Versions = ConfData[4]
						ConfigProps.Sizes = ConfData[5]
						ConfigProps.RAWBuildDate = ConfData[6]
						if IsProperty ConfigProps #Hashes then
							ConfigProps.Hashes = ConfData[7]
						if Setup then
							Result = ((UpdateCore false Setup:true) != false)
						else (
							local	IsGameUpdateDeclined = false
							if GIMS.CurrentGame == GIMS.Shared then (
								FindLangPacks()
								Result = (UpdateCore true)
								InitDOTNet()
								LoadRules()
							) else
								Result = (UpdateCore true IsGameUpdateDeclined:(&IsGameUpdateDeclined))
							if Result == true then (
								Format "File check\n" To:UpdateStream
								local	FileCheckResult = (SystemMgr.CheckFiles()),
										CurrentGameName = GIMS.CurrentGame.Name
								if FileCheckResult == true then (
									Format "Files checked successfully, load game\n" To:UpdateStream
									try (
										EGIMS_GAReportEvent (EGIMS_GetCoreVersion Game:GIMS.CurrentGame) "Start" CurrentGameName 0
										local	GCoreOps = GIMS.CurrentGame.Core.CoreOps
										GCoreOps.PreLoad()
										if IsFirstLaunch then (
											SystemMgr.IncludeFiles()
											GCoreOps.FirstLaunchCleanup()
										)
										local	ChangeLog = (LoadChangeLog())
										ChangeLog[2][1] = BuildDate
										ConfigProps.ChangeLog = ChangeLog
										GCoreOps.PostLoad()
										Result = true
									) catch (
										if IsGameUpdateDeclined then (
											Format "Game loading failed, asked for update\n" To:UpdateStream
											if (QueryBox (CurrentGameName + " core loading failed!\nUpdate now?") title:(Append (Append "GIMS " CurrentGameName) " core loading")) then
												Result = (UpdateCore false ForceUpdate:true)
											else
												Result = false
										) else
											throw
									)
								) else (
									Format "File check failed, asked for update\n" To:UpdateStream
									if (QueryBox (CurrentGameName + " core loading failed! Some files're missing or corrupted.\nUpdate them now?\n\nDetails:\n" + (FileCheckResult as String)) title:(Append (Append "GIMS " CurrentGameName) " core loading")) then
										Result = (UpdateCore false UpdateMissing:true)
									else
										Result = false
								)
							)
							if Result == #Updated then
								Result = true
						)
					) else (
						Format "Config not found\n" To:UpdateStream
						if not Setup then (
							Format "Asked for setup\n" To:UpdateStream
							if (QueryBox ("Welcome to the GIMS " + GIMS.CurrentGame.Name + " core setup.\n\nPlease, check your internet connection if you want to continue.") Title:("GIMS " + GIMS.CurrentGame.Name + " core setup")) then (
								Format "Setup allowed\n" To:UpdateStream
								local	Files = (GetFiles (GIMS.CurrentGame.BasePath + "*")),
										--Download = GIMS.Download,
										TypeCast = GIMS.Core.ValueOps.TypeCast,
										FileDelete = SystemMgr.FileDelete
								for tFile in Files where (TypeCast (GetFileNameFile tFile) name) != #Paths do
									FileDelete tFile
								if (
									Download GIMS.CurrentGame.ServerURLs #(
										GIMS.Core.ValueOps.FormatText \
											v1:"GIMS/" \
											v2:GIMS.CurrentGame.Tag \
											v3:"/Files/" \
											v4:GIMS.ConfigFile
									) FilesPath true
								) then (
									Format "Config downloaded\n" To:UpdateStream
									Result = (LoadGame IsFirstLaunch Setup:true)
								) else (
									Format "Config download failed\n" To:UpdateStream
									if (QueryBox "Can't download the configuration file for " + GIMS.CurrentGame.Name + " core.\nPlease check the internet connection and try again in 30 minutes, or contact the support.\n\nICQ: 466645558\nSkype: treedoomer\n3Doomer2@gmail.com\n\nContact support?" Title:("GIMS " + GIMS.CurrentGame.Name + " core loading")) then (
										shellLaunch GIMS.CurrentGame.RussianSupport ""
										shellLaunch GIMS.CurrentGame.IntlSupport ""
									)
								)
							)
						)
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
				Format "} Result: %\n" Result To:UpdateStream
				--if GIMS.SupportsLifetimeControl then	--prevent UI event handlers from deleting by GC
				--	try (GIMS.Core.SystemMgr.DoGC()) catch ()
				Result
			),
			fn InitShortcuts = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	SceneOps = GIMS.Core.MAXFactory.SceneOps,
							ValueOps = GIMS.Core.ValueOps
					SceneOps.TypeLibrary = GIMS.Core.TypeLibrary
					SceneOps.FormatText = ValueOps.FormatText
					SceneOps.GetPathString = GIMS.Core.ObjectMgr.GetPathString
					SceneOps.AddResult = GIMS.Core.SystemMgr.AddResult
					SceneOps.UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					SceneOps.TypeCast = ValueOps.TypeCast
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn PostLoad = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					InitShortcuts()
					InitGUI()
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
	)
	struct /*#PC*PATH	GIMS.Core.CacheMgr*/ CacheMgrstr (
		/*Props*/
			BehaviorID = 0,
				/*0	None			:No caching, except system needs*/
				/*1		Ondemand		:Cache the resource only when called*/
				/*2	Auto			:Cache all resources at startup*/
			BufferMode = #TxtLines,
		/*Ops*/
			fn Write Obj FullGCCPath SubresourcesPath:unsupplied IgnoreBehavior:true = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if
						IgnoreBehavior or
						BehaviorID != 0
					then (
						local	TempFilePath = (FullGCCPath + ".StageA"),
								BufferMgr = GIMS.Core.BufferMgr,
								SystemMgr = GIMS.Core.SystemMgr
						MakeDir (GetFileNamePath FullGCCPath) All:true
						SystemMgr.FileDelete TempFilePath
						local	BufferID = (BufferMgr.Create Mode:BufferMode FilePath:TempFilePath)
						if BufferID != false then (
							GIMS.Core.ValueOps.AsText Obj BufferID:BufferID SubresourcesPath:SubresourcesPath Executable:true
							BufferMgr.WriteFile BufferID
							BufferMgr.ClearBuffer BufferID
							SystemMgr.FileRename TempFilePath FullGCCPath
						) else
							EGIMS_EHAbort ("Can't write file " + (TempFilePath as String))
					)
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn RefreshObjectData Result GameFile HandlerParam = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					if IsProperty Result #Extension then (
						Result.Extension = (GetFileNameType GameFile)
						if IsProperty Result #ObjName then
							Result.ObjName = (GetFileNameFile GameFile)
					) else
						Result.ObjName = (FileNameFromPath GameFile)
					if IsProperty Result #DiskPath then
						Result.DiskPath = (GetFileNamePath GameFile)
					if IsProperty Result #TexPath then
						Result.TexPath = HandlerParam
					OK
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn ReadCached \
				GameFile Handler \
				GCCPath:#CachePath GCCFile:undefined Type:"GCF" \
				ReportProgress:true \
				HandlerParam:#NoHandlerParam \
				DefaultData:undefined \
				IgnoreBehavior:false \
				ForceInvalidateCache:false \
				&IsLoadedFromCache:unsupplied \
				&ReadTime:unsupplied \
				&WriteTime:unsupplied = \
			(
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	GATimeStart = (GetTimeStamp()),
							TimeStart = 0,
							TimeEnd = 0,
							SuppliedReadTime = (Supplied ReadTime),
							SuppliedWriteTime = (Supplied WriteTime),
							Result = undefined,
							SystemMgr = GIMS.Core.SystemMgr,
							GameFileSupplied = (Have GameFile),
							GameFileExist = (
								GameFileSupplied and
								(DoesFileExist GameFile)
							),
							IsGCCPathGeneric = true,
							RealGCCPath = (
								case GCCPath of (
									#FilesPath:
										GIMS.CurrentGame.FilesPath
									#CachePath:
										GIMS.CurrentGame.CachePath
									#ResourceCachePath:
										GIMS.CurrentGame.ResourceCachePath
									default: (
										IsGCCPathGeneric = false
										GCCPath
									)
								)
							),
							FullGCCPath = (Copy RealGCCPath),
							GUIMgr = GIMS.Core.GUIMgr
					if GUIMgr.IsInProgress then
						GUIMgr.UpdateProgress #Progress -1
					Type = (
						if Type[1] == "." then
							Type
						else
							Append "." Type
					)
					local	GameFileMD5 = (
								if GameFileExist then
									((SystemMgr.GetFileMD5 GameFile) as String)
								else
									"NoGameFile"
							)
					if No GCCFile then (
						if GameFileSupplied then (
							GCCFile = (
								if GameFileExist then (
									GIMS.Core.ValueOps.FormatText \
										v1:(GetFileNameFile GameFile) \
										v2:"." \
										v3:GameFileMD5
								) else
									GameFileMD5
							)
						) else
							throw "Can't resolve cache file name"
					)
					Append FullGCCPath GCCFile
					Append FullGCCPath Type
					local	ReadResult,
							DoesCacheFileExist = false
					if (DoesFileExist FullGCCPath) then (
						DoesCacheFileExist = true
						ForceInvalidateCache = (GIMS.Core.ConfigOps.IsDatetimeNewerThan #CacheResetDate FullGCCPath)
					)
					if
						ForceInvalidateCache and
						DoesCacheFileExist
					then (
						SystemMgr.FileDelete FullGCCPath
						DoesCacheFileExist = false
					)
					if Supplied IsLoadedFromCache then
						IsLoadedFromCache = DoesCacheFileExist
					local	SubresourcesPath = (FullGCCPath + ".StageA.Data\\")
					if
						DoesCacheFileExist and (
							IgnoreBehavior or
							BehaviorID != 0
						)
					then (
						if SuppliedReadTime then
							TimeStart = (GetTimeStamp())
						/*<PROFILERSTART>*//*LogProfiler #Start "ReadCached FileIn"; local PWS = (*//*<PROFILERSTARTED>*/
						/*<ERRHANDLERSTART>*/try (
							global	EGIMS_ExecutePath = SubresourcesPath
							Result = (FileIn FullGCCPath)
						/*<ERRHANDLER>*/) catch (
							if No DefaultData then (
								local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#FullGCCPath), #(FullGCCPath))
							)
						)/*<ERRHANDLEREND>*/
						/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
						if Have Result then (
							if
								GameFileSupplied and
								(SuperClassOf Result) == StructDef
							then (
								RefreshObjectData Result GameFile HandlerParam
								local	ResultPostCacheLoad = (TryGetProperty Result #PostCacheLoad)
								if ResultPostCacheLoad != #GetPropertyFailed then
									ResultPostCacheLoad RealGCCPath
							)
						)
						if SuppliedReadTime then (
							TimeEnd = (GetTimeStamp())
							ReadTime = (TimeEnd - TimeStart)
						)
					) else (
						if SuppliedReadTime then
							TimeStart = (GetTimeStamp())
						if Have Handler then (
							case (ClassOf Handler) of (
								MAXScriptFunction: (
									ReadResult = (
										if HandlerParam == #NoHandlerParam then
											(Handler GameFile CachePath:RealGCCPath FullGCCPath:SubresourcesPath)
										else
											(Handler GameFile HandlerParam CachePath:RealGCCPath FullGCCPath:SubresourcesPath)
									)
									if ReadResult == false then
										Result = undefined
									else
										Result = ReadResult
								)
								StructDef: (
									if GameFileSupplied then (
										Result = (Handler())
										RefreshObjectData Result GameFile HandlerParam
										ReadResult = (
											if HandlerParam == #NoHandlerParam then
												(Result.Read CachePath:RealGCCPath ReportProgress:ReportProgress)
											else
												(Result.Read HandlerParam CachePath:RealGCCPath ReportProgress:ReportProgress)
										)
										if ReadResult == false then
											Result = undefined
									) else
										throw "Can't resolve game file name"
								)
								Default:
									throw "Unknown Handler type"
							)
						)
						if SuppliedReadTime then (
							TimeEnd = (GetTimeStamp())
							ReadTime = (TimeEnd - TimeStart)
						)
					)
					if
						No Result and
						ReadResult != false
					then (
						if (IsKindOf DefaultData StructDef) then
							Result = (DefaultData())
						else
							Result = DefaultData
					)
					if
						not DoesCacheFileExist and
						Have Result
					then (
						if SuppliedWriteTime then
							TimeStart = (GetTimeStamp())
						Write Result FullGCCPath SubresourcesPath:(if IsGCCPathGeneric then GCCPath else unsupplied) IgnoreBehavior:IgnoreBehavior
						if SuppliedWriteTime then (
							TimeEnd = (GetTimeStamp())
							WriteTime = (TimeEnd - TimeStart)
						)
					)
					EGIMS_GAReportTiming "CacheMgr" "ReadCached" "Function" (((GetTimeStamp()) - GATimeStart) / EGIMS_DNTicksPerMillisecond)
					Result
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#GameFile, #Handler, #GCCPath, #GCCFile, #Type, #ReportProgress, #HandlerParam, #ClassOfDefaultData, #IgnoreBehavior, #ForceInvalidateCache, #IsLoadedFromCache, #ReadTime, #WriteTime), #(GameFile, Handler, GCCPath, GCCFile, Type, ReportProgress, HandlerParam, (ClassOf DefaultData), IgnoreBehavior, ForceInvalidateCache, IsLoadedFromCache, ReadTime, WriteTime)))/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			),
			fn DeleteCache = (
				/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
				/*<ERRHANDLERSTART>*/try (
					local	CacheFiles = (
								(GetFiles (GIMS.CurrentGame.CachePath + "*")) +
								(GetFiles (GIMS.CurrentGame.ResourceCachePath + "*"))
							),
							FileDelete = GIMS.Core.SystemMgr.FileDelete
					for tFile in CacheFiles do
						FileDelete tFile
				/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
				/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
			)
	)
	struct /*#PC*PATH	GIMS.Core.MaterialOps*/ MaterialOpsstr (
		fn FindTexture TexFilePathWithName = (
			/*<PROFILERSTART>*//*LogProfiler #Start "FindTexture"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Extensions = #(".dds", ".tga", ".png", ".gif", ".jpg", ".bmp"),
						Result, TempPath
				for Ext in Extensions while No Result where (DoesFileExist (TempPath = (TexFilePathWithName + Ext))) do
					Result = TempPath
				Free Extensions
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn LoadBitmapFile TexDirs TexSubPathWithName NoSearch:false BackColor:Red DefaultExt:".png" = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TexFilePathWithName, FoundFileName
				if (IsKindOf TexDirs Array) then (
					if TexDirs.Count == 0 then
						throw "Empty TexDirs array supplied"
					if NoSearch then (
						for TexDir in TexDirs while No FoundFileName do (
							TexFilePathWithName = (TexDir + TexSubPathWithName)
							if (DoesFileExist TexFilePathWithName) then
								FoundFileName = TexFilePathWithName
						)
					) else (
						for TexDir in TexDirs while No FoundFileName do (
							TexFilePathWithName = (TexDir + TexSubPathWithName)
							FoundFileName = (FindTexture TexFilePathWithName)
						)
					)
					if No FoundFileName then
						TexDirs = TexDirs[1]
				)
				if No FoundFileName then (
					TexFilePathWithName = (TexDirs + TexSubPathWithName)
					FoundFileName = (
						if NoSearch then
							TexFilePathWithName
						else
							(FindTexture TexFilePathWithName)
					)
				)
				local	NotFound = (
							if No FoundFileName then (
								FoundFileName = (TexFilePathWithName + DefaultExt)
								true
							) else
								false
						),
						TheBitmap = (BitmapTexture Name:(GetFileNameFile TexSubPathWithName) FileName:FoundFileName)
				if
					NotFound or (
						NoSearch and
						not (DoesFileExist FoundFileName)
					)
				then (
					local	Core = GIMS.Core
					Core.SystemMgr.AddResult #Warning (
						Core.ValueOps.FormatText \
							v1:"Can't find a texture file \"" \
							v2:TexFilePathWithName \
							v3:"\""
					)
				)
				TheBitmap.Coords.RealWorldScale = false
				TheBitmap.AlphaSource = 0
				TheBitmap.PreMultAlpha = false
				TheBitmap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(#(#TexDirs, #TexSubPathWithName), #(TexDirs, TexSubPathWithName)))/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn RecastTexturePath Map = (
			/*<PROFILERSTART>*//*LogProfiler #Start "RecastTexturePath"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TheBMP = (
							try
								Map.Bitmap
							catch
								undefined
						),
						BMPFileName = (
							try
								TheBMP.FileName
							catch
								undefined
						),
						FileName = (
							if Have BMPFileName then
								BMPFileName
							else
								Map.FileName
						)
				if Have FileName then (
					local	FullFilePath = (MapPaths.GetFullFilePath FileName)
					if FullFilePath.Count != 0 then (
						if Have TheBMP then
							TheBMP.FileName = FullFilePath
						Map.FileName = FullFilePath
						true
					) else (
						if
							Have TheBMP and
							not (DoesFileExist FileName)
						then (
							local	MapDir = (
										if MAXFilePath.Count != 0 then
											MAXFilePath
										else
											Append (GetDir #Scene) "\\"
									)
							FileName = (MapDir + (FileNameFromPath FileName))
							local	Conflicted = (
										(DoesFileExist FileName) and
										not (CompareBitmaps TheBMP FileName 0 0 UseAlpha:true)
									)
							if Conflicted then (
									local	NewFileName = (MapDir + (GetFileNameFile FileName))
									Append NewFileName "_"
									Append NewFileName ((GetTimeStamp()) as String)
									Append NewFileName (GetFileNameType FileName)
									FileName = NewFileName
							)
							Map.FileName = FileName
							TheBMP.FileName = FileName
							Save TheBMP Gamma:1
							Close TheBMP
							true
						) else
							false
					)
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FixMapFileName Map = (
			/*<PROFILERSTART>*//*LogProfiler #Start "FixMapFileName"; local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = false
				if Have Map then (
					local	RecastSuccess = (RecastTexturePath Map),
							OldPath = Map.FileName,
							OldName = (GetFileNameFile OldPath),
							NewName = (GIMS.Core.StringOps.ReplaceChars OldName)
					if NewName != OldName then (
						local	NewPath = (
							GIMS.Core.ValueOps.FormatText \
								v1:(GetFileNamePath OldPath) \
								v2:NewName \
								v3:(GetFileNameType OldPath)
						)
						if RecastSuccess then
							GIMS.Core.SystemMgr.FileRename OldPath NewPath
						Map.FileName = NewPath
					)
					Result = true
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FixMapFileNames Mtl = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	AllTagNames = (GetPropNames Mtl)
				for TempTag in AllTagNames do (
					local	Property = (GetProperty Mtl TempTag)
					case (ClassOf Property) of (
						BitmapTexture: (
							if not (FixMapFileName Property) then
								SetProperty Mtl TempTag undefined
						)
						ArrayParameter: (
							for i = 1 to Property.Count do (
								local	Tex = Property[i]
								if
									(IsKindOf Tex BitmapTexture) and
									not (FixMapFileName Tex)
								then
									Property[i] = undefined
							)
						)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReplaceShader MtlEditor = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if MtlEditor.OnPreview then (
					MtlEditor.TheObj.Material.MaterialList[MtlEditor.PrevMtl[1]] = MtlEditor.PrevMtl[2]
				) else (
					local	MaterialList = MtlEditor.TheObj.Material.MaterialList
					MtlEditor.PrevMtl = #(MtlEditor.MtlID, MaterialList[MtlEditor.MtlID])
					MaterialList[MtlEditor.MtlID] = (GIMS.CurrentGame.Core.MAXFactory.MaterialOps.ReplaceWithShader MaterialList[MtlEditor.MtlID])
				)
				MtlEditor.OnPreview = (not MtlEditor.OnPreview)
				Update MtlEditor.TheObj
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CheckFaceSelection MtlEditor = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = false
				if
					not (IsDeleted MtlEditor.TheObj) and
					$ == MtlEditor.TheObj
				then (
					case	(ClassOf MtlEditor.TheObj.BaseObject) of (
						Editable_mesh: (
							if
								SubObjectLevel == 3 or
								SubObjectLevel == 4 or
								SubObjectLevel == 5
							then
								Result = ((GetFaceSelection MtlEditor.TheObj).Count != 0)
						)
						Editable_Poly: (
							if
								SubObjectLevel == 4 or
								SubObjectLevel == 5
							then
								Result = ((PolyOp.GetFaceSelection MtlEditor.TheObj).Count != 0)
						)
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn PasteImageShader_ColorToAlpha SrcColor SrcPos DstColor DstPos = (
			DstColor.a = ((SrcColor.r + SrcColor.g + SrcColor.b) / 3)
			DstColor
		),
		fn PasteImageShader_AlphaToAlpha SrcColor SrcPos DstColor DstPos = (
			DstColor.a = SrcColor.a
			DstColor
		),
		fn PasteImage Source Destination PasteImageShader Opacity:1 DestinationFilePostfix:undefined = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Source = Source.Bitmap
				Destination = Destination.Bitmap
				local	DstFileName = Destination.FileName
				if No DestinationFilePostfix then
					DestinationFilePostfix = ("_" + (GIMS.Core.SystemMgr.GetFileMD5 DstFileName))
				local	SrcW = Source.Width,
						SrcH = Source.Height,
						SrcArea = (SrcW * SrcH),
						DstW = Destination.Width,
						DstH = Destination.Height,
						DstArea = (DstW * DstH),
						Pos = [0, 0],
						DstFilePath = (
							GIMS.Core.ValueOps.FormatText \
								v1:(GetFileNamePath DstFileName) \
								v2:(GetFileNameFile DstFileName) \
								v3:DestinationFilePostfix \
								v4:(GetFileNameType DstFileName)
						),
						Src, Dst
				if SrcArea > DstArea then (
					Src = Source
					Dst = (GIMS.GUI.ResizeBitmap Destination [SrcW, SrcH] FilePath:DstFilePath DoSave:false)
				) else (
					Src = (
						if
							SrcArea == DstArea and
							SrcW == DstW
						then
							Source
						else
							GIMS.GUI.ResizeBitmap Source [DstW, DstH] DoSave:false
					)
					Dst = (Bitmap DstW DstH FileName:DstFilePath)
					Copy Destination Dst
				)
				PasteBitmap Src Dst Pos Pos Type:#Function Function:PasteImageShader
				if (Opacity < 0.9999) then (
					local	Modify = GIMS.Core.ArrayOps.Modify,
							Width = Dst.Width,
							PropertyName = #A,
							Action = #Multiply
					for y = 0 to (Dst.Height - 1) do (
						local	Coord = [0, y]
						SetPixels Dst Coord (Modify (GetPixels Dst Coord Width) Opacity Action PropertyName:PropertyName CopyArray:false)
					)
				)
				(BitmapTexture Bitmap:(GIMS.GUI.SaveBitMap Dst))
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetDiffuseWithOpacityAlpha Mtl UseOpacity:true DestinationFilePostfix:"_opacitymapped" &IsGeneratedDiffuse:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DiffMap = (if Mtl.DiffuseMapEnable then Mtl.DiffuseMap),
						NoDiffMap = (No DiffMap),
						OpacityMap = (if Mtl.OpacityMapEnable then Mtl.OpacityMap),
						OpacityBitmap
				if
					(IsKindOf OpacityMap BitMapTexture) and
					Have (OpacityBitmap = (try OpacityMap.Bitmap catch ())) and (
						NoDiffMap or
						not DiffMap.BitMap.HasAlpha
					)
				then (
					if NoDiffMap then
						DiffMap = (BitmapTexture Bitmap:(GIMS.GUI.CreateBitmap BackColor:Mtl.Diffuse Size:[OpacityBitmap.Width, OpacityBitmap.Height]))
					PasteImage OpacityMap DiffMap PasteImageShader_ColorToAlpha Opacity:(
							if UseOpacity then
								((Mtl.Opacity / 100) * (Mtl.OpacityMapAmount / 100))
							else
								1
						) DestinationFilePostfix:DestinationFilePostfix
					if Supplied IsGeneratedDiffuse then
						IsGeneratedDiffuse = true
				) else
					DiffMap
			/*<ERRHANDLER>*/) catch (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS AddInfo:#(
					#(
						#ClassOf_Mtl,
						#DiffuseMapEnable,
						#OpacityMapEnable,
						#ClassOf_DiffuseMap,
						#ClassOf_OpacityMap,
						#ClassOf_DiffuseBitmap,
						#ClassOf_OpacityBitmap
					), #(
						(ClassOf Mtl),
						(try Mtl.DiffuseMapEnable catch "<ERROR>"),
						(try Mtl.OpacityMapEnable catch "<ERROR>"),
						(try (ClassOf Mtl.DiffuseMap) catch "<ERROR>"),
						(try (ClassOf Mtl.OpacityMap) catch "<ERROR>"),
						(try (ClassOf Mtl.DiffuseMap.Bitmap) catch "<ERROR>"),
						(try (ClassOf Mtl.OpacityMap.Bitmap) catch "<ERROR>")
					)
				)
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetBumpWithSpecAlpha Mtl DestinationFilePostfix:"_normal_specular" = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	MtlBumpMap = (if Mtl.BumpMapEnable then Mtl.BumpMap),
						BumpMap = (if (IsKindOf MtlBumpMap Normal_Bump) then MtlBumpMap.Normal_Map),
						NoBumpMap = (No BumpMap),
						SpecMap = (if Mtl.SpecularLevelMapEnable then Mtl.SpecularLevelMap)
				if
					Have SpecMap and (
						NoBumpMap or
						not BumpMap.BitMap.HasAlpha
					)
				then (
					if NoBumpMap then
						BumpMap = (BitmapTexture Bitmap:(GIMS.GUI.CreateBitmap Size:[SpecMap.Width, SpecMap.Height]))
					PasteImage SpecMap BumpMap PasteImageShader_ColorToAlpha Opacity:(Mtl.SpecularLevelMapAmount / 100) DestinationFilePostfix:DestinationFilePostfix
				) else
					BumpMap
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CopyBitmapAlpha Source Destination DestinationFilePostfix:"_alphamerged" = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	SourceBitmap = Source.Bitmap
				if No Destination then
					Destination = (BitmapTexture Bitmap:(GIMS.GUI.CreateBitmap BackColor:White Size:[SourceBitmap.Width, SourceBitmap.Height]))
				PasteImage Source Destination (Ternary (Source.RGBOutput == 0) PasteImageShader_ColorToAlpha PasteImageShader_AlphaToAlpha) DestinationFilePostfix:DestinationFilePostfix
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	struct /*#PC*PATH	EGIMS_ThreadMgr*/ strThreadMgr (
		IsWorking = false,
		Workers = #(),
		ThreadNames = #(),
		ThreadIdleStarts = #(),
		ThreadIdleLimits = #(),
		ThreadCancelledFlags = #(),
		_IsInfoLocked = false,
		_IsLockSet = false,
		
		ProcessPostedMessages,
		
		fn LockInfo = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not EGIMS_ThreadMgr._IsLockSet then (
					EGIMS_ThreadMgr._IsLockSet = true
					while EGIMS_ThreadMgr._IsInfoLocked do
						EGIMS_ThreadMgr.ProcessPostedMessages()
					EGIMS_ThreadMgr._IsInfoLocked = true
				)
				OK
			/*<ERRHANDLER>*/) catch (
				EGIMS_ThreadMgr._IsInfoLocked = false
				EGIMS_ThreadMgr._IsLockSet = false
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn UnlockInfo = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if EGIMS_ThreadMgr._IsLockSet then (
					EGIMS_ThreadMgr._IsLockSet = false
					EGIMS_ThreadMgr._IsInfoLocked = false
				)
				OK
			/*<ERRHANDLER>*/) catch (
				EGIMS_ThreadMgr._IsInfoLocked = false
				EGIMS_ThreadMgr._IsLockSet = false
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		
		fn PrintState = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WorkerCount = Workers.Count
				Format "Watchdog's state % with % workers, % thread names, % cancelled flags, % IdleStarts, and % IdleLimits\n" IsWorking WorkerCount ThreadNames.Count ThreadCancelledFlags.Count ThreadIdleStarts.Count ThreadIdleLimits.Count
				for i = 1 to WorkerCount do (
					local	Worker = Workers[i]
					Format "\tCancellationPending: %\tIsBusy: %\tCancelledFlag: %\tIdleStart: %\tIdleLimit: %\tThread name: %\n" Worker.CancellationPending Worker.IsBusy ThreadCancelledFlags[i] ThreadIdleStarts[i] ThreadIdleLimits[i] ThreadNames[i]
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn FindWorkerByName ThreadName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				LockInfo()
				local	Result = (FindItem ThreadNames ThreadName)
				UnlockInfo()
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FindWorker Worker = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				LockInfo()
				local	Result = (FindItem Workers Worker)
				UnlockInfo()
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn GetArgument Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = Args.Argument
				if Have Result then
					Result.Value
				else
					undefined
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn SetResult Sender Args Result = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Args.Result = (DotNETMXSValue Result)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetResults Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	aError = Args.Error
				if Have aError then
					throw aError.Message
				local	Cancelled = Args.Cancelled
				if not Cancelled then (
					local	WorkerID = (FindWorker Sender)
					if WorkerID != 0 then
						Cancelled = ThreadCancelledFlags[WorkerID]
				)
				#(
					Cancelled,
					(
						if Cancelled then
							#TMNoResult
						else (
							local	Result = Args.Result
							if Have Result then (
								if (IsKindOf Result DotNETMXSValue) then
									Result.Value
								else
									Result
							) else
								undefined
						)
					)
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn IsThreadCancelled Sender Args = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Sender.CancellationPending then
					Args.Cancel = true
				else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn WaitForThreads ThreadNames = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Waiting = true
				while Waiting do (
					Waiting = false
					for ThreadName in ThreadNames while not Waiting do (
						LockInfo()
						local	WorkerID = (FindWorkerByName ThreadName)
						if WorkerID != 0 then
							Waiting = Workers[WorkerID].IsBusy
						UnlockInfo()
					)
					ProcessPostedMessages()
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CancelThread ThreadName = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WorkerID = (FindWorkerByName ThreadName)
				if WorkerID != 0 then (
					ThreadCancelledFlags[WorkerID] = true
					local	ThreadWorker = Workers[WorkerID]
					if ThreadWorker.WorkerSupportsCancellation then
						ThreadWorker.CancelAsync()
					true
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn CancelAllThreads = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				for i = 1 to Workers.Count do (
					ThreadCancelledFlags[i] = true
					Workers[i].CancelAsync()
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn EraseAllThreads = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				CancelAllThreads()
				Sleep 0.25
				EGIMS_ThreadMgr.IsWorking = false
				Sleep 0.25
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		
		fn WatchdogProcess Sender Args = (
			/*<ERRHANDLERSTART>*/try (
				local	Workers = EGIMS_ThreadMgr.Workers,
						ThreadNames = EGIMS_ThreadMgr.ThreadNames,
						ThreadIdleStarts = EGIMS_ThreadMgr.ThreadIdleStarts,
						ThreadIdleLimits = EGIMS_ThreadMgr.ThreadIdleLimits,
						ThreadCancelledFlags = EGIMS_ThreadMgr.ThreadCancelledFlags,
						CancelThread = EGIMS_ThreadMgr.CancelThread,
						ProcessPostedMessages = EGIMS_ThreadMgr.ProcessPostedMessages,
						LockInfo = EGIMS_ThreadMgr.LockInfo,
						UnlockInfo = EGIMS_ThreadMgr.UnlockInfo
				while
					Have EGIMS_ThreadMgr and
					EGIMS_ThreadMgr.IsWorking
				do (
					if not Workers[1].CancellationPending then (
						local	WorkerCount = Workers.Count
						for i = WorkerCount to 1 by -1 do (
							if Workers[i].IsBusy then
								ThreadIdleStarts[i] = 0
							else (
								local	ThreadIdleStart = ThreadIdleStarts[i]
								if ThreadIdleStart == 0 then 
									ThreadIdleStarts[i] = (GetTimeStamp())
								else (
									local	TimeCurrent = (GetTimeStamp())
									if (TimeCurrent - ThreadIdleStart) > ThreadIdleLimits[i] then (
										LockInfo()
										DeleteItem Workers i
										DeleteItem ThreadNames i
										DeleteItem ThreadCancelledFlags i
										DeleteItem ThreadIdleStarts i
										DeleteItem ThreadIdleLimits i
										UnlockInfo()
									)
								)
							)
						)
					) else
						EGIMS_ThreadMgr.IsWorking = false
				)
			/*<ERRHANDLER>*/) catch (
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true
			)/*<ERRHANDLEREND>*/
			try
				EGIMS_ThreadMgr.IsWorking = false
			catch ()
			try
				while EGIMS_ThreadMgr.IsInfoLocked do
					ProcessPostedMessages()
			catch ()
			try
				EGIMS_ThreadMgr.IsInfoLocked = true
			catch ()
			try
				DeleteItem EGIMS_ThreadMgr.Workers 1
			catch ()
			try
				DeleteItem EGIMS_ThreadMgr.ThreadNames 1
			catch ()
			try
				DeleteItem EGIMS_ThreadMgr.ThreadCancelledFlags 1
			catch ()
			try
				DeleteItem EGIMS_ThreadMgr.ThreadIdleStarts 1
			catch ()
			try
				DeleteItem EGIMS_ThreadMgr.ThreadIdleLimits 1
			catch ()
			try
				EGIMS_ThreadMgr.IsInfoLocked = false
			catch ()
			OK
		),
		
		fn RunThread \
			ThreadName Thread Arg:#TMNoArg \
			SupportsCancellation:false \
			FinishFn:unsupplied ProgressChangedFn:unsupplied \
			ThreadIdleLimit:1000 \
			Timeout:0 = \
		(
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				ProcessPostedMessages = (GIMS.ProcessPostedMessages)
				
				--launch watchdog
				if not IsWorking then (
					IsWorking = true
					RunThread #ThreadMgr_Watchdog WatchdogProcess SupportsCancellation:true
				)

				--create worker
				local	Worker = (
							try
								(DotNETObject "CSharpUtilities.SynchronizingBackgroundWorker")
							catch
								(DotNETObject "System.ComponentModel.BackGroundWorker")
						),
						AddEventHandler = DOTNet.AddEventHandler
				GIMS.SetLifetimeController Worker #MXS
				
				--set worker properties
				Worker.WorkerSupportsCancellation = SupportsCancellation
				
				--add event handlers
				AddEventHandler Worker "DoWork" Thread
				if Supplied ProgressChangedFn then (
					Worker.WorkerReportsProgress = true
					AddEventHandler Worker "ProgressChanged" ProgressChangedFn
				)
				if Supplied FinishFn then
					AddEventHandler Worker "RunWorkerCompleted" FinishFn
				
				--lock data
				LockInfo()
				
				--add worker info
				Append ThreadNames ThreadName
				Append Workers Worker
				Append ThreadCancelledFlags false
				Append ThreadIdleStarts 0
				Append ThreadIdleLimits ThreadIdleLimit
				
				--run worker
				if Arg != #TMNoArg then
					Worker.RunWorkerAsync (DotNETMXSValue Arg)
				else
					Worker.RunWorkerAsync()
				local	TimeStart = (GetTimeStamp())
				
				--unlock data
				UnlockInfo()
				
				--wait
				local	Result = true
				if Timeout != 0 then (
					while
						Result and
						Worker.IsBusy
					do (
						local	TimeCurrent = (GetTimeStamp())
						if TimeCurrent < TimeStart then
							TimeStart = TimeCurrent
						else (
							if (TimeCurrent - TimeStart) > Timeout then (
								CancelThread ThreadName
								Result = false
							)
						)
						ProcessPostedMessages()
					)
				)
				Result
			/*<ERRHANDLER>*/) catch (
				_IsInfoLocked = false
				_IsLockSet = false
				local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS
			)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	try (
		if EGIMS_ThreadMgr != undefined then
			EGIMS_ThreadMgr.EraseAllThreads()
	) catch ()
	EGIMS_ThreadMgr = (strThreadMgr())
		
	struct /*#PC*PATH	GIMS.Core.DevMgr*/ DevMgrstr (
		/*Development*/
			fn ExportGUI = (
				local	Languages = #(),
						LanguageCores = #(),
						LanguageCoreLayouts = #()
				for Layout in Objects where
					(not Layout.IsFrozen) and
					(IsKindOf Layout ::EGIMS_GUI_Layout)
				do (
					Format "\tFound layout: %\n" Layout.Name
					local	LangID = (FindItem Languages Layout.Lang)
					if LangID == 0 then (
						Append Languages Layout.Lang
						Append LanguageCores #()
						Append LanguageCoreLayouts #()
						LangID = Languages.Count
					)
					local	CoreTag = Layout.CoreTag,
							CurrentLanguageCores = LanguageCores[LangID],
							CurrentLanguageCoreLayouts = LanguageCoreLayouts[LangID],
							CoreID = (FindItem CurrentLanguageCores CoreTag)
					if CoreID == 0 then (
						Append CurrentLanguageCores CoreTag
						Append CurrentLanguageCoreLayouts #(Layout)
					) else
						Append CurrentLanguageCoreLayouts[CoreID] Layout
				)
				local	GIMSPath = GIMS.GIMSPath,
						Write = GIMS.Core.CacheMgr.Write
				Print "\t--GUI export--"
				for LangID = 1 to Languages.Count do (
					local	CurrentLanguage = Languages[LangID],
							CurrentLanguageCores = LanguageCores[LangID],
							CurrentLanguageCoreLayouts = LanguageCoreLayouts[LangID]
					Format "\tLanguage: %\n" CurrentLanguage
					for CoreID = 1 to CurrentLanguageCores.Count do (
						local	Layouts = CurrentLanguageCoreLayouts[CoreID],
								CoreTag = CurrentLanguageCores[CoreID],
								FilePath = (GIMSPath + CoreTag + "/" + GIMS.FilesDir + CurrentLanguage + ".GIP")
						Format "\t\tLayouts for core %: %\n\t\t\t%\n" CoreTag (for Lay in Layouts collect Lay.Name) FilePath
						Write Layouts FilePath
						local GIMSCoreTag
						if
							CoreTag != #Shared and
							((GIMSCoreTag = (TryGetProperty GIMS CoreTag)) != #GetPropertyFailed)
						then
							GIMSCoreTag.WindowLayouts = #()
					)
				)
				Print "\t--GUI export end--"
				OK
			),
		/*Logging*/
			LogFilePath = "C:/LogFile.log",
			LogFileMode = "at",
			LogFile,
			fn DoLogging Mode Msg Val LineFormat:"%: %\n" = (
				case Mode of (
					#Start: (
						if not (DoesFileExist LogFilePath) then (
							LogFile = (CreateFile LogFilePath)
							Close LogFile
						) else
							DoLogging #LogEmptyLine undefined undefined
						DoLogging #Log Msg Val
					)
					#LogEmptyLine:
						DoLogging #Log "" "" LineFormat:"%%\n"
					#Log: (
						LogFile = (OpenFile LogFilePath Mode:LogFileMode)
						with PrintAllElements true
							Format LineFormat Msg Val To:LogFile
						Close LogFile
					)
					#Finish: (
						DoLogging #LogEmptyLine undefined undefined
						DoLogging #Log Msg Val
					)
					Default:
						throw (Append "Unknown mode: " (Mode as String))
				)
			),
		/*GIMS info printer data*/
			/*USAGE
			(Sleep 1;	GIMS.Core.DevMgr.PrintGIMSInfo ShowSimpleData:false ShowArrayData:false ShowFns:true ShowClassNames:false LogFile:"Z:\\ClassHierarchy.c")
			(Print #NewTypes;	Print GIMS.Core.DevMgr.NewTypes;	OK)
			*/
			ExcludedStructMemberNames = #(
				#GIMSObjectLink,
				#DevInfoPropList
			),
			Types = #(
				UndefinedClass,
				Generic,
				Value,
				BooleanClass,
				Integer,
				Float,
				Point2,
				Point3,
				Point4,
				Matrix3,
				Color,
				Quat,
				Name,
				String,
				StringStream,
				Array,
				ArrayParameter,
				BitArray,
				GeometryClass,
				BitMap,
				DotNETClass,
				DotNETObject,
				#EmptyStruct,
				StructDef,
				FileStream,
				Integer64,
				BakeElement,
				Node,
				Helper,
				MAXWrapper,
				Primitive,
				MAXScriptFunction,
				DotNETMethod
			),
			TypeNames = #(
				"UNDEFINED",
				"Generic",
				"Value",
				"Boolean",
				"Integer",
				"Float",
				"Point2",
				"Point3",
				"Point4",
				"Matrix3",
				"Color",
				"Quat",
				"Name",
				"String",
				"StringStream",
				"Array",
				"ArrayParameter",
				"BitArray",
				"Geometry",
				"BitMap",
				"DotNETClass",
				"DotNETObject",
				"StructDef",
				"Structure",
				"FileStream",
				"Integer64",
				"BakeElement",
				"Node",
				"Helper",
				"MAXWrapper",
				"MXSFunction",
				"Function",
				"DotNETMethod"
			),
			TypeInfoIDs = #(
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				1,
				2,
				2,
				2
			),
			InfoFns = #(
				ShowProperties,
				ShowMethods,
				ShowInterfaces,
				ShowEvents,
				DotNET.ShowConstructors
			),
			InfoNames = #(
				"Properties:",
				"Methods:",
				"Interfaces:",
				"Events:",
				"Constructors:"
			),
			InfoTags = #(
				#Properties,
				#Methods,
				#Interfaces,
				#Events,
				#Constructors
			),
			DNObjTypes = #(
				#GIMSOps
			),
			ObjNameMapping = #(
				#(),
				#(
					"Mass",
					"Groups",
					"HotSpot",
					"Range",
					"Bounds",
					"Vertices",
					"Shrunk",
					"Extents",
					"Indices",
					"Polys",
					"Portals",
					"Center",
					"MaterialIDs",
					"BreakVerts",
					"DefaultMapFaces",
					"DeleteFaces",
					"GetFacesUsingVert",
					"GetIsoVerts",
					"GetMapFace",
					"GetMapSupport",
					"GetMapVert",
					"IsFinite",
					"RemoveDegenerateFaces",
					"RemoveIllegalFaces",
					"RemoveIsolatedVerts",
					"Points",
					"Cars",
					"Nodes",
					"Normals",
					"Radius",
					"Visible",
					"Destroy",
					"Reversed",
					"Type",
					"MtlID",
					"Siblings",
					"Flags",
					"StartIndex",
					"VertexCount",
					"Already",
					"Normal",
					"Position",
					"Tangent",
					"Idx",
					"Locked",
					"GUI",
					"Body",
					"Name",
					"Pos",
					"SubItems",
					"Button",
					"Align",
					"Images",
					"Forecolor",
					"BackColor",
					"Icon",
					"IconSize",
					"Font",
					"Scrollable",
					"Animated",
					"GUI_Item",
					"Import",
					"Types",
					"Postload",
					"BufferMode",
					"Skip",
					"Create",
					"Split",
					"Regular",
					"Light",
					"Transparent",
					"Warning",
					"Info",
					"Header",
					"Version",
					"MouseDown",
					"MouseMove",
					"MouseUp",
					"Obj",
					"Children",
					"Extension",
					"Items",
					"Data",
					"Read",
					"Write",
					"Load",
					"Compare",
					"Shared",
					"Tag",
					"Init",
					"Load",
					"Start",
					"Node",
					"Helper",
					"Shared",
					"GUI"
				)
			),
			NewTypes,
			HandledObjects,
			HandledObjectNames,
			SendMessage = Windows.SendMessage,
			ProcessPostedMessages,
			EditorWindowType = #MXS_SciTEWindow,
			EditorControlType = #MXS_Scintilla,
			SCI_COPY = 0x882,
			SCI_LINEUP = 0x8FE,
			SCI_LINEUPEXTEND = 0x8FF,
			SCI_LINEDOWNEXTEND = 0x8FD,
			SCI_HOMEWRAP = 0x92D,
			FnUpperBoundPattern = "*struct*(*",
			FnHeaderStartPattern = "*fn*",
			FnHeaderEndPattern = "*=*(*",
			FnHeaderPattern = "*fn*=*(*",
			InfoBlockStartPattern = "/?@*",
			InfoBlockEndPattern = "*?/",
			InfoBlockPattern = "/?@*?/",
			BlockCommentStartPattern = "/?*",
			BlockCommentEndPattern = "*?/",
			BlockCommentPattern = "/?*?/",
		/*GIMS info printer ops*/
			fn GetDotNETObjInfo Obj TabString = (
				local	Data = #(
							(StringStream ""),
							(StringStream ""),
							(StringStream ""),
							(StringStream ""),
							(StringStream "")
						)
				for i = 1 to InfoFns.Count do (
					local	TempStream = Data[i]
					try
						InfoFns[i] Obj To:TempStream
					catch ()
					local	ItemCount = 0
					Seek TempStream 0
					while not (EOF TempStream) do (
						ReadLine TempStream
						ItemCount += 1
					)
					local	InfoTag = InfoTags[i]
					Data[i] = (
						if ItemCount != 0 then (
							local	tData = #()
							tData.Count = ItemCount
							Seek TempStream 0
							for i = 1 to ItemCount do
								tData[i] = (ReadLine TempStream)
							for i = 1 to ItemCount where Have tData[i] do (
								local	Words = (FilterString tData[i] " \t<>:,"),
										ParamString = unsupplied
								case InfoTag of (
									#Properties: (
										local	WordCount = Words.Count
										ParamString = ("<" + Words[2] + "> \t" + (SubString Words[1] 2 -1))
										if WordCount > 2 then (
											ParamString += ":\t"
											for i = 3 to WordCount do (
												if i != 3 then
													ParamString += ", "
												ParamString += Words[i]
											)
										)
									)
									#Methods: (
										local	WordCount = Words.Count
										if WordCount == 1 then
											ParamString = (SubString Words[1] 2 -1)
										else (
											ParamString = ("<" + Words[2] + "> \t" + Words[3])
											if WordCount > 3 then (
												ParamString += " ("
												local	LastWordID = (WordCount - 1)
												for i = 4 to LastWordID by 2 do (
													ParamString += ("\n" + TabString + "\t\t<" + Words[i] + ">\t" + Words[i + 1])
													if i != LastWordID then
														ParamString += ","
												)
												ParamString += ("\n" + TabString + "\t)")
											)
										)
									)
									#Interfaces: (
										ParamString = ""
										ParamString = (Words as String)
									)
									#Events: (
										local	WordCount = Words.Count
										if WordCount == 1 then
											ParamString = (Words[1] + "()")
										else (
											ParamString = Words[1]
											if WordCount > 1 then (
												ParamString += " ("
												for i = 2 to (WordCount - 1) by 2 while Words[i] != "=" do (
													if i != 2 then
														ParamString += ", \t<"
													else
														ParamString += " <"
													ParamString += (Words[i] + "> " + Words[i + 1])
												)
												ParamString += " )"
											)
										)
									)
									#Constructors: (
										ParamString = Words[1]
										local	WordCount = Words.Count
										if WordCount > 1 then (
											ParamString += " ("
											local	LastWordID = (WordCount - 1)
											for i = 2 to LastWordID by 2 do (
												ParamString += ("\n" + TabString + "\t\t<" + Words[i] + ">\t" + Words[i + 1])
												if i != LastWordID then
													ParamString += ","
											)
											ParamString += ("\n" + TabString + "\t)")
										)
									)
								)
								tData[i] = ParamString
							)
							tData
						) else
							undefined
					)
					Free TempStream
				)
				for i = 1 to Data.Count where Have Data[i] do (
					DoLogging #Log TabString InfoNames[i] LineFormat:"%%\n"
					for Param in Data[i] where Have Param do
						DoLogging #Log TabString Param LineFormat:"%\t%\n"
				)
			),
			fn GetObjClass Obj = (
				local	ObjClass = (ClassOf Obj),
						Result = (
							if ObjClass == StructDef then
								#EmptyStruct
							else (
								if (SuperClassOf Obj) == StructDef then
									StructDef
								else
									ObjClass
							)
						)
				if (FindItem Types Result) == 0 then
					AppendIfUnique NewTypes Result
				Result
			),
			fn SendMsg ControlHWND Msg = (
				SendMessage ControlHWND Msg 0 0
				ProcessPostedMessages()
			),
			fn GetControlTextCopy ControlHWND = (
				SendMessage ControlHWND SCI_COPY 0 0
				local	Result,
						tryCount = 0
				while
					No Result and
					tryCount < 10
				do (
					if TryCount != 0 then
						Sleep 0.1
					tryCount += 1
					Result = (GetClipboardText())
					ProcessPostedMessages()
				)
				Result
			),
			fn PrintFn Txt TabString = (
				local	Items = (FilterString Txt " \t\n\\"),
						StartID = 0,
						EndID = 0,
						Result,
						FirstItem = Items[1],
						TypeName,
						FormatText = GIMS.Core.ValueOps.FormatText
				if (MatchPattern FirstItem Pattern:InfoBlockStartPattern) then (
					if (MatchPattern FirstItem Pattern:InfoBlockPattern) then (
						TypeName = (SubString FirstItem 4 (FirstItem.Count - 5))
						DeleteItem Items 1
					) else (
						local	ItemID = 1
						TypeName = (SubString FirstItem 4 -1)
						local	ParsingType = true
						while ParsingType do (
							DeleteItem Items 1
							FirstItem = Items[1]
							if (MatchPattern FirstItem Pattern:InfoBlockEndPattern) then (
								TypeName += (" " + (SubString FirstItem 1 (FirstItem.Count - 2)))
								ParsingType = false
							) else
								TypeName += (" " + FirstItem)
						)
						DeleteItem Items 1
					)
				) else
					TypeName = "<UNKNOWN>"
				if Items.Count < 4 then
					throw ("Wrong function header: " + (TrimRight (TrimLeft Txt)))
				for i = 1 to (Items.Count - 1) while EndID == 0 where
					Items[i] == "=" and
					Items[i + 1] == "("
				do
					EndID = i
				Items.Count = (EndID - 2)
				for i = 1 to Items.Count while StartID == 0 where (Items[i] as name) == #fn do
					StartID = i
				if StartID != 1 then (
					for i = StartID to 1 by -1 do
						DeleteItem Items i
				) else
					DeleteItem Items 1
				Result = Items[1]
				DoLogging #Log (TabString + TypeName) Result LineFormat:"%\t% ("
				local	ItemCount = Items.Count
				if ItemCount == 1 then
					DoLogging #Log ")" "" LineFormat:"%%\n"
				else (
					local	ItemID = 2
					while ItemID <= ItemCount do (
						local	Item = Items[ItemID]
						DoLogging #Log TabString "" LineFormat:"\n%%\t"
						if (MatchPattern Item Pattern:InfoBlockStartPattern) then (
							if (MatchPattern Item Pattern:InfoBlockPattern) then
								DoLogging #Log (SubString Item 4 (Item.Count - 5)) "" LineFormat:"%%"
							else (
								DoLogging #Log (SubString Item 4 -1) "" LineFormat:"%%"
								local	ParsingType = true
								while ParsingType do (
									ItemID += 1
									Item = Items[ItemID]
									if (MatchPattern Item Pattern:InfoBlockEndPattern) then (
										DoLogging #Log (SubString Item 1 (Item.Count - 2)) "" LineFormat:" %%"
										ParsingType = false
									) else
										DoLogging #Log Item "" LineFormat:" %%"
								)
							)
							ItemID += 1
						) else
							DoLogging #Log "<UNKNOWN>" "" LineFormat:"%%"
						Item = Items[ItemID]
						DoLogging #Log Item "" LineFormat:"\t%%"
						if (MatchPattern Item Pattern:"*:*") then (
							local	NextID
							while
								(NextID = (ItemID + 1)) <= ItemCount and
								not (MatchPattern Items[NextID] Pattern:"*:*")
							do (
								DoLogging #Log Items[NextID] "" LineFormat:"%%"
								ItemID += 1
							)
						)
						if ItemID < ItemCount then
							DoLogging #Log "," "" LineFormat:"%%"
						ItemID += 1
					)
					DoLogging #Log TabString "" LineFormat:"\n%%)\n"
				)
				Result
			),
			fn GetFnDefinition TheFn TabString = (
				ShowSource TheFn
				local	HWND,
						HWNDs = (Windows.GetChildrenHWND 0),
						Result
				for tHWND in HWNDs while No HWND where (tHWND[4] as name) == EditorWindowType do
					HWND = tHWND[1]
				if No HWND then
					throw "No HWND"
				local	ChildHWNDs = (Windows.GetChildrenHWND HWND),
						ControlHWND
				for tHWND in ChildHWNDs while No ControlHWND where
					(tHWND[4] as name) == EditorControlType and
					tHWND[5].Count != 0
				do
					ControlHWND = tHWND[1]
				if No ControlHWND then
					throw "No control HWND"
				local	FnHeader,
						FnName = (TheFn as String)
				FnName = (SubString FnName 1 (FnName.Count - 2))
				local	ThisFnHeaderPattern = (FnHeaderStartPattern + FnName + FnHeaderEndPattern),
						FirstTime = true,
						UpperBoundReached = false,
						UpperCheckPending = true,
						FnOK = false
				while
					not FnOK and
					Have (FnHeader = (GetControlTextCopy ControlHWND))
				do (
					FnOK = (MatchPattern FnHeader Pattern:ThisFnHeaderPattern)
					if FnOK then
						Result = (PrintFn FnHeader TabString)
					else (
						if FirstTime then (
							SendMsg ControlHWND SCI_HOMEWRAP
							SendMsg ControlHWND SCI_LINEDOWNEXTEND
							FirstTime = false
						) else (
							if UpperCheckPending then (
								UpperBoundReached = (
									(MatchPattern FnHeader Pattern:FnHeaderPattern) or
									(MatchPattern FnHeader Pattern:FnUpperBoundPattern)
								)
							) else (
								if (MatchPattern FnHeader Pattern:FnHeaderPattern) then (
									local	FakeFnDefinition = "/*@<MISSING DEFINITION>*/ fn ",
											MappedNameID = (FindItem ObjNameMapping[1] (FnName as name))
									if MappedNameID != 0 then
										FnName = ObjNameMapping[2][MappedNameID]
									Append FakeFnDefinition FnName
									Append FakeFnDefinition " = ("
									Result = (PrintFn FakeFnDefinition TabString)
									FnOK = true
								)
							)
							if UpperBoundReached then (
								if UpperCheckPending then (
									ShowSource TheFn
									SendMsg ControlHWND SCI_HOMEWRAP
									SendMsg ControlHWND SCI_LINEUP
									UpperCheckPending = false
								)
								SendMsg ControlHWND SCI_LINEDOWNEXTEND
							) else
								SendMsg ControlHWND SCI_LINEUPEXTEND
						)
					)
				)
				if not FnOK then
					throw ("No FnHeader for: " + TheFn as String)
				Result
			),
			fn PrintHInstance Obj ObjName ObjClass ObjPath TabString ShowSimpleData:false ShowArrayData:false ShowFns:true ShowClassNames:false = (
				local	ObjID = (FindItem HandledObjects Obj),
						NewObject = (ObjID == 0),
						FormatText = GIMS.Core.ValueOps.FormatText
				if ObjPath.Count != 0 then
					ObjPath += "."
				if
					ObjClass == StructDef or
					ObjClass == #EmptyStruct
				then (
					if ObjClass == #EmptyStruct then
						Obj = Obj()
					local	ObjDevInfoPropList = (TryGetProperty Obj #DevInfoPropList Failsafe:undefined),
							ChildNames = (
								if Have ObjDevInfoPropList then
									ObjDevInfoPropList
								else
									(Sort (GetPropNames Obj))
							),
							GIMSObjectLink = (TryGetProperty Obj #GIMSObjectLink)
					if GIMSObjectLink == #GetPropertyFailed then (
						GIMSObjectLink = (
							local	ClassName = ((ClassOf Obj) as String)
							if (MatchPattern ClassName Pattern:"#Struct:*(*") then
								(SubString ClassName 9 ((FindString ClassName "(") - 9))
							else
								ClassName
						)
					)
					local	MappedNameID = (FindItem ObjNameMapping[1] (GIMSObjectLink as name))
					if MappedNameID != 0 then
						ObjName = ObjNameMapping[2][MappedNameID]
					if NewObject then (
						ObjPath += Objname
						Append HandledObjects Obj
						Append HandledObjectNames ObjPath
						if ShowClassNames then (
							DoLogging #Log (
								FormatText \
									v1:TabString \
									v2:"<" \
									v3:TypeNames[FindItem Types ObjClass] \
									v4:": " \
									v5:GIMSObjectLink \
							) ObjName LineFormat:"%>\t% = {\n"
						) else (
							DoLogging #Log (
								FormatText \
									v1:TabString \
									v2:"<" \
									v3:TypeNames[FindItem Types ObjClass] \
							) ObjName LineFormat:"%>\t% = {\n"
						)
						local	LastInfoTypeID
						for TypeID = 1 to Types.Count do (
							local	Type = Types[TypeID],
									TypeInfoID = TypeInfoIDs[TypeID]
							if
								ShowFns or
								TypeInfoID != 2
							then (
								for ChildName in ChildNames where ((FindItem ExcludedStructMemberNames ChildName) == 0) do (
									local	Child = (GetProperty Obj ChildName),
											ChildObjClass = (GetObjClass Child)
									if ChildObjClass == Type then (
										if TypeInfoID != LastInfoTypeID then (
											DoLogging #Log TabString InfoNames[TypeInfoID] LineFormat:"%\t%\n"
											LastInfoTypeID = TypeInfoID
										)
										PrintHInstance Child (ChildName as String) ChildObjClass ObjPath (TabString + "\t\t") ShowSimpleData:ShowSimpleData ShowArrayData:ShowArrayData ShowFns:ShowFns ShowClassNames:ShowClassNames
									)
								)
							)
						)
						DoLogging #Log TabString "" LineFormat:"%%}\n"
					) else (
						if ShowClassNames then (
							DoLogging #Log (
								FormatText \
									v1:TabString \
									v2:"<" \
									v3:TypeNames[FindItem Types ObjClass] \
									v4:": " \
									v5:GIMSObjectLink \
									v6:">\t" \
									v7:ObjName \
							) HandledObjectNames[ObjID] LineFormat:"%:\tAlias of %\n"
						) else (
							DoLogging #Log (
								FormatText \
									v1:TabString \
									v2:"<" \
									v3:TypeNames[FindItem Types ObjClass] \
									v4:">\t" \
									v5:ObjName \
							) HandledObjectNames[ObjID] LineFormat:"%:\tAlias of %\n"
						)
					)
				) else (
					local	MappedNameID = (FindItem ObjNameMapping[1] (ObjName as name))
					if MappedNameID != 0 then
						ObjName = ObjNameMapping[2][MappedNameID]
					if
						ObjClass == DotNETClass or
						ObjClass == DotNETObject or
						ObjClass == DotNETMethod
					then (
						local	DNObjName = (FilterString (Obj as String) ":")[2]
						DoLogging #Log (
							FormatText \
								v1:TabString \
								v2:"<" \
								v3:TypeNames[FindItem Types ObjClass] \
								v4:": " \
								v5:DNObjName \
						) ObjName LineFormat:"%>\t%"
						if ObjClass == DotNETMethod then
							DoLogging #Log "" "" LineFormat:"%%\n"
						else (
							local	DNObjID = (FindItem DNObjTypes (DNObjName as name))
							if DNObjID == 0 then
								DoLogging #Log "" "" LineFormat:"%%\n"
							else (
								DoLogging #Log " = " "{" LineFormat:"%%\n"
								GetDotNETObjInfo Obj (TabString + "\t")
								DoLogging #Log TabString "" LineFormat:"%%}\n"
							)
						)
					) else (
						if ObjClass == MAXScriptFunction then
							ObjName = (GetFnDefinition Obj TabString)
						else (
							if
								ObjClass == Array or
								ObjClass == BitArray or
								ObjClass == ArrayParameter
							then (
								local	ObjCount = Obj.Count
								if ObjCount != 0 then (
									if ObjClass == BitArray then (
										if ShowArrayData then (
											DoLogging #Log (
												FormatText \
													v1:TabString \
													v2:"<" \
													v3:TypeNames[FindItem Types ObjClass] \
													v4:">\t" \
													v5:ObjName \
											) Obj LineFormat:"% = %\n"
										) else (
											DoLogging #Log (
												FormatText \
													v1:TabString \
													v2:"<" \
													v3:TypeNames[FindItem Types ObjClass] \
											) ObjName LineFormat:"%>\t%\n"
										)
									) else (
										DoLogging #Log (
											FormatText \
												v1:TabString \
												v2:"<" \
												v3:TypeNames[FindItem Types ObjClass] \
										) ObjName LineFormat:"%>\t% = #(\n"
										if ShowArrayData then (
											for ItemID = 1 to Obj.Count do (
												local	Item = Obj[ItemID]
												PrintHInstance Child ("[" + ItemID as String + "]") (GetObjClass Item) ObjPath (TabString + "\t") ShowSimpleData:ShowSimpleData ShowArrayData:ShowArrayData ShowFns:ShowFns ShowClassNames:ShowClassNames
											)
										) else (
											local	ArrItemTypes = #(),
													ArrItemCounts = #()
											for Item in Obj do (
												local	ItemClass = (GetObjClass Item),
														TypeNameID = (FindItem ObjNameMapping[1] ((ItemClass as String) as name))
												if TypeNameID != 0 then
													ItemClass = ObjNameMapping[2][TypeNameID]
												local	ItemID = (FindItem ArrItemTypes ItemClass)
												if ItemID == 0 then (
													Append ArrItemTypes ItemClass
													Append ArrItemCounts 1
													ItemID = ArrItemTypes.Count
												) else
													ArrItemCounts[ItemID] += 1
											)
											for TypeID = 1 to ArrItemTypes.Count do (
												DoLogging #Log TabString (
													FormatText \
														v1:ArrItemTypes[TypeID] \
														v2:"[" \
														v3:ArrItemCounts[TypeID] \
												) LineFormat:"%\t<%]>\n"
											)
										)
										DoLogging #Log TabString "" LineFormat:"%%)\n"
									)
								) else (
									DoLogging #Log (
										FormatText \
											v1:TabString \
											v2:"<" \
											v3:TypeNames[FindItem Types ObjClass] \
									) ObjName LineFormat:"%>\t%\n"
								)
							) else (
								if ShowSimpleData then (
									DoLogging #Log (
										FormatText \
											v1:TabString \
											v2:"<" \
											v3:TypeNames[FindItem Types ObjClass] \
											v4:">\t" \
											v5:ObjName \
									) Obj LineFormat:"% = %\n"
								) else (
									DoLogging #Log (
										FormatText \
											v1:TabString \
											v2:"<" \
											v3:TypeNames[FindItem Types ObjClass] \
									) ObjName LineFormat:"%>\t%\n"
								)
							)
						)
						Append HandledObjects Obj
						Append HandledObjectNames (ObjPath + ObjName)
					)
				)
			),
			fn PrintGIMSInfo ShowSimpleData:false ShowArrayData:false ShowFns:true ShowClassNames:false LogFile:LogFilePath = (
				ClearListener()
				ProcessPostedMessages = GIMS.ProcessPostedMessages
				NewTypes = #()
				HandledObjects = #()
				HandledObjectNames = #()
				local	NumNameMappings = ObjNameMapping[2].Count
				ObjNameMapping[1].Count = NumNameMappings
				for i = 1 to NumNameMappings do
					ObjNameMapping[1][i] = (ObjNameMapping[2][i] as name)
				LogFilePath = LogFile
				DoLogging #Start "GIMS Evo Hierarchy" "Start"
				DoLogging #LogEmptyLine undefined undefined
				PrintHInstance GIMS "GIMS" (GetObjClass GIMS) "" "" ShowSimpleData:ShowSimpleData ShowArrayData:ShowArrayData ShowFns:ShowFns ShowClassNames:ShowClassNames
				DoLogging #LogEmptyLine undefined undefined
				DoLogging #Finish "GIMS Evo Hierarchy" "End"
				local	NewTypeCount = NewTypes.Count
				if NewTypeCount != 0 then (
					DoLogging #Log ("Found " + (NewTypeCount as String)) " new object types, which may be weren't displayed properly:" LineFormat:"\n%%\n"
					for Type in NewTypes do
						DoLogging #Log "\t" Type LineFormat:"%%\n"
				)
				OK
			)
	)
	
	struct /*#PC*PATH	GIMS.Core*/ Corestr (
		/*PROPS*/		ConfigProps = ConfigPropsstr(),
						ArrayMap = ArrayMapstr,
		/*FUNCTIONS*/	BufferMgr = BufferMgrstr(),
						ObjectMgr = ObjectMgrstr(),
						ArrayOps = ArrayOpsstr(),
						StringOps = StringOpsstr(),
						ValueOps = ValueOpsstr(),
						ConfigOps = ConfigOpsstr(),
						GUIMgr = GUIMgrstr(),
						SystemMgr = SystemMgrstr(),
						CoreOps = CoreOpsstr(),
						CacheMgr = CacheMgrstr(),
						MaterialOps = MaterialOpsstr(),
						DevMgr = DevMgrstr(),
		/*PARTS*/		strRules = Rulesstr,
						TypeLibrary,
						MAXFactory,
						DB,
						GUI,
		/*INFO*/		DevInfoPropList = #(
							#ConfigProps,
							#ConfigOps,
							#SystemMgr,
							#CoreOps,
							#DB,
							#GUIMgr,
							#GUI,
							#BufferMgr,
							#ObjectMgr,
							#ArrayOps,
							#StringOps,
							#ValueOps,
							#CacheMgr,
							#MaterialOps,
							#DevMgr,
							#TypeLibrary,
							#MAXFactory
						)
	)
	
	GIMS.Core = Corestr()
	GIMS.CurrentGame.Core = GIMS.Core
	GIMS.CoreLoader = (
		if EGIMS_CheckEULA() then
			GIMS.Core.CoreOps.LoadGame
		else
			#EULARejected
	)
/*<ERRHANDLER>*/) catch (
	local	CET = (GetCurrentException()),
		Reported = (
			try (
				local	ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS
				true
			) catch
				false
		)
	if not Reported then (
		Reported = true
		try
			_CompileError = GIMS.Core.SystemMgr.ErrorStream
		catch
		--	Reported = false
		--if not Reported then
			throw
	)
)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)

if _CompileError != undefined then
	throw _CompileError
