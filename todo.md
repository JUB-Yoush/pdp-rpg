how does one make a panel de pon (at least the mechanics needed for my game)
- ~~generating 2d array of piece scenes~~
- ~~generating without existing matches ~~
- ~~moving cursor around~~
- ~~swaping blocks at cursor (make sure blocks can swap with nothing and if nothing is under them post swap then they fall)~~
- ~~check for clear (3 row or col)~~
- ~~remove cleared blocks, move others down~~
- ~~move other blocks down~~

now what:
- ~~design the different kinds of blocks there will be/whole battle system (PUSH AND PULL JAYDEN)~~
- ~~work on spawning different kinds of blocks and from the bottom~~ 
- make some sample data and a simple ui to interact with the systems with
- make sure there are no holes in the RPG system then work on going back and forth from pdp to the rpg



- design the rpg systems
  - party member stats:
	- Name
	- member id
	- HP (when it hits 0 you ded)
	- Atk (added to attacks dealt)
	- Def (subtracted from damage taken)
	- skills (array of skills they have)
  
  skill stats:
  - id
  - name
  - passive or active
  - cost to use
  - targets (self or enemies)
  - effect

  enemy stats:
  - name
  - id
  - HP
  - Attack
  - Def
  - Skills (same system as PCs, just make sure you stipulate who's using it)

resources:
- generic actions
- attack actions
- other actions
- hit event


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
