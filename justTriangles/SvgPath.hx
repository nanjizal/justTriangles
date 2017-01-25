package justTriangles;
import justTriangles.StoreF8;
import justTriangles.StoreF6;
import justTriangles.IPathContext;
class SvgPath{
    var str : String;
    var pos : Int;
    var lastX: Float = 0;
    var lastY: Float = 0;
    var controlX: Float;
    var controlY: Float;
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
                    lastX = store.s0;
                    lastY = store.s1;
                    pathContext.moveTo( lastX, lastY );
                case 'm'.code:
                    extractArgs();
                    lastX = store.s0 + lastX;
                    lastY = store.s1 + lastY;
                    pathContext.moveTo( lastX, lastY );
                case 'L'.code:
                    extractArgs();
                    lastX = store.s0;
                    lastY = store.s1;
                    pathContext.lineTo( lastX, lastY );
                case 'l'.code:
                    extractArgs();
                    lastX = store.s0 + lastX;
                    lastY = store.s1 + lastY;
                    pathContext.lineTo( lastX, lastY );
                case 'H'.code:
                    extractArgs();
                    lastX = store.s0;
                    pathContext.lineTo( lastX, lastY );
                case 'h'.code:
                    extractArgs();
                    lastX = lastX + store.s0;
                    pathContext.lineTo( lastX, lastY );
                case 'V'.code:
                    extractArgs();
                    lastY = store.s1;
                    pathContext.lineTo( lastX, lastY );
                case 'v'.code:
                    extractArgs();
                    lastY = lastY + store.s1;
                    pathContext.lineTo( lastX, lastY );
                case 'C'.code:
                    extractArgs();
                    controlX = store.s2;
                    controlY = store.s3;
                    lastX = store.s4;
                    lastY = store.s5;
                    pathContext.curveTo( store.s0, store.s1
                                    ,   controlX, controlY
                                    ,   lastX, lastY );
                case 'c'.code:
                    extractArgs();
                    controlX = store.s2 + lastX;
                    controlY = store.s3 + lastY;
                    var endX = store.s4 + lastX;
                    var endY = store.s5 + lastY;
                    pathContext.curveTo( store.s0 + lastX, store.s1 + lastY
                                    ,   controlX, controlY
                                    ,   endX, endY );
                    lastX = endX;
                    lastY = endY;
                case 'S'.code:
                    // TODO: add code for cases when no last control
                    extractArgs();
                    // calculate reflection of previous control points
                    controlX = 2*lastX - controlX;
                    controlY = 2*lastY - controlY;
                    var endX = store.s4;
                    var endY = store.s5;
                    pathContext.curveTo( store.s0, store.s1
                                     ,   controlX, controlY
                                     ,   endX, endY );
                case 's'.code:
                    // TODO: add code for cases when no last control
                    extractArgs();
                    // calculate reflection of previous control points
                    controlX = 2*lastX - controlX;
                    controlY = 2*lastY - controlY;
                    var endX = store.s4 + lastX;
                    var endY = store.s5 + lastY;
                    pathContext.curveTo( store.s0 + lastX, store.s1 + lastY
                                     ,   controlX, controlY
                                     ,   endX, endY );
                    
                case 'Q'.code:
                    extractArgs();
                    controlX = store.s0;
                    controlY = store.s1;
                    lastX = store.s2;
                    lastY = store.s3;
                    pathContext.quadTo( controlX, controlY
                                    ,   lastX, lastY );
                case 'q'.code:
                    extractArgs();
                    controlX = lastX + store.s0;
                    controlY = lastY + store.s1;
                    lastX = store.s0 + lastX;
                    lastY = store.s1 + lastY;
                    pathContext.quadTo( controlX, controlY 
                                    ,   lastX, lastY );
                case 'T'.code:
                // TODO: add code for cases when no last control
                    extractArgs();
                    // calculate reflection of previous control points
                    controlX = 2*lastX  - controlX;
                    controlY = 2*lastY - controlY;
                    lastX = store.s0;   
                    lastY = store.s1;
                    pathContext.quadTo( controlX, controlY 
                                    ,   lastX, lastY );
                case 't'.code:
                // TODO: add code for cases when no last control
                    extractArgs();
                    // calculate reflection of previous control points
                    controlX = 2*lastX - controlX;
                    controlY = 2*lastY - controlY;
                    lastX = store.s0 + lastY;
                    lastY = store.s1 + lastX;
                    pathContext.quadTo( controlX, controlY 
                                    ,   lastX, lastY );
                    
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
        //pos++;
        c = nextChar();
        var count = 0;
        var temp: String = '';
        while( true ) {
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
                    trace( 'default ' + str.substr( pos, 1 ) );
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
