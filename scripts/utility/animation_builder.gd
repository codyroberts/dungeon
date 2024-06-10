class_name AnimationBuilder extends Node

func build_character_library() -> AnimationLibrary:
	var new_library := AnimationLibrary.new()
	#var sprite = "res://Assets/Sprites/" + character + "/Animations.png"

	build_animations("walk", new_library, 16, 24, 320, 4, true)
	build_animations("damage", new_library, 16, 24, 112, 4, true)
	build_animations("idle", new_library, 16, 24, 176, 16, true)
	build_animations("attack", new_library, 16, 24, 0, 4, true)
	
	return new_library
	
func build_slime_library() -> AnimationLibrary:
	var new_library := AnimationLibrary.new()
	
	build_animations("die", new_library, 9, 13, 0, 9, false)
	build_animations("idle", new_library, 9, 13, 9, 8, true)
	build_animations("walk", new_library, 9, 13, 81, 4, true)
	build_animations("damage", new_library, 9, 13, 45, 4, true)
	
	return new_library

func build_boss_library() -> AnimationLibrary:
	var new_library := AnimationLibrary.new()
	#var sprite = "res://Assets/Sprites/" + boss + "/Animations.png"
	#print("BUILDING A BOSS")

	build_animations("walk", new_library, 16, 21, 272, 6, true)
	build_animations("idle", new_library, 16, 21, 0, 16, true)
	build_animations("attack", new_library, 16, 21, 63, 8, true)
	
	return new_library


func build_animations(animation_name: String, library: AnimationLibrary, hframes_input: int, vframes_input: int, starting_frame: int, frames: int, directional: bool) -> void:
	print(animation_name)
	var new_animation := Animation.new()
	var hframes := hframes_input
	var vframes := vframes_input
	var frame_index := starting_frame

	var hframes_track := new_animation.add_track(Animation.TYPE_VALUE)
	var vframes_track := new_animation.add_track(Animation.TYPE_VALUE)
	var frame_track := new_animation.add_track(Animation.TYPE_VALUE)

	new_animation.track_set_path(hframes_track, "Sprite2D:hframes")
	new_animation.track_set_path(vframes_track, "Sprite2D:vframes")
	new_animation.track_set_path(frame_track, "Sprite2D:frame")

	new_animation.track_insert_key(hframes_track, 0, hframes)
	new_animation.track_insert_key(vframes_track, 0, vframes)

	if directional:
		for i in range(4):
			#print("Direction count: ", i)
			var directional_animation: Animation
			directional_animation = new_animation.duplicate(true)

			var duration := 0.0
			var frame_count := 0
			
			for k in range(hframes):
				#print("hframe count: ", k)
				if(frame_count < frames):
					#print(frame_index)
					directional_animation.track_insert_key(frame_track, duration, frame_index)
				
					frame_count += 1
					duration += 0.4
				
				frame_index += 1
				#print(frame_index)
			
			directional_animation.length = duration

			match i:
				0:
					library.add_animation(animation_name + "_down_right", directional_animation)
				1:
					library.add_animation(animation_name + "_down_left", directional_animation)
				2:
					library.add_animation(animation_name + "_up_right", directional_animation)
				3:
					library.add_animation(animation_name + "_up_left", directional_animation)
	else:
		var duration := 0.0
		var frame_count := 0
		
		for k in range(hframes):
			#print("hframe count: ", k)
			if(frame_count < frames):
				#print(frame_index)
				new_animation.track_insert_key(frame_track, duration, frame_index)
			
				frame_count += 1
				duration += 0.4
			
			frame_index += 1
			#print(frame_index)
		
		new_animation.length = duration
		library.add_animation(animation_name, new_animation)
		
func get_direction(vector: Vector2) -> String:
	if  vector.x > 0:
		if vector.y >= 0:
			return("_down_right")
		else:
			return("_up_right")
	elif vector.x < 0:
		if vector.y >= 0:
			return("_down_left")
		else:
			return("_up_left")
	elif  vector.y > 0:
		if vector.x > 0:
			return("_down_left")
		else:
			return("_down_right")
	elif vector.y < 0:
		if vector.x > 0:
			return("_up_left")
		else:
			return("_up_right")
	else:
		return "_down_right"
