# justTriangles
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
- Finish refactor of 2D Vector ( 80% done not commited ) from classes and check if it's faster.
- Explore further combinations of mixing with fill libraries, beginFill and alpha and endFill.
