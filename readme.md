# **DK Coach** #

## A MAME plugin to assist with Donkey Kong gameplay 

At the moment,  the plugin only helps you with the elevator/springs stage.
 - The type of the latest generated spring is displayed in game.  Springs have a type between 0 and 15.  0 being the shortest,  15 being the longest.
 - An alert appears for short (0-6) and long (12-15) springs.
 - The fixed safe zones on DK's girder appear in green
 - The variable danger zones on DK's girder appear in red

Compatible with MAME and WolfMAME versions 0.200 and above.
The Plugin is installed by copying the "dkcoach" folder into your MAME plugins folder.

The Plugin is activated by adding `-plugin dkcoach` to your mame arguments e.g.
`mame dkong -plugin dkcoach`  
