package justTriangles;
import justTriangles.ShapePoints;
import justTriangles.DrawTri;
@:enum
abstract EndLineCurve( Int ){
    var no = 0;
    var begin = 1;
    var end = 2;
    var both = 3;
}
class Draw {
    /*
    var p0: Point;
    var p1: Point;
    var p2: Point;
    public var p3: Point;
    public var p4: Point;
    public var p3old: Point;
    public var p4old: Point;
    public var p3old2: Point;
    public var p4old2: Point;
    */
    var p0x: Float;
    var p0y: Float;
    var p1x: Float;
    var p1y: Float;
    var p2x: Float;
    var p2y: Float;
    var p3x: Float;
    var p3y: Float;
    var p4x: Float;
    var p4y: Float;
    var p3oldx: Float;
    var p3oldy: Float;
    var p4oldx: Float;
    var p4oldy: Float;
    var p3old2x: Float;
    var p3old2y: Float;
    var p4old2x: Float;
    var p4old2y: Float;
    
    
    public var angleA: Float; // smallest angle between lines
    var cosA: Float;
    var b2: Float;
    var c2: Float;
    var a2: Float;
    var b: Float; // first line length
    var c: Float; // second line length
    var a: Float;
    var clockwiseP2: Bool;
    var angleD: Float;
    public var halfA: Float;
    public var beta: Float;
    var r: Float;
    public var _theta: Float;
    public var angle1: Float;
    public var angle2: Float;
    public var thickRatio: Float = 1024;
    var _thick: Float;
    public static var thickness: Float;
    public static var thick( get, set ): Float;
    public static function set_thick( val: Float ):Float{
        if( val < 0 ) val = 0.00001; // TODO: check if this is reasonable lower limit.
        thickness = val/1024;
        return thickness;
    }
    public static function get_thick(): Float {
        return thickness;
    }
    public static function thickSame( val: Float ): Bool {
        return( thickness == val/1024 );
    }
    public static var colorFill_id: Int;
    public static var colorLine_id: Int;
    public static var extraLine_id: Int;
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
    public static inline function line( d: Int
                                    ,   p0x_: Float, p0y_: Float
                                    ,   p1x_: Point, p1y_: Float
                                    ,   ?endLineCurve: EndLineCurve
                                    ,   ?thick: Float ): Draw {
        var draw = new Draw();
        draw.p0x = p1x_;
        draw.p0y = p1y_;
        draw.p1x = p0x_;
        draw.p1y = p0y_;
        draw.halfA = Math.PI/2;
        draw.setThickness( thick );
        draw.calculateP3p4();
        var p3oldx = draw.p3x;
        var p3oldy = draw.p3y;
        var p4oldx = draw.p4x;
        var p4oldy = draw.p4y;
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        draw.p0x = p0x_;
        draw.p0y = p0y_;
        draw.p1x = p1x_;
        draw.p1y = p1y_;
        draw.calculateP3p4();
        switch( endLineCurve ){
            case no: // don't draw ends
            case begin: // draw curve at beginning
                drawCurveEnd( p0x, p0y, draw.angle1, thick );
            case end: // draw curve at end
                drawCurveEnd( p1x, p1y, draw.angle1 + Math.PI, thick );
            case both: // draw curve at beginning and end
                draw2CurveEnd( p0x, p0y, p1x, p1y, draw.angle1, thick );
            case _: //
        }
        drawTri( id, true, p3oldx, p3oldy, draw.p3x, draw.p3y, p4oldx, p4oldy, colorLine_id );
        drawTri( id, true, p3oldx, p3oldy, draw.p3x, draw.p3y, draw.p4x, draw.p4y, colorLine_id );
        return draw;
    }
    
    private inline static function draw2CurveEnd( p0x: Float, p0y: Float, p1x: Float, p1y: Float, angle: Float, thick: Float ){
        var oldThickness = thickness;
        thickness = thick/2;
        Draw.outerPoly( id, true, p0x, p0y, ShapePoints.arc( p0x, p0y, thick/4, angle, Math.PI, 24 ) );
        Draw.outerPoly( id, true, p1x, p1y, ShapePoints.arc( p0x, p0y, thick/4, angle + Math.PI, Math.PI, 24 ) );
        thickness = oldThickness;
    }
    
    private inline static function drawCurveEnd( px: Float, py: Float, angle: Float, thick: Float ){
        var oldThickness = thickness;
        thickness = thick/2;
        Draw.outerPoly( id, true, px, py, ShapePoints.arc( px, py, thick/4, angle, Math.PI, 24 ) );
        thickness = oldThickness;
    }
   
    public static inline function triangleJoin( id: Int, draw: Draw, p0_: Point, p1_: Point, thick: Float, ?curveEnds: Bool = false ){
        var oldAngle = if( draw.p3x != null ) { draw.angle1; } else { null; };
        draw.halfA = Math.PI/2;
        if( draw.p3old2x != null && thickSame( thick ) ){
            
        } else {
            // only calculate p3, p4 if missing - not sure if there are any strange cases this misses, seems to work and reduces calculations
            draw.p0x = p1x_;
            draw.p0y = p1y_;
            draw.p1x = p0x_;
            draw.p1y = p0y_;
            draw.setThickness( thick );
            draw.calculateP3p4();
        }
        //switch lines round to get other side but make sure you finish on p1 so that p3 and p4 are useful
        draw.p0x = p0x_;
        draw.p0y = p0y_
        draw.p1x = p1x_;
        draw.p1y = p1y_;
        draw.calculateP3p4();
        if( draw.p3old2 != null ){
            var clockWise = dist( draw.p3old2x, draw.p3old2y, p1x_, p1y_ ) > dist( draw.p4old2x, draw.p4old2y, p1x_, p1y_ );
            if( curveEnds ){
                // arc between lines
                if( oldAngle != null ){
                    var dif = Math.abs( draw.angle1 - oldAngle );
                    if( dif > 0.1 ) { // protect against angles where not worth drawing arc which fails due to distance calculations?
                        var oldThickness = thickness;
                        thickness = thick/2;
                        if( clockWise ){
                            Draw.outerPoly( id, true, p0x_, p0y_, ShapePoints.arc_internal( p0_.x, p0_.y, thick/4, draw.angle1, dif, 240 ) );
                        } else {
                            Draw.outerPoly( id, true, p0x_, p0y_, ShapePoints.arc_internal( p0_.x, p0_.y, thick/4, draw.angle2, -dif, 240 ) );
                        }
                        thickness = oldThickness;
                    }
                }
            } else { /* should be in here, but there are some gaps when using curve so use the next part to fill.*/ }
            // straight line between lines    
            if( clockWise ){
               drawTri( id, true, draw.p3old2, draw.p3old, p0_, extraFill_id );
            } else {
               drawTri( id, true, draw.p4old2, draw.p3old, p0_, colorFill_id );
            }
            
        }
        drawTri( id, true, draw.p3old, draw.p3, draw.p4old, colorFill_id );
        drawTri( id, true, draw.p3old, draw.p3, draw.p4, extraFill_id );
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
    public function create2Lines( p0x_: Float, p0y_: Float
                                , p1x_: Float, p1y_: Float
                                , p2x_: Float, p2y_: Float
                                , thick: Float ){
        p0x = p0x_;
        p1x = p1x_;
        p2x = p2x_;
        p0y = p0y_;
        p1y = p1y_;
        p2y = p2y_;
        b2 = dist( p0x, p0y, p1x, p1y );
        c2 = dist( p1x, p1y, p2x, p2y );
        a2 = dist( p0x, p0y, p2x, p2y );
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
        //r = ( _thick/2 );Math.cos( beta )
        r = ( _thick/2 )*Math.cos( beta );
        //trace( ' r ' + r );
    }
    public inline function calculateP3p4(){
        _theta = theta( p0x, p0y, p1x, p1y );
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
        if( p3oldx != null ) p3old2x = p3oldx;
        if( p4oldx != null ) p4old2x = p4oldx;
        if( p3x != null ) p3oldx = p3x;
        if( p4x != null ) p4oldx = p4x;
        p3x = p1x + r * Math.cos( angle1 );
        p3y = p1y + r * Math.sin( angle1 );
        p4x = p1x + r * Math.cos( angle2 );
        p4y = p1y + r * Math.sin( angle2 );
    }
    public function rebuildAsPoly( p2x_: Float, p2y_: Float ){
        p0x = p1x;
        p0y = p1y;
        p1x = p2x;
        p1y = p2y;
        p2x = p2x_;
        p2y = p2y_;
        calculateP3p4();
    }   
    public static inline function theta( p0x: Float, p0y: Float, p1x: Float, p1y: Float ): Float {
        return Math.atan2( p0y - p1y, p0x - p1x );
    }
    public static inline function dist( p0x: Float, p0y: Float, p1x: Float, p1y: Float  ): Float {
        var dx = p0x - p1x;
        var dy = p0y - p1y;
        return dx*dx + dy*dy;
    }
   
    private static var q0x: Float;
    private static var q0y: Float;
    private static var q1x: Float;
    private static var q1y: Float;
    public static var colors: Array<UInt>;
    public static var lineCol: Array<UInt>;
    public static inline function poly( id, outline: Bool, p: Array<Float> ){
         q0x = p[0];
         q0y = p[1];
         q1x = p[0];
         q1y = p[1]; 
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) otherQuad( id, outline, p, draw, i );
    }
    public static inline function outerPoly( id: Int, outline: Bool, centre: Point, p: Array<Float> ){
         q0 = p[0];
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) outerFilledTriangles( id, outline, centre, p, draw, i );
    }
    public static inline function outerPolyExtra( id: Int, outline: Bool, centre: Point, p: Array<Float> ){
         q0 = p[0];
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) outerFilledTrianglesExtra( id, outline, centre, p, draw, i );
    }
    
    public static inline function innerPoly( id: Int, outline: Bool, centre: Point, p: Array<Float> ){
         q0 = p[0];
         q1 = p[0];
         var draw: Draw = firstQuad( id, p, 0 );
         for( i in 1...( p.length - 2 ) ) innerFilledTriangles( id, outline, centre, p, draw, i );
    }
    public static inline function triangles( id: Int, outline: Bool, p: Array<Float> ){
         q0 = p[0];
         q1 = p[0];
         for( i in 0...( p.length - 2 ) ) quad( id, outline, p, i );
    }
    private static inline function firstQuad( id, p: Array<Point>, i: Int ): Draw {
        var draw = new Draw();
        draw.create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ], p[ i + 4 ], p[ i + 5 ], thickness );
        q0x = draw.p3x;
        q0y = draw.p3y;
        q1x = draw.p4x;
        q1y = draw.p4y;
        return draw;
    }
    // assumes that firstQuad is drawn.
    private static inline function otherQuad( id: Int, outline: Bool, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q3x = draw.p3x;
        var q3y = draw.p3y;
        var q4x = draw.p4x;
        var q4y = draw.p4y;
        drawTri( id, outline, q0x, q0y, q3x, q3y, q1x, q1y, colorFill_id );
        drawTri( id, outline, q1x, q1y, q3x, q3y, q4x, q4y, extraFill_id );
        q0x = q3x;
        q0y = q3y;
        q1x = q4x;
        q1y = q4y;
        return draw;
    }
    private static inline function outerFilledTriangles( id: Int, outline: Bool, centre: Point, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q3 = draw.p3;
        drawTri( id, outline, q0, q3, centre, colorLine_id );
        q0 = q3;
        return draw;
    }
    private static inline function outerFilledTrianglesExtra( id: Int, outline: Bool, centre: Point, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q3 = draw.p3;
        drawTri( id, outline, q0, q3, centre, extraLine_id );
        q0 = q3;
        return draw;
    }
    
    // suitable for fill.
    private static inline function innerFilledTriangles( id: Int, outline: Bool, centre: Point, p: Array<Point>, draw: Draw, i: Int ){
        draw.rebuildAsPoly( p[ i + 2 ]);
        var q4x = draw.p4x;
        var q4y = draw.p4y;
        drawTri( id, outline, q1x, q1y, q4x, q4y, centre, colorFill_id );
        q1x = q4x;
        q1y = q4y;
        return draw;
    }
    public static inline function quad( id: Int, outline: Bool, p: Array<Float>, i: Int ){
        var draw = new Draw();
        draw.create2Lines( p[ i ], p[ i + 1 ], p[ i + 2 ], p[ i + 3 ], p[ i + 4 ], p[ i + 5 ], thickness );
        var q3x = draw.p3x;
        var q3y = draw.p3y;
        var q4x = draw.p4x;
        var q4y = draw.p4y;
        if( i != 0 ){
            drawTri( id, outline, q0x, q0y, q3x, q3y, q1x, q1y, colorFill_id );
            drawTri( id, outline, q1x, q1y, q3x, q3y, q4x, q4y, extraFill_id );
        }
        q0x = q3x;
        q0y = q3y;
        q1x = q4x;
        q1y = q4y;
        return draw;
    }
    
    // TODO: Move away from points but not urgent.
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
