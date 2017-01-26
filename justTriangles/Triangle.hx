package justTriangles;
class Triangle {
    public static var triangles = new Array<Triangle>();
    public static inline function drawTri(  id: Int, outline: Bool
                                        ,   p0x: Float, p0y: Float 
                                        ,   p1x: Float, p1y: Float 
                                        ,   p2x: Float, p2y: Float
                                        ,   colorID: Int ):Void {
        triangles.push( new Triangle( id, outline, p0x, p0y, p1x, p1y, p2x, p2y, 0, colorID ) );
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
                        , ax_: Float, ay_: Float
                        , bx_: Float, by_: Float 
                        , cx_: Float, cy_: Float
                        , depth_: Float
                        , colorID_: Int
                        ){
        id = id_;
        outline = outline_;
        if( windingGood( ax_, ay_, bx_, by_, cx_, cy_ ) ){
            ax = ax_;
            ay = ay_;
            bx = bx_;
            by = by_;
            cx = cx_;
            cy = cy_;
        } else {    
            ax = ax_;
            ay = ay_;
            bx = cx_;
            by = cy_;
            cx = bx_;
            cy = by_;
        }
        depth = depth_;
        colorID = colorID_;
    }
    // A B C, you can find the winding by computing the cross product (B - A) x (C - A)
    inline static function windingGood( ax: Float, ay: Float, bx: Float, by: Float, cx: Float, cy: Float ): Bool{
        return ( ((bx - ax)*(cx - ax) - (by - by)*(cx - ax) ) < 0 );
    }
    //http://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
    public function hitTest( px: Float, py: Float ): Bool {
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
