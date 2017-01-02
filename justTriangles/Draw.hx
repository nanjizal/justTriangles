package justTriangles;
import justTriangles.ShapePoints;
import justTriangles.Point;
import justTriangles.DrawTri;
class Draw { 
    var p0: Point;
    var p1: Point;
    var p2: Point;
    public var p3: Point;
    public var p4: Point;
    var angleA: Float; // smallest angle between lines
    var cosA: Float;
    var b2: Float;
    var c2: Float;
    var a2: Float;
    var b: Float; // first line length
    var c: Float; // second line length
    var a: Float;
    var angleD: Float;
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var _theta: Float;
    public var angle1: Float;
    var angle2: Float;
    var _thick: Float;
    public static var colorFill_id: Int;
    public static var colorLine_id: Int;
    public static var extraFill_id: Int;
    public static var drawTri: DrawTri;//Int -> Bool -> Point -> Point -> Point -> Int -> Void;
    public function new(){}
    public static inline var circleSides: Int = 60;
    public static function packManFill( id: Int, dx: Float, dy: Float, radius: Float, start: Float, dA: Float ){
        Draw.outerPoly( id, false, { x: dx, y: dy }, ShapePoints.arc( dx, dy, radius, start, dA, circleSides ) );
    }
    public static function roundedRectangleOutline( id: Int, dx: Float, dy: Float, hi: Float, wid: Float, radiusSmall: Float, radius: Float ): Void {
        var dia = radius*2; // radiusSmall = 10 radius = 25
        var circleSides2 = circleSides*2;
        var lb = ShapePoints.arc( dx, dy + hi, radiusSmall, -Math.PI - Math.PI/2, Math.PI/2, circleSides2 );
        var rb = ShapePoints.arc( dx + wid, dy + hi, radiusSmall, 0, Math.PI/2, circleSides2 );
        var rt = ShapePoints.arc( dx + wid , dy, radiusSmall, -Math.PI/2, Math.PI/2, circleSides2 );
        var lt = ShapePoints.arc( dx, dy, radiusSmall, -Math.PI, Math.PI/2, circleSides2 );
        
        Draw.isolatedLine( id, { x: dx, y: dy - radius }, { x: dx + wid, y: dy - radius }, dia, false );
        Draw.isolatedLine( id, { x: dx + radius + wid, y: dy }, { x: dx + radius + wid, y: dy + hi }, dia, false );
        Draw.isolatedLine( id, { x: dx, y: dy + radius + hi }, { x: dx + wid, y: dy + radius + hi }, dia, false );
        Draw.isolatedLine( id, { x: dx - radius, y: dy }, { x: dx - radius, y: dy + hi }, dia, false );
        Draw.outerPoly( id, true, { x: dx, y: dy + hi }, lb );// left bottom
        Draw.outerPoly( id, true, { x: dx + wid, y: dy + hi }, rb );// right bottom
        Draw.outerPoly( id, true, { x: dx + wid, y: dy }, rt );// right top
        Draw.outerPoly( id, true, { x: dx, y: dy }, lt );// left top
    }
    public static function equilateralTriangleOutline( id: Int, dx: Float, dy: Float, radius: Float, ?rotation: Float = 0 ):Void {
        Draw.poly( id, true, ShapePoints.equalTri( dx, dy, radius, rotation ) );
    }
    public static function rectangleOutline( id: Int, dx: Float, dy: Float, dw: Float, dh: Float): Void {
        Draw.poly( id, true, ShapePoints.box( dx, dy, dw, dh ) );
    }
    public static function pentagonOutline( id: Int, dx: Float, dy: Float, radius: Float ):Void {
        Draw.poly( id, true, ShapePoints.poly( dx, dy, radius, 5 ) );
    }
    public static function hexagonOutline( id: Int, dx: Float, dy: Float, radius: Float ):Void {
        Draw.poly( id, true, ShapePoints.poly( dx, dy, radius, 6 ) );
    }
    public static inline function heptagonOutline( id: Int, dx: Float, dy: Float, radius: Float ):Void {
        Draw.poly( id, true, ShapePoints.poly( dx, dy, radius, 7 ) );
    }
    public static function octagonOutline( id: Int, dx: Float, dy: Float, radius: Float ):Void {
        Draw.poly( id, true, ShapePoints.poly( dx, dy, radius, 8 ) );
    }    
    public static function circleOutline( id: Int, dx: Float, dy: Float, radius: Float ):Void {
        Draw.poly( id, true, ShapePoints.poly( dx, dy, radius, circleSides ) );
    }
    public static inline function beginLine( id: Int, p0_: Point, p1_: Point, thick: Float ){
        var draw = new Draw();
        draw.p0 = p1_;
        draw.p1 = p0_;
        draw.halfA = Math.PI/2;
        draw.setThickness( thick );
        draw.calculateP3p4();
        var q0 = { x: draw.p3.x, y: draw.p3.y };
        var q1 = { x: draw.p4.x, y: draw.p4.y };
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        draw.p0 = p0_;
        draw.p1 = p1_;
        draw.calculateP3p4();
        var oldThickness = thickness;
        thickness = thick/2;
        var temp = draw.angle1;
        Draw.outerPoly( id, true, p0_, ShapePoints.arc( p0_.x, p0_.y, thick/4, temp, Math.PI, 24 ) );
        thickness = oldThickness;
        var q3 = { x: draw.p3.x, y: draw.p3.y };
        var q4 = { x: draw.p4.x, y: draw.p4.y };
        drawTri( id, true, q0, q3, q1, colorLine_id );
        drawTri( id, true, q0, q3, q4, colorLine_id );
        return draw;
    }
    public static inline function endLine( id: Int, p0_: Point, p1_: Point, thick: Float ){
        var draw = new Draw();
        draw.p0 = p1_;
        draw.p1 = p0_;
        draw.halfA = Math.PI/2;
        draw.setThickness( thick );
        draw.calculateP3p4();
        var q0 = { x: draw.p3.x, y: draw.p3.y };
        var q1 = { x: draw.p4.x, y: draw.p4.y };
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        draw.p0 = p0_;
        draw.p1 = p1_;
        draw.calculateP3p4();
        var oldThickness = thickness;
        thickness = thick/2;
        var temp = draw.angle1 + Math.PI;
        Draw.outerPoly( id, true, p1_, ShapePoints.arc( p1_.x, p1_.y, thick/4, temp, Math.PI, 24 ) );
        thickness = oldThickness;
        var q3 = { x: draw.p3.x, y: draw.p3.y };
        var q4 = { x: draw.p4.x, y: draw.p4.y };
        drawTri( id, true, q0, q3, q1, colorLine_id );
        drawTri( id, true, q0, q3, q4, colorLine_id );
        return draw;
    }
    public static inline function isolatedLine( id: Int, p0_: Point, p1_: Point, thick: Float, curveEnds: Bool = false ){
        var draw = new Draw();
        draw.p0 = p1_;
        draw.p1 = p0_;
        draw.halfA = Math.PI/2;
        draw.setThickness( thick );
        draw.calculateP3p4();
        var q0 = { x: draw.p3.x, y: draw.p3.y };
        var q1 = { x: draw.p4.x, y: draw.p4.y };
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        draw.p0 = p0_;
        draw.p1 = p1_;
        draw.calculateP3p4();
        if( curveEnds ){
            var oldThickness = thickness;
            thickness = thick/2;
            var temp = draw.angle1;
            Draw.outerPoly( id, true, p0_, ShapePoints.arc( p0_.x, p0_.y, thick/4, temp, Math.PI, 24 ) );
            temp = temp + Math.PI;
            Draw.outerPoly( id, true, p1_, ShapePoints.arc( p1_.x, p1_.y, thick/4, temp, Math.PI, 24 ) );
            thickness = oldThickness;
        }
        var q3 = { x: draw.p3.x, y: draw.p3.y };
        var q4 = { x: draw.p4.x, y: draw.p4.y };
        drawTri( id, true, q0, q3, q1, colorLine_id );
        drawTri( id, true, q0, q3, q4, colorLine_id );
        return draw;
    }
    public static inline function quadCurves( id: Int, p: Array<Point>, thick: Float ){
        var curvePoints:Array<Point>;
        var curveLen: Int;
        var len = p.length - 1;
        for( i in 0...len ){
            if( ( i - 1 ) % 2 == 0 ){
                curvePoints = ShapePoints.quadCurve( p[ i], p[ i + 1 ], p[ i + 2 ] );
                curveLen = curvePoints.length;
                Draw.beginLine( id, curvePoints[ 0 ], curvePoints[ 1 ], thick );
                Draw.endLine( id, curvePoints[ curveLen - 2 ], curvePoints[ curveLen - 1 ], thick );
                Draw.triangles( id, true, curvePoints );
            }
        }
    }
    public static inline function cubicCurves( id: Int, p: Array<Point>, thick: Float ){
        var curvePoints:Array<Point>;
        var curveLen: Int;
        var len = p.length - 1;
        for( i in 0...len ){
            if( ( i - 2 ) % 3 == 0 ){
                curvePoints = ShapePoints.cubicCurve( p[ i], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ] );
                curveLen = curvePoints.length;
                Draw.beginLine( id, curvePoints[ 0 ], curvePoints[ 1 ], thick );
                Draw.endLine( id, curvePoints[ curveLen - 3 ], curvePoints[ curveLen - 2 ], thick );
                Draw.triangles( id, true, curvePoints );
            }
        }
    }    
    public function create2Lines( p0_: Point, p1_: Point, p2_: Point, thick: Float ){
        p0 = p0_;
        p1 = p1_;
        p2 = p2_;
        b2 = dist( p0, p1 ); 
        c2 = dist( p1, p2 );
        a2 = dist( p0, p2 );
        b = Math.sqrt( b2 );
        c = Math.sqrt( c2 );
        a = Math.sqrt( a2 );
        cosA = ( b2 + c2 - a2 )/ ( 2*b*c );
        // clamp cosA between ±1
        if( cosA > 1 ) {
            cosA = 1;
        } else if( cosA < -1 ){
            cosA = -1;
        }
        angleA = Math.acos( cosA );
        // angleD = Math.PI - angleA;
        halfA = angleA/2;
        setThickness( thick );
        calculateP3p4();
    }
    public inline function setThickness( val: Float ){
        _thick = val;
        beta = Math.PI/2 - halfA;
        //if( cosA == -1  ) 
        r = ( _thick/2 );///Math.cos( beta );
        //trace( ' r ' + r );
    }
    public inline function calculateP3p4(){
        _theta = theta( p0, p1 );
        if( _theta > 0 ){
            if( halfA < 0 ){
                angle2 = _theta + halfA + Math.PI/2;
                angle1 =  _theta - halfA; 
            } else {
                angle1 =  _theta + halfA - Math.PI;
                angle2 =  _theta + halfA; 
            }
        } else {
            if( halfA > 0 ){
                angle1 =  _theta + halfA - Math.PI;
                angle2 =  _theta + halfA; 
            } else {
                angle2 = _theta + halfA + Math.PI/2;
                angle1 =  _theta - halfA; 
            }
        }
        p3 = { x: p1.x + r * Math.cos( angle1 ), y: p1.y + r * Math.sin( angle1 ) };
        p4 = { x: p1.x + r * Math.cos( angle2 ), y: p1.y + r * Math.sin( angle2 ) };
    }
    public function rebuildAsPoly( p2_: Point ){
        p0 = p1;
        p1 = p2;
        p2 = p2_;
        calculateP3p4();
    }    
    private function theta( p0: Point, p1: Point ): Float {
        var dx: Float = p0.x - p1.x;
        var dy: Float = p0.y - p1.y;
        return Math.atan2( dy, dx );
    }
    private function dist( p0: Point, p1: Point  ): Float {
        var dx: Float = p0.x - p1.x;
        var dy: Float = p0.y - p1.y;
        return dx*dx + dy*dy; 
    }
    public static var thickness: Float;
    private static var q0: Point;
    private static var q1: Point;
    public static var colors: Array<UInt>;
    public static var lineCol: Array<UInt>;
    public static inline function poly( id, outline: Bool, p: Array<Point> ){
         q0 = p[0]; 
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) otherQuad( id, outline, p, draw, i );
    }
    public static inline function outerPoly( id: Int, outline: Bool, centre: Point, p: Array<Point> ){
         q0 = p[0]; 
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) outerFilledTriangles( id, outline, centre, p, draw, i );
    }
    public static inline function innerPoly( id: Int, outline: Bool, centre: Point, p: Array<Point> ){
         q0 = p[0]; 
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) innerFilledTriangles( id, outline, centre, p, draw, i );
    }
    public static inline function triangles( id: Int, outline: Bool, p: Array<Point> ){
         q0 = p[0]; 
         q1 = p[0];
         for( i in 0...( p.length - 2 ) ) quad( id, outline, p, i );
    }
    private static inline function firstQuad( id, p: Array<Point>, i: Int ): Draw {
        var draw = new Draw();
        draw.create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], thickness );
        var q3 = draw.p3;
        var q4 = draw.p4;
        q0 = q3;
        q1 = q4;
        return draw;
    }
    // assumes that firstQuad is drawn.
    private static inline function otherQuad( id: Int, outline: Bool, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q3 = draw.p3;
        var q4 = draw.p4;
        drawTri( id, outline, q0, q3, q1, colorFill_id );
        drawTri( id, outline, q1, q3, q4, extraFill_id );
        q0 = q3;
        q1 = q4;
        return draw;
    }
    private static inline function outerFilledTriangles( id: Int, outline: Bool, centre: Point, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q3 = draw.p3;
        drawTri( id, outline, q0, q3, centre, colorFill_id );
        q0 = q3;
        return draw;
    }
    // suitable for fill.
    private static inline function innerFilledTriangles( id: Int, outline: Bool, centre: Point, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q4 = draw.p4;
        drawTri( id, outline, q1, q4, centre, colorFill_id );
        q1 = q4;
        return draw;
    }
    private static inline function quad( id: Int, outline: Bool, p: Array<Point>, i: Int ){
        var draw = new Draw();
        draw.create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], thickness );
        var q3 = draw.p3;
        var q4 = draw.p4;
        if( i != 0 ){
            drawTri( id, outline, q0, q3, q1, colorFill_id );
            drawTri( id, outline, q1, q3, q4, colorFill_id );
        }
        q0 = q3;
        q1 = q4;
        return draw;
    }
    public static inline function generateMidPoints( arr: Array<{ x: Float, y: Float }>
                                                    ): Array<{ x: Float, y: Float }>{
        var out: Array<{ x: Float, y: Float }> = [];
        var a: { x: Float, y: Float };
        var b: { x: Float, y: Float };
        var len = arr.length - 2;
        for( i in 0...len ){
            a = arr[ i ];
            b = arr[ i + 1 ];
            out.push( { x: ( b.x + a.x )/2, y: ( b.y + a.y )/2 });
            out.push( { x: b.x, y: b.y } );
        }
        a = arr[0];
        out.unshift( { x: a.x, y: a.y } );
        out.unshift( { x: a.x, y: a.y } );
        b = arr[ arr.length - 1 ];
        out.push( { x: b.x, y: b.y } );
        out.push( { x: b.x, y: b.y } );
        out.push( { x: b.x, y: b.y } );
        return out;
    }
}
