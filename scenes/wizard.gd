extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("wizard_action_signal", start_wizard_action)
	Globals.connect('battle_end', start_wizard_death)
	Globals.connect('wizard_hit', start_wizard_hit)
	Globals.connect('wizard_back_to_idle', start_wizard_idle)
	Globals.connect("go_to_battle", reset_wizard)
	Globals.connect("start_battle_over", start_wizard_idle)


func start_wizard_action(action):
	if action == 'attack':
		await start_wizard_walk_into_melee()
		await start_wizard_attack()
		await start_wizard_walk_back_to_place()
	elif action == 'magic':
		pass
	elif action == 'thunder':
		await start_wizard_thunder()
		await get_tree().create_timer(1.5).timeout
	elif action == 'cure':
		await start_wizard_cure()
		await get_tree().create_timer(1.5).timeout
	else:
		Globals.wizard_defending = true
	
	play('idle')
	if action != 'magic' && Globals.dragon_health > 0:
		Globals.start_dragon_turn()
	
	

func start_wizard_walk_into_melee():
	var tween = create_tween()
	play('run')
	tween.tween_property(self, 'position', Vector2(670,400), 1)
	await tween.finished
	await get_tree().create_timer(0.1).timeout

func start_wizard_attack():
	play('attack')
	await get_tree().create_timer(0.2).timeout
	Globals.dragon_health -= 500
	await get_tree().create_timer(0.1).timeout
	

func start_wizard_walk_back_to_place():
	scale = Vector2(-0.4,0.4)  # flips the wizard for the walk back
	var tween = create_tween()
	play('run')
	tween.tween_property(self, 'position', Vector2(300,400), 1)
	await tween.finished
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(0.4,0.4)
	
func start_wizard_hit():
	play('damage')
	await get_tree().create_timer(0.4).timeout
	play('idle')

func start_wizard_death(outcome):
	if outcome == 'wizard_death':
		play('die')
		await get_tree().create_timer(1.2).timeout
		Globals.start_ending_screen(outcome)

func start_wizard_thunder():
	play('attack')
	await get_tree().create_timer(0.2).timeout
	Globals.play_thunder_anim()
	
func start_wizard_cure():
	play('attack')
	await get_tree().create_timer(0.2).timeout
	Globals.play_cure_anim()
	
func start_wizard_idle():
	play('idle')

func reset_wizard(_outcome):
	play('idle')
