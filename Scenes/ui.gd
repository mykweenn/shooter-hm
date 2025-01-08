extends Control



func _process(delta):
	$AmmoLabel.text = str("Ammo: ", %Player.ammo)
	$ProgressBar.value = %Player.hp
	
