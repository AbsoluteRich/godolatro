extends Control

const suits: Array[String] = ["Clubs", "Diamonds", "Hearts", "Spades"]
var deck: Array[Card] = []


func construct_deck() -> void:
	for suit in suits:
		for rank in range(2, 13):
			deck.append(Card.create(suit, rank))
	deck.shuffle()


func draw_card() -> Card:
	var chosenCard: Card
	if deck.is_empty():
		return null

	chosenCard = deck[0]
	deck.pop_at(0)
	return chosenCard


func deal_cards(count: int) -> void:
	for i in range(count):
		var new_card: Card = draw_card()

		if new_card != null:
			%Cards.add_child(new_card)


func _ready() -> void:
	construct_deck()
	deal_cards(7)


func _on_play_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			print(child.rank, child.suit)


func _on_discard_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			Card.all_selected -= 1
			child.queue_free()
			deal_cards(1)
