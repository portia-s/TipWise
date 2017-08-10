# TipWise
A tip calculator for the Wise

# Pre-work - *TipWise*

**TipWise** is a tip calculator application for iOS.

Submitted by: **Portia Sharma**

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is complete:

* [X] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [X] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [X] UI animations
* [X] Remembering the bill amount across app restarts (if <10mins)
* [X] Using locale-specific currency and currency thousands separators.
* [X] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [X] List anything else that you can get done to improve the app functionality!
* [X] Picker control to select number of person in the party to split the bill.
* [X] 3 Preset values of tip along with customizable tip value at settings.
* [X] Decimal enable/disable for tip, total and split amounts availble at settings.
* [X] 4 Preset & formatted currencies in addition to locale-specific "auto" currency.
* [ ] 3 Color themes to choose from.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:


<img src='https://github.com/portia-s/TipWise/blob/master/preWork_TipWise_5.gif'/>

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

As part of your pre-work submission, please reflect on the app and answer the following questions below:

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** [I’m glad that when I pivoted from hardware, iOS app development was basking in the Swift glory. Xcode and Swift have propelled me, a self-taught developer, to enjoy the development process while I challenge myself to learn the skills of this trade. The unique features of the language, like - type safety and ARC, provide nice guard rails to keep focus on the bowling pins aka functionality of the code. The features of Xcode like Interface Builder, templates with boilerplate code, AutoLayout help visualize the flow and provide a robust infrastructural foundation to customize and build upon. I am throughly in awe of this ecosystem and intend to mature along.

IBOutlets and IBActions for the UI elements are analogous to the properties and methods for a class. Both are part of communication design pattern connecting the elements from the View to its View Controller (MVC architecture). While the IBOutlets are property-specific, the IBActions are method-specific(Target-Action pattern). IBOutlets aid customize the available properties either at Inspector@interfaceBuilder or in code. IBActions are targeted callback functions implemented in the View Controller that respond to the specific user activity at the View for that particular element.
The implementation of storyboards (elements, outlets, actions, layout) is taken care by Interface Builder under the hood where all the visualization is translated to an XML format. The XIB file corresponding to the project storyboard has elements that are defined with their id, property attributes, constraints, connections to other elements and actions with their respective details, like property/selector, destination, event type.].

Question 2: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** [Automatic Reference Counting (ARC) is one of the Swift’s strengths. It takes care of object reference counting by evaluating the lifecycle and relationships of objects thereby automatically inserting retain for allocation and release for deallocation of memory under the hood at compile time. This can be done successfully, provided few considerations about the object relationships are taken care of while coding. The intent is to use weak or unowned references so that when these instances are not needed, the ARC can successfully free up the memory associated. However if not monitored closely, closures, as the name suggests, close/capture the values/references creating a strong bi-directional association, called a reference cycle. The object references the closure via property and closure references the object via captured self and both these references are strong references. These objects stay indefinitely as this strong reference cycle prevents ARC from the freeing up of the associated memory and causes the memory leaks. Using capture lists in closures where these self associations are specifically defined weak or unowned helps break the reference cycles thus preventing memory leaks.].


## License

    Copyright [2017] [Portia Sharma]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
