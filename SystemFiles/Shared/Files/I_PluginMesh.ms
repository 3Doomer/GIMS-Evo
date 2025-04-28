local	RebuildMesh,
		AdditionalCreateHandler,
		_Faces = #(),
		_Verts = #(),
		_MtlIDs = #(),
		_MeshBuildingEnabled = true,
		_NeedUpdate = true,
		_AlwaysRedraw = false
fn _RebuildMesh = (
	/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
	/*<ERRHANDLERSTART>*/try (
	if _MeshBuildingEnabled then (
		if _NeedUpdate or _AlwaysRedraw then (
			_NeedUpdate = false
			Free _Verts
			Free _MtlIDs
			RebuildMesh (&_Verts) (&_Faces) (&_MtlIDs)
		)
		true
	) else
		false
	/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
	/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
fn SuspendMeshBuilding = (
	_MeshBuildingEnabled = false
	OK
)
fn ResumeMeshBuilding = (
	/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
	/*<ERRHANDLERSTART>*/try (
	_MeshBuildingEnabled = true
	_RebuildMesh()
	OK
	/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHReport CET ESS NoMetro:true)/*<ERRHANDLEREND>*/
	/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
)
on buildMesh do (
	if _RebuildMesh() then (
		if _MtlIDs.Count != 0 then
			SetMesh Mesh Faces:_Faces Vertices:_Verts MaterialIDs:_MtlIDs
		else
			SetMesh Mesh Faces:_Faces Vertices:_Verts
	)
)
on Clone OldObj do (
	_Faces = (DeepCopy OldObj._Faces)
	_Verts = (DeepCopy OldObj._Verts)
	_MtlIDs = (DeepCopy OldObj._MtlIDs)
	_AlwaysRedraw = OldObj._AlwaysRedraw
)
on Create do (
	SuspendMeshBuilding()
	if Have AdditionalCreateHandler then
		AdditionalCreateHandler()
)
on PostCreate do
	ResumeMeshBuilding()
on Load do
	SuspendMeshBuilding()
on PostLoad do
	ResumeMeshBuilding()
