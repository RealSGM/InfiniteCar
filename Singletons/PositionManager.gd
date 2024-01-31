extends Node

func center_item(parent_node:Node, centering_node:Node,
				width_padding:int = 0, height_padding:int = 0,
				xPos:int = 0, yPos:int = 0,
				centerX:bool = true, centerY:bool = true):
	var parent_size = parent_node.rect_size
	var centering_node_size = centering_node.rect_size
	
	if !(width_padding == 0 && height_padding == 0):
		parent_size = Vector2(centering_node_size.x + width_padding, centering_node_size.y + height_padding)
		parent_node.rect_size = parent_size
		parent_node.rect_min_size = parent_size
		
	#This centers the node
	if (centerX):
		xPos = (parent_size.x - centering_node_size.x) / 2
	if (centerY):
		yPos = (parent_size.y - centering_node_size.y) / 2
		
	var centering_node_new_pos = Vector2(xPos, yPos)
	centering_node.rect_position = centering_node_new_pos

