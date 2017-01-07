package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
class PathContext {
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
    public function render( thick: Float, ?outline: Bool = true ){
        if( dirty ) reverseEntries();
        for( pp0 in ppp_ ){
            Draw.poly( id, outline, pp0 );
        }
    }
    inline function reverseEntries(){
        var p: Array<Point>;
        if( ppp_ == null ) ppp_ = new Array<Array<Point>>();
        var plen = ppp.length;
        var plen_ = ppp_.length;
        var pp0: Array<Point>;
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
