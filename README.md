# ARMHeistRPG
My final project for EE 3752 from Fall 2018. Written in Assembly, a simple text-based game that attempts to somewhat simulate a Tabletop RPG.

At the beginning of the game, you allocate points to different skills (how many points to allocate depends on difficulty). 
Several challenges face you in the game, for each one you must choose an approach that best suits your skill set.
After choosing an action, a random number is generated from 1 to 20 (simulating rolling a 20-sided die), your skill bonus is added, 
and this number is compared against some difficulty score. If you meet or exceed the score, the action succeeds. 
If not, you fail; the consequences of failure depend on the exact action.

The RNG algorithm was based off that of Super Mario 64, in particular [this video](https://www.youtube.com/watch?v=MiuLeTE2MeQ).

The easiest way to run the code is to use Keil uVision and open the Project.ubproj file.

[ProjectMain.s](ProjectMain.s) contains the main game logic for all choices and outcomes.

[Subroutines.s](Subroutines.s) contains useful subroutines. Most notably the routine to make a die roll and its RNG algorithm.

[Memory.s](Memory.s) contains all the strings used to present information to the player.

[ProjectReport.docx](ProjectReport.docx) is my report for the project, which includes much more in-depth information about the game's design, choices, and code.
