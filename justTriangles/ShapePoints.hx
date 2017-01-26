package justTriangles;
//import justTriangles.Point;
import justTriangles.Bezier;
using justTriangles.ShapePoints;
class ShapePoints {
    /*
    public static inline function reversePoints( p: Array<Float> ): Array<Float> {
        var x: Float;
        var y: Float;
        var l = p.length;
        for( i in 0...l ){
            if( (i & 1) == 0 ){
                x = p[i];
                y = p[i+1];
                p[i] = y;
                p[i+1] = x;
            }
        }
        p.reverse();
    }
    */
    public static inline function reversePoints( p: Array<Float> ): Array<Float> {
        var xl: Float;
        var yl: Float;
        var xr: Float;
        var yr: Float;
        var l = p.length;
        var r: Int;
        var lm = p.length - 1;
        var half = Std.int( p.length/2 );
        for( i in 0...half ){
            if( (i & 1) == 0 ){
                xl = p[ i ];
                yl = p[ i+1 ];
                r = lm - i;
                xr = p[ r - 1 ];
                yr = p[ r ];
                p[i] = xr;
                p[i+1] = yr;
                p[r-1] = xl;
                p[r] = yl;
            }
        }
        return p;
    }
    // Create Rectangular Box Points
    public static inline function boxPoints( p: Array<Float>, px: Float, py: Float, wid: Float, hi: Float ){
        p = p.concat([ px, py, px + wid, py, px + wid, py + hi, px, py + hi, px, py, px + wid, py, px + wid, py + hi ]);
        return p;
    }
    /*
    // Create Rectangular Box Points
    public static inline function box( x: Float,y: Float, wid: Float, hi: Float ): Array<Float>{
        boxPoints( x, y, wid, hi );
        p.reversePoints();
        return p;
    }
    */
    // Create Equalatrial Triangle points
    public static inline function equalTri( p: Array<Float>, dx: Float, dy: Float
                                                , radius: Float, ?rotation: Float = 0 ):Array<Float>{
        var angle = 0.;
        var offset = - 2.5*Math.PI*2/6 - Math.PI + rotation;
        for( i in 0...6 ){
            angle = i*( Math.PI*2 )/3 - offset;
            p.push( dx + radius * Math.cos( angle ) ); // check if array access is faster p[Std.int(i*2)];
            p.push( dy + radius * Math.sin( angle ) );
        } 
        // p.reversePoints();
        return p;
    }
    // Create Polygon Points
    public static inline function polyPoints( p: Array<Float>, d: Point, radius: Float, sides: Int, ?rotation: Float = 0 ):Array<Float>{
        var angle = 0.;
        var angleInc = ( Math.PI*2 )/sides;
        var offset = rotation - Math.PI/2;
        for( i in 0...( sides + 3 ) ){
            angle = i*angleInc;
            angle = angle + offset; // ?  to test!
            p.push( d.x + radius * Math.cos( angle ) );
            p.push( d.y + radius * Math.sin( angle ) );
        } 
        return p;
    }
    /*
    // Create Polygon Points
    public static inline function poly( dx: Float, dy: Float
                                      , radius: Float, sides: Int ):Array<Float>{
        var p = new Array<Float>();
        var angle = 0.;
        var angleInc = ( Math.PI*2 )/sides;
        for( i in 0...( sides + 3 ) ){
            angle = i*angleInc; 
            p.push( dx + radius * Math.cos( angle ) );
            p.push( dy + radius * Math.sin( angle ) );
        } 
        p.reversePoints();
        return p;
    }
    */
    // Create Horizontal Wave Points
    public static inline function horizontalWave( p: Array<Float>, x_: Float, dx_: Float, y_: Float
                                                , amplitude: Float, sides: Int, repeats: Float ):Array<Float>{
        var dx: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var len: Int = Std.int( sides*repeats );
        for( i in 0...len ) {
            p.push( x_ + ( dx += dx_ ) );
            p.push( y_ + amplitude * Math.sin( i*angleInc ) );
        }
        return p;
    }
    // Create Vertical Wave Points
    public static inline function verticalWave( p: Array<Float>, x_: Float, y_: Float, dy_: Float
                                              , amplitude: Float, sides: Int, repeats: Float ):Array<Float>{
        var dy: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var len: Int = Std.int( sides*repeats );
        for( i in 0...len ) {
            p.push( y_ + ( dy += dy_ ) );
            p.push( x_ + amplitude * Math.sin( i*angleInc ) );
        }
        return p;
    }
    // Create Arc Points
    public static inline function arcPoints( p: Array<Float>, d: Point, radius: Float, start: Float, dA: Float, sides: Int ):Array<Float>{
        var dx = d.x;
        var dy = d.y;
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                nextAngle = angle + start; 
                i--;
                if( angle <= dA ) break; 
                p.push( dx + radius * Math.cos( nextAngle ) );
                p.push( dy + radius * Math.sin( nextAngle ) );
            } 
        } else {
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >= ( dA + angleInc ) ) break; 
                p.push( dx + radius * Math.cos( nextAngle ) );
                p.push( dy + radius * Math.sin( nextAngle ) );
            } 
        }
        return p;
    }
    
    // Create Arc Points
    public static inline function arc_internal( p: Array<Float>, dx: Float, dy: Float
                                     , radius: Float, start: Float, dA: Float, sides: Int ):Array<Float>{
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i--;
                nextAngle = angle + start; 
                if( angle <= ( dA ) ) break; //dA
                p.push( dx + radius * Math.cos( nextAngle ) );
                p.push( dy + radius * Math.sin( nextAngle ) );
            } 
        } else {
            var i = -1;
            var p2 = new Array<Float>();
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >=  ( dA + angleInc ) ) break; 
                p2.push( dx + radius * Math.cos( nextAngle ) );
                p2.push( dy + radius * Math.sin( nextAngle ) );
            } 
            p2.reversePoints();  // TODO: rearrange to avoid?
            p = p.concat( p );
        }
        return p;
    }
    
    // Create Arc Points
    public static inline function arc( p: Array<Float>, dx: Float, dy: Float
                                     , radius: Float, start: Float, dA: Float, sides: Int ):Array<Float>{
        var p2: Array<Float> = new Array<Float>();         
        var angle: Float = 0;
        var angleInc: Float = ( Math.PI*2 )/sides;
        var sides = Math.round( sides );
        var nextAngle: Float;
        if( dA < 0 ){
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i--;
                nextAngle = angle + start; 
                if( angle <= ( dA ) ) break; //dA
                p2.push( dx + radius * Math.cos( nextAngle ) );
                p2.push( dy + radius * Math.sin( nextAngle ) );
            } 
        } else {
            var i = -1;
            while( true ){
                angle = i*angleInc;
                i++;
                nextAngle = angle + start; 
                if( angle >=  ( dA + angleInc ) ) break; 
                p2.push( dx + radius * Math.cos( nextAngle ) );
                p2.push( dy + radius * Math.sin( nextAngle ) );
            } 
            
        }
        p2.reversePoints(); // arrange to avoid or remove arc?
        p = p.concat( p2 );
        return p;
    }
    public static var quadStep: Float = 0.03;
    // Create Quadratic Curve
    public static inline function quadCurve(    p: Array<Float>
                                            ,   p0x: Float, p0y: Float
                                            ,   p1x: Float, p1y: Float
                                            ,   p2x: Float, p2y: Float ): Array<Float> {
        var approxDistance = distance( p0x, p0y, p1x, p1y ) + distance( p1x, p1y, p2x, p2y );
        if( approxDistance == 0 ) approxDistance = 0.000001;
        var step = Math.min( 1/( approxDistance*0.707 ), quadStep );
        p.push( p0x );
        p.push( p0y );
        var t = step;
        while( t < 1 ){
            p.push( Bezier.quadratic( t, p0x, p1x, p2x ) );
            p.push( Bezier.quadratic( t, p0y, p1y, p2y ) );
            t += step;
        }
        p.push( p2x );
        p.push( p2y );
        return p;
    }
    public static var cubicStep: Float = 0.03;
    // Create Cubic Curve
    public static inline function cubicCurve( p: Array<Float>
                                            , p0x: Float, p0y: Float
                                            , p1x: Float, p1y: Float
                                            , p2x: Float, p2y: Float
                                            , p3x: Float, p3y: Float ): Array<Float> {
        var p: Array<Float> = new Array<Float>(); 
        var approxDistance = distance( p0x, p0y, p1x, p1y ) + distance( p1x, p1y, p2x, p2y ) + distance( p2x, p2y, p3x, p3y );
        if( approxDistance == 0 ) approxDistance = 0.000001;
        var step = Math.min( 1/( approxDistance*0.707 ), cubicStep );
        p.push( p0x );
        p.push( p0y );
        var t = step;
        while( t < 1 ){
            p.push( Bezier.cubic( t, p0x, p1x, p2x, p3x ) );
            p.push( Bezier.cubic( t, p0y, p1y, p2y, p3y ) );
            t += step;
        }
        p.push( p3x );
        p.push( p3y );
        return p;
    }
    public static inline function distance(     p0x: Float, p0y: Float
                                            ,   p1x: Float, p1y: Float
                                            ): Float {
        var x = p0x - p1x;
        var y = p0y - p1y;
        return Math.sqrt( x*x + y*y );
    }
}
