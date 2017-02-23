# justTriangles
Vector shape generation with triangles helper library - mostly just lines rather than fills all generated with lots of little triangles!

Now supports SVG path data parsing, such as thes DroidSans font path data and the bird.

![](https://cloud.githubusercontent.com/assets/20134338/22331662/91c39c82-e3c4-11e6-8bc6-ee5ad0197ad4.png)

## Live demo via codepen:

- [justTriangles](http://codepen.io/Nanjizal/pen/JWjGOj)

- [justTriangles mixed with hxSpiro](http://codepen.io/Nanjizal/pen/qReLLR)

## Example Use Repositories:
- ### WebGL example
https://github.com/nanjizal/justTrianglesDemo

- ###Kha ( g2 ) example see:
https://github.com/nanjizal/justTrianglesKhaG2

## Fills
For simple fills I have included **PolyK** library, set fill to true on PathContext, and reduce Curve settings from 0.03 

```ShapePoints.quadStep = 0.2;```

```ShapePoints.cubicStep = 0.2;```

![]( https://cloud.githubusercontent.com/assets/20134338/22377303/42bd7e92-e4a9-11e6-8e96-2803da056b56.png )

Perhaps I need to create two arrays one of paths and one for fills?

## Details

new PathContext much improved for drawing outlines.
- MoveTo and LineTo supported
- Cubic and Quadratic Curves supported
- Regular Polygons
- Simple Arc supported
- Svg path data paths partially supported.

MAIN TODO:
- Debug lines against SVG path data
- Finish refactor to remove all Point reference ( 80% done see 'No Point' branch ) from classes and check if it's faster to just use x,y.
- Explore further combinations of mixing with fill libraries, beginFill and alpha and endFill.
