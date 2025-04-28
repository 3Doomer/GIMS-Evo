/*#PC*DEFINE	CurrentGame	NR*/
/*<PROFILERSTART>*//*(LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
/*<ERRHANDLERSTART>*/try (
	struct /*#PC*PATH	GIMS.CurrentGame.Core.DB*/ strDB (
		ThisObj,
		Loaded = false,
		fn Load = (
			/*<PROFILERSTART>*//*LogProfiler #Start (local SS = (StringStream ""); Stack ShowLocals:false FirstFrameOnly:true To:SS; SS); local PWS = (*//*<PROFILERSTARTED>*/
			/*<ERRHANDLERSTART>*/try (
				Loaded = true
			/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
			/*<PROFILEREND>*//*); LogProfiler #End 0; PWS*//*<PROFILERENDED>*/
		)
	)
	(
		local DB = strDB()
		DB.ThisObj = DB
		GIMS.CurrentGame.Core.DB = DB
	)
/*<ERRHANDLER>*/) catch (local	CET = (GetCurrentException()),ESS;if not (MatchPattern CET Pattern:"*<THROW>*") then (ESS = (StringStream "");Stack ShowLocals:EGIMS_EHStackLocals FirstFrameOnly:EGIMS_EHFFO To:ESS); EGIMS_EHError CET ESS)/*<ERRHANDLEREND>*/
/*<PROFILEREND>*//*); LogProfiler #End 0; PWS)*//*<PROFILERENDED>*/
