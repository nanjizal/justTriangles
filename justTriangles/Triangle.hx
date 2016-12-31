package justTriangles;
import justTriangles.Point;
class Triangle {
    public static var triangles = new Array<Triangle>();
    public static inline function drawTri(   id: Int, outline: Bool, p0: Point, p1: Point, p2: Point, colorID: Int ):Void {
        triangles.push( new Triangle( id, outline, p0, p1, p2, 0, colorID ) );
    };
    public var id: Int;
    public var colorID: Int;
    public var outline: Bool;
    public var depth: Float;
    public var ax: Float;
    public var bx: Float;
    public var cx: Float;
    public var ay: Float;
    public var by: Float;
    public var cy: Float;
    public var x( get, set ): Float;
    function get_x() {
        return Math.min( Math.min( ax, bx ), cx );
    }
    function set_x( x: Float ): Float {
        var dx = x - get_x();
        ax = ax + dx;
        bx = bx + dx;
        cx = cx + dx;
        return x;
    }
    public var y( get, set ): Float;    
    function get_y(): Float {
        return Math.min( Math.min( ay, by ), cy );
    }
    function set_y( y: Float ): Float {
        var dy = y - get_y();
        ay = ay + dy;
        by = by + dy;
        cy = cy + dy;
        return y;
    }
    public var right( get, never ): Float;
    public function get_right(): Float {
        return Math.max( Math.max( ax, bx ), cx );
    }
    public var bottom( get, never ): Float;
    public function get_bottom(): Float {
        return Math.max( Math.max( ay, by ), cy );
    }
    function moveDelta( dx: Float, dy: Float ){
        ax += dx;
        ay += dy;
        bx += dx;
        by += dy;
        cx += dx;
        cy += dy;
    }    
    public function new(  id_: Int
                        , outline_: Bool
                        , A_: Point, B_: Point, C_: Point
                        , depth_: Float
                        , colorID_: Int
                        ){
        id = id_;
        outline = outline_;
        ax = A_.x;
        ay = A_.y;
        bx = B_.x;
        by = B_.y;
        cx = C_.x;
        cy = C_.y;
        depth = depth_;
        colorID = colorID_;
    }
    //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public function hitTest( P: Point ): Bool {
        var px: Float = P.x;
        var py: Float = P.y;
        if( px > x && px < right && py > y && py < bottom ) return true;
        var planeAB = ( ax - px )*( by - py ) - ( bx - px )*( ay - py );
        var planeBC = ( bx - px )*( cy - py ) - ( cx - px )*( by - py );
        var planeCA = ( cx - px )*( ay - py ) - ( ax - px )*( cy - py );
        return sign( planeAB ) == sign( planeBC ) && sign( planeBC ) == sign( planeCA );
    }
    function sign( n: Float ): Int {
        return Std.int( Math.abs( n )/n );
    }
}
