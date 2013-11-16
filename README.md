CSM/SEM2220 Mobile Solutions Assessed Assignment 2013-14
========================================================

iOS Welsh Vocabulary App
========================

> Neil Taylor
>
> Hand-out date: Friday 15th November 2013
>
> Hand-in date: Monday 2nd December 2013
>
> 20% of overall assessment
>
> (Approximately 17 hours)

The	problem
-----------

In the worksheets, you have developedan initial version of a table-based application that stores English and Welsh words.In this assignment, you will extend this application to add functionality that is described in this document.

A starting project has been created and is available on Blackboard. Screenshots for the application are shown below. This is related to the application that is described in worksheet 5.

<!-- Screenshots here -->

The Main Screen includes two changes from that describedin Worksheet 5. Firstly, the table uses a custom cell, which is linked to a new class `WordTableCell`. Secondly, there is a `UISegmentedControl` in the Navigation Bar. This is used to toggle between ordering the words in the list as English or Welsh. 

To support the feature to toggle the language to order the lists, an enum has been introduced to the `SharedData` class.

The database access has been updated. One change has been made to the insertion of words. If the user enters a word that already exists in the database, the word is not added again. The SharedData class has been modified to add this functionality.

In this assignment, you will build on concepts from the lectures and practical sessions. You will also be expected to do some investigation into new parts of the API to tackle some features. 

Your Task
---------

Change the application to meet the following requirements.

**Note:** In the following descriptions, there are references to the use of words. Wherever you see this in the requirements, you should assume that the word, e.g. the English or Welsh word, could be a phrase with several words in it. 

### FR1: Add fields to the word link

The Add screen, shown in Figure 1, allows the user to enter details about a word and the translation insecond language. In this first step, you should allow the user to enter the following details: 

* **Context** - this is a short phrase that is used to explain when this word can be used. For example, the word Ysgolin Welsh can mean two different things. It can mean School or Ladder. For context, you could set the context to “for education” for the first entry and “for climbing” in the second entry. 
* **Area** - in Welsh, some words are used in the north and some in the south. Add the ability for the user to record this. For example, there may be anoptionto choose one of three values: Both (the default), North and South. 
* **Notes** - the user can add notes, such as examples on how to use the words/phrases. This might go over a few lines; investigate the use of the `UITextView`. In addition to adding a way to enter the data, make changes to store this in the database. If the user hasn’t filled in either of the English and Welsh fields, the Done button should not be enabled. The data fields listed above are optional. Look in the documentation for a way to track edits in a text field.


### FR2: Update the custom table cell

Edit the custom cell. Think about what information should be shown on this view to be useful. It currently has a placeholder for the two sets of words and the notes. Change this layout to show the information in way that you think is helpful. In your write-up, discussed later, you can explain what you have done and why.


### FR3: Add word link detail screen

When the user selects a word on the Main screen, a new view should be displayed. This view will show the detailed information for the selected word. For example, if the word selected was Ysgol, then the detail screen should show all possible translations of the word, together with information added in FR1. Choosea suitable way to show that information on the screen.


### FR4: Create word games

On the Revision tab you should create two simple word games based on the words in the database. These games will help users to learn the words.

Example games are: 

* Get a list of 10 words from the database. Show each word and allow the user to type in the translation. Keep track of how many words the user guesses correctly and present a score to the user at the end of the game. 

  A basic version would allow the user to enter characters with the keyboard. A more advanced version could show some buttons on the screen. Each button represents one character from the word and possibly some extra characters not in the word. These are presented in a random order. The user has to select the buttons to spell out the translation. 
* Get a list of 10 words from the database. For each word, select another 4 or 6 words fromthe database. Show the word and a list of possible translations taken from the other words and the actual translation. Ask the user to select the correct translation.

When you present the words, think about what other information would be useful to show, e.g. Context and Area.

Each game should show a mixture of English and Welsh words. If the user enters an incorrect answer, they should be shown the correct answer at some point in the game.

You could choose to design and implement games that are different to the ones outlined above.

The Revision tab currently contains a `UITableViewController`. You could use this as the way to show links to the games and to show the user’s recent scores. You can change this screen to use a different view controller if you prefer.


### Existing Code

You should start with the existing code that is provided with this assignment. In addition to changes to meet the requirements in this document, you can change the existing code if you see opportunities to improve it. Highlight any changes in your documentation.


### Documentation and Submission

Write up to a four-page report that tells the story of how you went about implementing the assignment, problems encountered, what you have learned and a few screen shots showing the solution running either on the iPhone emulator or a real iOS device. Oneto twoof those pages should include a table to record the tests that you performed on the application. Make sure you include an additional cover page with your name etc.

Please reflect in your report on a mark you think you should be awarded and why.

Create a ZIP file containing your Xcode project and a PDF version of your report. Upload to Blackboard by 3pm Monday 2nd December.

If you are late then please complete a Late Assignment Submission form and hand this in to the Department office. All required forms can be found at: http://www.aber.ac.uk/~dcswww/intranet/staff-students-internal/teaching/resources.php

Note: this is an “individual” assignment and must be completed as a one-person effort by the student submitting the work.

This assignment is **not** marked anonymously.

I will attempt to provide provisional marks and feedback by Monday 16th December 2013.


### Learning Outcomes

By undertaking this assignment, and the worksheets it builds on, you will:

1.Learn how to create a native iOS application.
2.Learn about the use of storyboards and `UIKit` controls.
3.Learn to use Objective-C.
4.Design new screens to show data and respond to user input.


### Mark Breakdown

Assessment will be based on the assessment criteria described in Appendix AA of the Student Handbook. However, the following table gives you some indication of the weights associated with individual parts of the assignment. This will help you judge how much time to spend on each part.

#### Documentation

Does the documentation convey a convincing and detailed story of how the code was implemented, problems encountered, what was learned and anindication of the mark that should be awarded and why? *30%*


#### Implementation

Does the documentation convey a convincing and detailed story of how the code was implemented, problems encountered, what was learned and anindication of the mark that should be awarded and why? *50%*


#### Flair

You implemented and documented something in a way that really impresses me. I’ll know it when I see it. *10%*


#### Testing

You provided evidence of testing using browser developer tools. (sic?) *10%*
