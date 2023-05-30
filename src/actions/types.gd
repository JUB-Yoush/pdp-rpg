class_name Types


enum Elements {NONE,ROCK,PAPER,SCISSORS}
const WEAKNESS_MAPPING = {
    # -1: strong and weak aganst nothing
    Elements.NONE:-1,
    Elements.ROCK: Elements.SCISSORS,
    Elements.SCISSORS: Elements.PAPER,
    Elements.PAPER: Elements.ROCK
}
enum ActionType {ATTACK,HEAL,MODIFIER}
enum ColorCost {RE,GR}
