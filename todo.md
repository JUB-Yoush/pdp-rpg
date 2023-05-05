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

- use hard coded interactions to make sure rpg systems work
- go one layer out and think about how players and enemies will notify the manager that it's thier turn
  - party: it's an array we go though (all party members act at the same time)
  - enemies: notified by purple blocks counting down
  - make the ui/ai systems that let partymems and enemies pick actions

- make more than just attackActions (figure out how to differetntiate them)
- add stat modifing actions (figure out a turn time limit system)


the battle system:
kinds of pieces:
- generic skill/action points
- attacking skills
- red: power points, gives you points to do active skills with 
- green: tech points, gives you points to do passive skills with 
- blue: defence, feeds into a slay the spire style defence pool that tanks damage before it reaches your HP
- yellow: increases multiplier for all other things? ~~(might be op) or gold (might not be helpful)~~ 
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
