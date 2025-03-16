extends NinePatchRect

var label_code : String
var input = ""
const text_a := "ABCDEFGHIJKLNOPQRSTUVY123456789"
@onready var button = $Button_OK
@onready var code_label = $Code_label
var input_check = false


func _ready():
	label_code = generate_word(text_a.split(),8)
	code_label.text = label_code
	
	
func generate_word(chars: Array[String], length: int):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
	

func compare_input(code: Array[String], input: Array[String],):
	if 	code == input:
		input_check = true
		return input_check
	else:
		input_check = false
		return input_check


func _on_button_ok_pressed() -> void:
	input = $LineEdit.text
	input_check=compare_input(label_code.split(), input.split())
	print ("yay")
