
--						!!!WARNING!!!	EXECUTE THIS WHOLE SCRIPT BEFORE DOING ANYTHING FROM THE COMMENTED OUT ZONE	!!!WARNING!!!
	
/*PROFILER
	EGIMS_DumpProfiler()
	GC()
	GC()
	
	EGIMS_DumpProfiler AllowFull:false
	GC()
	GC()
	
	EGIMS_ResetProfiler()
	GC()
	GC()
/**/
/*Export GUI layouts
	GIMS.Core.DevMgr.ExportGUI()
/**/
/*Import GUI layouts
(
	local	ConvertStruct = GIMS.Core.ValueOps.ConvertStruct,
			LayoutPropMapping = #(
				#(
					#Name,
					#Pos,
					#Lang,
					#CoreTag,
					#ItemText,
					#EvtOnLoadCore,
					#EvtOnCloseCore,
					#HeaderTextAlign,
					#EvtOnLoad,
					#EvtOnClose,
					#HasBackButton,
					#StoreInRolloutChain,
					#BackColor,
					#ForeColor
				)
			),
			ItemPropMapping = #(
				#(
					#Name,
					#Pos,
					#ItemSize,
					#DefaultState,
					#CheckState,
					#ChangeIcon,
					#Animated,
					#Icon,
					#IconSize,
					#ItemType,
					#ItemText,
					#Font,
					#BackColor,
					#ForeColor,
					#ScrollOrient,
					#SelectionMode,
					#EventTypes,
					#EventCores,
					#EventNames,
					#Clickable,
					#Scrollable,
					#GroupID,
					#TextAlign
				)
			)
	LayoutPropMapping[2] = LayoutPropMapping[1]
	ItemPropMapping[2] = ItemPropMapping[1]
			
	fn HandleSubItems ParentNode Str = (
		local	SubItems = Str.SubItems
		for i = 1 to SubItems.Count do (
			local	Item = SubItems[i]
			if Have Item then (
				local	SubItem = (ConvertStruct Item EGIMS_GUI_Item PropMapping:ItemPropMapping AllowOwnProps:false)
				SubItem.Parent = ParentNode
				SubItem.WireColor = Blue
				ParentNode.SubItems[i] = SubItem
				HandleSubItems SubItem Item
			)
		)
		OK
	)
	
	local	GameLayouts = (for GameCore in GIMS.Cores collect (FileIn (GameCore.FilesPath + "English.GIP")))
	
	for Layouts in GameLayouts do (
		for lay in Layouts do (
			local	LayObj = (ConvertStruct lay EGIMS_GUI_Layout PropMapping:LayoutPropMapping AllowOwnProps:false)
			LayObj.WireColor = Black
			HandleSubItems LayObj lay
		)
	)
	OK
)
/**/
/*	RELEASE

--	ServerDir = ""
-- 	ServerDir = "NR\\"
-- 	ServerDir = "Test\\"	--MP3 test path
-- 	ServerDir = "TestNR\\"
-- 	ServerDir = "TestMP3\\"
-- 	ServerDir = "TestV\\"
-- 	ServerDir = "TestNFS\\"
-- 	ServerDir = "UpdateTest\\"
 	ServerDir = "Staging/"

	ResetCache = #()
	ReleaseParts = #()

-- 	Append ResetCache #Shared

-- 	Append ResetCache #AE
-- 	Append ResetCache #MP3
-- 	Append ResetCache #NR
-- 	Append ResetCache #V
-- 	Append ResetCache #NFS

	(
		Append ReleaseParts GIMS.Shared

-- 		Append ReleaseParts GIMS.AE
		Append ReleaseParts GIMS.MP3
		Append ReleaseParts GIMS.NR
		Append ReleaseParts GIMS.V
-- 		Append ReleaseParts GIMS.NFS

		OK
	)
	
	WinRarPath = "Z:\\SOFT\\WinRAR\\rar "
	DropboxPath = "Z:\\Dropbox\\"

	Release WinRarPath DropboxPath ResetCache:ResetCache ReleaseParts:ReleaseParts ServerDir:ServerDir
	
	#READY

RELEASE	*/
/*	CCF

--	ServerDir = ""
-- 	ServerDir = "NR/"
--	ServerDir = "Test/"	--MP3 test path
-- 	ServerDir = "TestNR/"
-- 	ServerDir = "TestMP3/"
-- 	ServerDir = "TestV/"
-- 	ServerDir = "TestNFS/"
-- 	ServerDir = "UpdateTest/"
	ServerDir = "Staging/"

	GenerateCoreConfig ServerDir #(
		#(	--enable flags
			true,	--shared	--DONT SET FALSE!!!
			true,	--AE
			true,	--MP3
			true,	--NR
			true,	--V
			false	--NFS
		), #(	--IsShared flags
			true,	--DONT SET FALSE!!!
			false,
			false,
			false,
			false,
			false
		), #(	--TAGS
			undefined,	--dont need - it sets automatically
			"AE",
			"MP3",
			"NR",
			"V",
			"NFS"
		), #(	--NAMES
			undefined,	--dont need - it sets automatically
			"Abyss Engine",
			"Max Payne 3",
			"Ninja Ripper",
			"GTA V",
			"NFS"
		), #(	--ServerURLs
			if ServerDir.Count != 0 then (for sURL in GIMS.ServerURLs collect (sURL + ServerDir)) else undefined,
			undefined,
			undefined,
			undefined,
			undefined,
			undefined
		), #(	--RussianSupport links
			undefined,	--dont need - it sets automatically
			"http://gtamaps.net/forum/index.php?showuser=7034",	--its default, replace that!
			"http://gtamaps.net/forum/index.php?showtopic=14862",
			"http://cgig.ru/ninjaripper/",
			"http://gtamaps.net/forum/index.php?showtopic=14920",
			"http://gtamaps.net/forum/index.php?showuser=7034"	--its default, replace that!
		), #(	--IntlSupport links
			undefined,	--dont need - it sets automatically
			"http://gtaforums.com/user/203669-3doomer/",	--its default, replace that!
			"http://gtaforums.com/user/203669-3doomer/",	--its default, replace that!
			"http://cgig.ru/ninjaripper/",
			"http://gtaforums.com/topic/836266-vrel-gims-evo-for-gta-v/",
			"http://gtaforums.com/user/203669-3doomer/"	--its default, replace that!
		)
	)
	#READY
	
CCF	*/

-----------------	CODE	---------------------

fn GenerateCoreConfig ServerDir Cores = (
		/*Cores format:
		#(
			#{
				IsShared flags
			}, #(
				TAGS
			), #(
				NAMES
			), #(
				ServerURLs
			), #(
				RussianSupport links
			), #(
				IntlSupport links
			)
		)
		*/
		local	FileDelete = GIMS.Core.SystemMgr.FileDelete,
				CCFPath = (ScriptsPath + "\\Startup\\"),
				CCFNameTemp = ("GIMS.ccf.tmp." + (timeStamp() as String)),
				CCFNameTarget = "GIMS.ccf",
				CFFPathTemp = (CCFPath + CCFNameTemp),
				CCFPathTarget = (CCFPath + CCFNameTarget)
		FileDelete CFFPathTemp
		local	CCFStream = (CreateFile CFFPathTemp)
		if CCFStream == undefined then
			throw "GenerateCoreConfig error: Can't create temp CCF"
		try (
			Format "#(\n" To:CCFStream
			local	EnableFlags = Cores[1],
					IsSharedFlags = Cores[2],
					Tags = Cores[3],
					Names = Cores[4],
					ServerURLs = Cores[5],
					RussianSupports = Cores[6],
					IntlSupports = Cores[7],
					CoreCount = Tags.Count,
					IsFirstCore = true
			for CoreID = 1 to CoreCount where EnableFlags[CoreID] do (
				local	IsShared = IsSharedFlags[CoreID],
						Tag = Tags[CoreID],
						cName = Names[CoreID],
						tServerURLs = ServerURLs[CoreID],
						RussianSupport = RussianSupports[CoreID],
						IntlSupport = IntlSupports[CoreID],
						DataSet = false
				if IsFirstCore then (
					Format "\t(\n" To:CCFStream
					IsFirstCore = false
				) else
					Format "\t,(\n" To:CCFStream
				if IsShared then
					Format "\tSharedCore \\\n" To:CCFStream
				else (
					Format "\tGameCore \\\n" To:CCFStream
					if No Tag then
						throw "GenerateCoreConfig error: No Tag in core " CoreID
					Format "\t\tTag:\"%\" \\\n" Tag To:CCFStream
					if No cName then
						throw "GenerateCoreConfig error: No Name in core " CoreID
					Format "\t\tName:\"%\" \\\n" cName To:CCFStream
					if Have IntlSupport then
						Format "\t\tIntlSupport:\"%\" \\\n" IntlSupport To:CCFStream
					if Have RussianSupport then
						Format "\t\tRussianSupport:\"%\" \\\n" RussianSupport To:CCFStream
					DataSet = true
				)
				if Have tServerURLs then (
					Format "\t\tServerURLs:#(" To:CCFStream
					for i = 1 to tServerURLs.Count do (
						if i == tServerURLs.Count then
							Format "\"%\"" tServerURLs[i] To:CCFStream
						else
							Format "\"%\", " tServerURLs[i] To:CCFStream
						isFirst = false
					)
					Format ")\\\n" To:CCFStream
					DataSet = true
				)
				if not DataSet then
					Format "\t\t() \\\n" To:CCFStream
				Format "\t)\n" To:CCFStream
			)
			Format ")\n" To:CCFStream
			Close CCFStream
		) catch (
			Close CCFStream
			throw
		)
		Free CCFStream
		FileDelete CCFPathTarget
		EncryptFile CFFPathTemp CCFPathTarget (GetHashValue "IHateShittyConfigs" 777)
		if not (DoesFileExist CCFPathTarget) then
			throw "GenerateCoreConfig error: Can't encrypt CCF"
		FileDelete CFFPathTemp
		OK
)
fn PrepareReleaseFiles TempFiles TempCore ReleaseDir SourcesDir ExtensionTag CfgTag IncludePattern = (
		local	FilesToZIP = "",
				FilesPath = TempCore.FilesPath,
				FilesToSourceCopy = (GetFiles (FilesPath + "*")),
				FilesToRelease = (DeepCopy FilesToSourceCopy),
				WebDownloadPath = (ReleaseDir + TempCore.Tag + "\\Files\\"),
				WebSourcesPath = (SourcesDir + TempCore.Tag + "\\Files\\"),
				BufferMgr = GIMS.Core.BufferMgr,
				ReadFile = BufferMgr.ReadFile,
				BufferMgrCreate = BufferMgr.Create,
				NotEOF = BufferMgr.NotEOF,
				ReadVal = BufferMgr.ReadVal,
				WriteVal = BufferMgr.WriteVal,
				WriteFile = BufferMgr.WriteFile,
				ClearBuffer = BufferMgr.ClearBuffer,
				TypeCast = GIMS.Core.ValueOps.TypeCast,
				ReplaceChars = GIMS.Core.StringOps.ReplaceChars,
				PrecompilePath = TempCore.BackupPath
				
		/*remove paths file*
		for i = FilesToRelease.count to 1 by -1 where
			(TypeCast (GetFileNameFile FilesToRelease[i]) name) == #Paths
		do (
			DeleteItem FilesToRelease i
			DeleteItem FilesToSourceCopy i
		)
		/**/
		
		/*collect includes*/
		local	IncludeFiles = (GetFiles (FilesPath + IncludePattern)),
				ReplaceTags = #(#(), #())
		for tFile in IncludeFiles do (
			Append ReplaceTags[1] (FileNameFromPath tFile)
			Append ReplaceTags[2] ((GetFileNameFile tFile) + ".mse")
		)
		/**/
		
		--process release files
		for i = 1 to FilesToRelease.Count do (
			local	tFile = FilesToRelease[i],
					fName = (GetFileNameFile tFile),
					fNameType = (FileNameFromPath tFile),
					FileTypename = (TypeCast (GetFileNameType tFile) name)
			if FileTypename == ExtensionTag then (
				FilesToZIP += (" \"" + WebDownloadPath + fName + ".mse\"")
			
				/*precompile*/
				local	PrecompiledFile = (PrecompilePath + fNameType),
						BufIDIn = (ReadFile tFile),
						BufIDOut = (BufferMgrCreate())
				if BufIDIn == false then
					throw "Can't read source file: " tFile
				if BufIDOut == false then
					throw "Can't create a buffer for target file: " PrecompiledFile
				while (NotEOF BufIDIn) do (
				
					--read old line
					local	tLine = (ReadVal BufIDIn),
							TrimmedLine = (TrimLeft tLine)
					if
						(TrimmedLine[1] != "-") or
						(TrimmedLine[2] != "-")
					then (
					
						--fix include files extension
						tLine = (ReplaceChars tLine ReplaceTags:ReplaceTags)
					
					)
					
					--write new line
					WriteVal BufIDOut tLine
				)
				
				--store precompiled file
				Append TempFiles PrecompiledFile
				FilesToRelease[i] = PrecompiledFile
				WriteFile BufIDOut FilePath:PrecompiledFile
				ClearBuffer BufIDIn
				ClearBuffer BufIDOut
				/**/
			) else (
				if FileTypename == CfgTag then
					FilesToZIP += (" \"" + FilesPath + fNameType + "\"")
				else
					FilesToZIP += (" \"" + WebDownloadPath + fNameType + "\"")
			)
		)
		#(FilesToZIP, FilesToRelease, WebDownloadPath, WebSourcesPath, FilesToSourceCopy)
)

fn Release WinRarPath DropboxPath ResetCache:#() ReleaseParts:#() ServerDir:undefined = (
	/*<ERRHANDLERSTART>*/try (
	if not GIMS.IsDevBuild then
		return OK

	/*preload shared core*/
	if not (GIMS.Shared.Start GIMS.Shared) then
		throw "Core load failed: " GIMS.Shared.Name
	/**/

	/*preload release cores*/
	for TempCore in ReleaseParts where (
		TempCore != GIMS.Shared and
		not (TempCore.Start TempCore) 
	) do
		throw "Core loading failed: " TempCore.Name
	/**/

	MessageBox "Do all needed GIMS file name or path changes, and enable web sync now, before closing this message.\nNext step will collect release files and remove delayed web files to temporarily disable clients update." title:"GIMS Evo releaser"
	local	IsSuccess = true,
			FileCopy = GIMS.Core.SystemMgr.FileCopy,
			FileDelete = GIMS.Core.SystemMgr.FileDelete,
			TypeCast = GIMS.Core.ValueOps.TypeCast,
			ScriptExtension = ".ms",
			ExtensionTag = (TypeCast ".ms" name),
			CfgTag = (TypeCast ".cfg" name),
			IncludePattern = ("I_*" + ScriptExtension),
			OldCacheResetDate = (GIMS.Core.ConfigOps.GetTime #CacheResetDate),
			RAWBuildDate = (GIMS.Core.ConfigOps.GetTime #Build),
			BuildDate = (GIMS.Core.ConfigOps.TimeToString RAWBuildDate),
			SourcesDir = (DropboxPath + "Projects\\GIMS\\Evo\\" + (GIMS.Core.StringOps.ReplaceChars BuildDate ReplaceTags:#(#(":"), #("."))) + "\\"),
			ReleaseDir = (DropboxPath + "Public\\GIMS\\" + ServerDir),
			GUISourcesDir = (SourcesDir + "GIMS_GUI\\"),
			GUIFiles = (GetFiles (GIMS.ScriptPath + "GIMS_GUI\\*")),
			GUIFilesString = "",
			CoreFilesToZIP = #(),
			CoreFilesToRelease = #(),
			CoreFilesToSourceCopy = #(),
			CoreDlPaths = #(),
			CoreSourcePaths = #(),
			TempFiles = #(),
			Data = (PrepareReleaseFiles TempFiles GIMS.Shared ReleaseDir SourcesDir ExtensionTag CfgTag IncludePattern), --collect shared files
			SharedFilesToZIP = Data[1],
			SharedFilesToRelease = Data[2],
			SharedDlPath = Data[3],
			SharedSourcePath = Data[4],
			SharedFilesToSourceCopy = Data[5],
			ReadMeGames = #(),
			ReadMeGamesPart2 = #(),
			RuSupportText = GIMS.Shared.RussianSupport,
			IntlSupportText = (
				if (StriCmp GIMS.Shared.IntlSupport RuSupportText) == 0 then (
					RuSupportText = unsupplied
					"	International forum: " + GIMS.Shared.IntlSupport
				) else
					"	International forum: " + GIMS.Shared.IntlSupport
			)
			
	/*collect release core files*/
	for TempCore in ReleaseParts do (
		if TempCore == GIMS.Shared then
			Data = #()
		else (
			Data = (PrepareReleaseFiles TempFiles TempCore ReleaseDir SourcesDir ExtensionTag CfgTag IncludePattern)
			Append ReadMeGames TempCore.Name
			Append ReadMeGamesPart2 (TempCore.Name + " script support:")
			if (StriCmp TempCore.RussianSupport TempCore.IntlSupport) == 0 then
				Append ReadMeGamesPart2 ("	International forum" + TempCore.IntlSupport)
			else (
				Append ReadMeGamesPart2 ("	Russian forum: " + TempCore.RussianSupport)
				Append ReadMeGamesPart2 ("	International forum: " + TempCore.IntlSupport)
			)
		)
		Append CoreFilesToZIP Data[1]
		Append CoreFilesToRelease Data[2]
		Append CoreDlPaths Data[3]
		Append CoreSourcePaths Data[4]
		Append CoreFilesToSourceCopy Data[5]
	)
	/**/

	/*collect and remove delayed files from the server*/
	local	DelayedCopyFiles = #()
	for CoreID = 1 to ReleaseParts.Count do (
		local	TempCore = ReleaseParts[CoreID],
				Tag = (TypeCast (TempCore.Tag as String) name),
				FilesToRelease, WebDownloadPath
		GIMS.CurrentGame = TempCore /*temp setting set for functions*/
		if Tag == #Shared then (
			FilesToRelease = SharedFilesToRelease
			WebDownloadPath = SharedDlPath
		) else (
			FilesToRelease = CoreFilesToRelease[CoreID]
			WebDownloadPath = CoreDlPaths[CoreID]
		)
		for tFile in FilesToRelease do (
			local	FileName = (FileNameFromPath tFile),
					FileTypename = (TypeCast (GetFileNameType FileName) name)
			if FileTypename == CfgTag then (
				local	WebFile = (WebDownloadPath + FileName)
				FileDelete WebFile
				Append DelayedCopyFiles #(tFile, WebFile)
			)
		)
	)
	/**/

	/*make web changes*/
	MessageBox "Please wait for web sync now, and then pause it.\nNext step will change web files." title:"GIMS Evo releaser"
	for tFile in (getfiles (SourcesDir + "*")) do
		FileDelete tFile
	MakeDir GUISourcesDir All:true
	MakeDir ReleaseDir All:true
	FileCopy (GIMS.ScriptPath + "GIMS.ms") (SourcesDir + "GIMS.ms")
	FileCopy (GIMS.ScriptPath + "GIMS.ccf") (SourcesDir + "GIMS.ccf")
	EncryptScript (GIMS.ScriptPath + "GIMS.ms")
	for tFile in GUIFiles do (
		GUIFilesString += (" \"" + tFile + "\"")
		FileCopy tFile (GUISourcesDir + (FileNameFromPath tFile))
	)
	/**/

	/*create text files*/
		local	ReadMe = (
					#(
						"Game Indefinite Modding Suite Evolved(GIMS Evo) online installed version",
						"",
						"=====GAME SUPPORT=====",
						""
					) + ReadMeGames + #(
						"",
						"=====SYSTEM REQUIREMENTS=====",
						"",
						"PC:",
						"	RAM: minimum 2 Gb(with equal or bigger swap file), recommended 4 or more.",
						"	Internet connection(for setup and updates).",
						"Software:",
						"	Windows 7, or any newer version.",
						"	.NET Framework 4.0.",
						"	Any 3D MAX version from 9(with Service Pack 2 and \"AvGuard DLX Extension\") to 2016.",
						"	Also, it's highly recommended to install the latest 3D MAX updates and service packs.",
						"",
						"=====INSTALLATION=====",
						"",
						"1) Extract \"scripts\" folder into the 3D MAX directory with files replacement.",
						"2) Start 3D MAX, check your internet connection, and install GIMS from the Utilities tab",
						"",
						"=====CREDITS=====",
						"",
						"Developer: Mansurov Sergey a.K.a. 3Doomer",
						"E-mail: 3Doomer2@gmail.com",
						"",
						"=====DONATION=====",
						"",
						"I appreciate any financial assistance on this project ;-) ",
						"Also, we can discuss some other games support if you wish. ",
						"",
						"PayPal: 3Doomer2@gmail.com",
						"boosty.to/3Doomer",
						"patreon.com/GIMS",
						"",
						"=====LINKS=====",
						""
					) + (
						if Supplied RuSupportText then (
							#(
								"Developer:",
								IntlSupportText,
								"	Russian forum: " + RuSupportText,
								""
							)
						) else (
							#(
								"Developer:",
								IntlSupportText,
								""
							)
						)
					) + ReadMeGamesPart2
				),
				ManualReadMe = (
					#(
						"Game Indefinite Modding Suite Evolved(GIMS Evo) manual installed version",
						"",
						"=====GAME SUPPORT=====",
						""
					) + ReadMeGames + #(
						"",
						"=====SYSTEM REQUIREMENTS=====",
						"",
						"PC:",
						"	RAM: minimum 2 Gb(with equal or bigger swap file), recommended 4 or more.",
						"	Internet connection(for setup and updates).",
						"Software:",
						"	Windows 7, or any newer version.",
						"	.NET Framework 4.0.",
						"	Any 3D MAX version from 9(with Service Pack 2 and \"AvGuard DLX Extension\") to 2016.",
						"	Also, it's highly recommended to install the latest 3D MAX updates and service packs.",
						"",
						"=====INSTALLATION=====",
						"",
						"1) Extract \"scripts\" folder into the 3D MAX directory with files replacement.",
						"2) Extract \"GIMS\" folder with files replacement into:",
						"	Windows Vista/7/8: \"<DRIVE>:\\Users\\<USER_NAME>\\AppData\\Local\\\"",
						"	Windows 2K/XP: \"<DRIVE>:\\Documents and Settings\\<USER_NAME>\\Application Data\\\"",
						"	If you have some errors with GIMS Evo loading, run one of those scripts",
						"		to get the installation path:",
						"		github.com/3Doomer/GIMS-Evo/raw/master/Release/Tools/ShowEGIMSPath.ms",
						"		gims.openiv.com/downloads/GIMS/ShowEGIMSPath.ms",
						"3) Start 3D MAX, check your internet connection, and install GIMS from the Utilities tab",
						"",
						"=====CREDITS=====",
						"",
						"Developer: Mansurov Sergey a.K.a. 3Doomer",
						"E-mail: 3Doomer2@gmail.com",
						"",
						"=====DONATION=====",
						"",
						"I appreciate any financial assistance on this project ;-) ",
						"Also, we can discuss some other games support if you wish. ",
						"",
						"PayPal: 3Doomer2@gmail.com",
						"boosty.to/3Doomer",
						"patreon.com/GIMS",
						"",
						"=====CONTACTS=====",
						""
					) + (
						if Supplied RuSupportText then (
							#(
								"Developer:",
								IntlSupportText,
								"	Russian forum: " + RuSupportText,
								""
							)
						) else (
							#(
								"Developer:",
								IntlSupportText,
								""
							)
						)
					) + ReadMeGamesPart2
				)
		FileDelete (GIMS.Shared.DownloadPath + "WEB_INSTALL_NOTES.txt")
		FileDelete (GIMS.Shared.DownloadPath + "MANUAL_INSTALL_NOTES.txt")
		GIMS.Core.SystemMgr.NETFileIO.WriteAllLines (GIMS.Shared.DownloadPath + "WEB_INSTALL_NOTES.txt") ReadMe
		GIMS.Core.SystemMgr.NETFileIO.WriteAllLines (GIMS.Shared.DownloadPath + "MANUAL_INSTALL_NOTES.txt") ManualReadMe
	/**/

	/*copy new files*/
	local	CoreZipCmds = #()
	for CoreID = 1 to ReleaseParts.Count do (
		local	TempCore = ReleaseParts[CoreID],
				FilesPath = TempCore.FilesPath,
				StringTag = (TempCore.Tag as String),
				Tag = (TypeCast StringTag name),
				FilesToZIP, FilesToRelease, WebSourcesPath, WebDownloadPath, FilesToSourceCopy
		GIMS.CurrentGame = TempCore /*temp setting set for functions*/
		if Tag == #Shared then (
			FilesToZIP = SharedFilesToZIP
			FilesToRelease = SharedFilesToRelease
			FilesToSourceCopy = SharedFilesToSourceCopy
			WebDownloadPath = SharedDlPath
			WebSourcesPath = SharedSourcePath
		) else (
			FilesToZIP = CoreFilesToZIP[CoreID]
			FilesToRelease = CoreFilesToRelease[CoreID]
			FilesToSourceCopy = CoreFilesToSourceCopy[CoreID]
			WebDownloadPath = CoreDlPaths[CoreID]
			WebSourcesPath = CoreSourcePaths[CoreID]
		)
		Append CoreZipCmds ("a -m5 -ep -apGIMS\\" + StringTag + "\\Files \"" + ReleaseDir + "EvoGIMS_manualinstall\" " + FilesToZIP)
		/*prepare folders*/
			MakeDir WebSourcesPath All:true
			MakeDir WebDownloadPath All:true
			for tFile in (getfiles (WebSourcesPath + "*") + getfiles (WebDownloadPath + "*")) do
				FileDelete tFile
		/**/
		/*copy sources*/
			for tFile in FilesToSourceCopy do
				FileCopy tFile (WebSourcesPath + (FileNameFromPath tFile))
		/**/
		/*encrypt files*/
			for tFile in FilesToRelease do (
				local	FileName = (FileNameFromPath tFile)
				if FileName[1] != "_" then (
					local	TypeStr = (GetFileNameType FileName),
							TypeName = (TypeCast TypeStr name)
					if TypeName == ExtensionTag then (
						EncryptScript tFile
						local	EncryptedNametype = ((GetFileNameFile FileName) + ".mse"),
								EncryptedFile = (FilesPath + EncryptedNametype)
						RenameFile ((GetFileNamePath tFile) + EncryptedNametype) EncryptedFile
						Append TempFiles EncryptedFile
					)
				)
			)
		/**/
		/*set config*/
			TempCore.Core.ConfigProps.RAWBuildDate = RAWBuildDate
			TempCore.Core.ConfigProps.BuildDate = BuildDate
			TempCore.Core.ConfigProps.CacheResetDate = (
				if (FindItem ResetCache Tag) != 0 then
					RAWBuildDate
				else
					OldCacheResetDate
			)
			GIMS.Core.ConfigOps.WriteConfigFile true
		/**/
		/*copy files*/
			FileCopy (GIMS.ScriptPath + "GIMS.mse") (ReleaseDir + "GIMS.mse")
			FileCopy (GIMS.ScriptPath + "GIMS.ccf") (ReleaseDir + "GIMS.ccf")
			for tFile in FilesToRelease do (
				local	FileName = (FileNameFromPath tFile),
						FileTypename = (TypeCast (GetFileNameType FileName) name)
				case FileTypename of (
					ExtensionTag: (
						local	EncryptedFileName = ((GetFileNameFile FileName) + ".mse")
						FileCopy (FilesPath + EncryptedFileName) (WebDownloadPath + EncryptedFileName)
					)
					CfgTag: ()	--delayed, processed earlier
					Default:
						FileCopy tFile (WebDownloadPath + FileName)
				)
			)
		/**/
	)
	/**/

	/*zip file!*/

		FileDelete (ReleaseDir + "EvoGIMS_webinstall.rar")
		FileDelete (ReleaseDir + "EvoGIMS_manualinstall.rar")
		
		ClearListener()
		
		local	PackCommands = #(
					("a -m5 -ep -apscripts/startup \"" + ReleaseDir + "EvoGIMS_webinstall\" \"" + GIMS.ScriptPath + "GIMS.mse\""),
					("a -m5 -ep -apscripts/startup \"" + ReleaseDir + "EvoGIMS_webinstall\" \"" + GIMS.ScriptPath + "GIMS.ccf\""),
					("a -m5 -ep -apscripts/startup/GIMS_GUI \"" + ReleaseDir + "EvoGIMS_webinstall\" " + GUIFilesString),
					("a -m5 -ep \"" + ReleaseDir + "EvoGIMS_webinstall\" \"" + GIMS.Shared.DownloadPath + "WEB_INSTALL_NOTES.txt\""),
					("c -z" + GIMS.Shared.DownloadPath + "WEB_INSTALL_NOTES.txt" + " \"" + ReleaseDir + "EvoGIMS_webinstall\"")
				)
		for CmdID = 1 to PackCommands.Count do (
			local	Cmd = PackCommands[CmdID],
					CmdResult = (DOSCommand (WinRarPath + Cmd + " || pause"))
			if CmdResult != 0 then (
				Format "WEBINST RAR command\t%\tfailed with code\t%%:\t%\n" CmdID CmdResult WinRarPath Cmd
				IsSuccess = false
			)
		)
				
		for CmdID = 1 to CoreZipCmds.Count do (
			local	Cmd = CoreZipCmds[CmdID],
					CmdResult = (DOSCommand (WinRarPath + Cmd + " || pause"))
			if CmdResult != 0 then (
				Format "CORE RAR command\t%\tfailed with code\t%:\t%%\n" CmdID CmdResult WinRarPath Cmd
				IsSuccess = false
			)
		)

		PackCommands = #(
			("a -m5 -ep -apscripts/startup \"" + ReleaseDir + "EvoGIMS_manualinstall\" \"" + GIMS.ScriptPath + "GIMS.mse\""),
			("a -m5 -ep -apscripts/startup \"" + ReleaseDir + "EvoGIMS_manualinstall\" \"" + GIMS.ScriptPath + "GIMS.ccf\""),
			("a -m5 -ep -apscripts/startup/GIMS_GUI \"" + ReleaseDir + "EvoGIMS_manualinstall\" " + GUIFilesString),
			("a -m5 -ep \"" + ReleaseDir + "EvoGIMS_manualinstall\" \"" + GIMS.Shared.DownloadPath + "MANUAL_INSTALL_NOTES.txt\""),
			("c -z" + GIMS.Shared.DownloadPath + "MANUAL_INSTALL_NOTES.txt" + " \"" + ReleaseDir + "EvoGIMS_manualinstall\"")
		)
		for CmdID = 1 to PackCommands.Count do (
			local	Cmd = PackCommands[CmdID],
					CmdResult = (DOSCommand (WinRarPath + Cmd + " || pause"))
			if CmdResult != 0 then (
				Format "MANINST RAR command\t%\tfailed with code\t%:\t%%\n" CmdID CmdResult WinRarPath Cmd
				IsSuccess = false
			)
		)
	/**/

	/*cleanup*/
		FileDelete (GIMS.Shared.DownloadPath + "WEB_INSTALL_NOTES.txt")
		FileDelete (GIMS.ScriptPath + "GIMS.mse")
		for File in TempFiles do
			FileDelete File
		Free TempFiles
	/**/

	/*finalize release*/
	if IsSuccess then (
		local	Msg = "Complete.\nPlease unpause web sync and wait until it's complete now, before closing this message.\nIf the main script version's changed, you should upload new GIMS packages to all websites.\nNext step will upload delayed files to re-enable clients update:"
		for DelayedCopyFile in DelayedCopyFiles do
			Append Msg ("\n\t" + (DelayedCopyFile as String))
		MessageBox Msg Title:"GIMS Evo release"
		for DelayedCopyFile in DelayedCopyFiles do (
			FileCopy DelayedCopyFile[1] DelayedCopyFile[2]
			Sleep 2
		)
	) else
		MessageBox "Release failed! Please check the MAXScript Listener." Title:"GIMS Evo release"
	/**/

	/*restore dev configs*/
	for CoreID = 1 to ReleaseParts.Count do (
		GIMS.CurrentGame = ReleaseParts[CoreID] /*temp setting set for functions*/
		GIMS.Core.ConfigOps.WriteConfigFile false
	)
	/**/

	/*restart cores*/
	GIMS.Shared.Start GIMS.Shared /*load released shared core*/
	for TempCore in ReleaseParts where TempCore != GIMS.Shared do /*load released cores*/
		TempCore.Start TempCore
	/**/

	OK
	/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
)
