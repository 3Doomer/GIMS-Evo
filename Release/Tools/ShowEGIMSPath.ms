SysEnv = (DotNETClass "System.Environment")
SpcFolder = (DotNETClass "System.Environment+SpecialFolder")
GetFolderPath = SysEnv.GetFolderPath
LocalApplicationPath = (GetFolderPath SpcFolder.LocalApplicationData)
CommonApplicationPath = (GetFolderPath SpcFolder.CommonApplicationData)
if LocalApplicationPath.Count == 0 then
	LocalApplicationPath = CommonApplicationPath
if LocalApplicationPath.Count == 0 then
	LocalApplicationPath = "Can't find the application data folder!\nPlease report this error at forums."
MessageBox LocalApplicationPath Title:"GIMS Evo install path"
