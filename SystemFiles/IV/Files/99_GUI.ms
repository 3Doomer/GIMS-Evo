/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
	(
		local	DialogsToDestroy = #(
					EGIMS_IV_matlist,
					EGIMS_IV_mateditor,
					EGIMS_IV_coleditor,
					EGIMS_IV_BlendProps
				)
		for Dialog in DialogsToDestroy where Have Dialog do
			DestroyDialog Dialog
	)
	rollout EGIMS_IV_edit_diffall "Diffuse" (
		local TheMtl
		label l_diffmap "1st diffuse" align:#left across:3 offset:[0, 3] enabled:false
		button c_diffmap "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_d labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		label l_diffmapd2 "2nd diffuse" align:#left across:3 offset:[0, 3] enabled:false
		button c_diffmapd2 "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_d2 labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		colorpicker c_diffcolor "Diffuse color" default:white width:260 align:#left enabled:false
		
		on c_diffmap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmap #DiffuseMap_1
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmapd2 rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmapd2 #DiffuseMap_2
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmap #DiffuseMap_1
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmapd2 pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmapd2 #DiffuseMap_2
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_d changed State do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [1, 1] State)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_d2 changed State do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [1, 2] State)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffcolor changed Col do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			local	ValueOps = GIMS.Core.ValueOps
			TheMtl.ColorData = (ValueOps.UpdateMatrix TheMtl.ColorData 1 (ValueOps.TypeCast Col Point3))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_lightpow "Luminescence" (
		local TheMtl
		label l_lightpower "Power" align:#left across:3 enabled:false
		slider c_lightpower type:#Float orient:#horizontal range:[0,100,0] ticks:5 align:#left width:130 enabled:false
		edittext t_lightpower text:(c_lightpower.value as String) width:60 align:#right enabled:false
		label l_zshift "Z-shift" align:#left across:3 enabled:false
		slider c_zshift type:#Float orient:#horizontal range:[0.0001,0.001,0] ticks:5 align:#left width:130 enabled:false
		edittext t_zshift text:(c_zshift.value as String) width:60 align:#right enabled:false
		
		on c_lightpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				t_lightpower.text = (power as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 2] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_lightpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				try
					c_lightpower.value = (power as Float)
				catch
					t_lightpower.text = (c_lightpower.value as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 2] c_lightpower.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_zshift changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				t_zshift.text = (power as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 1] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_zshift changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				try
					c_zshift.value = (power as Float)
				catch
					t_zshift.text = (c_zshift.value as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 1] c_zshift.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_dirtmask "Dirt" (
		local TheMtl
		label l_dirtmap "Dirt map" align:#left across:3 offset:[0, 3] enabled:false
		button c_dirtmap "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_dirt labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		colorpicker c_dirtmask "Dirt mask" default:white width:260 align:#left enabled:false
		
		on c_dirtmap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_dirtmap #DirtMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_dirtmap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_dirtmap #DirtMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_dirt changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [2, 3] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_dirtmask changed col do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			local	ValueOps = GIMS.Core.ValueOps
			TheMtl.ColorData = (ValueOps.UpdateMatrix TheMtl.ColorData 3 (ValueOps.TypeCast col Point3))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_skincolor "Skin color" (
		local TheMtl
		colorpicker c_skincolor default:white width:260 align:#center
		on c_skincolor changed col do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ValueOps = GIMS.Core.ValueOps
				TheMtl.ColorData = (ValueOps.UpdateMatrix TheMtl.ColorData 4 (ValueOps.TypeCast col Point3))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_fadeth "Fade thickness" (
		local TheMtl
		slider c_thickness type:#Float orient:#horizontal range:[0,1,0.5] ticks:10 align:#left width:200 across:2
		edittext t_thickness text:(c_thickness.value as String) width:60 align:#right
		on c_thickness changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_thickness.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 3] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_thickness changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_thickness.value = (power as Float)
			catch
				t_thickness.text = (c_thickness.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 3] c_thickness.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_refall "Reflection" (
		local TheMtl
		label l_envmap "Ref. map" align:#left across:3 offset:[0, 3] enabled:false
		button c_envmap "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_e labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		label l_refpower "Power" align:#left across:3 enabled:false
		slider c_refpower type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
		edittext t_refpower text:(c_refpower.value as String) width:60 align:#right enabled:false
		label l_reflectivepowered "Ref. power" align:#left across:3 enabled:false enabled:false
		slider c_reflectivepowered type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
		edittext t_reflectivepowered text:(c_reflectivepowered.value as String) width:60 align:#right enabled:false
		
		on c_envmap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_envmap #RefMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_envmap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_envmap #RefMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_e changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [2, 2] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_refpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_refpower.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 2] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_refpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_refpower.value = (power as Float)
			catch
				t_refpower.text = (c_refpower.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 2] c_refpower.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_reflectivepowered changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_reflectivepowered.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 2] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_reflectivepowered changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_reflectivepowered.value = (power as Float)
			catch
				t_reflectivepowered.text = (c_reflectivepowered.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 2] c_reflectivepowered.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_bumpall "Normal bump" (
		local TheMtl
		label l_bumpmap "Norm. map" align:#left across:3 offset:[0, 3] enabled:false
		button c_bumpmap "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_b labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		label l_bumppower "Power" align:#left across:3 enabled:false enabled:false
		slider c_bumppower type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
		edittext t_bumppower text:(c_bumppower.value as String) width:60 align:#right enabled:false
		label l_parallaxscale "Parallax bias" align:#left across:3 enabled:false enabled:false
		slider c_parallaxscale type:#Float orient:#horizontal range:[0,1,0.04] ticks:5 align:#left width:130 enabled:false
		edittext t_parallaxscale text:(c_parallaxscale.value as String) width:60 align:#right enabled:false
		
		on c_bumpmap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_bumpmap #NormalMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_bumpmap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_bumpmap #NormalMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_b changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [1, 3] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_bumppower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_bumppower.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 1] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_bumppower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_bumppower.value = (power as Float)
			catch
				t_bumppower.text = (c_bumppower.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 1] c_bumppower.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_parallaxscale changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_parallaxscale.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 2] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_parallaxscale changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_parallaxscale.value = (power as Float)
			catch
				t_parallaxscale.text = (c_parallaxscale.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 2] c_parallaxscale.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_specall "Specular" (
		local TheMtl
		label l_specmap "Spec. map" align:#left across:3 offset:[0, 3] enabled:false
		button c_specmap "Empty" width:145 align:#right enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_s labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		label l_specpower "Spec. map power" align:#left across:3 enabled:false enabled:false
		slider c_specpower type:#Float orient:#horizontal range:[0,100,100] ticks:5 align:#left width:130 enabled:false
		edittext t_specpower text:(c_specpower.value as String) width:60 align:#right across:2 enabled:false
		label l_speccolpower "Specularity" align:#left across:3 enabled:false enabled:false
		slider c_speccolpower type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
		edittext t_speccolpower text:(c_speccolpower.value as String) width:60 align:#right enabled:false
		colorpicker c_specmask "Specular mask" default:white width:260 align:#left enabled:false
		group "Vehicle" (
			label l_specularfactored "Spec. map power" align:#left across:3 enabled:false enabled:false
			slider c_specularfactored type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
			edittext t_specularfactored text:(c_specularfactored.value as String) width:60 align:#right enabled:false
			label l_specularcolorfactored "Specularity" align:#left across:3 enabled:false enabled:false
			slider c_specularcolorfactored type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
			edittext t_specularcolorfactored text:(c_specularcolorfactored.value as String) width:60 align:#right enabled:false
			label l_diffuse2specmod "2nd spec. diffuse" align:#left across:3 enabled:false enabled:false
			slider c_diffuse2specmod type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
			edittext t_diffuse2specmod text:(c_diffuse2specmod.value as String) width:60 align:#right enabled:false
			label l_specular2factored "2nd spec. map" align:#left across:3 enabled:false enabled:false
			slider c_specular2factored type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
			edittext t_specular2factored text:(c_specular2factored.value as String) width:60 align:#right enabled:false
			label l_specular2colorintensityed "2nd specularity" align:#left across:3 enabled:false enabled:false
			slider c_specular2colorintensityed type:#Float orient:#horizontal range:[0,1,1] ticks:5 align:#left width:130 enabled:false
			edittext t_specular2colorintensityed text:(c_specular2colorintensityed.value as String) width:60 align:#right enabled:false
		)
		
		on c_specmap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_specmap #SpecMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specmap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_specmap #SpecMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specmask changed col do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ValueOps = GIMS.Core.ValueOps
				TheMtl.ColorData = (ValueOps.UpdateMatrix TheMtl.ColorData 2 (ValueOps.TypeCast col Point3))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_s changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [2, 1] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_specpower.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 3] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_specpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_specpower.value = (power as Float)
			catch
				t_specpower.text = (c_specpower.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [1, 3] c_specpower.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_speccolpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_speccolpower.text = (power as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 1] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_speccolpower changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_speccolpower.value = (power as Float)
			catch
				t_speccolpower.text = (c_speccolpower.value as String)
			TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [2, 1] c_speccolpower.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specular2colorintensityed changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_specular2colorintensityed.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [3, 1] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_specular2colorintensityed changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_specular2colorintensityed.value = (power as Float)
			catch
				t_specular2colorintensityed.text = (c_specular2colorintensityed.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [3, 1] c_specular2colorintensityed.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffuse2specmod changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_diffuse2specmod.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [3, 2] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_diffuse2specmod changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_diffuse2specmod.value = (power as Float)
			catch
				t_diffuse2specmod.text = (c_diffuse2specmod.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [3, 2] c_diffuse2specmod.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specularcolorfactored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_specularcolorfactored.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 1] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_specularcolorfactored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_specularcolorfactored.value = (power as Float)
			catch
				t_specularcolorfactored.text = (c_specularcolorfactored.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 1] c_specularcolorfactored.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specular2factored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_specular2factored.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 3] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_specular2factored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_specular2factored.value = (power as Float)
			catch
				t_specular2factored.text = (c_specular2factored.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [2, 3] c_specular2factored.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_specularfactored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			t_specularfactored.text = (power as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [1, 3] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_specularfactored changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			try
				c_specularfactored.value = (power as Float)
			catch
				t_specularfactored.text = (c_specularfactored.value as String)
			TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [1, 3] c_specularfactored.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_BlendProps "Blend painter options" Width:250 (
		Spinner 	Radius			"Radius"		Type:#Float	Range:[0, 10000, EGIMS_IV_matlist.Radius]	Width:100	Across:2
		Spinner		Strength		"Strength"	Type:#Float	Range:[0, 1, EGIMS_IV_matlist.Strength]	Width:100
		Slider		TreeDepth		"Interaction speed"	Type:#Integer	Range:[2, 10, ThePainterInterface.TreeDepth]	Ticks:8	Width:235	Align:#Left
		Group "Viewport drawing" (
			CheckBox	DrawRing	"Ring"		Checked:ThePainterInterface.DrawRing	Across:2
			CheckBox	DrawNormal	"Normal"	Checked:ThePainterInterface.DrawNormal
			CheckBox	DrawTrace	"Trace"	Checked:ThePainterInterface.DrawTrace
		)
		on Radius Changed Val do (
			EGIMS_IV_matlist.Radius = Val
			ThePainterInterface.MaxSize = Val
		)
		on Strength Changed Val do
			EGIMS_IV_matlist.Strength = Val
		on TreeDepth Changed Val do
			ThePainterInterface.TreeDepth = Val
		on DrawRing Changed State do
			ThePainterInterface.DrawRing = State
		on DrawNormal Changed State do
			ThePainterInterface.DrawNormal = State
		on DrawTrace Changed State do
			ThePainterInterface.DrawTrace = State
	)
	rollout EGIMS_IV_edit_blendall "Blending" (
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
		label l_diffmap1 "1st layer" align:#left across:3 offset:[0, 3]
		button c_diffmap1 "Empty" align:#right width:150 toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_1 labels:#("Dictionary","Include") columns:1 align:#right
		label l_diffmap2 "2nd layer" align:#left across:3 offset:[0, 3]
		button c_diffmap2 "Empty" align:#right width:150 toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_2 labels:#("Dictionary","Include") columns:1 align:#right
		label l_diffmap3 "3rd layer" align:#left across:3 enabled:false offset:[0, 3]
		button c_diffmap3 "Empty" align:#right width:150 enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_3 labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		label l_diffmap4 "4th layer" align:#left across:3 enabled:false offset:[0, 3]
		button c_diffmap4 "Empty" align:#right width:150 enabled:false toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_4 labels:#("Dictionary","Include") columns:1 align:#right enabled:false
		group "Editor" (
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
		)
		GroupBox lgb "Current layer" Pos:[EraseLyr.Pos.x - 12.5, EraseLyr.Pos.y - 15] Width:85 Height:70
		GroupBox lgbf "All layers" Pos:[EraseAll.Pos.x - 12.5,EraseAll.Pos.y - 15] Width:85 Height:70
		
		on c_diffmap1 rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmap1 #BlendLayerMap_1
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap2 rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmap2 #BlendLayerMap_2
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap3 rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmap3 #BlendLayerMap_3
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap4 rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_diffmap4 #BlendLayerMap_4
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap1 pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmap1 #BlendLayerMap_1
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap2 pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmap2 #BlendLayerMap_2
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap3 pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmap3 #BlendLayerMap_3
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_diffmap4 pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_diffmap4 #BlendLayerMap_4
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_1 changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [3, 1] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_2 changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [3, 2] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_3 changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [3, 3] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_4 changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [4, 1] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		fn BrakePaint = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				PaintBtn.Checked = false
				ThePainterInterface.EndPaintSession()
				DestroyDialog EGIMS_IV_BlendProps
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
				EGIMS_IV_edit_blendall.OnBlend = false
				if EGIMS_IV_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn SetMapPaintData BasePoint = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				Free PaintMapVertIDs
				local	MapChannelID = MapVertPaintData.x,
						Radius = (EGIMS_IV_matlist.Radius / 2),
						Strength = EGIMS_IV_matlist.Strength,
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn SelectLayer = (
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
		on PaintTexID Changed State do (
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
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				throw
			)
		)
		on beopt Pressed do (
			DestroyDialog EGIMS_IV_BlendProps
			CreateDialog EGIMS_IV_BlendProps Style:#(#style_titlebar, #style_border, #style_sysmenu)
		)
		fn FillChannel ID:unsupplied Factor:0 = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		on FillLyr Pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				FillChannel Factor:1
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EraseLyr Pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				FillChannel()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on FillAll Pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EraseAll Pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PaintBtn Changed State do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if State then (
					local	FaceSelectModes
					case (ClassOf TheObj.BaseObject) of (
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
								SelectedMtlID = MaterialIDList[EGIMS_IV_matlist.MtlID],
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
						if EGIMS_IV_matlist.OnPreview then
							GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
						EGIMS_IV_edit_blendall.OnBlend = true
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
						GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
						ThePainterInterface.MaxSize = EGIMS_IV_matlist.Radius
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
						MessageBox "Can't edit blending - unknown object type!" title:"GIMS IV material editor"
					)
				) else
					BrakePaint()
				Update TheObj
				RedrawViews()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_edit_blendall Close do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if PaintBtn.State then
					BrakePaint()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_edit_blendall Open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheObj = EGIMS_IV_matlist.TheObj
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_edit_grassall "Grass" (
		local TheMtl
		label l_grassmap "Diffuse" align:#left across:3 offset:[0, 3]
		button c_GrassMap "Empty" width:145 align:#right toolTip:"Empty" offset:[15, 0]
		radiobuttons c_copytex_grass labels:#("Dictionary","Include") columns:1 align:#right
		colorpicker c_PlantColor "Plant color" default:green width:260 align:#left
		label l_FadeAlphaDist "Alpha fade distance" align:#left across:3
		slider c_FadeAlphaDist type:#Float orient:#horizontal range:[0,1,1] ticks:10 align:#left width:130
		edittext t_FadeAlphaDist text:(c_FadeAlphaDist.value as String) width:60 align:#right
		
		on c_GrassMap rightclick do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapRC c_GrassMap #GrassMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_GrassMap pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_mateditor.DoTexmapPress c_GrassMap #GrassMap
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_copytex_grass changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.MapsLocationData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.MapsLocationData [4, 2] state)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_PlantColor changed col do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ValueOps = GIMS.Core.ValueOps
				TheMtl.ColorData2 = (ValueOps.UpdateMatrix TheMtl.ColorData2 1 (ValueOps.TypeCast col Point3))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_FadeAlphaDist changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				t_FadeAlphaDist.text = (power as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 3] power)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on t_FadeAlphaDist changed power do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				try
					c_FadeAlphaDist.value = (power as Float)
				catch
					t_FadeAlphaDist.text = (c_FadeAlphaDist.value as String)
				TheMtl.PowerData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.PowerData [3, 3] c_FadeAlphaDist.value)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_matlist "GIMS IV material editor" Width:250 Height:535 (
		local	TheObj, CpyMtl, CpyTexPath, MtlID, LastMtlID, PrevMtl,
				RC = #(),
				OnPreview = false,
				/*Painter options*/
				Radius = 2,
				Strength = 1,
				/*Material rollouts*/
				Padding = 5,
				ImageSize = [40, 40],
				AccentThickness = 3
				/**/
		Label ObjName "Unknown selection" Pos:[5,20] Align:#Left
		Button LibSave "Save" enabled:false across:2
		Button LibLoad "Load" enabled:false
		SubRollout List Height:-1 Align:#Center
		CheckButton LockCol "< Dock" width:45 height:17 checked:true pos:[0,0] enabled:false
		CheckButton LockSh "Dock >" width:45 height:17 checked:true pos:[205,0] enabled:false
		Timer MtlAddTimer Interval:1 Active:false
		Timer MtlInitTimer Interval:1 Active:false
		fn EditMaterial DestroyEars:false = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if DestroyEars then (
					DestroyDialog EGIMS_IV_mateditor
					DestroyDialog EGIMS_IV_coleditor
				)
				local	Result = true,
						TheObjMaterial = TheObj.Material,
						MaterialList = TheObjMaterial.MaterialList,
						CurrentMaterial = MaterialList[MtlID]
				if not (IsKindOf CurrentMaterial EGIMS_IV_material) then (
					if (QueryBox "Unknown material type.\nConvert to GTA IV material?" Title:"GIMS IV material editor") then (
						TheObjMaterial.MaterialList[MtlID] = (GIMS.IV.Core.MAXFactory.MaterialOps.GetStandartized CurrentMaterial NeedMultiMtl:false)
						List.Rollouts[MtlID].Init MtlID
						EGIMS_IV_matlist.UpdateThumbnail MtlID
						CurrentMaterial = MaterialList[MtlID]
					) else (
						Result = false
						if LastMtlID == MtlID then
							LastMtlID = 0
						EGIMS_IV_matlist.SelectItem LastMtlID
					)
				)
				if Result then (
					List.Rollouts[MtlID].SetSelected true
					local WPos = (GetDialogPos EGIMS_IV_matlist),
							Style = #(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
					CreateDialog EGIMS_IV_mateditor Pos:[WPos.x + 270, WPos.y] Style:Style
					CreateDialog EGIMS_IV_coleditor Pos:[WPos.x - 370, WPos.y] Style:Style
					EGIMS_IV_mateditor.TheObj = TheObj
					EGIMS_IV_coleditor.TheMtl = CurrentMaterial
					EGIMS_IV_mateditor.TheMtl = CurrentMaterial
					EGIMS_IV_mateditor.Init()
					EGIMS_IV_coleditor.Init()
				)
				Result
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn SelectItem Index = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				DestroyDialog EGIMS_IV_mateditor
				DestroyDialog EGIMS_IV_coleditor
				local	MatCount = TheObj.Material.MaterialList.Count,
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateThumbnail Index Preview:false = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				DisableSceneRedraw()
				--SuspendEditing()
				Callbacks.RemoveScripts #selectionSetChanged id:#EGIMS_IV_matlist_GetMaterial
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
						Sample = (GeoSphere Pos:[0.0, 0.0, 0.0] Radius:25 Segments:3 BaseType:2 MapCoords:true RealWorldMapSize:false WireColor:White),
						BGPlane = (Plane Dir:CamDir Pos:(CamDir * (-25)) Width:80.02 Length:80.02 WidthSegs:1 LengthSegs:1 MapCoords:true RealWorldMapSize:false WireColor:White),
						RenderLights = #(
							(OmniLight Pos:[-100.0, -100.0, 300.0] Multiplier:1.0),
							(OmniLight Pos:[50.0, 0.0, -100.0] Multiplier:1.0)
						)
				for MatID in Indices do (
					local	MapSlot = Rollouts[MatID].MaterialBMP,
							CurrentMtl = MaterialList[MatID],
							ShowInViewport = (
								if Have CurrentMtl then
									CurrentMtl.ShowInViewport
							),
							PicSize = (
								if Preview then
									[512, 512]
								else
									[MapSlot.Width, MapSlot.Height]
							)
					if Have ShowInViewport then
						CurrentMtl.ShowInViewport = true
					BGPlane.Material = CurrentMtl
					Sample.Material = CurrentMtl
					local	TheBMP = (Render Camera:Cam OutputSize:PicSize VFB:Preview)
					if Have ShowInViewport then
						CurrentMtl.ShowInViewport = ShowInViewport
					if not Preview then
						MapSlot.BitMap = TheBMP
				)
				Delete Cam
				Delete Sample
				Delete BGPlane
				Delete RenderLights
				UnHide OldShownObjects
				Select OldSelection
				for LightID = 1 to LightStateFlagHolders.count do
					LightStateFlagHolders[LightID].On = LightStates[LightID]
				Callbacks.AddScript #selectionSetChanged "EGIMS_IV_matlist.GetMaterialList()" ID:#EGIMS_IV_matlist_GetMaterial
				ResumeEditing()
				EnableSceneRedraw()
			/*<ERRHANDLER>*//*) catch (
				ResumeEditing()
				EnableSceneRedraw()
				GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw
				throw
			)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn DeleteMaterial Index = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn InitMatRollout Index = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	MaterialRolloutName = (GIMS.IV.Core.GUI.MaterialRolloutName + (Index as String)),
						MaterialRollout = (Execute MaterialRolloutName)
				if Have MaterialRollout then
					MaterialRollout.Init Index
				else
					throw (Append "Can't find material rollout " MaterialRolloutName)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn AddMatRollout Index = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	GUI = GIMS.IV.Core.GUI,
						MaterialRolloutName = (GUI.MaterialRolloutName + (Index as String)),
						MaterialRollout = (Execute MaterialRolloutName)
				if Have MaterialRollout then (
					MaterialRollout.Open = false
					MaterialRollout.TheObj = undefined
					MaterialRollout.Title = "...loading..."
				) else (
					local	MaterialRolloutCode = (StringStream "")
					Format GUI.MaterialRolloutCode Index Index Index Index To:MaterialRolloutCode
					MaterialRollout = (Execute (MaterialRolloutCode as String))
					Free MaterialRolloutCode
				)
				if not MaterialRollout.isDisplayed then
					AddSubRollout List MaterialRollout
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn LoadList = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MtlAddTimer.Ticks = 0
				MtlAddTimer.Active = true
				MtlInitTimer.Ticks = 0
				MtlInitTimer.Active = true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn ClearList = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Rollouts = List.Rollouts
				for i = Rollouts.Count to 1 by -1 do
					RemoveSubRollout List Rollouts[i]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn UpdateHeader = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn FixGUI = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				List.Width = (EGIMS_IV_matlist.Width - (Padding * 2))
				List.Pos.x = Padding
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn GetMaterialList = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MtlAddTimer.Active = false
				MtlInitTimer.Active = false
				FixGUI()
				if EGIMS_IV_edit_blendall.OnBlend then
					EGIMS_IV_edit_blendall.BrakePaint()
				if EGIMS_IV_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
				DestroyDialog EGIMS_IV_mateditor
				DestroyDialog EGIMS_IV_coleditor
				local	Result = false
				if Selection.Count == 1 then (
					local	BaseObject = $.BaseObject
					if 	
						IsKindOf BaseObject Editable_Poly or
						IsKindOf BaseObject Editable_Mesh or
						IsKindOf BaseObject EGIMS_IV_Car_Wheel or
						IsKindOf BaseObject GIMS_IV_Col_Box or
						IsKindOf BaseObject GIMS_IV_Col_Sphere or
						IsKindOf BaseObject GIMS_IV_Col_Capsule
					then
						Result = true
				)
				ClearList()
				if Result then (
					LibSave.Enabled = true
					LibLoad.Enabled = true
					TheObj = $
					MtlID = 0
					LastMtlID = 0
					if (ClassOf TheObj.Material) != MultiMaterial then (
						TheObj.Material = (
							MultiMaterial \
							Name:TheObj.Name \
							Material:#(TheObj.Material) \
							Names:#(TheObj.Material.Name) \
						)
					)
					LoadList()
				) else (
					LibSave.Enabled = false
					LibLoad.Enabled = false
					TheObj = undefined
				)
				UpdateHeader()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
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
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
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
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			)
			OK
		)
		on LibSave pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if not (IsDeleted TheObj) then (
					local	LibPath = (GetSaveFileName Caption:"Save GIMS IV material library" Types:"GIMS IV material library (*.GIVEML)|*.GIVEML")
					if Have LibPath then (
						GIMS.Core.CacheMgr.Write TheObj.Material LibPath
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted!" title:"GIMS IV material editor"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LibLoad pressed do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if not (IsDeleted TheObj) then (
					local LibPath = (GetOpenFileName Caption:"Load GIMS IV material library" Types:"GIMS IV material library (*.GIVEML)|*.GIVEML")
					if Have LibPath then (
						TheObj.Material = (FileIn LibPath)
						GetMaterialList()
						GIMS.Core.SystemMgr.CheckResult KeepLayout:true
					)
				) else
					MessageBox "Failed: object's deleted!" title:"GIMS IV material editor"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LockCol changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_IV_matlist)
					SetDialogPos EGIMS_IV_coleditor [(NewPos.x - (GetDialogSize EGIMS_IV_coleditor).x - 20), NewPos.y]
				)
				EGIMS_IV_coleditor.LockCol.checked = state
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on LockSh changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_IV_matlist)
					SetDialogPos EGIMS_IV_mateditor [(NewPos.x + (GetDialogSize EGIMS_IV_matlist).x + 20), NewPos.y]
				)
				EGIMS_IV_mateditor.LockSh.checked = state
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on EGIMS_IV_matlist moved NewPos do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if LockSh.checked then
					SetDialogPos EGIMS_IV_mateditor [(NewPos.x + (GetDialogSize EGIMS_IV_matlist).x + 20), NewPos.y]
				if LockCol.checked then
					SetDialogPos EGIMS_IV_coleditor [(NewPos.x - (GetDialogSize EGIMS_IV_coleditor).x - 20), NewPos.y]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_matlist Open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				List.Height = (EGIMS_IV_matlist.Height - List.Pos.y - 5)
				Callbacks.AddScript #selectionSetChanged "EGIMS_IV_matlist.GetMaterialList()" ID:#EGIMS_IV_matlist_GetMaterial
				GetMaterialList()
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_matlist Close do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MtlAddTimer.Active = false
				MtlInitTimer.Active = false
				MtlID = 0
				Callbacks.RemoveScripts #selectionSetChanged id:#EGIMS_IV_matlist_GetMaterial
				DestroyDialog EGIMS_IV_mateditor
				DestroyDialog EGIMS_IV_coleditor
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_coleditor "Collision and navigation" Width:350 Height:535 (
		local	TheMtl, ColFlagControlIDs, NavFlag1ControlIDs, NavFlag2ControlIDs
		listbox c_matgrp "Type" selection:1 height:15 Offset:[0, 16] across:2
		listbox c_matlst "Material" selection:1 height:15 Offset:[0, 16]
		dropdownlist c_unk1 "Procedural material" selection:1 height:15
		group "Collision flags" (
			checkbox mflag_1 "Interior peds" across:3
			checkbox mflag_2 "unk 2"
			checkbox mflag_3 "unk 3"
			checkbox mflag_4 "unk 4" across:3
			checkbox mflag_5 "unk 5"
			checkbox mflag_6 "unk 6"
			checkbox mflag_7 "unk 7" across:3
			checkbox mflag_8 "unk 8"
			checkbox m1flag_1 "Stairs"
			checkbox m1flag_2 "unk 2" across:3
			checkbox m1flag_3 "unk 3"
			checkbox m1flag_4 "Ignore shots"
			checkbox m1flag_5 "unk 5" across:3
			checkbox m1flag_6 "unk 6"
			checkbox m1flag_7 "Ignore camera"
			checkbox m1flag_8 "unk 8" across:3
			label l1
			label l2
		)
		group "Navigation" (
			Label	ls	"Surface:"	Align:#Left
			checkbox nmflag_r0_2 "Crossroads" Across:2
			checkbox nmflag_r0_3 "Pavement"
			Label	lg	"Ped generation:"	Align:#Left
			checkbox nmflag_r1 "Walking" Across:3
			checkbox nmflag_r2 "Standing"
			checkbox nmflag_r3 "Dangerous place"
		)
		checkbutton LockCol "Dock >" width:45 height:17 checked:true pos:[305,0]
		fn Init = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local DBIndex = (TheMtl.FindDBIndex()),
						DBIndexX = DBIndex.x,
						CollisionData1 = TheMtl.CollisionData[1],
						NavData = TheMtl.NavData,
						DB = GIMS.IV.Core.DB,
						ColMaterials = DB.ColMaterials
				c_matgrp.Items = ColMaterials[1]
				c_matlst.items = ColMaterials[3][DBIndexX]
				c_unk1.Items = DB.ProcMaterials
				c_matgrp.selection = DBIndexX
				c_matlst.selection = (DBIndex.y as Integer)
				c_unk1.selection = (CollisionData1.y as Integer + 1)
				local	ColFlagMask = #{1..16},
						NavFlag1Mask = #{2, 3},
						NavFlag2Mask = #{1..3},
						AsBitArray = GIMS.Core.ValueOps.AsBitArray,
						CollisionData1Flags = (AsBitArray (CollisionData1.z as Integer) Range:ColFlagMask),
						BitGet = Bit.Get,
						NavDataX = (NavData.x as Integer),
						NavData1Flags = #{},
						NavData2Flags = (AsBitArray (NavData.y as Integer) Range:NavFlag2Mask),
						Controls = EGIMS_IV_coleditor.Controls,
						ColControlStartID = (FindItem Controls mflag_1),
						Nav1ControlStartID = (FindItem Controls nmflag_r0_2),
						Nav2ControlStartID = (FindItem Controls nmflag_r1),
						SetControlProperties = GIMS.Core.GUI.SetControlProperties,
						Iterator = 1
				ColFlagControlIDs = #{ColControlStartID..(ColControlStartID + 15)}
				NavFlag1ControlIDs = #{Nav1ControlStartID..(Nav1ControlStartID + 1)}
				NavFlag2ControlIDs = #{Nav2ControlStartID..(Nav2ControlStartID + 2)}
				for i in NavFlag1Mask do (
					NavData1Flags[Iterator] = (BitGet NavDataX i)
					Iterator += 1
				)
				SetControlProperties Controls #Checked CollisionData1Flags ControlIDs:ColFlagControlIDs
				SetControlProperties Controls #Checked NavData1Flags ControlIDs:NavFlag1ControlIDs
				SetControlProperties Controls #Checked NavData2Flags ControlIDs:NavFlag2ControlIDs
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		on c_matgrp selected id do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ColMaterials = GIMS.IV.Core.DB.ColMaterials
				c_matlst.items = ColMaterials[3][id]
				if ColMaterials[4][id].Count > c_matlst.selection then
					c_matlst.selection = 1
				TheMtl.CollisionData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.CollisionData [1, 1] ColMaterials[4][id][c_matlst.selection])
				c_matlst.Selection = ((TheMtl.FindDBIndex()).y as Integer)
				if
					No TheMtl.DiffuseMap_1 and
					No TheMtl.BlendLayerMap_1
				then
					TheMtl.delegate.diffuse = ColMaterials[2][id]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_matlst selected id do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.CollisionData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.CollisionData [1, 1] GIMS.IV.Core.DB.ColMaterials[4][c_matgrp.selection][id])
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on c_unk1 selected id do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.CollisionData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.CollisionData [1, 2] (id - 1))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_coleditor open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.LockCol.enabled = true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_coleditor close do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.LockCol.enabled = false
				local	GetControlProperties = GIMS.Core.GUI.GetControlProperties,
						Controls = EGIMS_IV_coleditor.Controls,
						CollisionData1Flags = (GetControlProperties Controls #Checked ControlIDs:ColFlagControlIDs AsBitArray:true),
						NavData1Flags = (GetControlProperties Controls #Checked ControlIDs:NavFlag1ControlIDs AsBitArray:true),
						NavData2Flags = (GetControlProperties Controls #Checked ControlIDs:NavFlag2ControlIDs AsBitArray:true)
				local	ColFlagMask = #{1..16},
						NavFlag1Mask = #{2, 3},
						NavFlag2Mask = #{1..3},
						BitArrayAsValue = GIMS.Core.ArrayOps.BitArrayAsValue,
						CollisionData1z = (BitArrayAsValue CollisionData1Flags Range:ColFlagMask),
						NavDatax = 0,
						NavDatay = (BitArrayAsValue NavData2Flags Range:NavFlag2Mask),
						BitSet = Bit.Set,
						Iterator = 1
				for i in NavFlag1Mask do (
					NavDatax = (BitSet NavDatax i NavData1Flags[Iterator])
					Iterator += 1
				)
				TheMtl.CollisionData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.CollisionData [1, 3] CollisionData1z)
				TheMtl.NavData = [NavDatax, NavDatay, TheMtl.NavData.z]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LockCol changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_IV_coleditor)
					SetDialogPos EGIMS_IV_matlist [(NewPos.x + (GetDialogSize EGIMS_IV_coleditor).x + 20), NewPos.y]
				)
				EGIMS_IV_matlist.LockCol.checked = state
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on EGIMS_IV_coleditor moved NewPos do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if LockCol.checked then
					SetDialogPos EGIMS_IV_matlist [(NewPos.x + (GetDialogSize EGIMS_IV_coleditor).x + 20), NewPos.y]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rcmenu EGIMS_IV_TexMapRC (
		MenuItem cpy "Copy" enabled:(Have EGIMS_IV_matlist.RC[3])
		MenuItem pst "Paste" enabled:(Have EGIMS_IV_matlist.CpyTexPath)
		MenuItem clr "Clear"
		MenuItem Preview "Preview" enabled:(Have EGIMS_IV_matlist.RC[3])
		
		on cpy picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.CpyTexPath = EGIMS_IV_matlist.RC[3].FileName
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on pst picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
			local	CpyTexPath = EGIMS_IV_matlist.CpyTexPath,
					TheBMP = (try (OpenBitmap CpyTexPath)	catch undefined)
			if Have TheBMP then (
				local	TexMapData = EGIMS_IV_matlist.RC[1]
				SetProperty TexMapData[1] TexMapData[2] (bitmaptexture bitmap:TheBMP)
				local	TexMapBtn = EGIMS_IV_matlist.RC[2]
				TexMapBtn.tooltip = CpyTexPath
				TexMapBtn.caption = (FileNameFromPath CpyTexPath)
			) else
				MessageBox ("Can't load the texture from \"" + CpyTexPath + "\" file!") title:"GIMS IV material editor"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on clr picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TexMapData = EGIMS_IV_matlist.RC[1]
				SetProperty TexMapData[1] TexMapData[2] undefined
				local	TexMapBtn = EGIMS_IV_matlist.RC[2]
				TexMapBtn.tooltip = (TexMapBtn.caption = "Empty")
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on Preview picked do (
			try
				Display EGIMS_IV_matlist.RC[3]
			catch
				MessageBox "Can't load the texture!" title:"GIMS IV texture map preview"
		)
		on EGIMS_IV_TexMapRC Open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	TexMapData = EGIMS_IV_matlist.RC[1]
				clr.Enabled = (Have (GetProperty TexMapData[1] TexMapData[2]))
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rollout EGIMS_IV_mateditor "Model" Width:350 Height:176 (
		local	TheObj, TheMtl, Shaders,
				SubRols = #(
					EGIMS_IV_edit_diffall,
					EGIMS_IV_edit_bumpall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_refall,
					EGIMS_IV_edit_lightpow,
					EGIMS_IV_edit_fadeth,
					EGIMS_IV_edit_dirtmask,
					EGIMS_IV_edit_skincolor,
					EGIMS_IV_edit_blendall,
					EGIMS_IV_edit_grassall
				),
				SubRolParamNames = #(
					#bumpiness,
					#bumpsampler,
					#diffuse2specmod,
					#dimmerset,
					#dirtdecalmask,
					#dirtsampler,
					#emissivemultiplier,
					#environmentsampler,
					#fade_thickness,
					#fadeAlphaDist,
					#gWorldInstanceInverseTranspose,
					#gWorldInstanceMatrix,
					#matdiffusecolor,
					#matGrassTransform,
					#parallaxscalebias,
					#plantColor,
					#reflectivepower,
					#reflectivepowered,
					#specmapintmask,
					#specsampler,
					#specular2colorintensityed,
					#specular2factored,
					#specularcolorfactor,
					#specularcolorfactored,
					#specularfactor,
					#specularfactored,
					#subcolor,
					#TextureGrassSampler,
					#texturesampler,
					#texturesampler2,
					#texturesampler_layer0,
					#texturesampler_layer1,
					#texturesampler_layer2,
					#texturesampler_layer3,
					#vecCameraPos,
					#zshift
				),
				SubRolParamRols = #(
					EGIMS_IV_edit_bumpall,
					EGIMS_IV_edit_bumpall,
					EGIMS_IV_edit_specall,
					undefined,
					EGIMS_IV_edit_dirtmask,
					EGIMS_IV_edit_dirtmask,
					EGIMS_IV_edit_lightpow,
					EGIMS_IV_edit_refall,
					EGIMS_IV_edit_fadeth,
					EGIMS_IV_edit_grassall,
					undefined,
					undefined,
					EGIMS_IV_edit_diffall,
					undefined,
					EGIMS_IV_edit_bumpall,
					EGIMS_IV_edit_grassall,
					EGIMS_IV_edit_refall,
					EGIMS_IV_edit_refall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_specall,
					EGIMS_IV_edit_skincolor,
					EGIMS_IV_edit_grassall,
					EGIMS_IV_edit_diffall,
					EGIMS_IV_edit_diffall,
					EGIMS_IV_edit_blendall,
					EGIMS_IV_edit_blendall,
					EGIMS_IV_edit_blendall,
					EGIMS_IV_edit_blendall,
					undefined,
					EGIMS_IV_edit_lightpow
				),
				SubRolParamActions = #(
					#(
						#(#l_bumppower, #enabled, true),
						#(#c_bumppower, #enabled, true),
						#(#t_bumppower, #enabled, true),
						#(#c_bumppower, #value, #(#PowerData, 1, 1)),
						#(#t_bumppower, #text, #(undefined, undefined, String))
					), #(
						#(#l_bumpmap, #enabled, true),
						#(#c_bumpmap, #enabled, true),
						#(#c_copytex_b, #enabled, true),
						#(#c_copytex_b, #state, #(#MapsLocationData, 1, 3)),
						#(#c_bumpmap, undefined, #NormalMap)
					), #(
						#(#l_diffuse2specmod, #enabled, true),
						#(#c_diffuse2specmod, #enabled, true),
						#(#t_diffuse2specmod, #enabled, true),
						#(#c_diffuse2specmod, #value, #(#ShaderData, 3, 2)),
						#(#t_diffuse2specmod, #text, #(undefined, undefined, String))
					),
					undefined,
					#(
						#(#c_dirtmask, #enabled, true),
						#(#c_dirtmask, #color, #(#ColorData, 3, Color))
					), #(
						#(#l_dirtmap, #enabled, true),
						#(#c_dirtmap, #enabled, true),
						#(#c_copytex_dirt, #enabled, true),
						#(#c_copytex_dirt, #state, #(#MapsLocationData, 2, 3)),
						#(#c_dirtmap, undefined, #DirtMap)
					), #(
						#(#l_lightpower, #enabled, true),
						#(#c_lightpower, #enabled, true),
						#(#t_lightpower, #enabled, true),
						#(#c_lightpower, #value, #(#PowerData, 2, 2)),
						#(#t_lightpower, #text, #(undefined, undefined, String))
					), #(
						#(#l_envmap, #enabled, true),
						#(#c_envmap, #enabled, true),
						#(#c_copytex_e, #enabled, true),
						#(#c_copytex_e, #state, #(#MapsLocationData, 2, 2)),
						#(#c_envmap, undefined, #RefMap)
					), #(
						#(#c_thickness, #value, #(#PowerData, 2, 3)),
						#(#t_thickness, #text, #(undefined, undefined, String))
					), #(
						#(#c_FadeAlphaDist, #value, #(#PowerData, 3, 3)),
						#(#t_FadeAlphaDist, #text, #(undefined, undefined, String))
					),
					undefined,
					undefined,
					#(
						#(#c_diffcolor, #enabled, true),
						#(#c_diffcolor, #color, #(#ColorData, 1, Color))
					),
					undefined,
					#(
						#(#l_parallaxscale, #enabled, true),
						#(#c_parallaxscale, #enabled, true),
						#(#t_parallaxscale, #enabled, true),
						#(#c_parallaxscale, #value, #(#PowerData, 3, 2)),
						#(#t_parallaxscale, #text, #(undefined, undefined, String))
					), #(
						#(#c_PlantColor, #color, #(#ColorData2, 1, Color))
					), #(
						#(#l_refpower, #enabled, true),
						#(#c_refpower, #enabled, true),
						#(#t_refpower, #enabled, true),
						#(#c_refpower, #value, #(#PowerData, 1, 2)),
						#(#t_refpower, #text, #(undefined, undefined, String))
					), #(
						#(#l_reflectivepowered, #enabled, true),
						#(#c_reflectivepowered, #enabled, true),
						#(#t_reflectivepowered, #enabled, true),
						#(#c_reflectivepowered, #value, #(#ShaderData, 2, 2)),
						#(#t_reflectivepowered, #text, #(undefined, undefined, String))
					), #(
						#(#c_specmask, #enabled, true),
						#(#c_specmask, #color, #(#ColorData, 2, Color))
					), #(
						#(#l_specmap, #enabled, true),
						#(#c_specmap, #enabled, true),
						#(#c_copytex_s, #enabled, true),
						#(#c_copytex_s, #state, #(#MapsLocationData, 2, 1)),
						#(#c_specmap, undefined, #SpecMap)
					), #(
						#(#l_specular2colorintensityed, #enabled, true),
						#(#c_specular2colorintensityed, #enabled, true),
						#(#t_specular2colorintensityed, #enabled, true),
						#(#c_specular2colorintensityed, #value, #(#ShaderData, 3, 1)),
						#(#t_specular2colorintensityed, #text, #(undefined, undefined, String))
					), #(
						#(#l_specular2factored, #enabled, true),
						#(#c_specular2factored, #enabled, true),
						#(#t_specular2factored, #enabled, true),
						#(#c_specular2factored, #value, #(#ShaderData, 2, 3)),
						#(#t_specular2factored, #text, #(undefined, undefined, String))
					), #(
						#(#l_speccolpower, #enabled, true),
						#(#c_speccolpower, #enabled, true),
						#(#t_speccolpower, #enabled, true),
						#(#c_speccolpower, #value, #(#PowerData, 2, 1)),
						#(#t_speccolpower, #text, #(undefined, undefined, String))
					), #(
						#(#l_specularcolorfactored, #enabled, true),
						#(#c_specularcolorfactored, #enabled, true),
						#(#t_specularcolorfactored, #enabled, true),
						#(#c_specularcolorfactored, #value, #(#ShaderData, 2, 1)),
						#(#t_specularcolorfactored, #text, #(undefined, undefined, String))
					), #(
						#(#l_specpower, #enabled, true),
						#(#c_specpower, #enabled, true),
						#(#t_specpower, #enabled, true),
						#(#c_specpower, #value, #(#PowerData, 1, 3)),
						#(#t_specpower, #text, #(undefined, undefined, String))
					), #(
						#(#l_specularfactored, #enabled, true),
						#(#c_specularfactored, #enabled, true),
						#(#t_specularfactored, #enabled, true),
						#(#c_specularfactored, #value, #(#ShaderData, 1, 3)),
						#(#t_specularfactored, #text, #(undefined, undefined, String))
					), #(
						#(#c_skincolor, #color, #(#ColorData, 4, Color))
					), #(
						#(#c_copytex_grass, #state, #(#MapsLocationData, 4, 2)),
						#(#c_GrassMap, undefined, #GrassMap)
					), #(
						#(#l_diffmap, #enabled, true),
						#(#c_diffmap, #enabled, true),
						#(#c_copytex_d, #enabled, true),
						#(#c_copytex_d, #state, #(#MapsLocationData, 1, 1)),
						#(#c_diffmap, undefined, #DiffuseMap_1)
					), #(
						#(#l_diffmapd2, #enabled, true),
						#(#c_diffmapd2, #enabled, true),
						#(#c_copytex_d2, #enabled, true),
						#(#c_copytex_d2, #state, #(#MapsLocationData, 1, 2)),
						#(#c_diffmapd2, undefined, #DiffuseMap_2)
					), #(
						#(#c_copytex_1, #state, #(#MapsLocationData, 3, 1)),
						#(#c_diffmap1, undefined, #BlendLayerMap_1)
					), #(
						#(#c_copytex_2, #state, #(#MapsLocationData, 3, 2)),
						#(#c_diffmap2, undefined, #BlendLayerMap_2)
					), #(
						#(#l_diffmap3, #enabled, true),
						#(#c_diffmap3, #enabled, true),
						#(#c_copytex_3, #enabled, true),
						#(#c_copytex_3, #state, #(#MapsLocationData, 3, 3)),
						#(#c_diffmap3, undefined, #BlendLayerMap_3)
					), #(
						#(#l_diffmap4, #enabled, true),
						#(#c_diffmap4, #enabled, true),
						#(#c_copytex_4, #enabled, true),
						#(#c_copytex_4, #state, #(#MapsLocationData, 4, 1)),
						#(#c_diffmap4, undefined, #BlendLayerMap_4)
					),
					undefined,
					#(
						#(#l_zshift, #enabled, true),
						#(#c_zshift, #enabled, true),
						#(#t_zshift, #enabled, true),
						#(#c_zshift, #value, #(#PowerData, 3, 1)),
						#(#t_zshift, #text, #(undefined, undefined, String))
					)
				)
		label lstrt
		Group "UV coordinates" (
			label luvtip1 "These values won't be stored in the model!"
			label luvtip2 "Don't forget to:" Align:#Right Across:2
			Button ResetUV "Reset" Align:#Left Offset:[5, 0] Height:15
			label offs "Offset" across:2
			label tile "Tiling"
			spinner UOffs "U" Type:#Float Range:[-100000,100000,0] width:50 Align:#Right Across:4
			spinner VOffs "V" Type:#Float Range:[-100000,100000,0] width:50 Align:#Left
			spinner UTile "U" Type:#Float Range:[-100000,100000,1] width:50 Align:#Right
			spinner VTile "V" Type:#Float Range:[-100000,100000,1] width:50 Align:#Left
		)
		label l0 "Shader" across:3
		label l1 "Parameter set" Offset:[20, 0]
		label l2 "Skinnable" Offset:[20, 0]
		dropdownlist mdl_shtype items:#() height:30 across:3
		dropdownlist mdl_spslist items:#() height:30 Width:150
		label SkinnableTip "YES" Offset:[20, 0]
		subrollout editor Height:-1
		checkbutton LockSh "< Dock" width:45 height:17 checked:true pos:[0,0]
		fn DoTexmapRC SlotControl TexmapName = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local Texmap = (GetProperty TheMtl TexmapName),
						TheBMP = (
							try
								Texmap.Bitmap
							catch ()
						)
				EGIMS_IV_matlist.RC = #(#(TheMtl, TexmapName), SlotControl, TheBMP)
				PopUpMenu EGIMS_IV_TexMapRC
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn DoTexmapPress SlotControl TexmapName = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local Texmap = (GetProperty TheMtl TexmapName),
						FileName = (
							if Have Texmap then (
								try
									Texmap.FileName
								catch
									""
							)
						),
						TheBMP = (SelectBitMap FileName:FileName Caption:"Select the texture file")
				if Have TheBMP then (
					local	TargetMap = (
								try
									(BitmapTexture Bitmap:TheBMP)
								catch
									undefined
							)
					if Have TargetMap then (
						SlotControl.Tooltip = TheBMP.FileName
						SlotControl.Caption = (FilenameFromPath TheBMP.FileName)
					) else
						SlotControl.Tooltip = SlotControl.Caption = "Empty"
					SetProperty TheMtl TexmapName TargetMap
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn AlterProperty SubRol ControlName ControlProperty Val PrevParam = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if Have ControlProperty then (
					if (IsKindOf Val Array) then (
						local	PropertyName = Val[1],
								TypeOrIndex = Val[3]
						Val = (
							if (IsKindOf TypeOrIndex Integer) then
								(GetProperty TheMtl PropertyName)[Val[2]][TypeOrIndex]
							else (
								(
									if No PropertyName then
										PrevParam
									else
										(GetProperty TheMtl PropertyName)[Val[2]]
								) as TypeOrIndex
							)
						)
					)
					SetProperty (GetProperty SubRol ControlName) ControlProperty Val
					Val
				) else (
					local	TexButton = (GetProperty SubRol ControlName),
							Tex = (GetProperty TheMtl Val),
							FileName = (
								if Have Tex then (
									try
										Tex.FileName
									catch
										undefined
								)
							)
					if Have FileName then (
						TexButton.Caption = (FileNameFromPath FileName)
						TexButton.Tooltip = FileName
					) else (
						TexButton.Caption = (TexButton.Tooltip = "Empty")
						SetProperty TheMtl Val undefined
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		fn Init ShaderChanged:false = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				UOffs.Value = TheMtl.UOffs
				VOffs.Value = TheMtl.VOffs
				UTile.Value = TheMtl.UTile
				VTile.Value = TheMtl.VTile
				local	ShaderData = TheMtl.ShaderData[1],
						TargetGroupID = ShaderData.x,
						SPSList = Shaders[2][TargetGroupID],
						TargetSPSID = ShaderData.y,
						UpdateMatrix = GIMS.Core.ValueOps.UpdateMatrix
				if TargetSPSID > SPSList.Count then (
					TargetSPSID = 1
					TheMtl.ShaderData = (UpdateMatrix TheMtl.ShaderData [1, 2] TargetSPSID)
				)
				mdl_shtype.selection = TargetGroupID
				mdl_spslist.items = SPSList
				mdl_spslist.selection = TargetSPSID
				SkinnableTip.Text = (
					if Shaders[5][TargetGroupID][TargetSPSID] then
						"YES"
					else
						"NO"
				)
				for Rol in SubRols do
					RemoveSubRollout editor Rol
				EditorHeight = 176
				MaxEditorHeight = EGIMS_IV_matlist.Height
				EGIMS_IV_mateditor.height = EditorHeight
				editor.height = -1
				local	ShaderParams = Shaders[3][TargetGroupID][TargetSPSID],
						QuickSearch = GIMS.Core.ArrayOps.QuickSearch
				for param in ShaderParams do (
					SubRolID = (QuickSearch SubRolParamNames param)
					if SubRolID == 0 then
						throw (Append "Unknown parameter: " (param as String))
					local	SubRol = SubRolParamRols[SubRolID]
					if Have SubRol then (
						if not SubRol.isDisplayed then
							AddSubRollout editor SubRol
						local	ParamActions = SubRolParamActions[SubRolID]
						if Have ParamActions then (
							local	PrevParam
							for ParamAction in ParamActions do
								PrevParam = (AlterProperty SubRol ParamAction[1] ParamAction[2] ParamAction[3] PrevParam)
						)
					)
				)
				local	EditorRols = editor.Rollouts
				if EditorRols.Count != 0 then (
					for Rol in EditorRols do
						EditorHeight += (rol.Height + 24)
					if EditorHeight <= MaxEditorHeight then
						EditorHeight += 10
					else
						EditorHeight = MaxEditorHeight
					editor.Height = (EditorHeight - 181)
					EGIMS_IV_mateditor.height = EditorHeight
				)
				for Rol in SubRols do
					Rol.TheMtl = TheMtl
				if
					ShaderChanged and
					not EGIMS_IV_edit_lightpow.isDisplayed
				then
					TheMtl.PowerData = (UpdateMatrix TheMtl.PowerData [2, 2] 0)
				if
					ShaderChanged and
					not EGIMS_IV_edit_blendall.isDisplayed
				then
					TheMtl.BlendLayerMap_1 = undefined
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		on mdl_shtype selected id do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	ShaderData = TheMtl.ShaderData[1],
						TargetSPSID = ShaderData.y,
						UpdateMatrix = GIMS.Core.ValueOps.UpdateMatrix
				if TargetSPSID > Shaders[2][id].Count then (
					TargetSPSID = 1
					TheMtl.ShaderData = (UpdateMatrix TheMtl.ShaderData [1, 2] TargetSPSID)
				)
				TheMtl.ShaderData = (UpdateMatrix TheMtl.ShaderData [1, 1] id)
				Init ShaderChanged:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on mdl_spslist selected id do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.ShaderData = (GIMS.Core.ValueOps.UpdateMatrix TheMtl.ShaderData [1, 2] id)
				Init ShaderChanged:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		fn SetBitmapData = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheMtl.UOffs = UOffs.Value
				TheMtl.VOffs = VOffs.Value
				TheMtl.UTile = UTile.Value
				TheMtl.VTile = VTile.Value
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
		on UOffs changed val do
			SetBitmapData()
		on VOffs changed val do
			SetBitmapData()
		on UTile changed val do
			SetBitmapData()
		on VTile changed val do
			SetBitmapData()
		on ResetUV pressed do (
			UOffs.Value = (VOffs.Value = 0)
			UTile.Value = (VTile.Value = 1)
			SetBitmapData()
		)
		on EGIMS_IV_mateditor open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.LockSh.enabled = true
				Shaders = GIMS.IV.Core.DB.Shaders
				mdl_shtype.items = Shaders[1]
				mdl_shtype.selection = (Shaders[6].x as Integer)
				mdl_spslist.items = Shaders[2][Shaders[6].x as Integer]
				mdl_spslist.selection = (Shaders[6].y as Integer)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on EGIMS_IV_mateditor close do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.LockSh.enabled = false
				if EGIMS_IV_edit_blendall.OnBlend then
					EGIMS_IV_edit_blendall.BrakePaint()
				if EGIMS_IV_matlist.OnPreview then
					GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on LockSh changed state do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if state then (
					local NewPos = (GetDialogPos EGIMS_IV_mateditor)
					SetDialogPos EGIMS_IV_matlist [(NewPos.x - (GetDialogSize EGIMS_IV_matlist).x - 20), NewPos.y]
				)
				EGIMS_IV_matlist.LockSh.checked = state
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)		
		on EGIMS_IV_mateditor moved NewPos do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if LockSh.checked then
					SetDialogPos EGIMS_IV_matlist [(NewPos.x - (GetDialogSize EGIMS_IV_matlist).x - 20), NewPos.y]
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	rcmenu EGIMS_IV_MaterialRC (
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
		submenu "Show" (
			MenuItem PreviewInVFB "Large thumbnail"
			MenuItem PreviewInScene "Shader in scene"
		)
		on EGIMS_IV_MaterialRC Open do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				TheObj = EGIMS_IV_matlist.TheObj
				TheObjMaterial = TheObj.Material
				MaterialList = TheObjMaterial.MaterialList
				MaterialIDList = TheObjMaterial.MaterialIDList
				MtlID = EGIMS_IV_matlist.MtlID
				CpyMtl = EGIMS_IV_matlist.CpyMtl
				CurrentMtl = MaterialList[MtlID]
				ShowSubMtl.checked = (CurrentMtl.ShowInViewport)
				PasteReference.enabled = (Have CpyMtl)
				PasteDuplicate.enabled = (Have CpyMtl)
				FaceApply.enabled = (GIMS.Core.MaterialOps.CheckFaceSelection EGIMS_IV_matlist)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on CreateNew picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				local	Core = GIMS.Core,
						MtlID = (Core.ArrayOps.GetFirstUnusedIndex (MaterialIDList as array)),
						NewListID = (MaterialList.Count + 1)
				MaterialList[NewListID] = (
					EGIMS_IV_material \
						Name:(
							Core.ValueOps.FormatText \
								v1:TheObj.Name \
								v2:" #" \
								v3:NewListID \
						) \
						ShowInViewport:true \
				)
				MaterialIDList[NewListID] = MtlID
				EGIMS_IV_matlist.AddMatRollout NewListID
				EGIMS_IV_matlist.InitMatRollout NewListID
				EGIMS_IV_matlist.UpdateThumbnail NewListID
				EGIMS_IV_matlist.UpdateHeader()
				EGIMS_IV_matlist.SelectItem NewListID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on DelSubMtl picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if MaterialList.Count == 1 then (
					MaterialList[1] = (
						EGIMS_IV_material \
							Name:(
								GIMS.Core.ValueOps.FormatText \
									v1:TheObj.Name \
									v2:" #1" \
							) \
							ShowInViewport:true \
					)
					MaterialIDList[1] = 1
					EGIMS_IV_matlist.List.Rollouts[1].Init 1
					EGIMS_IV_matlist.UpdateThumbnail 1
				) else (
					EGIMS_IV_matlist.DeleteMaterial MtlID
					EGIMS_IV_matlist.UpdateHeader()
				)
				EGIMS_IV_matlist.SelectItem MtlID
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on FaceApply picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if not (IsDeleted TheObj) then (
					if $ == TheObj then (
						local	FaceSelectModes, FSetFaceMatID, FGetFaceSelection,
								IsPoly = false
						case (ClassOf TheObj.BaseObject) of (
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
									local	CurrentMatID = MaterialIDList[MtlID]
									if IsPoly then
										FSetFaceMatID TheObj Faces CurrentMatID
									else (
										for tFace in Faces do
											FSetFaceMatID TheObj tFace CurrentMatID
									)
								) else
									MessageBox "Please select the faces first!" title:"GIMS IV material editor"
								Update TheObj
							) else
								MessageBox "Please select the faces first!" title:"GIMS IV material editor"
						) else
							MessageBox "Can't apply the material - object isn't an Editable Mesh/Poly!" title:"GIMS IV material editor"
					) else
						MessageBox "Can't apply the material - another object's selected!" title:"GIMS IV material editor"
				) else
					MessageBox "Can't apply the material - object's deleted!" title:"GIMS IV material editor"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on FaceSelect picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if not (IsDeleted TheObj) then (
					Callbacks.RemoveScripts #selectionSetChanged id:#EGIMS_IV_matlist_GetMaterial
					Select TheObj
					Callbacks.AddScript #selectionSetChanged "EGIMS_IV_matlist.GetMaterialList()" ID:#EGIMS_IV_matlist_GetMaterial
					max modify mode
					local	FGetFaceMatID, FSetFaceSelection, TargetSubObjectLevel
					case (ClassOf TheObj.BaseObject) of (
						Editable_Mesh: (
							FGetFaceMatID = GetFaceMatID
							FSetFaceSelection = SetFaceSelection
							TargetSubObjectLevel = 3
						)
						Editable_Poly: (
							FGetFaceMatID = PolyOp.GetFaceMatID
							FSetFaceSelection = PolyOp.SetFaceSelection
							TargetSubObjectLevel = 4
						)
					)
					if Have TargetSubObjectLevel then (
						ModPanel.SetCurrentObject TheObj
						SubObjectLevel = TargetSubObjectLevel
						local Faces = #{},
								CurrentMatID = MaterialIDList[MtlID]
						for i = TheObj.NumFaces to 1 by -1 do 
							Faces[i] = ((FGetFaceMatID TheObj i) == CurrentMatID)
						if Faces.Count != 0 then
							FSetFaceSelection TheObj Faces
						else
							MessageBox "Can't find faces with that material!" title:"GIMS IV material editor"
					) else
						MessageBox "Can't select faces with that material - object isn't an Editable Mesh/Poly!" title:"GIMS IV material editor"
				) else
					messagebox "Can't select faces with that material - object's deleted!" title:"GIMS IV material editor"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on CopySet picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.CpyMtl = CurrentMtl
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PasteReference picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MaterialList[MtlID] = CpyMtl
				EGIMS_IV_matlist.UpdateThumbnail MtlID
				EGIMS_IV_matlist.EditMaterial DestroyEars:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PasteDuplicate picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MaterialList[MtlID] = (Copy CpyMtl)
				EGIMS_IV_matlist.UpdateThumbnail MtlID
				EGIMS_IV_matlist.EditMaterial DestroyEars:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on Unify picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MaterialList[MtlID] = (Copy CurrentMtl)
				EGIMS_IV_matlist.EditMaterial DestroyEars:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PreviewInScene picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				GIMS.Core.MaterialOps.ReplaceShader EGIMS_IV_matlist
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on PreviewInVFB picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				EGIMS_IV_matlist.UpdateThumbnail EGIMS_IV_matlist.MtlID Preview:true
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
		on ShowSubMtl picked do (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				CurrentMtl.ShowInViewport = (not ShowSubMtl.checked)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
			OK
		)
	)
	struct GUIstr (
		MaterialRolloutName = "EGIMS_IV_matlist_Item",
		MaterialRolloutCode = (
			"rollout EGIMS_IV_matlist_Item% \"...loading...\" RolledUp:true (
				local	TheObj, Index, MatName,
						ImageSize = EGIMS_IV_matlist.ImageSize,
						Padding = EGIMS_IV_matlist.Padding,
						TricePadding = (Padding * 3),
						SpinnerWidth = 60,
						MiscX = (ImageSize.x + 5)
				ImgTag MaterialBMP Width:ImageSize.x Height:ImageSize.y Style:#BMP_Stretch Pos:[Padding, Padding] Transparent:Red
				EditText MaterialName Align:#Left Pos:[MiscX, Padding] Width:100 Text:\"...loading...\"
				Spinner ObjMtlID \"  ID\" Align:#Left Type:#Integer Range:[1, 1000, 1] Pos:[MiscX, MaterialName.Pos.y + MaterialName.Height + Padding] Width:SpinnerWidth
				HyperLink ActiveTip \"<EDITING>\" Align:#Left Color:Red Pos:[ObjMtlID.Pos.x + SpinnerWidth - 30 + Padding, ObjMtlID.Pos.y] Enabled:false Visible:false
				fn UpdateHeader = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						local	TheObjMaterial = TheObj.Material,
								Mtl = TheObjMaterial.MaterialList[Index],
								Names = TheObjMaterial.Names,
								MMName = Names[Index],
								MatTitle
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
						if not (IsKindOf Mtl EGIMS_IV_Material) then (
							Append MatTitle \": \"
							Append MatTitle ((ClassOf Mtl) as String)
						)
						EGIMS_IV_matlist.List.Rollouts[Index].Title = (
							GIMS.Core.ValueOps.FormatText \
								v1:\"ID \" \
								v2:TheObjMaterial.MaterialIDList[Index] \
								v3:\": \" \
								v4:MatTitle
						)
						OK
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				fn SetSelected Flag = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						ActiveTip.Visible = Flag
						if Flag then
							EGIMS_IV_matlist_Item%.Open = true
						OK
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				fn FixGUI = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						local	Height = (ImageSize.y + TricePadding),
								Rol = EGIMS_IV_matlist.List.Rollouts[Index]
								Width = Rol.Width
						Rol.Height = Height
						MaterialName.Width = (Width - ImageSize.x - TricePadding)
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				fn InitControls = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						ObjMtlID.Value = TheObj.Material.MaterialIDList[Index]
						MaterialName.Text = MatName
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				fn Init MatIndex = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						MaterialBMP.Bitmap = undefined
						Index = MatIndex
						FixGUI()
						TheObj = EGIMS_IV_matlist.TheObj
						UpdateHeader()
						InitControls()
						SetSelected false
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				on EGIMS_IV_matlist_Item% RolledUp Flag do (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						if Flag then (
							if Have TheObj then (
								InitControls()
								EGIMS_IV_matlist.UpdateThumbnail Index
							) else
								EGIMS_IV_matlist_Item%.Open = false
						) else (
							if
								Have TheObj and
								Index == EGIMS_IV_matlist.MtlID
							then
								EGIMS_IV_matlist.SelectItem 0
						)
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				fn SelectItem = (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						if not (IsDeleted TheObj) then
							EGIMS_IV_matlist.SelectItem Index
						else (
							MessageBox \"Failed: object's deleted!\" title:\"GIMS IV material editor\"
							false
						)
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				)
				on MaterialBMP Click do (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						if Have TheObj then (
							if EGIMS_IV_matlist.MtlID != Index then
								SelectItem()
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS IV material editor\"
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on MaterialBMP RightClick do (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						if Have TheObj then (
							if not (IsDeleted TheObj) then (
								if (
									EGIMS_IV_matlist.MtlID == Index or
									SelectItem()
								) then
									PopUpMenu EGIMS_IV_MaterialRC
							) else
								MessageBox \"Failed: object's deleted!\" title:\"GIMS IV material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS IV material editor\"
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on ObjMtlID Changed MID do (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
						if Have TheObj then (
							if not (IsDeleted TheObj) then (
								local	MaterialIDList = TheObj.Material.MaterialIDList
								if MID != MaterialIDList[Index] then (
									local	UsedID = (FindItem MaterialIDList MID)
									if UsedID == 0 then
										MaterialIDList[Index] = MID
									else (
										if (QueryBox \"This mesh material ID's already used.\\nSwap materials?\" Title:\"GIMS IV material editor\") then (
											Swap MaterialIDList[Index] MaterialIDList[UsedID]
											EGIMS_IV_matlist.List.Rollouts[UsedID].Init UsedID
										) else
											ObjMtlID.Value = MaterialIDList[Index]
									)
									UpdateHeader()
									Update TheObj
								)
								RedrawViews()
							) else
								MessageBox \"Failed: object's deleted!\" title:\"GIMS IV material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS IV material editor\"
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
					OK
				)
				on MaterialName Entered MtlName do (
					/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
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
								MessageBox \"Failed: object's deleted!\" title:\"GIMS IV material editor\"
						) else
							MessageBox \"This material isn't loaded yet. Please wait...\" title:\"GIMS IV material editor\"
					/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Report NoMetro:true)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
					OK
				)
			)"
		),
		fn Import_Create Sender Args InitLayout:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Game = GIMS.CurrentGame,
							SCore = GIMS.Core,
							GCore = Game.Core,
							SceneFromStruct = GCore.MAXFactory.ObjectMgr.SceneFromStruct,
							GUIMgr = SCore.GUIMgr,
							UpdateProgress = GUIMgr.UpdateProgress,
							ObjectMgr = SCore.ObjectMgr,
							Objs = ObjectMgr.ExchangeData[2],
							ObjStrings = ObjectMgr.ExchangeData[3],
							ObjCount = Objs.Count,
							BaseID = (ObjCount + 2)
					if InitLayout then
						GUIMgr.InitProgress ObjStrings Title:"Import"
					MAX Create Mode
					for ObjID = 1 to ObjCount do (
						UpdateProgress #Stage (ObjID + BaseID)
						SceneFromStruct Objs[ObjID]
					)
					SCore.CacheMgr.Write GCore.DB.ObjectNames (
						SCore.ValueOps.FormatText \
							v1:Game.CachePath \
							v2:"ObjectNames" \
							v3:".Cache"
					)
					GUIMgr.EndProgress true
					SCore.SystemMgr.DoGC()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Import Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							GUIMgr = Core.GUIMgr,
							ObjectMgr = Core.ObjectMgr,
							SystemMgr = Core.SystemMgr,
							AddResult = SystemMgr.AddResult,
							Files = (Core.GUI.SelectFiles "Select the resources to load" true "openFormats resource|*.obn;*.obd;*.odr;*.odd;*.oft;*.onv"),
							ONVExtName = (".onv" as name)
					for i = Files.Count to 1 by -1 do (
						local	File = Files[i],
								FileName = (FileNameFromPath File)
						if (MatchPattern FileName Pattern:"sectors2x2_*.onv") then (
							AddResult #Warning (
								GIMS.Core.ValueOps.FormatText \
									v1:"Can't import file \"" \
									v2:FileName \
									v3:"\" - you should use Resource import."
							)
							DeleteItem Files i
						)
					)
					local	FileCount = Files.Count,
							HaveObjects = (FileCount != 0),
							Objs = #()
					if HaveObjects then (
						local	ValueOps = Core.ValueOps,
								TypeCast = ValueOps.TypeCast,
								FileStrings = #(),
								NeedTextures = false,
								FileStringStart = "\t> ",
								FileStringMid = ": "
						FileStrings.Count = FileCount
						for i = 1 to FileCount do (
							local	File = Files[i],
									FileType = (GetFileNameType File)
							FileType = (TypeCast (SubString FileType 2 FileType.Count) name)
							local	TypeString = (
										case FileType of (
											#obd:
												"Collision Dictionary"
											#obn:
												"Collision"
											#odd: (
												NeedTextures = true
												"Model Dictionary"
											)
											#odr: (
												NeedTextures = true
												"Model"
											)
											#oft: (
												NeedTextures = true
												"FragType"
											)
											#otd:
												"Texture Dictionary"
											#onv:
												"NavMesh"
											Default:
												throw "Unknown file type!"
										)
									),
									FileString = (Copy FileStringStart)
							Append FileString TypeString
							Append FileString FileStringMid
							Append FileString (GetFileNameFile File)
							FileStrings[i] = FileString
						)
						FileStrings = (
							#("Read from file") +
							FileStrings +
							#("Create in scene") +
							FileStrings
						)
						local	TexPath
						if NeedTextures then (
							TexPath = (GetSavePath Caption:"Select external textures directory" InitialDir:(GetFileNamePath Files[1]))
							if Have TexPath then
								Append TexPath "\\"
						)
						GUIMgr.InitProgress FileStrings Title:"Import"
						local	Game = GIMS.CurrentGame,
								GCore = Game.Core,
								StructFromFile = GCore.MAXFactory.ObjectMgr.StructFromFile,
								UpdateProgress = GUIMgr.UpdateProgress,
								Iterator = 0
						Objs.Count = FileCount
						for FileID = 1 to FileCount do (
							UpdateProgress #Stage (FileID + 1)
							local	Obj = (StructFromFile Files[FileID] TexPath)
							if Have Obj then (
								Iterator += 1
								Objs[Iterator] = Obj
							)
						)
						Objs.Count = Iterator
						HaveObjects = (Iterator != 0)
						if HaveObjects then (
							Core.CacheMgr.Write GCore.DB.TextureNames (
								ValueOps.FormatText \
									v1:Game.CachePath \
									v2:"TextureNames" \
									v3:".Cache"
							)
							ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Import_Create, 2), Objs, FileStrings)
						) else
							AddResult #Error "Can't import anything."
					)
					if (SystemMgr.HaveResults()) then
						GUIMgr.EndProgress true Continueable:HaveObjects
					else (
						if HaveObjects then
							Import_Create Sender Args InitLayout:false
					)
					Core.SystemMgr.DoGC()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							GUIMgr = Core.GUIMgr,
							UpdateProgress = GUIMgr.UpdateProgress,
							SavePath = (GetSavePath Caption:"Select a location to export" InitialDir:GUIMgr.LastPath)
					if Have SavePath then (
						Append SavePath "\\"
						GUIMgr.LastPath = SavePath
						GUIMgr.InitProgress #(
							"Collect objects from scene"
						) Title:"Export"
						UpdateProgress #Stage 1
						local	Objs = (Core.MAXFactory.SceneOps.GetObjsToExport()),
								HaveObjects = (Objs.Count != 0)
						if not HaveObjects then
							Core.SystemMgr.AddResult #Error "Nothing found to export."
						Core.ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_Select, 2), Objs, SavePath)
						GUIMgr.EndProgress true Continueable:HaveObjects
					)
					Core.SystemMgr.DoGC()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_Select Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							ObjectMgr = Core.ObjectMgr,
							GUIMgr = Core.GUIMgr,
							FormatText = Core.ValueOps.FormatText,
							ExchangeData = ObjectMgr.ExchangeData,
							GetPathString = Core.ObjectMgr.GetPathString,
							Objs = ExchangeData[2],
							SavePath = ExchangeData[3]
					GUIMgr.SetWindow GIMS.Shared #Selection
					local	ListControl = (GUIMgr.FindControl #ObjectList),
							ObjCount = Objs.Count,
							ObjStrings = #()
					for i = ObjCount to 1 by -1 do (
						local	Obj = Objs[i]
						ObjStrings[i] = (
							FormatText \
								v1:(
									case (ClassOf Obj.ParamSource) of (
										EGIMS_IV_CollisionDict:
											"Collision Dictionary"
										EGIMS_IV_ColComposite:
											"Composite collision"
										EGIMS_IV_Car_Wheel:
											"Car wheel collision"
										GIMS_IV_Col_Box:
											"Collision Box"
										GIMS_IV_Col_Sphere:
											"Collision Sphere"
										GIMS_IV_Col_Capsule:
											"Collision Capsule"
										EGIMS_IV_ModelDict:
											"Model Dictionary"
										EGIMS_IV_Model:
											"Model"
										EGIMS_IV_CollisionMesh:
											"Collision Mesh"
										EGIMS_IV_FragType:
											"FragType"
										EGIMS_IV_NavMesh:
											"NavMesh"
										EGIMS_IV_NavMesh_Portal:
											"NavMesh Portal"
										Default:
											throw ("Unknown object class: " + (ClassOf Obj.ParamSource) as String)
									)
								) \
								v2:": " \
								v3:(GetPathString Obj.Obj) \
						)
					)
					Core.GUI.SetLines ListControl ObjStrings
					for i = 0 to (ObjCount - 1) do
						ListControl.SetItemChecked i true
					ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_StructsFromObjs, 2), Objs, ObjStrings, SavePath, GetPathString)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_Write Sender Args InitLayout:true = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							GUIMgr = Core.GUIMgr,
							AddResult = Core.SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ExchangeData = Core.ObjectMgr.ExchangeData,
							Objs = ExchangeData[2],
							ObjStrings = ExchangeData[3],
							ObjCount = Objs.Count,
							BaseID = (ObjCount + 2),
							Obj
					if InitLayout then
						GUIMgr.InitProgress ObjStrings Title:"Export"
					for ObjID = 1 to ObjCount do (
						UpdateProgress #Stage (ObjID + BaseID)
						Objs[ObjID].Write()
					)
					GUIMgr.EndProgress true
					Core.SystemMgr.DoGC()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn Export_StructsFromObjs Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							GUIMgr = Core.GUIMgr,
							ObjectMgr = Core.ObjectMgr,
							SystemMgr = Core.SystemMgr,
							AddResult = SystemMgr.AddResult,
							UpdateProgress = GUIMgr.UpdateProgress,
							ListControl = (GUIMgr.FindControl #ObjectList),
							ExchangeData = Core.ObjectMgr.ExchangeData,
							AllObjs = ExchangeData[2],
							AllObjStrings = ExchangeData[3],
							SavePath = ExchangeData[4],
							GetPathString = ExchangeData[5],
							AllObjCount = AllObjs.Count,
							TabStart = "\t> " ,
							CheckedIndices = #{},
							Objs = #(),
							ObjStrings = #()
					CheckedIndices.Count = AllObjCount
					for i = AllObjCount to 1 by -1 where (ListControl.GetItemChecked (i - 1)) do
						CheckedIndices[i] = true
					local	CheckedIndicesCount = CheckedIndices.NumberSet,
							HaveObjects = (CheckedIndicesCount != 0)
					if HaveObjects then (
						ObjStrings.Count = CheckedIndicesCount
						Objs.Count = CheckedIndicesCount
						local	Iterator = 0
						for CheckedIndex in CheckedIndices do (
							Iterator += 1
							ObjStrings[Iterator] = (TabStart + AllObjStrings[CheckedIndex])
							Objs[Iterator] = AllObjs[CheckedIndex]
						)
						ObjStrings = (
							#("Collect from scene") +
							ObjStrings +
							#("Write to file") +
							ObjStrings
						)
						GUIMgr.InitProgress ObjStrings Title:"Export"
						local	Game = GIMS.CurrentGame,
								GCore = Game.Core,
								StructFromScene = GCore.MAXFactory.ObjectMgr.StructFromScene,
								UpdateProgress = GUIMgr.UpdateProgress
						Iterator = 0
						MAX Create Mode
						for ObjID = 1 to CheckedIndicesCount do (
							UpdateProgress #Stage (ObjID + 1)
							local	Obj = (StructFromScene Objs[ObjID] DiskPath:SavePath)
							if Have Obj then (
								Iterator += 1
								Objs[Iterator] = Obj
							)
						)
						Objs.Count = Iterator
						HaveObjects = (Iterator != 0)
						if HaveObjects then (
							local	WriteCache = Core.CacheMgr.Write,
									CachePath = Game.CachePath,
									DB = GCore.DB,
									FormatText = Core.ValueOps.FormatText
							WriteCache DB.TextureNames (
								FormatText \
									v1:CachePath \
									v2:"TextureNames" \
									v3:".Cache"
							)
							WriteCache DB.ObjectNames (
							FormatText \
								v1:CachePath \
								v2:"ObjectNames" \
								v3:".Cache"
							)
						) else
							AddResult #Error "Can't export anything."
					) else
						AddResult #Error "Nothing selected to export."
					ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Export_Write, 2), Objs, ObjStrings)
					if (SystemMgr.HaveResults()) then
						GUIMgr.EndProgress true Continueable:HaveObjects
					else
						Export_Write Sender Args InitLayout:false
					Core.SystemMgr.DoGC()
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn EP_TLaD Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					GIMS.CurrentGame.Core.GameMgr.LoadEFLC "tlad\\"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn EP_TBoGT Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					GIMS.CurrentGame.Core.GameMgr.LoadEFLC "tbogt\\"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ShowMatEditor Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					DestroyDialog EGIMS_IV_matlist
					CreateDialog EGIMS_IV_matlist Style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateMap Sender Args = (
			try (
				if args.Button.value__ == 1048576 then (
					--SuspendEditing()
					DisableSceneRedraw()
					local	MapHelper
					for Obj in Objects while No MapHelper where
						(IsKindOf Obj Editable_Poly) and
						Have (GetUserProp Obj "IsIVMapHelper")
					do
						MapHelper = Obj
					if No MapHelper then (
						local	FilesPath = GIMS.CurrentGame.FilesPath,
								TextureIDs = #(
									7, 8, 9,
									4, 5, 6,
									1, 2, 3
								),
								FormatText = GIMS.Core.ValueOps.FormatText,
								MapStr = "map_",
								JPGStr = ".jpg",
								MapCount = TextureIDs.Count,
								Maps = #()
						for i = MapCount to 1 by -1 do (
							Maps[i] = (
								Standard \
									DiffuseMap:(
										BitmapTexture FileName:(
											FormatText \
												v1:FilesPath \
												v2:MapStr \
												v3:TextureIDs[i] \
												v4:JPGStr
										)
									) \
									ShowInViewport:true \
							)
						)
						local	MapHelper = (
									ConvertToPoly (
										Plane \
										Width:6000 \
										Length:6000 \
										LengthSegs:3 \
										WidthSegs:3 \
										Name:"GTA IV Map helper" \
										Material:(
											MultiMaterial \
											Material:Maps \
											Names:(
												local	Res = #()
												for i = MapCount to 1 by -1 do
													Res[i] = Maps[i].Name
												Res
											) \
										) \
										DisplayByLayer:false \
										RealWorldMapSize:false \
										ShowFrozenInGray:false \
									)
								),
								PSetFaceMatID = PolyOp.SetFaceMatID
						SetUserProp MapHelper "IsIVMapHelper" true
						for i = 1 to 9 do
							PSetFaceMatID MapHelper i i
						PolyOp.ApplyUVWMap MapHelper #face Utile:1.0 Vtile:1.0 Wtile:1.0 Uflip:false Vflip:false Wflip:false Cap:true Channel:1
						local	UVWXFormMod = (UVW_Xform Rotation_Angle:-90)
						AddModifier MapHelper UVWXFormMod
						CollapseStack MapHelper
						Update MapHelper
					) else
						UnHide MapHelper
					ResumeEditing()
					EnableSceneRedraw()
					RedrawViews()
				)
			) catch (
				ResumeEditing()
				EnableSceneRedraw()
				/*<ERRHANDLER>*//*GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
				throw
			)
		),
		fn CreateHelper MeshData ObjName = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				MeshOp.BreakVerts (
					Mesh Faces:MeshData[2] Vertices:MeshData[1] Name:(
						GIMS.Core.ValueOps.FormatText \
							v1:GIMS.CurrentGame.Name \
							v2:" " \
							v3:ObjName
					)
				) #All
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreatePed Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.PedMesh[1] "Ped"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateCar Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.CarMesh[1] "Car"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateTruck Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.TruckMesh "Truck"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateBoat Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.BoatMesh[1] "Boat"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateHeli Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.HeliMesh "Helicopter"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn CreateSubway Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then
					CreateHelper GIMS.CurrentGame.Core.DB.SubwayMesh "Subway train"
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ImportNavMesh Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Core = GIMS.Core,
							GUIMgr = Core.GUIMgr,
							ObjectMgr = Core.ObjectMgr,
							SystemMgr = Core.SystemMgr,
							AddResult = SystemMgr.AddResult,
							Game = GIMS.CurrentGame,
							GCore = Game.Core,
							GObjectMgr = GCore.MAXFactory.ObjectMgr,
							ValueOps = Core.ValueOps,
							TypeCast = ValueOps.TypeCast,
							FormatText = ValueOps.FormatText,
							NavFileStart = "sectors2x2_",
							FilesPath = (GetSavePath InitialDir:GUIMgr.LastPath Caption:"Select the folder with all navmeshes(navmeshes.img > sectors2x2_*.wnv files) exported to openFormats(.onv files)")
					if Have FilesPath then (
						Append FilesPath "\\"
						GUIMgr.LastPath = FilesPath
						local	Files = (
									GetFiles (
										FormatText \
											v1:FilesPath \
											v2:NavFileStart \
											v3:"*.onv"
									)
								),
								FileCount = Files.Count,
								CanImport = (FileCount == 3600)
						if CanImport then (
							MessageBox "Select the area to import with 2 LMB clicks\nin the top/bottom/perspective/orthographic view.\n\nAlso, you can select only one point and then press RMB or Escape." Title:"GTA IV NavMesh import"
							local	ImportArea = (Core.GUI.SelectArea())
							CanImport = (Have ImportArea)
							if CanImport then (
								local	GetAreaID = GObjectMgr.GetAreaID,
										FileNames = #()
								for i = FileCount to 1 by -1 do
									FileNames[i] = (GetFileNameFile Files[i])
								local	FilesMHL = #(Files, FileNames),
										ArrayOps = Core.ArrayOps,
										FetchMHL = ArrayOps.FetchMHL
								ArrayOps.QuickSort FilesMHL MHL:true
								local	AreaFiles = #(),
										AreaStartData = (GetAreaID [ImportArea.x, ImportArea.y, 0] Mode:#NavMesh AllowOutOfBounds:true),
										AreaEndData = (GetAreaID [ImportArea.z, ImportArea.w, 0] Mode:#NavMesh AllowOutOfBounds:true),
										AreaStartX = (AreaStartData.z as Integer),
										AreaStartY = (AreaStartData.w as Integer),
										AreaEndX = (AreaEndData.z as Integer),
										AreaEndY = (AreaEndData.w as Integer)
								if AreaEndX < AreaStartX then
									Swap AreaEndX AreaStartX
								if AreaEndY < AreaStartY then
									Swap AreaEndY AreaStartY
								if AreaStartX < 0 then
									AreaStartX = 0
								if AreaStartY < 0 then
									AreaStartY = 0
								if AreaEndX > 118 then
									AreaEndX = 118
								if AreaEndY > 118 then
									AreaEndY = 118
								local	LowerSpaceChar = "_"
								for x = AreaStartX to AreaEndX by 2 do (
									for y = AreaStartY to AreaEndY by 2 do (
										local	SectorName = (
											FormatText \
												v1:NavFileStart \
												v2:x \
												v3:LowerSpaceChar \
												v4:y
										)
										Append AreaFiles (FetchMHL FilesMHL SectorName)
									)
								)
								local	AreaFileCount = AreaFiles.Count
								CanImport = (AreaFileCount != 0)
								if CanImport then (
									local	Objs = #(),
											NeedTextures = false,
											FileStringStart = "\t> ",
											FileStringMid = ": ",
											NavMeshString = "NavMesh"
											FileStrings = #()
									for i = AreaFileCount to 1 by -1 do (
										FileStrings[i] = (
											FormatText \
												v1:FileStringStart \
												v2:NavMeshString \
												v3:FileStringMid \
												v4:(GetFileNameFile AreaFiles[i]) \
										)
									)
									FileStrings = (
										#("Read from file") +
										FileStrings +
										#("Create in scene") +
										FileStrings
									)
									GUIMgr.InitProgress FileStrings Title:"Import"
									local	StructFromFile = GObjectMgr.StructFromFile,
											UpdateProgress = GUIMgr.UpdateProgress,
											Iterator = 0
									Objs.Count = AreaFileCount
									for FileID = 1 to AreaFileCount do (
										UpdateProgress #Stage (FileID + 1)
										local	Obj = (StructFromFile AreaFiles[FileID] TexPath)
										if Have Obj then (
											Iterator += 1
											Objs[Iterator] = Obj
										)
									)
									Objs.Count = Iterator
									CanImport = (Iterator != 0)
									if CanImport then
										ObjectMgr.ExchangeData = #(#(GIMS.CurrentGame, 2, #Import_Create, 2), Objs, FileStrings)
									else
										AddResult #Error "Can't import anything."
								) else
									AddResult #Error "Can't find any NavMeshes in the selected area"
							)
						) else
							AddResult #Error (Append "Can't import NavMeshes - expected 3600 files, found " (FileCount as String))
						if (SystemMgr.HaveResults()) then
							GUIMgr.EndProgress true Continueable:CanImport
						else (
							if CanImport then
								Import_Create Sender Args InitLayout:false
						)
						Core.SystemMgr.DoGC()
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		),
		fn ChangeGamePath Sender Args = (
			/*<PROFILERSTART>*//*local PTS, PWS; PTS = ((GetTimeStamp()) / 10000); LogProfiler #Start 0 0 (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); PWS = (*//*<PROFILERSTARTED>*//*<ERRHANDLERSTART>*/--try (
				if args.Button.value__ == 1048576 then (
					local	Game = GIMS.CurrentGame
					if (QueryBox "Are you really want to change the game path?" Title:("GIMS for " + Game.Name)) then (
						local	SCore = GIMS.Core
						SCore.GUIMgr.MainWindow.Close()
						SCore.SystemMgr.FileDelete (Game.BasePath + "Paths.txt")
						Game.Start Game
					)
				)
			/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
		)
	)
	GIMS.CurrentGame.Core.GUI = GUIstr()
/*<ERRHANDLER>*//*) catch (GIMS.Core.SystemMgr.ThrowError (GetCurrentException()) #Throw)*//*<ERRHANDLEREND>*//*<PROFILEREND>*//*); local PTE; PTE = ((GetTimeStamp()) / 10000); LogProfiler #End PTS PTE 0; PWS*//*<PROFILERENDED>*/
