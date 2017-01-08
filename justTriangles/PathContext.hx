package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
@:enum
abstract PolySides( Int ) {
    var triangle        = 3;
    var quadrilateral   = 4;
    var square          = 4;
    var tetragon        = 4;
    var pentagon        = 5;
    var hexagon         = 6;
    var heptagon        = 7;
    var septagon        = 7;
    var octagon         = 8;
    var nonagon         = 9;
    var enneagon        = 9;
    var decagon         = 10;
    var hendecagon      = 11;
    var undecagon       = 11;
    var dodecagon       = 12;
    var triskaidecagon  = 13;
    var tetrakaidecagon = 14;
    var pentadecagon    = 15;
    var hexakaidecagon  = 16;
    var heptadecagon    = 17;
    var octakaidecagon  = 18;
    var enneadecagon    = 19;
    var icosagon        = 20;
    var triacontagon    = 30;
    var tetracontagon   = 40;
    var pentacontagon   = 50;
    var hexacontagon    = 60;
    var heptacontagon   = 70;
    var octacontagon    = 80;
    var enneacontagon   = 90;
    var hectagon        = 100;
    var chiliagon       = 1000;
    var myriagon        = 10000;
}
class PathContext {
    public static var circleSides: PolySides = hexacontagon;
    var dirty: Bool = true;
    var p0: Point;
    var pp: Array<Point>;
    var ppp: Array<Array<Point>>;
    var ppp_: Array<Array<Point>>;
    var s: Float;
    var dw: Float;
    var tx: Float;
    var ty: Float;
    public var id: Int;
    public function new( id_: Int, width_: Float, ?tx_: Float = 0, ?ty_: Float = 0){
        id = id_;
        dw = width_/2;
        s = 1/width_;
        tx = tx_;
        ty = ty_;
        ppp = new Array<Array<Point>>();
        moveTo( dw, dw );
    }
    inline function pt( x: Float, y: Float ): Point {
        // default is between ±1
        return { x: s*( x - dw + tx ), y: s*( y - dw + ty ) }
    }
    public function moveTo( x: Float, y: Float ): Void {
        dirty = true;
        p0 = pt( x, y );
        if( pp != null ) if( pp.length == 1 ) ppp.pop(); // remove moveTo that don't have another drawing command after.
        pp = new Array();
        pp.push( p0 );
        ppp.push( pp );
    }
    function moveToPoint( p0: Point ): Void {
        dirty = true;
        if( pp != null ) if( pp.length == 1 ) ppp.pop(); // remove moveTo that don't have another drawing command after.
        pp = new Array();
        pp.push( p0 );
        ppp.push( pp );
    }
    public function lineTo( x: Float, y: Float ): Void {
        var p1: Point = pt( x, y );
        pp.push( p1 );
        p0 = p1;
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        var p1: Point = pt( x1, y1 );
        var p2: Point = pt( x2, y2 );
        var pMore: Array<Point> = ShapePoints.quadCurve( p0, p1, p2 );
        var plen = pp.length;
        for( i in 1...( pMore.length ) ) pp[ plen++ ] = pMore[ i ];
        p0 = p2;
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        var p1: Point = pt( x1, y1 );
        var p2: Point = pt( x2, y2 );
        var p3: Point = pt( x3, y3 );
        var pMore = ShapePoints.cubicCurve( p0, p1, p2, p3 );
        var plen = pp.length;
        for( i in 1...( pMore.length ) ) pp[ plen++ ] = pMore[ i ];
        p0 = p3;
    }
    public function rectangle( x: Float, y: Float, width: Float, height: Float ): Void {
        var p1: Point = pt( x, y );
        var pMore = ShapePoints.box( p1.x, p1.y, width*s, height*s );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // probably not yet working.
    public function arc( x: Float, y: Float, radius: Float, start: Float, dA: Float, sides: Int ):Void{
        var p1: Point = pt( x, y );
        var pMore = ShapePoints.arcPoints( p1, radius*s, start, dA, sides );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // not yet working 
    public function roundedRectangle( dx: Float, dy: Float, width: Float, height: Float, radiusSmall: Float, radius: Float ): Void {
        var dia = radius*2; // radiusSmall = 10 radius = 25
        var circleSides2 = (cast circleSides )*2;
        width = width*s;
        height = height*s;
        radiusSmall = radiusSmall*s;
        radius = radius*s;
        var p1 = pt( dx, dy - radius );
        var p2 = pt( dx + width, dy - radius );
        var p3 = pt( dx + radius + width, dy );
        var p4 = pt( dx + radius + width, dy + height );
        var p5 = pt( dx, dy + radius + height );
        var p6 = pt( dx + width, dy + radius + height );
        var p7 = pt( dx - radius, dy );
        var p8 = pt( dx - radius, dy + height );
        moveToPoint( p1 );
        pp.push( p2 );
        p0 = p2;
        arc( dx + width , dy, radiusSmall, -Math.PI/2, Math.PI/2, circleSides2 ); // right top
        moveToPoint( p3 );
        pp.push( p4 );
        p0 = p4;
        arc( dx + width, dy + height, radiusSmall, 0, Math.PI/2, circleSides2 ); // right bottom
        moveToPoint( p6 );
        pp.push( p5 );
        p0 = p5;
        arc( dx, dy + height, radiusSmall, -Math.PI - Math.PI/2, Math.PI/2, circleSides2 ); // left bottom
        moveToPoint( p8 );
        pp.push( p7 );
        p0 = p7;
        arc( dx, dy, radiusSmall, -Math.PI, Math.PI/2, circleSides2 ); // top left
    }
    // currently only use predefined sides to encourage use of PolySides names.
    public function regularPoly( sides: PolySides, x: Float, y: Float, radius: Float, ?rotation: Float = 0 ): Void {
        var p1: Point = pt( x, y );
        var pMore = ShapePoints.polyPoints( p1, radius*s, cast sides, rotation );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    public function render( thick: Float, ?outline: Bool = true ){
        Draw.thick = thick;
        if( dirty ) reverseEntries();
        for( pp0 in ppp_ ){
            trace( pp0.length );
            trace( pp0 );
            Draw.poly( id, outline, pp0 );
        }
    }
    inline function reverseEntries(){
        var p: Array<Point>;
        if( ppp_ == null ) ppp_ = new Array<Array<Point>>();
        var plen = ppp.length;
        var plen_ = ppp_.length;
        var pp0: Array<Point> = ppp[0];
        for( i in plen_...plen ){
            // only add ones new ones
            pp0 = ppp[ i ];
            p = pp0.copy(); // not sure why not allowed to do all this in one line?
            p.reverse();
            ppp_[ i ] = p;
        }
        dirty = false;
    }
    public function clear(){
        dirty = true;
        ppp_ = null;
        ppp = null;
        pp = null;
        p0 = null;
    }
}
