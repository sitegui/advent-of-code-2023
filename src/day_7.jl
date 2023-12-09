struct Hand
    cards
    bid
    hand_type_value
end

card_values = reverse([
    'A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'
])

hands = []
for line in readlines("data/day_7")
    cards = map(collect(line[1:5])) do card
        findfirst(e -> e == card, card_values)
    end
    
    cards_counts = Dict()
    for card in cards
        cards_counts[card] = get(cards_counts, card, 0) + 1
    end
    counts = sort(collect(values(cards_counts)))
    bid = parse(Int, line[7:end])

    hand_type_value = if counts == [5]
        10
    elseif counts == [1, 4]
        9
    elseif counts == [2, 3]
        8
    elseif counts == [1, 1, 3]
        7
    elseif counts == [1, 2, 2]
        6
    elseif counts == [1, 1, 1, 2]
        5
    elseif counts == [1, 1, 1, 1, 1]
        4
    else
        error("impossible")
    end
    
    sorted_cards = sort(collect(cards))

    push!(hands, Hand(cards, bid, hand_type_value))
end

sort!(hands, by=hand -> (hand.hand_type_value, hand.cards...))

total = 0
for (i, hand) in enumerate(hands)
    global total += i * hand.bid
end

println(hands)
println(total)