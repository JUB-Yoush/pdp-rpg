how does one make a panel de pon (at least the mechanics needed for my game)
- ~~generating 2d array of piece scenes~~
- 
- ~~generating without existing matches ~~
- ~~moving cursor around~~
- ~~swaping blocks at cursor (make sure blocks can swap with nothing and if nothing is under them post swap then they fall)~~
- ~~check for clear (3 row or col)~~
- ~~remove cleared blocks, move others down~~
- ~~move other blocks down~~

### now what:
- ~~design the different kinds of blocks there will be/whole battle system (PUSH AND PULL JAYDEN)~~
- ~~work on spawning different kinds of blocks and from the bottom~~ 

~~what's left of the puzzle systems:~~
~~- design a combo system (pieces in a combo are worth thier combo amount + 1)~~
~~- fix score allocation (1 point per piece, any pieces above 3 are worth 2 each)~~
~~- let the player spend 5 seconds to spawn in an extra row?~~


~~- make more than just attackActions (figure out how to differetntiate them)~~
	~~- buff actions~~
	~~- debuff actions~~
	~~- heal actions~~
~~- add stat modifing actions (figure out a turn time limit system)~~

- make all actions have a red and green cost
- get skill cost working (feed puzzle points through the battlers?)
- add bad Ai for enemies to select actions (weighted randomization)
- ko/negative hp state for pm

- add Ui for users to select their actions and targets
- heal party in between fights
- create content
- radomization
- done mvp!!!

the battle system:
kinds of pieces:
- generic skill/action points
- attacking skills
- red: power points, gives you points to do active skills with 
- green: tech points, gives you points to do passive skills with 
- blue: defence, feeds into a slay the spire style defence pool that tanks damage before it reaches your HP
- yellow: gives time back
- purple: enemy attacks, countdown style (seperate from other styles of blocks), once it hits 0 an enemy acts
- garbage: pdp style garbage logs that spawn in from the top (not nessicary ig?)
- topping out is a insta die
- you're given a timer of 10 seconds to clear as many blocks as possible
- clears of more than 3 at a time and chains give extra time +2 for every additional block
- after that you get to act on your turn (spend the pp and tp to beat up the enemies lol) 
- enemies then add more blocks to the grid and the timer restarts
- pokemon style effectiveness types? and extra effective moves provide a bonus on the next puzzle round
- alternate between puzzle rounds and spending rounds until enemies die or you die
- don't even THINK about dungeon crawling until this is done >:(

post mvp:
- fix things that could be static classes/objects instead of nodes
- fix modifers checking based on strings instead of an enum
- recognize combos (also maybe chains??)
- real enemy ai
- dungeon crawling
- leveling up
- items
- status effects
- multi action attacks (attacking + status + heal)
- crits and weak hits give you more puzzle time
- recruiting by clearing some sort of preset puzzle?
