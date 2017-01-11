package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
enum LineType {
    Poly;
    Round;
    Isolated;
    Quad;
}
@:enum
abstract DrawDirection( Bool ){
    var clockwise = true;
    var counterClockwise = false;
}
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
    public var lineType: LineType = Round;
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
    // working.
    public function arc_move( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1: Point = pt( x, y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        var pMore = ShapePoints.arcPoints( p1, radius*s, start, dA, cast sides );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // working.
    public function arc( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1: Point = pt( x, y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        var pMore = ShapePoints.arcPoints( p1, radius*s, start, dA, cast sides );
        for( p in pMore  ) pp.push( p );
    }
    // TODO: issue with closing rounded rectangle and some polys with the last line - webgl specific?
    public function roundedRectangle( dx: Float, dy: Float, width: Float, height: Float, radius: Float ): Void {
        var pi = Math.PI;
        var pi_2 = Math.PI/2;
        var p_arc1x = dx + radius;  // TODO: excessive reduce temp var
        var p_arc1y = dy + radius;
        var p_arc2x = dx + width - radius;
        var p_arc2y = dy + radius;
        var p_arc3x = dx + width - radius;
        var p_arc3y = dy + height - radius;
        var p_arc4x = dx + radius;
        var p_arc4y = dy + height - radius;
        var p1x = dx + radius;
        var p1y = dy;
        var p2x = dx + width - radius;
        var p2y = dy;
        var p3x = dx + width;
        var p3y = dy + radius;
        var p4x = dx + width;
        var p4y = dy + height - radius;
        var p5x = dx + width - radius;
        var p5y = dy + height;
        var p6x = dx + radius;
        var p6y = dy + height;
        var p7x = dx;
        var p7y = dy + height - radius;
        var p8x = dx;
        var p8y = dy + radius;
        moveTo( p8x, p8y );
        arc_move( p_arc1x, p_arc1y, radius,    pi, pi_2, clockwise, hexacontagon );
        lineTo( p2x, p2y );
        arc( p_arc2x, p_arc2y, radius, -pi_2, pi_2, clockwise, hexacontagon );
        lineTo( p4x, p4y );
        arc( p_arc3x, p_arc3y, radius,     0, pi_2, clockwise, hexacontagon );
        lineTo( p6x, p6y );
        arc( p_arc4x, p_arc4y, radius,  pi_2, pi_2,   clockwise, hexacontagon );
        //lineTo( p8x + 0.0001, p8y + 0.0001 );// TODO: this needs fixing?
        lineTo( p8x, p8y );
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
            switch( lineType ){
                case Poly:
                    // fairly optimal but broken
                    Draw.poly( id, outline, pp0 );
                case Round:
                    // Pretty perfect but over drawing
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 2) Draw.isolatedLine( id, pp0[ i ], pp0[ i + 1 ], thick/800, true );
                    }
                case Isolated:
                    // similar to poly but more broken
                    for( i in 0...pp0.length ){
                       if( i%1 == 0 && i< pp0.length - 2) Draw.isolatedLine( id, pp0[ i ], pp0[ i + 1 ], thick/800, false );
                    }
                case Quad:
                    // very broken
                    for( i in 0...pp0.length ) {
                        if( i%1 == 0 && i< pp0.length - 2) Draw.quad( id, outline, pp0, i );
                    }
            }
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
