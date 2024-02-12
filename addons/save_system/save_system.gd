extends Node


# Caminho padrão do arquivo que será salve, se quiser pode mudar ele
const default_file_path : String = "user://save_data.sav"

# Encriptação se quiser evitar que players troquem saves entre si (evitar cheaters)
const encryption_key : String = "abcdefg1234567"
const use_encryption : bool = false
const perform_typecast_on_dictionary_keys : bool = true

var current_state_dictionary := {}
var base_resource_property_names := []

signal loaded
signal saved

func _ready():
	# Localiza quais propriedades por padrão existem
	# Cria um dict baseado no que foi encontrado
	var res := Resource.new()
	for property in res.get_property_list():
		base_resource_property_names.append(property.name)
	
	_load() # Carrega o arquivo salvo
	
func _exit_tree():
	save() # Salva ao sair.


# Apaga todos os save files.
func delete_all():
	current_state_dictionary.clear()


# Deleta informações específicas.
func delete(key_path : String):
	if not has(key_path):
		return
	
	if not _is_hierarchical(key_path):
		current_state_dictionary.erase(key_path)
		return
	
	var body = _get_variable_name_body(key_path)
	var head = _get_variable_name_head(key_path)
	_get_variable_at_path(body).erase(head)


func has(key_path : String) -> bool:
	if _is_hierarchical(key_path):
		var variable_head = _get_variable_name_head(key_path)
		var key_parent = _get_variable_at_path(_get_variable_name_body(key_path))
		if key_parent == null:
			return false
		
		var valid_as_object : bool = (key_parent is Object and variable_head in key_parent)
		var valid_as_dict : bool = (not key_parent is Object and key_parent.has(variable_head))
		return key_parent != null and (valid_as_object or valid_as_dict)
	else:
		return current_state_dictionary.has(key_path)


# Atribui um valor para uma chave p/ salvar
func set_var(key_path : String, value):
	key_path = _sanitize_key_path(key_path)
	if _is_hierarchical(key_path):
		if value is Resource:
			value = _resource_to_dict(value)
		elif value is Array:
			value = _parse_array(value)
		elif value is Dictionary:
			value = _typecast_dictionary_keys(value)
		
		if not has(key_path):
			return
		
		var result = _get_parent_dictionary(key_path)
		var variable_name : String = _get_variable_name_head(key_path)
		result[variable_name] = value
		return
	
	if value is Resource:
		current_state_dictionary[key_path] = _resource_to_dict(value)
	else:
		current_state_dictionary[key_path] = value


# Salve o estado atual.
# Precisa de arquivos diferentes para vários save (tipo save do RE4)
func save(file_path : String = default_file_path):
	var file : FileAccess
	if use_encryption:
		file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, encryption_key)
	else:
		file = FileAccess.open(file_path, FileAccess.WRITE)
	
	current_state_dictionary = _typecast_dictionary_keys(current_state_dictionary)
	file.store_string(JSON.stringify(current_state_dictionary, "\t"))
	emit_signal("saved")


# Retorna a variável
func get_var(key_path : String, default = null):
	key_path = _sanitize_key_path(key_path)
	var var_at_path = _get_variable_at_path(key_path)
	if var_at_path != null:
		return var_at_path
	else:
		return default


func _parse_array(array : Array) -> Array:
	var result := []
	for element in array:
		if element is Resource:
			result.append(_resource_to_dict(element))
		elif element is Array:
			result.append(_parse_array(element))
		else:
			result.append(element)
	return result


# Chave principal que divide o aruqivo
func _is_hierarchical(key : String) -> bool:
	return key.find(":") != -1


# Carrega o diretorio raiz
func _load(file_path : String = default_file_path):
	var file : FileAccess
	if use_encryption:
		file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, encryption_key)
	else:
		file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		current_state_dictionary = JSON.parse_string(file.get_as_text())
		if perform_typecast_on_dictionary_keys:
			current_state_dictionary = _typecast_dictionary_keys(current_state_dictionary)
	
	emit_signal("loaded")
	
func _typecast_dictionary_keys(input_dict : Dictionary) -> Dictionary:
	var typed_dict := {}
	for key in input_dict.keys():
		var value = input_dict[key]
		
		var typed_key = _get_typed_key(key)
	
		if value is Dictionary:
			typed_dict[typed_key] = _typecast_dictionary_keys(value)
		else:
			
			if value is Array:
				for i in range(value.size()):
					if value[i] is Dictionary:
						value[i] = _typecast_dictionary_keys(value[i])
			typed_dict[typed_key] = value
	return typed_dict

func _get_typed_key(key):

	if key is String and key.begins_with("(") and key.ends_with(")") and key.find(",") != -1:
		var comma_count : int = key.count(",")

		var supposed_vector_value = str_to_var("Vector" + str(comma_count + 1) + key)
		if supposed_vector_value != null:
			return supposed_vector_value
		else:
			return key
	elif (key is String and str_to_var(key) == null) or (not key is String):
		return key
	else:
		return str_to_var(key)


# Deve ser ativado a cada entrada que entra nas
# Funções internas
func _sanitize_key_path(key_path : String) -> String:
	var sanitized_string : String = ""
	key_path = key_path.lstrip(":").rstrip(":") # Tira o : da chave
	
	var i : int = 0
	while i < key_path.length():
		sanitized_string += key_path[i]
		if key_path[i] == ":":
			while(key_path[i + 1] == ":"):
				i += 1
		i += 1
	return sanitized_string


# Retorna o caminho principal da chave
func _get_variable_root(key_path : String) -> String:
	key_path = _sanitize_key_path(key_path)
	if _is_hierarchical(key_path): 
		return key_path.substr(0, key_path.find(":"))
	else:
		return key_path

func _get_variable_name_body(key_path : String) -> String:
	key_path = _sanitize_key_path(key_path)
	if _is_hierarchical(key_path): 
		return key_path.substr(0, key_path.rfind(":"))
	else:
		return key_path

func _get_variable_name_head(key_path : String) -> String:
	key_path = _sanitize_key_path(key_path)
	if _is_hierarchical(key_path): 
		return key_path.substr(key_path.rfind(":") + 1)
	else:
		return key_path


# Retorna a chave pela hierarquia do dict usado em recurso.
# Se o caminho não for hieraquizado, a base do arquivo é usada.

func _get_parent_dictionary(key_path : String, carried_dict : Dictionary = current_state_dictionary):
	key_path = _sanitize_key_path(key_path)
	var depth_count = key_path.count(":")
	if depth_count == 0:
		return carried_dict
	elif depth_count == 1:
		return carried_dict[key_path.split(":")[0]]
	
	var first_splitter_index = key_path.find(":")
	var first_name = key_path.substr(0, first_splitter_index)
	key_path = key_path.trim_prefix(first_name + key_path[first_splitter_index])
	
	if carried_dict[first_name] is Object:
		carried_dict[first_name] = _resource_to_dict(carried_dict[first_name])
	return _get_parent_dictionary(key_path, carried_dict[first_name])

func _get_variable_at_path(key_path : String, carried_dict : Dictionary = current_state_dictionary):
	key_path = _sanitize_key_path(key_path)
	var parent_dict = _get_parent_dictionary(key_path)
	if parent_dict != null:
		var variable_head = _get_variable_name_head(key_path)
		if not parent_dict is Object and parent_dict.has(variable_head):
			return parent_dict[variable_head]
		elif parent_dict is Object and variable_head in parent_dict:
			return parent_dict.get(variable_head)
		else:
			return null
	else:
		return null


func _resource_to_dict(resource : Resource) -> Dictionary:
	var dict := {}
	for property in resource.get_property_list():
		if base_resource_property_names.has(property.name) or property.name.ends_with(".gd"): 
			continue
		
		var property_value = resource.get(property.name)
		
		if property_value is Array:
			dict[property.name] = _parse_array(property_value)
		else:
			dict[property.name] = property_value
	return dict

func _dict_to_resource(dict : Dictionary, target_resource : Resource) -> Resource:
	for i in range(dict.size()):
		var key = dict.keys()[i]
		var value = dict.values()[i]
		target_resource.set(key, value)
	return target_resource
