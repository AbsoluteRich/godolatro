extends Control

var rng = RandomNumberGenerator.new()
const suits = ["Clubs", "Diamonds", "Hearts", "Spades"]


func draw_hand():
	for i in range(7):
		var suit = suits.pick_random()
		var rank = rng.randi_range(2, 14)
		var card = TextureRect.new()

		match rank:
			11:
				rank = "J"
			12:
				rank = "Q"
			13:
				rank = "K"
			14:
				rank = "A"

		card.texture = load("res://assets/cards/card%s%s.png" % [suit, rank])

		%Cards.add_child(card)


func _ready():
	draw_hand()


func _input(event):
	if event.is_action_pressed("gamble"):
		draw_hand()
