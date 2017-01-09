# justTriangles
Vector shape generation with triangles helper library

Example WebGL use please see:
https://github.com/nanjizal/justTrianglesDemo

new PathContext much improved for drawing outlines.
- MoveTo and LineTo supported
- Cubic and Quadratic Curves supported
- Regular Polygons
- Arc supported

https://github.com/nanjizal/justTrianglesDemo/blob/master/justTrianglesDemo/Demo.hx#L33

TODO:
- Rounded Rectangles have issue with joining ( wider issue ), but work.
- fix occasional edge cases for thickness trig related perhaps actually js error in trig.
- improve stability
- add fill to PathContext.
- add isolated lines round edge to general PathContext so that sharp angle can look better.
- Explore further combinations of mixing with fill libraries, beginFill and alpha and endFill.
