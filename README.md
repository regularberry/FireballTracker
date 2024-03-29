# Fireball Tracker

Hey Livefront team!

Here's my code challenge project.

I chose the [Jet Propulsion Lab's Fireball Data API](https://ssd-api.jpl.nasa.gov/doc/fireball.html)

My app grabs a list of fireball incidents and shows where the atmospheric impact was on a map.

There's also infinite scrolling at the bottom (until the data runs out).

Built for iPhones and iOS 10.2 with Swift 3, no 3rd party libraries, and plenty of unit tests.

Looking forward to your feedback!

Cheers,
Sean

![App Preview](http://i.imgur.com/E0rWz1n.gif)

# Class/Struct Tour:
**FireballApiClient** interfaces with the NASA api allowing two calls: getting the newest fireballs, and getting them after a certain date. Received data is passed to **FireballParser** which turns the JSON into a **FireballJSON** struct.

**FireballJSON** is passed to a Core Data stack: **FireballDataStack** which persists it between sessions.

The fanciest class is **FireballListDataSource**, which is responsible for the data stack and api client and provides a table view source.

The table view controller: **FireballListVC** is straight forward. I wanted to create an ominous look because we're talking about fireballs in the sky. Style inspired from a google images search.

**FireballListVC** segues to **FireballLocationVC** which creates a MKMapView and animates a meteor flying to the location specified by the fireball.

# Credits:
* Meteor art by [momentbloom](https://www.vecteezy.com/vector-art/96764-meteor-shower-vector-illustration) [Illustrations by Vecteezy.com](https://www.vecteezy.com)
* JPL SSD/CNEOS Api Service: [https://ssd-api.jpl.nasa.gov/doc/fireball.html](https://ssd-api.jpl.nasa.gov/doc/fireball.html)