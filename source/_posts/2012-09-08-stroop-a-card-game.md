---
title: "Stroop: A Card Game"
date: '2012-09-08 11:26'
description:
categories: 
tags: [fun, games]
---

Stroop is a card game for two or more players and a dealer, who also serves as referee. The objective is to collect the most cards, by naming cards that differ in rank and suit color from the cards that the dealer reveals.

Stroop is played with a standard 52-card deck. The dealer shuffles the deck and turns it face down; this is the *stock pile*. At the beginning of each round, the dealer removes the top card (the *top card*) from the stock pile, and places it face up. This begins the *stake pile*. If the stake pile contains cards, the top card is placed on top of them.

Once the dealer has revealed the top card, all players become *active*. An active player may *call* a card name (e.g. “five of spades”). The first active player to call a *qualifying card* wins the round and collects the discard pile. A qualifying card is a card that differs in both rank and suit color from the top card in the discard pile, as described below.

# Qualified Cards
To qualify, a card must have a different rank and a different color suit than the top card. If the top card is a face card or an ace, the qualifying card must additionally be a face card or an ace. If the top card is a number card (two through ten), the qualifying card must additionally be a number card.

Examples:

| Top Card    | Qualifying Calls | Non-Qualifying Calls |
| :---------- | :--------------- | :------------        |
| 3♠          | 4♡, 9♧           | 3♡, 4, A♡, J♣        |
| 6♢          | 2♠, 8♣           | 3♢, 6, J♡            |
| Q♡          | K♠, A♦           | 9♦, Q♦, A♢           |
| A♣          | J♢, Q♡           | 10♢, 7♣, J♠          |

In a two player game, if one player names a card that doesn't qualify, the other player wins the dealt card. Otherwise, the first player to name a qualifying card wins the card.

# Active Players
When the top card is dealt, all players are active. A player who calls a non-qualifying card becomes inactive, if there are other players who have not yet called a non-qualifying card in this turn. Once all players have called non-qualifying cards, all players become active for the remainder of the round.

Example: Player one wins on the first call.

| Top Card | Player 1 Calls | Player 2 Calls | Result                                |
| :------- | :------------: | :------------: | :-----                                |
| 3♠       |                |                | Round starts; both players are active |
| 3♠       | 2♡             |                | Player 1 wins the round               |

Example: Player one makes an invalid call; player two wins.

| Top Card | Player 1 Calls | Player 2 Calls | Result                                |
| :------- | :------------: | :------------: | :-----                                |
| 4♢       |                |                | Round starts; both players are active |
| 4♢       | 2♡             |                | Player 1 becomes inactive             |
| 4♢       | 3♣             |                | No effect; player 1 is inactive       |
| 4♢       |                | 3♣             | Player 2 wins the round               |

Example: Both players make invalid calls.

| Top Card | Player 1 Calls | Player 2 Calls | Result                                                |
| :------- | :------------: | :------------: | :-----                                                |
| J♣       |                |                | Round starts; both players are active                 |
| J♣       | 2♡             |                | Player 1 becomes inactive                             |
| J♣       |                | Q♠             | Player 2 miscalls; now both players are active acgain |
| J♣       | Q♡             |                | Player 1 wins the round                               |

# Call Ties
If two or more active players call a qualifying card simultaneously, the first player to *complete* the call (in the judgement of the dealer) wins the turn. If several active players complete qualified calls simultaneously, the first player to *begin* the call (in the judgement of the dealer) wins the turn. If several active players begin and end qualified calls simultaneously, the round is a draw and the next card is placed on top of it (and the winner of that round wins the entire discard pile).

# Variants
We tried a variant where each player is dealt a “match card”: if the top card matches the match card’s suit, a qualifying card *for that player* must match the suit instead of differ from it’s color; and if the top card matches the match card’s rank, a qualifying for that player must match the top card’s rank instead of differing from it.

For example, if player one’s match card is a 9♠, and a 9♡ is dealt, player one must call a 9♡ or 9♢ to win the round (but player two cannot call a nine, unless player two’s match card is also a nine). If player one’s match card is a 9♠ and a K♠ is dealt, player one must call an A♠, J♠, or Q♠ to win.

This variant was intended to keep the game from getting too easy after we’d played it for a while and therefore presumably gotten better at it. It turned out to be unnecessary. Presumably there’s a [practice effect](http://en.wikipedia.org/wiki/Power_Law_of_Practice) eventually, but in our limited experience the game was actually harder the second time we sat down for it.

# Origin
Stroop is named after the [Stroop Effect](http://en.wikipedia.org/wiki/Stroop_effect). I made it up last weekend after showing the kids [GOPS](http://en.wikipedia.org/wiki/GOPS), and we played it over the weekend.
