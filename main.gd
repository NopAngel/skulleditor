extends TextEdit

var current_file_path = ""  # Guarda la ruta del archivo actual

func _ready():
	set_readonly(false)  # Permitir edición
	setup_syntax_highlighting()  # Configurar resaltado de sintaxis

func _input(event):
	if event.is_action_pressed("open_file"):  # Usa el mapa de entrada que creaste en Godot
		open_file()
	elif event.is_action_pressed("save_file"):
		save_file()

# 📂 Función para abrir archivo
func open_file():
	var file_dialog = FileDialog.new()
	file_dialog.mode = FileDialog.MODE_OPEN_FILE
	file_dialog.connect("file_selected", self, "_on_file_selected")
	add_child(file_dialog)
	file_dialog.popup_centered()

func _on_file_selected(path):
	var file = File.new()
	if file.open(path, File.READ) == OK:
		text = file.get_as_text()
		current_file_path = path
		file.close()

# 💾 Función para guardar archivo
func save_file():
	if current_file_path != "":
		var file = File.new()
		if file.open(current_file_path, File.WRITE) == OK:
			file.store_string(text)
			file.close()
	else:
		save_as_new_file()

func save_as_new_file():
	var file_dialog = FileDialog.new()
	file_dialog.mode = FileDialog.MODE_SAVE_FILE
	file_dialog.connect("file_selected", self, "_on_save_file_selected")
	add_child(file_dialog)
	file_dialog.popup_centered()

func _on_save_file_selected(path):
	var file = File.new()
	if file.open(path, File.WRITE) == OK:
		file.store_string(text)
		current_file_path = path
		file.close()

# ✨ Configuración de resaltado de sintaxis
func setup_syntax_highlighting():
	add_color_region('"', '"', Color(0.807843, 0.568627, 0.470588), true) # Strings
	add_color_region('//', '', Color(0.709804, 0.760784, 0.466667), true) # Comentarios de C++
	add_color_region('#', '', Color(0.709804, 0.760784, 0.466667), true) # Comentarios de Python

	var keyword_blue = ["return", "void", "bool", "const", "char", "for", "while", "true", "var", "in", "self"]
	var keyword_yellow = ["main", "printf", "new", "construct"] 
	var keyword_red = ["iostream", "fstream", "class"] 

	for a in keyword_blue:
		add_keyword_color(a, Color(0.360784, 0.639216, 0.87451))
	for b in keyword_yellow:
		add_keyword_color(b, Color(0.709804, 0.760784, 0.466667))
	for c in keyword_red:
		add_keyword_color(c, Color(0.807843, 0.568627, 0.470588))
