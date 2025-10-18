extends Node2D

const DIALOGUE_BUTTON = preload("res://scenes/dialogueSystem/dialouge_button.tscn")

@onready var rich_text_label: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel

signal dialouge_finished

var _dilogue: Array[DE]
var _current_dialogue_item: int = 0
var _next_item: bool = true

var _player: player

func _ready() -> void:
	visible = false
	$HBoxContainer/VBoxContainer/ButtonContainer.visible = false
	
	for i in get_tree().get_nodes_in_group("Player"):
		_player = i

func _process(delta: float) -> void:
	if _current_dialogue_item == _dilogue.size():
		if !_player:
			for i in get_tree().get_nodes_in_group("Player"):
				_player = i
			return
		_player.can_move = true
		queue_free()
		dialouge_finished.emit()
		return
	
	if _next_item:
		_next_item = false
		var i = _dilogue[_current_dialogue_item]
		
		if i is DialogueFunction:
			if i.hide_dialogue_box:
				visible = false
			else:
				visible = true
			_fuction_resource(i)
		elif i is DialogueChoice:
			visible = true
			_choice_resource(i)
			
		elif i is DialougeText:
			visible = true
			_text_resource(i)
			
		else:
			print(i)
			printerr("ERROR: ADDED DE RESOURCE TO DIALOGUE TREE")
			_move_to_next_item()

func _fuction_resource(i: DialogueFunction) -> void:
	var target_node = get_node(i.traget_path) 
	if target_node.has_method(i.function_name):
		if i.function_arg.size() == 0:
			target_node.call(i.function_name)
		else:
			target_node.callv(i.function_name, i.function_arg)
	
	if i.wait_for_signal_to_continue:
		var _signal_name = i.wait_for_signal_to_continue
		if target_node.has_signal(_signal_name):
			var signal_state = {"done": false}
			var callable = func(_args): signal_state.done = true
			target_node.connect(_signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	
	_move_to_next_item()

func _choice_resource(i: DialogueChoice) -> void:
	rich_text_label.text = i.text
	rich_text_label.visible_characters = -1
	
	$HBoxContainer/VBoxContainer/ButtonContainer.visible = true
	
	for item in  i.choice_text.size():
		var _DilogueButton = DIALOGUE_BUTTON.instantiate()
		_DilogueButton.text = i.choice_text[item]
		
		var function_resource: DialogueFunction = i.choice_function_call[item]
		if function_resource:
			_DilogueButton.connect("pressed", Callable(get_node(function_resource.traget_path), function_resource.function_name).bindv(function_resource.function_arg), CONNECT_ONE_SHOT)
			if function_resource.hide_dialogue_box:
				_DilogueButton.connect("pressed", hide,CONNECT_ONE_SHOT)
			
			_DilogueButton.connect("pressed", _choice_button_pressed.bind(get_node(function_resource.traget_path), function_resource.wait_for_signal_to_continue), CONNECT_ONE_SHOT)
		
		else:
			_DilogueButton.connect("pressed", _choice_button_pressed.bind(null, ""), CONNECT_ONE_SHOT)
		
		$HBoxContainer/VBoxContainer/ButtonContainer.add_child(_DilogueButton)
	#$HBoxContainer/VBoxContainer/ButtonContainer.get_child(0).grab_focus()

func _choice_button_pressed(target_node: Node, WFSTC:String) -> void:
	$HBoxContainer/VBoxContainer/ButtonContainer.visible = false
	for i in $HBoxContainer/VBoxContainer/ButtonContainer.get_children():
		i.queue_free()
	
	if WFSTC:
		var _signal_name = WFSTC
		if target_node.has_signal(_signal_name):
			var signal_state = {"done": false}
			var callable = func(_args): signal_state.done = true
			target_node.connect(_signal_name, callable, CONNECT_ONE_SHOT)
			while not signal_state.done:
				await get_tree().process_frame
	
	_move_to_next_item()

func _text_resource(i: DialougeText) -> void:
	AudioManager.play_sfx(i.audioStream, i.volume)
	var camera: Camera2D = get_viewport().get_camera_2d()
	if camera and i.camera_position != Vector2(999.999, 999.999):
		var camera_tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
		camera_tween.tween_property(camera, "global_position", i.camera_position, i.camera_transition_time)
	
	rich_text_label.visible_characters = 0
	rich_text_label.text = i.text
	var text_without_square_brackets: String = _text_without_square_brackets(i.text)
	var total_characters: int = text_without_square_brackets.length()
	var character_timer: float = 0.0
	while rich_text_label.visible_characters < total_characters:
		if Input.is_action_just_pressed("Cancel"):
			rich_text_label.visible_characters = total_characters
			break
		
		character_timer += get_process_delta_time()
		if character_timer >= (1.0 / i.text_speed) or text_without_square_brackets[rich_text_label.visible_characters] == " ":
			var character: String = text_without_square_brackets[rich_text_label.visible_characters]
			rich_text_label.visible_characters += 1
			character_timer = 0.0
		
		await get_tree().process_frame
	
	while true:
		await get_tree().process_frame
		if rich_text_label.visible_characters == total_characters:
			if Input.is_action_just_pressed("Accept"):
				_move_to_next_item()

func _text_without_square_brackets(text: String) -> String:
	var result: String = ""
	var inside_bracket: bool = false
	
	for i in text:
		if i == "[":
			inside_bracket = true
			continue
		if i == "]":
			inside_bracket = false
			continue
		
		if !inside_bracket:
			result += i
	
	return result

func _move_to_next_item() -> void:
	_current_dialogue_item += 1
	_next_item = true
