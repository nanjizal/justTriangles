package justTriangles;
import justTriangles.Draw;
import justTriangles.Point;
import justTriangles.ShapePoints;
class PathContext {
    var p0: Point;
    var pp: Array;
    var ppp: Array<Array<Point>>;
    public var id: Int;
    public function new( id_: Int ){
        id = id_;
        ppp = new Array<Array<Point>>();
        moveTo( 0, 0 );
    }
    public function moveTo( x: Float, y: Float ): Void {
        p0 = { x: x, y: y };
        pp = new Array();
        pp.push( p0 );
        ppp.push( pp );
    }
    public function lineTo( x: Float, y: Float ): Void {
        var p1: Point = { x: x, y: y };
        pp.push( p1 );
        p0 = p1;
    }
    public function quadTo( x1: Float, y1: Float, x2: Float, y2: Float ): Void {
        var p1: Point = { x: x1, y: y1 };
        var p2: Point = { x: x2, y: y2 };
        var pMore = ShapePoints.quadCurve( p0, p1, p2 );
        for( p in pMore ) pp.push( p );
        p0 = p2;
    }
    public function curveTo( x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float ): Void {
        var p1: Point = { x: x1, y: y1 };
        var p2: Point = { x: x2, y: y2 };
        var p3: Point = { x: x2, y: y3 };
        var pMore = ShapePoints.cubicCurve( p0, p1, p2, p3 );
        for( p in pMore ) pp.push( p );        
        p0 = p3;
    }
    public function render( thick: Float, ?outline: Bool = true ){
        for( pp0 in ppp ){
            Draw.triangles( id, outline, pp0 );
        }
    }
    public function clear(){
        for( pp0 in ppp ){
            pp0.length = 0;
        }
        ppp.length = 0;
        p0 = null;
    }
}
