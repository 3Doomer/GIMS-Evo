(
	local	Layouts = (FileIn (GIMS.IV.FilesPath + "English.GIP")),
			ConvertStruct = GIMS.Core.ValueOps.ConvertStruct,
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
	
	for lay in Layouts do (
		local	LayObj = (ConvertStruct lay EGIMS_GUI_Layout PropMapping:LayoutPropMapping AllowOwnProps:false)
		LayObj.WireColor = Black
		HandleSubItems LayObj lay
	)
	OK
)
