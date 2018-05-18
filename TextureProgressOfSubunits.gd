extends Control

export var num_subunits = 1 setget set_num_subunits
export var percent = 0.0 setget set_percent #0-1

export var margin_x = 10

func _ready():
	set_num_subunits(num_subunits)
	$ReferenceTextureProgress.visible = false

func set_percent(val):
	percent = clamp(val,0,1)
	if is_inside_tree():
		var val_per_subunit = 1.0 / num_subunits
		var subunit_index = int(percent / val_per_subunit)
		
		var tps = $CreatedTextureProgresses.get_children()
		for i in range( tps.size() ):
			var tp = tps[i]
			if i == subunit_index:
				var remainder = (float(percent) / val_per_subunit - subunit_index)
				tp.value = remainder * tp.max_value
			elif i < subunit_index:
				tp.value = tp.max_value
			else: 
				tp.value = tp.min_value

func set_num_subunits(val):
	num_subunits = val
	if is_inside_tree():
		for child in $CreatedTextureProgresses.get_children():
			child.queue_free()
		
		for i in range(num_subunits):
			var tp = $ReferenceTextureProgress.duplicate()
			$CreatedTextureProgresses.add_child(tp)
			tp.rect_position = Vector2(i * (tp.rect_size.x + margin_x), 0)
			tp.visible = true
		
		set_percent(percent)

func get_width():
	var tp = _last_tp()
	return tp.rect_position.x + tp.rect_size.x

func get_height():
	var tp = _last_tp()
	return tp.rect_position.y + tp.rect_size.y

func _last_tp():
	var num_children = $CreatedTextureProgresses.get_children().size()
	return $CreatedTextureProgresses.get_children()[num_children - 1]