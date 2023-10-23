# mast

A library for building fully dynamic sail front-ends

[![N|Solid](https://freepages.rootsweb.com/~pbtyc/genealogy/B_S_M/Images/Sailing_Steam_Ship_With_Sails_Red.jpg)](https://nodesource.com/products/nsolid)

> full-stack urbit!

Using mast, an app is able to store its current display state on an agent, and when the display state changes, updates to the browser containing only the necessary amount of html to achieve this state are sent and swapped in.

A small script that is generic to any application is inserted into your sail and used to establish an Eyre channel, receive display updates from your ship, and sync the browser with them.

Additionally, in your sail components, you may add data tags on elements specifying event listeners with unique routes; the script will add these event listeners with handlers which poke your agent when the event is triggered. Your agent can then have event handlers for these client-side events on the ship identified by and corresponding to the tags specified in the sail. A second set of tags on the element may be used to specify any data from the event object, the target element, or any other element associated by id to return to the ship for the event handler to process.

Display updates do not need to be in response to an event from the client, though. Your ship can stream updates to the browser as an effect of any state change in the agent.

Check out the example app for more details.

***
License: MIT