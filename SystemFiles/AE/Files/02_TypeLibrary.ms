/*#PC*DEFINE	CurrentGame	AE*/
/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	
	/*etc*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileInstance*/ strBINWeaponsFileInstance (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileInstance",
		WeaponClass,
		Pos,
		Size,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ReadVal = GIMS.Core.BufferMgr.ReadVal
				WeaponClass = ((ReadVal BufferID BinType:#UShort) + 1)
				Pos = (ReadVal BufferID MaxType:#P3 BinType:#Short)
				Pos.y *= -1
				Size = (
					if WeaponClass == 4 then
						(GIMS.Core.ArrayOps.Modify (ReadVal BufferID MaxType:#Array Size:3 BinType:#Float) 100 #Multiply)
					else
						#(50, 50, 50)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID (WeaponClass - 1) BinType:#UShort
				WriteVal BufferID [Pos.x, -Pos.y, Pos.z] BinType:#Short
				if WeaponClass == 4 then
					WriteVal BufferID (GIMS.Core.ArrayOps.Modify Size 100 #Divide) BinType:#Float
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode i = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				EGIMS_AE_WeaponInstance Name:(i as String) WeaponClass:WeaponClass Size:Size Pos:Pos Parent:ParentNode
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileNode*/ strBINWeaponsFileNode (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileNode",
		ShipID,
		Instances = #(),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress
				ShipID = ((ReadVal BufferID BinType:#UShort) + 1)
				local	InstanceCount = (ReadVal BufferID BinType:#UShort),
						BINWeaponsFileInstance = GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileInstance
				Instances.Count = InstanceCount
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				for i = 1 to InstanceCount do (
					local	tInstance = (BINWeaponsFileInstance())
					tInstance.Read BufferID
					Instances[i] = tInstance
					UpdateProgress #Progress (GetProgress BufferID)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID (ShipID - 1) BinType:#UShort
				WriteVal BufferID Instances.Count BinType:#UShort
				for Inst in Instances do
					Inst.Write BufferID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode i = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (EGIMS_AE_WeaponNode Name:(i as String) ShipID:ShipID Parent:ParentNode)
				for i = 1 to Instances.Count do
					Instances[i].Create Result i
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFile*/ strBINWeaponsFile (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFile",
		DiskPath,
		ObjName,
		Extension = ".bin",
		Nodes = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						NotEOF = BufferMgr.NotEOF,
						ReadVal = BufferMgr.ReadVal,
						BINWeaponsFileNode = GIMS.CurrentGame.Core.TypeLibrary.BINWeaponsFileNode,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName + Extension) Mode:#StreamBin)
				while (NotEOF BufferID) do (
					local	tNode = (BINWeaponsFileNode())
					tNode.Read BufferID
					Append Nodes tNode
				)
				BufferMgr.ClearBuffer BufferID
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						FilePath = (DiskPath + ObjName + Extension),
						BufferID = (BufferMgr.Create FilePath:FilePath Mode:#StreamBin),
						NodeCount = Nodes.Count,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				for i = 1 to NodeCount do (
					Nodes[i].Write BufferID
					UpdateProgress #Progress [i, 0, NodeCount]
				)
				BufferMgr.WriteFile BufferID FilePath:FilePath
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Self ParentNode:RootNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsParentRoot = (ParentNode == RootNode),
						ParentNodeTransform = (
							if IsParentRoot then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						Result = (EGIMS_AE_Weapon Name:ObjName Transform:ParentNodeTransform),
						NodeCount = Nodes.Count,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				if not IsParentRoot then
					Result.Parent = ParentNode
				for i = 1 to NodeCount do (
					Nodes[i].Create Result i
					UpdateProgress #Progress [i, 0, NodeCount]
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	/*collisions*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileInstance*/ strBINCollisionFileInstance (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileInstance",
		Type,
		Pos,
		Size,
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ReadVal = GIMS.Core.BufferMgr.ReadVal
				Type = (ReadVal BufferID BinType:#UInt)
				case Type of (
					0: (
						Pos = (ReadVal BufferID MaxType:#P3 BinType:#Int)
						Size = ((ReadVal BufferID BinType:#Int) / (-2))
					)
					1: (
						Pos = (ReadVal BufferID MaxType:#P3 BinType:#Int)
						Size = ((ReadVal BufferID MaxType:#P3 BinType:#Int) * (-2))
					)
					default:
						throw "Unknown Type"
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID Type BinType:#UInt
				case Type of (
					0: (
						WriteVal BufferID Pos BinType:#Int
						WriteVal BufferID (Size * (-2)) BinType:#Int
					)
					1: (
						WriteVal BufferID Pos BinType:#Int
						WriteVal BufferID (Size / (-2)) BinType:#Int
					)
					default:
						throw "Unknown Type"
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetValueCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case Type of (
					0:
						5
					1:
						7
					default:
						throw "Unknown Type"
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode i = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case Type of (
					0:
						EGIMS_AE_Col_Sphere Name:(FormattedPrint i Format:"03d") Pos:Pos Radius:Size Parent:ParentNode
					1: (
						local	Result = (EGIMS_AE_Col_Box Name:(FormattedPrint i Format:"03d") Pos:Pos Parent:ParentNode)
						Result.SuspendMeshBuilding()
						Result.Width = Size.x
						Result.Depth = Size.y
						Result.Height = Size.z
						Result.ResumeMeshBuilding()
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileNode*/ strBINCollisionFileNode (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileNode",
		ID,
		Instances = #(),
		fn Read BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						GetProgress = BufferMgr.GetProgress
				ID = (ReadVal BufferID BinType:#UInt)
				BufferMgr.Skip BufferID 4
				local	InstanceCount = (ReadVal BufferID BinType:#UInt),
						BINCollisionFileInstance = GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileInstance
				Instances.Count = InstanceCount
				local	UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				for i = 1 to InstanceCount do (
					local	tInstance = (BINCollisionFileInstance())
					tInstance.Read BufferID
					Instances[i] = tInstance
					UpdateProgress #Progress (GetProgress BufferID)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID ID BinType:#UInt
				local	ValueCount = 0
				for Inst in Instances do
					ValueCount += (Inst.GetValueCount())
				WriteVal BufferID ValueCount BinType:#UInt
				WriteVal BufferID Instances.Count BinType:#UInt
				for Inst in Instances do
					Inst.Write BufferID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create ParentNode i = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = (EGIMS_AE_CollisionNode Name:(FormattedPrint i Format:"03d") Parent:ParentNode ID:ID)
				for i = 1 to Instances.Count do
					Instances[i].Create Result i
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFile*/ strBINCollisionFile (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFile",
		DiskPath,
		ObjName,
		Extension = ".bin",
		Nodes = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						NotEOF = BufferMgr.NotEOF,
						ReadVal = BufferMgr.ReadVal,
						BINCollisionFileNode = GIMS.CurrentGame.Core.TypeLibrary.BINCollisionFileNode,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName + Extension) Mode:#StreamBin)
				while (NotEOF BufferID) do (
					local	tNode = (BINCollisionFileNode())
					tNode.Read BufferID
					Append Nodes tNode
				)
				BufferMgr.ClearBuffer BufferID
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						FilePath = (DiskPath + ObjName + Extension),
						BufferID = (BufferMgr.Create FilePath:FilePath Mode:#StreamBin),
						NodeCount = Nodes.Count,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				for i = 1 to NodeCount do (
					Nodes[i].Write BufferID
					UpdateProgress #Progress [i, 0, NodeCount]
				)
				BufferMgr.WriteFile BufferID FilePath:FilePath
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Self ParentNode:RootNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsParentRoot = (ParentNode == RootNode),
						ParentNodeTransform = (
							if IsParentRoot then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						Result = (EGIMS_AE_Collision Name:ObjName Transform:ParentNodeTransform),
						NodeCount = Nodes.Count,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				if not IsParentRoot then
					Result.Parent = ParentNode
				for i = 1 to NodeCount do (
					Nodes[i].Create Result i
					UpdateProgress #Progress [i, 0, NodeCount]
				)
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	/*models*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimBlock*/ strAEMMeshAnimBlock (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimBlock",
		Type = (-1),
		KeyTimes = #(),
		KeyValues = #(),
		fn ReadKeys BufferID FPS = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	ReadVal = GIMS.Core.BufferMgr.ReadVal,
						KeyCount = (ReadVal BufferID BinType:#UShort),
						TargetKeyTimes = #(),
						TargetKeyValues = #()
				TargetKeyTimes.Count = (TargetKeyValues.Count = KeyCount)
				for i = 1 to KeyCount do (
					TargetKeyTimes[i] = ((ReadVal BufferID BinType:#Float) / FPS)
					TargetKeyValues[i] = (
						case Type of (
							0:
								(ReadVal BufferID BinType:#Float)
							1:
								(ReadVal BufferID BinType:#Float MAXType:#P3)
							2:
								(ReadVal BufferID BinType:#Float)
							Default:
								throw ("Unknown key type " + (Type as String))
						)
					)
				)
				#(TargetKeyTimes, TargetKeyValues)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID FPS AxisCount = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				case Type of (
					(-1):
						(/*SKIP*/)
					0: (
						KeyTimes.Count = (KeyValues.Count = AxisCount)
						for i = 1 to AxisCount do (
							local	Data = (ReadKeys BufferID FPS)
							KeyTimes[i] = Data[1]
							KeyValues[i] = Data[2]
						)
					)
					Default: (
						local	Data = (ReadKeys BufferID FPS)
						KeyTimes += Data[1]
						KeyValues += Data[2]
					)
				)
				GIMS.Core.GUIMgr.UpdateProgress #Progress (GIMS.Core.BufferMgr.GetProgress BufferID)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn WriteKeys BufferID FPS Times Values = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal,
						KeyCount = Times.Count
				WriteVal BufferID KeyCount BinType:#UShort
				for i = 1 to KeyCount do (
					WriteVal BufferID (Times[i] * FPS) BinType:#Float
					if
						(IsKindOf Type Integer) and
						Type > -1 and
						Type < 3
					then
						WriteVal BufferID Values[i] BinType:#Float
					else
						throw ("Unknown key type " + (Type as String))
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID FPS TypeMod = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	WriteVal = GIMS.Core.BufferMgr.WriteVal
				WriteVal BufferID (Type + TypeMod) BinType:#Short
				case Type of (
					(-1):
						(/*SKIP*/)
					0: (
						for i = 1 to KeyTimes.Count do
							WriteKeys BufferID FPS KeyTimes[i] KeyValues[i]
					)
					Default:
						WriteKeys BufferID FPS KeyTimes KeyValues
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn FixAnimValue BlockID Type AxisID ValueID AllKeyValues:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if not Supplied AllKeyValues then
					AllKeyValues = KeyValues
				case BlockID of (
					1: (	/*Pos*/
						case Type of (
							0: (
								case AxisID of (
									1:
										-AllKeyValues[1][ValueID]
									2:
										AllKeyValues[3][ValueID]
									3:
										AllKeyValues[2][ValueID]
								)
							)
							1: (
								local	Val = AllKeyValues[ValueID]
								[-Val.x, Val.z, Val.y]
							)
						)
					)
					2: (	/*Rotation*/
						local	TypeCast = GIMS.Core.ValueOps.TypeCast
						case Type of (
							0: (
								if AxisID != 3 then
									-(TypeCast AllKeyValues[AxisID][ValueID] #RadToDeg)
								else
									(TypeCast AllKeyValues[AxisID][ValueID] #RadToDeg)
							)
							1: (
								local	Val = (TypeCast AllKeyValues[ValueID] #RadToDeg)
								(TypeCast [-Val.x, -Val.y, Val.z] #Euler)
							)
						)
					)
					3: (	/*Scale*/
						case Type of (
							0: (
								case AxisID of (
									1:
										AllKeyValues[1][ValueID]
									2:
										AllKeyValues[3][ValueID]
									3:
										AllKeyValues[2][ValueID]
								)
							)
							1: (
								local	Val = AllKeyValues[ValueID]
								[Val.x, Val.z, Val.y]
							)
						)
					)
					4:	/*Opacity*/
						(AllKeyValues[ValueID] / 100)
					5:	/*UVW*/
						(AllKeyValues[AxisID][ValueID] / 100)
					default:
						throw "Unknown BlockID"
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn AnimateAngle TheMesh KeyTime Val = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				at Time (
					if KeyTime < 0 then
						0
					else
						KeyTime
				) (
					local	TempPos = TheMesh.Pos
					TheMesh.Rotation = Val
					TheMesh.Pos = TempPos
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create TheMesh BlockID = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Type != -1 then (
					local	AxisKeyCounts = #(),
							KeyTimeCount = KeyTimes.Count,
							HaveKeys = false
					if Type == 0 then (
						for i = KeyTimeCount to 1 by -1 do (
							local	KeyCount = KeyTimes[i].Count
							AxisKeyCounts[i] = KeyCount
							if not HaveKeys then
								HaveKeys = (KeyCount != 0)
						)
					) else
						HaveKeys = (KeyTimeCount != 0)
					if HaveKeys then (
						with animate on (
							case BlockID of (
								1: (
									case Type of (
										0: (
											for AxisID = 1 to 3 do (
												local	AxisTimes = KeyTimes[AxisID],
														KeyCount = AxisKeyCounts[AxisID]
												for KeyID = 1 to KeyCount do (
													local	KeyTime = AxisTimes[KeyID]
													at Time (if KeyTime < 0 then 0 else KeyTime) (
														local	CurrentValue = TheMesh.Pos
														CurrentValue[AxisID] = (FixAnimValue BlockID Type AxisID KeyID)
														TheMesh.Pos = CurrentValue
													)
												)
											)
										)
										1: (
											for KeyID = 1 to KeyTimeCount do (
												local	KeyTime = KeyTimes[KeyID]
												at Time (if KeyTime < 0 then 0 else KeyTime)
													TheMesh.Pos = (FixAnimValue BlockID Type 0 KeyID)
											)
										)
										2:
											throw "Can't handle Float position data"
									)
								)
								2: (
									local	TypeCast = GIMS.Core.ValueOps.TypeCast,
											AllKeyValues, AllKeyTimes
									case Type of (
										0: (
											local	XTimes = KeyTimes[1],
													YTimes = KeyTimes[2],
													ZTimes = KeyTimes[3],
													XKeyCount = XTimes.Count,
													YKeyCount = YTimes.Count,
													ZKeyCount = ZTimes.Count
											if
												XKeyCount == YKeyCount and
												XKeyCount == ZKeyCount
											then (
												for KeyID = 1 to XKeyCount do
													AnimateAngle TheMesh XTimes[KeyID] (TypeCast (EulerAngles (FixAnimValue BlockID Type 1 KeyID) (FixAnimValue BlockID Type 2 KeyID) (FixAnimValue BlockID Type 3 KeyID)) Quat)
											) else (
												local	AppendIfUniq = GIMS.Core.ArrayOps.AppendIfUniq,
														AllKeyCount = XKeyCount,
														AllKeyCountAxisID = 1
												if YKeyCount > AllKeyCount then (
													AllKeyCount = YKeyCount
													AllKeyCountAxisID = 2
												)
												if ZKeyCount > AllKeyCount then (
													AllKeyCount = ZKeyCount
													AllKeyCountAxisID = 3
												)
												AllKeyTimes = (DeepCopy KeyTimes[AllKeyCountAxisID])
												AllKeyValues = #()
												for i = AllKeyCount to 1 by -1 do (
													local	Val = [0, 0, 0]
													Val[AllKeyCountAxisID] = KeyValues[AllKeyCountAxisID][i]
													AllKeyValues[i] = Val
												)
												local	KeyValuesTimes = #(AllKeyValues, AllKeyTimes),
														AxisIDs = #{1..3}
												AxisIDs[AllKeyCountAxisID] = false
												for AxisID in AxisIDs do (
													local	AxisKeyTimes = KeyTimes[AxisID],
															AxisKeyValues = KeyValues[AxisID]
													for i = 1 to AxisKeyTimes.Count do
														AxisKeyValues[AppendIfUniq KeyValuesTimes AxisKeyTimes[i] MHLItem:[0, 0, 0] GetID:true Sorted:true Search_Compare_MaxDiff:0.1] = AxisKeyValues[i]
												)
											)
										)
										1: (
											AllKeyTimes = KeyTimes
											AllKeyValues = unsupplied
										)
										2:
											throw "Can't handle Float rotation data"
									)
									if Have AllKeyValues then (
										local	KeyCount = AllKeyTimes.Count
										for KeyID = 1 to KeyCount do
											AnimateAngle TheMesh AllKeyTimes[KeyID] (TypeCast (FixAnimValue BlockID 1 0 KeyID AllKeyValues:AllKeyValues) Quat)
									)
								)
								3: (
									case Type of (
										0: (
											for AxisID = 1 to 3 do (
												local	AxisTimes = KeyTimes[AxisID],
														KeyCount = AxisTimes.Count
												for KeyID = 1 to KeyCount do (
													local	KeyTime = AxisTimes[KeyID]
													at Time (if KeyTime < 0 then 0 else KeyTime) (
														local	CurrentValue = TheMesh.Scale
														CurrentValue[AxisID] = (FixAnimValue BlockID Type AxisID KeyID)
														TheMesh.Scale = CurrentValue
													)
												)
											)
										)
										1: (
											for KeyID = 1 to KeyTimeCount do (
												local	KeyTime = KeyTimes[KeyID]
												at Time (if KeyTime < 0 then 0 else KeyTime)
													TheMesh.Scale = (FixAnimValue BlockID Type 0 KeyID)
											)
										)
										2:
											throw "Can't handle Float scale data"
									)
								)
								4: (
									case Type of (
										0:
											throw "Can't handle per-axis material opacity data"
										1:
											throw "Can't handle Point3 material opacity data"
										2: (
											local	Mtl = TheMesh.Material
											for KeyID = 1 to KeyTimeCount do (
												local	KeyTime = KeyTimes[KeyID]
												at Time (if KeyTime < 0 then 0 else KeyTime)
													Mtl.AlterProperty #Opacity (FixAnimValue BlockID Type 0 KeyID)
											)
										)
									)
								)
								5: (
									case Type of (
										0: (
											local	PropertyNames = #(
														#U_Offset,
														#V_Offset,
														#U_Tiling,
														#V_Tiling
													),
													Mtl = TheMesh.Material
											for AxisID = 1 to 4 do (
												local	AxisTimes = KeyTimes[AxisID],
														KeyCount = AxisKeyCounts[AxisID]
												for KeyID = 1 to KeyCount do (
													local	KeyTime = AxisTimes[KeyID]
													at Time (if KeyTime < 0 then 0 else KeyTime)
														Mtl.AlterProperty PropertyNames[AxisID] (FixAnimValue BlockID Type AxisID KeyID)
												)
											)
										)
										Default:
											throw "Can't handle non - Float UVW data"
									)
								)
							)
						)
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimation*/ strAEMMeshAnimation (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimation",
		Blocks = #(),
		fn Read BufferID ModelVersion = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	FPS = GIMS.CurrentGame.Rules.AnimationFPS,
						AEMMeshAnimBlock = GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimBlock,
						ReadVal = GIMS.Core.BufferMgr.ReadVal
				if ModelVersion == 2 then (
					local	UNKNOWN = (ReadVal BufferID BinType:#UByte)
					if
						Have UNKNOWN and
						UNKNOWN != 0
					then
						throw ("Holy shit, IT'S ALIVE!!!!!! " + (UNKNOWN as String))
				) else (
					local	Type,
							BaseBlockCount = (
								if ModelVersion > 4 then
									4
								else
									ModelVersion
							)
					Blocks.Count = BaseBlockCount
					for i = 1 to BaseBlockCount do (
						Type = (ReadVal BufferID BinType:#Short)
						local	AnimBlock = (AEMMeshAnimBlock Type:Type)
						AnimBlock.Read BufferID FPS 3
						Blocks[i] = AnimBlock
					)
					while (Type = (ReadVal BufferID BinType:#Short)) != 0 do (
						local	AnimBlock = (AEMMeshAnimBlock Type:(Type - 1))
						AnimBlock.Read BufferID FPS 7
						Append Blocks AnimBlock
					)
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID ModelVersion = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if ModelVersion == 2 then
					GIMS.Core.BufferMgr.WriteVal BufferID 0 BinType:#UByte
				else (
					local	FPS = GIMS.CurrentGame.Rules.AnimationFPS,
							BaseBlockCount = (
								if ModelVersion > 4 then
									4
								else
									ModelVersion
							)
					for i = 1 to BaseBlockCount do
						Blocks[i].Write BufferID FPS 0
					for i = (BaseBlockCount + 1) to Blocks.Count do
						Blocks[i].Write BufferID FPS 1
					GIMS.Core.BufferMgr.WriteVal BufferID 0 BinType:#Short
				)
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create TheMesh = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				MAXOps.SetSetKeyFilterState #Materials true
				TheMesh.Pos.Controller = (Linear_Position())
				TheMesh.Rotation.Controller = (Linear_Rotation())
				TheMesh.Scale.Controller = (Linear_Scale())
				local	MaxTime = -999999999
				for tBlock in Blocks do (
					local	Type = tBlock.Type
					if Type == 0 then (
						for BlockKeyTimes in tBlock.KeyTimes do (
							local	KeyTimes = BlockKeyTimes,
									KeyCount = KeyTimes.Count,
									StartKeyID = (
										if KeyCount > 2 then
											2
										else
											1
									)
							for i = StartKeyID to KeyCount do (
								local	KeyTime = KeyTimes[i]
								if KeyTime > MaxTime then
									MaxTime = KeyTime
							)
						)
					) else (
						local	KeyTimes = tBlock.KeyTimes,
								KeyCount = KeyTimes.Count,
								StartKeyID = (
									if KeyCount > 2 then
										2
									else
										1
								)
						for i = StartKeyID to KeyCount do (
							local	KeyTime = KeyTimes[i]
							if KeyTime > MaxTime then
								MaxTime = KeyTime
						)
					)
				)
				if MaxTime > 0 then
					GIMS.Core.ObjectMgr.ExtendAnimationRange 0 MaxTime
				for BlockID = 1 to Blocks.Count do
					Blocks[BlockID].Create TheMesh BlockID
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.AEMMesh*/ strAEMMesh (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.AEMMesh",
		Faces = #(),
		Verts = #(),
		UVs,
		Normals = unsupplied,
		Colors = unsupplied,
		Animation,
		BoundingSphere,
		PivotPoint,
		fn FixData ModelVersion Flags Mode DataToRestore:unsupplied = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Mode == #Restore then (
					if DataToRestore == OK then
							throw "You're trying to restore data from file. Don't do that"
					else (
						if not Supplied DataToRestore then
								throw "You're trying to restore data that doesn't exist. Don't do that"
					)
					Faces = DataToRestore[1]
					Verts = DataToRestore[2]
					if Supplied DataToRestore[3] then
						UVs = DataToRestore[3]
					if Supplied DataToRestore[4] then
						Normals = DataToRestore[4]
					if Supplied DataToRestore[5] then
						Colors = DataToRestore[5]
					OK
				) else (
					local	FromMAX = (Mode == #FromMAX),
							FromFile = (Mode == #FromFile),
							HaveNormals = Flags[2]
					if FromMAX then (
						DataToRestore = #(
							(DeepCopy Faces),
							(DeepCopy Verts),
							unsupplied,
							unsupplied,
							unsupplied
						)
					) else (
						if not FromFile then
							throw ("Unknown Mode: " + (Mode as String))
					)
					local	FaceModifier, DataAction
					if FromFile then (
						FaceModifier = 1
						DataAction = #Divide
					) else (
						FaceModifier = -1
						DataAction = #Multiply
					)
					for i = 1 to Verts.Count do (
						local	Val = Verts[i]
						Verts[i] = [-Val.x, Val.z, Val.y]
					)
					if HaveNormals then (
						for i = 1 to Normals.Count do (
							local	Val = Normals[i]
							Normals[i] = [-Val.x, Val.z, Val.y]
						)
					)
					local	Modify = GIMS.Core.ArrayOps.Modify
					Modify Faces FaceModifier #Add CopyArray:false
					if ModelVersion > 2 then (
						BoundingSphere.x *= -1
						BoundingSphere.y *= -1
						PivotPoint.x *= -1
						PivotPoint.y *= -1
					)
					if ModelVersion < 4 then (
						if not FromFile then (
							local	Round = GIMS.Core.ValueOps.Round
							for Vert in Verts do (
								for i = 1 to 3 do
									Vert[i] = (Round Vert[i])
							)
						)
						if Flags[1] then (
							if FromMAX then
								DataToRestore[3] = (DeepCopy UVs)
							Modify UVs 4096 DataAction CopyArray:false
						)
						if HaveNormals then (
							if FromMAX then
								DataToRestore[4] = (DeepCopy Normals)
							Modify Normals 32768 DataAction CopyArray:false
						)
						if Flags[3] then (
							if FromMAX then
								DataToRestore[5] = (DeepCopy Colors)
							Modify Colors 255 DataAction CopyArray:false
						)
					)
					if FromMAX then
						DataToRestore
					else
						OK
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Read BufferID ModelVersion Flags AllowNullMesh = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						Skip = BufferMgr.Skip,
						ReadVal = BufferMgr.ReadVal,
						Modify = GIMS.Core.ArrayOps.Modify,
						HaveBounds = (ModelVersion != 2),
						VertType, UVType, NormalType, ColorType,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						GetProgress = BufferMgr.GetProgress
				if ModelVersion < 4 then (
					VertType = #Int
					UVType = (NormalType = #Short)
					ColorType = #UByte
				) else
					VertType = (UVType = (NormalType = (ColorType = #Float)))
				if HaveBounds then
					PivotPoint = (ReadVal BufferID BinType:#Float MAXType:#P3)
				local	IdxCount = (ReadVal BufferID BinType:#UShort)
				UpdateProgress #Progress (GetProgress BufferID)
				if
					AllowNullMesh or
					IdxCount != 0
				then (
					Faces = (ReadVal BufferID MAXType:#Array ArrayItemMAXType:#P3 BinType:#UShort Size:(IdxCount / 3))
					UpdateProgress #Progress (GetProgress BufferID)
					local	VertCount = (ReadVal BufferID BinType:#UShort)
					Verts = (ReadVal BufferID MAXType:#Array Size:VertCount ArrayItemMAXType:#P3 BinType:VertType)
					UpdateProgress #Progress (GetProgress BufferID)
					if Flags[1] then (
						UVs = (ReadVal BufferID MAXType:#Array Size:VertCount ArrayItemMAXType:#P2 BinType:UVType)
						UpdateProgress #Progress (GetProgress BufferID)
					)
					if Flags[2] then (
						Normals = (ReadVal BufferID MAXType:#Array Size:VertCount ArrayItemMAXType:#P3 BinType:NormalType)
						UpdateProgress #Progress (GetProgress BufferID)
					)
					if Flags[3] then (
						Colors = (ReadVal BufferID MAXType:#Array Size:VertCount ArrayItemMAXType:#P4 BinType:ColorType)
					)
					if HaveBounds then
						BoundingSphere = (ReadVal BufferID BinType:#Float MAXType:#P4)
					Animation = (GIMS.CurrentGame.Core.TypeLibrary.AEMMeshAnimation())
					Animation.Read BufferID ModelVersion
					FixData ModelVersion Flags #FromFile
					true
				) else
					false
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write BufferID ModelVersion Flags CurrentProgress = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	DataToRestore = (FixData ModelVersion Flags #FromMAX),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						WriteVal = GIMS.Core.BufferMgr.WriteVal,
						HaveBounds = (ModelVersion != 2),
						VertType, UVType, NormalType, ColorType
				if ModelVersion < 4 then (
					VertType = #Int
					UVType = (NormalType = #Short)
					ColorType = #UByte
				) else
					VertType = (UVType = (NormalType = (ColorType = #Float)))
				if HaveBounds then
					WriteVal BufferID PivotPoint
				CurrentProgress.x += 1
				UpdateProgress #Progress CurrentProgress
				local	IdxCount = (Faces.Count * 3)
				WriteVal BufferID IdxCount BinType:#UShort
				if IdxCount != 0 then (
					WriteVal BufferID Faces BinType:#UShort
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					WriteVal BufferID Verts.Count BinType:#UShort
					WriteVal BufferID Verts BinType:VertType
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					if Flags[1] then
						WriteVal BufferID UVs BinType:UVType
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					if Flags[2] then
						WriteVal BufferID Normals BinType:NormalType
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					if Flags[3] then
						WriteVal BufferID Colors BinType:ColorType
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					if HaveBounds then
						WriteVal BufferID BoundingSphere
					Animation.Write BufferID ModelVersion
					CurrentProgress.x += 1
				) else
					CurrentProgress.x += 6
				FixData ModelVersion Flags #Restore DataToRestore:DataToRestore
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Mtl InstanceID ParentNode CurrentProgress = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				if Verts.Count != 0 then (
					local	Result = (
								GIMS.Core.ObjectMgr.CreateMesh \
								Verts \
								Faces \
								ObjName:(FormattedPrint InstanceID Format:"03d") \
								MapFaces:#(Faces) \
								MapVerts:#(UVs) \
								VertNormals:Normals \
								VertColors:Colors \
								Parent:ParentNode
							),
							UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
					CurrentProgress.x += 1
					UpdateProgress #Progress CurrentProgress
					Result.ShowVertexColors = true
					Result.Material = Mtl
 					/*<TODO> if Have Animation then
 						Animation.Create Result*/
					CurrentProgress.x += 1
				) else
					CurrentProgress.x += 2
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.AEMFile*/ strAEMFile (
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.AEMFile",
		DiskPath,
		ObjName,
		Extension = ".aem",
		ModelVersion,
		Flags,
		Instances = #(),
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	Result = true,
						BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						AEMMesh = GIMS.CurrentGame.Core.TypeLibrary.AEMMesh,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName + Extension) Mode:#StreamBin)
				local	Signature = (ReadVal BufferID MAXType:#NTString)
				ModelVersion = (GIMS.Core.ValueOps.TypeCast Signature[2] Integer)
				local	FlagsValue = (ReadVal BufferID BinType:#UByte),
						BitGet = Bit.Get
				Flags = #()
				for i = 3 to 1 by -1 do
					Flags[i] = (BitGet FlagsValue (i + 1))
				if ModelVersion == 2 then (
					local	tMesh = (AEMMesh())
					Result = (tMesh.Read BufferID ModelVersion Flags false)
					if Result then
						Append Instances tMesh
				) else (
					local	InstanceCount = (BufferMgr.ReadVal BufferID BinType:#UShort)
					Result = (InstanceCount != 0)
					if Result then (
						Instances.Count = InstanceCount
						local	Is1stMesh = true
						for i = 1 to InstanceCount while Result do (
							local	tMesh = (AEMMesh()),
									AllowNullMesh = (
										if Is1stMesh then
											Is1stMesh = false
										else
											true
									)
							Result = (tMesh.Read BufferID ModelVersion Flags AllowNullMesh)
							if
								AllowNullMesh or
								Result
							then
								Instances[i] = tMesh
							else
								GIMS.Core.SystemMgr.AddResult #Error ("File \"" + DiskPath + ObjName + Extension + "\" is corrupted! Skipping...")
						)
					)
				)
				BufferMgr.ClearBuffer BufferID
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Write = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						WriteVal = BufferMgr.WriteVal,
						FilePath = (DiskPath + ObjName + Extension),
						BufferID = (BufferMgr.Create FilePath:FilePath Mode:#StreamBin),
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress
				WriteVal BufferID ("V" + ModelVersion as String + "AEMesh") Size:-1
				local	BitSet = Bit.Set,
						FlagsValue = 0
				FlagsValue = (BitSet FlagsValue 1 true)
				for i = 1 to Flags.Count do
					FlagsValue = (BitSet FlagsValue (i + 1) Flags[i])
				FlagsValue = (BitSet FlagsValue 5 true)
				WriteVal BufferID FlagsValue BinType:#UByte
				local	InstanceCount = Instances.Count,
						CurrentProgress = [0, 0, InstanceCount * 7]
				if ModelVersion != 2 then
					WriteVal BufferID InstanceCount BinType:#UShort
				for i = 1 to InstanceCount do (
					Instances[i].Write BufferID ModelVersion Flags CurrentProgress
					UpdateProgress #Progress CurrentProgress
				)
				BufferMgr.WriteFile BufferID FilePath:FilePath
				OK
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetMaterial = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	TypeCast = GIMS.Core.ValueOps.TypeCast,
						\
						AEIFiles = (GIMS.CurrentGame.Core.GameMgr.AEIFiles),
						AEIFileNames = (GIMS.CurrentGame.Core.GameMgr.AEIFileNames),
						ModelTextureMap = GIMS.CurrentGame.Core.DB.ModelTextureMap,
						ArrayOps = GIMS.Core.ArrayOps,
						ModelMapID = (ArrayOps.Search ModelTextureMap[1] (ObjName as Name) Sorted:true),
						FoundTextureIDs = #(),
						FoundTextures = #(),
						FoundNSTextures = #()
				if ModelMapID != 0 then (
					local TextureFileName = ModelTextureMap[2][ModelMapID][1],
							NSTextureFileName = ModelTextureMap[3][ModelMapID][1]
					if Have TextureFileName then (
						local	TextureID = (FindItem AEIFileNames (TypeCast TextureFileName Name))
						if TextureID > 0 then (
							FoundTextureIDs[1] = TextureID
							FoundTextures[1] = AEIFiles[TextureID]
						)
					)
					if Have NSTextureFileName then (
						local	TextureID = (FindItem AEIFileNames (TypeCast NSTextureFileName Name))
						if TextureID > 0 then
							FoundNSTextures[1] = AEIFiles[TextureID]
					)
				) else (
					local	NameSplitter = "_",
							ObjNameParts = (FilterString ObjName NameSplitter),
							ObjNamePartCount = ObjNameParts.Count,
							QuickSort = ArrayOps.QuickSort,
							TexturePrecisions = #(),
							NSTexturePrecisions = #(),
							ObjNamePattern = (ObjName + "*")
					for i = 1 to ObjNamePartCount do
						ObjNameParts[i] = (TypeCast ObjNameParts[i] Name)
					for FileID = 1 to AEIFiles.Count do (
						local	FileName = (AEIFileNames[FileID] as String),
								FileNameParts = (FilterString FileName NameSplitter)
						for i = 1 to FileNameParts.Count do
							FileNameParts[i] = (TypeCast FileNameParts[i] Name)
						local	FoundPartIDs = #(),
								FoundTargetPartIDs = #()
						for i = 1 to ObjNamePartCount do (
							local	FoundPartID = (FindItem FileNameParts ObjNameParts[i])
							if FoundPartID != 0 then (
								Append FoundPartIDs i
								Append FoundTargetPartIDs FoundPartID
							)
						)
						local	FoundPartCount = FoundPartIDs.Count
						if FoundPartCount != 0 then (
							local	Precision = (((FoundPartCount as Float) / ObjNamePartCount) * 100)
							for i = 1 to FoundPartCount do (
								local	OffsetPenalty = (Abs (FoundPartIDs[i] - FoundTargetPartIDs[i])),
										LengthPenalty = (Abs (FileName.Count - ObjName.Count))
								Precision -= (((OffsetPenalty as Float) / ObjNamePartCount) + LengthPenalty)
							)
							if Precision > 0 then (
								if (FindItem FileNameParts #normal) != 0 then (
									Append FoundNSTextures AEIFiles[FileID]
									Append NSTexturePrecisions Precision
								) else (
									Append FoundTextures AEIFiles[FileID]
									Append TexturePrecisions Precision
									Append FoundTextureIDs FileID
								)
							)
						)
					)
					QuickSort #(FoundTextures, TexturePrecisions, FoundTextureIDs) MHL:true Descending:true
					QuickSort #(FoundNSTextures, NSTexturePrecisions) MHL:true Descending:true
					/*
					Print #FoundTextures
					Print FoundTextures
					Print #TexturePrecisions
					Print TexturePrecisions
					Print #FoundNSTextures
					Print FoundNSTextures
					Print #NSTexturePrecisions
					Print NSTexturePrecisions
					throw #DEBUG
					*/
				)
				local	HaveFoundTextures = (FoundTextures.Count != 0),
						RGBAlpha = (
							(MatchPattern ObjName Pattern:"*_add*") or
							(MatchPattern ObjName Pattern:"*_glow*") or
							(MatchPattern ObjName Pattern:"*_lights*") or (
								HaveFoundTextures and
								(GIMS.CurrentGame.Core.MAXFactory.MaterialOps.IsRGBAlphaTexture AEIFileNames[FoundTextureIDs[1]])
							)
						),
						GetAEITexture = GIMS.CurrentGame.Core.MAXFactory.ObjectMgr.GetAEITexture,
						ReadCached = GIMS.Core.CacheMgr.ReadCached,
						DiffMap, NormalSpecMap
				if HaveFoundTextures then
					DiffMap = (ReadCached FoundTextures[1] GetAEITexture GCCPath:#ResourceCachePath Type:"AEI.Cache" IgnoreBehavior:true)
				else
					GIMS.Core.SystemMgr.AddResult #Warning ("Can't find the texture for model: " + ObjName)
				if Have FoundNSTexture then
					NormalSpecMap = (ReadCached FoundNSTextures[1] GetAEITexture GCCPath:#ResourceCachePath Type:"AEI.Cache" IgnoreBehavior:true)
				(
					EGIMS_AE_material \
						DiffMap:DiffMap \
						NormalSpecMap:NormalSpecMap \
						Name:ObjName \
						RGBAlpha:RGBAlpha \
						ShowInViewport:true
				)
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create Self ParentNode:RootNode = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	IsParentRoot = (ParentNode == RootNode),
						ParentNodeTransform = (
							if IsParentRoot then
								(Matrix3 1)
							else
								ParentNode.Transform
						),
						Result = (
							EGIMS_AE_Model \
								Name:(GetFileNameFile ObjName) \
								ModelVersion:(ModelVersion - 1) \
								Flags:Flags \
								Transform:ParentNodeTransform \
						),
						InstanceCount = Instances.Count,
						UpdateProgress = GIMS.Core.GUIMgr.UpdateProgress,
						CurrentProgress = [0, 0, InstanceCount * 2]
				if not IsParentRoot then
					Result.Parent = ParentNode
				local	Mtl = (GetMaterial())
				for i = 1 to InstanceCount do (
					Instances[i].Create (Copy Mtl) i Result CurrentProgress
					UpdateProgress #Progress CurrentProgress
				)
				Result.Transform = ParentNodeTransform
				Result
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	/*textures*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary.AEIFile*/ strAEIFile ( /*WARN:	for testing only*/
		GIMSObjectLink = "GIMS.CurrentGame.Core.TypeLibrary.AEIFile",
		DiskPath,
		ObjName,
		Signature = "AEIFile",
		Type = 1,
		unk = 0,
		fn Read = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				local	BufferMgr = GIMS.Core.BufferMgr,
						ReadVal = BufferMgr.ReadVal,
						Skip = BufferMgr.Skip,
						BufferID = (BufferMgr.ReadFile (DiskPath + ObjName) Mode:#StreamBin)
				Signature = (ReadVal BufferID MAXType:#NTString)
				Type = (ReadVal BufferID BinType:#UByte)
				local	Width = (ReadVal BufferID BinType:#UShort),
						Height = (ReadVal BufferID BinType:#UShort)
				Skip BufferID (8 * (ReadVal BufferID BinType:#UShort))
				if
					Type > 12 and
					Type < 67
				then
					Skip BufferID (ReadVal BufferID BinType:#UInt)
				else
					Skip BufferID (Width * Height * 4)
				unk = (ReadVal BufferID BinType:#UShort)
				BufferMgr.ClearBuffer BufferID
				true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	
	/*this*/
	struct /*#PC*PATH	GIMS.CurrentGame.Core.TypeLibrary*/ strTypeLibrary (
		/*ETC*/
			BINWeaponsFileInstance = strBINWeaponsFileInstance,
			BINWeaponsFileNode = strBINWeaponsFileNode,
			BINWeaponsFile = strBINWeaponsFile,
		/*collisions*/
			BINCollisionFileInstance = strBINCollisionFileInstance,
			BINCollisionFileNode = strBINCollisionFileNode,
			BINCollisionFile = strBINCollisionFile,
		/*models*/
			AEMMeshAnimBlock = strAEMMeshAnimBlock,
			AEMMeshAnimation = strAEMMeshAnimation,
			AEMMesh = strAEMMesh,
			AEMFile = strAEMFile,
		/*textures*/
			AEIFile = strAEIFile
	)
	GIMS.CurrentGame.Core.TypeLibrary = strTypeLibrary()
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
