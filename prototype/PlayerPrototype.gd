extends MeshInstance2D
#CRSPY 

# Logic: Convert all input text to lowercase 
# Logic: Only accept A-Z, 1-9, and " " input
# Rule: If special condition is fulfilled, automatically consider input as that type of response
# Rule: If an entire phrase is said, automatically consider player input as that type of response
# Rule: If an entire phrase is not said, pick the catagory with the highest amount of keywords said

# Response Databases:
    # Facilitation (These responses encourage the NPC to say more, to continue the story)
        # Phrases:
            # I agree
            # Go on
            # Keep going
            # I'm listening
            # I understand
            # That's cool
        # Key Words:
            # Yes
            # No
            # Maybe
            # Okay
            # Ok
            # Bet
    # Silence (Depending on the context, this is either disrepectful or used to show silent attentiveness)
        # Special Condition 1: Input Text Char length == 0
        # Special Condition 2: Text contains only spaces
    # Reflection (This response echos the words of the NPC. In other words, you repeat they say)
        # Special Condition: 65% of the words of most recent NPC dialogue match with input text
    # Clarification (These response ask the NPC to explain)
        # Special Condition: If any of these keywords are found
        # Phrases:
            # What do you mean
        # Key Words:
            # Explain
            # Clarify
            # Define
    # Interpertation (This links events, makes associations, or implies cause)
        # Special Condition 1: Word found in NPC story
    # Disrespecful (Insulting to the NPC)
        # Special Condition: If any of these keywords are found
        # Key Words:
            # Bitch
            # Ho
            # Hoe
            # Bigot
            # Blowhard
            # Commie
            # Coward
            # Crazy
            # Crony
            # Douche
            # Elitist
            # Extremist
            # Fanatic
            # Fencesitter
            # Fool
            # Stupid
            # Moron
            # Idiot
            # Jackass
            # Ass
            # Asshole
            # Loon
            # Loser
            # Lunatic
            # Misogynist
            # Moron
            # Nitwit
            # Nut
            # Nutjob
            # Racist
            # Scum
            # Thug
    # Confrontation (Mentions NPC's crime)
        # Special Condition: If any of these keywords are found 
        # Key Words: 
            # Extortion
            # Embezzlement
            # Forgery
            # Fraud
            # ID Theft
            # Insider Trading
    # Irrelevant (Pharser doesn't understand)
        # Special Condition: Doesn't fit in any of the ^ catagories 
