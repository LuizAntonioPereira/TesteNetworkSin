extends VBoxContainer

func _ready():
  Network.connect("emite_text", self, "update_text")  

func update_text(text):
  $Status.text += text

func _on_ServerButton_button_up():
	Network.host_room()
	pass # Replace with function body.


func _on_ClientButton_button_up():
	Network.join_room($HBoxContainer/TextEdit.text)
	pass # Replace with function body.


func _on_LineEdit_text_entered(new_text):
	Network.send_message(new_text)
	pass # Replace with function body.
