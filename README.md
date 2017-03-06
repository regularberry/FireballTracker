# FireballTracker

Hey Livefront team!

Here's my code challenge project.

I chose the Jet Propulsion Lab's Fireball Data API: https://ssd-api.jpl.nasa.gov/doc/fireball.html

My app grabs a list of fireball incidents and shows where the atmospheric impact was on a map.

There's also infinite scrolling at the bottom (until the data runs out).

Built for iPhones and iOS 10.2 with Swift 3. No 3rd party libraries.

Looking forward to your feedback!

Cheers,
Sean

Class Tour:
FireballApiClient interfaces with the NASA api, allowing two calls, getting the newest fireballs, and getting them after a certain date. Chunk size (number of fireballs to get per call) is determined on init. Received data is passed to FireballParser, which turns the JSON into a FireballJSON struct.

FireballJSON is passed to a Core Data stack: FireballDataStack, which saves and persists it.

The fanciest class is FireballListDataSource, which is responsible for the data stack and api client, and provides a NSFetchedResultsController/UITableViewDataSource for a table view. 
Added functionality enables infinite scroll to older data. The data source notes what data we have already and creates the correct calls to the api client.

The table view controller (FireballListVC) is straight forward. I wanted to create an ominous look, because we're talking about fireballs in the sky. Style inspired from a google images search.

FireballListVC segues to FireballLocationVC which creates a MKMapView and animates a meteor flying to the correct location on the map. I did this by disabling scrolling while the animation is playing, and directing it to the center.

Criticisms:
With this meteor animation implementation, if a location is near the edge of the map and thus can't be centered, the meteor will still fly to the center. This is an edge case not accounted for.
The unit tests use the live ApiClient, a stub should be created so unit tests that rely on an Api call don't fail if the network isn't working. (ApiClient unit tests could fail then though)
Doesn't inform user about network errors, only prints to console for now.

Credits:
Meteor art by momentbloom on https://www.vecteezy.com/vector-art/96764-meteor-shower-vector-illustration
<a target="_blank" href="https://www.vecteezy.com">Illustrations by Vecteezy.com</a>

JPL SSD/CNEOS Api Service: https://ssd-api.jpl.nasa.gov/doc/fireball.html