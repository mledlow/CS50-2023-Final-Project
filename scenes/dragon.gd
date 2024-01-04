extends AnimatedSprite2D

var dragon_action: String

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect("dragon_hit", start_dragon_damage_anim)
	Globals.connect("dragon_action_signal", start_dragon_action)
	Globals.connect("battle_end", start_dragon_death)
	Globals.connect("go_to_battle", reset_dragon)
	Globals.connect("start_battle_over", dragon_from_start)

func start_dragon_action(action):
	if action == 'bite':
		await start_dragon_walk_to_wizard_for_bite()
		await start_dragon_bite()
		await start_dragon_walk_back_to_position()
	else:
		await start_dragon_walk_to_wizard()
		await start_dragon_attack()
		await start_dragon_walk_back_to_position()
	Globals.start_wizard_turn()

func start_dragon_walk_to_wizard():
	play('walk')
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(650,300), 2.5)
	await tween.finished

func start_dragon_walk_to_wizard_for_bite():
	play('walk')
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(650,300), 2.5)
	await tween.finished

func start_dragon_damage_anim():
	play('hurt')
	await get_tree().create_timer(1).timeout
	play('idle')

func start_dragon_bite():
	play('attack2')
	await get_tree().create_timer(2).timeout
	Globals.deal_damage_to_wizard(500)
	await get_tree().create_timer(0.5).timeout
	play('idle')

func start_dragon_attack():
	play('attack1')
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(625,300), 0.5)
	await get_tree().create_timer(1).timeout
	Globals.deal_damage_to_wizard(250)
	await get_tree().create_timer(1).timeout
	play('idle')
	
func start_dragon_walk_back_to_position():
	scale = Vector2(-1.5,1.5)
	play('walk')
	var tween = create_tween()
	tween.tween_property(self, 'position', Vector2(1080,300), 2.5)
	await tween.finished
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(1.5,1.5)
	play('idle')
	
func start_dragon_death(outcome):
	if outcome == 'dragon_death':
		play('death')
		await get_tree().create_timer(5).timeout
		Globals.start_ending_screen(outcome)
		

func reset_dragon(_outcome):
	play('idle')

func dragon_from_start():
	play('idle')
