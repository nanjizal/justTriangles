# justTriangles

## NO POINT - Branch removes Point class in the hope that no Point structure will reduce calculations.
### Still requires some work with setting up some of the loops like the fill, and testing.

Vector shape generation with triangles helper library

Example WebGL use please see:
https://github.com/nanjizal/justTrianglesDemo

new PathContext much improved for drawing outlines.
- MoveTo and LineTo supported
- Cubic and Quadratic Curves supported
- Regular Polygons
- Simple Arc supported
- Svg path data paths partially supported.

https://github.com/nanjizal/justTrianglesDemo/blob/master/justTrianglesDemo/Demo.hx#L33

MAIN TODO:
- Debug lines against SVG path data
- Finish refactor to remove all Point reference ( 80% done not commited ) from classes and check if it's faster to just use x,y.
- Explore further combinations of mixing with fill libraries, beginFill and alpha and endFill.
