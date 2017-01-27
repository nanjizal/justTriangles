# justTriangles
Vector shape generation with triangles helper library - mostly just lines rather than fills all generated with lots of little triangles!

Now supports SVG path data parsing, such as thes DroidSans font path data and the bird.

![](https://cloud.githubusercontent.com/assets/20134338/22331662/91c39c82-e3c4-11e6-8bc6-ee5ad0197ad4.png)



## Fills
For simple fills I have included **PolyK** library, just set fill to true on PathContext, but beware default curve settings are very high so this is very slow, so turned off for drawing the font.

![]( https://cloud.githubusercontent.com/assets/20134338/22377303/42bd7e92-e4a9-11e6-8e96-2803da056b56.png )


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
- Finish refactor to remove all Point reference ( 80% done see 'No Point' branch ) from classes and check if it's faster to just use x,y.
- Explore further combinations of mixing with fill libraries, beginFill and alpha and endFill.
