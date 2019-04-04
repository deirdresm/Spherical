# Spherical

## Glorious Computational Excess, part 1
### Build 0.4

Project I coded from scratch using Swift, CoreData, and SceneKit. This app runs on iOS, but I plan to add a macOS target at some point.

This project came to be because I wanted to brush up on CoreData (having a WebObjects background) and learn some SceneKit—with no background in computational geometry. This is one of several apps that talk to the same back end data store, including features such as CoreML predictions about color.

[For a quick view of what this app looks like, here's my Instagram post.](https://www.instagram.com/p/BqS0Sn-gDdF/) Since then, I added automatic rotation rather than the user initiated jerky motion in that post.

The app's data organization is based on makeup colors: makers, palettes, and eyeshadow colors.

The next app will go another step further and create convex hulls for each palette. The goal is to demonstrate overlap as well as show what colors can be created with that palette.

## ToDo

(Not in any particular order)

1. ~~Add per-maker animations~~ Done as of 0.3.
2. ~~Add the maker title.~~ Done as of 0.4
3. Maker labels should reflect the colors of the maker in question. This is harder to calculate than it might sound, but initially I'm thinking the median of what's in a convex hull containing the smallest volume of 50% of the points. IOW, the least outliers. (Essentially means it'll be some shade of light brown for most companies.) I'm not yet decided on how to approach this, especially since some companies are really known for color and others…aren't. It'd be nice to have the feel work for both.
3. Fix the cruft marked in the code
4. Incorporate Ensembles.
5. Pull in the unit and UI tests, which may involve refactoring to make some things more testable. Slow on this because there are precious few good examples of tests online with projects using similar features, so learning this the hard way.
6. Add a macOS target, and maybe also tvOS (this really requires more than watchOS can give, I believe).

## External dependencies

None at this time. Note that I've moved to Ensembles for my main project, so likely this will require Ensembles at some point. However, there are issues I haven't yet debugged on that, so…it'll be a while.

## Changelog

**0.2 -> 0.3**

Added per-maker animations.

**0.3 -> 0.4**

Maker labels.
