# Spherical

## Glorious Computational Excess, part 1

This project came to be because I wanted to brush up on CoreData (having a WebObjects background) and learn some SceneKit—with no background in computational geometry. This is one of several apps that talk to the same back end data store, including features such as CoreML predictions about color.

[For a quick view of what this app looks like, here's my Instagram post.](https://www.instagram.com/p/BqS0Sn-gDdF/) Since then, I added automatic rotation rather than the user initiated jerky motion in that post.

The app's data organization is based on makeup colors: makers, palettes, and eyeshadow colors.

The next app will go another step further and create convex hulls for each palette. The goal is to demonstrate overlap as well as show what colors can be created with that palette.

## ToDo

1. Add per-maker animations
2. Fix the cruft marked in the code
3. Pull in the unit and UI tests

## External dependencies

None at this time. Note that I've moved to Ensembles for my main project, so likely this will require Ensembles at some point. However, there are issues I haven't yet debugged on that, so…it'll be a while.
