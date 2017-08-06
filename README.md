
# Balj

Balj is a platformer where one plays as a bouncing ball, with the added bonus
of antigravity. The goal of the game is to reach a green square without touching
any red squares. This game is ran from the command line. It uses the
[LÖVE](https://love2d.org/) game engine. To run the game enter the following at
the command line.

```
> love balj <a path to a level file>
```

Levels can be found in the level/ directory.

## Controls

- left: Applies a leftward force to the ball.
- right: Applies a righttward force to the ball.
- down: Applies a downward force to the ball.
- up: Negates the effect of gravity.
- backspace: Resets the level.

## Designing a Level

Levels are simply text files containing a grid of the digits 0-4. An example
level would be

```
22222
30004
30104
30004
22222
```

0s correspond to empty spaces. 1 corresponds to the balls spawn point. 2, 3, and
4 correspond to blue, red, and green blocks, respectively. Pull requests with
new levels are welcome.
