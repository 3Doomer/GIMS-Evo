parameters chFlags rollout:rolChFlags (
	Flags1		Type:#BoolTab	Default:false		UI:(
		f1_01,
		f1_02,
		f1_03,
		f1_04,
		f1_05,
		f1_06,
		f1_07,
		f1_08,
		f1_09,
		f1_10,
		f1_11,
		f1_12,
		f1_13,
		f1_14,
		f1_15,
		f1_16,
		f1_17,
		f1_18,
		f1_19,
		f1_20,
		f1_21,
		f1_22,
		f1_23,
		f1_24,
		f1_25,
		f1_26,
		f1_27,
		f1_28,
		f1_29,
		f1_30,
		f1_31,
		f1_32
	)	TabSize:32
	Flags2		Type:#BoolTab	Default:true		UI:(
		f2_01,
		f2_02,
		f2_03,
		f2_04,
		f2_05,
		f2_06,
		f2_07,
		f2_08,
		f2_09,
		f2_10,
		f2_11,
		f2_12,
		f2_13,
		f2_14,
		f2_15,
		f2_16,
		f2_17,
		f2_18,
		f2_19,
		f2_20,
		f2_21,
		f2_22,
		f2_23,
		f2_24,
		f2_25,
		f2_26,
		f2_27,
		f2_28,
		f2_29,
		f2_30,
		f2_31,
		f2_32
	)	TabSize:32
)

rollout rolChFlags "Composite child flags" (
	Group	"Flags 1"	(
		CheckBox	f1_01	"Animal"				Align:#Left
		CheckBox	f1_02	"Animal ragdoll"		Align:#Left
		CheckBox	f1_03	"Explosion"				Align:#Left
		CheckBox	f1_04	"Foliage"				Align:#Left
		CheckBox	f1_05	"Forklift forks"		Align:#Left
		CheckBox	f1_06	"Glass"					Align:#Left
		CheckBox	f1_07	"Map animal"			Align:#Left
		CheckBox	f1_08	"Map cover"				Align:#Left
		CheckBox	f1_09	"Map deep surface"		Align:#Left
		CheckBox	f1_10	"Map dynamic"			Align:#Left
		CheckBox	f1_11	"Map river"				Align:#Left
		CheckBox	f1_12	"Map stairs"			Align:#Left
		CheckBox	f1_13	"Map vehicle"			Align:#Left
		CheckBox	f1_14	"Map weapon"			Align:#Left
		CheckBox	f1_15	"Object"				Align:#Left
		CheckBox	f1_16	"Object env cloth"		Align:#Left
		CheckBox	f1_17	"Ped"					Align:#Left
		CheckBox	f1_18	"Pickup"				Align:#Left
		CheckBox	f1_19	"Plant"					Align:#Left
		CheckBox	f1_20	"Projectile"			Align:#Left
		CheckBox	f1_21	"Ragdoll"				Align:#Left
		CheckBox	f1_22	"Smoke"					Align:#Left
		CheckBox	f1_23	"Test ai"				Align:#Left
		CheckBox	f1_24	"Test camera"			Align:#Left
		CheckBox	f1_25	"Test script"			Align:#Left
		CheckBox	f1_26	"Test vehicle wheel"	Align:#Left
		CheckBox	f1_27	"Test weapon"			Align:#Left
		CheckBox	f1_28	"Unknown"				Align:#Left
		CheckBox	f1_29	"Unsmashed"				Align:#Left
		CheckBox	f1_30	"Vehicle box"			Align:#Left
		CheckBox	f1_31	"Vehicle bvh"			Align:#Left
		CheckBox	f1_32	"Vehicle not bvh"		Align:#Left
	)
	Group	"Flags 2" (
		CheckBox	f2_01	"Animal"				Align:#Left
		CheckBox	f2_02	"Animal ragdoll"		Align:#Left
		CheckBox	f2_03	"Explosion"				Align:#Left
		CheckBox	f2_04	"Foliage"				Align:#Left
		CheckBox	f2_05	"Forklift forks"		Align:#Left
		CheckBox	f2_06	"Glass"					Align:#Left
		CheckBox	f2_07	"Map animal"			Align:#Left
		CheckBox	f2_08	"Map cover"				Align:#Left
		CheckBox	f2_09	"Map deep surface"		Align:#Left
		CheckBox	f2_10	"Map dynamic"			Align:#Left
		CheckBox	f2_11	"Map river"				Align:#Left
		CheckBox	f2_12	"Map stairs"			Align:#Left
		CheckBox	f2_13	"Map vehicle"			Align:#Left
		CheckBox	f2_14	"Map weapon"			Align:#Left
		CheckBox	f2_15	"Object"				Align:#Left
		CheckBox	f2_16	"Object env cloth"		Align:#Left
		CheckBox	f2_17	"Ped"					Align:#Left
		CheckBox	f2_18	"Pickup"				Align:#Left
		CheckBox	f2_19	"Plant"					Align:#Left
		CheckBox	f2_20	"Projectile"			Align:#Left
		CheckBox	f2_21	"Ragdoll"				Align:#Left
		CheckBox	f2_22	"Smoke"					Align:#Left
		CheckBox	f2_23	"Test ai"				Align:#Left
		CheckBox	f2_24	"Test camera"			Align:#Left
		CheckBox	f2_25	"Test script"			Align:#Left
		CheckBox	f2_26	"Test vehicle wheel"	Align:#Left
		CheckBox	f2_27	"Test weapon"			Align:#Left
		CheckBox	f2_28	"Unknown"				Align:#Left
		CheckBox	f2_29	"Unsmashed"				Align:#Left
		CheckBox	f2_30	"Vehicle box"			Align:#Left
		CheckBox	f2_31	"Vehicle bvh"			Align:#Left
		CheckBox	f2_32	"Vehicle not bvh"		Align:#Left
	)
)
/*
fn AdditionalCreateHandler = (
	local	cf = this.Flags2
	for i = 2 to 6 do	--TODO wrong numbers here, fix if uncommented
		cf[i] = true
)
*/
