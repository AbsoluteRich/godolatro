extends Control

const suits: Array[String] = ["Clubs", "Diamonds", "Hearts", "Spades"]
var deck = []


func construct_deck():
	for suit in suits:
		for rank in range(2, 13):
			var properRank: String

			match rank:
				11:
					properRank = "J"
				12:
					properRank = "Q"
				13:
					properRank = "K"
				14:
					properRank = "A"
				_:
					properRank = str(rank)

			deck.append(suit + properRank)
	deck.shuffle()


func draw_card():
	var chosenCard: String
	if deck.is_empty():
		return "Clubs2"  # Todo: Special logic required
	
	chosenCard = deck[0]
	deck.pop_at(0)
	return chosenCard


func draw_hand():
	for child in %Cards.get_children():
		child.queue_free()
	
	for i in range(7):
		var cardData = draw_card()
		var card = TextureRect.new()
		card.texture = load("res://assets/cards/card%s.png" % cardData)
		%Cards.add_child(card)


func _ready():
	construct_deck()
	draw_hand()


func _input(event):
	if event.is_action_pressed("gamble"):
		draw_hand()
