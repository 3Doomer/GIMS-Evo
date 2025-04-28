GIMSVersion = 12
global	FailText = "Can't load GIMS! Error:\n\n",
			Checksum = FailText.Count,
			SharedCore, GameCore, strGUI

if HiddenDOSCommand != undefined then (
global	GIMS, uEvoGIMS, EGIMS_LangSelectRollout
UtilityDummySource = (
	"utility UtilityDummy" +
	((TimeStamp()) as String) +
	" \"UtilityDummy\" (\n)"
)
UtilityDummy = (Execute UtilityDummySource)
OpenUtility UtilityDummy
global	UtilityWidth = UtilityDummy.Width
CloseUtility UtilityDummy
UtilityDummy = undefined
try (CloseUtility uEvoGIMS)	catch ()
uEvoGIMS = undefined
try (DestroyDialog EGIMS_LangSelectRollout)	catch ()
rollout EGIMS_LangSelectRollout "EGIMS_LangSelectRollout" Width:200 Height:31 (
)

global	TempScriptPath = (Append ScriptsPath "Startup\\"),
		EGIMS_CoreConfigFileName = "GIMS.ccf",
		EGIMS_DevGIMSFileName = "GIMS.ms",
		EGIMS_PublicGIMSFileName = "GIMS.mse",
		EGIMS_CoreConfigFile = (TempScriptPath + EGIMS_CoreConfigFileName)

struct /*#PC*PATH	GIMS.Shared*/ SharedCore (
		/*CCF_SPEC*/		ServerURL,
		/*DEFAULT*/			Tag = "Shared",
							Name = "Shared",
							RussianSupport, IntlSupport,
							BasePath, FilesPath, BackupPath, DownloadPath, CachePath, ResourceCachePath,
							Core, Rules,
							Loaded = false,
							WindowLayouts = #(),
							IsUpdateDeclined = false,
							DevInfoPropList = #(
								#Tag,
								#ServerURL,
								#BasePath,
								#FilesPath,
								#CachePath,
								#ResourceCachePath,
								#DownloadPath,
								#BackupPath,
								#Core,
								#Rules,
								#RussianSupport,
								#IntlSupport,
								#Loaded,
								#WindowLayouts,
								#Init,
								#Start
							),
							fn FileDelete FilePath = (
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
											Result = (not (DoesFileExist FilePath))
										)
										Result
									) else
										true
								/*<ERRHANDLER>*/) catch false/*<ERRHANDLEREND>*/
							),
							fn FileRename SourcePath TargetPath = (
								/*<ERRHANDLERSTART>*/try (
									if (DoesFileExist SourcePath) then (
										if (FileDelete TargetPath) then (
											local	Result = false,
													FileDir = (GetFileNamePath TargetPath)
											for i = 1 to 3 while not Result do
												Result = (MakeDir FileDir All:true)
											if not Result then (
												MessageBox ("Can't create the directory\n" + FileDir + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
												Result = (DoesFileExist FileDir)
											)
											if Result then (
												Result = false
												for i = 1 to 3 while not Result do
													Result = (RenameFile SourcePath TargetPath)
												if not Result then (
													MessageBox ("Can't rename or move the file\n" + SourcePath + "\nto\n" + TargetPath + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
													Result = (DoesFileExist TargetPath)
												)
											)
											Result
										) else
											false
									) else
										false
								/*<ERRHANDLER>*/) catch false/*<ERRHANDLEREND>*/
							),
							fn FileCopy SourcePath TargetPath = (
								/*<ERRHANDLERSTART>*/try (
									if (DoesFileExist SourcePath) then (
										if (FileDelete TargetPath) then (
											local	Result = false,
													FileDir = (GetFileNamePath TargetPath)
											for i = 1 to 3 while not Result do
												Result = (MakeDir FileDir All:true)
											if not Result then (
												MessageBox ("Can't create the directory\n" + FileDir + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
												Result = (DoesFileExist FileDir)
											)
											if Result then (
												Result = false
												for i = 1 to 3 while not Result do
													Result = (CopyFile SourcePath TargetPath)
												if not Result then (
													MessageBox ("Can't copy the file\n" + SourcePath + "\nto\n" + TargetPath + "\n\nPlease do by yourself it before pressing OK.\n\nThis can happen when 3D MAX hasn't got enough system privileges, antivirus work, or incorrect paths.") Title:"GIMS file error"
													Result = (DoesFileExist TargetPath)
												)
											)
											Result
										) else
											false
									) else
										false
								/*<ERRHANDLER>*/) catch false/*<ERRHANDLEREND>*/
							),
							/*@<Boolean>*/ fn Start Game NoEH:false = (
								/*@<GUIDE>
									Creates all core related directories.
									If core launcher's found by (FilesPath + GIMS.CoreFile) path, calling it with <MXSFunction> FileIn, thereby loading the core.
									Otherwise:
									-Deletes all core related files, 
									-Downloads (ServerURL + Tag + "\\" + GIMS.FilesDir + GIMS.CoreFile) URL to (FilesPath) directory. If succeeded, calling it with <MXSFunction> FileIn, thereby loading the core.
									-Otherwise - sets the execution result to false.
								
									Sets (Loaded) field to the execution result.
									
									Returns execution result.
								*/
								local FailText = "",
										OriginalException = "",
										Checksum = FailText.Count,
										Result = false,
										CoreFile = GIMS.CoreFile,
										CoreFilePath = (FilesPath + CoreFile),
										StarChar = "*"
								/*<ERRHANDLERSTART>*/try (
									GIMS.CurrentGame = Game
									if
										MakeDir BasePath All:true and
										MakeDir FilesPath All:true and
										MakeDir BackupPath All:true and
										MakeDir CachePath All:true and
										MakeDir ResourceCachePath All:true and
										MakeDir DownloadPath All:true
									then (
										if (DoesFileExist CoreFilePath) then (
											GIMS.CoreLoader = unsupplied
											FileIn CoreFilePath Quiet:true
											local	CoreLoader = GIMS.CoreLoader
											case CoreLoader of (
												#EULARejected:
													return()
												unsupplied:
													throw "GIMS core loader's unsupplied"
												Default:
													Result = (CoreLoader true)
											)
										) else (
											Loaded = false
											local	Files = (
														if GIMS.IsDevBuild then
															#()
														else (
															GetFiles (FilesPath + StarChar) +
															GetFiles (CachePath + StarChar) +
															GetFiles (ResourceCachePath + StarChar)
														)
													)
											for tFile in Files do
												DeleteFile tFile
											local	URL = (StringStream "")
											Format "%%/%%" ServerURL Tag GIMS.FilesDir CoreFile To:URL
											if (GIMS.Download #(URL as string) DownloadPath true) then (
												/*<ERRHANDLERSTART>*/try (
													FileIn (DownloadPath + CoreFile) Quiet:true
													local	CoreLoader = GIMS.CoreLoader
													case CoreLoader of (
														#EULARejected:
															return()
														unsupplied:
															throw "GIMS core loader's unsupplied"
														Default: (
															/*<ERRHANDLERSTART>*/try (
																Result = (CoreLoader true)
															/*<ERRHANDLER>*/) catch (
																OriginalException = (GetCurrentException())
																Append FailText ("Can't load the " + (Name as String) + " core.\n")
															)/*<ERRHANDLEREND>*/
														)
													)
												/*<ERRHANDLER>*/) catch (
													OriginalException = (GetCurrentException())
													Append FailText ("Can't compile the " + (Name as String) + " core.\n")
												)/*<ERRHANDLEREND>*/
											) else
												Append FailText ("Failed to download the " + (Name as String) + " core. May be, it isn't released yet.\n")
											Free URL
										)
									) else
										Append FailText "Failed to create folders.\n"
								/*<ERRHANDLER>*/) catch (
									if NoEH then
										throw()
									OriginalException = (GetCurrentException())
									local	OldVersionError = "<GIMSVERSIONOLD>"
									case of (
										(MatchPattern OriginalException Pattern:("*" + OldVersionError)): (
											local	ScriptPath = GIMS.ScriptPath,
													CoreConfigFileName = GIMS.CoreConfigFileName,
													PublicScriptFileName = GIMS.PublicScriptFileName,
													MainScriptFilePath = (ScriptPath + PublicScriptFileName),
													CCFPath = (ScriptPath + CoreConfigFileName),
													BakMainScriptFilePath = (ScriptPath + PublicScriptFileName + ".bak"),
													BakCCFPath = (ScriptPath + CoreConfigFileName + ".bak")
											if
												(FileRename MainScriptFilePath BakMainScriptFilePath) and	--TODO script cant do that, because the file is busy(its this file!)
												(FileRename CCFPath BakCCFPath) and
												(GIMS.Download #((ServerURL + PublicScriptFileName), (ServerURL + CoreConfigFileName)) ScriptPath true)
											then (
												try
													FileIn MainScriptFilePath Quiet:true
												catch ()
											)
											if GIMS.Shared.Loaded then (
												FileDelete BakMainScriptFilePath
												FileDelete BakCCFPath
												Result = #Abort
											) else (
												FileRename BakMainScriptFilePath MainScriptFilePath
												FileRename BakCCFPath CCFPath
												local	ErrorStart = "-- Runtime error: ",
														StartIndex = (FindString OriginalException ErrorStart)
												while (StartIndex != undefined) do (
													OriginalException = (SubString OriginalException (StartIndex + ErrorStart.Count) -1)
													StartIndex = (FindString OriginalException ErrorStart)
												)
												Append FailText ((SubString OriginalException 1 (OriginalException.Count - OldVersionError.Count)) + "\n")
												OriginalException = ""
												Result = false
											)
										)
										(MatchPattern OriginalException Pattern:"*<GIMSVERSIONUNKNOWN>*"): (
											local	Files = (
														GetFiles (FilesPath + StarChar) +
														GetFiles (CachePath + StarChar) +
														GetFiles (ResourceCachePath + StarChar)
													)
											for tFile in Files do
												DeleteFile tFile
											Result = (Start Game)
										)
										Default:
											Append FailText OriginalException
									)
								)/*<ERRHANDLEREND>*/
								if FailText.Count != Checksum then (
									if (MatchPattern FailText Pattern:"*OutOfMemory*") then
										throw "Your system's ran out of memory and GIMS can't do anything with it...try to restart 3D MAX."
									if OriginalException.Count != 0 then (
										Append FailText (
											(
												try (
													local	SystemMgr = GIMS.Core.SystemMgr,
															Warnings = SystemMgr.Warnings,
															Errors = SystemMgr.Errors,
															ErrorStream = (SystemMgr.ErrorStream as String)
													if ErrorStream.Count != 0 then
														ErrorStream
													else (
														local	LastError = SystemMgr.LastError
														try (
															Free Errors[1]
															Free Errors[2]
															Free Errors[3]
															Free Errors[4]
															SystemMgr.LastErrorID = 0
															Free Warnings[1]
															Free Warnings[2]
															Free Warnings[3]
															Free Warnings[4]
															SystemMgr.LastWarningID = 0
														) catch ()
														if LastError.Count != 0 then
															LastError
														else
															OriginalException
													)
												) catch
													OriginalException
											) as String
										)
									)
									MessageBox ("Can't start the " + (Name as String) + " core.\n" + FailText) Title:"GIMS start"
								)
								Loaded = (Result == true)
								Result
							),
							/*@<VOID>*/ fn Init /*@<Structure>*/ GIMS = (
								/*@<GUIDE>
									Initializes structure fields.
								*/
								Tag = "Shared"
								Name = "Shared"
								RussianSupport = ""
								IntlSupport = ""
								local FailText = ("Can't initialize the " + (Name as String) + " core.\n\n"),
										Checksum = FailText.Count
								/*<ERRHANDLERSTART>*/try (
									if ServerURL == undefined then
										ServerURL = GIMS.ServerURL
									else
										GIMS.ServerURL = ServerURL
									BasePath = (Append (GIMS.GIMSPath + (Tag as String)) "/")
									FilesPath = (BasePath + GIMS.FilesDir)
									BackupPath = (BasePath + GIMS.BackupDir)
									CachePath = (BasePath + GIMS.CacheDir)
									ResourceCachePath = (CachePath + GIMS.ResourceCacheDir)
									DownloadPath = (BasePath + GIMS.DownloadDir)
								/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
								if FailText.Count != Checksum then
									MessageBox FailText Title:"GIMS initialization"
							)
)
struct /*#PC*PATH	GIMS.CurrentGame*/ GameCore (
	/*FROM_CCF*/	Tag = "NONE",
					Name = "NONE",
					RussianSupport = "",
					IntlSupport = "",
	/*CCF_SPEC*/	ServerURL,
	/*DEFAULT*/	BasePath, FilesPath, BackupPath, DownloadPath, CachePath, ResourceCachePath,
						Core, Rules,
						Installed, Loaded,
						WindowLayouts = #(),
						IsUpdateDeclined = false,
						DevInfoPropList = #(
							#Tag,
							#Name,
							#ServerURL,
							#BasePath,
							#FilesPath,
							#CachePath,
							#ResourceCachePath,
							#DownloadPath,
							#BackupPath,
							#Core,
							#Rules,
							#RussianSupport,
							#IntlSupport,
							#Installed,
							#Loaded,
							#WindowLayouts,
							#Install,
							#Init,
							#Start,
							#UnInstall
						),
						/*@<VOID>*/ fn Init /*@<Structure>*/ GIMS = (
							/*@<GUIDE>
								Initializes structure fields.
							*/
							local FailText = ("Can't initialize the " + (Name as String) + " core.\n\n"),
									Checksum = FailText.Count
							/*<ERRHANDLERSTART>*/try (
								if ServerURL == undefined then
									ServerURL = GIMS.ServerURL
								BasePath = (Append (GIMS.GIMSPath + (Tag as String)) "/")
								FilesPath = (BasePath + GIMS.FilesDir)
								BackupPath = (BasePath + GIMS.BackupDir)
								CachePath = (BasePath + GIMS.CacheDir)
								ResourceCachePath = (CachePath + GIMS.ResourceCacheDir)
								DownloadPath = (BasePath + GIMS.DownloadDir)
								Loaded = false
								Installed = (DoesFileExist (FilesPath + GIMS.CoreFile))
								Core = undefined
							/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
							if FailText.Count != Checksum then
								MessageBox FailText Title:("GIMS " + (Name as String) + " initialization")
						),
						/*@<VOID>*/ fn UnInstall = (
							/*@<GUIDE>
								Deletes all core related files(except backup) and calls (Init) sunction to set the state to default.
							*/
							local	StarChar = "*",
									Files = (
										if GIMS.IsDevBuild then
											#()
										else (
											GetFiles (FilesPath + StarChar) +
											GetFiles (CachePath + StarChar) +
											GetFiles (ResourceCachePath + StarChar) +
											GetFiles (DownloadPath + StarChar)
										)
									)
							for tFile in Files do
								DeleteFile tFile
							Init GIMS
						),
						/*@<Boolean>*/ fn Install Game = (
							/*@<GUIDE>
								Calls (UnInstall) function.
								Creates all core related directories.
								Downloads (ServerURL + Tag + "\\" + GIMS.FilesDir + GIMS.CoreFile) URL to (DownloadPath) directory. If succeeded, calling it with <MXSFunction> FileIn, thereby loading the core.
								Otherwise - sets the execution result to false.
							
								Sets (Installed) and (Loaded) fields to the execution result.
							
								Returns execution result.
							*/
							local FailText = "",
									OriginalException = "",
									Checksum = FailText.Count,
									Result = false,
									CoreFile = GIMS.CoreFile
							/*<ERRHANDLERSTART>*/try (
								GIMS.CurrentGame = Game
								UnInstall()
								if
									MakeDir BasePath All:true and
									MakeDir FilesPath All:true and
									MakeDir BackupPath All:true and
									MakeDir DownloadPath All:true and
									MakeDir CachePath All:true and
									MakeDir ResourceCachePath All:true
								then (
									local	URL = (StringStream "")
									Format "%%/%%" ServerURL Tag GIMS.FilesDir CoreFile To:URL
									if (GIMS.Download #(URL as String) DownloadPath true) then (
										/*<ERRHANDLERSTART>*/try (
											FileIn (DownloadPath + CoreFile) Quiet:true
											/*<ERRHANDLERSTART>*/try (
												Result = (GIMS.CoreLoader true)
											/*<ERRHANDLER>*/) catch (
												OriginalException = (GetCurrentException())
												Append FailText ("Can't load the " + (Name as String) + " core.\n")
											)/*<ERRHANDLEREND>*/
										/*<ERRHANDLER>*/) catch (
											OriginalException = (GetCurrentException())
											Append FailText ("Can't compile the " + (Name as String) + " core.\n")
										)/*<ERRHANDLEREND>*/
									) else
										Append FailText ("Failed to download the " + (Name as String) + " core. May be, it isn't released yet.\n")
									Free URL
								) else
									Append FailText "Failed to create folders.\n"
							/*<ERRHANDLER>*/) catch (
								OriginalException = (GetCurrentException())
								Append FailText ("Can't install the " + (Name as String) + " core.\n")
							)/*<ERRHANDLEREND>*/
							if FailText.Count != Checksum then (
								if (MatchPattern FailText Pattern:"*OutOfMemory*") then
									throw "Your system's ran out of memory and GIMS can't do anything about it...try to restart 3D MAX."
								Append FailText (
									(
										try (
											local	ErrorStream = (GIMS.Shared.Core.SystemMgr.ErrorStream as String)
											if ErrorStream.Count != 0 then
												ErrorStream
											else (
												local	LastError = GIMS.Shared.Core.SystemMgr.LastError
												if LastError.Count != 0 then
													LastError
												else
													OriginalException
											)
										) catch
											OriginalException
									) as String
								)
								MessageBox FailText Title:("GIMS " + (Name as String) + " setup")
							)
							Loaded = Result
							Installed = Result
							Result
						),
						/*@<Boolean>*/ fn Start /*@<Structure>*/ Game NoEH:false = (
							/*@<GUIDE>
								Creates all core related directories.
								If core launcher's found by (FilesPath + GIMS.CoreFile) path, calling it with <MXSFunction> FileIn, thereby loading the core.
								Otherwise, calls (Install) function, which sets the execution result.
							
								Sets (Loaded) field to the execution result.
								
								Returns execution result.
							*/
							local FailText = "",
									OriginalException = "",
									Checksum = FailText.Count,
									Result = false
							/*<ERRHANDLERSTART>*/try (
								GIMS.CurrentGame = Game
								if
									MakeDir BasePath All:true and
									MakeDir FilesPath All:true and
									MakeDir BackupPath All:true and
									MakeDir DownloadPath All:true and
									MakeDir CachePath All:true and
									MakeDir ResourceCachePath All:true
								then (
									local	CoreFile = (FilesPath + GIMS.CoreFile)
									if (DoesFileExist CoreFile) then (
										/*<ERRHANDLERSTART>*/try (
											local	IsFirstLaunch = (Core == undefined)
											if IsFirstLaunch then
												FileIn CoreFile Quiet:true
											/*<ERRHANDLERSTART>*/try (
												Result = (GIMS.CoreLoader IsFirstLaunch)
											/*<ERRHANDLER>*/) catch (
												Core = undefined
												OriginalException = (GetCurrentException())
												Append FailText ("Can't load the " + (Name as String) + " core.\n")
											)/*<ERRHANDLEREND>*/
										/*<ERRHANDLER>*/) catch (
											OriginalException = (GetCurrentException())
											Append FailText ("Can't compile the " + (Name as String) + " core.\n")
										)/*<ERRHANDLEREND>*/
									) else
										Result = (Install Game)
								) else
									Append FailText "Failed to create folders.\n"
							/*<ERRHANDLER>*/) catch (
								if NoEH then
									throw()
								OriginalException = (GetCurrentException())
								Append FailText ("Can't start the " + (Name as String) + " core.\n")
							)/*<ERRHANDLEREND>*/
							if FailText.Count != Checksum then (
								if (MatchPattern FailText Pattern:"*OutOfMemory*") then
									throw "Your system's ran out of memory and GIMS can't do anything about it...try to restart 3D MAX."
								Append FailText (
									(
										try (
											local	ErrorStream = (GIMS.Shared.Core.SystemMgr.ErrorStream as String)
											if ErrorStream.Count != 0 then
												ErrorStream
											else (
												local	LastError = GIMS.Shared.Core.SystemMgr.LastError
												if LastError.Count != 0 then
													LastError
												else
													OriginalException
											)
										) catch
											OriginalException
									) as String
								)
								MessageBox FailText Title:("GIMS " + (Name as String) + " start")
							)
							Loaded = Result
							Result
						)
)
struct /*#PC*PATH	GIMS.GUI.Font.Tip*/ GUIFontTip (
	Regular,
	SemiBold
)
struct /*#PC*PATH	GIMS.GUI.Font.Body*/ GUIFontBody (
	Regular,
	SemiBold
)
struct /*#PC*PATH	GIMS.GUI.Font.SubHeader*/ GUIFontSubHeader (
	Regular,
	Light
)
struct /*#PC*PATH	GIMS.GUI.Font*/ GUIFont (
	Header,
	SubHeader = GUIFontSubHeader(),
	Body = GUIFontBody(),
	Tip = GUIFontTip(),
	/*@<Boolean>*/ fn Check = (
		/*@<GUIDE>
			Checks structure fields to be initialized properly
		*/
		(
			Header != undefined and
			SubHeader.Regular != undefined and
			SubHeader.Light != undefined and
			Body.Regular != undefined and
			Body.SemiBold != undefined and
			Tip.Regular != undefined and
			Tip.SemiBold != undefined
		)
	)
)
struct /*#PC*PATH	GIMS.GUI.Colour*/ GUIColour (
	SDC,
	CBlack,
	CWhite,
	CGray,
	Theme,
	Accent,
	Warning,
	Transparent,
	Info,
	/*@<Boolean>*/ fn Check = (
		/*@<GUIDE>
			Checks structure fields to be initialized properly
		*/
		(
			SDC != undefined and
			CBlack != undefined and
			CWhite != undefined and
			CGray != undefined and
			Theme != undefined and
			Accent != undefined and
			Warning != undefined and
			Transparent != undefined and
			Info != undefined
		)
	)
)
struct /*#PC*PATH	GIMS.GUI*/ strGUI (
	BitmapPath,
	Images = #(#(), #()),
	Font = GUIFont(),
	Colour = GUIColour(),
	Align,
	ScrollOrientation,
	NameSeparator = "_",
	ImageExt = ".png",
	/*@<BitMap>*/ fn SaveBitMap /*@<BitMap>*/ TheBMP = (
		/*@<GUIDE>
			Saves the bitmap adnd opens it again.
			returns the BitMap, or "undefined" if saving\opening failed.
		*/
		local	FileName = TheBMP.FileName
		if FileName.Count == 0 then
			throw "Can't Save the BitMap without a FileName"
		Save TheBMP Gamma:1
		Close TheBMP
		if not (DoesFileExist FileName) then
			throw "Can't save the bitmap: " FileName
		try
			OpenBitmap FileName
		catch
			undefined
	),
	/*@<BitMap>*/ fn ResizeBitmap /*@<BitMap>*/ TheBMP /*@<Point2>*/ Size /*@<String>*/ FilePath:undefined DoSave:true = (
		/*@<GUIDE>
			Resizes the bitmap with using the parameter "Size".
			Saves the bitmap to the path from "FilePath" parameter if it's defined, otherwise by the following formula:
				<Shared core resource cache path>/R-G-B-A_WidthxHeight.png
			returns the BitMap, or "undefined" if saving\opening failed.
		*/
		local	Width = Size.x,
				Height = Size.y
		if FilePath == undefined then (
			local	SS = (StringStream "")
			Format "%%_%x%.png" GIMS.Shared.ResourceCachePath (GetHashValue TheBMP.FileName 0) Width Height To:SS
			FilePath = (SS as string)
			Free SS
		)
		local	ResizedBMP = (BitMap Width Height FileName:FilePath)
		Copy TheBMP ResizedBMP
		if DoSave then
			SaveBitmap ResizedBMP
		else
			ResizedBMP
	),
	/*@<BitMap>*/ fn CreateBitmap /*@<Point2>*/ Size:[8, 8] /*@<Color>*/ BackColor:Red /*@<String>*/ FilePath:undefined = (
		/*@<GUIDE>
			Creates the bitmap with given unnecessary parameters "Size"(Default's [8, 8]) and "BackColor"(Default's White).
			Saves the bitmap to the path from "FilePath" parameter if it's defined, otherwise by the following formula:
				<Shared core resource cache path>/R-G-B-A_WidthxHeight.png
			returns the BitMap, or "undefined" if saving\opening failed.
		*/
		local	Width = Size.x,
				Height = Size.y
		if FilePath == undefined then (
			local	SS = (StringStream "")
			Format "%%-%-%-%_%x%.png" \
				GIMS.Shared.ResourceCachePath \
				(BackColor.R as integer) \
				(BackColor.G as integer) \
				(BackColor.B as integer) \
				(BackColor.A as integer) \
				(Width as integer) \
				(Height as integer) \
				To:SS
			FilePath = (SS as string)
			Free SS
		)
		SaveBitMap (Bitmap Width Height FileName:FilePath Color:BackColor)
	),
	/*@<BitMap>*/ fn GetImage /*@<ImgTag>*/ Item /*@<Name>*/ Action /*@<Name | String>*/ tIcon /*@<Point2>*/ Size:[26, 26] = (
		/*@<GUIDE>
			Creates the value "Tag" of ((tIcon as string + Action as string + Size as string) as name).
			Searches (Images)[1] array for an entry of "Tag" value, storing its number in "BitmapID" value.
			If found, returns the BitMap from Images[2][BitmapID].
			Otherwise:
			-Searches for a file ((BitmapPath) + tIcon as string + "_" + Action as string + ".png").
			-If not found, creates it in size of (Size) argument with a Red square inside. Returns it.
			-If found - opens it. If the file BitMap size's different - resizes it. Adds "Tag" value to (Images)[1], and the resulting BitMap to (Images)[2]. Returns the resulting BitMap.
		*/
		local	Tag = (Append ((tIcon as String) + (Action as String)) (Size as String)),
				ImageName = (Append ((tIcon as string) + (NameSeparator as String)) (Action as string)),
				Tags = Images[1],
				BitmapID = (FindItem Tags Tag),
				Result
		if BitmapID == 0 then (
			local	FilePath = (Append ((BitmapPath as String) + (ImageName as String)) (ImageExt as String))
			if (DoesFileExist FilePath) then (
				Result = (OpenBitmap FilePath)
				local	SX = Size.x,
						SY = Size.y
				if
					Result.Width != SX or
					Result.Height != SY
				then (
					Result = (ResizeBitmap Result Size)
					Item.Width = SX
					Item.Height = SY
				)
			) else
				Result = (CreateBitmap Size:Size FilePath:FilePath BackColor:Red)
			Append Tags Tag
			Append Images[2] Result
		) else
			Result = Images[2][BitmapID]
		Result
	),
	/*@<BitMap | Undefined>*/ fn ImageControl /*@<ImgTag>*/ Item /*@<Name>*/ Action /*@<Name | String>*/ tIcon /*@<Point2>*/ Size:[26, 26] = (
		/*@<GUIDE>
			Sets (Item).Enabled property to true if (Action) is #Enable. Otherwise, to false.
			If (Action) is #Null, sets (Item).BitMap to undefined. Otherwise, to the result of calling (GetImage) function with all the same arguments.
		
			Returns (Item).BitMap
		*/
		Item.Enabled = (
			if Action == #Enable then
				true
			else
				false
		)
		Item.BitMap = (
			if Action != #Null then
				GetImage Item Action tIcon Size:Size
		)
	),
	/*@<Boolean>*/ fn Check = (
		/*@<GUIDE>
			Checks structure fields to be initialized properly.
		*/
		if not Colour.Check() then
			throw "\n\nCan't load colors! Please, update your .NET framework and restart 3Ds MAX"
		if not Font.Check() then
			throw "\n\nCan't load fonts! Please, install these:\n\nSegoe UI\nSegoe UI Light\nSegoe UI SemiBold\n\nand restart 3Ds MAX"
		true
	),
	/*@<Boolean>*/ fn Init /*@<Function>*/ GIMS = (
		/*@<GUIDE>
			SetLifetimeController - Alias to GIMS.SetLifetimeController.
		
			Initializes structure fields.
		*/
		local FailText = "Can't initialize GIMS GUI.\n\n",
				Checksum = FailText.Count
		/*<ERRHANDLERSTART>*/try (
			local	SetLifetimeController = GIMS.SetLifetimeController
			BitmapPath = (GIMS.ScriptPath + "GIMS_GUI\\")
			ScrollOrientation = (DotNETClass "System.Windows.Forms.ScrollOrientation")
			SetLifetimeController ScrollOrientation #MXS
			Align = (DotNETClass "System.Drawing.ContentAlignment")
			SetLifetimeController Align #MXS
			local	SDC = (DotNETClass "System.Drawing.Color")
			Colour.SDC = SDC
			SetLifetimeController Colour.SDC #MXS
			Colour.CBlack = SDC.Black
			Colour.CWhite = SDC.Snow
			Colour.CGray = SDC.SlateGray
			Colour.Theme = SDC.SteelBlue
			local	AccentColor = SDC.DodgerBlue
			Colour.Accent = AccentColor
			Colour.Warning = SDC.Orange
			Colour.Transparent = SDC.Transparent
			Colour.Info = SDC.Green
			local	FontFamily = (DotNETClass "System.Drawing.FontFamily"),
					Fonts = #(
						("Segoe UI" as name),
						("Segoe UI Light" as name),
						("Segoe UI SemiBold" as name)
					)
			SetLifetimeController FontFamily #MXS
			for TempFont in FontFamily.Families do (
				case (FindItem Fonts (TempFont.Name as name)) of (
					1: (
						Font.Tip.Regular = (DotNETObject "System.Drawing.Font" TempFont 9)
						SetLifetimeController Font.Tip.Regular #MXS
						Font.Body.Regular = (DotNETObject "System.Drawing.Font" TempFont 11)
						SetLifetimeController Font.Body.Regular #MXS
						Font.SubHeader.Regular = (DotNETObject "System.Drawing.Font" TempFont 20)
						SetLifetimeController Font.SubHeader.Regular #MXS
					)
					2: (
						Font.Header = (DotNETObject "System.Drawing.Font" TempFont 28)
						SetLifetimeController Font.Header #MXS
						Font.SubHeader.Light = (DotNETObject "System.Drawing.Font" TempFont 20)
						SetLifetimeController Font.SubHeader.Light #MXS
					)
					3: (
						Font.Body.SemiBold = (DotNETObject "System.Drawing.Font" TempFont 11)
						SetLifetimeController Font.Body.SemiBold #MXS
						Font.Tip.SemiBold = (DotNETObject "System.Drawing.Font" TempFont 9)
						SetLifetimeController Font.Tip.SemiBold #MXS
					)
				)
			)
		/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
		if FailText.Count != Checksum then (
			MessageBox FailText Title:"GIMS initialization"
			false
		) else
			true
	)
)

FailText = "Can't load GIMS core configuration! Error:\n\n"
Checksum = FailText.Count
global	Cores = #(),
		SharedCoreID = 0
if (DoesFileExist EGIMS_CoreConfigFile) then (
	local	GECCFStream
	/*<ERRHANDLERSTART>*/try (
		GECCFStream = (OpenEncryptedFile EGIMS_CoreConfigFile (GetHashValue "IHateShittyConfigs" 777))
		Cores = (ReadValue GECCFStream)
	/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
	if GECCFStream != undefined then
		Close GECCFStream
	if FailText.Count == Checksum then (
		local	CoreCount = Cores.Count
		for CoreID = CoreCount to 1 by -1 while SharedCoreID == 0 where (Cores[CoreID].Tag as name) == #Shared do
			SharedCoreID = CoreID
		if SharedCoreID == 1 then (
			local	CoreTags = #()
			for i = CoreCount to 1 by -1 do
				CoreTags[i] = Cores[i].Tag
			local	CoreTagsAsFields = "",
					CoreTagsAsNames = "",
					CoreTagsAsArrayEntries = "",
					CoreTagsAsFieldInits = "",
					HeaderY = 5,
					ButtonsY = 37,
					GUIDefinition = (StringStream ""),
					GUICallbacks = (StringStream ""),
					GUIInits = (StringStream ""),
					GUIPostInits = (StringStream ""),
					CommaChar = ",",
					GridChar = "#",
					RightSquareBracket = "]",
					DoubleDotChar = ":",
					SpaceChar = " ",
					CoresIDStart = "Cores[",
					ControlSpace = 15,
					GUIDefinitionFormat = ("
								DotNETControl	Tip% \"System.Windows.Forms.Label\"	BackColor:GIMS.GUI.Colour.CBlack	ForeColor:GIMS.GUI.Colour.CBlack	TextAlign:GIMS.GUI.Align.BottomLeft	Text:\"%\"	Pos:[%, %] Width:130 Height:26
								ImgTag				Install%			Pos:[%, %]		Bitmap:(BitMap 26 26 Color:Red)	Enabled:false	Style:#bmp_stretch
								ImgTag				Remove%		Pos:[%, %]		Bitmap:(BitMap 26 26 Color:Red)	Enabled:false	Style:#bmp_stretch
								ImgTag				Start%			Pos:[%, %]		Bitmap:(BitMap 26 26 Color:Red)	Enabled:false	Style:#bmp_stretch
"					),
					GUICallbacksFormat = ("
								on Start% LButtonUp Pos Flags do (
									if
										Flags == 0 and
										Pos.x >= 0 and
										Pos.x <= 26 and
										Pos.y >= 0 and
										Pos.y <= 26
									then
										StartGame GIMS.% %
								)
								on Install% LButtonUp Pos Flags do (
									if
										Flags == 0 and
										Pos.x >= 0 and
										Pos.x <= 26 and
										Pos.y >= 0 and
										Pos.y <= 26
									then
										InstallGame GIMS.% %
								)
								on Remove% LButtonUp Pos Flags do (
									if
										Flags == 0 and
										Pos.x >= 0 and
										Pos.x <= 26 and
										Pos.y >= 0 and
										Pos.y <= 26
									then
										RemoveGame GIMS.% %
								)
"					),
					GUIInitsFormat = ("
											uEvoGIMS.ChangeImages % #(#Disable, #Disable, #Disable) #(#Download, #Delete, #Launch)
											GIMS.%.Init GIMS
"					),
					GUIPostInitsFormat = ("
												uEvoGIMS.PostInitGame GIMS.% % uEvoGIMS.Tip%
"					),
					GUIButtonsFormat = "#(uEvoGIMS.Install%, uEvoGIMS.Remove%, uEvoGIMS.Start%)",
					CoreCount = CoreTags.Count,
					ButtonPos2 = ((UtilityWidth / 2) - 13),
					ButtonPos3 = (UtilityWidth - ControlSpace  - 26 - 1)
			for CoreID = 1 to CoreCount do (
				local	CoreIDString = (CoreID as string)
				Append CoreTagsAsArrayEntries CoresIDStart
				Append CoreTagsAsArrayEntries CoreIDString
				Append CoreTagsAsArrayEntries RightSquareBracket
				if CoreID != CoreCount then
					Append CoreTagsAsArrayEntries CommaChar
				if CoreID != SharedCoreID then (
					local	CoreTag = CoreTags[CoreID],
							TempVal = (CoreTag + CommaChar),
							GUIButtonsStream = (StringStream "")
					Format GUIButtonsFormat CoreTag CoreTag CoreTag To:GUIButtonsStream
					GUIButtons = (GUIButtonsStream as string)
					Free GUIButtonsStream
					Append CoreTagsAsFields TempVal
					Append CoreTagsAsNames (GridChar + TempVal)
					Append CoreTagsAsFieldInits CoreTag
					Append CoreTagsAsFieldInits DoubleDotChar
					Append CoreTagsAsFieldInits CoresIDStart
					Append CoreTagsAsFieldInits CoreIDString
					Append CoreTagsAsFieldInits RightSquareBracket
					Append CoreTagsAsFieldInits SpaceChar
					Format GUIDefinitionFormat \
						CoreTag Cores[CoreID].Name ControlSpace HeaderY \
						CoreTag ControlSpace ButtonsY \
						CoreTag ButtonPos2 ButtonsY \
						CoreTag ButtonPos3 ButtonsY \
					To:GUIDefinition
					Format GUICallbacksFormat \
						CoreTag \
						CoreTag GUIButtons \
						CoreTag \
						CoreTag GUIButtons \
						CoreTag \
						CoreTag GUIButtons \
					To:GUICallbacks
					Format GUIInitsFormat \
						GUIButtons \
						CoreTag \
					To:GUIInits
					Format GUIPostInitsFormat \
						CoreTag GUIButtons CoreTag \
					To:GUIPostInits
					HeaderY += 64
					ButtonsY += 64
				)
			)
			local	Height = (ButtonsY - 25),
					CompileSet = (StringStream "")
			Format ("struct /*#PC*PATH	GIMS*/ GIMSstr (
								Version = %,
								LocalApplicationPath, RoamingApplicationPath, CommonApplicationPath,
								ScriptPath = TempScriptPath,
								CoreConfigFileName = EGIMS_CoreConfigFileName,
								DevScriptFileName = EGIMS_DevGIMSFileName,
								PublicScriptFileName = EGIMS_PublicGIMSFileName,
								GIMSPath,
								Extension,
								CoreLoader,
								Cores,
								Shared, Core,
								%
								CurrentGame,
								CoreFile = \"00_Core\",
								ConfigFile = \"System.cfg\",
								CacheConfigFile = \"Cache.cfg\",
								FilesDir = \"Files\\\\\",
								BackupDir = \"Backup\\\\\",
								CacheDir = \"Cache\\\\\",
								ResourceCacheDir = \"Resources\\\\\",
								DownloadDir = \"Download\\\\\",
								ServerURL = \"http://gims.openiv.com/downloads/GIMS/\",
								GUI = (strGUI()),
								Languages = #(),
								LangID = 1, 
								CanExec = true,
								IsDevBuild = false,
								SupportsLifetimeControl = false,
								
								IsWorkerBusy = false,
								WorkerArg,
								ProcessPostedMessages,
								
								DevInfoPropList = #(
									#Version,
									#ServerURL,
									#LocalApplicationPath,
									#CommonApplicationPath,
									#RoamingApplicationPath,
									#GIMSPath,
									#Extension,
									#CoreFile,
									#ConfigFile,
									#CacheConfigFile,
									#FilesDir,
									#BackupDir,
									#CacheDir,
									#ResourceCacheDir,
									#DownloadDir,
									#IsDevBuild,
									#Languages,
									#LangID,
									#SupportsLifetimeControl,
									#CanExec,
									#IsWorkerBusy,
									#WorkerArg,
									#GUI,
									#Shared,
									#Core,
									%
									#CurrentGame,
									#ProcessPostedMessages,
									#DoAsyncWaiting,
									#Download,
									#Init,
									#Check,
									#Load,
									#SetLifetimeController
								),
								/*@<VOID>*/ fn SetLifetimeController /*@<DotNETObject | DotNETClass>*/ Obj /*@<Name>*/ Handler = (
									/*@<GUIDE>
										Obj - DotNET object or class to control.
										Handler - #MXS or #MXS.
									
										Sets (Obj) lifetime controller to MAXScript or DotNET.
									*/
									if SupportsLifetimeControl then
										DotNET.SetLifetimeControl Obj Handler
								),
								fn CheckConnection args = (
									try (
										local	arr = GIMS.WorkerArg	--args.Argument
										if not (Internet.CheckConnection URL:arr[2] Force:true) then
											arr[1].CancelAsync()
										GIMS.IsWorkerBusy = false
									) catch (
										GIMS.IsWorkerBusy = false
										MessageBox (\"Internet connection check error:\n\" + (GetCurrentException()))
									)
									OK
								),
								fn DoWaitAsync Task arg Timeout:0 = (
									CanExec = false
									local	Worker = (DotNETObject \"System.ComponentModel.BackGroundWorker\")
									SetLifetimeController Worker #MXS
									Worker.WorkerSupportsCancellation = true
									DOTNet.AddEventHandler Worker \"DoWork\" Task
									local	HaveTimeout = false,
											TimeStart
									IsWorkerBusy = true
									WorkerArg = #(Worker, arg)
									Worker.RunWorkerAsync()	-- #(Worker, arg)
									if Timeout != 0 then (
										HaveTimeout = true
										TimeStart = (TimeStamp())
									)
									local	CancellationPending = false
									while IsWorkerBusy do (
										CancellationPending = Worker.CancellationPending
										if HaveTimeout then (
											local	CurTime = (TimeStamp())
											if CurTime < TimeStart then
												TimeStart = CurTime
											else (
												if (CurTime - TimeStart) > Timeout then
													CancellationPending = true
											)
										)
										if CancellationPending then (
											Worker.CancelAsync()
											IsWorkerBusy = false
										)
										ProcessPostedMessages()
									)
									CanExec = true
									(not CancellationPending)
								),
								/*@<Boolean>*/ fn Download /*@<String[]>*/ FileList /*@<String>*/ Location /*@<Boolean>*/ ShowGUI Timeout:5000 = (
									/*@<GUIDE>
										Downloads (FileList) URLs to (Location) directory.
										(ShowGUI) argument affects process visibility.
										
										Returns the downloading result.
									*/
									--Print #FnDownload	--<TODO> remove, debug--<TODO> remove, debug
									--Print #FileList	--<TODO> remove, debug
									--Print FileList	--<TODO> remove, debug
									if FileList.Count != 0 then (
										local	Result = true
										if (DoWaitAsync CheckConnection FileList[1] Timeout:Timeout) then (
											--Print #ConnectedAndDownloaded	--<TODO> remove, debug
											local	hash = (TimeStamp()),
													DownloadUrlToDisk = DragAndDrop.DownloadUrlToDisk
											for DownFile in FileList while Result do (
												local	TargetFile = (Location + (FileNameFromPath DownFile))
												if
													(not (DoesFileExist TargetFile)) and (
														(not (DownloadUrlToDisk (DownFile + \"?is=\" + (hash as String)) TargetFile 0)) or
														(not (DoesFileExist TargetFile))
													)
												then
													Result = false 
											)
										) else
											Result = false
										if not Result then (
											--Print #NotConnectedOrDownloaded	--<TODO> remove, debug
											for DownFile in FileList do
												DeleteFile (Location + (FileNameFromPath DownFile))
										)
										Result
									) else
										true
								),
								/*@<Boolean>*/ fn Load = (
									/*@<GUIDE>
										Sets MXS (DragAndDrop.GlobalEnableDragAndDrop) to true.
										Checks if the main GIMS script file's named as DevScriptFileName or PublicScriptFileName, and located in \"<3D MAX ROOT>\\Scripts\Startup\\\" directory.
										Sets (Extension) field value to the extension of that file.
										(IsDevBuild) field value represents that the (Extension) is \".ms\" or not.
										Adds the (Extension) to the (CoreFile) file name.
									
										Returns execution result.
									*/
									local FailText = \"Can't initialize GIMS.\n\n\",
											Checksum = FailText.Count,
											Result = true
									/*<ERRHANDLERSTART>*/try (
										DragAndDrop.GlobalEnableDragAndDrop true
										EscapeEnable = False
										if (DoesFileExist (ScriptPath + DevScriptFileName)) then (
											Extension = \".ms\"
											IsDevBuild = true
										) else (
											if (DoesFileExist (ScriptPath + PublicScriptFileName)) then
												Extension = \".mse\"
											else
												throw \"Invalid installation.\nCan't find the GIMS script in \\\"<3D MAX root>\\\\scripts\\\\Startup\\\\\\\" folder.\n\"
										)
										local	HookFile = (Append ScriptsPath \"PreloadGIMS.ms\")
										if not (DoesFileExist HookFile) then
											HookFile = (Append ScriptsPath \"PreloadGIMS.mse\")
										if (DoesFileExist HookFile) then
											FileIn HookFile Quiet:true
										Append CoreFile Extension
									/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
									if FailText.Count != Checksum then (
										MessageBox FailText Title:\"GIMS initialization\"
										Result = false
									)
									Result
								),
								/*@<Boolean>*/ fn Check = (
									/*@<GUIDE>
										Checks structure fields to be initialized properly.
									*/
									GUI.Check()
								),
								/*@<Boolean>*/ fn Init = (
									/*@<GUIDE>
										Initializes structure fields.
									*/
									local FailText = \"Can't initialize GIMS.\n\n\",
											Checksum = FailText.Count
									/*<ERRHANDLERSTART>*/try (
										try (
											DotNET.SetLifetimeControl
											SupportsLifetimeControl = true
										) catch ()
										ProcessPostedMessages = (
											try
												Windows.ProcessPostedMessages
											catch
												(DotNETClass \"Application\").DoEvents
										)
										local SysEnv = (DotNETClass \"System.Environment\"),
												SpcFolder = (DotNETClass \"System.Environment+SpecialFolder\")
										LocalApplicationPath = (SysEnv.GetFolderPath SpcFolder.LocalApplicationData)
										RoamingApplicationPath = (SysEnv.GetFolderPath SpcFolder.ApplicationData)
										CommonApplicationPath = (SysEnv.GetFolderPath SpcFolder.CommonApplicationData)
										if LocalApplicationPath.Count == 0 then
											LocalApplicationPath = CommonApplicationPath
										if RoamingApplicationPath.Count == 0 then
											RoamingApplicationPath = CommonApplicationPath
										if
											LocalApplicationPath.Count == 0 or
											RoamingApplicationPath.Count == 0 or
											CommonApplicationPath.Count == 0
										then
											throw \"Can't find the application data folders!\"
										Append LocalApplicationPath \"\\\\\"
										Append RoamingApplicationPath \"\\\\\"
										Append CommonApplicationPath \"\\\\\"
										GIMSPath = (LocalApplicationPath + \"\\GIMS\\\\\")
									/*<ERRHANDLER>*/) catch (Append FailText (GetCurrentException()))/*<ERRHANDLEREND>*/
									if FailText.Count != Checksum then (
										MessageBox FailText Title:\"GIMS initialization\"
										false
									) else
										true
								)
						)
						GIMS = (
							GIMSstr \\
							Cores:#(%) \\
							Shared:Cores[1] \\
							%\\
						)
						if (
							GIMS.Init() and
							GIMS.GUI.Init GIMS
						) then (
							utility uEvoGIMS \"GIMS Evo\" (
								ImgTag				BGImg 			Pos:[0, 1]			BitMap:(BitMap UtilityWidth % Color:Black)	Transparent:White	Enabled:false	Style:#bmp_stretch
	%
								Button	LangButton \"Language\"	Offset:[0, 15]	Height:26	Width:65	Align:#Left	Across:2
								Button	InfoButton \"About\"		Offset:[0, 15]	Height:26	Width:65	Align:#Right
								fn ChangeImages Buttons Actions Icons = (
									local	ImageControl = GIMS.GUI.ImageControl
									for i = 1 to Buttons.Count do
										ImageControl Buttons[i] Actions[i] Icons[i]
								)
								fn EnableGame Game Buttons = (
									ChangeImages Buttons #(#Disable, #Enable, #Enable) #(#Download, #Delete, #Launch)
								)
								fn DisableGame Game Buttons = (
									ChangeImages Buttons #(#Enable, #Disable, #Disable) #(#Download, #Delete, #Launch)
								)
								fn StartGame Game Buttons = (
									if GIMS.CanExec then (
										local	ImageControl = GIMS.GUI.ImageControl
										ImageControl Buttons[3] #Active #Launch
										Game.Start Game
										ImageControl Buttons[3] #Enable #Launch
									)
								)
								fn InstallGame Game Buttons = (
									if GIMS.CanExec then (
										GIMS.GUI.ImageControl Buttons[1] #Active #Download
										if (Game.Install Game) then
											EnableGame Game Buttons
										else
											DisableGame Game Buttons
									)
								)
								fn RemoveGame Game Buttons = (
									if
										not GIMS.IsDevBuild and
										GIMS.CanExec
									then (
										GIMS.GUI.ImageControl Buttons[2] #Active #Delete
										local	GameName = Game.Name
										if (QueryBox (Append (Append \"Are you sure you want to uninstall GIMS \" GameName) \"?\") Title:(Append (Append \"GIMS \" GameName) \"uninstall\")) then (
											Game.UnInstall()
											DisableGame Game Buttons
										) else
											EnableGame Game Buttons
									)
								)
								fn PostInitGame Game Buttons TipControl = (
									local	GUI = GIMS.GUI
									TipControl.Font = GUI.Font.Body.SemiBold
									TipControl.ForeColor = GUI.Colour.CWhite
									if Game.Installed then
										EnableGame Game Buttons
									else
										DisableGame Game Buttons
								)
								%
								on InfoButton pressed do (
									/*<ERRHANDLERSTART>*/try (
										if GIMS.CanExec then
											GIMS.Core.GUIMgr.SetWindow GIMS.Shared #GIMSInfo
									/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:\"*<THROW>*\") then (ESS = (StringStream \"\");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS)/*<ERRHANDLEREND>*/
								)
								on LangButton pressed do (
									if GIMS.CanExec then
										CreateDialog EGIMS_LangSelectRollout
								)
							)
							/*<ERRHANDLERSTART>*/try (
								if GIMS.Load() then (
									GIMS.Shared.Init GIMS
									%
									local SharedStartResult = (GIMS.Shared.Start GIMS.Shared)
									if SharedStartResult == true then (
										OpenUtility uEvoGIMS
										%
									)
								)
							/*<ERRHANDLER>*/) catch (MessageBox (Append \"Failed to start the Evo GIMS utility!\\n\\n\" (GetCurrentException())) Title:\"GIMS Evo initialization\")/*<ERRHANDLEREND>*/
						)
						GIMSstr = undefined"
			) \
				GIMSVersion \
				CoreTagsAsFields \
				CoreTagsAsNames \
				CoreTagsAsArrayEntries \
				CoreTagsAsFieldInits \
				Height \
				(GUIDefinition as string) \
				(GUICallbacks as string) \
				(GUIInits as string) \
				(GUIPostInits as string) \
			To:CompileSet
-- 			/*<ERRHANDLERSTART>*/try (
				Execute (CompileSet as string)
-- 			/*<ERRHANDLER>*/) catch (
-- 				Append FailText "\nCan't load GIMS Evo! CompileSet's corrupted. Error:\n\n"
-- 				Append FailText (GetCurrentException())
-- 			)/*<ERRHANDLEREND>*/
			Free CompileSet
			Free GUIDefinition
			Free GUICallbacks
			Free GUIInits
			Free GUIPostInits
		) else
			Append FailText "The core configuration's invalid! Can't find the Shared core initialization"
	)
) else
	Append FailText (EGIMS_CoreConfigFileName + " file's not found. Please reinstall GIMS Evo.")
) else
	Append FailText "Some functions needed for GIMS wasn't found.\nPlease install AvGuard Extensions for 3D MAX."
if FailText.Count != Checksum then
	MessageBox FailText Title:"GIMS Evo loading"
OK
