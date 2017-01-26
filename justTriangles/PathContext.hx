package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
enum LineType {
    TriangleJoinCurve; // arc- Default seems to work quite well, but WIP.
    TriangleJoinStraight; // straight   
    Poly;         // polygons
    Curves;       // curves
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
    var p0x: Float;
    var p0y: Float;
    var pp: Array<Float>;
    var ppp: Array<Array<Float>>;
    var ppp_: Array<Array<Float>>;
    var s: Float;
    var dw: Float;
    var tx: Float;
    var ty: Float;
    public var id: Int;
    public var lineType: LineType = TriangleJoinCurve;
    public function new( id_: Int, width_: Float, ?tx_: Float = 0, ?ty_: Float = 0){
        id = id_;
        dw = width_/2;
        s = 1/width_;
        tx = tx_;
        ty = ty_;
        ppp = new Array<Array<Float>>();
        moveTo( dw, dw );
    }
    inline function ptx( x: Float, y: Float ): Point {
        // default is between ±1
        return s*( x + tx ) - 0.5;
    }
    inline function pty( x: Float, y: Float ): Point {
        // default is between ±1
        return s*( y + ty ) - 0.5; //
    }
    public function moveTo( x: Float, y: Float ): Void {
        dirty = true;
        p0x = ptx( x );
        p0y = pty( y );
        if( pp != null ) if( pp.length < 3 ) ppp.pop(); // remove moveTo that don't have another drawing command after.
        pp = new Array();
        pp.push( p0x );
        pp.push( p0y );
        ppp.push( pp );
    }
    function moveToPoint( p0x: Float, p0y: Float ): Void {
        dirty = true;
        if( pp != null ) if( pp.length < 3 ) ppp.pop(); // remove moveTo that don't have another drawing command after.
        pp = new Array();
        pp.push( p0x );
        pp.push( p0y );
        ppp.push( pp );
    }
    public function lineTo( x: Float, y: Float ): Void {
        var p1x = ptx( x );
        var p1y = pty( y );
        pp.push( p1x );
        pp.push( p1y );
        p0x = p1x;
        p0y = p1y;
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        var p1x = ptx( x1 );
        var p1y = pty( y1 );
        var p2x = ptx( x2 );
        var p2y = pty( y2 );
        ShapePoints.quadCurve( pp, p0x, p0y, p1x, p1y, p2x, p2y );
        p0x = p2x;
        p0y = p2y;
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        var p1x = ptx( x1 );
        var p1y = pty( y1 );
        var p2x = ptx( x2 );
        var p2y = pty( y2 );
        var p3x = ptx( x3 );
        var p3y = pty( y3 );
        ShapePoints.cubicCurve( pp, p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y );
        p0x = p3x;
        p0y = p3y;
    }
    public function rectangle( x: Float, y: Float, width: Float, height: Float ): Void {
        var p1x = ptx( x );
        var p1y = pty( y );
        var pMore = ShapePoints.box( new Array<Float>(), p1x, p1y, width*s, height*s ); // TODO: not ideal rethink?
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // working.
    public function arc_move( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1x = ptx( x );
        var p1y = pty( y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        var pMore = ShapePoints.arcPoints( new Array<Float>(), p1x, p1y, radius*s, start, dA, cast sides );
        moveToPoint( pMore[0] );
        for( p in pMore  ) pp.push( p );
    }
    // working.
    public function arc( x: Float, y: Float, radius: Float, start: Float, dA: Float, ?direction: DrawDirection, ?sides: PolySides ):Void{
        if( direction == null ) direction = clockwise;
        if( sides == null ) sides = circleSides;
        var p1x = ptx( x );
        var p1y = pty( y );
        if( direction == counterClockwise ) dA = -dA; //TODO: Check
        ShapePoints.arcPoints( pp, p1x, p1y, radius*s, start, dA, cast sides );
    }
    // working
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
        arc( p_arc2x, p_arc2y, radius, -pi_2, pi_2, clockwise, hexacontagon );
        arc( p_arc3x, p_arc3y, radius,     0, pi_2, clockwise, hexacontagon );
        arc( p_arc4x, p_arc4y, radius,  pi_2, pi_2,   clockwise, hexacontagon );
        lineTo( p8x, p8y );
    }
    // currently only use predefined sides to encourage use of PolySides names.
    public function regularPoly( sides: PolySides, x: Float, y: Float, radius: Float, ?rotation: Float = 0 ): Void {
        var p1x = ptx( x );
        var p1y = pty( y );
        var pMore = ShapePoints.polyPoints( new Array<Float>(), p1x, p1y, radius*s, cast sides, rotation );
        moveToPoint( pMore[0], pMore[1] );
        for( p in pMore  ) pp.push( p );
    }
    public function render( thick: Float, ?outline: Bool = true ){
        Draw.thick = thick;
          //if( dirty ) reverseEntries(); Not sure about this needs some thought.
        for( pp0 in ppp_ ){
            switch( lineType ){
                // Currently best line drawing enum still under active development.
                case TriangleJoinCurve:
                    var draw = new Draw();
                    var l = pp0.length;
                    var tot = l - 4;
                    var j: Int = 0;
                    for( i in 0...tot ){
                        if( (i & 1) == 0 ){
                            if( (j & 1) == 0 ){
                                Draw.triangleJoin( id, draw, pp0[ i ], pp0[ i + 1 ], pp0[ i + 2 ], pp0[ i + 3 ], thick/800, true );
                            }
                            j++;
                        }
                    }
                case _:
                    //throw( 'currently not implemented' ); 
            }
        }
    }
    
    
    /*
case TriangleJoinStraight:
    var draw = new Draw();
    var l = p.length;
    for( i in 0...pp0.length ){
       if( i%1 == 0 && i< pp0.length - 2) Draw.triangleJoin( id, draw, pp0[ i ], pp0[ i + 1 ], thick/800, false );
    }
    
// Other alternates still keeping till have developed ideal solution.
case Poly:
    // fairly optimal but broken
    Draw.poly( id, outline, pp0 );
case Curves:
    // Not quite working on round rectangle but working well otherwise
    //Draw.isolatedSpecial( id, pp0[ 0 ], pp0[ 1 ], thick/800 );
    for( i in 0...pp0.length ) {
        if( i%1 == 0 && i< pp0.length - 2) Draw.quad( id, outline, pp0, i );
    }
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
    */
    
    
    
    
    inline function reverseEntries(){  // problematic with new Array<Array<Float>>
        var p: Array<Float>;
        if( ppp_ == null ) ppp_ = new Array<Array<Float>>();
        var plen = ppp.length;
        var plen_ = ppp_.length;
        var pp0: Array<Float> = ppp[0];
        for( i in plen_...plen ){
            // only add ones new ones
            pp0 = ppp[ i ];
            p = pp0.copy(); // not sure why not allowed to do all this in one line?
            reversePoints( p );
            ppp_[ i ] = p;
        }
        dirty = false;
    }
    
    public static inline function reversePoints( p: Array<Float> ): Array<Float> {
        var xl: Float;
        var yl: Float;
        var xr: Float;
        var yr: Float;
        var l = p.length;
        var lm = p.length - 1;
        var half = Std.int( p.length/2 );
        for( i in 0...half ){
            if( (i & 1) == 0 ){
                xl = p[ i ];
                yl = p[ i+1 ];
                r = lm - i;
                xr = p[ r - 1 ];
                yr = p[ r ];
                p[i] = y;
                p[i+1] = x;
                p[r-1] = y;
                p[r] = x;
            }
        }
    }
    
    public function clear(){
        dirty = true;
        ppp_ = null;
        ppp = null;
        pp = null;
        p0 = null;
    }
}
