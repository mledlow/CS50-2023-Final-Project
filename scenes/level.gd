extends Node2D

var thunder_scene: PackedScene = preload("res://scenes/thunder.tscn")
var cure_scene: PackedScene = preload("res://scenes/cure.tscn")

func _ready():
	Globals.connect("wizard_cure_anim", wizard_cure_animation)
	Globals.connect("wizard_thunder_anim", wizard_thunder_animation)
	
func wizard_cure_animation():
	var cure = cure_scene.instantiate()
	$Spells.add_child(cure)
	Globals.wizard_health += 1000
	Globals.wizard_mana -= 100
	await get_tree().create_timer(1).timeout
	cure.queue_free()
	Globals.return_wizard_to_idle()

func wizard_thunder_animation():
	var thunder = thunder_scene.instantiate()
	$Spells.add_child(thunder)
	Globals.dragon_health -= 1500
	Globals.wizard_mana -= 100
	await get_tree().create_timer(1).timeout
	thunder.queue_free()
	Globals.return_wizard_to_idle()
