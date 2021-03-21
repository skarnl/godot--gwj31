extends MeshInstance2D
# CRSPY

# Name (Randomly Picked)
    # James
    # John
    # Robert
    # Mike
    # Will
    # David
    # Richard
    # Joe
    # Thomas
    # Charles
    # Christopher
    # Daniel
    # Matthew
    # Anthony
    # Donald
    # Mark
    # Paul
    # Steven
    # Andrew
    # Kenneth
    # Joshua
    # Kevin
    # George
    # Edward
    # Ronald
# States:
    # Enter Conversation
        # Enter: Player inside of NPC collision region
        # Exit: Player interacts with NPC in collision region
        # Transition To: Stand Still State
    # Follow Player for 30 Seconds
        # Enter: Player Input Determined
        # Exit: After 30 Seconds
        # Transition To: Stand Still State
    # Follow Player for 15 Seconds
        # Enter: Player Input Determined
        # Exit: After 15 Seconds
        # Transition To: Stand Still State
    # Follow Player for 5 Seconds
        # Enter: Player Input Determined
        # Exit: After 5 Seconds
        # Transition To: Stand Still State
    # Stand Still
        # Enter: From Enter Conversation and Follow Player States
        # Exit: Player Input Determined
        # Transition To: Follow Player States or Exit Conversation State
    # Exit Conversation
        # Enter:
            # Condition A: Silence for 10 seconds
            # Condition B: Character Type Determined
        # Exit: After saying Exit Conversation Message

# Character Types (Before the NPC enters next beat, NPC responds to player input based on character type)  <- Database
    # Average
        # Facilitation:
            # Generic Replies:
                # Mhm
                # So yeah
            # Behavior: NPC enters follow player for 30 seconds state
        # Silence:
            # Generic Replies:
                # uhhh
                # ...
            # Behavior: Stands still for 3 seconds before saying new beat if his happens twice, NPC enters exit conversation state
        # Reflection:
            # Generic Replies:
                # Mhm
                # So yeah
            # Behavior: NPC enters follow player for 5 seconds state
        # Clarification:
            # Generic Replies:
                # haha nevermind that
            # Behavior: NPC enters follow player for 15 seconds state
        # Interpertation:
            # Generic Replies:
            # Behavior: NPC enters follow player for 15 seconds state
        # Disrespecful:
            # Generic Replies:
                # okay well screw you too then
                # that's disrespectful 
            # Behavior: NPC enters exit conversation state
        # Confrontational:
            # Generic Replies:
                # I don't know what you're talking about
                # Uhh haha
                # ...
            # Behavior: NPC stops following player
        # Incomprehensible:
            # Generic Replies:
                # Uhhh ok
            # Behavior: NPC stops following player
        # Exit Conversation: 
            # Generic Replies:
                # Laters
                # Bye
                # Cya 
            # Behavior: NPC deleted when out of view
    # Reserved
    # Self-Centered
    # Role Model
# Conversation Topics (This determines story beats) <- Database
    # Vacation
        # Set 1:
            # Beat 1:
                # Average Dialogue:
                # Reserved Dialogue:
                # Self-Centered Dialogue:
                # Role Model Dialogue:
            # Beat 2:
            # Beat 3:
            # Beat 4:
            # Beat 5
    # Family
    # Sports
    # Art
# Story <- Random Range
    # Extortion ($2000 -> $3000)
    # Embezzlement ($500 -> $1000)
    # Forgery ($200 -> $1000)
    # Fraud ($250 -> $1000)
    # ID Theft ($400 -> $1000)
    # Insider Trading ($250 -> $1000)
# Bounty (This determines how much money player gets if NPC is killed)


# Example 1
    # Character Type: Reserved
    # Conversation Topics: Vacation
    # Story: Insider Trading
    # Bounty: $800
    # (Beat 1) NPC Says: "Hey"
        # They will:
            # Follow for 30 Seconds if:
                # Databases:
            # Follow for 20 Seconds if:
            # Follow for 10 Seconds if:
            # Follow for 5 Seconds if:
            # Stay Still if: Irrelevant Database
            # Leave Player if: Disrepect Database
    # (Beat 2) NPC Says: "So are you from around here?"
        # They will:
            # Follow for 30 Seconds if:
            # Follow for 20 Seconds if:
            # Follow for 10 Seconds if:
            # Follow for 5 Seconds if:
            # Stay Still if:
            # Leave Player if:
    # (Beat 3) NPC Says: "Actually I'm going on vaccation soon haha"
        # They will:
            # Follow for 30 Seconds if:
            # Follow for 20 Seconds if:
            # Follow for 10 Seconds if:
            # Follow for 5 Seconds if:
            # Stay Still if:
            # Leave Player if:
    # (Beat 4) NPC Says: "I don't really know "
        # They will:
            # Follow for 30 Seconds if:
            # Follow for 20 Seconds if:
            # Follow for 10 Seconds if:
            # Follow for 5 Seconds if:
            # Stay Still if:
            # Leave Player if:
    # (Beat 5) NPC Says:
        # They will:
            # Follow for 30 Seconds if:
            # Follow for 20 Seconds if:
            # Follow for 10 Seconds if:
            # Follow for 5 Seconds if:
            # Stay Still if:
            # Leave Player if: