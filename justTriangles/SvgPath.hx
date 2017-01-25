package justTriangles;
import justTriangles.StoreF8;
import justTriangles.StoreF6;
import justTriangles.IPathContext;
class SvgPath{
    var str : String;
    var pos : Int;
    var lastX: Float = 0;
    var lastY: Float = 0;
    var c: Int;
    var l: Int;
    var pathContext: IPathContext;
    var store: StoreF6;
    public function new( pathContext_: IPathContext ){
        pathContext = pathContext_;
    }
    // currently not much protection against malformed, or unusual path data.
    public function parse( str_: String ): String{
        str = str_;
        pos = 0;
        l = str.length;
        c = nextChar();
        var count = 0;
        store = new StoreF6();
        while( pos < l ){
            switch( c ){
                case 'M'.code:
                    extractArgs();
                    var s0 = store.s0;
                    var s1 = store.s1;
                    pathContext.moveTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'm'.code:
                    extractArgs();
                    var s0 = store.s0 + lastX;
                    var s1 = store.s1 + lastY;
                    pathContext.moveTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'L'.code:
                    extractArgs();
                    var s0 = store.s0;
                    var s1 = store.s1;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'l'.code:
                    extractArgs();
                    var s0 = lastX + store.s0;
                    var s1 = lastY + store.s1;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'H'.code:
                    extractArgs();
                    var s0 = store.s0;
                    var s1 = lastY;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'h'.code:
                    extractArgs();
                    var s0 = lastX + store.s0;
                    var s1 = lastY;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'V'.code:
                    extractArgs();
                    var s0 = lastX;
                    var s1 = store.s1;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'v'.code:
                    extractArgs();
                    var s0 = lastX;
                    var s1 = lastY + store.s1;
                    pathContext.lineTo( s0, s1 );
                    lastX = s0;
                    lastY = s1;
                case 'C'.code:
                    extractArgs();
                    var s0 = store.s0;
                    var s1 = store.s1;
                    pathContext.curveTo( s0, s1
                                    ,   store.s2, store.s3
                                    ,   store.s4, store.s5 );
                    lastX = store.s4;
                    lastY = store.s5;
                    
                case 'c'.code:
                    extractArgs();
                    pathContext.curveTo( store.s0 + lastX, store.s1 + lastY
                                    ,   store.s2 + lastX, store.s3 + lastY
                                    ,   store.s4 + lastX, store.s5 + lastY );
                    lastX = store.s4 + lastX;
                    lastY = store.s5 + lastY;
                case 'S'.code:
                    trace( 'smooth_curveto - not implemented' );
                    extractArgs();
                case 's'.code:
                    trace( 'relative smooth_curveto - not implemented' );
                    extractArgs();
                case 'Q'.code:
                    extractArgs();
                    var s0 = store.s0;
                    var s1 = store.s1;
                    pathContext.quadTo( s0, s1
                                    ,   store.s2, store.s3 );
                    lastX = store.s2;
                    lastY = store.s3;
                case 'q'.code:
                    extractArgs();
                    pathContext.quadTo( lastX + store.s0, lastY + store.s1
                                    ,   store.s2 + lastX, store.s3 + lastY );
                    lastX = store.s2 + lastX;
                    lastY = store.s3 + lastY;
                case 'T'.code:
                    trace( 'smooth_quadratic_Bézier_curveto - not implemented' );
                    extractArgs();
                case 't'.code:
                    trace( 'relative smooth_quadratic_Bézier_curveto - not implemented' );
                    extractArgs();
                case 'A'.code:
                    trace( 'elliptical_Arc - not implemented' );
                    extractArgs();
                case 'a'.code:
                    trace( 'relative elliptical_Arc - not implemented' );
                    extractArgs();
                case 'Z'.code, 'z'.code: 
                    lastX = 0;
                    lastY = 0;
                    trace( 'closepath' );
                    //break;
                case 'B'.code:
                    trace( 'bearing - not implemented' );
                    throw( 'bearing not supported please remove' );
                default:
                    count++;
            }
            c = nextChar();
        }
        return str_;
    }
    // Extract the args
    // Assumes all values are float
    // new lines not yet implemented
    // scientifc numbers not implemented yet
    function extractArgs() {
        store.clear();
        pos++;
        c = nextChar();
        var count = 0;
        var temp: String = '';
        while( pos < l ) {
            switch( c ) {
                
                case '-'.code:
                    if( temp != '' ){
                        store.push( Std.parseFloat( temp ) );
                    }
                    temp = '-';
                case '.'.code:
                    temp = temp + '.';
                case '0'.code:
                    temp = temp + '0';
                case '1'.code:
                    temp = temp + '1';
                case '2'.code:
                    temp = temp + '2';
                case '3'.code:
                    temp = temp + '3';
                case '4'.code:
                    temp = temp + '4';
                case '5'.code:
                    temp = temp + '5';
                case '6'.code:
                    temp = temp + '6';
                case '7'.code:
                    temp = temp + '7';
                case '8'.code:
                    temp = temp + '8';
                case '9'.code:
                    temp = temp + '9';
                case ' '.code,','.code:
                    if( temp != '' ){
                        store.push( Std.parseFloat( temp ) );
                        temp = '';
                    }
                default:
                    if( temp != '' ){
                        store.push( Std.parseFloat( temp ) );
                        temp = '';
                    }
                    pos--;
                    break;
            }
            c = nextChar();
        }
    }
    inline function nextChar() {
        return StringTools.fastCodeAt( str, pos++ );
    }
}
