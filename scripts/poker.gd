extends Control

var deck: Array[Card] = []


func construct_deck() -> void:
	for suit in Card.Suits.values():
		for rank in range(2, 15):
			# Behind the scenes, Enums are technically just an array of ints
			# Therefore, something that accepts an Enum as a parameter needs a int, not a String
			deck.append(Card.create(suit, rank))
	deck.shuffle()
	assert(deck.size() == 52)


func sort_cards(card_list: Array[Node]) -> Array[Node]:
	var list_length: int = len(card_list)

	for i in range(list_length):
		var swapped: bool = false

		for j in range(0, list_length - i - 1):
			# Swap is set to true if the FIRST card is "more" than the SECOND card
			var swap: bool = false

			# Rank sorting
			if card_list[j].rank > card_list[j + 1].rank:
				swap = true

			# Suit sorting (uses the rule Clubs > Diamonds > Hearts > Spades)
			# Because there can't be duplicate suits (at least for now), this always produces a definitely sorted list
			elif card_list[j].rank == card_list[j + 1].rank:
				if card_list[j].suit > card_list[j + 1].suit:
					swap = true

			if swap:
				var temp: Card = card_list[j]
				card_list[j] = card_list[j + 1]
				card_list[j + 1] = temp
				swapped = true

		if swapped == false:
			break

	return card_list


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
			print(child)


func _on_discard_button_pressed() -> void:
	for child in %Cards.get_children():
		if child.selected:
			Card.all_selected -= 1
			child.queue_free()
			deal_cards(1)


func _on_sort_button_pressed() -> void:
	var all: Array[Node] = %Cards.get_children()
	var sorted: Array[Node] = sort_cards(%Cards.get_children().duplicate())

	for node in all:
		print("ALL: ", node)

	for node in sorted:
		print("SORTED: ", node)
