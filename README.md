## Flights to Mars

Showcase and notify the next rocket launch. Show details about upcoming rocket launches.

<img src="https://github.com/paulsump/mars_flights/blob/813c01c1b2326f937fc1e4d08a8c52add9d284f9/images/background.jpg" width="1248">

### To Do

#### Fix

- Navigation (e.g. buttons redraw)
- Position table better on [FavoritesPage]. Looks silly in the middle especially when empty.

#### UI

- Test mirror twice on my git.
- Add WhatsApp share button. But is this really social media? No, but more likely to be used.

- Check flightErrorMessage when bad internet.
- Store favorites.
- Shorter date format on [FlightsPage].

#### UI Later

- Add a share button for social media platforms to share the next launch with friends
- [FavoritesNotifier]. Use the localStorage API here (save the launches id)
- Animate Transform background image position.
- Image.network
- Video
- Remove hexagon buttons. They detract from it.

#### Tests

- DateTime tests - check count down maths. DataTable Column titles scroll off when scroll.
  widget_test
- flightErrorMessage

## Original Specification...

### Objective

Your assignment is to implement a website showcasing and notifying visitors about the next SpaceX
rocket launch and displaying details about upcoming rocket launches. Use Dart and Flutter.

### Brief

You are the last frontend developer on earth. Everyone wants to leave for Mars to live a safer,
cooler life there. The one problem is, people need to know when the next launch is happening, and
that's where you come into the picture. You decide to build a website that informs the public about
the next launch and information about future launches.

Everyone is counting on you!

### Tasks

- Implement assignment using:
  - Language: **Dart**
  - Framework: **Flutter**
- Build out the project to the designs inside the `/Designs` folder
- Connect your application to the **SpaceX-API** (
  Docs: `https://github.com/r-spacex/SpaceX-API/#readme`)
- Use the API to build two screens/sections like in the design
- The countdown should be live and specify days, hours, minutes, and seconds
- The 'Upcoming Launches' screen/section should display the mission name, date, and launchpad like
  in the design
- The countdown and upcoming launches table can be implemented either in separate screens (implement
  navigation)
  or simply with different sections in the page, try to make them intuitive and fluid
- Add a share button for social media platforms to share the next launch with friends
- Fetching should be done safely, with a fallback when an error occurs
- Each launch should have a 'Bookmark' or 'Favorite' button that adds it to a separate 'Favorites'
  section. We would like to see the use of the localStorage API here (either save the launches data
  or its id)

### API Endpoints

- Next Launch Counter: 'https://github.com/r-spacex/SpaceX-API/blob/master/docs/launches/v4/next.md'
- Upcoming Launches: 'https://github.com/r-spacex/SpaceX-API/blob/master/docs/launches/v4/upcoming.md'

A simple GET request will provide you all the data needed for the tasks without requiring any
authentication.

### Deliverables

Make sure to include all source code in the repository.

### Evaluation Criteria

- **Dart** best practices
- Show us your work through your commit history
- Completeness: did you complete the features?
- Correctness: does the functionality act in sensible, thought-out ways?
- Maintainability: is it written in a clean, maintainable way?
- Testing: is the system adequately tested? do your components have unit tests?
- Responsiveness and full mobile compatibility
- Elegantly use placeholders/skeletons when fetching data
- Effective use of the localStorage API

### CodeSubmit

Please organize, design, test, and document your code as if it were going into production - then
push your changes to the master branch. After you have pushed your code, you may submit the
assignment on the assignment page.

