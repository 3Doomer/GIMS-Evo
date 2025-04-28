/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
	struct strEmuNODLane (
		Points,
		StepCounts,
		Steppings,
		Transforms,
		Cars = #(),
		CarCount = 1
	)
	struct strEmuNODSpline (
		Points,
		Nodes,
		StartInters = #(),
		StartInverts = #(),
		EndInters = #(),
		EndInverts = #(),
		FWLanes,
		RWLanes,
		HasFWLanes,
		HasRWLanes,
		Closed,
		FWLanesCount,
		RWLanesCount,
		DoubleSide,
		FWTrafficIDs,
		RWTrafficIDs,
		Widths,
		RevWidths,
		Normals,
		IsBoatPath
	)
	struct strEmuNODInter (
		Pos,
		Radius,
		Structure
	)
	struct strEmuNODCar (
		CurrentLink,
		Trans = (Matrix3 0),
		Visible = false,
		Reversed = false,
		OwnSpline,
		CanMove = true,
		LaneID,
		StartPointID,
		EndPointID,
		StepCount,
		LODLevel = 3,
		LaneCarID = 1,
		ThisObj,
		fn AssignLink = (PROTOTYPE),
		fn RevertBack = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if Reversed then (
					if OwnSpline.HasFWLanes then
						Reversed = false
					else
						CanMove = false
				) else (
					if OwnSpline.HasRWLanes then
						Reversed = true
					else
						CanMove = false
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ResolveRoadCross = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local NewSplineID = 0
				if OwnSpline.Closed then (
					if OwnSpline.StartInters.Count != 0 then (
						if Reversed then (
							OwnSpline.RWLanes[LaneID].Cars[LaneCarID] = undefined
							OwnSpline.RWLanes[LaneID].CarCount -= 1
						) else (
							OwnSpline.FWLanes[LaneID].Cars[LaneCarID] = undefined
							OwnSpline.FWLanes[LaneID].CarCount -= 1
						)
						NewSplineID = (Random 1 OwnSpline.StartInters.Count)
						Reversed = OwnSpline.StartInverts[NewSplineID]
						OwnSpline = OwnSpline.StartInters[NewSplineID]
					)
				) else (
					if EndPointID == 1 then (
						if OwnSpline.StartInters.Count != 0 then (
							if Reversed then (
								OwnSpline.RWLanes[LaneID].Cars[LaneCarID] = undefined
								OwnSpline.RWLanes[LaneID].CarCount -= 1
							) else (
								OwnSpline.FWLanes[LaneID].Cars[LaneCarID] = undefined
								OwnSpline.FWLanes[LaneID].CarCount -= 1
							)
							NewSplineID = (Random 1 OwnSpline.StartInters.Count)
							Reversed = OwnSpline.StartInverts[NewSplineID]
							OwnSpline = OwnSpline.StartInters[NewSplineID]
						) else
							RevertBack()
					) else (
						if OwnSpline.EndInters.Count != 0 then (
							if Reversed then (
								OwnSpline.RWLanes[LaneID].Cars[LaneCarID] = undefined
								OwnSpline.RWLanes[LaneID].CarCount -= 1
							) else (
								OwnSpline.FWLanes[LaneID].Cars[LaneCarID] = undefined
								OwnSpline.FWLanes[LaneID].CarCount -= 1
							)
							NewSplineID = (Random 1 OwnSpline.EndInters.Count)
							Reversed = OwnSpline.EndInverts[NewSplineID]
							OwnSpline = OwnSpline.EndInters[NewSplineID]
						) else
							RevertBack()
					)
				)
				if CanMove then (
					if Reversed then (
						LaneID = (Random 1 OwnSpline.RWLanesCount)
						CurrentLink = (OwnSpline.Widths.Count + 1)
						if NewSplineID != 0 then (
							Append OwnSpline.RWLanes[LaneID].Cars ThisObj
							LaneCarID = OwnSpline.RWLanes[LaneID].Cars.Count
							OwnSpline.RWLanes[LaneID].CarCount += 1
						)
					) else (
						LaneID = (Random 1 OwnSpline.FWLanesCount)
						CurrentLink = 0
						if NewSplineID != 0 then (
							Append OwnSpline.FWLanes[LaneID].Cars ThisObj
							LaneCarID = OwnSpline.FWLanes[LaneID].Cars.Count
							OwnSpline.FWLanes[LaneID].CarCount += 1
						)
					)
					AssignLink()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn AssignLink = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Skip = false
				if OwnSpline.Closed then (
					if Reversed then (
						if CurrentLink == 1 then (
							ResolveRoadCross()
							Skip = true
						) else
							CurrentLink -= 1
						if not Skip then (
							EndPointID = CurrentLink
							if EndPointID == OwnSpline.Points.Count then
								StartPointID = 1
							else
								StartPointID = (CurrentLink + 1)
						)
					) else (
						if CurrentLink == OwnSpline.Points.Count then (
							ResolveRoadCross()
							Skip = true
						) else
							CurrentLink += 1
						if not Skip then (
							StartPointID = CurrentLink
							if EndPointID == OwnSpline.Points.Count then
								EndPointID = 1
							else
								EndPointID = (CurrentLink + 1)
						)
					)
				) else (
					if Reversed then (
						if CurrentLink == 1 then (
							ResolveRoadCross()
							Skip = true
						) else
							CurrentLink -= 1
						if not Skip then (
							StartPointID = (CurrentLink + 1)
							EndPointID = CurrentLink
						)
					) else (
						if CurrentLink == OwnSpline.Widths.Count then (
							ResolveRoadCross()
							Skip = true
						) else
							CurrentLink += 1
						if not Skip then (
							StartPointID = CurrentLink
							EndPointID = (CurrentLink + 1)
						)
					)
				)
				if not Skip then (
					local	PreTrans
					if Reversed then (
						PreTrans = (Copy OwnSpline.RWLanes[LaneID].Transforms[CurrentLink])
						PreTrans.Position = OwnSpline.RWLanes[LaneID].Points[StartPointID]
					) else (
						PreTrans = (Copy OwnSpline.FWLanes[LaneID].Transforms[CurrentLink])
						PreTrans.Position = OwnSpline.FWLanes[LaneID].Points[StartPointID]
					)
					Trans = PreTrans
					StepCount = 1
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Init = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if Reversed then
					CurrentLink = (OwnSpline.Widths.Count + 1)
				else
					CurrentLink = 0
				Visible = false
				AssignLink()
				ThisObj
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Refresh = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Dist = (Distance (mapScreenToWorldRay [0, 0]).Pos Trans.Pos),
						Skip = false
				Visible = (
					Dist < NODEmulator.LODLevels[3] and
					(GIMS.Core.MAXFactory.SceneOps.CheckPointInFrustrum Trans.Pos)
				)
				if Visible then (
					LODLevel = (case of (
							(Dist < NODEmulator.LODLevels[1]): 1
							(Dist < NODEmulator.LODLevels[2]): 2
							Default: 3
						)
					)
					if
						CanMove and
						not NODEmulator.Paused
					then (
						if Reversed then (
							if NODEmulator.TrafficLight != OwnSpline.RWTrafficIDs[CurrentLink] then (
								if NODEmulator.CheckCollision then (
									if
										(
											Reversed and
											OwnSpline.RWLanes[LaneID].CarCount > 1
										) or (
											not Reversed and
											OwnSpline.FWLanes[LaneID].CarCount > 1
										)
									then (
										for tCar in OwnSpline.RWLanes[LaneID].Cars while not Skip where (
											Have tCar and
											tCar.Reversed and
											tCar.LaneCarID != LaneCarID and
											(
												(
													tCar.CurrentLink == CurrentLink and
													tCar.StepCount > StepCount
												) or
												tCar.CurrentLink == (CurrentLink - 1)
											) and
											(Distance Trans.Pos tCar.Trans.Pos) < 10
										) do
											Skip = true
									)
								)
								if not Skip then (
									Trans.Position -= OwnSpline.RWLanes[LaneID].Steppings[CurrentLink]
									StepCount += 1
									if StepCount >= OwnSpline.RWLanes[LaneID].StepCounts[CurrentLink] then
										AssignLink()
								)
							)
						) else (
							if NODEmulator.TrafficLight != OwnSpline.FWTrafficIDs[CurrentLink] then (
								if NODEmulator.CheckCollision then (
									for tCar in OwnSpline.FWLanes[LaneID].Cars while not Skip where (
										Have tCar and
										not tCar.Reversed and
										tCar.LaneCarID != LaneCarID and
										(
											(
												tCar.CurrentLink == CurrentLink and
												tCar.StepCount > StepCount
											) or
												tCar.CurrentLink == (CurrentLink + 1)
										) and
										(Distance Trans.Pos tCar.Trans.Pos) < 10
									) do
										Skip = true
								)
								if not Skip then (
									Trans.Position += OwnSpline.FWLanes[LaneID].Steppings[CurrentLink]
									StepCount += 1
									if StepCount >= OwnSpline.FWLanes[LaneID].StepCounts[CurrentLink] then
										AssignLink()
								)
							)
						)
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strPathsEmulator (
		EmuNODLane = strEmuNODLane,
		EmuNODSpline = strEmuNODSpline,
		EmuNODInter = strEmuNODInter,
		EmuNODCar = strEmuNODCar,
		Working = false,
		Worker, WorkerTL,
		Splines = #(),
		Cars = #(),
		UpdateInterval = 50.0,
		TrafficSwitchInterval = 5000.0,
		LODLevels = #(250, 500, 1000),
		RenderCars = true,
		RenderBoats = true,
		CheckCollision = true,
		RenderLanes = true,
		BoatColor = White,
		CarColor = Yellow,
		LaneColor = Orange,
		RenderMode = #(#ZBuffer, #Wireframe),
		RefreshTime = 0,
		ActiveCars = 0,
		Paused = false,
		TrafficLight = 1,
		fn EmulateTrafficLights = (
			try (
				local	RefreshTime, StartTime
				while NODEmulator.Working do (
					StartTime = GetTimeStamp()
					if NODEmulator.TrafficLight == 1 then
						NODEmulator.TrafficLight = 2
					else
						NODEmulator.TrafficLight = 1
					for Spl in NODEmulator.Splines do (
						for Lane in Spl.FWLanes where (Lane.Cars.Count != 0) and (Lane.CarCount < 1) do
							Free Lane.Cars
						for Lane in Spl.RWLanes where (Lane.Cars.Count != 0) and (Lane.CarCount < 1) do
							Free Lane.Cars
					)
					RefreshTime = ((GetTimeStamp()) - StartTime)
					if RefreshTime < NODEmulator.TrafficSwitchInterval then
						Sleep (0.001 * (NODEmulator.TrafficSwitchInterval - RefreshTime))
				)
			) catch (
				NODEmulator.Destroy()
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			)
			OK
		),
		fn Emulate = (
			try (
				local	StartTime, ACars
				while NODEmulator.Working do (
					StartTime = GetTimeStamp()
					ACars = 0
					for TempCar in NODEmulator.Cars while NODEmulator.Working do (
						TempCar.Refresh()
						if TempCar.Visible then
							ACars += 1
					)
					NODEmulator.ActiveCars = ACars
					NODEmulator.RefreshTime = ((GetTimeStamp()) - StartTime)
					if NODEmulator.RefreshTime < NODEmulator.UpdateInterval then
						Sleep (0.001 * (NODEmulator.UpdateInterval - NODEmulator.RefreshTime))
				)
			) catch (
				NODEmulator.Destroy()
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			)
			OK
		),
		fn GetNodeSpeed tNode = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if (Bit.Get tNode.flags_3 6) then
					((80.0 * 0.277778) / 1000.0 * UpdateInterval)
				else (
					if (Bit.Get tNode.flags_3 7) then
						((20.0 * 0.277778) / 1000.0 * UpdateInterval)
					else
						((60.0 * 0.277778) / 1000.0 * UpdateInterval)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetLinkWidth tLink IsBoatPath RW:false = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local Res
				if RW then (
					if (Bit.Get tLink.BackFlags 3) then
						Res = 8.0
					else (
						if (Bit.Get tLink.BackFlags 8) then
							Res = 4.0
						else
							Res = 6.0
					)
				) else (
					if (Bit.Get tLink.Flags 3) then
						Res = 8.0
					else (
						if (Bit.Get tLink.Flags 8) then
							Res = 4.0
						else
							Res = 6.0
					)
				)
				if IsBoatPath then
					(Res * 5)
				else
					Res
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn InitLanes tSpline = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	NodeSpeeds = (for i = 1 to tSpline.Nodes.Count collect (GetNodeSpeed tSpline.Nodes[i])),
						Steppings, RevSteppings, StepCounts, LanePoints, LaneOffsetID, Normals, Vectors, Transforms, PointID, LaneCount, Fixup, FixPointID, Proj, RX, RZ, PreTrans, tCar,
						OffsetFixups = #()
				if tSpline.Closed then (
					Steppings = (DeepCopy NodeSpeeds)
					RevSteppings = (DeepCopy Steppings)
					RevSteppings[RevSteppings.Count + 1] = RevSteppings[1]
					DeleteItem RevSteppings 1
				) else (
					Steppings = (DeleteItem (DeepCopy NodeSpeeds) NodeSpeeds.Count)
					RevSteppings = (DeleteItem (DeepCopy NodeSpeeds) 1)
				)
				Free OffsetFixups
				if tSpline.Closed then (
					if tSpline.DoubleSide then
						OffsetFixups = (Append (for PointID = 1 to tSpline.Points.Count collect 0.5) 0.5)
					else
						OffsetFixups = (Append (for PointID = 1 to tSpline.Points.Count collect ((0.5 * tSpline.FWLanesCount[PointID]) + 0.5)) ((0.5 * tSpline.FWLanesCount[1]) + 0.5))
				) else (
					if tSpline.DoubleSide then
						OffsetFixups = (for PointID = 1 to tSpline.Points.Count collect 0.5)
					else (
						for PointID = 1 to tSpline.Points.Count do (
							if PointID == tSpline.Points.Count then
								FixPointID = (PointID - 1)
							else
								FixPointID = PointID
							Append OffsetFixups ((0.5 * tSpline.FWLanesCount[FixPointID]) + 0.5)
						)
					)
				)
				tSpline.FWLanes = #()
				for LaneID = 1 to (AMax tSpline.FWLanesCount) do (
					LanePoints = #()
					if tSpline.Closed then (
						for PointID = 1 to tSpline.Points.Count do (
							if LaneID > tSpline.FWLanesCount[PointID] then
								LaneOffsetID = tSpline.FWLanesCount[PointID]
							else
								LaneOffsetID = LaneID
							Append LanePoints (tSpline.Points[PointID] + (tSpline.Normals[PointID] * tSpline.Widths[PointID] * LaneOffsetID) - (tSpline.Normals[PointID] * tSpline.Widths[PointID] * OffsetFixups[PointID]))
						)
						Append LanePoints (tSpline.Points[1] + (tSpline.Normals[1] * tSpline.Widths[1] * LaneOffsetID) - (tSpline.Normals[1] * tSpline.Widths[1] * OffsetFixups[1]))
					) else (
						for PointID = 1 to tSpline.Points.Count do (
							if PointID == tSpline.Points.Count then
								FixPointID = (PointID - 1)
							else
								FixPointID = PointID
							if LaneID > tSpline.FWLanesCount[FixPointID] then
								LaneOffsetID = tSpline.FWLanesCount[FixPointID]
							else
								LaneOffsetID = LaneID
							Append LanePoints (tSpline.Points[PointID] + (tSpline.Normals[FixPointID] * tSpline.Widths[FixPointID] * LaneOffsetID) - (tSpline.Normals[FixPointID] * tSpline.Widths[FixPointID] * OffsetFixups[PointID]))
						)
					)
					Vectors = (for i = 1 to (LanePoints.Count - 1) collect (Normalize (LanePoints[i + 1] - LanePoints[i])))
					Transforms = #()
					for Vec in Vectors do (
						Vec *= -1
						Proj = [Vec.x, Vec.y, 0]
						if Vec.z > 0 then
							RX = -(ACos ((Vec.x * Proj.x + Vec.y * Proj.y + Vec.z * Proj.z) / (SqRt (Vec.x^2 + Vec.y^2 + Vec.z^2) * SqRt (Proj.x^2 + Proj.y^2 + Proj.z^2))))
						else
							RX = (ACos ((Vec.x * Proj.x + Vec.y * Proj.y + Vec.z * Proj.z) / (SqRt (Vec.x^2 + Vec.y^2 + Vec.z^2) * SqRt (Proj.x^2 + Proj.y^2 + Proj.z^2))))
						RZ = (
							if Vec.x > 0 then
								(acos (dot -[Vec.x, Vec.y, 0] [0, 1, 0]))
							else (
								if Vec.x < 0 then
									-(acos (dot -[Vec.x, Vec.y, 0] [0, 1, 0]))
								else
									0
							)
						)
						Append Transforms (GIMS.Core.ValueOps.TypeCast (EulerAngles RX 0 RZ) Matrix3)
					)
					StepCounts = (for PointID = 1 to (LanePoints.Count - 1) collect ((Distance LanePoints[PointID] LanePoints[PointID + 1]) / Steppings[PointID]))
					if tSpline.Closed then 
						Append StepCounts ((Distance LanePoints[LanePoints.Count] LanePoints[1]) / Steppings[Steppings.Count])
					for i = 1 to Vectors.Count do
						Vectors[i] *= Steppings[i]
					Append tSpline.FWLanes (EmuNODLane Steppings:Vectors Points:LanePoints StepCounts:StepCounts Transforms:Transforms)
				)
				if not tSpline.DoubleSide then (
					Free OffsetFixups
					if tSpline.Closed then
						OffsetFixups = (Append (for PointID = 1 to tSpline.Points.Count collect ((0.5 * tSpline.RWLanesCount[PointID]) + 0.5)) ((0.5 * tSpline.RWLanesCount[1]) + 0.5))
					else (
						for PointID = 1 to tSpline.Points.Count do (
							if PointID == tSpline.Points.Count then
								FixPointID = (PointID - 1)
							else
								FixPointID = PointID
							Append OffsetFixups ((0.5 * tSpline.RWLanesCount[FixPointID]) + 0.5)
						)
					)
				)
				tSpline.RWLanes = #()
				for LaneID = 1 to (AMax tSpline.RWLanesCount) do (
					LanePoints = #()
					if tSpline.Closed then (
						for PointID = 1 to tSpline.Points.Count do (
							if LaneID > tSpline.RWLanesCount[PointID] then
								LaneOffsetID = tSpline.RWLanesCount[PointID]
							else
								LaneOffsetID = LaneID
							Append LanePoints (tSpline.Points[PointID] - (tSpline.Normals[PointID] * tSpline.RevWidths[PointID] * LaneOffsetID) + (tSpline.Normals[PointID] * tSpline.RevWidths[PointID] * OffsetFixups[PointID]))
						)
						Append LanePoints (tSpline.Points[1] - (tSpline.Normals[1] * tSpline.RevWidths[1] * LaneOffsetID) + (tSpline.Normals[1] * tSpline.RevWidths[1] * OffsetFixups[1]))
					) else (
						for PointID = 1 to tSpline.Points.Count do (
							if PointID == tSpline.Points.Count then
								FixPointID = (PointID - 1)
							else
								FixPointID = PointID
							if LaneID > tSpline.RWLanesCount[FixPointID] then
								LaneOffsetID = tSpline.RWLanesCount[FixPointID]
							else
								LaneOffsetID = LaneID
							Append LanePoints (tSpline.Points[PointID] - (tSpline.Normals[FixPointID] * tSpline.RevWidths[FixPointID] * LaneOffsetID) + (tSpline.Normals[FixPointID] * tSpline.RevWidths[FixPointID] * OffsetFixups[PointID]))
						)
					)
					Vectors = (for i = 1 to (LanePoints.Count - 1) collect (Normalize (LanePoints[i + 1] - LanePoints[i])))
					Transforms = #()
					for Vec in Vectors do (
						Proj = [Vec.x, Vec.y, 0]
						if Vec.z > 0 then
							RX = -(ACos ((Vec.x * Proj.x + Vec.y * Proj.y + Vec.z * Proj.z) / (SqRt (Vec.x^2 + Vec.y^2 + Vec.z^2) * SqRt (Proj.x^2 + Proj.y^2 + Proj.z^2))))
						else
							RX = (ACos ((Vec.x * Proj.x + Vec.y * Proj.y + Vec.z * Proj.z) / (SqRt (Vec.x^2 + Vec.y^2 + Vec.z^2) * SqRt (Proj.x^2 + Proj.y^2 + Proj.z^2))))
						RZ = (
							if Vec.x > 0 then
								(acos (dot -[Vec.x, Vec.y, 0] [0, 1, 0]))
							else (
								if Vec.x < 0 then
									-(acos (dot -[Vec.x, Vec.y, 0] [0, 1, 0]))
								else
									0
							)
						)
						Append Transforms (GIMS.Core.ValueOps.TypeCast (EulerAngles RX 0 RZ) Matrix3)
					)
					StepCounts = (for PointID = 1 to (LanePoints.Count - 1) collect ((Distance LanePoints[PointID] LanePoints[PointID + 1]) / RevSteppings[PointID]))
					if tSpline.Closed then
						Append StepCounts ((Distance LanePoints[LanePoints.Count] LanePoints[1]) / RevSteppings[RevSteppings.Count])
					for i = 1 to Vectors.Count do
						Vectors[i] *= RevSteppings[i]
					Append tSpline.RWLanes (EmuNODLane Steppings:Vectors Points:LanePoints StepCounts:StepCounts Transforms:Transforms)
				)
				Free OffsetFixups
				tSpline.FWLanesCount = (AMax tSpline.FWLanesCount)
				tSpline.RWLanesCount = (AMax tSpline.RWLanesCount)
				for LaneID = 1 to tSpline.FWLanesCount do (
					tCar = (EmuNODCar OwnSpline:tSpline LaneID:LaneID)
					tCar.ThisObj = tCar
					tCar.Init()
					Append tSpline.FWLanes[LaneID].Cars tCar
					Append Cars tCar
				)
				for LaneID = 1 to tSpline.RWLanesCount do (
					tCar = (EmuNODCar OwnSpline:tSpline LaneID:LaneID Reversed:true)
					tCar.ThisObj = tCar
					tCar.Init()
					Append tSpline.RWLanes[LaneID].Cars tCar
					Append Cars tCar
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ReadSplineProps tPath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	DoubleSide, IsBoatPath, Links, Nodes, Points, HasFWLanes, HasRWLanes, FWLanesCount, RWLanesCount, FWTrafficIDs, RWTrafficIDs, Widths, RevWidths,
						NoProps = true,
						NumNodes = (NumKnots tPath 1),
						NumLinks = (NumSegments tPath 1),
						Closed = (IsClosed tPath 1)
				if (getuserprop tPath "is_nodpath") == true then (
					Links = (execute (getuserprop tPath "links"))
					Nodes = (execute (getuserprop tPath "nodes"))
					if
						NumLinks == links.count and
						NumNodes == nodes.count
					then
						NoProps = false
				)
				if NoProps then (
					Links = (for i = 1 to NumLinks collect (shrlink density:100 backdensity:100 len:1 flags:0 backlen:8 backflags:0))
					Nodes = (for i = 1 to NumNodes collect (shrnode width:0 type:1 flags_1:0 flags_2:0 flags_3:0 flags_4:0 interp:0))
				)
				IsBoatPath = (Bit.Get Nodes[1].Flags_4 2)
				FWLanesCount = (for tLink in Links collect (Bit.And tLink.Len 7))
				RWLanesCount = (for tLink in Links collect (Bit.And tLink.BackLen 7))
				HasFWLanes = ((AMin FWLanesCount) != 0)
				HasRWLanes = ((AMin RWLanesCount) != 0)
				DoubleSide = (HasFWLanes and HasRWLanes)
				FWTrafficIDs = (for tLink in Links collect (Bit.Shift (Bit.And tLink.Len 192) -6))
				RWTrafficIDs = (for tLink in Links collect (Bit.Shift (Bit.And tLink.BackLen 192) -6))
				Points = (for i = 1 to NumNodes collect (GetKnotPoint tPath 1 i))
				Widths = (for tLink in Links collect (GetLinkWidth tLink IsBoatPath))
				RevWidths = (for tLink in Links collect (GetLinkWidth tLink IsBoatPath RW:true))
				local	Vectors = (
							if Closed then
								(Append (for i = 1 to (NumLinks - 1) collect (Normalize (Points[i + 1] - Points[i]))) (Normalize (Points[1] - Points[Points.Count])))
							else
								(for i = 1 to NumLinks collect (Normalize (Points[i + 1] - Points[i])))
						)
				local	VectorCount = Vectors.Count,
						Normals = #()
				for i = VectorCount to 1 by -1 do (
					local	Vec = Vectors[i]
					Vec.z = 0
					Normals[i] = (Vec * (Quat 0 0 0.707107 0.707107))
				)
				for i = 2 to Normals.Count do
					Normals[i] = (Normalize (Normals[i] + Normals[i - 1]))
				if Closed then
					Normals[1] = (Normalize (Normals[1] + Normals[Normals.Count]))
				(
					EmuNODSpline \
					RevWidths:RevWidths \
					DoubleSide:DoubleSide \
					Normals:Normals \
					IsBoatPath:IsBoatPath \
					Points:Points \
					Nodes:Nodes \
					HasFWLanes:HasFWLanes \
					HasRWLanes:HasRWLanes \
					Closed:Closed \
					FWLanesCount:FWLanesCount \
					RWLanesCount:RWLanesCount \
					FWTrafficIDs:FWTrafficIDs \
					RWTrafficIDs:RWTrafficIDs \
					Widths:Widths
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Destroy = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				Working = false
				try (
					WorkerTL.CancelAsync()
					Worker.CancelAsync()
					WorkerTL.Dispose()
					Worker.Dispose()
				)	catch ()
				WorkerTL = undefined
				Worker = undefined
				Sleep 0.5
				RefreshTime = 0
				ActiveCars = 0
				GIMS.Core.SystemMgr.DoGC()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Create = (
			local	Result = false
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if Have (NODParent = (findhierarchy "dev_paths/nod")) then (
					ProgressStart "Loading NOD emulator [1/3]"
					local	TempSpline, Structure, LinkFromStart, LinkToStart, LinkFromEnd, LinkToEnd,
							Intersections = #()
					RefreshTime = 0
					ActiveCars = 0
					Free Splines
					Free Cars
					for i = 1 to NODParent.Children.Count do (
						ProgressUpdate (i * 100.0 / NODParent.Children.Count)
						if not NODParent.Children[i].IsHiddenInVpt then (
							if
								(IsKindOf NODParent.Children[i] SplineShape) or
								(IsKindOf NODParent.Children[i] Line)
							then (
								if
									(getnodearea NODParent.Children[i].min Checkonly:true) and
									(getnodearea NODParent.Children[i].max Checkonly:true) and
									Have (TempSpline = (ReadSplineProps NODParent.Children[i])) and
									(
										TempSpline.HasFWLanes or
										TempSpline.HasRWLanes
									)
								then (
									if (Bit.And TempSpline.Nodes[1].Flags_1 144) == 0 then /* cars or boats */
										Append Splines TempSpline
								)
							) else (
								if
									(getnodearea NODParent.Children[i].pos Checkonly:true) and
									(
										(IsKindOf NODParent.Children[i] Sphere) or
										(IsKindOf NODParent.Children[i] GeoSphere)
									)
								then (
									Structure = (getuserprop NODParent.Children[i] "structure")
									if Have Structure then
										Append Intersections (EmuNODInter Pos:NODParent.Children[i].Pos Radius:NODParent.Children[i].Radius Structure:(Execute Structure))
									else
										Append Intersections (EmuNODInter Pos:NODParent.Children[i].Pos Radius:NODParent.Children[i].Radius Structure:(shrnode width:0 type:1 flags_1:0 flags_2:0 flags_3:0 flags_4:0 interp:0))
								)
							)
						)
					)
					ProgressEnd()
					ProgressStart "Loading NOD emulator [2/3]"
					local	LinkFromStart, LinkToStart
					for i = 1 to Splines.Count do (
						ProgressUpdate (i * 100.0 / Splines.Count)
						for tInter in Intersections do (
							LinkFromStart = ((Distance tInter.Pos Splines[i].Points[1]) < tInter.Radius)
							LinkFromEnd = ((Distance tInter.Pos Splines[i].Points[Splines[i].Points.Count]) < tInter.Radius)
							if
								LinkFromStart or
								LinkFromEnd
							then (
								if Splines[i].Closed then (
									Splines[i].Nodes[1] = tInter.Structure
									if LinkFromStart then ( /* inter at closed spline start/end */
										for tSpline in Splines where tSpline != Splines[i] do ( /* find linked splines */
											LinkToStart = (Distance tInter.Pos tSpline.Points[1]) < tInter.Radius
											LinkToEnd = (Distance tInter.Pos tSpline.Points[tSpline.Points.Count]) < tInter.Radius
											if
												LinkToStart or
												LinkToEnd
											then (
												if tSpline.Closed then (
													if LinkToStart then (
														tSpline.Nodes[1] = tInter.Structure
														if tSpline.HasFWLanes then ( /*inter at new closed path start*/
															Append Splines[i].StartInters tSpline
															Append Splines[i].StartInverts false
														)
														if tSpline.HasRWLanes then ( /*inter at new closed path end*/
															Append Splines[i].StartInters tSpline
															Append Splines[i].StartInverts true
														)
													)
												) else (
													if
														LinkToStart and
														tSpline.HasFWLanes
													then ( /*inter at spline start*/
														tSpline.Nodes[1] = tInter.Structure
														Append Splines[i].StartInters tSpline
														Append Splines[i].StartInverts false
													)
													if
														LinkToEnd and
														tSpline.HasRWLanes
													then ( /*inter at spline end*/
														tSpline.Nodes[tSpline.Nodes.Count] = tInter.Structure
														Append Splines[i].StartInters tSpline
														Append Splines[i].StartInverts true
													)
												)
											)
										)
									)
								) else (
									if LinkFromStart then ( /*inter at spline start*/
										Splines[i].Nodes[1] = tInter.Structure
										for tSpline in Splines where tSpline != Splines[i] do ( /*find linked splines*/
											LinkToStart = (Distance tInter.Pos tSpline.Points[1]) < tInter.Radius
											LinkToEnd = (Distance tInter.Pos tSpline.Points[tSpline.Points.Count]) < tInter.Radius
											if
												LinkToStart or
												LinkToEnd
											then (
												if tSpline.Closed then (
													if LinkToStart then (
														tSpline.Nodes[1] = tInter.Structure
														if tSpline.HasFWLanes then ( /*inter at new closed path start*/
															Append Splines[i].StartInters tSpline
															Append Splines[i].StartInverts false
														)
														if tSpline.HasRWLanes then ( /*inter at new closed path end*/
															Append Splines[i].StartInters tSpline
															Append Splines[i].StartInverts true
														)
													)
												) else (
													if
														LinkToStart and
														tSpline.HasFWLanes
													then ( /*inter at spline start*/
														tSpline.Nodes[1] = tInter.Structure
														Append Splines[i].StartInters tSpline
														Append Splines[i].StartInverts false
													)
													if
														LinkToEnd and
														tSpline.HasRWLanes
													then ( /*inter at spline end*/
														tSpline.Nodes[tSpline.Nodes.Count] = tInter.Structure
														Append Splines[i].StartInters tSpline
														Append Splines[i].StartInverts true
													)
												)
											)
										)
									)
									if LinkFromEnd then ( /*inter at spline end*/
										Splines[i].Nodes[Splines[i].Nodes.Count] = tInter.Structure
										for tSpline in Splines where tSpline != Splines[i] do ( /*find linked splines*/
											LinkToStart = (Distance tInter.Pos tSpline.Points[1]) < tInter.Radius
											LinkToEnd = (Distance tInter.Pos tSpline.Points[tSpline.Points.Count]) < tInter.Radius
											if
												LinkToStart or
												LinkToEnd
											then (
												if tSpline.Closed then (
													if LinkToStart then (
														tSpline.Nodes[1] = tInter.Structure
														if tSpline.HasFWLanes then ( /*inter at new closed path start*/
															Append Splines[i].EndInters tSpline
															Append Splines[i].EndInverts false
														)
														if tSpline.HasRWLanes then ( /*inter at new closed path end*/
															Append Splines[i].EndInters tSpline
															Append Splines[i].EndInverts true
														)
													)
												) else (
													if
														LinkToStart and
														tSpline.HasFWLanes
													then ( /*inter at spline start*/
														tSpline.Nodes[1] = tInter.Structure
														Append Splines[i].EndInters tSpline
														Append Splines[i].EndInverts false
													)
													if
														LinkToEnd and
														tSpline.HasRWLanes
													then ( /*inter at spline end*/
														tSpline.Nodes[tSpline.Nodes.Count] = tInter.Structure
														Append Splines[i].EndInters tSpline
														Append Splines[i].EndInverts true
													)
												)
											)
										)
									)
								)
							)
						)
					)
					ProgressEnd()
					ProgressStart "Loading NOD emulator [3/3]"
					for i = 1 to Splines.Count do (
						ProgressUpdate (i * 100.0 / Splines.Count)
						InitLanes Splines[i]
					)
					WorkerTL = (dotnetobject "System.ComponentModel.BackGroundWorker")
					Worker = (dotnetobject "System.ComponentModel.BackGroundWorker")
					WorkerTL.WorkerSupportsCancellation = true
					Worker.WorkerSupportsCancellation = true
					dotNet.addEventHandler WorkerTL "DoWork" EmulateTrafficLights
					dotNet.addEventHandler Worker "DoWork" Emulate
					Working = true
					WorkerTL.RunWorkerAsync()
					Worker.RunWorkerAsync()
					ProgressEnd()
					Reault = true
				) else
					MessageBox "Can't find NOD paths!" Title:"NOD paths emulator"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			Result
		),
		fn RenderInViewport = (
			local	TempLimits = (gw.getRndLimits()), LODlevel,
					CarMesh = GIMS.IV.Core.DB.CarMesh,
					BoatMesh = GIMS.IV.Core.DB.BoatMesh
			gw.setRndLimits RenderMode
			if RenderLanes then (
				gw.setTransform (Matrix3 1)
				gw.setColor #Line LaneColor
				for tSpl in Splines do (
					for tLane in tSpl.FWLanes do
						gw.Polyline tLane.Points false
					for tLane in tSpl.RWLanes do
						gw.Polyline tLane.Points false
				)
			)
			for TempCar in Cars where TempCar.Visible do (
				gw.setTransform TempCar.Trans
				gw.startTriangles()
				LODlevel = TempCar.LODLevel
				if TempCar.OwnSpline.IsBoatPath then (
					if RenderBoats then (
						for i = 1 to BoatMesh[LODLevel][2].Count do
							gw.triangle #(
								BoatMesh[LODLevel][1][BoatMesh[LODLevel][2][i].x], 
								BoatMesh[LODLevel][1][BoatMesh[LODLevel][2][i].y], 
								BoatMesh[LODLevel][1][BoatMesh[LODLevel][2][i].z]
							) #(BoatColor, BoatColor, BoatColor)
					)
				) else (
					if RenderCars then (
						for i = 1 to CarMesh[LODLevel][2].Count do
							gw.triangle #(
								CarMesh[LODLevel][1][CarMesh[LODLevel][2][i].x], 
								CarMesh[LODLevel][1][CarMesh[LODLevel][2][i].y], 
								CarMesh[LODLevel][1][CarMesh[LODLevel][2][i].z]
							) #(CarColor, CarColor, CarColor)
					)
				)
				gw.endTriangles()
			)
			gw.setRndLimits TempLimits
			gw.enlargeUpdateRect #whole
			gw.updateScreen()
		)
	)
	struct strObjectMgr (
		/*Shortcuts*/
			/*MAX*/
			IsFinite = Bit.IsFinite,
			BitAnd = Bit.And,
			DeleteFaces = MeshOp.DeleteFaces,
			BreakVerts = MeshOp.BreakVerts,
			GetIsoVerts = MeshOp.GetIsoVerts,
			WeldVertsByThreshold = MeshOp.WeldVertsByThreshold,
			RemoveIsolatedVerts = MeshOps.RemoveIsolatedVerts,
			RemoveDegenerateFaces = MeshOp.RemoveDegenerateFaces,
			RemoveIllegalFaces = MeshOp.RemoveIllegalFaces,
			GetMapSupport = MeshOp.GetMapSupport,
			DefaultMapFaces = MeshOp.DefaultMapFaces,
			GetMapFace = MeshOp.GetMapFace,
			GetMapVert = MeshOp.GetMapVert,
			GetFacesUsingVert = MeshOp.GetFacesUsingVert,
			MDetachFaces = MeshOp.DetachFaces,
			PDetachFaces = PolyOp.DetachFaces,
			PAttach = PolyOp.Attach,
			PGetFaceMatID = PolyOp.GetFaceMatID,
			PGetFaceVerts = PolyOp.GetFaceVerts,
			PGetFaceEdges = PolyOp.GetFaceEdges,
			PGetFacesUsingEdge = PolyOp.GetFacesUsingEdge,
			PGetFaceNormal = PolyOp.GetFaceNormal,
			PGetFaceCenter = PolyOp.GetFaceCenter,
			PDeleteFaces = PolyOp.DeleteFaces,
			PGetVert = PolyOp.GetVert,
			PGetFaceArea = PolyOp.GetFaceArea,
			PGetFaceDeg = PolyOp.GetFaceDeg,
			PTessellateByFace = PolyOp.TessellateByFace,
			PCreateEdge = PolyOp.CreateEdge,
			PWeldVertsByThreshold = PolyOp.WeldVertsByThreshold,
			PGetMapSupport = PolyOp.GetMapSupport,
			PDefaultMapFaces = PolyOp.DefaultMapFaces,
			GetVertexWeightCount = SkinOps.GetVertexWeightCount,
			GetVertexWeight = SkinOps.GetVertexWeight,
			GetVertexWeightBoneID = SkinOps.GetVertexWeightBoneID,
			AddBone = SkinOps.AddBone,
			SetInnerRadius = SkinOps.SetInnerRadius,
			SetOuterRadius = SkinOps.SetOuterRadius,
			UnNormalizeVertex = SkinOps.UnNormalizeVertex,
			ReplaceVertexWeights = SkinOps.ReplaceVertexWeights,
			GetBoneName = (
				try
					SkinOps.GetBoneNameByListID
				catch
					SkinOps.GetBoneName
			),
			DependencyLoopTest = Refs.DependencyLoopTest,
			/*Classes*/
			SCore, GCore, STypeLibrary, GTypeLibrary,
			/*Data*/
			Rules, ObjectNames,
			/*GUI*/
			UpdateProgress, AddResult,
			/*Array*/
			Split, Modify, RotateA, NormalizeA, QuickSearch, QuickSort, AppendMHL, FetchMHL, RebuildMHL,
			/*Misc*/
			TypeCast, ConvertStruct, CreateIfUnique, CalculateBounds, ExtendBound, RemoveSmoothingGroups, GetStandartized, GetPathString, CreateMesh, StoreModData, RestoreModData, GetChildren, ReadCached, ReplaceChars, Shaders, UnifyMaterials, CalculateVolumeAndCenterOfMass, GetSectorCoords, oFTypeExec, FormatText, DumpMesh, Compare,
			/*Buffers*/
			ClearBuffer, ReadFile, BufSearch, ReadVal, GetPath,
		/*Ops*/
		fn GetAreaID Pos AllowOutOfBounds:true Checkonly:false Mode:#NOD = (	/*<TODO>	NavMesh height limit*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if Checkonly then ( /*<TODO>	NavMesh height limit*/
					local	NODHeightBounds = Rules.NODHeightBounds,
							X = pos.x,
							Y = pos.y,
							Z = pos.z
					(
						X >= -3000.0 and
						X <= 3000.0 and
						Y >= -3000.0 and
						Y <= 3000.0 and
						(
							case Mode of (
								#NavMesh: (
									true /*<TODO>	NavMesh height limit*/
								)
								#NOD: (
									Z < NODHeightBounds.Y and
									Z > NODHeightBounds.X
								)
								Default:
									true
							)
						)
					)
				) else (
					case Mode of (
						#NOD: (
							if
								AllowOutOfBounds or
								(GetAreaID Pos Checkonly:true Mode:Mode)
							then (
								local	SectorCoords = (GetSectorCoords Pos 750)
								((SectorCoords.y * 8) + (SectorCoords.x + 1))
							)
						)
						#NavMesh: (
							if
								AllowOutOfBounds or
								(GetAreaID Pos Checkonly:true Mode:Mode)
							then (
								local	SectorSize = 100,
										SectorCoords = (GetSectorCoords Pos SectorSize),
										SectorCoordsX = SectorCoords.x,
										SectorCoordsY = SectorCoords.y,
										SubAreaID = (
											if Pos.x < ((SectorCoordsX * SectorSize) - 2950) then (
												if Pos.y < ((SectorCoordsY * SectorSize) - 2950) then
													3
												else
													4
											) else (
												if Pos.y < ((SectorCoordsY * SectorSize) - 2950) then
													2
												else
													1
											)
										)
								[ \
									SubAreaID, \
									((SectorCoordsY * 60) + (SectorCoordsX + 1)), \
									(SectorCoordsX * 2), \
									(SectorCoordsY * 2) \
								]
							)
						)
						default:
							throw "Unknown mode!"
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn PrepareMeshForExport Obj Mode = ( /*<TODO>	keep source mesh unchanged, navmesh*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result = true,
						ModData = (StoreModData Obj),	/*store modifiers*/
						WeldThreshold = 0.0001,
						FGetFace, FGetVert, FDeleteFaces, FGetMapSupport, FDefaultMapFaces,
						IsPoly = (IsKindOf Obj.BaseObject Editable_Poly)
				if IsPoly then (
					FGetFace = PGetFaceVerts
					FGetVert = PGetVert
					FDeleteFaces = PDeleteFaces
					FGetMapSupport = PGetMapSupport
					FDefaultMapFaces = PDefaultMapFaces
				) else (
					FGetFace = GetFace
					FGetVert = GetVert
					FDeleteFaces = DeleteFaces
					FGetMapSupport = GetMapSupport
					FDefaultMapFaces = DefaultMapFaces
				)
				CollapseStack Obj
				/*delete NAN broken faces*/
				local	InvalidPolys = #{}
				for FaceID = 1 to Obj.NumFaces do (
					local	FaceVerts = (FGetFace Obj FaceID),
							Invalid = false
					for i = 1 to (if IsPoly then FaceVerts.Count else 3) while not Invalid do (
						local	TempVert = (FGetVert Obj FaceVerts[i])
						for j = 1 to 3 where not (IsFinite TempVert[j]) while not Invalid do
							Invalid = true
					)
					if Invalid then
						InvalidPolys[FaceID] = true
				)
				if InvalidPolys.count != 0 then
					FDeleteFaces Obj InvalidPolys
				/*mode - specific actions*/
				case Mode of (
					#Model: (
						if ModData[2].Count != 0 then (
							local	ObjMtls = (GetStandartized Obj.Material).MaterialList,
									ShaderSkinnableFlags = Shaders[5]
							for ObjMtl in ObjMtls while Result where not ShaderSkinnableFlags[ObjMtl.ShaderData[1].x][ObjMtl.ShaderData[1].y] do (
								AddResult #Error (
									FormatText \
										v1:"Model mesh \"" \
										v2:(GetPathString Obj) \
										v3:"\" is skinned, but uses unskinnable shaders! Skipping..."
								)
								Result = false
							)
						)
					)
					#Bounds: (
						ConvertToPoly Obj
						local	PlanarCoef = Rules.ColPolyPlanarCoef,
								MaxArea = Rules.ColPolyMaxArea
						/*tesselate big polys*/
						local	HaveInvalid = true
						while HaveInvalid do (
							local	InvalidPolys = #{}
							for PolyID = 1 to Obj.NumFaces where (PGetFaceArea Obj PolyID) > MaxArea do
								InvalidPolys[PolyID] = true
							HaveInvalid = (InvalidPolys.Count != 0)
							if HaveInvalid then
								PTessellateByFace Obj InvalidPolys
						)
						/*triangulate non-planar and 4+ vertex-based polys*/
						local	InvalidPolyVerts = #(),
								InvalidPolyDegrees = #(),
								InvalidPolys = #{},
								NumFaces = Obj.NumFaces
						InvalidPolyVerts.Count = NumFaces
						InvalidPolyDegrees.Count = NumFaces
						for PolyID = 1 to NumFaces do (
							local	FaceDegree = (PGetFaceDeg Obj PolyID),
									FaceVerts = ((PGetFaceVerts Obj PolyID) as array)
							if FaceDegree > 4 then (
								InvalidPolyDegrees[PolyID] = FaceDegree
								InvalidPolyVerts[PolyID] = FaceVerts
								InvalidPolys[PolyID] = true
							) else (
								if FaceDegree == 4 then (
									local	Matrix = (Inverse (Translate (MatrixFromNormal (PGetFaceNormal Obj PolyID)) (PGetFaceCenter Obj PolyID))),
											Searching = true
									for Vert in FaceVerts while Searching where (Abs ((PGetVert Obj Vert) * Matrix).z > PlanarCoef) do (
										InvalidPolyDegrees[PolyID] = FaceDegree
										InvalidPolyVerts[PolyID] = FaceVerts
										InvalidPolys[PolyID] = true
										Searching = false
									)
								)
							)
						)
						if InvalidPolys.Count != 0 then (
							for PolyID in InvalidPolys do (
								local	PolyVerts = InvalidPolyVerts[PolyID],
										PolyDegree = InvalidPolyDegrees[PolyID],
										IsDegreeEven = ((Mod PolyDegree 2) == 0),
										EndID = (
											if IsDegreeEven then
												PolyDegree - 2
											else
												PolyDegree - 1
										)
								for i = 1 to EndID by 2 do
									PCreateEdge Obj PolyVerts[i] PolyVerts[i + 2]
								if
									IsDegreeEven and
									PolyDegree > 4
								then
									PCreateEdge Obj PolyVerts[EndID + 1] PolyVerts[1]
							)
						)
					)
					#NavMesh: ( /*<TODO>*/
					)
					default:
						throw "Unknown Mode!"
				)
				/*remove the mesh garbage*/
				if IsPoly then
					ConvertToMesh Obj
				RemoveDegenerateFaces Obj
				RemoveIllegalFaces Obj
				RemoveIsolatedVerts Obj
				/*finish mesh ops*/
				if Mode != #Model then (
					ConvertToPoly Obj
					Obj.WeldThreshold = WeldThreshold
					PWeldVertsByThreshold Obj #All
					RemoveSmoothingGroups Obj
				)
				/*restore modifiers*/
				RestoreModData Obj ModData
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetCNodeProgressEntryCount CNode = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result = 0,
						Children = CNode.Children
				for CNodeChild in Children do (
					local	ChildClass = (ClassOf CNodeChild.ParamSource)
					Result += (
						case ChildClass of (
							EGIMS_IV_ModelMesh:
								4
							EGIMS_IV_Model_Bone:
								1 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_IV_Model:
								3 + (GetCNodeProgressEntryCount CNodeChild)
							EGIMS_IV_CollisionMesh:
								4
							EGIMS_IV_ColComposite:
								(GetCNodeProgressEntryCount CNodeChild)
							Default:
								1
						)
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromScene \
			CNode \
			DiskPath:undefined \
			Ancestor:undefined \
			AncestorNode:undefined \
			Parent:undefined \
			ParentParamSource:undefined \
			ParentResult:undefined \
			AdditionalParam:undefined \
			AllowProgress:true \
			ProgressData:undefined = \
		( /*<TODO>	col shrunk research and export,	other types*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Obj = CNode.Obj,
						ParamSource = CNode.ParamSource,
						Children = CNode.Children,
						Result,
						ObjClass = (ClassOf ParamSource),
						SetOwnProgress = (No ProgressData)
				case ObjClass of (
					EGIMS_IV_CollisionDict: (
						local	Items = #(),
								ObjName = (ReplaceChars Obj.Name)
						if SetOwnProgress then (
							ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
							UpdateProgress #Progress ProgressData
						)
						AppendMHL ObjectNames ObjName
						for Child in Children do (
							local	Item = (StructFromScene Child Parent:Obj ParentParamSource:ParamSource ProgressData:ProgressData AllowProgress:AllowProgress)
							if Have Item then
								Append Items Item
						)
						if Items.Count == 0 then (
							AddResult #Error (
								FormatText \
									v1:"Collision dictionary \"" \
									v2:(GetPathString Obj) \
									v3:"\" is empty. Skipping..."
							)
						) else (
							Result = (
								GTypeLibrary.grcPhBoundDictionary \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Items:Items \
							)
						)
					)
					EGIMS_IV_ColComposite: (
						local	ObjName = (ReplaceChars Obj.Name),
								TempChild, TempTrans,
								InvTrans = (Inverse Obj.Transform),
								ObjBounds = (CalculateBounds CNode CoordsysTM:(Inverse Parent.Transform) CheckChildrenOnly:true),
								Items = #(),
								ChildTransforms = #(),
								CMBox = (STypeLibrary.AABB())
						if SetOwnProgress then (
							ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
							UpdateProgress #Progress ProgressData
						)
						AppendMHL ObjectNames ObjName
						for Child in Children do (
							local	Item = (StructFromScene Child Parent:Child.Obj ParentParamSource:ParamSource ProgressData:ProgressData AllowProgress:AllowProgress)
							if Have Item then (
								ExtendBound CMBox Item.Bounds.CenterOfMass
								Append Items Item
								local	ItemParamSource = Child.ParamSource
								if
									(IsKindOf ItemParamSource EGIMS_IV_CollisionMesh) and
									ItemParamSource.Type == 1
								then
									TempTrans = (Matrix3 1)
								else (
									TempTrans = Child.Obj.Transform
									Scale TempTrans InvTrans.Scale
									Rotate TempTrans InvTrans.Rotation
									Translate TempTrans InvTrans.Translation
									if (IsKindOf ItemParamSource EGIMS_IV_Car_Wheel) then (
										local	NTPos = TempTrans.Position
										TempTrans.Rotation = (Quat 0 0 0 1)
										TempTrans.Position = NTPos
									)
								)
								Append ChildTransforms TempTrans
							)
						)
						if Items.Count == 0 then (
							AddResult #Error (
								FormatText \
									v1:"Composite collision \"" \
									v2:(GetPathString Obj) \
									v3:"\" is empty. Skipping..."
							)
						) else (
							Result = (
								GTypeLibrary.grcPhBound \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Type:"BoundComposite" \
								Children:Items \
								ChildTransforms:ChildTransforms \
							)
							local	Bounds = Result.Bounds
							Bounds.AABB = ObjBounds[1]
							Bounds.Centroid = ObjBounds[2]
							Bounds.Radius = ObjBounds[3]
							Bounds.WorldRadius = ObjBounds[4]
							local	CMBoxMin = CMBox.bMin
							Bounds.CenterOfMass = (CMBoxMin + ((CMBox.bMax - CMBoxMin) / 2))
							Bounds.PushFlags = true
							Result.Margin = [0.04, 0.04, 0.04]
						)
					)
					EGIMS_IV_Car_Wheel: (
						if AllowProgress then (
							if SetOwnProgress then
								UpdateProgress #Progress [1, 0, 1]
							else (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							)
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						Obj.Material = (GetStandartized Obj.Material)
						Result = (
							GTypeLibrary.grcPhBound \
							DiskPath:DiskPath \
							ObjName:ObjName \
							Type:"BoundCurvedGeometry" \
						)
						local	Bounds = Result.Bounds,
								Width = ParamSource.Width,
								InfRadius = ParamSource.InfRadius,
								DefRadius = ParamSource.DefRadius,
								HalfWidth = (Width / 2),
								AABBMax = [HalfWidth, HalfWidth, InfRadius],
								AABBMin = (-1 * AABBMax),
								QWidth = (Width / 65534),
								VertexScale = [QWidth, QWidth, InfRadius / 32767],
								VertZ = ((DefRadius / VertexScale.z) as Integer),
								Dir = Obj.Dir,
								grcCurvedEdge = GTypeLibrary.grcCurvedEdge
						Result.Vertices = #(
							[0, 0, -VertZ],
							[0, 0, VertZ]
						)
						Result.CurvedEdges = #(
							(grcCurvedEdge unk_V:[-0.001, 0.0, 0.0] Dir:Dir DeflatedRadius:DefRadius Vertices:[0, 1]),
							(grcCurvedEdge unk_V:[0.001, 0.0, 0.0] Dir:Dir DeflatedRadius:DefRadius Vertices:[1, 0])
						)
						Bounds.Radius = (Length AABBMax)
						Bounds.AABB.bMin = AABBMin
						Bounds.AABB.bMax = AABBMax
						Result.Margin = ([1, 1, 1] * AABBMax.x)
						Bounds.WorldRadius = 0
						Bounds.CenterOfMass = (CalculateVolumeAndCenterOfMass Obj CMOnly:true)
						Bounds.PushFlags = true
						Result.VertexOffset = [0, 0, 0]
						Result.VertexScale = VertexScale
						local	Materials = (Obj.Material.MaterialList as array)
						Materials.Count = 2
						Result.Materials = Materials
					)
					GIMS_IV_Col_Box: (
						if AllowProgress then (
							if SetOwnProgress then
								UpdateProgress #Progress [1, 0, 1]
							else (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							)
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						Obj.Material = (GetStandartized Obj.Material)
						Result = (
							GTypeLibrary.grcPhBound \
							DiskPath:DiskPath \
							ObjName:ObjName \
							Type:"BoundBox" \
						)
						local	ObjBounds = (CalculateBounds Obj CoordsysTM:(Inverse Parent.Transform)),
								Bounds = Result.Bounds
						Bounds.AABB = ObjBounds[1]
						Bounds.Radius = ObjBounds[3]
						Bounds.WorldRadius = ObjBounds[4]
						Bounds.CenterOfMass = (CalculateVolumeAndCenterOfMass Obj CMOnly:true)
						Bounds.PushFlags = true
						Result.Margin = [0.05, 0.05, 0.05]
						local	BoxSize = [ParamSource.Width, ParamSource.Depth, ParamSource.Height]
						Result.Extents = BoxSize
						Result.VertexScale = (BoxSize / 65534)
						Result.VertexOffset = [0, 0, 0]
						local	Materials = (Obj.Material.MaterialList as array)
						Materials.Count = 1
						Result.Materials = Materials
						Result.SimpleMaterial = true
					)
					GIMS_IV_Col_Sphere: (
						if AllowProgress then (
							if SetOwnProgress then
								UpdateProgress #Progress [1, 0, 1]
							else (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							)
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						Obj.Material = (GetStandartized Obj.Material)
						Result = (
							GTypeLibrary.grcPhBound \
							DiskPath:DiskPath \
							ObjName:ObjName \
							Type:"BoundSphere" \
						)
						local	Bounds = Result.Bounds,
								Radius = ParamSource.Radius
						Bounds.AABB = (CalculateBounds Obj CoordsysTM:(Inverse Parent.Transform))[1]
						Bounds.Radius = Radius
						Bounds.WorldRadius = Radius
						Bounds.CenterOfMass = (CalculateVolumeAndCenterOfMass Obj CMOnly:true)
						Bounds.PushFlags = true
						local	Materials = (Obj.Material.MaterialList as array)
						Materials.Count = 1
						Result.Materials = Materials
						Result.SimpleMaterial = true
					)
					GIMS_IV_Col_Capsule: (
						if AllowProgress then (
							if SetOwnProgress then
								UpdateProgress #Progress [1, 0, 1]
							else (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							)
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						Obj.Material = (GetStandartized Obj.Material)
						Result = (
							GTypeLibrary.grcPhBound \
							DiskPath:DiskPath \
							ObjName:ObjName \
							Type:"BoundCapsule" \
						)
						local	Bounds = Result.Bounds,
								Radius = ParamSource.Radius,
								Height = ParamSource.Height,
								CapsuleData = [Radius, Height],
								Radius = (Height / 2 + Radius)
						Bounds.AABB = (CalculateBounds Obj CoordsysTM:(Inverse Parent.Transform))[1]
						Bounds.Radius = Radius
						Bounds.WorldRadius = Radius
						Bounds.CenterOfMass = (CalculateVolumeAndCenterOfMass Obj CMOnly:true)
						Bounds.PushFlags = true
						Result.CapsuleData = CapsuleData
						local	Materials = (Obj.Material.MaterialList as array)
						Materials.Count = 1
						Result.Materials = Materials
						Result.SimpleMaterial = true
					)
					EGIMS_IV_CollisionMesh: ( /*<TODO> shrunk research and export*/
						if AllowProgress then (
							if SetOwnProgress then (
								ProgressData = [0, 0, 4]
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						if
							Obj.NumVerts == 0 or
							Obj.NumFaces == 0
						then (
							if AllowProgress then (
								ProgressData.x += 4
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							AddResult #Warning (
								FormatText \
									v1:"The collision mesh \"" \
									v2:(GetPathString Obj) \
									v3:"\" hasn't got any useful information. Skipping..."
							)
						) else (
							local	VertCountLimit = Rules.ColVertBufferSize,
									VertCountErr = (
										FormatText \
											v1:"Maximum vertex count of " \
											v2:VertCountLimit \
											v3:" exceeded in the collision object \"" \
											v4:(GetPathString Obj) \
											v5:"\". Please, subdivide it."
									)
							if Obj.NumVerts > VertCountLimit then (
								if AllowProgress then (
									ProgressData.x += 4
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
								AddResult #Error VertCountErr
							) else (
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None Undefined
								if
									(PrepareMeshForExport Obj #Bounds)
								then (
									if Obj.NumVerts > VertCountLimit then (
										if AllowProgress then (
											ProgressData.x += 3
											UpdateProgress #Progress ProgressData
										) else
											UpdateProgress #None undefined
										AddResult #Error VertCountErr
									) else (
										if Obj.Material.Count > Rules.ColMaterialBufferSize then (
											if AllowProgress then (
												ProgressData.x += 3
												UpdateProgress #Progress ProgressData
											) else
												UpdateProgress #None undefined
											AddResult #Error (
												FormatText \
													v1:"Maximum material count of " \
													v2:Rules.ColMaterialBufferSize \
													v3:" exceeded in the collision object \"" \
													v4:(GetPathString Obj) \
													v5:"\". Please, fix it."
											)
										) else (
											if AllowProgress then (
												ProgressData.x += 1
												UpdateProgress #Progress ProgressData
											) else
												UpdateProgress #None Undefined
											
											local	Vertices = #(),
													Faces = #(),
													FaceGroups = #(),
													Siblings = #(),
													MatIDs = #()
													Materials = #()
											if (
												DumpMesh \
													Obj \
													Vertices \
													Faces \
													Siblings:Siblings \
													FaceMatIDs:MatIDs \
													Materials:Materials \
													MatPropMapping:#(#CollisionData)
											) then (
												local	IsBVH = (ParamSource.Type == 1)
												Result = (
													GTypeLibrary.grcPhBound \
													DiskPath:DiskPath \
													ObjName:ObjName \
													Type:(
														if IsBVH then
															"BoundBVH"
														else
															"BoundGeometry"
													) \
													PolyVerts:Faces \
													PolySiblings:Siblings \
													PolyMatIDs:MatIDs \
													Materials:Materials
												)
												local	InvParentTM = (
															if Have Parent then
																Inverse Parent.Transform
															else
																(Matrix3 1)
														),
														ObjBounds = (CalculateBounds CNode CoordsysTM:InvParentTM),
														AABB = ObjBounds[1],
														Centroid = ObjBounds[2],
														Bounds = Result.Bounds,
														VertexOffset = (Centroid * InvParentTM),
														VertCount = Obj.Verts.Count,
														VertexScale = ((AABB.bMax - AABB.bMin) / 65534)
												Bounds.AABB = AABB
												Bounds.Centroid = Centroid
												Bounds.Radius = ObjBounds[3]
												Bounds.WorldRadius = ObjBounds[4]
												Result.Margin = [0.05, 0.05, 0.05]
												Result.VertexScale = VertexScale
												Result.VertexOffset = VertexOffset
												Result.Vertices = (Modify Vertices #((-VertexOffset), VertexScale) #(#Add, #Divide) CopyArray:false)
												if AllowProgress then (
													ProgressData.x += 1
													UpdateProgress #Progress ProgressData
												) else
													UpdateProgress #None Undefined
												Bounds.CenterOfMass = (CalculateVolumeAndCenterOfMass Obj CoordsysTM:InvParentTM CMOnly:true)
												if not IsBVH then
													Result.Shrunk = (Modify Vertices 0.96 #Multiply CopyArray:true)
												Bounds.PushFlags = true
												if AllowProgress then (
													ProgressData.x += 1
													UpdateProgress #Progress ProgressData
												) else
													UpdateProgress #None Undefined
											) else (
												if AllowProgress then (
													ProgressData.x += 2
													UpdateProgress #Progress ProgressData
												) else
													UpdateProgress #None Undefined
											)
										)
									)
								) else (
									if AllowProgress then (
										ProgressData.x += 3
										UpdateProgress #Progress ProgressData
									)
								)
							)
						)
					)
					EGIMS_IV_ModelDict: (
						if SetOwnProgress then (
							ProgressData = [0, 0, (GetCNodeProgressEntryCount CNode)]
							UpdateProgress #Progress ProgressData
						)
						local	Items = #(),
								ObjName = (ReplaceChars Obj.Name),
								Item
						AppendMHL ObjectNames ObjName
						for Child in Children do (
							Item = (StructFromScene Child Parent:Obj ParentParamSource:ParamSource ProgressData:ProgressData AllowProgress:AllowProgress)
							if Have Item then
								Append Items Item
						)
						if Items.Count == 0 then (
							AddResult #Error (
								FormatText \
									v1:"Model dictionary \"" \
									v2:(GetPathString Obj) \
									v3:"\" is empty. Skipping..."
							)
						) else (
							Result = (
								GTypeLibrary.grcDrawableDictionary \
								DiskPath:DiskPath \
								ObjName:ObjName \
								Items:Items
							)
						)
					)
					EGIMS_IV_Model: (
						if AllowProgress then (
							if SetOwnProgress then (
								ProgressData = [0, 0, 3 + (GetCNodeProgressEntryCount CNode)]
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
						) else
							UpdateProgress #None undefined
						local	ObjName = (ReplaceChars Obj.Name)
						AdditionalParam = 0
						AppendMHL ObjectNames ObjName
						Result = (
							GTypeLibrary.grcDrawable \
							DiskPath:DiskPath \
							ObjName:ObjName \
						)
						if AllowProgress then (
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						) else
							UpdateProgress #None Undefined
						for Child in Children do (
							local	ChildResult = (
								StructFromScene \
								Child \
								Ancestor:Result \
								AncestorNode:Obj \
								Parent:Obj \
								ParentParamSource:ParamSource \
								AdditionalParam:AdditionalParam \
								ProgressData:ProgressData \
								AllowProgress:AllowProgress \
							)
							if (IsKindOf ChildResult Integer) then
								AdditionalParam = ChildResult
						)
						local	TheSkeleton = Result.TheSkeleton,
								HaveSkeleton = (Have TheSkeleton),
								LodGroup = Result.LodGroup
						if AllowProgress then (
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						) else
							UpdateProgress #None Undefined
						if HaveSkeleton then (
							TheSkeleton.Flags = ParamSource.Flags
							local	SkeletonMaxBoneCount = Rules.SkeletonMaxBoneCount,
									TheBonesCount = TheSkeleton.TheBones.Count
							if TheBonesCount > SkeletonMaxBoneCount then (
								AddResult #Error (
									FormatText \
										v1:"Model \"" \
										v2:(GetPathString Obj) \
										v3:"\" has got " \
										v4:TheBonesCount \
										v5:" bones, when the maximum's " \
										v6:SkeletonMaxBoneCount \
										v7:" ! Skipping..."
								)
								Result = undefined
							)
						)
						local	HaveDrawables = false
						if
							Have LodGroup
						then (
							for LODGroup in LODGroups = LodGroup.LODGroups while
								HaveSkeleton or
								not HaveDrawables
							do (
								for LODMesh in LODGroup while
									HaveSkeleton or
									not HaveDrawables
								do (
									if not HaveDrawables then
										HaveDrawables = true
									local	MeshBoneID = LODMesh.BoneID
									LODMesh.BoneID = (
										if No MeshBoneID then
											1
										else
											MeshBoneID.Index
									)
									/*
									if
										HaveSkeleton and
										LODMesh.Skinned
									then (
										for Mtl in LODMesh.Mtls do (
											for Prim in Mtl.Prims do (
												for SkinBones in Prim.SkinBones do (
													local	SkinBoneCount = SkinBones.Count
													for BoneID = 1 to SkinBoneCount do (
														local	tBone = SkinBones[BoneID]
														SkinBones[BoneID] = (
															if No tBone then
																1
															else
																tBone.Index
														)
													)
												)
											)
										)
									)
									*/
								)
							)
						)
						if not HaveDrawables then (
							AddResult #Error (
								FormatText \
									v1:"Model \"" \
									v2:(GetPathString Obj) \
									v3:"\" hasn't got any meshes! Skipping..."
							)
							Result = undefined
						)
						if AllowProgress then (
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						) else
							UpdateProgress #None Undefined
					)
					EGIMS_IV_Model_Bone: (
						if No Ancestor.TheSkeleton then
							Ancestor.TheSkeleton = (GTypeLibrary.grcSkeleton())
						AdditionalParam += 1
						ParamSource.Index = AdditionalParam
						local	ObjName = (ReplaceChars Obj.Name),
								tBone = (ConvertStruct undefined GTypeLibrary.grcBone ParamSource:ParamSource)
						AppendMHL ObjectNames ObjName
						tBone.ObjName = ObjName
						local	ParentPresent = (Have Parent),
								InvParentTM = (
									if ParentPresent then
										Inverse Parent.Transform
									else
										(Matrix3 1)
								),
								InvWorldTM = (
									if AdditionalParam == 0 then
										InvParentTM
									else
										Inverse AncestorNode.Transform
								)
						tBone.WorldOffset = (Obj.Pos * InvWorldTM)
						tBone.LocalOffset = (Obj.Pos * InvParentTM)
						local	Rot = ((Inverse (Obj.Rotation as Matrix3)) * InvParentTM).Rotation,
								RotEuler = (Rot as EulerAngles)
						tBone.RotationQuaternion = (Inverse Rot)
						tBone.RotationEuler = RotEuler
						tBone.Orient = RotEuler
						tBone.Sorient = [0, 0, 0]
						tBone.TheScale = (
							Obj.Scale - (
								if ParentPresent then
									Parent.Scale
								else
									[1, 1, 1]
							)
						)
						if AllowProgress then (
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						) else
							UpdateProgress #None undefined
						for Child in Children do (
							local	ChildResult = (
								StructFromScene \
								Child \
								Ancestor:Ancestor \
								AncestorNode:AncestorNode \
								Parent:Obj \
								ParentParamSource:ParamSource \
								ParentResult:tBone \
								AdditionalParam:AdditionalParam \
								ProgressData:ProgressData \
								AllowProgress:AllowProgress \
							)
							if (IsKindOf ChildResult Integer) then
								AdditionalParam = ChildResult
						)
						local	ParentBones = (
							if (IsKindOf ParentParamSource EGIMS_IV_Model) then
								Ancestor.TheSkeleton.TheBones
							else
								ParentResult.Children
						)
						Append ParentBones tBone
						Result = AdditionalParam
					)
					EGIMS_IV_Model_Light: (
						if AllowProgress then (
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						) else
							UpdateProgress #None undefined
						if No Ancestor.LightAttributes then
							Ancestor.LightAttributes = (GTypeLibrary.grcLightAttributes())
						local	LightAttributes = Ancestor.LightAttributes,
								InvParentTM = (
									if Have Parent then
											Inverse Parent.Transform
									else
											(Matrix3 1)
								),
								LightAttr = (ConvertStruct undefined GTypeLibrary.grcLight ParamSource:ParamSource)
						LightAttr.ObjName = (ReplaceChars Obj.Name)
						LightAttr.BoneID = (
							if (IsKindOf ParentParamSource EGIMS_IV_Model_Bone) then
								ParentParamSource.ID
							else
								0
						)
						LightAttr.Position = (Obj.Pos * InvParentTM)
						LightAttr.Direction = ([0, 0, 1] * (Inverse (Obj.Rotation as Matrix3)))
						LightAttr.CoronaHash = (GIMS.Core.StringOps.GetJenkinsHash (ReplaceChars Obj.Name))
						LightAttr.LuminescenceHash = (GIMS.Core.StringOps.GetJenkinsHash ParamSource.pLuminescenceHash)
						local	pDrawDistDiv4 = ParamSource.pDrawDistDiv4
						LightAttr.DrawDistDiv4 = (if pDrawDistDiv4 == -1 then -1 else (pDrawDistDiv4 / 4))
						Append LightAttributes.Items LightAttr
					)
					EGIMS_IV_ModelMesh: (
						if No Ancestor.LodGroup then
							Ancestor.LodGroup = (GTypeLibrary.grcLodGroup())
						if No Ancestor.ShadingGroup then
							Ancestor.ShadingGroup = (GTypeLibrary.grcShadingGroup())
						local	LodGroup = Ancestor.LodGroup,
								AncestorShaders = Ancestor.ShadingGroup.Shaders,
								ObjName = (ReplaceChars Obj.Name)
						AppendMHL ObjectNames ObjName
						if (PrepareMeshForExport Obj #Model) then (
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	LODMesh = (
										GTypeLibrary.grcLODMesh \
											BoneID:(
												if (IsKindOf ParentParamSource EGIMS_IV_Model_Bone) then
													ParentResult
											) \
											ObjName:ObjName \
									),
									SkinMod = (
										try
											Obj.Skin
										catch ()
									),
									Skinned = (Have SkinMod)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
							local	RAWSkinData, RAWUVCount
							if Skinned then (
								RAWSkinData = #()
								RAWUVCount = 2
							) else
								RAWUVCount = 6
							local	RAWVerts = #(),
									RAWFaces = #(),
									RAWFaceGroups = #(undefined, undefined, #SG),
									RAWNormals = #(),
									RAWUVData = #(),
									RAWTangents = #(),
									RAWColors = #(),
									MatPropMapping = #(
										#ShaderData,
										#MapsLocationData,
										#ColorData,
										#ColorData2,
										#PowerData,
										#ClipData,
										#DiffuseMap_1,
										#DiffuseMap_2,
										#NormalMap,
										#SpecMap,
										#RefMap,
										#DirtMap,
										#BlendLayerMap_1,
										#BlendLayerMap_2,
										#BlendLayerMap_3,
										#BlendLayerMap_4,
										#BlendLayerMap_4
									)
							if (
								DumpMesh \
									Obj \
									RAWVerts \
									RAWFaces \
									Normals:RAWNormals \
									Tangents:RAWTangents \
									Colors:RAWColors \
									UVCount:RAWUVCount \
									UVData:RAWUVData \
									SkinData:RAWSkinData \
									FaceGroups:RAWFaceGroups \
									Materials:AncestorShaders \
									MatPropMapping:MatPropMapping \
							) then (
								local	GroupMtlIDs = RAWFaceGroups[1],
										FaceGroups = RAWFaceGroups[2],
										GroupCount = FaceGroups.Count,
										SplitCount = (Rules.ModelVertBufferSize / 3)
								for GroupID = 1 to GroupCount do (
									local	SplittedFaceGroups = (Split FaceGroups[GroupID] SplitCount),
											SplittedGroupCount = SplittedFaceGroups.Count
									if SplittedGroupCount != 1 then (
										FaceGroups[GroupID] = SplittedFaceGroups[1]
										for SplittedGroupID = SplittedGroupCount to 2 by -1 do (
											local	NewGroupID = (GroupCount + SplittedGroupID - 1)
											GroupMtlIDs[NewGroupID] = GroupMtlIDs[GroupID]
											FaceGroups[NewGroupID] = SplittedFaceGroups[SplittedGroupID]
										)
										GroupCount += (SplittedGroupCount - 1)
									)
								)
								local	Idx = #(),
										VertsMHL = #(),
										grcMeshVertex = GTypeLibrary.grcMeshVertex,
										RAWMapFaceGroups = RAWUVData[1],
										RAWMapVertGroups = RAWUVData[2],
										Map1Faces = RAWMapFaceGroups[1],
										RAWSkinBones, RAWSkinWeights
								for i = GroupCount to 1 by -1 do (
									Idx[i] = #()
									VertsMHL[i] = #(#(), #())
								)
								if Skinned then (
									RAWSkinBones = RAWSkinData[1]
									RAWSkinWeights = RAWSkinData[2]
								)
								for GroupID = 1 to GroupCount do (
									local	Faces = FaceGroups[GroupID],
											IdxGroup = Idx[GroupID],
											VertsMHLGroup = VertsMHL[GroupID],
											Mtl = AncestorShaders[GroupMtlIDs[GroupID]],
											ShaderName = (Mtl.GetShaderName()),
											BlendStartMapID = (
												if not Skinned then (
													case ShaderName of (
														#gta_terrain_va_2lyr:
															3
														#gta_terrain_va_3lyr:
															4
														#gta_terrain_va_4lyr:
															5
														Default:
															7
													)
												) else
													7
											)
									UpdateProgress #None undefined
									for FaceID in Faces do (
										local	Face = RAWFaces[FaceID],
												ColorFaces = RAWColors[1][FaceID],
												ColorVerts = RAWColors[2],
												Map1VertIDs = RAWMapFaceGroups[1],
												Map1Face = Map1Faces[FaceID]
										local	FaceIndices = #()
										FaceIndices.Count = 3
										for SubVertID = 1 to 3 do (
											local	PhysVertID = Face[SubVertID],
													Pos = RAWVerts[PhysVertID],
													Normal = RAWNormals[PhysVertID],
													VertColor = ColorVerts[ColorFaces[SubVertID]],
													SkinWeights = #(),
													SkinBones
											if Skinned then (
												SkinBones = RAWSkinBones[PhysVertID]
												SkinWeights = RAWSkinWeights[PhysVertID]
											)
											local	UVCoords = #()
											for ChID = RAWUVCount to 1 by -1 do (
												local	MapVertID = RAWMapFaceGroups[ChID][FaceID][SubVertID],
														UV = (TypeCast RAWMapVertGroups[ChID][MapVertID] Point3)
												if ChID < BlendStartMapID then
													UV.y *= -1
												UVCoords[ChID] = UV
											)
											local	VertTangents = RAWTangents[PhysVertID],
													MapTangentID = (FindItem VertTangents[1] Map1Face[SubVertID]),
													Tangent = VertTangents[2][MapTangentID],
													TempVertex = (
														grcMeshVertex \
															Position:Pos \
															Normal:Normal \
															TheColor:VertColor \
															Tangent:Tangent \
															SkinBones:SkinBones \
															SkinWeights:SkinWeights \
															UVCoords:UVCoords \
													)
											FaceIndices[SubVertID] = (AppendMHL VertsMHLGroup TempVertex GetID:true Sorted:false)
										)
										Append IdxGroup (TypeCast FaceIndices Point3)
									)
								)
								if AllowProgress then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								) else
									UpdateProgress #None undefined
								local	Mtls = LODMesh.Mtls,
										grcLODMeshMtl = GTypeLibrary.grcLODMeshMtl,
										grcLODMeshPrim = GTypeLibrary.grcLODMeshPrim
								LODMesh.Skinned = Skinned
								for GroupID = GroupCount to 1 by -1 do (
									local	Verts = VertsMHL[GroupID][1],
											Positions = #(),
											Normals = #(),
											Colors = #(),
											Tangents = #(),
											SkinBones = #(),
											SkinWeights = #(),
											UVCoords = (
												local	Res = #()
												for i = RAWUVCount to 1 by -1 do
													Res[i] = #()
												Res
											)
									for VertID = Verts.Count to 1 by -1 do (
										local	Vert = Verts[VertID]
										Positions[VertID] = Vert.Position
										Normals[VertID] = Vert.Normal
										Colors[VertID] = Vert.TheColor
										Tangents[VertID] = Vert.Tangent
										SkinBones[VertID] = Vert.SkinBones
										SkinWeights[VertID] = Vert.SkinWeights
										local	VertUVCoords = Vert.UVCoords
										for ChID = 1 to RAWUVCount do
											UVCoords[ChID][VertID] = VertUVCoords[ChID]
									)
									Mtls[GroupID] = (
										grcLODMeshMtl \
											MatID:GroupMtlIDs[GroupID] \
											Prims:#(
												grcLODMeshPrim \
												Idx:Idx[GroupID] \
												Positions:Positions \
												Normals:Normals \
												Colors:Colors \
												Tangents:Tangents \
												SkinBones:SkinBones \
												SkinWeights:SkinWeights \
												UVCoords:UVCoords \
											)
									)
								)
								Append LodGroup.LODGroups[ParamSource.Type] LODMesh
							)
							if AllowProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
						) else (
							if AllowProgress then (
								ProgressData.x += 4
								UpdateProgress #Progress ProgressData
							) else
								UpdateProgress #None undefined
						)
					)
					/*<TODO> OTHER TYPES
					EGIMS_IV_FragType: ( --<TODO>
						Result = (GTypeLibrary.000000000000())
						--get data
					)
					EGIMS_IV_FragType_Bone: ( --<TODO>
						Result = (GTypeLibrary.000000000000())
						--get data
					)
					EGIMS_IV_FragType_Child: ( --<TODO>
						Result = (GTypeLibrary.000000000000())
						--get data
						--set as model mesh of high detail: Ancestor
					)
					EGIMS_IV_NavMesh_Portal: ( --<TODO>
						Result = (GTypeLibrary.000000000000())
						--get data
						--attach to the navmesh: Ancestor
					)
					EGIMS_IV_NavMesh: ( --<TODO>
						Result = (GTypeLibrary.000000000000())
						--get data
						local	SectorTree = Obj.SectorTree,
								SubTrees = (#(SectorTree) + SectorTree.SubTrees),
								Portals = Obj.Portals,
								Divider = Obj.Divider,
								Sizes = Obj.Sizes,
								BoundMin = SectorTree.Bounds.AABB.bMin
						for TempPortal in Portals do
							Modify TempPortal.Points #(-BoundMin, Sizes, Divider) #(#Add, #Divide, #Multiply) CopyArray:false
						Modify Vertices #(-BoundMin, Sizes, Divider) #(#Add, #Divide, #Multiply) CopyArray:false
						for TempSectorTree in SubTrees where Have TempSectorTree.SectorData do
							Modify TempSectorTree.SectorData.Bounds #(-[BoundMin.x, BoundMin.y, BoundMin.z, 0], [Sizes.x, Sizes.y, Sizes.z, 1], Divider) #(#Add, #Divide, #Multiply) CopyArray:false
					)
					GeoSphere: ( --<TODO> attach to the navmesh(find subtree): Ancestor
					)
					*/
					Default:
						throw ("Unknown object type: " + ObjClass as String)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn SceneFromStruct Obj \
			ParentNode:RootNode \
			Ancestor:undefined \
			IsSkinned:false \
			SplitParts:false \
			NodeType:unsupplied \
			ProgressData:undefined \
			AllowCallingSearch:false \
			AdditionalParam:undefined = \
		(
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result
				if (IsKindOf Obj String) then (
					local	ObjInt = (Obj as Integer)
					if Have ObjInt then
						Obj = (FetchMHL ObjectNames ObjInt)
					else
						AppendMHL ObjectNames Obj
					Result = (CreateIfUnique Obj ParentNode:ParentNode NodeType:NodeType AllowSearch:AllowCallingSearch)
				) else (
					local	ObjTag = Obj.Tag
					case ObjTag of (
						#FragmentChildPart: (
							local	GroupNames = #("high", "med", "low", "vlow"),
									PartParent = ParentNode[1],
									MinChildID = ParentNode[2],
									LODGroups = ParentNode[3],
									LODCount = ParentNode[4],
									AllowDrawable = ParentNode[5],
									ObjMaterial = Ancestor[3],
									Children = (GetChildren PartParent #(EGIMS_IV_Model_Bone) WithSelf:true),
									HighLODMesh = PartParent,
									BoundTransformBase = HighLODMesh
							if AllowDrawable then (
								if LODCount != 0 then ( /*create meshes*/
									local	Grp
									for GroupID = 1 to LODCount where (Grp = LODGroups[GroupID]).Count != 0 do (
										local	GrpCount = Grp.Count,
												MeshData
										for ItemID = 1 to GrpCount do (
											local	Item = Grp[ItemID]
											
											
											/*
											MeshData = (SceneFromStruct Item AdditionalParam:AdditionalParam)
											local	Parent = Children[Item.BoneID - MinChildID + LODCount]
											MeshData.Parent = Parent
											MeshData.Pos = Parent.Pos
											*/
											
											MeshData = (SceneFromStruct Item ParentNode:Children[Item.BoneID - MinChildID + LODCount] AdditionalParam:AdditionalParam)
											
											
											MeshData.Material = ObjMaterial
											if GroupID != 1 then
												AddModifier MeshData (EGIMS_IV_ModelMesh Type:GroupID)
											if
												GroupID == 1 and
												ItemID == 1
											then (
												HighLODMesh = MeshData[1]
												BoundTransformBase = HighLODMesh.Parent
											)
										)
										if GroupID == 1 then
											AddModifier MeshData (EGIMS_IV_FragType_Child Mass:Obj.Mass)
									)
								) else ( /*find skin*/
									local	MeshData = (
										CreateIfUnique (
											FormatText \
												v1:PartParent.Name \
												v2:" [" \
												v3:GroupNames[1] \
												v4:"]"
										) ParentNode:PartParent NodeType:Editable_Mesh FindOnly:true
									)
									if Have MeshData then (
										local	ModelMeshMod
										for tMod in MeshData.Modifiers where (IsKindOf tMod EGIMS_IV_ModelMesh) while No ModelMeshMod do
											ModelMeshMod = tMod
										if Have ModelMeshMod then
											DeleteModifier MeshData ModelMeshMod
										AddModifier MeshData (EGIMS_IV_FragType_Child Mass:Obj.Mass)
										HighLODMesh = MeshData
										BoundTransformBase = HighLODMesh.Parent
									)
								)
							)
							local	ObjBound = Obj.Bound
							if Have ObjBound then (
								local	Col = (SceneFromStruct ObjBound ParentNode:HighLODMesh)
								Col.Name += " [COL]"
								Col.Transform = (Obj.BoundTransform * BoundTransformBase.Transform)
								if (ClassOf Col == EGIMS_IV_Car_Wheel) then
									Col.Dir = ObjBound.CurvedEdges[1].Dir
							)
							Result = HighLODMesh
						)
						#FragmentChild: (
							local	Parents = ParentNode[1],
									AllowDrawable = ParentNode[2],
									Parts = #(
										Obj.PristinePart,
										Obj.DamagedPart
									),
									PartCount = Parts.Count,
									MinChildID = 255,
									HavePartFlags = (
										local	Res = #()
										for i = PartCount to 1 by -1 do
											Res[i] = (Have Parts[i])
										Res
									),
									PartLODGroups = #(),
									PartLODCounts = #()
							for PartID = PartCount to 1 by -1 where HavePartFlags[PartID] do (
								local	LODGroups = Parts[PartID].Drawable.LodGroup.LODGroups,
										LODCount = 0
								for Grp in LODGroups where Grp.Count != 0 do (
									LODCount += 1
									local	BoneID
									for Item in Grp where (BoneID = Item.BoneID) < MinChildID do
										MinChildID = BoneID
								)
								PartLODGroups[PartID] = LODGroups
								PartLODCounts[PartID] = LODCount
							)
							for PartID = 1 to PartCount where HavePartFlags[PartID] do (
								Parents[PartID] = (
									SceneFromStruct \
										Parts[PartID] \
										ParentNode:#(
											Parents[PartID],
											MinChildID,
											PartLODGroups[PartID],
											PartLODCounts[PartID],
											AllowDrawable
										) \
										Ancestor:Ancestor \
										AdditionalParam:AdditionalParam
								)
							)
							/*DEBUG f50*
							Point Name:"f50" Transform:Obj.f50 Parent:Parents[1] Size:0.2
							/**/
							ParentNode[1] = Parents
							ParentNode[2] = false
						)
						#FragmentGroup: (
							local	GroupName = (TypeCast Obj.ObjName name),
									tBones = Ancestor[2],
									TargetBone
							for tBone in tBones while No TargetBone where (TypeCast tBone.Name name) == GroupName do
								TargetBone = tBone
							if No TargetBone then
								SCore.SystemMgr.ThrowError ("Skeleton link error in group \"" + Obj.ObjName + "\" - no such bone!") #Abort
							ConvertStruct TargetBone EGIMS_IV_FragType_Group AddMod:true ParamSource:Obj
							local	ChildData = #(#(TargetBone, TargetBone), true)
							for Child in Obj.Children do
								SceneFromStruct Child ParentNode:ChildData Ancestor:Ancestor AdditionalParam:AdditionalParam
							local	ObjGroups = Obj.Groups
							for Grp in ObjGroups do
								SceneFromStruct Grp Ancestor:Ancestor AdditionalParam:AdditionalParam
						)
						#Fragment: (
							ConvertStruct ParentNode EGIMS_IV_FragType AddMod:true ParamSource:Obj
							local	Groups = Obj.Groups
							for Grp in Groups do
								SceneFromStruct Grp ParentNode:ParentNode Ancestor:Ancestor ProgressData:ProgressData AdditionalParam:AdditionalParam
						)
						#FragType: (
							local	Fragment = Obj.Fragment,
									Drawable = Obj.Drawable
							ProgressData = [0, 0, 3]
							if No Drawable then
								SCore.SystemMgr.ThrowError ("Error in file \"" + Obj.ObjName + "\" - no drawable found!") #Abort
							local	ModelData = (SceneFromStruct Drawable IsSkinned:true SplitParts:true)
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							Result = ModelData[4]
							SceneFromStruct Fragment ParentNode:Result Ancestor:ModelData AdditionalParam:ModelData[5]
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							local	LightAttributes = Obj.LightAttributes
							if Have LightAttributes then (
								for Item in LightAttributes.Items do
									SceneFromStruct Item Ancestor:ModelData[2]
							)
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							/*DEBUG f8*
							for Mtx in Obj.f8 do
								Point Name:"f8" Transform:Mtx Size:0.2
							/**/
						)
						#NavPortal: (
							local	Divider = SplitParts[1],
									Sizes = SplitParts[2],
									BoundMin = SplitParts[3],
									DiskPath = Ancestor.DiskPath,
									ObjName = Ancestor.ObjName,
									Extension = Ancestor.Extension,
									CurrentSectorData = (FilterString ObjName "_")
							Result = (SplineShape Name:(ObjName + " portal") WireColor:Blue Rotation:(EulerAngles 0 0 Obj.tAngle))
							AddNewSpline Result
							local	SectorID = (Ancestor.SectorID),
									Points = Obj.Points,
									Sectors = Obj.Sectors,
									SizesPattern = "*Sizes*",
									SectorTreePattern = "*SectorTree*",
									AABBMinPattern = "*AABBMin*"
							for PointID = 1 to Points.Count do (
								local	TargetSectorID = Sectors[PointID],
										KnotPos = (
											if TargetSectorID != SectorID then (
												local	SectorDiff = (TargetSectorID - SectorID),
														dSY = (((SectorDiff as Float) / 60) as Integer),
														dSX = ((SectorDiff - (dSY * 60)) as Integer),
														TargetSectorName = (Append CurrentSectorData[1] "_")
												Append TargetSectorName (((Typecast CurrentSectorData[2] Integer) + (dSX * 2)) as String)
												Append TargetSectorName "_"
												Append TargetSectorName (((Typecast CurrentSectorData[3] Integer) + (dSY * 2)) as String)
												local	TargetSectorFile = (Copy DiskPath)
												Append TargetSectorFile TargetSectorName
												Append TargetSectorFile Extension
												TargetSectorName = (TypeCast TargetSectorName Name)
												local	BufferID
												for BufID in NodeType where ((TypeCast (GetFileNameFile (GetPath BufID)) Name) == TargetSectorName) while No BufferID do
													BufferID = BufID
												if No BufferID then (
													BufferID = (ReadFile TargetSectorFile)
													NodeType[BufferID] = true
												)
												if (BufSearch BufferID SizesPattern CaseOp:#Pattern NoSeek:false FromCurrent:false) == 0 then
													throw "Can't find NavMesh \"Sizes\" tag"
												local	tLine = (ReadVal BufferID FilterStr:"\t "),
														TargetSizes = (oFTypeExec tLine #P3 IDMask:#{2..4})
												if (BufSearch BufferID AABBMinPattern CaseOp:#Pattern NoSeek:false) == 0 then
													throw "Can't find NavMesh \"AABBMin\" tag"
												tLine = (ReadVal BufferID FilterStr:"\t ")
												local	TargetBoundMin = (oFTypeExec tLine #P3 IDMask:#{2..4})
												(((Points[PointID] / Divider) * TargetSizes) + TargetBoundMin)
											) else
												(((Points[PointID] / Divider) * Sizes) + BoundMin)
										)
								AddKnot Result 1 #Corner #Line KnotPos
							)
							UpdateShape Result
							Result.Pivot = Result.Center
							AddModifier Result (EGIMS_IV_NavMesh_Portal WayDown:Obj.WayDown)
						)
						#NavTreeData: (
							local	Materials = ParentNode[1],
									TriIndices = ParentNode[2],
									TriMatIDs = ParentNode[3],
									PolyIndices = ParentNode[4],
									PolyMatIDs = ParentNode[5],
									AttachNode = ParentNode[6],
									VertIndices, EndID,
									NewMtl, MtlID,
									AppendIfUniq = SCore.ArrayOps.AppendIfUniq,
									Polys = Ancestor.Polys
							for PolyID in Obj.PolyIndices do (
								Poly = Polys[PolyID]
								EndID = (Poly.StartIndex + Poly.VertexCount - 1)
								VertIndices = (
									MakeUniqueArray \
										(
											local	Res = #()
											for i = EndID to Poly.StartIndex by -1 do
												Res[i] = Ancestor.Indices[i]
											Res
										)
								)
								if VertIndices.Count > 2 then (
									local	SurfaceFlags = (BitAnd Poly.SurfaceFlags 6),	/*Bits #{2..3}*/
											PedGenFlags = (BitAnd Poly.PedGenFlags 7)	/*Bits #{1..3}*/
									MtlID = (AppendIfUniq Materials [SurfaceFlags, PedGenFlags, 0] GetID:true)
									if VertIndices.Count == 3 then (
										Append TriIndices [VertIndices[1], VertIndices[2], VertIndices[3]]
										Append TriMatIDs MtlID
									) else (
										Append PolyIndices VertIndices
										Append PolyMatIDs MtlID
									)
								) else (
									AddResult #Error (
										FormatText \
											v1:"Poly " \
											v2:PolyID \
											v3:" hasn't got enough vertices! Skipping..."
									)
								)
							)
							Result = ParentNode
						)
						#NavTree: (
							Result = ParentNode
							if Have Obj.SectorData then (
								Result = (SceneFromStruct Obj.SectorData ParentNode:Result Ancestor:Ancestor)
							)
							local	SubTrees = Obj.SubTrees
							for SubTree in SubTrees where Have SubTree do (
								if Have ProgressData then (
									ProgressData.x += 1
									UpdateProgress #Progress ProgressData
								)
								Result = (SceneFromStruct SubTree ParentNode:Result Ancestor:Ancestor)
							)
						)
						#NavMesh: (
							local	SectorTree = Obj.SectorTree,
									SubTrees = SectorTree.SubTrees
							ProgressData = [0, 0, 5 + SubTrees.Count]
							UpdateProgress #Progress ProgressData
							local	SubTrees = (#(SectorTree) + SubTrees),
									Portals = Obj.Portals,
									Divider = Obj.Divider,
									Sizes = Obj.Sizes,
									BoundMin = SectorTree.Bounds.AABB.bMin,
									Vertices = (Modify Obj.Vertices #(Divider, Sizes, BoundMin) #(#Divide, #Multiply, #Add) CopyArray:false)
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							local	MeshData = (SceneFromStruct SectorTree ParentNode:#(#(), #(), #(), #(), #(), ParentNode) Ancestor:Obj ProgressData:ProgressData),
									Materials = MeshData[1],
									TriIndices = MeshData[2],
									TriMatIDs = MeshData[3],
									PolyIndices = MeshData[4],
									PolyMatIDs = MeshData[5]
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							Result = (
								CreateMesh \
									Vertices \
									TriIndices \
									MaterialIDs:TriMatIDs \
									ObjName:(
										if Obj.SectorID == 3600 then
											Obj.ObjName
										else
											"NavMesh"
									) \
									Parent:ParentNode \
									ResultAsPoly:true \
									Polys:PolyIndices \
									PolyMatIDs:PolyMatIDs \
									SG:#Remove \
									ResultAsPoly:true
							)
							Result.Pivot = Result.Center
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							for ID = 1 to Materials.Count do (
								Materials[ID] = ( \
									EGIMS_IV_material \
									Name:Obj.ObjName \
									ShowInViewport:true \
									NavData:Materials[ID] \
								)
							)
							local	MaterialCount = Materials.Count
							Result.Material = (
								MultiMaterial \
								Name:Obj.ObjName \
								MaterialList:Materials \
								MaterialIDList:(TypeCast #{1..MaterialCount} array) \
								Names:( \
									local	Res = #()
									for i = MaterialCount to 1 by -1 do
										Res[i] = Materials[i].Name
									Res
								) \
							)
							AddModifier Result (EGIMS_IV_NavMesh Flags:Obj.Flags)
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
							SplitParts = #(Divider, Sizes, BoundMin)
							local	BufferIDs = #{}
							for Portal in Portals do
								SceneFromStruct Portal Ancestor:Obj SplitParts:SplitParts NodeType:BufferIDs
							for BufferID in BufferIDs do
								ClearBuffer BufferID
							for TempSectorTree in SubTrees do (
								local	SectorData = TempSectorTree.SectorData
								if Have SectorData then (
									for TempBound in SectorData.Bounds do (
										local	Pos = [TempBound.x, TempBound.y, TempBound.z]
										Pos /= Divider
										Pos *= Sizes
										Pos += BoundMin
										EGIMS_IV_NavMesh_Obstacle Parent:Result Pos:Pos Radius:(TempBound.w / Divider) Name:"Obstacle" WireColor:Orange
									)
								)
							)
							ProgressData.x += 1
							UpdateProgress #Progress ProgressData
						)
						#MeshPrim: (
							local	UVCoords = Obj.UVCoords,
									UVChannelCount = UVCoords.Count,
									MapVertMults = #()
							for i = UVChannelCount to 1 by -1 do (
								MapVertMults[i] = (
									if i < AdditionalParam then
										[1, -1]
									else
										1
								)
							)
							Result = #(
								(
									CreateMesh \
										Obj.Positions \
										Obj.Idx \
										MaterialIDs:Ancestor \
										VertNormals:Obj.Normals \
										VertColors:Obj.Colors \
										MapVerts:UVCoords \
										MapVertMults:MapVertMults \
										UVCount:(if IsSkinned then 2 else 6)
								), (
									if IsSkinned then
										#(Obj.SkinBones, Obj.SkinWeights)
								)
							)
						)
						#MeshMtl: (
							Result = #()
							local	SkinData = #(#(), #()),
									MatID = Obj.MatID,
									PrimCount = Obj.Prims.Count
							Result.Count = PrimCount
							for PrimID = 1 to PrimCount do (
								local	MeshData = (
											SceneFromStruct \
												Obj.Prims[PrimID] \
												Ancestor:MatID \
												IsSkinned:IsSkinned \
												AdditionalParam:(
													if IsSkinned then
														7
													else
														AdditionalParam[MatID]
												)
										)
								Result[PrimID] = MeshData[1]
								if Have MeshData[2] then (
									SkinData[1] += MeshData[2][1]
									SkinData[2] += MeshData[2][2]
								)
							)
							for MeshID = 2 to Result.Count do
								Attach Result[1] Result[MeshID]
							Result = #(
								Result[1],
								SkinData
							)
						)
						#LODMesh: (
							Result = #()
							local	SkinBones = #(),
									SkinWeights = #(),
									Mtls = Obj.Mtls,
									MtlCount = Mtls.Count
							Result.Count = MtlCount
							IsSkinned = Obj.Skinned
							for MtlID = 1 to MtlCount do (
								local	MeshData = (
											SceneFromStruct \
												Mtls[MtlID] \
												IsSkinned:IsSkinned \
												AdditionalParam:AdditionalParam
										)
								Result[MtlID] = MeshData[1]
								if Have MeshData[2] then (
									SkinBones += MeshData[2][1]
									SkinWeights += MeshData[2][2]
								)
							)
							for MeshID = 2 to Result.count do
								Attach Result[1] Result[MeshID]
							Result = Result[1]
							Result.Name = Obj.ObjName
							if ParentNode != RootNode then
								Result.Parent = ParentNode
							if SplitParts then (
								if Obj.Skinned then (
									local	ResultMesh = Result,
											Faces = #(#(),#()),
											BoneVerts = #(),
											TempFaces = #()
											FaceVerts
											NewMesh
									Result = #()
									GroupNames = #("high", "med", "low", "vlow")
									for BoneID = Ancestor.Count to 1 by -1 do (
										Append Faces[1] BoneID
										Append Faces[2] #()
										for VertID = 1 to SkinBones.Count do (
											local	Searching = true
											for WeightID = 1 to SkinBones[VertID].Count while Searching where
												SkinBones[VertID][WeightID] == BoneID and
												SkinWeights[VertID][WeightID] > 0.0001
											do (
												Append BoneVerts VertID
												Searching = false
											)
										)
										if BoneVerts.Count != 0 then (
											QuickSort BoneVerts
											TempFaces = (GetFacesUsingVert ResultMesh BoneVerts)
											for FaceID in TempFaces do (
												FaceVerts = (GetFace ResultMesh FaceID)
												if
													(QuickSearch BoneVerts FaceVerts.x) != 0 and
													(QuickSearch BoneVerts FaceVerts.y) != 0 and
													(QuickSearch BoneVerts FaceVerts.z) != 0
												then
													Append Faces[2][Faces[2].Count] FaceID
											)
											Free BoneVerts
										)
									)
									local	DetachedFaceCount = 0
									for GrpID = 1 to Faces[1].Count do (
										local	FaceGrp = Faces[2][GrpID],
												BoneID = Faces[1][GrpID]
										if FaceGrp.Count != 0 then (
											local	MeshName = (
														FormatText \
															v1:Ancestor[BoneID].Name \
															v2:" [" \
															v3:GroupNames[NodeType] \
															v4:"]"
													)
											NewMesh = (Mesh Name:MeshName Mesh:(MDetachFaces ResultMesh FaceGrp AsMesh:true Delete:false) Pivot:Ancestor[BoneID].Pivot Parent:Ancestor[BoneID])
											DetachedFaceCount += FaceGrp.Count
											Append Result NewMesh
										)
									)
									TempFaces = #()
									for GrpID = 1 to Faces[1].Count do (
										local	FaceGrp = Faces[2][GrpID]
										if FaceGrp.Count != 0 then
											TempFaces += FaceGrp
									)
									if DetachedFaceCount != ResultMesh.NumFaces then (
										AddResult #Error (
											FormatText \
												v1:"Can't split skinned mesh " \
												v2:ResultMesh.Name \
												v3:" completely: " \
												v4:(ResultMesh.NumFaces - DetachedFaceCount) \
												v5:" faces remaining\n"
										)
									) else
										Delete ResultMesh
								)
							) else (
								if Obj.Skinned then (
									local	OldSelection = (Selection as array),
											SkinMod = (Skin WeightAllVertices:false)
									ResumeEditing()
									Select Result
									MAX Modify Mode
									AddModifier Result SkinMod
									for BoneID = 1 to Ancestor.Count do (
										AddBone SkinMod Ancestor[BoneID] 0
										SetInnerRadius SkinMod BoneID 1 0
										SetOuterRadius SkinMod BoneID 1 0
										SetInnerRadius SkinMod BoneID 2 0
										SetOuterRadius SkinMod BoneID 2 0
									)
									if ((MAXVersion())[1] > 15000) then (
										for VertID = 1 to Result.NumVerts do (
											UnNormalizeVertex SkinMod VertID false
											local	VertBones = SkinBones[VertID],
													VertWeights = SkinWeights[VertID],
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
									) else (
										for VertID = 1 to Result.NumVerts do
											ReplaceVertexWeights SkinMod VertID SkinBones[VertID] SkinWeights[VertID]
									)
									Update Result
									MAX Create Mode
									Select OldSelection
									--SuspendEditing()
								) else (
									Result.Transform = (
										if ParentNode == RootNode then
											(Matrix3 1)
										else
											ParentNode.Transform
									)
								)
								Result = #(Result)
							)
						)
						#Bone: (
							local	ParentTM = (
									if ParentNode == RootNode then
										(Matrix3 1)
									else
										ParentNode.Transform
								)
							Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_Model_Bone)
							Result.WireColor = Yellow
							Result.ShowLinks = true
							Result.ShowLinksOnly = true
							Result.Scale = (ParentNode.Scale + Obj.TheScale)
							Result.Rotation = ((Inverse ParentTM) * (Obj.RotationQuaternion as Matrix3))
							Result.Pos = (Obj.LocalOffset * ParentTM)
							ConvertStruct Result undefined ParamSource:Obj DontCreate:true
							Ancestor[Obj.Index] = Result
							for Item in Obj.Children do
								SceneFromStruct Item ParentNode:Result Ancestor:Ancestor
						)
						#Skeleton: (
							local	TheBones = Obj.TheBones,
									Result = #()
							Result.Count = TheBones.Count
							for Item in TheBones do
								SceneFromStruct Item ParentNode:ParentNode Ancestor:Result AllowCallingSearch:AllowCallingSearch
						)
						#Light: (
							local	BoneID = Obj.BoneID
							ParentNode = undefined
							for tBone in Ancestor while No ParentNode where
								not (IsKindOf tBone EGIMS_IV_Model) and
								tBone.ID == BoneID
							do
								ParentNode = tBone
							if No ParentNode then (
								if BoneID != 0 then
									SCore.SystemMgr.ThrowError ("Light link error in object \"" + Obj.ObjName + "\" - no bone with ID " + BoneID as String) #Abort
								else
									ParentNode = Ancestor[1]
							)
							local	ParentTM = (
										if ParentNode == RootNode then
											(Matrix3 1)
										else
											ParentNode.Transform
									),
									TextureNames = GCore.DB.TextureNames
							Result = (SceneFromStruct (FetchMHL TextureNames Obj.CoronaHash) ParentNode:ParentNode NodeType:EGIMS_IV_Model_Light)
							ConvertStruct Result undefined ParamSource:Obj DontCreate:true
							Result.Pos = (Obj.Position * ParentTM)
							Result.Dir = Obj.Direction
							Result.pLuminescenceHash = (FetchMHL TextureNames Obj.LuminescenceHash)
							local	DrawDistDiv4 = Obj.DrawDistDiv4
							Result.pDrawDistDiv4 = (
								if DrawDistDiv4 == -1 then
									-1
								else
									(DrawDistDiv4 * 4)
							)
						)
						#ShadingGroup: (
							local	Shaders = Obj.Shaders,
									ShaderCount = Shaders.Count
							Result = (
								MultiMaterial \
								Name:Obj.ObjName \
								MaterialList:Shaders \
								MaterialIDList:(TypeCast #{1..ShaderCount} array) \
								Names: ( \
									local	Res = #()
									for i = ShaderCount to 1 by -1 do
										Res[i] = Shaders[i].Name
									Res
								) \
							)
						)
						#Drawable: (
							Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_Model)
							local	TheBones,
									Groups = Obj.LodGroup.LodGroups,
									GroupCount = Groups.Count
							if Have Obj.TheSkeleton then (
								local	BonesParent = (
									if AllowCallingSearch then
										(SceneFromStruct "*Skeleton" ParentNode:ParentNode NodeType:EGIMS_IV_ModelDict_Skeleton AllowCallingSearch:AllowCallingSearch)
									else
										Result
								)
								TheBones = (SceneFromStruct Obj.TheSkeleton ParentNode:BonesParent AllowCallingSearch:AllowCallingSearch)
								Result.Flags = Obj.TheSkeleton.Flags
							) else
								TheBones = #(Result)
							if Have Obj.LightAttributes then (
								for Item in Obj.LightAttributes.Items do
									SceneFromStruct Item Ancestor:TheBones
							)
							local	DoOwnProgress = (No ProgressData)
							if DoOwnProgress then (
								ProgressData = [1, 0, 2]
								for Grp in Groups do
									ProgressData.z += Grp.Count
								UpdateProgress #Progress ProgressData
							)
							local	MeshData = #(#(), #(), #(), #()),
									ShadingGroup = Obj.ShadingGroup,
									HaveShadingGroup = (Have ShadingGroup),
									ObjMaterial,
									BlendStartMapIDs = #()
							if HaveShadingGroup then (
								ObjMaterial = (SceneFromStruct ShadingGroup)
								local	MatList = ObjMaterial.MaterialList
								for MtlID = MatList.Count to 1 by -1 do (
									BlendStartMapIDs[MtlID] = (
										case (MatList[MtlID].GetShaderName()) of (
											#gta_terrain_va_2lyr:
												3
											#gta_terrain_va_3lyr:
												4
											#gta_terrain_va_4lyr:
												5
											Default:
												7
										)
									)
								)
							)
							for GroupID = 1 to GroupCount do (
								local	Grp = Groups[GroupID]
								for Item in Grp do (
									if DoOwnProgress then (
										ProgressData.x += 1
										UpdateProgress #Progress ProgressData
									)
									local	TempMeshes = (
												SceneFromStruct \
													Item \
													ParentNode:TheBones[Item.BoneID] \
													Ancestor:TheBones \
													SplitParts:SplitParts \
													NodeType:GroupID \
													AdditionalParam:BlendStartMapIDs \
											)
									for TempMesh in TempMeshes do
										AddModifier TempMesh (EGIMS_IV_ModelMesh Type:GroupID)
									MeshData[GroupID] += TempMeshes
								)
							)
							if DoOwnProgress then (
								ProgressData.x += 1
								UpdateProgress #Progress ProgressData
							)
							if HaveShadingGroup then (
								for Meshes in MeshData do
									Meshes.Material = ObjMaterial
							)
							Result = #(MeshData, TheBones, ObjMaterial, Result, BlendStartMapIDs)
						)
						#DrawableDictionary: (
							local	ODD_MergeSkeletons = false
							Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_ModelDict)
							local	Items = Obj.Items,
									ItemCount = Items.Count,
									ProgressData = [0, 0, ItemCount]
							for ItemID = 1 to ItemCount do (
								ProgressData.x = ItemID
								UpdateProgress #Progress ProgressData
								SceneFromStruct Items[ItemID] ParentNode:Result ProgressData:ProgressData AllowCallingSearch:ODD_MergeSkeletons
							)
						)
						#PhBound: (
							local	Bounds = Obj.Bounds,
									ParentTM = (
										if ParentNode == RootNode then
											(Matrix3 1)
										else
											ParentNode.Transform
									),
									ObjType = (TypeCast Obj.Type name),
									TargetPos = (
										if
											Have Bounds.Centroid and
											ObjType != #BoundComposite and
											ObjType != #BoundBVH and
											ObjType != #BoundGeometry
										then
											Bounds.Centroid
										else
											[0, 0, 0]
									),
									Results = #(),
									DoOwnProgress = (No ProgressData)
							case ObjType of (
								#BoundComposite: (
									local	Children = Obj.Children,
											ChildTransforms = Obj.ChildTransforms,
											ChildrenCount = Children.Count,
											ChildProgress
									Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_ColComposite)
									if DoOwnProgress then
										ProgressData = [0, 0, ChildrenCount]
									else
										ProgressData.x += 1
									UpdateProgress #Progress ProgressData
									for ChildID = 1 to ChildrenCount where Have Children[ChildID] do (
										if DoOwnProgress then (
											ProgressData.x = ChildID
											UpdateProgress #Progress ProgressData
										)
										TempChildSource = Children[ChildID]
										TempChild = (SceneFromStruct TempChildSource ParentNode:Result ProgressData:ProgressData)
										TempChild.Transform = (ChildTransforms[ChildID] * ParentTM)
										if (ClassOf TempChild == EGIMS_IV_Car_Wheel) then
											TempChild.Dir = TempChildSource.CurvedEdges[1].Dir
										Append Results TempChild
									)
								)
								#BoundBox: (
									Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:GIMS_IV_Col_Box)
									local	Extents = Obj.Extents
									Result.Width = Extents.x
									Result.Depth = Extents.y
									Result.Height = Extents.z
								)
								#BoundSphere: (
									Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:GIMS_IV_Col_Sphere)
									Result.Radius = Bounds.Radius
								)
								#BoundCapsule: (
									Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:GIMS_IV_Col_Capsule)
									Result.Radius = Obj.CapsuleData.x
									Result.Height = Obj.CapsuleData.y
								)
								#BoundCurvedGeometry: (
									Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_Car_Wheel)
									Result.Dir = Obj.CurvedEdges[1].Dir
									local	AABB = Bounds.AABB,
											AABBMax = AABB.bMax,
											AABBMin = AABB.bMin,
											MarginX = Obj.Margin.x,
											VertScaleQuan = (Obj.VertexScale * 32767)
									Result.DefRadius = (Obj.Vertices[2].z * Obj.VertexScale.z + Obj.VertexOffset.z)
									Result.InfRadius = VertScaleQuan.z
									Result.Width = (AABBMax.x * 2)
								)
								default: (
									if
										ObjType == #BoundBVH or
										ObjType == #BoundGeometry
									then (
										local	Faces = #(),
												FaceMatIDs = #(),
												Polys = #(),
												PolyMatIDs = #()
										local	Vertices = (Modify Obj.Vertices #(Obj.VertexScale, Obj.VertexOffset) #(#Multiply, #Add)),
												PolyMatIDs = Obj.PolyMatIDs,
												PolyVerts = Obj.PolyVerts,
												ObjPolyCount = PolyMatIDs.Count,
												FaceCount = 0,
												PolyCount = 0
										Faces.Count = (FaceMatIDs.Count = (Polys.Count = (PolyMatIDs.Count = ObjPolyCount)))
										for PolyID = 1 to ObjPolyCount do (
											local	Verts = PolyVerts[PolyID]
											if
												(IsKindOf Verts Point3) or
												Verts.w == 1
											then (
												FaceCount += 1
												FaceMatIDs[FaceCount] = PolyMatIDs[PolyID]
												Faces[FaceCount] = Verts
											) else (
												PolyCount += 1
												PolyMatIDs[PolyCount] = PolyMatIDs[PolyID]
												Polys[PolyCount] = #(
													Verts.x,
													Verts.y,
													Verts.z,
													Verts.w
												)
											)
										)
										Faces.Count = (FaceMatIDs.Count = FaceCount)
										Polys.Count = (PolyMatIDs.Count = PolyCount)
										in ParentNode (
											Result = (
												CreateMesh \
													Vertices \
													Faces \
													MaterialIDs:FaceMatIDs \
													ResultAsPoly:true \
													Polys:Polys \
													PolyMatIDs:PolyMatIDs\
													SG:#Remove \
											)
										)
										AddModifier Result (EGIMS_IV_CollisionMesh Type:(if ObjType == #BoundBVH then 1 else 2))
										Update Result
									) else
										throw "Unknown type!"
								)
							)
							if ObjType != #BoundComposite then (
								local	Materials = Obj.Materials,
										MaterialCount = Materials.Count
								Result.Material = (
									MultiMaterial \
									Name:Obj.ObjName \
									MaterialList:Materials \
									MaterialIDList:(TypeCast #{1..MaterialCount} array) \
									Names:( \
										local	Res = #()
										for i = MaterialCount to 1 by -1 do
											Res[i] = Materials[i].Name
										Res
									) \
								)
							)
							if ParentNode != NodeType then (
								Result.Name = Obj.ObjName
								Result.Pos = (TargetPos * ParentTM)
							)
							if ParentNode == NodeType then
								Result = Results
						)
						#PhBoundDictionary: (
							Result = (SceneFromStruct Obj.ObjName ParentNode:ParentNode NodeType:EGIMS_IV_CollisionDict)
							local	Items = Obj.Items,
									ItemCount = Items.Count,
									ProgressData = [0, 0, ItemCount]
							for ItemID = 1 to ItemCount do (
								ProgressData.x = ItemID
								UpdateProgress #Progress ProgressData
								SceneFromStruct Items[ItemID] ParentNode:Result ProgressData:ProgressData
							)
						)
						Default:
							throw "Unknown object!"
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn StructFromFile File TexPath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	FileType = (GetFileNameType File),
						Type = (SubString FileType 2 FileType.Count),
						TypeName = (TypeCast Type name),
						StrType = (
							case TypeName of (
								#obn:
									GTypeLibrary.grcPhBound
								#obd:
									GTypeLibrary.grcPhBoundDictionary
								#otd:
									GTypeLibrary.grcTextureDictionary
								#odr:
									GTypeLibrary.grcDrawable
								#odd:
									GTypeLibrary.grcDrawableDictionary
								#onv:
									GTypeLibrary.grcNavMesh
								#oft:
									GTypeLibrary.grcFragType
								default:
									throw "Unknown resource type!"
							)
						),
						Result = (ReadCached File StrType GCCPath:#ResourceCachePath Type:Type HandlerParam:TexPath)
				if Have Result then (
					if (TryAccess Obj #CheckLocked) then (
						if (Obj.CheckLocked()) then (
							--<TODO> add result message
							Result = undefined
						)
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strMaterialOps (
		/*Shader param handling data*/
			ParamNameMap = #(
				#specularfactored,
				#specularcolorfactored,
				#reflectivepowered,
				#specular2factored,
				#specular2colorintensityed,
				#diffuse2specmod,
				#reflectivepower,
				#specularfactor,
				#specularcolorfactor,
				#bumpiness,
				#emissivemultiplier,
				#fade_thickness,
				#zshift,
				#parallaxscalebias,
				#fadeAlphaDist,
				#matdiffusecolor,
				#subcolor,
				#dirtdecalmask,
				#specmapintmask,
				#plantColor,
				#dimmerset,
				#dirtsampler,
				#texturesampler,
				#texturesampler2,
				#bumpsampler,
				#specsampler,
				#environmentsampler,
				#texturesampler_layer0,
				#texturesampler_layer1,
				#texturesampler_layer2,
				#texturesampler_layer3,
				#TextureGrassSampler,
				#matGrassTransform, /*spMatrix, SKIP*/
				#vecCameraPos, /*spVector4, SKIP*/
				#gWorldInstanceMatrix,	/*spVector4, SKIP*/
				#gWorldInstanceInverseTranspose	/*spVector4, SKIP*/
			),
			DataMap = #(
				#ShaderData,	/*specularfactored*/
				#ShaderData,	/*specularcolorfactored*/
				#ShaderData,	/*reflectivepowered*/
				#ShaderData,	/*specular2factored*/
				#ShaderData,	/*specular2colorintensityed*/
				#ShaderData,	/*diffuse2specmod*/
				#PowerData,	/*reflectivepower*/
				#PowerData,	/*specularfactor*/
				#PowerData,	/*specularcolorfactor*/
				#PowerData,	/*bumpiness*/
				#PowerData,	/*emissivemultiplier*/
				#PowerData,	/*fade_thickness*/
				#PowerData,	/*zshift*/
				#PowerData,	/*parallaxscalebias*/
				#PowerData,	/*fadeAlphaDist*/
				#ColorData,	/*matdiffusecolor*/
				#ColorData,	/*subcolor*/
				#ColorData,	/*dirtdecalmask*/
				#ColorData,	/*specmapintmask*/
				#ColorData2,	/*plantColor*/
				undefined,	/*dimmerset*/
				#MapsLocationData,	/*dirtsampler*/
				#MapsLocationData,	/*texturesampler*/
				#MapsLocationData,	/*texturesampler2*/
				#MapsLocationData,	/*bumpsampler*/
				#MapsLocationData,	/*specsampler*/
				#MapsLocationData,	/*environmentsampler*/
				#MapsLocationData,	/*texturesampler_layer0*/
				#MapsLocationData,	/*texturesampler_layer1*/
				#MapsLocationData,	/*texturesampler_layer2*/
				#MapsLocationData,	/*texturesampler_layer3*/
				#MapsLocationData,	/*TextureGrassSampler*/
				undefined,	/*#matGrassTransform*/
				undefined,	/*#vecCameraPos*/
				undefined,	/*#gWorldInstanceMatrix*/
				undefined	/*#gWorldInstanceInverseTranspose*/
			),
			DataIDMap = #(
				[1, 3],	/*specularfactored*/
				[2, 1],	/*specularcolorfactored*/
				[2, 2],	/*reflectivepowered*/
				[2, 3],	/*specular2factored*/
				[3, 1],	/*specular2colorintensityed*/
				[3, 2],	/*diffuse2specmod*/
				[1, 2],	/*reflectivepower*/
				[1, 3],	/*specularfactor*/
				[2, 1],	/*specularcolorfactor*/
				[1, 1],	/*bumpiness*/
				[2, 2],	/*emissivemultiplier*/
				[2, 3],	/*fade_thickness*/
				[3, 1],	/*zshift*/
				[3, 2],	/*parallaxscalebias*/
				[3, 3],	/*fadeAlphaDist*/
				1,	/*matdiffusecolor*/
				4,	/*subcolor*/
				3,	/*dirtdecalmask*/
				2,	/*specmapintmask*/
				1,	/*plantColor*/
				undefined,	/*dimmerset*/
				[2, 3],	/*dirtsampler*/
				[1, 1],	/*texturesampler*/
				[1, 2],	/*texturesampler2*/
				[1, 3],	/*bumpsampler*/
				[2, 1],	/*specsampler*/
				[2, 2],	/*environmentsampler*/
				[3, 1],	/*texturesampler_layer0*/
				[3, 2],	/*texturesampler_layer1*/
				[3, 3],	/*texturesampler_layer2*/
				[4, 1],	/*texturesampler_layer3*/
				[4, 2],	/*TextureGrassSampler*/
				undefined,	/*#matGrassTransform*/
				undefined,	/*#vecCameraPos*/
				undefined,	/*#gWorldInstanceMatrix*/
				undefined	/*#gWorldInstanceInverseTranspose*/
			),
			TextureSlotNameMap = #(
				undefined,	/*specularfactored*/
				undefined,	/*specularcolorfactored*/
				undefined,	/*reflectivepowered*/
				undefined,	/*specular2factored*/
				undefined,	/*specular2colorintensityed*/
				undefined,	/*diffuse2specmod*/
				undefined,	/*reflectivepower*/
				undefined,	/*specularfactor*/
				undefined,	/*specularcolorfactor*/
				undefined,	/*bumpiness*/
				undefined,	/*emissivemultiplier*/
				undefined,	/*fade_thickness*/
				undefined,	/*zshift*/
				undefined,	/*parallaxscalebias*/
				undefined,	/*fadeAlphaDist*/
				undefined,	/*matdiffusecolor*/
				undefined,	/*subcolor*/
				undefined,	/*dirtdecalmask*/
				undefined,	/*specmapintmask*/
				undefined,	/*plantColor*/
				undefined,	/*dimmerset*/
				#DirtMap,	/*dirtsampler*/
				#DiffuseMap_1, /*texturesampler*/
				#DiffuseMap_2,	/*texturesampler2*/
				#NormalMap,	/*bumpsampler*/
				#SpecMap,	/*specsampler*/
				#RefMap,	/*environmentsampler*/
				#BlendLayerMap_1, /*texturesampler_layer0*/
				#BlendLayerMap_2,	/*texturesampler_layer1*/
				#BlendLayerMap_3,	/*texturesampler_layer2*/
				#BlendLayerMap_4,	/*texturesampler_layer3*/
				#GrassMap,	/*TextureGrassSampler*/
				undefined,	/*#matGrassTransform*/
				undefined,	/*#vecCameraPos*/
				undefined,	/*#gWorldInstanceMatrix*/
				undefined	/*#gWorldInstanceInverseTranspose*/
			),
			SetNameMap = (#{
				/*1,	/*specularfactored*/
				/*2,	/*specularcolorfactored*/
				/*3,	/*reflectivepowered*/
				/*4,	/*specular2factored*/
				/*5,	/*specular2colorintensityed*/
				/*6,	/*diffuse2specmod*/
				/*7,	/*reflectivepower*/
				/*8,	/*specularfactor*/
				/*9,	/*specularcolorfactor*/
				/*10,	/*bumpiness*/
				/*11,	/*emissivemultiplier*/
				/*12,	/*fade_thickness*/
				/*13,	/*zshift*/
				/*14,	/*parallaxscalebias*/
				/*15,	/*fadeAlphaDist*/
				/*16,	/*matdiffusecolor*/
				/*17,	/*subcolor*/
				/*18,	/*dirtdecalmask*/
				/*19,	/*specmapintmask*/
				/*20,	/*plantColor*/
				/*21,	/*dimmerset*/
				/*22,	/*dirtsampler*/
				23,	/*texturesampler*/
				/*24,	/*texturesampler2*/
				/*25,	/*bumpsampler*/
				/*26,	/*specsampler*/
				/*27,	/*environmentsampler*/
				28}/*,	/*texturesampler_layer0*/
				/*29,	/*texturesampler_layer1*/
				/*30,	/*texturesampler_layer2*/
				/*31,	/*texturesampler_layer3*/
				/*32,	/*TextureGrassSampler*/
				/*33,	/*#matGrassTransform*/
				/*34,	/*#vecCameraPos*/
				/*35,	/*#gWorldInstanceMatrix*/
				/*36}	/*#gWorldInstanceInverseTranspose*/
			),
			IgnoreMap = (#{
				/*1,	/*specularfactored*/
				/*2,	/*specularcolorfactored*/
				/*3,	/*reflectivepowered*/
				/*4,	/*specular2factored*/
				/*5,	/*specular2colorintensityed*/
				/*6,	/*diffuse2specmod*/
				/*7,	/*reflectivepower*/
				/*8,	/*specularfactor*/
				/*9,	/*specularcolorfactor*/
				/*10,	/*bumpiness*/
				/*11,	/*emissivemultiplier*/
				/*12,	/*fade_thickness*/
				/*13,	/*zshift*/
				/*14,	/*parallaxscalebias*/
				/*15,	/*fadeAlphaDist*/
				/*16,	/*matdiffusecolor*/
				/*17,	/*subcolor*/
				/*18,	/*dirtdecalmask*/
				/*19,	/*specmapintmask*/
				/*20,	/*plantColor*/
				21,	/*dimmerset*/
				/*22,	/*dirtsampler*/
				/*23,	/*texturesampler*/
				/*24,	/*texturesampler2*/
				/*25,	/*bumpsampler*/
				/*26,	/*specsampler*/
				/*27,	/*environmentsampler*/
				/*28,	/*texturesampler_layer0*/
				/*29,	/*texturesampler_layer1*/
				/*30,	/*texturesampler_layer2*/
				/*31,	/*texturesampler_layer3*/
				/*32,	/*TextureGrassSampler*/
				33,	/*#matGrassTransform*/
				34,	/*#vecCameraPos*/
				35,	/*#gWorldInstanceMatrix*/
				36}	/*#gWorldInstanceInverseTranspose*/
			),
		/*Shortcuts*/
			AddResult, FixMapFileNames, ConvertStruct, AsoFText, LoadBitmapFile, AppendMHL, QuickSort, TypeCast, TextureNames, UpdateMatrix, Shaders, UpdateProgress, FormatText, GetDiffuseWithOpacityAlpha, GetBumpWithSpecAlpha,
		/*Ops*/
		fn ReplaceWithShader Mtl AllowWarnings:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local IV = GIMS.IV,
						ShaderName = (Append ((Mtl.GetShaderName()) as String) ".fx"),
						FilesPath = IV.FilesPath,
						FileFX = (FilesPath + ShaderName)
				if not (DoesFileExist FileFX) then (
					if AllowWarnings then (
						AddResult #Warning (
							FormatText \
								v1:"Can't find \"" \
								v2:ShaderName \
								v3:"\" shader in the GIMS IV folder! Using \"dummy.fx\"..."
						)
					)
					FileFX = (FilesPath + "dummy.fx")
				)
				local DXMtl = (DXMaterial ShowInViewport:true EffectFile:FileFX),
						PowerData1 = Mtl.PowerData[1],
						PowerData2 = Mtl.PowerData[2],
						ColorData = Mtl.ColorData
				try
					DXMtl.BumpPower = PowerData1.x
				catch (
					if AllowWarnings then
						AddResult #Warning ("Bump power've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.RefPower = PowerData1.y
				catch (
					if AllowWarnings then
						AddResult #Warning ("Reflection power've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.SpecMapPower = PowerData1.z
				catch (
					if AllowWarnings then
						AddResult #Warning ("Specular map power've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.SpecPower = PowerData2.x
				catch (
					if AllowWarnings then
						AddResult #Warning ("Specular power've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.LightPower = PowerData2.y
				catch (
					if AllowWarnings then
						AddResult #Warning ("Light power've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.DiffColor = ((ColorData[1] / 255) as Point4)
				catch (
					if AllowWarnings then
						AddResult #Warning ("Diffuse color've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.SpecMask = ((ColorData[2] / 255) as Point4)
				catch (
					if AllowWarnings then
						AddResult #Warning ("Specular mask've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.DirtMask = ((ColorData[3] / 255) as Point4)
				catch (
					if AllowWarnings then
						AddResult #Warning ("Dirt mask've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.SkinColor = ((ColorData[4] / 255) as Point4)
				catch (
					if AllowWarnings then
						AddResult #Warning ("Skin color've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				try
					DXMtl.GrassColor = ((Mtl.ColorData2[1] / 255) as Point4)
				catch (
					if AllowWarnings then
						AddResult #Warning ("Grass color've failed to pass into the shader: " + (GetCurrentException()) as String)
				)
				if Have Mtl.DiffuseMap_1 then (
					try
						DXMtl.TexDiff = Mtl.DiffuseMap_1.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("1st diffuse texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.DiffuseMap_2 then (
					try
						DXMtl.TexDiff2 = Mtl.DiffuseMap_2.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("2nd diffuse texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.NormalMap then (
					try
						DXMtl.TexBump = Mtl.NormalMap.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Normal bump texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.SpecMap then (
					try
						DXMtl.TexSpec = Mtl.SpecMap.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Specular texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.RefMap then (
					try
						DXMtl.TexRef = Mtl.RefMap.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Reflection texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.DirtMap then (
					try
						DXMtl.TexDirt = Mtl.DirtMap.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Dirt texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.BlendLayerMap_1 then (
					try
						DXMtl.TexLayer1 = Mtl.BlendLayerMap_1.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Blend layer 1 texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.BlendLayerMap_2 then (
					try
						DXMtl.TexLayer2 = Mtl.BlendLayerMap_2.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Blend layer 2 texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.BlendLayerMap_3 then (
					try
						DXMtl.TexLayer3 = Mtl.BlendLayerMap_3.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Blend layer 3 texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.BlendLayerMap_4 then (
					try
						DXMtl.TexLayer4 = Mtl.BlendLayerMap_4.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Blend layer 4 texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if Have Mtl.GrassMap then (
					try
						DXMtl.GrassMap = Mtl.GrassMap.bitmap
					catch (
						if AllowWarnings then
							AddResult #Warning ("Grass texture've failed to pass into the shader: " + (GetCurrentException()) as String)
					)
				)
				if AllowWarnings then
					GIMS.Core.SystemMgr.CheckResult ShowSuccess:false Title:("GIMS " + IV.Name + " shader replacement results")
				DXMtl
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetStandartized Mtl NeedMultiMtl:true DoOwnProgress:false = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
					GTAIVunimat: (
						local	PropMapping = #(
									#(
										#Name,
										#ShowInViewport,
										#diffName,
										#diffName2,
										#normName,
										#specName,
										#envName,
										#dirtName,
										#blendname1,
										#blendname2,
										#blendname3,
										#blendname4
									), #(
										#Name,
										#ShowInViewport,
										#DiffuseMap_1,
										#DiffuseMap_2,
										#NormalMap,
										#SpecMap,
										#RefMap,
										#DirtMap,
										#BlendLayerMap_1,
										#BlendLayerMap_2,
										#BlendLayerMap_3
									)
								),
								NewMtl = (ConvertStruct Mtl EGIMS_IV_material PropMapping:PropMapping AllowOwnProps:false)
						NewMtl.MapsLocationData = (UpdateMatrix NewMtl.MapsLocationData 1 [Mtl.copytex_d, Mtl.copytex_d2, Mtl.copytex_b])
						NewMtl.MapsLocationData = (UpdateMatrix NewMtl.MapsLocationData 2 [Mtl.copytex_s, Mtl.copytex_e, Mtl.copytex_dirt])
						NewMtl.MapsLocationData = (UpdateMatrix NewMtl.MapsLocationData 3 [Mtl.copytex_1, Mtl.copytex_2, Mtl.copytex_3])
						NewMtl.MapsLocationData = (UpdateMatrix NewMtl.MapsLocationData 4 [Mtl.copytex_4, 1, NewMtl.MapsLocationData[4].z])
						NewMtl.ColorData = (UpdateMatrix NewMtl.ColorData 1 (TypeCast DiffColor Point3))
						NewMtl.ColorData = (UpdateMatrix NewMtl.ColorData 2 (TypeCast SpecMask Point3))
						NewMtl.ColorData = (UpdateMatrix NewMtl.ColorData 3 (TypeCast DirtMask Point3))
						NewMtl.ColorData = (UpdateMatrix NewMtl.ColorData 4 (TypeCast SkinColor Point3))
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 1 [Mtl.bumppower, Mtl.refpower, Mtl.specpower])
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 2 [Mtl.speccolpower, Mtl.lightpower, Mtl.thickness])
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 3 [Mtl.zshift, Mtl.parallaxscale, 1])
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					GTA_IV_material: (
						local	NewMtl = (ConvertStruct Mtl EGIMS_IV_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)))
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					EGIMS_IV_material: (
						FixMapFileNames Mtl
						if NeedMultiMtl then
							Mtl = (MultiMaterial Material:#(Mtl) Names:#(Mtl.Name))
						Mtl
					)
					Standard: (
						local	PropMapping = #(
									#(
										#Name,
										#ShowInViewport,
										#SpecularLevelMap,
										#ReflectionMap
									), #(
										#Name,
										#ShowInViewport,
										#SpecMap,
										#RefMap
									)
								),
								BumpMap = Mtl.BumpMap,
								DiffMap = (GetDiffuseWithOpacityAlpha Mtl),
								NewMtl = (ConvertStruct Mtl EGIMS_IV_material PropMapping:PropMapping AllowOwnProps:false)
						if
							Have DiffMap and
							Have DiffMap.Bitmap and
							DiffMap.Bitmap.HasAlpha
						then
							NewMtl.ShaderData = (UpdateMatrix NewMtl.ShaderData 1 [1, 2, 1]) 
						NewMtl.DiffuseMap_1 = DiffMap
						NewMtl.NormalMap = (if (IsKindOf BumpMap Normal_Bump) then BumpMap.Normal_Map)
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 1 [Mtl.BumpMapAmount/100, Mtl.ReflectionMapAmount/100, Mtl.SpecularLevelMapAmount])
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 2 [Abs (Mtl.Glossiness/100 - 1), Mtl.SelfIllumination, 0.5])
						NewMtl.PowerData = (UpdateMatrix NewMtl.PowerData 3 [1, 0.05, 1])
						FixMapFileNames NewMtl
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
					BitMap:
						GetStandartized (BitMapTexture BitMap:Mtl) DoOwnProgress:DoOwnProgress
					BitMapTexture: (
						local	NewMtl = EGIMS_IV_material DiffuseMap_1:Mtl Name:(GetFIleNameFile Mtl.FileName) ShowInViewport:true
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
					)
					Default: (
						local	NewMtl = (
									if No Mtl then
										EGIMS_IV_material ShowInViewport:true
									else (
										local	MatDelegate = (try Mtl.Delegate	catch())
										if
											Have MatDelegate and
											(IsKindOf MatDelegate Standard)
										then
											GetStandartized MatDelegate NeedMultiMtl:false
										else
											ConvertStruct Mtl EGIMS_IV_material PropMapping:#(#(#Name, #ShowInViewport), #(#Name, #ShowInViewport)) AllowOwnProps:false
									)
								)
						if NeedMultiMtl then
							NewMtl = (MultiMaterial Material:#(NewMtl) Names:#(NewMtl.Name))
						NewMtl
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn DoMatrixUpdate Mtl PropertyName DataID Val = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				case PropertyName of (
					#ShaderData:
						Mtl.ShaderData = (UpdateMatrix Mtl.ShaderData DataID Val)
					#PowerData:
						Mtl.PowerData = (UpdateMatrix Mtl.PowerData DataID Val)
					#ColorData:
						Mtl.ColorData = (UpdateMatrix Mtl.ColorData DataID Val)
					#ColorData2:
						Mtl.ColorData2 = (UpdateMatrix Mtl.ColorData2 DataID Val)
					default:
						throw (Append "Unknown PropertyName: " (PropertyName as String))
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ParamFromFormats ParamString ShaderParamType Mtl PropertyName \
			DiskPath:undefined \
			TexPath:undefined \
			DataID:undefined \
			TextureSlotName:undefined \
			SetName:false = \
		(
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				case ShaderParamType of (
					#spTexture: (
						if (TypeCast ParamString name) != #null then (
							local	TexName = (GetFileNameFile ParamString),
									IsIncluded = ((GetFileNameType ParamString).Count != 0),
									SearchPath = (
										if IsIncluded then
											DiskPath
										else
											TexPath
									)
							AppendMHL TextureNames TexName
							SetProperty Mtl TextureSlotName (LoadBitmapFile SearchPath (Append (GetFileNamePath ParamString) TexName))
							if IsIncluded then
								Mtl.MapsLocationData = (UpdateMatrix Mtl.MapsLocationData DataID 2)
							if SetName then
								Mtl.Name = TexName
						)
					)
					#spFloat: (
						local	Val = (TypeCast (FilterString ParamString ";")[1] Float)
						if Have Mult then
							Val *= Mult
						DoMatrixUpdate Mtl PropertyName DataID Val
					)
					#spVector4: (
						if (IsKindOf DataID Integer) then (	/*color*/
							local	TempParam = (FilterString ParamString ";")
							DoMatrixUpdate Mtl PropertyName DataID ([(TypeCast TempParam[1] Float), (TypeCast TempParam[2] Float), (TypeCast TempParam[3] Float)] * 255)
						) else
							ParamFromFormats ParamString #spFloat Mtl PropertyName DataID:DataID
					)
					default:
						throw ("Unknown parameter type: " + ShaderParamType as String)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetFromFormats Params DiskPath TexPath = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result = (EGIMS_IV_material ShowInViewport:true),
						GCore = GIMS.CurrentGame.Core,
						ShaderName = (TypeCast (GetFileNameFile Params[1]) Name),
						ShaderGroups = Shaders[2],
						ShaderGroupCount = ShaderGroups.count,
						ShaderID, GroupID
				for GID = 1 to ShaderGroupCount while No ShaderID do (
					SID = (FindItem ShaderGroups[GID] ShaderName)
					if SID != 0 then (
						ShaderID = SID
						GroupID = GID
					)
				)
				if Have ShaderID then (
					local	ShaderParams = Shaders[3][GroupID][ShaderID],
							ShaderParamTypes = Shaders[4][GroupID][ShaderID]
					if ShaderParams.Count == (Params.Count - 1) then (
						Result.ShaderData = (UpdateMatrix Result.ShaderData [1, 1] GroupID)
						Result.ShaderData = (UpdateMatrix Result.ShaderData [1, 2] ShaderID)
						for ParamID = 1 to ShaderParams.count do (
							local	ParamName = ShaderParams[ParamID],
									MapID = (FindItem ParamNameMap ParamName)
							if MapID != 0 then (
								if not IgnoreMap[MapID] then (
									ParamFromFormats \
										Params[ParamID + 1] \
										ShaderParamTypes[ParamID] \
										Result \
										DataMap[MapID] \
										DiskPath:DiskPath \
										TexPath:TexPath \
										SetName:SetNameMap[MapID] \
										DataID:DataIDMap[MapID] \
										TextureSlotName:TextureSlotNameMap[MapID] \
								)
							) else
								throw ("Unknown parameter: " + ParamName as String)
						)
					) else (
						AddResult #Warning (
							FormatText \
								v1:"\"" \
								v2:ShaderName \
								v3:"\" shader syntax error! Expected " \
								v4:ShaderParams.Count \
								v5:" parameters, got: " \
								v6:(Params.Count - 1) \
								v7:". Defaulting..."
						)
					)
				) else (
					AddResult #Warning (
						FormatText \
							v1:"Unknown shader \"" \
							v2:ShaderName \
							v3:"\" found! Defaulting..."
					)
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn GetShaderTexture DiskPath SubDirName TexMap IncludeFlag = (	/*<TODO> HERE FUCKING THE TEXTURES*/
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Result
				if No TexMap then
					Result = "null"
				else (
					local	Core = GIMS.Core,
							TexPath, NewPath,
							TexName = (GetFileNameFile TexMap.FileName),
							TexType = (GetFileNameType TexMap.FileName)
					Core.ArrayOps.AppendMHL GIMS.CurrentGame.Core.DB.TextureNames TexName
					if (DoesFileExist TexMap.FileName) then
						TexPath = TexMap.FileName
					else (
						local	SceneDirTexName = (MAXFilepath + TexName)
						if (DoesFileExist SceneDirTexName) then
							TexPath = SceneDirTexName
						else (
							Core.SystemMgr.AddResult #Warning (
								Core.ValueOps.FormatText \
									v1:"Can't find \"" \
									v2:TexMap.FileName \
									v3:"\" texture file!\n"
							)
						)
					)
					if IncludeFlag then (
						Result = (Copy SubDirName)
							Append Result "\\"
							Append Result TexName
							Append Result TexType
						if Have TexPath then
							Core.SystemMgr.FileCopy TexPath (DiskPath + Result)
					) else
						Result = TexName
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn AsFormatsText Mtl DiskPath SubDirName = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	PowerData = Mtl.PowerData,
							PowerData1 = Mtl.PowerData[1],
							PowerData2 = Mtl.PowerData[2],
							PowerData3 = Mtl.PowerData[3],
						ShaderData = Mtl.ShaderData,
							ShaderData1 = Mtl.ShaderData[1],
							ShaderData2 = Mtl.ShaderData[2],
							ShaderData3 = Mtl.ShaderData[3],
						ColorData = Mtl.ColorData,
							ColorData01 = ColorData[1],
							ColorData02 = ColorData[2],
							ColorData03 = ColorData[3],
							ColorData04 = ColorData[4],
						ColorData21 = Mtl.ColorData2[1],
						MapsLocationData = Mtl.MapsLocationData,
							MapsLocationData1 = MapsLocationData[1],
							MapsLocationData2 = MapsLocationData[2],
							MapsLocationData3 = MapsLocationData[3],
							MapsLocationData4 = MapsLocationData[4],
						GCore = GIMS.CurrentGame.Core,
						GroupID = ShaderData[1].x,
						ShaderID = ShaderData[1].y,
						Params = Shaders[3][GroupID][ShaderID],
						Result = #(((Mtl.GetShaderName()) as String) + ".sps")
				for ParamID = 1 to Params.count do (
					Append Result (
						case Params[ParamID] of (
							#specularfactored:
								ShaderData1.z
							#specularcolorfactored:
								ShaderData2.x
							#reflectivepowered:
								ShaderData2.y
							#specular2factored:
								ShaderData2.z
							#specular2colorintensityed:
								ShaderData3.x
							#diffuse2specmod:
								ShaderData3.y
							#reflectivepower:
								PowerData1.y
							#specularfactor:
								PowerData1.z
							#specularcolorfactor:
								PowerData2.x
							#bumpiness:
								PowerData1.x
							#emissivemultiplier:
								PowerData2.y
							#zshift:
								(PowerData3.x / 1000)
							#parallaxscalebias:
								PowerData3.y
							#fade_thickness:
								PowerData2.z
							#fadeAlphaDist:
								PowerData3.z
							#matdiffusecolor:
								(AsoFText (ColorData01 / 255) SplitString:";")
							#specmapintmask:
								(AsoFText (ColorData02 / 255) SplitString:";")
							#dirtdecalmask:
								(AsoFText (ColorData03 / 255) SplitString:";")
							#subcolor:
								(AsoFText (ColorData04 / 255) SplitString:";")
							#plantColor:
								(AsoFText (ColorData21 / 255) SplitString:";")
							#dirtsampler:
								(GetShaderTexture DiskPath SubDirName Mtl.DirtMap (MapsLocationData2.z == 2))
							#texturesampler2:
								(GetShaderTexture DiskPath SubDirName Mtl.DiffuseMap_2 (MapsLocationData1.y == 2))
							#texturesampler:
								(GetShaderTexture DiskPath SubDirName Mtl.DiffuseMap_1 (MapsLocationData1.x == 2))
							#environmentsampler:
								(GetShaderTexture DiskPath SubDirName Mtl.RefMap (MapsLocationData2.y == 2))
							#bumpsampler:
								(GetShaderTexture DiskPath SubDirName Mtl.NormalMap (MapsLocationData1.z == 2))
							#specsampler:
								(GetShaderTexture DiskPath SubDirName Mtl.SpecMap (MapsLocationData2.x == 2))
							#texturesampler_layer0:
								(GetShaderTexture DiskPath SubDirName Mtl.BlendLayerMap_1 (MapsLocationData3.x == 2))
							#texturesampler_layer1:
								(GetShaderTexture DiskPath SubDirName Mtl.BlendLayerMap_2 (MapsLocationData3.y == 2))
							#texturesampler_layer2:
								(GetShaderTexture DiskPath SubDirName Mtl.BlendLayerMap_3 (MapsLocationData3.z == 2))
							#texturesampler_layer3:
								(GetShaderTexture DiskPath SubDirName Mtl.BlendLayerMap_4 (MapsLocationData4.x == 2))
							#TextureGrassSampler:
								(GetShaderTexture DiskPath SubDirName Mtl.GrassMap (MapsLocationData4.y == 2))
							#dimmerset:
								"0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0;0.0"
							#matGrassTransform:
								"1.0;0.0;0.0;0.0;0.0;1.0;0.0;0.0;0.0;0.0;1.0;0.0;0.0;0.0;0.0;0.0"
							#vecCameraPos:
								"0.0;0.0;0.0;0.0"
							#gWorldInstanceMatrix:
								"0.0;0.0;0.0;0.0"
							#gWorldInstanceInverseTranspose:
								"0.0;0.0;0.0;0.0"
							default:
								throw ("Unknown parameter: " + Params[ParamID] as String)
						)
					)
				)
				(AsoFText Result)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	struct strMAXFactory (
		ObjectMgr = strObjectMgr(),
		MaterialOps = strMaterialOps(),
		PathsEmulator = strPathsEmulator()
	)
	GIMS.CurrentGame.Core.MAXFactory = strMAXFactory()
/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
