extends Node2D
# CRPSY
# Enum with 5 States:
    # IncitingIncident: The player receives a call that lets them know who their next target is
        # EntryPointConditions:
        # # Condition A: The level loads for the first time 
        # # Condition B: After killing NPC, they finish the phone call
        # Behaviors:
        #     The Sniper: Calls the player and begins dialogue sequence (Check SniperPrototype)
        #     The Player: Answers the phone
        #     The NPC: Randomly spawns and follows a path
        # ExitPointConditions: The phone conversation finishes
    # Complication: The player has to find the person in the map
        # EntryPointConditions: The phone conversation finishes
        # Behaviors:
        #     The Sniper: Spawns to the position furthest from the current target
        #     The Player: Looks for NPC
        #     The NPC: Assigns a story (Check NPCPrototype)
        # ExitPointConditions: The player interacts with the NPC
    # Crisis: The player has to figure out the right things to say so that the NPC follows them to the sniper line
        # EntryPointConditions: The player interacts with the NPC
        # Behaviors:
        #     The Sniper: Goes to the location closest to the NPC
        #     The Player The player types into the text field and enters (Check PlayerPrototype)
        #     The NPC: The NPC responds to what the player said and either stands still, exits the conversation,
        #               or follows the player for a certain number of seconds depending on player text input for 
        #               5 total story beats (dialogue slides)
        # ExitPointConditions:
            # # Condition A: The player gives 3 bad responses 
            # # Condition B: The target reaches sniper point
    # Climax: The player either successfully gets the NPC killed or they fail and the sniper begins targeting the player
        # EntryPointConditions:
            # # Condition A: The player gives 3 bad responses 
            # # Condition B: The target reaches sniper point
        # Behaviors:
        #     The Sniper: If NPC killed, Calls the player and begins dialogue sequence
        #     The Sniper: If player has 3 failed NPC interactions, calls player and tells them they're being hunted now-
        #               # keep spawning at location closest to player (can harm player)
        #     The Player: Answers the phone
        #     The NPC: The NPC is erased from the scene when they are killed or out of view
        # ExitPointConditions: The phone conversation finishes 
    # Resolution: The game ends or they receive another call letting them know who their next target it
        # EntryPointConditions: The phone conversation finishes
        # Behaviors:
        #     The Sniper: If the player has enough money, begin game ending conversation
        #     The Player: Waits for Phone Call
        #     The NPC: Wait for Inciting Incident state
        # ExitPointConditions:
            # # Condition A: If the player doesn't have enough money yet, go back to IncitingIncident
            # # Condition B: Ending phone conversation finishes -> Back to Main Menu